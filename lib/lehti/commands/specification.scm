
;; -*- coding: utf-8 -*-

(define-module lehti.commands.specification
  (export
    specification)
  (use lehti)
  (use srfi-1)
  (use gauche.process)
  (use file.util))
(select-module lehti.commands.specification)

(define (specification package)
(let  ((lehspec (eval  (car (file->sexp-list (build-path *lehti-dist-directory* package (path-swap-extension package "lehspec"))))
                        (interaction-environment))))
  (ref lehspec 'name)
  ))

