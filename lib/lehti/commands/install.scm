
;; -*- coding: utf-8 -*-

(define-module lehti.commands.install
  (export install)
  (use lehti)
  (use lehti.commands.fetch)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.install)


(define install
  (lambda (packages)
    (for-each
      (lambda (package)
        (print (string-append
                 "installing "
                 (colour-string 12 package)))
        (let ((lehtifile (file->sexp-list (build-path (*lehti-leh-file-directory* )
                                                      (string-append package
                                                                     ".leh"))))
              (cache-directory (build-path (*lehti-cache-directory* )
                                           package))
              (prefix-directory  (build-path  (*lehti-dist-directory* )
                                              package)))
          (let
            ((url  (cadr  (assoc 'url lehtifile)))
             (install-commands (assoc 'install lehtifile)))
            (cond
              (install-commands
                (current-directory (fetch url package))
                (for-each
                  (lambda (c) (eval c (interaction-environment)))
                  (cadr install-commands))
                (remove-directory* cache-directory))
              (else
                (current-directory (fetch url package))
                (let ((cmd (cadr (assoc 'install (file->sexp-list (build-path cache-directory
                                                                              (path-swap-extension package "leh")))))))
                  (for-each
                    (lambda (c) (eval c (interaction-environment)))
                    cmd))
                (remove-directory* cache-directory)))
            )))
      packages)))
