
;; -*- coding: utf-8 -*-

(define-module lehti.commands.command
  (export print-commands)
  (use lehti.env)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.command)


(define (print-commands)
  (for-each
    print
    (map
      (lambda (path) (path-sans-extension path))
      (directory-list (build-path ( *lehti-directory* ) "src/lehti/commands" )
                      :children? #t))))
