# C985 native CSS backend persistence and scaling plan

**Date:** 2026-08-29

**Status:** persistence gate passed; parallel-anchor implementation next; private

## Outcome target

Turn the first native C997 result into a reusable exact backend rather than a
single-instance spike. The retained one-core checkpoint is 0.1244 seconds of
compilation plus a median 0.1502-second exact search, versus 3.8080 seconds for
the retained one-thread Gurobi 13.0.2 control.

## Ordered work

1. Persist the source-bound compiled syndrome filters and packed adjacency.
2. Reload them into the native in-memory layout with strict shape, version,
   source-fingerprint, truncation, and trailing-byte checks.
3. Measure compile, write, page-cache load, cold load, and warm search
   separately. Retain the uncached path as the checker and fallback.
4. Parallelize independent orbit anchors, then bounded root subtrees if anchor
   count is too small for the machine.
5. Run the native backend over a diversified qLDPC suite before generalizing
   the C997 speed claim.

## Persistent artifact

The artifact is a compiler cache, not a portable proof by itself. It contains:

- a versioned magic header;
- a cryptographic fingerprint of the physical and logical matrices;
- exact dimensions and theorem flags;
- packed column syndromes and logical observations;
- packed coordinate adjacency;
- exact one/two-column tables;
- no-false-negative three/four-column reachability filters.

The loader must fail closed on a source mismatch or malformed length. Evidence
continues to bind the source input, artifact, runner, exact witness replay, and
uncached checker. Create-only output prevents accidental replacement.

Acceptance gate: cached preparation plus median search should improve cold
runtime by at least 1.5x, without increasing steady search RSS or changing any
candidate, pruning, distance, or witness counter.

### Persistence checkpoint

The version-one artifact uses SHA-256 for source identity and SIMD BLAKE3 for
payload corruption detection. Large little-endian bitmap sections transfer
directly into their final boxed-word storage, so loading does not allocate a
second file-sized byte buffer. Small structural fields are recomputed from the
source and compared before the artifact is accepted.

On the pinned one-core C997 run, the retained artifact load took 0.01264 s and
the 11-round median exact search took 0.15786 s, for 0.17051 s cached
end-to-end. This is 1.61x faster than the prior 0.27463 s cold native checkpoint
and 22.33x faster than the retained 3.80805 s one-thread Gurobi 13.0.2 control.
Repeated warm-process loads reached about 0.0059 s. Candidate counts, pruning
counters, optimum, and witness were unchanged.

## Parallel search discipline

Gurobi 13.0.2 supports parallel MIP. Every parallel comparison therefore runs
both backends at matched thread counts, while the retained one-thread result
remains the algorithmic-efficiency control.

The native implementation will share only immutable compiled columns,
neighbors, and reachability filters. Each worker owns its complete DFS stack,
support/syndrome frames, counters, incumbent, witness, and buffered evidence.
No allocator, hash table, atomic counter, incumbent lock, or output sink is
touched from the hot loop.

Worker records use explicit cache-line separation. Work descriptors are compact
and read-only after dispatch; result slots are one cache line or more apart.
Reduction occurs after join in deterministic anchor/root order. The first
implementation uses static anchor partitioning. Work stealing is admitted only
after measurement shows material imbalance, and then through coarse subtrees
rather than per-node queues.

Validation includes:

- exact sequential/parallel result and counter parity;
- allocation-envelope tests per worker;
- 1/2/4/8-thread interleaved rounds against matched-thread Gurobi;
- `perf c2c` or equivalent cache-line contention inspection;
- context switches, migrations, LLC misses, cycles/support, and scaling
  efficiency;
- a negative gate for speedup caused only by extra duplicated search work.

## Expected sequence

Persistence should make effective cold execution approach the current
0.150-second warm search. Two independent C997 anchors then provide the first
contention-free parallel split. If they balance poorly, compile a bounded set
of canonical ESU root subtrees before starting workers. The near-term target is
about 50x over the retained one-thread Gurobi result, but measured matched-thread
Gurobi ratios—not that target—determine the claim.
