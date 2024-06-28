module Components.DataEntry exposing (Model, ZoneWithName, asDate, asLink, asTime, join, map, nested, optional, required, view, withHelp, withWarnings)

import DateFormat
import Helper.CustomValidations exposing (Validator, viewerMessage)
import Html exposing (..)
import Html.Attributes exposing (attribute, class, href, style, target)
import Iso8601
import Time


type alias Model a =
    { name : String
    , value : Value a
    , options : Options
    , helpText : Maybe String
    , warnings : List String
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
    , warnings = []
    }


optional : String -> Maybe a -> Model a
optional name value =
    { name = name
    , value = Optional value
    , options = Default
    , helpText = Nothing
    , warnings = []
    }



-- TRANSFORMATION


applyOne : (a -> Value b) -> (Maybe a -> Value b) -> Model a -> Model b
applyOne requiredFun optionalFun entry =
    { name = entry.name
    , helpText = entry.helpText
    , options = entry.options
    , warnings = entry.warnings
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


join : (a -> String) -> Model (List a) -> Model String
join f entry =
    entry
        |> map (List.map f)
        |> map (String.join ", ")


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


withWarnings : Validator a -> Model a -> Model a
withWarnings validator entry =
    let
        getMessages value =
            List.filterMap viewerMessage (validator "" value)
    in
    case entry.value of
        Required value ->
            { entry | warnings = entry.warnings ++ getMessages value }

        Optional (Just value) ->
            { entry | warnings = entry.warnings ++ getMessages value }

        Optional Nothing ->
            entry



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
            , warningTooltip entry.warnings
            , case entry.helpText of
                Just h ->
                    helpTooltip h

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


helpTooltip : String -> Html msg
helpTooltip message =
    span
        [ attribute "data-tooltip" message
        , class "has-tooltip-arrow has-tooltip-multiline"
        , style "border-bottom" "none"
        ]
        [ text " "
        , i [ class "fas fa-circle-question" ]
            [ text " " ]
        ]


warningTooltip : List String -> Html msg
warningTooltip warnings =
    case warnings of
        [] ->
            text ""

        list ->
            span
                [ attribute "data-tooltip" (String.join " " list)
                , class "has-text-warning has-tooltip-arrow has-tooltip-multiline"
                , style "border-bottom" "none"
                ]
                [ text " "
                , i [ class "fas fa-triangle-exclamation" ]
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
