module TeaCombine
    exposing
        ( View
        , Both
        , Ix(..)
        , initAll
        , viewBoth
        , (<|>)
        , viewAll
        , viewEach
        , viewSome
        , joinViews
        , (<::>)
        , withView
        , (<::)
        , bind
        , thenBind
        )

{-| FIXME: fill the docs

@docs View, Both, Ix
@docs initAll
@docs viewBoth, (<|>), viewAll, viewEach, viewSome
@docs joinViews, (<::>), withView, (<::)
@docs bind, thenBind

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


{-| Just an alias for @Array.fromList
-}
initAll : List a -> Array a
initAll =
    Array.fromList


{-| Combine two sub-views into a pair (@Both)
-}
viewBoth :
    View model1 msg1
    -> View model2 msg2
    -> Both model1 model2
    -> Both (Html (Either msg1 msg2)) (Html (Either msg1 msg2))
viewBoth v1 v2 ( m1, m2 ) =
    ( Html.map Left <| v1 m1
    , Html.map Right <| v2 m2
    )


{-| An infix version for the @viewBoth
-}
(<|>) :
    View model1 msg1
    -> View model2 msg2
    -> Both model1 model2
    -> Both (Html (Either msg1 msg2)) (Html (Either msg1 msg2))
(<|>) =
    viewBoth


{-| Returns a list of @Html produced by applying a number
of sub-views to sub-models
-}
viewAll :
    List (View model msg)
    -> Array model
    -> List (Html (Ix msg))
viewAll views models =
    Array.toList models
        |> List.map2 (<|) views
        |> List.indexedMap (Html.map << Ix)


{-| Returns a list of @Html produced by applying an index-dependent view
to the sub-models
-}
viewEach :
    (Int -> View model msg)
    -> Array model
    -> List (Html (Ix msg))
viewEach viewAt models =
    Array.toList models
        |> List.indexedMap
            (\idx model ->
                viewAt idx model
                    |> Html.map (Ix idx)
            )


{-| Works as @viewEach but returns only some of sub-views
-}
viewSome :
    (Int -> Maybe (View model msg))
    -> Array model
    -> List (Html (Ix msg))
viewSome viewAt models =
    Array.toList models
        |> List.indexedMap
            (\idx model ->
                viewAt idx
                    |> Maybe.map (Html.map (Ix idx) << ((|>) model))
            )
        |> List.filterMap identity


{-| Works as @viewBoth but returns a function that produces a list of sub-views.
This is a first step of "joinViews+[withView]" chain.
 -}
joinViews :
    View model1 msg1
    -> View model2 msg2
    -> Both model1 model2
    -> List (Html (Either msg1 msg2))
joinViews v1 v2 m =
    let
        ( h1, h2 ) =
            (v1 <|> v2) m
    in
        [ h1, h2 ]

{-| An infix alias for @joinViews
 -}
(<::>) :
      View model1 msg1
    -> View model2 msg2
    -> Both model1 model2
    -> List (Html (Either msg1 msg2))
(<::>) =
    joinViews


{-| Continues a "joinViews+[withView]" chain by adding an another sub-view
 -}
withView :
    View model2 msg2
    -> (model1 -> List (Html msg1))
    -> Both model1 model2
    -> List (Html (Either msg1 msg2))
withView v2 hs ( m1, m2 ) =
    List.append
        (List.map (Html.map Left) <| hs m1)
        [ Html.map Right <| v2 m2 ]

{-| An infix alias for @withView
 -}
(<::) :
    (model1 -> List (Html msg1))
    -> View model2 msg2
    -> Both model1 model2
    -> List (Html (Either msg1 msg2))
(<::) =
    flip withView

{-| Makes a function that applies a getter to the model and
then modifies result.
This is a first step in a "bind+[thenBind]"-chain.
 -}
bind :
    (a -> b)
    -> (model -> a)
    -> model
    -> b
bind use get =
    use << get

{-| Adds an another step to the "bind+[thenBind]"-chain.
 -}
thenBind :
    (model2 -> a)
    -> (model1 -> (a -> b))
    -> Both model1 model2
    -> b
thenBind get use ( m1, m2 ) =
    use m1 (get m2)
