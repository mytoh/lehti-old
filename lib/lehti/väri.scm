
;; -*- coding: utf-8 -*-

(define-module lehti.väri
  (export
    colour-string

    colour-package
    colour-symbol1
    colour-symbol2)
  (use gauche.parameter)
  (use gauche.process)
  (require-extension
    (srfi 13)))

(select-module lehti.väri)


(define (colour-string colour-number s)
  ;; take number, string -> return string
  (cond
    ((string? s)
     (string-concatenate
       `("[38;5;" ,(number->string colour-number) "m"
         ,s
         "[0m")))
    (else
      (string-concatenate
        `("[38;5;" ,(number->string colour-number) "m"
          ,s
          "[0m")))))

(define colour-symbol1
  (make-parameter
    208))

(define colour-symbol2
  (make-parameter
    95))

(define colour-package
  (make-parameter
    156))
