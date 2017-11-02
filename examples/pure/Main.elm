module Main exposing (..)

import Html exposing (Html, beginnerProgram)
import String
import Tuple


-- local imports

import CheckBox
import Counter
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)
import TeaCombine.Pure.Many exposing (..)
import Utils


main =
    let
        simpleDemo =
            { model = Counter.model <> Counter.model
            , view =
                Utils.wrapView "Just aside"
                    (Html.div []
                        << (Counter.view <::> Counter.view)
                    )
            , update = Counter.update <&> Counter.update
            }

        arrayDemo =
            let
                asUL =
                    Html.ul [] << List.map (Html.li [] << flip (::) [])
            in
                { model =
                    initAll <|
                        List.map (CheckBox.mkModel << toString) <|
                            List.range 1 5
                , view =
                    Utils.wrapView "Array of same components"
                        (asUL << viewEach (always CheckBox.view))
                , update = updateEach <| always CheckBox.update
                }

        complexDemo =
            { model =
                Counter.model
                    <> initAll [ CheckBox.mkModel "a", CheckBox.mkModel "b" ]
                    <> Counter.model
            , view =
                Utils.wrapView
                    "Aside + Array with separate views & updates"
                    (Html.div []
                        << (Counter.view
                                <::>
                                    (Html.span []
                                        << viewAll
                                            [ CheckBox.view
                                                << Tuple.mapFirst
                                                    (\label ->
                                                        String.concat
                                                            [ "<", label, ">" ]
                                                    )
                                            , CheckBox.view
                                            ]
                                    )
                                <:: Counter.view
                           )
                    )
            , update =
                Counter.update
                    <&> updateAll [ CheckBox.update, CheckBox.update ]
                    <&> Counter.update
            }
    in
        simpleDemo
            |> addBelow arrayDemo
            |> addBelow complexDemo
            |> beginnerProgram


addBelow program2 program1 =
    { model = program1.model <> program2.model
    , view =
        viewBoth program1.view program2.view
            >> uncurry
                (\h1 h2 ->
                    Html.div []
                        [ h1
                        , Html.hr [] []
                        , h2
                        ]
                )
    , update = program1.update <&> program2.update
    }
