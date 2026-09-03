# C1061 probe 1: composition survey and retained-tree delta prototype

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 (Ergodis as a compiled dynamic decision engine), open-ended probe 1.
**Brief**: `notes/2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`

Contract documents read in full before any work: `/home/tavis/src/ergodis/CLAUDE.md`,
`/home/tavis/src/ergodis-contrib/PERFORMANCE.md`, `/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`.

## Part A — survey of the existing composition and incremental machinery

### A1. Associative composition / min-sum / Pareto / semiring operators over boundary-indexed summaries

| Operator | Location | Element type | Associativity checked? |
|---|---|---|---|
| Finite ordered commutative monoid `combine` | `/home/tavis/src/ergodis/src/ordered_resource.rs:10` (trait `FiniteOrderedMonoid`) | compact `u32` element ids | Yes — `validate_finite_ordered_monoid` (`ordered_resource.rs:53`) exhaustively certifies identity, commutativity, associativity, reflexivity, antisymmetry, transitivity, monotonicity, extensivity over all triples. This is the strongest algebraic gate in the tree. |
| `CappedAdditiveMonoid` (coordinatewise capped resource vectors) | `ordered_resource.rs:132` | encoded resource vector `u32` | Yes, through the same validator |
| Pareto-front composition `WitnessedParetoWorkspace::compose` | `ordered_resource.rs:511` | `ParetoWitness` fronts | Indirectly — correctness rests on the validated monoid; no separate front-level associativity property test |
| Min-plus label setting over a frozen quotient | `/home/tavis/src/ergodis/src/frozen_shortest_path.rs` (`solve`, `solve_validated`, `verify_result`) | `u64` costs per quotient class, `ABSENT_SHORTEST_PATH_COST` sentinel | No algebraic law test; it has a result verifier instead (`verify_result`, line 285) |
| `CompositionTable::compose*` and `CostTable` (matrix-label min-cost composition over a finite field) | `/home/tavis/src/ergodis/src/composition.rs:257,272-344` | `CostRecord { label: MatrixId, cost: u32, witness: u32 }`, 16 bytes | No explicit associativity property test |
| Interface presentation (finite interface / Pareto interface) | `/home/tavis/src/ergodis/src/interface.rs:24,132,154` (`FiniteInterfaceAdapter`, `present_witnessed_pareto_interface`) | quotient classes + Pareto fronts | Laws come from the monoid validator |
| Repair-DAG batch scheduling (min-slot BFS over subset states) | `/home/tavis/src/ergodis/src/applications.rs:1075` `schedule_repair_dag` | `u64` subset mask, `RepairVisit` 24-byte record | Not an associative operator at all — it is a BFS over `2^tasks` subsets |

Only `ordered_resource.rs` treats associativity as a certified law. Everything else composes
associatively in fact but is gated by result verification or Python differential parity, not by a
law test. That is the first gap: an `OpenProblem` layer wants `compose` associativity as a
property test per instantiated semiring.

### A2. Is any composition result retained as a tree/DAG updatable leaf-to-root?

Nearly, but no. `CompositionTower` (`composition.rs:206`) retains `ordinary_base`/`target_base`
cost tables plus a boxed slice of `CompiledTowerLevel`, each holding its own `CompositionTable`.
That is a retained *linear tower*, not a balanced tree, and it is built for replay
(`TowerWitness`, `replay_target_witness*`, `TowerReplaySummary`) rather than for update: there is
no entry point that re-evaluates one base entry and repairs only the levels above it, and the
levels are keyed by label matrices rather than by leaf index, so there is no leaf identity to
address a delta to. `FrozenObservation` / `FrozenParetoPlan`
(`/home/tavis/src/ergodis/src/observational.rs:2470`, `ordered_resource.rs:561`) are frozen
read-only artifacts with presized workspaces — exactly the right *snapshot* shape, and exactly the
wrong *mutable* shape: a parameter change requires re-solving the whole frozen plan.

So: retained state exists, retained-and-repairable state does not.

### A3. Existing incremental / delta / warm-start machinery

There is no `apply_delta`, warm-start, or differential-gate API anywhere in
`/home/tavis/src/ergodis/src` or `/home/tavis/src/ergodis-private/src`. What exists is four
private *tests* that check an incremental computation against a full recomputation:

- `/home/tavis/src/ergodis-private/src/g53_search.rs:2872` `incremental_orbit_moves_match_direct_recomputation`
- `/home/tavis/src/ergodis-private/src/q29_transfer_anneal.rs:297` `incremental_transfers_agree_with_direct_replay`
- `/home/tavis/src/ergodis-private/src/q18_unassumed_evolve.rs:368` `incremental_mutation_stream_preserves_rows_and_report_score`
- `/home/tavis/src/ergodis-private/src/order6_margin_evolve.rs:2631` `incremental_views_match_full_recomputation`

These are the "incremental differential gate" the handoff refers to: a *discipline* (every
incremental path is checked against a fresh full recomputation on a deterministic stream), applied
ad hoc inside four search adapters, with no shared type, trait, or harness. The discipline is the
reusable asset; the code is not. Probe 1 adopts the same gate for the new layer.

### A4. Repair-DAG and capacitated simultaneous-repair code, and its boundary/interface types

All in `/home/tavis/src/ergodis/src/applications.rs`:

- `ceph_xor_repair_supports` (line 260), `ceph_xor_repair_supports_compressed` (364),
  `ceph_xor_repair_family` (374) — inclusion-minimal repair supports over XOR layers, with a
  compressed family (`CephCompressedRepairFamily`, 103) and a reliability polynomial (52, 126).
- `CephAggregatedRepairProblem` / `aggregate_for_scheduler` (88, 140) — the aggregation bridge into
  the scheduler.
- `azure_lrc_12_2_2_upgrade_domains` (618) and `azure_lrc_12_2_2_counted` (664) — capacity vector
  `[u32; 9]` plus a demand count, returning `AzureLrcBatchAnswer { repaired_count, ... }` (650).
- `gpu_checkpoint_mds_recovery` (752) and `gpu_checkpoint_mds_same_rack_recovery` (851), with
  `GpuCheckpointCapacities<'a>` (840) and `GpuCheckpointBatchAnswer::helper_shard` (829).
- `schedule_repair_dag` (1075) with `RepairTask { predecessors: u64, loads: Box<[u16]> }` (1018),
  `RepairDagAnswer { slots, task_batches, states_examined }` (1024), and the internal
  `RepairVisit` 24-byte visit record (size/align asserted at 1049).

The boundary/interface types here are *capacity vectors* (`&[u16]` / `[u32; 9]`) and *subset masks*
(`u64` over ≤63 tasks). Note the shape mismatch that matters for a delta layer:
`schedule_repair_dag` is an exponential-state BFS whose state is a subset mask, so it has no
factorization into per-leaf summaries and no cheap leaf-to-root repair. The *capacitated batch*
kernels (Azure LRC, GPU checkpoint) are much closer: they are parameterized by a capacity vector and
a demand count, which is exactly a delta vocabulary, but they recompute from scratch per call.

### A5. Quotient states, orbit canonicalization, sufficient-statistic features

- Quotient states: `CompiledObservation` (`observational.rs:2452`) with `class_of_state` /
  `representative_state` accessors reached through `ContinuationLevel`
  (`/home/tavis/src/ergodis/src/continuation.rs:30-58`); `FrozenObservation` (2470) is its
  serialized frozen form with `FrozenObservationStorage` / `FrozenObservationLimits`.
- Continuation hierarchy: `ContinuationHierarchy` (`continuation.rs:68`) with `verify_level`,
  `level_for_generators`, and `project_class` — a ladder of coarser quotients with an explicit
  projection between levels. This is the closest existing thing to the brief's "optimization
  congruence" ladder, but it is indexed by generator subsets, not by an update vocabulary.
- Orbit canonicalization: `/home/tavis/src/ergodis/src/group_action.rs` — canonical reduced
  row-echelon representatives (line 172, 194), dense canonical orbit ids (211), direct GL-quotient
  compilation by row-space canonicalization (413), and orbit compilation with a spanning-word
  certificate (994).
- Sufficient-statistic features: `/home/tavis/src/ergodis/src/feature_dag.rs` —
  `FeatureId`/`FeatureNode`/`FeatureOp` (23, 47, 60), `FeatureDagSnapshot` (91),
  `FeatureZeroQuotient` (257), `FeatureValueQuotient` (280) with explicit bounds, and
  `FeatureScopeBank` (484). Evolve's feature layer already *is* a sufficient-statistic search; what
  it does not have is the update monoid as a closure condition.

### A6. What is missing for `OpenProblem<Boundary, Summary>` with `apply_delta`, and where it sits

Missing, in dependency order:

1. **A leaf identity.** Nothing in the core addresses a compiled component by a stable leaf index
   that a delta can name. Composition is keyed by labels/classes.
2. **A retained composition tree with a repair entry point.** `CompositionTower` retains levels but
   exposes only replay.
3. **A typed delta enum as a compilation contract**, with a declared parametric/structural split
   and a `REBASE_REQUIRED` exit. Nothing of this exists.
4. **A generic summary trait**: `compose(&mut self, &S, &S)`, `identity()`, `optimum()`, so the same
   topology can be reinterpreted in min-plus / Boolean / counting / Pareto. Today each kernel hard-codes
   its semiring.
5. **A shared incremental differential gate** (the A3 discipline as a reusable harness).
6. **An event monoid type** with a collapse law (`fold` of a run equals event-by-event application).

Where it sits: the layer is *below* the application kernels and *above* the semiring elements. It
is domain-neutral enough to end up in the public core eventually
(`/home/tavis/src/ergodis/src/`, next to `composition.rs` and `ordered_resource.rs`), but per
`/home/tavis/src/ergodis-private/CLAUDE.md` it is experimental and not yet demonstrably reusable,
so probe 1 builds it entirely in `ergodis-private` tier 1. No change was made to
`/home/tavis/src/ergodis` — no core hook turned out to be needed, because the probe's summary type
is self-contained and does not have to reuse `CostTable`.

## Part B — retained composition tree with typed deltas

### B1. What was built

New tier-1 module (no task ID in the name, per the private repo's layout rules):

- `/home/tavis/src/ergodis-private/src/delta_composition.rs` — the layer.
- `/home/tavis/src/ergodis-private/tests/delta_composition_allocations.rs` — zero-allocation regression.
- `/home/tavis/src/ergodis-private/tasks/tools/src/delta_composition_bench.rs` — the sequence benchmark,
  wired as the `delta-composition-bench` subcommand of the existing `ergodis-tools` binary (no new
  `src/bin` file).
- `/home/tavis/src/ergodis-private/src/lib.rs` — one `pub mod delta_composition;` line.

**Domain.** A chain of capacitated repair stages, *clearly synthetic*: no existing kernel exposes a
per-leaf-addressable min-plus chain (see A2/A4), so the probe builds the minimal one, shaped after
the capacitated repair chains. Each stage carries an immutable compiled min-plus transfer matrix
over a 4-label boundary alphabet plus mutable parameters `{ offset: i32, capacity: u8, enabled: bool }`.
The instance generator is SplitMix64 with a declared seed.

**Algebra.** Min-plus (tropical) matrix product on `4 x 4` matrices with a `u32::MAX` absent
sentinel: associative, non-commutative, unit = the min-plus identity matrix. The observable is one
matrix entry (entry label 0 to exit label 3).

**Representation.** `Summary` is `#[repr(C, align(64))]`, exactly one 64-byte cache line, with a
compile-time `size_of`/`align_of` assertion. `LeafParameters` is `#[repr(C)]`, 8 bytes, also
asserted. No owned dynamic container appears in either hot record. The tree is a single flat
`Box<[Summary]>` in heap layout (node 1 = root, children `2i`/`2i+1`, leaf `l` = node
`leaves + l`), leaf count rounded up to a power of two with identity padding leaves, which are inert
because the identity is the composition unit.

**Delta vocabulary** (`enum Delta`): `CostBump { leaf, amount: i32 }`,
`SetEnabled { leaf, enabled }`, `SetCapacity { leaf, capacity }`. Every variant keeps the compiled
topology fixed, so no variant can force a rebase; a structural event is deliberately not
representable in the type, which is the point of the enum-as-contract framing.

**`apply_delta`** mutates the leaf parameters, re-evaluates that one leaf summary from its immutable
base matrix, and walks `1 + log2(leaves)` nodes to the root, recomposing each. Iterative, no
recursion, no allocation.

**Event monoid** (`DeltaRun`): a run of events on one leaf folds into
`{ bump: i64, enabled: Option<bool>, capacity: Option<u8> }` — additive accumulation for the bump,
last-writer-wins for the two setters. `apply_run` applies the fold and repairs the path once.

### B2. A design defect the collapse law caught

The first version stored `offset: u32` and applied `CostBump` with saturating add/sub. That broke
the collapse law: from offset 1, the run `(-8, +8)` gives 8 event-by-event (because the intermediate
saturated at 0) but 1 when collapsed. Storing the offset **signed** and clamping to zero only when
the leaf summary is evaluated makes `CostBump` an exact group action on the parameter record, so any
run collapses exactly and rollback is algebraic. This is a small instance of the brief's general
point: the quotient must be closed under the update vocabulary, and a lossy store is what breaks
closure. Test `collapsed_run_equals_event_by_event_application` is the gate.

### B3. Correctness gates (all passing)

In `delta_composition.rs`:

- `min_plus_composition_is_associative` — `(a*b)*c == a*(b*c)` on generated summaries.
- `identity_is_a_two_sided_unit`.
- `retained_tree_matches_fresh_recomposition_after_every_delta` — 37 leaves, 20,000 deltas, exact
  agreement of the incremental optimum with a fresh full recomposition **after every single delta**.
- `collapsed_run_equals_event_by_event_application` — 2,000 runs of 5 events, both the optimum and
  the leaf parameter record must match.
- `padding_leaves_do_not_change_the_answer` — 33 real leaves padded to 64.

In `tests/delta_composition_allocations.rs`: `delta_updates_allocate_nothing_in_steady_state` —
1,024 leaves, 50,000 pre-drawn events, counting global allocator, asserts **0** allocations across
both `apply_delta` and `apply_run` loops.

The benchmark also has a `--verify` mode that re-runs the fresh recomposition oracle inside the
measured sequence; `--leaves 256 --events 20000 --verify` reports `verify_mismatches 0`.

Commands run:

```
cd /home/tavis/src/ergodis-private
cargo test -p ergodis-private --lib delta_composition        # 5 passed
cargo test --test delta_composition_allocations              # 1 passed
cargo fmt --all --check
cargo clippy --workspace --all-targets -- -D warnings        # clean
cargo build --release -p ergodis-tools
cargo test --workspace                                       # full private workspace, still
                                                             # running at report time; the
                                                             # change is additive (one new
                                                             # module, one new test file, one
                                                             # new subcommand) and every
                                                             # targeted gate above passed
```

Committed in `ergodis-private` as `cbf2332`. No change was made in `/home/tavis/src/ergodis`
(working tree clean); no core hook was needed.

### B4. Measured numbers

Host: the usual development box, NixOS; release profile; shared target directory
`~/.cache/ergodis/target/ergodis-private`. Binary
`~/.cache/ergodis/target/ergodis-private/release/ergodis-tools`. Seed 2026 throughout.

`ergodis-tools delta-composition-bench --leaves 1024 --events 200000`:

| Quantity | Value |
|---|---|
| boundary width | 4 labels (16-entry summary, 64 bytes) |
| leaves | 1,024 |
| tree nodes | 2,048 |
| nodes touched per update | 11 |
| fraction of tree recomputed per update | 0.00537 |
| bytes of maintained state | 204,800 |
| snapshot compile | 329,352 ns |
| fresh full recomposition (mean of 64) | 116,632 ns |
| delta mean | 317.8 ns |
| delta p50 | 290 ns |
| delta p99 | 722 ns |
| delta p99.99 | 4,138 ns |
| delta max | 794,897 ns (one sample; scheduler artifact, single histogram overflow) |
| break-even update count `T_compile / (T_fresh - T_delta)` | 2.83 updates |
| allocations per update | 0 (asserted by regression test) |

`--leaves 16384 --events 200000`:

| Quantity | Value |
|---|---|
| leaves | 16,384 |
| nodes touched per update | 15 |
| fraction of tree recomputed | 0.000458 |
| maintained state | 3,276,800 bytes |
| snapshot compile | 4,901,540 ns |
| fresh full recomposition | 4,930,738 ns |
| delta mean / p50 / p99 / p99.99 / max | 614.0 / 491 / 1,463 / 14,617 / 121,816 ns |
| break-even | 0.99 updates |

So a single event costs about 8,000x less than a fresh solve at 16k leaves, and the compile pays for
itself after one update. The delta cost grows as `log(leaves)` (11 vs 15 nodes → 318 vs 614 ns,
consistent with the extra levels plus worse cache locality on the 3.3 MB state).

**Hardware counters** (playbook counter method; `perf stat -e instructions,cycles`, two run sizes
differenced so process startup and instance generation cancel). With `--collapse-run 1` each
`--events N` run performs `3N` tree updates (timed loop, stepwise loop, collapsed loop):

```
perf stat -e instructions,cycles -x, ergodis-tools delta-composition-bench --leaves 1024 --events 200000  --collapse-run 1
perf stat -e instructions,cycles -x, ergodis-tools delta-composition-bench --leaves 1024 --events 1200000 --collapse-run 1
```

| | 200k | 1.2M | difference | per update (3M updates) |
|---|---|---|---|---|
| instructions:u | 1,482,395,689 | 8,580,443,802 | 7,098,048,113 | ~2,366 |
| cycles:u | 656,592,984 | 3,732,924,141 | 3,076,331,157 | ~1,025 |

IPC ~2.31. Roughly 1,025 cycles for 11 min-plus 4x4 products (704 min-plus operations plus the leaf
re-evaluation), i.e. about 1.5 cycles per min-plus operation with the current scalar inner loop.
One third of the measured updates also carry an `Instant::now()` pair, so the true update cost is
somewhat below these figures; a SIMD `compose_into` over the 4-wide rows is the obvious next lever
and is not yet attempted.

**Monoid collapse.** Folding `k` consecutive events on the same leaf into one `DeltaRun` before
touching the tree, at 1,024 leaves and 200,000 events:

| run length `k` | stepwise | collapsed | speedup |
|---|---|---|---|
| 8 | 51,771,418 ns for 200,000 events | 7,336,726 ns for 25,000 runs | 7.06x |
| 8 (16,384 leaves) | 200,000 events | 25,000 runs | 4.56x |

The speedup tracks `k` almost exactly at 1,024 leaves (7.06 vs the ideal 8), confirming that the
tree walk, not the leaf evaluation, dominates the update; at 16,384 leaves the ratio drops to 4.56
because each remaining walk is longer and colder. Practical consequence: batching an event burst per
leaf before touching the retained tree is close to a free `k`-fold win, and it is exactly the
segment-tree/parallel-prefix structure the brief predicted.

## Part C — verdict notes

### C1. Is the optimization congruence exact for this domain?

**Yes, exactly, for the declared vocabulary.** The quotient map sends a stretch of the chain to its
`4 x 4` min-plus boundary matrix. It satisfies all three conditions of the brief:

1. *The observable factors through it.* The optimum is one entry of the composed matrix, and the
   witness (the argmin sequence) is recoverable from the same matrices by the standard back-pointer
   walk (not implemented in probe 1 — see C3).
2. *Composition descends.* Min-plus matrix product is associative with the identity matrix as unit;
   the summary of a concatenation depends only on the two summaries, never on their interiors.
   `min_plus_composition_is_associative` and `identity_is_a_two_sided_unit` gate this.
3. *Every allowed update descends.* Each `Delta` names one leaf and only changes that leaf's
   parameter record; the leaf summary is a pure function of `(immutable base matrix, parameters)`.
   Nothing outside the changed leaf's ancestor path can change.

The quotient is *not* finite in the sense of a finite transducer — the summary carries `u32` costs,
so `Q` is countably infinite. It becomes finite under either a cost cap or a
difference-from-diagonal normalization, which is the standard tropical-matrix normalization and the
natural next thing to test (C3). Where the congruence would break is instructive: it broke once
already, at the saturating `u32` offset (B2), because the store lost information the collapse law
needed. Any lossy parameter store, or any event that touches two leaves with a shared constraint,
would break condition 3.

### C2. Interface width

The interface is **4 boundary labels, 16 min-plus entries, 64 bytes per summary** — one cache line,
chosen so a summary is exactly one Tiger-style record. Cost scaling is the binding constraint here:
compose is `O(W^3)`, and the maintained state is `2 * leaves * W^2 * 4` bytes. At `W = 8` a summary
is 256 bytes (four lines) and compose is 8x more work per node; at `W = 16` it is 1 KiB and 64x. The
brief's claim that interface width, not system size, is the controlling parameter is directly
visible in this measurement: going from 1,024 to 16,384 leaves cost 1.9x per update (log growth),
while going from `W = 4` to `W = 16` would cost roughly 64x. Any real domain has to justify a narrow
boundary before anything else matters.

### C3. Most promising next probes

1. **Witness and certificate deltas.** Probe 1 maintains the optimal *value* only. Maintaining the
   argmin back-pointer per matrix entry, and emitting `(C_t, d_t) -> C_{t+1}` touching only the
   changed leaf and its ancestors, is brief item 4 and is the difference between a benchmark and a
   product claim.
2. **Normalize the summary to make the quotient finite.** Subtract the row minimum (standard
   tropical projective normalization) and cap; then count the reachable normalized summaries on a
   real instance. If that count is small, the brief's "exact optimization becomes a finite weighted
   transducer" ending is reachable and testable, not just asserted.
3. **Several semirings over one topology.** Make `Summary` a trait with `compose_into`/`identity`
   and instantiate Boolean (feasibility), counting, and Pareto alongside min-plus with a const
   generic. The cheap test of brief item 7, and it also produces the associativity property test per
   semiring that A1 says the core lacks.
4. **Bind a real kernel.** The capacitated batch kernels (`azure_lrc_12_2_2_counted`,
   `gpu_checkpoint_mds_same_rack_recovery` in `applications.rs`) are parameterized by a capacity
   vector — a ready-made delta vocabulary — but recompute from scratch. Making one of them
   leaf-addressable is the first non-synthetic instance. `schedule_repair_dag` is *not* the target:
   its subset-mask BFS has no per-leaf factorization.
5. **SIMD `compose_into`.** ~1.5 cycles per min-plus operation scalar; the 4-wide row is a natural
   128-bit `min`/saturating-add pair. Worth roughly 2-4x on the update path, and it is the only
   instruction-level lever visible before the representation changes.
6. **Tree over a real topology, not a chain.** The rack/pod hierarchy the brief names is a tree with
   varying arity; the balanced-binary heap layout here has to generalize to a compiled arbitrary
   tree with a per-node arity, which changes the update path length but not the algebra.
7. **Promote the incremental differential gate.** A3 found the same "check the incremental path
   against a fresh recomputation on a deterministic stream" discipline copy-pasted into four private
   adapters. A shared harness is a genuine tier-1 asset independent of this probe.

### Mystery ledger

- **Break-even under one update at 16,384 leaves** (0.99). The compile and the fresh full
  recomposition are nearly the same cost (4.90 vs 4.93 ms) because compile *is* a full recomposition
  plus one allocation. That is expected here, but it means the "compile is expensive, amortize it"
  framing has no force in this domain — the interesting amortization only appears when compile does
  real structural work (orbit canonicalization, quotient construction), which probe 1 does not do.
  Settled by inspection; flagged because it will mislead anyone reading only the table.
- **Collapse speedup 7.06 at `k = 8` but 4.56 at 16,384 leaves.** Explained by the longer, colder
  walk, but not separately measured; a counter run at both sizes would confirm it is cache misses
  rather than path length. Open, cheap.
- **The 794,897 ns max delta sample.** One sample out of 200,000, three orders above p99.99, and the
  only histogram overflow. Almost certainly scheduler preemption or a page fault, but probe 1 does
  not pin threads or pre-fault the state, so it is not proven. Open; matters for any tail-latency
  claim and would be settled by `choom`/pinning plus a pre-fault pass.
- No genuine algebraic mystery remains: the congruence is exact, and the one law that failed (the
  saturating offset) was diagnosed and fixed.

### Vibe check

Good, and cheaper to reach than expected. The algebra held on the first real attempt, the collapse
law caught a genuine design defect within an hour, and the headline ratio (a single event ~8,000x
below a fresh solve at 16k leaves, with zero steady-state allocations) is the shape the brief
predicted. The caveat is that the domain is synthetic by necessity — the survey found no
existing kernel with a per-leaf-addressable compositional structure — so the next real milestone is
binding a capacitated batch kernel, not making this one faster.
