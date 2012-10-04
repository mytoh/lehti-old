
;; -*- coding: utf-8 -*-

(define-module lehti.commands.uninstall
  (export uninstall)
  (use lehti)
  (use lehti.commands.fetch)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.uninstall)


(define (uninstall packages)
  (for-each
    (lambda (package)
      (let ((pac (build-path (*lehti-dist-directory* ) package)))
        (cond
          ((file-is-symlink? pac)
           (sys-remove pac))
          ((not (file-is-directory? pac))
           (sys-remove pac))
          ((file-is-directory? pac)
           (remove-directory* pac)))))
    packages))
