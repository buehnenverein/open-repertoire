module Components.DataEntry exposing (ZoneWithName, asDate, asLink, asTime, map, nested, optional, required, view, withHelp)

import DateFormat
import Html exposing (..)
import Html.Attributes exposing (attribute, class, href, style, target)
import Iso8601
import Time


type alias Model a =
    { name : String
    , value : Value a
    , options : Options
    , helpText : Maybe String
    }


type Value a
    = Required a
    | Optional (Maybe a)


type Options
    = Default
    | Link (Maybe String)
    | Date ZoneWithName
    | Time ZoneWithName


type alias ZoneWithName =
    ( String, Time.Zone )



-- CREATION


required : String -> a -> Model a
required name value =
    { name = name
    , value = Required value
    , options = Default
    , helpText = Nothing
    }


optional : String -> Maybe a -> Model a
optional name value =
    { name = name
    , value = Optional value
    , options = Default
    , helpText = Nothing
    }



-- TRANSFORMATION


applyOne : (a -> Value b) -> (Maybe a -> Value b) -> Model a -> Model b
applyOne requiredFun optionalFun entry =
    { name = entry.name
    , helpText = entry.helpText
    , options = entry.options
    , value =
        case entry.value of
            Required value ->
                requiredFun value

            Optional value ->
                optionalFun value
    }


map : (a -> b) -> Model a -> Model b
map f entry =
    applyOne (Required << f) (Optional << Maybe.map f) entry


nested : (a -> Maybe b) -> Model a -> Model b
nested f entry =
    applyOne (Optional << f) (Optional << Maybe.andThen f) entry


asLink : Maybe String -> Model a -> Model a
asLink linkText entry =
    { entry | options = Link linkText }


asDate : ZoneWithName -> Model a -> Model a
asDate zone entry =
    { entry | options = Date zone }


asTime : ZoneWithName -> Model a -> Model a
asTime zone entry =
    { entry | options = Time zone }


withHelp : String -> Model a -> Model a
withHelp message entry =
    { entry | helpText = Just message }



-- VIEW


view : List (Model String) -> Html msg
view entries =
    table [ class "table is-hoverable" ]
        [ tbody []
            (List.map viewEntry entries)
        ]


viewEntry : Model String -> Html msg
viewEntry entry =
    tr []
        [ th []
            [ text entry.name
            , case entry.helpText of
                Just h ->
                    help h

                Nothing ->
                    text ""
            ]
        , case entry.value of
            Required value ->
                viewRequired value entry.options

            Optional value ->
                viewOptional value entry.options
        ]


viewRequired : String -> Options -> Html msg
viewRequired value options =
    case options of
        Default ->
            td [ class "preserve-newlines" ]
                [ text value
                ]

        Link linkText ->
            td []
                [ Html.a [ href value, target "_blank" ] [ text (Maybe.withDefault value linkText) ]
                ]

        Date zone ->
            td []
                [ text (formatDate value zone) ]

        Time zone ->
            td []
                [ text (formatTime value zone) ]


viewOptional : Maybe String -> Options -> Html msg
viewOptional value options =
    case ( value, options ) of
        ( Just v, Default ) ->
            td
                [ class "preserve-newlines" ]
                [ text v
                ]

        ( Just v, Link linkText ) ->
            td
                []
                [ Html.a [ href v, target "_blank" ] [ text (Maybe.withDefault v linkText) ]
                ]

        ( Just v, Date zone ) ->
            td
                []
                [ text (formatDate v zone)
                ]

        ( Just v, Time zone ) ->
            td
                []
                [ text (formatTime v zone)
                ]

        ( Nothing, _ ) ->
            td
                []
                [ text ""
                ]


help : String -> Html msg
help message =
    span
        [ attribute "data-tooltip" message
        , class "has-tooltip-arrow has-tooltip-multiline"
        , style "border-bottom" "none"
        ]
        [ text " "
        , i [ class "fas fa-circle-question" ]
            [ text " " ]
        ]



-- HELPERS


formatDate : String -> ZoneWithName -> String
formatDate isoString ( _, timezone ) =
    case Iso8601.toTime isoString of
        Ok result ->
            DateFormat.format
                [ DateFormat.dayOfMonthFixed
                , DateFormat.text "."
                , DateFormat.monthFixed
                , DateFormat.text "."
                , DateFormat.yearNumber
                ]
                timezone
                result

        Err _ ->
            if String.trim isoString == "" then
                ""

            else
                "Ungültige Datumsangabe (" ++ isoString ++ ")"


formatTime : String -> ZoneWithName -> String
formatTime isoString ( name, timezone ) =
    case Iso8601.toTime isoString of
        Ok result ->
            DateFormat.format
                [ DateFormat.hourMilitaryFixed
                , DateFormat.text ":"
                , DateFormat.minuteFixed
                , DateFormat.text (" (" ++ name ++ ")")
                ]
                timezone
                result

        Err _ ->
            if String.trim isoString == "" then
                ""

            else
                "Ungültige Zeitangabe (" ++ isoString ++ ")"
