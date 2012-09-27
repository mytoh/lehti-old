

;; -*- coding: utf-8 -*-

(define-module lehti.commands.create
  (export create)
  (use lehti.env)
  (use file.util)
  (use util.list)
  (use text.tree)
  (use gauche.process))
(select-module lehti.commands.create)


(define (dir-spec name)
  `(,name
     ((bin ((,name ,make-bin)))
      (src
        ((,(path-swap-extension name "scm"))
         (,name (("cli.scm" ,make-cli))))
        ))))

(define (make-cli path)
  (let ((name (sys-basename (sys-dirname path))))
    (display
      (tree->string
        (intersperse
          "\n"
          `(
            ,(string-append "(define-module " name ".cli")
            "  (export runner)"
            "  (use gauche.parseopt)"
            "  (use util.match)"
            "  (use file.util)"
            ,(string-append "  (use " name ")")
            ,(string-append "(select-module " name ".cli)")
            ""
            "(define runner"
            "  (lambda (args)"
            "    (let-args (cdr args)"
            "      ((#f \"h|help\" (usage 0))"
            "       . rest)"
            "      (when (null-list? rest)"
            "        (usage 0))"
            "      (match (car  rest)"
            "        ;; actions"
            "        (\"install\""
            "         (install (cadr rest)))"
            "        ((or \"uninstall\" \"rm\")"
            "         (uninstall (cadr rest)))"
            "        (\"setup\""
            "         (setup (cadr rest)))"
            "        (\"command\""
            "         (print-commands))"
            "        (_ (usage 0))))))"

            ))))))

(define (make-bin path)
  (let ((name (sys-basename path)))
    (display
      (tree->string
        (intersperse
          "\n"
          `("#!/usr/bin/env gosh"
            ""
            ,(string-append "(use " name ".cli :prefix cli:)")
            ""
            "(define (main args)"
            "  (cli:runner args))"
            ""
            ";; vim:filetype=scheme"))))))

(define (create name)
  (cond
    ((file-exists? name)
     (exit 1 "directory ~a exists!" name))
    (else
      (create-directory-tree
        (current-directory)
        (dir-spec name)))))
