#lang racket

(define args (vector->list (current-command-line-arguments)))

(when (< (length args) 2)
  (error "Usage: racket main.rkt <year> <day> [input-file]"))

(define year (first args))
(define day (second args))
(define input-file (if (> (length args) 2)
                       (third args)
                       (format "~a/~a.txt" year day)))

(define day-module (format "~a/~a.rkt" year day))

(printf "Loading ~a with input ~a~n" day-module input-file)

; Set up the input file for the day module to use
(parameterize ([current-command-line-arguments (vector input-file)])
  ; Common symbols to try timing from AOC solutions
  (define symbols-to-time '(lists part1 part2))

  (for ([sym symbols-to-time])
    (with-handlers ([exn:fail? (lambda (_e) #f)])
      (printf "Timing ~a:~n" sym)
      (time (dynamic-require day-module sym))
      (newline))))
