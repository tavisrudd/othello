# C1061 probe 10: QEC on the space axis, and a split-only incremental minimizer

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 10, continuing `notes/2026-09-03-c1061-probe7-other-domains-and-shapes.md`.
**Brief**: `notes/2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`

Contract documents read in full before the probe-7 work this continues:
`/home/tavis/src/ergodis/CLAUDE.md`, `/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`.

## Questions

**Part A.** Probe 7's time-axis chain dies at distance 6 because the boundary is `2^D`. Cut the same
problem along space: leaves are detector columns and the separator is the crossing data-error
column. Measure separator width against distance, whether tropical normalization or a
matching-parity invariant collapses the boundary classes, and delta against fresh per event. Also
test a cluster-growth decoder whose state is a partition under idempotent merges, and say plainly
where each decomposition stops paying.

**Part B.** Implement the split-only incremental minimizer that probe 7's refinement-only
observation licenses; measure instructions per edit against full re-minimization and against probe
7's trace-edit path; test the refinement-only claim on a hostile edit set; emit the compiled
transducer and check it against the automaton on every monoid element.

## Files and commands

All work is in `ergodis-private`, committed as `c079d29`. `/home/tavis/src/ergodis` was not
modified. The two shared files were staged as exact patches so that only my own lines were
included; the probe-12 agent's `counted_family` and `family_audit` lines stayed in the working tree.

- `/home/tavis/src/ergodis-private/src/space_axis_window.rs` — the space cut (schema, event
  contract, closed-form column leaf, parity superselection, cross-axis check) and the
  `ClusterDecoder` semilattice.
- `/home/tavis/src/ergodis-private/src/policy_minimizer.rs` — the shared refinement primitive, the
  split-only `IncrementalMinimizer`, the hostile edit census, `TransitionTransducer` emission with
  its Cayley and product tables, and `MonoidTraceTree`.
- `/home/tavis/src/ergodis-private/tasks/tools/src/space_and_minimizer_bench.rs` — the
  `space-and-minimizer-bench` subcommand of the existing `ergodis-tools` binary.

```
cd /home/tavis/src/ergodis-private
cargo fmt -p ergodis-private -p ergodis-tools
cargo test --release -p ergodis-private --lib -- space_axis_window:: policy_minimizer:: \
    semiring_tree:: policy_automaton:: syndrome_window::          # 30 passed
cargo clippy -p ergodis-private -p ergodis-tools --all-targets -- -D warnings
cargo build --release -p ergodis-tools
ergodis-tools space-and-minimizer-bench --mode census --operations 5000
ergodis-tools space-and-minimizer-bench --mode space-delta --height 4 --distance 1025 \
    --operations 2000 --verify
```

The `--verify` run re-checks the incremental answer against a cold solve inside the measured loop
and reported no mismatch. My own files pass the clippy gate; the crate-wide run reports one error in
`/home/tavis/src/ergodis-private/tasks/tools/src/summary_cache_bench.rs`, a concurrent agent's file
I did not touch.

### Measurement method

Hardware counters are primary and wall time secondary, because the box is running other agents'
builds. Per-operation figures come from `perf stat -e instructions,cycles` on two run sizes of the
same mode, differenced so startup and the snapshot bind cancel. The driver runs **eight interleaved
rounds**, each executing both sizes of both arms in a fixed order; the analysis reports mean and
standard deviation per arm and a paired `t` and 95% confidence interval on the log ratio across
rounds, exponentiated to a ratio. A result is a win only when the interval excludes 1.0. The
separator-width sweep uses three rounds, which suffices because instruction counts are deterministic
there to within tens of counts.

## Part A1 — the space cut

### The decomposition

Index qubit columns `i = 0..D` and detector columns `i = 0..D-1`. With `u = e_{.,i}` the data errors
on qubit column `i` across all `T` rounds and `v = e_{.,i+1}` the next column, the detector
constraint `d_{t,i} = e_{t,i} + e_{t,i+1} + f_{t,i} + f_{t-1,i}` gives `y_t = d_{t,i} + u_t + v_t`,
so the measurement errors in the column are forced: `f_t = y_0 + ... + y_t`, subject to
`f_{T-1} = 0`. Two consequences, both load-bearing.

**The leaf is closed form.** One prefix-parity scan of `T` bits gives the whole column's measurement
error and its weight. No search, exactly as in the time cut.

**A parity superselection rule.** `f_{T-1} = 0` forces `parity(y) = 0`, that is
`parity(u) + parity(v) = parity(d_{.,i})`. The transfer matrix is block-structured by parity and the
two blocks never mix, so exactly half of the `W^2` entries are absent. This is the matching-parity
invariant the probe was asked to look for. It is measured, not assumed:

| window height `T` | separator width `W = 2^T` | entries | mean absent fraction | max deviation from one half | live entries | retained bytes at distance 1,025 |
|---|---|---|---|---|---|---|
| 2 | 4 | 16 | 0.500000 | 0 | 8 | 8,192 |
| 3 | 8 | 64 | 0.500000 | 0 | 32 | 32,768 |
| 4 | 16 | 256 | 0.500000 | 0 | 128 | 131,072 |
| 5 | 32 | 1,024 | 0.500000 | 0 | 512 | 2,048 / 524,288 |
| 6 | 64 | 4,096 | 0.500000 | 0 | 2,048 | 2,097,152 |

Exactly one half at every height, with zero deviation across every column of a 64-leaf window
(`the_parity_superselection_rule_voids_exactly_half_the_entries`). **The invariant is worth exactly a
factor of two and no more.** It halves the live entry count but leaves the width itself untouched, so
it does not move the wall — it moves it by one bit of window height at best.

### (a) Separator width against distance

The headline structural result: **the space cut's separator width is `2^T` in the window height and
is completely independent of the code distance.** Time-axis width is `2^D` with chain length `T`;
space-axis width is `2^T` with chain length `D`. They are the same grid cut across its two
directions.

The two cuts must therefore agree on every instance, and they do:
`space_axis_agrees_with_the_time_axis_chain` and the census both check a distance-4, three-round grid
(time width 16 against space width 8) and report **0 mismatches in 500 planted trials**.
`space_axis_matches_brute_force_minimum_weight_decoding` independently checks the space cut against
exhaustive enumeration over all `2^15` error patterns.

Per-event instruction counts at distance 1,025, three interleaved rounds per height:

| window height `T` | width `W` | instructions per event | sd | cycles per event | sd | growth |
|---|---|---|---|---|---|---|
| 2 | 4 | 5,137 | 0 | 1,470 | 21 | — |
| 3 | 8 | 37,074 | 0 | 8,940 | 134 | 7.22x |
| 4 | 16 | 285,038 | 38 | 79,317 | 392 | 7.69x |
| 5 | 32 | 2,577,728 | 70 | 563,080 | 2,358 | 9.04x |
| 6 | 64 | 22,027,544 | 1 | 4,223,052 | 2,021 | 8.55x |

This is within a percent of probe 7's time-axis table at the same widths (5,040 / 37,525 / 281,580 /
2,565,491 / 21,974,623). **Per-event cost is a function of separator width alone**; the two cuts
differ only in which problem parameter sets that width. Cost is `W^3` per node, so it multiplies by
about 8 for each additional unit of the exponent.

**Where each decomposition stops paying.** Both stop at a separator width of about 64, which is one
event of roughly 22 million instructions — more than a full fresh solve of probe 2's 16,384-pod LRC
fleet. For the time cut that ceiling is **code distance 6**, which is useless: distance is the thing
a real code increases. For the space cut it is **window height 6**, which is a decoder tuning knob,
and the distance is then unbounded — the chain simply grows, costing `log D` per event. Stated as
the operational rule: **cut along the shorter axis, and since only the window height is under the
operator's control, the space cut is the one that scales.** A distance-25 code with a four-round
window is impossible on the time axis (`2^25`) and routine on the space axis (`2^4 = 16`).

### (b) Event vocabulary and its algebra

`DetectorFlipped`, `DataErasureToggled` and `MeasurementErasureToggled` are parametric and name one
column; all three are involutions on disjoint coordinates, so the update monoid is again the
**elementary abelian 2-group** probe 7 found on the time axis. The classification differs in one
interesting way from every earlier probe:

| event | class | reason |
|---|---|---|
| the three toggles | `Parametric` | one leaf |
| `WindowHeightChanged` | `RebaseRequired` | the boundary alphabet itself changes |
| `DistanceChanged` | **`RegrowRequired`** | chain length changes, but the boundary alphabet and every leaf evaluator survive |

`RegrowRequired` is a third class between "in envelope" and "recompile", and it exists only on the
space axis. Growing the code distance reallocates the tree and rebinds, but does not recompile the
schema — precisely because the separator does not depend on the distance. On the time axis the
equivalent event, changing the code distance, is a hard rebase. That asymmetry is a direct
consequence of the width result and is gated by `a_distance_change_regrows_rather_than_rebasing`.

### (c) Congruence and quotient size

The congruence is exact for the declared vocabulary;
`the_retained_space_chain_matches_a_cold_solve_after_every_event` compares the retained answer
against a cold solve after every one of 3,000 events at height 4.

Tropical normalization is the disappointing half. Over a 5,000-event stream at height 3, width 8,
distance 1,025:

| | raw | tropically normalized | collapse |
|---|---|---|---|
| leaf summaries | 8 | 8 | 1.0x |
| root summaries | 3,810 | 946 | 4.0x |

Probe 7's time cut collapsed 799 raw root summaries to 42, a factor of 19. **The space cut collapses
only fourfold and lands at 946 classes.** So the answer to "do the boundary classes collapse as they
did for the LRC fleet" is no, and less well than on the time axis: the space boundary carries the
crossing error column, whose cost shape genuinely varies, while the time boundary carries a
measurement-error vector whose cost shape repeats. A compiled transducer over the space boundary is
not on the table at 946 states and growing.

The 64-entry normalization key caps the census at width 8, so heights above 3 are not measured. That
is a tooling limit, stated rather than worked around.

### (d) Sequence benchmark

Eight interleaved rounds, height 4 (width 16), distance 1,025, two-size differencing (20,000 against
40,000 events for delta; 200 against 400 for fresh).

| metric | fresh, per operation | sd | delta, per operation | sd | paired ratio | 95% CI | paired `t` | verdict |
|---|---|---|---|---|---|---|---|---|
| instructions | 33,666,587 | 0.00% | 285,045 | 0.01% | 118.11x | [118.10, 118.12] | 137,116 | win |
| cycles | 9,114,038 | 0.70% | 79,345 | 0.45% | 114.87x | [113.91, 115.83] | 1,347 | win |

`n = 8`. Retained state is 2,097,152 bytes; the update recomposes 11 of 2,048 nodes.

The ratio matches probe 7's time-axis 134.7x to within the different chain lengths, and confirms the
cross-domain rule probe 7 derived: with a closed-form leaf, the delta win is the ratio of path
length to chain length and nothing more. This is a two-order-of-magnitude win, not the four orders
probe 2 got from an expensive leaf.

### (e) Semirings

Unchanged from probe 7: the leaf evaluator is generic through the same `RoundCost` trait, so
min-plus, max-plus, Boolean, counting and sum-product all instantiate over the space cut without
recompilation. Nothing new was measured here; the interesting functor result stands from probe 7.

## Part A2 — cluster growth as a join-semilattice

`ClusterDecoder` is a union-find over the detector lattice whose state is a **partition** plus a
per-cluster defect parity. `merge` is idempotent, commutative and associative — the join of the
partition lattice — and `cluster_merges_are_idempotent_commutative_and_order_independent` checks
directly that applying a set of joins in forward and reverse order reaches the same blocks, and that
re-applying any join is a no-op.

Measured on a 64x64 detector lattice (4,096 sites, 8,064 random neighbour joins):

| quantity | value |
|---|---|
| joins applied | 8,064 |
| effective merges | 3,974 |
| pointers repointed | 3,974 |
| worst pointers repointed by one merge | **1** |
| find steps total | 14,983 |
| redundant (idempotent no-op) join fraction | 0.507 |

**A merge event is maximally local: exactly one parent pointer per effective merge, worst case one,
never more.** Half of all joins are no-ops absorbed by idempotence, which is the semilattice paying
for itself — a duplicate event costs a find and nothing else.

The other half of the verdict is the one that matters for the framework. The semilattice has joins
but no inverses: a withdrawn defect or a corrected syndrome cannot be undone by another join, so
**retraction is a rebuild**. Measured against a bounded 64-join replay per retraction, eight
interleaved rounds:

| metric | rebuild, per operation | sd | merge, per operation | sd | paired ratio | 95% CI | paired `t` | verdict |
|---|---|---|---|---|---|---|---|---|
| instructions | 10,962 | 0.00% | 87 | 0.03% | 126.00x | [125.97, 126.03] | 46,849 | win |
| cycles | 2,231 | 6.10% | 21 | 38.02% | 121.41x | [73.23, 201.29] | 22.5 | win |

So monotone growth costs 87 instructions and a retraction costs 126 times that even with a
*bounded* 64-join replay; an unbounded replay would be worse still. That is the concrete price of
the missing inverse, and it is the sharpest statement of why the brief's group case is worth more
than its semilattice case: the syndrome-toggle vocabulary in Part A1 is a group and rolls back for
free, while the cluster vocabulary is a semilattice and rolls back by replay.

**Where cluster growth stops paying**: it does not stop with distance at all — cost is per defect,
not per boundary — but it stops the moment the workload contains retractions at a rate above roughly
one per 126 merges. A decoder fed a monotone defect stream should use it; one that revises syndromes
should not.

## Part B — the split-only incremental minimizer

### The implementation

`refine_from` runs Moore partition refinement to its fixed point **from a supplied partition**.
Starting from the two-block permit/deny partition is full minimization; starting from the previous
minimal partition is the split-only incremental path. Both entry points share one primitive, so the
comparison below measures the warm start and nothing else.
`full_minimization_agrees_with_the_probe_seven_minimizer` checks the shared primitive against probe
7's minimizer on every policy size.

`IncrementalMinimizer::update_checked` runs the split-only path and then a full minimization, and
repairs the maintained partition if they disagree, so the state can never drift even when the
refinement assumption fails.

### Where the refinement-only claim holds, and where it breaks

Probe 7 observed refinement-only behaviour on random single-cell edits. The hostile census applies
four edit kinds, 500 trials each, reverting after each so every measurement is against the same
baseline. At 3 resources and 4 replicas (36 states, 9 classes):

| edit kind | what it does | refining | coarsening | unchanged | split-only exact |
|---|---|---|---|---|---|
| `Random` | retarget one cell at random | 500 | **0** | 53 | 500 / 500 |
| `Deletion` | retarget one cell to the deny sink | 500 | **0** | 135 | 500 / 500 |
| `CellAlign` | retarget one cell to match another state's target | 500 | **0** | 147 | 500 / 500 |
| `RowCopy` | copy another state's entire row | 179 | **321** | 65 | 179 / 500 |

The same pattern holds at 2 and 3 replicas with identical counts, so it is a property of the edit
kind rather than of the size.

**The characterization is clean and it is exactly the boundary the coordinator asked for.** A single
*cell* edit — including rule deletion, which was the suspected counterexample — refines the
Myhill--Nerode partition and never coarsens it, in 1,500 trials across three sizes. Coarsening needs
an edit that makes two states' behaviour agree, and one cell is not enough: the states still differ
on the other symbols. A whole-**row** copy is enough, and it coarsens 64% of the time. So the
licensed rule is "single-cell edits refine", not "edits refine", and a multi-cell transaction must
either be checked or decomposed.

Split-only exactness tracks refinement exactly — 500/500 where the true partition refined and
179/500 on `RowCopy`, the same 179 — which is the predicted behaviour and confirms the algorithm is
exactly as correct as its precondition. On a cumulative 5,000-edit random stream (not reverted), the
split-only path was exact on all 5,000 with 0 coarsenings, and the policy degraded to 36 classes,
that is fully discrete.

### The performance verdict, which is a negative

Eight interleaved rounds, 36 states, 12 symbols, cumulative random single-cell edits:

| metric | full, per edit | sd | split-only, per edit | sd | paired ratio | 95% CI | paired `t` | verdict |
|---|---|---|---|---|---|---|---|---|
| instructions | 32,353 | 0.00% | 12,212 | 0.00% | 2.65x | [2.65, 2.65] | 1,449,238 | win |
| cycles | 5,266 | 2.22% | 1,924 | 3.87% | 2.74x | [2.67, 2.80] | 101.7 | win |

**2.65x, not a factor.** The census explains why: full minimization uses 6.9 refinement rounds per
edit on average and the split-only path uses 6.3, and the signature-probe counts differ by only 2 to
12% (`probe_ratio` 1.02 to 1.12 across sizes and edit kinds). Moore's convergence is dominated by
the *depth of the refinement cascade* the edit triggers, and a warm start does not shorten that
cascade — the new split has to propagate the same distance either way. The 2.65x that remains comes
from the warm start skipping the early passes that rediscover the block structure, not from any
locality.

Stated plainly: **the refinement-only property licenses the algorithm but does not by itself buy
locality.** The locality is available — probe 7 measured that one edit flips only 4.7% to 6.8% of the
pair relation — but capturing it needs a *worklist* refinement that re-examines only states whose
successors changed class, which is Hopcroft's structure rather than Moore's. That is the honest next
step and it was not built here. Compared against probe 7's 13.0x trace-edit path, re-minimization is
the weaker of the two incremental paths by a factor of five.

### The emitted transducer

`TransitionTransducer::compile` enumerates the transition monoid and emits the Cayley table over the
input alphabet; `product_table` additionally emits the full element-by-element product.

| resources | states | symbols | monoid elements | Cayley disagreements | trace disagreements | element table | product table |
|---|---|---|---|---|---|---|---|
| 2 | 5 | 6 | 26 | **0** | **0** | 1,144 B | 2,704 B |
| 3 | 9 | 9 | 126 | **0** | **0** | 9,072 B | 63,504 B |
| 4 | 17 | 12 | **626** | **0** | **0** | 72,616 B | 1,567,504 B |

`disagreements` checks every `(element, symbol)` cell against direct composition in the automaton:
all 626 x 12 = 7,512 cells agree at 4 resources, and 0 of 2,000 random traces of length up to 64
disagree with running the automaton directly. The monoid size matches probe 7's independent count
exactly (`the_transducer_monoid_matches_the_probe_seven_count`).

**What the transducer buys, measured.** `MonoidTraceTree` is probe 7's retained trace tree after the
quotient is compiled: each node stores **one `u32` monoid index** instead of a 17-entry function, and
composing two nodes is one indexed load into the product table instead of 17 dependent gathers.
`the_monoid_tree_agrees_with_the_function_tree_after_every_edit` checks the two trees against each
other after every one of 3,000 edits. Eight interleaved rounds, 4,096-position trace:

| metric | function tree, per edit | sd | monoid tree, per edit | sd | paired ratio | 95% CI | paired `t` | verdict |
|---|---|---|---|---|---|---|---|---|
| instructions | 3,404 | 0.05% | 371 | 0.64% | 9.17x | [9.12, 9.22] | 988.5 | win |
| cycles | 527 | 8.55% | 129 | 44.69% | 4.77x | [2.68, 8.49] | 6.4 | win |

Node state drops from 557,056 bytes to 32,768 bytes, a factor of 17, at the cost of a 1,567,504-byte
shared product table. Composed with probe 7's 13.0x trace-edit win over direct re-execution, the
compiled transducer path is about **119x** the naive policy engine in instructions.

The trade is explicit: the product table is `|M|^2` words, so it is 1.5 MB at 626 elements and would
be 100 MB at 5,000. The Cayley table alone (`|M| x |symbols|`, 30 KB at 626 elements) suffices for
streaming evaluation and only the retained *tree* needs the quadratic table. That distinction is
worth carrying into any productization: streaming is cheap, retained composition is what costs.

## Ranking and rule revisions

| claim | before probe 10 | after |
|---|---|---|
| QEC decoding stops paying at distance 6 | probe 7's verdict | **Corrected.** Distance is unbounded on the space cut; the ceiling is a window height of 6. Both cuts stop at separator width 64. |
| `CodeDistanceChanged` is a rebase | probe 7 | **Corrected.** On the space cut it is a regrow: rebind without recompiling the schema. |
| A matching-parity invariant might collapse the boundary | open | **Settled, worth exactly 2x.** Half the entries are absent at every height, with zero deviation; the width is untouched. |
| Tropical normalization collapses the boundary | 19x on the time cut | **Weaker on space: 4x, to 946 classes.** No compiled transducer over the space boundary. |
| Single rule edits refine the partition | probe 7's observation on random edits | **Confirmed and bounded.** Any single-*cell* edit refines, deletion included; a whole-row copy coarsens 64% of the time. |
| Split-only minimization is the locality win | conjectured | **Refuted as stated: 2.65x.** The cascade depth, not the starting partition, dominates Moore. A worklist refinement is the real lever. |
| The finite quotient is emittable | conjectured | **Done.** 626 elements, zero disagreements, and the monoid tree is 9.17x the function tree with 17x less node state. |

The cross-domain rule probe 7 added survives intact and gains a corollary: per-event cost is a
function of separator width alone, so the design question in a chain domain is only ever *which cut
makes the separator narrow*, and that choice can change which parameters are compile-time and which
are events.

## Mystery ledger

- **The space boundary normalizes fourfold, the time boundary nineteenfold.** Both measured on one
  stream at width 8. The reasoned explanation is that the space boundary carries a crossing error
  column whose cost shape varies while the time boundary carries a measurement-error vector whose
  shape repeats, but that is an argument, not a measurement. Open; settling it needs the
  normalization key widened past 64 entries so heights 4 and 5 can be censused, which is a small
  tooling change.
- **The split-only minimizer's 2.65x.** Explained by the refinement-cascade depth (6.3 rounds warm
  against 6.9 cold, 2 to 12% fewer signature probes), and the explanation is measured rather than
  reasoned. What is *not* settled is how much a worklist refinement would recover; probe 7's 4.7% to
  6.8% pair-flip rate is an upper bound on the locality available, suggesting something like a 15x
  ceiling, but nobody has built it.
- **`RowCopy` coarsens 64% of the time and the other three kinds never coarsen.** The boundary
  between the two behaviours is sharp and the mechanism is clear — one cell cannot make two states
  agree everywhere — but the exact condition on multi-cell edits was not characterized. A stated
  conjecture worth proving: an edit coarsens only if it makes some state's full row equal to
  another's up to the induced partition. Open.
- **The monoid tree's cycle interval is wide, [2.68, 8.49] against a 9.17x instruction ratio.** The
  measured work is about 129 cycles per edit, short enough that a loaded box dominates; the
  instruction ratio is the defensible figure. Not settled without an idle box.
- No algebraic mystery remains in Part A: the parity superselection rule is exact and derived, the
  cross-axis agreement is checked against 500 planted trials and against brute force, and the
  semilattice properties were stated in advance and confirmed by test.

## Vibe check

Strong, and it rescues the domain probe 7 wrote off. The space cut makes code distance a free
parameter and moves the exponential onto the window height, which is the one number a decoder
operator actually controls — a distance-25 code with a four-round window is now routine where the
time cut needed `2^25`. The two cuts agreeing exactly on 500 planted trials and per-event cost
matching to within a percent at equal width is the cleanest confirmation in the series that
separator width is the only thing that matters. Part B is the mixed half: the transducer emission is
an unqualified success (626 elements, zero disagreements, 9.17x with 17x less state), but the
split-only minimizer is a measured 2.65x rather than the locality win the refinement property
suggested, and the reason — Moore's cascade depth — points at a worklist algorithm nobody has built.

## Next probes

1. Widen the normalization key past 64 entries and census the space boundary at heights 4 and 5, to
   decide whether 946 classes is a plateau or the start of an exponential.
2. Build the worklist refinement (Hopcroft-shaped, re-examining only states whose successors changed
   class) and measure it against both the 2.65x split-only path and probe 7's 6.8% pair-flip
   locality bound.
3. Replace the repetition code with a real CSS code on the space cut, using `bp_osd.rs`'s
   `BinaryParityCheck` at the leaves. The space cut is the right axis to try it on, since the leaf
   becomes a coset search while the separator stays fixed by the window height.
4. Prove the multi-cell coarsening condition conjectured in the mystery ledger, which would let a
   policy engine classify a whole edit transaction as refining or not before minimizing.
5. Test whether the `RegrowRequired` class generalizes: any event that changes chain length but not
   the boundary alphabet should be a rebind rather than a recompile, and probe 2's `PodCountChanged`
   rebase exit is a candidate for the same reclassification.
