module Main exposing (main)

-- local imports

import Browser
import Either exposing (Either(..))
import Html exposing (Html)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)
import TabControl
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)
import Utils


main =
    Browser.sandbox
        { init =
            -- each page can have own type of state:
            "Foo"
                |> initWith (Just "Bar")
                |> initWith 42
                |> initWith False
                -- path to the current page (now it points to the last page):
                |> initWith (Right ())
        , update =
            always identity
                |> updateWith (always identity)
                |> updateWith (always identity)
                |> updateWith (always not)
                -- this update function updates a page selection (path):
                |> updateWith always
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
