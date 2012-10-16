
;; -*- coding: utf-8 -*-

(define-module lehti.commands.readme
  (export readme)
  (use lehti)
  (use file.util)
  (use util.list)
  (use text.tree)
  (use util.match)
  (use gauche.parseopt)
  (use gauche.process))
(select-module lehti.commands.readme)


(define (find-readme path)
  (directory-list path
                  :children? #t
                  :add-path? #t
                  :filter (lambda (e) (#/readme.*/i e))))

(define  (readme name)
  (let ((path (build-path ( *lehti-dist-directory* ) name)))
    (if (file-exists? path)
      (let ((readme  (find-readme path) ))
        (if (not (null? readme))
          (print (file->string (car readme)))  
          (print (string-append "no readme file"))
          ))
      (print (string-append "can't found " name)))))
