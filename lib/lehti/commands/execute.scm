

;; -*- coding: utf-8 -*-

(define-module lehti.commands.execute
  (export execute)
  (use lehti)
  (use file.util)
  (use util.list)
  (use text.tree)
  (use util.match)
  (use gauche.parseopt)
  (use gauche.process))
(select-module lehti.commands.execute)


(define  (append-environment-variable name value sep)
  (sys-setenv name
              (string-append value sep (sys-getenv name))
              #t))

(define (execute commands)
  (append-environment-variable "GAUCHE_LOAD_PATH"
                               "lib" ":")
  (run-process `(,@commands) :wait #t)
  )

