module Forest exposing (Model, Msg, init, update, view)

import Array exposing (Array)
import Debug
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import TeaCombine exposing (Ix, View, previewEvery)
import TeaCombine.Pure exposing (Update)
import TeaCombine.Pure.Many exposing (updateByIndex)


type alias Model a =
    Array a


type alias Msg a =
    Ix a


view : View a b -> View (Model a) (Msg b)
view viewA =
    ul [] << previewEvery (\a -> li [] [ viewA a ])


update : Update a b -> Update (Model a) (Msg b)
update updateAB =
    updateByIndex updateAB


init : List a -> Model a
init =
    Array.fromList
