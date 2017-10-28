module Simple exposing (..)

import Html
import TeaCombine exposing (..)
import TeaCombine.Pure exposing (..)
import CheckBox
import Counter


main =
    Html.beginnerProgram
        { model =
            Counter.model
                <> CheckBox.mkModel "foo"
                <> CheckBox.mkModel "bar"
        , view =
            Counter.view
                <|> CheckBox.view
                <|> CheckBox.view
        , update =
            Counter.update
                <&> CheckBox.update
                <&> CheckBox.update
        }
