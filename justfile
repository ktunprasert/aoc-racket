run YEAR DAY:
    cat {{YEAR}}/{{DAY}}.txt | racket ./{{YEAR}}/{{DAY}}.rkt

example YEAR DAY:
    cat {{YEAR}}/{{DAY}}e.txt | racket ./{{YEAR}}/{{DAY}}.rkt
