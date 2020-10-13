module Recursive exposing (main)

import Array exposing (Array)
import Browser
import Either exposing (Either(..))
import Forest
import Html
import List
import Maybe
import TeaCombine exposing (Both, View, mapBoth, viewBoth)
import TeaCombine.Effectful exposing (Update)
import TeaCombine.Effectful.Pair exposing (initWith, updateWith, subscribeWith)
import TicToc
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
    = Node (Both TicToc.Model (Forest.Model Tree))



{-
   This is a message to Tree. It targets one of tree's subcomponents.

   This is an another "unying type" (see above).
-}


type Msg
    = Msg (Either TicToc.Msg (Forest.Msg Msg))


init : flags -> ( Tree, Cmd Msg )
init flags =
    let
        initNode c f =
            let
                ( x, cmd ) =
                    (TicToc.init c |> initWith (Forest.init f)) flags
            in
            ( Node x, cmd )

        ( tree, ct ) =
            initNode 2000 [ n1, n2 ]

        ( n1, c1 ) =
            initNode 1000 []

        ( n2, c2 ) =
            initNode 1000 [ n3 ]

        ( n3, c3 ) =
            initNode 500 []

        cmds =
            Cmd.map Msg (Cmd.batch [ ct, c1, c2, c3 ])
    in
    ( tree, cmds )


view : View Tree Msg
view =
    Utils.wrapView "A tree" <|
        \(Node payload) ->
            let
                ( header, contents ) =
                    viewBoth TicToc.view (Forest.view view) payload
            in
            Html.div [] [ header, contents ]
                |> Html.map Msg


update : Update Tree Msg
update (Msg msg) (Node payload) =
    let
        updateTree =
            TicToc.update
                |> updateWith (Forest.update update)
    in
    updateTree
        msg
        payload
        |> mapBoth Node (Cmd.map Msg)


sub : Tree -> Sub Msg
sub (Node t) =
    let
        subTree =
            TicToc.sub
                |> subscribeWith (Forest.sub sub)
    in
    subTree t |> Sub.map Msg


main : Program () Tree Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = sub
        }
