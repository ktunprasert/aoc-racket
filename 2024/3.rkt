#lang racket

(provide input
         part1
         part2)

(require parser-tools/lex)

(require threading)

(define args (vector->list (current-command-line-arguments)))

(define has-flag? (λ (flag) (member flag args)))

(define filename
  (let ([non-flags (filter (λ (arg) (not (string-prefix? arg "--"))) args)])
    (if (null? non-flags)
        "2024/3.txt"
        (first non-flags))))

(define part1-lexer
  (lexer [(eof) eof]
         ["do()" 'do]
         ["don't()" 'dont]
         [(concatenation "mul(" (repetition 1 3 numeric) "," (repetition 1 3 numeric) ")")
          (let* ([content (substring lexeme 4 (- (string-length lexeme) 1))]
                 [parts (string-split content ",")])
            (list (string->number (first parts)) (string->number (second parts))))]
         ; Skip everything else
         [any-char (part1-lexer input-port)]))

(define input
  (time (display "Parsing took: ")
        (with-input-from-file filename
                              (λ ()
                                (let loop ([result '()])
                                  (let ([token (part1-lexer (current-input-port))])
                                    (cond
                                      [(eof-object? token) (reverse (flatten result))]
                                      [(list? token) (loop (cons token result))]
                                      [(symbol? token) (loop (cons token result))]
                                      [else (loop result)])))))))

(define (part1 input)
  (~> input
      (filter number? _)
      (in-slice 2 _)
      sequence->list
      (foldl (λ (pair acc) (+ acc (apply * pair))) 0 _)))

(define (part2 input)
  (~> input (displayln _))
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
