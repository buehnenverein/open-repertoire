module View exposing (main)

import Browser
import Data.Root exposing (CreatorItem, Event, LocationItem(..), Offer, PerformerItem, Production, Root, WheelChairPlaces, rootDecoder)
import DateFormat
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (Error(..))
import Iso8601
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..))
import Set exposing (Set)
import Task
import Time
import TimeZone
import Url


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { input : String
    , localTimeZone : ZoneWithName
    , data : EventData
    }


type alias Data =
    { root : Root
    , nameFilter : String
    , hiddenProductions : Set Int
    , hiddenEvents : Set Int
    }


type Error
    = HttpError Http.Error
    | JsonError Decode.Error


type alias EventData =
    RemoteData Error Data


type alias ZoneWithName =
    ( String, Time.Zone )


type Msg
    = Submit String
    | TextChange String
    | GotTimeZone ZoneWithName
    | Response (RemoteData Http.Error Root)
    | ProductionCardClicked Int Bool
    | EventCardClicked Int Bool
    | NameFilterChanged String


init : () -> ( Model, Cmd Msg )
init _ =
    ( { input = ""
      , localTimeZone = ( "UTC", Time.utc )
      , data = NotAsked
      }
    , getTimeZone
    )


newData : Root -> Data
newData value =
    { root = value
    , nameFilter = ""
    , hiddenProductions = Set.empty
    , hiddenEvents = Set.empty
    }


getTimeZone : Cmd Msg
getTimeZone =
    Task.perform GotTimeZone
        (TimeZone.getZone
            |> Task.onError
                (\_ ->
                    Task.succeed ( "UTC", Time.utc )
                )
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit input ->
            fetchData model input

        TextChange text ->
            ( { model | data = NotAsked, input = text }, Cmd.none )

        GotTimeZone zone ->
            ( { model | localTimeZone = zone }, Cmd.none )

        Response response ->
            ( { model
                | data =
                    RemoteData.mapError HttpError response
                        |> RemoteData.map newData
              }
            , Cmd.none
            )

        ProductionCardClicked index isOpen ->
            ( { model | data = toggleProductionCard model.data index isOpen }, Cmd.none )

        EventCardClicked index isOpen ->
            ( { model | data = toggleEventCard model.data index isOpen }, Cmd.none )

        NameFilterChanged filter ->
            ( { model | data = updateNameFilter model.data filter }, Cmd.none )


fetchData : Model -> String -> ( Model, Cmd Msg )
fetchData model inputString =
    if isUrl inputString then
        ( { model | data = Loading }
        , Http.get
            { url = inputString
            , expect = Http.expectJson (RemoteData.fromResult >> Response) rootDecoder
            }
        )

    else
        case Decode.decodeString rootDecoder inputString of
            Ok jsonValue ->
                ( { model | data = Success (newData jsonValue) }, Cmd.none )

            Err parsingError ->
                ( { model | data = Failure (JsonError parsingError) }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        enableButton =
            case model.data of
                Loading ->
                    False

                _ ->
                    True
    in
    div [ class "container" ]
        [ viewIntroduction
        , viewInput model.input enableButton
        , case model.data of
            NotAsked ->
                text ""

            Loading ->
                text ""

            Failure (HttpError error) ->
                viewRequestError model.input error

            Failure (JsonError _) ->
                section
                    [ div [ class "notification is-danger" ]
                        [ viewJsonError ]
                    ]

            Success data ->
                viewData data model.localTimeZone
        ]



-- VIEW HELPERS


viewData : Data -> ZoneWithName -> Html Msg
viewData data zone =
    let
        productionOpen index =
            not
                (Set.member index data.hiddenProductions)

        eventOpen index =
            not
                (Set.member index data.hiddenEvents)

        viewProduction : Int -> Production -> Html Msg
        viewProduction index production =
            div []
                [ div [ class "sticky-header" ]
                    [ h1 [ class "is-size-1" ] [ text production.name ]
                    ]
                , card (text "Info")
                    (productionTable production)
                    (productionOpen index)
                    (ProductionCardClicked index (not (productionOpen index)))
                , card (text "Veranstaltungen")
                    (div [] <| viewEvents production.events zone)
                    (eventOpen index)
                    (EventCardClicked index (not (eventOpen index)))
                ]
    in
    section
        [ filterInput data.nameFilter
        , div []
            (data.root.productions
                |> List.filter (productionNameMatches data.nameFilter)
                |> List.indexedMap viewProduction
            )
        ]


looksLikeUrl : String -> Bool
looksLikeUrl string =
    (String.startsWith "http" string
        || String.startsWith "www" string
        || not (looksLikeJson string)
    )
        && not (String.isEmpty string)


looksLikeJson : String -> Bool
looksLikeJson string =
    (String.startsWith "{" string
        || String.startsWith "[" string
    )
        && not (String.isEmpty string)


isUrl : String -> Bool
isUrl string =
    case ( Url.fromString string, Url.fromString ("https://" ++ string) ) of
        ( Just _, _ ) ->
            True

        ( _, Just _ ) ->
            True

        ( Nothing, Nothing ) ->
            False


isJson : String -> Bool
isJson string =
    case Decode.decodeString Decode.value string of
        Ok _ ->
            True

        Err _ ->
            False



-- PRODUCTIONS


productionNameMatches : String -> Production -> Bool
productionNameMatches filter production =
    String.contains (String.toLower filter) (String.toLower production.name)


productionTable : Production -> Html Msg
productionTable production =
    table
        [ class "table is-hoverable" ]
        [ tbody []
            [ tableRow "Titel" production.name
            , maybeTableRow "Untertitel" production.subtitle
            , maybeTableRow "Beschreibung" production.description
            , maybeTableRow "Kurzbeschreibung" production.abstract
            , maybeTableRow "Zusätzliche Informationen" production.additionalInfo
            , maybeTableRow "Genre" (Maybe.map Data.Root.productionsGenreToString production.genre)
            , tr []
                [ th [] [ text "Team" ]
                , td []
                    [ viewCreators production.creator
                    ]
                ]
            ]
        ]



-- EVENTS


viewEvents : List Event -> ZoneWithName -> List (Html Msg)
viewEvents events zone =
    List.map (viewEvent zone) events
        |> List.intersperse (hr [ class "has-background-grey-light mb-6 mt-6" ] [])


viewEvent : ZoneWithName -> Event -> Html Msg
viewEvent zone event =
    div []
        [ div [ class "tile is-ancestor" ]
            [ div [ class "tile is-vertical is-parent" ]
                [ div [ class "tile is-child box" ]
                    [ viewEventTable zone event
                    ]
                ]
            , div [ class "tile is-vertical is-parent" ]
                [ div [ class "tile is-child box" ]
                    [ viewLocations event.location
                    ]
                , div [ class "tile is-child box" ]
                    [ viewOffers event.offers
                    ]
                ]
            ]
        ]


viewEventTable : ZoneWithName -> Event -> Html Msg
viewEventTable zone event =
    table [ class "table" ]
        [ tbody []
            [ tableRow "Startdatum" (formatDate event.startDate zone)
            , tableRow "Startzeit" (formatTime event.startDate zone)
            , tableRow "Enddatum" (formatDate (Maybe.withDefault "" event.endDate) zone)
            , tableRow "Endzeit" (formatTime (Maybe.withDefault "" event.endDate) zone)
            , tableRow "Dauer" (Maybe.map formatDuration event.duration |> Maybe.withDefault "")
            , tr []
                [ th []
                    [ text "Link"
                    ]
                , td []
                    [ maybeLink event.url
                    ]
                ]
            , tr []
                [ th [] [ text "Besetzung" ]
                , td [] [ viewPerformers event.performer ]
                ]
            ]
        ]



-- LOCATIONS


viewLocations : Maybe (List LocationItem) -> Html Msg
viewLocations locations =
    case locations of
        Nothing ->
            em [] [ text "In den Daten ist kein Ort für diese Veranstaltung angegeben." ]

        Just [] ->
            em [] [ text "In den Daten ist kein Ort für diese Veranstaltung angegeben." ]

        Just list ->
            div []
                [ div [ class "title is-5" ]
                    [ text "Aufführungsort"
                    , locationTag list
                    ]
                , div [] (List.map locationTable list)
                ]


locationTag : List LocationItem -> Html Msg
locationTag locations =
    case ( isOnlineEvent locations, isOfflineEvent locations ) of
        ( True, True ) ->
            span
                [ class "tag is-info is-light ml-2 has-tooltip-arrow has-tooltip-multiline"
                , attribute "data-tooltip" "Es handelt sich um eine hybride Veranstaltung, die sowohl online als auch offline stattfindet"
                ]
                [ text "Hybrid" ]

        ( True, False ) ->
            span
                [ class "tag is-info is-light ml-2 has-tooltip-arrow has-tooltip-multiline"
                , attribute "data-tooltip" "Es handelt sich um eine Veranstaltung, die online stattfindet"
                ]
                [ text "Online" ]

        _ ->
            text ""


locationTable : LocationItem -> Html Msg
locationTable location =
    case location of
        Physical place ->
            table [ class "table" ]
                [ tbody []
                    [ maybeTableRow "Name" place.name
                    , maybeTableRow "Addresse" place.address.streetAddress
                    , maybeTableRow "Postleitzahl" place.address.postalCode
                    , maybeTableRow "Stadt" place.address.addressLocality
                    , tr []
                        [ th [] [ text "Koordinaten" ]
                        , td []
                            [ geoCoordinates place
                            ]
                        ]
                    , maybeTableRow "Rollstuhlplätze" (wheelChairCount place.wheelChairPlaces)
                    , tableRow "Platz für Assistent:in?" (spaceForAssistant place.wheelChairPlaces)
                    , maybeTableRow "Rollstuhlkapazität" (wheelChairCapacity place.wheelChairPlaces)
                    ]
                ]

        Virtual info ->
            table [ class "table" ]
                [ tbody []
                    [ maybeTableRow "Name" info.name
                    , maybeTableRow "Link" info.url
                    ]
                ]


wheelChairCapacity : Maybe WheelChairPlaces -> Maybe String
wheelChairCapacity wheelChairPlaces =
    case Maybe.map .wheelchairUserCapacity wheelChairPlaces of
        Just capacity ->
            Maybe.map String.fromInt capacity

        Nothing ->
            Just ""


spaceForAssistant : Maybe WheelChairPlaces -> String
spaceForAssistant wheelChairPlaces =
    case Maybe.andThen .hasSpaceForAssistant wheelChairPlaces of
        Just True ->
            "Ja"

        Just False ->
            "Nein"

        Nothing ->
            ""


wheelChairCount : Maybe WheelChairPlaces -> Maybe String
wheelChairCount wheelChairPlaces =
    Maybe.map .count wheelChairPlaces
        |> Maybe.map String.fromInt


geoCoordinates : { a | latitude : Maybe Float, longitude : Maybe Float } -> Html Msg
geoCoordinates place =
    case ( place.latitude, place.longitude ) of
        ( Just lat, Just lon ) ->
            osmLink { latitude = lat, longitude = lon }

        _ ->
            text ""


osmLink : { a | latitude : Float, longitude : Float } -> Html Msg
osmLink place =
    let
        url =
            "https://www.osm.org/?zoom=19&mlat="
                ++ String.fromFloat place.latitude
                ++ "&mlon="
                ++ String.fromFloat place.longitude
    in
    a [ href url, target "_blank" ] [ text "Karte anzeigen" ]



-- PARTICIPANTS


viewCreators : Maybe (List CreatorItem) -> Html Msg
viewCreators creators =
    case creators of
        Nothing ->
            text ""

        Just list ->
            ul []
                (List.map viewCreator list)


viewCreator : CreatorItem -> Html Msg
viewCreator creator =
    li []
        [ [ creator.roleName
          , Just creator.creator.name
          ]
            |> List.filterMap identity
            |> String.join ":"
            |> text
        ]


viewPerformers : Maybe (List PerformerItem) -> Html Msg
viewPerformers performers =
    case performers of
        Nothing ->
            text ""

        Just list ->
            ul []
                (List.map viewPerformer list)


viewPerformer : PerformerItem -> Html Msg
viewPerformer performer =
    li []
        [ [ performer.characterName
          , Just performer.performer.name
          ]
            |> List.filterMap identity
            |> String.join ":"
            |> text
        ]



-- OFFERS


viewOffers : Maybe (List Offer) -> Html Msg
viewOffers offers =
    case offers of
        Nothing ->
            table [ class "table is-fullwidth" ]
                [ thead []
                    [ tr []
                        [ th [] [ text "Ticketinformationen" ]
                        ]
                    ]
                , tbody
                    []
                    [ tr []
                        [ td [] [ em [] [ text "Die Daten enthalten keine Ticketinformationen für diese Veranstaltung" ] ]
                        ]
                    ]
                ]

        Just list ->
            table [ class "table is-fullwidth" ]
                [ thead []
                    [ tr []
                        [ th [ colspan 3 ] [ text "Ticketinformationen" ]
                        ]
                    ]
                , tbody
                    []
                    (tr []
                        [ th [] [ text "Name" ]
                        , th [] [ text "Preis" ]
                        , th [] [ text "Link" ]
                        ]
                        :: List.map viewOffer list
                    )
                ]


viewOffer : Offer -> Html Msg
viewOffer offer =
    let
        formattedPrice =
            [ Just offer.priceSpecification.minPrice
            , offer.priceSpecification.maxPrice
            ]
                |> List.filterMap identity
                |> List.map (\price -> String.fromFloat price ++ " " ++ offer.priceSpecification.priceCurrency)
                |> String.join " - "
    in
    tr []
        [ td []
            [ text (Maybe.withDefault "" offer.name)
            ]
        , td [] [ text formattedPrice ]
        , td [] [ maybeLink offer.url ]
        ]



-- HELPERS


isOnlineEvent : List LocationItem -> Bool
isOnlineEvent locations =
    let
        isVirtualLocation : LocationItem -> Bool
        isVirtualLocation location =
            case location of
                Physical _ ->
                    False

                Virtual _ ->
                    True
    in
    List.any isVirtualLocation locations


isOfflineEvent : List LocationItem -> Bool
isOfflineEvent locations =
    let
        isPhysicalLocation : LocationItem -> Bool
        isPhysicalLocation location =
            case location of
                Physical _ ->
                    True

                Virtual _ ->
                    False
    in
    List.any isPhysicalLocation locations


updateNameFilter : EventData -> String -> EventData
updateNameFilter remoteData filter =
    case remoteData of
        Success data ->
            Success { data | nameFilter = filter }

        _ ->
            remoteData


toggleProductionCard : EventData -> Int -> Bool -> EventData
toggleProductionCard remoteData index isOpen =
    case ( remoteData, isOpen ) of
        ( Success data, True ) ->
            Success { data | hiddenProductions = Set.remove index data.hiddenProductions }

        ( Success data, False ) ->
            Success { data | hiddenProductions = Set.insert index data.hiddenProductions }

        ( _, _ ) ->
            remoteData


toggleEventCard : EventData -> Int -> Bool -> EventData
toggleEventCard remoteData index isOpen =
    case ( remoteData, isOpen ) of
        ( Success data, True ) ->
            Success { data | hiddenEvents = Set.remove index data.hiddenEvents }

        ( Success data, False ) ->
            Success { data | hiddenEvents = Set.insert index data.hiddenEvents }

        ( _, _ ) ->
            remoteData


card : Html Msg -> Html Msg -> Bool -> Msg -> Html Msg
card title content isOpen clickHandler =
    div [ class "card" ]
        [ div
            [ class "card-header has-background-primary is-clickable"
            , onClick clickHandler
            ]
            [ div [ class "card-header-title has-text-white" ]
                [ title
                , span [ style "margin-left" "0.5em" ] []
                , i
                    [ class "fas  has-text-white"
                    , classList [ ( "fa-angle-down", isOpen ), ( "fa-angle-right", not isOpen ) ]
                    ]
                    []
                ]
            ]
        , if isOpen then
            div [ class "card-content" ]
                [ content ]

          else
            text ""
        ]


section : List (Html Msg) -> Html Msg
section content =
    div [ class "section" ]
        [ div [ class "container" ] content
        ]


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


formatDuration : Int -> String
formatDuration duration =
    let
        hours =
            duration // 60

        minutes =
            modBy 60 duration
    in
    if minutes >= 10 then
        String.fromInt hours ++ ":" ++ String.fromInt minutes ++ "h"

    else if minutes > 0 then
        String.fromInt hours ++ ":0" ++ String.fromInt minutes ++ "h"

    else
        String.fromInt hours ++ ":00" ++ "h"


maybeLink : Maybe String -> Html Msg
maybeLink url =
    case url of
        Just link ->
            Html.a [ href link, target "_blank" ] [ text link ]

        Nothing ->
            text ""


tableRow : String -> String -> Html Msg
tableRow name value =
    tr []
        [ th []
            [ text name
            ]
        , td
            [ class "preserve-newlines" ]
            [ text value
            ]
        ]


maybeTableRow : String -> Maybe String -> Html Msg
maybeTableRow name value =
    tr []
        [ th []
            [ text name
            ]
        , td
            [ class "preserve-newlines" ]
            [ text (Maybe.withDefault "" value)
            ]
        ]


viewRequestError : String -> Http.Error -> Html Msg
viewRequestError url error =
    section
        [ div [ class "notification is-danger" ]
            [ case error of
                BadUrl invalidUrl ->
                    text ("Ich konnte " ++ invalidUrl ++ "nicht finden. Bitte stellen Sie sicher, dass der Link korrekt ist.")

                Timeout ->
                    text "Der Server scheint zur Zeit nicht erreichbar zu sein. Bitte versuchen Sie es in ein paar Minuten noch einmal."

                NetworkError ->
                    viewNetworkError url

                BadStatus code ->
                    text
                        ("Der Server konnte meine Anfrage nicht verarbeiten (Status code: "
                            ++ String.fromInt code
                            ++ "). Leider kann ich deswegen keine Daten anzeigen. Bitte stellen Sie sicher, dass der Link korrekt ist."
                        )

                BadBody _ ->
                    viewJsonError
            ]
        ]


viewNetworkError : String -> Html Msg
viewNetworkError url =
    div []
        [ text "Beim Versuch, Daten von diesem Link abzurufen, ist ein Fehler aufgetreten."
        , h1 [ class "title is-size-5 mt-5" ] [ text "Nächste Schritte:" ]
        , ol []
            [ li []
                [ text "Öffnen Sie den Link in Ihrem Browser:"
                , a [ href url, target "_blank" ] [ text url ]
                ]
            , li []
                [ text "Kopieren Sie die angezeigten Daten"
                ]
            , li []
                [ text "Fügen Sie die kopierten Daten in das Textfeld auf dieser Seite ein und versuchen Sie es erneut"
                ]
            ]
        ]


viewJsonError : Html Msg
viewJsonError =
    div []
        [ text "Leider scheinen Ihre Daten ungültig zu sein."
        , h1 [ class "title is-size-5 mt-5" ] [ text "Nächste Schritte:" ]
        , ul []
            [ li []
                [ text "Wahrscheinlich muss ihre Schnittstelle angepasst werden, um dem vorgegebenen Datenformat zu entsprechen."
                ]
            , li []
                [ text "Bitte kontaktieren Sie den Betreuer Ihrer Schnittstelle und bitten Sie ihn sicherzustellen, dass der Endpunkt gültige Daten zurückgibt."
                ]
            , li []
                [ text "Das "
                , a [ href "../validate" ] [ text "Validierungs-Tool" ]
                , text " kann benutzt werden, um sicherzustellen, dass die Daten gültig sind."
                ]
            ]
        ]



-- GENERAL INTERFACE


viewIntroduction : Html Msg
viewIntroduction =
    section
        [ h1 [ class "is-size-1" ]
            [ text "Anwendungsfall 3 - Datenbetrachter"
            ]
        , p []
            [ text "Verwenden Sie dieses Tool, um die Daten anzuzeigen, die von Ihrem Repertoire-Endpunkt zurückgegeben werden."
            ]
        ]


viewInput : String -> Bool -> Html Msg
viewInput inputString buttonEnabled =
    let
        invalidUrl =
            looksLikeUrl inputString && not (isUrl inputString)

        invalidJson =
            looksLikeJson inputString && not (isJson inputString)

        invalid =
            invalidUrl || invalidJson

        controlAttrs =
            if invalidUrl then
                [ attribute "data-tooltip" "Invalider Link" ]

            else if invalidJson then
                [ attribute "data-tooltip" "Invalides Datenformat" ]

            else
                []
    in
    section
        [ div [ class "field" ]
            [ h3 [ class "label is-size-3" ] [ text "Geben Sie die URL Ihres Endpunkts ein ODER kopieren & fügen Sie Ihre Daten ein" ]
            , div (class "control has-icons-right has-tooltip-arrow" :: controlAttrs)
                [ textarea
                    [ onInput TextChange
                    , value inputString
                    , class "input"
                    , classList [ ( "is-danger", invalid ) ]
                    ]
                    []
                , span [ class "icon is-right" ]
                    [ i [ class "fas has-text-danger", classList [ ( "fa-xmark", invalid ) ] ] []
                    ]
                ]
            ]
        , div [ class "control" ]
            [ button
                [ onClick (Submit inputString)
                , disabled (not buttonEnabled || invalid || String.isEmpty inputString)
                , class "button is-primary"
                ]
                [ text "Daten anzeigen" ]
            ]
        ]


filterInput : String -> Html Msg
filterInput filter =
    div [ class "field" ]
        [ div [ class "label" ] [ text "Ergebnisse nach Titel filtern:" ]
        , div [ class "control" ]
            [ input
                [ type_ "text"
                , onInput NameFilterChanged
                , value filter
                , placeholder "Titel"
                , class "input"
                ]
                []
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
