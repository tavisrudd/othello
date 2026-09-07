# C1082 — scalar PlanSpec semantics and FeatureDag lowering

**Lane**: `ergodis`
**Date**: 2026-09-07
**Status**: COMPLETE; all native gates passed. Core commit `ac6b3ad`.

## Implemented contract

Tavis continued the semantics programme in intent-based mode. Core
`docs/scalar-plan-semantics.md` now specifies all 27 PlanOp variants as typed stack operations,
with exact signed-64-bit arithmetic and evaluation/error semantics, compilation limits, scope,
source/expression lowering and FeatureDag obligations. `docs/language-semantics.md` links it and
corrects the earlier statement that arithmetic failures were compilation errors.

The independent executable reference is `python/plan_semantics.py`, which emits
`tests/fixtures/plan_semantics.json`. Its 41 deterministic cases cover all 27 operations and
important error domains: truncating signed division versus Euclidean remainder, negative
moduli, the MIN/-1 pair, checked arithmetic overflow, magnitude popcount/parity, GCD magnitude,
Legendre outputs, norm intermediate overflow, strict Boolean/select evaluation and scope
suppression of errors. This is a valid-plan mathematical oracle with selected error cases, not a
complete JSON or compiler-rejection oracle.

`tests/plan_semantics.rs` compares the optimized Rust evaluator against this corpus and covers
compiler boundaries separately, including integer/Boolean sorts, field schemas, scope, program/
stack bounds, and expression text/JSON lowering. An exhaustive Rust match over PlanOp forces
conformance review when the enum grows. Error categories and values are tested; diagnostic prose
is not a stable semantic identifier.

`tests/feature_lowering_semantics.rs` checks all FeatureOp forms and nested roots over 1,984
rows (12 cubed sign/modulus boundary combinations plus 256 deterministic generated rows).
Additional cases check reachable overflow, unrelated whole-DAG overflow and expanded-bytecode
limits. This connects the DAG evaluator to the scalar VM whose primitive semantics has the
independent oracle. It is finite conformance evidence, not a machine-checked compiler proof.

## Concrete source fix

`CompiledPlan::compile` previously cast field count and indices to u16 without bounding or
checking the public caller's schema. FeatureBatch loading validated its own schema, but callers
can invoke compilation directly. An oversized schema could truncate the recorded row width or
field index; duplicate names silently selected the last occurrence.

The cold compiler now rejects more than 65,535 fields and empty/duplicate field names before
narrowing. Empty schemas still support constant-only plans. Tests accept the exact maximum width
and evaluate its final field, reject oversized/ambiguous schemas, and reject a mismatched row.
The compiled operation layout, evaluator, fusion/truth-table paths and hot loops are unchanged.
No performance claim or A/B benchmark is made.

## Important semantic boundaries

- `Select`, `And` and `Or` are strict over already evaluated operands. A discarded branch can
  fail. Scope is checked first and can suppress the whole program, returning zero.
- Division truncates toward zero; remainder is nonnegative Euclidean remainder. They are not
  one quotient/remainder pairing. MIN remainder -1 errors even though mathematical remainder zero
  is representable, because that is the checked VM contract.
- Norm operations check specified intermediates. An Eisenstein norm may have a representable
  final polynomial value while an intermediate square overflows; the operation then errors.
- Feature lowering selects one root and expands shared terms into stack code. Whole-DAG
  evaluation visits unrelated nodes too. Lowering preserves defined selected-root values, not
  unconditional whole-DAG error behavior, and can hit the 128-operation limit despite a small DAG.
- Logical plan hashes exclude display names and do not bind compiler version, field-schema
  ordering, feature-generator meaning or target. They are not general artifact identities.
- These scalar APIs remain behind native `control-plane`. No WASM scalar API or full daemon
  extraction was added. C1081's portable reduction/WASM conformance remains a separate surface.

## Validation and replay

Focused scalar conformance: 4 tests passed. Focused feature lowering: 4 tests passed. Default
core check, formatting, all-target/all-feature clippy and the full all-feature test suite passed.
All three Python fixture checks passed (existing solver corpus, 12 admission cases, 41 scalar
cases). Cache GC passed in dry-run mode; no shared artifacts were deleted.

Full-suite local log:
`/tmp/claude-run-quiet/20260907-081420-RAYON_NUM_THREADS12-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-all-fe`.
Committed source/reference/tests and the replay commands are the durable evidence. All commands run from `~/src/ergodis` through the
run-quiet wrapper, with shared out-of-tree build artifacts and no parallel build contention.

```sh
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo fmt --all -- --check
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy --all-targets --all-features -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command env RAYON_NUM_THREADS=12 cargo test --all-features
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
nix shell nixpkgs#python3 --command python3 python/admission_semantics.py --check
nix shell nixpkgs#python3 --command python3 python/plan_semantics.py --check
```

Terra wrote the initial language contract and independently reviewed current source behavior;
Luna supplied the initial scalar reference; a second Terra wrote the DAG-lowering tests. Parent
review corrected oracle compiler/runtime classification, missing i64/error behavior, negative
remainder and typing cases, as well as the source compiler boundary. An initial focused test
failed on the oracle's row-width classification, then passed after correction. Test construction
bugs in the new DAG tests were also corrected before acceptance. No production evaluator bug
was found in the tested operation corpus.

## Next gate

Implement a portable campaign transition model with explicit candidate/evidence/artifact state,
mode and actual coverage, cancellation/budget outcomes and replay binding. Use the completed
scalar/reduction semantics as contracts; do not equate a diagnostic PlanSpec with an admitted
quotient. Extract host-independent parser/evaluator ownership only through a bounded successor,
without importing native socket/filesystem machinery into WASM or changing 64-bit hot layouts.

## Closeout review and mystery ledger

After acceptance, the explicit ej+tt pass clarified a reusable compiler obligation: algebraic
value equality alone is insufficient for a strict checked language. Rewrites must preserve the
error domain too, or declare a narrower input precondition. The public specification now says
this explicitly, connecting the norm/select findings to future optimized IR passes.

Terra's final independent review found no remaining mismatch between the reference and the
current operation semantics in the tested domain. No unexplained mathematical result remains
in this slice. Portable extraction, executable campaign transitions, generalized quotient/lifting
instructions and machine-checked compiler proofs remain explicit successor gates. The review
findings were sought task deliverables; no incidental discovery-track entry is warranted.
