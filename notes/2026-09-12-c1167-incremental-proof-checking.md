# C1167 — source-bound incremental min-plus proofs

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS.

Prove the existing runtime's improvement policy in Lean: with unchanged rules
and pointwise improved facts, a checked old least solution is a safe seed for
the new problem. Warm replay reaches the new least fixed point within the
scalar N-round bound; an earlier fixed result is already least.

Add a checked incremental proof object tied to the old checked solution and
the caller's new formal program. Preserve the existing from-zero checker and
certificate interface; do not change runtime admission or retraction behavior.
The new Lean proof route checks fact monotonicity, identical rules, exact value
coverage, bounded replay from the old valuation, and fixedness.

Acceptance: universal symbolic proofs, guarded Lean aggregate and axiom audit,
controls for real improvements, zero-round no-ops, changed rules, retractions,
unsupported cyclic fixed points and malformed replay. Demonstrate conversion to
the existing `CheckedSolution` without asserting Rust correctness or external
source correspondence. Owned paths are new `lean/WeightedRules/` modules and
task/programme lifecycle documentation.
