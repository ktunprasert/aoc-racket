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

(define (in-bound? pos)
  (and (>= (first pos) 0) (>= (second pos) 0) (< (first pos) pos-bound) (< (second pos) pos-bound)))

(define-values (N E S W) (values '(-1 0) '(0 1) '(1 0) '(0 -1)))

(define (turn delta)
  (cond
    [(eq? delta N) E]
    [(eq? delta E) S]
    [(eq? delta S) W]
    [(eq? delta W) N]))

(define (part1 _)
  (define visited (make-hash))
  (let loop ([current starting-pos]
             [delta N])
    (when (and (not (hash-has-key? obstacle-map current)) (in-bound? current))
      (hash-set! visited current #t))
    (cond
      [(not (in-bound? current)) 'exited]
      [(hash-has-key? obstacle-map current) (loop (map - current delta) (turn delta))]
      [else (loop (map + current delta) delta)]))
  (hash-count visited))

(define (part2 _)
  (define original-path '())
  
  ; Get the actual path taken (in order)
  (let loop ([current starting-pos]
             [delta N]
             [path '()])
    (cond
      [(not (in-bound? current)) (set! original-path (reverse path))]
      [(hash-has-key? obstacle-map current) 
       (loop (map - current delta) (turn delta) path)]
      [else 
       (loop (map + current delta) delta (cons current path))]))

  ; Function to check if adding obstacle at pos creates a loop
  (define (creates-loop? obstacle-pos)
    (define state-visited (make-hash))
    (hash-set! obstacle-map obstacle-pos 'wall)

    (define result
      (let loop ([current starting-pos]
                 [delta N]
                 [steps 0])
        (define state (list current delta))
        (cond
          [(> steps (* pos-bound pos-bound 4)) 'loop] ; Simple cycle detection
          [(hash-has-key? state-visited state) 'loop]
          [(not (in-bound? current)) 'exited]
          [else
           (hash-set! state-visited state #t)
           (if (hash-has-key? obstacle-map current)
               (loop (map - current delta) (turn delta) (add1 steps))
               (loop (map + current delta) delta (add1 steps)))])))

    (hash-remove! obstacle-map obstacle-pos)
    (eq? result 'loop))

  ; Only check positions that are on the original path (excluding start)
  (define candidates (remove-duplicates (filter (lambda (pos) (not (equal? pos starting-pos))) original-path)))
  
  (length (filter creates-loop? candidates)))

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
