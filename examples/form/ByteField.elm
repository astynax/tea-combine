module ByteField exposing (getValue, init, update, view)

import Debug
import Html exposing (Html)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onInput)
import Result
import String


type alias Model =
    { input : String
    , value : Maybe Int
    }


type alias Msg =
    String


init : Int -> Model
init v =
    { input = Debug.toString v, value = Just v }


view : Model -> Html Msg
view model =
    Html.input
        (List.append
            [ type_ "number"
            , onInput identity
            , value model.input
            , style "width" "40px"
            ]
         <|
            Maybe.withDefault [ style "background-color" "red" ] <|
                Maybe.map (always []) <|
                    model.value
        )
        []


update : Msg -> Model -> Model
update newValue _ =
    let
        bound value =
            if value < 0 || value > 255 then
                Nothing

            else
                Just value
    in
    { input = newValue
    , value =
        String.toInt newValue
            |> Maybe.andThen bound
    }


getValue : Model -> Maybe Int
getValue =
    .value
