# TEA Combine

A set of combinators for working with stateful (and effectful) components.

Using this library you can do this:

```elm
import Browser
import CheckBox
import Counter
import Html
import TeaCombine exposing (..)
import TeaCombine.Pure.Pair exposing (..)


main =
    Browser.sandbox
        { init =
            Counter.model
                |> initWith (CheckBox.init False)
                |> initWith (CheckBox.init False)
        , view =
            Html.div []
                << (joinViews Counter.view CheckBox.view
                        |> withView CheckBox.view
                   )
        , update =
            Counter.update
                |> updateWith CheckBox.update
                |> updateWith CheckBox.update
        }
```

and have an app that looks like this:

![screenshot](https://github.com/astynax/tea-combine/blob/master/assets/example.png)

Examples (sources you can find [here](https://github.com/astynax/tea-combine/tree/master/examples)):
- [one with Pure combinators](https://astynax.github.com/tea-combine/examples/pure.html),
- [one with Effectful combinators](https://astynax.github.com/tea-combine/examples/effectful.html),
- [one with form & binding](https://astynax.github.com/tea-combine/examples/form.html)
- [one with multi-page layout](https://astynax.github.com/tea-combine/examples/pages.html)
