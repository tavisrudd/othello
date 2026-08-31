# Ergodis performance contract

**Private monorepo contributor document. Do not export, publish, package, or
include in a release manifest or standalone synchronization.**

This document is mandatory reading before editing Ergodis core Rust code under
`src/`, or before designing, profiling, optimizing, or benchmarking that code.
It specializes the repository-wide rules to Ergodis. Also read
`../../../notes/queens-othello-perf-playbook.md` in full before such work; the
shared playbook remains authoritative where it is stricter.

## Non-negotiable solve invariant

The Ergodis solve hot loop is completely allocation-free.

This includes the allocator calls hidden by container growth, formatting,
cloning owned data, error construction, logging, serialization, channels, and
library helpers. Allocate and presize every worker workspace, frame stack,
counter block, witness slot, mailbox, and output buffer before search begins.
The loop may mutate caller- or worker-owned fixed-capacity storage, but it must
never grow it. Capacity exhaustion must return through a predesigned bounded
path; it must not fall back to allocation.

Every new solve kernel and every hot-path change needs an allocation-count
regression that enters the real loop repeatedly after setup and observes zero
allocations. “Only once,” “amortized,” and “only on exceptional states” fail
this gate. Compilation and result serialization may allocate outside search,
but their boundaries must be explicit.

Every operation admitted to a solve hot loop must be deliberately profiled and
costed. Every change touching that loop requires a retained before/after
profile and an interleaved A/B with hardware performance counters. This applies
to correctness fixes, refactors, instrumentation, and new theorem checks as
well as changes labelled optimization. A hot-loop change is incomplete until
its instruction, cycle, branch, branch-miss, and relevant cache effects are
understood and recorded.

## Order of attack

1. Preserve exact semantics, witness replay, and certificate verification.
2. Seek a theorem or equivalent predicate that visits fewer states, performs
   fewer transitions, or makes a bound cheaper to decide.
3. Fix representation, memory traffic, compilation, and artifact loading.
4. Profile the retained workload before changing instructions, branches, ISA,
   or parallel scheduling.

Fermi-estimate the expected leverage before implementing. If measurement
disagrees materially, treat the cost model as wrong and profile at a wider
level. Never call a measured result a floor or hard limit.

Skipping an optional rejection filter is exact only when it can add work but
cannot reject a valid solution. Replacing a predicate is exact only when its
equivalence or one-sided safety is stated and tested. Keep explicit negative
controls: a plausible optimization that loses is useful design evidence.

## Tiger-style hot data and control flow

In addition to zero allocation, candidate/state/transition loops require:

- no recursion over the search tree; traversal uses an explicit presized,
  bounded iterative stack even when current instances appear shallow;
- presized contiguous storage and range-sized integer IDs;
- no `String`, `Vec`, `HashMap`, trait object, reference-counted pointer, or
  other owned dynamic container inside a hot record;
- no locks, environment reads, serialization, filesystem or socket I/O,
  formatting, or logging;
- no run-constant branch: dispatch once outside the loop, preferably to a
  const-generic or target-specialized monomorphization;
- no per-node instrumentation in production instantiations;
- no raw pointers merely for speed; unavoidable `unsafe` requires a local
  `SAFETY` invariant and a measured advantage; and
- no repeated calculation of a value that can be accumulated cheaply and
  reconciled once at a boundary.

The complete Tiger-style record rules are mandatory:

1. Hot structs contain plain data only: no `String`, `Vec`, `HashMap`, or other
   owned dynamic container. Use inline fixed arrays, boxed slices owned by the
   cold workspace, or pool indices represented by integer ranges.
2. Storage is contiguous: use flat slices or vectors, never per-element boxes,
   linked structures, reference-counted records, or trait objects.
3. There is no pointer chasing in the loop body. Read compact indices and
   resolve their backing slice once at scan entry.
4. Every hot struct has explicit `#[repr(C)]` or `#[repr(transparent)]`; never
   rely on Rust's default representation. Cache-line records use
   `#[repr(C, align(64))]` (or a larger explicitly justified line multiple).
5. Choose and assert one stride shape: a cache-line-sized record such as 64,
   128, or 192 bytes with `#[repr(C, align(64))]`, or a compact 8-, 16-, or
   32-byte `#[repr(C)]` record with several entries per line. Assert both size
   and alignment. Worker-written records are at least one whole cache-line
   stride apart; adjacent array elements must not false-share.
6. Order fields from largest alignment to smallest with hottest fields first.
   Use explicit padding for intentional gaps and move cold or tuning fields to
   a sibling struct.
7. Use compile-time assertions such as
   `const _: () = assert!(size_of::<T>() == EXPECTED && align_of::<T>() == EXPECTED_ALIGN);`
   so a layout regression fails the build.
8. Hot in-memory representations do not serialize or deserialize themselves.
   Serialization uses a separate cold schema and boundary.

No raw pointer is admitted merely for performance; references, slices, and
range-indexed pools normally provide the same layout safely. Any unavoidable
`unsafe` block needs a local `SAFETY` comment stating its invariant and a
measured benefit. Size integer fields to their proven value range rather than
using `usize`; validate at the input boundary and cast to `usize` only at an
actual indexing or capacity operation.

Adding or reordering a hot field requires renewed compile-time size/alignment
assertions, cache-line analysis, and single-/parallel-counter A/B evidence.

Materialize expensive child state only after cheaper exact rejection tests.
Stop monotone bounds as soon as they decide the predicate. Prefer equivalent
comparisons that remove division or normalization in the loop. Remove
redundant writes and derive aggregate counters at worker exit when measurement
supports it.

## Compilation, state, and evidence memory

Compiler performance is part of end-to-end performance. Compile observable
types rather than syntactic duplicates when a bounded-multiplicity or
contextual quotient proves that safe. Project once, sort or canonicalize once,
and reuse presized work arrays. Abandon an optional filter before constructing
it when a rigorous saturation/cost test says it cannot pay.

Choose representation from measured density and access pattern: fixed words
for small dense universes, bitmaps for dense membership, sorted or delta-coded
IDs for sparse monotone sets, and compact CSR/range pools for relations.
Elias--Fano and Roaring are candidates, not defaults. Every compressed
representation needs an exact crossover policy and replay test.

Large evidence must stream through `Write`/`Read` or an equivalent bounded
interface. Do not retain a transcript or duplicate a file-sized payload in
memory. Serialization happens outside search. Preflight hard record and byte
limits before writing. Persistent compiled artifacts are caches, not proofs:
bind them to source fingerprints and schema versions, check lengths and
trailing bytes, fail closed, and load large sections directly into their final
storage when possible.

Do not put large build, profile, or evidence artifacts in `/tmp`; it is tmpfs
on the development host. Use the designated persistent cache location.

## Hardware specialization

Detect capabilities and dispatch outside the hot loop. Specialize whole
kernels when that enables inlining and exposes POPCNT, BMI, SIMD, or GF
operations across the actual fixed-width state. Do not assume the widest ISA
is fastest: compare portable and relevant target variants on the retained
workload. Inspect generated code when a hot helper unexpectedly misses a
hardware instruction or remains out of line.

Branchless code is not automatically faster. Measure cycles and dependency
chains as well as branch counts and misses. A change that reduces instructions
or mispredictions but lengthens dependent loads is a regression. Avoid adding
an incremental side structure when recomputing from already-hot fixed words is
cheaper.

## Parallel search and control plane

Parallelism must not disguise duplicate work. Report exact state or candidate
counts by thread count as well as wall time.

Search threads must not contend with one another. This forbids shared mutable
queues, allocator locks, global counters, incumbent locks, and separate
worker-written fields that occupy the same cache line. Read-only compiled data
may be shared. Each thread owns every mutable byte it changes during search;
rare controller-to-worker mailboxes are isolated per worker and never create a
worker-to-worker write path.

Search threads also never busy-poll. They do not spin, wait for an epoch, or
repeatedly load shared state until it changes. An admitted control or pulse
check is a bounded safe-point action guarded by a measured coarse work counter;
the worker performs useful search between checks and stale state can only add
work. Blocking, event waits, socket handling, fan-out, and retry loops belong
outside the solve workers.

- Share immutable compiled data only.
- Give every worker a presized workspace, iterative stack, counters, witness
  slot, and fixed evidence buffer.
- Separate worker-written records and mailboxes by cache line; check for false
  sharing and contention.
- Prefer deterministic coarse roots/subtrees and post-join reduction. Add
  stealing only after measured imbalance, at coarse exact boundaries.
- Establish useful bounds before opening speculative siblings. Propagate only
  verified monotone scalar facts through rare cache-line-isolated pulses; stale
  values may add work but must never affect correctness.
- Check at a measured power-of-two candidate stride. Do not add unconditional
  root/branch-boundary probes. The ordinary no-message path must have no
  measurable overhead.
- Keep plan evolution, socket handling, evidence merging, and serialization in
  watcher, daemon, or other low-priority threads, never search workers.

For rare monotone cross-worker facts, use **controller fan-out** when
measurement supports it. These are guarded safe points, not busy polling:

- allocate separate cache-line-isolated publication and inbox lines per worker
  before search;
- each solver writes only its own publication line and otherwise works
  independently; a blocking off-path controller reduces published facts and is
  the sole writer of every inbox line;
- guard the pulse behind a measured power-of-two work counter, so the normal
  iteration performs only the counter test;
- at a pulse, check only the worker's dedicated local `AtomicBool` with relaxed
  ordering and load its payload only on change;
- wake the controller through an event-driven, allocation-free publication
  path; complete a ready handshake before search starts and do not inherit a
  pinned worker's one-CPU affinity; and
- require a one-sided proof that delayed or stale propagation can only add
  work, never alter the verdict, witness validity, or certificate.

The controller may scan all publications only after an event; workers never do.
A global atomic, ring gossip, an all-mailbox worker scan, or all-to-all RMW may
win on a tiny thread count, but is not admitted without explicit contention and
latency evidence. Split pulse-disabled and pulse-enabled kernels outside the
hot loop so the disabled production instantiation contains neither the
run-constant branch nor atomic loads.

Record topology and affinity. Scaling across SMT siblings or heterogeneous
cores is a hardware result, not automatically a scheduler limit.

Every change that can affect solving must be tested in both single-thread and
parallel modes. Require exact verdict and witness parity, deterministic merged
evidence, and explain any difference in work counts. For hot-loop changes,
collect the before/after A/B counters in both modes; inspect cache-line
contention or an equivalent false-sharing diagnostic whenever mutable layout or
communication changes.

## Measurement and acceptance

Correctness gates precede performance claims: exact results, work counters,
witnesses, and certificates must agree with the retained implementation and an
independent oracle or replay boundary.

For timing claims:

- use release binaries and record compiler, flags, features, revision, and
  executable hashes;
- protect heavy processes with `choom -n 1000` and use at most 12 workers unless
  the user explicitly authorizes more;
- use deterministic inputs and interleaved or rotated A/B rounds;
- compare saved binaries when diagnosing small deltas;
- distinguish fresh-process cold, compiled-artifact load, and warm search;
- include equal parsing, compilation, startup, solving, and output boundaries
  in end-to-end comparisons;
- stream raw samples as they complete and verify summaries independently;
- report sample count, medians or geometric-mean ratios, paired log-ratio
  t-scores, exact work counts, and peak RSS;
- label interrupted or timed-out controls as lower bounds, never completed
  ratios; and
- report theorem-hit coverage and clean-miss overhead separately from wins.

Use performance counters to explain every hot-loop change: at minimum
instructions, cycles, branches, branch misses, and relevant cache events. The
counter run must be an A/B against the retained binary or implementation, not a
candidate-only snapshot. A wall-time win with more search work, unexplained
semantics changes, or an unfair measurement boundary does not pass. Do not
generalize an application-family comparison into a generic solver ranking.

## Required validation

Before reporting a coherent core change, run the validation gate in
`AGENTS.md`. A performance change additionally requires:

1. a zero-allocation test for the affected solve loop;
2. exact old/new work and result parity, except where a stated theorem safely
   changes the search tree;
3. an interleaved multi-round A/B with a retained control;
4. single-thread and parallel correctness, work-count, and A/B counter results;
5. a contention and false-sharing check for mutable-layout or communication
   changes;
6. peak-memory measurement; and
7. a short record of accepted and rejected variants so future agents do not
   repeat failed experiments.
