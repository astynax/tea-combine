module TeaCombine.Effectful.Pair
    exposing
        ( initBoth
        , updateBoth
        , subscribeBoth
        , (<>)
        , (<&>)
        , (<+>)
        )

{-| FIXME: fill the docs

@docs initBoth, updateBoth, subscribeBoth, (<>), (<&>), (<+>)

-}

import Platform.Cmd exposing ((!))
import Either exposing (Either(..))
import Tuple
import TeaCombine exposing (Both)
import TeaCombine.Effectful exposing (Subscription, Update)


{-| Inits both models (with Cmds)
-}
initBoth :
    ( model1, Cmd msg1 )
    -> ( model2, Cmd msg2 )
    -> ( Both model1 model2, Cmd (Either msg1 msg2) )
initBoth ( m1, c1 ) ( m2, c2 ) =
    ( m1, m2 )
        ! [ Cmd.batch
                [ Cmd.map Left c1
                , Cmd.map Right c2
                ]
          ]


{-| Updates one of two submodels using corresponding subupdate function
-}
updateBoth :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
updateBoth ul ur =
    let
        applyL f m =
            Tuple.mapFirst (f m)
                >> (\( ( x, c ), y ) -> ( x, y ) ! [ Cmd.map Left c ])

        applyR f m =
            Tuple.mapSecond (f m)
                >> (\( x, ( y, c ) ) -> ( x, y ) ! [ Cmd.map Right c ])
    in
        Either.unpack (applyL ul) (applyR ur)


{-| Merges two subscriptions
-}
subscribeBoth :
    Subscription model1 msg1
    -> Subscription model2 msg2
    -> Subscription (Both model1 model2) (Either msg1 msg2)
subscribeBoth s1 s2 ( m1, m2 ) =
    Sub.batch
        [ Sub.map Left <| s1 m1
        , Sub.map Right <| s2 m2
        ]


{-| An infix alias for @updateBoth
-}
(<&>) :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
(<&>) =
    updateBoth


{-| An infix alias for @initBoth
-}
(<>) :
    ( model1, Cmd msg1 )
    -> ( model2, Cmd msg2 )
    -> ( Both model1 model2, Cmd (Either msg1 msg2) )
(<>) =
    initBoth


{-| An infix alias for @subscribeBoth
-}
(<+>) :
    Subscription model1 msg1
    -> Subscription model2 msg2
    -> Subscription (Both model1 model2) (Either msg1 msg2)
(<+>) =
    subscribeBoth
