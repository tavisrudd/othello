# Ergodis core performance quick wins, 2026-09-02

**Lane:** `complete-ports`

Read-only survey of `papers/complete-repair-ports/ergodis/src` against `PERFORMANCE.md`,
`AGENTS.md`, `BENCHMARKS.md`, the C1017 remediation note, and the 2026-08-28 Lemire-lens
review. Nothing was built, run, or modified. Each row is a hypothesis to confirm with the
contract's A/B gate before acting.

## Already closed or owned elsewhere — do not re-propose

- `sat.rs` hash map where a dense array fits (review item 5): fixed, no `HashMap` remains.
- `span.rs` boxed duplicate key per state, double hashing (review item 5, Lemire list):
  fixed by `CollisionIndex` (hash head + `next_same_hash` chain).
- Recursive QC/orbit/meet-in-the-middle traversals: closed in C1017 with retained A/Bs.
- Sparse scheduler backend per-layer allocation: closed by `SparseRepairStorage` +
  `CollisionEpochIndex` + `quadratic_pareto_keep_into`.
- **C1048 (bounded subset-sum bitset, width cap):** `counts`/`scratch` as `Box<[u64]>` in
  `bounded_subset_sum::solve_into`, and the `2^20` width cap behind the C6-C8 declines.
  One note for that task: once `counts` is a bitset, it is row `item+1` of the existing
  `reachability` bitmap, so the two structures should merge rather than coexist.
- **C1049 (scheduler dominance):** `quadratic_pareto_keep` / `state_is_pareto`, the L2
  quadratic frontier scan, and any SWAR/packed rewrite of the dominance test itself.
  `packed_states: Vec<u128>` already exists for feasibility and is unused by the dominance
  test — that is an input to C1049, not a separate item.
- `defect.rs::refine` re-intersecting all `DEGREE_BINS` masks per node: still live, but
  `defect`/fixed-GF(27) is slated to leave public core per `AGENTS.md`; do not optimize
  in place.

## Memory

| # | module and function | cost now | change | expected gain, estimate basis | risk | one session | gate evidence |
|---|---|---|---|---|---|---|---|
| M1 | `scheduler.rs::dense_pareto_keep` | `prefix_best = vec![0u32; state_space]` freshly allocated and zeroed on every demand layer; `state_space` is the full capacity lattice, up to `MAX_DENSE_LATTICE_STATES = 1<<24`, so up to 64 MiB mapped, faulted, and unmapped per layer. Drives dense-backend peak RSS on the Repair DAG and GPU MDS headline rows. | Move `prefix_best` and `keys` into `WeightedRepairWorkspace`; reuse across layers. | Removes one mmap/munmap plus a full page-fault storm per layer. At 2^24 cells that is ~16k first-touch faults per layer; at ~0.2 us each, ~3 ms per layer. Peak RSS unchanged, but allocator churn and RSS sawtooth go away. | Low; buffer must still be cleared, so semantics are unchanged. | Yes | zero-alloc test around the dense loop; peak RSS before/after; interleaved retained-binary A/B on a dense-backend row |
| M2 | `scheduler.rs::dense_pareto_keep` `prefix_best` element type | `u32` per lattice cell holds `repairs + 1`, bounded by the demand count (18 in L2, 300 in W3). Half the bytes are always zero. | Narrow to `u16` with an explicit guard that falls back to the `u32` sweep when `repairs + 1 > u16::MAX`. | Halves the bytes of the prefix-max sweep, which is a pure streaming pass over `state_space` and therefore memory-bandwidth bound. Expect close to 2x on that phase and half the workspace bytes. | Medium: needs the overflow guard and a two-type sweep, or a const-generic element type. | Yes | exact keep-vector parity on both element widths; RSS; A/B counters showing the cache/bandwidth effect |
| M3 | `scheduler.rs::solve_impl` `loads: Vec<u32>` | One `u32` per resource coordinate per state. Capacities are validated at the input boundary and fit `u16` in every benchmarked instance. `loads` also grows within a layer before compaction, so peak is old plus new. | Narrow the load element to `u16` behind a compile-time-checked boundary validation, per the contract's "size integer fields to their proven value range" rule. | Halves load-vector bytes. This also halves the bytes read by the dominance scan, so coordinate with C1049 rather than landing both blind. | Medium; touches the width contract in several functions. | Borderline — do it only after C1049 settles the dominance representation. | exact verdict/witness parity; RSS; A/B in single and parallel modes |
| M4 | `zdd.rs:1101-1111` reliability memo | `vec![BigUint::zero(); tail_size + 2]` per node, then `counts.clone()` deep-copies every limb into the memo. Two heap graphs per node. | Store the memo as a flat limb pool with per-node ranges, or move the clone to a single `into_boxed_slice` of the already-owned vector. | The second half is nearly free: `counts` is owned at that point, so the clone is redundant. Removes one full `BigUint` vector copy per memoized node. | Low for the redundant-clone half. | Yes for the clone removal alone | exact reliability-value parity on the fixture corpus; allocation count per solve |

Peak RSS on all six headline rows is already 1.9-3.8 MiB, so outside the dense scheduler
lattice and the C1048 subset-sum width there is no large memory target in this crate. Say so
rather than manufacturing one.

## Time

| # | module and function | cost now | change | expected gain, estimate basis | risk | one session | gate evidence |
|---|---|---|---|---|---|---|---|
| T1 | `scheduler.rs::solve_impl` (lines 691-960), the general dense-lattice backend | Per demand layer it allocates `updated` (`Vec::with_capacity(states.len())`), `updated_packed = packed_states.clone()`, `compact_loads`, and a `FxHashMap::<u64,u32>::default()` that is **not presized** and so reallocates and rehashes about `log2(states)` times per layer. `solve_dense_lattice_with_workspace` accepts a `WeightedRepairWorkspace` and then throws it away for these paths. This violates the non-negotiable allocation-free solve invariant. | Port the sparse backend's treatment: add the dense buffers to `WeightedRepairWorkspace`, double-buffer `states`/`updated` and `packed_states`/`updated_packed`, and replace `heads` with the existing `CollisionEpochIndex`. | The pattern, the epoch index, and `quadratic_pareto_keep_into` all already exist for the sparse path, so this is a port, not a design. Removes every per-layer allocation plus the repeated rehash of an entire layer's states. On the flat path the rehash alone touches every state `log2(n)` times per layer. | Low; mechanical, with a working precedent in the same file. | Yes | zero-allocation guard around `solve_impl` (the harness already brackets `solve_sparse_with_storage`); exact transition-count and witness parity; interleaved retained-binary A/B, single and parallel |
| T2 | `orbit.rs:120-152` `heads: FxHashMap<u64, u32>` | The key is already a 64-bit `FxHasher` digest of the packed trits and totals, and the map hashes it again on every lookup and insert. Chaining is already done externally through `next_same_hash`, so the map is used purely as a bucket head table. | Replace with `Box<[u32]>` of `next_pow2(2 * reservation)` heads indexed by `hash & mask`; the collision chain is unchanged. | Removes one `FxHash` round and one hashbrown control-group probe per transition, replacing them with a mask and a load. Affects the `orbit-grid` and `orbit-meet` rows that C1017 already A/B'd (3.25 s and 1.01 s per round), so the control is retained and the harness exists. Expect low single-digit percent, more if the map is near its load factor. | Low; the map is already presized, so occupancy is bounded and a fixed table cannot overflow. | Yes | exact state count and witness parity per solve; A/B counters (branch misses and L1/L2 misses are the ones that should move) |
| T3 | `applications.rs:1050-1052` `repair_dag_*` BFS | Two separate `FxHashMap`s (`distance: u64 -> u16`, `parent`) keyed by the same subset mask, both default-constructed and grown from empty, plus a growing `VecDeque`. Two hash computations and two probe sequences per visited state. This is the Repair DAG headline row (167x cold, 275x warm). | Merge into one map to a packed `{distance, parent}` record, presize from the budget, and presize the queue. | Halves hash and probe work per BFS state and removes the growth reallocations. Fermi: the BFS is dominated by map traffic since the successor generation is a few mask operations. Expect 20-40% on this kernel. | Low; single function, exact same visit order. | Yes | exact `slots`, `task_batches`, and `states_examined` parity; A/B on the Repair DAG row with equal cold and warm boundaries |
| T4 | `matrix.rs::row_space_contains_field` (215-234) | Appends candidate rows one at a time; each `append_row_field` allocates a whole new matrix and re-scans all data for reducedness, so k rows cost O(k^2) copies. Then it runs a full canonical row basis where only the rank is needed. | Build the joined data once into a single `Vec`, call `canonicalize_rows_in_place_field` on it, and compare pivot counts. Skip the re-validation on data already validated. | Turns O(k^2) copying plus k validation scans into one copy and one scan. Review item 2, still live verbatim. | Low; the comparison is already `rank == rank`. | Yes | exact boolean parity across the fixture corpus and both field paths; allocation count per call |
| T5 | `matrix.rs::canonicalize_rows_in_place_field` (262-306) | Elimination inner loops use `data[row * cols + j]` indexing, so every element carries a bounds check and the compiler cannot prove non-aliasing between pivot row and target row. No vectorization. | `split_at_mut` to separate the pivot row from the rest, then `chunks_exact_mut(cols)` and `zip` over slice iterators. | Removes the bounds check and the aliasing barrier, which is what blocks vectorization of the `F::sub(x, F::mul(factor, y))` inner loop. Review item 1, rated HIGH, still live. Gain depends on whether `F::mul` inlines to a table lookup; check the generated code before claiming a number. | Medium: `F::mul` may not vectorize, in which case the win is only the bounds checks. Fermi first, per the contract. | Yes | exact matrix parity; A/B counters with instructions per element; inspect generated code as the contract requires when a hot helper misses hardware instructions |
| T6 | `scheduler.rs:2676` canonical support construction | `supports.sort_unstable_by_key(\|support\| (support.len(), support.clone()))` clones the whole support vector on every comparator call. | `sort_unstable_by` with a borrowed `(len, slice)` comparison. | Removes O(n log n) vector clones from compilation. Compile-time, not per-transition, but `PERFORMANCE.md` counts compiler time as end-to-end performance and the cold-wall column is reported. | Very low. | Yes, trivially | exact canonical-support parity; cold wall time on the affected rows |
| T7 | `packed_ternary.rs` | No `sub_mod3` or `neg_mod3`, so the orbit DFS undoes a move with two SWAR additions. | Add the branchless `sub_mod3`/`neg_mod3` companions to `add_mod3`. | One SWAR operation instead of two on the undo path. Review item 6, LOW, still live. Small but the cheapest change in the list. | Very low. | Yes | exact orbit state parity; A/B instruction count |

## Representation reductions (information-theoretic)

`PERFORMANCE.md` already sets the policy: choose representation from measured density and
access pattern, treat Elias-Fano and Roaring as candidates rather than defaults, and give
every compressed representation an exact crossover policy and a replay test. It also forbids
added indirection inside a solve hot loop, so the succinct structures below are admissible at
the certificate, snapshot, and cold-load boundaries, while inside a hot loop only the
allocation-free, indirection-free steps of the grammar (bit-width narrowing, canonical
ordering, flattening to offsets) are admissible.

The "grammar" column asks whether a small typed encoder grammar — bit-width narrowing, delta,
zigzag, varint, Elias-Fano, run-length, canonical permutation, dictionary or hash-consing, and
compositions of these — could express the change, so that an evolve-style search scored by
exact encoded bytes plus measured access cycles, and admitted only on round-trip identity,
could rediscover it unaided.

Ranked by bytes saved times how often the structure is materialized.

| # | structure | now | succinct bound | affects | random access after | grammar | one session |
|---|---|---|---|---|---|---|---|
| R1 | `bp_osd.rs:47-51` parity CSR: `row_offsets`, `edge_bits`, `edge_checks`, `col_offsets`, `col_edges`, all `Vec<usize>` | 8 bytes per element across five arrays; materialized once per decode setup and read on every belief-propagation sweep | Ids are bounded by the code length, so `u32` is a free 2x. The offsets are strictly monotone with near-constant gap `w`, giving Elias-Fano `2 + log2(w)` bits, about 4 bits against 64. A row's sorted edge list of `w` out of `N` columns costs `2 + log2(N/w)` bits, about 18 bits at `N = 2 x 10^5`, `w = 4`. | QC-LDPC headline row (lift 50,000, weight 4, 190x cold, 3.8 MiB RSS) | `u32` narrowing: unchanged, one load. Elias-Fano: a select query, so it adds indirection and is admissible only for the on-disk or snapshot form, not the sweep. | Yes: narrowing is bit-width, offsets are delta plus Elias-Fano, both in the grammar; composition is `narrow . delta` | Yes for the `u32` narrowing; Elias-Fano is a separate boundary-only task |
| R2 | `witness.rs:9-20` `WitnessNode` | 16 bytes: `parent` u32, `coordinate` u32, `inverse_scale` u8, three bytes of padding, `depth` u32. Materialized once per admitted state, up to `max_states = 2^18` per span build | `depth` is exactly `parent.depth + 1`, so it carries zero information and exists only to presize `support`; store the depth once on the answer instead. `coordinate` is bounded by `ambient: u16`. Narrowed record is `{parent: u32, coordinate: u16, inverse_scale: u8, _pad: u8}` = 8 bytes. Entropy bound is `log2(n) + log2(ambient) + 5` bits, about 4 bytes. | vector node span headline row; every span-based witness replay | Unchanged: still one 8-byte load, better cache density, one fewer record per line pair | Yes: bit-width narrowing plus removal of a functionally dependent field, which a round-trip-identity search would find because the field reconstructs exactly | Yes |
| R3 | `scheduler.rs` `canonical_supports: Vec<Vec<Vec<u32>>>` and the per-family `loads: Vec<Vec<u32>>` built at line 2688 | Three levels of `Vec`, so 24 bytes of header per inner list plus a separate allocation each, before any payload | Flatten to one CSR pool with a monotone offset array. Saves the 24-byte header and the allocation per list; the offsets are monotone and delta-codable at the snapshot boundary. | Ceph XOR headline row asks for an entire support family (256 minimal supports); also every scheduler compile | Improves: one contiguous slice, no pointer chasing, which the contract's rule 3 wants anyway | Yes: this is exactly the dictionary-plus-offsets composition, expressible as `flatten . delta` | Yes |
| R4 | `bounded_subset_sum.rs` `reachability` | Already a bit-packed row per item over the compiled width, `(n+1) x ceil(width/64)` words | Rows are monotone-ish reachable sets over a contiguous sum window and are typically dense in the middle and empty at the ends; run-length or a per-row window bound would cut the empty prefix and suffix. The `windows` array already records those bounds and is not used to shrink the bitmap. | L-tier subset-sum rows C1-C8 and their RSS column | Unchanged if the shrink is only a per-row base offset, which is one subtraction | Yes: run-length, or equivalently `window-clip . bitpack` | Yes, but fold it into C1048 rather than landing separately |
| R5 | certificate and snapshot payloads generally (`BoundedSubsetSumCertificate.witness_words`, `ParametricCertificate`, `frozen_shortest_path` id arrays, `continuation` class arrays) | Fixed-width `u32`/`u64` arrays written verbatim | Sorted or near-sorted id arrays delta-code to small gaps and varint to one or two bytes; witness bitmaps at low density are smaller as a delta-varint gap list, with an exact crossover at density `1/(2 + log2(u/n))`. | evidence and certificate file sizes, which the contract requires to stream under bounded limits | Cold boundary only, so indirection is free | Yes, and this is the most grammar-native family: `zigzag . delta . varint` with an Elias-Fano alternative and a measured crossover | Yes for one certificate type; not for all of them at once |
| R6 | `zdd.rs` `UniqueTable` hash-consing | Already applied to ZDD nodes: `buckets` and `links` as `Vec<u32>` with a power-of-two bucket count | The same dictionary step is not applied to repeated substructures elsewhere: `scheduler` option load vectors, `composition.rs` `FxHashMap<Box<[u8]>, _>` keys at lines 80, 449, 1038, 1067, and the interned `feature_dag` ops. `composition.rs` in particular allocates a boxed key per distinct state. | Ceph XOR row already benefits; `composition` was the 2026-08-28 review's leading suspect for the 16-to-24-thread regression | Dictionary lookup is one hash and one indexed load; acceptable outside the innermost transition, not inside it | Yes: hash-consing is a named grammar step, and its round-trip identity is the dictionary inverse | No: `composition.rs` is 1,700 lines and the boxed-key path is threaded through several functions |

**Rediscovery control: R4, the bounded subset-sum reachability bitmap.** It is the right
control for an evolve-style encoder search because all three grading inputs are already exact
and already instrumented. Encoded bytes are a closed form in the compiled width and item
count, so a search's score needs no estimate. Round-trip identity is not a new test: the
existing witness replay walks the bitmap backwards from the target and returns
`InvalidCertificate` on any disagreement, so admission is the kernel's own correctness gate.
Access cycles are measurable inside a loop that already runs in the benchmark tier. And the
answer is known independently — the human-derived encoding is the window-clipped bit-packed
row — so a search that returns something larger, or that returns the same thing by a different
composition, is diagnostic either way. Seed the search from the pre-bitmap `Vec<u64>` form and
require it to rediscover `window-clip . bitpack`; if it cannot recover a 64x narrowing whose
correctness test already exists, the grammar or the scorer is wrong, not the target.

## Do these three first

1. **T1, dense-lattice workspace port.** It is the only item on the list that closes a stated
   violation of the non-negotiable allocation-free solve invariant rather than shaving a
   constant, it affects the dense backend that `solve_adaptive` routes three headline rows
   into, and the entire pattern — workspace struct, epoch-based collision index, `_into`
   keep-vector variant, allocation guard — already exists in the same file for the sparse
   backend. Lowest design risk and highest contract value per session.

2. **M1 plus M2, `dense_pareto_keep` buffer reuse and `u16` prefix array.** These land in the
   same function T1 already opens, they are the largest memory objects the crate allocates
   outside C1048's subset-sum tables, and the prefix-max sweep is a pure streaming pass where
   halving the element width is close to a direct 2x. Doing them in the same session as T1
   means one A/B and one RSS measurement covers all three.

3. **T3, the Repair DAG BFS map merge.** It is a single self-contained function, it targets a
   published headline row with a retained control and an existing benchmark harness, the
   change cannot alter visit order, and the parity check is three scalar fields. It is the
   cheapest way to produce a clean, fully gated performance result if T1 runs long.

T2 is the best fourth pick: it is small, and C1017 already retained `orbit-grid` and
`orbit-meet` binaries, so the A/B control costs nothing to produce.
