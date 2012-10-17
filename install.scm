(use file.util)
(use gauche.process)

(define *lehti-directory*
  (if (sys-getenv "LEHTI_DIR")
    (sys-getenv "LEHTI_DIR")
    (build-path (home-directory)
                ".lehti")))

(define install
  (lambda ()
    (print "cloning repository")
    (run-process `(git clone git://github.com/mytoh/lehti ,*lehti-directory*) :wait #t)

    (print "creating dist directory")
    (make-directory* (build-path *lehti-directory* "dist"))

    (print "make executable")
    (sys-chmod (build-path *lehti-directory* "bin/leh") #o755)

    (newline)
    ))


(define (main args)
  (cond
    ((file-exists? *lehti-directory*)
     (print "please remove %s directory " (sys-getenv "LEHTI_DIR")))
    (else
      (install))))
