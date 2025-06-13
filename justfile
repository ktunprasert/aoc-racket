default:
    @just --list

run YEAR DAY *FLAGS:
    cat {{YEAR}}/{{DAY}}.txt | racket {{FLAGS}} ./{{YEAR}}/{{DAY}}.rkt

example YEAR DAY *FLAGS:
    cat {{YEAR}}/{{DAY}}e.txt | racket {{FLAGS}} ./{{YEAR}}/{{DAY}}.rkt
