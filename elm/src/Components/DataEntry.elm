module Components.DataEntry exposing (Model, ZoneWithName, abstract, asDate, asDateAndTime, asImage, asLink, asTime, eventDescription, eventName, join, map, nested, optional, productionContentWarning, productionDescription, productionName, productionSubtitle, required, superEventDescription, superEventName, view, viewConcat, withHelp, withWarnings)

import Data.Event as Event
import Data.InternationalizedString exposing (InternationalizedString)
import Data.Root exposing (Abstract(..), ContentWarningItem(..), Description(..), Name(..), Subtitle(..))
import Data.SuperEvent as SuperEvent
import DateFormat
import Helper.CustomValidations exposing (Validator, viewerMessage)
import Html exposing (..)
import Html.Attributes exposing (attribute, class, href, src, style, target)
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
    | Logo
    | Date ZoneWithName
    | Time ZoneWithName
    | DateTime ZoneWithName


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


mapValue : (a -> b) -> Model a -> Maybe b
mapValue f entry =
    case entry.value of
        Required value ->
            Just (f value)

        Optional (Just value) ->
            Just (f value)

        Optional Nothing ->
            Nothing


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


asImage : Model a -> Model a
asImage entry =
    { entry | options = Logo }


asDate : ZoneWithName -> Model a -> Model a
asDate zone entry =
    { entry | options = Date zone }


asTime : ZoneWithName -> Model String -> Model String
asTime zone entry =
    { entry | options = Time zone }
        |> withWarnings Helper.CustomValidations.dateTime


asDateAndTime : ZoneWithName -> Model String -> Model String
asDateAndTime zone entry =
    { entry | options = DateTime zone }
        |> withWarnings Helper.CustomValidations.dateTime


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


viewConcat : List (List (Model String)) -> Html msg
viewConcat entries =
    entries
        |> List.concat
        |> view


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

        Logo ->
            td []
                [ Html.a [ href value, target "_blank" ] [ img [ class "logo", src value ] [] ]
                ]

        Date zone ->
            td []
                [ text (formatDate value zone) ]

        Time zone ->
            td []
                [ text (formatTime value zone) ]

        DateTime zone ->
            td []
                [ text (formatDateTime value zone) ]


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

        ( Just v, Logo ) ->
            td
                []
                [ Html.a [ href v, target "_blank" ] [ img [ class "logo", src v ] [] ]
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

        ( Just v, DateTime zone ) ->
            td
                []
                [ text (formatDateTime v zone)
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


formatDateTime : String -> ZoneWithName -> String
formatDateTime isoString ( name, timezone ) =
    case Iso8601.toTime isoString of
        Ok result ->
            DateFormat.format
                [ DateFormat.dayOfMonthFixed
                , DateFormat.text "."
                , DateFormat.monthFixed
                , DateFormat.text "."
                , DateFormat.yearNumber
                , DateFormat.text ", "
                , DateFormat.hourMilitaryFixed
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


expandInternationalizedString : String -> InternationalizedString -> List (Model String)
expandInternationalizedString name i18nString =
    [ optional (name ++ " (de)") i18nString.de
    , optional (name ++ " (en)") i18nString.en
    , optional (name ++ " (fr)") i18nString.fr
    ]


abstract : Model Abstract -> List (Model String)
abstract entry =
    let
        mapAbstract name value =
            case value of
                AbstractSt string ->
                    [ required name string ]

                AbstractIn string ->
                    expandInternationalizedString name string
    in
    mapValue
        (mapAbstract entry.name)
        entry
        |> Maybe.withDefault [ optional entry.name Nothing ]


productionName : Model Name -> List (Model String)
productionName entry =
    let
        mapName name value =
            case value of
                NameSt string ->
                    [ required name string ]

                NameIn string ->
                    expandInternationalizedString name string
    in
    mapValue
        (mapName entry.name)
        entry
        |> Maybe.withDefault [ optional entry.name Nothing ]


productionSubtitle : Model Subtitle -> List (Model String)
productionSubtitle entry =
    let
        mapSubtitle name value =
            case value of
                SubtitleSt string ->
                    [ required name string ]

                SubtitleIn string ->
                    expandInternationalizedString name string
    in
    mapValue
        (mapSubtitle entry.name)
        entry
        |> Maybe.withDefault [ optional entry.name Nothing ]


productionDescription : Model Description -> List (Model String)
productionDescription entry =
    let
        mapDescription name value =
            case value of
                DescriptionSt string ->
                    [ required name string ]

                DescriptionIn string ->
                    expandInternationalizedString name string
    in
    mapValue
        (mapDescription entry.name)
        entry
        |> Maybe.withDefault [ optional entry.name Nothing ]


productionContentWarning : Model ContentWarningItem -> List (Model String)
productionContentWarning entry =
    let
        mapWarning name value =
            case value of
                ContentWarningItemSt string ->
                    [ required name string ]

                ContentWarningItemIn string ->
                    expandInternationalizedString name string
    in
    mapValue
        (mapWarning entry.name)
        entry
        |> Maybe.withDefault [ optional entry.name Nothing ]


eventDescription : Model Event.Description -> List (Model String)
eventDescription entry =
    let
        mapDescription name value =
            case value of
                Event.DescriptionSt string ->
                    [ required name string ]

                Event.DescriptionIn string ->
                    expandInternationalizedString name string
    in
    mapValue
        (mapDescription entry.name)
        entry
        |> Maybe.withDefault [ optional entry.name Nothing ]


eventName : Model Event.Name -> List (Model String)
eventName entry =
    let
        mapDescription name value =
            case value of
                Event.NameSt string ->
                    [ required name string ]

                Event.NameIn string ->
                    expandInternationalizedString name string
    in
    mapValue
        (mapDescription entry.name)
        entry
        |> Maybe.withDefault [ optional entry.name Nothing ]


superEventDescription : Model SuperEvent.Description -> List (Model String)
superEventDescription entry =
    let
        mapDescription name value =
            case value of
                SuperEvent.DescriptionSt string ->
                    [ required name string ]

                SuperEvent.DescriptionIn string ->
                    expandInternationalizedString name string
    in
    mapValue
        (mapDescription entry.name)
        entry
        |> Maybe.withDefault [ optional entry.name Nothing ]


superEventName : Model SuperEvent.Name -> List (Model String)
superEventName entry =
    let
        mapDescription name value =
            case value of
                SuperEvent.NameSt string ->
                    [ required name string ]

                SuperEvent.NameIn string ->
                    expandInternationalizedString name string
    in
    mapValue
        (mapDescription entry.name)
        entry
        |> Maybe.withDefault [ optional entry.name Nothing ]
