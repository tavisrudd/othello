# C1202 — probe-count index rule, mask demotion and the per-link probe counter

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: IN PROGRESS (Opus, reviewed by the main agent). C1201 successor; allocated on
Tavis's call from C1201's recommended shape ("mask demotion plus the per-link probe counter").

## Goal

Replace the density proxy `DIRECT_STATIC_DENSITY = 64` with a rule on the quantity C1201 showed
is the cause, `key_space / probes`, and give a fully bound atom the cheap-build O(1)-probe index
that C1201 priced but did not build. Three pieces, in build order:

1. **Per-link probe counter in `Evaluation`** (C1201 closeout candidate 2). One increment per
   bucket lookup at each body-atom link, beside the existing top-level `probes`. Instrument
   first: it makes the C1201 probe figures measured rather than derived from the generators'
   out-degree (3 at `sparse`, 15 at `blocks`) and it is the missing half of C1193's queued
   `matches` counter. Must not add a per-iteration branch on a run-constant (PERFORMANCE rule 3):
   the loop already branches on the bucket lookup, so the increment rides that branch or a
   monomorphized instrumentation const.
2. **Mask demotion** (C1201 candidate 3; report section "Not built: demoting the index's mask and
   verifying the rest per row"). A fully bound atom indexes on a subset of its bound columns
   (one column is the priced shape) and the remaining bound columns are verified per row through
   the existing `join::<VERIFY = true, _>`, instantiated for the CSR arm. Needs an op kind the key
   fold in `Index::bucket` and `run` skips (or a mask-aware fold). No new storage, no new kind.
   `triangle:sparse:4096`'s third atom then indexes `domain` keys (16 KiB of offsets) instead of
   `domain²` (64 MiB); priced at two extra row reads and two extra comparisons per probe.
3. **The rule** (C1201 candidate 1). `Policy::Auto` chooses the static kind on
   `key_space <= K · estimated_probes`, `K` fitted from the located crossover (C1201: about 23,
   bracketed only between 18.2 and 273). The estimate multiplies each level's average fan-out
   (exact at the first level, independence after); check it against the measured per-link counter
   over the whole cohort set (C1201 mystery item 4). Then decide whether `DIRECT_INDEX_DENSITY = 48`
   for growing indexes carries the same defect (mystery item 5): C1192's sweep at two workloads
   with equal density and different probes per row. If one constant replaces both, say so with
   the measurement; if not, keep 48 and record why.

Order may be reshuffled by evidence, but piece 1 lands before piece 3 is fitted. Piece 2 is a
kernel change with its own A/B; report it as such even if its wins are on two cohorts.

## Acceptance

- `mutual:blocks:4096` and `triangle:blocks:4096` both get the right kind under `Policy::Auto`
  (opposite answers at the same density; C1201 report section "Which cohort's choice changes").
- `triangle:sparse:4096` and `triangle:blocks:4096` under the demoted mask: preparation near
  C1201's sparse figure, derivation loop at or near the direct row (C1201's unmet criterion:
  the two changed-kind cohorts paid 1.41–1.45× in the loop).
- Every cohort in the C1201 seventeen-cohort table: output digest, derived count, probe count
  and candidate count equal between control and candidate; certificates accepted by both
  checkers; C1189 differential zero disagreements under both body policies; parity digest
  reported (moved or unchanged, with the reason).
- Direct-path cohorts whose kind does not change: instructions within the A/A null or the loss
  stated as a loss with its mechanism (as C1193 did).
- Per-link probe counter's own cost on the two-atom kernel measured and stated.
- Gates: `cargo test --all-features`, clippy `-D warnings`, fmt, the allocation regression,
  `generate_evidence.py --write`, private workspace gates as in the C1201 replay block.

## Method (binding)

`~/src/ergodis-dev/PERFORMANCE.md` in full and `~/src/ergodis-dev/performance-playbook.md` in
full before any edit. Fermi from the compiled loop before code. Controls:
`closure_ballpark-8c04b7a` (derivation loop) and `ergodis-tools-8c04b7a` (frontend/backend),
rustc 1.95.0, both `clean`; re-retain if the trees have moved. Event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults`, cache events in a
separate run. Keep or revert by commit. Report with Mystery ledger, replay commands, bundle
rows naming commits and tracked files (never `~/.cache` paths as citations), and the cache
listing at close (deletion is Tavis's call).

Cheap adjacent items to take if they fall out of the same runs (C1201 candidates 6, 7, 9):
`triangle`/`mutual` at the `blocks` density into `ab.py`'s standing cohort set; the cache-event
run on `triangle:sparse:4096` under both forced policies (closes C1201 open item 2 and C1193
open item 3); load average, CPU and arm hash emitted by `static_index_stages.py` and
`static_index_sweep.py`. Out of scope: the plan-owned hash kind (candidate 4), join-order
changes, preparation's per-fact cost (candidate 5), Free Join.

## Inputs

- `notes/2026-09-17-c1201-static-index-build-cost-report.md` and its audit
  `notes/2026-09-17-c1201-static-index-build-cost-audit.md`.
- `notes/2026-09-16-c1192-sparse-join-index-report.md` (index kinds, `DIRECT_INDEX_DENSITY`).
- `notes/2026-09-17-c1193-nary-bodies-report.md` (n-ary join, `join::<VERIFY>`, frame stack).
- Core `~/src/ergodis` (`crates/rules/src/demand.rs`), private `~/src/ergodis-private`,
  scripts in `~/src/ergodis-dev`.

## Report

`notes/2026-09-18-c1202-probe-count-index-rule-report.md` (written incrementally from the
start; sections: arms, commits, Fermi predictions before code, each piece's measurement,
results, mystery ledger, candidates to queue, replay commands, cache listing).
