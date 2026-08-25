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
The producer now uses guarded fixed/preallocated hot records, emits three
generators closing to all 120 actions, and produces independently replayable
equivalence/inequivalence and reconstruction artifacts.

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
- gated actions: projective and semilinear profiles already require exact field
  moduli, element encodings, matrices, and Frobenius powers, but cannot be
  enabled until arithmetic and replay exist;
- every gated profile carries a frozen source hash, explicit carrier and
  ambiguity, optional odd calibration, and collision artifacts for each
  minimality claim;
- no manuscript, Lean, or existing paper fixture was modified.

## Validation

- `cargo test --workspace --all-features`: pass;
- `cargo clippy --workspace --all-targets --all-features -- -D warnings`: pass;
- Paper-I exhaustive search: automorphism order 120, one vertex orbit;
- property test: canonical identity invariant under all tested cyclic
  relabelings;
- deliberate canonical-identity, branch-trace, and automorphism-set corruption:
  rejected by the independent reference implementation.
- hot Paper-I search: fixed 32/64/128-byte guarded records; zero allocations,
  reallocations, deallocations, and cold arena grows over 193 nodes;
- equivalence certificates carry an explicit isomorphism or two exhaustive
  canonical proofs plus a separating identity; reconstruction artifacts replay
  their carrier, residual `C2`, and round trip;
- `cargo deny check`: advisories, bans, licenses, and sources green.

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
  matching the declared residual orientation ambiguity. Three generators close
  to all 120 verified actions.
- **Settled in the closeout pass:** source provenance initially contaminated
  canonical identity. Canonical serialization now normalizes the theorem
  locator to the adapter identity, and a regression test proves that a second
  frozen export of the same shadow remains equivalent.
- **Partly settled — certificate trust:** independent exhaustive replay now
  exists and shares no canonical-search implementation with the producer.
  Remaining question: what is the smallest compact proof language that covers
  richer relation/action adapters? Evidence gap: no explicit proof-rule calculus
  yet. Owning next gate: adapt and minimize the `isocert` rule/checker split.
- **Open — source exports:** nearby evidence files exist for Papers II--V, but
  none is the complete frozen shadow required by its typed adapter. Four
  fail-closed schema fixtures name the missing export paths. Owning next gate:
  the respective paper stream must freeze one exact export at a time; C968 will
  not infer it from manuscript prose or trust metadata.
- **Settled — hot representation:** the Paper-I producer uses fixed/preallocated
  search data with compile-time size/alignment guards and a zero-allocation
  instrumented fixture run. The slower independent checker intentionally keeps
  simple cold structures.
- **Open — timing drift:** two consecutive CPU-0-pinned runs differed by 37%.
  No optimization verdict uses them. Evidence gap: interleaved A/B plus
  cycles/instructions per node; owning successor is the first actual
  optimization proposal, not routine correctness work.

## Next gate

Specify an `isocert`-caliber compact proof-rule calculus, using the independent
reference search as oracle. In parallel, the owning paper streams may freeze
the exact exports named by the four gated fixtures; no further adapter can be
enabled before that source gate.
