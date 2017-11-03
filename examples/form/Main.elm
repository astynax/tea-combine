module Main exposing (main)

import Html exposing (Html)
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)


-- local imports

import ByteField
import CheckBoxField
import RGBBox exposing (..)
import Utils


main =
    Html.beginnerProgram
        { model =
            ByteField.init 80
                <> ByteField.init 160
                <> ByteField.init 240
                <> CheckBoxField.init True
        , update =
            ByteField.update
                <&> ByteField.update
                <&> ByteField.update
                <&> CheckBoxField.update
        , view = Utils.wrapView "Form demo" view
        }


view model =
    let
        box =
            bindForm model
    in
        Html.div []
            [ viewForm model
            , RGBBox.view box
            ]


bindForm =
    bind RGBBox
        (Maybe.withDefault 0 << ByteField.getValue)
        |> thenBind (Maybe.withDefault 0 << ByteField.getValue)
        |> thenBind (Maybe.withDefault 0 << ByteField.getValue)
        |> thenBind CheckBoxField.getValue


viewForm =
    Html.form []
        << (Utils.labeled "R" ByteField.view
                <::> Utils.labeled "G" ByteField.view
                <:: Utils.labeled "B" ByteField.view
                <:: Utils.labeled "Rounded" CheckBoxField.view
           )
