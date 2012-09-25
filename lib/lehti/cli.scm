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
        ("install"
         (install (cadr rest)))
        ((or "uninstall" "rm")
         (uninstall (cadr rest)))
        ("setup"
         (setup (cadr rest)))
        ("commands"
         (commands ))
        (_ (usage 0))))))



