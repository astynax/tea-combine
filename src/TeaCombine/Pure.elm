module TeaCombine.Pure
    exposing
        ( Update
        , updateBoth
        , updateEach
        , updateAll
        , (<&>)
        , (<>)
        )

import Array exposing (Array)
import Either exposing (Either(..))
import Tuple2


-- local import

import TeaCombine exposing (..)


type alias Update msg model =
    msg -> model -> model


updateBoth :
    Update msg1 model1
    -> Update msg2 model2
    -> Update (Either msg1 msg2) (Both model1 model2)
updateBoth ua ub =
    Either.unpack (Tuple2.mapFst << ua) (Tuple2.mapSnd << ub)


updateEach :
    (Int -> Update msg model)
    -> Update (Ix msg) (Array model)
updateEach updateAt (Ix idx msg) models =
    Array.get idx models
        |> Maybe.map (flip (Array.set idx) models << updateAt idx msg)
        |> Maybe.withDefault models


updateAll :
    List (Update msg model)
    -> Update (Ix msg) (Array model)
updateAll updates =
    let
        uarr =
            Array.fromList updates

        updateIx =
            Maybe.withDefault (flip always) << flip Array.get uarr
    in
        \(Ix idx msg) models ->
            Array.get idx models
                |> Maybe.map (flip (Array.set idx) models << updateIx idx msg)
                |> Maybe.withDefault models


(<&>) :
    Update msg1 model1
    -> Update msg2 model2
    -> Update (Either msg1 msg2) (Both model1 model2)
(<&>) =
    updateBoth


(<>) : a -> b -> Both a b
(<>) =
    (,)
