# C1017 Ergodis core performance-contract remediation

**Lane:** `complete-ports`

**Status:** QUEUED

## Goal

Bring every reusable public Ergodis solve kernel into compliance with the
private performance contract, and move all domain-specific, task-specific,
experimental, or otherwise non-reusable work to `ergodis-private/`.

The source audit is
`notes/2026-08-30-c985-ergodis-core-performance-contract-audit.md`. It covers
all 56 Rust files and identifies definite allocation, recursion, contention,
layout, evidence, and publication-boundary failures.

## Acceptance gates

1. A test-only thread-local allocator guard proves zero allocation,
   reallocation, and deallocation after every public solve kernel enters its
   hot loop.
2. Search-tree and decision-diagram traversal is iterative with a presized,
   bounded workspace; no recursive production solve path remains.
3. Every hot state, frame, transition, mailbox, and worker result has an
   explicit Tiger representation and compile-time size/alignment assertions.
4. Search workers share immutable state only. There are no worker-to-worker
   writes, contended atomics, shared queues, allocator traffic, or false-shared
   mutable fields during solve.
5. Every affected kernel passes exact old/new verdict, witness, certificate,
   and work-count checks in one-thread and parallel modes.
6. Every hot-loop change has an interleaved retained-binary A/B with
   instructions, cycles, branches, branch misses, relevant cache events, wall
   time, and peak RSS in both one-thread and parallel modes.
7. `alignment`, fixed-field research front ends, private theorem schemas, C-ID
   fixtures, and other non-reusable adapters live only in `ergodis-private/`.
8. One guarded registry command checks allocation, layout, correctness,
   single/parallel parity, counter evidence, and contention coverage for every
   registered solve kernel.

## Ordered work packages

1. Add the allocation guard and machine-readable kernel/evidence registry.
2. Move private adapters and fixtures before changing their implementation.
3. Replace recursive/growing ZDD, application, orbit, sparse-scheduler, and
   ordered-resource solve paths.
4. Replace CSS worker broadcast with contention-free publication, make
   workspaces worker-owned, and split pulse/no-pulse kernels outside the loop.
5. Close the remaining Tiger layout and recursive cold-replay findings.
6. Run the full correctness, allocation, counter, memory, and parallel gates;
   retain negative controls and close the task only with independently checked
   evidence.

## Boundaries

- Preserve exact semantics and replayable witnesses.
- No performance claim is accepted from source inspection or wall time alone.
- No private contributor document, adapter, fixture, task identifier, or
  research process enters a public export.
- Remediation changes remain private until the separate publication boundary
  is deliberately reopened.
