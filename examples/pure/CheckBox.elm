module CheckBox exposing (..)

import Html exposing (..)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)
import TeaCombine exposing (View)
import Tuple


type alias Model =
    ( String, Bool )


type alias Msg =
    ()


mkModel : String -> Model
mkModel =
    flip (,) False


view : View Model Msg
view ( label_, state ) =
    label []
        [ input
            [ checked state
            , type_ "checkbox"
            , onClick ()
            ]
            []
        , text label_
        ]


update : Msg -> Model -> Model
update =
    always <| Tuple.mapSecond not
