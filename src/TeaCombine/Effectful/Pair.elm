module TeaCombine.Effectful.Pair
    exposing
        ( initWith
        , updateWith
        , subscribeWith
        , (<>)
        , (<&>)
        , (<+>)
        )

{-| Combinators for work with effectful programs (those use @Cms and @Sub).

TODO: add some great docs.

@docs initWith, updateWith, subscribeWith, (<>), (<&>), (<+>)

-}

import Platform.Cmd exposing ((!))
import Either exposing (Either(..))
import Tuple
import TeaCombine exposing (Both)
import TeaCombine.Effectful exposing (Subscription, Update)


{-| Inits both models (with Cmds).
-}
initWith :
    ( model2, Cmd msg2 )
    -> ( model1, Cmd msg1 )
    -> ( Both model1 model2, Cmd (Either msg1 msg2) )
initWith ( m2, c2 ) ( m1, c1 ) =
    ( m1, m2 )
        ! [ Cmd.batch
                [ Cmd.map Left c1
                , Cmd.map Right c2
                ]
          ]


{-| An infix alias for @initWith.
-}
(<>) :
    ( model1, Cmd msg1 )
    -> ( model2, Cmd msg2 )
    -> ( Both model1 model2, Cmd (Either msg1 msg2) )
(<>) =
    flip initWith


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
                >> (\( ( x, c ), y ) -> ( x, y ) ! [ Cmd.map Left c ])

        applyR f m =
            Tuple.mapSecond (f m)
                >> (\( x, ( y, c ) ) -> ( x, y ) ! [ Cmd.map Right c ])
    in
        Either.unpack (applyL u1) (applyR u2)


{-| An infix alias for @updateWith.
-}
(<&>) :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
(<&>) =
    flip updateWith


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


{-| An infix alias for @subscribeWith.
-}
(<+>) :
    Subscription model1 msg1
    -> Subscription model2 msg2
    -> Subscription (Both model1 model2) (Either msg1 msg2)
(<+>) =
    flip subscribeWith
