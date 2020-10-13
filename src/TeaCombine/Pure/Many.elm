module TeaCombine.Pure.Many exposing (updateEach, updateAll, updateByIndex)

{-| Combinators those help to work with homogenous sets of sub-models
(in a form of @Array).

TODO: add some great docs

@docs updateEach, updateAll, updateByIndex

-}

import Array exposing (Array)
import TeaCombine exposing (Ix(..))
import TeaCombine.Pure exposing (..)


{-| Updates each sub-model in @Array using a function
from sub-model index to sub-update.
-}
updateEach :
    (Int -> Update model msg)
    -> Update (Array model) (Ix msg)
updateEach updateAt (Ix idx msg) models =
    Array.get idx models
        |> Maybe.map ((\x -> Array.set idx x models) << updateAt idx msg)
        |> Maybe.withDefault models


{-| Updates an @Array of sub-models using a @List of sub-updates.
-}
updateAll :
    List (Update model msg)
    -> Update (Array model) (Ix msg)
updateAll updates =
    let
        uarr =
            Array.fromList updates

        updateAt idx =
            Maybe.withDefault (\_ y -> y)
                (Array.get idx uarr)
    in
    updateEach updateAt


{-| Updates a sub-model with given index in @Array using a sub-update.
-}
updateByIndex :
    Update model msg
    -> Update (Array model) (Ix msg)
updateByIndex update (Ix idx msg) model =
    case Array.get idx model of
        Just elem ->
            Array.set idx (update msg elem) model

        Nothing ->
            model
