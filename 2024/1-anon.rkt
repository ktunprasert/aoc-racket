#lang racket

(time
 (define lists
   (for/lists (a b #:result (list (sort a <) (sort b <))) ([x (in-port)] [y (in-port)]) (values x y)))
 (displayln (apply foldl (λ (a b r) (+ r (abs (- a b)))) 0 lists))
 (displayln (foldl (λ (x z) (+ (* x (count (curry = x) (second lists))) z)) 0 (first lists))))
