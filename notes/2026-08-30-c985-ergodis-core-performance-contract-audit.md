# C985 Ergodis core performance-contract audit

**Date:** 2026-08-30

**Scope:** every Rust source under `papers/complete-repair-ports/ergodis/src`

**Mode:** read-only source/evidence audit; no Rust source was edited, staged, built,
or committed because another agent owned a live nine-file Rust overlay

## Verdict

The core does not yet satisfy the new performance contract.

The best recent kernels already embody most of the intended design: iterative
fixed-layout search, exact work counters, theorem-driven pruning, compact
records, target specialization, worker-local state, and measured A/B evidence.
That discipline is not uniform across the public API. There are definite
recursive and allocating solve loops, one definite worker-to-worker contention
path, missing Tiger layout gates, private research adapters in the public core,
and no allocator instrumentation that can prove zero allocation.

| Gate | Grade | Audit conclusion |
| --- | ---: | --- |
| Exactness and replay | A- | Strong tests and replay boundaries across the principal kernels |
| Solve-loop zero allocation | D | Definite violations and no allocation-count harness |
| No search recursion | D | Definite recursive search/decision-diagram paths |
| Tiger hot layouts | B | 78 explicit `repr(C)` declarations and 81 size/alignment assertions, but several hot records remain ungated |
| Parallel ownership | C | Good worker-local design in most paths; CSS bound broadcast is a contended worker-write path |
| Single/parallel validation | B- | Good parity tests on selected kernels, not a core-wide gate |
| Counter A/B evidence | C | Excellent retained studies for selected kernels; no systematic harness or per-change enforcement |
| Public/private partition | D | Several task/domain-specific adapters and fixtures remain in public source |

This is a compliance audit against the newly adopted standard, not a claim that
all listed code is slow. Several violations are fast on current fixtures; the
contract deliberately rules out designs that fail at larger depth, state count,
or thread count.

## P0 findings

### 1. Zero allocation is not testable today

No source file defines a guarded counting allocator, allocator counter, or
equivalent allocation-envelope harness. Tests with names such as
`without_hot_loop_allocation` inspect outcomes, and the Hall test checks that
three workspace pointers do not change. Neither detects a hidden allocation in
a helper, a temporary allocation/deallocation, or a container growth that does
not move the checked pointer.

Required gate: a test-only thread-local allocation guard that is armed only
after setup, executes the real kernel repeatedly, and fails on any allocation,
reallocation, or deallocation. Every public solve kernel needs a named test
through that guard.

### 2. Definite recursive or allocating solve paths

- `applications.rs:1313` implements `search_trapping_sets` recursively. The
  caller starts `selected` as `vec![anchor]`, so deeper `push` operations grow
  it during search. `minimum_node_span_repair` stores boxed data in each
  `NodeSpanState`, clones the entire state set per node, and allocates new basis
  and witness vectors inside its transition loop (`applications.rs:1425` and
  `applications.rs:1490`).
- `balanced.rs:1883` recursively calls `search_node`. Its fixed arrays avoid
  heap growth, but call-stack search is forbidden. This module is also a
  private fixed-`q=27` adapter and should not be repaired in public core.
- `orbit.rs:386`, `orbit.rs:457`, and `orbit.rs:704` contain three recursive
  enumeration/search kernels. Ordinary inputs deliberately select the
  recursive implementation near `orbit.rs:982`. `DeadMemo::insert` grows an
  `FxHashMap` and two vectors at rejected nodes, so both the recursive and
  iterative traversal variants allocate during search.
- `zdd.rs:565`, `zdd.rs:602`, and `zdd.rs:642` recursively traverse the
  decision diagram. `UniqueTable::intern` can call `grow` from the node loop,
  resizing and rehashing its table. Memo tables and the explicit union stack
  can also grow after solve entry.
- the sparse scheduler path beginning at `scheduler.rs:536` constructs and
  grows state vectors, witness vectors, load pools, touched lists, and hash
  tables inside demand/state/option loops. Reusable dense workspaces do not
  cover the public sparse/adaptive path.
- `ordered_resource.rs:855` allocates the live-front hierarchy, retained
  fronts, per-sort vectors, and one boxed front per class during evaluation.
  Its reusable workspace covers only the accumulator, not the solve state.

These are structural failures, not merely missing evidence.

### 3. CSS parallel search contains worker contention

`css_distance.rs:2641` broadcasts every improved bound by performing
`fetch_min` on every worker mailbox. Multiple search workers therefore write
the same mailboxes. Alignment prevents false sharing between mailboxes but does
not remove atomic-line contention or the worker-to-worker write path.

The worker partition entry at `css_distance.rs:1403` also allocates a frame
workspace per Rayon task rather than creating one presized workspace per
worker. The allocation is before that task's DFS loop, but it occurs
concurrently during the solve and can contend in the allocator.

The pulse test at `css_distance.rs:1462` includes a run-constant
`pulse_interval != 0` branch in the candidate loop. Disabled and enabled pulse
kernels need outside-loop dispatch or monomorphization.

Required shape: workers publish an improvement only to a noncontended local
slot; one non-search broadcaster or bounded reduction stage fans out verified
bounds. Worker workspaces are created once with `map_init` or an equivalent
stable worker owner. Disabled pulse code is absent from the generated hot
kernel.

### 4. Public/private partition is presently violated

The following source is not domain-neutral reusable core:

- `alignment.rs`: aligned-attachment research adapter;
- `balanced.rs`: fixed `GF(27)` balanced-branch front end;
- `defect.rs`: fixed `q=27`, defect-19 open-branch search;
- current untracked `hadamard.rs`: cyclic Goethals--Seidel adapter; the generic
  `character_sum.rs` primitive is the reusable core;
- current untracked `control/proof.rs`: a generic proof role mixed with a
  Goethals--Seidel-specific theorem schema.

The public library currently exports alignment and fixed-domain modules. Move
their adapters, binaries, fixtures, and theorem schemas to `ergodis-private/`.
Promote only generic kernels such as character sums, bounded proof-role
interfaces, worker-local execution, and reusable packed arithmetic.

Private task identifiers also remain in public tests:

- `integer_moments.rs:309` names a C1000 stage;
- `hall.rs:583`, `hall.rs:610`, and `hall.rs:672` name C80 and embed private
  projective campaign fixtures.

Generic Hall and moment regressions may stay only after neutral renaming and
replacement with public mathematical fixture descriptions; campaign-specific
fixtures belong in `ergodis-private/`.

## P1 findings

### 5. Tiger layout holes

The following frequently traversed records lack explicit representation and
compile-time size/alignment gates:

- `alignment.rs:791` `SearchFrame`;
- `css_distance.rs:2588` `WideBranchFrame`;
- `observational.rs:6790` `SeparatorSearchNode`;
- `selector.rs:62` `SparseTerm`;
- `css_distance.rs:2529` `RootBranch` and `css_distance.rs:2564`
  `WideRootBranch`.

`applications.rs:1425` `NodeSpanState` is more serious: it is a hot state
record containing two boxes, so adding `repr(C)` would not repair its pointer
chasing or per-transition ownership.

The cache-padded CSS result records and `BoundMailbox` assert alignment but not
size. The contract requires both, for every instantiated hot layout. Generic
wide frames need assertions for every supported support/check-word
specialization.

### 6. The performance gate is not automated or discoverable enough

The public scripts contain many timing A/B harnesses, but no retained script
runs an A/B `perf stat` counter protocol. No source/evidence artifact maps every
hot kernel to:

1. its zero-allocation test;
2. one-thread correctness/work-count control;
3. parallel correctness/work-count control;
4. single-thread counter A/B;
5. parallel counter A/B; and
6. false-sharing/contention evidence where applicable.

Selected C985 records supply excellent manual evidence for CSS distance,
observational minimization, completion compilation, residual hitting, and
parallel roots. Other public solve paths have wall/RSS measurements or ordinary
unit tests only. The new rule needs a machine-readable kernel registry and a
single guarded audit command; prose discipline alone will drift.

### 7. Recursive cold paths still have scaling risk

`composition.rs:903` recursively replays a witness tree, while the adjacent
owned-witness expansion recursively allocates child boxes. These are not solve
hot loops, so they do not violate the narrow zero-allocation invariant, but
composition depth is input-controlled and can exhaust the call stack. Replace
them with the same presized iterative path used by the streaming replay API, or
enforce and test a hard public depth bound.

## Module census

All 56 Rust files were included in the source census.

### Definite solve-contract failures

`alignment`, `applications`, `balanced`, `css_distance` parallel pulse,
`orbit`, `ordered_resource`, `scheduler` sparse/adaptive, and `zdd`.

### Strong source shape, but missing the universal allocation/counter gate

`character_sum`, `commutant`, `control/vm`, `hall`, `integer_moments`,
`residual_hitting`, `root_execution`, and `selector`. `selector` additionally
has the `SparseTerm` layout hole. `root_execution` is the cleanest parallel
ownership model: immutable roots plus `map_init` worker state and associative
reduction.

### Compiler/evaluator modules with no definite solve-loop violation found

`automata`, `composition`, `confinement`, `contextual`, `continuation`,
`family_response`, `group_action`, `interface`, `observational`,
`orbit_compile`, `semantic_symmetry`, `span`, and `transfer`.

This is not a blanket performance pass. Compilation may allocate, but must
still meet its measured memory and end-to-end contract. `observational` has the
strongest retained compiler evidence and one hot-record layout hole;
`composition` has the cold recursive replay risk and allocation-heavy parallel
hash-map compilation.

### Foundational/cold-boundary modules

`arena`, `bitset`, `field`, `incidence`, `matrix`, `packed_ternary`,
`projective`, `provenance`, `rpc`, `sat`, and `witness`. Their I/O and owned
allocation are outside search entry points in the inspected paths. Hot records
inside these modules still require Tiger gates when consumed by a solver.

### Optional control and theorem-evolution modules

`control/client`, `control/mod`, `control/synthesis`, `theorem_search`, and the
current `control/proof` overlay. Socket, JSON, ledger, and evolution work is
cold/daemon-side as designed. `control/proof` currently violates the public
boundary. The live overlay was not treated as stable enough for a correctness
verdict.

### Binaries

`bench_kernels`, `css_distance_native`, `css_distance_random`,
`ergodis_campaign`, `ergodisctl`, `ergodis_rpc`, and `ergodis` keep parsing and
serialization outside the inspected library search loops. Their thread/setup
choices do not repair library violations. CLI I/O was not classified as a hot
allocation failure.

## Ordered remediation

1. Land the test-only allocation guard and a kernel registry. Do not claim
   compliance from source inspection.
2. Remove private adapters and fixtures from public core before optimizing
   them; this prevents doing expensive public API surgery twice.
3. Replace recursive and growing public solve paths, starting with ZDD,
   applications trapping/node-span, orbit memo search, sparse scheduler, and
   ordered-resource evaluation.
4. Replace CSS worker broadcast with a contention-free publication topology,
   make workspaces worker-owned, and split pulse/no-pulse kernels.
5. Close all Tiger layout assertions, then run one- and parallel-mode counter
   A/B on each changed kernel.
6. Add a guarded `perf` audit harness and machine-readable evidence ledger.
   A core hot-loop change should be mechanically unable to pass without its
   allocation, layout, single-thread, parallel, counter, and contention rows.

## Validation boundary

This audit used committed source plus the visible dirty overlay and exact
source-line inspection. It did not run Cargo because another agent was actively
repairing the Rust files and the user prohibited committing that work. Dynamic
format, clippy, test, allocation, counter, and contention gates remain required
after that overlay stabilizes.
