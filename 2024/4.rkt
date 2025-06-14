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
  (let* ([x (+ x dx)]
         [y (+ y dy)]
         [seq-x (if (zero? dx)
                    (in-cycle (in-list (list x))) ; cycle just x
                    (in-range x (+ x (* 3 dx)) dx))] ; proper range
         [seq-y (if (zero? dy)
                    (in-cycle (in-list (list y))) ; cycle just y
                    (in-range y (+ y (* 3 dy)) dy))]) ; proper range

    (for/fold ([ok? #t])
              ([should "MAS"]
               [cx seq-x]
               [cy seq-y]
               ;; #:when (and (not (negative)))
               ;; #:when (~> (values (negative-integer? cx) (negative-integer? cy)) or not))
               ;; #:when (~> (or (negative-integer? cx) (negative-integer? cy) (<)) not))
               ;; #:when (~> (list cx cy) (apply in-bound _)))
               #:when (~> (list cx cy) (andmap in-bound _)))
      ;; #:final (not ok?)
      #:break (not ok?)
      ;; (displayln (list "coords:" cx cy "expected:" should "ok?" ok?))
      ;; (displayln (list "grid-at:" (grid-at cx cy)))
      (char=? (grid-at cx cy) should))))

(define (part1 input)
  ;; (displayln input)
  ;; (displayln (grid-at 0 5))
  ;; (displayln (word-search 0 5 0 -1))
  ;; for*/fold
  ;; match-for
  (for*/fold ([sum 0])
             ([(row x) (in-indexed input)]
              [(c y) (in-indexed row)]
              #:when (char=? #\X c))
    ;; (displayln (list c x y))
    ;; (displayln deltas)
    (displayln (count (λ (d)
                        ;; (displayln d)
                        (word-search x y (first d) (second d)))
                      deltas))
    (+ sum
       (count (λ (d)
                ;; (displayln d)
                (word-search x y (first d) (second d)))
              deltas))
    ;; (displayln (list c x))
    ;; sum)
    )

  )

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
