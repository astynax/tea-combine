module Main exposing (main)

import Either exposing (Either(..))
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)


main =
    Html.beginnerProgram
        { model = False <> False <> False <> False
        , update = toggle <&> toggle <&> toggle <&> toggle
        , view = Html.div [] << (view <: view <:: view <:: view)
        }


toggle =
    always not


view b =
    Html.div
        [ style
            [ ( "width", "20px" )
            , ( "height", "20px" )
            , ( "background-color", "#777" )
            , ( "display", "inline-block" )
            , ( "border-width", "5px" )
            , ( "border-style"
              , if b then
                    "inset"
                else
                    "outset"
              )
            ]
        , onClick ()
        ]
        []


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
