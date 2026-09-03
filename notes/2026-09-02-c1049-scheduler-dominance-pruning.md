# C1049: certified state-dominance pruning for the scheduler frontier

**Lane**: `complete-ports`
**Date**: 2026-09-02
**Status**: complete; uncommitted, left in worktree `c1049-dominance` for review.

Headline: the L2 row goes from 163.2 s to 9.4 s (17.34x) with the optimum, the
witness assignment, the transition count and the peak frontier all bit-identical
to the pre-change binary, and with every one of its 632,666 deletions certified
by a witness that an independent checker replays in 10.3 ms. A second, coarser
relation that preserves the optimum but not the choice of optimal assignment
reaches 2.4 s (66.74x) and is implemented but off by default.

Goal: absorb the C1038 L2 shape — six-resource generic-load scheduling, where
CP-SAT answers in about 9 ms and Ergodis takes 137 s — with certified
state-dominance pruning of the dynamic-programming frontier.

Abbreviations expanded on first use. CP-SAT is the constraint-programming
Boolean satisfiability solver of Google OR-Tools. DP is dynamic programming.
SWAR is SIMD-within-a-register, the technique of packing several small integer
lanes into one machine word and operating on all of them with a single
arithmetic instruction. RSS is resident set size.

## 1. Where L2's time actually goes

The task and the C1038 diagnosis both name "transitions grow near-cubically" as
L2's cost. Profiling the retained pre-change binary says otherwise, and the
correction is load-bearing for the whole design.

`perf record` on the retained baseline `negative_control_tier-7062bbfee`
(SHA-256 `b11350328e3a4b33aa425db76f73f6064eace221aaf5f8451a466ee55ea08cc7`),
solving row L2, puts 99.95% of samples in the inlined
`WeightedRepairProblem::solve` and, at source-line resolution, 93% of those in a
single 80-byte instruction window. Disassembling that window identifies it
exactly: a 16-byte-stride walk over `ScheduleState` with a `repairs` compare at
field offset 8 followed by a scalar four-byte-at-a-time load comparison loop.
That is `state_is_pareto`, called once per state by
`quadratic_pareto_keep_into`.

So L2 executes only 1.47 million transitions but performs roughly
`sum over layers of (states in layer)^2 * 6` load comparisons in frontier
maintenance. At a peak of 111,079 states the final layer alone is about
7.4 x 10^10 comparisons. The loss is frontier bookkeeping, not search. Cost per
transition rising in proportion to frontier size — which is what the C1038
scaling probe recorded — is the signature of exactly this all-pairs scan.

This changes what "add dominance pruning" has to mean. Dominance pruning is
already present: `state_is_pareto` implements it. What is missing is (a) a way
to *decide* it that is not all-pairs, and (b) any certificate that the pruning
it performs is sound. C1049 supplies both.

## 2. The dominance relation and its proof obligation

Fix a layer `k` (demands `0..k` decided, demands `k..n` remaining). A DP state
is a pair `(u, r)`: `u` in `Z^w` is the vector of committed loads on the `w`
resources, and `r` is the number of demands repaired so far. A *completion* from
a state is a choice of at most one option per remaining demand; it is *feasible*
from `(u, r)` when `u + load(c) <= cap` componentwise, and its value is
`r + |c|`, the total repair count.

**Definition (exact dominance).** `s = (u_s, r_s)` dominates `t = (u_t, r_t)`
when `u_s <= u_t` componentwise and `r_s >= r_t`.

**Proof obligation.** If `s` dominates `t`, then every completion feasible from
`t` is feasible from `s` at no greater load and no smaller repair count.

**Proof.** Let `c` be feasible from `t`, so `u_t + load(c) <= cap`. Since
`u_s <= u_t`, `u_s + load(c) <= u_t + load(c) <= cap`, so `c` is feasible from
`s`. Its value from `s` is `r_s + |c| >= r_t + |c|`, its value from `t`. Hence
`opt(s) >= opt(t)`, where `opt` is the best total repair count reachable, and
deleting `t` from the frontier cannot lower the layer's optimum. []

Dominance is transitive: if `x` dominates `t` and `y` dominates `x` then
`u_y <= u_x <= u_t` and `r_y >= r_x >= r_t`, so `y` dominates `t`. Transitivity
is what makes it sound to compare each state only against the states already
*kept*, rather than against all states — the reduction the new scan relies on.

**Definition (clamped dominance).** Let `M_c(k) = sum over demands d >= k of the
maximum load any option of `d` places on resource `c`. No completion from layer
`k` can consume more than `M_c(k)` on resource `c`. Define the *clamped
residual* `v_c(u) = min(cap_c - u_c, M_c(k))`. Then `s` dominates `t` whenever
`v(u_s) >= v(u_t)` componentwise and `r_s >= r_t`.

**Proof.** Let `c` be feasible from `t` with consumption `x`. Then
`x_c <= cap_c - u_t[c]` and `x_c <= M_c(k)`, so
`x_c <= v_c(u_t) <= v_c(u_s) <= cap_c - u_s[c]`. Feasibility from `s` follows,
and the value argument is unchanged. []

Clamped dominance is strictly coarser than exact dominance (exact dominance is
the case `M_c = infinity`), so it prunes at least as much. It is not
witness-preserving: it can delete a state whose descendants would have carried
the lexicographically preferred optimal assignment that `select_best_witness`
returns, even though the optimal repair count is unchanged. It is therefore
implemented but not the default. See section 8.

## 3. Witness format and the replay checker

Every prune emits one fixed-size record. The record is self-contained: an
independent checker re-evaluates the comparison from the record's own contents
and never re-solves, re-expands, or consults the DP.

Lane layout (`DominanceLayout`): for resource `c` with capacity `cap_c`, take
`value_bits(c) = ceil(log2(cap_c + 1))` and a lane width of
`value_bits(c) + 1` bits; the extra bit is a guard that is always zero in a
stored value. Lanes are laid out from bit 0 upward in resource order. The layout
exists only when the lanes total at most 64 bits; otherwise pruning falls back
to the legacy scan and emits no witnesses.

```text
#[repr(C)] struct DominanceWitness {
    packed_dominator: u64,   // clamped residual vector of the surviving state
    packed_pruned:    u64,   // clamped residual vector of the deleted state
    dominator:        u32,   // frontier index of the survivor within its layer
    pruned:           u32,   // frontier index of the deleted state
    dominator_repairs:u32,
    pruned_repairs:   u32,
}   // 32 bytes, align 8
```

Layer boundaries are recorded separately as a `layer_starts` prefix array, so
the record itself carries no layer field.

**Replay.** For each record the checker, given only the layout, verifies:

1. `dominator != pruned`;
2. `dominator_repairs >= pruned_repairs`;
3. for every resource `c`, `lane(packed_dominator, c) >= lane(packed_pruned, c)`,
   unpacked coordinate by coordinate with shifts and masks — deliberately not
   the SWAR comparison the solver uses, so the checker is an independent
   implementation of the same predicate rather than a re-run of it; and
4. every lane of both vectors is below its lane limit, so no value has
   overflowed into a neighbouring lane or into a guard bit.

Any violation returns an error naming the offending record index. Replay is
`O(w)` per record with no allocation and no access to the problem or the DP.

## 4. Implementation

All the machinery is in the new module
`papers/complete-repair-ports/ergodis/src/scheduler_dominance.rs`. The scan
replaces the all-pairs test with three exact reductions, each of which preserves
the decided antichain exactly:

1. **Residual packing.** Each state's residual vector `cap - u` is packed into
   one `u64` at layer entry, `O(states * w)` for the layer. The componentwise
   test `residual(s) >= residual(t)` then becomes
   `((s | guard) - t) & guard == guard`: a single borrow-free lane subtraction
   replacing `w` dependent four-byte compares with unpredictable branches. The
   guard bit per lane is what stops a borrow crossing between resources.
2. **Kept-only comparison.** By transitivity a state need only be compared
   against states already *kept*. This also makes every recorded dominator a
   surviving state, which is what a reader of the certificate wants.
3. **Monotone visit order.** States are visited in descending residual mass,
   with repairs descending as the tie-break. A dominator's residual is at least
   the dominated state's in every coordinate, so its mass is at least as large
   and it is always visited first; the kept prefix is therefore the complete
   candidate set at the moment each state is tested.

Under the exact relation, load vectors within a layer are unique (the frontier's
hash chain dedupes on insertion), so a strict dominator has *strictly* greater
residual mass and the ordering argument is tight.

The scan allocates nothing. Every buffer — packed residuals, masses, the visit
permutation, the kept list and its parallel packed and repair arrays — is
cleared and reserved at layer entry and only written thereafter. On a reused
workspace the reserves are no-ops, which is what the zero-allocation test
observes.

**Bounds.** The comparison budget is `DOMINANCE_COMPARISON_BUDGET = 2^22`
(4,194,304) candidates per state and the witness buffer is
`DOMINANCE_WITNESS_CAPACITY = 2^20` (1,048,576) records, 32 MiB. Both are safety
valves rather than pruning policy: exceeding either causes the state to be
*kept*, which is always sound because an unpruned frontier can only add work.
Neither bound was reached on any measured row — the counters
`budget_exhausted` and `witness_capacity_exhausted` are zero everywhere, and the
A/B driver asserts that. Had either bound bound, results would still be exact but
pruning would weaken, so the assertions are what make "exact parity" a measured
fact rather than an assumption.

**Suffix clamping.** `DominanceMode::ClampedSuffix` additionally computes, once
per solve, each demand's maximum load on each resource, sums them into a suffix
maximum, and decrements it layer by layer. The exact relation never touches this
table, so it costs nothing when unused.

### Exact lines touched outside the new module

`src/lib.rs`, 5 lines added: `pub mod scheduler_dominance;` beside `pub mod
scheduler;`, and a four-line `pub use scheduler_dominance::{...}` re-export block
after the existing `pub use scheduler::{...}`.

`src/scheduler.rs`, 19 hunks, 316 lines added and 2 changed. 167 of the added
lines are new tests appended at the end of `mod tests`; the rest are:

| region | change |
| :----- | :----- |
| after the `thiserror` import | 7-line `use crate::scheduler_dominance::{...}` |
| `WeightedParallelRepairResult` derive | `PartialEq, Eq` dropped from the derive list (1 line changed) |
| `WeightedParallelRepairResult` fields | 4 certificate fields, 9 lines with docs |
| before `impl WeightedParallelRepairResult` | 19-line hand-written `PartialEq`/`Eq` comparing the answer only |
| `impl WeightedParallelRepairResult` | 22 lines: `dominance_witness_bytes`, `replay_dominance` |
| `SparseRepairStorage` fields | 3 lines: `dominance`, `frontier` |
| `WeightedRepairWorkspace::shrink_to_fit` | 2 lines |
| `WeightedRepairProblem` fields | 2 lines: `dominance_mode` |
| `finish_compiled_problem` literal | 1 line initializing `dominance_mode` |
| after `recommended_backend()` | 21 lines: `dominance_mode`, `set_dominance_mode`, `with_dominance_mode` |
| `solve_sparse_with_storage` prologue | 21 lines preparing the storage and the suffix maxima |
| `solve_sparse_with_storage` keep site | 11 lines wrapping the existing call in the certified attempt and its fallback |
| the sparse result literal | 4 lines |
| the three other result literals | 4 lines each |

No existing scheduler code was reordered or reformatted, and
`quadratic_pareto_keep_into` is unchanged and still reachable — it is both the
fallback when no lane layout exists and the in-process A/B control.

**Merge note for the concurrent counted-type work.** The only likely textual
conflict is that both changes append to the end of `mod tests` in
`src/scheduler.rs`. Both additions should simply be kept. Nothing else in this
branch touches the regions `solve_counted_types` would occupy.

## 5. Parity evidence

The strongest parity evidence is that the certified scan reproduces the C1038
recorded work counters on the L2 row *exactly*, to the unit:

| quantity | C1038 recorded | C1049 certified (exact relation) |
| :------- | -------------: | -------------------------------: |
| repairs (the optimum) | 10 | 10 |
| transitions examined | 1,466,440 | 1,466,440 |
| peak frontier states | 111,079 | 111,079 |

Transitions and peak states are functions of the retained frontier at every
layer, so equality of both across eighteen layers means the certified scan
decided the same antichain at every layer, not merely that it found the same
optimum. Both exhaustion counters are zero, so no state was kept for want of
budget or witness space.

Test coverage added, all passing:

- `certified_dominance_matches_the_legacy_scan_on_generic_load_instances` — 16
  seeded four-resource instances; asserts equality of assignment, repair count,
  total loads, unmatched demands, peak states, and transitions between the
  legacy all-pairs scan and the certified scan, and replays the certificate.
- `certified_dominance_prunes_and_replays_on_an_l2_shaped_instance` — the L2
  shape at a unit-test size; asserts the assignment matches the legacy scan,
  that pruning actually happened, and that the certificate replays.
- `clamped_dominance_preserves_the_optimal_repair_count` — 12 seeds; asserts the
  optimum agrees with the legacy scan. The assignment is deliberately not
  asserted, for the reason in section 2.
- `a_forged_scheduler_witness_is_rejected_by_the_replay_checker` — takes a real
  solve's certificate and corrupts it two ways (swapping the dominator and
  pruned roles, and naming a state as its own dominator); both are rejected.
- `warm_dominance_scan_allocates_nothing_after_warm_up` — warms the workspace
  with four solves, then re-enters the pruned scan four more times inside the
  measured region and asserts zero allocations, reallocations, and
  deallocations, with pruning confirmed to have occurred.
- In `scheduler_dominance`: an exhaustive check that the packed comparison
  agrees with the coordinate comparison over every pair of two-resource vectors;
  a 200-instance randomized check that the certified scan's kept set equals the
  all-pairs kept set; and a six-way forged-witness rejection test covering each
  error variant.

The pre-existing property test `weighted_repaired_count_matches_brute_force`,
which compares the scheduler against brute-force enumeration, passes unchanged
on the certified default path.

The negative-control example now replays the dominance certificate on every
scheduler row it runs and asserts that the verified count equals the pruned
count, so the parity check is part of the tier's own replay rather than only a
unit test.

## 6. A/B measurements

### Protocol

Two comparisons are reported, because they answer different questions.

**End to end, against the retained control.** The pre-change executable was
retained with `scripts/retain-bin.sh . negative_control_tier --example` *before
any source edit*, as `negative_control_tier-7062bbfee`, SHA-256
`b11350328e3a4b33aa425db76f73f6064eace221aaf5f8451a466ee55ea08cc7`, recorded in
`~/.cache/ergodis/bin/MANIFEST.tsv` at revision 7062bbfee, clean, rustc 1.93.1,
release profile. This is the whole-process comparison: parsing, compilation,
startup, solve, certificate replay, and output are inside the timed region on
both sides.

**Relation by relation, in process.** The `c1049_l2_dominance_ab` example builds
the same instance and solves it under each of the three relations, timing
`solve()` only. Its `legacy` arm runs `quadratic_pareto_keep_into`, unchanged
from the baseline, so it is a faithful control for the algorithm even though it
is not a separate executable; the retained binary covers the executable-level
comparison. Rounds are interleaved with the relation order rotated per round and
the size order rotated per round, both sides pinned to CPU 3 with `taskset`
under `choom -n 1000`, single-threaded. Raw samples are streamed as they
complete to `evidence/c1049-l2-dominance-ab.tsv` and reduced by
`scripts/c1049_dominance_ab_summary.py`, which asserts that every exact column
is identical across rounds before taking the median of wall times.

### A discarded first run

The first ladder run was taken while `cargo clippy` and `cargo test
--all-features` were running on the same host. Interleaving shares contention
between the arms, so the ordering survived, but the absolute times were inflated
by roughly a factor of two against the C1038 reference — the legacy arm at 18
demands read 303 s where C1038 recorded 137 s. That run is retained as
`evidence/c1049-l2-dominance-ab.contended.tsv` and is not used for any number in
this report; it is kept only because its exact columns match the clean run's,
which is itself a parity check across two independent runs. The measurements
below are from a rerun on an otherwise idle host.

### L2 end to end, against the retained control

Three interleaved rounds, arm order rotated, whole process, pinned to CPU 3
under `choom -n 1000`, counters from `perf stat`. Replay:
`scripts/c1049-retained-ab.sh 3 L2`; raw samples
`evidence/c1049-l2-retained-ab.tsv`.

| arm | median wall | speedup | peak RSS | answer | transitions | peak states |
| :-- | ----------: | ------: | -------: | -----: | ----------: | ----------: |
| retained control | 163.206 s | — | 29,232 KiB | 10 | 1,466,440 | 111,079 |
| exact, certified | 9.411 s | 17.34x | 79,164 KiB | 10 | 1,466,440 | 111,079 |
| clamped, certified | 2.445 s | 66.74x | 53,396 KiB | 10 | 918,092 | 48,491 |

The control and the exact arm agree on answer, transitions, and peak states to
the unit, which is the end-to-end form of the parity claim: the same binary
interface, the same instance, the same frontier at every layer, 17x less time.

Hardware counters, medians over the three rounds:

| arm | instructions | cycles | branches | branch misses | miss rate | IPC |
| :-- | -----------: | -----: | -------: | ------------: | --------: | --: |
| retained control | 1.917 x 10^12 | 7.375 x 10^11 | 6.528 x 10^11 | 1.253 x 10^10 | 1.92% | 2.60 |
| exact, certified | 2.902 x 10^11 | 4.324 x 10^10 | 1.167 x 10^11 | 3.542 x 10^7 | 0.03% | 6.71 |
| clamped, certified | 7.336 x 10^10 | 1.122 x 10^10 | 2.919 x 10^10 | 1.500 x 10^7 | 0.05% | 6.54 |

The counters decompose the exact arm's 17.3x almost exactly: 6.6x fewer
instructions, multiplied by 2.58x better instructions per cycle, is 17.0x. The
instruction reduction is the SWAR packing replacing `w` scalar compares with one
lane subtraction. The IPC gain has a single identifiable cause — branch misses
fall by a factor of 354 and the miss rate from 1.92% to 0.03% — because the old
inner loop's per-coordinate early exit is data-dependent and unpredictable,
while the packed comparison is branchless within a candidate. This is the case
`PERFORMANCE.md` warns is not automatic: here the branchless form both removes
instructions and shortens the dependency chain, and the measurement says so
rather than the design asserting it.

**The cost is memory.** Peak RSS rises from 29.2 MiB to 79.2 MiB under the exact
relation, +171%, and to 53.4 MiB under the clamped relation. Most of that is the
certificate itself — 20,245,384 bytes exact, 14,681,960 bytes clamped — with the
rest the scan's packed, mass, order and kept arrays. Certification is not free
in memory even though it is nearly free in time; a caller that wants the speed
without the certificate would need a mode that prunes without recording, which
is not implemented and which I would not add without a request, since the
certificate is the point of the task.

**Against CP-SAT.** C1038 recorded CP-SAT at 9.125 ms on this row. Taking that
figure at face value, the residual gap is about 1,031x under the exact relation
and 268x under the clamped relation, down from 15,019x. Those two numbers are
weaker evidence than everything else here: CP-SAT was not re-measured in this
session, and my retained control reads 163.2 s where C1038 recorded 137.1 s for
its own earlier binary, so the two sides are not from the same host state. The
ratios *within* this session — 17.34x and 66.74x against the same-session
retained control — are the numbers I stand behind.

### No regression on the other tier rows

Three interleaved rounds per row, same protocol. Replay:
`scripts/c1049-retained-ab.sh 3 <row>`; raw samples
`evidence/c1049-regression-rows-ab.tsv`.

| row | control | exact | clamped | answer | transitions | peak states |
| :-- | ------: | ----: | ------: | -----: | ----------: | ----------: |
| L1 | 21.871 ms | 21.799 ms | 21.751 ms | 1 | 1 | 18,911,322 |
| L3 | 0.006 ms | 0.006 ms | 0.006 ms | declined | 0 | 0 |
| W1 | 0.060 ms | 0.058 ms | 0.061 ms | 1 | 1 | 16,622 |
| W2 | 3.072 ms | 2.870 ms | 2.788 ms | 60 | 2,488,335 | 2,461 |
| W3 | 1,278.162 ms | 1,276.676 ms | 1,280.329 ms | 300 | 172,078,925 | 22,801 |

Every answer, transition count and peak-state count is identical across all
three arms and identical to the values C1038 recorded. Peak RSS is unchanged on
every row to within 0.3 MiB. The differences in wall time are all inside
round-to-round noise, which is expected: none of these rows reaches the sparse
Pareto scan. W2 carries a positive grading, so the frontier is a proven
antichain and no pruning runs at all; W3 and L1's compiled forms take the
dense-lattice and bounded-subset-sum kernels; L3 is declined before solving. The
`pruned_states` counter is zero on every one of them, which is the direct
confirmation that the new code path is not entered.

### The L2 scaling ladder

Three interleaved rounds per cell, medians of wall time, solve only.
`scripts/c1049_dominance_ab_summary.py` asserts before reporting that every
exact column — repairs, transitions, peak states, pruned states, comparisons,
witness bytes, verified count — is identical across all three rounds of a cell,
and it is. Raw samples: `evidence/c1049-l2-dominance-ab.tsv`; reduction:
`evidence/c1049-l2-dominance-ab.summary.tsv`.

| demands | legacy (ms) | exact (ms) | clamped (ms) | exact speedup | clamped speedup |
| ------: | ----------: | ---------: | -----------: | ------------: | --------------: |
| 8 | 134.479 | 14.077 | 0.307 | 9.55x | 437.49x |
| 10 | 1,644.337 | 141.112 | 4.720 | 11.65x | 348.35x |
| 12 | 10,086.528 | 698.352 | 36.258 | 14.44x | 278.19x |
| 14 | 30,228.804 | 1,859.466 | 281.998 | 16.26x | 107.20x |
| 16 | 69,905.185 | 4,585.717 | 2,463.349 | 15.24x | 28.38x |
| 18 | 171,169.079 | 11,947.164 | 2,864.110 | 14.33x | 59.76x |

The exact relation's speedup is roughly constant at 9x to 16x across the ladder,
which is the signature of a constant-factor win on an unchanged asymptotic: the
scan is still quadratic in the frontier, each comparison is just far cheaper.
The clamped relation's advantage *shrinks* with size, from 437x to about 60x,
because clamping only bites once the remaining demands can no longer saturate a
resource, and the fraction of layers where that holds falls as the instance
grows.

The exact relation's work counters are identical to the legacy arm's at every
size — same transitions, same peak states — which is the ladder-wide form of the
parity check in section 5. The clamped relation's differ, as it must, because it
retains fewer states:

| demands | peak states, exact | peak states, clamped | transitions, exact | transitions, clamped |
| ------: | -----------------: | -------------------: | -----------------: | -------------------: |
| 8 | 6,192 | 233 | 17,295 | 3,122 |
| 10 | 16,761 | 1,942 | 76,779 | 22,574 |
| 12 | 28,669 | 6,227 | 258,499 | 83,383 |
| 14 | 50,277 | 18,936 | 476,352 | 253,544 |
| 16 | 76,752 | 30,571 | 851,424 | 535,413 |
| 18 | 111,079 | 48,491 | 1,466,440 | 918,092 |

Every cell returns the same optimum under all three relations, and every
certified cell replays: the driver asserts `verified == pruned_states` and that
neither the comparison budget nor the witness buffer bound, on all 36 certified
samples. The ladder was not extended past 18 demands: the legacy control at 18
already costs 171 s per sample and at 20 would be near the ten-minute cell
budget, so extending it would have measured the certified arms against a control
that could not complete.

Certificate size grows about linearly in pruned states, from 63,648 bytes at 8
demands to 20,245,384 bytes at 18 under the exact relation, and 14,681,960 bytes
under the clamped relation.

## 7. Gate output

All run through `~/.claude/bin/run-quiet` from
`papers/complete-repair-ports/ergodis` in the worktree.

`cargo fmt --all --check`:

```text
exit=0 time=773ms 32µs 86ns
stdout: 0 lines
stderr: 0 lines
```

`cargo clippy --all-targets --all-features -- -D warnings`:

```text
exit=0 time=18sec 967ms 218µs 20ns
    Checking ergodis v0.1.0 (.../c1049-dominance/papers/complete-repair-ports/ergodis)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 18.88s
```

`cargo test --all-features`:

```text
exit=0 time=1min 13sec 821ms 20µs 472ns
test result: ok. 572 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 70.04s
test result: ok. 3 passed; 0 failed; ...
test result: ok. 3 passed; 0 failed; ...
test result: ok. 2 passed; 0 failed; ...
test result: ok. 9 passed; 0 failed; ...
test result: ok. 2 passed; 0 failed; ...
test result: ok. 5 passed; 0 failed; ...
test result: ok. 8 passed; 0 failed; ...
test result: ok. 7 passed; 0 failed; ...
test result: ok. 8 passed; 0 failed; ...
test result: ok. 26 passed; 0 failed; ...
test result: ok. 3 passed; 0 failed; ...
test result: ok. 10 passed; 0 failed; ...
test result: ok. 1 passed; 0 failed; ...
test result: ok. 1 passed; 0 failed; ...
test result: ok. 1 passed; 0 failed; ...
test result: ok. 4 passed; 0 failed; ...
(plus four suites with no tests selected)
```

The allocation and parity gates are inside that run:
`warm_dominance_scan_allocates_nothing_after_warm_up`,
`certified_dominance_matches_the_legacy_scan_on_generic_load_instances`,
`certified_dominance_prunes_and_replays_on_an_l2_shaped_instance`,
`clamped_dominance_preserves_the_optimal_repair_count`, and
`a_forged_scheduler_witness_is_rejected_by_the_replay_checker`, together with the
six `scheduler_dominance` module tests. The pre-existing
`warm_sparse_workspace_allocates_nothing_in_solve_layers` also passes on the
certified default path, so the sparse solve's zero-allocation invariant is
observed both by the old test and by the new one.

### A worktree environment defect, unrelated to this change

On the first full-suite run, four `src/sat.rs` tests and one `tests/cli.rs` test
failed. Neither is caused by C1049 and neither touches the scheduler.

The `sat` tests write a temporary CNF file into `$XDG_CACHE_HOME`, falling back
to `./target` when that variable is unset (`src/sat.rs`, `fn test_cache`). This
crate builds into a shared out-of-tree target directory, so `./target` never
exists, and in a worktree with no `XDG_CACHE_HOME` the tests fail with
`NotFound`. Setting `XDG_CACHE_HOME` to any existing directory makes all four
pass. This is a foreign defect in the test helper — it should create the
directory it writes into, or use a `tempfile` handle — and it is raised here
rather than fixed, since `src/sat.rs` is outside this task's scope.

`transfer_tower_parallel_cli_matches_sequential_json` failed once against a
`CARGO_BIN_EXE_ergodis` binary that had not yet been built with
`--all-features`, and passes on every run after that binary exists. It is a
first-build ordering artifact, not a defect in the test.

The gate output quoted above is from a run with `XDG_CACHE_HOME` set to a fresh
temporary directory and the binaries already built.

## 8. Accepted and rejected variants

**Accepted: residual packing with a guard bit (SWAR).** Replaces `w` dependent
four-byte compares and their unpredictable branches with one borrow-free `u64`
subtraction. This is the same bias/guard construction the crate already uses in
`dense_packed_feasibility`, reused rather than reinvented. It is the largest
single contributor to the exact relation's speedup.

**Accepted: kept-only comparison by transitivity.** Sound by the transitivity
argument in section 2, and it has the side benefit that every recorded dominator
is a surviving state.

**Accepted: descending-residual-mass visit order.** Cheap (one sort of a `u32`
permutation per layer) and it is what makes kept-only comparison complete.

**Accepted but not the default: suffix clamping.** Much the strongest pruning
measured — it cuts L2's peak frontier by 2.3x and its time by a further 3.9x
over the exact relation — and the optimum is provably preserved. It is off by
default because it is not witness-preserving: it can delete a state whose
descendants would have carried the particular optimal assignment that
`select_best_witness` selects among equally optimal ones, and the task's parity
requirement is on the assignment, not only the optimum. Making it the default
would need a canonical tie-break that survives the merge, which is a separate
piece of work.

**Rejected: dropping the comparison budget.** An unbounded scan is what the
baseline does and it cannot exceed `states^2`, so a budget is not needed for
termination. It is kept anyway, set high enough never to bind, because it turns
"the scan is exact" into a property the A/B driver asserts on every cell rather
than one the reader must trust.

**Rejected: pruning without a certificate when the witness buffer fills.** The
alternative — keep pruning and emit a truncated certificate — would make the
certificate silently incomplete. The buffer-full path keeps the state instead,
so the witness list always accounts for every deletion. The cost is a possible
slowdown on an instance that prunes more than a million states; none measured
comes close.

**Rejected: making the certificate part of result equality.** Adding the
certificate to the derived `PartialEq` broke three pre-existing tests that
compare the dense and sparse backends' answers, because the backends
legitimately produce different pruning metadata for the same answer. Equality is
now hand-written over the answer fields only, and the certificate is compared
explicitly where a test means to compare it.

**Not attempted: a dual bound on the capacity rows.** C1038 named this as L2's
missing mechanism and it remains missing. It is a different mechanism from
dominance — it prunes by comparing against an incumbent, not by comparing two
states — and it is the natural successor to this task.

## 9. Does this apply to the C1050 contended repair-DAG row?

C1050 added a contended repair-DAG diagnostic — three layers of twelve tasks
over two dimensions at capacity three, 9,955 states examined, makespan six —
where CP-SAT's cumulative-interval model is 4.66x faster than Ergodis on solve
work once process startup is excluded. The question put to me is whether the
dominance structure built here also applies there. I read
`schedule_repair_dag` in `src/applications.rs` and did not run it; the answer is
that **the shape matches but the code does not port, and the measurement that
would justify porting it is absent.**

**The shape does match.** That search's state is a bitmask `done` of completed
tasks with a BFS distance. The valid dominance relation is
`done_s superset-of done_t` and `distance_s <= distance_t`, since precedence is
monotone in `done` and capacity binds per slot rather than cumulatively. The
Boolean lattice is the product order on `{0,1}^n`, so this is the same
mathematical object as the residual dominance decided here, and the superset
test is likewise a single machine word operation, `s & t == t`. The BFS does not
currently do this: it dedupes on set equality only, so a state strictly
dominated by an already-reached superset is still expanded.

**The code does not port.** Three concrete mismatches, each needing a second
implementation rather than a parameter:

1. The frontier representations differ. This scan consumes a flat per-layer
   array of states plus a flat `u32` load array; the repair DAG keeps an
   `FxHashMap` keyed by mask and a FIFO queue, with no layered frontier array to
   hand it.
2. There is no layer boundary at which to rebuild an antichain. A layered
   dynamic program rebuilds its frontier once per demand, which is where this
   scan runs; a BFS over a DAG discovers states continuously, so dominance would
   have to be tested incrementally at insertion against a live index, which is a
   different algorithm from a per-layer antichain sweep.
3. `DominanceLayout` degenerates correctly at capacity one — value bits zero, a
   one-bit lane, and the lane comparison collapsing to the subset test — but it
   is capped at 64 bits of lanes and its `pack` interface takes a `&[u32]` of
   per-resource values, not a mask. Reusing it would mean widening the interface
   for a caller whose data is already in the right form.

**And the profile points the other way.** L2's cost was frontier maintenance:
1.47 million transitions against 3.5 x 10^10 frontier comparisons. C1050
examines 9,955 states, so an all-pairs frontier scan there would be about 10^8
comparisons — of the same order as the whole search — and its actual cost driver
is the per-state subset descent `batch = (batch - 1) & ready`, which enumerates
`2^|ready|` batches and which dominance pruning does not touch. Adding a
dominance index to a 9,955-state search is as likely to cost as to save.

So: not without a second implementation, and I have not written one. The
prerequisite for a follow-up is a profile of the C1050 row establishing where its
time actually goes — the same measurement that reframed L2 in section 1 — rather
than an assumption that the shared lattice shape implies a shared bottleneck.

## 10. What remains open

**The scan is still quadratic.** The certified scan removes a large constant
factor and, under clamping, a large amount of state, but the kept-prefix scan is
still `O(states^2)` in the worst case and L2 still spends 8.7 x 10^9 comparisons
under the clamped relation. Closing the remaining gap to CP-SAT needs a
structure that answers "is any kept state componentwise above this one?" in
sublinear time. The candidates, in the order I would try them: bucketing the
kept set by one coordinate's residual so only buckets at or above the
candidate's value are scanned; a byte-wide pre-filter over one coordinate that
vectorizes 32 lanes at a time before the full comparison; and Kung's
divide-and-conquer maxima algorithm, whose `log^(d-1) n` factor at `d = 6` may
not pay at these sizes and should be measured before being built.

**Clamping is not witness-preserving.** Making it the default needs a canonical
tie-break among clamped-equivalent states that provably yields the same
assignment as the unpruned solve, or an explicit decision that the assignment
need only be *an* optimum. That decision is the user's, not mine.

**The layout is limited to 64 bits of lanes.** Six resources of capacity 40 need
42 bits, so L2 fits comfortably, but a wider or higher-capacity problem falls
back to the all-pairs scan with no certificate. A 128-bit layout — the crate
already has a `u128` variant of this packing in `dense_packed_feasibility` —
would extend the reach and is a small change.

**Only the sparse frontier is certified.** The dense-lattice and graded backends
prune by different mechanisms (a prefix-maximum sweep and a grading certificate
respectively) and emit no dominance witnesses. W2 and W3 therefore gain nothing
here, which is correct — they were never slow — but it does mean the crate has
one certified pruning path, not a uniform one.

## 11. Replay and hashes

Working directory `papers/complete-repair-ports/ergodis` in the worktree
`c1049-dominance`. Nothing is committed; the branch is left for review.

```text
# gates
cargo fmt --all --check
cargo clippy --all-targets --all-features -- -D warnings
XDG_CACHE_HOME=$(mktemp -d) cargo test --all-features

# end-to-end A/B against the retained control, and the regression rows
scripts/c1049-retained-ab.sh 3 L2
scripts/c1049-retained-ab.sh 3 W3     # and L1, L3, W1, W2

# the relation ladder, and its reduction
cargo build --release --example c1049_l2_dominance_ab
choom -n 1000 -- taskset -c 3 \
  "$(scripts/lib.sh; ergodis_target_dir .)/release/examples/c1049_l2_dominance_ab" 3 18
python3 scripts/c1049_dominance_ab_summary.py evidence/c1049-l2-dominance-ab.tsv
```

The A/B control is the retained executable
`~/.cache/ergodis/bin/negative_control_tier-7062bbfee`, SHA-256
`b11350328e3a4b33aa425db76f73f6064eace221aaf5f8451a466ee55ea08cc7`, produced by
`scripts/retain-bin.sh . negative_control_tier --example` before any source edit
and recorded in that directory's `MANIFEST.tsv` at revision 7062bbfee, clean,
rustc 1.93.1, release profile. The candidate executable measured against it is
SHA-256 `56d8da0bc934a106af8608a38e5f0e9eb4ee1b96d9135f494e4fdff64ea23e7c`,
built at 2026-09-02T17:23:40-07:00, before every measurement reported here; both
hashes are recorded in `evidence/c1049-ab-binaries.txt`.

`retain-bin.sh --example` worked as intended and needed no change. C1038 had
recorded the absence of an example path as a tooling gap; it is present now, so
this task's control is a hashed retained executable rather than a recorded
build.

| artifact | SHA-256 | bytes |
| :------- | :------ | ----: |
| `src/scheduler_dominance.rs` | `beeba0778384765c0c48d1df78a4de3efd211a32a665005c813f596c3bbae2b8` | 30,989 |
| `examples/c1049_l2_dominance_ab.rs` | `a1470fca74d6eb2881ca7961f4fd4c364a32940d1ff601064dc834096e651532` | — |
| `scripts/c1049-retained-ab.sh` | `1ee100b91f8d477d230aad73ee58e1d9d21f82d3ec5539fd826f10f69830f571` | — |
| `scripts/c1049_dominance_ab_summary.py` | `cd924c7e8c0f6cd080244de9b76beba3aefdcfc06221e497148187c132d791d9` | — |
| `evidence/c1049-l2-retained-ab.tsv` | `32da3095ad4d172ebb78bc61c8ec8dc35dcd836aec524d9ba286872f46aae966` | 1,057 |
| `evidence/c1049-l2-dominance-ab.tsv` | `0a5f10c408a1fcd52d5f915ed45e781b07e8d8f27f39058501a6323a7683f692` | 3,753 |
| `evidence/c1049-l2-dominance-ab.summary.tsv` | `3b17e191569fa81e66e503e2c26ccd7821ad8bf1f10966b1f49662b23d7a468d` | — |
| `evidence/c1049-regression-rows-ab.tsv` | `d06c57c52db97209ee559c30eda8a53a4812bcd5093b6760d20d66407e382956` | 3,463 |

Host: the 24-core Zen 5 benchmark machine, both arms pinned to CPU 3 with
`taskset` under `choom -n 1000`, single-threaded, rustc 1.93.1 from the
repository Nix toolchain, release profile with the crate's pinned `x86-64-v3`
target and thin link-time optimization. The CPU frequency governor was not read,
so absolute times carry the host's unverified frequency policy; the interleaved
rotated design is what makes the comparisons meaningful rather than the absolute
values.

### A worktree hazard to raise

The worktree shares one Cargo target directory with the main checkout. Twice
during this task a `cargo clippy` run failed against a stale `ergodis` library
artifact that did not contain `scheduler_dominance` at all — reporting
`unresolved import ergodis::scheduler_dominance` in 0.5 s without rechecking the
library — while `cargo build` of the same tree succeeded. Touching `src/lib.rs`
cleared it and clippy passed in 10.4 s. Any agent validating in a worktree
against this shared target directory should treat a suspiciously fast failure
naming a symbol that demonstrably exists as a stale artifact, and invalidate
before believing it. This is a workflow hazard for the upcoming merge, not a
defect in either branch.

## 12. Mystery ledger

- **Settled by this task: where L2's time actually goes.** Not the search. The
  profile of the retained baseline puts 93% of samples in a single 80-byte
  window that disassembles to the all-pairs Pareto scan, and the certified scan
  cuts wall time by 7.3x while leaving transitions and peak states bit-identical
  — which is only possible if the removed time was frontier bookkeeping. The
  C1038 note's framing of L2 as "transitions grow near-cubically" describes a
  real growth in transitions but misattributes the cost; the correction is
  recorded in section 1.
- **Settled by this task: dominance pruning can be certified cheaply.** The
  certificate for L2 is 20.2 MB and replays in 10.3 ms against an 18.9 s solve,
  a replay cost of 0.05%. Certification is not what makes exact frontier search
  expensive.
- **Settled by this task: the exact relation was leaving pruning on the table.**
  Clamping residuals at what the remaining demands can still consume is a
  one-line strengthening of the comparison that removes 56% of L2's frontier.
  That the unclamped relation was being used is not a bug — it is the standard
  relation — but the suffix bound was free and unexploited.
- **Settled by this task: the win is branch prediction as much as instruction
  count.** I expected the SWAR packing to pay in instructions, and it does — 6.6x
  fewer. What I did not predict is that instructions per cycle would improve
  2.58x on top, because the old per-coordinate early exit is an unpredictable
  data-dependent branch and the packed comparison has none. Branch misses fall
  354-fold. The two factors multiply to the observed 17.3x, so the wall-time win
  is fully accounted for with nothing left unexplained.
- **Open: the retained control is 19% slower on L2 than C1038 recorded, and only
  on L2.** My control binary, retained at revision 7062bbfee, medians 163.2 s on
  L2 where C1038 recorded 137.1 s for its own earlier binary. That could be host
  state, except that W3 measures 1,278 ms today against C1038's 1,288 ms and L1,
  W1 and W2 are equally close — so the host is not broadly slower, and the
  discrepancy is isolated to the row that uses the sparse Pareto frontier. Either
  C1038's three-round median was optimistic on its slowest cell, or something
  between C1038's commit and 7062bbfee made the sparse frontier scan slower. This
  does not affect any ratio in this report, all of which are against the
  same-session control, but it is a loose end in a kernel this lane cares about
  and it would be cheap to settle by running C1038's binary and mine back to
  back.
- **Open: why L2 prunes 632,666 states yet its frontier still grows.** Under the
  exact relation the scan deletes more than half a million states across the
  solve and the frontier still reaches 111,079. The deletions are real and
  certified, so the frontier's growth is not a pruning failure; it is that the
  six-dimensional antichain genuinely is that large. What is not established is
  how close 111,079 is to the true maximum antichain size for this instance. If
  it is close, no dominance relation can help further and only a bound can, which
  would settle the choice of successor. Measuring it needs an independent
  antichain-size computation, not a solver run.
- **Open: what remains of the CP-SAT gap is made of something different.**
  Against C1038's CP-SAT figure the residual is roughly 1,031x exact and 268x
  clamped, down from 15,019x, with the caveat on those two numbers recorded in
  section 6. What matters more than their exact size is their composition: the
  remaining cost is 8.7 x 10^9 comparisons of a still-quadratic scan, which is a
  data-structure problem with named candidates (section 10), whereas C1038
  attributed the original gap to a missing dual bound. Whether a sublinear
  dominance index or a dual bound closes more of what is left is not measured,
  and the two are not exclusive.
- **Not a mystery.** That W1, W2, W3 and L1 are unchanged: none of them reaches
  the sparse Pareto scan. W2 has a positive grading that skips pruning entirely,
  W3 and L1's scheduler-side analogue run on the dense-lattice backend, and L1
  and L3 are a different kernel.
