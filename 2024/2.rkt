#lang racket

(provide input
         part1
         part2)

(define args (vector->list (current-command-line-arguments)))

(define has-flag? (lambda (flag) (member flag args)))

(define filename
  (let ([non-flags (filter (lambda (arg) (not (string-prefix? arg "--"))) args)])
    (if (null? non-flags)
        "2024/2.txt"
        (first non-flags))))

(define input
  (with-input-from-file filename
                        (lambda ()
                          (for/list ([line (in-lines)])
                            (map string->number (string-split line))))))

(define (part1 input)
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
