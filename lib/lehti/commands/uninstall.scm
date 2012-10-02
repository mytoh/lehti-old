
;; -*- coding: utf-8 -*-

(define-module lehti.commands.uninstall
  (export uninstall)
  (use lehti.env)
  (use lehti.commands.fetch)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.uninstall)


(define (uninstall package)
  (let ((pac (build-path *lehti-dist-directory* package)))
    (cond
      ((not (file-is-directory? pac))
       (sys-remove pac))
      ((file-is-directory? pac)
       (remove-directory* pac)))))
