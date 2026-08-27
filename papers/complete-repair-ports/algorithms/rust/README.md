# ERGO-comp Rust engine

This Cargo package is the high-performance counterpart to the exact Python
oracle in the parent directory. It uses Rust-native representations and
algorithms rather than mirroring the Python module tree.

## Architecture

- prime-field arithmetic is const-generic and monomorphized; canonical
  polynomial-basis GF(4) uses the same byte-valued, statically dispatched field
  interface, with no runtime tag in matrix or composition loops;
- cold input matrices are contiguous row-major `Box<[u8]>` values with an
  asserted 32-byte owning boundary;
- generated bases live in one flat byte arena addressed by asserted 16-byte
  records;
- hot span states and predecessor nodes are asserted 16-byte records using
  range-sized IDs;
- labelled cost tables keep matrix labels in the same byte arena and expose
  16-byte scalar records to literal-block min-plus composition;
- the rank-one transfer front end derives ordinary and target-normalized
  labelled costs from represented binary encoder columns, retains minimizing
  coefficient vectors separately, and fails closed on an explicit candidate
  budget;
- the target-subspace compiler fixes an explicit normalized binary basis,
  minimizes row-union support over matrix-valued coefficient lifts, and feeds
  its matrix-valued labelled tables directly to arbitrary-rank confinement;
- target-aware min-plus composition propagates distinct ordinary and
  target-normalized tables through successive levels, optionally in parallel,
  while retaining each level's minimizing labels for witness reconstruction;
- `transfer-tower` expands those labels recursively to the original
  coefficient matrices under an explicit witness-node budget;
- composition and syndrome-trellis frontiers retain witnesses as 16-byte
  predecessor nodes; generator enumeration uses a base-`P` odometer without
  allocating coefficient matrices in its inner loop;
- ternary syndromes use 21 carry-safe three-bit lanes per `u64` block;
- orbit-syndrome search keeps packed residues in place, precomputes suffix
  residue and integer bounds, and stores failed states in flat exact-key and
  16-byte collision-record arenas;
- cold orbit compilation quotients ternary constraints to the affine span of
  option differences and integer totals to Smith coordinates, returning
  checkable annihilator or congruence obstructions for excluded targets;
- weighted capacity scheduling uses 16-byte Pareto states and predecessor
  records, flat resource-load arrays, and compacts pruned load layers so live
  load storage remains `O(SH)`;
- caller-supplied strictly positive helper gradings are verified exactly; when
  all options have one weighted mass, the scheduler proves the frontier is an
  antichain and deletes dominance work even when ordinary option sizes differ;
- narrow certified dense scheduling fuses packed loads, witness ID, and lattice
  key into one asserted 16-byte state; grading makes duplicate loads
  irreplaceable, so a one-bit membership table replaces the `u32` incumbent
  table and coordinate loads are never materialized;
- when the full capacity box exceeds the dense ceiling, a bounded-composition
  ranker addresses only the exactly certified weighted-grade shells; a
  residue-prefix table makes each coordinate's lexicographic rank contribution
  constant-time and preserves the same packed state and one-bit membership
  kernel;
- incidence constraints use contiguous `u64` masks and `count_ones`;
- the GF(27) spatial continuation uses table-driven `GF(9)`/`GF(27)` arithmetic
  only while compiling geometry, then retains the self-dual projective-plane
  incidence relation as one flat `u16` array with fixed stride `q+1`; its
  ordering is differentially pinned to the Python oracle by exact hashes;
- the GF(27) balanced endpoint reconstructs the degree-eight trace/product
  carrier from two 16-byte high-fiber polynomials and treats every later fiber
  as a direct coefficient check; nine supplied candidate families are joined
  by their least-product seed pair and return one 64-byte indexed witness;
- alternatively, high-fiber cells compile directly to affine equations in the
  18 carrier coefficients; exact elimination rejects inconsistent prefixes,
  reports underdetermined rank, or reconstructs the unique carrier at rank 18,
  avoiding enumeration of root-free cofactors;
- hashing is confined to cold sibling/frontier indexes with exact collision
  checks; no map or owned dynamic container occurs inside a hot record; and
- serialization and differential fixtures remain outside the in-memory hot
representation.

Dependencies are admitted when used. `rustc-hash` serves deterministic cold
interning, `rayon` optionally partitions independent composition frontiers and
Pareto/lattice kernels with deterministic reduction, `serde` handles cold
boundaries, and `thiserror` handles checked input failures. `proptest` and
`serde_json` are development-only. Criterion 0.7 supplies the Rust-1.82-compatible
statistical locality benchmark target.

## Gates

From this directory, using the repository Nix toolchain:

```text
nix shell nixpkgs#python3 --command python3 generate_fixtures.py --check
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo fmt --check
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command \
  cargo clippy --all-targets --all-features -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test --all-features
```

The current fixture exhausts all 64 binary `2 x 3` generators against all 16
binary `2 x 2` demands and all 27 ternary `1 x 3` generators against all nine
ternary `1 x 2` demands: 91 generators and 1,267 exact cost/support queries.
The same fixture also checks binary and ternary two-block labelled composition,
and checks both exact confinement backends on two binary instances, including
the winning sector, functional coefficients, and block-label witnesses.
An independently generated GF(4) fixture checks both encoder presentations in
the paper's functional-label separation: associated-pair bases, every labelled
cost and coefficient argmin, inner-dual witness, both sector costs, selected
outer functional, block labels, and the resulting unequal exact costs.
Seventeen orbit cases check choices and every pruning counter, including a
25-coordinate packed-word boundary. Weighted and unit-capacity cases check
assignments, aggregate helper loads, Pareto counters, and the unit capacity-cut
certificate. Property tests independently compare packed orbit feasibility and
weighted optimum cardinality with brute force.
Python and Rust share the canonical witness order: cost, original-coordinate
support, then coefficient rows.

The orbit fixture also re-solves every Python case after independent ternary
affine-span and integer Smith compilation.  Random `3 x 3` Smith tests replay
the transformed lattice and determinant, while Python and Rust independently
reconstruct the same `GF(27)` carrier from two high fibers.

No speed claim is accepted until exact parity passes and a release A/B run
records transitions, wall time, and peak memory. Never describe a measurement
as a floor or hard limit.

## Bounded performance evidence

The GF(27) balanced Criterion target additionally measures two new compiled
stages.  On the current loaded host, two-fiber trace/product reconstruction
takes 33.212 ns, while a synthetic 32-binary-family, 102-coordinate affine
compilation takes 6.0292 us and guarantees at most 32 output coordinates.
The latter is a generic shape test, not the rank of the distinct GF(27)
102-parity balanced-carrier model.  The unrestricted carrier and mapping zero
in both semilinear representatives have now been checked separately and all
have full affine rank 102.  The local pair-difference rank is six at every
unmarked row; combined with the 17-row Vandermonde rank, this proves full rank
102 for every fixed mapping.  Their correct reduction is therefore two-fiber
carrier reconstruction rather than affine rebasing.  These are component
measurements, not a complete finite-branch solve.

The indexed nine-family seed join takes 215.11 us on a bounded 64-candidate-
per-family shape whose unique coherent seed pair is last, so all 4,096 seed
pairs are examined.  Genuine cubic/quartic candidate generation is excluded
from this component timing.

From-scratch elimination of 18 high-cell equations and reconstruction of the
unique carrier takes 5.5344 us.  The recursive search should use transactional
rollback updates rather than rerun this cold baseline at every node.  The
implemented 384-byte aligned echelon state appends rows without modifying old
ones; rank-17 push/pop takes 323.54 ns, while adding the unique solve gives
523--552 ns across two Criterion sessions.

At a complete high-fiber ledger, double rows give common roots of every
carrier-kernel pair.  Eight double rows force carrier uniqueness; seven leave
at most one fractional-linear defect parameter.  The ledger keeps zero- and
double-row counts in its spare bytes and reports this zero/one nullity bound.

`run_benchmarks.py` runs pinned-core, rotated interleaved release comparisons
and records raw samples in `evidence/benchmarks.json`. On its one deterministic
workload per kernel, the seven-round medians are:

- weighted scheduling: 8.869 s Python versus 46.2 ms Rust flat, with identical
  35,334 transitions, a 1,907-state peak, and the same witness (`192x` here);
- ternary orbit search: 84.3 ms Python versus 1.064 ms Rust coordinatewise,
  with identical 16,645 visited states and the same infeasibility witness
  (`79x` here).

These are whole-solve, single-workload comparisons, not general speedups.
Python peak RSS was about 30 MiB; Rust was about 2.3--2.5 MiB, including
process overhead.

Two 11-round Rust-only A/B tests are instructive. Mixed-radix capacity keys
changed neither work nor frontier size and produced a paired median `1.005x`;
that is a wash, so the flat-load engine remains the default. Exact correlated
suffix residues reduced orbit DFS states from 16,645 to one, but took 4.28
times as long overall and raised peak RSS from 2.4 to 7.6 MiB because closure
construction dominated. It remains a bounded experimental backend for testing
an adaptive planner, not an accepted optimization.

The exact meet-in-the-middle orbit backend changes that conclusion on this
instance: its 26.1 us median is `40.4x` faster than coordinate DFS, `172.7x`
faster than correlated closure, and `3,229x` faster than Python. Its two half
enumerations examine 486 assignments and retain 243 right states. Bounded
preallocation contributes a separately measured `1.214x`.

A separate exact-feasibility scaling sweep holds four choices per family and
six ternary syndrome coordinates while increasing the number of orbit
families. CP-SAT receives one-hot family choices and the same exact ternary
syndrome equations. The packed coordinate engine is the appropriate ERGO
backend in this regime; building correlated suffix closure would waste both
time and memory.

| families | ERGO time | ERGO RSS | CP-SAT time | CP-SAT RSS | speedup |
|---------:|----------:|---------:|------------:|-----------:|--------:|
|       80 |     46 us |  1.6 MiB |   29.590 ms |   77.3 MiB |    644x |
|      320 |    138 us |  1.7 MiB |  168.105 ms |   83.9 MiB |  1,215x |
|    1,280 |    424 us |  2.3 MiB |       1.09 s |  104.7 MiB |  2,582x |
|    8,192 |  2,735 us |  6.2 MiB |      20.21 s |  246.7 MiB |  7,388x |

The first two rows use 21 rotated rounds, the 1,280-family row seven, and the
seconds-scale 8,192-family row three. Every run returns the same feasibility
verdict; raw samples and artifact hashes are recorded separately from the
older Python-oracle comparison.
For unequal family sizes, the production split minimizes the exact sum of the
two contiguous half-assignment products, breaking ties toward the smaller
right table. On the skew `[2,2,2,2,2,2,64]` fixture this changes 520 examined
half assignments and 511 retained right states to 128 and 64, for a measured
`2.215x` improvement while preserving the first witness.

For scheduling, a mixed-radix dominance lattice replaces the quadratic Pareto
scan by a multidimensional prefix maximum. Direct addressing, guarded packed
capacity arithmetic, and once-dispatched `u64`/`u128` kernels remove hashing
and per-coordinate feasibility scans; each non-antichain frontier selects the
lattice transform only when its margin-adjusted `P H` estimate is no larger
than the quadratic `S^2 H` estimate.

A further exact certificate applies when every compiled option has the same
positive total load `m`: every frontier state has total load `m` times its
repair count, so two distinct states cannot dominate one another. Pareto
pruning is then skipped. In the narrow dense kernel, packed loads, the witness
ID, and the mixed-radix key form one 16-byte state. Coordinate loads are never
materialized, copied, or compacted. Equal-load incumbents cannot improve, so a
one-bit membership lattice replaces the `u32` incumbent table. Canonical final
witness selection uses an exact mixed-radix `u64` code when the certified
repair-depth bound fits; otherwise it compares persistent parent chains
iteratively with no allocation. The code, 24-bit parent, 8-bit depth, and
option ID occupy one 16-byte witness node. Compiled metadata selects sparse or dense generation once, with separate
occupancy models for this fused kernel and the general dominance kernels.

In the fresh 21-round pinned-core interleave, the balanced dense backend takes
144.0 us versus 1.170 ms for antichain-aware sparse Rust and 2.246 ms for a
reused-model OR-Tools 9.14 CP-SAT solve (`15.60x`). On the
small-state/high-demand case it takes 26.4 us versus 11.082 ms for CP-SAT
(`420.2x`). Relative to the immediately preceding certified implementation,
the fused state, bit membership, append-only loads, persistent index, and
allocation-free witness selection are representation changes; transition
counts and exact outputs are unchanged.

The seeded phase grid contains 26 profiles: thirteen `(H,c,D)` shapes at two
seeds, with equal four-option families, `P` from 81 through 1,048,576, and ten
solves per sample. The fused-kernel cost model selects correctly in all 26,
with maximum
measured dispatch regret `1.115x`. Rust beats reused-model single-worker CP-SAT
in all 26, with median `48.10x` and minimum `5.10x` speedup. This closes the two
previous large-lattice losses on the bounded grid, not universally.

A separate 11-round rotated comparison gives CP-SAT the same safe structural
preprocessing: capacity feasibility, option deduplication and Pareto
canonicalization, the exact positive-grading repair bound, one deterministic
worker, a reused model, and a reusable solver object.  On the new large-box
shell fixture Rust takes 73.4 us versus 185.3 us for this strengthened CP-SAT
control (`2.526x`); CP-SAT has zero branches and conflicts, so this is a
representation/dispatch comparison rather than a search-tree win.  The same
protocol gives Rust wins of `336.514x`, `560.936x`, and `18.074x` on the
balanced, small-state, and large-nonuniform profiles respectively.  These are
bounded warm-solve results, not universal claims about CP-SAT.

An end-to-end scaling sweep then increases one input axis at a time. The demand
sweep holds four options per demand; the option sweep holds 80 demands. Raw
CP-SAT receives all generated options, while the structured control receives
the same safe Pareto canonicalization and grading bound as ERGO-comp. All
three backends return the same optimum.

| demands | ERGO time | ERGO RSS | raw CP-SAT | raw RSS | structured CP-SAT | structured RSS | speedup: raw / structured |
|--------:|----------:|---------:|-----------:|--------:|------------------:|---------------:|--------------------------:|
|      80 |     46 us |  1.6 MiB |   6.686 ms | 75.1 MiB |          6.733 ms |       75.2 MiB |              147x / 148x |
|     320 |    146 us |  1.6 MiB |  28.045 ms | 78.2 MiB |         28.173 ms |       78.0 MiB |              192x / 193x |
|   1,280 |    515 us |  2.1 MiB | 212.182 ms | 97.3 MiB |        212.162 ms |       95.7 MiB |              412x / 412x |
|   8,192 |  2,633 us |  4.4 MiB |      1.37 s | 199.9 MiB |            1.35 s |      188.6 MiB |              522x / 511x |

| options per demand | ERGO time | ERGO RSS | raw CP-SAT | raw RSS | structured CP-SAT | structured RSS | speedup: raw / structured |
|-------------------:|----------:|---------:|-----------:|--------:|------------------:|---------------:|--------------------------:|
|                 64 |    417 us |  1.8 MiB |  72.216 ms | 84.8 MiB |         18.334 ms |       77.5 MiB |               173x / 44x |
|              1,024 |  4,515 us |  6.0 MiB |       1.59 s | 386.1 MiB |         71.936 ms |       89.7 MiB |               353x / 16x |

The small and medium rows use 21 rotated rounds; the two seconds-scale rows
use seven. This sweep shows two different advantages: the dense certified
kernel scales gently with demand count, while option canonicalization prevents
a thousand alternatives per demand from reaching the residual optimizer.

The represented-tower path has a separate 21-round, pinned-core end-to-end
comparison. Direct CP-SAT receives binary coefficient variables, the exact
row-support objective, and GF(4) parity constraints. The stronger-preprocessing
control receives the same independently generated labelled cost tables as
ERGO-comp, then uses one-hot leaf choices and the same parity constraints.
Every solver proves the same optimum; ERGO-comp additionally expands its
canonical coefficient witness tree.

| depth / fanout | leaves | ERGO time | ERGO RSS | direct CP-SAT | direct RSS | labelled CP-SAT | labelled RSS | speedup: direct / labelled |
|:---------------|-------:|----------:|---------:|--------------:|-----------:|----------------:|-------------:|---------------------------:|
| 2 / 2          |      4 |     89 us |  1.3 MiB |      3.011 ms |   74.4 MiB |        4.917 ms |     74.9 MiB |                  34x / 55x |
| 3 / 3          |     27 |    134 us |  1.3 MiB |     11.560 ms |   75.5 MiB |       27.479 ms |     77.0 MiB |                 86x / 204x |
| 4 / 3          |     81 |    166 us |  1.3 MiB |     43.160 ms |   78.5 MiB |      112.086 ms |     82.0 MiB |                260x / 676x |
| 5 / 4          |  1,024 |    300 us |  1.4 MiB |        8.21 s |  126.4 MiB |          1.57 s |    157.8 MiB |           27,385x / 5,224x |
| 6 / 4          |  4,096 |    766 us |  2.8 MiB |      263.76 s |  281.4 MiB |          6.19 s |    411.4 MiB |          344,300x / 8,080x |

These are bounded single-worker results for the identity-block GF(4) tower
family, not a general claim about CP-SAT. The first three rows use 21 rounds;
the 1,024-leaf row uses seven. At 4,096 leaves, Rust uses 21 samples, labelled
CP-SAT seven, and direct CP-SAT one completed solve. Raw samples, artifact
hashes, work counters, and the exact protocol are in
`evidence/benchmarks.json`; replay the first four rows with
`run_benchmarks.py --write --transfer-only --ab-rounds 21` and the last with
`run_benchmarks.py --write --transfer-deep-only` after building the release
benchmark binary with the documented architecture flags.

ERGO-comp alone can be pushed much farther before ten seconds. The following
are pinned-core single end-to-end solves, including instance compilation and
complete witness construction. They are the largest completed geometric or
power-of-ten probes attempted, not claimed hard limits.

| kernel                     | input scale                                     |            exact work |   time |  peak RSS |
|:---------------------------|:------------------------------------------------|----------------------:|-------:|----------:|
| represented tower          | depth 14, fanout 4; 268,435,456 leaves          | 357,913,941 witnesses | 3.90 s |   2.5 MiB |
| scheduling: demand scaling | 40,000,000 demands; 4 alternatives each         |   2,039,999,880 moves | 8.03 s | 2,787 MiB |
| scheduling: fanout scaling | 80 demands; 14,000,000 alternatives each        |           9,338 moves | 9.12 s |   2.3 MiB |
| orbit feasibility          | 10,000,000 families; 4 alternatives, width 6    |     10,000,003 states | 3.08 s | 4,523 MiB |

The tower streams nearly 358 million reconstructible witness records. The
scheduler-fanout row generates and canonicalizes 1.12 billion alternatives,
yet retains only the antichain needed for 9,338 optimizer moves. The demand
and orbit axes remain representation-memory limited; tower replay and
scheduler fanout no longer are. Replay with
`run_benchmarks.py --write --ergo-limits-only`.

Zen 5 top-down microarchitecture analysis supports that diagnosis. These are
percentages of pipeline slots, rounded to whole percentages; the top-level
group is multiplexed and therefore approximate. The memory/core columns come
from a separate nonmultiplexed backend-breakdown run.

| kernel                     | retiring | frontend | bad speculation | backend | memory | core |
|:---------------------------|---------:|---------:|----------------:|--------:|-------:|-----:|
| represented tower          |      55% |       2% |              1% |     42% |    21% |  20% |
| scheduling: demand scaling |      38% |      32% |             17% |     13% |     6% |   3% |
| scheduling: fanout scaling |      18% |      17% |             25% |     39% |    30% |   9% |
| orbit feasibility          |      61% |      14% |              1% |     24% |    22% |   2% |

These measurements follow streaming witness/input introduction and precede
the final narrow-load representation. They show the tower shifting from 48%
memory-bound to a balanced 21% memory / 20% core split, while the streamed
fanout compiler exposes branch and residual memory costs. Replay with
`run_benchmarks.py --write --tma-large-only`.

Tower witness replay therefore also has a low-memory mode. It retains the
compiled argmin tables, preallocates one `O(depth * fanout)` choice scratch,
and emits preorder records through a callback; it allocates neither per node
nor per push. A record contains its level, label bytes, cost, normalization
flag, and child count, so the original tree is reconstructible from the
stream. The eager API remains available when callers actually need an owned
tree.

| mode      | depth / fanout | witness records |    time |  peak RSS |
|:----------|:---------------|----------------:|--------:|----------:|
| eager     | 12 / 4         |      22,369,621 |  1.32 s | 1,965 MiB |
| streaming | 12 / 4         |      22,369,621 |  238 ms |   2.4 MiB |
| streaming | 14 / 4         |     357,913,941 |  3.83 s |   2.4 MiB |

At depth 12, streaming is 6x faster and uses about 800x less peak memory. The
depth-14 run expands 268 million leaves and nearly 358 million exact witness
records below four seconds. These are seven-round rotated medians at depth 12
and three rounds at depth 14; replay with
`run_benchmarks.py --write --tower-stream-only --ab-rounds 7`.

Scheduling input compilation has a matching streaming path. Its generic
iterator API maintains each family's Pareto-minimal antichain online; generated
callers can yield stack arrays, and materialized callers use the same canonical
implementation. Family records occupy 8 bytes, option offsets are derived
from fixed-width layout rather than stored, and retained loads use the
narrowest exact `u8`/`u16`/`u32` representation selected once at construction.

| axis                         | materialized time | materialized RSS | streamed time | streamed RSS |
|:-----------------------------|------------------:|-----------------:|--------------:|-------------:|
| 10,000,000 demands x 4       |            2.81 s |        3,588 MiB |        2.31 s |    1,576 MiB |
| 80 demands x 1,000,000       |            2.69 s |        4,275 MiB |         891 ms |      2.2 MiB |

These three-round rotated comparisons use identical generated alternatives,
work counts, and optima. The final derived-offset and narrow-load changes then
move the 10-million-demand single run to about 2.14 s / 699 MiB and enable the
40-million-demand stress row above. Replay the paired comparison with
`run_benchmarks.py --write --streaming-input-only`.

The frontier-sized thread sweep includes compilation and uses CPUs 0--23 for
parallel variants. Additional workers act only on the small residual solve,
so the results are effectively flat; 24 is not the optimum.

| axis                    |      single thread |           best parallel | verdict |
|:------------------------|-------------------:|------------------------:|:-------|
| 40,000,000 demands x 4  | 8.25 s / 2,787 MiB | 8.13 s / 2,787 MiB (12) | neutral |
| 80 demands x 14,000,000 |   9.15 s / 2.4 MiB |    9.12 s / 2.6 MiB (8) | neutral |

Parentheses give worker count. These are single frontier probes, not stable
speedup claims; the sequential path remains the default for these shapes.
Streaming tower replay and the deep orbit DFS are currently sequential, so no
synthetic multithread number is reported for those rows.
Replay with `run_benchmarks.py --write --ergo-thread-sweep-only`.

A pinned-core `perf stat` diagnostic on the largest nonuniform profile records
about 661,000 cycles, 2.01 million instructions, 341,000 branches, 454 branch
misses, and 961 cache misses per solve. Against the preceding implementation,
instructions per examined transition fall from about 357 to 61. Top-down slot
analysis attributes about 16.0% to memory-bound backend stalls, 0.7% to
core-bound backend stalls, 10.4% to frontend stalls, 0.1% to bad speculation,
and 33.4% to retiring; multiplexed counters make these approximate. The change
is state representation and allocation removal, not reduced transition counts.

Repeated callers can pass a `WeightedRepairWorkspace` to
`solve_adaptive_with_workspace`, `solve_adaptive_parallel_with_workspace`, or
`solve_dense_lattice_with_workspace`.
Frontiers, witnesses, membership bits, and narrow packed metadata then retain
their allocations between exact solves; result ownership remains unchanged.
The workspace is problem-independent and offers `shrink_to_fit` when a caller
wants to release retained capacity. In a fresh 21-round pinned-core interleave,
workspace reuse improves the large nonuniform profile from 205.0 to 133.3 us
(`1.538x`), the balanced profile from 9.48 to 7.72 us (`1.227x`), and the
tiny-state/high-demand profile from 12.20 to 11.07 us (`1.102x`). Work,
frontier peaks, checksums, and median process peak RSS agree. Sampling reduces
`memmove` from 3.7% to 0.9% and `realloc` below the reported threshold.

The next L1D pass uses the dense ceiling twice. Mixed-radix keys occupy at most
24 bits, so the high byte of the state's key word stores repair depth. Witness
nodes then need only `(parent: u32, option: u32)`, an asserted 8-byte
`repr(C)` record rather than 16 bytes. Exact lexicographic codes are constructed
once in a sequential scratch pass after the dynamic program instead of being
read and extended inside every accepted transition. A 21-round saved-binary
interleave improves the large nonuniform workspace case from 161.1 to 134.8 us
(`1.195x`), the balanced graded case from 10.09 to 8.15 us (`1.237x`), and the
small-state case from 14.90 to 12.15 us (`1.226x`), with exact output/work
parity and neutral RSS. Instructions fall from about 62.5 to 51.5 per examined
transition and L1D misses by about 11% in the large diagnostic.

L1I is not presently limiting: hardware counters report roughly 0.1% fetch
misses and only a few dozen L1I misses per solve. Forcing the 7.7 KiB graded
kernel out of the 16.5 KiB dispatch symbol measured `1.018x`, `1.009x`, and
`0.999x`; it was reverted. Glibc's AVX-512/ERMS `memmove` is about 1.2% of
samples, so manual REP/copy code was likewise rejected.

Architecture flags are measured rather than inherited from the Queens engine.
On this Zen 5 host, `target-cpu=znver5` is 11--16% slower for this scalar/bitmap
kernel. `x86-64-v3` improves all three profiles by `1.029x`--`1.055x` over
generic x86-64 and narrowly wins two of three against `znver3`, so the local
Cargo configuration pins that reproducible non-AVX-512 target. Thin LTO and one
codegen unit remain: disabling them measured 1--2% slower in the executable
A/B even though Criterion's harness-local absolute times moved in the opposite
direction.

Criterion 0.7 is the newest compatible line for the crate's Rust 1.82 floor.
`scheduler_locality` uses 60 samples, two seconds of warmup, four seconds of
measurement, a warmed workspace, and transition throughput. With the final
production-equivalent profile and `x86-64-v3`, its point estimates are 3.794 us
for balanced, 8.097 us for small-state, and 67.941 us for large nonuniform.
Criterion values are within-harness microbenchmark baselines; release claims
continue to use the pinned rotated cross-binary harness.

The opt-in `parallel_kernels` sweep measures exact output parity at 1, 2, 4,
6, 8, 12, 16, 20, and 24 workers. On the 24-core benchmark host, the bounded
width-nine composition fixture improves from 4.925 ms sequential to 1.562 ms
at 16 workers (`3.15x`); 24 workers take 1.831 ms. The heterogeneous adaptive
scheduler fixture improves from 44.402 ms to 18.189 ms at 12 workers
(`2.44x`); 24 workers take 20.831 ms. These two fixtures motivate the CLI's
command-specific default caps; they are crossover measurements, not universal
thread-count prescriptions.

Explicit SIMD was considered after profiling. The stride/block prefix loop is
already contiguous and SIMD-friendly, but after division removal it was not
the measured bottleneck. Hash elimination and scalar packed arithmetic had
higher leverage, so no architecture-specific SIMD dependency or unsafe path
was added.

## GF(27) maximal-point engine

`projective` and `defect` implement the custom continuation of the open
defect-19 branch. The plane uses flat fixed-stride `u16` incidence. The hot
augmentor stores 757 byte degrees and updates one 28-line pencil on push/pop.
The exact arithmetic catalogue contains 1,013 combined degree profiles derived
from all 3,435 labelled shells; precomputed tail-threshold masks reduce a
reversible parent/child refine from 1.193 us to 18.22 ns. The frontier and its
rollback delta are asserted 128-byte, cache-line-aligned records.

Criterion's `defect_augmentation` benchmark includes a shallow negative
control and a selective winning branch. On the deterministic depth-34 prefix,
the catalogue reduces a two-level scan from 261,726 to 18,897 nodes and from
16.027 ms to 1.378 ms (`11.63x`). Extending the same prefix to depth 54 proves
the conditioned branch impossible in 19,468 nodes and 1.409 ms. The matching
single-worker CP-SAT v9 conditioned model takes a 4.761 s median (about
`3380x` slower), but the fair
deployment is the Rust necessary-condition prefilter followed by CP-SAT on
survivors; the kernels do not encode identical constraint systems.

The terminal fixed-maximal analyzer chooses minimum-defect line labels and
expresses every other label as a signed unit correction of cost at most nine.
An exact budget-19 cardinality DP and 757 local pencil DPs provide further
necessary spatial checks. The prefix search retains its first survivor with a
single terminal allocation. `examples/gf27_prefix_probe.rs` supplies bounded
replay/profiling without starting an unbounded whole-instance solve.

The new bitmap search confirms the existing architecture decision: an
interleaved 2,000-solve probe measured 2.65 s for `x86-64-v3`, 2.73 s for
`native`, and 2.72 s for `znver5`. AVX-512 appears in the host-target binaries
but does not improve this workload.

The normalization API also fixes a lossless noncollinear maximal-point frame.
The two-point stabilizer is transitive on all 729 off-line points, and a
54-point set cannot lie on the 28-point anchor line. After fixing the third
point, the remaining diagonal stabilizer has order 676 and four point orbits
of sizes `26,26,26,676`. Tests pin their representatives, disjointness, and
coverage. Recursive stabilizer-orbit augmentation is the next search step; the
current lexicographic engine deliberately makes no isomorph-free claim.

## GF(27) balanced-branch front end

`balanced` compiles the newer almost-duplex endpoint reduction without
mirroring its CP-SAT model. Projective shear fixes `w=1`; residual homothety
fixes `e3(U)=1`; Frobenius collapses the four normalized ratio fibers to two
semilinear cases with `kappa=2,18`. Each case has exactly 530 transversal
mappings. The combined hot pool is 1,060 asserted 16-byte records; sorted
8-byte `(U,E)` keys leave 1,058 distinct pairs, with 1,056 simple and two
double mappings. This is precisely half of the Python oracle's unquotiented
2,120 mappings and 2,116 pairs. A table-driven Frobenius transport lifts any
representative mapping witness back through `{18,23,26}` and closes after
three powers, so the quotient loses neither feasibility nor witnesses. The
fixed `kappa=2` fiber has 11 Frobenius-fixed mappings and 173 three-cycles,
leaving 184 representatives; the moving orbit contributes 530. Thus the full
semilinear mapping quotient has 714 cases, a `2.969x` reduction from 2,120.
This quotient applies to the joint carrier--mapping search. For a fixed carrier
the full mapping pool remains necessary; a companion table transport implements
`A'(x^(3^j))=A(x)^(3^j)` and tests exact cell-gate equivariance.
The catalogue stores 714 asserted eight-byte work items carrying the ratio
case, local mapping index, and orbit multiplicity; their weights sum exactly to
2,120 (11 singleton and 703 triple-orbit tasks). Scheduling borrows this
contiguous slice without rebuilding or allocating a queue.

Each mapping precomputes the three cubed row indices and the three forbidden
`A` values. A caller-owned `[u16;530]` scratch buffer therefore applies the
completion-cell avoidance gate with no allocation and no field arithmetic.
The first independent post-quadratic Witt constraint is also precompiled:
the 17 nonmultiples of three in `1..=25` generate the full spectrum, and a
1,458-byte table stores `Theta_4(u,t;kappa)^9` for all cells of the two
semilinear cases. The newer six-monomial collapse is compiled too: the
carrier-level gates are `H4=-Delta_A` for `kappa=2` and
`H4=7*a5^9+26*Delta_A` for `kappa=18`. Two 729-byte field tables make that a
few indexed byte operations. Total catalogue payload is 34,052 bytes including
the prebuilt zero-allocation work queue.
The combined degree-54 support product uses an eight-byte streaming state for
`e1,...,e4`; terminal replay enforces `e1=0`, the coefficient-derived `e2=H2`,
and `e4=-H4-H2^2`, while deliberately leaving the characteristic-three `e3`
blind spot unconstrained.

The high-fiber coherence layer has a separate asserted 16-byte prefix state.
For nine fibers, `g` cubic and `9-g` quartic, it maintains all target counts
and `n2-n0=10-g`. With `R` rows remaining it rejects when the overlap target
is outside `delta+[-R,R]`, one fiber deficit exceeds `R`, or total deficit
exceeds `2R`. A complete 26-row replay measures 320 ns under the loaded-host
Criterion run (about 12.3 ns per row). A separate pinned release probe over
26 million row transitions per round gives 236.3 ns per replay, 9.09 ns and 37.2 cycles
per row, 145.4 instructions per row, about `0.00005` L1D misses per row, and
negligible branch misses. The state is compute/front-end work, not cache-miss
bound; packed-nibble or SIMD rewriting is not justified by this profile.

On a heavily loaded host, pinned-core Criterion diagnostics gave 104.79 us to
compile both cases, 174--187 ns to scan one 530-record mapping pool, 540--559
ns for a complete three-evaluation avoidance pass, and 199--202 ns to scan all
729 precomputed fourth-Witt weights in one case. These are provisional
microbenchmarks; the 184-representative fixed-fiber avoidance scan measures
259 ns under the same degraded load. They are not clean-host or SOTA claims. Replay with
`cargo bench --bench balanced_frontend`.
`examples/gf27_balanced_probe.rs` is the bounded hardware-counter driver.

The contemporaneous four-worker direct incidence CP-SAT probes remained
`UNKNOWN` after 1,800 seconds in both semilinear ratio cases. The fixed case
visited 1,947,011 branches with 141,374 conflicts; the moving case visited
153,691 branches with 10,168 conflicts. The Rust front end is not a competing
complete solver, so these timings are evidence for compiling the quotient and
Witt gate ahead of CP-SAT, not a Rust/CP-SAT speedup claim.
The stronger 9,126-option carrier models, with Reed--Solomon and every affine
direction ledger enabled, also remained `UNKNOWN` at 600 seconds: 413,160
branches/3,600 conflicts for `kappa=2` and 54,154/103 for `kappa=18`.

The high-incidence continuation is now an exact three-way DFS.  For a fixed
mapping and nine-value high set, it chooses the unprocessed row with the
fewest feasible high subsets, tries rank-increasing subsets first, pushes
`C(x)-yA(x)=-y^2` into the 384-byte insertion-order basis, and rolls back by
rank.  Rank 18 checks one carrier; rank 17 enumerates all 27 points of the
Möbius-defect line.  Every compatible terminal replays, in order, splitting,
the complete `y`-fiber profile, the mapping exclusions, the unshifted and
reciprocal norms, and the collapsed fourth-Witt equality.  Prefix mismatch
and an exact 18-byte carrier key remove duplicate terminal work without
discarding a possible witness.

Splitting is compiled one step further on the rank-17 line.  For each row,
`A_lambda(x)^2-C_lambda(x)` must be a nonzero square; the 27 allowed values of
`lambda` fit in one `u32` mask.  Intersecting the 26 masks rejects an empty
Möbius line before root enumeration.  Greedy deletion records a minimal set
of rows with empty mask intersection.  The first bounded slice reaches the
minimum certificate shape of 17 carrier equations plus one discriminant row.
For a *completed* exceptional profile, however, double rows have full masks
and each of the 19 singleton rows excludes at most one parameter.  At least
eight parameters therefore remain split.  A multirow-empty mask is an exact
unfinished-node extension prune, not an additional completed terminal type;
the surviving parameters are candidate completions.  Structurally, no
completed rank-17 pattern exists: factoring the seven double rows makes the
kernel ratio fractional-linear on at least 18 singleton rows, where it cannot
fit into nine high values with fiber cap four.  Any candidate that passes the
complete high-fiber replay therefore has full rank 18 before the later gates.

The outer driver streams all `binom(26,9)=3,124,550` high sets for each of the
714 weighted joint mapping tasks; it does not materialize that product.
Nonzero limits always return `Incomplete`, never `Rejected`.  Rejections keep
greedily inclusion-minimal high-cell cores, canonicalized jointly with the
mapping and high set under Frobenius.  A completely rejected 714-task queue
can classify one minimal core per task and sum both task counts and orbit
weights.  No such exhaustive run has been completed: this API supplies the
finite decision engine and theorem-discovery ledger, not a `q=27`
nonexistence result.

The bounded deterministic probe takes
`max_tasks max_high_sets max_nodes max_terminal_carriers`:

```text
nix shell nixpkgs#cargo nixpkgs#rustc --command \
  cargo run --release --example gf27_balanced_dfs -- 1 1 10000 10000
```

Append `cores` to print the canonical mapping, high values, discriminant rows,
and high cells of every retained minimal core in a bounded discovery run.
To bypass the lexicographic outer stream and probe one exact high set, use the
first argument as the zero-based work ordinal and append
`high=v1,...,v9`; exact-spec mode always prints its retained cores.

Its explicit status and stop counters are the safeguard against treating a
discovery cutoff as a certificate.

Replay after building the release binary:

```text
nix shell nixpkgs#cargo nixpkgs#rustc --command \
  cargo build --release --bin bench_kernels
nix shell nixpkgs#python3 --command \
  python3 run_benchmarks.py --write --rounds 7 --ab-rounds 11
nix shell nixpkgs#python3 --command \
  python3 run_benchmarks.py --write --scheduler-tuning-only --ab-rounds 21
nix shell nixpkgs#python3 --command \
  python3 run_benchmarks.py --write --phase-only --phase-rounds 5
nix shell nixpkgs#python3 --command \
  python3 run_benchmarks.py --write --nonuniform-phase-only --phase-rounds 5
nix shell nixpkgs#python3 --command \
  python3 run_benchmarks.py --write --workspace-only --ab-rounds 21
nix shell nixpkgs#python3 --command \
  python3 run_benchmarks.py --write --locality-only \
    --baseline-binary /path/to/saved-pre-locality-binary --ab-rounds 21
nix shell nixpkgs#cargo nixpkgs#rustc --command \
  cargo bench --bench scheduler_locality
nix shell nixpkgs#cargo nixpkgs#rustc --command \
  cargo bench --features parallel --bench parallel_kernels
nix shell nixpkgs#python3 --command \
  python3 run_benchmarks.py --write --tuning-only --ab-rounds 21
```

The nonuniform phase uses alternating helper weights `1,2`, common weighted
option mass `4`, and ordinary option loads ranging from `2` to `4`. Across its
18 seeded profiles, the verified certificate selects the faster backend in all
18, removes enough work for a `16.105x` median speedup over the same adaptive
solver without the certificate (`140.506x` maximum), and beats reused-model
single-worker CP-SAT in all 18 (`73.352x` median, `11.634x` minimum). This is a
bounded deterministic crossover map, not a general SOTA claim.
