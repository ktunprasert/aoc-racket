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
        (with-input-from-file
         filename
         (λ ()
           (let loop ([result '()])
             (let ([token (the-lexer (current-input-port))])
               (cond
                 [(eof-object? token) (reverse (group-by (λ~> length (<= 2)) result))]
                 [(list? token) (loop (cons token result))]
                 [else (loop result)])))))))

(define fail-map
  (for/hash ([h (first input)])
    (values (reverse h) #t)))

(define (middle lst)
  (~> (length lst) (quotient _ 2) (drop lst _) first))

(define (is-ordered? lst)
  (for/and ([n lst]
            #:when (> (length (member n lst)) 1))
    (andmap (λ (r) (not (hash-ref fail-map (list n r) #f))) (rest (member n lst)))))

(define (part1 input)
  (for/sum ([lst (second input)])
           (if (is-ordered? lst)
               (middle lst)
               0)))

(define (part2 input)
  (for/sum ([lst (filter (λ (lst) (not (is-ordered? lst))) (second input))])
           (let loop ([sub-lst lst]
                      [idx 0])
             (define target (drop sub-lst idx))
             (define-values (l rest) (values (car target) (cdr target)))
             (define-values (right-idx found?) (values idx #f))
             (for ([r rest]
                   #:do [(set! right-idx (add1 right-idx))]
                   #:final (hash-ref fail-map (list l r) #f)
                   #:when (hash-ref fail-map (list l r) #f))
               (set! found? #t)
               (set! sub-lst (~> (list-set sub-lst idx r) (list-set _ right-idx l))))

             (cond
               [(= idx (- (length sub-lst) 2)) (middle sub-lst)]
               [found? (loop sub-lst idx)]
               [else (loop sub-lst (add1 idx))]))))

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
