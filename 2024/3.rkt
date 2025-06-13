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
        "2024/3.txt"
        (first non-flags))))

(define part1-lexer
  (lexer [(eof) eof]
         ["mul" 'mul]
         ["(" 'left-paren]
         [")" 'right-paren]
         ["," 'comma]
         [(repetition 1 +inf.0 numeric) (string->number lexeme)]
         ; Skip everything else - any single character that doesn't match above
         [any-char (part1-lexer input-port)]))

(define input
  (with-input-from-file filename
                        (lambda ()
                          (sequence->list (in-producer (lambda () (part1-lexer (current-input-port)))
                                                       eof-object?)))))

(define (part1 input)
  (~> (filter number? input)
      (in-slice 2 _)
      sequence->list
      (foldl (λ (pair acc) (displayln pair) (+ acc (apply * pair))) 0 _)
      )
  )

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
