(load "shell.scm")

(define scheme-dir (make-parameter "/home/teejay/thomas/programming/scheme"))
(define ++ string-append)

(load (++ (scheme-dir) "/network/network.scm"))