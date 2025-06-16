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

(define (|| a b)
  (~> (let loop ([n b]
                 [count 0])
        (cond
          [(<= n 0) count]
          [else (loop (quotient n 10) (add1 count))]))
      (expt 10 _)
      (* a)
      (+ b)))

(define (equation-possible? target nums [ops (list + *)])
  (define (try-operators current remaining)
    (cond
      [(null? remaining) (= current target)]
      [(> current target) #f] ; Early termination for addition/multiplication
      [else (ormap (lambda (op) (try-operators (op current (car remaining)) (cdr remaining))) ops)]))

  (if (null? nums)
      #f
      (try-operators (car nums) (cdr nums))))

(define (part1 input)
  (for/sum ([lst input] #:when (equation-possible? (first lst) (rest lst))) (car lst)))

(define (part2 input)
  (for/sum ([lst input] #:when (equation-possible? (first lst) (rest lst) (list || + *))) (car lst)))

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
