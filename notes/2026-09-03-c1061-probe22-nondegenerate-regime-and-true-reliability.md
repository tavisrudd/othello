# C1061 probe 22: non-degenerate regime, true reliability, incremental counting

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 22, **stopped early on coordinator instruction** and written up as
documentation only. No new experiments were run after the stop; nothing below is a measurement
unless it says so.

## Status at the stop

| part | state |
|---|---|
| A — re-run the headline results in a regime where the shared budget binds | **not started**: no code, no measurements |
| B — true reliability by per-pod threshold decomposition | **implemented, unverified, unmeasured** |
| C — incremental top-k for the counting readout | **implemented, unverified, unmeasured** |

What is true of the code as committed: it builds, it is clippy-clean, and the six pre-existing
`fleet_semirings` tests still pass. What is **not** true: none of the new code has a test of its
own, and no instruction counts were taken for any of it. Treat every claim about parts B and C
below as a design statement awaiting verification, not a result.

All new code is in `src/fleet_semirings.rs`, appended below the probe 20 material.

## Part A — not started

The motivating finding stands from probe 20 and is unchanged: on the generated fleets the min-plus
knapsack is close to degenerate, because adding global parity capacity also raises the aggregate
data load, so the per-domain admissibility test tightens as fast as the budget loosens. The binding
resource is data-domain capacity, not the shared budget. Probe 20 found empirically that boosting
the six data-domain capacities alone moves the fleet into a regime where a level actually buys
repairs — best gain 579 with 7,833 optimal grant patterns on a 64-pod fleet — but that was a
one-off bench flag, not a generator, and no headline result was re-run under it.

**Nothing about the regime question has been settled.** Which of probe 12's commuting-leaf claim,
probe 15's 11.37x top-k ratio, probe 19's closure result and 11.40x end-to-end ratio, and probe 20's
semiring closure are regime-dependent is exactly as open as it was before this probe.

My expectation, recorded so a fresh session can falsify it rather than inherit it: the *structural*
results should be regime-independent, because commutation follows from `cost[from][to] = f(to - from)`
and closure follows from the alphabet, neither of which mentions the size of the discounts; the
*ratios* are the ones at risk, because a contended regime makes the top-k walk go deeper before its
slots fill, which is the one place the policy's cost depends on the discount structure.

## Part B — true reliability, implemented but unverified

### The design, and the answer to "is it a semiring readout"

Probe 20's negative was that the probability semiring sums over allocations, and those events
overlap, so it over-counts — by 20.0x on a three-pod fleet, returning a "probability" above 1. The
fix identified there was a per-pod threshold decomposition, and implementing it answers the question
the coordinator asked.

**It is a semiring readout, but over a different decomposition.** The probability semiring applied
to the *cost* decomposition sums over allocations and over-counts. Applied instead to the
distribution of **budget demand**, it is exact: each pod has a random threshold — the fewest levels
that leave nothing unserved — and the fleet is repairable exactly when every threshold is finite and
they sum to at most the grant bound. So the object to convolve is the threshold distribution, and
the convolution is the ordinary `(+, x)` truncated convolution. Nothing non-semiring is needed; the
earlier failure was choosing the wrong carrier, not the wrong semiring.

Two consequences worth stating: the events no longer overlap, because a fleet has exactly one
threshold vector rather than many admissible allocations; and truncation at the grant bound is
sound, since mass above it is exactly the infeasible mass.

### What was written

- `ThresholdDistribution::of_satisfaction` turns a profile's per-level satisfaction probabilities
  into threshold mass plus an `unrepairable` remainder, using the fact that satisfaction is
  nondecreasing in levels.
- `SpendDistribution` is the truncated convolution carrier, with `fold` (one pod), `combine` (two
  independent groups), and `feasible_mass`.
- `reliability_exact(distributions, counts)` folds pods of the same profile by **repeated squaring**
  of the truncated convolution, so a fleet costs `O(P log n)` combines of a four-entry vector rather
  than `O(n)`. It reads the count vector alone, so it is a candidate for the same compiled state.

### What is missing

- No test against direct summation on small fleets. The natural oracle already exists:
  `overlap_gap`'s exact branch enumerates per-pod threshold outcomes directly, and
  `reliability_exact` should reproduce its second return value.
- No scorer run, so whether the count vector stays closed under this readout is **unknown**. It
  should be — the readout is a function of the counts — but probe 20 established the habit of
  measuring that rather than assuming it.
- No instruction count.

## Part C — incremental counting, implemented but unverified

### The design

Probe 20 measured the counting readout at 627.3k instructions, about 470x the min-plus event,
because it enumerates every grant shape and every assignment of that shape's slots to profiles, so
its cost scales with the profile count rather than the grant bound.

The reduction: a grant spends at most `GRANT_BOUND` levels and therefore names at most that many
pods, so at each level the optimum can only use classes whose discount is among the top
`GRANT_BOUND` **distinct** values. `counting_candidates` collects exactly those classes, carrying
their full multiplicities so ties and exhausted classes are still handled, and
`optimal_pattern_count_incremental` runs the existing exact enumeration on that reduced set.

The correctness argument is that any assignment achieving the maximum uses, at each level, a class
whose discount is one of the values appearing in some optimal combination; with at most
`GRANT_BOUND` slots those values lie within the top `GRANT_BOUND` distinct discounts at that level.
Multiplicity is preserved because the candidate set carries the original counts.

### What is missing

- **No equality test against `optimal_pattern_count`.** This is the load-bearing gate and it is the
  first thing a fresh session should write: the two must agree on random fleets across seeds and pod
  counts, including fleets with ties and with singleton classes, which is where a candidate-set
  reduction is most likely to be wrong.
- No instruction count, so the claim that this removes the 470x gap is **entirely unverified**.

## Exact next steps for a fresh session

1. **Gate part C first.** Add a test asserting `optimal_pattern_count_incremental` equals
   `optimal_pattern_count` over random fleets, deliberately including tied discounts and
   count-one classes. If it disagrees, the candidate set is too small and the fix is to widen it to
   the top `GRANT_BOUND` distinct values *per level plus one*, not to abandon the reduction.
2. **Gate part B second.** Assert `reliability_exact` equals the exact branch of `overlap_gap` on
   three- and four-pod fleets, then run the congruence scorer with reliability as the observable —
   quantized to a fixed-point integer, since the scorer's observable column is `i64`.
3. **Measure both** with the pinned-binary, fixed-window harness: add `semiring-reliability` and
   `semiring-counting-incremental` operations to `summary_cache_bench`, add them and their
   comparisons to `scripts/counter_ab.py`, and report against the 627.3k and 650.0k baselines from
   probe 20's `evidence/2026-09-03-lrc-fleet-counter-ab-probe20.json`.
4. **Then do part A**, which is untouched: write a contended-fleet generator (high data-domain
   capacities, low local and global parity, moderate demand) as a named function rather than a bench
   flag, and re-run probe 12's commutation check, probe 15's top-k ratio, probe 19's closure and
   end-to-end ratio, and probe 20's semiring closure under it. Report which results moved.
5. Carry forward the two process items from probes 15 and 20: the shared git index is not safe under
   concurrent agents — a per-agent worktree or `GIT_INDEX_FILE` is the only reliable fix — and every
   counter campaign should include a containment pair, a part-versus-whole operation, as a standing
   sanity check.

## Mystery ledger

- **Whether any headline result is regime-dependent is completely open**, and it is the question
  probe 22 existed to answer. The exactness results rest on arguments that do not mention discount
  magnitudes, so they should survive; the performance ratios rest on the top-k walk terminating
  early, which a contended regime could change. Neither half is measured.
- **The threshold decomposition may restore the semiring framing in full.** If reliability really is
  a truncated convolution over budget demand, then probe 20's "not a semiring readout" caveat is
  itself too strong and should be narrowed to "not a semiring readout over the cost decomposition".
  That rewording is warranted only once the oracle test passes.
- **The candidate-set reduction is the kind of optimization that is wrong on ties.** It is written
  and unverified, which is the worst state for code of that shape; it should not be used until the
  equality test exists.

## Validation

```
cargo fmt -p ergodis-private
cargo clippy -p ergodis-private --all-targets -- -D warnings   # my files clean
cargo test -p ergodis-private --lib fleet_semirings --release  # 6 pre-existing tests pass
```

The crate-wide clippy run fails on three `unused_mut` lints in probe 21's `src/dynamic_routing.rs`,
which I have not touched; no error points at any file of mine.

## Vibe check

An unsatisfying stop, honestly recorded. Parts B and C are written and I believe both are right —
the threshold decomposition in particular looks like the clean answer to probe 20's negative, and it
reframes that negative as a wrong-carrier problem rather than a limit of semirings — but neither has
a test or a number, so neither is a result. Part A, the question the probe was actually named for,
was not started. The next session should gate the two implementations before trusting them and then
do the regime work, which remains the open question that matters most for interpreting the whole
probe series.

## Log addendum, 2026-09-03: commit provenance

Stopped as documentation in ergodis-private `305373d` (one path).
