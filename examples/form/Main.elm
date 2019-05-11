module Main exposing (main)

-- local imports

import Browser
import ByteField
import CheckBoxField
import Html exposing (Html)
import RGBBox exposing (..)
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)
import Utils


main =
    Browser.sandbox
        { init =
            ByteField.init 80
                |> initWith (ByteField.init 160)
                |> initWith (ByteField.init 240)
                |> initWith (CheckBoxField.init True)
        , update =
            ByteField.update
                |> updateWith ByteField.update
                |> updateWith ByteField.update
                |> updateWith CheckBoxField.update
        , view = Utils.wrapView "Form demo" view
        }


view model =
    let
        box =
            bindForm model
    in
    Html.div
        []
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
        << (joinViews (Utils.labeled "R" ByteField.view)
                (Utils.labeled "G" ByteField.view)
                |> withView (Utils.labeled "B" ByteField.view)
                |> withView (Utils.labeled "Rounded" CheckBoxField.view)
           )
