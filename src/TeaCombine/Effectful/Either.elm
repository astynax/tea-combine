module TeaCombine.Effectful.Either exposing (oneOfInits, orInit, updateEither, subscribeEither)

{-| Combinators for work with effectful programs (those use @Cms and @Sub).

TODO: add some great docs.

@docs oneOfInits, orInit, updateEither, subscribeEither

-}

import Either exposing (Either(..))
import List.Nonempty as NE exposing (Nonempty)
import TeaCombine exposing (Both)
import TeaCombine.Effectful exposing (Subscription, Update)


{-| Combines two inits models to selector and list of paths.

This is a first step in the _"oneOfInits+[orInit]"-chain_.

-}
oneOfInits :
    (flags -> ( model2, Cmd msg2 ))
    -> (flags -> ( model1, Cmd msg1 ))
    -> ( Either () () -> flags -> ( Either model1 model2, Cmd (Either msg1 msg2) ), Nonempty (Either () ()) )
oneOfInits init2 init1 =
    ( \path ->
        case path of
            Left () ->
                \flags -> Tuple.mapBoth Left (Cmd.map Left) <| init1 flags

            Right () ->
                \flags -> Tuple.mapBoth Right (Cmd.map Right) <| init2 flags
    , NE.cons (Left ()) <| NE.fromElement (Right ())
    )


{-| Adds an another init to the _"oneOfInits+[orInit]"-chain_.
-}
orInit :
    (flags -> ( model2, Cmd msg2 ))
    -> ( path -> flags -> ( model1, Cmd msg1 ), Nonempty path )
    -> ( Either path () -> flags -> ( Either model1 model2, Cmd (Either msg1 msg2) ), Nonempty (Either path ()) )
orInit init2 ( next, ps ) =
    ( \path ->
        case path of
            Left p ->
                \flags ->
                    Tuple.mapBoth Left (Cmd.map Left) <| next p flags

            Right () ->
                \flags ->
                    Tuple.mapBoth Right (Cmd.map Right) <| init2 flags
    , NE.append
        (NE.map Left ps)
      <|
        NE.fromElement (Right ())
    )


{-| Updates one of two submodels using corresponding subupdate function.
-}
updateEither :
    Update model2 msg2
    -> Update model1 msg1
    -> Update (Either model1 model2) (Either msg1 msg2)
updateEither u2 u1 msg model =
    case ( msg, model ) of
        ( Left msg1, Left model1 ) ->
            Tuple.mapBoth Left (Cmd.map Left) <| u1 msg1 model1

        ( Right msg2, Right model2 ) ->
            Tuple.mapBoth Right (Cmd.map Right) <| u2 msg2 model2

        _ ->
            ( model, Cmd.none )


{-| Combines two subscriptions.
-}
subscribeEither :
    Subscription model2 msg2
    -> Subscription model1 msg1
    -> Subscription (Either model1 model2) (Either msg1 msg2)
subscribeEither s2 s1 model =
    case model of
        Left model1 ->
            Sub.map Left <| s1 model1

        Right model2 ->
            Sub.map Right <| s2 model2
