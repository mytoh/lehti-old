
;; -*- coding: utf-8 -*-

(define-module lehti.väri
  (export
    colour-string
    )
  (use gauche.process)
  (require-extension
    (srfi 13))
  )

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

