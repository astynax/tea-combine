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
            Counter.init 0
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

and have an app that looks like this (image is clickable!):

[![screenshot](https://github.com/astynax/tea-combine/blob/master/assets/example.png)](https://astynax.github.com/tea-combine/examples/pure/Simple.html)

[Here](https://medium.com/@mattia512maldini/the-principles-behind-tea-combine-49120b9137d0) you can find a good explanatory article (thanks to [Maldus512](https://github.com/Maldus512)!) about *how* all this stuff works!

### More examples

(All the sources you can find [here](https://github.com/astynax/tea-combine/tree/master/examples))

- [simple one](https://astynax.github.io/tea-combine/examples/pure/Main.html) with `Pure` combinators,
- [another](https://astynax.github.io/tea-combine/examples/pure/Recursive.html) pure but recursive,
- [one](https://astynax.github.io/tea-combine/examples/effectful/Main.html) with `Effectful` combinators,
- [another](https://astynax.github.io/tea-combine/examples/effectful/Recursive.html) effectful but recursive,
- [one](https://astynax.github.io/tea-combine/examples/form/Main.html) with form & binding,
- [one](https://astynax.github.io/tea-combine/examples/pages/Main.html) with multi-page layout,
- [another](https://astynax.github.io/tea-combine/examples/xor_pages/Main.html) multi-page one but with the state resetting on tab switch.
