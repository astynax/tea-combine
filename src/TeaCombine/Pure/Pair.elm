module TeaCombine.Pure.Pair exposing (initWith, updateWith)

{-| Combinators for work with pure programs (those doesn't use @Cmd and @Sub).

TODO: add some great docs

@docs initWith, (<>), updateWith, (<&>)

-}

import Either exposing (Either(..))
import TeaCombine exposing (Both)
import TeaCombine.Pure exposing (Update)
import Tuple


{-| Inits two sub-models as pair.
-}
initWith :
    model2
    -> model1
    -> Both model1 model2
initWith m2 m1 =
    ( m1, m2 )


{-| Updates one of two sub-models using corresponding sub-update function.
-}
updateWith :
    Update model2 msg2
    -> Update model1 msg1
    -> Update (Both model1 model2) (Either msg1 msg2)
updateWith u2 u1 =
    Either.unpack (Tuple.mapFirst << u1) (Tuple.mapSecond << u2)
