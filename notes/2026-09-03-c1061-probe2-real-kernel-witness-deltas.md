# C1061 probe 2: real kernel binding, witness deltas, quotient finiteness

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 2, continuing `notes/2026-09-03-c1061-probe1-composition-survey-and-delta-prototype.md`.

Files (all in `ergodis-private`; the public core at `/home/tavis/src/ergodis` was not modified and
its working tree is clean):

- `/home/tavis/src/ergodis-private/src/lrc_delta_binding.rs` — the binding, schema, event contract,
  witness tree, tropical normalization, and symmetry canonicalization.
- `/home/tavis/src/ergodis-private/tests/lrc_delta_allocations.rs` — zero-allocation regression for
  the update path *and* for witness materialization.
- `/home/tavis/src/ergodis-private/tasks/tools/src/lrc_delta_bench.rs` — the `lrc-delta-bench`
  subcommand of the existing `ergodis-tools` binary.
- One `pub mod lrc_delta_binding;` line in `src/lib.rs` and three lines in
  `tasks/tools/src/main.rs`.

## Part A — binding a real capacitated kernel as leaves

### A1. The problem, and why this kernel

Probe 1 found no existing kernel with a per-leaf-addressable compositional structure. The closest
real candidates were the capacitated batch kernels in `/home/tavis/src/ergodis/src/applications.rs`,
which are parameterized by a capacity vector — a ready-made delta vocabulary — but recompute from
scratch. This probe binds `azure_lrc_12_2_2_counted` (line 664 of that file), the exact counted
compiler for the published Azure LRC(12,2,2) upgrade-domain layout, as the **leaf evaluator** of the
retained tree.

The composed problem is a fleet: a chain of pods, each one an LRC(12,2,2) stripe with its own nine
upgrade-domain capacities and its own count of shards awaiting repair. The pods are coupled by one
shared pool of cross-rack global-parity repair budget — budget spent on an early pod is not
available to a later one. The **boundary label is how much of that shared budget has been spent so
far**, quantized to four levels, and the summary entry `cost[b][b']` is the cheapest way for a
stretch of the chain to move the shared-budget counter from level `b` to `b'`. Cost is
`UNSERVED_PENALTY = 100` per shard the pod cannot repair plus `BUDGET_WEIGHT = 7` per level
consumed. The fleet optimum is the cheapest fleet-wide allocation of the shared budget.

Each leaf entry is one call into the real kernel: `evaluate_pod` tops the two global-parity domain
capacities up by `(b' - b) * budget_grain`, calls `azure_lrc_12_2_2_counted`, and charges the
shortfall. Ten calls per leaf (the upper triangle of a 4x4 matrix). Nothing about the repair
mathematics is reimplemented.

This is a genuine min-plus chain over real application code, and the coupling is exactly the
one-dimensional bounded interface the brief predicts is the controlling parameter.

### A2. Schema versus parameters, and the event contract

**Stable schema** (`FleetSchema`): the pod count, the LRC(12,2,2) code itself (twelve data labels in
six upgrade domains, one local parity domain, two global parity domains) and the helper
relationships that code fixes, the boundary alphabet size, and the shared-budget grain.

**Mutable parameters** (`PodParameters`, `#[repr(C)]`, 48 bytes, layout asserted): the nine
upgrade-domain capacities, a nine-bit availability mask, and the demand count. Availability *gates*
a capacity rather than overwriting it, so a node recovery restores the exact prior state — the
inverse-event property that makes availability a group action rather than a lossy one.

**Event vocabulary** (`FleetEvent`) and its classification (`EventClass`):

| Event | Class | Affected components |
|---|---|---|
| `DomainCapacityChanged { pod, domain, capacity }` | parametric | leaf `pod` |
| `DomainAvailabilityChanged { pod, domain, available }` | parametric | leaf `pod` |
| `DemandChanged { pod, demand }` | parametric | leaf `pod` |
| `BudgetGrainChanged { grain }` | **`RebaseRequired`** | whole artifact |
| `PodCountChanged { pods }` | **`RebaseRequired`** | whole artifact |

The affected set is **derived from the schema, not hardcoded in the handler**:
`FleetSchema::affected` reasons from two declared schema facts — pods are coupled only through the
shared-budget boundary, and every mutable parameter is owned by exactly one pod — to conclude that a
parametric event's affected set is the single leaf owning the named pod. A schema-valued event has
no affected leaf set at all, because the compiled artifact itself is invalid, so it returns
`RebaseRequired`; a malformed event returns `OutOfRange`. `apply_event` returns the class it took,
so a caller can count rebases. The classification is gated by
`structural_events_are_classified_as_rebase`.

The value-only and witness-maintaining trees are one type with a `const WITNESS: bool` parameter, so
the production value-only instantiation contains neither the witness stores nor a run-constant
branch — the playbook's monomorphize-once rule, and it doubles as the A/B for the witness cost.

### A3. Exact agreement

- `retained_tree_matches_fresh_solve_after_every_event` — 23 pods, 5,000 events, the retained
  optimum is compared with a fresh full recomposition **after every event**, and every event is
  asserted to have been classified parametric.
- `witnessed_and_value_only_instantiations_agree` — 13 pods, 2,000 events, both instantiations
  driven by the identical stream.
- The benchmark's `--verify` mode re-runs the fresh solve inside the measured sequence:
  `--pods 256 --events 20000 --verify` reports `verify_mismatches 0`.

### A4. Measured numbers

Release build, shared target directory, binary
`~/.cache/ergodis/target/ergodis-private/release/ergodis-tools`, seed 2026, grain 2.

`ergodis-tools lrc-delta-bench --pods 1024 --events 200000`:

| Quantity | Value |
|---|---|
| pods (leaves) | 1,024 |
| tree nodes | 2,048 |
| nodes touched per update | 11 |
| fraction of tree recomputed | 0.00537 |
| state, value-only | 188,416 bytes |
| state, witness-maintaining | 221,184 bytes |
| snapshot compile | 1,448,791 ns |
| fresh full solve | 1,208,597 ns |
| events / rebases | 200,000 / 0 |
| delta mean | 1,892.9 ns |
| delta p50 / p99 / p99.99 / max | 1,834 / 2,705 / 9,057 / 124,804 ns |
| break-even update count | 1.20 |
| allocations per update | 0 (regression test) |

`--pods 16384 --events 200000`:

| Quantity | Value |
|---|---|
| nodes touched per update | 15 of 32,768 (0.0458%) |
| state, value-only / witnessed | 3,014,656 / 3,538,944 bytes |
| snapshot compile | 21,665,384 ns |
| fresh full solve | 19,125,509 ns |
| delta mean | 1,889.7 ns |
| break-even | 1.13 updates |

**The delta cost is flat in fleet size** — 1,893 ns at 1,024 pods and 1,890 ns at 16,384 — because
the ten real-kernel calls in one leaf evaluation dominate the `log(pods)` tree walk. At 16,384 pods
a single event therefore costs about **10,000x less than the fresh solve** (1.89 µs against 19.1 ms).
That is the sharpest result in this probe, and it inverts probe 1's cost picture: there the tree walk
dominated and collapsing events was worth a factor of `k`; here the leaf evaluator dominates, so the
next lever is memoizing or specializing the kernel call, not shortening the walk.

**Hardware counters** (`perf stat -e instructions,cycles`, two run sizes differenced so process
startup and instance generation cancel; each `--events N` run performs one value-only and one
witnessed pass, so the difference covers `2N` updates):

| | 100k | 600k | difference | per update (1M updates) |
|---|---|---|---|---|
| instructions:u | 4,066,770,891 | 21,355,179,659 | 17,288,408,768 | ~17,288 |
| cycles:u | 1,415,763,410 | 7,550,559,348 | 6,134,795,938 | ~6,135 |

IPC 2.82. Roughly 600 cycles per kernel invocation, ten invocations per leaf evaluation.

## Part B — witness deltas

### B1. What is maintained

Each internal node stores a `WitnessBlock` (`#[repr(C, align(16))]`, exactly 16 bytes, layout
asserted): the argmin split boundary label for each of the sixteen `(from, to)` entries.
`compose_into_witnessed` records the argmin as it computes the min-plus product, so maintaining the
witness costs one extra byte-store per entry and no extra pass. `apply_event` repairs the witness
blocks on exactly the same leaf-to-root path as the values — the witness is never reconstructed from
scratch.

`materialize_witness` reads those blocks top down with an explicit presized stack (no recursion, no
allocation) and fills a `PodDecision` per pod: entry level, exit level, shards repaired, shards
unserved. The repaired count comes from the same real kernel, so the witness carries the actual
repair-mode allocation, not just an abstract path.

### B2. Cost and state, measured

| Quantity | Value-only | Witness-maintaining | Ratio |
|---|---|---|---|
| state at 1,024 pods | 188,416 B | 221,184 B | 1.174 |
| state at 16,384 pods | 3,014,656 B | 3,538,944 B | 1.174 |
| compile | 1,448,791 ns | 1,604,232 ns | 1.107 |
| delta mean at 1,024 pods | 1,892.9 ns | 2,562.2 ns | 1.354 |
| delta p50 / p99 | 1,834 / 2,705 ns | 2,494 / 3,506 ns | 1.36 / 1.30 |
| delta mean at 16,384 pods | 1,889.7 ns | 2,590.2 ns | 1.371 |

**Maintaining the optimal witness costs about 35% more per update and 17% more state.** That is the
whole price of `apply_delta` yielding the new witness rather than only the new value.

Materialization is a separate, on-demand cost and it is `O(pods)`: 116,582 ns at 1,024 pods and
2,609,949 ns at 16,384. Stated plainly, the *maintenance* of the witness index is `O(log pods)` per
event, but *reading the whole witness out* is linear — at 16,384 pods it is 2.6 ms against a 19.1 ms
fresh solve, so it is only a 7x saving, not a 10,000x one. A consumer that needs the full allocation
after every event gets far less benefit than one that needs it occasionally or needs only the
decisions near a changed pod. Extracting just the changed suffix of the witness is the obvious
follow-on and is not implemented here.

### B3. Witness correctness gates

- `maintained_witness_agrees_with_the_maintained_value` — 17 pods, 3,000 events: after every event
  the materialized witness must be a valid chain (levels contiguous and non-decreasing, starting at
  zero) and its independently recomputed cost must equal the maintained optimum, which must in turn
  equal the fresh solve.
- The benchmark prints `witness_chained true` and `witness_cost 604500` against
  `optimum 604500` at 1,024 pods.
- `fleet_updates_and_witness_materialization_allocate_nothing` — 512 pods, 20,000 events: zero
  allocations in the value-only update loop, zero in the witnessed update loop, and zero in a
  steady-state `materialize_witness` call.

## Part C — quotient finiteness

### C1. Tropical normalization

`NormalizedSummary::split` factors a summary into `(offset, residual)` by subtracting the global
minimum of the finite entries. A min-plus summary and the same summary plus a constant choose the
same argmin, so the residual is the part that carries the decision and the offset is a scalar
carried alongside. `tropical_normalization_is_offset_plus_residual` gates the reconstruction
identity and that the residual attains zero.

Census over the first 20,000 events of the standard stream at 1,024 pods:

| Quantity | Raw | Tropically normalized |
|---|---|---|
| distinct leaf summaries | 25 | **2** |
| distinct root summaries | 1,338 | **4** |

At 16,384 pods the same census gives 3 normalized leaf classes and 3 normalized root classes.

**Verdict: the normalized boundary state space is finite and very small on this real kernel.** Two
to three residual classes at the leaves and three to four at the root, against 1,338 distinct raw
root matrices. The raw state space is unbounded only through the additive offset, which is a scalar;
the *shape* of the boundary cost function takes a handful of values. This is the concrete form of
the brief's claim that "if the quotient is finite, exact optimization becomes a finite weighted
transducer": for this domain the transducer would have on the order of four states carrying one
integer offset, which is a genuinely compilable object. Probe 3 should try to build it and check
that the transition function closes.

The caveat is scope: the census counts classes *reached by this event stream on this fleet*, so it
is a measured lower bound on the reachable set and not a proof of a bound over all parameter values.
Establishing the bound needs an argument over the kernel's cost structure, not a longer run.

### C2. Orbit canonicalization under the code symmetry

The LRC(12,2,2) layout treats its six data upgrade domains symmetrically: the kernel's per-domain
load is `(L + 2G) - s_i` for every data domain `i`. Permuting the six data capacities therefore
looks like it should leave the answer unchanged, which would let many distinct pods share one
compiled leaf class. `canonical_pod` sorts the six data capacities to test that.

**It is exact only when the demand count is a multiple of six.** The kernel's multiplicity vector is
`complete_cycles + (kind < remainder)`, so when `demand % 6 != 0` the first `demand % 6` data
domains each carry one extra demand and the six domains are no longer interchangeable; sorting the
capacities can then change the answer. `data_domain_permutation_is_exact_only_on_full_demand_cycles`
asserts exactness on full cycles and records the asymmetric case without asserting it.

Practically, on the benchmark fleet 236 of 1,024 pods sit on a full demand cycle (about 23%, which
is exactly `3/13` for demand drawn uniformly from `0..13`), so plain capacity sorting is a valid
canonicalization for under a quarter of pods. The correct canonical form for the rest sorts the
*pairs* `(capacity, multiplicity)` rather than the capacities alone; that is a small change and is
the recommended next step, because it would make the symmetry usable on the whole fleet instead of a
quarter of it. The measured collapse from sorting alone is weak (1,024 distinct capacity vectors to
980 canonical forms at 1,024 pods) and most of the apparent collapse at 16,384 pods is a birthday
effect on a small capacity alphabet, not a structural merge.

## Validation

```
cd /home/tavis/src/ergodis-private
cargo test -p ergodis-private --lib lrc_delta        # 7 passed
cargo test --test lrc_delta_allocations              # 1 passed
cargo build --release -p ergodis-tools
ergodis-tools lrc-delta-bench --pods 256 --events 20000 --verify   # verify_mismatches 0
perf stat -e instructions,cycles -x, ergodis-tools lrc-delta-bench --pods 1024 --events {100000,600000}
```

Committed in `ergodis-private` as `525a82b`, staged as an exact patch so that only my own hunks of
the shared `src/lib.rs` and `tasks/tools/src/main.rs` were included and the concurrent agents' lines
were left in the working tree for them.

Two other agents are working in this repository concurrently. At the time of the final gate run,
`cargo clippy` and `cargo fmt --check` over the whole crate fail inside a foreign in-progress module,
`/home/tavis/src/ergodis-private/src/congruence_search.rs` (twelve compile errors plus formatting
diffs). That file is not mine and was left untouched. My own targeted gates above all pass; the
crate-wide clippy and fmt checks need a rerun once that module compiles.

## Mystery ledger

- **Two normalized leaf classes.** Settled enough to act on: the leaf cost function is
  `100 * unserved + 7 * levels` with `unserved` monotone in the allocated levels, so the residual
  shape is determined by how many of the four levels change the repaired count. What is *not*
  settled is whether the reachable set is bounded over all capacity and demand values rather than
  over this stream. Owning successor: probe 3's transducer construction, which fails loudly if the
  transition function does not close.
- **Delta cost flat in fleet size.** Explained — the ten kernel calls dominate the `log n` walk —
  but it means every conclusion about tree-walk cost from probe 1 is inapplicable here, and the
  monoid-collapse win from probe 1 will be roughly `1x` in this domain rather than `k`. Not
  measured here; cheap to check and worth doing before anyone assumes collapse transfers.
- **Witness materialization is `O(pods)`.** Real limitation, not a mystery, but it is the one place
  where the "the answer is maintained, not recomputed" framing does not hold end to end. A
  changed-suffix extraction would fix it; nobody has tried.
- **The 124,804 ns max delta and eight histogram overflows.** Same tail-latency artifact as probe 1,
  same unproven attribution to scheduler preemption and page faults. Open; needs pinning and
  pre-faulting to settle.
- The data-domain symmetry defect (exact only on full demand cycles) was a genuine surprise and is
  now settled with an exact condition and a named repair (canonicalize capacity-multiplicity pairs).

## Vibe check

Strong. The real kernel bound cleanly, every exact-agreement gate passed first try, witnesses cost
only 35% per update, and the tropical-normalization census came back with two to three classes,
which is a much better finiteness result than expected and makes a compiled transducer a real
target rather than a slogan. Two caveats keep it from being unqualified: reading the whole witness
out is still linear in fleet size, and the code symmetry is only exact on a quarter of the pods
until the canonical form is fixed to sort capacity-multiplicity pairs.

## Next probes

1. Build the weighted transducer the class census implies: enumerate the normalized boundary
   classes, derive `(class, event) -> (class, offset delta)`, and check closure. If it closes, the
   per-event cost stops depending on the kernel at all.
2. Fix the canonical form to sort `(capacity, multiplicity)` pairs so the code symmetry applies to
   every pod, then re-measure the collapse.
3. Extract only the changed suffix of the witness, removing the `O(pods)` materialization.
4. Memoize or specialize the ten kernel calls per leaf evaluation — the dominant cost now.
5. Re-run the probe 1 monoid collapse in this domain to confirm the expected near-`1x`.
