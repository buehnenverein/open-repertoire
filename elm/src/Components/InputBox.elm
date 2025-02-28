module Components.InputBox exposing (forDataViewer, forValidator, view)

import Helper.Util exposing (isJson, isUrl, looksLikeJson, looksLikeUrl)
import Html exposing (Html, button, div, h3, i, span, text, textarea)
import Html.Attributes exposing (attribute, autocomplete, class, classList, disabled, spellcheck, value)
import Html.Events exposing (onClick, onInput)


type alias Labels =
    { buttonLabel : String
    , inputLabel : String
    , invalidLinkLabel : String
    , invalidDataLabel : String
    }


type alias Params msg =
    { value : String
    , buttonEnabled : Bool
    , onChange : String -> msg
    , onSubmit : String -> msg
    }


type InputBox msg
    = Settings (Params msg) Labels


forValidator : Params msg -> InputBox msg
forValidator params =
    Settings params englishLabels


forDataViewer : Params msg -> InputBox msg
forDataViewer params =
    Settings params germanLabels


view : InputBox msg -> Html msg
view (Settings params labels) =
    let
        invalidUrl =
            looksLikeUrl params.value && not (isUrl params.value)

        invalidJson =
            looksLikeJson params.value && not (isJson params.value)

        invalid =
            invalidUrl || invalidJson

        controlAttrs =
            if invalidUrl then
                [ attribute "data-tooltip" labels.invalidLinkLabel ]

            else if invalidJson then
                [ attribute "data-tooltip" labels.invalidDataLabel ]

            else
                []
    in
    div [ class "section" ]
        [ div [ class "container" ]
            [ div [ class "field" ]
                [ h3 [ class "label is-size-3" ] [ text labels.inputLabel ]
                , div (class "control has-icons-right has-tooltip-arrow" :: controlAttrs)
                    [ textarea
                        [ onInput params.onChange
                        , value params.value
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
                    [ onClick (params.onSubmit params.value)
                    , disabled (not params.buttonEnabled || invalid || String.isEmpty params.value)
                    , class "button is-primary"
                    ]
                    [ text labels.buttonLabel ]
                ]
            ]
        ]



-- LABELS


germanLabels : Labels
germanLabels =
    { buttonLabel = "Daten anzeigen"
    , inputLabel = "Geben Sie die URL Ihres Endpunkts ein ODER kopieren & fügen Sie Ihre Spielplandaten ein"
    , invalidLinkLabel = "Ungültiger Link"
    , invalidDataLabel = "Ungültiges Datenformat"
    }


englishLabels : Labels
englishLabels =
    { buttonLabel = "Validate"
    , inputLabel = "Enter the URL of your endpoint OR paste your JSON output"
    , invalidLinkLabel = "Invalid link"
    , invalidDataLabel = "Invalid data format"
    }
