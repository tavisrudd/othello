# C1155 — weighted normalization and existing quotient reuse

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE as a bounded private offline prototype; commit `73e1d29`.

Settled the sentinel boundary with checked u64 costs and explicit absence,
implemented weight pushing plus exact layered weighted-bisimulation lumping,
and verified reuse of the existing certified observational compiler. No
production arithmetic, format, default backend or dependency was changed.

## Source-study correction

`compile_observational` already constructs certified coarsest quotients; this
was present in the study baseline `927c618`, not a newly missing capability.
`ValidatedQuotient::admit` reads an additional observable from a supplied
quotient. Replacing observations and recompiling can merge more states. The
supplied quotient remains minimal for its original stronger observation.
No second quotient engine was introduced. The study's partition-order wording
was also reversed: the coarsest equivalence contains every valid finer one.

## Gates

- 640 assignments from the existing SyntheticInstance/CompositionTree fixture
  machinery: all 10,240 boundary costs agree after normalization; no legacy
  saturation occurs in that generated corpus.
- Exhaustive enumeration of all 15 partitions per four-state layer checks
  156,000 candidate partitions. Logical state counts total 44,160 original /
  40,700 normalized. The prototype retains padded records and source maps;
  this is not a physical-memory or speed claim.
- A deliberate two-leaf high-cost case produces 64 legacy clipping events.
  The wide result remains finite at 8,589,934,588 and distinct from true absence;
  both project correctly to the legacy bounded result.
- The admitted 4096-leaf maximum-cost case reaches 17,592,186,036,224 without
  wide overflow. A conservative bound for every intermediate is below 2^57.
  Explicit u64-overflow input is rejected, not saturated or wrapped.
- Independent u128 path enumeration covers all root entries for 32 seeds and
  lengths 1–5. Reading the maximum-size normalized root allocates nothing.
- Thirty reobservation cases in the existing bit-flip admission family agree
  with an independent pair oracle (18,720 comparisons). Summed class counts
  are 340 supplied / 120 recompiled across those distinct readouts.
- Five weighted tests, seven interval regressions and strict library/test
  Clippy pass. Audit JSON replays exactly. Shared AuditOutput preserves the
  old interval CLI result byte-for-byte; its source receipt now has 17 files.

Full contract, proof rationale, finite evidence, SHA-256 receipts and commands:
`ergodis-private/analysis/weighted-normalization/README.md`.

## Post-gate ej + tt / Mystery ledger

- Settled: use the existing minimum-quotient compiler; additional-readout
  admission and reobservation are distinct operations.
- Settled: widening does not make min cancellative. Exact vector comparisons
  and exhaustive local partition checks avoid that false assumption.
- Settled: explicit absence plus the path/intermediate bounds resolves the
  finite-cost ambiguity before projection. Already-lost leaf provenance cannot
  be reconstructed from the old sentinel alone.
- Open: production packing/update maintenance needs a concrete consumer and
  retained A/B. This is an offline representation, not a speed result.
- Open: global weighted-language minimization, changed contexts and reuse
  across leaf mutations are outside this layered finite audit.

These were targeted findings; no incidental discovery entry was warranted.
The remaining two-hour window returns to C1170's portability gate. Deadline
remains 2026-09-13 07:24:50 UTC.
