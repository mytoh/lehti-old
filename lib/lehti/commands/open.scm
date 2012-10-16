

;; -*- coding: utf-8 -*-

(define-module lehti.commands.open
  (export open)
  (use lehti)
  (use file.util)
  (use util.list)
  (use text.tree)
  (use util.match)
  (use gauche.parseopt)
  (use gauche.process))
(select-module lehti.commands.open)


(define (editor)
  (and-let* ((command (sys-getenv "EDITOR")))
    command))

(define  (open name)
  (let ((path (build-path ( *lehti-dist-directory* ) name)))
    (if (file-exists? path)
      (run-process `(,(editor) ,path)
                   :wait #t)
      (print "no package found"))
    ))
