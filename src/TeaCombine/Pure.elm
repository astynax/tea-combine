module TeaCombine.Pure
    exposing
        ( Update
        , updateBoth
        , updateEach
        , updateAll
        , (<>)
        , (<&>)
        )

import Array exposing (Array)
import Either exposing (Either(..))
import Tuple


-- local import

import TeaCombine exposing (..)


type alias Update model msg =
    msg -> model -> model


updateBoth :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
updateBoth ua ub =
    Either.unpack (Tuple.mapFirst << ua) (Tuple.mapSecond << ub)


updateEach :
    (Int -> Update model msg)
    -> Update (Array model) (Ix msg)
updateEach updateAt (Ix idx msg) models =
    Array.get idx models
        |> Maybe.map (flip (Array.set idx) models << updateAt idx msg)
        |> Maybe.withDefault models


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


(<&>) :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
(<&>) =
    updateBoth


(<>) : a -> b -> Both a b
(<>) =
    (,)
