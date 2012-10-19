

;; -*- coding: utf-8 -*-

(define-module lehti.util
  (export
    puts-columns
    package-is-installed?
    package-is-available?)
  (use lehti.env)
  (use file.util)
  (use gauche.process))
(select-module lehti.util)



(define (package-is-installed? package)
  (if (file-is-directory? (build-path (*lehti-dist-directory* ) package))
    #t #f))

(define (package-is-available? package)
  (if (file-exists? (build-path (*lehti-leh-file-directory* )
                                      (path-swap-extension package
                                                           "leh")))
    #t #f))


(define (string-longest string-list)
  (fold (lambda (s r)
          (if (< r (string-length s))
            (string-length s)
            r))
        0 string-list))

(define (puts-columns items)
  (let* ((console-width (string->number  (process-output->string "tput cols " )))
         (longest (string-longest items))
         (optimal-col-width (floor->exact (/. console-width (+ longest 2))))
         (cols (if (< 1 optimal-col-width ) optimal-col-width 1)))

    (let loop ((itm items))
      (cond
        ((< (length itm) cols)
         (for-each
           (lambda (s) (format #t (string-append
                                    "~" (number->string (+  longest 2)) "a")
                               s))
           (take* itm cols)))
        (else
          (for-each
            (lambda (s) (format #t (string-append
                                     "~" (number->string (+ longest 2)) "a")
                                s))
            (take* itm cols))
          (newline)
          (loop (drop* itm cols)))))
    (newline)))
