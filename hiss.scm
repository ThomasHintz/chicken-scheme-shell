(import chicken scheme)
(use parley parley-auto-completion srfi-1 apropos posix chicken-syntax scsh-process)

; match (foo or foo
(word-class '($ (: (& (~ (or "(" "[")) (~ whitespace)) (+ (~ whitespace)))))

(define (get-scheme-completions)
  (map (lambda (s)
         (string-append s " "))
       (delete-duplicates!
        (map (lambda (sym)
               (let ((string-sym (symbol->string sym)))
                 (if (not (substring-index "#" string-sym))
                          string-sym
                          (cadr (string-split string-sym "#")))))
             (apropos-list "" macros?: #t)))))

(define (get-shell-completions)
  (let ((paths (string-split (get-environment-variable "PATH") ":")))
    (delete-duplicates!
     (flatten
      (map (lambda (files) (map (cut string-append <> " ") files))
           (map (cut directory <>) paths))))))

(completion-choices (lambda (input position last-word)
                      (let* ((full-line (string-append input last-word))
                             (paren-pos (or (substring-index "(" full-line) -1))
                             (bracket-pos (or (substring-index "[" full-line) -1)))
                        (if (> paren-pos bracket-pos)
                            (get-scheme-completions)
                            (get-shell-completions)))))

(add-key-binding! #\tab auto-completion-handler)

(let ((old (current-input-port)))
     (current-input-port (make-parley-port old)))

(define exit? (make-parameter #f))
(define (exit) (exit? #t))

(define line-num (make-parameter 0))
(define repl-prompt (make-parameter (lambda () (string-append "#;" (number->string (line-num)) "> "))))

(define config-file
 (make-parameter (string-append (or (get-environment-variable "HOME") ".") "/.hiss")))

(define (shell-repl)
  (if (exit?)
      #t
      (begin (handle-exceptions
              exn
              (begin (print-error-message exn)
                     (display (with-output-to-string (lambda () (print-call-chain)))))
              (let ((x (with-input-from-string (parley ((repl-prompt))) (lambda () (read)))))
                (write (eval x))))
             (newline)
             (shell-repl))))

(begin
  (when (file-exists? (config-file))
        (load (config-file)))
  (shell-repl))
