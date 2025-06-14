#lang racket

(require net/http-client
         net/url)

(define args (vector->list (current-command-line-arguments)))

(when (< (length args) 2)
  (error "Usage: racket dl.rkt <year> <day>"))

(define year (first args))
(define day (second args))

; Read SESSION from .env file
(define session
  (if (file-exists? ".env")
      (with-input-from-file ".env"
        (lambda ()
          (for/fold ([session #f])
                    ([line (in-lines)])
            (if (string-prefix? line "SESSION=")
                (substring line 8)
                session))))
      (error "No .env file found")))

(when (not session)
  (error "SESSION not found in .env file"))

; Create directory if it doesn't exist
(unless (directory-exists? year)
  (make-directory year))

; Download input
(define url (string->url (format "https://adventofcode.com/~a/day/~a/input" year day)))
(define-values (status headers response-port)
  (http-sendrecv
   (url-host url)
   (format "/~a/day/~a/input" year day)
   #:ssl? #t
   #:headers (list (format "Cookie: session=~a" session))))

(define output-file (format "~a/~a.txt" year day))

; Save response to file
(with-output-to-file output-file
  (lambda ()
    (copy-port response-port (current-output-port))))

(close-input-port response-port)

(printf "Downloaded input to ~a~n" output-file)
