
;; -*- coding: utf-8 -*-

(define-module lehti.commands
  (extend
    lehti.commands.install
    lehti.commands.uninstall
    lehti.commands.fetch
    )
  )
(select-module lehti.commands)
