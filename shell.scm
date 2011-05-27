(use shell readline regex)

(current-input-port (make-gnu-readline-port))
(gnu-history-install-file-manager (string-append (or (getenv "HOME") ".") "/.csi.history"))

(define (shell-repl)
  (let ((x (read)))
    (if (eq? x 'exit)
        #t
        (begin (execute (list x))
               (newline)
               (shell-repl)))))

(shell-repl)