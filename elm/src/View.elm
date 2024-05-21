module View exposing (main)

import Browser
import Components.DataEntry as Entry exposing (asDate, asLink, asTime)
import Data.Root exposing (CreatorEntry(..), CreatorRole, Event, EventEventStatus(..), EventTypeItem(..), LocationItem(..), Offer, Organization, PerformanceRole, Production, ProductionGenre, ProductionProductionType(..), Root, rootDecoder)
import Helper.CustomValidations as CustomValidations
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Lazy exposing (lazy2)
import Http exposing (Error(..))
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
    , localTimeZone : Entry.ZoneWithName
    , data : EventData
    }


type alias Data =
    { root : Root
    , nameFilter : String
    , showOnlyWarning : Bool
    , hiddenProductions : Set Int
    , hiddenEvents : Set Int
    }


type Error
    = HttpError Http.Error
    | JsonError Decode.Error


type alias EventData =
    RemoteData Error Data


type Msg
    = Submit String
    | TextChange String
    | GotTimeZone Entry.ZoneWithName
    | Response (RemoteData Http.Error Root)
    | ProductionCardClicked Int Bool
    | EventCardClicked Int Bool
    | NameFilterChanged String
    | ToggleWarningsFilter
    | ExpandAllClicked
    | CollapseAllClicked


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
    , showOnlyWarning = False
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

        ToggleWarningsFilter ->
            ( { model | data = toggleWarningsFilter model.data }, Cmd.none )

        ExpandAllClicked ->
            ( { model | data = expandAll model.data }, Cmd.none )

        CollapseAllClicked ->
            ( { model | data = collapseAll model.data }, Cmd.none )


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
        , lazy2 viewInput model.input enableButton
        , case model.data of
            NotAsked ->
                text ""

            Loading ->
                text ""

            Failure (HttpError error) ->
                lazy2 viewRequestError model.input error

            Failure (JsonError _) ->
                section
                    [ div [ class "notification is-danger" ]
                        [ viewJsonError ]
                    ]

            Success data ->
                lazy2 viewJsonData data model.localTimeZone
        ]



-- VIEW HELPERS


viewJsonData : Data -> Entry.ZoneWithName -> Html Msg
viewJsonData data zone =
    let
        productionOpen index =
            not
                (Set.member index data.hiddenProductions)

        eventOpen index =
            not
                (Set.member index data.hiddenEvents)

        viewProduction : Int -> Production -> Html Msg
        viewProduction index production =
            div [ class "block mt-6", classList [ ( "is-hidden", not (isProductionVisible data production) ) ] ]
                [ div [ class "hero is-dark is-small sticky-header" ]
                    [ div [ class "hero-body" ]
                        [ p [ class "title" ] [ text production.name ]
                        ]
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
        [ controlBar data
        , div
            [ class "block" ]
            (data.root.productions
                |> List.indexedMap (lazy2 viewProduction)
            )
        ]


isProductionVisible : Data -> Production -> Bool
isProductionVisible data production =
    productionNameMatches data.nameFilter production
        && (not data.showOnlyWarning || hasWarnings production)


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
    Entry.view
        [ Entry.required "ID" production.identifier
        , Entry.required "Titel" production.name
        , Entry.optional "Sprache" production.inLanguage
            |> Entry.withWarnings CustomValidations.languageTagValid
        , Entry.optional "Untertitel" production.subtitle
        , Entry.required "Beschreibung" production
            |> Entry.withWarnings CustomValidations.abstractOrDescription
            |> Entry.withWarnings CustomValidations.abstractDifferentFromDescription
            |> Entry.nested .description
        , Entry.required "Kurzbeschreibung" production
            |> Entry.withWarnings CustomValidations.abstractDifferentFromDescription
            |> Entry.nested .abstract
        , Entry.optional "Zusätzliche Informationen" production.additionalInfo
        , Entry.optional "Genre" production.genre |> Entry.map humanReadableGenre
        , Entry.optional "Produktionstyp" production.productionType |> Entry.map humanReadableProductionType
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


humanReadableProductionType : ProductionProductionType -> String
humanReadableProductionType productionType =
    case productionType of
        WorldPremiereProduction ->
            "Uraufführung"

        FirstPerformanceProduction ->
            "Erstaufführung"

        RevivalProduction ->
            "Wiederaufnahme"


viewProductionAudience : Production -> Html Msg
viewProductionAudience production =
    let
        formatAge audience =
            ([ audience.suggestedMinAge
             , audience.suggestedMaxAge
             ]
                |> List.filterMap identity
                |> List.map String.fromInt
                |> String.join " - "
            )
                ++ " Jahre"
    in
    div []
        [ div [ class "title is-5" ] [ text "Zielgruppe" ]
        , Entry.view
            [ Entry.optional "Beschreibung" production.audience
                |> Entry.nested .audienceType
            , Entry.optional "Altersempfehlung" production.audience
                |> Entry.withWarnings CustomValidations.minMaxAge
                |> Entry.map formatAge
            ]
        ]


viewProductionAccessibility : Production -> Html Msg
viewProductionAccessibility production =
    div []
        [ div [ class "title is-5" ] [ text "Barrierefreiheit" ]
        , Entry.view
            [ Entry.optional "Zugangsmodus" production.accessModeSufficient
                |> Entry.map viewAccessMode
                |> Entry.withHelp "Eine Liste an Sinnen, die ausreichend sind um sich die Produktion inhaltlich zu erschließen."
            , Entry.optional "Inhaltswarnungen" production.accessibilityHazard
                |> Entry.map viewAccessibilityHazards
                |> Entry.withHelp "Eigenschaften der Produktion, die für bestimtme Personen gefährlich sein könnten (z.B. Lichtblitze/Stroboskoplicht)."
            , Entry.optional "Barrierefreiheitsbeschreibung" production.accessibilitySummary
                |> Entry.withHelp "Eine textuelle Beschreibung möglicher Barrieren bei dieser Produktion."
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
    Entry.view
        [ Entry.required "Name" organization.name
        , Entry.optional "Addresse" organization.address |> Entry.nested .streetAddress
        , Entry.optional "Postleitzahl" organization.address |> Entry.map .postalCode
        , Entry.optional "Stadt" organization.address |> Entry.map .addressLocality
        , Entry.optional "Logo" organization.logo |> asLink (Just "Link")
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
    Entry.view
        [ Entry.required "Name" organization.name
        , Entry.optional "Addresse" organization.address |> Entry.nested .streetAddress
        , Entry.optional "Postleitzahl" organization.address |> Entry.map .postalCode
        , Entry.optional "Stadt" organization.address |> Entry.map .addressLocality
        , Entry.optional "Logo" organization.logo |> asLink (Just "Link")
        ]



-- EVENTS


viewEvents : List Event -> Entry.ZoneWithName -> List (Html Msg)
viewEvents events zone =
    List.map (viewEvent zone events) events
        |> List.intersperse (hr [ class "has-background-grey-light mb-6 mt-6" ] [])


viewEvent : Entry.ZoneWithName -> List Event -> Event -> Html Msg
viewEvent zone allEvents event =
    div [ class "fixed-grid has-2-cols" ]
        [ div [ class "grid" ]
            [ div [ class "cell box mb-0 is-col-span-2 is-col-span-1-widescreen" ]
                [ viewEventTable zone allEvents event
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


viewEventTable : Entry.ZoneWithName -> List Event -> Event -> Html Msg
viewEventTable zone allEvents event =
    Entry.view
        [ Entry.required "ID" event.identifier
        , Entry.required "Startdatum" event
            |> Entry.withWarnings CustomValidations.startAndEndDates
            |> Entry.map .startDate
            |> asDate zone
        , Entry.required "Startzeit" event
            |> Entry.withWarnings CustomValidations.startAndEndDates
            |> Entry.map .startDate
            |> asTime zone
        , Entry.optional "Enddatum" event.endDate |> asDate zone
        , Entry.optional "Endzeit" event.endDate |> asTime zone
        , Entry.optional "Dauer" event.duration
            |> Entry.withWarnings CustomValidations.duration
            |> Entry.map formatDuration
        , Entry.optional "Mit Pause?" event.intermission
            |> Entry.map intermissionCountToString
        , Entry.required "Veranstaltungstyp" event
            |> Entry.withWarnings (CustomValidations.validPremiere allEvents)
            |> Entry.withWarnings (CustomValidations.validDerniere allEvents)
            |> Entry.nested .eventType
            |> Entry.map humanReadableEventTypes
        , Entry.optional "Untertitel in" event.subtitleLanguage
            |> Entry.withWarnings CustomValidations.languageTagValid
        , Entry.required "Status" (eventStatusToString event.eventStatus)
        , Entry.required "Vorheriges Startdatum" event
            |> Entry.withWarnings CustomValidations.eventStatusAndDate
            |> Entry.nested .previousStartDate
            |> asDate zone
        , Entry.required "Vorherige Startzeit" event
            |> Entry.withWarnings CustomValidations.eventStatusAndDate
            |> Entry.nested .previousStartDate
            |> asTime zone
        , Entry.optional "Link" event.url |> asLink Nothing
        ]


humanReadableEventTypes : List EventTypeItem -> String
humanReadableEventTypes eventTypes =
    let
        translation eventType =
            case eventType of
                PremiereEventType ->
                    "Premiere"

                LastShowEventType ->
                    "Derniere"

                GuestPerformanceEventType ->
                    "Gastspiel"
    in
    List.map translation eventTypes
        |> String.join ", "


intermissionCountToString : Int -> String
intermissionCountToString intermissionCount =
    if intermissionCount < 1 then
        "Nein"

    else
        "Ja (" ++ String.fromInt intermissionCount ++ ")"


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
            Entry.view
                [ Entry.optional "Name" place.name
                , Entry.optional "Addresse" place.address.streetAddress
                , Entry.required "Postleitzahl" place.address.postalCode
                , Entry.required "Stadt" place.address.addressLocality
                , Entry.required "Koordinaten" place
                    |> Entry.nested osmUrl
                    |> asLink (Just "Karte anzeigen")
                , Entry.optional "Rollstuhlplätze" place.wheelChairPlaces
                    |> Entry.map .count
                    |> Entry.map String.fromInt
                , Entry.optional "Platz für Assistent:in?" place.wheelChairPlaces
                    |> Entry.nested .hasSpaceForAssistant
                    |> Entry.map boolString
                , Entry.optional "Rollstuhlkapazität" place.wheelChairPlaces
                    |> Entry.nested .wheelchairUserCapacity
                    |> Entry.map String.fromInt
                ]

        LocationItemVi info ->
            Entry.view
                [ Entry.optional "Name" info.name
                , Entry.optional "Link" info.url
                ]


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
                em [] [ text "Die Daten enthalten keine Ticketinformationen für diese Veranstaltung" ]

            Just [] ->
                em [] [ text "Die Daten enthalten keine Ticketinformationen für diese Veranstaltung" ]

            Just list ->
                div [] (List.map viewOffer list)
        ]


viewOffer : Offer -> Html Msg
viewOffer offer =
    let
        formatPrice specification =
            [ Just specification.minPrice
            , specification.maxPrice
            ]
                |> List.filterMap identity
                |> List.map (\price -> String.fromFloat price ++ " " ++ specification.priceCurrency)
                |> String.join " - "
    in
    Entry.view
        [ Entry.optional "Name" offer.name
        , Entry.required "Preis" offer.priceSpecification
            |> Entry.withWarnings CustomValidations.minMaxPrice
            |> Entry.map formatPrice
        , Entry.optional "Link" offer.url
            |> asLink Nothing
        ]



-- HELPERS


hasWarnings : Production -> Bool
hasWarnings production =
    CustomValidations.production "" production
        |> List.filterMap CustomValidations.viewerMessage
        |> List.isEmpty
        |> not


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


toggleWarningsFilter : EventData -> EventData
toggleWarningsFilter remoteData =
    case remoteData of
        Success data ->
            Success { data | showOnlyWarning = not data.showOnlyWarning }

        _ ->
            remoteData


expandAll : EventData -> EventData
expandAll remoteData =
    case remoteData of
        Success data ->
            Success { data | hiddenProductions = Set.empty, hiddenEvents = Set.empty }

        _ ->
            remoteData


collapseAll : EventData -> EventData
collapseAll remoteData =
    case remoteData of
        Success data ->
            let
                allIds =
                    List.range 0 (List.length data.root.productions - 1)
                        |> Set.fromList
            in
            Success { data | hiddenProductions = allIds, hiddenEvents = allIds }

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


boolString : Bool -> String
boolString value =
    if value then
        "Ja"

    else
        "Nein"


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
                    , autocomplete False
                    , spellcheck False
                    , attribute "autocorrect" "off"
                    , attribute "autocapitalize" "off"
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


controlBar : Data -> Html Msg
controlBar data =
    div
        [ class "hero is-small is-dark control-bar" ]
        [ div [ class "hero-body is-flex is-flex-direction-column" ]
            [ nameFilterInput data.nameFilter
            , div [ class "is-flex is-justify-content-space-between" ]
                [ collapseExpandButtons
                , viewProductionCount data
                , warningsFilterButton data
                ]
            ]
        ]


viewProductionCount : Data -> Html Msg
viewProductionCount data =
    let
        count =
            List.length data.root.productions

        visibleCount =
            List.filter (isProductionVisible data) data.root.productions
                |> List.length
    in
    text (String.fromInt visibleCount ++ " von " ++ String.fromInt count ++ " Produktionen werden angezeigt")


nameFilterInput : String -> Html Msg
nameFilterInput filter =
    div [ class "field is-horizontal" ]
        [ div [ class "field-label" ]
            [ label [ class "label has-text-dark-invert" ] [ text "Ergebnisse nach Titel filtern:" ]
            ]
        , div [ class "field-body" ]
            [ div [ class "field" ]
                [ div [ class "control" ]
                    [ input
                        [ type_ "text"
                        , onInput NameFilterChanged
                        , value filter
                        , placeholder "Titel"
                        , class "input is-small"
                        ]
                        []
                    ]
                ]
            ]
        ]


warningsFilterButton : { a | root : Root, showOnlyWarning : Bool } -> Html Msg
warningsFilterButton data =
    let
        count =
            List.filter hasWarnings data.root.productions
                |> List.length

        buttonText =
            if count == 1 then
                "1 Produktion mit potentiellen Problemen anzeigen"

            else
                String.fromInt count ++ " Produktionen mit potentiellen Problemen anzeigen"
    in
    if count == 0 then
        text ""

    else
        div [ class "buttons" ]
            [ button
                [ class "button is-warning is-small"
                , classList [ ( "is-outlined", not data.showOnlyWarning ) ]
                , onClick ToggleWarningsFilter
                ]
                [ text buttonText
                ]
            ]


collapseExpandButtons : Html Msg
collapseExpandButtons =
    div [ class "buttons mb-0" ]
        [ button
            [ class "button is-primary is-small"
            , onClick ExpandAllClicked
            ]
            [ text "Expand all" ]
        , button
            [ class "button is-primary is-small"
            , onClick CollapseAllClicked
            ]
            [ text "Collapse all" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
