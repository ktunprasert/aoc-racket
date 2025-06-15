#lang racket

(provide input
         part1
         part2)

(require parser-tools/lex)
(require threading)

(define args (vector->list (current-command-line-arguments)))

(define has-flag? (lambda (flag) (member flag args)))

(define the-lexer
  (lexer [(eof) eof]
         [(concatenation (repetition 1 +inf.0 numeric)
                         ": "
                         (repetition 1 3 numeric)
                         (repetition 1 +inf.0 (concatenation " " (repetition 1 3 numeric))))
          (let* ([split (string-split lexeme #px":\\s|\\s+")]) (map string->number split))]
         [any-char (the-lexer input-port)]))

(define filename
  (let ([non-flags (filter (λ (arg) (not (string-prefix? arg "--"))) args)])
    (if (null? non-flags)
        "2024/7.txt"
        (first non-flags))))

(define input
  (time (display "Parsing took: ")
        (with-input-from-file filename
                              (λ ()
                                (let loop ([result '()])
                                  (let ([token (the-lexer (current-input-port))])
                                    (cond
                                      [(eof-object? token) (reverse result)]
                                      [(list? token) (loop (cons token result))]
                                      [else (loop result)])))))))

(define (generate-op-combinations n)
  (apply cartesian-product (make-list n (list + *))))

(define (evaluate-left-to-right numbers operators)
  (foldl (lambda (num op acc) (op acc num)) (car numbers) (cdr numbers) operators))

; Generate all operator combinations with results
(define (generate-combinations numbers)
  (let* ([n (length numbers)]
         [num-operators (- n 1)]
         [operator-combinations (generate-op-combinations num-operators)])
    (map (lambda (operators)
           (let ([result (evaluate-left-to-right numbers operators)])
             ;; (list numbers operators result)))
             result))
         operator-combinations)))

(define (equation-possible? target nums)
  (and (>= (apply * nums) target) (ormap (curry = target) (generate-combinations nums))))

(define (part1 input)
  (~> (for/sum ([lst input] #:when (equation-possible? (first lst) (rest lst)))
               ;; filter sublist eq target
               (car lst))
      )
  ;; displayln)

  ;; "TODO: Implement part 1"
  )

(define (part2 input)
  "TODO: Implement part 2")

(when (has-flag? "--output")
  ;; (printf "Input: ~a~n" input))
  (display (format "Input: ~a~n" input)))

(if (has-flag? "--time")
    (begin
      (printf "Part 1: ")
      (time (displayln (part1 input)))
      (printf "Part 2: ")
      (time (displayln (part2 input))))
    (begin
      (displayln (part1 input))
      (displayln (part2 input))))
