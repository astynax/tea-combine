module TeaCombine.Effectful
    exposing
        ( Update
        , Subscription
        )

{-| FIXME: fill the docs

@docs Update, Subscription

-}


{-| A type alias for the effectful (that returns also a @Cmd) update function
-}
type alias Update model msg =
    msg -> model -> ( model, Cmd msg )


{-| A type alias for the subscription function
-}
type alias Subscription model msg =
    model -> Sub msg
