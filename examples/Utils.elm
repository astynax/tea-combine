module Utils exposing (labeled, wrapView)

import Debug
import Html exposing (Html)
import Html.Attributes exposing (style)


wrapView : String -> (model -> Html msg) -> model -> Html msg
wrapView title view model =
    Html.div
        [ style "margin" "5px 5px"
        , style "border" "1px solid lightgray"
        ]
        [ Html.h3
            [ style "margin" "0"
            , style "background-color" "skyblue"
            ]
            [ Html.text title ]
        , Html.div
            [ style "margin" "10px 10px"
            ]
            [ view model ]
        , Html.pre
            [ style "margin" "0"
            , style "padding" "3px 3px"
            , style "background-color" "lightgray"
            ]
            [ Html.text "model = "
            , Html.text <| Debug.toString model
            ]
        ]


labeled : String -> (model -> Html msg) -> model -> Html msg
labeled label view model =
    Html.label []
        [ Html.text label
        , view model
        ]
