
;; -*- coding: utf-8 -*-

(define-module lehti.commands.install
  (export install)
  (use lehti.env)
  (use lehti.commands.fetch)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.install)


(define install
  (lambda (packages)
    (for-each
      (lambda (package)
        (let ((lehtifile (build-path ( *lehti-leh-file-directory* )
                                     (string-append package
                                                    ".leh")))
              (cache-directory (build-path ( *lehti-cache-directory* )
                                           package))
              (prefix-directory  (build-path  ( *lehti-dist-directory* )
                                              package)))
          (and-let*
            ((url  (cadr  (assoc 'url (file->sexp-list lehtifile)))))
            (current-directory (fetch url package))
            (let ((cmd (cadr (assoc 'install (file->sexp-list (build-path cache-directory
                                                                          (path-swap-extension package "leh")))))))
              (for-each
                (lambda (c) (eval c (interaction-environment)))
                cmd))
            (remove-directory* cache-directory))))
      packages)))
