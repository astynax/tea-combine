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
        << (labeled "R" ByteField.view
                <::> labeled "G" ByteField.view
                <:: labeled "B" ByteField.view
                <:: labeled "Rounded" CheckBoxField.view
           )


labeled label view model =
    Html.label []
        [ Html.text label
        , view model
        ]
