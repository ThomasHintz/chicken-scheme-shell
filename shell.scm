(use shell)
(include "../macs/general-macs.scm")

(define-syntax mk-shell-cmd
  (syntax-rules ()
    ((mk-shell-cmd cmd)
     (define-syntax cmd
       (syntax-rules ()
         ((cmd . r)
          (execute '((cmd . r)))))))))

(mac-apply mk-shell-cmd ls pwd cat rm touch cd ps grep kill killall mkdir mv top alsamixer nano emacs git)