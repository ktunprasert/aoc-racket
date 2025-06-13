#lang racket

(define args (vector->list (current-command-line-arguments)))

(define filename
  (if (null? args)
      "2024/1.txt"
      (first args)))

(time (define lists
        (with-input-from-file filename
                              (lambda ()
                                (for/lists (a b #:result (list (sort a <) (sort b <)))
                                           ([x (in-port)] [y (in-port)])
                                           (values x y)))))
      (displayln (apply foldl (lambda (a b dist) (+ dist (abs (- a b)))) 0 lists))
      (displayln (foldl (λ (x z) (+ (* x (count (curry = x) (second lists))) z)) 0 (first lists))))
