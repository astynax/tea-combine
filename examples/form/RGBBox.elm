module RGBBox exposing (RGBBox, view)

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
        [ style
            [ ( "width", "50px" )
            , ( "height", "50px" )
            , ( "border-radius"
              , if box.rounded then
                    "15px"
                else
                    "0"
              )
            , ( "background-color"
              , String.concat
                    [ "rgb("
                    , toString box.r
                    , ","
                    , toString box.g
                    , ","
                    , toString box.b
                    , ")"
                    ]
              )
            ]
        ]
        []
