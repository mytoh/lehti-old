
;; -*- coding: utf-8 -*-

(define-module lehti.commands.update
  (export update)
  (use lehti.env)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.update)


(define (update)
  (current-directory (*lehti-directory*))
  (run-process '(git pull) :wait #t))
