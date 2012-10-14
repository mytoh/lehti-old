
(define-module lehti.cli
  (export runner)
  (use gauche.parseopt)
  (use util.match)
  (use file.util)
  (use lehti)
  (use lehti.commands))
(select-module lehti.cli)


(define (usage status)
  (exit status "usage: ~a <command> <package-name>\n" "lehti"))

(define package-list
  (lambda ()
    (file->sexp-list
      "lehtifile")))

(define runner
  (lambda (args)
    (let-args (cdr args)
      ((#f "h|help" (usage 0))
       . rest)
      (when (null-list? rest)
        (usage 0))
      (match (car  rest)
        ;; actions
        ((or "install" "i" "ase")
         (install (cdr rest)))
        ((or "uninstall" "rm")
         (uninstall (cdr rest)))
        ((or "re" "reinstall")
         (reinstall (cdr rest)))
        ("setup"
         (setup (cadr rest)))
        ((or "list" "ls")
         (list-packages))
        ("command"
         (print-commands))
        ((or "exec" "execute" "e")
         (execute (cdr rest)))
        ((or "console" "c")
         (console ))
        (_ (usage 0))))))




