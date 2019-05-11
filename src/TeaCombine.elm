module TeaCombine exposing
    ( View, Both, Ix(..)
    , initAll
    , viewBoth, viewAll, viewEach, viewSome
    , joinViews, withView
    , bind, thenBind
    , oneOfViews, orView, oneOfPaths, orPath
    )

{-| The common types and combinators.

TODO: add some great docs.

@docs View, Both, Ix
@docs initAll
@docs viewBoth, viewAll, viewEach, viewSome
@docs joinViews, withView
@docs bind, thenBind
@docs oneOfViews, orView, oneOfPaths, orPath

-}

import Array exposing (Array)
import Either exposing (Either(..))
import Html exposing (Html)


{-| An alias for the view function.
-}
type alias View model msg =
    model -> Html msg


{-| An alias for the pair of things (product of two types).
-}
type alias Both a b =
    ( a, b )


{-| Wrapper type that adds an index.
-}
type Ix a
    = Ix Int a


{-| Just an alias for [Array.fromList](Array#fromList) (made for convinience).
-}
initAll : List a -> Array a
initAll =
    Array.fromList


{-| Combines two sub-views into a pair ([Both](#Both)).
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


{-| Returns a list of [Html](Html#Html) produced by applying a `List`
of sub-views to the `List` of sub-models (like [List.zip](List#zip) does).
-}
viewAll :
    List (View model msg)
    -> Array model
    -> List (Html (Ix msg))
viewAll views models =
    Array.toList models
        |> List.map2 (<|) views
        |> List.indexedMap (Html.map << Ix)


{-| Returns a list of [Html](Html#Html) produced by applying
an index-aware view to the each of sub-models.
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


{-| Works as [viewEach](#viewEach) but returns only some of sub-views.
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
                    |> Maybe.map (Html.map (Ix idx) << (|>) model)
            )
        |> List.filterMap identity


{-| Works as [viewBoth](#viewBoth) but returns a function that produces a
`List` of sub-views.

This is a first step of _"joinViews+[withView]" chain_.

-}
joinViews :
    View model1 msg1
    -> View model2 msg2
    -> Both model1 model2
    -> List (Html (Either msg1 msg2))
joinViews v1 v2 m =
    let
        ( h1, h2 ) =
            viewBoth v1 v2 m
    in
    [ h1, h2 ]


{-| Adds an another step to the _"joinViews+[withView]" chain_.
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


{-| Makes a function that applies a getter to the model and
then modifies result.

This is a first step in the _"bind+[thenBind]"-chain_.

-}
bind :
    (a -> b)
    -> (model -> a)
    -> model
    -> b
bind use get =
    use << get


{-| Adds an another step to the _"bind+[thenBind]"-chain_.
-}
thenBind :
    (model2 -> a)
    -> (model1 -> (a -> b))
    -> Both model1 model2
    -> b
thenBind get use ( m1, m2 ) =
    use m1 (get m2)


{-| Combines two views and lets to select (using path)
which one should be applied to the combined model.

This is a first step in a _"oneOfViews+[orView]"-chain_.

-}
oneOfViews :
    View model1 msg1
    -> View model2 msg2
    -> Either () ()
    -> View (Both model1 model2) (Either msg1 msg2)
oneOfViews v1 v2 path ( m1, m2 ) =
    case path of
        Left () ->
            Html.map Left <| v1 m1

        Right () ->
            Html.map Right <| v2 m2


{-| Adds an another view to the _"oneOfViews+[orView]"-chain_.
-}
orView :
    View model2 msg2
    -> (path -> model1 -> Html msg1)
    -> Either path ()
    -> View (Both model1 model2) (Either msg1 msg2)
orView v2 next path ( m1, m2 ) =
    case path of
        Left p ->
            Html.map Left <| next p m1

        Right () ->
            Html.map Right <| v2 m2


{-| Combines two path labels.

This is a first step in the _"oneOfViews+[orView]"-chain_.

-}
oneOfPaths : a -> a -> List ( a, Either () () )
oneOfPaths v1 v2 =
    [ ( v1, Left () )
    , ( v2, Right () )
    ]


{-| Adds an another path label to the _"oneOfPaths+[orPath]"-chain_.
-}
orPath : a -> List ( a, b ) -> List ( a, Either b () )
orPath v ps =
    List.append
        (List.map (Tuple.mapSecond Left) ps)
        [ ( v, Right () ) ]
