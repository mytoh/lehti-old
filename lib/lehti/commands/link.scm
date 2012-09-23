;; -*- coding: utf-8 -*-

(define-module lehti.commands.link
  (export link)
  (use gauche.parseopt)
  (use gauche.process)
  (use rfc.uri)
  (use file.util)
  (use srfi-1)
  )
(select-module lehti.commands.link)
 (define link
  (lambda (package)
    (let* ((package-directory (build-path *lehti-dist-directory*
                                package)))
    (current-directory *lehti-directory*)

    (newline)
    (display (string-append "[38;5;38m" ":: " "[0m"))
    (print "symlinking files")
    (newline)
    (letrec ((relative-path
              (lambda (p)
                (fold
                    (lambda (e str)
                      (string-append "../" str))
                  (simplify-path
                      (string-append
                          "."
                        (string-scan p
                           *lehti-directory*
                          'after)))
                  (string-split
                      (sys-dirname
                          (simplify-path
                              (string-append
                                  "."
                                (string-scan p
                                  package-directory
                                  'after))))
                    #/\//))))
             (file-list
              (directory-fold
                  package-directory
                (lambda (path seed)
                  (cons (list
                            (relative-path path)
                          (simplify-path (string-append "."
                                           (string-scan path
                                             package-directory
                                             'after))))
                    seed))
                '())))
      (for-each
       (^p
        (unless (file-exists? (sys-dirname (cadr p)))
             (make-directory* (sys-dirname (cadr p))))
        (unless  (file-exists? (cadr p))
           (begin
             (print (string-append
                        "linking file "
                      (colour-string 163
                        (cadr  p))))
             (sys-symlink (car p)
               (cadr p)))))
       file-list)))))
