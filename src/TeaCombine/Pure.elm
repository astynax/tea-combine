module TeaCombine.Pure
    exposing
        ( Update
        , updateBoth
        , updateAll
        , updateEach
        , (<>)
        , (<&>)
        )

{-| FIXME: fill the docs

@docs Update, updateBoth, updateAll, updateEach, (<>), (<&>)

-}

import Array exposing (Array)
import Either exposing (Either(..))
import Tuple


-- local import

import TeaCombine exposing (..)


{-| A type alias for the update function
-}
type alias Update model msg =
    msg -> model -> model


{-| Updates both of the models using pair of update functions
-}
updateBoth :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
updateBoth ua ub =
    Either.unpack (Tuple.mapFirst << ua) (Tuple.mapSecond << ub)


{-| Updates each sub-model in array using a function
from sub-model index to sub-update
-}
updateEach :
    (Int -> Update model msg)
    -> Update (Array model) (Ix msg)
updateEach updateAt (Ix idx msg) models =
    Array.get idx models
        |> Maybe.map (flip (Array.set idx) models << updateAt idx msg)
        |> Maybe.withDefault models


{-| Updates an array of sub-models using a list of sub-updates
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


{-| Just an infix alias for @updateBoth
-}
(<&>) :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
(<&>) =
    updateBoth


{-| Just an alias for (,) (made for consistency)
-}
(<>) : a -> b -> Both a b
(<>) =
    (,)
