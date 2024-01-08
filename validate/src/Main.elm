port module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h2, h3, input, p, span, table, tbody, td, text, textarea, th, thead, tr)
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
    | ResultSuccess
    | ResultError (List ValidationErrorGroup) Encode.Value
    | JsonParsingError String
    | ValidationParsingError String


type ValidationResult
    = Valid
    | Error (List ValidationError)


type alias ValidationError =
    { path : String
    , message : String
    , keyword : String
    , additionalProperty : Maybe String
    , allowedEnumValues : Maybe (List String)
    }


type alias ValidationErrorGroup =
    ( ValidationError, List ValidationError )


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
                    ( { model | state = ResultSuccess }, Cmd.none )

                Ok (Error errors) ->
                    ( { model | state = ResultError (groupErrors errors) responseValue }, Cmd.none )

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

            ResultSuccess ->
                viewValid

            ResultError errors jsonValue ->
                viewValidationErrors errors jsonValue

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


viewValidationErrors : List ValidationErrorGroup -> Encode.Value -> Html Msg
viewValidationErrors errors jsonValue =
    div []
        [ div [ class "notification is-warning" ] [ text "I have found some issues in your JSON." ]
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
                        (viewValidationError jsonValue)
                        errors
                    )
                ]
            ]
        ]


viewValidationError : Encode.Value -> ValidationErrorGroup -> Html Msg
viewValidationError jsonValue ( err, others ) =
    let
        additionalProperties =
            List.Extra.unique
                (List.filterMap .additionalProperty (err :: others))

        errorPath =
            if String.isEmpty err.path then
                "Top-level object"

            else
                err.path

        message =
            String.join " "
                [ errorPath
                , err.message
                , case ( err.allowedEnumValues, additionalProperties ) of
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


viewHighlightedJson : ValidationErrorGroup -> Encode.Value -> List (Html Msg)
viewHighlightedJson ( err, others ) jsonValue =
    let
        extractAdditionalProperties errors =
            List.filterMap .additionalProperty errors

        isProperty line property =
            String.contains ("\"" ++ property ++ "\":") line

        highlightAdditionalProperties line =
            if err.keyword == "additionalProperties" then
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
    div [ class "inputs" ]
        [ div [ class "row" ]
            [ div [ class "five columns" ] [ h3 [] [ text "Enter the URL of your endpoint" ] ]
            , div [ style "text-align" "center", class "two columns" ] [ h3 [] [ text "- OR -" ] ]
            , div [ class "five columns" ] [ h2 [] [ text "Paste your JSON output" ] ]
            ]
        , div [ class "row" ]
            [ div [ class "five columns" ]
                [ input
                    [ type_ "text"
                    , onInput UrlChange
                    , value inputs.url
                    , class "u-full-width"
                    ]
                    []
                ]
            , div [ class "two columns" ] [ div [ class "u-full-width" ] [ text "\u{00A0}" ] ]
            , div [ class "five columns" ]
                [ textarea
                    [ onInput TextChange
                    , value inputs.text
                    , class "u-full-width"
                    ]
                    []
                ]
            ]
        , div [ class "row" ]
            [ div [ class "five columns" ]
                [ button
                    [ onClick (SubmitUrl inputs.url)
                    , disabled (not buttonEnabled || String.isEmpty inputs.url)
                    , class "button-primary u-pull-right"
                    ]
                    [ text "Validate endpoint" ]
                ]
            , div [ class "two columns" ] [ text "\u{00A0}" ]
            , div [ class "five columns" ]
                [ button
                    [ onClick (SubmitJson inputs.text)
                    , disabled (not buttonEnabled || String.isEmpty inputs.text)
                    , class "button-primary u-pull-right"
                    ]
                    [ text "Validate JSON" ]
                ]
            ]
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


groupErrors : List ValidationError -> List ValidationErrorGroup
groupErrors validationErrors =
    -- Selects a representative example of each type of error,
    -- to not repeat similar errors that happen e.g. in each element of an array.
    List.Extra.gatherWith similarError validationErrors


similarError : ValidationError -> ValidationError -> Bool
similarError err1 err2 =
    similarPath err1.path err2.path
        && (err1.message == err2.message)
        && (err1.keyword == err2.keyword)


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
                        (Decode.field "errors" errorDecoder)
            )


errorDecoder : Decoder (List ValidationError)
errorDecoder =
    Decode.list
        (Decode.map5 ValidationError
            (Decode.field "instancePath" Decode.string)
            (Decode.field "message" Decode.string)
            (Decode.field "keyword" Decode.string)
            (Decode.maybe (Decode.at [ "params", "additionalProperty" ] Decode.string))
            (Decode.maybe (Decode.at [ "params", "allowedValues" ] (Decode.list Decode.string)))
        )
