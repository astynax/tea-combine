module Main exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import List
import Maybe
import Either exposing (Either(..))

import TeaCombine as Tea
import TeaCombine.Pure as Tea
import TeaCombine.Pure.Pair as Pair
import TeaCombine.Pure.Many as Many

{-
    The first component is a Counter.

    It stores an integer, draws it and a button and can increment
    on button click.
-}

type alias Counter = Int


type Inc = Inc


viewCount : Tea.View Int Inc
viewCount count = div []
    [ text <| Debug.toString count
    , button [ onClick Inc ] [ text "+" ]
    ]

updateCount : Tea.Update Int Inc
updateCount Inc = (+) 1


{-
    The second component is an array of Trees - a forest.

    It draws an unordered list of Trees.
-}

type alias Forest a = Array a


viewForest : Tea.View a b -> Tea.View (Forest a) (Tea.Ix b)
viewForest viewA =
    ul [] << Tea.viewEvery (\a -> li [] [viewA a])


updateForest : Tea.Update a b -> Tea.Update (Forest a) (Tea.Ix b)
updateForest updateAB = Many.updateOfGivenIndex updateAB


{-
    The "third" component, or in this case a root component is a Tree.

    It has a Counter and a Forest of subtrees, and it draws the former
    above the latter.

    It /has/ to be non-alias, because recursive types are not supported.
-}
type Tree
    = Node (Forest Tree, Int)


{-
    This adapter allows to unwrap the Tree before use and rewrap the new tree
    after.
-}
withTree : ((Forest Tree, Int) -> (Forest Tree, Int)) -> Tree -> Tree
withTree f (Node payload) = Node <| f payload


{-
    This is a message to Tree. It targets one of tree's subcomponents.

    It has to be non-alias for the same reason Tree has to be.
-}
type Msg = Msg (Either (Tea.Ix Msg) Inc)


{-
    Since we only consume messages, we only need the unwrapper.
-}
unMsg : Msg -> Either (Tea.Ix Msg) Inc
unMsg (Msg msg) = msg


{-
    I propose a CPS-style viewBothCPS:

    unNode
    >> Tea.viewBothCPS viewForest viewCount
    <| \contents header -> div [] [ header, contents ]
-}
viewTree : Tea.View Tree Msg
viewTree (Node payload) =
    let (contents, header) = Tea.viewBoth (viewForest viewTree) viewCount payload
    in Html.map Msg
    <| div [] [ header, contents ]


updateTree : Tea.Update Tree Msg
updateTree (Msg msg) =
    withTree
    <| Pair.updateWith updateCount (updateForest updateTree) msg


initTree =
    Node <| Pair.initWith 0 <|
        Tea.initAll
            [ Node <| Pair.initWith 1 <| Tea.initAll []
            , Node <| Pair.initWith 2 <| Tea.initAll
                [ Node <| Pair.initWith 3 <| Tea.initAll []
                ]
            ]


main : Program () Tree Msg
main =
    Browser.sandbox
        { init = initTree
        , view = viewTree
        , update = updateTree
        }
