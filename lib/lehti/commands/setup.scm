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
  (string-join
    (append
      (remove not
              (map
                (lambda (e)
                  (let ((lib-path
                          (build-path e "share/gauche-0.9/site/lib")))
                    (if (file-exists? lib-path)
                      lib-path
                      #f)))
                (directory-list *lehti-dist-directory* :add-path? #t :children? #t)))
      (make-src-load-path))
    ":"))

(define (make-src-load-path)
  (remove not
          (map
            (lambda (e)
              (let ((lib-path
                      (build-path e "src")))
                (if (file-exists? lib-path)
                  lib-path
                  #f)))
            (directory-list *lehti-dist-directory* :add-path? #t :children? #t))))


(define (make-dynload-path)
  (string-join
    (append
      (remove not
              (map
                (lambda (e)
                  (let ((lib-path
                          (build-path e "lib/gauche-0.9/site" (gauche-architecture))))
                    (if (file-exists? lib-path)
                      lib-path
                      #f)))
                (directory-list *lehti-dist-directory* :add-path? #t :children? #t)))
      (list (let1 dynpath (sys-getenv "GAUCHE_DYNLOAD_PATH")
              dynpath "")))
    ":"))

(define (make-path)
  (string-join
    (remove not
            (map
              (lambda (e)
                (let ((bin-path
                        (build-path e "bin")))
                  (if (file-exists? bin-path)
                    bin-path
                    #f)))
              (directory-list *lehti-dist-directory* :add-path? #t :children? #t)))
    ":"))



(define (setup args)
  (match args
    ("load-path"
     (display (make-load-path)))
    ("dynload-path"
     (display (make-dynload-path)))
    ("path"
     (display (make-path)))
    ))
