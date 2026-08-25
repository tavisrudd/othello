# C968 — sparse-shadow first implementation gate

**Lane:** `clebsch`

**Date:** 2026-08-25

## Result

The standalone `sparse-shadow/` Rust workspace now has a frozen schema-v1
boundary, strict JSON parsing, five distinct typed profile variants, a thin CLI,
and an enabled Paper-I orientation adapter. Its hand-checkable twelve-point
fixture carries the two five-valent icosahedral orbitals and antipodal matching.
The explicit individualization/refinement search returns a canonical form,
input-to-canonical witness, all verified automorphisms (order 120 on the
fixture), vertex orbits, deterministic BLAKE3 identity, branch trace, and the
residual uncalibrated orientation `C2`. Relabeling and corruption tests pass.
An independently implemented reference search rederives the canonical payload,
witness, winning trace, and complete automorphism set from raw relations; it
rejects hash, trace, and missing-automorphism corruption.

This closes C968's first implementation gate, not C968. Papers II--V remain
schema-gated pending exact frozen exports, and the current independent replay
exhaustively recomputes the reference search rather than checking a compact,
separately specified proof-rule calculus.

## Frozen boundary

- workspace crates: `sparse-shadow-core`, `sparse-shadow-cli`;
- MSRV/toolchain: Rust 1.85.0, edition 2024;
- commands: `validate`, `canonicalize`, `equivalent`, `reconstruct`,
  `verify-certificate`;
- enabled action: color-preserving permutations over named binary relations;
- deferred actions: projective and semilinear witnesses require an explicit
  schema extension;
- no manuscript, Lean, or existing paper fixture was modified.

## Validation

- `cargo test --workspace --all-features`: pass;
- `cargo clippy --workspace --all-targets --all-features -- -D warnings`: pass;
- Paper-I exhaustive search: automorphism order 120, one vertex orbit;
- property test: canonical identity invariant under all tested cyclic
  relabelings;
- deliberate canonical-identity, branch-trace, and automorphism-set corruption:
  rejected by the independent reference implementation.

## Prior-art result

The bounded audit is in `sparse-shadow/docs/prior-art-audit.md`. It read three
cached papers in relevant sections and five official software surfaces.
McKay--Piperno and nauty/Traces are the canonicalization baseline; Vole is the
closest arbitrary-permutation-action engine; Feulner and Sage `codecan` are the
closest projective/semilinear canonical-form precedent; and
Bankovic--Drecun--Maric `isocert` is the direct independent-certificate
baseline. No novelty or priority claim is licensed.

## Mystery ledger

- **Settled:** the fixture's 120 automorphisms are not the orientation-preserving
  `A5` alone; the two unlabeled orientations retain the central `C2`, exactly
  matching the declared residual orientation ambiguity.
- **Partly settled — certificate trust:** independent exhaustive replay now
  exists and shares no canonical-search implementation with the producer.
  Remaining question: what is the smallest compact proof language that covers
  richer relation/action adapters? Evidence gap: no explicit proof-rule calculus
  yet. Owning next gate: adapt and minimize the `isocert` rule/checker split.
- **Open — source exports:** the exact stable machine exports for Papers II--V
  have not been identified. Owning next gate: freeze one adapter export at a
  time; do not infer it from manuscript prose.
- **Open — hot representation:** current search allocates cloned partitions and
  signatures. This was intentional for the first correctness gate, but fails
  the final Tiger-style acceptance gate. Owning next gate: proof-checker design
  first, then a fixed/preallocated search representation with size/alignment
  assertions and allocation instrumentation.

## Next gate

Specify an `isocert`-caliber compact proof-rule certificate for the Paper-I
fixture, using the independent reference search as the oracle during
development. Then freeze/profile the hot representation before enabling the
next exported adapter.
