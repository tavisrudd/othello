# C1177 — private kernel follow-ups

**Lane**: `ergodis`
**Date**: 2026-09-13
**Repository**: private `~/src/ergodis-private` (branch `main`, base `9cdc124`, tip `051f734`;
developed on `task/c1177-kernels` in a paired worktree with core detached at `2074025`, both
worktrees removed after the fast-forward). Core untouched.

Closes review items R15, R16, E5 and E6 and the three C1177 property rows of
`notes/2026-09-12-c1171-rule-programme-review.md`.

## Status

Complete. Private commits, oldest first:

| Commit    | Contents                                                                                   |
| --------- | ------------------------------------------------------------------------------------------ |
| `272abe9` | `proptest` dev-dependency for the private root and `packages/scheduling-provider`          |
| `527b434` | `tests/privacy_properties.rs`                                                              |
| `9447838` | sparse-frame dispatch assertion, frame property test, 10^5–10^6 detector measurement       |
| `051f734` | allocation domain: construction-time workers, single table enum, count-axis measurement, Domain parity property test |

All work was drafted by Opus sub-agents and re-verified here: every diff re-read, every gate
re-run (`rustfmt --check` on changed files, `cargo clippy -D warnings` on the affected targets in
both feature configurations, the affected test targets, sibling provider `cargo check`).

## R15 / E5 — sparse frame selection

- `Plan::sparse_frame_dispatch(&self, &Workspace) -> bool` is now the single definition of the
  dispatch predicate (`syndrome words > 2 × radius × max column degree`); `search_impl` calls it.
  The existing 80-source parity test asserts the dense plan takes the bitmap branch and the
  expanded plan the sparse branch at every radius; no fixture change was needed.
- Property test `sparse_and_bitmap_frames_agree_with_min_degree_then_min_id_spec` (512 cases,
  in-module): random supports with a random selected prefix, both monomorphized frame scans
  equal an independent minimum-(degree, id) specification over the odd detectors.
  Mutation-checked: removing the sparse tie-break fails it.
- Measurement, `#[ignore]` test `sparse_frame_large_detector_measurement` through a
  `#[doc(hidden)]` benchmark-only `search_indexed_with_frame_policy`; production dispatch is
  unchanged. Deterministic chain source (data faults `{i,i+1}`, hook faults `{i,i+1,i+2}`, max
  column degree 3), single thread, release, five alternating rounds, exact
  `(status, candidates, roots, witness)` parity asserted per configuration.

  | Detectors | Radius | Bitmap median | Sparse median | Bitmap / sparse |
  | --------: | -----: | ------------: | ------------: | --------------: |
  |   100,000 |      3 |      74.57 ms |      12.15 ms |            6.1× |
  |   100,000 |      4 |     140.73 ms |      23.12 ms |            6.1× |
  |   100,000 |      5 |     241.28 ms |      21.04 ms |           11.5× |
  | 1,000,000 |      3 |    1610.11 ms |     123.63 ms |           13.0× |
  | 1,000,000 |      4 |    1805.97 ms |     114.97 ms |           15.7× |
  | 1,000,000 |      5 |    2832.05 ms |      68.79 ms |           41.2× |

  The 4–5% figure of `2026-09-12-sparse-frame-selection.md` was the portable provider's
  4,096-detector admission ceiling, as E5 predicted. The external "60M → 12M" figure is still
  not attributed: no input, radius or timing boundary exists for it. Report:
  private `analysis/external-benchmarks/2026-09-13-sparse-frame-large-detectors.md` and
  `c1177-sparse-frame-large.json`.

## R16 / E6 — allocation domain

- `Domain::parallel_workers()` returns a value stored at construction (workers the scratch was
  sized for, 1 for serial tables); the retained telemetry no longer depends on the reading thread.
- `Table` is one enum whose variants own their optional scratch
  (`Budget { surface, scratch: Option<…<u16>> }`, `Count { surface, scratch: Option<…<u64>> }`);
  the separate `ParallelTable` and the `unreachable!` on the C-ABI advance path are gone. Public
  `Domain` API, layout strings, workspace-byte accounting and zero-allocation discipline unchanged;
  the non-`parallel-tables` build is clean.
- Count-axis parallelism was made constructible and then measured rather than assumed. Paired
  serial vs four-worker construction inside one warm pool, seven alternating rounds, release, six
  multi-tile count/resource shapes (9,207–69,673 cells; the three sources of the 2026-09-10
  count-axis report reproduce its transition counts exactly at 2× capacities). Every shape lost,
  serial/parallel median ratio 0.81–0.95, loss growing with tile count. Decision: count tables stay
  serial. The gate is a shape predicate (`COUNT_PARALLEL_MIN_CELLS` = 2,000,000, the count-layout
  cell ceiling), so the count scratch arm is type-constructible but unreachable under the shipped
  `ParallelPolicy::Measured`. `Domain::with_policy` with `TiledCount`/`Serial` exists for the
  measurement only. Report: private `analysis/interface-review/2026-09-13-count-axis-parallel.md`
  and `.json`.
- Property test `parallel_advancement_matches_serial` (`parallel-tables`, 64 cases): serial
  (1-thread pool) vs 2- and 8-thread pools, equal transitions/jobs/layout, equal answers and
  witnesses over random capacity vectors; a deterministic 19,881-cell case must take the scratch,
  and the run fails if no generated case takes the parallel branch (about half do). Plus
  `parallel_advancement_is_allocation_free` under a warmed four-thread pool.
- Generator deviations, both forced: the literal spec (≤3 resources, maxima ≤48, ≤12 jobs) cannot
  exceed 2,401 cells, so a wide arm was added; a freely varying third resource is rejected by
  `recognize`, so demands beyond index 1 are fixed at one unit.

## Privacy property tests

`tests/privacy_properties.rs`, four tests, 0.1 s: `joint_span` is a subgroup (exhaustive over
256 sources, against an independent XOR-closure oracle, plus monotonicity over all pairs); the
joint lowering is a congruence at all depths (exhaustive one-step sweep of 524,288 triples with the
cell count pinned at 274,688, plus 1,024 random event words of length ≤12 checked after every
prefix); the leakage-only quotient is not a congruence (2,208 ordered witnesses, including the
committed obstruction `(16, 0, 5)`); the committed `joint.lowering` agrees with the live code.

## Foreign issues, not fixed

- `cargo clippy -p ergodis-private --all-targets -D warnings` fails at private `main` in the
  `williamson_parallel_profile` test target: four dead-code errors in `src/williamson_search.rs`,
  `src/additive_equality_index.rs`, `src/additive_pair_join.rs` (unmodified by C1177).
- Workspace-wide `cargo fmt --check` reports pre-existing diffs in `src/hadamard_execution.rs`
  and `src/partitioned_additive_join.rs`.
- The private checkout still carries the C1170/C1130 owner's uncommitted
  `analysis/campaign-console/mockups/*` and `analysis/interface-review/*thread*` edits; the
  fast-forward to `051f734` did not touch them.

## Mystery ledger

- **Count-axis parallel loss grows with tiles.** Explained by shape: a count layer's transition work
  is bounded by surviving jobs, while the owner's merge copies every `u64` cell back, so more tiles
  add merge cost faster than they divide work. Settled as policy; the lever, if ever wanted, is a
  merge-free tile write into the next layer, logged to the discovery track. No open gap.
- **Sparse-frame ratio grows with radius.** Explained: frames per candidate grow with radius while
  the sparse scan stays bounded by radius × degree. No open gap.
- **External 60M → 12M.** Not a mystery of this code; unattributable without the external input.
  Owner: C1143 if that input ever arrives.
