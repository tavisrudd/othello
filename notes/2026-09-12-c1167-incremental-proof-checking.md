# C1167 — source-bound incremental min-plus proofs

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE. Proof `aa8b2a362`; live oracle/examples `7798d342d`;
private paired evidence `57a4eb9`.

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

## Results

`lean/WeightedRules/Incremental.lean` proves
`WeightedRules.iterate_le_of_improves` over every supplied scalar algebra.
For bounded min-plus, `WeightedRules.iterateFrom_scalar_bound` and
`WeightedRules.iterateFrom_eq_of_fixed` prove the sandwich argument for any safe
seed. `WeightedRules.improved_iterateFrom_bound` and
`WeightedRules.improved_iterateFrom_fixed` instantiate it at an old least solution.

`lean/WeightedRules/IncrementalReflection.lean` adds the source-bound predicate
and typed `WeightedRules.CheckedImprovement`. Its
`WeightedRules.checkImprovementCertificate_sound` theorem proves leastness from
an actual old `CheckedSolution`, identical rules, improved facts, exact old/new
coverage, bounded synchronous replay and fixedness.
`WeightedRules.CheckedImprovement.toCheckedSolution` converts to the existing
from-zero certificate type by proof, with round count N; it does not recompute
N rounds while constructing that proof. `WeightedRules.iteratedImprovement`
establishes certificate existence for every admitted fact improvement.

The existing `lean/WeightedRules/Oracle.lean` now also accepts
`ergodis_improvement old to Q from "source.json" replay k`. Its common decoder
and proof elaboration helpers preserve the original oracle's diagnostics and
strict no-sorry proof construction. Only literals are imported. The provider's
own from-zero round count is validated but is not mistaken for k.

`lean/WeightedRules/IncrementalExample.lean` checks actual ABI responses:
`WeightedRules.oracleImprovedDistance` uses three steps to change the four-vertex
readout `[0,3,2,6]` to `[0,1,2,4]`; `WeightedRules.oracleTwiceImprovedDistance`
uses two steps to reach `[0,1,0,4]`. A no-op uses zero steps. The final leastness
terminal is `WeightedRules.oracleTwiceImprovedDistance_least`; its converted
certificate has the from-zero scalar bound 21.

## Validation and scope

Generic and live oracle gate: `run-20260913-041154-f557ce95`,
`WeightedRules.IncrementalAxiomAudit`. All twenty printed terminals use only
subsets of propext, Classical.choice and Quot.sound; generic input monotonicity
is axiom-free. No sorry, native-decision or foreign-process axiom appears.
The original oracle example, rejection suite and eight-terminal audit also
rebuild successfully (`run-20260913-040450-649b45ef`).

Finite controls cover improvements, chained conversion, zero-round no-ops,
changed rules, retractions, old/new list coverage, excessive bounds, incorrect
replay and an unauthenticated old seed. Four live incremental rejection controls
reject insufficient/excessive replay, values for different new equations and a
retraction. The Python ABI adapter suite passes all three tests, including five
distance fixtures independently checked against Floyd–Warshall.

The touched Oracle module and every new formal module were reviewed in full.
The scope expanded within the same proof task to its additive oracle entry,
example fixtures, existing adapter tests and private proof-timing consumers.
No Rust or runtime admission policy is changed. The provider still solves its
source independently; the incremental operation here is the Lean proof replay.
Its inherited subprocess timeout/isolation and post-capture output-limit
restrictions remain exactly as documented in the oracle README.

## Mystery ledger — ej + tt

After the correctness gate, the closeout pass tested whether shorter replay
produces an observable proof-checking benefit and checked its authority boundary.

- Settled: a typed old proof is necessary. `WeightedRules.unchecked_seed_boundary`
  exhibits an unsupported seed that passes local replay but fails the old
  from-zero checker. The soundness theorem and constructor require the old proof.
- Settled: local fixedness after a retraction is insufficient; the zero-cost
  self-cycle control is rejected by source compatibility.
- Settled: semantic from-zero bounds and incremental work counts are distinct.
  The converter uses N by proof; actual runtime counters are not accepted without
  replay under the formal synchronous convention.
- Measured: on a six-vertex chain (43 scalar coordinates, 36 products), two-step
  incremental checking versus six-step from-zero checking has median guarded
  elaboration wall 4.68 versus 7.30 seconds across three interleaved pairs, about
  1.56×. Median user CPU is 3.23 versus 5.82 seconds. These include imports and
  native witness acquisition, with the same already compiled old proof.
- Boundary: this is a small proof-checking measurement, not a production solver
  speedup or broad benchmark. Private exact replay, sample spread, hashes and
  axiom audits: `evidence/2026-09-12-incremental-lean-profile.{md,json,sha256}`.
- No genuine mathematical mystery remains in the admitted improvement statement.
  Broader runtime integration and external IR interpretation keep their own gates.
  No incidental discovery entry: these were task-owned closeout questions.
