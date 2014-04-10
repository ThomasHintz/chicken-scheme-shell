(import chicken scheme)
(use parley parley-auto-completion srfi-1 apropos posix)

(set-read-syntax!
 #\[
 (lambda (port)
   (letrec ((read-cmd (lambda (cmd)
                        (let ((c (peek-char port)))
                          (cond ((eof-object? c)
                                 (error "EOF encountered while parsing { ... } clause"))
                                ((char=? c #\])
                                 (read-char port)
                                 cmd)
                                ((or (char=? c #\') (char=? c #\())
                                 (read-cmd (string-append cmd (->string (eval (read port))))))
                                (else
                                 (read-char port)
                                 (read-cmd (string-append cmd (->string c)))))))))
     `(begin (let ((result (with-input-from-pipe ,(read-cmd "") read-lines)))
               ;(for-each (cut print <>) result)
               (for-each (lambda (l) (print l)) result)
               (values #t result))))))

; match (foo or foo
(word-class '($ (: (& (~ "(") (~ whitespace)) (+ (~ whitespace)))))

(define (get-completions)
  (map (lambda (s) (string-append (symbol->string s) " ")) (delete-duplicates! (apropos-list "" macros?: #t))))

(completion-choices (lambda (input position last-word) (get-completions)))

(add-key-binding! #\tab auto-completion-handler)

(let ((old (current-input-port)))
     (current-input-port (make-parley-port old)))

(define exit? (make-parameter #f))
(define (exit) (exit? #t))

(define line-num (make-parameter 0))
(define repl-prompt (make-parameter (lambda () (string-append "#;" (number->string (line-num)) "> "))))

(define config-file
 (make-parameter (string-append (or (get-environment-variable "HOME") ".") "/.hiss")))
(when (file-exists? (config-file))
  (load (config-file)))

(define (shell-repl)
  (if (exit?)
      #t
      (begin (handle-exceptions
	      exn
	      (begin (print-error-message exn)
		     (display (with-output-to-string (lambda () (print-call-chain)))))
	      (let ((x (with-input-from-string (parley ((repl-prompt))) (lambda () (read)))))
		(write (eval x))
                (line-num (+ (line-num) 1))))
	     (newline)
	     (shell-repl))))

(shell-repl)
