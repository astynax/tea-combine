module Main exposing (main)

import Browser
import Either exposing (Either(..))
import Html exposing (Html)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)
import List.Nonempty as NE
import TabControl
import TeaCombine exposing (..)
import TeaCombine.Pure.Either exposing (..)
import TeaCombine.Pure.Pair exposing (..)
import Utils


main =
    Browser.sandbox
        { init = setup.init
        , update = update
        , view =
            Utils.wrapView "Pages" view
        }


setup =
    let
        ( select, paths ) =
            oneOfInits
                False
                False
                |> orInit False

        path =
            NE.head paths
    in
    { select = select
    , paths = paths
    , init = ( select path, path )
    }


view =
    let
        viewTabs =
            TabControl.tabControl <|
                NE.zip
                    (NE.cons "Page 1" <|
                        NE.cons "Page 2" <|
                            NE.fromElement "Page 3"
                    )
                    setup.paths

        viewCheckBox =
            Utils.wrapView "Page with checkbox"
                (\x ->
                    Html.input
                        [ type_ "checkbox"
                        , checked x
                        , onClick ()
                        ]
                        []
                )

        viewPage =
            viewCheckBox
                |> eitherView viewCheckBox
                |> eitherView viewCheckBox
    in
    \( models, path ) ->
        Html.div []
            [ Html.map Right <| viewTabs path
            , Html.map Left <| viewPage models
            ]


update =
    let
        updates =
            always not
                |> updateEither (always not)
                |> updateEither (always not)
    in
    \msg ( models, path ) ->
        case msg of
            Right p ->
                ( setup.select p, p )

            Left subMsg ->
                ( updates subMsg models, path )
