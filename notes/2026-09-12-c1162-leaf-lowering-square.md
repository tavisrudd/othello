# C1162 — finite leaf-lowering square

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE.

User-authorized continuous work ends 2026-09-13 01:30:51 UTC. C1161 closed at
monorepo `761a4d683`, core `9cd2980`. Core C1162 mechanism: `a3a4942`; private family/evidence: `cc42f1b`.

## Result

The generic finite checker admits complete source transition tables F, a
surjective lowering G and a proposed summary transition H, then checks every
cell of G(F(x,e))=H(G(x),e). The caller owns the source model; a certificate
cannot substitute another model. Exact coverage, index bounds and model/claim
SHA256 identities are enforced. The verifier mints an opaque checked capability.

Counterexample-guided synthesis starts with an all-zero H. Each failed square
fixes one summary/event cell. Incompatible source representatives in one fiber
produce an independently checked obstruction. At most one refinement per cell
precedes success or obstruction. The cold reference algorithm rescans the model
for counterexamples; no solve-loop or performance claim is made.

Core paths: `crates/verify/src/finite_lowering.rs`,
`src/finite_lowering.rs`, `tests/finite_lowering.rs`, `docs/finite-lowering.md`.
Full workspace fmt and Clippy pass; 919 tests pass, three ignored, no failures.
The checksum manifest is refreshed. WASM release compilation passes. Exhaustive
synthesis-completeness tests cover all 4,374 three-source/two-event/two-summary
models, independently enumerating all 16 H tables for each. Each successful H
cell is mutated and rejected; obstruction mutations and malformed models fail.

## Discharged private family

The existing C1091/C1092 privacy fixture supplies two GF(2) secrets s,t and one
shared mask r. Source states are all 256 subsets of the eight linear observations.
Each of eight events appends an observation. Order, repetition counts, acquisition
costs and evidence provenance are outside this source abstraction.

Full joint-span G has 16 summaries. Synthesis finds its 128-cell H after 127
refinements, and the independent checker verifies all 2,048 source/event cells.
Every case also runs through existing `transcript_leakage::analyze`: complete
leakage spaces and joint ranks before and after agree, and existing coefficient,
matrix and contraction checks pass. The independent Python oracle enumerates
physical assignments, using constancy on observation fibers rather than row
reduction or span enumeration. It checks all lowerings, all transitions, all
131,072 source/event/assignment-pair append relations and both digests.

Leakage-space-only G has five summaries and cannot admit an H. After 36
refinements, the checked obstruction is source16 (observe r), source0 (observe
nothing), event5 (append s+r). Both initially leak no secret functional, but the
former then reveals s. This is established mask-reuse semantics, not a novelty claim.

The ej+tt refinement finds the smallest deterministic state for these privacy
readouts: 15 summaries. It merges the secret plane with the full joint space,
since both already reveal every secret functional. The independent checker
verifies all 2,048 transitions, each state has a well-defined current readout,
and every one of the 105 state pairs has a distinguishing current or one-event
readout. Thus 15 is minimal for all finite future append traces in this family,
not for full observation-space identity, costs or witness provenance.

Private implementation and exact replay bundle:
`src/privacy_lowering.rs`, `tasks/tools/src/privacy_lowering.rs`,
`tests/privacy_lowering.rs`, `tests/privacy_lowering_oracle.py`,
`evidence/2026-09-12-privacy-lowering.{json,md,sha256}`.
The manifest binds the producer, independent oracle, generic mechanism, certificate
and both dependency lockfiles. Scoped library/test and operator Clippy pass;
all five new and existing privacy tests pass. Final closeout validation passes after the 15-state addition, including all
manifest hashes. Cache GC runs dry; no foreign artifacts are deleted. No private artifact is exported to core.

## Lean and automation boundary

`lean/WeightedRules/LoweringSquare.lean` contains:
- `WeightedRules.EventLowering.square_trace` for all finite event lists;
- `square_fiber`, `incompatible_no_square`, `exists_square_iff`, `square_unique`;
- `checkSquare_sound` for exhaustive finite-function checking;
- `observation_span_square` and `observation_span_trace` over arbitrary semiring
  modules, specializing to the binary privacy observation span.

`grind` supplies ordinary equality reasoning in `square_fiber` and `square_unique`.
Mathlib's span-insert law proves the observation-space square. This concretely
places automation around the specialized checked solver. No toolchain upgrade
was needed. No bit-vector obligation required `bv_decide` in this slice.

Exact axiom audit, `WeightedRules.LoweringSquareAxiomAudit`:
`checkSquare_sound` has no axioms; `square_trace` uses propext; the other six
terminals use only propext, Classical.choice and Quot.sound. No sorry, native
decision or external-process axiom occurs. The Lean module does not import the
private JSON or certify Rust row reduction; those have their separate independent
finite semantic gate. The 15-state minimality claim is finite Rust/Python evidence,
not a claimed Lean theorem.

## Mystery ledger — ej + tt

- Settled: 127 refinements are the 127 nonzero cells of the 16-by-8 H; the
  empty-span/zero-event cell already matches the initial zero candidate.
- Settled: leakage alone cannot support future updates; the explicit same-fiber
  obstruction explains the failure without blaming the synthesizer.
- Settled: 16 full observation spans are not minimal for privacy readouts.
  The 15-state quotient and 105 pair witnesses establish the exact bounded answer.
- Settled: surjectivity removes unconstrained H cells and makes a successful H
  unique; the Lean theorem states that condition explicitly.
- Scope limit: arbitrary source languages, nonlinear releases, larger fields,
  changing mask spaces, witness provenance and other summary-transition consumers
  remain outside this family. C1097's generic source-lowering caveat is not erased
  globally. No genuine unresolved mystery remains inside the declared finite scope.
- No discovery-track entry: these were task-owned contract and closeout checks.

Next allocated independent programme task: C1158 acting-subgroup measurement.
Join-engine and broader benchmark allocation remain behind a concrete workload.

Final Lean aggregate gate: `run-20260913-003206-81d7e877`, success.
