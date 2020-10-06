module Recursive exposing (main)

import Array exposing (Array)
import Browser
import Counter
import Either exposing (Either(..))
import Forest
import Html exposing (..)
import Html.Events exposing (onClick)
import List
import Maybe
import TeaCombine exposing (View, viewBoth)
import TeaCombine.Pure exposing (Update)
import TeaCombine.Pure.Pair exposing (updateWith)
import Utils



{-
   The root component.

   It has a Counter and a Forest of subtrees, and it draws the former
   above the latter.

   It /has/ to be non-alias, because recursive types aliases are not supported.
-}


type Tree
    = Node ( Counter.Model, Forest.Model Tree )



{-
   This is a message to Tree. It targets one of tree's subcomponents.

   It has to be non-alias for the same reason Tree has to be.
-}


type Msg
    = Msg (Either Counter.Msg (Forest.Msg Msg))


view : View Tree Msg
view (Node payload) =
    let
        ( header, contents ) =
            viewBoth Counter.view (Forest.view view) payload
    in
    div [] [ header, contents ]
        |> Html.map Msg


update : Update Tree Msg
update (Msg msg) (Node payload) =
    payload
        |> updateWith (Forest.update update) Counter.update msg
        |> Node


node c f =
    Node ( c, Forest.init f )


init =
    node 0
        [ node 1 []
        , node 2
            [ node 3 []
            ]
        ]


main : Program () Tree Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
