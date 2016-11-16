module TicToc exposing (..)

import Html exposing (Html)
import Html.Events exposing (onClick)
import Html.Attributes exposing (checked, type_)
import Platform.Cmd exposing ((!))
import Time


-- local imports

import TeaCombine exposing (..)
import TeaCombine.Effectful exposing (..)


type alias Model =
    { interval : Float
    , state : Bool
    , enabled : Bool
    }


type Msg
    = Toggle
    | Tick


init : Float -> ( Model, Cmd Msg )
init i =
    { interval = i
    , state = False
    , enabled = True
    }
        ! []


view : View Model Msg
view m =
    Html.span []
        [ Html.input
            [ type_ "checkbox"
            , checked m.enabled
            , onClick Toggle
            ]
            []
        , Html.code []
            [ Html.text <|
                if m.state then
                    "Tic"
                else
                    "Toc"
            ]
        ]


update : UpdateE Model Msg
update msg model =
    (case msg of
        Toggle ->
            { model | enabled = not model.enabled }

        Tick ->
            { model | state = not model.state }
    )
        ! []


sub : Subscription Model Msg
sub model =
    if model.enabled then
        Time.every (model.interval * Time.second) (always Tick)
    else
        Sub.none
