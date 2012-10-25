
;; -*- coding: utf-8 -*-

(define-module lehti.commands.upgrade
  (export upgrade)
  (use lehti)
  (use lehti.commands.reinstall)
  (use text.tree)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.upgrade)


(define (upgrade names)
  (let ((names (cdr names)))
    (if (null? names)
      (reinstall (list-packages))
      (for-each reinstall (list names)))))

(define (list-packages)
  (map
    (lambda (path) (path-sans-extension path))
    (directory-list (build-path ( *lehti-directory* ) "dist/" )
                    :children? #t)))
