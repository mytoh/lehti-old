
;; -*- coding: utf-8 -*-

(define-module lehti.commands.specification
  (export
    specification)
  (use lehti)
  (use srfi-1)
  (use gauche.process)
  (use util.match)
  (use file.util))
(select-module lehti.commands.specification)

(define (specification args)
  (let* ((name (cadr args))
         (lehspec (eval  (car (file->sexp-list (build-path (*lehti-dist-directory* ) name (path-swap-extension name "lehspec"))))
                         (interaction-environment))))
    (for-each (lambda (s)
                (print-specs lehspec (car s)))
              (class-slots <lehspec>))
    ))

(define-method print-specs ((self <lehspec>) spec)
  (cond
    ((list? (ref self spec))
     (print-spec-slot self spec)
     (for-each (lambda (s)
                 (print-slot-bound self spec s))
               (match spec
                 ('files
                  (spec-glob-files self))
                 (else
                   (ref self spec)))))
    (else
      (print-spec-slot self spec)
      (print-slot-bound self spec))))

(define-method spec-glob-files ((self <lehspec>))
  (let ((path (build-path (*lehti-dist-directory*) (spec-name-of self))))
    (current-directory path)
      (flatten (map glob (spec-files-of self )))))

(define-method print-spec-slot ((self <lehspec>) spec)
  (when (slot-bound? self spec)
    (print (colour-string
             (match spec
                         ('files 33)
                         ('name 99)
                         ('dependencies 218)
                         ('description 88)
                         ('homepage 3)
                         (else 1))
             (symbol->string spec)))))

(define-method print-slot-bound ((self <lehspec>) spec)
  (when (slot-bound? self spec)
    (spec-format (ref self spec))))

(define-method print-slot-bound ((self <lehspec>) spec value)
  (when (slot-bound? self spec)
    (spec-format value)))



(define (spec-format spec)
  (format #t "   ~a" spec)
  (newline))
