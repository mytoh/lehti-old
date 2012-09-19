
;; -*- coding: utf-8 -*-

(define-module lehti.commands.install
  (export)
  (use lehti.env)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.install)

 (define install
  (lambda (package)
    (let ((lehtifile (build-path *lehti-leh-file-directory*
                                 (string-append package
                                                ".leh")))
          (prefix-directory  (build-path  *lehti-dist-directory*
                                          package)))
      (and-let*
        ((url  (cadr  (assoc 'url (file->sexp-list lehtifile))))
         (commands (cadr (assoc 'install (file->sexp-list lehtifile)))))
        (current-directory (fetch url package))
        (for-each
          (lambda (c) (eval c (interaction-environment)))
          commands)
        (remove-directory* (build-path *lehti-cache-directory* package))))
    ; (link package)
    ))
