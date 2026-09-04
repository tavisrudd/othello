# C1061 cross-cutting log notes: launches, candidates, caveats, and the QEC redirect

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Purpose**: the entries of the C1061 exploration log that belong to no single probe report —
probe launches, candidate lists, a measurement caveat, and Tavis's mid-day QEC redirect.

## Task start

2026-09-03 — allocated; brief written; event-sourcing/CQRS shell added to brief.

## Open next probes (from probe 1)

Witness/certificate deltas; tropical normalization to test finiteness of the quotient; several
semirings over one topology; bind a real capacitated batch kernel (`azure_lrc_12_2_2_counted`);
`schedule_repair_dag` is not a candidate (subset-mask BFS has no per-leaf factorization).

## Probe 5 candidate, from the snapshot-speedup question

Accelerate the initial snapshot bind using probe-2 observations: memoize leaf kernels by normalized
class with an exact miss path; compose runs of identical leaf classes by repeated squaring; treat
snapshot-from-snapshot as a bucketed delta batch with subtree rebuild O(k log(n/k)); compile leaf
classes as piecewise functions of the shared budget level; run-length witness readout. Gate to
watch: the 2-class leaf census is stream-specific and needs a hostile stream or a proved bound.

## Probe 3 follow-up launched

Hash backend A/B on the certified path (sha2 baseline, SHA-NI/asm sha2, BLAKE3 single and batch,
non-cryptographic lower bound, fewer hash calls). Certificate work is engineering, not a paper; no
further novelty effort. Result appended to `2026-09-03-c1061-probe3-incremental-certificates.md`.

## Measurement caveat

The box was loaded with concurrent builds and benchmarks during probes 2, 3, and 5, and their
ratios are wall-clock. Every wall-based verdict in those entries is provisional until re-measured
in hardware counters (instructions and cycles). Probe 6 re-measures probes 2 and 5; the
hash-backend A/B re-measures probe 3's baseline. Probe 1's counter numbers (about 2,366
instructions / 1,025 cycles per update) stand.

## Probe 11 launched

Land the two defect-kernel collapses in the Ergodis core under the full core validation gate (first
core edit of this task).

## Redirect (Tavis, from Sol's notes)

QEC is not given up. The dense per-shot decoder negative stands; the target becomes compiling the
smallest certifiably safe decoder policy, plus an internal zero-allocation sparse-blossom kernel.
Brief: `2026-09-03-c1061-qec-redirect-brief.md`. Probes 18 (generic certificates), 21 (routing fair
baseline), and 22 (non-degenerate LRC regime, true reliability) are stopped as documentation only
and continue in a fresh session. Launched: probe 23 context-certified predecoder (coverage(p, d,
T), exactness of the safety claim, minimized LUT, tiered path vs PyMatching); probe 24
matching-signature compression of the dense boundary tables (valuated delta-matroid and matchgate
identities); probe 25 soft output vs `decode_gap`; probe 26 TigerBlossom (specialized,
bounded-memory, index-based sparse blossom with exact fast paths, gated on identical MWPM weight to
PyMatching on probe 13's frozen inputs).
