(define-syntax _ (syntax-rules () ((_ . cmd) (run (fold (lambda (e o) (string-append o " " (->string e))) "" 'cmd)))))
(define-syntax _rl (syntax-rules () ((_rl . cmd) (cmd->list (fold (lambda (e o) (string-append o " " (->string e))) "" 'cmd) read-line))))
(define-syntax _rc (syntax-rules () ((_rc f . cmd) (cmd->list (fold (lambda (e o) (string-append o " " (->string e))) "" 'cmd) 'f))))