
;; -*- coding: utf-8 -*-

(define-module lehti.commands.list
  (export list-packages)
  (use lehti.env)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.list)


(define (list-packages)
  (for-each
    print
    (map
      (lambda (path) (path-sans-extension path))
      (directory-list (build-path ( *lehti-directory* ) "dist/" )
                      :children? #t))))
