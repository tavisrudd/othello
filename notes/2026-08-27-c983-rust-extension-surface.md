# C983 — Ergodis Rust extension surface

**Lane**: `complete-ports`

**Date**: 2026-08-27
**Status**: DESIGN ONLY; NO RUST CHANGE AUTHORIZED OR MADE

## Current crate assets

The cross-domain compiler does not start from an empty crate.

- `composition.rs` already supplies compact labelled cost records, min-sum
  composition, tower compilation, and replayable predecessor nodes.
- `contextual.rs` already implements recovery-specific rank-one/rank-bounded
  context caches, direct-versus-cached planning, flat keys, compact records,
  and explicit work counters.  It is domain-specific despite its broad name.
- `scheduler.rs` already supplies exact capacity optimization, dense/sparse
  backends, compact load storage, workspaces, and assignment witnesses.
- `witness.rs` and the private arenas demonstrate the intended split between
  compact numerical state and separately replayed concrete solutions.
- `applications.rs` and the CLI already establish that worked operational
  adapters can share the crate without becoming general-purpose products.

These assets support the C983 application framing.  They should become
adapters, controls, or consumers of a new cold compiler; they should not be
forced through a new dynamic abstraction in their tuned hot loops.

## Proposed cold compiler boundary

Add a separate module such as `observational`, rather than broadening the
meaning of the existing recovery-specific `contextual` module.  Its input is
the finite typed presentation proved in the theorem note:

```text
sorts
reachable states grouped by sort
typed generator actions
finite observations
domain representatives / context reconstruction metadata
```

Its output is a self-contained artifact:

```text
CompiledContextMachine:
    sort ranges
    state -> quotient-class map
    quotient outputs
    flat generator transition tables
    representative state per class
    split traces / distinguishing typed paths
    query-profile/schema identifier
    optional potential normalization data
```

Adapter traits, if any, remain cold and generic/monomorphized.  The compiled
artifact uses integer IDs and contiguous boxed slices; evaluating it requires
no `dyn` dispatch, hash lookup, allocation, or domain object traversal in the
transition loop.

If the original finite presentation is retained, adding observations or
context generators can refine the existing partition incrementally.  The
artifact version must name its exact query profile; a value-only quotient
cannot silently answer a later count or witness-sensitive query.  Coarsening
is a cold recompilation unless full refinement history is deliberately kept.

Do not reuse `projective.rs` for additive gauge: that module means finite-
geometry projective space.  A potential backend should use a name such as
`potential.rs` and store signed checked offsets separately from the domain's
absolute nonnegative costs.

## Memory and algorithm napkin

Let `N` be total reachable states and

```text
T = sum over generators g of |source carrier of g|.
```

A dense deterministic presentation needs approximately `4T` bytes for `u32`
successors, `4N` bytes for class IDs, `4N` bytes for representative/output IDs
when those are `u32`, and one small record per generator.  A split forest can
fit in roughly 8--16 bytes per strict split before domain reconstruction
metadata.  These quantities, not only quotient cardinality, belong in every
benchmark.

Naive refinement scans all `T` transitions per strict round and can take
`O(TN)` time.  That is acceptable only as the small independent reference.
The production compiler should use inverse transition lists/worklist
refinement if profiles justify it.  For a ranked operation, blindly expanding
all fixed coargument tuples can dominate `T`; the adapter should exploit
symmetry, sparse reachable operations, or a proved separator basis before the
generic compiler sees them.

The performance playbook rules out a per-transition feature switch.  Absolute,
potential, certificate, and instrumented modes should be selected once at the
cold entry point and call separate monomorphized or specialized loops.  Keep
work counters and context reconstruction out of the minimal production table
unless explicitly requested.

## Front ends

### Explicit presentation

The domain compiler enumerates reachable states and generator actions, then
calls partition refinement.  This is the first implementation path because it
has an exhaustive oracle and simple failure semantics.

### Oracle learning

A later cold front end accepts effective access constructors, context/value
queries, and an exact equivalence/counterexample oracle.  It incrementally
learns the finite observational machine and emits the same artifact.  It must
not claim exactness when equivalence is replaced by sampled testing.

### Existing relation backend

`CostTable`/`CompositionTable` can compile their allowed one-hole relation
operations into the presentation, but they remain optimized domain data
structures.  The generic compiler should not replace their matrix arenas or
witness representation.

## Exemplar placement

1. The bounded tropical weighted-tree control should live as a small adapter
   and exhaustive test/reference workload.  It exercises multiary compilation
   without touching recovery hot paths.
2. The symmetric resource-batch adapter should use the existing scheduler as
   an independent exact oracle where its model overlaps.  It should not
   retrofit `scheduler.rs` until it demonstrates reduction beyond known load
   symmetry or a reusable batch/query capability.
3. Quantitative boundaried networks are the first stretch application.  They
   should arrive only after the finite-integer-index and rank-representative
   backends are cleanly separated from state quotienting.

## Validation and acceptance gates

- Exhaustively compare original and quotient observations for every reachable
  small state/context pair.
- Replay every split certificate and verify it actually distinguishes its
  recorded pair.
- Replay absolute answers after potential normalization, including overflow,
  all-infinite, and mixed finite/infinite cases.
- Validate chosen witnesses in the original domain; report witness memory
  independently.
- Compare the weighted-tree control with its direct vector evaluator and the
  scheduling adapter with exhaustive assignments plus the existing exact
  scheduler where applicable.
- Report `N`, `T`, quotient classes, table bytes, split/certificate bytes,
  provenance bytes, compile time, and repeated-query break-even.
- Use interleaved A/B only after correctness and a channel-Fermi estimate show
  that a runtime claim is plausible.

The architecture gate fails if the two first adapters require special cases in
the minimizer itself, if certificates cannot replay independently, or if the
generic artifact adds hot-loop indirection without a compensating state or
capability gain.
