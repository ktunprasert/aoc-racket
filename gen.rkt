#lang racket

(define args (vector->list (current-command-line-arguments)))

(when (< (length args) 2)
  (error "Usage: racket gen.rkt <year> <day>"))

(define year (first args))
(define day (second args))

(define output-file (format "~a/~a.rkt" year day))

(define template
  (format
   "#lang racket

(provide input
         part1
         part2)

(define args (vector->list (current-command-line-arguments)))

(define has-flag? (lambda (flag) (member flag args)))

(define filename
  (let ([non-flags (filter (lambda (arg) (not (string-prefix? arg \"--\"))) args)])
    (if (null? non-flags)
        \"~a/~a.txt\"
        (first non-flags))))

(define input
  (with-input-from-file filename
    (lambda ()
      (for/list ([line (in-lines)])
        line))))

(define (part1 input)
  \"TODO: Implement part 1\")

(define (part2 input)
  \"TODO: Implement part 2\")

(when (has-flag? \"--output\")
  (printf \"Input: ~~a~~n\" input))

(if (has-flag? \"--time\")
    (begin
      (printf \"Part 1: \")
      (time (displayln (part1 input)))
      (printf \"Part 2: \")
      (time (displayln (part2 input))))
    (begin
      (displayln (part1 input))
      (displayln (part2 input))))
"
   year
   day))

; Create directory if it doesn't exist
(unless (directory-exists? year)
  (make-directory year))

; Write the file
(with-output-to-file output-file (lambda () (display template)))

(printf "Generated ~a~n" output-file)
