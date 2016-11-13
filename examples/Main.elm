module Main exposing (..)

import Html exposing (Html)
import Html.App exposing (beginnerProgram)
import Counter
import CheckBox
import String
import TeaCombine exposing (..)
import Tuple2


main =
    let
        simpleDemo =
            demo
                "Just `aside`"
                (Counter.model <> Counter.model)
                (Counter.view `aside` Counter.view)
                (Counter.update <&> Counter.update)

        arrayDemo =
            let
                asUL =
                    Html.ul [] << List.map (Html.li [] << flip (::) [])
            in
                demo
                    "Array of same components"
                    (all <| List.map (CheckBox.mkModel << toString) [1..5])
                    (asUL << viewEach (always CheckBox.view))
                    (updateEach <| always CheckBox.update)

        complexDemo =
            demo
                "Aside + Array with separate views & updates"
                (Counter.model
                    <> all [ CheckBox.mkModel "a", CheckBox.mkModel "b" ]
                    <> Counter.model
                )
                (Counter.view
                    `aside`
                        (Html.span []
                            << viewAll
                                [ CheckBox.view
                                    << Tuple2.mapFst
                                        (\label ->
                                            String.concat [ "<", label, ">" ]
                                        )
                                , CheckBox.view
                                ]
                        )
                    `aside` Counter.view
                )
                (Counter.update
                    <&> updateAll [ CheckBox.update, CheckBox.update ]
                    <&> Counter.update
                )
    in
        beginnerProgram <|
            simpleDemo
                `atop` arrayDemo
                `atop` complexDemo


demo title model view update =
    { model = model
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
    }


atop demo1 demo2 =
    { model = demo1.model <> demo2.model
    , view =
        viewBoth demo1.view demo2.view
            >> uncurry
                (\h1 h2 ->
                    Html.div []
                        [ h1
                        , Html.hr [] []
                        , h2
                        ]
                )
    , update = demo1.update <&> demo2.update
    }
