# TEA Combine

A set of combinators for working with stateful (and effectful) components.

Using this library you can do this:

```elm
import TeaCombine exposing (..)
import TeaCombine.Pure exposing (..)

main =
    beginnerProgram
        { model = Counter.model <> CheckBox.mkModel "1" <> CheckBox.mkModel "2"
        , view = Counter.view <|> CheckBox.view <|> CheckBox.view
        , update = Counter.update <&> CheckBox.update <&> CheckBox.update
        }
```

and have an app what looks like this:

![screenshot](https://github.com/astynax/tea-combine/blob/master/assets/example.png)

Examples of usage can be found [here](https://github.com/astynax/tea-combine/tree/master/examples), and here is a [live demo #1](https://astynax.github.com/tea-combine/examples/pure.html) (pure)
and [live demo #2](https://astynax.github.com/tea-combine/examples/effectful.html) (effectful).
