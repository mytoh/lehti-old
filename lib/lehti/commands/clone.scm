

;; -*- coding: utf-8 -*-

(define-module lehti.commands.clone
  (export clone)
  (use lehti)
  (use file.util)
  (use gauche.process))
(select-module lehti.commands.clone)


(define (clone name)
  (cond
    ((package-is-available? name)
     (let* ((lehfile (file->sexp-list (build-path (*lehti-leh-file-directory*)
                                (path-swap-extension name "leh"))))
            (url (cadr (assoc 'url lehfile))))
       (cond
         ((url-is-git? url)
          (ohei "cloning from " url)
          (run-process `(git clone -q ,url ,name) :wait #t))
         (else
           (oai "not supported url"))
         )))
    (else
      (oai "no such package " name)))
  )
