module TabControl exposing (tabControl)

import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import List.Nonempty as NE exposing (Nonempty)


tabControl : Nonempty ( String, msg ) -> msg -> Html msg
tabControl all current =
    let
        item ( text, msg ) =
            Html.div
                [ onClick msg
                , style "cursor" "pointer"
                , style "display" "inline-block"
                , style "padding" "5px"
                , style "border-right" "2px solid black"
                , style "border-left" "2px solid black"
                , style "border-top" "2px solid black"
                , style "background-color"
                    (if msg == current then
                        "white"

                     else
                        "gray"
                    )
                ]
                [ Html.text text ]
    in
    Html.div [] <| NE.toList <| NE.map item all
