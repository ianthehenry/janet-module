(defmacro- lazy-seq [rules & body]
  ~(coro (loop ,rules (yield (do ,;body)))))

(defn- defmodule* [name body export]
  (def dest-env (curenv))
  (def module-env (make-env dest-env))
  (def inputs (lazy-seq [form :in body] form))
  (run-context {
    :env module-env
    :read (fn [env source]
      (or
        (resume inputs)
        (do (put env :exit true) nil)))})
  (merge-module dest-env module-env (string name "/") export)
  nil)

(defmacro defmodule- [name & body] (defmodule* name body false))
(defmacro defmodule [name & body] (defmodule* name body true))
