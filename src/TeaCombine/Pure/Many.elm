module TeaCombine.Pure.Many exposing (updateEach, updateAll)

{-| Combinators those help to work with homogenous sets of sub-models
(in a form of @Array).

TODO: add some great docs

@docs updateEach, updateAll

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
