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
  ; Load the module and get its provided symbols
  (define module-path (string->path day-module))
  (define mod-ns (module->namespace module-path))
  
  ; Get all exported symbols from the module
  (define exported-symbols 
    (parameterize ([current-namespace mod-ns])
      (namespace-mapped-symbols)))
  
  (printf "Module symbols: ~a~n" exported-symbols)
  
  ; Time each exported symbol that's not a utility variable
  (parameterize ([current-namespace mod-ns])
    (for ([name exported-symbols])
      (when (and (not (eq? name 'args))
                 (not (eq? name 'filename)))
        (printf "Timing ~a: " name)
        (time (namespace-variable-value name))))))