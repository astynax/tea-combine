module Utils exposing (..)

import Html exposing (Html)


wrapView : String -> (model -> Html msg) -> model -> Html msg
wrapView title view model =
    Html.div []
        [ Html.h3 [] [ Html.text title ]
        , view model
        , Html.pre []
            [ Html.text "model = "
            , Html.text <| toString model
            ]
        ]


labeled : String -> (model -> Html msg) -> model -> Html msg
labeled label view model =
    Html.label []
        [ Html.text label
        , view model
        ]
