default:
    @just --list

run YEAR DAY *FLAGS:
    racket {{FLAGS}} main.rkt {{YEAR}} {{DAY}}

example YEAR DAY *FLAGS:
    racket {{FLAGS}} main.rkt {{YEAR}} {{DAY}} {{YEAR}}/{{DAY}}e.txt
