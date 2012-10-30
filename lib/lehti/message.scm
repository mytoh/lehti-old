
(define-module lehti.message
  (export
    ohei
    oai)
  (use gauche.parseopt)
  (use gauche.parameter)
  (use util.match)
  (use file.util)
  (use lehti.väri)
  )
(select-module lehti.message)


(define symbol
  (make-parameter
    "==> "))

(define (ohei msg . rest)
  (apply print
         (colour-string (colour-symbol1) (symbol))
         msg rest))

(define (oai msg . rest)
  (apply print
         (colour-string (colour-symbol2) (symbol))
         msg rest))
