
(define-module lehti.väri
  (export colour-string)
  (use srfi-1)
  (use srfi-13)
  (use gauche.process)
  (use gauche.parseopt)
  (use util.match)
  (use file.util)
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

