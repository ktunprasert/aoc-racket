#lang racket

(provide lists
         part1
         part2)

(define args (vector->list (current-command-line-arguments)))

(define has-flag? (lambda (flag) (member flag args)))

(define filename
  (let ([non-flags (filter (lambda (arg) (not (string-prefix? arg "--"))) args)])
    (if (null? non-flags)
        "2024/1.txt"
        (first non-flags))))

(define lists
  (with-input-from-file filename
                        (lambda ()
                          (for/lists (a b #:result (list (sort a <) (sort b <)))
                                     ([x (in-port)] [y (in-port)])
                                     (values x y)))))

(define (part1 lists)
  (apply foldl (lambda (a b dist) (+ dist (abs (- a b)))) 0 lists))
(define (part2 lists)
  (foldl (λ (x z) (+ (* x (count (curry = x) (second lists))) z)) 0 (first lists)))

(when (has-flag? "--output")
  (printf "Lists: ~a~n" lists))

(if (has-flag? "--time")
    (begin
      (printf "Part 1: ")
      (time (displayln (part1 lists)))
      (printf "Part 2: ")
      (time (displayln (part2 lists))))
    (begin
      (displayln (part1 lists))
      (displayln (part2 lists))))
