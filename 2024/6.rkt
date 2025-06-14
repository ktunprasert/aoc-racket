#lang racket

(provide input
         part1
         part2)

(define args (vector->list (current-command-line-arguments)))

(define has-flag? (lambda (flag) (member flag args)))

(define filename
  (let ([non-flags (filter (lambda (arg) (not (string-prefix? arg "--"))) args)])
    (if (null? non-flags)
        "2024/6.txt"
        (first non-flags))))

(define obstacle-map (make-hash))
(define starting-pos empty)
(define pos-bound 0)

(define input
  (time (display "Parsing took: ")
        (with-input-from-file filename
                              (lambda ()
                                (define x -1)
                                (for ([line (in-lines)]
                                      #:do [(set! x (add1 x)) (set! pos-bound (add1 pos-bound))])
                                  (define y -1)
                                  (for ([c line]
                                        #:do [(set! y (add1 y))]
                                        #:when (or (char=? #\^ c) (char=? #\# c)))
                                    (match c
                                      [#\# (hash-set! obstacle-map (list x y) 'wall)]
                                      [#\^ (set! starting-pos (list x y))])))))
        obstacle-map))

(define-values (N E S W) (values '(-1 0) '(0 1) '(1 0) '(0 -1)))

(define (in-bound? pos)
  (and (positive-integer? (first pos))
       (positive-integer? (second pos))
       (< (first pos) pos-bound)
       (< (second pos) pos-bound)))

(define (part1 input)
  (define visited (make-hash))

  ;; (printf "\nobs ~a starting ~a\n" obstacle-map starting-pos)
  ;; (define facing N)
  ;; (define starting starting-pos)
  (displayln pos-bound)
  (let loop ([current starting-pos]
             [delta N])
    ;; (cond
    ;;   [(hash-ref  )]
    ;;   )
    1)

  "TODO: Implement part 1")

(define (part2 input)
  "TODO: Implement part 2")

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
