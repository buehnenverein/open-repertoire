module View exposing (main)

import Browser
import Data.Root exposing (Event, Location(..), Offer, Participant, Production, Root, rootDecoder)
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
    , localTimeZone : Maybe Time.Zone
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


type Msg
    = Submit String
    | TextChange String
    | GotTimeZone Time.Zone
    | Response (RemoteData Http.Error Root)
    | ProductionCardClicked Int Bool
    | EventCardClicked Int Bool
    | NameFilterChanged String


init : () -> ( Model, Cmd Msg )
init _ =
    ( { input = ""
      , localTimeZone = Nothing
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
    Task.perform GotTimeZone Time.here


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit input ->
            fetchData model input

        TextChange text ->
            ( { model | input = text }, Cmd.none )

        GotTimeZone zone ->
            ( { model | localTimeZone = Just zone }, Cmd.none )

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
                div [ class "notification is-danger", style "white-space" "pre-wrap" ]
                    [ span []
                        [ text "Unfortunately, it looks like the data you provided isn't correct. Please use the "
                        , a [ href "../validate" ] [ text "validator tool" ]
                        , text " first to make sure your endpoint is returning data that conforms to our standards."
                        ]
                    ]

            Success data ->
                viewData data (Maybe.withDefault Time.utc model.localTimeZone)
        ]



-- VIEW HELPERS


viewData : Data -> Time.Zone -> Html Msg
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
                    [ h1 [ class "is-size-1" ] [ text production.title ]
                    ]
                , card (text "Info")
                    (productionTable production)
                    (productionOpen index)
                    (ProductionCardClicked index (not (productionOpen index)))
                , card (text "Events")
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
    String.contains (String.toLower filter) (String.toLower production.title)


productionTable : Production -> Html Msg
productionTable production =
    table
        [ class "table is-hoverable" ]
        [ tbody []
            [ tableRow "Title" production.title
            , maybeTableRow "Subtitle" production.subtitle
            , maybeTableRow "Description" production.description
            , maybeTableRow "Teaser" production.teaser
            , maybeTableRow "Additional info" production.additionalInfo
            , maybeTableRow "Genre" (Maybe.map Data.Root.genreToString production.genre)
            , tr []
                [ th [] [ text "Participants" ]
                , td []
                    [ viewParticipants production.participants
                    ]
                ]
            ]
        ]



-- EVENTS


viewEvents : List Event -> Time.Zone -> List (Html Msg)
viewEvents events zone =
    List.map (viewEvent zone) events


viewEvent : Time.Zone -> Event -> Html Msg
viewEvent zone event =
    div [ class "box" ]
        [ div [ class "columns" ]
            [ div [ class "column" ]
                [ table [ class "table" ]
                    [ tbody []
                        [ tableRow "Start date" (formatDate event.startDate zone)
                        , tableRow "Start time" (formatTime event.startDate zone)
                        , tableRow "End date" (formatDate (Maybe.withDefault "" event.endDate) zone)
                        , tableRow "End time" (formatTime (Maybe.withDefault "" event.endDate) zone)
                        , tableRow "Duration" (Maybe.map formatDuration event.duration |> Maybe.withDefault "")
                        , tr []
                            [ th []
                                [ text "Link"
                                ]
                            , td []
                                [ maybeLink event.url
                                ]
                            ]
                        ]
                    ]
                ]
            , div [ class "column" ] [ viewLocations event.locations ]
            ]
        , viewOffers event.offers
        ]



-- LOCATIONS


viewLocations : Maybe (List Location) -> Html Msg
viewLocations locations =
    case locations of
        Nothing ->
            em [] [ text "The data does not contain a location for this event" ]

        Just [] ->
            em [] [ text "The data does not contain a location for this event" ]

        Just list ->
            table [ class "table" ]
                [ thead []
                    [ th [ colspan 5 ] [ text "Locations", locationTag list ]
                    ]
                , tbody []
                    (tr []
                        [ th [] [ text "Name" ]
                        , th [] [ text "Link" ]
                        , th [] [ text "Address" ]
                        , th [] [ text "Postal code" ]
                        , th [] [ text "City" ]
                        ]
                        :: List.map locationRow list
                    )
                ]


locationTag : List Location -> Html Msg
locationTag locations =
    case ( isOnlineEvent locations, isOfflineEvent locations ) of
        ( True, True ) ->
            span
                [ class "tag is-info ml-2 has-tooltip-arrow has-tooltip-multiline"
                , attribute "data-tooltip" "This is a hybrid event that takes place both online and offline"
                ]
                [ text "Hybrid" ]

        ( True, False ) ->
            span
                [ class "tag is-info ml-2 has-tooltip-arrow has-tooltip-multiline"
                , attribute "data-tooltip" "This is an online event"
                ]
                [ text "Online" ]

        _ ->
            text ""


locationRow : Location -> Html Msg
locationRow location =
    case location of
        Physical address ->
            tr []
                [ td [] [ text <| Maybe.withDefault "" address.name ]
                , td [] [ text "" ]
                , td [] [ text <| Maybe.withDefault "" address.streetAddress ]
                , td [] [ text <| Maybe.withDefault "" address.postalCode ]
                , td [] [ text <| Maybe.withDefault "" address.city ]
                ]

        Virtual info ->
            tr []
                [ td [] [ text <| Maybe.withDefault "" info.name ]
                , td [] [ maybeLink info.url ]
                , td [] [ text "" ]
                , td [] [ text "" ]
                , td [] [ text "" ]
                ]



-- PARTICIPANTS


viewParticipants : Maybe (List Participant) -> Html Msg
viewParticipants participants =
    case participants of
        Nothing ->
            text ""

        Just list ->
            ul []
                (List.map viewParticipant list)


viewParticipant : Participant -> Html Msg
viewParticipant participant =
    li []
        [ [ Maybe.map Data.Root.functionToString participant.function
          , participant.roleName
          , Just (String.join " / " participant.names)
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
            table [ class "table" ]
                [ thead []
                    [ tr []
                        [ th [] [ text "Ticketing" ]
                        ]
                    ]
                , tbody
                    []
                    [ tr []
                        [ td [] [ em [] [ text "The data does not contain any ticketing information for this event" ] ]
                        ]
                    ]
                ]

        Just list ->
            table [ class "table" ]
                [ thead []
                    [ tr []
                        [ th [ colspan 3 ] [ text "Ticketing" ]
                        ]
                    ]
                , tbody
                    []
                    (tr []
                        [ th [] [ text "Name" ]
                        , th [] [ text "Price" ]
                        , th [] [ text "Link" ]
                        ]
                        :: List.map viewOffer list
                    )
                ]


viewOffer : Offer -> Html Msg
viewOffer offer =
    let
        formattedPrice =
            [ Just offer.minPrice
            , offer.maxPrice
            ]
                |> List.filterMap identity
                |> List.map (\price -> String.fromFloat price ++ " " ++ offer.priceCurrency)
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


isOnlineEvent : List Location -> Bool
isOnlineEvent locations =
    let
        isVirtualLocation : Location -> Bool
        isVirtualLocation location =
            case location of
                Physical _ ->
                    False

                Virtual _ ->
                    True
    in
    List.any isVirtualLocation locations


isOfflineEvent : List Location -> Bool
isOfflineEvent locations =
    let
        isPhysicalLocation : Location -> Bool
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


formatDate : String -> Time.Zone -> String
formatDate isoString timezone =
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
                "Invalid date (" ++ isoString ++ ")"


formatTime : String -> Time.Zone -> String
formatTime isoString timezone =
    case Iso8601.toTime isoString of
        Ok result ->
            DateFormat.format
                [ DateFormat.hourMilitaryFixed
                , DateFormat.text ":"
                , DateFormat.minuteFixed
                ]
                timezone
                result

        Err _ ->
            if String.trim isoString == "" then
                ""

            else
                "Invalid time (" ++ isoString ++ ")"


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
            []
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
            []
            [ text (Maybe.withDefault "" value)
            ]
        ]


viewRequestError : String -> Http.Error -> Html Msg
viewRequestError url error =
    section
        [ div [ class "notification is-danger" ]
            [ case error of
                BadUrl invalidUrl ->
                    text ("Unfortunately, it looks like " ++ invalidUrl ++ " is not a valid URL.")

                Timeout ->
                    text "Unfortunately, the request to your endpoint timed out."

                NetworkError ->
                    viewNetworkError url

                BadStatus code ->
                    text
                        ("Unfortunately, your endpoint returned an unsuccessful status code ("
                            ++ String.fromInt code
                            ++ "), so I could not check whether your JSON is valid or not. Please check your browser's console logs for more information."
                        )

                BadBody reason ->
                    text
                        ("Unfortunately, I could not parse the response from your endpoint. Are you sure that it is valid JSON? Here is why I couldn't parse the response: "
                            ++ reason
                        )
            ]
        ]


viewNetworkError : String -> Html Msg
viewNetworkError url =
    div []
        [ text "I encountered an error while trying to fetch data from this link."
        , h1 [ class "title is-size-5 mt-5" ] [ text "Here is what you can try:" ]
        , ol []
            [ li []
                [ text "Open the link in your browser: "
                , a [ href url, target "_blank" ] [ text url ]
                ]
            , li []
                [ text "Copy the data that is displayed"
                ]
            , li []
                [ text "Paste the data into the input field above"
                ]
            ]
        ]



-- GENERAL INTERFACE


viewIntroduction : Html Msg
viewIntroduction =
    section
        [ h1 [ class "is-size-1" ]
            [ text "Use Case 3 - Data Viewer"
            ]
        , p []
            [ text "Use this tool to view the data returned by your repertoire endpoint."
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
                [ attribute "data-tooltip" "Not a valid link" ]

            else if invalidJson then
                [ attribute "data-tooltip" "Not valid JSON" ]

            else
                []
    in
    section
        [ div [ class "field" ]
            [ h3 [ class "label is-size-3" ] [ text "Enter the URL of your endpoint OR copy & paste your data" ]
            , div (class "control has-icons-right has-tooltip-arrow" :: controlAttrs)
                [ input
                    [ type_ "text"
                    , onInput TextChange
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
                [ text "View data" ]
            ]
        ]


filterInput : String -> Html Msg
filterInput filter =
    div [ class "field" ]
        [ div [ class "label" ] [ text "Filter results by title:" ]
        , div [ class "control" ]
            [ input
                [ type_ "text"
                , onInput NameFilterChanged
                , value filter
                , placeholder "Title"
                , class "input"
                ]
                []
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
