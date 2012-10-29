
;; -*- coding: utf-8 -*-

(define-module lehti.lehspec
  (export
    <lehspec>
    slot-unbound
    spec-files-of
    spec-name-of
    spec-homepage-of
    spec-dependencies-of
    spec-description-of
    spec)
  (require-extension (srfi 1))
  (use util.list))
(select-module lehti.lehspec)

(define-class <lehspec> ()
  ((name :init-value "unknown" :init-keyword :name :accessor spec-name-of)
   (files :init-value '() :init-keyword :files :accessor spec-files-of)
   (dependencies :init-value '() :init-keyword :dependencies :accessor spec-dependencies-of)
   (description :init-value "" :init-keyword :description :accessor spec-description-of)
   (homepage  :init-value "" :init-keyword :homepage :accessor spec-homepage-of)))

(define (spec . infos)
  (let ((register (lambda (i e)
                    (if (assoc-ref i e)
                      (car (assoc-ref i e))
                      #f))))
  (make <lehspec>
        :name (register infos 'name)
        :files (register infos 'files)
        :dependencies (register infos 'dependencies)
        :description (register infos 'description)
        :homepage    (register infos 'homepage))))

(define-method slot-unbound ((self <lehspec>))
  #f)



