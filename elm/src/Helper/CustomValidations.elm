module Helper.CustomValidations exposing (Validator, checkAll, duration, eventStatusAndDate, languageTagValid, minMaxAge, minMaxPrice, startAndEndDates, teaserOrDescription, viewerMessage)

import Data.Root
    exposing
        ( Audience
        , CreatorEntry(..)
        , CreatorRole
        , Event
        , EventEventStatus(..)
        , LocationItem(..)
        , Offer
        , Organization
        , PerformanceRole
        , Person
        , Place
        , PostalAddress
        , PriceSpecification
        , Production
        , Root
        , VirtualLocation
        )
import Helper.LanguageCodes as LanguageCodes
import Iso8601
import LanguageTag.Parser
import List.Extra
import Time


type alias ValidationMessage =
    { path : String
    , message : String
    , messageForView : Maybe String
    }


viewerMessage : ValidationMessage -> Maybe String
viewerMessage msg =
    msg.messageForView


message : String -> String -> ValidationMessage
message path msg =
    { path = path
    , message = msg
    , messageForView = Nothing
    }


forView : String -> ValidationMessage -> ValidationMessage
forView viewMessage msg =
    { msg | messageForView = Just viewMessage }


type alias Validator value =
    String -> value -> List ValidationMessage


checkAll : Root -> List ValidationMessage
checkAll data =
    object
        [ field "/organization" .organization organization
        , field "/productions" .productions (list production)
        , field "/productions" .productions (uniqueIdsFor "productions")
        ]
        |> check data ""


organization : Validator Organization
organization =
    object
        [ field "/address" .address (maybe address)
        , field "/name" .name required
        ]


check : model -> String -> Validator model -> List ValidationMessage
check data path validator =
    validator path data


field : String -> (model -> value) -> Validator value -> Validator model
field path accessor validator basePath model =
    validator (basePath ++ path) (accessor model)



-- TRANSFORMATIONS


object : List (Validator model) -> Validator model
object validators basePath model =
    List.foldr
        (\validator result ->
            validator basePath model ++ result
        )
        []
        validators


list : Validator model -> Validator (List model)
list validator basePath model =
    List.indexedMap
        (\idx data ->
            validator (basePath ++ "/" ++ String.fromInt idx) data
        )
        model
        |> List.foldr (++) []


maybe : Validator model -> Validator (Maybe model)
maybe validator basePath model =
    case model of
        Just value ->
            validator basePath value

        Nothing ->
            []



-- STRING VALIDATORS


required : Validator String
required path value =
    if String.trim value == "" then
        [ message path "is a required text field, but you provided an empty value"
        ]

    else
        []


optional : Validator (Maybe String)
optional path value =
    case value of
        Just text ->
            if String.trim text == "" then
                [ message path "is empty. You can omit optional text fields if there is no content."
                ]

            else
                []

        Nothing ->
            []



-- CUSTOM VALIDATORS


uniqueIdsFor : String -> Validator (List { a | identifier : String })
uniqueIdsFor name path data =
    let
        allIds =
            List.map .identifier data

        getMessage idx item count =
            message
                (path ++ "/" ++ String.fromInt idx)
                ("must have a unique ID. However, ID "
                    ++ item.identifier
                    ++ " is also used in "
                    ++ String.fromInt (count - 1)
                    ++ " other "
                    ++ name
                    ++ "."
                )
    in
    List.indexedMap
        (\idx item ->
            case elementCount item.identifier allIds of
                1 ->
                    Nothing

                count ->
                    Just (getMessage idx item count)
        )
        data
        |> List.filterMap identity


duration : Validator Int
duration path minutes =
    if minutes > 900 then
        [ message path
            "seems to be very long. The duration field is supposed to contain the event's duration in minutes. Are you sure you didn't accidentally use seconds instead?"
            |> forView "Diese Veranstaltung scheint sehr lange zu dauern. Sind Sie sich sicher, dass diese Angabe korrekt ist?"
        ]

    else if minutes >= 0 && minutes < 10 then
        -- the duration being negative is already a validation error, so we don't need to cover this case here
        [ message path
            "seems to be very short. The duration field is supposed to contain the event's duration in minutes. Are you sure you didn't accidentally use hours instead?"
            |> forView "Diese Veranstaltung scheint sehr kurz zu sein. Sind Sie sich sicher, dass diese Angabe korrekt ist?"
        ]

    else
        []


geocoordinates : Validator Place
geocoordinates path data =
    case ( data.latitude, data.longitude ) of
        ( Nothing, Just _ ) ->
            [ message path "has a longitude but no latitude" ]

        ( Just _, Nothing ) ->
            [ message path "has a latitude but no longitude" ]

        _ ->
            []


teaserOrDescription : Validator Production
teaserOrDescription path data =
    case ( data.abstract, data.description ) of
        ( Nothing, Nothing ) ->
            [ message path "has neither a description nor a teaser. You should set at least one of these fields."
                |> forView "Diese Produktion hat weder eine Beschreibung noch eine Kurzbeschreibung. Wenigstens eines der beiden Felder sollte gesetzt sein."
            ]

        _ ->
            []


eventStatusAndDate : Validator Event
eventStatusAndDate =
    object
        [ previousStartDateDifferentFromCurrent
        , previousStartPresent
        , previousStartNotRequired
        ]


previousStartDateDifferentFromCurrent : Validator Event
previousStartDateDifferentFromCurrent path data =
    case data.previousStartDate of
        Just previousStart ->
            if data.startDate == previousStart then
                [ message (path ++ "/previousStartDate") "should be different from startDate for rescheduled events"
                    |> forView "Die vorherige Startzeit sollte sich von der neuen Startzeit unterscheiden."
                ]

            else
                []

        Nothing ->
            []


previousStartPresent : Validator Event
previousStartPresent path data =
    case ( data.eventStatus, data.previousStartDate ) of
        ( Just EventPostponedEvent, Nothing ) ->
            [ message (path ++ "/previousStartDate") "should be set for postponed events"
                |> forView "Die vorherige Startzeit sollte bei verschobenen Veranstaltungen angegeben werden."
            ]

        ( Just EventRescheduledEvent, Nothing ) ->
            [ message (path ++ "/previousStartDate") "should be set for rescheduled events"
                |> forView "Die vorherige Startzeit sollte bei verschobenen Veranstaltungen angegeben werden."
            ]

        ( _, _ ) ->
            []


previousStartNotRequired : Validator Event
previousStartNotRequired path data =
    case ( data.eventStatus, data.previousStartDate ) of
        ( Just EventScheduledEvent, Just _ ) ->
            [ message (path ++ "/previousStartDate") "should only be set if the event status is either 'rescheduled, 'postponed', or 'cancelled'"
                |> forView "Die vorherige Startzeit sollte nur bei verschobenen oder abgesagten Veranstaltungen angegeben werden."
            ]

        ( Just EventMovedOnlineEvent, Just _ ) ->
            [ message (path ++ "/previousStartDate") "should only be set if the event status is either 'rescheduled, 'postponed', or 'cancelled'"
                |> forView "Die vorherige Startzeit sollte nur bei verschobenen oder abgesagten Veranstaltungen angegeben werden."
            ]

        ( Nothing, Just _ ) ->
            [ message (path ++ "/previousStartDate") "should only be set if the event status is either 'rescheduled, 'postponed', or 'cancelled'"
                |> forView "Die vorherige Startzeit sollte nur bei verschobenen oder abgesagten Veranstaltungen angegeben werden."
            ]

        ( _, _ ) ->
            []


languageTagValid : Validator String
languageTagValid path data =
    let
        validationMsg =
            message path "doesn't seem to be a valid language code. This field should contain language codes like 'en', 'de', etc."
                |> forView "Dieses Feld sollte einen Sprachcode enthalten und nicht, z.B. den vollen Namen der Sprache. Beispiele für Codes dieser Art sind \"de\" und \"en-GB\"."
    in
    case LanguageTag.Parser.parseBcp47 data of
        Just ( lang, _ ) ->
            if LanguageCodes.isValid lang then
                []

            else
                [ validationMsg ]

        Nothing ->
            [ validationMsg ]


minMaxPrice : Validator PriceSpecification
minMaxPrice path data =
    case data.maxPrice of
        Just max ->
            if data.minPrice > max then
                [ message path "should be smaller than maxPrice"
                    |> forView "Der Mindestpreis sollte niedriger sein als der Höchstpreis."
                ]

            else
                []

        Nothing ->
            []


minMaxAge : Validator Audience
minMaxAge path data =
    case ( data.suggestedMinAge, data.suggestedMaxAge ) of
        ( Just minAge, Just maxAge ) ->
            if minAge > maxAge then
                [ message (path ++ "/suggestedMinAge") "should be smaller than suggestedMaxAge"
                    |> forView "Das Mindestalter sollte niedriger sein als das Höchstalter."
                ]

            else
                []

        ( _, _ ) ->
            []


startAndEndDates : Validator Event
startAndEndDates path data =
    let
        startMillis =
            data.startDate
                |> Iso8601.toTime
                |> Result.map Time.posixToMillis

        endMillis =
            data.endDate
                |> Result.fromMaybe []
                |> Result.andThen Iso8601.toTime
                |> Result.map Time.posixToMillis
    in
    case ( startMillis, endMillis ) of
        ( Ok start, Ok end ) ->
            if start > end then
                [ message (path ++ "/startDate") "should be before endDate"
                    |> forView "Der Beginn der Veranstaltung liegt nach dem Ende der Veranstaltung."
                ]

            else
                []

        _ ->
            []



-- MODEL VALIDATORS


event : Validator Event
event =
    object
        [ field "/duration" .duration (maybe duration)
        , field "/endDate" .endDate optional
        , field "/location" .location (maybe (list location))
        , field "/offers" .offers (maybe (list offer))
        , field "/performer" .performer (maybe (list performer))
        , field "/previousStartDate" .previousStartDate optional
        , field "/startDate" .startDate required
        , field "/subtitleLanguage" .subtitleLanguage (maybe languageTagValid)
        , field "/url" .url optional
        , eventStatusAndDate
        , startAndEndDates
        ]


creator : Validator CreatorRole
creator =
    object
        [ field "/creator" .creator creatorEntry
        , field "/roleName" .roleName optional
        ]


creatorEntry : Validator CreatorEntry
creatorEntry path data =
    case data of
        CreatorEntryPe personInfo ->
            person path personInfo

        CreatorEntryOr organizationInfo ->
            organization path organizationInfo


person : Validator Person
person =
    object
        [ field "/name" .name required
        ]


performer : Validator PerformanceRole
performer =
    object
        [ field "/performer" .performer person
        , field "/characterName" .characterName optional
        ]


offer : Validator Offer
offer =
    object
        [ field "/name" .name optional
        , field "/priceSpecification" .priceSpecification priceSpecification
        , field "/url" .url optional
        ]


priceSpecification : Validator PriceSpecification
priceSpecification =
    object
        [ field "/priceCurrency" .priceCurrency required
        , minMaxPrice
        ]


production : Validator Production
production =
    object
        [ field "/accessibilitySummary" .accessibilitySummary optional
        , field "/additionalInfo" .additionalInfo optional
        , field "/audience" .audience (maybe audience)
        , field "/creator" .creator (maybe (list creator))
        , field "/description" .description optional
        , field "/events" .events (list event)
        , field "/events" .events (uniqueIdsFor "events")
        , field "/inLanguage" .inLanguage (maybe languageTagValid)
        , field "/subtitle" .subtitle optional
        , field "/abstract" .abstract optional
        , field "/name" .name required
        , teaserOrDescription
        ]


address : Validator PostalAddress
address =
    object
        [ field "/addressLocality" .addressLocality optional
        , field "/postalCode" .postalCode optional
        , field "/streetAddress" .streetAddress optional
        ]


audience : Validator Audience
audience =
    object
        [ field "/audienceType" .audienceType optional
        , minMaxAge
        ]


location : Validator LocationItem
location path data =
    case data of
        LocationItemPl placeItem ->
            place path placeItem

        LocationItemVi virtual ->
            virtualLocation path virtual


place : Validator Place
place =
    object
        [ field "/name" .name optional
        , field "/address" .address address
        , geocoordinates
        ]


virtualLocation : Validator VirtualLocation
virtualLocation =
    object
        [ field "/name" .name optional
        , field "/url" .url optional
        ]



-- HELPERS


elementCount : a -> List a -> Int
elementCount element all =
    let
        equalsElement =
            (==) element
    in
    List.Extra.count equalsElement all
