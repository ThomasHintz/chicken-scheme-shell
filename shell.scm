(use shell)

(define (shell-repl)
  (let ((x (read)))
    (if (eq? x 'exit)
        #t
        (begin (execute (list x))
               (newline)
               (display "#;> ")
               (shell-repl)))))

(shell-repl)