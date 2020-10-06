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
import TeaCombine exposing (Both, View, viewBoth)
import TeaCombine.Pure exposing (Update)
import TeaCombine.Pure.Pair exposing (initWith, updateWith)
import Utils



{-
   The root component.

   It has a Counter and a Forest of subtrees, and it draws the former
   above the latter.

   Elm can not infer the infinite types like `Both a (Many (Both a (Many ...)))`.
   You are need to provide an auxiliary type, that will help it to "untie"
   the recursion in types (but will keep recursion in values!).
-}


type Tree
    = Node (Both Counter.Model (Forest.Model Tree))



{-
   This is a message to Tree. It targets one of tree's subcomponents.

   This is an another "unying type" (see above).
-}


type Msg
    = Msg (Either Counter.Msg (Forest.Msg Msg))


view : View Tree Msg
view =
    Utils.wrapView "A tree" <|
        \(Node payload) ->
            let
                ( header, contents ) =
                    viewBoth Counter.view (Forest.view view) payload
            in
            div [] [ header, contents ]
                |> Html.map Msg


update : Update Tree Msg
update (Msg msg) (Node payload) =
    let
        updateTree =
            Counter.update
                |> updateWith (Forest.update update)
    in
    updateTree
        msg
        payload
        |> Node


init : Tree
init =
    let
        node c f =
            Counter.init c |> initWith (Forest.init f) |> Node
    in
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
