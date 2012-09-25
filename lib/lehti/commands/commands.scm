
;; -*- coding: utf-8 -*-

(define-module lehti.commands.commands
  (export commands)
  (use lehti.env)
  (use lehti.commands.fetch)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.commands)

(define-macro (commands)
  (for-each
    print
    `,(map
        (lambda (path) (path-sans-extension path))
        (directory-list (build-path (sys-dirname (current-load-path))
                                    "commands")
                        :children? #t)))
  )
