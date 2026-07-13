# RepairCodes asymptotic family: strict-gate adversarial review

**Date:** 2026-07-13
**Verdict:** PASS, with exactly one deep literature theorem exposed as a quarantined axiom.

## Statement adequacy

- `TraceDual.lean` proves, rather than assumes, the extension-field trace bridge.  Every
  `F`-linear functional on a finite separable extension `L/F` is represented by the
  nondegenerate trace pairing; scalar closure of the `L`-linear outer code forces the
  representing coefficient word into its ordinary `L`-dual.  Coordinatewise injectivity
  proves exact support and weight equality.
- `Q9ExtensionLift.lean` constructs the actual restricted-scalar concatenated code.  Lean proves
  the dimension multiplier `[L:F]=4`, equality of extension-field and restricted symbol support,
  the `[19N,4K,≥8D]₉` parameter transfer, and exact repair-hypergraph transfer from the
  ordinary outer dual-distance hypothesis `d(O⊥)≥5`.
- The sole imported theorem is Stichtenoth, arXiv:math/0506264, Theorem 1.6(ii), specialized to
  `q=6561=81²`: an unbounded self-dual family with rate `1/2` and limiting relative distance at
  least `1/2-1/80=39/80`.  The Lean axiom mirrors its sequence, self-duality, parameter, length,
  and limit assertions.
- The analytic-to-discrete step is proved in Lean: `39/80>1/3` gives eventually `N≤3D` and
  `N≥15`.  Self-duality makes the primal and dual distances identical, hence supplies the
  repair gate.
- The concrete headline theorem constructs `GF(9)=GaloisField 3 2`, chooses and verifies an
  embedding into `GF(6561)=GaloisField 3 8`, and proves extension degree four.  No field-existence
  hypothesis remains in that corollary.
- The output family has lengths tending to infinity, exact rate `2/19`, eventual relative
  distance at least `8/57`, and the complete radius-three repair rows
  `(nu,tau)=(4,7),(6,12),(7,13)` at every coordinate.

## Arithmetic and direction checks

- Outer self-dual rate `1/2` and inner dimension rate `4/19` multiply to `2/19`; Lean records the
  denominator-free equality `19k=2n`.
- From `N≤3D`, seed distance eight gives `d_lift≥8D`, hence
  `57 d_lift ≥ 456D ≥ 152N = 8(19N)`, i.e. relative distance at least `8/57`.
- `N≥15` and `N≤3D` imply `D≥5`; self-duality identifies `dualDist O=minDist O`, so the
  direction of the repair-gate implication is correct.
- The result preserves the complete code-derived repair hypergraph, not a selected repair family.

## Trust audit

- Forbidden-token scan of `lean/RepairCodes`: no `sorry`, `admit`, `native_decide`, `unsafe`, or
  `implemented_by` in the proof chain.
- The only project `axiom` is
  `RepairCodes.Imported.stichtenoth_selfDual_TVZ_6561`, isolated in `Imported.lean` with theorem
  number, primary-source link, specialization, and exact consumed statement.
- `#print axioms` reports only `propext`, `Classical.choice`, and `Quot.sound` for the trace bridge,
  extension lift, and analytic reduction.  The concrete asymptotic headline adds exactly the
  quarantined Stichtenoth axiom and nothing else.
- `lake build RepairCodes.Asymptotic` and the aggregate `lake build RepairCodes` pass under the
  OOM-safe build wrapper.

## Boundary and remaining work

The finite seed, trace bridge, extension-field lift, finite-field instantiation, and reduction from
the imported self-dual family are formalized.  No genuine mathematics blocker remains on this
track.  The asymptotic existence theorem is not a kernel-derived fact: it is a formally exact
corollary of one explicitly imported deep theorem.  Accordingly, prose should say
"Lean-checked modulo Stichtenoth Theorem 1.6(ii)" or "with one quarantined literature import,"
not claim a zero-axiom proof of the TVZ theorem itself.

Paper assembly and a specialist novelty audit of the complete-repair-hypergraph transfer are
separate editorial/literature tasks, not formalization blockers.
