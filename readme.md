# benchmark

```fish
⋯ /aoc-racket/2024 on  master [!?] on ☁️  (eu-west-2)
➜ hyperfine -- "./1" "racket ./1.rkt"
Benchmark 1: ./1
  Time (mean ± σ):     271.5 ms ±  10.0 ms    [User: 211.3 ms, System: 67.6 ms]
  Range (min … max):   261.1 ms … 295.9 ms    10 runs

Benchmark 2: racket ./1.rkt
  Time (mean ± σ):     390.9 ms ±  14.1 ms    [User: 322.8 ms, System: 78.6 ms]
  Range (min … max):   373.7 ms … 421.3 ms    10 runs

Summary
  './1' ran
    1.44 ± 0.07 times faster than 'racket ./1.rkt'
⋯ /aoc-racket/2024 on  master [!?] on ☁️  (eu-west-2) took 7s110ms
➜ raco make 1.rkt
⋯ /aoc-racket/2024 on  master [!?] on ☁️  (eu-west-2)
➜ hyperfine -- "./1" "racket ./1.rkt"
Benchmark 1: ./1
  Time (mean ± σ):     286.0 ms ±  17.4 ms    [User: 217.5 ms, System: 76.6 ms]
  Range (min … max):   267.4 ms … 321.5 ms    10 runs

Benchmark 2: racket ./1.rkt
  Time (mean ± σ):     226.4 ms ±   5.7 ms    [User: 172.6 ms, System: 60.2 ms]
  Range (min … max):   218.8 ms … 236.1 ms    12 runs

Summary
  'racket ./1.rkt' ran
    1.26 ± 0.08 times faster than './1'
```
