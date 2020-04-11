module Main exposing (main)

import Browser
import Either exposing (Either(..))
import Html exposing (Html)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)
import List.Nonempty as NE
import TabControl
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)
import Utils


main =
    Browser.sandbox
        { init = setup.init
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


setup =
    let
        paths =
            oneOfPaths
                "Page 1"
                "Page 2"
                |> orPath "Other page"
                |> orPath "Last page"
    in
    { init =
        -- each page can have own type of state:
        "Foo"
            |> initWith (Just "Bar")
            |> initWith 42
            |> initWith False
            -- path to the current page (now it points to the last page):
            |> initWith (Tuple.second <| NE.head paths)
    , paths = paths
    }


view =
    let
        viewEmpty =
            Utils.wrapView "Empty page" <|
                always <|
                    Html.text "empty"

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

        viewTabs =
            TabControl.tabControl setup.paths

        viewPage =
            oneOfViews
                viewEmpty
                viewEmpty
                |> orView viewEmpty
                |> orView viewCheckBox
    in
    \( models, path ) ->
        Html.div []
            [ Html.map Right <| viewTabs path
            , Html.map Left <| viewPage path models
            ]
