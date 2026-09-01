# ADR: Ergodis correctness safeguards after C1030

**Status:** accepted for incremental adoption; no broad refactor in this tranche  
**Date:** 2026-08-31  
**Scope:** public Ergodis core, private capability kernels, and evidence-producing binaries

## Context

C1030 found five recurring failure shapes rather than a collection of unrelated
bugs:

1. campaign-local copies of shared kernels diverge;
2. release-performance conventions remove checks without an independent safety
   mechanism;
3. a verifier repeats the producer or omits the field it claims to check;
4. source and evidence are not commit-addressable;
5. an artifact describes the requested run rather than the run that occurred.

Round 2 sharpened the third shape: several checks were structurally incapable
of failing.  A benchmark compared untouched inputs, a shard ledger stamped a
coverage verdict without establishing a stable partition, a headline deficit
was omitted from verification, and shell `diff` commands could fail while the
script exited successfully.

The performance contract remains unchanged.  Search hot loops stay iterative,
allocation-free, contention-free, and measured in both one-thread and parallel
modes.  The safeguards below belong in cold compilation, typed construction,
reduction boundaries, evidence emission, and independent replay unless a hot
check is proved necessary and admitted by counters.

## Decision

### 1. Every advertised check gets a failing control

A test for a verifier, benchmark gate, coverage verdict, or replay script must
construct the smallest mutation that should make that check fail and assert
that the named check rejects it.  Merely asserting `is_err()` after changing
several fields is insufficient: each load-bearing field gets an isolated
mutation.  Benchmark controls must additionally assert that the compared
kernels performed nontrivial work and changed the fixture when mutation is the
intended operation.

This is the default review question:

> What input makes this check fail, and does the test prove that this check—not
> an adjacent one—caused the failure?

### 2. Evidence records describe observed scope through typed fields

Every parameter that can change coverage, truncation, semantics, or replay is
serialized.  Free-form provenance and verdict strings may summarize these
fields but never replace them.  Incrementally converge on the following cold
record shape:

```text
RunScope {
    algorithm_semantics,
    input_binding,
    parameter_binding,
    partition,
    limits,
    completion,
}

Completion = Exhaustive | Truncated { reason, attained } | Interrupted
VerifierKind = WitnessReplay | IndependentRecomputation | ProofCheck
```

Schemas deny unknown fields and do not default load-bearing values.  Timings
and host measurements live outside deterministic certificate payloads.  Files
are published atomically and create-only.

Immediate applications are already small and local: C80 records its candidate
cap and truncation; orbit enumeration records its cap and whether the count is
exhaustive; q7 repair records the actual input/target prefixes; certiis checks
its stated deficit; certdist requires and replays the source input.

### 3. Coverage is a first-class certificate obligation

Presence of every shard index is necessary but not sufficient.  A sharding API
must establish that every invocation partitions the same deterministic domain.
The current wide CSS repair makes prefix generation independent of shard-local
incumbents and reserves those incumbents for already-assigned deep branches.

The next schema revision should bind a cold partition descriptor to each shard:
algorithm-semantics version, anchor order, frontier depth, frontier length, and
a deterministic frontier commitment per anchor.  The ledger may emit
`CompleteCover` only when these descriptors agree and all partition indices are
present.  This is additive cold evidence; it does not add hashing or I/O to the
solve loop.  The first incremental schema step is landed: v2 records both the
requested and effective search maxima, admits only a one-step odd-to-even
normalization, scopes the cover to the effective maximum, and requires every
shard to agree on it.

### 4. Reduction operators declare and test their algebra

Every parallel reducer must have tests for left identity, right identity,
associativity on a bounded exhaustive model, and deterministic witness tie
breaking.  Optional minima use an explicit “None sorts last” helper or a bare
sentinel carrier; raw `Option` ordering is not a reduction policy.

Allocation instrumentation must propagate measurement identity to worker
threads.  A caller-thread counter is not evidence for a Rayon kernel.  One
shared harness should replace campaign copies once ownership permits; until
then, every new measured parallel kernel must use the guarded worker-aware
variant.

### 5. Representation bounds travel with constructors and kernels

Widths, moduli, field identity, carrier caps, and arithmetic ranges are checked
where the representation is created or consumed—not in one caller.  Release
soundness never rests solely on `debug_assert!`.  Proof/certificate arithmetic
uses checked or widened operations; overflow-checked CI runs small-parameter
campaign controls even when production release builds retain overflow checks
off for measured hot paths.

This is an incremental architectural direction, not approval for a wholesale
type rewrite.  Introduce capability-owned checked constructors as affected
kernels are touched.  Matrix field tagging, unified allocation instrumentation,
and common evidence writers are later capability-layer migrations.

### 6. Verification independence is explicit

“Verified” must name its level:

- **witness replay:** independently checks a concrete witness against source;
- **independent recomputation:** derives the claimed scalar/shape through a
  separate implementation or simpler semantics;
- **proof check:** checks a certificate whose soundness is smaller than the
  producer search.

Calling the producer's builder twice is none of these.  Sharing parsing and
primitive arithmetic is acceptable only when the claim does not depend on the
shared transformation, and mutation controls cover the shared boundary.

### 7. Clean-checkout buildability is part of the evidence chain

Paper-facing commands name a Git SHA or tracked patch, never an ephemeral
binary.  CI checks the public feature matrix and a clean checkout of every
tracked private target referenced by evidence.  Untracked campaign sources do
not support durable replay claims.  Work owned by another active session is not
absorbed to satisfy this rule; its owner must land the source chain first.

### 8. Evolve imports only reusable semantic contracts

C1016's public-core enhancement ledger is a recurring source of feature
requests.  The currently admissible general directions are relational plan
operations, provenance-bound counterexample-guided presentation transitions,
and typed set-theorem templates with canonical semantics and independent
witness reconstruction.  Campaign-specific fields and conclusions remain in
`ergodis-private`.

## Tactical adoption order

1. Close confirmed SEV1/SEV2 defects with isolated commits and negative
   controls.
2. Add shared rank/order and evidence-field helpers where two live tracked
   callers already need them; do not reorganize the private crate yet.
3. Add a clean-checkout evidence/build gate once the current private source
   owner lands the missing modules.
4. Add typed `RunScope`/`Completion` at the next evidence schema revision.
5. Extract the worker-aware allocation/reduction-law harness after the dirty
   campaign tree is commit-addressable.

## Consequences

Cold compilation and verification become slightly more explicit and some old
evidence schemas are invalidated when their semantics were ambiguous.  Solve
throughput should not move.  In return, claims become mutation-tested,
coverage-aware, reproducible from Git, and clear about the independence their
verification actually provides.
