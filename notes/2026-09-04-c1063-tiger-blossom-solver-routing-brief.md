# C1063: route TigerBlossom to its best solver per shot, and rebenchmark on that default

**Lane**: `complete-ports` · **Allocated**: 2026-09-04 · **Code**: `~/src/ergodis-private`
(`src/tiger_blossom.rs`, `src/tiger_blossom_sparse.rs`, `scripts/tiger_blossom_ab.py`) ·
**Predecessor**: `2026-09-04-c1061-probe28g-depth-merge-and-the-rejected-rate-cache.md`

## Why

Every TigerBlossom benchmark to date, including the direct PyMatching comparison, runs the
production arm `LEVEL_SPARSE` (level 4), in which the sparse region-growth matcher takes the whole
defect set ahead of the pair matrix and the cluster decomposition. Probe 28g's stack ladder shows
that arm is **not** the fastest configuration in 13 of 18 measured cells, so both the default and
every external comparison are being reported on something slower than what the kernel can already
do. Tavis's instruction on 2026-09-04: the default configuration and all comparisons against
PyMatching or other state of the art must use the best arm we have for each point.

## The measurement that motivates it

`scripts/tiger_blossom_ab.py stack`, six interleaved rounds, two-size differencing, instructions
per decode, binary `ergodis-tools-ce0658b`, log
`benchmarks/tiger-blossom/2026-09-04-probe28g-ce0658b-stack-ab.log`. Best arm per cell against the
shipped level 4:

| d  | p     | best arm                  | best     | production | gain      |
|----|-------|---------------------------|----------|------------|-----------|
| 3  | 0.001 | level 2 closed forms      | 64.1     | 66.9       | 1.044x    |
| 3  | 0.01  | level 3 no decomposition  | 77.6     | 96.2       | 1.240x    |
| 3  | 0.05  | level 3 no decomposition  | 259.4    | 605.5      | **2.334x**|
| 5  | 0.001 | level 2 closed forms      | 65.3     | 68.1       | 1.043x    |
| 5  | 0.01  | level 3 no decomposition  | 114.8    | 180.7      | **1.574x**|
| 5  | 0.05  | level 3 no decomposition  | 1,407.3  | 2,132.7    | **1.515x**|
| 7  | 0.001 | level 3 no decomposition  | 66.7     | 69.7       | 1.045x    |
| 7  | 0.01  | level 3 no decomposition  | 179.9    | 254.1      | 1.412x    |
| 7  | 0.05  | level 3 no decomposition  | 3,921.8  | 4,168.3    | 1.063x    |
| 9  | 0.001 | level 3 no decomposition  | 67.9     | 71.8       | 1.057x    |
| 9  | 0.01  | level 3 no decomposition  | 283.7    | 385.0      | 1.357x    |
| 9  | 0.05  | level 4 production        | 6,623.7  | 6,623.7    | 1.000x    |
| 15 | 0.001 | level 3 no decomposition  | 73.5     | 81.2       | 1.105x    |
| 15 | 0.01  | level 4 production        | 1,002.7  | 1,002.7    | 1.000x    |
| 15 | 0.05  | level 4 production        | 14,367.7 | 14,367.7   | 1.000x    |
| 25 | 0.001 | level 3 no decomposition  | 99.9     | 106.2      | 1.063x    |
| 25 | 0.01  | level 4 production        | 2,688.7  | 2,688.7    | 1.000x    |
| 25 | 0.05  | level 4 production        | 27,139.9 | 27,139.9   | 1.000x    |

Level 3 wins eleven cells, level 2 two, level 4 five. Summed over the eighteen cells the best-arm
envelope is 1.027x of production, but that average is misleading: the large gains sit at the
low-error cells that dominate any realistic operating point, and at 5% error on the small codes.
All levels return identical checksums, so this is a pure cost choice with no exactness consequence.

The shape is legible. Level 4 sends the whole defect set to the matcher; level 3 keeps the closed
forms but solves per cluster. Sending everything to the matcher pays only once the syndrome is
dense enough that cluster decomposition and the pair matrix cost more than they save, which is why
level 4 wins as distance times error rate grows and loses everywhere else.

## What to build

**Do not tune per `(d, p)` cell.** A deployed decoder knows its compiled graph but not the physical
error rate, so a table indexed by the benchmark's rate is benchmark-fitting and must not become the
default. Route on a per-shot observable instead.

1. **Find the discriminating feature.** The obvious candidate is the shot's defect count, which
   level 3 already pays for quadratically through the pair matrix while the matcher's cost tracks
   events. Cluster size after the flood fill is the other candidate. Measure the per-arm cost as a
   function of defect count on a fixed graph, not as a function of the rate, and find whether a
   single threshold separates them cleanly or whether the crossover moves with the graph.
2. **Compile the threshold, do not read it at run time.** Per the performance contract, no
   run-constant branch inside the hot loop: the routing decision is resolved once per shot at the
   top of `decode_at`, and any per-graph constant belongs in `KernelSpec` where the compiler can
   see it. Both arms already exist as const-generic monomorphizations, so this is a dispatch, not a
   new solver.
3. **Make the default the routed arm** and keep the fixed levels as measured arms for the ladder.
4. **Rebenchmark against PyMatching on the routed default**, all eighteen cells, and restate the
   standing. The current direct comparison
   (`benchmarks/tiger-blossom/2026-09-04-probe28g-ce0658b-vs-pymatching-external-ab.log`) is
   level 4 only, so every figure in it is a lower bound on what the kernel can do. Expect the two
   losing cells to be unaffected — d=15 and d=25 at 5% error are exactly where level 4 already
   wins — and the winning cells to widen.
5. **Check the other comparisons.** The same argument applies to any future state-of-the-art
   comparison; the SOTA-comparison conventions in
   `2026-08-27-c983-observational-minimization-sota-comparison.md` are the reference for how the
   competitor arm must be configured and cited.

## Gates

The usual TigerBlossom set, unchanged: the debug kernel suite at four distances with the `I1`/`I2`,
boundary and no-late-entry oracles; the release suite including the zero-allocation `decode_batch`
gate; `cargo fmt --check` and `cargo clippy --all-targets --all-features -- -D warnings` in debug
and release; PyMatching 2.4.0 `verify` on `--mode emit --operations 20000` per cell with zero
weight disagreements on all eighteen cells; and an interleaved eighteen-cell A/B against a retained
control. Additionally:

- **Routing changes no answer.** Every level already agrees on the checksum; the routed arm must
  agree with level 4 shot by shot on weight and observable parity, not merely in aggregate.
- **No run-constant branch.** Show the dispatch is outside the per-shot work, per
  `../ergodis-contrib/PERFORMANCE.md`.
- **State the rule's provenance.** If the threshold is fitted on measured data rather than derived,
  say so and give the data it was fitted on; a rule fitted per benchmark cell is not admissible as
  a default.

## Open question for Tavis

Whether the routed default should also be free to choose the *unspecialized* graph path. Probe 28g
measured `--plain-graph` at 0.904x of production at d=3 p=0.001 — the one cell where the compiled
closure costs more than it saves — while being up to 18.8x worse elsewhere. That single cell is
probably not worth a second axis of routing, but it is the only measured case where the compiled
graph is a loss, and the decision belongs to you.
