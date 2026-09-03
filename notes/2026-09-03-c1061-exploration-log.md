# C1061 exploration log: Ergodis as a compiled dynamic decision engine

**Lane**: `complete-ports`
**Brief**: `2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`
**Mode**: open-ended; append-only; each entry names the probe, the evidence location, and the
verdict (promote / drop / open). Findings that deserve their own file get a dated note and a
one-line pointer here.

## Entries

- 2026-09-03 — allocated; brief written; event-sourcing/CQRS shell added to brief.
- 2026-09-03 — probe 1 launched: survey of existing composition / interface / min-sum machinery
  in `~/src/ergodis` and `~/src/ergodis-private` for associativity, retained composition trees,
  and delta hooks; first incremental-recomposition prototype with a sequence benchmark. Report:
  `2026-09-03-c1061-probe1-composition-survey-and-delta-prototype.md`. Verdict: **promote**.
  Survey: core has associative min-plus / Pareto / frozen-shortest-path composition and an
  exhaustive associativity certifier, but no leaf identity, no repairable retained tree, and no
  `apply_delta` in either repo. Prototype `delta_composition` in ergodis-private (commit `cbf2332`):
  64-byte min-plus boundary summary, flat balanced tree, typed `Delta` enum, allocation-free
  leaf-to-root update, `DeltaRun` event monoid. At 16,384 leaves: fresh solve 4.93 ms vs delta
  mean 614 ns (p50 491 ns, p99.99 14.6 us), 0.046% of nodes recomputed, break-even about one
  update, zero allocations. Monoid collapse k=8 gives 7.06x. The collapse law exposed a lossy
  saturating cost store that broke the group action; fixed by signed store, clamp at leaf.
  Congruence is exact for the declared vocabulary; quotient infinite only through unbounded cost.
  Interface width (4 labels), not chain length, drives cost.
- Open next probes (from probe 1): witness/certificate deltas; tropical normalization to test
  finiteness of the quotient; several semirings over one topology; bind a real capacitated batch
  kernel (`azure_lrc_12_2_2_counted`); `schedule_repair_dag` is not a candidate (subset-mask BFS
  has no per-leaf factorization).
