# Codex review: Othello Rust strong-family solvers

**Date**: 2026-06-15
**Scope**: Static review of the current Rust `strong`, `strong+`, and `strong++`
solver paths for optimization opportunities. No code changes were made.

## Context

The current strong-family engine is already heavily tuned:

- `strong`: iterative-deepening negamax PVS, aspiration windows, mobility ordering,
  hash-move hints, and a cache-sized transposition table.
- `strong+`: same search with a stronger horizon evaluation.
- `strong++`: `strong+` plus calibrated Multi-ProbCut forward pruning.

Several common ideas have already been tried and documented as losses in
`rust/NOTES.md`: SIMD across ray directions, batched movegen in the search,
killer moves, outflank/PEXT-style flips, PGO, and root-parallel `best_move`.
Those should stay closed unless the evaluation/search shape changes.

## Findings

### 1. Root aspiration miss passes can use faster ordering

Current code:

- `pvs_root` keeps root moves in LSB order to preserve exact tie-break:
  `rust/src/search.rs:539`.
- `search_strong_move` repeats `pvs_root` until the aspiration window lands:
  `rust/src/search.rs:641`.

The exact LSB tie-break only matters on the final in-window pass. On fail-high or
fail-low aspiration passes, the returned move is discarded; only the bound matters.

Possible optimization:

- Add a value-only root probe for aspiration miss passes that can use hash-move
  and/or mobility ordering at the root.
- Once the window lands, run the existing LSB-ordered `pvs_root` to preserve the
  exact `best_by_side` tie-break.

Risk:

- Low for correctness if the existing final pass remains unchanged.
- Benchmark carefully; this only helps when aspiration misses are frequent enough
  and root ordering wins more than it costs.

Validation:

- `strong_fast_best_move_matches_exact_scores` must stay green.
- Benchmark `examples/bench.rs` for `strong`, `strong+`, and `strong++` at depths
  8-10.

### 2. Root-parallel `scores` can load-imbalance

Current code:

- `Strong::scores` splits root children into fixed chunks:
  `rust/src/engines.rs:492`.
- It zips those chunks with private per-worker TTs:
  `rust/src/engines.rs:495`.

Root child costs can vary significantly, so static chunking can leave one worker
as the tail.

Possible optimization:

- Keep private TT ownership, but use a more dynamic schedule.
- Candidate designs:
  - `rayon::map_init` with thread-local/per-worker TT state.
  - A small work queue plus worker-local TT reuse.
  - Cost-based chunking using a cheap root-child estimate, such as mobility or
    shallow search time from the previous iteration.

Risk:

- Medium. A naive shared TT or mutex around worker tables will likely lose.
- Dynamic scheduling may reduce cross-child TT locality inside each worker.

Validation:

- `bench_parallel` across thread counts.
- Full exact-scores self-play, not just one position.

### 3. The hot PVS loop still pays runtime engine-mode branches

Current code:

- Leaf eval checks `tt.plus()`:
  `rust/src/search.rs:256`.
- Multi-ProbCut checks `tt.mpc_on()` at non-leaf nodes:
  `rust/src/search.rs:310`.

These branches are predictable, but they prevent full specialization of the hot
recursive loop for the three modes:

- base eval, MPC off;
- plus eval, MPC off;
- plus eval, MPC on.

Possible optimization:

- Split the hot loop into monomorphic variants, or use const generics:
  `pvs<const PLUS: bool, const MPC: bool>(...)`.
- Keep public wrappers stable.

Risk:

- Medium. Code size grows and the compiler may or may not produce a better hot
  loop.
- Must preserve the invariant that MPC is calibrated only for plus eval.

Validation:

- Equivalence tests for `strong` and exact solve.
- Strength/time match for `strong++`, because MPC is not value-preserving.
- `make bench` for all strong-family engines.

### 4. Exact solve has unimplemented domain-specific wins

Current code:

- `solve_pvs` is the exact endgame solver:
  `rust/src/search.rs:667`.

The notes already list plausible exact-solve optimizations that have not been
attempted:

- explicit empty-square list;
- parity "fastest-first" ordering;
- specialized `solve_1..4`;
- stability-based cutoffs.

These matter for `--depth full`, not finite-depth play. The existing benchmarks
show exact solve grows exponentially with empties, so a few extra tractable
empties would be useful.

Risk:

- Medium to high depending on the cutoff. Specialized terminal solvers are low
  risk; stability cutoffs need more proof and tests.

Validation:

- Existing exact endgame tests: values 6 / -40 / 4.
- `examples/bench_solve.rs`.
- Add randomized near-terminal agreement against current `solve_pvs` for small
  empty counts before replacing any exact path.

### 5. Small mechanical cleanup in `solve_pvs`

Current code:

- `solve_pvs` computes `idx` at entry:
  `rust/src/search.rs:676`.
- It recomputes the same index before final store:
  `rust/src/search.rs:871`.

Possible optimization:

- Reuse the existing `idx`.

Risk:

- Very low.
- Expected payoff is tiny; do it only when touching `solve_pvs` for other work.

### 6. MPC calibration likely has more headroom than instruction shaving

Current code:

- MPC pairs and coefficients are generated in `rust/src/mpc.rs`.
- `MPC_MIN_DEPTH`, `MPC_T`, and `MPC_LIMIT` are fixed:
  `rust/src/mpc.rs:361`.

`strong++` is intentionally non-value-preserving, so the optimization surface is
empirical strength/time:

- tune `MPC_T`;
- test additional depth pairs beyond `(9,4)`;
- consider phase-specific thresholds;
- recalibrate after any eval change.

Risk:

- Medium. A faster setting can silently reduce strength.

Validation:

- `examples/match.rs` color-balanced matches.
- Equal-depth and time-matched comparisons:
  - `strong++` vs `strong+` at the same depth;
  - `strong++` one ply deeper vs `strong+`.

## Suggested order

1. Try the root aspiration value-only miss-pass path.
2. Benchmark all strong-family engines with `examples/bench.rs`.
3. If `scores` matters, test dynamic root scheduling while preserving worker-local
   TTs.
4. Only then try const-generic/split PVS specialization.
5. Treat exact solve improvements as a separate track with `bench_solve`.
6. Tune MPC with match results, not only wall-clock.

## Do not reattempt without new evidence

- SIMD ray-direction search integration.
- Batched `legal_moves_x8` in the search.
- Killer moves.
- PEXT/outflank flips in production search.
- PGO as a general win.
- Root-parallel `best_move`.

## Appendix: Claude review of Codex's strong-family findings (2026-06-15)

Independent pass, checked against the cited code and `rust/NOTES.md`. No code
changes in this appendix -- assessment only.

### Bottom line

None of these are the cheap, correctness-preserving slam-dunk that the queens
terminal-child fast path was. The genuine lever is **Finding 4** (the exact-solve
toolkit), which adds *capability* rather than shaving cycles, but it is a real
project. **Finding 3 I'd drop outright** -- `NOTES.md` already predicts it washes.
The rest are modest, path-scoped, benchmark-gated experiments.

### The cross-check Codex didn't make: NOTES already predicts Finding 3 is a wash

The two branches Finding 3 wants to const-generic away are `tt.plus()` (leaf eval,
`search.rs:258`) and `tt.mpc_on()` (`search.rs:310`). Both are predictable flag
reads -- `tt.rs:63`/`tt.rs:68` return a fixed bool for the entire search. `NOTES.md`
records **PGO = "wash -- inner loop already tight, branches predictable"**.
Eliminating predictable branches is exactly the win PGO already failed to produce.
Const-generic `pvs<const PLUS, const MPC>` also forces a 4-way monomorphization of
the whole hot recursion (I-cache pressure, and the const params must thread through
`pvs`, `pvs_root`, and the MPC probe calls) for a near-zero, already-measured-wash
gain. **Skip absent a profile that shows these branches actually costing.**

### Finding 4 is the real prize (and the only capability gain)

Empty-square list, specialized `solve_1..4` terminals, parity "fastest-first"
ordering, and stability cutoffs are the standard Logistello/Edax endgame toolkit,
genuinely unimplemented in `solve_pvs` (`search.rs:667`). They are worth multi-× on
`--depth full` (more tractable empties), not just constant-factor cycle shaving. It
is a substantial separate track with real test obligations -- Codex's randomized
near-terminal agreement check against the current `solve_pvs` (plus the existing
6 / -40 / 4 endgame values) is the right guard. `solve_1..4` + the empty list is the
conventional first increment.

### Finding 2 is sound but path-scoped

Confirmed: finite-depth `best_move` uses the *sequential* `search_strong_move`
(`engines.rs:443`); the static-chunk fan-out (`engines.rs:494-497`) only drives the
`--depth full` best move and the analysis/`scores` API (`game.rs:90`, `play.rs:26`,
`bench_parallel`). So this helps analysis/full-solve throughput, not per-move play.
`rayon::map_init` with a worker-local TT is the correct fix: dynamic work-stealing
*and* preserved per-worker TT reuse. Benchmark-gated via `bench_parallel`; medium
effort, worthwhile.

### Finding 1 is fail-high-only and adds a duplicate root path

On a fail-*low* aspiration pass every root move is searched regardless of order, so
ordering cannot help there; the benefit is confined to fail-*high* passes (hash move
first → earlier cut), a minority. It costs a value-only root variant alongside the
tie-break `pvs_root` (`search.rs:539`, whose LSB order is load-bearing for the
`best_by_side` tie-break). Benchmark-gated experiment, not a clear win.

### Finding 5 is free and safe

`idx` at `search.rs:677` is invariant through to the recompute at `search.rs:871`
(pure hash of the unchanged position + empty count). Reuse it -- but fold it in when
next touching `solve_pvs` (e.g. for Finding 4), not as a standalone change, per
Codex.

### Finding 6 is a strength track, not a code change

Tuning `MPC_T` / depth pairs (`mpc.rs:364-371`) is empirical: it needs
color-balanced, time-matched match-play to validate, and a faster setting silently
costs strength. A separate, slow-to-evaluate track from the code findings.

### Priority

| Finding                 | Verdict                                   | Priority                            |
|-------------------------|-------------------------------------------|-------------------------------------|
| 5 idx reuse             | correct, free, safe                       | fold in opportunistically           |
| 4 exact-solve toolkit   | high **capability** value, large          | the real prize for strength gains   |
| 2 `scores` map_init     | sound, path-scoped (analysis/full-solve)  | benchmark-gated, worthwhile         |
| 1 root aspiration order | fail-high-only, adds a dup path           | benchmark-gated experiment          |
| 6 MPC tuning            | strength track, match-play eval           | separate empirical track            |
| 3 const-generic PVS     | `NOTES.md` already predicts wash          | **skip** absent a profile           |

**Recommendation:** lead with Finding 4 if the goal is real strength/capability;
take Finding 2 (`map_init`) first if a quick benchmark-gated experiment is preferred;
drop Finding 3.

## Appendix: Codex reply to Claude's appendix (2026-06-15)

Claude's reply is sound. I would update the active priority list as follows:

- **Drop Finding 3 from the active queue.** The const-generic/split-PVS idea is
  plausible in isolation, but it targets predictable branches, and the project
  already has a strong "PGO was wash / branches predictable" data point. The code
  size and recursive duplication are not worth it without profile evidence.
- **Promote Finding 4.** Exact endgame improvements are the only item here that
  expands capability rather than shaving the current finite-depth play path. The
  first increment should be an explicit empty-square list plus specialized
  `solve_1..4`; leave stability cutoffs for later because they need more proof and
  testing.
- **Keep Finding 2 as the quick experiment.** Static chunking in `scores` is
  path-scoped, but `rayon::map_init` with worker-local TTs is the right shape if
  analysis/full-score throughput matters.
- **Downgrade Finding 1.** Root aspiration ordering only helps fail-high misses,
  not fail-low misses, and it adds a duplicate root path. Still valid as a
  benchmark experiment, but not first priority.
- **Finding 5 stays opportunistic.** Reuse the already-computed `idx` when
  touching `solve_pvs` for the endgame toolkit.
- **Finding 6 remains a separate strength-tuning project.** It needs match-play,
  not just speed benchmarks.

Revised recommendation:

1. If capability/strength matters: start the `solve_pvs` endgame toolkit.
2. If a small benchmark-gated experiment is preferred first: try `scores` dynamic
   scheduling with worker-local TTs.
3. Do not pursue const-generic PVS unless profiling points there.

## Implementation status (2026-06-15, Claude)

**Finding 4 — first increment: DONE.** TT-free leaf solver landed in
`rust/src/search.rs`:

- `solve_low` — TT-free / hint-free negamax over the explicit empty-square list
  (skips Kogge-Stone move-gen; flips computed for the search anyway double as the
  legality test), bottoming out in a `solve_1` base case.
- `solve_pvs` dispatches to it at/below `EMPTY_SOLVE_MAX` empties. A threshold
  sweep (`bench_solve`, `taskset -c 0-3`) picked **7** — the principled boundary
  just below `ENDGAME_ORDER_MIN`, replacing exactly the unordered/hint-only region.
  `≥10` keeps the TT-less region too large and loses transposition reuse.
- Wins (`make bench-solve`, before → after): 14 empties ~18→9 ms (2.1×),
  16 ~79→30 ms (2.6×), 18 ~1.30 s→0.46 s (2.8×). Finite-depth play is untouched
  (it never calls `solve`).
- **Finding 5 folded in**: `solve_pvs` now reuses the entry `idx` for the final
  store instead of recomputing.
- Value-preserving guard: new `exact_solve_matches_minimax_oracle_near_terminal`
  test (`tests/equivalence.rs`) cross-checks the full solve against the no-cache
  minimax oracle over bucketed near-terminal positions (handoff included). Full
  suite + clippy green; existing 6 / −40 / 4 endgame values unchanged.

**Still open** (in priority order):

- Finding 4 next increments: parity "fastest-first" ordering, unrolled
  `solve_2..4`, stability cutoffs.
- Finding 2 (`scores` `rayon::map_init` with worker-local TTs) — the quick
  benchmark-gated experiment.
- Finding 3 dropped; Finding 6 a separate match-play tuning track.
