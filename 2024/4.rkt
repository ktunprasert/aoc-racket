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

;NW N NE
;W _ E
;SE S SW
(define deltas '((-1 -1) (-1 0) (-1 1) (0 -1) (0 1) (1 -1) (1 0) (1 1)))
(define token (string->list "XMAS"))

(define (grid-at x y)
  (~> :input (vector-ref _ x) (vector-ref _ y)))

; pos (0 0)
; delta (0 0)
(define (word-search x y dx dy)
  ;; (displayln (list "word-search at:" x y "dx:" dx "dy:" dy))
  (let* ([x (+ x dx)]
         [y (+ y dy)]
         [seq-x (if (zero? dx)
                    (in-cycle (in-value x)) ; cycle just x
                    (in-range x (+ x (* 3 dx)) dx))] ; proper range
         [seq-y (if (zero? dy)
                    (in-cycle (in-value y)) ; cycle just y
                    (in-range y (+ y (* 3 dy)) dy))]) ; proper range

    (let ([val (for/and ([should "MAS"]
                         [cx seq-x]
                         [cy seq-y])
                 (if (andmap in-bound (list cx cy))
                     (char=? (grid-at cx cy) should)
                     #f))])
      ;; (displayln (list "word-search result:" val))
      val)))

(define (part1 input)
  ;; (displayln input)
  ;; (displayln (grid-at 0 5))
  ;; (displayln (word-search 0 5 0 -1))

  ;; (displayln (count (λ (d) (word-search 0 5 (first d) (second d))) deltas))
  ;; for*/fold
  ;; match-for

  (for*/fold ([sum 0])
             ([(row x) (in-indexed input)]
              [(c y) (in-indexed row)]
              #:when (char=? #\X c))
    ;; sum
    ;; (displayln (list c x y "count:" (count (λ (d) (word-search x y (first d) (second d))) deltas)))
    ;; (displayln)
    (+ sum
       (count (λ (d)
                ;; (displayln d)
                (word-search x y (first d) (second d)))
              deltas))
    ;; (displayln (list c x))
    ;; sum)
    ))

(define (part2 input)
  "TODO: Implement part 2")

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
