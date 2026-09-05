# C1067: the Tiger matcher against the Ergodis performance contract

**Lane**: `complete-ports` · **Date**: 2026-09-05 · **Code**: `~/src/ergodis-private`
**Contract**: `~/src/ergodis-contrib/PERFORMANCE.md` and the shared playbook it names
**Scope**: `src/tiger_blossom.rs`, `src/tiger_blossom_graph.rs`, `src/tiger_blossom_sparse.rs`
**Status**: complete — the contract holds except for the shipped traffic counters, now gated

## Headline

**The matcher holds the contract on everything structural — allocation, iteration, record layout,
run-constant dispatch, bounded exhaustion, `unsafe` — and broke it on one thing: it carried its
per-node traffic counters into the shipped build, where they cost 1.4 to 2.0 per cent of the
matcher's instructions.** They are now behind a cargo feature the production build does not
enable. Two smaller repairs went with it: documentation that still promised a dense matcher which
C1061 probe 28c removed, and a unit test that stopped running on 2026-09-04 because a
neighbouring commit took its attribute.

## What holds

Each of these was checked against the code rather than against its documentation.

**The decode path allocates nothing.** Every `vec!` and `Vec` outside the test modules is inside a
constructor: `Workspace::new`, `SparseMatcher::new`, `KernelSpec::compile`. The permanent gate is
`the_decode_loop_allocates_nothing` in `tiger_blossom.rs`, which runs `decode_batch` at the
routed, full, plain and sparse levels inside an allocation-counting global allocator and asserts
zero. Capacity exhaustion returns through the bounded path — `SparseOutcome::Exhausted` to
`bounded_fallback`, with the shot flagged `overflowed` and counted by cause — and never by
growing a container.

**The search is iterative.** No function in the three files is recursive. The blossom subtree
walk in `touch_region` uses a presized `walk_stack`; `resolve_pairing` descends through the
`task_*` arrays; the certificate's chain walks are loops over `parent_blossom`. Both stacks are
bounded by the region count, which is `2 * max_defects`.

**The hot records are Tiger-style.** `NodeState` 16 bytes, `RegionRate` 8, `EdgeState` 16,
`Incident` 8, and the queue's `Event` 16, each `#[repr(C)]` with a compile-time assertion on both
size and alignment, so a layout regression fails the build. Storage is structure-of-arrays and
contiguous; identifiers are `u16` or `u32` with `NONE` and `BOUNDARY` sentinels; `usize` appears
only at indexing and capacity boundaries. There are no owned dynamic containers, trait objects,
or reference-counted pointers in any hot record, and no pointer chasing in a loop body.

**There is no `unsafe` anywhere in the three files**, and no raw pointer taken for speed.

**Run-constant choices are dispatched outside the loop.** The specialization level and the
graph-specialized relaxation are const generics resolved by the caller
(`decode_at::<LEVEL, SPECIALIZED>`); the certificate's closure table is read through a
monomorphized `pairs_within` chosen once on whether the narrow mirror exists; and C1066 makes the
queue discipline a third such choice, taken when the graph is compiled.

**Exactness does not depend on the matcher being correct.** Every block the sparse matcher
answers is certified by LP duality before its answer is used, and a solve that does not certify
is declined and flagged.

## Findings

### 1. The traffic counters were per-node instrumentation in the shipped build

The contract's Tiger-style rules end with "no per-node instrumentation in production
instantiations". The matcher had six such counters — `stat_touch_node`, `stat_push`,
`stat_edge_time`, `stat_phantom`, `stat_subtree_nodes`, `stat_stale_pops` — plus `last_events`,
each incremented unconditionally in release builds on the hottest paths available: one bump per
node touched, one per event pushed, one per event-time evaluation, one per popped event. On
surface `d = 9` at `p = 0.001` that is about 176 pushes, 207 event-time evaluations and 22 pops
per solved block.

Measured as the shipped build `ergodis-tools-fa21d85` against the retained C1066 build
`ergodis-tools-5a22cbe`, three interleaved rounds at level four with two-size differencing, so
every shot goes to the matcher. Below one is a gain. Instructions, on the weighted
circuit-level grid's operating cells
(`benchmarks/tiger-blossom/2026-09-05-c1067-fa21d85-weighted-level4-ab.log`):

| graph               | `p = 0.0005` | `p = 0.001` | `p = 0.002` |
|---------------------|--------------|-------------|-------------|
| surface `d = 5`     | 0.986        | 0.984       | 0.982       |
| surface `d = 9`     | 0.982        | 0.982       | 0.982       |
| surface `d = 11`    | 0.982        | 0.982       | 0.983       |
| repetition `d = 9`  | 0.998        | 0.993       | 0.989       |
| repetition `d = 15` | 0.992        | 0.988       | 0.986       |
| repetition `d = 25` | 0.987        | 0.986       | 0.988       |

and on the phenomenological grid
(`2026-09-05-c1067-fa21d85-phenomenological-level4-ab.log`): 0.998 to 1.000 at `p = 0.001`,
0.983 to 0.996 at `p = 0.01`, and 0.979 to 0.986 at `p = 0.05`.

The gain tracks how much of a shot is the matcher rather than the closed forms: 1.8 per cent
where the matcher answers nearly everything, nothing on repetition `d = 3`, whose 24-detector
graph almost never reaches it. So the diagnostics cost about 2 per cent of the matcher — more
than the whole of what C1066's queue dispatch is worth, on the model a deployed decoder consumes.

**Repaired.** The counters are now behind the `tiger-traffic` cargo feature, which the shipped
build does not enable. The decline counters (`reason_*`) are per solve rather than per node and
stay live, so nothing that explains an unanswered block is lost. A build without the feature
reports zeros for traffic and events, and both bench lines now say `counters off` so a zero is
never read as a search that did no work; census and traffic runs are built with
`cargo build --release -p ergodis-tools --features tiger-traffic`.

### 2. Stale documentation on the certificate's decline path

`SparseMatcher::certify` said "a solve that fails to certify is declined and answered by the
dense matcher", and two comments in the coverage test said declines "cost speed, not exactness".
The dense matcher was removed in C1061 probe 28c, when blossom expansion made the sparse matcher
complete. A decline now goes to `bounded_fallback` and the shot is flagged `overflowed`, so it
costs accuracy on that shot, not only speed. Repaired in place; no behaviour change.

### 3. A test that stopped running on 2026-09-04

`the_repetition_graph_compiles_to_the_expected_shape` in `tiger_blossom_graph.rs` lost its
`#[test]` attribute in C1064's commit `bc3727d`, which inserted a new test above it and consumed
the attribute, leaving the old function dead. Clippy's `duplicate-macro-attributes` had been
reporting it as a duplicated attribute at the new test ever since, inside the workspace-wide
lint run that also carries ten pre-existing findings in other tools modules, so it went unread.
Repaired in C1066's first commit; the test passes.

## Gates for the counter repair

The debug random suite with the no-late-entry oracle and the feasibility assertion, run in both
feature configurations; the release kernel tests including the zero-allocation `decode_batch`
gate; library clippy `-D warnings` in both configurations; and an exact census parity sweep of a
`tiger-traffic` build against the retained C1065 control over all seventy-three cells — the same
logical error rate, answered and declined counts by cause, and event, push, subtree and stale-pop
traffic on every one — which is what shows the counters were only ever counting.

The A/B tables are in the finding above; the cycle ratios move with them but are noisy on the
small graphs, where a decode is under a hundred instructions.

Retained binaries: `ergodis-tools-5a22cbe` (control, SHA-256 `3837deff…44ab`) and
`ergodis-tools-fa21d85` (candidate, `27c45998…5646`). As in C1065, each was built from a working
tree carrying another task's uncommitted changes under `src/causal_*`, which the manifest records
as dirty; those modules are not on any decode path and the `tiger_blossom*` sources were at the
named commits.

## Also repaired

The evidence manifest `benchmarks/tiger-blossom/SHA256SUMS` had eleven older entries carrying a
repository-root path prefix while the other forty-seven are bare names, so no single working
directory verified them all. Normalized; all fifty-eight now check from the evidence directory.

## Not findings, checked anyway

**The bounded stacks are bounded structurally.** `walk_stack`, `cycle_*` and the `task_*` arrays
are sized at the region count, `2 * max_defects`; the blossom structure is a forest, so each
region is pushed at most once per walk and each becomes the child of at most one blossom, which
puts every one of those loops inside its array. `child_region` and its siblings are sized at
twice that.

**The workspace is dominated by `region_nodes`**, one `u16` per region and detector, which is
338 KiB at surface `d = 11` with sixty-four defects and the reason the whole kernel workspace is
25 MB there. It is the region membership lists, read on every whole-region touch, and nothing
grows during a solve.

**Compilation-time work follows the contract's representation rules**: the closure tables are
compiled only below explicit node limits (`CLOSURE_NODE_LIMIT`, `CLASS_CLOSURE_NODE_LIMIT`), the
narrow closure mirror is chosen by measured element range and read through a monomorphized
reader, and the routing threshold is a compiled constant rather than a per-shot decision.

**Nothing outside the matcher clears graph-sized state per shot**, which is the defect class
C1065 found inside it. The bounded Dijkstra keeps its distance and settled state live across
shots behind an epoch stamp and fills only on the wraparound; the cluster decomposition's clears
are bounded by the block size; the census reset is cold.

**Parallelism is not in scope here**: the matcher is a per-workspace, single-threaded object and
the kernel exposes no shared mutable state, so the contract's contention, false-sharing and
pulse rules have nothing to bind to in these three files.

## Vibe check

Clean result: the structure was already right, and the one real violation was the kind that hides
in plain sight — diagnostics nobody thought of as work, costing more than the optimization task
running beside this one was worth. The two incidental repairs are worth as much as the headline in
the long run: a test had been silently dead for a day, and the reason nobody noticed is that the
workspace lint run carries ten unrelated findings, so its output is not read.

## Next

1. The ten pre-existing clippy findings in the tools crate (`actual_cause_report`,
   `generic_certificate_bench`, `local_commit_bench`, `profile_vocabulary_bench`) are foreign to
   this lane and are why the workspace lint output is unread. Whoever owns them should clear
   them, so `cargo clippy --workspace --all-targets -- -D warnings` becomes a gate again rather
   than a wall of known noise.
2. The same audit against the predecoder and detector-error-model paths, which this task did not
   cover.
