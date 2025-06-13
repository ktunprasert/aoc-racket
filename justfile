default:
    @just --list

run YEAR DAY *FLAGS:
    racket ./{{YEAR}}/{{DAY}}.rkt {{FLAGS}}

example YEAR DAY *FLAGS:
    racket ./{{YEAR}}/{{DAY}}.rkt {{YEAR}}/{{DAY}}e.txt {{FLAGS}}
