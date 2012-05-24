;;; documentation at http://thintz.com/chicken-scheme-shell
(use readline symbol-utils)

(define (getenv2 e)
 ;; handles exorcism of getenv from 4.6.4 onwards
 (handle-exceptions
  exn
  (get-environment-variable e)
  (getenv e)))

(current-input-port (make-gnu-readline-port))
(gnu-history-install-file-manager
 (string-append (or (getenv2 "HOME") ".") "/.csi.history"))
(repl-prompt (lambda () "$ "))

(define config-file
 (make-parameter (string-append (or (getenv2 "HOME") ".") "/.hintz-shellrc")))
(when (file-exists? (config-file))
  (load (config-file)))

(define exit? (make-parameter #f))
(define (exit) (exit? #t))

; now we can can actually use things in a more lispy way
; #;1> (cmd->list "ls" read-line)
; (file1 file2 file3)
; #;2> (map (lambda (file) (run (string-append "cat " file)))
;             (cmd->list "ls" read-line))
; ...contents of all the files in the current directory
(define (cmd->list cmd read-func)
  (with-input-from-pipe
   cmd
   (lambda ()
     (letrec ((get-next (lambda (o)
			  (let ((v (read-func)))
			    (if (not (eof-object? v))
				(get-next (cons v o))
				(reverse o))))))
       (get-next '())))))

(define (run cmd) (process-wait (process-run cmd)))

(define (shell-repl)
  (if (exit?)
       #t
       (let ((x (read)))
	 (handle-exceptions
	  exn
	  (begin (print-error-message exn)
		 (display (with-output-to-string (lambda () (print-call-chain)))))
	  (if (unbound? x)
	      (run (symbol->string x))
	      (display (eval x)))
	  (newline))
	 (shell-repl))))

(shell-repl)
