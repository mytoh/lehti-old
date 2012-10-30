;; -*- coding: utf-8 -*-

(define-module lehti.commands.edit
  (export edit)
  (use lehti)
  (use file.util)
  (use util.list)
  (use text.tree)
  (use util.match)
  (use gauche.parseopt)
  (use gauche.process))
(select-module lehti.commands.edit)


(define (editor)
  (cond
    ((sys-getenv "EDITOR")
     (sys-getenv "EDITOR"))
    ((sys-getenv "VISUAL")
     (sys-getenv "VISUAL"))))

(define  (edit name)
  (if (string-scan name "/")
    (let* ((leh (car (string-split name "/")))
           (path (build-path (*lehti-dist-directory*) leh "lib"  (path-swap-extension name "scm"))))
      (if (file-exists? path)
        (run-process `(,(editor) ,path) :wait #t)
        (oai "can't find file " path)))
    (let* ((path (build-path (*lehti-dist-directory*) name "lib" (path-swap-extension name "scm"))))
      (if (file-exists? path)
      (run-process `(,(editor) ,path) :wait #t)
      (oai "can't find file " path)))))
