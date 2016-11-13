module CheckBox exposing (..)

import Html exposing (..)
import Html.Attributes exposing (checked, type')
import Html.Events exposing (onClick)
import TeaCombine exposing (View)
import Tuple2


type alias Model =
    ( String, Bool )


type alias Msg =
    ()


mkModel : String -> Model
mkModel =
    flip (,) False


view : View Model Msg
view ( label', state ) =
    label []
        [ input
            [ checked state
            , type' "checkbox"
            , onClick ()
            ]
            []
        , text label'
        ]


update : Msg -> Model -> Model
update =
    always <| Tuple2.mapSnd not
