module Components.DataEntry exposing (ZoneWithName, asDate, asLink, asTime, map, nestedOptional, optional, required, view)

import DateFormat
import Html exposing (..)
import Html.Attributes exposing (class, href, target)
import Iso8601
import Time


type DataEntry a
    = Required { name : String, value : a, options : Options }
    | Optional { name : String, value : Maybe a, options : Options }


type Options
    = Default
    | Link (Maybe String)
    | Date ZoneWithName
    | Time ZoneWithName


type alias ZoneWithName =
    ( String, Time.Zone )



-- CREATION


required : String -> a -> DataEntry a
required name value =
    Required { name = name, value = value, options = Default }


optional : String -> Maybe a -> DataEntry a
optional name value =
    Optional { name = name, value = value, options = Default }


nestedOptional : String -> Maybe a -> (a -> Maybe b) -> DataEntry b
nestedOptional name value f =
    Optional { name = name, value = Maybe.andThen f value, options = Default }



-- TRANSFORMATION


map : (a -> b) -> DataEntry a -> DataEntry b
map f entry =
    case entry of
        Required { name, value, options } ->
            Required { name = name, value = f value, options = options }

        Optional { name, value, options } ->
            Optional { name = name, value = Maybe.map f value, options = options }


asLink : Maybe String -> DataEntry a -> DataEntry a
asLink linkText entry =
    case entry of
        Required data ->
            Required { data | options = Link linkText }

        Optional data ->
            Optional { data | options = Link linkText }


asDate : ZoneWithName -> DataEntry a -> DataEntry a
asDate zone entry =
    case entry of
        Required data ->
            Required { data | options = Date zone }

        Optional data ->
            Optional { data | options = Date zone }


asTime : ZoneWithName -> DataEntry a -> DataEntry a
asTime zone entry =
    case entry of
        Required data ->
            Required { data | options = Time zone }

        Optional data ->
            Optional { data | options = Time zone }



-- VIEW


view : List (DataEntry String) -> Html msg
view entries =
    table [ class "table is-hoverable" ]
        [ tbody []
            (List.map viewEntry entries)
        ]


viewEntry : DataEntry String -> Html msg
viewEntry entry =
    case entry of
        Required { name, value, options } ->
            tr []
                [ th [] [ text name ]
                , viewRequired value options
                ]

        Optional { name, value, options } ->
            tr []
                [ th [] [ text name ]
                , viewOptional value options
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
