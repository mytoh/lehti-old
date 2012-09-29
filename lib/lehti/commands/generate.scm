

;; -*- coding: utf-8 -*-

(define-module lehti.commands.generate
  (export generate)
  (use lehti.env)
  (use file.util)
  (use util.list)
  (use text.tree)
  (use gauche.process))
(select-module lehti.commands.generate)


(define (dir-spec name cmds)
  `(,name
     ((bin ((,name ,make-bin)))
      (spec ((,(path-swap-extension name "spec.scm"))))
      (lib
        ((,(path-swap-extension name "scm") ,make-lib)
         (,name (("cli.scm" ,make-lib-cli)
                 (commands ,(if (null? cmds)
                              (command-list '("help") make-lib-commands-list)
                              (command-list cmds make-lib-commands-list)))
                 ("commands.scm" ,make-lib-commands))))))))

(define (make-lib-commands-list path)
  (let* ((cmd (sys-basename path))
        (name (sys-basename (sys-dirname (sys-dirname path))))
        (module (string-append name ".commands." cmd)))
  (display
    (tree->string
      (intersperse
        "\n"
        `(
          ,(string-append "(define-module " module)
          "  )"
          ,(string-append "(select-module " name ")")
          ))))))

(define (command-list lst proc)
  (map
    (lambda (e) (list (path-swap-extension e "scm") proc))
    lst))

(define (make-lib path)
  (let ((name (sys-basename (path-sans-extension path))))
  (display
    (tree->string
      (intersperse
        "\n"
        `(
          ,(string-append "(define-module " name)
          "  )"
          ))))))

(define (make-lib-cli path)
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
            ,(string-append "  (use " name ".commands)")
            "  )"
            ,(string-append "(select-module " name ".cli)")
            ""
            "(define runner"
            "  (lambda (args)"
            "    (let-args (cdr args)"
            "      ((#f \"h|help\" (exit 0))"
            "       . rest)"
            "      (when (null-list? rest)"
            "        (exit 0))"
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
            "        (_ (exit 0))))))"
            ""
            ))))))

(define (make-lib-commands path)
  (let* ((name (sys-basename (sys-dirname path)))
         (module (string-append name ".commands")))
    (display
      (tree->string
        (intersperse
          "\n"
          `(,(string-append "(define-module " module)
             "  )"
             ,(string-append "(select-module " module ")")
             ))))))

(define (make-bin path)
  (let ((name (sys-basename path)))
    (display
      (tree->string
        (intersperse
          "\n"
          `("#!/usr/bin/env gosh"
            ""
            "(add-load-path \"../lib\" :relative)"
            ,(string-append "(use " name ".cli :prefix cli:)")
            ""
            "(define (main args)"
            "  (cli:runner args))"
            ""
            ";; vim:filetype=scheme"))))))

(define (message name)
  (print
    (string-append "created app " name)))

(define (file->executable name)
  (let ((path (build-path (current-directory)
                          name "bin" name)))
    (run-process `(chmod +x ,path) :wait #t))
  )

(define (git-init dir)
  (current-directory dir)
  (run-process '(git init) :wait #t)
  )

(define (generate args)
  (let ((name (cadr args))
        (cmds (cddr args)))
  (cond
    ((file-exists? name)
     (exit 1 "directory ~a exists!" name))
    (else
      (message name)
      (create-directory-tree
        (current-directory)
        (dir-spec name cmds))
      (file->executable name)
      (print "initializing git")
      (git-init name)))))
