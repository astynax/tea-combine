module Main exposing (..)

import Html exposing (Html)
import Html.App exposing (program)


-- local imports

import TeaCombine exposing (..)
import TeaCombine.Effectful exposing (..)
import TicToc


type alias Demo model msg =
    { init : ( model, Cmd msg )
    , view : View model msg
    , update : UpdateE model msg
    , subscriptions : Subscription model msg
    }


main : Program Never
main =
    let
        simpleDemo =
            demo
                "Pair of effectful components: one `aside` another"
                (TicToc.init 0.5 <> TicToc.init 0.25)
                (TicToc.view `aside` TicToc.view)
                (TicToc.update <&> TicToc.update)
                (TicToc.sub <+> TicToc.sub)
    in
        program <|
            simpleDemo


demo :
    String
    -> ( model, Cmd msg )
    -> View model msg
    -> UpdateE model msg
    -> Subscription model msg
    -> Demo model msg
demo title init view update subscriptions =
    { init = init
    , view =
        \model ->
            Html.div []
                [ Html.h3 [] [ Html.text title ]
                , view model
                , Html.pre []
                    [ Html.text "model = "
                    , Html.text <| toString model
                    ]
                ]
    , update = update
    , subscriptions = subscriptions
    }
