# C1203 — re-locate the growing join index's direct/sparse crossover

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: IN PROGRESS (Opus, reviewed by the main agent). C1202 successor; allocated on Tavis's
call from C1202 report candidate 2 ("Locate the growing index's own crossover on the kept arm").

## Goal

`DIRECT_INDEX_DENSITY = 48` decides the kind of a join index over a relation that grows. C1192
located it (cycles cross between density 32 and 64 on `cycle:blocks:4096`) and named the mechanism
with counted cache events: the direct shape's per-evaluation `fill(NONE)` over the whole key space.
**C1198 then removed that mechanism**: workspace tables are lazy mappings reset by walking the rows
the previous evaluation wrote (`RESET_FILL_BYTES_PER_ROW`), so the reset is proportional to rows, not
key space. C1202 measured the direct kind ahead by 4.6–12.3 % in cycles at density 55.9, which is on
the sparse side of 48. The constant is therefore a pre-C1198 measurement applied to a post-C1198
kernel. Re-locate the crossover on the current kernel and set the rule from the measurement.

Three outcomes are possible and each is a result:

1. a crossover exists at some density above 48: bracket it (both bracket points reproduce in an
   independent re-run, as C1192 required), set the constant inside the bracket;
2. no crossover exists below the feasibility ceilings (`MAX_DIRECT_KEYS`, `MAX_WORKSPACE_BYTES`,
   the lazy mapping's address space): the density rule is dropped for growing indexes and the
   ceiling alone decides, as C1192 concluded for membership and static indexes; state the highest
   density measured and what stops the sweep there;
3. the crossover depends on something other than density (rows written per evaluation against
   `RESET_FILL_BYTES_PER_ROW`, the fill-versus-walk switch, committed-page footprint, repeated
   evaluation on one workspace versus a cold one): name the variable with a measurement that
   moves it at fixed density, as C1202 did for the static rule.

## Questions the report must answer

- Where, in density, do cycles cross on `cycle:blocks:4096` on the current kernel? Sweep
  `--max-rows` from density 1 through at least 1,024 (C1192's grid plus the points beyond 256 the
  row bound allows; a bound below the derived count is `Error::Budget`, so the top of the sweep is
  set by the cohort's derived rows — use the `blocks<N>` density to get smaller derived counts and
  so higher reachable densities).
- Does the answer hold on a second program and a second domain (`closure` or `mutual` where they
  have a growing index with a large key space; domain 16,384)? One constant from one cohort is
  what C1201 found wrong about the static rule.
- Does the fill-versus-walk switch sit near the crossover? If the direct table flips from fill to
  walk inside the sweep, the two regimes need separate readings.
- What does the direct kind cost in peak RSS and committed pages at the densities where it now
  wins? (C1202's open item for Tavis was exactly this trade on a static index: 4.4× RSS for a
  0.420 loop.) Report RSS beside every cycle ratio so the constant is a time/memory decision made
  with both numbers.
- Repeated-evaluation versus first-evaluation: the derivation-loop A/B re-enters one workspace;
  the whole-process figure pays first-touch faults. Report both stages at the bracket points.
- The cache-event run (separate run, cache set) at the new bracket points, or at the two highest
  densities if there is no crossover: does the counted traffic agree with the mechanism claimed?

## Acceptance

- The isolation defect C1192 recorded is addressed or re-priced: `Policy::SparseIndexes` forces
  every index in the plan, not only the large growing one. C1202's `--max-rows` bracket under
  `Policy::Auto` moves only the one index (kinds `ddd` against `dds`) and is the preferred
  instrument; if a forced policy is used anywhere, the other indexes' share is bounded by
  arithmetic as C1192 did.
- Both arms are one binary; derived counts, digests, work counters and per-index lookup counts
  equal between arms at every point; `--count-probes` figures are in receipts (C1202 recorded
  that three of its four lookup counts were unreceipted because `ab.py` does not record the
  counter — repair that in `ab.py` as part of this task).
- Even round counts (C1202 open item 4: a 2:1 arm order biased a null to 0.97).
- Bracket (or no-crossover) result reproduced by an independent re-run hours apart or under a
  different load; between-run drift stated.
- If the constant changes: every cohort in the C1202 eighteen-cohort table re-run against the
  control; cohorts whose kinds do not change inside the A/A null with byte-identical plans;
  cohorts whose kind changes reported with loop, preparation, whole process and RSS; digests,
  work counters, both checkers, C1189 differential under both body policies and the parity
  digest unmoved or the move explained.
- If the constant does not change, say so with the measurement that keeps it; do not move a
  constant inside between-run drift.
- Gates as in the C1202 replay block: core `cargo test --all-features`, clippy `-D warnings`,
  fmt, the allocation regression under every policy, `generate_evidence.py --write`, private
  workspace gates.

## Method (binding)

`~/src/ergodis-dev/PERFORMANCE.md` in full and `~/src/ergodis-dev/performance-playbook.md` in
full before any edit or measurement. Fermi predictions written into the report before the first
sweep: predict the crossover density (or its absence) from per-unit costs — the reset walk per
row, the direct probe against the sparse probe, first-touch faults per committed page — and then
score the prediction. Controls: `closure_ballpark-5217cdb` (derivation loop) and
`ergodis-tools-ab6be13` (frontend/backend), rustc 1.95.0; core repair commit `ca0609f` postdates
them, so re-retain from clean trees before any kernel A/B. Event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults`; cache events in a separate
run. Instructions will say "always direct" (C1192 and C1202 both found this); the decision
variable here is cycles with intervals, reproduced across runs, with the counted cache events as
the mechanism check. Keep or revert by commit. Bundle rows name commits and tracked files, never
`~/.cache` paths. Cache listing at close; deletion is Tavis's call.

Out of scope: the static rule (`DIRECT_STATIC_PROBES`), `DEMOTE_BUCKET_ROWS`, the plan-owned hash
kind, join order, preparation's per-fact cost, a single cost function replacing both constants
(name it as a successor if the data supports it; do not build it).

## Inputs

- `notes/2026-09-18-c1202-probe-count-index-rule-report.md`, section "`DIRECT_INDEX_DENSITY = 48`:
  does the growing index carry the same defect?", and its audit.
- `notes/2026-09-16-c1192-sparse-join-index-report.md`, section "The crossover, measured".
- `notes/2026-09-16-c1198-workspace-sized-from-rows-report.md` and
  `notes/2026-09-17-c1200-c1198-repair-pass.md` (lazy workspace, the fill-versus-walk rule).
- Core `~/src/ergodis` (`crates/rules/src/demand.rs`), private `~/src/ergodis-private`
  (`analysis/datalog-comparison/`, `ab.py`), scripts in `~/src/ergodis-dev`.

## Report

`notes/2026-09-18-c1203-growing-index-crossover-report.md`, written incrementally from the start:
arms, commits, Fermi predictions before measurement, the sweep, the second program and domain,
memory, cache events, reproduction run, disposition, `ej`+`tt` closeout, mystery ledger,
candidates to queue, replay commands, cache listing.
