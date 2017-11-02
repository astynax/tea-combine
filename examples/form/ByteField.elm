module ByteField exposing (init, view, update, getValue)

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
    { input = toString v, value = Just v }


view : Model -> Html Msg
view model =
    Html.input
        [ type_ "number"
        , onInput identity
        , value model.input
        , style <|
            List.append [ ( "width", "40px" ) ] <|
                Maybe.withDefault [ ( "background-color", "red" ) ] <|
                    Maybe.map (always []) <|
                        model.value
        ]
        []


update : Msg -> Model -> Model
update v _ =
    let
        bound v =
            if v < 0 || v > 255 then
                Nothing
            else
                Just v
    in
        { input = v
        , value =
            String.toInt v
                |> Result.toMaybe
                |> Maybe.andThen bound
        }


getValue : Model -> Maybe Int
getValue =
    .value
