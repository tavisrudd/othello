# C1163 — finite weighted rule contract

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS.

## Scope and implementation

The contract is finite relations over a declared idempotent semiring, grounded
ordered polynomial rules, an explicit scalar-variable bound, checked symmetry
declarations, and source-bound least-fixpoint certificates. The first executable
carrier is bounded nonnegative min-plus. A Datalog-style unary/binary-body parser
is an adapter to a typed IR; no MLIR dependency is needed for the first program.
The existing `ergodis-modules::Api` is the native/WASM execution boundary.

The initial Lean source is `lean/WeightedRules/Contract.lean`. It states the
scalar laws, information order, grounded program semantics, monotonicity,
finite convergence certificates, lowering commutation and symmetry invariance.
The intended terminal is `WeightedRules.certificate_least`; a concrete bounded
min-plus instantiation and recursive example will follow its successful gate.
Finite replay checks convergence within the scalar bound rather than postulating
a formalized universal convergence theorem. The reflective oracle remains C1164.

## Current validation and owned work

The first guarded elaboration refused an unavailable import named
`Mathlib.Tactic.Omega`; it was replaced with the actual function-iteration import
needed by the proof. No foreign Lean source or build was modified.

Unvalidated owned Lean work: `lean/WeightedRules/Contract.lean` and the additive
`WeightedRules` library declaration in `lean/lakefile.toml`. These are not yet
committed as validated formal results. Build entry is exclusively
`lean/scripts/guarded-lean` / `lean/scripts/lean-build-queue.py`.

Rust ownership: new rule contract/codec under `crates/verify`, and a reusable
rule provider crate under the core workspace, with scoped workspace membership,
tests and docs. No private adapters, served demo artifacts, other lane sources,
or existing solver kernels are task-owned.

## Gates

- Lean module build and exact axiom audit with no sorry or native oracle.
- Source → grounding → evaluation → serialized certificate → independent
  verification on one cyclic min-plus program.
- Malformed/schema/source/symmetry/budget mutation controls and a Python oracle.
- Existing C ABI round trip in native and actual WASM execution.
- Full native formatting/Clippy/tests and existing Python parity; zero-allocation
  evaluator loop after setup. No performance improvement claim.
- ej+tt closeout, mystery ledger, queue lifecycle and committed handoff.
