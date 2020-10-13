module Forest exposing (Model, Msg, init, view, update, sub)

import Array exposing (Array)
import Debug
import Html exposing (..)
import TeaCombine exposing (Ix, View, previewEvery)
import TeaCombine.Effectful exposing (Update, Subscription)
import TeaCombine.Effectful.Many exposing (updateEach, subscribeEach)


type alias Model a =
    Array a


type alias Msg a =
    Ix a


init : List a -> flags -> (Model a, Cmd msg)
init l _ =
    ( Array.fromList l, Cmd.none )


view : View a b -> View (Model a) (Msg b)
view viewA =
    ul [] << previewEvery (\a -> li [] [ viewA a ])


update : Update a b -> Update (Model a) (Msg b)
update = updateEach << always


sub : Subscription a b -> Subscription (Model a) (Msg b)
sub = subscribeEach << always
