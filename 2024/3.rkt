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
         ; Match valid mul(x,y) pattern and extract the numbers
         [(concatenation "mul("
                        (repetition 1 3 numeric)
                        ","
                        (repetition 1 3 numeric)
                        ")")
          (let ([match lexeme])
            (display lexeme)
            ; Extract numbers from "mul(x,y)"
            (let ([nums (regexp-match* #rx"[0-9]+" match)])
              (map string->number nums)))]
         ; Skip everything else
         [any-char (part1-lexer input-port)]))

(define input
  (with-input-from-file filename
                        (lambda ()
                          (let loop ([result '()])
                            (let ([token (part1-lexer (current-input-port))])
                              (cond
                                [(eof-object? token) (reverse (flatten result))]
                                [(list? token) (loop (cons token result))]
                                [else (loop result)]))))))

(define (part1 input)
  (~> input
      (in-slice 2 _)
      sequence->list
      (foldl (λ (pair acc) (+ acc (apply * pair))) 0 _)))

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
