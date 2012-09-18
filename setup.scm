#!/usr/bin/env gosh

(use gauche.process)
(use file.util)
(use util.match)
(use srfi-1)

(define lehti-directory (build-path (home-directory) ".lehti"))
(define dist-directory (build-path lehti-directory "dist"))

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
          (directory-list dist-directory :add-path? #t :children? #t)))
      *load-path*)
    ":"))

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
          (directory-list dist-directory :add-path? #t :children? #t)))
      (list (sys-getenv "GAUCHE_DYNLOAD_PATH")))
    ":"))

(define (main args)
  (match (cdr args)
    (("load-path")
     (display (make-load-path)))
    (("dynload-path")
     (display (make-dynload-path)))))
