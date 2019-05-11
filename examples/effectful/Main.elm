module Main exposing (main)

import Browser
import Html exposing (Html)
import TeaCombine exposing (..)
import TeaCombine.Effectful.Pair exposing (..)
import TicToc
import Utils


main =
    Browser.element
        { init = TicToc.init 500 |> initWith (TicToc.init 250)
        , view =
            Utils.wrapView "Pair of effectful components"
                (Html.div []
                    << (joinViews TicToc.view TicToc.view)
                )
        , update = TicToc.update |> updateWith TicToc.update
        , subscriptions = TicToc.sub |> subscribeWith TicToc.sub
        }
