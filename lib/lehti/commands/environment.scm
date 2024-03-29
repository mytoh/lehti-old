
;; -*- coding: utf-8 -*-

(define-module lehti.commands.environment
  (export
    environment)
  (use lehti)
  (use srfi-1)
  (use gauche.process)
  (use file.util))
(select-module lehti.commands.environment)

(define (environment)
  (display
    (string-join
      `("Lehti Environment:"
        ,(string-append "  - " (colour-string 93 "GAUCHE_VERSION") ": " (gauche-version) " [" (gauche-architecture) "]")
        ,(string-append "  - " (colour-string 109 "INSTALLATION DIRECTORY") ": "  (*lehti-directory*))
        ,(string-append "  - " (colour-string 44 "GAUCHE EXECUTABLE") ": " (find-file-in-paths "gosh"))
        ,(string-append "  - " (colour-string 60 "EXECUTABLE DIRECTORY") ": " (sys-dirname (find-file-in-paths "gosh")))
        ,(string-append "  - " (colour-string 63 "LEHTI PLATFORMS") ":" )
        ,(string-append "    - " (sys-basename (find-file-in-paths "gosh")))
        ,(string-append "    - " (gauche-architecture))
        ,(string-append "  - " (colour-string 28 "LEHTI BIN PATHS") ":" )
        ,(string-append "     - " (*lehti-bin-directory*))
        ,(string-append "  - " (colour-string 128 "LEHTI LOAD PATHS") ":" )
        ,@(map
            (lambda (path)
              (string-append
                "     - " path))
            (make-load-path))
        )
      "\n"
      'suffix))
  )


(define (make-load-path)
  (append
    (remove null?
            (map
              (lambda (e)
                (let ((share-lib-path (build-path e "share/gauche-0.9/site/lib")))
                  (cond
                    ((file-exists? share-lib-path)
                     share-lib-path)
                    ((and (file-exists? (build-path e "lib"))
                       (not (file-exists? (build-path e "lib/gauche-0.9"))))
                     (build-path e "lib"))
                    (else
                      '()))))
              (directory-list (*lehti-dist-directory* ) :add-path? #t :children? #t)))))

