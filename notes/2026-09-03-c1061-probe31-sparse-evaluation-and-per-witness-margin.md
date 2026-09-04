# C1061 probe 31: sparse position evaluation, the per-witness margin, and a matching oracle

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 31, continuing
`notes/2026-09-03-c1061-probe30-margin-certificate-predecoder.md`.

Contract documents read in full before this line of probes:
`/home/tavis/src/ergodis/CLAUDE.md`, `/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`.

**Status: paused by the coordinator partway through, after the machinery landed and before the
timed and census measurements were taken.** This report records exactly what is established, what is
built but unmeasured, and the precise next steps. All committed code builds, is `clippy` clean, and
its gates pass; nothing is left uncommitted.

## The premise probe 30 left

The margin certificate covers 97.4% of windows at surface distance 5, 7 and 9 through one
distance-independent 1,024-byte table. It loses on cost — 415.50 instructions per commit position
times `O(d^2)` positions is 32,825 instructions per committed round against PyMatching's 2,296 — and
its distance-9 margin is extrapolated rather than audited, because the metric-closure oracle stops at
surface distance 3.

## What is established

### The clean-ball lemma, proved and gated

**Lemma.** Let `B` be the ball of a commit position, and suppose the observed ball syndrome is zero.
Then `W_0 = 0`, because the empty set is a local explanation with empty commit restriction. For any
action `a ≠ 0`, a set `X` with `∂X|_B = 0` and `X|_R = a` must contain the commit mechanisms of `a`
together with enough further mechanisms to cancel their ball boundary, so `W_a(0) ≥ g_R`, where

```text
g_R = min over a ≠ 0 of W_a(0)
```

is the **local girth through the commit region** — the size of the smallest mechanism set that is
boundary-free inside `B` and changes the commit action. `g_R` depends only on the ball, and is read
directly off the escaped-ball metric at syndrome zero. Whenever `g_R ≥ Δ`, the margin condition
`W_0 + Δ ≤ min_{a ≠ 0} W_a` holds, so **a position whose ball contains no defect commits the empty
correction safely, without being evaluated.**

The lemma is an identity of the compiled policy, not an approximation of it: the table's entry at ball
syndrome zero *is* the empty action exactly when `g_R ≥ Δ`. So skipping defect-free positions changes
no decision at all, provided the evaluation order is preserved.

Gated three ways, all passing:

| Gate | What it establishes |
|---|---|
| `a_defect_free_ball_commits_the_empty_correction` | at surface distance 5, 7 and 9, for **every** commit position whose ball fits, the compiled table's zero entry is the empty action at `Δ = 2` |
| `the_local_girth_is_at_least_two_everywhere` | the girth is at least 2 at every repetition-code position, so `Δ ≤ 2` always admits the lemma |
| `the_sparse_sweep_equals_the_dense_sweep` | over 2,000 planted shots at surface distance 5, the sparse and dense sweeps agree on the residual syndrome, the committed weight **and** the defer count, and the sparse one evaluates strictly fewer positions |

The third gate caught a real defect during this probe and is worth recording: evaluation **order**
matters. Each commit rewrites the syndrome, so a different processing order is a different (still
sound) policy. The first implementation processed the worklist in defect-discovery order and disagreed
with the dense sweep on defer counts, 6 against 7. The fix is to keep the worklist in ascending
position order and re-sort only the unprocessed tail when a commit wakes a new position, which is rare.
With that, sparse evaluation is *equal* to dense evaluation rather than merely close to it.

### An exact matching oracle, and why it lifts the audit

Every mechanism of a phenomenological repetition or rotated-surface-code decoding graph flips at most
two detectors, so the graph is a matching graph. The minimum-weight explanation of a defect set is
then a minimum-weight perfect matching of the defects on the metric closure of the detector graph,
with a virtual boundary node reached through the one-detector mechanisms. Unit edge weights make the
detector metric one breadth-first search per detector, and the matching over `k` defects is a `2^k`
subset dynamic program — exact, and trivial at the defect counts an audit uses.

This replaces probe 30's `2^detectors` metric closure, which is what confined that audit to surface
distance 3.

| Gate | What it establishes |
|---|---|
| `the_matching_oracle_agrees_with_the_metric_closure` | on **every** syndrome of repetition `(5,3)` and `(3,4)` and surface `(3,2)`, the oracle equals the closure, including agreeing on which syndromes are unexplainable |
| `the_oracle_audit_agrees_with_the_closure_audit` | at `Δ = 0, 1, 2, 3` on surface distance 3, the oracle-based audit and probe 30's closure-based audit reach the same soundness verdict |

The audit driver `audit_with_oracle` is built and gated. It enumerates every defect subset of size at
most `max_weight` drawn from the ball and its immediate shell, checks the handoff identity
`globalmin = |a| + residualmin` through the oracle, and reports violations and worst excess.
Restricting the support to the ball's neighbourhood is what makes it tractable at distance 5: the
decision reads only `s|_B`, so a defect far from the ball cannot change it.

### The per-witness margin: an algebraic negative, established

Probe 30 bounded the outside advantage by `R_max`, the largest outside repair cost over the whole
crossing subspace, and the natural sharpening is to make it witness-specific:
`Δ(c_a) = max over c* of R(c_a ^ c*)`.

**That substitution tightens nothing, and the reason is structural.** The crossing patterns form a
group under symmetric difference, so as `c*` ranges over the subspace, `c_a ^ c*` ranges over the same
subspace. Hence `Δ(c_a) = R_max` identically, for every witness. The per-witness idea cannot work as
stated; the quantifier it re-indexes is over a coset of a group that equals the group.

What can tighten the bound is conditioning on **observation** — restricting which `c*` a
minimum-weight global solution could plausibly use, given the outside defects actually seen near the
ball. That is a different construction, and the defensible way to get it is to measure the smallest sound
`Δ` conditioned on the shell syndrome class using the oracle audit, rather than to assert a bound whose
proof I could not close. This is recorded as a redirect, not a result.

## What is built but unmeasured

Everything below compiles, is gated where a gate exists, and is committed. None of it has been run as
a census or a timed arm, because the probe was paused.

1. **The sparse sweep's cost.** `sparse_sweep` with its compressed-sparse-row `PositionIndex` and
   presized `SparseWorkspace` — worklist, generation stamps, defect list, working syndrome — is
   written and proven equal to the dense sweep. **Its instruction count has not been measured.** The
   expected shape is `O(defects × positions-per-detector)` rather than `O(d^2)`, but no number exists.
2. **The audit at surface distance 5.** `audit_with_oracle` is gated against the closure audit at
   distance 3 but has not been run at distance 5, so `Δ = 2` there remains extrapolated, exactly as it
   was at the end of probe 30.
3. **The observation-conditioned margin.** No measurement.
4. **No bench subcommand was written.** All of probe 31's machinery is library code with tests; there
   is no `ergodis-tools` entry point for it yet, so there are no census tables in this report.

## Precise next steps

In this order, because each unblocks the next.

1. **Run the distance-5 audit.** Call `smallest_audited_margin` on `surface_graph(d = 5, rounds = 4)`
   at radius 1 with `max_weight = 4`. This is a few lines in a bench subcommand and answers probe 30's
   single largest open item — whether `Δ = 2` at distance 5 is sound or merely extrapolated. Watch the
   subset enumeration: the ball-plus-shell support at radius 1 is roughly 30 detectors, so weight-4
   subsets number about 27,000, which is fine, but weight 5 would be 140,000 times an oracle call each.
2. **Add a `sparse-margin-bench` subcommand** with `audit`, `girth`, and `sweep` modes, following
   `margin_certificate_bench.rs`. The `sweep` mode must use `plant_into` and the presized workspace so
   the timed loop allocates nothing, and must run both sweeps under a `--verify` flag that asserts
   equality before timing.
3. **Measure instructions per committed round**, surface distance 5, 7 and 9 at
   `p ∈ {0.001, 0.005, 0.01, 0.02, 0.05}`, two-size differencing on `--operations`, seven interleaved
   rounds, pinned binary and SHA-256. Report the ratio against PyMatching's 2,296 per shot at distance
   9 and the composed figure charging deferred shots. The Fermi estimate from probe 30 still stands and
   should be checked against the measurement: at 1% error a distance-9 six-round shot has roughly 30
   defects, each waking about 10 positions, so about 300 evaluations against the dense 79 — **the
   sparse sweep may well be slower at 1% error and only win at low `p`**, which is the specific thing
   the sweep at `p = 0.001` will settle.
4. **Only then** attempt the observation-conditioned margin, using the oracle audit to measure the
   smallest sound `Δ` conditioned on the shell being clean versus not.

## Mystery ledger

- **Evaluation order changes the policy.** Two sound orders give different defer counts, 6 against 7
  on one shot. Settled operationally by fixing ascending position order, but it means "the certified
  local predecoder" is really a family of policies indexed by a schedule, and no schedule has been
  shown best. Not characterized.
- **The sparse sweep may not be faster at the error rate that matters.** At 1% on a distance-9
  six-round graph the defect count is high enough that the woken-position set could exceed the 79
  positions a dense sweep visits. This is a genuine risk to part A's premise and is the first thing
  the measurement should check.
- **The per-witness margin is dead as posed**, by the group argument above. What is not settled is
  whether the observation-conditioned version recovers anything, because it was not reached.
- **The girth `g_R` is at least 2 everywhere tested but was never tabulated per position.** It bounds
  the largest usable margin under the clean-ball lemma, so a position with girth 2 cannot use `Δ = 3`.
  Whether any position has girth exactly 2 on the surface code is unmeasured, and it is a one-line
  census.

## Files and commands

All work is in `ergodis-private`, committed as `8a75f0a`. `/home/tavis/src/ergodis` was not modified;
the concurrent agent's `tiger_blossom*` modules were not touched. The only shared file touched is
`src/lib.rs`, one added module line, staged as an explicit pathspec.

- `/home/tavis/src/ergodis-private/src/sparse_margin_predecoder.rs` — the clean-ball lemma and
  `local_girth`, the `MatchingOracle`, `audit_with_oracle` and `smallest_audited_margin`, the
  `PositionIndex` and `SparseWorkspace`, `sparse_sweep` and the `dense_sweep` reference, and the five
  gates.

```
cd /home/tavis/src/ergodis-private
cargo fmt -p ergodis-private
cargo clippy -p ergodis-private --lib -- -D warnings                                    # clean
cargo test --release -p ergodis-private --lib -- \
    sparse_margin_predecoder margin_certificate local_commit                            # 17 passed
```

## Vibe check

Paused in a good place rather than a ragged one. The two pieces that needed to exist before any
measurement now exist and are gated: the clean-ball lemma, which makes sparse evaluation provably
identical to dense evaluation rather than an approximation, and an exact matching oracle that agrees
with the metric closure everywhere both can be run and lifts the audit past the distance-3 ceiling.
The per-witness margin turned out to be dead on arrival for a clean structural reason worth keeping.
What is missing is entirely measurement, and the one number that would decide part A — whether the
sparse sweep is actually cheaper at 1% error, where the defect count is high enough that it may not be
— is a single bench run away.
