
;; -*- coding: utf-8 -*-

(define-module lehti.commands.specification
  (export
    specification)
  (use lehti)
  (use srfi-1)
  (use gauche.process)
  (use file.util))
(select-module lehti.commands.specification)

(define (specification args)
  (let ((name (cadr args))))
(let  ((lehspec (eval  (car (file->sexp-list (build-path *lehti-dist-directory* name (path-swap-extension name "lehspec"))))
                        (interaction-environment))))
  (print (ref lehspec 'name))  
  ))

