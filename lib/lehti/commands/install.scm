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

(define (install-files package-name file-list)
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

(define-method install-dependencies ((self <lespec>))
  (let ((deps (ref spc 'dependencies)))
    (when deps
      (install deps))))

(define install
  (lambda (packages)
    (for-each
      (lambda (package)
        (cond
          ((package-is-installed? package)
           (print (string-append
                    (colour-string 12 package)
                    " is already installed!")))
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
                   (print (string-append
                            "installing "
                            (colour-string 12 package)))
                   (for-each
                     (lambda (c) (eval c (interaction-environment)))
                     (cadr install-commands))
                   (generate-bin-file package)
                   (remove-directory* cache-directory))
                 (else
                   (let ((lehspec (eval  (car (file->sexp-list (build-path cache-directory (path-swap-extension package "lehspec")))) (interaction-environment))))
                     (install-dependencies lehspec)
                     (print (string-append
                              "installing "
                              (colour-string 12 package)))
                     (install-files package (ref lehspec 'files))
                     (generate-bin-file package)
                     (remove-directory* cache-directory)))))))
          (else
            (print (string-append
                     "package "
                     (colour-string 12 package)
                     " is not available!")))))
      packages)))
