#lang racket

(provide :input
         part1
         part2)

(require threading)

(define args (vector->list (current-command-line-arguments)))

(define has-flag? (lambda (flag) (member flag args)))

(define filename
  (let ([non-flags (filter (lambda (arg) (not (string-prefix? arg "--"))) args)])
    (if (null? non-flags)
        "2024/4.txt"
        (first non-flags))))

(define :input
  (time (display "Parsing took: ")
        (with-input-from-file filename
                              (lambda ()
                                (for/vector ([line (in-lines)])
                                  (~> line string->list list->vector))))))

(define (in-bound v)
  (not (or (negative-integer? v) (>= v (vector-length :input)))))

(define-values (NW N NE W E SE S SW)
  (values '(-1 -1) '(-1 0) '(-1 1) '(0 -1) '(0 1) '(1 -1) '(1 0) '(1 1)))

;NW N NE
;W _ E
;SE S SW
(define deltas (list NW N NE E SE S W SW))
;; (define token (string->list "XMAS"))

(define (grid-at x y)
  (~> :input (vector-ref _ x) (vector-ref _ y)))

(define (word-search x y dx dy)
  (let* ([x (+ x dx)]
         [y (+ y dy)]
         [seq-x (if (zero? dx)
                    (in-cycle (in-value x)) ; cycle just x
                    (in-range x (+ x (* 3 dx)) dx))] ; proper range
         [seq-y (if (zero? dy)
                    (in-cycle (in-value y)) ; cycle just y
                    (in-range y (+ y (* 3 dy)) dy))]) ; proper range

    (for/and ([should "MAS"]
              [cx seq-x]
              [cy seq-y])
      (if (andmap in-bound (list cx cy))
          (char=? (grid-at cx cy) should)
          #f))))

(define (part1 input)
  (for*/sum ([(row x) (in-indexed input)] [(c y) (in-indexed row)] #:when (char=? #\X c))
            (count (λ (d) (word-search x y (first d) (second d))) deltas)))

(define (diag-search x y)
  (if (and (in-bound x) (in-bound y))
      (let* ([top-left (grid-at (- x 1) (- y 1))]
             [top-right (grid-at (- x 1) (+ y 1))]
             [bottom-left (grid-at (+ x 1) (- y 1))]
             [bottom-right (grid-at (+ x 1) (+ y 1))]
             [diag1 (list top-left bottom-right)]
             [diag2 (list top-right bottom-left)])
        ;; Check if both diagonals form "MAS" or "SAM"
        (and (or (equal? diag1 '(#\M #\S)) (equal? diag1 '(#\S #\M)))
             (or (equal? diag2 '(#\M #\S)) (equal? diag2 '(#\S #\M)))))
      #f))

(define (part2 input)
  ;; lets just grid scan 3x3 everywhere fuck it im lazy
  (define len (vector-length input))
  (for*/sum ([x (in-range 1 (sub1 len))] [y (in-range 1 (sub1 len))]
                                         #:when (char=? #\A (grid-at x y)))
            (if (diag-search x y) 1 0)))

(when (has-flag? "--output")
  (printf "Input: ~a~n" :input))

(if (has-flag? "--time")
    (begin
      (printf "Part 1: ")
      (time (displayln (part1 :input)))
      (printf "Part 2: ")
      (time (displayln (part2 :input))))
    (begin
      (displayln (part1 :input))
      (displayln (part2 :input))))
