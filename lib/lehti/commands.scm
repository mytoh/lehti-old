
;; -*- coding: utf-8 -*-

(define-module lehti.commands
  (extend
    lehti.commands.install
    lehti.commands.uninstall
    lehti.commands.fetch
    lehti.commands.setup
    lehti.commands.link
    lehti.commands.command
    lehti.commands.generate
    )
  )
(select-module lehti.commands)
