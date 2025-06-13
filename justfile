default:
    @just --list

run YEAR DAY *FLAGS:
    racket {{FLAGS}} ./{{YEAR}}/{{DAY}}.rkt

example YEAR DAY *FLAGS:
    racket {{FLAGS}} ./{{YEAR}}/{{DAY}}.rkt {{YEAR}}/{{DAY}}e.txt
