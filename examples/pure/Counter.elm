module Counter exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import TeaCombine exposing (View)


type alias Model =
    Int


type alias Msg =
    Int


model : Model
model =
    0


view : View Model Msg
view model =
    let
        btn val lbl =
            button [ onClick val ] [ text lbl ]
    in
        span
            [ style
                [ ( "border", "2px outset" )
                , ( "padding", "2px" )
                ]
            ]
            [ btn (model - 1) "-"
            , text <| toString model
            , btn (model + 1) "+"
            ]


update : Msg -> Model -> Model
update =
    always << max 0
