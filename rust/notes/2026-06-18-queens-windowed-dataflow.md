# Queens n=16 windowed dataflow solver shape

Date: 2026-06-18
Goal: get n=16 below 3 minutes by replacing the late random-TT tail with dense,
reusable window computations.

## Current diagnosis

`iso-flat` is already good at raw node throughput, but its late n=16 wall is the
flat transposition table:

- The warmed hot path is dominated by `IsoFlat::wins_inc` and `band_entry`.
- `wins_inc` spends hot cycles on random TT slot load/fingerprint/value tests,
  move filtering, and child key generation.
- Throughput starts strong, then falls as the 17 GB TT fills and evicts.
- Larger TT is not currently viable on this machine state: swap is zram and the
  default 17.18 GB table is already close to the DRAM cliff.

The negative experiment from this turn matters: solving a dense `k=8` local DP
per parent entry reduced TT fill but was still slower than baseline. The problem
was not the dense kernel; it was redoing the same dense windows too many times.

## Target shape

Use a dataflow loop:

```text
pump frontier -> group/window -> dense local solve -> merge boundary values -> repeat/search
```

The flat TT should remain the coarse global table for large positions. Once a
subtree crosses a small-window boundary, the solver should stop issuing random
global probes for every descendant and instead move into an implicit-keyed dense
representation.

The value of a window is keyed by row position in a dense table, not by a 55-bit
fingerprint in a random slot. This matches the SoA/cold-sidecar note: splitting
the live random TT slot is bad, but implicit keying is good when membership is
known by construction.

## Layer 1: complete labelled `W8`

The first concrete primitive is a complete value table for all labelled
8-vertex Node-Kayles graphs:

```text
W_k[edge_code] -> win/loss
```

For `k=8`, the labelled graph has `8 * 7 / 2 = 28` possible edges:

- rows: `2^28 = 268,435,456`
- value bitset: 32 MiB
- no fingerprint
- no open addressing
- one indexed bit lookup at runtime

Build `W8` bottom-up by vertex count:

```text
W0[0] = loss
for k in 1..=8:
    for every labelled edge_code on k vertices:
        Wk[edge_code] =
            exists move i such that W_child[project(edge_code, alive_after_i)] == loss
```

This pre-pass computes every reusable `k=8` tail once. Runtime entry is:

1. Extract the 8 available vertices in `q.order`.
2. Build the 28-bit labelled edge code.
3. Return `W8[code]`.

No recursive tail, no global TT probe, and no rework across parents.

## Layer 2: frontier-specific `K > 8`

Full labelled tables stop being sane after `k=8`:

- `k=9`: `2^36` rows, 8 GiB for one value bitset
- `k=10`: impossible as a full labelled table

For `k=9..12`, use frontier-specific chunks:

1. During DFS, pump positions at a chosen boundary ply/popcount into chunk queues.
2. Canonicalize or bucket them by a cheap local graph signature.
3. For each chunk, build a dense local row space only for reachable/projected
   states in that chunk.
4. Solve the chunk with linear passes over compact arrays.
5. Publish only boundary values back to the shared TT or parent queue.

This tolerates some recompute inside a chunk, but prevents the expensive kind:
the same boundary graph being rediscovered independently by many parents.

## Data layout

For full `W8`:

```rust
struct W8 {
    value_bits: Box<[u64]>, // 2^28 bits
}
```

For frontier chunks:

```rust
struct WindowChunk {
    keys: Box<[u64]>,      // canonical/local row keys, sorted
    closed: Box<[u16]>,   // packed remove masks, SoA by row
    value: Box<[u64]>,    // bitset or byte values
    index: ChunkIndex,    // minimal perfect/ribbon/sorted lookup
}
```

The hot pass over a chunk should be linear:

```text
for row in chunk.rows_in_dependency_order:
    value[row] = any child row is loss
```

The global TT only sees boundary values. It should not be touched for every
descendant inside a small window.

## SIMD direction

Start scalar and contiguous. SIMD is only useful after the row space is dense.

Potential SIMD passes:

- Build child masks for several rows at once.
- For byte values, gather child bytes and OR inverted loss lanes.
- For bitset values, process 64 row states per word when child projection has a
  regular mask relation.

Do not start with SIMD in the recursive DFS. First make the data dense enough
that vector lanes have useful adjacent work.

## Microbench plan

Measure these primitives independently before wiring a solver:

1. `W8` pre-pass build time and memory.
2. Runtime edge-code extraction from a board mask.
3. `W8` lookup throughput.
4. Chunk projection cost for `k=9..12`.
5. Linear chunk solve throughput over synthetic frontier chunks.

The first microbench added for this plan is `src/bin/dense_window_bench.rs`,
which builds labelled `W_k` tables up to `k=8`.

Measured on 2026-06-18:

- `W7`: 2,097,152 labelled graphs in about 0.02s.
- `W8`: 268,435,456 labelled graphs, 32 MiB value bitset, in about 2.0s.

That makes full labelled `W8` practical as a startup pre-pass. It does **not**
make full labelled `W9` practical; `W9` would be an 8 GiB value bitset before
temporary build state.

## New solver plan

Add a new solver rather than mutating `iso-flat`:

```text
iso-window
```

Initial stages:

1. `iso-window = iso-flat + W8 pre-pass lookup`.
2. Add counters for W8 entries, hits, and TT bypassed descendants.
3. Add a pump queue at a `k=9..12` boundary, initially single-process/in-memory.
4. Replace recursive per-entry dense solve with grouped chunk solve.
5. Only after chunk grouping wins, consider SIMD and bit-packed row passes.

The expected win is not higher reported nodes/sec. It is lower wall time from
avoiding late TT fill/eviction and replacing random global probes with dense
local work.

## First implementation result

`iso-window` now exists as a first-stage solver:

- It reuses `iso-flat`.
- It builds a process-global `W8` table.
- At `popcount == 8`, it computes the labelled 28-bit edge code and returns the
  precomputed value instead of descending through the flat TT.

With a 13.6 GB capped TT (`QUEENS_TT_SLOTS=1700000000`) on n=16, this lowered
TT fill slightly but did not materially beat `iso-flat`:

- capped `iso-flat`: 33/36 roots at 2m04s, TT 89.2% full.
- capped `iso-window`: 33/36 roots at 2m04s, TT 88.2% full.

Conclusion: exact `W8` is good infrastructure but too shallow to reach the
sub-3m target by itself. The next useful piece is grouped `k=9..12` frontier
chunks that solve each boundary graph/chunk once and merge the result, rather
than per-parent local recompute.

An attempted single-entry `pc==9` evaluator was also negative. It used `W8` as
the base table and evaluated each 9-vertex child boundary independently. With
the same capped TT it reached only 30/36 roots at 2m04s, with much lower reported
node rate. That confirms the required granularity: `k=9..12` must be grouped and
solved once per chunk/frontier, not recomputed independently at every parent.

A bounded exact W9 direct-mapped cache was also tried as an intermediate merge
layer:

- 128 MiB cache: about 52% hit rate after ~1B W9 boundary queries, but only 3/36
  roots at 2m06s.
- 512 MiB cache: about 66% hit rate at 1m02s, but still only 2/36 roots and
  ~16M/s reported nodes.

The W9 stream has enormous reuse, but one-position-at-a-time cache/eval is still
the wrong shape. The next step is to collect W9/W10 boundary rows into chunk
queues, sort/group by edge-code or canonical bucket, evaluate each unique row
once, and replay results to parents.
