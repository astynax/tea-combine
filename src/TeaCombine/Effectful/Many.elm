module TeaCombine.Effectful.Many
    exposing
        ( updateEach
        , updateAll
        )

{-| FIXME: fill the docs!

@docs updateEach, updateAll

-}

import Array exposing (Array)
import Platform.Cmd exposing ((!))
import TeaCombine exposing (Ix(..))
import TeaCombine.Effectful exposing (Subscription, Update)


{-| Updates one of submodels in array using corresponding (by index)
update function
-}
updateEach :
    (Int -> Update model msg)
    -> Update (Array model) (Ix msg)
updateEach updateAt (Ix idx msg) models =
    Array.get idx models
        |> Maybe.map
            (Tuple.mapFirst (flip (Array.set idx) models)
                << Tuple.mapSecond (Cmd.map (Ix idx))
                << updateAt idx msg
            )
        |> Maybe.withDefault (models ! [])


{-| Updates one of submodels using a corresponding update function from the list
-}
updateAll :
    List (Update model msg)
    -> Update (Array model) (Ix msg)
updateAll updates =
    let
        uarr =
            Array.fromList updates

        updateAt idx =
            Maybe.withDefault (\_ m -> m ! [])
                (Array.get idx uarr)
    in
        updateEach updateAt
