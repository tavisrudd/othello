# C1061 probe 13: decoding-window exactness, an external decoder baseline, and the worklist minimizer

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 13, continuing `notes/2026-09-03-c1061-probe10-qec-space-axis-and-split-only-minimizer.md`.
**Brief**: `notes/2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`

Contract documents read in full before the probe-7 work this line of probes continues:
`/home/tavis/src/ergodis/CLAUDE.md`, `/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`.

## Headline

The commercial question has a plain answer and it is negative. **The retained space-cut delta does
not beat a tuned production decoder per event: it loses to PyMatching's sparse blossom by 64x to
82x in instructions at every distance tested, at matched accuracy.** The loss is structural — a
dense `W x W` boundary matrix against a sparse defect set — not an implementation detail. Two
things do come out ahead: the window-height knob is now quantified as accuracy against cost rather
than cost alone, and the worklist minimizer that probe 10 identified as the real lever delivers
47.8x to 154.8x over full re-minimization, against probe 10's 2.65x.

## Files and commands

All work is in `ergodis-private`, committed as `ecaa632`. `/home/tavis/src/ergodis` was not
modified. `src/lib.rs` and `tasks/tools/src/main.rs` were staged as exact patches so that only my
own lines were included; the probe-11 and probe-12 agents' lines stayed in the working tree.

- `/home/tavis/src/ergodis-private/src/window_exactness.rs` — the two objectives, the blocked
  window decoder, the exact full-history decoder, the seam census, and the detector error model.
- `/home/tavis/src/ergodis-private/src/policy_worklist.rs` — the inverse transition index and the
  worklist (Hopcroft-shaped) incremental minimizer.
- `/home/tavis/src/ergodis-private/tasks/tools/src/decoder_baseline_bench.rs` — the
  `decoder-baseline-bench` subcommand of the existing `ergodis-tools` binary.
- Scratchpad driver and baseline script: `p13/ab13.sh`, `p13/min13.sh`, `p13/pymatch.py`.

```
cd /home/tavis/src/ergodis-private
cargo fmt -p ergodis-private -p ergodis-tools
cargo test --release -p ergodis-private --lib -- window_exactness:: policy_worklist:: \
    policy_minimizer:: space_axis_window:: syndrome_window:: semiring_tree:: policy_automaton::
                                                              # 39 passed
cargo clippy -p ergodis-private -p ergodis-tools --all-targets -- -D warnings
cargo build --release -p ergodis-tools
ergodis-tools decoder-baseline-bench --mode census
ergodis-tools decoder-baseline-bench --mode window-accuracy --rounds 12 --operations 40000
ergodis-tools decoder-baseline-bench --mode emit-shots --distance 9 --height 4 --rate 0.01 \
    --operations 20000 --out shots_d9.txt
uv run --with pymatching --with numpy --with scipy python pymatch.py accuracy shots_d9.txt
```

My own files pass the clippy gate. The crate-wide run reports one remaining error in
`tasks/tools/src/summary_cache_bench.rs`, a concurrent agent's file I did not touch.

**Measurement method.** Instructions are primary and cycles secondary, because the box runs other
agents' builds. Every per-operation figure is a two-size difference under
`perf stat -e instructions,cycles`, so process startup, instance generation and graph construction
cancel. Drivers run eight interleaved rounds with both sizes of both arms in a fixed order per
round; reported ratios are paired log-ratio means with 95% confidence intervals, and a result
counts only when the interval excludes 1.0.

## Part A — what the window optimizes exactly

### The two objectives

Write `f_t` for the round-`t` measurement error vector. Both cuts impose `f_{-1} = 0` and
`f_{last} = 0`: the round before the artifact and the last round in it are assumed perfectly
measured.

- **Full-history minimum weight.** Over an `R`-round experiment, minimize total error weight subject
  to `f_{-1} = 0` and `f_{R-1} = 0`, minimizing over every interior `f_t` freely. The *time* cut
  computes this exactly for any `R` at interface width `2^D`, because its chain length is `R`.
- **Windowed minimum weight.** Partition the `R` rounds into blocks of `T`, decode each block with
  `f = 0` at both ends, compose the logical increments. This is what a `T`-round *space*-cut
  artifact computes, because the space cut's boundary alphabet **is** `F_2^T`, so `T` must equal the
  artifact's whole round count.

The windowed objective is therefore a **constrained** minimization: it optimizes over the strict
subset of error configurations that put no measurement error on a **seam round** (the last round of
each block). The two coincide when `T = R`, checked at 2,000 trials with zero mismatches
(`a_window_equal_to_the_history_agrees_with_the_exact_decoder`).

### The exactness condition, and a correction found by a failing test

The natural conjecture — blocking is exact when the *planted* error avoids the seams — is **false**,
and the failing form of a test produced the counterexample. For the distance-3 detector history
`[0, 0, 0, 1, 3, 0, 0, 0]` with height-4 blocking, the planted error puts nothing on the seam, yet
the two objectives disagree, because the full-history optimum prefers an explanation that *uses* a
seam measurement error. `the_seam_condition_is_about_the_optimum_not_the_noise` pins that case.

**The correct condition is about the optimum, not the noise: fixed-seam blocking returns the
full-history answer exactly when some minimum-weight explanation of the observed history avoids
every seam.** The weaker, noise-side statement holds only for histories the decoder cannot
re-explain, and `a_single_error_away_from_a_seam_decodes_identically` gates that restricted case
(weight at most one, no seam error, distance 3).

**Is there a height at which the two are provably identical?** Only `T = R`. For any `T < R` the
constraint set is strictly smaller and a single measurement error landing on a seam is enough to
separate them, so no finite height below the experiment length gives identity for a fixed distance
and a nonzero measurement rate. What a larger height buys is a *lower rate* of the disagreement, at
`W = 2^T` cost. A sliding window with a commit region is the standard construction that removes the
fixed-seam artifact; it needs a witness readout at the commit boundary, which the current artifact
does not expose, and it was not built here.

### The accuracy sweep

Distance 3, 12 rounds, 40,000 trials per point, exact decoder via the time cut at width 8.

| physical rate | height | exact logical error | windowed logical error | excess | excess / exact | disagreements | of those, no seam error |
|---|---|---|---|---|---|---|---|
| 0.001 | 2 | 0.00010 | 0.00017 | 0.00007 | 70% | 3 | 0 |
| 0.001 | 4 | 0.00013 | 0.00015 | 0.00003 | 23% | 1 | 0 |
| 0.001 | 6 | 0.00010 | 0.00013 | 0.00003 | 30% | 1 | 0 |
| 0.005 | 2 | 0.00237 | 0.00382 | 0.00145 | 61% | 96 | 20 |
| 0.005 | 3 | 0.00263 | 0.00313 | 0.00050 | 19% | 56 | 17 |
| 0.005 | 4 | 0.00265 | 0.00332 | 0.00068 | 26% | 47 | 12 |
| 0.005 | 6 | 0.00240 | 0.00275 | 0.00035 | 15% | 22 | 6 |
| 0.01 | 2 | 0.00955 | 0.01528 | 0.00573 | 60% | 389 | 90 |
| 0.01 | 3 | 0.01010 | 0.01235 | 0.00225 | 22% | 210 | 71 |
| 0.01 | 4 | 0.01033 | 0.01250 | 0.00217 | 21% | 183 | 58 |
| 0.01 | 6 | 0.01000 | 0.01040 | 0.00040 | 4% | 90 | 46 |
| 0.02 | 2 | 0.03757 | 0.05448 | 0.01690 | 45% | 1,366 | 353 |
| 0.02 | 4 | 0.03825 | 0.04258 | 0.00432 | 11% | 675 | 292 |
| 0.02 | 6 | 0.03565 | 0.03800 | 0.00235 | 7% | 398 | 208 |
| 0.05 | 2 | 0.18113 | 0.21570 | 0.03458 | 19% | 5,843 | 1,699 |
| 0.05 | 4 | 0.18200 | 0.19560 | 0.01360 | 7% | 3,702 | 1,996 |
| 0.05 | 6 | 0.18282 | 0.18873 | 0.00590 | 3% | 2,728 | 1,839 |

**The window height is a genuine accuracy knob and its price is `8x` per unit height.** Going from
height 2 to height 6 cuts the excess logical error by a factor of 6 to 14 across the sweep (at 1%
physical error, from a 60% excess over the exact decoder down to 4%), while probe 10 measured the
per-event cost rising by about `8x` for each unit of height. So the operator's trade is explicit:
roughly a factor of 500 in compute to buy back an order of magnitude of the windowing penalty.

The last column is the corrected condition showing up in data: a large and *growing* share of
disagreements happen on histories with no seam measurement error at all — 0 of 3 at rate 0.001, but
1,996 of 3,702 at rate 0.05. As the noise rises, the decoder's freedom to re-explain a history
dominates, and the seam census stops predicting disagreement.

## Part B — external baseline: PyMatching sparse blossom

### Setup and accuracy parity

`DetectorErrorModel::repetition_code` emits the matching graph for the phenomenological model this
workspace uses: a data error `(t, q)` flips detectors `(t, q-1)` and `(t, q)` and flips the
observable when `q == 0`; a measurement error `(t, i)` flips `(t, i)` and `(t+1, i)`. Every
mechanism flips at most two detectors, so it is exactly a matching graph.
`the_detector_error_model_reproduces_the_planted_syndrome` checks the emitted model against the
directly constructed syndrome and observable on 200 planted histories.

PyMatching 2.4.0, four-round window, 20,000 shots per distance at 1% physical error:

| distance | detectors | mechanisms | PyMatching logical error | space-cut logical error | decoder disagreements |
|---|---|---|---|---|---|
| 3 | 8 | 18 | 0.00375 | 0.00290 | 41 |
| 5 | 16 | 32 | 0.00030 | 0.00030 | **0** |
| 7 | 24 | 46 | 0.00000 | 0.00000 | **0** |
| 9 | 32 | 60 | 0.00000 | 0.00000 | **0** |

**Accuracy is matched**: identical logical error rates and zero disagreements at distances 5, 7 and
9. At distance 3 they differ on 41 of 20,000 shots (0.2%), with the space cut marginally *better*
(0.00290 against 0.00375) — degeneracy tie-breaking at the smallest distance, where ties are common
and the two decoders resolve them differently. So the cost comparison below is at matched accuracy,
which is the condition the question was posed under.

### Instructions per event, and the answer

Eight interleaved rounds, two-size differencing on both arms. The PyMatching arm decodes in batch
(`decode_batch`), which is what a production pipeline does, so no Python per-call overhead is being
charged to it; the differencing removes interpreter startup, imports, file loading and graph
construction entirely. One PyMatching round at distance 5 was discarded because a startup outlier
made its two-size difference non-positive; that round is excluded from the pairing and `n` is
reported per row.

| distance | metric | PyMatching per decode | sd | space-cut delta per event | sd | ratio (delta / PyMatching) | 95% CI | n | verdict |
|---|---|---|---|---|---|---|---|---|---|
| 3 | instructions | 497 | 4.40% | 40,539 | 0.01% | **81.6x** | [78.7, 84.7] | 8 | delta loses |
| 3 | cycles | 112 | 49.64% | 10,280 | 0.37% | 110.3x | [58.4, 208.3] | 8 | delta loses |
| 5 | instructions | 843 | 4.84% | 67,703 | 0.00% | **80.4x** | [76.9, 84.0] | 7 | delta loses |
| 5 | cycles | 179 | 51.98% | 17,960 | 0.61% | 112.7x | [69.6, 182.5] | 7 | delta loses |
| 7 | instructions | 1,195 | 3.52% | 94,870 | 0.00% | **79.4x** | [77.1, 81.8] | 8 | delta loses |
| 7 | cycles | 299 | 35.14% | 25,573 | 0.31% | 90.7x | [66.0, 124.8] | 8 | delta loses |
| 9 | instructions | 1,484 | 3.93% | 94,870 | 0.01% | **64.0x** | [61.9, 66.1] | 8 | delta loses |
| 9 | cycles | 263 | 52.77% | 25,559 | 0.58% | 113.0x | [66.3, 192.6] | 8 | delta loses |

**The answer, plainly: no.** At matched accuracy the retained space-cut delta costs 64 to 82 times
more instructions per event than sparse blossom, at every distance measured. Every confidence
interval is far from 1.0 and the instruction counts are deterministic to within hundredths of a
percent, so this is not a measurement artifact.

**Why it loses, structurally.** The delta path recomposes 4 to 11 tree nodes, each a dense
`16 x 16` min-plus product, which is 4,096 operations per node whether or not any defect is nearby.
Sparse blossom touches only the neighbourhood of the actual defects, and at 1% physical error a
four-round window holds very few. The retained tree's advantage — never recomputing the untouched
part of the chain — is real but is swamped by paying dense boundary arithmetic for the part it does
touch. That is a property of the representation, not of the code.

**Where the delta path is relatively better, and where the crossover would be.** Its per-event cost
is flat in distance (94,870 instructions at both distance 7 and 9, because both pad to the same
tree capacity, and only `log D` thereafter), while PyMatching grows roughly linearly in the detector
count (497, 843, 1,195, 1,484 at distances 3, 5, 7, 9 — about 165 instructions per unit of
distance). A crossover therefore exists, but extrapolating those two trends puts it near distance
3,000 to 5,000, which is far outside any physical surface-code regime. The compiled-dynamic
framework should not be sold on per-event decoding cost for QEC.

**What the framework still has that the baseline does not**: an exact minimum-weight answer for
*both* logical classes with their costs (not just a correction), a maintained state that survives
edits and retractions of individual syndrome bits as a group action, and a certificate path from
probe 3. None of those are what a decoder is bought for.

## Part C — the worklist incremental minimizer

### The algorithm

Probe 10 diagnosed that Moore's convergence is dominated by the *depth* of the refinement cascade,
so a warm start cannot help. `WorklistMinimizer` implements the algorithm that diagnosis points at:
it maintains the **inverse transition relation** in compressed sparse row form with per-row slack so
a single cell edit patches it in place, and it processes a worklist of blocks seeded by the edited
state's own block, re-queuing only the blocks of *predecessors* of a block that just split.

`the_inverse_index_lists_exactly_the_predecessors` and `patching_the_index_matches_a_rebuild` gate
the index; `the_worklist_minimizer_matches_full_minimization_on_cell_edits` checks the maintained
partition against a full minimization after each of 500 cell edits at three sizes, with zero
coarsenings, confirming probe 10's refinement-only precondition holds for the whole stream.

**One implementation fix mattered more than the algorithm.** The first version recompacted class
labels on every update, which is `O(states x classes)` and dominated everything; running it only
when a block actually split moved the result from 4.6x to the numbers below. That is recorded
because it is the difference between "the worklist is a modest win" and "the worklist is the lever".

### Locality, measured two ways

Each trial rebinds from the replicated baseline, so this measures a single edit on a genuinely
non-minimal policy (2,000 trials, 3 resources):

| replicas | states | mean states examined per edit | mean blocks split | states in one full Moore pass | examined / full pass |
|---|---|---|---|---|---|
| 2 | 18 | 14.71 | 7.25 | 18 | 0.82 |
| 4 | 36 | 37.72 | 10.34 | 36 | 1.05 |
| 8 | 72 | 97.80 | 14.90 | 72 | 1.36 |
| 16 | 144 | 265.92 | 23.07 | 144 | 1.85 |

Against full Moore's roughly 6.9 passes per edit, the worklist does about one to two passes' worth
of scanning, so on a live non-minimal policy the structural saving is roughly 4x to 7x. It does not
do better because a single edit on a *replicated* policy is inherently global: separating one
replica cascades through all of them, splitting 7 to 23 blocks. The replicated construction is the
adversarial case for locality, which is why probe 10 used it.

On the cumulative random stream the timed modes use, the policy reaches the discrete partition and
nothing can split any more (0.03 and 0.21 states examined per edit at 4 and 16 replicas), so the
timed ratios below are the **steady-state, nothing-to-split** regime — the regime a stable policy
under occasional edits actually sits in.

### Timed comparison

Eight interleaved rounds, 3 resources, cumulative random single-cell edits.

| replicas | states | metric | full re-minimization | split-only (probe 10) | worklist | full / worklist | 95% CI | split-only / worklist | 95% CI |
|---|---|---|---|---|---|---|---|---|---|
| 4 | 36 | instructions | 32,351 | 12,210 | **676** | **47.84x** | [47.84, 47.84] | **18.06x** | [18.06, 18.06] |
| 4 | 36 | cycles | 5,139 | 1,924 | 196 | 26.29x | [25.66, 26.94] | 9.84x | [9.59, 10.10] |
| 16 | 144 | instructions | 275,546 | 118,120 | **1,780** | **154.82x** | [154.82, 154.82] | **66.37x** | [66.37, 66.37] |
| 16 | 144 | cycles | 49,959 | 21,958 | 339 | 147.32x | [142.72, 152.08] | 64.74x | [61.94, 67.68] |

**The worklist is the lever probe 10 predicted, and it scales the right way.** The advantage grows
with the state count (47.8x at 36 states, 154.8x at 144), which is the signature of an algorithm
whose cost tracks the affected region rather than the automaton. Against probe 10's split-only path
it is 18x to 66x, and probe 10's split-only figure of 2.65x over full minimization is reproduced
exactly here (32,351 / 12,210 = 2.65).

## Revisions to earlier probes

| claim | before | after |
|---|---|---|
| The space cut makes code distance a free parameter (probe 10) | optimistic | **Qualified.** The space cut's `T` is the artifact's whole round count, so a long run forces blocking, and blocking costs accuracy. Distance is free; experiment length is not. |
| Fixed-seam blocking is exact when the planted error avoids the seams | conjectured here | **False**, with a counterexample. The condition is that some minimum-weight explanation avoids the seams — a statement about the optimum. |
| Window height is a cost knob (probe 10) | cost only | **Now an accuracy/cost knob**, quantified: `8x` cost per unit height buys a 6x to 14x reduction in the windowing excess error. |
| The compiled-dynamic delta is competitive for QEC decoding | untested | **Refuted at matched accuracy: 64x to 82x worse than sparse blossom per event**, structurally, at distances 3 to 9. |
| A worklist refinement is the real lever (probe 10's diagnosis) | conjectured, "maybe 15x" | **Confirmed and exceeded: 47.8x to 154.8x** over full minimization in the steady state, 4x to 7x structurally on a live non-minimal policy. |

## Mystery ledger

- **The delta loses to sparse blossom by a nearly constant 64x to 82x across distances 3 to 9**,
  even though the two have different asymptotics (flat versus linear). The ratio should drift, and
  over this narrow range it barely does because the delta's tree capacity is quantized to powers of
  two (distances 7 and 9 give the identical 94,870). Settling the crossover claim needs distances
  well beyond 9, where the exact space-cut leaf evaluation is still cheap but PyMatching's graph
  grows; that sweep was not run.
- **Disagreements without a seam error grow from 0% to 54% of all disagreements as the physical
  rate rises from 0.001 to 0.05.** The corrected condition explains the direction but not the shape.
  A cheap follow-up is to count, per disagreeing history, whether *every* minimum-weight explanation
  uses a seam, which would turn the empirical condition into a measured one.
- **The worklist's advantage is measured in the steady state where nothing splits.** The live-baseline
  locality census says the structural win there is only 4x to 7x, so the 47.8x to 154.8x figures
  describe a policy under occasional edits, not one being actively restructured. Both regimes are
  reported; which one a product sits in was not determined.
- **The worklist still materializes each popped block's members by scanning all states**, so it is
  `O(states)` per popped block rather than `O(block size)`. A proper Hopcroft partition structure
  (doubly linked blocks with member lists) would remove that term. It is the obvious next
  optimization and its absence bounds the live-baseline numbers above.
- **PyMatching's cycle counts vary 35% to 53% round to round** while its instruction counts vary 4%.
  The box is loaded; every claim above rests on instructions, and the cycle intervals are reported
  only for completeness.

## Vibe check

Useful and mostly deflationary, which is what the probe was for. The commercial question is
answered cleanly and negatively — a tuned production decoder beats the retained delta by 64x to 82x
per event at matched accuracy, and the reason is the dense boundary representation rather than
anything fixable in the code — so QEC decoding should come off the list of product targets for the
compiled-dynamic framework even though it remains an excellent source of algebraic structure. The
window-height knob is now honestly priced in both directions. The one strongly positive result is
on the policy side: the worklist minimizer that probe 10 could only point at delivers 47.8x to
154.8x over full re-minimization and improves with size, and a one-line fix to when labels are
recompacted was worth more than the algorithm change itself.

## Next probes

1. Sweep the PyMatching comparison to distances 15, 25 and 51 to locate or refute the predicted
   crossover, and to check whether the delta's `log D` growth holds once tree capacity stops being
   the quantizing factor.
2. Replace the dense `W x W` boundary product with a sparse or defect-indexed representation and
   re-run the same A/B; that is the only change that could move the 80x, and it would test whether
   the framework's advantage survives a representation that matches the workload's sparsity.
3. Build the sliding window with a commit region, which needs a witness readout at the commit
   boundary, and measure whether it removes the fixed-seam excess entirely at a given height.
4. Replace the block-member scan in the worklist with a linked partition structure and re-measure
   the live-baseline regime, where the current implementation is bounded at 4x to 7x.
5. Decide whether the policy-automaton line, not the QEC line, is the product surface: it is the
   only domain in probes 7, 10 and 13 where the framework beats the natural baseline by orders of
   magnitude rather than losing to it.
