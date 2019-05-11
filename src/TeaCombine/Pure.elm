module TeaCombine.Pure exposing (Update)

{-| A common stuff for the pure combinators.

TODO: add some great docs.

@docs Update

-}


{-| A type alias for the pure update function.
-}
type alias Update model msg =
    msg -> model -> model
