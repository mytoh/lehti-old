;; -*- coding: utf-8 -*-

(define-module lehti.commands.install
  (export install)
  (use lehti)
  (use lehti.commands.fetch)
  (use text.tree)
  (use file.util)
  (use util.list)
  (use gauche.process))
(select-module lehti.commands.install)


(define (generate-bin-file name)
  (if (file-exists? (build-path (*lehti-dist-directory*) name "bin"))
    (call-with-output-file
      (build-path (*lehti-directory*) "bin" name)
      (lambda (out)
        (display
          (string-join
            `(" \":\"; exec gosh -- $0 \"$@\""
              ";; -*- coding: utf-8 -*-"
              ""
              "(use lehti)"
              "(use file.util)"
              ""
              ,#`"(load (build-path (*lehti-dist-directory*) \",|name|\" \"bin\" \",|name|\"))"
              ";; vim:filetype=scheme")
            "\n"
            'suffix)
          out)
        (sys-chmod (build-path (*lehti-dist-directory*) name "bin" name) #o755)
        (sys-chmod (build-path (*lehti-directory*) "bin" name) #o755)
        ))))

(define (install-leh-package-files package-name file-list)
  (let ((files (map glob file-list)))
    (for-each
      (lambda (l)
        (when (not (null? l))
          (for-each
            (lambda (file)
              (if (file-is-directory? file)
                (make-directory* file)
                (let ((dir (build-path (*lehti-dist-directory*) package-name (sys-dirname file))))
                  (make-directory* dir)
                  (copy-file file
                             (build-path (*lehti-dist-directory*) package-name file)))))
            l)))
      files)))

(define-method install-dependencies ((self <lehspec>))
  (let ((deps (ref self 'dependencies)))
    (when deps
      (unless (every package-is-installed? deps)
        (install deps)))))

(define (install-leh-package package)
  (let* ((cache-directory (build-path (*lehti-cache-directory* )
                                      package))
         (lehspec (eval  (car (file->sexp-list (build-path cache-directory (path-swap-extension package "lehspec")))) (interaction-environment))))
    (install-dependencies lehspec)
    (ohei "installing " (colour-string (colour-package) package))
    (install-leh-package-files package (ref lehspec 'files))
    (generate-bin-file package)
    (remove-directory* cache-directory)))

(define  (install-gauche-package package commands)
  (let ((cache-directory (build-path (*lehti-cache-directory* )
                                     package)))
    (ohei "installing " (colour-string (colour-package) package))
    (for-each
      (lambda (c) (eval c (interaction-environment)))
      (cadr commands))
    (generate-bin-file package)
    (remove-directory* cache-directory)))

(define install
  (lambda (packages)
    (for-each
      (lambda (package)
        (cond
          ((package-is-installed? package)
           (oai (colour-string (colour-package) package)
                " is already installed"))
          ((package-is-available? package)
           (let ((lehtifile (file->sexp-list (build-path (*lehti-leh-file-directory* )
                                                         (string-append package
                                                                        ".leh"))))
                 (cache-directory (build-path (*lehti-cache-directory* )
                                              package))
                 (prefix-directory  (build-path  (*lehti-dist-directory* )
                                                 package)))
             (let ((url  (cadr  (assoc 'url lehtifile)))
                   (install-commands (assoc 'install lehtifile)))
               (current-directory (fetch url package))
               (cond
                 (install-commands
                   (install-gauche-package package install-commands))
                 (else
                   (install-leh-package package))))))
          (else
            (oai "package " (colour-string (colour-package) package)
                 " is not available!"))))
      packages)))
