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


2026-09-04, C1063, while adding evidence rows to
`ergodis-private/benchmarks/tiger-blossom/SHA256SUMS`: that manifest mixes two path conventions.
Thirty of its rows name a bare basename and two, added under C1061 probe 28g, name a path relative
to the repository root, so `sha256sum -c` fails on those two from inside the directory and would
fail on all the others from the root. Nothing is wrong with the recorded hashes; the manifest simply
cannot be checked in one command from either place. Any evidence manifest that accumulates rows
across tasks wants one stated convention and a check that runs in the reproducibility instructions,
which is a general point about our evidence bundles rather than about TigerBlossom.
