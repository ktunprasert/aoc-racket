alias r := run
alias e := example
alias g := generate
alias gen := generate

default:
    @just --list

run YEAR DAY *FLAGS:
    racket ./{{YEAR}}/{{DAY}}.rkt {{FLAGS}}

example YEAR DAY *FLAGS:
    racket ./{{YEAR}}/{{DAY}}.rkt {{YEAR}}/{{DAY}}e.txt {{FLAGS}}

generate YEAR DAY *FLAGS:
    racket {{FLAGS}} gen.rkt {{YEAR}} {{DAY}}
