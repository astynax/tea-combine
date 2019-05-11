module Main exposing (main)

-- local imports

import Browser
import CheckBox
import Counter
import Debug
import Html exposing (Html)
import TeaCombine exposing (..)
import TeaCombine.Pure.Many exposing (..)
import TeaCombine.Pure.Pair exposing (..)
import Utils


main =
    let
        simpleDemo =
            { init = Counter.model |> initWith Counter.model
            , view =
                Utils.wrapView "Just aside"
                    (Html.div []
                        << joinViews Counter.view Counter.view
                    )
            , update = Counter.update |> updateWith Counter.update
            }

        arrayDemo =
            let
                asUL =
                    Html.ul [] << List.map (Html.li [] << (\x -> x :: []))
            in
            { init =
                initAll <|
                    List.map (always <| CheckBox.init False) <|
                        List.range 1 5
            , view =
                Utils.wrapView "Array of same components"
                    (asUL
                        << viewEach
                            (\idx ->
                                Utils.labeled (Debug.toString idx)
                                    CheckBox.view
                            )
                    )
            , update = updateEach <| always CheckBox.update
            }

        complexDemo =
            { init =
                Counter.model
                    |> initWith
                        (initAll
                            [ CheckBox.init False
                            , CheckBox.init False
                            ]
                        )
                    |> initWith Counter.model
            , view =
                Utils.wrapView
                    "Aside + list of views"
                    (Html.div []
                        << (joinViews Counter.view
                                (Html.span []
                                    << viewAll
                                        [ Utils.labeled "a" CheckBox.view
                                        , Utils.labeled "b" CheckBox.view
                                        ]
                                )
                                |> withView Counter.view
                           )
                    )
            , update =
                Counter.update
                    |> updateWith
                        (updateAll
                            [ CheckBox.update
                            , CheckBox.update
                            ]
                        )
                    |> updateWith Counter.update
            }
    in
    simpleDemo
        |> addBelow arrayDemo
        |> addBelow complexDemo
        |> Browser.sandbox


addBelow program2 program1 =
    { init = program1.init |> initWith program2.init
    , view =
        viewBoth program1.view program2.view
            >> (\( h1, h2 ) ->
                    Html.div []
                        [ h1
                        , Html.hr [] []
                        , h2
                        ]
               )
    , update = program1.update |> updateWith program2.update
    }
