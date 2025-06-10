#lang racket

(define _example1 "3   4
4   3
2   5
1   3
3   9
3   3
")

(define input1 (file->string "1.txt"))

(define (solve1 s)
  (define parsed (map string->number (string-split s #px"\\s+|\n")))
  (define l empty)
  (define r empty)

  (do ()
      ((empty? parsed) (set!-values (l r) (values (sort l <) (sort r <))))
      (match-let ([(list a b) (take parsed 2)])
        (set! l (cons a l))
        (set! r (cons b r))
        (set! parsed (drop parsed 2))))

  (for/sum ([l l] [r r]) (abs (- l r))))

(solve1 input1)
