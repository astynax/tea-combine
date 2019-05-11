module TeaCombine.Effectful exposing (Update, Subscription)

{-| A common types for the effectful cominators.

TODO: add some great docs.

@docs Update, Subscription

-}


{-| A type alias for the effectful update function.
-}
type alias Update model msg =
    msg -> model -> ( model, Cmd msg )


{-| A type alias for the subscription function.
-}
type alias Subscription model msg =
    model -> Sub msg
