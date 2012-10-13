

;; -*- coding: utf-8 -*-

(define-module lehti.util
  (export
    package-is-installed?
    package-is-available?)
  (use lehti.env)
  (use file.util)
  (use gauche.process))
(select-module lehti.util)



(define (package-is-installed? package)
  (if (file-is-directory? (build-path (*lehti-dist-directory* ) package))
    #t #f))

(define (package-is-available? package)
  (if (file-exists? (build-path (*lehti-leh-file-directory* )
                                      (path-swap-extension package
                                                           "leh")))
    #t #f))
