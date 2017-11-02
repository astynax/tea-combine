module Main exposing (main)

import Either exposing (Either(..))
import Html exposing (Html)
import Html.Attributes exposing (style)
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)


-- local imports

import ByteField
import CheckBoxField
import RGBBox exposing (..)


main =
    Html.beginnerProgram
        { model =
            ByteField.init 80
                <> ByteField.init 160
                <> ByteField.init 240
                <> CheckBoxField.init True
        , update =
            ByteField.update
                <&> ByteField.update
                <&> ByteField.update
                <&> CheckBoxField.update
        , view = view
        }


bindForm =
    bind RGBBox
        (Maybe.withDefault 0 << ByteField.getValue)
        |> with (Maybe.withDefault 0 << ByteField.getValue)
        |> with (Maybe.withDefault 0 << ByteField.getValue)
        |> with CheckBoxField.getValue


view model =
    let
        box =
            bindForm model
    in
        Html.div []
            [ Html.form [] <|
                (labeled "R" ByteField.view
                    <: labeled "G" ByteField.view
                    <:: labeled "B" ByteField.view
                    <:: labeled "Rounded" CheckBoxField.view
                )
                    model
            , RGBBox.view box
            , Html.div [ style [ ( "font-family", "Monospace" ) ] ]
                [ Html.text <| toString model ]
            ]


labeled : String -> (model -> Html msg) -> model -> Html msg
labeled label view model =
    Html.label []
        [ Html.text label
        , view model
        ]


(<:) :
    View model1 msg1
    -> View model2 msg2
    -> Both model1 model2
    -> List (Html (Either msg1 msg2))
(<:) v1 v2 m =
    let
        ( h1, h2 ) =
            (v1 <|> v2) m
    in
        [ h1, h2 ]


(<::) :
    (model1 -> List (Html msg1))
    -> View model2 msg2
    -> Both model1 model2
    -> List (Html (Either msg1 msg2))
(<::) hs v2 ( m1, m2 ) =
    List.append
        (List.map (Html.map Left) <| hs m1)
        [ Html.map Right <| v2 m2 ]


bind :
    (a -> b)
    -> (model -> a)
    -> model
    -> b
bind use get =
    use << get


with :
    (model2 -> a)
    -> (model1 -> (a -> b))
    -> Both model1 model2
    -> b
with get use ( m1, m2 ) =
    use m1 (get m2)
