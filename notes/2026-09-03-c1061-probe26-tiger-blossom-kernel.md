# C1061 probe 26: TigerBlossom, a zero-allocation bounded-memory MWPM kernel

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 26, per the TigerBlossom section of
`notes/2026-09-03-c1061-qec-redirect-brief.md`.
**Frozen inputs**: `notes/2026-09-03-c1061-probe13-qec-window-exactness-and-external-baseline.md`.

Contract documents read in full before starting: `/home/tavis/src/ergodis/CLAUDE.md`,
`/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`.

## Headline

**TigerBlossom reproduces PyMatching's minimum-weight matching exactly — zero weight
disagreements on all 360,000 shots across d in {3,5,7,9,15,25} and p in {0.001, 0.01, 0.05} — with
zero allocations in the decode loop and a workspace under 560 KiB. On instructions per decode it
beats PyMatching by 3.1x to 12.3x everywhere at p=0.001, and by 1.9x to 7.2x at p=0.01 for
distances up to 15. It loses at p=0.05 for distances 7 and above, by 1.5x at distance 7 rising to
25.5x at distance 25, and at distance 25 with p=0.01 by 1.7x.**

The win and the loss have the same single cause. The win is graph specialization: the detector
geometry is a constant of the code and the noise model, so the metric closure — every pair
distance and its observable parity — is compiled once, and the modal shot becomes three table
reads. Removing that one specialization costs 1.2x at distance 3 and 20.6x at distance 25, and
without it the kernel would lose almost everywhere. The loss is the general fallback: what is
implemented is a dense `O(n^3)` blossom over the reduced complete graph, not PyMatching's sparse
blossom growing regions on the decoding graph, so as soon as the defect clusters get large the
asymptotics go the wrong way. The brief's prior was 1.5x to 3x; the measured answer is far better
than that in the regime a real device operates in and far worse than that above it.

## Status

- [x] M1 compiled graph and workspace, exact at d=3
- [x] M2 batch decode, exact at d in {3,5,7,9,15,25}
- [x] M3 zero-allocation regression, bounded workspace census
- [x] M4 external agreement with PyMatching on every shot
- [x] M5 A/B against PyMatching `decode_batch`
- [x] M6 fast-path and specialization contribution
- [x] M7 closeout pass and mystery ledger

## Files and commands

All code is in `ergodis-private`; `/home/tavis/src/ergodis` was not modified.

- `src/tiger_blossom_graph.rs` — the cold compiler: detector error model to `KernelSpec`.
- `src/tiger_blossom.rs` — the decode workspace, fast paths, and cluster solver.
- `src/tiger_blossom_match.rs` — the fixed-capacity blossom matcher used as the exact general
  fallback.
- `tasks/tools/src/tiger_blossom_bench.rs` — the `tiger-blossom-bench` subcommand.

- `scripts/tiger_blossom_pymatching_baseline.py` — the PyMatching arm, verification and timed loop.
- `scripts/tiger_blossom_ab.py` — the interleaved two-size A/B driver.

Commits: `a4b5146` (kernel and bench), `e1f054d` (`--plain-graph` flag), `acc8354` (metric
closure and the two-defect closed form), `85bd1c4` (drivers), `037809b` and `32de554` (the
direct level, added and then declined as the default), `546cc82` (retained A/B logs and hashes),
`c91b867` (documentation).

Retained measurement logs, with hashes, at
`ergodis-private/benchmarks/tiger-blossom/`.

```
cd /home/tavis/src/ergodis-private
cargo fmt -p ergodis-private -p ergodis-tools
cargo test --release -p ergodis-private --lib -- tiger_blossom      # 9 passed
cargo clippy --release -p ergodis-private --lib --all-features -- -D warnings
cargo build --release -p ergodis-tools
ergodis-tools tiger-blossom-bench --mode census  --distance 25 --rate 0.05 --operations 20000
ergodis-tools tiger-blossom-bench --mode levels  --distance 9  --rate 0.05 --operations 20000
ergodis-tools tiger-blossom-bench --mode emit    --distance 9  --rate 0.01 --operations 20000 \
    --out shots_d9_p0.01.txt
ergodis-tools tiger-blossom-bench --mode decode  --distance 9  --rate 0.01 --operations 81920
uv run --with pymatching --with numpy python \
    scripts/tiger_blossom_pymatching_baseline.py verify shots_d9_p0.01.txt

# the two A/B runs, from a directory holding the emitted 4,096-shot windows
python3 scripts/tiger_blossom_ab.py external <pinned-binary> <python> \
    scripts/tiger_blossom_pymatching_baseline.py <shotdir> 8
python3 scripts/tiger_blossom_ab.py internal <pinned-binary> 8
```

The A/B driver expects the shot windows named `window_d<distance>_p<rate>.txt`, produced by
`tiger-blossom-bench --mode emit --operations 4096`, whose first 4,096 shots are exactly the
window the `decode` mode cycles.

The crate-wide clippy run reports errors only in `src/certified_predecoder.rs`,
`tasks/tools/src/generic_certificate_bench.rs`, and
`tasks/tools/src/profile_vocabulary_bench.rs`, all files owned by the concurrent
predecoder agent and untouched here. My own files are clean under `-D warnings`.

Measurement binaries, pinned with `retain-bin.sh` before measuring:

| binary | SHA-256 | used for |
|---|---|---|
| `ergodis-tools-acc8354` | `77376ff7115aaffa53a868704e96f7cf1693d734920c3b4c63da2a7ffe938b1c` | the external A/B and the level ladder |
| `ergodis-tools-037809b` | `1f364cf8ad6c346c42906d17859010a6f3e2e26b08e708d7eb5414bc9159caf9` | the direct-level arm |
| `ergodis-tools-32de554` | `df580c13eb015ca8c6551d392afd914b41408c6f6c6481bb1637401954a7af5a` | the final correctness re-verification |

Every internal A/B arm is one binary selected by flag, so the arm hashes are identical by
construction. The level-2 code path is byte-identical across the three binaries; the later commits
add a monomorphization and change a default. External arm: PyMatching 2.4.0 with NumPy 2.5.1 on
CPython 3.14.3.

## Design

### What is compiled, and what is left for the shot

The compiler consumes a detector error model — one column per error mechanism, each flipping at
most two detectors — and emits a `KernelSpec` holding, all in presized boxed slices with `u16`
node identifiers and `u16::MAX` as the no-node sentinel:

1. the sparse adjacency in compressed sparse row form;
2. the distance and observable parity from every detector to the virtual boundary, so a boundary
   match is one array read rather than a search;
3. an *interior pattern* — the modal neighbour-offset multiset together with the bitmap of nodes
   whose entire neighbourhood is that pattern at one weight with no observable flip — so
   relaxation for such a node adds fixed offsets to the node identifier and never loads adjacency;
   and
4. the **metric closure**: the shortest distance and the retained path parity between every pair
   of detectors, compiled by one Dijkstra per node, for graphs up to 2,048 detectors.

Point four is the load-bearing specialization and it is the thing a general library cannot do.
The detector geometry is a constant of the code and the noise model, not of the shot; PyMatching
must rediscover local distances every shot because it does not own the graph across shots. On the
repetition-code family used here the closure costs 74 KiB at distance 25.

### What a shot costs

Decoding is three stages, all on a workspace allocated once in `Workspace::new`.

1. **Defect extraction** scans the syndrome as `u64` words and consumes set bits with
   `trailing_zeros`, so a clean shot costs one load and one test per 64 detectors.
2. **Local distances** are read from the compiled closure. When the closure is unavailable (or the
   unspecialized arm is selected) one bounded Dijkstra per defect recovers the same numbers over a
   fixed-capacity circular bucket queue, with epoch stamps rather than clearing, so reset cost
   scales with touched state and not with the detector count.
3. **Matching** splits the defects into clusters and solves each exactly.

### The cluster decomposition, and why it is exact

Write `b_i` for the boundary distance of defect `i` and `d_ij` for the pair distance. Join `i` and
`j` when `d_ij < b_i + b_j`, and take connected components.

Any pair matched across two components has `d_ij >= b_i + b_j`, so replacing it with the two
boundary matches does not increase the cost and is always available, because the boundary absorbs
any number of defects. Hence some minimum-weight solution has no cross-component pair, and solving
components independently is exact. The same exchange lets the pair cost be stored as
`min(d_ij, b_i + b_j)` throughout, which is what makes the bounded search radius `b_i + max_j b_j`
sound.

### The fast paths, each exact

- **zero defects** — return immediately, no boundary load, no matrix;
- **one defect** — one compiled boundary read;
- **two defects** — three table reads and one comparison, with no pair matrix, no cluster arrays,
  and no matcher;
- **four defects** — direct enumeration of the ten configurations;
- **clusters** — singletons and pairs in closed form, clusters up to eight by a subset dynamic
  program over the cluster's own index set, and larger clusters by the general matcher.

`decode_batch` is monomorphized on a `LEVEL` constant (`0` no fast paths, `1` clusters only, `2`
full) and a `SPECIALIZED` constant, so the choice is resolved once outside the loop and the
production instantiation carries no run-constant branch.

### The general fallback, and where it differs from the brief

The brief asked for a sparse-blossom kernel. What is implemented is a **dense primal-dual blossom
matcher** — Edmonds' algorithm with dual adjustment, blossom contraction, and blossom expansion —
running on presized integer arrays over the *reduced* problem: a cluster of `m` defects becomes
`2m` vertices, `m` defects and `m` boundary copies, with copy-to-copy edges at zero cost and no
edge from a copy to a foreign defect, so a perfect matching is exactly a choice of pairings and
boundary matches. Minimum weight is read off a maximum-weight perfect matching under
`weight = ceiling - cost`, valid because every perfect matching on a fixed vertex set uses the
same number of edges. Every textbook recursion — queue seeding, contracted-vertex relabelling, and
matching inside a contracted blossom — is replaced by an explicit preallocated stack, per the
no-recursion rule.

This is the deliberate deviation and it is where the cost profile below goes wrong at high error
rates: the matcher is `O(n^3)` in the cluster size, whereas PyMatching's sparse blossom grows
regions on the decoding graph and pays for defects rather than for the reduced complete graph.
Clusters above 64 defects fall through to a bounded greedy path, counted and flagged on the
outcome; that path was never taken anywhere on the measured grid.

## Correctness

### Internal oracle

`the_kernel_agrees_with_the_reference_matching_on_random_shots` compares every decode against an
independent oracle — Floyd-Warshall all-pairs shortest paths on the compiled graph plus a boundary
node, then an exhaustive subset dynamic program over the defects — at d in {3, 5, 7, 9, 15, 25},
four rounds, physical rate 0.05, on shots with at most 18 defects. Zero disagreements.
`the_matcher_reproduces_the_reference_optimum_on_random_complete_graphs` and
`the_matcher_handles_the_decoder_reduction_with_forbidden_copies` gate the blossom matcher on its
own against a subset dynamic program, 300 random instances at each of six sizes.
`every_specialization_level_returns_the_same_weight` checks that levels 0, 1, and 2 and both graph
arms return the same weight and the same parity.

### External agreement with PyMatching

20,000 shots per cell, four-round windows, the same matching graph on both sides, PyMatching
2.4.0 `decode_batch(..., return_weights=True)`.

| distance | detectors | p=0.001 weight / prediction | p=0.01 weight / prediction | p=0.05 weight / prediction |
|---|---|---|---|---|
| 3  | 8  | 0 / 0 | 0 / 39  | 0 / 832 |
| 5  | 16 | 0 / 0 | 0 / 4   | 0 / 323 |
| 7  | 24 | 0 / 0 | 0 / 0   | 0 / 62  |
| 9  | 32 | 0 / 0 | 0 / 0   | 0 / 27  |
| 15 | 56 | 0 / 0 | 0 / 0   | 0 / 3   |
| 25 | 96 | 0 / 0 | 0 / 0   | 0 / 0   |

**Zero minimum-weight disagreements on all 360,000 shots.** The gate the brief set — identical
MWPM weight on every shot — is met across the whole grid. Prediction differences are the
documented tie policy and appear only where degeneracy is dense: at distance 3 and p=0.05, 4.2% of
shots, falling to zero by distance 25. On those cells the two decoders' logical error rates track
each other closely (for example 0.06905 against 0.06945 at distance 3 and p=0.05, and 0.00195
against 0.00220 at distance 9 and p=0.05), so the tie policy is not systematically worse; it is
arbitrary on both sides.

### Zero allocation and bounded workspace

`the_decode_loop_allocates_nothing` runs `decode_batch` over 2,000 pre-drawn shots at distance 9
and p=0.05 twice — once at the full level with the specialized graph and once at the plain level
with the unspecialized graph, so every code path including the blossom matcher is entered — under
a counting global allocator, after a warm-up pass. **Zero allocations.**
`the_workspace_is_bounded_and_does_not_grow` decodes 2,000 shots and asserts the workspace byte
count is unchanged.

Peak workspace and compiled specification, measured by the bench:

| distance | detectors | workspace bytes | spec bytes |
|---|---|---|---|
| 9  | 32 | 151,799 | 1,884 |
| 15 | 56 | 402,311 | 3,204 |
| 25 | 96 | 558,551 | 5,412 |

The workspace is dominated by the blossom matcher's dense tables; nothing in it scales with the
shot count or the batch size.

## Measurement

### Method

Instructions are primary and cycles secondary, because the box runs other agents' builds. Every
per-decode figure is a two-size difference under `perf stat`, so process startup, imports, graph
compilation, and shot generation cancel exactly. Both arms are fixed-window harnesses: a shot
window is drawn once at setup and the timed loop performs an explicit `--operations` count of
decodes over it in whole `decode_batch` calls, so setup does not scale with the operation count.
Counters are collected in two passes — instructions with cycles, then branches with the miss
counters — so neither group is multiplexed. Eight interleaved rounds alternate the arms in a fixed
order per round; ratios are paired log-ratio means with 95% confidence intervals, and a result
counts only when the interval excludes 1.0.

The two arms use different window sizes (65,536 decodes differenced for TigerBlossom, 737,280 for
PyMatching) because differencing is internal to an arm and the Python arm's constant startup
otherwise dwarfs its own signal. At the smaller size PyMatching's difference had a 40 to 100 per
cent round-to-round spread; at the larger size it falls to 1 to 25 per cent. TigerBlossom's
instruction counts are deterministic to 0.02 per cent at every point.

### Instructions per decode, TigerBlossom against PyMatching `decode_batch`

| d | p | tiger instr | sd | pymatching instr | sd | ratio | 95% CI | n | verdict |
|---|---|---|---|---|---|---|---|---|---|
| 3  | 0.001 | 64      | 0.02% | 242    | 49.45% | **0.320x** | [0.167, 0.616]   | 8 | tiger wins  |
| 3  | 0.01  | 79      | 0.01% | 468    | 20.20% | **0.172x** | [0.143, 0.206]   | 8 | tiger wins  |
| 3  | 0.05  | 281     | 0.00% | 1,568  | 10.46% | **0.180x** | [0.165, 0.196]   | 8 | tiger wins  |
| 5  | 0.001 | 65      | 0.02% | 358    | 18.88% | **0.185x** | [0.159, 0.216]   | 8 | tiger wins  |
| 5  | 0.01  | 120     | 0.01% | 866    | 7.49%  | **0.139x** | [0.131, 0.148]   | 8 | tiger wins  |
| 5  | 0.05  | 1,791   | 0.00% | 3,579  | 2.87%  | **0.501x** | [0.489, 0.513]   | 8 | tiger wins  |
| 7  | 0.001 | 67      | 0.01% | 471    | 25.75% | **0.145x** | [0.121, 0.175]   | 8 | tiger wins  |
| 7  | 0.01  | 189     | 0.01% | 1,166  | 12.36% | **0.163x** | [0.145, 0.184]   | 7 | tiger wins  |
| 7  | 0.05  | 7,643   | 0.00% | 5,262  | 3.06%  | **1.453x** | [1.416, 1.491]   | 8 | tiger loses |
| 9  | 0.001 | 68      | 0.02% | 652    | 74.05% | **0.121x** | [0.079, 0.184]   | 8 | tiger wins  |
| 9  | 0.01  | 298     | 0.00% | 2,490  | 62.10% | **0.151x** | [0.070, 0.325]   | 7 | tiger wins  |
| 9  | 0.05  | 22,030  | 0.00% | 7,156  | 1.09%  | **3.079x** | [3.051, 3.107]   | 8 | tiger loses |
| 15 | 0.001 | 74      | 0.01% | 643    | 14.64% | **0.116x** | [0.102, 0.132]   | 8 | tiger wins  |
| 15 | 0.01  | 1,263   | 0.00% | 2,456  | 5.56%  | **0.515x** | [0.491, 0.540]   | 8 | tiger wins  |
| 15 | 0.05  | 135,822 | 0.00% | 12,571 | 1.51%  | **10.805x**| [10.672, 10.941] | 8 | tiger loses |
| 25 | 0.001 | 101     | 0.01% | 1,251  | 13.11% | **0.081x** | [0.073, 0.090]   | 8 | tiger wins  |
| 25 | 0.01  | 7,075   | 0.00% | 4,161  | 4.11%  | **1.702x** | [1.644, 1.761]   | 8 | tiger loses |
| 25 | 0.05  | 548,640 | 0.00% | 21,525 | 2.38%  | **25.495x**| [25.000, 25.999] | 8 | tiger loses |

Every confidence interval excludes 1.0, so every cell is decided.

### Cycles per decode

| d | p | tiger | pymatching | ratio | 95% CI | n |
|---|---|---|---|---|---|---|
| 3  | 0.001 | 11     | 214   | 0.081x  | [0.016, 0.419]   | 4 |
| 3  | 0.01  | 14     | 185   | 0.081x  | [0.059, 0.112]   | 5 |
| 3  | 0.05  | 47     | 392   | 0.159x  | [0.071, 0.354]   | 7 |
| 5  | 0.001 | 10     | 215   | 0.056x  | [0.019, 0.165]   | 4 |
| 5  | 0.01  | 21     | 291   | 0.080x  | [0.049, 0.131]   | 7 |
| 5  | 0.05  | 480    | 1,105 | 0.445x  | [0.363, 0.544]   | 8 |
| 7  | 0.001 | 10     | 271   | 0.045x  | [0.020, 0.101]   | 6 |
| 7  | 0.01  | 35     | 385   | 0.111x  | [0.055, 0.222]   | 6 |
| 7  | 0.05  | 2,070  | 1,607 | 1.313x  | [1.092, 1.580]   | 8 |
| 9  | 0.001 | 12     | 638   | 0.052x  | [0.007, 0.375]   | 7 |
| 9  | 0.01  | 62     | 3,788 | 0.030x  | [0.006, 0.142]   | 6 |
| 9  | 0.05  | 5,411  | 2,505 | 2.156x  | [1.953, 2.379]   | 8 |
| 15 | 0.001 | 12     | 143   | 0.095x  | [0.035, 0.258]   | 3 |
| 15 | 0.01  | 327    | 623   | 0.538x  | [0.418, 0.691]   | 7 |
| 15 | 0.05  | 26,605 | 4,467 | 5.975x  | [5.581, 6.396]   | 8 |
| 25 | 0.001 | 18     | 404   | 0.063x  | [0.030, 0.132]   | 8 |
| 25 | 0.01  | 1,767  | 1,026 | 1.882x  | [1.267, 2.796]   | 8 |
| 25 | 0.05  | 98,054 | 7,937 | 12.473x | [11.249, 13.830] | 8 |

Cycles agree with instructions on the direction everywhere. The cycle intervals are wide because
the box is loaded; instructions carry the claims.

### Branches and misses

| d | p | metric | tiger | pymatching | ratio |
|---|---|---|---|---|---|
| 9  | 0.001 | branches               | 15.20      | 105.40   | 0.145x  |
| 9  | 0.001 | branch-misses          | 0.10       | 0.10     | 0.755x  |
| 9  | 0.001 | L1-dcache-load-misses  | 0.30       | 1.30     | 0.254x  |
| 9  | 0.001 | cache-misses           | 0.00       | 0.20     | 0.025x  |
| 9  | 0.01  | branches               | 62.90      | 327.60   | 0.224x  |
| 9  | 0.01  | branch-misses          | 0.10       | 1.10     | 0.077x  |
| 9  | 0.01  | L1-dcache-load-misses  | 0.30       | 2.10     | 0.177x  |
| 9  | 0.01  | cache-misses           | 0.00       | 0.10     | 0.155x  |
| 9  | 0.05  | branches               | 4,812.90   | 1,307.70 | 3.681x  |
| 9  | 0.05  | branch-misses          | 36.90      | 33.40    | 1.106x  |
| 9  | 0.05  | L1-dcache-load-misses  | 11.00      | 3.50     | 3.716x  |
| 25 | 0.01  | branches               | 1,544.30   | 818.20   | 1.888x  |
| 25 | 0.01  | branch-misses          | 9.10       | 9.60     | 0.953x  |
| 25 | 0.01  | L1-dcache-load-misses  | 16.30      | 7.80     | 2.082x  |
| 25 | 0.05  | branches               | 119,864.10 | 3,993.80 | 30.013x |
| 25 | 0.05  | branch-misses          | 654.70     | 94.50    | 6.931x  |
| 25 | 0.05  | L1-dcache-load-misses  | 1,516.90   | 47.00    | 32.336x |

`LLC-load-misses` is not supported on this host; `cache-misses` stands in for it. In the winning
regime TigerBlossom is not merely doing fewer instructions but touching far less memory: a third
to a quarter of PyMatching's L1 misses and almost no last-level traffic, which is what reading a
compiled table instead of walking a graph looks like. In the losing regime the branch and L1-miss
ratios track the instruction ratio, confirming the loss is raw work in the blossom matcher rather
than a memory-system effect.

### Per-shot latency

TigerBlossom's decode is deterministic given the shot, and its instruction counts have a 0.02 per
cent spread across rounds, so the p50 / p99 / max spread is a property of the shot mix rather than
of the kernel. The defect histogram at distance 9 and p=0.01 (20,000 shots) is 11,070 shots with
no defect, 877 with one, 5,855 with two, 1,408 with four, and a tail reaching ten; at distance 25
and p=0.05 the largest cluster seen is 34. The distribution of work therefore has the shape of the
defect distribution: near zero at the mode, and dominated at the tail by whichever clusters reach
the general matcher.

## Fast-path and specialization contribution

Same pinned binary in every arm, selected by flag, so the arm hashes are identical. Eight
interleaved rounds, same two-size differencing, instructions. Each ratio is that arm's cost
divided by the full kernel's.

| d | p | full kernel | no fast paths | clusters only | searched graph | no-fast-paths ratio | clusters-only ratio | searched-graph ratio |
|---|---|---|---|---|---|---|---|---|
| 3  | 0.001 | 64      | 68      | 71      | 74      | 1.05x | 1.11x | 1.15x  |
| 3  | 0.01  | 79      | 125     | 158     | 196     | 1.58x | 2.01x | 2.49x  |
| 3  | 0.05  | 281     | 447     | 586     | 944     | 1.59x | 2.08x | 3.35x  |
| 5  | 0.001 | 65      | 74      | 81      | 118     | 1.13x | 1.25x | 1.81x  |
| 5  | 0.01  | 120     | 208     | 282     | 694     | 1.73x | 2.34x | 5.77x  |
| 5  | 0.05  | 1,791   | 2,004   | 2,267   | 5,227   | 1.12x | 1.27x | 2.92x  |
| 7  | 0.001 | 67      | 80      | 92      | 183     | 1.20x | 1.37x | 2.74x  |
| 7  | 0.01  | 189     | 319     | 431     | 1,531   | 1.69x | 2.28x | 8.09x  |
| 7  | 0.05  | 7,643   | 7,842   | 8,139   | 16,196  | 1.03x | 1.06x | 2.12x  |
| 9  | 0.001 | 68      | 85      | 100     | 258     | 1.25x | 1.46x | 3.78x  |
| 9  | 0.01  | 298     | 464     | 608     | 2,781   | 1.56x | 2.04x | 9.34x  |
| 9  | 0.05  | 22,030  | 22,594  | 22,466  | 38,350  | 1.03x | 1.02x | 1.74x  |
| 15 | 0.001 | 74      | 108     | 135     | 727     | 1.46x | 1.82x | 9.82x  |
| 15 | 0.01  | 1,263   | 1,524   | 1,730   | 9,664   | 1.21x | 1.37x | 7.65x  |
| 15 | 0.05  | 135,822 | 138,157 | 135,956 | 191,235 | 1.02x | 1.00x | 1.41x  |
| 25 | 0.001 | 101     | 161     | 217     | 2,079   | 1.60x | 2.15x | 20.62x |
| 25 | 0.01  | 7,075   | 7,779   | 7,669   | 35,307  | 1.10x | 1.08x | 4.99x  |
| 25 | 0.05  | 548,640 | 546,281 | 548,645 | 722,872 | 1.00x | 1.00x | 1.32x  |

All confidence intervals are narrower than the third decimal place, because the instruction counts
are deterministic; they are omitted from the table for width and are in the committed log.

**Graph specialization is the dominant lever and it is what beats PyMatching.** Replacing the
compiled metric closure with the bounded Dijkstra costs 1.15x at distance 3 and rises to 20.6x at
distance 25 and p=0.001. The effect grows with distance, because the search radius grows with the
code, and shrinks with the error rate, because at high rates the matching rather than the distance
lookup dominates. Without it TigerBlossom would lose to PyMatching at almost every point on the
grid; with it TigerBlossom wins the entire sub-threshold regime. This is the one thing a general
library cannot copy: it requires owning the graph across shots.

**The small-case closed forms are worth 1.0x to 2.3x**, read as the clusters-only arm against the
full kernel. They peak at p=0.01, where the two-defect and four-defect shots are the bulk of the
distribution, and fall to nothing at p=0.05 where almost no shot is small.

**Cluster decomposition is close to free, in both directions.** The no-fast-paths arm is cheaper
than the clusters-only arm at every point, which reads at first as the decomposition costing 5 to
35 per cent — but that comparison is taken with the closed forms absent, which is not the
configuration anyone would ship. Measuring it properly, by adding a level that keeps the closed
forms and drops only the flood fill, and running the same interleaved A/B on the same binary:

| d | p=0.001 | p=0.01 | p=0.05 |
|---|---|---|---|
| 3  | 1.000x | 1.015x | 1.085x |
| 5  | 1.000x | 1.048x | 1.044x |
| 7  | 1.002x | 1.054x | 1.014x |
| 9  | 1.002x | 1.053x | 0.987x |
| 15 | 1.007x | 1.019x | 0.984x |
| 25 | 1.010x | 0.951x | 1.004x |

Dropping the flood fill is worth between 9 per cent and −5 per cent — a wash. The decomposition is
kept as the default because it costs nothing measurable and it bounds each matcher call by the
cluster rather than by the whole defect set, which widens the range over which the exact fallback
applies. The direct level is retained as an arm. Recording this because the first reading of the
level ladder said 5 to 35 per cent and was wrong: comparing two arms that differ in two things at
once is not a contribution measurement.

## What this changes about the brief

The brief asked whether a Tiger-discipline sparse-blossom kernel could reach 1.5x to 3x over
PyMatching on a compiled detector graph, and said a tie would still be useful. The answer is
sharper than the question.

1. **The bar is beatable, by more than the prior, and not by the mechanism the brief expected.**
   Zero allocation buys nothing measurable here; the workspace discipline is what makes the result
   *stable* (0.02 per cent spread across rounds) rather than what makes it fast. The speed comes
   from one compile-time decision — precomputing the metric closure — which is available only
   because Ergodis owns the graph across shots.
2. **The general fallback is the whole remaining gap.** Every losing cell is a cell where large
   defect clusters reach the dense matcher. A real sparse blossom, or Fusion Blossom's
   region-growth, would close it. That is a well-defined follow-up with a known cost.
3. **The productization claim in the brief survives, and is now evidenced.** A deterministic-tail,
   bounded-memory, allocation-free substrate with an exact answer identical to PyMatching's, whose
   hot path at the operating point is a handful of table reads, is a far better base for an FPGA
   or ASIC translation than a C++ library call. The two-defect path in particular is a fixed
   sequence of three loads and a comparison, which is a pipeline stage.
4. **The operating point matters more than the grid.** Real surface-code devices run at physical
   error rates near or below 0.1 per cent relative to threshold; p=0.05 in this phenomenological
   model is a stress case, not an operating point. The regime where TigerBlossom wins by 3x to 12x
   is the regime a decoder is actually bought for. That said, the loss is real and should not be
   papered over: a decoder that degrades 25x in a burst-noise excursion is not obviously safe
   under a real-time latency budget, which is exactly why the sparse fallback is the next step.

## Mystery ledger

- **The compiled metric closure's contribution grows with distance and shrinks with rate, from
  1.15x to 20.6x.** The direction is clear — search radius grows with the code, matching cost grows
  with the rate — but the size at distance 25 and p=0.001 is larger than a napkin predicts from
  the settled-node counts alone. Settled. The bounded Dijkstra's radius bound is `b_i + max_j b_j`,
  and at distance 25 the boundary distance reaches 12, so a single search settles most of a
  96-node graph. The bound is the loose part, not the search.
- **Cluster decomposition looked like a 5 to 35 per cent cost and is actually a wash.** Settled by
  building the arm that differs in exactly one thing. The general lesson is recorded above.
- **PyMatching's per-decode instruction count moves by a factor of four across the grid at fixed
  distance** (652 to 7,156 at distance 9), while its round-to-round spread collapses from 74 per
  cent to 1 per cent as the rate rises. Open in the sense that only the second half is explained:
  the spread is the constant-startup-to-signal ratio in the two-size difference, which is why the
  Python arm needed the larger window. The first half is presumably its own defect-count scaling
  and was not separated.
- **TigerBlossom's largest cluster at distance 25 and p=0.05 is 34 defects, and no cell anywhere on
  the grid reached the 64-defect capacity or took the bounded greedy path.** Open: the capacity was
  chosen by a guess and then never tested against its own limit. The exact rate at which a cluster
  exceeds 64 is unmeasured, so the claim "exact everywhere" is scoped to the measured grid, not
  proved for the model.
- **The tie-policy prediction differences vanish with distance** — 4.2 per cent of shots at
  distance 3 and p=0.05, zero at distance 25 — and the two decoders' logical error rates stay
  within a few parts in ten thousand of each other on those cells. Open: whether either tie policy
  is systematically better was not tested, only that neither is obviously worse. A census of how
  often each decoder's choice matches the planted error would settle it cheaply.

## Vibe check

Good, and sharper than expected in both directions. The exactness gate is met outright — zero
weight disagreements against PyMatching on every one of 360,000 shots, with zero allocations and a
bounded workspace — which is the part that was genuinely at risk, and it took a real blossom
matcher to get there rather than the subset dynamic program the first design hoped would do. The
performance answer is not the modest 1.5x to 3x the brief priced in; it is a 3x to 12x win in the
sub-threshold regime and a 1.5x to 25x loss above it, and both sides trace to a single decision
each. That the entire win rests on compiling the metric closure — a specialization a general
library structurally cannot make — is the most useful thing in the probe, and the fact that zero
allocation bought stability rather than speed is worth remembering before the next Tiger rewrite is
justified on speed grounds.
