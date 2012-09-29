#!/usr/bin/env gosh

(define-module lehti.commands.setup
  (export setup)
  (use gauche.process)
  (use file.util)
  (use util.match)
  (use srfi-1)
  (use lehti)
  )
(select-module lehti.commands.setup)


(define (make-load-path)
  (append
    (remove null?
            (map
              (lambda (e)
                (let ((share-lib-path (build-path e "share/gauche-0.9/site/lib")))
                  (cond
                    ((file-exists? share-lib-path)
                     share-lib-path)
                    ((and (file-exists? (build-path e "lib"))
                       (not (file-exists? (build-path e "lib/gauche-0.9"))))
                     (build-path e "lib"))
                    (else
                      '()))))
              (directory-list *lehti-dist-directory* :add-path? #t :children? #t)))
    (make-src-load-path)))

(define (make-src-load-path)
  (remove null?
          (map
            (lambda (e)
              (let ((lib-path
                      (build-path e "src")))
                (if (file-exists? lib-path)
                  lib-path
                  '())))
            (directory-list *lehti-dist-directory* :add-path? #t :children? #t))))

(define (make-dynload-path)
  (append
    (map (lambda (e) (build-path e "lib/gauche-0.9/site" (gauche-architecture)))
         (directory-list *lehti-dist-directory*
                         :add-path? #t
                         :children? #t
                         :filter-add-path? #t
                         :filter (lambda (e)
                                   (let ((lib-path
                                           (build-path e "lib/gauche-0.9/site" (gauche-architecture))))
                                     (if (file-exists? lib-path)
                                       #t
                                       #f)))))
    (list (let1 dynpath (sys-getenv "GAUCHE_DYNLOAD_PATH")
            dynpath ""))))

(define (make-path)
  (map
    (lambda (e) (build-path e "bin"))
    (directory-list *lehti-dist-directory*
                    :filter-add-path? #t
                    :filter (lambda (e)
                              (let ((bin-path
                                      (build-path e "bin")))
                                (if (file-exists? bin-path)
                                  #t
                                  #f)))
                    :add-path? #t
                    :children? #t)))

(define (list->path lst)
  (cond
    ((= (length lst) 1)
     (car lst))
    (else
      (string-join lst ":"))))



(define (setup args)
  (match args
    ("load-path"
     (display (list->path (make-load-path))))
    ("dynload-path"
     (display (list->path (make-dynload-path))))
    ("path"
     (display (list->path (make-path))))))
