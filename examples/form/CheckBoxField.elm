module CheckBoxField exposing (init, view, update, getValue)

import Html exposing (Html)
import Html.Attributes exposing (style, type_, checked)
import Html.Events exposing (onClick)


type alias Model = Bool


type alias Msg = ()


init : Bool -> Model
init = identity


view : Model -> Html Msg
view model =
    Html.input
        [ type_ "checkbox"
        , onClick ()
        , checked model
        ]
        []


update : Msg -> Model -> Model
update = always not

getValue : Model -> Bool
getValue = identity
