module Helper.CustomValidations exposing (checkAll)

import Data.Root exposing (Address, AddressLocation, Creator, CreatorItem, Event, EventsEventStatus(..), LocationItem(..), Offer, Organization, Performer, PerformerItem, PriceSpecification, Production, Root, VirtualLocation)
import Helper.LanguageCodes as LanguageCodes
import LanguageTag.Parser


type alias ValidationMessage =
    { path : String
    , message : String
    }


type alias Validator value =
    String -> value -> List ValidationMessage


checkAll : Root -> List ValidationMessage
checkAll data =
    object
        [ field "/organization" .organization organization
        , field "/productions" .productions (list production)
        ]
        |> check data


organization : Validator Organization
organization =
    object
        [ field "/address" .address (maybe address)
        , field "/name" .name required
        ]


check : model -> Validator model -> List ValidationMessage
check data validator =
    validator "" data


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
        [ ValidationMessage path "is a required text field, but you provided an empty value"
        ]

    else
        []


optional : Validator (Maybe String)
optional path value =
    case value of
        Just text ->
            if String.trim text == "" then
                [ ValidationMessage path "is empty. You can omit optional text fields if there is no content."
                ]

            else
                []

        Nothing ->
            []



-- CUSTOM VALIDATORS


duration : Validator Int
duration path minutes =
    if minutes > 900 then
        [ ValidationMessage path
            "seems to be very long. The duration field is supposed to contain the event's duration in minutes. Are you sure you didn't accidentally use seconds instead?"
        ]

    else if minutes >= 0 && minutes < 10 then
        -- the duration being negative is already a validation error, so we don't need to cover this case here
        [ ValidationMessage path
            "seems to be very short. The duration field is supposed to contain the event's duration in minutes. Are you sure you didn't accidentally use hours instead?"
        ]

    else
        []


geocoordinates : Validator AddressLocation
geocoordinates path data =
    case ( data.latitude, data.longitude ) of
        ( Nothing, Just _ ) ->
            [ ValidationMessage path "has a longitude but no latitude" ]

        ( Just _, Nothing ) ->
            [ ValidationMessage path "has a latitude but no longitude" ]

        _ ->
            []


teaserOrDescription : Validator Production
teaserOrDescription path data =
    case ( data.abstract, data.description ) of
        ( Nothing, Nothing ) ->
            [ ValidationMessage path "has neither a description nor a teaser. You should set at least one of these fields." ]

        _ ->
            []


previousStartDateIsSet : Validator Event
previousStartDateIsSet path data =
    case ( data.eventStatus, data.startDate, data.previousStartDate ) of
        ( Just EventPostponedEvents, _, Nothing ) ->
            [ ValidationMessage (path ++ "/previousStartDate") "should be set for postponed events" ]

        ( Just EventRescheduledEvents, start, Just previousStart ) ->
            if start == previousStart then
                [ ValidationMessage (path ++ "/previousStartDate") "should be different from startDate for rescheduled events" ]

            else
                []

        ( Just EventRescheduledEvents, _, Nothing ) ->
            [ ValidationMessage (path ++ "/previousStartDate") "should be set for rescheduled events" ]

        ( _, _, _ ) ->
            []


languageTagValid : Validator String
languageTagValid path data =
    let
        validationMsg =
            ValidationMessage path "doesn't seem to be a valid language code. This field should contain language codes like 'en', 'de', etc."
    in
    case LanguageTag.Parser.parseBcp47 data of
        Just ( lang, _ ) ->
            if LanguageCodes.isValid lang then
                []

            else
                [ validationMsg ]

        Nothing ->
            [ validationMsg ]


rangeValid : Validator PriceSpecification
rangeValid path data =
    case data.maxPrice of
        Nothing ->
            []

        Just maxPrice ->
            if data.minPrice > maxPrice then
                [ ValidationMessage (path ++ "/minPrice") "should be smaller than maxPrice"
                ]

            else
                []



-- MODEL VALIDATORS


event : Validator Event
event =
    object
        [ field "/duration" .duration (maybe duration)
        , field "/endDate" .endDate optional
        , field "/inLanguage" .inLanguage (maybe languageTagValid)
        , field "/location" .location (maybe (list location))
        , field "/offers" .offers (maybe (list offer))
        , field "/performer" .performer (maybe (list performerItem))
        , field "/previousStartDate" .previousStartDate optional
        , field "/startDate" .startDate required
        , field "/subtitleLanguage" .subtitleLanguage (maybe languageTagValid)
        , field "/url" .url optional
        , previousStartDateIsSet
        ]


creatorItem : Validator CreatorItem
creatorItem =
    object
        [ field "/creator" .creator creator
        , field "/roleName" .roleName optional
        ]


creator : Validator Creator
creator =
    object
        [ field "/name" .name required
        ]


performerItem : Validator PerformerItem
performerItem =
    object
        [ field "/performer" .performer performer
        , field "/characterName" .characterName optional
        ]


performer : Validator Performer
performer =
    object
        [ field "/name" .name required
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
        , rangeValid
        ]


production : Validator Production
production =
    object
        [ field "/accessibilitySummary" .accessibilitySummary optional
        , field "/additionalInfo" .additionalInfo optional
        , field "/creator" .creator (maybe (list creatorItem))
        , field "/description" .description optional
        , field "/events" .events (list event)
        , field "/subtitle" .subtitle optional
        , field "/abstract" .abstract optional
        , field "/name" .name required
        , teaserOrDescription
        ]


address : Validator Address
address =
    object
        [ field "/addressLocality" .addressLocality optional
        , field "/postalCode" .postalCode optional
        , field "/streetAddress" .streetAddress optional
        ]


location : Validator LocationItem
location path data =
    case data of
        Physical physical ->
            addressLocation path physical

        Virtual virtual ->
            virtualLocation path virtual


addressLocation : Validator AddressLocation
addressLocation =
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
