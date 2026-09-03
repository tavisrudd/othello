# C1061 probe 5: accelerating the snapshot bind on the LRC fleet

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 5, continuing `notes/2026-09-03-c1061-probe2-real-kernel-witness-deltas.md`.

Probe 2 measured that one event costs about 1.9 microseconds on the Azure LRC fleet and that the
cost is flat in fleet size, because ten calls into `azure_lrc_12_2_2_counted` per leaf dominate the
logarithmic tree walk. The snapshot bind pays that leaf cost once per pod, so a fresh solve is
linear in the fleet with a large constant. This probe attacks that constant with five separately
switchable stages, each gated by exact agreement (value and witness) against the plain fresh solve.

Files (all in `ergodis-private`; `/home/tavis/src/ergodis` untouched and clean):

- `/home/tavis/src/ergodis-private/src/snapshot_acceleration.rs` — the five stages.
- `/home/tavis/src/ergodis-private/src/lrc_delta_binding.rs` — corrected canonical class,
  `pod_summary` / `pod_repaired_for_extra` factored out, `rebind_pod`, `rebind_snapshot`.
- `/home/tavis/src/ergodis-private/tasks/tools/src/snapshot_acceleration_bench.rs` — the
  `snapshot-acceleration-bench` subcommand.

Committed as `6403357`, staged as an exact patch so only my own hunks of the shared `src/lib.rs`
and `tasks/tools/src/main.rs` were included; the certificates and congruence agents' lines were
left in the working tree for them.

**Measurement note.** The plain fresh solve at 16,384 pods measured between 15.4 and 20.5 ms across
runs, and one outlier run reported 5.5 ms. Absolute nanoseconds on this box are therefore not
comparable across invocations; every stage below is reported as a **ratio measured inside a single
process against that same process's baseline**, and the headline ratios are repeated across three
independent runs.

## Stage 0 — the canonicalization defect from probe 2, fixed

Probe 2 canonicalized a pod by sorting its six data-domain capacities, and found that this is exact
only when the demand is a multiple of six: the kernel's multiplicity vector is
`complete_cycles + (domain < remainder)`, so when `demand % 6 != 0` the first `demand % 6` domains
each carry one extra demand and the domains are no longer interchangeable. Only about 23% of pods
qualified.

`LeafClassKey` fixes this by sorting the **(capacity, multiplicity) pairs**, and keying the two
global parity capacities by their sum. The correctness argument is short: the kernel's feasibility
test is `aggregate - capacity_d <= multiplicity_d` for every data domain together with
`sum of shortfalls <= served`, and both are symmetric functions of the multiset of pairs; the
repaired count is therefore invariant under any permutation that carries capacities and
multiplicities together. The two global capacities enter the kernel only through their sum
(`global_capacity = capacities[7] + capacities[8]`), so keying on the sum is exact as well.

Gates: `pair_canonicalization_is_exact_for_every_demand_residue` draws 40,000 hostile pods, checks
that every residue class 0 through 5 is exercised, and asserts that the class representative's
summary reproduces the pod's summary **exactly** in every case;
`permuting_capacity_multiplicity_pairs_preserves_the_class` checks the symmetry directly. The
representative constructor is the subtle part — it must place each capacity on the domain whose
multiplicity the class pairs it with, since assigning them in sorted order would silently re-pair
capacities with multiplicities and reintroduce the defect.

## Stage 1 — leaf-kernel memoization on the canonical class

`LeafClassCache` maps `LeafClassKey` to `Summary`. A miss evaluates the **class representative**,
not the pod that caused the miss, which is what makes the table a function of the class rather than
of its first occupant.

At 16,384 pods built from 24 pod types (three runs):

| Quantity | Run 1 | Run 2 | Run 3 |
|---|---|---|---|
| cold-table solve speedup | 4.33x | 4.61x | 4.40x |
| warm-table solve speedup | 4.48x | 4.51x | 4.44x |
| hit rate | 0.9985 | | |
| table classes | 24 | | |
| kernel calls saved | 163,600 | | |

**Negative control, and it is the important half.** With `--pod-types 0` (every pod drawn
independently) the hit rate collapses to 4.06%, the table grows to 15,718 classes, and the
cold-table solve is **0.66x — a 34% slowdown**, because hashing every pod buys almost nothing. The
warm-table solve is still 4.21x, since a lookup beats ten kernel calls once the table exists. So
memoization is a large win on a fleet built from rack types and a real loss on a fleet of unique
pods; it must be gated on a measured hit rate, not enabled unconditionally.

**Hostile stream, bounding the class count.** Two million adversarial draws (capacities spanning
the alphabet, all demand residues, verified present) produce 1,573,310 distinct classes. On a
200,000-draw prefix, 200,000 distinct raw parameter vectors collapse to 193,473 classes — a
collapse ratio of **1.034**. Stated plainly: the leaf class space is *not* small in general. The
canonicalization is exact and it merges genuinely equivalent pods, but the symmetry group is small
relative to the parameter space, so the class table is a fleet-structure win, not a structural
bound. This is a direct negative for any hope of enumerating all leaf classes ahead of time, and it
contrasts with probe 2's finding that the *tropically normalized boundary summaries* number two to
three — the summaries collapse, the parameter classes do not.

## Stage 2 — run composition by repeated squaring

`encode_runs` run-length encodes the leaf class sequence and `summary_power` composes a run of `r`
identical summaries in `O(log r)` min-plus products.
`repeated_squaring_matches_repeated_composition` checks powers 0 through 39 against sequential
composition.

| Fleet shape | Runs | Speedup over the plain fresh solve |
|---|---|---|
| interleaved (pod type = index mod 24) | 16,384 | 3.43x / 3.79x / 3.41x |
| blocked (one contiguous block per type) | 25 | **276x / 292x / 276x** |

The interleaved case has one run per pod, so squaring contributes nothing and the 3.4x is the class
cache showing through. The blocked case is the real result: 25 runs over 16,384 pods, and the whole
fleet composes in 25 microseconds against roughly 16 milliseconds. Fleet *layout* is therefore a
first-class performance parameter — sorting pods by class before compiling converts the interleaved
case into the blocked case, and nothing in the answer depends on the order in which independent
pods with equal classes appear.

## Stage 3 — snapshot-from-snapshot

`SnapshotRebuilder::diff` finds the changed pods; `FleetTree::rebind_snapshot` sets their
parameters, re-evaluates those leaves, and walks up one level at a time with a sorted deduplicated
frontier so every affected node is recomposed exactly once. The alternative,
`k` sequential `rebind_pod` calls, recomposes shared ancestors repeatedly.

At 16,384 pods, times in nanoseconds:

| changed pods `k` | full rebuild | `k` sequential rebinds | merged rebind | nodes recomposed |
|---|---|---|---|---|
| 1 | 17,227,661 | 2,545 | 3,036 | 15 |
| 4 | 17,343,427 | 8,706 | 8,856 | 52 |
| 16 | 17,342,476 | 32,991 | 30,887 | 171 |
| 63 | 16,685,861 | 117,669 | 111,237 | 579 |
| 255 | 15,573,426 | 445,741 | 368,808 | 1,828 |
| 996 | 15,680,546 | 1,728,464 | 1,361,679 | 5,291 |

Both incremental paths beat a full rebuild by three to four orders of magnitude at every `k`
measured, and even at `k = 996` — six percent of the fleet changed — the merged rebind is still
11.5x faster than rebuilding. Merging pays only once ancestors actually collide: it loses slightly
at `k = 1` (the frontier bookkeeping is pure overhead for a single path) and wins 21% at `k = 996`.
The node count is the reason and it is worth stating as the decision rule: `k` independent paths
would touch `k * 15` nodes, so at `k = 996` that is 14,940 against 5,291 actually recomposed.
`snapshot_rebuild_agrees_with_a_full_rebuild` checks the merged result against a full rebuild and
against a fresh recomposition.

## Stage 4 — parametric budget

The shared-budget grain enters a leaf summary only through `extra = levels * grain` with `levels`
in `0..4`. `BudgetProfile` compiles a leaf's *entire* budget dependence as a table of repaired
counts indexed by `extra`, so assembling the summary for any grain is indexing plus arithmetic with
no kernel call.

| Quantity | Value |
|---|---|
| profile compile, whole fleet | 43,926,117 ns (about 2.8 fresh solves) |
| profile bytes, whole fleet | 1,212,416 (74 bytes per pod) |
| `max_extra` covered | 24 |
| re-solve at a new grain, from profiles | 849,283 ns |
| re-solve at a new grain, by recompiling | 15,988,501 ns |
| speedup | **18.8x / 19.3x / 19.5x across three runs** |

`budget_profile_reproduces_the_kernel_for_every_grain` checks 200 pods against the kernel for
grains 0 through 8, and `budget_change_reduces_to_composing_precompiled_matrices` checks the whole
128-pod fleet optimum for grains 0 through 6.

**The answer to the question the stage was posed to settle is yes**: the whole fleet's budget
dependence reduces to composing precompiled matrices. That has a consequence for the event contract
from probe 2, and it is the most interesting result of this probe. `BudgetGrainChanged` was
classified `RebaseRequired` because every leaf summary is defined against the grain. With profiles
retained, a grain change is an in-envelope parametric event affecting all leaves, answered in 0.85
ms with no kernel call — one of the two declared rebase exits can be compiled away. The profile
does have a hard envelope of its own (`max_extra`), and a grain beyond it returns an absent summary
rather than extrapolating, so the rebase exit moves rather than disappearing.

## Stage 5 — witness readout

`compress_witness` run-length compresses materialized decisions and `run_witness_cost` sums the
fleet cost over runs. `witness_run_length_readout_is_exact` checks the run cost against the optimum
and that decompression is lossless.

At 16,384 pods after 1,000 events:

| Readout | Time | Runs |
|---|---|---|
| `materialize_witness` (tree descent, one kernel call per pod) | 1,506,754 ns | — |
| per-pod cost summation over materialized decisions | 29,471 ns | 16,384 pods |
| run-length cost readout, interleaved fleet | 29,153 ns | 15,064 runs |
| run-length cost readout, blocked fleet | 86 ns | 23 runs |

Two conclusions, and the first corrects the framing the stage was posed with. **Compression buys
nothing on an interleaved fleet** — 15,064 runs for 16,384 pods, so the run readout matches the
per-pod readout at 1.0x (1.02x, 1.01x, 1.05x across three runs). On a blocked fleet it is 343x,
mirroring stage 2: the same layout property drives both.

**The `O(pods)` cost probe 2 flagged is not the summation at all — it is materialization, and it is
kernel-bound.** `materialize_witness` calls `pod_repaired` per pod to fill the decision's repaired
count, so it is 51x the cost of any readout over already-materialized decisions. Serving those
calls from the stage-1 class cache is the obvious fix, is not implemented here, and is the single
highest-value follow-on from this probe.

## Validation

```
cd /home/tavis/src/ergodis-private
cargo test -p ergodis-private --lib snapshot_acceleration      # 11 passed
cargo test -p ergodis-private --lib lrc_delta                  # 7 passed
cargo test --test lrc_delta_allocations --test delta_composition_allocations   # 1 + 1 passed
cargo fmt -p ergodis-private -p ergodis-tools
cargo clippy -p ergodis-private -p ergodis-tools --all-targets -- -D warnings   # clean
cargo build --release -p ergodis-tools
ergodis-tools snapshot-acceleration-bench --pods 16384 --pod-types 24
ergodis-tools snapshot-acceleration-bench --pods 16384 --pod-types 0
```

Every stage aborts the benchmark run through `ensure!` if its result differs from the plain fresh
solve, so a reported number is always a number from an agreeing stage. The crate-wide clippy gate
passes again now that `congruence_search.rs` is committed as `015f487`.

## Mystery ledger

- **The class space is large but the summary space is tiny.** 193,473 canonical classes per 200,000
  hostile draws, against probe 2's two to three tropically normalized boundary summaries. Both are
  measured and both are believable — many parameter settings map to the same cost shape — but the
  map from class to normalized summary has not been characterized. If it is as coarse as probe 2's
  census suggests, the right table is keyed on the *summary*, not the class, and would be small
  even on a fleet of unique pods. That is the strongest lead this probe produced and it is not yet
  tested.
- **Baseline fresh-solve time varied 15.4-20.5 ms with one 5.5 ms outlier** across runs of the same
  binary and inputs. Unexplained; plausibly frequency scaling or page-cache state. It is why every
  claim here is a within-process ratio. Settling it needs pinning and a fixed governor, which this
  probe did not do.
- **Merged rebind loses slightly at `k = 1`** (3,036 ns against 2,545 ns). Expected — frontier
  bookkeeping with nothing to merge — but it means a dispatch rule is needed rather than always
  choosing the merged path. Threshold not measured precisely; it lies somewhere between `k = 4` and
  `k = 16`.
- **Profile compile costs 2.8 fresh solves.** Worth it after the third grain change, never worth it
  if the grain is fixed. No mystery, but it is a policy decision the compiler should make from a
  declared expectation about grain volatility, and nothing currently declares that.
- The stage-5 framing error (compression is not the bottleneck; kernel-bound materialization is)
  was a genuine correction produced by adding the like-for-like baseline, and is now settled.

## Vibe check

Good, with two useful negatives. Three stages delivered large wins (memoization 4.4x on a typed
fleet, run composition 276x on a blocked one, parametric budget 19x and the elimination of a rebase
exit), and the canonicalization defect from probe 2 is fixed with an exact argument and a test
across every demand residue. The two negatives are worth as much: memoization is a 34% *loss* on a
fleet of unique pods, and witness compression buys nothing unless the fleet is laid out in blocks.
Fleet layout turned out to be the hidden parameter behind both of the big wins.

## Next probes

1. Key the leaf table on the tropically normalized summary rather than the parameter class. Probe 2
   measured two to three normalized summaries; if that holds, the table stays tiny even on a fleet
   of unique pods and stage 1's negative control disappears.
2. Serve `materialize_witness`'s per-pod kernel calls from the class cache — the 51x term in stage
   5 and the last `O(pods)` kernel cost in the artifact.
3. Compile the pod ordering: sort by class at bind time so every fleet is a blocked fleet, and
   measure the sort cost against the 276x run-composition win.
4. Promote `BudgetGrainChanged` to a parametric event backed by retained profiles, and re-measure
   the rebase count on a stream that includes grain changes.
5. Measure the merged-versus-sequential rebind crossover precisely and make `rebind_snapshot`
   dispatch on it.
