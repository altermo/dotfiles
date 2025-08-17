;; extends

(("function" @keyword.function) (#set! conceal "λ"))
(("local" @keyword) (#set! conceal "»"))
(("then" @conditional) (#set! conceal "⇒"))
(("do" @repeat) (#set! conceal "⇒"))
(("end" @keyword.function) (#set! conceal "⇐"))

((binary_expression (unary_expression "not") "==") @comment.todo @markup.strikethrough @markup.underline)
