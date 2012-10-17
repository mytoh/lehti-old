
;; -*- coding: utf-8 -*-

(define-module lehti.commands.contents
  (export contents)
  (use lehti)
  (use file.util)
  (use srfi-1)
  (use gauche.parseopt)
  (use gauche.process))
(select-module lehti.commands.contents)


(define (list-all-files path no-prefix)
  (let ((file-list
          (reverse (directory-fold path cons '()
                                   :lister (lambda (path seed)
                                             (values
                                               (directory-list path :add-path? #t :children? #t)
                                               (cons path seed)))))))
    (cond 
      (no-prefix
        (remove not
                (map (lambda (e)
                       (string-scan e (string-append path "/") 'after))
                     file-list)) 
        )
      (else
        file-list))
    )
  )

(define (contents args)
  (let-args (cdr args)
    ((no-prefix "no-prefix" #f)
     . rest)
    (for-each
      (lambda (e) (map print e))  
      (map (lambda (n)
             (let ((path (build-path (*lehti-dist-directory*) n)))
               (list-all-files path no-prefix)))
           rest))))
