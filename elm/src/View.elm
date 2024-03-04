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
import Task
import Time


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { inputs : Inputs
    , localTimeZone : Maybe Time.Zone
    , data : RemoteData Error Root
    }


type Error
    = HttpError Http.Error
    | JsonError Decode.Error


type alias Inputs =
    { url : String
    , text : String
    }


type Msg
    = SubmitUrl String
    | SubmitJson String
    | UrlChange String
    | TextChange String
    | GotTimeZone Time.Zone
    | Response (RemoteData Http.Error Root)


init : () -> ( Model, Cmd Msg )
init _ =
    let
        inputs =
            { url = "", text = "" }
    in
    ( { inputs = inputs, localTimeZone = Nothing, data = NotAsked }, getTimeZone )


getTimeZone : Cmd Msg
getTimeZone =
    Task.perform GotTimeZone Time.here


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        inputs =
            model.inputs
    in
    case msg of
        SubmitUrl url ->
            ( { model | data = Loading }, Http.get { url = url, expect = Http.expectJson (RemoteData.fromResult >> Response) rootDecoder } )

        SubmitJson text ->
            case Decode.decodeString rootDecoder text of
                Ok jsonValue ->
                    ( { model | data = Success jsonValue }, Cmd.none )

                Err parsingError ->
                    ( { model | data = Failure (JsonError parsingError) }, Cmd.none )

        UrlChange url ->
            let
                newInputs =
                    { inputs | url = url }
            in
            ( { model | inputs = newInputs }, Cmd.none )

        TextChange text ->
            let
                newInputs =
                    { inputs | text = text }
            in
            ( { model | inputs = newInputs }, Cmd.none )

        GotTimeZone zone ->
            ( { model | localTimeZone = Just zone }, Cmd.none )

        Response response ->
            ( { model | data = RemoteData.mapError HttpError response }, Cmd.none )


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
        , viewInputs model.inputs enableButton
        , case model.data of
            NotAsked ->
                text ""

            Loading ->
                text ""

            Failure (HttpError error) ->
                viewRequestError model.inputs.url error

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


viewData : Root -> Time.Zone -> Html Msg
viewData data zone =
    div []
        (List.map (viewProduction zone) data.productions)



-- PRODUCTIONS


viewProduction : Time.Zone -> Production -> Html Msg
viewProduction zone production =
    div []
        [ div []
            [ h1 [ class "is-size-1" ] [ text production.title ]
            ]
        , card (text "Info") (productionTable production)
        , card (text "Events") (div [] <| viewEvents production.events zone)
        ]


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
            em [] [ text "No location" ]

        Just [] ->
            em [] [ text "No location" ]

        Just list ->
            table [ class "table" ]
                [ thead []
                    [ th [ colspan 5 ] [ text "Locations" ]
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
                        [ td [] [ em [] [ text "No information" ] ]
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


card : Html Msg -> Html Msg -> Html Msg
card title content =
    div [ class "card" ]
        [ div [ class "card-header has-background-primary is-clickable" ]
            [ div [ class "card-header-title has-text-white" ]
                [ title
                ]
            , button [ class "card-header-icon" ]
                [ span [ class "icon" ]
                    [ i [ class "fas fa-angle-down has-text-white" ] []
                    ]
                ]
            ]
        , div [ class "card-content" ]
            [ content
            ]
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
    div [ class "notification is-danger" ]
        [ case error of
            BadUrl invalidUrl ->
                text ("Unfortunately, it looks like " ++ invalidUrl ++ " is not a valid URL.")

            Timeout ->
                text "Unfortunately, the request to your endpoint timed out."

            NetworkError ->
                span []
                    [ text "Unfortunately, I encountered an issue when requesting the data from your endpoint. Alternatively, you can try to "
                    , a [ href url, target "_blank" ] [ text "open the link in your browser" ]
                    , text " and copy the data into the JSON output field directly"
                    ]

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



-- GENERAL INTERFACE


viewIntroduction : Html Msg
viewIntroduction =
    div []
        [ h1 [ class "is-size-1" ]
            [ text "Use Case 3 - Data Viewer"
            ]
        , p []
            [ text "Use this tool to view the data returned by your repertoire endpoint."
            ]
        ]


viewInputs : Inputs -> Bool -> Html Msg
viewInputs inputs buttonEnabled =
    div [ class "inputs grid-container" ]
        [ endpointInput inputs buttonEnabled
        , div [ class "grid-item-centered" ] [ h3 [ class "is-size-3 has-text-weight-bold" ] [ text "- OR -" ] ]
        , jsonInput inputs buttonEnabled
        ]


endpointInput : Inputs -> Bool -> Html Msg
endpointInput inputs buttonEnabled =
    div [ class "grid-column field" ]
        [ div [ class "field" ]
            [ h3 [ class "label is-size-3" ] [ text "Enter the URL of your endpoint" ]
            , div [ class "control" ]
                [ input
                    [ type_ "text"
                    , onInput UrlChange
                    , value inputs.url
                    , class "input"
                    ]
                    []
                ]
            ]
        , div [ class "control" ]
            [ button
                [ onClick (SubmitUrl inputs.url)
                , disabled (not buttonEnabled || String.isEmpty inputs.url)
                , class "button is-primary"
                ]
                [ text "View data" ]
            ]
        ]


jsonInput : Inputs -> Bool -> Html Msg
jsonInput inputs buttonEnabled =
    div [ class "grid-column field" ]
        [ div [ class "field" ]
            [ h3 [ class "label is-size-3" ] [ text "Paste your JSON output" ]
            , div [ class "control" ]
                [ textarea
                    [ onInput TextChange
                    , value inputs.text
                    , class "input"
                    ]
                    []
                ]
            ]
        , div [ class "control" ]
            [ button
                [ onClick (SubmitJson inputs.text)
                , disabled (not buttonEnabled || String.isEmpty inputs.text)
                , class "button is-primary"
                ]
                [ text "View data" ]
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
