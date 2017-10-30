module TeaCombine.Pure
    exposing
        ( Update
        )

{-| FIXME: fill the docs

@docs Update

-}


{-| A type alias for the update function
-}
type alias Update model msg =
    msg -> model -> model
