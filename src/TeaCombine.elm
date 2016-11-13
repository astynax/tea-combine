module TeaCombine
    exposing
        ( View
        , Update
        , Both
        , Ix
        , viewBoth
        , viewEach
        , viewAll
        , updateBoth
        , updateEach
        , updateAll
        , (<>)
        , all
        , aside
        , (<&>)
        )

import Array exposing (Array)
import Either exposing (Either(..))
import Html exposing (Html)
import Html.App as Html
import Tuple2


type alias View model msg =
    model -> Html msg


type alias Update msg model =
    msg -> model -> model


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


updateBoth :
    Update msg1 model1
    -> Update msg2 model2
    -> Update (Either msg1 msg2) (Both model1 model2)
updateBoth ua ub =
    Either.unpack (Tuple2.mapFst << ua) (Tuple2.mapSnd << ub)


updateEach :
    (Int -> Update msg model)
    -> Update (Ix msg) (Array model)
updateEach updateAt (Ix idx msg) models =
    Array.get idx models
        |> Maybe.map (flip (Array.set idx) models << updateAt idx msg)
        |> Maybe.withDefault models


updateAll :
    List (Update msg model)
    -> Update (Ix msg) (Array model)
updateAll updates =
    let
        uarr =
            Array.fromList updates

        updateIx =
            Maybe.withDefault (flip always) << flip Array.get uarr
    in
        \ (Ix idx msg) models ->
            Array.get idx models
                |> Maybe.map (flip (Array.set idx) models << updateIx idx msg)
                |> Maybe.withDefault models


(<>) : a -> b -> Both a b
(<>) =
    (,)


all : List a -> Array a
all =
    Array.fromList


aside :
    View a x
    -> View b y
    -> Both a b
    -> Html (Either x y)
aside v1 v2 =
    viewBoth v1 v2 >> uncurry (\h1 h2 -> Html.span [] [ h1, h2 ])


(<&>) :
    Update msg1 model1
    -> Update msg2 model2
    -> Update (Either msg1 msg2) (Both model1 model2)
(<&>) =
    updateBoth
