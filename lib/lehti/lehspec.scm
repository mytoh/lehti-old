
;; -*- coding: utf-8 -*-

(define-module lehti.lehspec
  (export
    <lehspec>
    spec)
  (use srfi-1)
  (use util.list)
  )
(select-module lehti.lehspec)

(define-class <lehspec> ()
  ((files :init-value '() :init-keyword :files :accessor spec-files)
   (dependencies :init-value '() :init-keyword :dependencies :accessor spec-dependencies)))

(define (spec . infos)
  (make <lehspec>
        :files (car (assoc-ref infos 'files))  
        :dependencies (car (assoc-ref infos 'dependencies)))
  )
