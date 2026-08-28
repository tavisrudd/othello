# C987 observational application integration

**Lane**: `complete-ports`

**Date**: 2026-08-28

## Goal

Determine whether C983's observational compiler accelerates an existing
ergodis recovery or resource-optimization workflow rather than only its
standalone minimization benchmarks.

## Acceptance gate

- Select an existing repeated application subproblem with exact witness use.
- Integrate through the existing typed observational API without duplicating
  domain logic or weakening verification.
- Preserve deterministic outputs and an independent oracle/parity route.
- Measure build cost, repeated-query cost, peak memory, and reuse break-even.
- Retain a production path only on a favorable application-level result;
  otherwise keep at most a benchmark/control and state the bounded negative.
- Make no manuscript, mirror, export, push, deposit, or public-surface change.

## Initial hypothesis

The best candidate is a repeated finite resource or recovery interface whose
syntactic state table has equivalent rows. One-time quotient compilation can
pay off only if downstream composition or query replay avoids enough repeated
state work to amortize compilation and proof verification.

## Selected application path

The control uses the existing hierarchical labelled-recovery construction in
`CompositionTable`.  A state is the four-entry ordinary/target cost profile
produced by the real binary min-sum composition API; each of the three labelled
hierarchy contexts is a typed transition.  The raw implementation memoizes
those profiles in a `FinitePresentation`, and the candidate compiles the same
presentation to a `SplitTranscript` observational quotient.

This is application-shaped rather than a new synthetic automaton: the direct
oracle rebuilds each hierarchy step through `CompositionTable::compose` and
`compose_with_target`.  Before timing, the driver compares direct composition,
raw memoized transitions, and quotient transitions for every depth-four word
and the first 64 seed profiles.  The raw and quotient timed checksums also agree
in every retained run.  The existing hierarchy integration test separately
checks exact argmin witness replay through the same composition tables; C987
does not replace or weaken that witness-bearing path.

## Experimental protocol

- Release binary pinned to CPU 2, seven fresh processes per case.
- Raw-first and quotient-first order alternates, with four raw-first and three
  quotient-first rounds, to expose order or warming effects.
- Query vectors are allocated before timing.  The raw and quotient query loops
  use flat integer transitions, fixed-width state IDs, and no allocation or
  recursion.
- The small case uses seed bound 3 and 7,290,000 sequential plus 7,290,000
  random queries per round.  The scaled case uses seed bound 256 and
  10,616,832 sequential plus 2,000,000 random queries per round.
- Storage is exact retained payload accounting from the concrete vectors.
  Seven alternating `/usr/bin/time` process runs separately measure raw-build
  and full quotient-compilation peak RSS.  Build peak necessarily includes the
  raw presentation because quotient compilation consumes it.

Raw evidence is retained at
`ergodis/evidence/c987-observational-hierarchy.tsv`, SHA-256
`ae835c06fe486ccc9163f034b97b223e75df12e7d7923d576035c59214852fc5`.
Peak-memory evidence is retained beside it at
`c987-observational-hierarchy-memory.tsv`, SHA-256
`ca7faf079e60fe5d5ba4fd885ea6951d2d5d344ccd6daa0e603c76d4fc31cdff`.
The checker fixes both schemas, case shapes, state/storage counts, parity,
alternating order, row counts, and all relevant medians.

## Results

| case | raw states | quotient classes | retained raw | quotient + certificate | sequential median | random median |
|---|---:|---:|---:|---:|---:|---:|
| seed bound 3 | 57 | 25 | 768 B | 1,040 B | 30.391 ms / 30.469 ms | 33.556 ms / 34.683 ms |
| seed bound 256 | 328,704 | 2,049 | 4,469,760 B | 1,369,264 B | 44.074 ms / 44.303 ms | 23.025 ms / 9.829 ms |

The scaled quotient therefore has 160.42 times fewer semantic states, a 3.26
times smaller retained artifact including its certificate, and a 2.34 times
faster random-query median.  Sequential scans remain cache-friendly and the
quotient is 0.52% slower there.  At tiny scale it is 3.36% slower on random
queries and larger in memory, so there is no universal application win.

Raw presentation construction takes a 2.061 s median at scale; quotient
compilation adds 26.144 ms, or 1.27%.  Against random traffic the 6.60 ns/query
median saving amortizes that extra compilation after approximately 3.96
million queries.  This crossover excludes raw construction because both paths
require it.  Separately, raw memoization is about 1,295 times faster than
rebuilding `CompositionTable` for every small query; that dominant speedup is
precomputation, not quotienting.

Peak RSS is a negative result: raw construction has a 22,500 KiB median and
full quotient compilation has a 38,332 KiB median, 70.36% higher, because both
the source presentation and transient refinement/inverse-index workspaces must
coexist before the quotient is emitted.  The 3.26-times retained-artifact
reduction applies after compilation; it is not a peak-build-memory claim.  A
streaming or direct-construction compiler would be required to reduce both.

## Architecture and scaling verdict

Retain the driver, replay script, raw evidence, and checker as an application
control.  Do **not** change the current recovery CLI or default execution path:
the existing small workloads would regress, and the quotient does not yet own
the witness artifact.  A future opt-in compiled service is justified only when
the presentation is large, query starts are poorly localized, and expected
reuse exceeds the measured break-even.

Two scaling opportunities are now concrete:

1. The family grows from roughly quadratic raw profiles to `8b + 1` quotient
   classes at seed bound `b` in every measured power-of-two case through 256.
   Deriving that collapse algebraically could avoid constructing the quadratic
   raw presentation at all.
2. `CompiledObservation` retains the raw-state-to-class map.  A frozen
   evaluation artifact whose callers already supply class IDs could discard
   that map after compilation and approach the full 160-fold semantic-state
   reduction.  It must be a distinct typed artifact so witness lifting and
   raw-state entry are not silently lost.

The speed difference is locality, not fewer transitions: sequential access is
flat, while random starts expose the raw table's cache footprint.  Elias--Fano
is not indicated here because IDs are dense; compact fixed-width arrays or a
bit-packed class map are the more natural representations.  The implementation
already avoids recursive evaluation and allocation in the measured hot loops.

### Compiler improvement order

The application control makes the next engineering order unusually clear.

1. **Construct the algebraic quotient directly.**  Generic quotient compilation
   is only 26.144 ms; the quadratic raw hierarchy construction is 2.061 s.
   Removing the raw presentation dominates micro-optimizing the minimizer.
2. **Choose inverse scheduling by target-sort fan-in.**  The current inverse
   index retains a per-state target-to-generator CSR.  With only three incoming
   generators per hierarchy sort, scanning the tiny sort-local generator list
   is cheaper and removes a state-proportional directory.  Keep the current CSR
   for high-fan-in sparse presentations.
3. **Add a consuming/streamed presentation boundary.**  Build inverse groups
   from generator transition streams and compute the fingerprint in the same
   pass, so the full forward table need not coexist with the inverse index.
4. **Canonicalize in place and reuse arenas.**  The worklist already owns a
   `u32[N]` state-block array, but canonicalization currently allocates another
   `u32[N]` class array plus an old-to-new map.  Remapping the owned state-block
   array in place removes one full-state allocation; the old-to-new map need
   only match the number of live blocks.
5. **Separate proof, entry map, and frozen evaluator.**  In the scaled control,
   1,314,816 of 1,352,944 quotient bytes are the raw-state-to-class `u32` map.
   A `u16` map would make quotient plus certificate 711,856 B (6.28x smaller
   than raw), and a 12-bit map 547,504 B (8.16x).  A typed evaluator entered by
   class ID can drop the map, representatives, and certificate after external
   verification, leaving 29,932 B (149.3x smaller than raw).  Width dispatch
   must occur outside the hot loop.

SIMD is not the first lever: refinement is dominated by irregular gathers and
partition movement.  It becomes relevant only after profiles/transitions have
been flattened enough for radix/counting passes; the structural allocations
above have much higher expected value.

## Disposition

**Conditional positive, no default integration.**  C983's quotient accelerates
a scaled version of an existing recovery hierarchy, but only for a large,
random-access, heavily reused compiled service.  C987 records that boundary
and does not turn a benchmark crossover into a general recovery-speed claim.

## EJ/TT closeout and mystery ledger

- **Quadratic-to-linear collapse — open, C985.**  The observed depth-four
  family has about quadratic raw growth but exactly `8b + 1` quotient classes
  at the measured power-of-two bounds.  C987 did not prove this for all bounds
  or depths.  C985 owns the algebraic derivation/direct constructor gate.
- **160-fold classes versus 3.26-fold bytes — mechanism settled, upgrade open
  in C985.**  The retained raw-state-to-class entry map dominates the frozen
  quotient.  A typed evaluation-only artifact may drop it only when callers
  enter by class ID; witness/raw-state entry must remain a distinct artifact.
- **Sequential/random divergence — settled for this control.**  Equal
  transition counts and flat allocation-free loops isolate locality as the
  cause.  A production admission threshold remains hardware/workload specific
  and requires a cache-size and query-locality sweep under C985.
- **Peak-build regression — settled, successor route identified.**  The 70.36%
  peak increase is coexistence of source presentation and transient compiler
  workspaces.  Direct algebraic construction or a streaming source-consumer
  boundary is required to remove it; serialization alone cannot.
- **Witness-bearing quotient service — open, C985.**  C987 preserves and tests
  the existing exact witness route but does not make the quotient itself own a
  witness lift.  That is a hard gate before production integration.

All of these observations were found while looking for C987's application
crossover and are task-owned, so the discovery-track discriminator produces no
incidental entry.

## Validation

- `cargo fmt --all -- --check`
- `cargo clippy --all-targets --all-features -- -D warnings`
- `cargo test --all-features`: 144 library tests plus all binary, CLI,
  allocation, observational-compiler, Python-parity, and doc-test targets pass
- both replay scripts pass `bash -n`
- retained evidence checker passes both pinned SHA-256 files and exact medians
