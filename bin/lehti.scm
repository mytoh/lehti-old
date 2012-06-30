#!/usr/bin/env gosh
;; -*- coding: utf-8 -*-

(use gauche.process)
(use gauche.parseopt)
(use util.match)
(use file.util)
(require-extension
  (srfi 1))
(use kirjasto)

(define *lehti-directory*
  (build-path (home-directory)
    ".lehti"))

(define *lehti-dist-directory*
  (build-path  *lehti-directory* "dist"))

(define *lehti-cache-directory*
  (build-path *lehti-directory*
              "cache"))

(define *lehti-leh-file-directory*
  (build-path *lehti-directory* "leh"))

(define (usage status)
  (exit status "usage: ~a <command> <package-name>\n" *program-name*))

(define package-list
  (lambda ()
    (file->sexp-list
      "lehtifile")))

(define install
  (lambda (package)
    (let ((lehtifile (build-path *lehti-leh-file-directory*
                                 (string-append package
                                                ".leh")))
          (prefix-directory  (build-path  *lehti-dist-directory*
                                          package)))
      (and-let*
        ((url  (cadr  (assoc 'url (file->sexp-list lehtifile))))
         (commands (cadr (assoc 'install (file->sexp-list lehtifile)))))
        (current-directory (fetch url package))
        (for-each
          (lambda (c) ( eval c (interaction-environment)))
          commands)
        (remove-directory* (build-path *lehti-cache-directory* package))
        ))
    (link package)))

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

(define fetch
  (lambda (url package)
    (let ((tmpdir *lehti-cache-directory*))
      (make-directory* tmpdir)
      (current-directory tmpdir)
      (cond
        ((url-is-git? url)
         (run-process `(git clone ,url ,package) :wait #t))
        (else
          exit)
        )
      (build-path tmpdir package)
      )))

(define lehti
  (lambda (args)
    (let-args (cdr args)
      ((#f "h|help" (usage 0))
       . rest)
      (when (null-list? rest)
        (usage 0))
      (match (car  rest)
        ;; actions
        ("install"
         (install (cadr rest)))

        (_ (usage 0))))))



(define (main args)
  (lehti args))
