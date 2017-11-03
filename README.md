# TEA Combine

A set of combinators for working with stateful (and effectful) components.

Using this library you can do this:

```elm
import Html
import TeaCombine exposing (..)
import TeaCombine.Pure exposing (..)
import TeaCombine.Pure.Pair exposing (..)

main =
    let
        labeled t v m = Html.label [] [Html.text t, v m]
    in
        Html.beginnerProgram
            { model = Counter.model <> CheckBox.model <> CheckBox.model
            , view = Html.div [] <<
                ( Counter.view
                     <::> labeled "1" CheckBox.view
                     <:: labeled "2" CheckBox.view
                )
            , update = Counter.update <&> CheckBox.update <&> CheckBox.update
            }
```

and have an app that looks like this:

![screenshot](https://github.com/astynax/tea-combine/blob/master/assets/example.png)

Examples (sources you can find [here](https://github.com/astynax/tea-combine/tree/master/examples)):
- [one with Pure combinators](https://astynax.github.com/tea-combine/examples/pure.html),
- [one with Effectful combinators](https://astynax.github.com/tea-combine/examples/effectful.html),
- [one with form & binding](https://astynax.github.com/tea-combine/examples/form.html)
