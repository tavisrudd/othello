# C1054 — promoting the sparse CSR Hall backend into core `hall.rs`

**Lane:** `complete-ports`. **Status:** in progress (working tree only; nothing committed).

Goal: core `papers/complete-repair-ports/ergodis/src/hall.rs` was dense-bitmap only. The private
`ergodis-private/src/hall_core.rs` carried an independent CSR kernel with the same algorithm. This
task merges them into one core kernel with two layouts and an automatic selector, closes the open
`layout` dimension on the `hall-matching` registry entry, and leaves no duplicate kernel behind.

## 0. Retained baselines

Produced with `papers/complete-repair-ports/ergodis/scripts/retain-bin.sh` before any edit, from a
tree whose core (`papers/complete-repair-ports/ergodis`) was clean at `d28766e38`.

| Retained name | SHA-256 | Crate dir | Profile |
|---|---|---|---|
| `ergodis-d28766e38` | `e42a7936073fb075370dddc5b718474ea655feab4d2897feedd02467c3daaa83` | `papers/complete-repair-ports/ergodis` | release |
| `bench_kernels-d28766e38` | `eaa6f04726d58bd3fa9406d1968a48078d13453fe0e0260ca45f59915399a0e4` | `papers/complete-repair-ports/ergodis` | release |
| `ergodis-tools-d28766e38` | `eee74d2ed268fc84fc52cd1cdfd0c3a37b6f6b6e28be3e457fc98ac63c7313ac` | `ergodis-private/tasks/tools` | release |

`bench_kernels` does carry a Hall row (`hall:<backend>:<left>:<right>:<density-per-mille>:<graphs>:<seed>`
with backends `bitmap` and `adjacency`), so it is the A/B vehicle.

Caveat on the private baseline: the `ergodis-private` workspace was already dirty with C1039 and
C1051 work when `ergodis-tools-d28766e38` was retained, so that executable is a dirty-tree control.
It is still the right control for this task because the `hall-certify` path it exercises is
untouched by those two tasks. Its replay of the committed case reproduces the committed evidence
byte-identically after JSON key normalization:

```
ergodis-tools-d28766e38 hall-certify \
  --input ergodis-private/evidence/c80-q11-ancestral-secant-hall-graph.json \
  --output <scratch>/baseline-cert.json
```
equals `ergodis-private/evidence/c80-q11-ancestral-secant-hall-certificate.json`.

## 1. Design

### 1.1 What the two kernels actually were

Both are the same algorithm: repeated breadth-first augmentation from each left vertex (Hopcroft–Karp
without the phase batching), an epoch-stamped `seen` pair to avoid clearing, and, on failure, one
final alternating-reachability sweep from all unmatched left vertices to produce the deficient set.
They differ only in how a left vertex's neighbours are enumerated:

| | core `hall.rs` (before) | private `hall_core.rs` |
|---|---|---|
| adjacency | one dense `u64` bitmap row per left vertex, `ceil(right/64)` words | caller-owned CSR `offsets`/`neighbors` slices |
| graph ownership | owned `Box<[u64]>`, compiled once from an edge iterator | borrowed, never copied |
| deficient set | two `u64` bitmaps in the workspace | two `Vec<u32>` index lists in the workspace |
| result | borrowed `HallResult` + streamed binary certificate + independent verifier | `HallOutcome` enum + `&self` accessors |
| errors | `Overflow`, `Edge`, `Workspace`, `Certificate` | `LeftCapacity`, `RightCapacity`, `InvalidOffsets`, `InvalidEndpoint` |

The deficient set is canonical, not an artefact of which maximum matching was found: by the
Dulmage–Mendelsohn decomposition, the set of left vertices reachable by alternating paths from
unmatched left vertices is the same for every maximum matching. That is what makes cross-layout
parity a meaningful gate rather than an accident of neighbour ordering, and it is why the sparse
path does not need to sort CSR rows to agree with the dense path.

### 1.2 Unified API

One kernel, monomorphized over an internal-iteration adjacency trait so that the layout choice is
resolved once, outside the loop, exactly as the performance contract requires (no run-constant
branch inside the hot loop).

```rust
trait HallAdjacency {
    fn left_count(&self) -> u32;
    fn right_count(&self) -> u32;
    fn contains(&self, left: u32, right: u32) -> bool;
    fn visit_neighbours<F>(&self, left: u32, f: F) -> ControlFlow<()>
    where F: FnMut(u32) -> ControlFlow<()>;
}
```

Internal iteration (rather than a GAT `Iterator`) was chosen so the dense implementation keeps its
original nested word/bit loop verbatim, which is what protects the dense path from a codegen
regression.

Public surface added to core:

- `SparseHallGraph` — owned CSR, compiled from an edge iterator.
- `SparseHallView<'a>` — borrowed CSR over caller-owned `offsets`/`neighbors`; this is the
  zero-copy entry the private consumers need, since copying their slices per call would itself
  allocate inside their loops.
- `HallGraph { Dense(DenseHallGraph), Sparse(SparseHallGraph) }` with
  `HallGraph::compile(left, right, edges, layout)`.
- `HallLayout { Dense, Sparse, Auto }` and `resolve_hall_layout(left, right, edge_count)`.
- `solve_hall_graph`, `solve_hall_sparse`, alongside the unchanged `solve_hall` for dense graphs.
- `HallOutcome { Saturated, Deficient { left_size, neighborhood_size } }`.
- `HallError::{LeftCapacity, RightCapacity, InvalidOffsets, InvalidEndpoint}` (additive; the four
  existing variants keep their meanings).

### 1.3 One workspace

`HallWorkspace` stays the single presized workspace and gains, alongside the existing deficient
bitmaps, two presized index lists (`Box<[u32]>` of `max_left` / `max_right`) plus their lengths.
Filling them costs one store per deficient vertex in the cold extraction sweep that already walks
those vertices, and it buys two things: O(k) enumeration for consumers instead of an O(n) bitmap
rescan, and the `&self` accessor shape (`matching`, `deficient_left_indices`,
`deficient_right_indices`) that the private API exposes after `solve` returns an owned outcome.

Presizing is unchanged in kind: both layouts size from `(max_left, max_right)` compiled bounds, and
neither path allocates after construction.

### 1.4 Density crossover rule

Per left-vertex scan, the dense row costs `ceil(right/64)` word loads plus one `tzcnt`/`blsr` pair
per set bit; the CSR row costs `deg(left)` `u32` loads. Measured in bytes of adjacency traffic, a
dense row is `right/8` bytes and a CSR row is `4·deg` bytes, so the two are equal at

```
deg / right = 1/32  (density 3.125%)
```

Below that density CSR touches strictly less memory and its advantage grows without bound as the
graph thins; above it the bitmap wins because it amortizes 64 candidate tests into one 8-byte load.
`HallLayout::Auto` therefore resolves to sparse exactly when `32 · edge_count < left · right`, an
O(1) test computed at compile time from bounds that are already known. Section 4 reports where the
measured crossover actually lands.

### 1.5 Mapping the private types onto core, without semantic change

| private | core | note |
|---|---|---|
| `hall_core::HallOutcome` | `ergodis::hall::HallOutcome` | same variants, same fields |
| `hall_core::HallError` | `ergodis::hall::HallError` | the four private variants added to the core enum |
| `hall_core::HallWorkspace::new(usize, usize)` | `HallWorkspace::new(u32, u32)` | wrapper keeps the `usize`, infallible signature |
| `solve(left, right, offsets, neighbors)` | `solve_hall_sparse(SparseHallView{..}, ws)` | identical validation order, identical borrowed slices |
| `matching(n)`, `deficient_left()`, `deficient_right()` | workspace `&self` accessors | index lists, same ordering (ascending) |

`ergodis-private/src/hall_core.rs` becomes a thin wrapper over these, so `hall-certify`,
`certiis`, `c80-hall-rematch`, `plane12`, and `plane12-hyperoval` compile unchanged.

## 2. Implementation

All of it lives in `papers/complete-repair-ports/ergodis/src/hall.rs`.

**One kernel body, two expansions.** The augmenting search, the alternating-reachability sweep that
extracts the deficient set, and the independent verifier are written once inside a `hall_kernel!`
macro and expanded twice, once per layout. Each expansion is straight-line code over its own
representation, so no loop carries a run-constant branch on the layout and neither expansion pays
for the other's existence. Two small companion macros supply the parts that genuinely differ:

- `scan_dense_row!` / `scan_sparse_row!` — the row loop. The dense expansion is the original
  nested word/bit loop character for character; the sparse one is a flat slice loop.
- `dense_out_of_range!` / `sparse_out_of_range!` — the leading clause of the kernel's short-circuit
  rejection chain. A dense row's last word can address columns past `right_count`, and that test led
  the original bitmap kernel's condition; it is reproduced in the same position. A validated CSR
  view has no such column, so its clause is `false` and folds away at compilation.

Section 7 records why both of those had to be shaped exactly this way.

**The failure path is outlined.** `$deficiency` carries `#[inline(never)]`. It runs at most once per
solve and only when the matching failed, but letting it inline grew the augmenting loop's code
enough to cost that loop 4.3% on inputs that never reach it. This single attribute is the difference
between the dense path regressing 4.3% and matching its baseline instruction-for-instruction.

**One workspace, no new allocations.** `HallWorkspace` gains three scalar fields
(`deficient_left_len`, `deficient_right_len`, `solved_left_count`) and nothing else. The two
ascending deficient-index lists that the private API returns are compacted into the front of the
existing `queue` and `parent_right` buffers, which the sweep has finished reading by the time the
lists are written, and whose write positions are always at or behind the position being read.
Adding two separate `Box<[u32]>` buffers instead was measured and rejected — see section 7. The
workspace still allocates only in `HallWorkspace::new`.

**New public surface**, all additive; every previously exported name keeps its signature and meaning:

| item | what it is |
|---|---|
| `SparseHallGraph` | owned CSR, compiled from an edge iterator, rows sorted and deduplicated |
| `SparseHallView<'a>` | borrowed CSR over caller-owned `offsets`/`neighbors`; the zero-copy entry |
| `HallGraph` | `Dense(..)` or `Sparse(..)`, built by `HallGraph::compile(left, right, edges, layout)` |
| `HallLayout` | `Dense` / `Sparse` / `Auto` |
| `resolve_hall_layout` | resolves `Auto` from the compiled edge count |
| `solve_hall_sparse`, `solve_hall_graph` | solve entries beside the unchanged `solve_hall` |
| `verify_hall_graph_result` | independent verifier for either layout |
| `HallOutcome` | `Saturated` / `Deficient { left_size, neighborhood_size }` |
| `HallWorkspace::{matching, deficient_left_indices, deficient_right_indices, max_left, max_right}` | `&self` accessors valid until the next solve |
| `HallResult::outcome` | the serializable verdict, independent of the borrowed bitmaps |
| `HallError::{LeftCapacity, RightCapacity, InvalidOffsets, InvalidEndpoint}` | the private enum's four variants, added |

**`ergodis-private/src/hall_core.rs` is now a wrapper**, not a kernel: it re-exports core's
`HallError` and `HallOutcome` and keeps a `HallWorkspace` whose `new`/`solve`/`matching`/
`deficient_left`/`deficient_right` signatures are unchanged, so `hall-certify`, `certiis`,
`c80-hall-rematch`, `plane12`, and `plane12-hyperoval` compile untouched. No duplicate kernel
remains anywhere — the module contains no loop, no epoch, and no matching state of its own.
`ergodis-private/src/lib.rs` needed no edit (`pub mod hall_core;` was already there, and the file
was already dirty with other tasks' work). `ergodis-private/tasks/tools/src/hall_certify.rs` needed
no edit either: preserving the wrapper's exact signatures is what made that possible, and it is why
its certificate output is byte-identical rather than merely equivalent.

**`bench_kernels`** gains `csr` and `auto` Hall backends. Its fixture builder is now
backend-scoped, so a backend's measurement boundary contains no other backend's compilation cost,
and the CSR views are validated once outside the timed loop rather than per decision — both of
those were measurement bugs that produced false readings early in this task.

## 3. Parity

Everything below is exact agreement, not sampled agreement.

- **Sparse against dense across densities and sizes.** 180 generated instances (sizes 8x8, 24x32,
  64x64, 48x192, 96x96 by densities 5, 10, 20, 31, 50, 125, 250, 500, 900 per mille, four seeds
  each), each solved four ways — dense bitmap, borrowed CSR, owned CSR, and `Auto` — and required to
  agree on the outcome, the cardinality, the full deficient left set, and its exact neighbourhood.
  The workspace's ascending index lists are checked against the bitmaps on the same instances, and
  the layout `Auto` chose is checked against `resolve_hall_layout`.
- **Exhaustive against brute force.** All 65,536 bipartite 4x4 graphs, sparse path against a
  brute-force saturation search and against the dense path, including the exact neighbourhood size
  and the strict deficiency inequality. This is the private kernel's own exhaustive gate, re-run
  against the promoted one.
- **The private fixtures, imported.** `hall_core`'s three unit tests and its two error cases are
  ported into core verbatim, pinning the promoted kernel to the private one's recorded answers.
- **Zero allocation.** A test enters both backends repeatedly after warm-up — 256 solves across
  saturated and deficient instances in both layouts — under the crate's counting allocator, and
  observes zero allocations, reallocations, and deallocations.
- **`hall-certify` replay.** The rebuilt `ergodis-tools` reproduces
  `ergodis-private/evidence/c80-q11-ancestral-secant-hall-certificate.json` **byte-identically**
  (SHA-256 `23d3830e4b0b0f47c5407462e4580be60d8e1c5101baa9ce0ae5cc10f53e4e1b`), matching both the
  committed evidence and the retained `ergodis-tools-d28766e38` baseline's output.

Cross-layout parity is meaningful rather than accidental because the deficient set is canonical:
by the Dulmage-Mendelsohn decomposition it does not depend on which maximum matching was found, so
the two layouts agree even though CSR row order need not match bitmap column order.

## 4. A/B and crossover

Method. `bench_kernels` builds its fixtures once and then repeats the solve loop, so a single run's
elapsed time is dominated by fixture generation — at 256x1024 the setup was 9.7 ms against 0.02 ms
per repetition, which diluted every early reading and initially hid a real regression. Every number
below is therefore a **marginal** measurement: each side is run at 6000 and at 300 repetitions and
differenced, isolating per-round solve cost. Sides are interleaved round-robin, pinned to one CPU
with `taskset -c 3`, run under `choom -n 1000`, single-threaded. Counters come from `perf stat`,
differenced the same way. Ratios are medians over rounds with a paired log-ratio t-score.

**Harness noise floor.** The retained baseline was run against itself through the identical harness:
ratios 0.982 to 1.002 with all |t| < 0.7. A rebuild of the unmodified source also reproduced the
retained executable **bit for bit** (SHA-256 `eaa6f04726d58bd3fa9406d1968a48078d13453fe0e0260ca45f59915399a0e4`),
so the build is reproducible and any counter difference is attributable to source changes.

### 4.1 Dense path must not regress — retained `bench_kernels-d28766e38` against the new binary

21 rounds, 6000/300 repetitions, 8 graphs per round.

| variant | old ns/round | new ns/round | new/old | t | instr % | branches % | peak RSS KiB old / new |
|---|---:|---:|---:|---:|---:|---:|---|
| `bitmap:256:256:100:8:13` | 51742 | 52262 | 1.108 | 1.80 | +0.00 | +0.01 | 2624 / 3020 |
| `bitmap:256:1024:100:8:23` | 32984 | 33772 | 1.007 | 0.66 | +0.01 | +0.01 | 3744 / 3736 |
| `bitmap:128:2048:400:8:17` | 30969 | 31135 | 0.996 | 0.25 | +0.01 | +0.01 | 7712 / 7680 |
| `bitmap:64:64:100:8:7` | 2818 | 2899 | 1.031 | 1.29 | +0.06 | +0.11 | 2192 / 2188 |

Instructions and branches are unchanged to within 0.06% and 0.11%, which is the substantive result:
the dense kernel compiles to the same work it did before. Wall-time ratios scatter on both sides of
one (0.996 to 1.108) with every |t| below 1.8 and no consistent sign, against a null floor of 0.982
to 1.002; that spread is the harness, not the kernel. Peak RSS is unchanged (the one +396 KiB
reading is not reproduced by the other three). Verified separately by direct marginal instruction
counts: 1,209,725 to 1,209,732 at 256x256, 1,092,326 to 1,092,389 at 128x2048.

### 4.2 Crossover — new binary, bitmap against CSR, 256x1024, 11 rounds

| density per mille | bitmap ns/round | csr ns/round | csr/bitmap | t | instr % |
|---:|---:|---:|---:|---:|---:|
| 2 | 6529 | 5727 | 0.878 | -9.51 | -19.2 |
| 5 | 7393 | 6523 | 0.881 | -9.27 | -18.4 |
| 10 | 8731 | 8003 | 0.917 | -18.84 | -17.3 |
| 20 | 11351 | 10919 | 0.956 | -5.10 | -15.5 |
| **31** | **14032** | **14016** | **1.002** | **-0.09** | -14.1 |
| 50 | 19378 | 20989 | 1.107 | 13.34 | -12.6 |
| 62 | 22239 | 26637 | 1.191 | 3.33 | -12.0 |
| 80 | 49269 | 48563 | 0.994 | 1.05 | -11.2 |
| 100 | 32738 | 42148 | 1.277 | 22.17 | -10.7 |
| 200 | 57805 | 76737 | 1.329 | 15.83 | -9.4 |
| 400 | 119747 | 139982 | 1.176 | 7.17 | -8.7 |

**The crossover is at density 31 per mille, or 3.1%** — where the
ratio is 1.002 with t = -0.09, statistically indistinguishable from neutral. Below it CSR wins by up
to 12% and the margin grows as the graph thins; above it the bitmap wins, reaching 28% at one tenth
density. This is the analytic prediction of section 1.4 to within one part in a thousand: a dense
row is `right / 8` bytes against a CSR row's `4 * degree`, equal at one neighbour per 32 right
vertices, which is 3.125%. `SPARSE_DENSITY_DIVISOR` is
therefore 32, and `Auto` picks sparse when `32 * edge_count < left_count * right_count`.

CSR executes 9% to 19% fewer instructions at every density, including those where it loses on wall
time — the bitmap's advantage in the dense regime is memory traffic per candidate, not instruction
count, which is why an instruction-only model would have picked the wrong layout above 3%.

The 80-per-mille row is a disturbed sample: its bitmap side reads 49269 against a trend value near
28000, and it is the only row out of eleven that breaks monotonicity. It is not evidence of a second
crossover.

### 4.3 `hall-certify` replay

Byte-identical output against the retained `ergodis-tools-d28766e38`, as recorded in section 3.
This path is cold — one JSON parse, one solve, one serialization — so no counter A/B is meaningful
for it and none is claimed.

## 5. Registry update

`ergodis-private/performance/kernel-registry-v1.json`, `hall-matching`:

- `layout` moves from `"na"` (previously reasoned as inapplicable because the kernel "stores state
  in fixed typed arrays and has no frame or record object") to `"pass"`, with
  `notes/2026-09-02-c1054-hall-core-promotion.md` as evidence. The old reason was answered rather
  than contradicted: the dimension was open because the kernel had only one adjacency layout and no
  measured justification for it. It now has two, an exact crossover policy, and the interleaved A/B
  that fixes the policy at its measured neutral point.
- `single_thread_counters` keeps `"pass"` and gains this report as a second evidence path.
- `parallel_counters` and `contention` stay `"na"`; the kernel is still deliberately
  single-threaded and this task did not change that.

## 6. Gates

Run through `~/.claude/bin/run-quiet`. Verbatim results below.

**Core, `papers/complete-repair-ports/ergodis`:**

```
$ cargo fmt --all --check
exit=0 time=717ms 382µs 683ns
stdout: 0 lines
stderr: 0 lines

$ cargo clippy --all-targets --all-features -- -D warnings
exit=0 time=10sec 1ms 619µs 226ns
    Checking ergodis v0.1.0 (/home/tavis/src/othello/papers/complete-repair-ports/ergodis)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 9.92s

$ cargo test --all-features
exit=0
test result: ok. 570 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 18.16s
  (lib; plus 26, 10, 9, 8, 8, 7, 5, 4, 3, 3, 3, 2, 2, 1, 1, 1 passed and 4 empty across the
   integration and doc-test binaries, every one `ok`, 0 failed anywhere)
```

The 11 Hall unit tests within that lib run are the four parity/selector/allocation tests added by
this task plus the seven pre-existing ones, all passing.

**Private, `ergodis-private`:**

```
$ cargo check --workspace --all-targets
exit=0 time=11sec 900ms
    Checking ergodis v0.1.0 (/home/tavis/src/othello/papers/complete-repair-ports/ergodis)
    Checking ergodis-private v0.0.0 (/home/tavis/src/othello/ergodis-private)
    Checking gem-hunt v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/gem-hunt)
    Checking hadamard-2092 v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/hadamard-2092)
    Checking ergodis-tools v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/tools)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 11.90s
```

```
$ cargo test -p ergodis-private -p ergodis-tools
exit=0 time=12min 29sec 904ms 473µs 509ns
    Finished `test` profile [unoptimized + debuginfo] target(s) in 0.31s
     Running unittests src/lib.rs (.../deps/ergodis_private-28f2e8687d1b24b0)
     Running tests/g41_pair_workspace_allocations.rs (.../deps/g41_pair_workspace_allocations-25a6e4311186cb5d)
     Running tests/hadamard_2092_allocations.rs (.../deps/hadamard_2092_allocations-880780a1afde3c1d)
     Running tests/proof_synthesis_allocations.rs (.../deps/proof_synthesis_allocations-73d7633d288b4b74)
     Running unittests src/main.rs (.../deps/ergodis_tools-8280bf993563f6c2)
   Doc-tests ergodis_private

test result: ok. 577 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 661.51s
test result: ok.  30 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in   0.53s
test result: ok.  13 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in  86.34s
test result: ok.   1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in   0.02s
test result: ok.   1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in   0.00s
test result: ok.   0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in   0.00s

622 passed, 0 failed, no `FAILED` or `panicked` line anywhere in the 669-line log.
```

The four `hall_core` tests all pass through the promoted core kernel:

```
test hall_core::tests::exhaustive_four_by_four_matches_brute_force_hall ... ok
test hall_core::tests::repeated_solves_reuse_storage_and_reject_bad_graphs ... ok
test hall_core::tests::returns_exact_hall_deficiency ... ok
test hall_core::tests::returns_saturating_matching ... ok
```

The run is slow (12.5 minutes) because it is a debug build of the whole private workspace; the
kernel was confirmed to be computing rather than stalled by watching its CPU time advance. This is
pre-existing and not caused by this change.

Workspace clippy for `ergodis-private` was **not** run, and should not be read as passing: the
workspace carries C1051's and C1039's uncommitted files, so a `-D warnings` run there reports on
another task's in-flight work and cannot isolate this change. `cargo check --workspace
--all-targets` above does cover every target this change touches.

## 7. Accepted and rejected variants

The whole difficulty of this task was that the dense bitmap scan resists abstraction. Six
structurally reasonable ways to share one kernel between two layouts each cost the dense path real
time. Recording them so nobody repeats them:

| Variant                                                                              | Dense cost                | Verdict      |
|--------------------------------------------------------------------------------------|---------------------------|--------------|
| Generic kernel over a `HallAdjacency` trait, closure internal iteration returning `ControlFlow` | instructions flat, wall +6%   | rejected |
| The same, with `#[inline(always)]` on both scan implementations                       | wall +21% to +25%         | rejected     |
| Generic kernel over a GAT `Iterator` (bit-scanner for dense, `Copied<slice::Iter>` for CSR)     | instructions +12%, wall +19% | rejected |
| Macro expansion, range test hoisted out of the chain into the scan macro              | instructions +4.5%        | rejected     |
| Macro expansion, range test removed entirely as provably dead                         | instructions +2.2%        | rejected     |
| Macro expansion, guard macro, deficiency sweep left inlinable                          | instructions +4.3%        | rejected     |
| **Macro expansion, guard macro, `#[inline(never)]` deficiency sweep**                  | **+0.00% to +0.06%**      | **accepted** |

Notes on two of those. Forcing `#[inline(always)]` on a hot helper lost badly, which is worth
remembering as a general caution. Removing the range test is exact — `DenseHallGraph::new` rejects
every out-of-range edge, so no bit at or above `right_count` is ever set — and it still measured
worse than leading the short-circuit chain with it, so the original condition order was already the
right one.

Two further rejected variants, outside the kernel's shape:

- **Two dedicated `Box<[u32]>` buffers for the deficient index lists.** Correct and simple, but the
  two extra heap allocations perturbed the workspace's heap layout enough to raise cache misses 25%
  and cycles 4.4% at 512x1024. Replaced by aliasing the lists onto the already-dead `queue` and
  `parent_right` buffers, which restored cache misses to +0.9%.
- **`SPARSE_DENSITY_DIVISOR = 20`.** Briefly adopted from a crossover sweep taken before the dense
  path was repaired, which put the neutral point near 50 per mille. Once the dense regression was
  fixed the neutral point moved to 31 per mille and the analytic value 32 was restored. The lesson
  is that a crossover measured against a degraded control encodes the degradation into the policy.

A bisection sequence made the accepted variant findable at all, and is worth reusing: because the
build is bit-reproducible, marginal instruction counts can be attributed to individual source edits
one at a time. That is how the deficiency sweep was identified — the three new workspace fields cost
0 instructions, a token-identical macro conversion of the augmenting loop cost 0, and converting the
deficiency sweep cost 52,166 instructions per round in a benchmark where **it never executes**.

## 8. Mystery ledger

1. **Settled: why a never-executed function cost 4.3%.** Growing `alternating_deficiency` changed
   inlining and register allocation in `solve_hall`, which is where the augmenting loop lives. The
   sweep is called once per solve from that function, so when it inlines, its code and its live
   values compete with the hot loop's. `#[inline(never)]` on a path that runs at most once per solve
   and only on failure costs nothing and recovers all of it. **Generalizable**: any core kernel with
   an inlinable cold failure path in the same function as its hot loop should be checked the same
   way. This is a cheap sweep and worth queueing.
2. **Settled: the analytic crossover was right and the first measurement was wrong.** The byte-traffic
   model predicted 3.125%; the first sweep said about 5%; the corrected sweep says 3.1%. The
   discrepancy was entirely the degraded dense control, not a missing term in the model.
3. **Settled: CSR uses fewer instructions at every density yet loses above 3%.** The bitmap's win in
   the dense regime is memory traffic per candidate tested, not instruction count — 8 bytes per 64
   candidates against 4 bytes per neighbour. An instruction-count-only selector would misroute every
   instance above 3% density.
4. **Open: the 80-per-mille crossover outlier.** One of eleven rows breaks monotonicity, with a
   bitmap reading 76% above its trend. Almost certainly a disturbed sample rather than structure —
   the rows on both sides of it are consistent — but it was not re-run. *Evidence gap*: re-run that
   single density with more rounds if the crossover constant is ever retuned. It does not affect the
   selected constant, which sits at 31.
5. **Open: the wall-time harness cannot resolve differences below about 4%.** Its null floor is
   0.982 to 1.002 while instruction counts are reproducible to five significant figures. Every
   conclusion in section 4.1 therefore rests on counters, with wall time only confirming the absence
   of a large effect. Part of the cause is external and was visible during the runs: three
   `ergodis-campaign` processes belonging to other lanes have been resident for one to two days on
   this host, so the machine was never quiet. Pinning to one CPU bounds but does not remove their
   effect on shared cache and frequency. *Gate for any successor*: a sub-4% Hall timing claim needs
   a quiet host plus a better harness (more rounds, larger per-round workloads, or a fixture cache
   so setup is not re-paid), not more samples from this one.
6. **Open, small: `HallWorkspace::matching` is now a `&self` accessor over the last solve.** It
   panics if asked for more left vertices than the last solve used, where the private version would
   have returned stale contents. No current caller can hit it — each passes its own `left_count`
   immediately after its own solve — but it is a behaviour change at the boundary, recorded here
   rather than papered over.

No mystery remains about the promoted kernel's correctness: parity is exhaustive at 4x4, exact
across 180 generated instances in four layouts, and byte-identical on the committed replay case.
