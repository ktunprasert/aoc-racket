#lang racket

(provide input
         part1
         part2)

(require parser-tools/lex)
(require threading)

(define args (vector->list (current-command-line-arguments)))

(define has-flag? (lambda (flag) (member flag args)))

(define filename
  (let ([non-flags (filter (lambda (arg) (not (string-prefix? arg "--"))) args)])
    (if (null? non-flags)
        "2024/5.txt"
        (first non-flags))))

(define the-lexer
  (lexer [(eof) eof]
         [(concatenation (repetition 2 2 numeric) "|" (repetition 2 2 numeric))
          (let* ([nums (string-split lexeme "|")]) (map string->number nums))]
         [(concatenation (repetition 2 2 numeric)
                         (repetition 0 24 (concatenation "," (repetition 2 2 numeric))))
          (map string->number (string-split lexeme ","))]
         [any-char (the-lexer input-port)]))

(define input
  (time (display "Parsing took: ")
        (with-input-from-file filename
                              (λ ()
                                (let loop ([result '()])
                                  (let ([token (the-lexer (current-input-port))])
                                    (cond
                                      [(eof-object? token) (reverse (group-by length result))]
                                      [(list? token) (loop (cons token result))]
                                      [else (loop result)])))))))

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
