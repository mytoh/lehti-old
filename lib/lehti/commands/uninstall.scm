
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
        (print (string-append
                 "uninstalling "
                 (colour-string 12 package)))
      (let ((pac (build-path (*lehti-dist-directory* ) package)))
        (cond
          ((file-is-symlink? pac)
           (sys-unlink pac))
          ((not (file-is-directory? pac))
           (sys-remove pac))
          ((file-is-directory? pac)
           (remove-directory* pac)))
        (if (file-exists? (build-path (*lehti-directory*) "bin" package))
          (sys-remove (build-path (*lehti-directory*) "bin" package)))))
    packages))
