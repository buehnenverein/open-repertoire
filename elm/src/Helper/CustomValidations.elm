module Helper.CustomValidations exposing (MessageType(..), ValidationMessage, Validator, checkAll, duration, eventStartAndEndDates, eventStatusAndDate, languageTagValid, list, minMaxAge, minMaxPrice, production, validDerniere, validPremiere, viewerMessage)

import Data.Agent exposing (Agent(..))
import Data.Event as Event
    exposing
        ( Event
        , EventStatus(..)
        , EventTypeItem(..)
        , LocationItem(..)
        , Offer
        , PerformanceRoleItem
        , Place
        , PriceSpecification
        , SubEventType
        , VirtualLocation
        )
import Data.InternationalizedString exposing (InternationalizedString)
import Data.Organization exposing (Organization)
import Data.Person exposing (Person)
import Data.PostalAddress exposing (PostalAddress)
import Data.Root
    exposing
        ( Abstract(..)
        , Audience
        , ContentWarningItem(..)
        , CreatorRoleItem
        , Description(..)
        , Name(..)
        , Production
        , Root
        , Subtitle(..)
        )
import Data.SuperEvent as SuperEvent exposing (SuperEvent)
import Helper.LanguageCodes as LanguageCodes
import Iso8601
import LanguageTag.Parser
import List.Extra
import Time


type alias ValidationMessage =
    { path : String
    , message : String
    , messageForView : Maybe String
    , kind : MessageType
    }


type MessageType
    = Warning
    | Error


viewerMessage : ValidationMessage -> Maybe String
viewerMessage msg =
    msg.messageForView


warning : String -> String -> ValidationMessage
warning path msg =
    { path = path
    , message = msg
    , messageForView = Nothing
    , kind = Warning
    }


error : String -> String -> ValidationMessage
error path msg =
    { path = path
    , message = msg
    , messageForView = Nothing
    , kind = Error
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
    if isEmptyString value then
        [ warning path "is a required text field, but you provided an empty value"
        ]

    else
        []


optional : Validator (Maybe String)
optional path value =
    case value of
        Just text ->
            if isEmptyString text then
                [ warning path "is empty. You can omit optional text fields if there is no content."
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
            error
                (path ++ "/" ++ String.fromInt idx ++ "/identifier")
                ("must be unique. However, ID "
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


premiereValid : Validator (List Event)
premiereValid path events =
    list (validPremiere events)
        |> check events path


validPremiere : List Event -> Validator Event
validPremiere allEvents path data =
    let
        isPremiere ev =
            case ev.eventType of
                Just types ->
                    List.member PremiereEventType types

                Nothing ->
                    False

        isPreview ev =
            case ev.eventType of
                Just types ->
                    List.member PreviewEventType types

                Nothing ->
                    False

        isFirst ev =
            List.all
                (\other ->
                    other == ev || other.startDate > ev.startDate || isPreview other
                )
                allEvents
    in
    if isPremiere data && not (isFirst data) then
        [ warning path "is labeled as the premiere, but it doesn't seem to be the first performance of this production"
            |> forView "Diese Aufführung ist als Premiere gekennzeichnet, obwohl es Aufführungen gibt, die früher stattfinden."
        ]

    else
        []


derniereValid : Validator (List Event)
derniereValid path events =
    list (validDerniere events)
        |> check events path


validDerniere : List Event -> Validator Event
validDerniere allEvents path data =
    let
        isDerniere ev =
            case ev.eventType of
                Just types ->
                    List.member LastShowEventType types

                Nothing ->
                    False

        isLast ev =
            List.all
                (\other ->
                    other == ev || other.startDate < ev.startDate
                )
                allEvents
    in
    if isDerniere data && not (isLast data) then
        [ warning path "is labeled as the last show, but it doesn't seem to be the last performance of this production"
            |> forView "Diese Aufführung ist als Derniere gekennzeichnet, obwohl es Aufführungen gibt, die später stattfinden."
        ]

    else
        []


duration : Validator Int
duration path minutes =
    if minutes > 900 then
        [ warning path
            "seems to be very long. The duration field is supposed to contain the event's duration in minutes. Are you sure you didn't accidentally use seconds instead?"
            |> forView "Diese Veranstaltung scheint sehr lange zu dauern. Sind Sie sich sicher, dass diese Angabe korrekt ist?"
        ]

    else if minutes >= 0 && minutes < 10 then
        -- the duration being negative is already a validation error, so we don't need to cover this case here
        [ warning path
            "seems to be very short. The duration field is supposed to contain the event's duration in minutes. Are you sure you didn't accidentally use hours instead?"
            |> forView "Diese Veranstaltung scheint sehr kurz zu sein. Sind Sie sich sicher, dass diese Angabe korrekt ist?"
        ]

    else
        []


geocoordinates : Validator Place
geocoordinates path data =
    case ( data.latitude, data.longitude ) of
        ( Nothing, Just _ ) ->
            [ warning path "has a longitude but no latitude" ]

        ( Just _, Nothing ) ->
            [ warning path "has a latitude but no longitude" ]

        _ ->
            []



-- abstractOrDescription : Validator Production
-- abstractOrDescription path data =
--     let
--         -- If either abstract or description contains actual text, then the combined
--         -- string will also contain actual text
--         combinedString =
--             Maybe.withDefault "" data.abstract
--                 ++ Maybe.withDefault "" data.description
--         message =
--             [ warning path "has neither a description nor an abstract. You should set at least one of these fields."
--                 |> forView "Diese Produktion hat weder eine Beschreibung noch eine Kurzbeschreibung. Wenigstens eines der beiden Felder sollte gesetzt sein."
--             ]
--     in
--     if isEmptyString combinedString then
--         message
--     else
--         []
-- getAbstractText : Abstract -> (InternationalizedString -> Maybe String) -> Maybe String
-- getAbstractText abstract languageAccessor =
--     case abstract of
--         AbstractCo string ->
--             Just string
--         AbstractIn internationalizedString ->
--             languageAccessor internationalizedString
-- abstractDifferentFromDescription : Validator Production
-- abstractDifferentFromDescription path data =
--     let
--         sameText text1 text2 =
--             String.trim text1 == String.trim text2 && not (isEmptyString text1)
--     in
--     case ( data.description, data.abstract ) of
--         ( Just description, Just abstract ) ->
--             if sameText description abstract then
--                 [ warning (path ++ "/abstract") "is the same"
--                     |> forView "Kurzbeschreibung und Beschreibung enthalten den selben Text. Vermeiden Sie es, Ihre Beschreibungstexte zu doppeln."
--                 ]
--             else
--                 []
--         _ ->
--             []


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
                [ warning (path ++ "/previousStartDate") "should be different from startDate for rescheduled events"
                    |> forView "Die vorherige Startzeit sollte sich von der neuen Startzeit unterscheiden."
                ]

            else
                []

        Nothing ->
            []


previousStartPresent : Validator Event
previousStartPresent path data =
    case ( data.eventStatus, data.previousStartDate ) of
        ( Just EventPostponed, Nothing ) ->
            [ warning (path ++ "/previousStartDate") "should be set for postponed events"
                |> forView "Die vorherige Startzeit sollte bei verschobenen Veranstaltungen angegeben werden."
            ]

        ( Just EventRescheduled, Nothing ) ->
            [ warning (path ++ "/previousStartDate") "should be set for rescheduled events"
                |> forView "Die vorherige Startzeit sollte bei verschobenen Veranstaltungen angegeben werden."
            ]

        ( _, _ ) ->
            []


previousStartNotRequired : Validator Event
previousStartNotRequired path data =
    case ( data.eventStatus, data.previousStartDate ) of
        ( Just EventScheduled, Just _ ) ->
            [ warning (path ++ "/previousStartDate") "should only be set if the event status is either 'rescheduled, 'postponed', or 'cancelled'"
                |> forView "Die vorherige Startzeit sollte nur bei verschobenen oder abgesagten Veranstaltungen angegeben werden."
            ]

        ( Just EventMovedOnline, Just _ ) ->
            [ warning (path ++ "/previousStartDate") "should only be set if the event status is either 'rescheduled, 'postponed', or 'cancelled'"
                |> forView "Die vorherige Startzeit sollte nur bei verschobenen oder abgesagten Veranstaltungen angegeben werden."
            ]

        ( Nothing, Just _ ) ->
            [ warning (path ++ "/previousStartDate") "should only be set if the event status is either 'rescheduled, 'postponed', or 'cancelled'"
                |> forView "Die vorherige Startzeit sollte nur bei verschobenen oder abgesagten Veranstaltungen angegeben werden."
            ]

        ( _, _ ) ->
            []


languageTagValid : Validator String
languageTagValid path data =
    let
        validationMsg =
            warning path "doesn't seem to be a valid language code. This field should contain language codes like 'en', 'de', etc."
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
                [ warning path "should be smaller than maxPrice"
                    |> forView "Der Mindestpreis sollte niedriger sein als der Höchstpreis."
                ]

            else
                []

        Nothing ->
            []


minMaxAge : Validator ( Maybe Int, Maybe Int )
minMaxAge path ( minAge, maxAge ) =
    case ( minAge, maxAge ) of
        ( Just min, Just max ) ->
            if min > max then
                [ warning path "should be smaller than the maximum age"
                    |> forView "Das Mindestalter sollte niedriger sein als das Höchstalter."
                ]

            else
                []

        ( _, _ ) ->
            []


eventStartAndEndDates : Validator Event
eventStartAndEndDates path data =
    startAndEndDates path { startDate = Just data.startDate, endDate = data.endDate }


startAndEndDates : Validator { a | startDate : Maybe String, endDate : Maybe String }
startAndEndDates path data =
    let
        startMillis =
            data.startDate
                |> Result.fromMaybe []
                |> Result.andThen Iso8601.toTime
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
                [ warning (path ++ "/startDate") "should be before endDate"
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
        , field "/subtitleLanguage" .subtitleLanguage (maybe (list languageTagValid))
        , field "/url" .url optional
        , field "/subEvent" .subEvent (maybe (list subEvent))
        , field "/superEvent" .superEvent (maybe superEvent)
        , eventStatusAndDate
        , eventStartAndEndDates
        ]


subEvent : Validator SubEventType
subEvent =
    object
        [ field "/duration" .duration (maybe duration)
        , field "/endDate" .endDate optional
        , field "/location" .location optional
        , field "/startDate" .startDate optional
        , field "/description" .description (maybe subEventDescription)
        , field "/inLanguage" .inLanguage (maybe (list languageTagValid))
        , startAndEndDates
        ]


superEvent : Validator SuperEvent
superEvent =
    object
        [ field "/duration" .duration (maybe duration)
        , field "/endDate" .endDate optional
        , field "/location" .location optional
        , field "/startDate" .startDate optional
        , field "/description" .description (maybe superEventDescription)
        , field "/inLanguage" .inLanguage (maybe (list languageTagValid))
        , startAndEndDates
        ]


creator : Validator CreatorRoleItem
creator =
    object
        [ field "/creator" .creator (list agent)
        , field "/roleName" .roleName optional
        ]


agent : Validator Agent
agent path data =
    case data of
        AgentPe personInfo ->
            person path personInfo

        AgentOr organizationInfo ->
            organization path organizationInfo


person : Validator Person
person =
    object
        [ field "/name" .name required
        ]


performer : Validator PerformanceRoleItem
performer =
    object
        [ field "/performer" .performer (list agent)
        , field "/characterName" .characterName optional
        , field "/roleName" .roleName optional
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
        , field "/audience" .audience (maybe audience)
        , field "/contentWarning" .contentWarning (maybe (list productionContentWarning))
        , field "/creator" .creator (maybe (list creator))
        , field "/description" .description (maybe productionDescription)
        , field "/events" .events (list event)
        , field "/events" .events (uniqueIdsFor "events")
        , field "/events" .events premiereValid
        , field "/events" .events derniereValid
        , field "/inLanguage" .inLanguage (maybe (list languageTagValid))
        , field "/subtitle" .subtitle (maybe productionSubtitle)
        , field "/abstract" .abstract (maybe productionAbstract)
        , field "/name" .name productionName
        , field "/isBasedOn" .isBasedOn (maybe originalWork)

        -- , abstractOrDescription
        -- , abstractDifferentFromDescription
        ]


productionAbstract : Validator Abstract
productionAbstract path data =
    case data of
        AbstractSt string ->
            optional path (Just string)

        AbstractIn i18nString ->
            internationalizedString path i18nString


productionDescription : Validator Description
productionDescription path data =
    case data of
        DescriptionSt string ->
            optional path (Just string)

        DescriptionIn i18nString ->
            internationalizedString path i18nString


productionName : Validator Name
productionName path data =
    case data of
        NameSt string ->
            optional path (Just string)

        NameIn i18nString ->
            internationalizedString path i18nString


productionSubtitle : Validator Subtitle
productionSubtitle path data =
    case data of
        SubtitleSt string ->
            optional path (Just string)

        SubtitleIn i18nString ->
            internationalizedString path i18nString


productionContentWarning : Validator ContentWarningItem
productionContentWarning path data =
    case data of
        ContentWarningItemSt string ->
            optional path (Just string)

        ContentWarningItemIn i18nString ->
            internationalizedString path i18nString


superEventDescription : Validator SuperEvent.Description
superEventDescription path data =
    case data of
        SuperEvent.DescriptionSt string ->
            optional path (Just string)

        SuperEvent.DescriptionIn i18nString ->
            internationalizedString path i18nString


subEventDescription : Validator Event.Description
subEventDescription path data =
    case data of
        Event.DescriptionSt string ->
            optional path (Just string)

        Event.DescriptionIn i18nString ->
            internationalizedString path i18nString


internationalizedString : Validator InternationalizedString
internationalizedString =
    object
        [ field "/en" .en optional
        , field "/de" .de optional
        , field "/fr" .fr optional
        ]


originalWork : Validator Data.Root.OriginalWork
originalWork =
    object
        [ field "/author" .author (maybe (list agent))
        , field "/name" .name required
        , field "/translator" .translator (maybe (list agent))
        ]


address : Validator PostalAddress
address =
    object
        [ field "/addressCountry" .addressCountry optional
        , field "/addressLocality" .addressLocality required
        , field "/postalCode" .postalCode required
        , field "/streetAddress" .streetAddress optional
        ]


audience : Validator Audience
audience =
    object
        [ field "/audienceType" .audienceType optional
        , field "/suggestedMinAge" (\data -> ( data.suggestedMinAge, data.suggestedMaxAge )) minMaxAge
        , field "/requiredMinAge" (\data -> ( data.requiredMinAge, data.requiredMaxAge )) minMaxAge
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
        , field "/description" .description optional
        ]



-- HELPERS


elementCount : a -> List a -> Int
elementCount element all =
    let
        equalsElement =
            (==) element
    in
    List.Extra.count equalsElement all


isEmptyString : String -> Bool
isEmptyString string =
    String.isEmpty (String.trim string)
