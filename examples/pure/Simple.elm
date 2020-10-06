module Simple exposing (main)

import Browser
import CheckBox
import Counter
import Html
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)


main =
    Browser.sandbox
        { init =
            Counter.init 0
                |> initWith (CheckBox.init False)
                |> initWith (CheckBox.init False)
        , view =
            Html.div []
                << (joinViews Counter.view
                        CheckBox.view
                        |> withView CheckBox.view
                   )
        , update =
            Counter.update
                |> updateWith CheckBox.update
                |> updateWith CheckBox.update
        }
