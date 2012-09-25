;; -*- coding: utf-8 -*-

(define-module lehti.env
  (export
    *lehti-cache-directory*
    *lehti-directory*
    *lehti-dist-directory*
    *lehti-leh-file-directory*)
  (use file.util))
(select-module lehti.env)

(define *lehti-directory*
  (sys-getenv "LEHTI_DIR")
  )

(define *lehti-dist-directory*
  (build-path  *lehti-directory* "dist"))

(define *lehti-cache-directory*
  (build-path *lehti-directory*
              "cache"))

(define *lehti-leh-file-directory*
  (build-path *lehti-directory* "leh"))
