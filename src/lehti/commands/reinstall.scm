
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
      (uninstall (list package))
      (install (list package)))
    packages))
