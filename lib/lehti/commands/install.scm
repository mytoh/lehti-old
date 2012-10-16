;; -*- coding: utf-8 -*-

(define-module lehti.commands.install
  (export install)
  (use lehti)
  (use lehti.commands.fetch)
  (use text.tree)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.install)



(define (generate-bin-file name)
  (if (file-exists? (build-path (*lehti-cache-directory*) name "bin"))
    (call-with-output-file
      (build-path (*lehti-directory*) "bin" name)
      (lambda (out)
        (display
          (string-join
              `( " \":\"; exec gosh -- $0 \"$@\""
                 ";; -*- coding: utf-8 -*-"
                 ""
                 "(use lehti)"
                 "(use file.util)"
                 "" 
                 ,#`"(load (build-path (*lehti-dist-directory*) \",|name|\" \"bin\" \",|name|\"))"
                 ";; vim:filetype=scheme")
              "\n"
              'suffix)
          out)))))

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
           (print (string-append
                    "installing "
                    (colour-string 12 package)))
           (let ((lehtifile (file->sexp-list (build-path (*lehti-leh-file-directory* )
                                                         (string-append package
                                                                        ".leh"))))
                 (cache-directory (build-path (*lehti-cache-directory* )
                                              package))
                 (prefix-directory  (build-path  (*lehti-dist-directory* )
                                                 package)))
             (let
               ((url  (cadr  (assoc 'url lehtifile)))
                (install-commands (assoc 'install lehtifile)))
               (cond
                 (install-commands
                   (current-directory (fetch url package))
                   (for-each
                     (lambda (c) (eval c (interaction-environment)))
                     (cadr install-commands))
                   (generate-bin-file package) 
                   (remove-directory* cache-directory)
                   )
                 (else
                   (current-directory (fetch url package))
                   (let ((cmd (cadr (assoc 'install (file->sexp-list (build-path cache-directory
                                                                                 (path-swap-extension package "leh")))))))
                     (for-each
                       (lambda (c) (eval c (interaction-environment)))
                       cmd))
                   (generate-bin-file package)     
                   (remove-directory* cache-directory)
                   )))))
          (else
            (print (string-append
                     "package "
                     (colour-string 12 package)
                     " is not available!")))))
      packages)))
