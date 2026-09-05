# Complete-ports discovery track

Append-only companion for incidental observations and musings encountered in
the `complete-ports` lane.  Planned theorem, formalization, manuscript, and
verification work belongs in the task reports and control ledgers instead.

No incidental entry was found during C671.

2026-09-04, C1016, while profiling the plain spin-shard tabu step: on this host
and toolchain, the fastest short `i16` inner product is the one that emits no
vector instruction. Eight independent scalar accumulator lanes beat the
autovectorized loop by 1.10x in cycles at length 87, because widening `i16` to
`i32` on the baseline target spends a whole vector load per four elements
through `punpcklwd`. `-C target-cpu=native` then removes 27% of instructions but
only 7% of cycles. This is a general fact about short widening reductions in
Ergodis hot loops, not about supplementary difference sets; it is a candidate
line for the shared performance playbook, and the measurement is in
`2026-09-04-c1016-full-neighbourhood-tabu-spin-shard.md`.

