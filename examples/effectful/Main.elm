module Main exposing (..)

import Html exposing (Html)
import TeaCombine exposing (..)
import TeaCombine.Effectful.Pair exposing (..)
import TicToc
import Utils


main =
    Html.program
        { init = TicToc.init 0.5 <> TicToc.init 0.25
        , view =
            Utils.wrapView "Pair of effectful components"
                (Html.div []
                    << (TicToc.view <::> TicToc.view)
                )
        , update = TicToc.update <&> TicToc.update
        , subscriptions = TicToc.sub <+> TicToc.sub
        }
