#lang racket

(define args (vector->list (current-command-line-arguments)))

(define filename
  (if (null? args)
      "2024/1.txt"
      (first args)))

(define lists
  (with-input-from-file filename
    (lambda ()
      (for/lists (a b #:result (list (sort a <) (sort b <)))
                 ([x (in-port)] [y (in-port)])
                 (values x y)))))

(define part1 (apply foldl (lambda (a b dist) (+ dist (abs (- a b)))) 0 lists))
(define part2 (foldl (λ (x z) (+ (* x (count (curry = x) (second lists))) z)) 0 (first lists)))

(displayln part1)
(displayln part2)
