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

### Two-anchor parallel checkpoint

Static contiguous anchor partitioning gives each Rayon task its own pre-sized
DFS workspace and 128-byte-aligned result record. The compiled filters are
read-only, and counters/incumbents are reduced deterministically only after
join. On cores 2 and 3, the retained 11-round median search fell from 0.15786 s
to 0.07859 s (2.01x), with exactly the same 12,268,521 candidates. Cached
preparation plus search was 0.09769 s.

The matched Gurobi 13.0.2 control used `Threads=2` and took 1.87536 s across
the same two anchored exact solves, leaving native ahead by 23.86x on search
and 19.20x end-to-end. Perf counted zero context switches and migrations in
both native runs. Two threads retired essentially the same total instructions
as one thread; cache misses rose 3.2%, consistent with concurrent read-only
filter pressure rather than duplicated work. `perf c2c` could not open the AMD
IBS load-latency event under the host's `perf_event_paranoid=2`, so direct HITM
sampling remains an optional privileged confirmation rather than a release
gate.

### Root splitting, YBWC, and bound-pulse checkpoint

The first direct weight-12 parallelization reproduced the Queens solver's
classic cutoff failure: independent local incumbents inflated eight-thread work
from 134.4 million to 258.3 million candidates. The corrected scheduler uses
three layers:

1. exact first-extension ESU branches, statically round-robin partitioned;
2. anchor-level Young-Brothers-Wait, fully resolving the elder anchor before
   searching younger anchors against its frozen bound;
3. rare monotone bound pulses through one 128-byte mailbox per worker, polled
   every 16,384 candidates and at branch boundaries.

Only a verified scalar bound is broadcast. Witnesses, DFS frames, counters, and
results remain worker-local. Relaxed mailbox ordering is safe because a stale
bound can only add work. A 1K/4K/16K/disabled sweep found that 16K retained the
work reduction with roughly 1% no-update polling overhead.

Iterative deepening over admissible parity makes direct optimization insensitive
to a loose caller bound: maximum weights 12 and 24 both terminate at distance 12
after about 85.9 million candidates. Retained 11-round pinned results are:

| workload | threads | median search | speedup | median candidates | Welch t vs 1t |
|---|---:|---:|---:|---:|---:|
| certify weight 12 | 1 | 0.157539 s | 1.00x | 12,268,521 | -- |
| certify weight 12 | 2 | 0.085615 s | 1.84x | 12,268,521 | 52.93 |
| certify weight 12 | 4 | 0.045352 s | 3.47x | 12,268,521 | 74.83 |
| certify weight 12 | 8 | 0.039009 s | 4.04x | 12,268,521 | 90.25 |
| direct, initial bound 24 | 1 | 1.072201 s | 1.00x | 85,922,184 | -- |
| direct, initial bound 24 | 2 | 0.553233 s | 1.94x | 85,922,184 | 151.81 |
| direct, initial bound 24 | 4 | 0.299110 s | 3.59x | 85,953,731 | 238.07 |
| direct, initial bound 24 | 8 | 0.242861 s | 4.42x | 86,004,025 | 212.86 |

The eight-thread direct run has about 0.10% work inflation, down from 92% in the
negative control. Five-round perf runs retired within 0.10% of the one-thread
instruction count, added about 2% cache misses, and recorded zero context
switches or CPU migrations. CPUs 0--3 are physical performance cores; the
eight-thread point adds their SMT siblings 12--15, so the modest gain beyond
four threads is a hardware topology result rather than a scheduler ceiling.

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
