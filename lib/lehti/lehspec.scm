
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
  ((files :init-value '() :init-keyword :files :accessor spec-files-of)
   (dependencies :init-value '() :init-keyword :dependencies :accessor spec-dependencies-of)))

(define (spec . infos)
  (let ((register (lambda (i e)
                    (if (assoc-ref i e)
                      (car (assoc-ref i e))
                      #f)))))
  (make <lehspec>
        :files (register infos 'files)  
        :dependencies (register infos 'dependencies))
  )
