module TeaCombine.Effectful.Pair exposing (initWith, updateWith, subscribeWith)

{-| Combinators for work with effectful programs (those use @Cms and @Sub).

TODO: add some great docs.

@docs initWith, updateWith, subscribeWith

-}

import Either exposing (Either(..))
import TeaCombine exposing (Both)
import TeaCombine.Effectful exposing (Subscription, Update)
import Tuple


{-| Inits both models (with Cmds).
-}
initWith :
    (flags -> ( model2, Cmd msg2 ))
    -> (flags -> ( model1, Cmd msg1 ))
    -> (flags -> ( Both model1 model2, Cmd (Either msg1 msg2) ))
initWith init2 init1 flags =
    let
        ( m2, c2 ) =
            init2 flags

        ( m1, c1 ) =
            init1 flags
    in
    ( ( m1, m2 )
    , Cmd.batch
        [ Cmd.map Left c1
        , Cmd.map Right c2
        ]
    )


{-| Updates one of two submodels using corresponding subupdate function.
-}
updateWith :
    Update model2 msg2
    -> Update model1 msg1
    -> Update (Both model1 model2) (Either msg1 msg2)
updateWith u2 u1 =
    let
        applyL f m =
            Tuple.mapFirst (f m)
                >> (\( ( x, c ), y ) -> ( ( x, y ), Cmd.map Left c ))

        applyR f m =
            Tuple.mapSecond (f m)
                >> (\( x, ( y, c ) ) -> ( ( x, y ), Cmd.map Right c ))
    in
    Either.unpack (applyL u1) (applyR u2)


{-| Combines two subscriptions.
-}
subscribeWith :
    Subscription model2 msg2
    -> Subscription model1 msg1
    -> Subscription (Both model1 model2) (Either msg1 msg2)
subscribeWith s2 s1 ( m1, m2 ) =
    Sub.batch
        [ Sub.map Left <| s1 m1
        , Sub.map Right <| s2 m2
        ]
