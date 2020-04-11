module TeaCombine.Pure.Either exposing (oneOfInits, orInit, updateEither)

{-| Combinators for work with pure programs (those doesn't use @Cmd and @Sub).

TODO: add some great docs

@docs oneOfInits, orInit, updateEither

-}

import Either exposing (Either(..))
import List.Nonempty as NE exposing (Nonempty)
import TeaCombine exposing (Both)
import TeaCombine.Pure exposing (Update)


{-| Combines two initial models to selector and list of paths.

This is a first step in the _"oneOfInits+[orInit]"-chain_.

-}
oneOfInits :
    m1
    -> m2
    -> ( Either () () -> Either m1 m2, Nonempty (Either () ()) )
oneOfInits m1 m2 =
    ( \path ->
        case path of
            Left () ->
                Left m1

            Right () ->
                Right m2
    , NE.cons (Left ()) <| NE.fromElement (Right ())
    )


{-| Adds an another init to the _"oneOfInits+[orInit]"-chain_.
-}
orInit :
    m2
    -> ( path -> m1, Nonempty path )
    -> ( Either path () -> Either m1 m2, Nonempty (Either path ()) )
orInit m2 ( next, ps ) =
    ( \path ->
        case path of
            Left p ->
                Left <| next p

            Right () ->
                Right m2
    , NE.append
        (NE.map Left ps)
      <|
        NE.fromElement (Right ())
    )


{-| Updates one of two sub-models using corresponding sub-update function.
-}
updateEither :
    Update model2 msg2
    -> Update model1 msg1
    -> Update (Either model1 model2) (Either msg1 msg2)
updateEither u2 u1 msg model =
    case ( msg, model ) of
        ( Left msg1, Left model1 ) ->
            Left <| u1 msg1 model1

        ( Right msg2, Right model2 ) ->
            Right <| u2 msg2 model2

        _ ->
            model
