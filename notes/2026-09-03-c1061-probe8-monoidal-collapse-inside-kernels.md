# C1061 probe 8: does monoidal collapse suggest optimizations inside the kernels?

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 8.
**Brief**: `notes/2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`
**Predecessors**: probe 2 (`notes/2026-09-03-c1061-probe2-real-kernel-witness-deltas.md`),
probe 5 (`notes/2026-09-03-c1061-probe5-snapshot-bind-acceleration.md`),
probe 6 (`notes/2026-09-03-c1061-probe6-summary-keyed-cache-and-witness-serving.md`).

Question: the collapse law pays off *between* kernel calls; does the same algebra pay off *inside*
a kernel when its inner state space is small?

**Answer: yes, on both kernels tried, and the mechanism is the same one the brief predicts.** A
kernel whose inner loop applies commuting maps over a small boundary is a monoid product waiting to
be reassociated, and reassociating it removes the loop rather than speeding it up.

Measurement rules: hardware counters, never wall time; interleaved paired A/B, seven rounds, each
round differencing two problem sizes so process startup and instance construction cancel; a win only
when the 95% confidence interval on the paired ratio excludes 1.0. Ratios are one-sample t
intervals on the per-round log ratios, exponentiated back.

Binary `~/.cache/ergodis/target/ergodis-private/release/ergodis-tools` at commit `2d114d2`, run under
`choom -n 1000`. Drivers and raw per-round rows:
`/tmp/claude-1000/-home-tavis-src-othello-rust/b9c7b857-9104-4ac3-b222-9bc84903a341/scratchpad/`
(`lrcab.sh`, `flipab.sh`, `analyse2.py`, `ab-lrc-final.tsv`, `ab-flip.tsv`).

## Part A — parametric single-pass LRC kernel

### What probe 6 established, and the two things left on the table

Probe 6 (`ergodis-private` `c2e1ac5`) found that `azure_lrc_12_2_2_counted`'s global-capacity
rejection is dead code and that its six per-domain tests collapse to the single scalar bound
`A(s) <= min_d (c_d + m_d)`, and built a decided path that is 8.2x fewer instructions than calling
the published kernel per leaf. It stopped at a descending scan, on the stated ground that the
residual test `sum_d max(0, A(s) - c_d) <= s` "is not monotone — its slope is `2k - 1`".

Two things were left, and this probe takes both.

**The residual test is monotone where it matters, so no scan is needed at all.** The slope argument
is right that `2k - 1` is `-1` when `k = 0`, but `k = 0` means no domain is over capacity, so the
shortfall is zero and the test cannot be violated. Wherever the test *is* violated, at least one
domain is over capacity, `k >= 1`, and the violation grows. The predicate is therefore a prefix in
`s`: infeasible once, infeasible forever after. That is proved in the module docstring and gated
empirically by `feasibility_is_a_prefix_predicate_in_the_served_count`, which walks every served
count on 20,000 hostile instances and fails if feasibility ever heals after a violation.

**The threshold does not depend on the budget, so one compile answers every level.** Neither
feasibility condition mentions the global parity capacities; they enter only the search bound
`maximum = min(demand, Lc + Gc)`. So with `s*` the largest feasible served count,

```text
repaired(extra) = min(s*, Lc + Gc + extra)
```

for every budget grant at once. `threshold_is_independent_of_the_global_parity_capacities` checks
that directly.

### What was built

`/home/tavis/src/ergodis-private/src/parametric_lrc.rs`, with the benchmark at
`/home/tavis/src/ergodis-private/tasks/tools/src/parametric_lrc_bench.rs`
(`ergodis-tools parametric-lrc-bench`). `LrcTransfer::compile` sorts the six data capacities, forms
their prefix sums, and evaluates fourteen closed forms — two regimes (`s <= Lc`, where `A = s`, and
`s > Lc`, where `A = 2s - Lc`) times seven prefix segments, where segment `k` is the range of `A`
with exactly `k` capacities below it and the shortfall is `k*A - prefix[k]`. Each closed form is a
division; there is no candidate scan anywhere. `repaired_at_extra` is then a `min`, and `answer`
reconstructs the kernel's full greedy witness at the chosen threshold.

The core is untouched. The two shared files got only my own lines, staged as an exact patch.

### Correctness

- `parametric_pass_agrees_with_the_kernel_on_the_hostile_stream` — 40,000 hostile draws times 24
  budget grants, i.e. **960,000 exact comparisons against the published kernel**, checking
  `repaired_count`, `mode_counts` and `total_loads` — value *and* witness. Every demand residue class
  modulo six is asserted present, and the stream is asserted to exercise more than 100,000 nonzero
  answers so the agreement is not vacuous.
- `closed_form_threshold_matches_a_brute_force_scan` — 20,000 instances, closed form against a full
  scan.
- `all_levels_readout_matches_ten_kernel_calls` — the whole budget family from one compile, at six
  grains.
- The benchmark itself re-checks 2,000 pods per run against both the published kernel and probe 6's
  decided predicate, and aborts rather than print a number from a disagreeing evaluation.

`totals_checked` is the one field that differs: it is the kernel's work counter, and the parametric
pass reports 1 because it performs no candidate scan.

### Measured, per pod, all ten boundary pairs

Seven interleaved rounds, each differencing 40,000 against 200,000 pods, grain 3.

| evaluation | instructions (sd) | cycles (sd) | instructions vs published kernel | 95% CI | cycles vs kernel | 95% CI |
|---|---|---|---|---|---|---|
| published kernel, ten calls | 15,641 (0) | 3,509 (11) | baseline | — | baseline | — |
| published kernel, four distinct levels | 6,716 (0) | 1,714 (5) | 2.33x | [2.33, 2.33] | 2.05x | [2.04, 2.05] |
| probe 6 decided, ten calls | 2,563 (0) | 913 (5) | 6.10x | [6.10, 6.10] | 3.84x | [3.82, 3.87] |
| probe 6 decided, four distinct levels | 1,239 (0) | 632 (2) | 12.62x | [12.62, 12.62] | 5.55x | [5.53, 5.57] |
| **parametric, one compile plus ten readouts** | **794 (0)** | **634 (2)** | **19.70x** | [19.70, 19.70] | 5.53x | [5.51, 5.55] |
| parametric, ten full witness reconstructions | 3,661 (0) | 1,359 (3) | 4.27x | [4.27, 4.27] | 2.58x | [2.57, 2.59] |

Instruction counts are deterministic to the last digit across rounds, so every instruction interval
is degenerate and every comparison is decisive.

Against probe 6's decided path **as its callers use it** — one call per boundary pair — the
parametric pass is 3.22x fewer instructions, CI [3.22, 3.22]. Against the strongest form of probe 6's
path, with the six redundant pairs removed so it makes only four calls, it is **1.56x fewer
instructions, CI [1.56, 1.56], but the cycle ratio is 1.00, CI [0.99, 1.00] — a wash**. Reported
plainly: at 794 instructions per pod the evaluation is no longer instruction-bound, so removing
instructions stops buying cycles. That is the honest boundary of this result, and it says the next
lever on this kernel is memory layout, not arithmetic.

Two independent facts still favour the parametric pass at equal cycles. It is the only variant that
produces the *whole* budget family from a single compile, which is what a parametric event needs;
and it is the only one that also serves the full witness, at 4.27x the published kernel, where
probe 6's decided path returns a count only.

Work counters, 20,000 pods: the published kernel performs 2,211,118 candidate evaluations (110.6 per
pod, about 11 per call); the parametric pass performs 20,000 compiles and no candidates.

**Verdict on Part A: it still adds something, but less than it would have before probe 6.** The
scan removal is real and the instruction win is decisive; the cycle win over the best decided
variant is not established. The durable contributions are the monotonicity proof — which contradicts
probe 6's stated reason for keeping a scan — and the budget-family collapse.

## Part B — survey: which kernels have the repeated-inner-stage shape

Sources: `/home/tavis/src/ergodis/src` and `/home/tavis/src/ergodis-private/src`, excluding the
modules other agents own. The shape hunted for is a repeated inner stage over a boundary small
enough that stage composition can be precomputed. The algebra column and the verdicts are this
probe's analysis.

### Positive candidates

| kernel | inner state, and its width | iterations | candidate algebra | small enough? |
|---|---|---|---|---|
| `ergodis/src/applications.rs:664` `azure_lrc_12_2_2_counted` | `[u64;6]` shortfalls plus two scalars, 384 bits | one per candidate served count, ~11 per call | threshold scan collapsed to a closed form over sorted prefixes; the budget is a separated parameter | **yes — done, Part A** |
| `ergodis/src/defect.rs:387` `signed_flip_reachability` | `[u64;20]` reachability, 1,280 bits | one per line degree; 757 on the real plane | Boolean-semiring convolution monoid: commuting maps, binary splitting over multiplicities | **yes — done, Part C** |
| `ergodis/src/defect.rs:631` `build_threshold_masks` | `[u64; TARGET_WORDS]` lower/upper masks per (degree, bound) | one per bound, recomputed from scratch | the masks are a prefix and a suffix scan over the sorted tails; one scan yields every bound | yes, and it is the same parametric collapse as Part A |
| `ergodis-private/src/g53_mod28_reduction.rs:151` `compile_g53_mod28_prefix_counts` | `[u64;4]` reachable set, 256 bits, plus per-shift totals | one per block, whole scan re-run per active-shift count | associative XOR-sumset (`ergodis-private/src/bitset_sumset.rs:6`): tree fold or prefix scan; repeated blocks are squarable; the active-shift rerun is a parametric family | yes, and the active-shift rerun is the cheaper half |
| `ergodis/src/orbit.rs:755` `TernaryOrbitSearch::run` | packed `(Z/3)^n` residues plus `[i64; width]` totals, with an explicit undo log | one per DFS node | abelian group action; option words precompose, prefix sums replace push/pop | yes for the algebra, but the width is instance-set |
| `ergodis/src/linear_code.rs:219` `gray_scan_kernel` | `[u64; word_count]` codeword | `2^rank - 1` | GF(2) group action; segment XOR prefixes precomputable | boundary yes, **but the enumeration is the point**: every state must be visited, so composition cannot remove work |
| `ergodis/src/commutant.rs:843` `extension_field_powers` | one packed GF(2)-linear map, `dimension^2` bits | `degree`, 2 to 16 | repeated squaring | boundary yes, **but every intermediate power is consumed**, so squaring saves nothing |
| `ergodis/src/modular_power.rs:144` `matrix_powers` | `order^2` u32, 288 bits at order 3 | one per certified power | repeated squaring | same objection: consecutive powers are the output |
| `ergodis/src/contextual.rs:2106` `checked_pow`; `selector.rs:307,500` | one `u64` | `exponent` | square-and-multiply, as `modular_power.rs:214 pow_mod` already does | yes, trivially; small absolute stakes |
| `ergodis-private/src/mask_cycle_proof.rs:23` `synthesize_complement_cycle_proof` | two vertex ids | `width`, at most `MAX_WIDTH` | one power of a fixed permutation on darts | yes, but `width` is already tiny |
| `ergodis/src/linear_code.rs:264` `brouwer_zimmermann_scan_kernel` | `u16` best weight plus a codeword buffer | information sets times rank | min-semilattice reduction, so parallel-reducible | the accumulator is small, but there is nothing to compose: each stage has its own basis |

### Negative cases, stated explicitly

These have no small boundary, and no amount of algebra creates one.

- **`ergodis/src/applications.rs:1075` `schedule_repair_dag`** — the canonical negative. The state is
  `done: u64`, a **subset mask over up to 63 tasks**, held in a hash map of up to `2^n` entries with
  a frontier queue; the inner step `batch = (batch - 1) & ready` descends through *all subsets* of
  the ready set, so the per-state work is `2^popcount(ready)`. The object carried across a slot is
  the whole reachable-state map, and the transfer operator is a map on antichains over `2^n`. There
  is no fixed-size boundary to square. This confirms probe 1's assessment from the other direction:
  the kernel is not merely awkward to make incremental, it has no compositional factorization at all.
- `ergodis/src/observational.rs:5162` `minimize_partition` and `:5543`
  `minimize_partition_worklist_with_pending` — the state is a **partition of the whole state set**,
  living in the Bell-number-sized partition lattice, and the worklist variant's per-iteration map
  depends on which splitter was dequeued, so the sequence of maps is data-dependent rather than a
  fixed generator applied `k` times. Hopcroft/Paige-Tarjan is already the right algorithm.
- `ergodis/src/applications.rs:1604` `minimum_node_span_repair` — the state is a set of
  reduced-row-echelon subspace bases in a hash map, cloned wholesale per node; the boundary is the
  subspace lattice of `GF(q)^ambient`, Gaussian-binomial sized.
- `ergodis/src/applications.rs:495` `ceph_xor_repair_family_with` and its antichain helpers — the
  state is an antichain of `u128` support masks; insertion is not a fixed map.
- `ergodis/src/composition.rs:1022` `parallel_composition_step` — the per-block state list is keyed
  by cost-matrix labels and grows multiplicatively per block; prunable by Pareto dominance, not
  composable.

The pattern across the negatives is uniform and worth stating as the survey's main structural
finding: **a kernel has an exploitable inner algebra exactly when its inner state is a fixed-width
vector and its stages are drawn from a small set of commuting maps.** Where the inner state is a
subset, a partition, a subspace, or an antichain, the state space is its own obstruction, and the
work goes into pruning instead.

## Part C — a second prototype: collapsing the GF(27) flip-reachability scan

Chosen from the survey for the smallest boundary attached to a genuinely published instance:
PG(2,27) maximal-arc defect analysis, whose fixed-maximal-set pass asks which signed cardinality
corrections are reachable within a flip budget.

`ergodis::defect`'s private `signed_flip_reachability` folds one two-element set into a `[u64; 20]`
array per line degree. On the real plane the degree list has one entry per line — **757 entries** —
while only seven degree values carry a flip at all, so the same map is applied a hundred times over.
The elementary map for a degree with direction `d` and cost `c` is convolution with `{(0,0), (c,d)}`
in the (budget, adjustment) monoid over the Boolean semiring: associative, commutative, monotone.
Applying it `k` times is convolution with the arithmetic progression `{(0,0), (c,d), ..., (kc,kd)}`,
which binary splitting reaches in `O(log k)` folds — batches of 1, 2, 4, … copies, each one shifted
fold — and every count from 0 to `k` stays representable, so it is exact. The batch sequence stops
as soon as one more copy would exceed the budget, at which point no larger count is reachable
anyway.

Built as `/home/tavis/src/ergodis-private/src/flip_reachability.rs` with
`ergodis-tools flip-reachability-bench`. The core is untouched: `elementary` is a faithful replica of
the private scan and serves as the reference oracle, `squared` is the collapsed version, and
`DegreeMultiset` is the sufficient statistic (the counts alone, because the maps commute).

**Correctness.** `collapsed_scan_matches_the_elementary_scan_on_the_real_plane` builds PG(2,27) with
`ProjectivePlane::ternary(27)`, seats point prefixes through the real `MaximalPointAugmentor`, and
compares the two scans at every budget 0 to 19; `collapsed_scan_matches_on_every_pencil_of_the_real_plane`
does the same for all 757 pencils of 28 lines; `collapsed_scan_matches_on_hostile_multisets` covers
2,000 random multisets at every budget; `the_multiset_is_a_sufficient_statistic` checks permutation
invariance directly. The benchmark re-checks both shapes on every run and aborts on disagreement.

**Measured**, seven interleaved rounds, each differencing 200 against 1,000 repeats, budget 19, 32
seated points:

| evaluation | instructions (sd) | cycles (sd) | folds | instruction speedup | 95% CI | cycle speedup | 95% CI |
|---|---|---|---|---|---|---|---|
| scalar scan over 757 line degrees, elementary | 188,469 (1) | 58,158 (6,846) | 598 | baseline | — | baseline | — |
| **the same, collapsed** | **9,762 (1)** | **4,839 (953)** | **17** | **19.31x** | [19.31, 19.31] | **12.13x** | [10.09, 14.57] |
| all 757 pencils, elementary | 5,315,529 (1) | 1,874,777 (71,308) | 16,744 | baseline | — | baseline | — |
| **all 757 pencils, collapsed** | **1,998,179 (1)** | **680,918 (29,532)** | **5,852** | **2.66x** | [2.66, 2.66] | **2.75x** | [2.65, 2.86] |

Both CIs exclude 1.0 on both metrics, so both are wins under the stated rule. The scalar scan is the
large one because its multiplicities are large: 598 folds become 17. The pencil scan wins less
because each pencil has 28 lines with multiplicities near four, and the tally pass itself costs a
pass over those 28 entries — the collapse still pays, but the constant is close to the crossover.

Unlike Part A, this win is a cycle win as well as an instruction win, and by roughly the same factor,
because the elementary scan is a long chain of dependent 20-word folds rather than a handful of
divisions.

## Validation

```
cd /home/tavis/src/ergodis-private
cargo test -p ergodis-private --lib parametric_lrc          # 5 passed
cargo test -p ergodis-private --lib flip_reachability       # 5 passed
cargo clippy -p ergodis-private --all-targets -- -D warnings   # clean
rustfmt --edition 2021 --check <the four owned files>          # clean
cargo build --release -p ergodis-tools
```

Committed in `ergodis-private` as `2d114d2`: the two modules, the two benchmark subcommands, and my
own lines in the two shared files, staged as an exact patch so that another agent's concurrent
`space_axis_window` and `closed_form_audit` lines stayed in the working tree.
`cargo clippy -p ergodis-tools` currently fails on a `non_canonical_clone_impl` finding in
`tasks/tools/src/summary_cache_bench.rs:569`, which is probe 6's file and not an owned path.

## Mystery ledger

- **The parametric pass wins 1.56x on instructions against the best decided variant and 1.00x on
  cycles.** At 794 instructions and 634 cycles per pod the evaluation has an IPC of 1.25, against
  4.46 for the published kernel — the closed form is a short chain of dependent divisions, and
  divisions are long-latency. Removing arithmetic no longer helps; replacing the divisions with
  reciprocal multiplications or restructuring the fourteen cases into independent chains might. Open,
  measured, and it is the specific reason not to claim a cycle win in Part A.
- **The scalar flip scan's cycle interval is wide** — 12.13x with CI [10.09, 14.57] — while its
  instruction interval is degenerate. The elementary scan touches 20 words 598 times and the
  collapsed one 17 times, so the two have very different cache and dependency behaviour, and the box
  was carrying other agents' builds throughout. The instruction ratio is the reliable statistic here.
- **`build_threshold_masks` was identified but not prototyped.** It is the same parametric collapse
  as Part A on a different instance — masks recomputed per bound where one sorted scan yields every
  bound — and it is the cheapest remaining item in the survey. Left for a successor.
- **Probe 6's "not monotone" claim was a real error, not a difference of framing**, and it cost that
  probe a scan it did not need. The lesson generalizes past this kernel: a slope argument about a
  predicate must be evaluated on the region where the predicate is violated, not globally.
- No mystery remains about the negatives. `schedule_repair_dag` and the partition-refinement loops
  are structurally excluded, not merely unattempted.

## Vibe check

Good, and the survey is worth more than either prototype. Two kernels collapsed on the first attempt
with decisive instruction wins (19.7x and 19.3x over their published baselines), one of them with a
matching 12x cycle win, and both gated against the real kernels on real instances. The sobering half
is Part A's cycle wash against probe 6's best variant — the LRC leaf is now latency-bound, so this
line of attack on that particular kernel is finished — and the survey's structural finding that the
shape only exists where the inner state is a fixed-width vector of commuting maps, which rules out
the largest kernels in the tree by construction.

## Next probes

1. `build_threshold_masks` in `ergodis/src/defect.rs:631`: one prefix-and-suffix scan replacing a
   per-bound recomputation. Same collapse as Part A, cheapest item left.
2. `compile_g53_mod28_prefix_counts`: tree-fold the XOR-sumset over blocks, and collapse the
   active-shift rerun into one parametric pass.
3. Attack the LRC closed form's latency rather than its instruction count: replace the fourteen
   divisions with reciprocal multiplications and measure IPC.
4. Feed the parametric transfer operator back into the fleet binding so a `BudgetGrainChanged` event
   costs one compile per pod instead of a profile table, and re-measure probe 5's stage 4.

---

## 2026-09-03 follow-up: landing both defect collapses in the Ergodis core

Probe 11. The two collapses of Part B and Part C are now in
`/home/tavis/src/ergodis/src/defect.rs` under the core's full validation gate, and the private
replica is gone. This is the first core edit of C1061.

### What landed, in three commits

| commit | change |
|---|---|
| `eb349ce` | Three counter workloads in the existing `bench_kernels` binary: `defect:catalog` (the catalogue constructor), `defect:analysis` (the fixed-maximal analysis of one complete 54-point set), `defect:search` (the depth-32 canonical prefix search under catalogue pruning). No behaviour change; this is the harness the A/B needs on both arms. |
| `08ccfb0` | The two collapses. `signed_flip_reachability` tallies the degree multiset and folds each degree by binary splitting over its multiplicity instead of once per line; `build_threshold_masks` scatters each target into the row of its own tail value and runs one suffix scan for the lower family and one prefix scan for the upper family instead of rescanning every target per bound. Both previous implementations are retained verbatim as `#[cfg(test)]` differential references. |
| `9a02921` | `signed_flip_reachability` becomes public, and the budget-parameterised `defect:flip-scalar:<budget>` and `defect:flip-pencils:<budget>` workloads are added. |

In `ergodis-private`, `b25cb13` deletes `src/flip_reachability.rs` and its benchmark subcommand: the
core now owns the collapsed scan, its elementary reference, and the differential between them, so the
private copy was duplication. Its lines in the two shared files were removed by an exact staged patch
so that the other agents' concurrent `compiled_transducer`, `counted_family`, `policy_worklist`,
`window_exactness`, `family_audit` and `transducer_bench` lines stayed in the working tree.

### Why the scan had to be made public to be measured at all

The measurement plan called for the budget-12/13 diagnostics, and finding them exposed a fact about
the module that is worth recording on its own. `analyze_fixed_maximal_set` computes
`correction_budget = 19 - baseline_defect` and returns immediately when that is negative. On the
seeded 54-point set the benchmark can construct — the same deterministic walk the criterion benchmark
uses — the analysis reports `baseline_defect: 640`, `correction_budget: -621`. **No constructible
54-point set reaches the scan through the analysis entry point**, because a set with defect at most 19
is precisely the open object the whole branch is searching for. The scan's real inputs are
hypothetical near-maximal sets, so through the public surface as it stood the scan was both
unmeasurable and untestable at a chosen budget.

That is the reason for `9a02921`. Publishing the primitive lets a caller ask the same reachability
question at a chosen budget without owning a complete maximal set, which is what makes budgets 12 and
13 measurable, and it is also what makes the private replica convertible — the alternative to deleting
it was a differential against an entry point that did not exist.

It also explains the `defect:analysis` workload showing no change between the arms: it never reaches
either kernel. It is retained as an end-to-end regression, not as a speed measurement.

### Correctness

Differentials against the previous implementations, all in `src/defect.rs`:

- `collapsed_flip_scan_matches_the_elementary_scan_on_the_real_plane` — PG(2,27) at five seated
  prefixes including the full 54, every budget 0 to 19.
- `collapsed_flip_scan_matches_on_every_pencil_of_the_real_plane` — all 757 pencils of 28 lines, five
  budgets each.
- `collapsed_flip_scan_matches_on_hostile_multisets` — 2,000 random multisets, every budget.
- `threshold_masks_match_the_per_bound_construction` — the real catalogue's masks compared bit for
  bit against the per-bound construction, and against the masks the catalogue actually stores.

The pre-existing suite is unchanged and passes, including `signed_flip_dp_matches_subset_enumeration`
(the scan against brute-force subset enumeration) and
`gf27_catalog_matches_independent_python_counts` (3,435 pairs, 1,013 targets, 1,496 spectra).

Zero-allocation regression: `gf27_fixed_maximal_analysis_allocates_nothing` in
`tests/contextual_allocations.rs` drives the terminal analysis of a complete 54-point set sixteen
times through the crate's counting allocator and asserts zero allocator events. The scan is on the
per-terminal-node path of the search, so this is the required hot-loop gate.

Work-count agreement between the two arms, on all seven workloads, `work` and `checksum` identical:

```
defect:flip-scalar:12   1514 46912495419392     defect:catalog   2026 5018
defect:flip-scalar:13   1514 93824991887360     defect:analysis  1516 596
defect:flip-pencils:12  42392 4140068797153280  defect:search    529256 527802
defect:flip-pencils:13  42392 5654702737850368
```

Single-thread and parallel: the defect path contains no rayon and no threads, so the requirement is
that enabling parallelism changes nothing. A `--features parallel` build reproduces every `work` and
`checksum` above exactly, and `defect:search` is identical at `RAYON_NUM_THREADS` of 1, 2 and 8
(264,628 nodes, checksum 263,901 in every case).

### Interleaved paired A/B

Arms are two retained executables carrying the identical harness:

| arm | retained name | SHA-256 |
|---|---|---|
| control (pre-collapse kernels) | `bench_kernels-979db9c` | `833604150c56a0a42d4f68b01e7782595565f93bf1595a406ef3d369b0aa4a68` |
| candidate (collapsed kernels) | `bench_kernels-9a02921` | `667f6183cf1b8fd6624891bab9a7e8230c6905ffd32d03817d023d9d5e6619e2` |

The control was built in a detached worktree at `eb349ce` with the harness from `9a02921` and the
four-line visibility patch applied, committed there as `979db9c` so `retain-bin.sh` could name it;
that commit is not on any branch, and the retained binary plus its hash is the durable record.

Seven interleaved rounds; each round runs both arms on each workload at two repetition counts and
differences them, so process startup, plane construction and fixture building cancel. Instructions are
the primary metric; ratios are one-sample t intervals on the per-round log ratios.

| workload | n | control instructions | candidate | instruction speedup | 95% CI | t | cycle speedup | 95% CI |
|---|---|---|---|---|---|---|---|---|
| `defect:flip-scalar:12` | 7 | 109,285 | 7,360 | **14.848x** | [14.848, 14.849] | 648,402 | 8.348x | [7.566, 9.212] |
| `defect:flip-scalar:13` | 7 | 118,414 | 7,666 | **15.447x** | [15.446, 15.447] | 600,771 | 9.297x | [9.233, 9.361] |
| `defect:flip-pencils:12` | 7 | 4,101 | 1,908 | **2.150x** | [2.150, 2.150] | 155,348 | 2.162x | [2.130, 2.195] |
| `defect:flip-pencils:13` | 7 | 4,439 | 2,064 | **2.151x** | [2.151, 2.151] | — | 2.208x | [2.177, 2.240] |
| `defect:catalog` | 7 | 46,814,181 | 9,292,637 | **5.038x** | [5.038, 5.038] | 948,149 | 3.866x | [3.685, 4.056] |
| `defect:search` (negative control) | 7 | 567,142,496 | 567,142,691 | 1.000x | [1.000, 1.000] | −4.0 | 0.998x | [0.985, 1.011] |

Every interval on the five measured workloads excludes 1.0 on both metrics. The scalar figures are per
whole-plane scan, the pencil figures per single pencil scan, the catalogue figure per construction,
and the search figure per search.

`defect:search` is the negative control and behaves like one: 195 instructions of difference on 567
million, a relative change of 3.4 parts in ten million. It reaches neither kernel — the catalogue is
built once outside the differenced region and the terminal analysis short-circuits — so the collapse
correctly does nothing there.

The pencil win is the smaller one for the reason Part C gave: 28 lines with multiplicities near four,
where the tally pass itself costs a pass over those entries. Probe 8's private-replica measurement of
the scalar scan was 19.31x at budget 19; at budgets 12 and 13 the elementary baseline does less work
per fold, so the ratio falls to 14.85x and 15.45x. The two measurements agree in shape, and the budget
is the parameter that moves them.

### Validation gate

```
cd /home/tavis/src/ergodis
cargo fmt --check                                             # clean
cargo clippy --all-targets --all-features -- -D warnings      # clean
cargo test --all-features                                     # 747 passed, 0 failed
nix shell nixpkgs#python3 --command python3 python/test_algorithms.py   # 79 tests, OK
cargo test --test contextual_allocations gf27                 # zero-allocation regression
../ergodis-contrib/scripts/cache-gc.sh                        # dry run only, nothing applied
```

The Python oracle differential is the defect module's existing one: `python/test_algorithms.py`'s
`DefectShellTests` derives the shell histograms and the GF(27) pair census independently, and the Rust
side asserts the same counts. My change is downstream of the targets those tests fix, and the mask
differential compares the new construction to the old bit for bit, so the chain from oracle to stored
masks is closed.

### A hazard worth recording for other agents

Building the control in a git worktree while the main checkout shares
`~/.cache/ergodis/target/ergodis` silently produced two *identical* retained binaries: cargo keys
fingerprints by source path but writes both to the same `release/bench_kernels`, so the worktree build
overwrote the candidate and the main checkout then considered its own artifact fresh and did not
relink. The first `retain-bin.sh` of the candidate therefore captured the control's bytes, and the
manifest still carries that superseded row (`bench_kernels-9a02921` at `8336041...`, 13:52:20) ahead of
the correct one (`667f6183...`, 13:52:57). The retained file on disk is the correct one. The fix is to
delete the shared output path and force a relink before retaining after any worktree build, and the
check that catches it is comparing the two arms' SHA-256 values before trusting a single measurement.
`retain-bin.sh` refusing to overwrite `bench_kernels-eb349ce` is what surfaced the collision.

### Mystery ledger, follow-up

- **The whole flip scan is unreachable through the module's public analysis.** Recorded above, and it
  is a statement about the search rather than about my change: a set with defect at most 19 is the open
  object, so until one exists the scan runs only on hypotheticals. The collapse still matters, because
  the scan is on the per-terminal-node path the moment such a set appears, but no end-to-end workload
  can show it today. Settled by measurement, not open.
- **The catalogue win is 5.04x on instructions but 3.87x on cycles.** The scanned construction touches
  the same mask block three times (scatter, suffix, prefix) where the per-bound construction streamed it
  once, so it trades instructions for memory traffic. Still a large win on both metrics; the gap is the
  reason the two ratios differ, and it was not separately profiled.
- **`defect:flip-scalar:12`'s cycle interval is wide** ([7.57, 9.21]) where its instruction interval is
  degenerate and the budget-13 cycle interval is tight. The box was carrying other agents' builds; the
  instruction ratio is the reliable statistic.
- No correctness mystery. Both collapses are bit-exact against their predecessors on the real plane, on
  every pencil, on hostile multisets, and on the real catalogue.

### Vibe check

Clean landing. Two kernels collapsed in the core under the full gate with decisive instruction wins
(14.8x and 15.4x on the budget-12/13 scans, 5.0x on the catalogue), a negative control that correctly
shows nothing, bit-exact differentials against both predecessors, and the private duplicate deleted.
The uncomfortable finding is the one that has nothing to do with performance: the scan the search
depends on cannot be reached by any set anyone can currently build, which says more about how far the
defect-19 branch is from a survivor than any of the ratios do.

## Log addendum, 2026-09-03: probe 11 entry from the exploration log

Probe 11: defect-kernel collapses landed in the Ergodis core under the full gate (core commits
`eb349ce`, `08ccfb0`, `9a02921`; ergodis-private `b25cb13` removes the replica). Appended to this
report. Verdict: **landed**. Binary splitting over multiplicities replaces the per-degree fold;
threshold masks rebuilt as one scatter plus suffix and prefix scans; both predecessors retained as
cfg(test) differential references. Paired A/B, seven rounds, two retained binaries with distinct
hashes: 14.85x / 15.45x fewer instructions at budgets 12 / 13 on the whole-plane scan (cycles 8.3x
/ 9.3x), 2.15x per pencil, 5.04x on the catalogue constructor, all CIs excluding 1.0; the depth-32
search is the negative control at 1.000x. Bit-exact on PG(2,27) at five seated prefixes and every
budget, all 757 pencils, 2,000 hostile multisets, the catalogue's masks; zero-allocation
regression; identical work counts across arms and under parallel at 1/2/8 threads. Gate green:
fmt, clippy, 747 tests, 79 Python oracle tests. Finding: `analyze_fixed_maximal_set`
short-circuits on a negative correction budget and the best constructible 54-point set reports
defect 640 for a budget of -621, so the flip scan is unreachable through the public analysis; a set
with defect at most 19 is the open object it searches for, which is why the end-to-end workload
shows no change. Hazard recorded: a worktree build sharing the target directory overwrote the
candidate binary and produced two identical retained arms; compare SHA-256 of both arms before
trusting an A/B.
