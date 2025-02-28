module Helper.Util exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Json.Decode as Decode
import Url



-- VIEW HELPERS


section : List (Html msg) -> Html msg
section content =
    div [ class "section" ]
        [ div [ class "container" ] content
        ]



-- HELPERS


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
