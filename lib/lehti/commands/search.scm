
;; -*- coding: utf-8 -*-

(define-module lehti.commands.search
  (export search)
  (use lehti)
  (use kirjasto.pääte)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.search)


(define (search packages)
  (print packages)
  (puts-columns
    (map
      (lambda (path) (path-sans-extension path))
      (directory-list (build-path ( *lehti-directory* ) "leh" )
                      :children? #t))))
