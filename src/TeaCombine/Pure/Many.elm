module TeaCombine.Pure.Many
    exposing
        ( updateEach
        , updateAll
        )

{-| FIXME: fill the docs

@docs updateEach, updateAll

-}

import Array exposing (Array)
import TeaCombine exposing (Ix(..))
import TeaCombine.Pure exposing (..)


{-| Updates each sub-model in array using a function
from submodel index to subupdate
-}
updateEach :
    (Int -> Update model msg)
    -> Update (Array model) (Ix msg)
updateEach updateAt (Ix idx msg) models =
    Array.get idx models
        |> Maybe.map (flip (Array.set idx) models << updateAt idx msg)
        |> Maybe.withDefault models


{-| Updates an array of submodels using a list of subupdates
-}
updateAll :
    List (Update model msg)
    -> Update (Array model) (Ix msg)
updateAll updates =
    let
        uarr =
            Array.fromList updates

        updateAt idx =
            Maybe.withDefault (flip always)
                (Array.get idx uarr)
    in
        updateEach updateAt
