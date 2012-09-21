
;; -*- coding: utf-8 -*-

(define-module lehti.commands.uninstall
  (export uninstall)
  (use lehti.env)
  (use lehti.commands.fetch)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.uninstall)


(define (uninstall package)
  (remove-directory* (build-path *lehti-dist-directory* package))
  )
