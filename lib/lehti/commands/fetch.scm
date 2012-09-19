
;; -*- coding: utf-8 -*-

(define-module lehti.commands.fetch
  (export fetch)
  (use lehti.env)
  (use lehti.scm)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.fetch)


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
