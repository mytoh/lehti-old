
;; -*- coding: utf-8 -*-

(define-module lehti.commands.reinstall
  (export reinstall)
  (use lehti)
  (use lehti.commands.uninstall)
  (use lehti.commands.install)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.reinstall)




(define (reinstall packages)
  (for-each
    (lambda (package)
      (cond
        ((package-is-installed? package)
         (uninstall (list package))
         (install (list package)))
        ((package-is-available? package)
          (print (string-append
                   (colour-string 33 package)
                   " not installed")))
        (else
          (print (string-append
                   "package "
                   (colour-string 12 package)
                   " is not available")))))
    packages))
