module TeaCombine.Pure.Pair exposing (..)

import Either exposing (Either(..))
import Tuple
import TeaCombine exposing (Both)
import TeaCombine.Pure exposing (Update)


{-| Inits both models
-}
initBoth :
    model1
    -> model2
    -> Both model1 model2
initBoth =
    (,)


{-| Updates one of two submodels using corresponding subupdate function
-}
updateBoth :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
updateBoth ua ub =
    Either.unpack (Tuple.mapFirst << ua) (Tuple.mapSecond << ub)


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
    model1
    -> model2
    -> Both model1 model2
(<>) =
    initBoth
