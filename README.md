# janet-module

This library exports two macros: `defmodule` and `defmodule-`.

These allow you to define multiple modules in a single file, and to bring them in scope as if you had `import`ed them. It's a convenient way to namespace symbols without having to put things in separate files.

A simple example:

```janet
(use module)

(defmodule printer
  (defn new []
    @{:indent 0
      :indented false
      :buf (buffer/new 256)})

  (defn indent [t]
    (repeat (t :indent)
      (buffer/push-string (t :buf) "  "))
    (put t :indented true))

  (defn newline [t]
    (buffer/push-byte (t :buf) (chr "\n"))
    (put t :indented false))

  (defn prin [t & things]
    (unless (t :indented) (indent t))
    (each thing things
      (buffer/push-string (t :buf) thing)))

  (defn print [t & things]
    (prin t ;things)
    (newline t)))

(def printer (printer/new))
(printer/print printer "hello")
```

This is a pretty trivial library but I keep defining this helper over and over.
