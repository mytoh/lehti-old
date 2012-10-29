
;; -*- coding: utf-8 -*-

(define-module lehti.commands.clean
  (export clean)
  (use lehti)
  (use file.util))
(select-module lehti.commands.clean)

(define  (clean name)
  (let ((path (build-path (*lehti-cache-dirctory*) name)))
    (cond
      ((file-is-symlink? path)
       (sys-remove path))
      ((file-is-directory? path)
       (remove-directory* path)))))
