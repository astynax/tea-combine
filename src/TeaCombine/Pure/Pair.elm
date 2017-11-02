module TeaCombine.Pure.Pair exposing (..)

import Either exposing (Either(..))
import Tuple
import TeaCombine exposing (Both)
import TeaCombine.Pure exposing (Update)


{-| Inits one model with another
-}
initWith :
    model2
    -> model1
    -> Both model1 model2
initWith =
    flip (,)


{-| An infix alias for @initWith
-}
(<>) :
    model1
    -> model2
    -> Both model1 model2
(<>) =
    (,)


{-| Updates one of two submodels using corresponding subupdate function
-}
updateWith :
    Update model2 msg2
    -> Update model1 msg1
    -> Update (Both model1 model2) (Either msg1 msg2)
updateWith u2 u1 =
    Either.unpack (Tuple.mapFirst << u1) (Tuple.mapSecond << u2)


{-| An infix alias for @updateBoth
-}
(<&>) :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
(<&>) =
    flip updateWith
