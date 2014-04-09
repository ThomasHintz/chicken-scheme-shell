(use parley parley-auto-completion srfi-1)
(import foreign)

(use parley readline)
(let ((old (current-input-port)))
     (current-input-port (make-parley-port old)))

(word-class '($ (: (& (~ "(") (~ whitespace)) (+ (~ whitespace)))))
; (completion-list '("string-append " "foobar "))
(define foo '())
(completion-choices
 (lambda (input position last-word)
   (let* ((result '())
          (symbols (car (map (lambda (pair) ((cdr pair) "")) (gnu-readline-completions)))))
     (let loop ()
       (let ((next (symbols)))
         (if (any (cut string=? <> next) result)
           result
           (begin (set! result (cons next result)) (loop)))))
     (set! result (lset-union string=?
                              result
                              (map (lambda (s) (symbol->string (car s))) (##sys#macro-environment))))
     (map (cut string-append <> " ") result))))
   ;; (if (symbol? (string->symbol last-word))
       ;(map (lambda (s) (string-append (symbol->string (car s)) " ")) (##sys#macro-environment))))
;   '("string-append" "strs" "foobar")))

(add-key-binding! #\tab auto-completion-handler)
