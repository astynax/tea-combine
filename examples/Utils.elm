module Utils exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (style)


wrapView : String -> (model -> Html msg) -> model -> Html msg
wrapView title view model =
    Html.div
        [ style
            [ ( "margin", "5px 5px" )
            , ( "border", "1px solid lightgray" )
            ]
        ]
        [ Html.h3
            [ style
                [ ( "margin", "0" )
                , ( "background-color", "skyblue" )
                ]
            ]
            [ Html.text title ]
        , Html.div
            [ style
                [ ( "margin", "10px 10px" )
                ]
            ]
            [ view model ]
        , Html.pre
            [ style
                [ ( "margin", "0" )
                , ( "padding", "3px 3px" )
                , ( "background-color", "lightgray" )
                ]
            ]
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
