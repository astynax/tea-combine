module TeaCombine
    exposing
        ( View
        , Both
        , Ix(..)
        , viewBoth
        , viewEach
        , viewAll
        , initAll
        , (<|>)
        )

{-| FIXME: fill the docs

@docs View, Both, Ix, viewBoth, viewEach, viewAll, initAll, (<|>)

-}

import Array exposing (Array)
import Either exposing (Either(..))
import Html exposing (Html)


{-| Alias for the view function
-}
type alias View model msg =
    model -> Html msg


{-| Alias for the pair of things (product of two types)
-}
type alias Both a b =
    ( a, b )


{-| Wrapper type that adds an index
-}
type Ix a
    = Ix Int a


{-| Makes a view from the pair of sub-views
-}
viewBoth :
    View model1 msg1
    -> View model2 msg2
    -> Both model1 model2
    -> Both (Html (Either msg1 msg2)) (Html (Either msg1 msg2))
viewBoth va vb ( a, b ) =
    ( Html.map Left <| va a
    , Html.map Right <| vb b
    )


{-| Returns a view that applies each view from the list to the
corresponding submodel from the array.
-}
viewAll :
    List (View model msg)
    -> Array model
    -> List (Html (Ix msg))
viewAll views models =
    Array.toList models
        |> List.map2 (<|) views
        |> List.indexedMap (Html.map << Ix)


{-| Returns a view that applies a function "from index to subview"
to the array of submodels
-}
viewEach :
    (Int -> View model msg)
    -> Array model
    -> List (Html (Ix msg))
viewEach viewAt models =
    Array.toList models
        |> List.indexedMap (\idx model -> Html.map (Ix idx) <| viewAt idx model)


{-| Just an alias for @Array.fromList
-}
initAll : List a -> Array a
initAll =
    Array.fromList


{-| An infix version for the @viewBoth
-}
(<|>) :
    View model1 msg1
    -> View model2 msg2
    -> Both model1 model2
    -> Both (Html (Either msg1 msg2)) (Html (Either msg1 msg2))
(<|>) =
    viewBoth
