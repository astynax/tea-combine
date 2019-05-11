module RGBBox exposing (RGBBox, view)

import Debug
import Html exposing (Html)
import Html.Attributes exposing (style)


type alias RGBBox =
    { r : Int
    , g : Int
    , b : Int
    , rounded : Bool
    }


view : RGBBox -> Html msg
view box =
    Html.div
        [ style "width" "50px"
        , style "height" "50px"
        , style "border-radius"
            (if box.rounded then
                "15px"

             else
                "0"
            )
        , style "background-color"
            (String.concat
                [ "rgb("
                , Debug.toString box.r
                , ","
                , Debug.toString box.g
                , ","
                , Debug.toString box.b
                , ")"
                ]
            )
        ]
        []
