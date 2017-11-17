module Main exposing (main)

import Either exposing (Either(..))
import Html exposing (Html)
import Html.Attributes exposing (type_, checked)
import Html.Events exposing (onClick)
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)


-- local imports

import TabControl
import Utils


main =
    Html.beginnerProgram
        { model =
            -- each page can have own type of state:
            "Foo"
                <> Just "Bar"
                <> 42
                <> False
                -- path to the current page (now it points to the last page):
                <> Right ()
        , update =
            always identity
                <&> always identity
                <&> always identity
                <&> always not
                -- this update function updates a page selection (path):
                <&> always
        , view =
            Utils.wrapView "Pages" view
        }


view ( model, path ) =
    let
        emptyPage =
            Utils.wrapView "Empty page" <|
                always <|
                    Html.text "empty"

        checkBoxPage =
            Utils.wrapView "Page with checkbox"
                (\x ->
                    Html.input
                        [ type_ "checkbox"
                        , checked x
                        , onClick ()
                        ]
                        []
                )

        tabs =
            TabControl.tabControl path
                (oneOfPaths
                    "Page 1"
                    "Page 2"
                    |> orPath "Other page"
                    |> orPath "Last page"
                )

        page =
            (oneOfViews
                emptyPage
                emptyPage
                |> orView emptyPage
                |> orView checkBoxPage
            )
                path
                model
    in
        Html.div []
            [ Html.map Right tabs
            , Html.map Left page
            ]
