(use shell readline)

(current-input-port (make-gnu-readline-port))
(gnu-history-install-file-manager (string-append (or (getenv "HOME") ".") "/.csi.history"))
(repl-prompt (lambda () "$ "))

(define config-file (make-parameter (string-append (or (getenv "HOME") ".") "/.hintz-shellrc")))
(when (file-exists? (config-file))
  (load (config-file)))

(define exit? (make-parameter #f))
(define (exit) (exit? #t))

(define (shell-repl)
    (if (exit?)
        #t
        (let ((x (read)))
          (begin (handle-exceptions
                  exn
                  (handle-exceptions
                   exn
                   (begin (print-error-message exn)
                          (display (with-output-to-string (lambda () (print-call-chain)))))
                   (execute (list x)))
                  (display (eval x))
                  (newline))
                 (newline)
                 (shell-repl)))))

(shell-repl)