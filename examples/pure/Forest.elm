module Forest exposing (Model, Msg, init, update, view)

import Array exposing (Array)
import Debug
import Html exposing (..)
import TeaCombine exposing (Ix, View, previewEvery)
import TeaCombine.Pure exposing (Update)
import TeaCombine.Pure.Many exposing (updateEach)


type alias Model a =
    Array a


type alias Msg a =
    Ix a


view : View a b -> View (Model a) (Msg b)
view viewA =
    ul [] << previewEvery (\a -> li [] [ viewA a ])


update : Update a b -> Update (Model a) (Msg b)
update =
    updateEach << always


init : List a -> Model a
init =
    Array.fromList
