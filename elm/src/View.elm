module View exposing (main)

import Browser
import Data.Root exposing (CreatorEntry(..), CreatorRole, Event, EventEventStatus(..), LocationItem(..), Offer, Organization, PerformanceRole, Production, ProductionGenre, Root, WheelChairPlace, rootDecoder)
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
                    (productionGrid production)
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


productionGrid : Production -> Html Msg
productionGrid production =
    div [ class "fixed-grid has-3-cols has-1-cols-mobile has-1-cols-tablet has-1-cols-desktop" ]
        [ div [ class "grid" ]
            [ div [ class "cell box mb-0 is-col-span-2-widescreen is-row-span-3" ]
                [ productionInfo production
                ]
            , div [ class "cell box mb-0 is-row-span-2" ]
                [ viewCreators production.creator
                ]
            , div [ class "cell box mb-0 is-row-span-2" ]
                [ viewProductionAudience production
                ]
            , div [ class "cell box mb-0 is-col-span-2-widescreen" ]
                [ viewProductionAccessibility production
                ]
            , div [ class "cell box mb-0 is-col-span-3-widescreen" ]
                [ viewFunders production
                ]
            , div [ class "cell box mb-0 is-col-span-3-widescreen" ]
                [ viewSponsors production
                ]
            ]
        ]


productionInfo : Production -> Html Msg
productionInfo production =
    dataTable
        [ required "Titel" production.name
        , optional "Sprache" production.inLanguage
        , optional "Untertitel" production.subtitle
        , optional "Beschreibung" production.description
        , optional "Kurzbeschreibung" production.abstract
        , optional "Zusätzliche Informationen" production.additionalInfo
        , optional "Genre" production.genre |> dataMap humanReadableGenre
        ]


humanReadableGenre : ProductionGenre -> String
humanReadableGenre genre =
    let
        firstToUpper string =
            case String.toList string of
                [] ->
                    ""

                first :: rest ->
                    Char.toUpper first
                        :: rest
                        |> String.fromList
    in
    Data.Root.productionGenreToString genre
        |> String.split "-"
        |> List.map firstToUpper
        |> String.join " "


viewProductionAudience : Production -> Html Msg
viewProductionAudience production =
    div []
        [ div [ class "title is-5" ] [ text "Zielgruppe" ]
        , dataTable
            [ nestedOptional "Beschreibung" production.audience .audienceType
            , nestedOptional "Mindestalter" production.audience .suggestedMinAge |> dataMap String.fromInt
            , nestedOptional "Höchstalter" production.audience .suggestedMaxAge |> dataMap String.fromInt
            ]
        ]


viewProductionAccessibility : Production -> Html Msg
viewProductionAccessibility production =
    div []
        [ div [ class "title is-5" ] [ text "Barrierefreiheit" ]
        , dataTable
            [ optional "Zugangsmodus" production.accessModeSufficient |> dataMap viewAccessMode
            , optional "Inhaltswarnungen" production.accessibilityHazard |> dataMap viewAccessibilityHazards
            , optional "Barrierefreiheitsbeschreibung" production.accessibilitySummary
            ]
        ]


viewAccessibilityHazards : List Data.Root.AccessibilityHazardItem -> String
viewAccessibilityHazards hazards =
    List.map Data.Root.accessibilityHazardItemToString hazards
        |> String.join ", "


viewAccessMode : List Data.Root.AccessModeSufficientItem -> String
viewAccessMode items =
    List.map Data.Root.accessModeSufficientItemToString items
        |> String.join ", "


viewFunders : Production -> Html Msg
viewFunders production =
    div []
        [ div [ class "title is-5" ] [ text "Förderer" ]
        , case production.funder of
            Nothing ->
                em [] [ text "Die Daten enthalten keine Informationen zu Förderern" ]

            Just list ->
                div [] (List.map viewFunder list)
        ]


viewFunder : Organization -> Html Msg
viewFunder organization =
    dataTable
        [ required "Name" organization.name
        , nestedOptional "Addresse" organization.address .streetAddress
        , nestedOptional "Postleitzahl" organization.address .postalCode
        , nestedOptional "Stadt" organization.address .addressLocality
        , optional "Logo" organization.logo |> asLink (Just "Link")
        ]


viewSponsors : Production -> Html Msg
viewSponsors production =
    div []
        [ div [ class "title is-5" ] [ text "Sponsoren" ]
        , case production.sponsor of
            Nothing ->
                em [] [ text "Die Daten enthalten keine Informationen zu Sponsoren" ]

            Just list ->
                div [] (List.map viewSponsor list)
        ]


viewSponsor : Organization -> Html Msg
viewSponsor organization =
    dataTable
        [ required "Name" organization.name
        , nestedOptional "Addresse" organization.address .streetAddress
        , nestedOptional "Postleitzahl" organization.address .postalCode
        , nestedOptional "Stadt" organization.address .addressLocality
        , optional "Logo" organization.logo |> asLink (Just "Link")
        ]



-- EVENTS


viewEvents : List Event -> ZoneWithName -> List (Html Msg)
viewEvents events zone =
    List.map (viewEvent zone) events
        |> List.intersperse (hr [ class "has-background-grey-light mb-6 mt-6" ] [])


viewEvent : ZoneWithName -> Event -> Html Msg
viewEvent zone event =
    div [ class "fixed-grid has-2-cols" ]
        [ div [ class "grid" ]
            [ div [ class "cell box mb-0 is-col-span-2 is-col-span-1-widescreen" ]
                [ viewEventTable zone event
                ]
            , div [ class "cell box mb-0 is-col-span-2 is-col-span-1-widescreen" ]
                [ viewLocations event.location
                ]
            , div [ class "cell box mb-0 is-col-span-2 is-col-span-1-widescreen" ]
                [ viewPerformers event.performer
                ]
            , div [ class "cell box mb-0 is-col-span-2 is-col-span-1-widescreen" ]
                [ viewOffers event.offers
                ]
            ]
        ]


viewEventTable : ZoneWithName -> Event -> Html Msg
viewEventTable zone event =
    dataTable
        [ required "Startdatum" event.startDate |> asDate zone
        , required "Startzeit" event.startDate |> asTime zone
        , optional "Enddatum" event.endDate |> asDate zone
        , optional "Endzeit" event.endDate |> asTime zone
        , optional "Dauer" event.duration |> dataMap formatDuration
        , optional "Untertitel in" event.subtitleLanguage
        , required "Status" (eventStatusToString event.eventStatus)
        , optional "Vorheriges Startdatum" event.previousStartDate |> asDate zone
        , optional "Vorherige Startzeit" event.previousStartDate |> asTime zone
        , optional "Link" event.url |> asLink Nothing
        ]


eventStatusToString : Maybe EventEventStatus -> String
eventStatusToString eventStatus =
    case eventStatus of
        Nothing ->
            "Findet statt"

        Just EventScheduledEvent ->
            "Findet statt"

        Just EventCancelledEvent ->
            "Abgesagt"

        Just EventMovedOnlineEvent ->
            "Findet online statt"

        Just EventPostponedEvent ->
            "Verschoben"

        Just EventRescheduledEvent ->
            "Geändertes Datum"



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
        LocationItemPl place ->
            dataTable
                [ optional "Name" place.name
                , optional "Addresse" place.address.streetAddress
                , optional "Postleitzahl" place.address.postalCode
                , optional "Stadt" place.address.addressLocality
                , nestedOptional "Koordinaten" (Just place) osmUrl |> asLink (Just "Karte anzeigen")
                , optional "Rollstuhlplätze" place.wheelChairPlaces
                    |> dataMap .count
                    |> dataMap String.fromInt
                , required "Platz für Assistent:in?" (spaceForAssistant place.wheelChairPlaces)
                , nestedOptional "Rollstuhlkapazität" place.wheelChairPlaces .wheelchairUserCapacity
                    |> dataMap String.fromInt
                ]

        LocationItemVi info ->
            dataTable
                [ optional "Name" info.name
                , optional "Link" info.url
                ]


spaceForAssistant : Maybe WheelChairPlace -> String
spaceForAssistant wheelChairPlaces =
    case Maybe.andThen .hasSpaceForAssistant wheelChairPlaces of
        Just True ->
            "Ja"

        Just False ->
            "Nein"

        Nothing ->
            ""


osmUrl : { a | latitude : Maybe Float, longitude : Maybe Float } -> Maybe String
osmUrl place =
    case ( place.latitude, place.longitude ) of
        ( Just lat, Just lon ) ->
            Just
                ("https://www.osm.org/?zoom=19&mlat="
                    ++ String.fromFloat lat
                    ++ "&mlon="
                    ++ String.fromFloat lon
                )

        _ ->
            Nothing



-- PARTICIPANTS


viewCreators : Maybe (List CreatorRole) -> Html Msg
viewCreators creators =
    div []
        [ div [ class "title is-5" ] [ text "Team" ]
        , table [ class "table" ]
            [ tbody []
                (case creators of
                    Nothing ->
                        [ em [] [ text "Die Daten enthalten keine Informationen zum Produktionsteam" ] ]

                    Just list ->
                        List.map viewCreator list
                )
            ]
        ]


viewCreator : CreatorRole -> Html Msg
viewCreator creator =
    tr []
        [ td [] [ text (Maybe.withDefault "" creator.roleName) ]
        , td [] [ text (creatorName creator.creator) ]
        ]


creatorName : CreatorEntry -> String
creatorName creator =
    case creator of
        CreatorEntryPe person ->
            person.name

        CreatorEntryOr organization ->
            organization.name


viewPerformers : Maybe (List PerformanceRole) -> Html Msg
viewPerformers performers =
    div []
        [ div [ class "title is-5" ] [ text "Besetzung" ]
        , table [ class "table" ]
            [ tbody []
                (case performers of
                    Nothing ->
                        [ em [] [ text "Die Daten enthalten keine Informationen zur Besetzung" ] ]

                    Just list ->
                        List.map viewPerformer list
                )
            ]
        ]


viewPerformer : PerformanceRole -> Html Msg
viewPerformer performer =
    tr []
        [ td [] [ text (Maybe.withDefault "" performer.characterName) ]
        , td [] [ text performer.performer.name ]
        ]



-- OFFERS


viewOffers : Maybe (List Offer) -> Html Msg
viewOffers offers =
    div []
        [ div [ class "title is-5" ] [ text "Ticketinformationen" ]
        , case offers of
            Nothing ->
                table [ class "table is-fullwidth" ]
                    [ tbody
                        []
                        [ tr []
                            [ td [] [ em [] [ text "Die Daten enthalten keine Ticketinformationen für diese Veranstaltung" ] ]
                            ]
                        ]
                    ]

            Just list ->
                table [ class "table is-fullwidth" ]
                    [ tbody
                        []
                        (tr []
                            [ th [] [ text "Name" ]
                            , th [] [ text "Preis" ]
                            , th [] [ text "Link" ]
                            ]
                            :: List.map viewOffer list
                        )
                    ]
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

        maybeLink : { url : Maybe String, description : Maybe String } -> Html Msg
        maybeLink { url, description } =
            case url of
                Just link ->
                    Html.a [ href link, target "_blank" ] [ text (Maybe.withDefault link description) ]

                Nothing ->
                    text ""
    in
    tr []
        [ td []
            [ text (Maybe.withDefault "" offer.name)
            ]
        , td [] [ text formattedPrice ]
        , td [] [ maybeLink { url = offer.url, description = Nothing } ]
        ]



-- HELPERS


isOnlineEvent : List LocationItem -> Bool
isOnlineEvent locations =
    let
        isVirtualLocation : LocationItem -> Bool
        isVirtualLocation location =
            case location of
                LocationItemPl _ ->
                    False

                LocationItemVi _ ->
                    True
    in
    List.any isVirtualLocation locations


isOfflineEvent : List LocationItem -> Bool
isOfflineEvent locations =
    let
        isPhysicalLocation : LocationItem -> Bool
        isPhysicalLocation location =
            case location of
                LocationItemPl _ ->
                    True

                LocationItemVi _ ->
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
            [ div [ class "card-header-title has-text-primary-invert" ]
                [ title
                , span [ style "margin-left" "0.5em" ] []
                , i
                    [ class "fas  has-text-primary-invert"
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



-- DATA ENTRY


type DataEntry a
    = Required { name : String, value : a, options : Options }
    | Optional { name : String, value : Maybe a, options : Options }


type Options
    = Default
    | Link (Maybe String)
    | Date ZoneWithName
    | Time ZoneWithName


required : String -> a -> DataEntry a
required name value =
    Required { name = name, value = value, options = Default }


optional : String -> Maybe a -> DataEntry a
optional name value =
    Optional { name = name, value = value, options = Default }


nestedOptional : String -> Maybe a -> (a -> Maybe b) -> DataEntry b
nestedOptional name value f =
    Optional { name = name, value = Maybe.andThen f value, options = Default }


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


viewRequired : String -> Options -> Html Msg
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


viewOptional : Maybe String -> Options -> Html Msg
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


renderEntry : DataEntry String -> Html Msg
renderEntry entry =
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


dataMap : (a -> b) -> DataEntry a -> DataEntry b
dataMap f entry =
    case entry of
        Required { name, value, options } ->
            Required { name = name, value = f value, options = options }

        Optional { name, value, options } ->
            Optional { name = name, value = Maybe.map f value, options = options }


dataTable : List (DataEntry String) -> Html Msg
dataTable entries =
    table [ class "table is-hoverable" ]
        [ tbody []
            (List.map renderEntry entries)
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
