port module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h3, input, p, span, table, tbody, td, text, textarea, th, thead, tr)
import Html.Attributes exposing (class, classList, disabled, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import List.Extra


port sendData : Encode.Value -> Cmd msg


port receiveResult : (Encode.Value -> msg) -> Sub msg


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
    , state : State
    }


type State
    = Init
    | Validating (Maybe Encode.Value)
    | RequestFailed Http.Error
    | ResultSuccess (List ValidationIssueGroup) Encode.Value
    | ResultError { errors : List ValidationIssueGroup, warnings : List ValidationIssueGroup } Encode.Value
    | JsonParsingError String
    | ValidationParsingError String


type ValidationResult
    = Valid
    | Error (List ValidationIssue)


type alias ValidationIssue =
    { path : String
    , message : String
    , kind : IssueType
    }


type IssueType
    = ValidationWarning
    | ValidationError ErrorInfo


type alias ErrorInfo =
    { keyword : String
    , additionalProperty : Maybe String
    , allowedEnumValues : Maybe (List String)
    }


type alias ValidationIssueGroup =
    ( ValidationIssue, List ValidationIssue )


type alias Production =
    { title : String
    , description : String
    , events : List Event
    }


type alias Event =
    { duration : Maybe Int }


type alias Inputs =
    { url : String
    , text : String
    }


type Msg
    = SubmitUrl String
    | SubmitJson String
    | UrlChange String
    | TextChange String
    | Response (Result Http.Error Encode.Value)
    | ReceiveValidationResult Encode.Value Encode.Value


init : () -> ( Model, Cmd Msg )
init _ =
    let
        inputs =
            { url = "", text = "" }
    in
    ( { inputs = inputs, state = Init }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        inputs =
            getInputs model
    in
    case msg of
        SubmitUrl url ->
            ( { model | state = Validating Nothing }, Http.get { url = url, expect = Http.expectJson Response jsonDecoder } )

        SubmitJson text ->
            case Decode.decodeString jsonDecoder text of
                Ok jsonValue ->
                    ( { model | state = Validating (Just jsonValue) }, sendData jsonValue )

                Err parsingError ->
                    ( { model | state = JsonParsingError (Decode.errorToString parsingError) }, Cmd.none )

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

        Response (Ok value) ->
            ( { model | state = Validating (Just value) }, sendData value )

        Response (Err error) ->
            ( { model | state = RequestFailed error }, Cmd.none )

        ReceiveValidationResult responseValue validationResult ->
            case Decode.decodeValue resultDecoder validationResult of
                Ok Valid ->
                    ( { model | state = ResultSuccess (groupedWarnings responseValue) responseValue }, Cmd.none )

                Ok (Error errors) ->
                    ( { model
                        | state =
                            ResultError
                                { errors = groupIssues errors
                                , warnings = groupedWarnings responseValue
                                }
                                responseValue
                      }
                    , Cmd.none
                    )

                Err parsingError ->
                    ( { model | state = ValidationParsingError (Decode.errorToString parsingError) }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        enableButton =
            case model.state of
                Validating _ ->
                    False

                _ ->
                    True
    in
    div [ class "container" ]
        [ viewIntroduction
        , viewInputs (getInputs model) enableButton
        , case model.state of
            Init ->
                text ""

            Validating _ ->
                text ""

            RequestFailed error ->
                viewRequestError error

            ResultSuccess warnings jsonValue ->
                div []
                    [ viewValid
                    , viewValidationWarnings warnings jsonValue
                    ]

            ResultError { errors, warnings } jsonValue ->
                div []
                    [ viewValidationErrors errors jsonValue
                    , viewValidationWarnings warnings jsonValue
                    ]

            JsonParsingError message ->
                div [ class "notification is-danger", style "white-space" "pre-wrap" ]
                    [ text
                        ("Unfortunately, I wasn't able to parse the data you provided. Are you sure that it is valid JSON?"
                            ++ " The error was:\n"
                            ++ message
                        )
                    ]

            ValidationParsingError message ->
                div [ class "notification is-danger", style "white-space" "pre-wrap" ]
                    [ text
                        ("Unfortunately, I encountered an error while parsing the validation result, so I could not check whether your JSON is valid or not."
                            ++ " This is most likely a bug in the validator. The error was:\n"
                            ++ message
                        )
                    ]
        ]



-- VIEW HELPERS


viewRequestError : Http.Error -> Html Msg
viewRequestError error =
    div [ class "notification is-danger" ]
        [ case error of
            BadUrl invalidUrl ->
                text ("Unfortunately, it looks like " ++ invalidUrl ++ " is not a valid URL.")

            Timeout ->
                text "Unfortunately, the request to your endpoint timed out."

            NetworkError ->
                text "Unfortunately, I encountered an issue when requesting data from your endpoint. Please check your browser's console logs for more information."

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


viewValid : Html Msg
viewValid =
    div []
        [ div [ class "notification is-success" ]
            [ text "Your JSON data is valid!"
            ]
        ]


viewValidationErrors : List ValidationIssueGroup -> Encode.Value -> Html Msg
viewValidationErrors errors jsonValue =
    div []
        [ div [ class "notification is-danger" ] [ text "I have found some issues in your JSON." ]
        , div [ class "row" ]
            [ table []
                [ thead []
                    [ tr []
                        [ th [] [ text "Error" ]
                        , th [] [ text "Value" ]
                        , th [] [ text "Error count" ]
                        ]
                    ]
                , tbody []
                    (List.map
                        (viewValidationIssue jsonValue)
                        errors
                    )
                ]
            ]
        ]


viewValidationWarnings : List ValidationIssueGroup -> Encode.Value -> Html Msg
viewValidationWarnings warnings jsonValue =
    if List.isEmpty warnings then
        text ""

    else
        div []
            [ div [ class "notification is-warning" ]
                [ text "I have found some potential issues. These are not technically validation errors, but they might indicate issues with your data."
                ]
            , div [ class "row" ]
                [ table []
                    [ thead []
                        [ tr []
                            [ th [] [ text "Warning" ]
                            , th [] [ text "Value" ]
                            , th [] [ text "Warning count" ]
                            ]
                        ]
                    , tbody []
                        (List.map
                            (viewValidationIssue jsonValue)
                            warnings
                        )
                    ]
                ]
            ]


getAdditionalProperty : ValidationIssue -> Maybe String
getAdditionalProperty issue =
    getErrorInfoField .additionalProperty Nothing issue


getAllowedEnumValues : ValidationIssue -> Maybe (List String)
getAllowedEnumValues issue =
    getErrorInfoField .allowedEnumValues Nothing issue


getKeyword : ValidationIssue -> String
getKeyword issue =
    getErrorInfoField .keyword "warning" issue


getErrorInfoField : (ErrorInfo -> a) -> a -> ValidationIssue -> a
getErrorInfoField accessor default issue =
    case issue.kind of
        ValidationError errorData ->
            accessor errorData

        ValidationWarning ->
            default


viewValidationIssue : Encode.Value -> ValidationIssueGroup -> Html Msg
viewValidationIssue jsonValue ( err, others ) =
    let
        additionalProperties =
            List.Extra.unique
                (List.filterMap getAdditionalProperty (err :: others))

        errorPath =
            if String.isEmpty err.path then
                "Top-level object"

            else
                err.path

        message =
            String.join " "
                [ errorPath
                , err.message
                , case ( getAllowedEnumValues err, additionalProperties ) of
                    ( Just list, _ ) ->
                        "[" ++ String.join ", " list ++ "]"

                    ( Nothing, [] ) ->
                        ""

                    ( Nothing, _ ) ->
                        "[" ++ String.join ", " additionalProperties ++ "]"
                ]
    in
    tr []
        [ td [] [ text message ]
        , td [ style "white-space" "pre-wrap" ]
            (viewHighlightedJson ( err, others ) jsonValue)
        , td [] [ text (String.fromInt (List.length others + 1)) ]
        ]


viewHighlightedJson : ValidationIssueGroup -> Encode.Value -> List (Html Msg)
viewHighlightedJson ( err, others ) jsonValue =
    let
        extractAdditionalProperties errors =
            List.filterMap getAdditionalProperty errors

        isProperty line property =
            String.contains ("\"" ++ property ++ "\":") line

        highlightAdditionalProperties line =
            if getKeyword err == "additionalProperties" then
                List.any (isProperty line) (extractAdditionalProperties (err :: others))

            else
                False
    in
    extractPath err.path jsonValue
        |> String.split "\n"
        |> List.map
            (\line ->
                p [ class "json-line" ]
                    [ span
                        [ classList [ ( "is-danger", highlightAdditionalProperties line ) ]
                        ]
                        [ text line ]
                    ]
            )


viewIntroduction : Html Msg
viewIntroduction =
    div []
        [ h1 []
            [ text "Use Case 3 - JSON Schema validator"
            ]
        , p []
            [ text "Use this tool to test whether your API/JSON data conforms to the specification of the Use Case 3 data schema."
            ]
        ]


viewInputs : Inputs -> Bool -> Html Msg
viewInputs inputs buttonEnabled =
    div [ class "inputs grid-container" ]
        [ endpointInput inputs buttonEnabled
        , div [ class "grid-item-centered" ] [ h3 [] [ text "- OR -" ] ]
        , jsonInput inputs buttonEnabled
        ]


endpointInput : Inputs -> Bool -> Html Msg
endpointInput inputs buttonEnabled =
    div [ class "grid-column" ]
        [ h3 [] [ text "Enter the URL of your endpoint" ]
        , input
            [ type_ "text"
            , onInput UrlChange
            , value inputs.url
            , class "u-full-width"
            ]
            []
        , button
            [ onClick (SubmitUrl inputs.url)
            , disabled (not buttonEnabled || String.isEmpty inputs.url)
            , class "button-primary u-pull-right"
            ]
            [ text "Validate endpoint" ]
        ]


jsonInput : Inputs -> Bool -> Html Msg
jsonInput inputs buttonEnabled =
    div [ class "grid-column" ]
        [ h3 [] [ text "Paste your JSON output" ]
        , textarea
            [ onInput TextChange
            , value inputs.text
            , class "u-full-width"
            ]
            []
        , button
            [ onClick (SubmitJson inputs.text)
            , disabled (not buttonEnabled || String.isEmpty inputs.text)
            , class "button-primary u-pull-right"
            ]
            [ text "Validate JSON" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.state of
        Validating (Just responseValue) ->
            receiveResult (ReceiveValidationResult responseValue)

        _ ->
            Sub.none



-- HELPERS


getInputs : Model -> Inputs
getInputs model =
    model.inputs


extractPath : String -> Encode.Value -> String
extractPath path jsonValue =
    let
        -- Since the path starts with a "/", the first element after the split will always be empty and can be dropped.
        components =
            List.drop 1 (String.split "/" path)
    in
    if String.isEmpty path then
        ""

    else
        case Decode.decodeValue (decodePath components) jsonValue of
            Ok value ->
                Encode.encode 4 value

            Err err ->
                Decode.errorToString err


decodePath : List String -> Decoder Decode.Value
decodePath components =
    -- Build a decoder for the given path, starting from the innermost path component and working outwards.
    List.foldr
        (\component decoder ->
            if String.isEmpty component then
                decoder

            else
                case String.toInt component of
                    Just index ->
                        Decode.index index decoder

                    Nothing ->
                        Decode.at [ component ] decoder
        )
        Decode.value
        components



-- VALIDATION ISSUES


groupIssues : List ValidationIssue -> List ValidationIssueGroup
groupIssues validationIssues =
    -- Selects a representative example of each type of error,
    -- to not repeat similar errors that appear e.g. in each element of an array.
    List.Extra.gatherWith similarIssues validationIssues


similarIssues : ValidationIssue -> ValidationIssue -> Bool
similarIssues issue1 issue2 =
    similarPath issue1.path issue2.path
        && (issue1.message == issue2.message)
        && (getKeyword issue1 == getKeyword issue2)


similarPath : String -> String -> Bool
similarPath path1 path2 =
    isEquivalentPath
        (String.split "/" path1)
        (String.split "/" path2)


isEquivalentPath : List String -> List String -> Bool
isEquivalentPath list1 list2 =
    -- Two paths are considered equivalent, if the only differences between them is the array index they
    -- are referencing.
    if List.length list1 /= List.length list2 then
        False

    else
        List.map2 isEquivalentPathComponent list1 list2
            |> List.all identity


isEquivalentPathComponent : String -> String -> Bool
isEquivalentPathComponent a b =
    a == b || (isInteger a && isInteger b)


isInteger : String -> Bool
isInteger string =
    case String.toInt string of
        Just _ ->
            True

        Nothing ->
            False


groupedWarnings : Decode.Value -> List ValidationIssueGroup
groupedWarnings jsonValue =
    groupIssues (parseWarnings jsonValue)


parseWarnings : Decode.Value -> List ValidationIssue
parseWarnings jsonValue =
    let
        productionsResult =
            Decode.decodeValue productionsDecoder jsonValue

        productionWarnings =
            case productionsResult of
                Ok productions ->
                    List.indexedMap
                        (\index production ->
                            parseProductionWarnings index production
                                ++ parseEventsWarnings index production.events
                        )
                        productions
                        |> List.foldr (++) []

                Err _ ->
                    []

        nameResult =
            Decode.decodeValue nameDecoder jsonValue

        nameWarnings =
            case nameResult of
                Ok name ->
                    [ validateRequiredTextField { path = "/name", value = name }
                    ]
                        |> List.filterMap identity

                Err _ ->
                    []
    in
    nameWarnings ++ productionWarnings


parseProductionWarnings : Int -> Production -> List ValidationIssue
parseProductionWarnings index production =
    let
        basePath =
            "/productions/" ++ String.fromInt index ++ "/"
    in
    [ validateRequiredTextField { path = basePath ++ "title", value = production.title }
    ]
        |> List.filterMap identity


validateRequiredTextField : { path : String, value : String } -> Maybe ValidationIssue
validateRequiredTextField { path, value } =
    if String.trim value == "" then
        Just
            { path = path
            , message = "is a required text field, but you provided an empty value"
            , kind = ValidationWarning
            }

    else
        Nothing


parseEventsWarnings : Int -> List Event -> List ValidationIssue
parseEventsWarnings productionIndex events =
    List.indexedMap (validateEventDuration productionIndex) events
        |> List.filterMap identity


validateEventDuration : Int -> Int -> Event -> Maybe ValidationIssue
validateEventDuration productionId eventId event =
    event.duration
        |> Maybe.andThen
            (\minutes ->
                if minutes > 900 then
                    Just
                        { path = "/productions/" ++ String.fromInt productionId ++ "/events/" ++ String.fromInt eventId ++ "/duration"
                        , message = "seems to be very long. The duration field is supposed to contain the event's duration in minutes. Are you sure you didn't accidentally use seconds instead?"
                        , kind = ValidationWarning
                        }

                else if minutes >= 0 && minutes < 10 then
                    -- the duration being negative is already a validation error, so we don't need to cover this case here
                    Just
                        { path = "/productions/" ++ String.fromInt productionId ++ "/events/" ++ String.fromInt eventId ++ "/duration"
                        , message = "seems to be very short. The duration field is supposed to contain the event's duration in minutes. Are you sure you didn't accidentally use hours instead?"
                        , kind = ValidationWarning
                        }

                else
                    Nothing
            )



-- JSON Decoding


jsonDecoder : Decoder Encode.Value
jsonDecoder =
    Decode.value


resultDecoder : Decoder ValidationResult
resultDecoder =
    Decode.field "valid" Decode.bool
        |> Decode.andThen
            (\isValid ->
                if isValid then
                    Decode.succeed Valid

                else
                    Decode.map Error
                        (Decode.field "errors" issueDecoder)
            )


issueDecoder : Decoder (List ValidationIssue)
issueDecoder =
    Decode.list
        (Decode.map3 ValidationIssue
            (Decode.field "instancePath" Decode.string)
            (Decode.field "message" Decode.string)
            issueTypeDecoder
        )


issueTypeDecoder : Decoder IssueType
issueTypeDecoder =
    Decode.map3 ErrorInfo
        (Decode.field "keyword" Decode.string)
        (Decode.maybe (Decode.at [ "params", "additionalProperty" ] Decode.string))
        (Decode.maybe (Decode.at [ "params", "allowedValues" ] (Decode.list Decode.string)))
        |> Decode.andThen
            (\info ->
                Decode.succeed (ValidationError info)
            )


nameDecoder : Decoder String
nameDecoder =
    Decode.field "name" Decode.string


productionsDecoder : Decoder (List Production)
productionsDecoder =
    Decode.field "productions"
        (Decode.list
            (Decode.map3 Production
                (Decode.field "title" Decode.string)
                (Decode.field "description" Decode.string)
                (Decode.field "events" eventsDecoder)
            )
        )


eventsDecoder : Decoder (List Event)
eventsDecoder =
    Decode.list
        (Decode.map Event
            (Decode.maybe (Decode.field "duration" Decode.int))
        )
