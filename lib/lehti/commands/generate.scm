

;; -*- coding: utf-8 -*-

(define-module lehti.commands.generate
  (export generate)
  (use lehti)
  (use file.util)
  (use util.list)
  (use text.tree)
  (use util.match)
  (use gauche.parseopt)
  (use gauche.process))
(select-module lehti.commands.generate)


(define (dir-spec name cmds)
  `(,name
     (readme.rst
      ,(path-swap-extension name "leh")
      (bin ((,name ,make-bin)))
      (src
        ((,name ((core.scm ,make-src-core)
                 (cli.scm ,make-src-cli)
                 (test ((test.scm)))
                 (commands ,(if (null? cmds)
                              (command-list '("help") make-src-commands-list)
                              (command-list cmds make-src-commands-list)))
                 (commands.scm ,make-src-commands))))))))

(define (make-src-commands-list path)
  (let* ((cmd (sys-basename (path-sans-extension path)))
         (name (sys-basename (sys-dirname (sys-dirname path))))
         (module (string-append name ".commands." cmd)))
    (display
      (tree->string
        (intersperse
          "\n"
          `(,(string-append "(define-module " module)
             "  (use gauche.parseopt)"
             "  (use gauche.process)"
             "  (use util.match)"
             "  )"
             ,(string-append "(select-module " module ")")))))))

(define (command-list lst proc)
  (map
    (lambda (e) (list (path-swap-extension e "scm") proc))
    lst))

(define (make-src-core path)
  (let* ((name (sys-basename (sys-dirname path)))
         (module (string-append name ".core")))
    (display
      (tree->string
        (intersperse
          "\n"
          `(,(string-append "(define-module " module)
             "  )"
             ,(string-append "(select-module " module ")")))))))

(define (make-src-cli path)
  (let ((name (sys-basename (sys-dirname path))))
    (display
      (tree->string
        (intersperse
          "\n"
          `(,(string-append "(define-module " name ".cli")
             "  (export runner)"
             "  (use gauche.parseopt)"
             "  (use util.match)"
             "  (use file.util)"
             ,(string-append "  (use " name ".core)")
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
             "        (\"help\""
             "         (help))"
             "        (_ (exit 0))))))"
             ""))))))

(define (make-src-commands path)
  (let* ((name (sys-basename (sys-dirname path)))
         (module (string-append name ".commands")))
    (display
      (tree->string
        (intersperse
          "\n"
          `(,(string-append "(define-module " module)
             "  )"
             ,(string-append "(select-module " module ")")))))))

(define (make-bin path)
  (let ((name (sys-basename path)))
    (display
      (tree->string
        (intersperse
          "\n"
          `("#!/usr/bin/env gosh"
            ""
            "(add-load-path \"../src\" :relative)"
            ,(string-append "(use " name ".cli :prefix cli:)")
            ""
            "(define (main args)"
            "  (cli:runner args))"
            ""
            ";; vim:filetype=scheme"))))))

(define (message name)
  (print
    (string-append "created new app in: " name)))

(define (file->executable name)
  (let ((path (build-path (current-directory)
                          name "bin" name)))
    (run-process `(chmod +x ,path) :wait #t)))

(define (git-init dir)
  (current-directory dir)
  (run-process '(git init) :wait #t))


(define (project args)
  (let ((name (car args))
        (cmds (cdr args)))
    (cond
      ((file-exists? name)
       (exit 1 "directory ~a exists!" name))
      (else
        (message name)
        (create-directory-tree
          (current-directory)
          (dir-spec name cmds))
        (file->executable name)
        (git-init name))))
  )

(define (help status)
  (exit status "lehti generate: ~a <command> <package-name>\n" "lehti"))

(define (generate args)
  (match (cadr args)
    ("project"
     (project (cddr args)))))




