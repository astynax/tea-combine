module TabControl exposing (tabControl)

import Html exposing (Html)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)


tabControl : msg -> List ( String, msg ) -> Html msg
tabControl current =
    let
        item ( text, msg ) =
            Html.div
                [ onClick msg
                , style
                    [ ( "cursor", "pointer" )
                    , ( "display", "inline-block" )
                    , ( "padding", "5px" )
                    , ( "border-right", "2px solid black" )
                    , ( "border-left", "2px solid black" )
                    , ( "border-top", "2px solid black" )
                    , ( "background-color"
                      , if msg == current then
                            "white"
                        else
                            "gray"
                      )
                    ]
                ]
                [ Html.text text ]
    in
        Html.div [] << List.map item
