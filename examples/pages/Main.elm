module Main exposing (main)

import Either exposing (Either(..))
import Html exposing (Html)
import Html.Attributes exposing (type_, checked)
import Html.Events exposing (onClick)
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)


-- local imports

import TabControl
import Utils


main =
    Html.beginnerProgram
        { model =
            -- each page can have own type of state:
            "Foo"
                <> Just "Bar"
                <> 42
                <> False
                -- path to the current page (now it points to the last page):
                <> Right ()
        , update =
            always identity
                <&> always identity
                <&> always identity
                <&> always not
                -- this update function updates a page selection (path):
                <&> always
        , view =
            Utils.wrapView "Pages" view
        }


view ( model, path ) =
    let
        emptyPage =
            Utils.wrapView "Empty page" <|
                always <|
                    Html.text "empty"

        checkBoxPage =
            Utils.wrapView "Page with checkbox"
                (\x ->
                    Html.input
                        [ type_ "checkbox"
                        , checked x
                        , onClick ()
                        ]
                        []
                )

        tabs =
            TabControl.tabControl path
                (oneOfPaths
                    "Page 1"
                    "Page 2"
                    |> orPath "Other page"
                    |> orPath "Last page"
                )

        page =
            (oneOfViews
                emptyPage
                emptyPage
                |> orView emptyPage
                |> orView checkBoxPage
            )
                path
                model
    in
        Html.div []
            [ Html.map Right tabs
            , Html.map Left page
            ]


oneOfViews :
    View model1 msg1
    -> View model2 msg2
    -> Either () ()
    -> View (Both model1 model2) (Either msg1 msg2)
oneOfViews v1 v2 path ( m1, m2 ) =
    case path of
        Left () ->
            Html.map Left <| v1 m1

        Right () ->
            Html.map Right <| v2 m2


orView :
    View model2 msg2
    -> (path -> model1 -> Html msg1)
    -> Either path ()
    -> View (Both model1 model2) (Either msg1 msg2)
orView v2 next path ( m1, m2 ) =
    case path of
        Left p ->
            Html.map Left <| next p m1

        Right () ->
            Html.map Right <| v2 m2


oneOfPaths : a -> a -> List ( a, Either () () )
oneOfPaths v1 v2 =
    [ ( v1, Left () )
    , ( v2, Right () )
    ]


orPath : a -> List ( a, b ) -> List ( a, Either b () )
orPath v ps =
    List.append
        (List.map (Tuple.mapSecond Left) ps)
        [ ( v, Right () ) ]
