(import chicken scheme)
(use chicken-syntax)

(print (eval `(begin (import chicken) ,(read))))
