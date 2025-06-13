#lang racket

(provide input
         part1
         part2)

(require threading)

(define args (vector->list (current-command-line-arguments)))

(define has-flag? (lambda (flag) (member flag args)))

(define filename
  (let ([non-flags (filter (lambda (arg) (not (string-prefix? arg "--"))) args)])
    (if (null? non-flags)
        "2024/2.txt"
        (first non-flags))))

(define input
  (with-input-from-file filename
                        (λ ()
                          (for/list ([line (in-lines)])
                            (map string->number (string-split line))))))

(define (safe? lst)
  (and (andmap (λ (n) (and (<= (abs n) 3) (>= (abs n) 1))) lst)
       (or (andmap negative-integer? lst) (andmap positive-integer? lst))))

(define (to-diff lst)
  (foldl (λ (a b l) (cons (- a b) l)) empty (drop lst 1) (drop-right lst 1)))

(define part1 (curry count (compose safe? to-diff)))

(define part2
  (curry count
         (lambda (lst)
           (for/or ([l (in-combinations lst (sub1 (length lst)))])
             (~> l to-diff safe?)))))

(when (has-flag? "--output")
  (printf "Input: ~a~n" input))

(if (has-flag? "--time")
    (begin
      (printf "Part 1: ")
      (time (displayln (part1 input)))
      (printf "Part 2: ")
      (time (displayln (part2 input))))
    (begin
      (displayln (part1 input))
      (displayln (part2 input))))
