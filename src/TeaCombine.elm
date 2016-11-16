module TeaCombine
    exposing
        ( View
        , Both
        , Ix(..)
        , viewBoth
        , viewEach
        , viewAll
        , all
        , (<|>)
        )

import Array exposing (Array)
import Either exposing (Either(..))
import Html exposing (Html)
import Tuple


type alias View model msg =
    model -> Html msg


type alias Both a b =
    ( a, b )


type Ix a
    = Ix Int a


viewBoth :
    View model1 msg1
    -> View model2 msg2
    -> Both model1 model2
    -> ( Html (Either msg1 msg2), Html (Either msg1 msg2) )
viewBoth va vb ( a, b ) =
    ( Html.map Left <| va a
    , Html.map Right <| vb b
    )


viewAll :
    List (View model msg)
    -> Array model
    -> List (Html (Ix msg))
viewAll views models =
    Array.toList models
        |> List.map2 (<|) views
        |> List.indexedMap (Html.map << Ix)


viewEach :
    (Int -> View model msg)
    -> Array model
    -> List (Html (Ix msg))
viewEach viewAt models =
    Array.toList models
        |> List.indexedMap (\idx model -> Html.map (Ix idx) <| viewAt idx model)


all : List a -> Array a
all =
    Array.fromList


(<|>) :
    View a x
    -> View b y
    -> Both a b
    -> Html (Either x y)
(<|>) v1 v2 =
    viewBoth v1 v2 >> \(h1, h2) -> Html.span [] [ h1, h2 ]
