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
