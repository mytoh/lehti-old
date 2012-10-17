;; -*- coding: utf-8 -*-

(define-module lehti.env
  (export
    *lehti-cache-directory*
    *lehti-directory*
    *lehti-dist-directory*
    *lehti-bin-directory*
    *lehti-leh-file-directory*)
  (use gauche.parameter)
  (use file.util))
(select-module lehti.env)

(define *lehti-directory*
  (make-parameter
    (sys-getenv "LEHTI_DIR")))

(define *lehti-dist-directory*
  (make-parameter
    (build-path  ( *lehti-directory* ) "dist")))

(define *lehti-cache-directory*
  (make-parameter
    (build-path ( *lehti-directory* )
                "cache")))

(define *lehti-leh-file-directory*
  (make-parameter
    (build-path ( *lehti-directory* ) "leh")))

(define *lehti-bin-directory*
  (make-parameter
    (build-path  ( *lehti-directory* ) "bin")))

