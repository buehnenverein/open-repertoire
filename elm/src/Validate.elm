port module Validate exposing (main)

import Browser
import Components.InputBox
import Data.Root
import Helper.CustomValidations as CustomValidations
import Helper.Util as Util
import Html exposing (Html, div, h1, input, p, span, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, classList, style, value)
import Html.Lazy exposing (lazy)
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
    { input : String
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


type Msg
    = Submit String
    | TextChange String
    | Response (Result Http.Error Encode.Value)
    | ReceiveValidationResult Encode.Value Encode.Value


init : () -> ( Model, Cmd Msg )
init _ =
    ( { input = "", state = Init }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit input ->
            fetchData model input

        TextChange text ->
            ( { model | input = text }, Cmd.none )

        Response (Ok value) ->
            ( { model | state = Validating (Just value) }, sendData value )

        Response (Err error) ->
            ( { model | state = RequestFailed error }, Cmd.none )

        ReceiveValidationResult responseValue validationResult ->
            ( { model | state = handleValidationResult responseValue validationResult }, Cmd.none )


fetchData : Model -> String -> ( Model, Cmd Msg )
fetchData model inputString =
    if Util.isUrl inputString then
        ( { model | state = Validating Nothing }
        , Http.get
            { url = inputString
            , expect = Http.expectJson Response jsonDecoder
            }
        )

    else
        case Decode.decodeString jsonDecoder inputString of
            Ok jsonValue ->
                ( { model | state = Validating (Just jsonValue) }, sendData jsonValue )

            Err parsingError ->
                ( { model | state = JsonParsingError (Decode.errorToString parsingError) }, Cmd.none )


handleValidationResult : Decode.Value -> Decode.Value -> State
handleValidationResult response result =
    let
        customIssues =
            customValidations response
                |> List.map toValidationIssue

        isWarning issue =
            case issue.kind of
                ValidationWarning ->
                    True

                ValidationError _ ->
                    False

        ( customWarnings, customErrors ) =
            List.partition isWarning customIssues
    in
    case ( Decode.decodeValue resultDecoder result, customErrors ) of
        ( Ok Valid, [] ) ->
            ResultSuccess (groupIssues customWarnings) response

        ( Ok Valid, custom ) ->
            ResultError
                { errors = groupIssues custom
                , warnings = groupIssues customWarnings
                }
                response

        ( Ok (Error errors), custom ) ->
            ResultError
                { errors = groupIssues (errors ++ custom)
                , warnings = groupIssues customWarnings
                }
                response

        ( Err parsingError, _ ) ->
            ValidationParsingError (Decode.errorToString parsingError)


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
    div []
        [ viewIntroduction
        , lazy Components.InputBox.view <|
            Components.InputBox.forValidator
                { value = model.input
                , buttonEnabled = enableButton
                , onChange = TextChange
                , onSubmit = Submit
                }
        , case model.state of
            Init ->
                text ""

            Validating _ ->
                text ""

            RequestFailed error ->
                viewRequestError error

            ResultSuccess warnings jsonValue ->
                section
                    [ viewValid
                    , viewValidationWarnings warnings jsonValue
                    ]

            ResultError { errors, warnings } jsonValue ->
                section
                    [ viewValidationErrors errors jsonValue
                    , viewValidationWarnings warnings jsonValue
                    ]

            JsonParsingError message ->
                section
                    [ div [ class "notification is-danger", style "white-space" "pre-wrap" ]
                        [ text
                            ("Unfortunately, I wasn't able to parse the data you provided. Are you sure that it is valid JSON?"
                                ++ " The error was:\n"
                                ++ message
                            )
                        ]
                    ]

            ValidationParsingError message ->
                section
                    [ div [ class "notification is-danger", style "white-space" "pre-wrap" ]
                        [ text
                            ("Unfortunately, I encountered an error while parsing the validation result, so I could not check whether your JSON is valid or not."
                                ++ " This is most likely a bug in the validator. The error was:\n"
                                ++ message
                            )
                        ]
                    ]
        ]



-- VIEW HELPERS


viewRequestError : Http.Error -> Html Msg
viewRequestError error =
    section
        [ div [ class "notification is-danger" ]
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
        , div []
            [ table [ class "table" ]
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
            , div []
                [ table [ class "table" ]
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
            String.startsWith (String.repeat jsonIndentSpaces " " ++ "\"" ++ property ++ "\":") line

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
                p []
                    [ span
                        [ classList [ ( "has-background-danger has-text-danger-invert", highlightAdditionalProperties line ) ]
                        ]
                        [ text line ]
                    ]
            )


section : List (Html Msg) -> Html Msg
section content =
    div [ class "section" ]
        [ div [ class "container" ] content
        ]


viewIntroduction : Html Msg
viewIntroduction =
    section
        [ h1 [ class "is-size-1" ]
            [ text "ORIF - JSON Schema validator"
            ]
        , p []
            [ text "Use this tool to test whether your API/JSON data conforms to the specification of the Use Case 3 data schema."
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


jsonIndentSpaces : Int
jsonIndentSpaces =
    4


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
                Encode.encode jsonIndentSpaces value

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


customValidations : Decode.Value -> List CustomValidations.ValidationMessage
customValidations jsonValue =
    let
        decodingResult =
            Decode.decodeValue Data.Root.rootDecoder jsonValue
    in
    case decodingResult of
        Ok data ->
            CustomValidations.checkAll data

        Err _ ->
            []


toValidationIssue : CustomValidations.ValidationMessage -> ValidationIssue
toValidationIssue message =
    case message.kind of
        CustomValidations.Warning ->
            ValidationIssue message.path message.message ValidationWarning

        CustomValidations.Error ->
            let
                keyword =
                    String.split "/" message.path
                        |> List.Extra.last
                        |> Maybe.withDefault ""

                errorInfo =
                    { keyword = keyword
                    , additionalProperty = Nothing
                    , allowedEnumValues = Nothing
                    }
            in
            ValidationIssue message.path message.message (ValidationError errorInfo)



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
