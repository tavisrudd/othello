# C1182 — demand-driven Datalog evaluation with support witnesses

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: QUEUED. Successor to C1179 (`2026-09-13-c1179-datalog-closure-ballpark.md`).

## Why

C1179 showed the rules path is capped at domain N≈24 on transitive closure, not by time or
memory but by the grounding budget: every product of every rule is materialized before
evaluation, so work grows as N⁵ for a binary recursive rule. Soufflé runs the same inputs to
N=1024 dense in seconds. No Datalog-scale comparison is possible until derivation work is
proportional to output times degree instead of the full product space.

## Goal

A demand-driven, semi-naive evaluator for positive Datalog over the Boolean carrier whose
certificate is a support witness per derived tuple, verifiable without the full grounding.
Then a matched comparison against Soufflé (interpreter and compiled, `-j1`) on the C1179
inputs extended to N=4096 sparse and N=1024 dense, plus same-generation, through the C1179
harness.

## Design points (decide, then build)

1. **Sparse support certificate.** The C1173 `SupportCertificate` names a witness by grounded
   product index, so it presupposes the full product list. Define a sparse variant whose witness
   for a derived tuple is (rule id, premise tuples), verifiable by: every premise tuple is an
   input fact or a derived tuple of strictly lower rank, ranks are well founded, and every
   derived tuple has exactly one witness. Least-fixedness follows from rank order; completeness
   (no derivable tuple missing) is checked by one closed-world pass over the final relation with
   the same indexes, or stated as not certified if that pass is dropped. Reuse the C1173
   verifier's structure; do not weaken its obligations.
2. **Evaluation.** Index each relation on its join columns; worklist over newly derived tuples;
   for each rule body, probe the other premise's index (binary joins first; n-ary bodies via
   left-deep binary joins). Products are never stored. Record the first witness per tuple.
   Preallocated hash sets or sorted vectors with explicit capacity from the input size;
   allocation-counted hot loop per `ergodis-contrib/PERFORMANCE.md`.
3. **Scope.** Positive rules, constants and equality joins, Boolean carrier. Min-plus stays on
   the finite grounded contract; negation, aggregation and stratification are out of scope and
   must be rejected at admission, not silently accepted.
4. **Placement.** Core `crates/rules` (domain-neutral), behind the same `Program` wire format
   so the C1179 harness switches evaluator by flag. Read core `AGENTS.md` and the export
   manifest rules before adding files.

## Acceptance

- Exact tuple agreement with the grounded evaluator for every N ≤ 24 program in the C1179
  set and the existing `boolean.rs` fixtures, and with Soufflé's `path.csv` for every larger N.
- Sparse certificate verified by an independent checker for every run; a corrupted witness,
  a missing tuple and a wrong rank each rejected (negative controls).
- Zero allocations in the derivation loop after preparation, measured.
- Comparison table per density: N, edges, output tuples, Ergodis prepare/eval, certificate
  size and verify time, Soufflé interpreter and compiled, peak RSS, ratios with paired
  intervals over interleaved rounds (retained binaries, `perf stat`, single pinned core).
- Report states plainly which of Soufflé's features are absent here; no engine claim beyond
  the measured rule class.

## Not in scope

Compiling rules onto the Hadamard/partitioned join kernels (the longer-term story), Rel
frontend lowering (C1170), parallel evaluation, incremental maintenance.
