
;; -*- coding: utf-8 -*-

(define-module lehti.commands.clean
  (export clean)
  (use lehti)
  (use file.util))
(select-module lehti.commands.clean)

(define  (clean name)
  (let ((packages (cdr name)))
    (for-each
      (lambda (p)
      (let ((path (build-path (*lehti-cache-directory*) p)))
        (cond
          ((file-is-symlink? path)
           (print "cleaning " path)
           (sys-remove path))
          ((file-is-directory? path)
           (print "cleaning " path)
           (remove-directory* path)))))
      packages)))
