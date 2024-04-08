module Helper.CustomValidations exposing (checkAll)

import Data.Root exposing (Accessibility, Address, AddressLocation, Event, Location(..), Offer, Participant, Production, Root, VirtualLocation)


type alias ValidationMessage =
    { path : String
    , message : String
    }


type alias Validator value =
    String -> value -> List ValidationMessage


checkAll : Root -> List ValidationMessage
checkAll data =
    object
        [ field "/address" .address (maybe address)
        , field "/name" .name required
        , field "/productions" .productions (list production)
        ]
        |> check data


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
    case ( data.teaser, data.description ) of
        ( Nothing, Nothing ) ->
            [ ValidationMessage path "has neither a description nor a teaser. You should set at least one of these fields." ]

        _ ->
            []



-- MODEL VALIDATORS


event : Validator Event
event =
    object
        [ field "/duration" .duration (maybe duration)
        , field "/endDate" .endDate optional
        , field "/locations" .locations (maybe (list location))
        , field "/offers" .offers (maybe (list offer))
        , field "/startDate" .startDate required
        , field "/url" .url optional
        ]


participant : Validator Participant
participant =
    object
        [ field "/names" .names (list required)
        , field "/function" .function optional
        , field "/role" .role optional
        ]


offer : Validator Offer
offer =
    object
        [ field "/name" .name optional
        , field "/priceCurrency" .priceCurrency required
        , field "/url" .url optional
        ]


production : Validator Production
production =
    object
        [ field "/accessibility" .accessibility (maybe accessibility)
        , field "/additionalInfo" .additionalInfo optional
        , field "/description" .description optional
        , field "/events" .events (list event)
        , field "/participants" .participants (maybe (list participant))
        , field "/subtitle" .subtitle optional
        , field "/teaser" .teaser optional
        , field "/title" .title required
        , teaserOrDescription
        ]


accessibility : Validator Accessibility
accessibility =
    field "/accessibilitySummary" .accessibilitySummary optional


address : Validator Address
address =
    object
        [ field "/city" .city optional
        , field "/postalCode" .postalCode optional
        , field "/streetAddress" .streetAddress optional
        ]


location : Validator Location
location path data =
    case data of
        Physical physical ->
            addressLocation path physical

        Virtual virtual ->
            virtualLocation path virtual


addressLocation : Validator AddressLocation
addressLocation =
    object
        [ field "/city" .city optional
        , field "/name" .name optional
        , field "/postalCode" .postalCode optional
        , field "/streetAddress" .streetAddress optional
        , geocoordinates
        ]


virtualLocation : Validator VirtualLocation
virtualLocation =
    object
        [ field "/name" .name optional
        , field "/url" .url optional
        ]
