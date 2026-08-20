# C932 — Golden cubic Hessians away from characteristics 2, 3, and 5

**Lane:** `clebsch`
**Paper stream:** Paper I Lean development only
**State:** complete 2026-08-20. Report:
`../2026-08-20-c932-golden-cubic-hessian-characteristic-generalization.md`.

## Goal

Remove the artificial characteristic-zero boundary from
`RelativeConicArcs.GoldenCubicNodeHessians`. State the Hessian derivative
identity over a general commutative ring, evaluate the six normalized-node
determinants over every field in which five is nonzero, and prove
nondegeneracy over every field in which thirty is nonzero. Thread the result
through `SupportOrientationNodes`, so the uniform ordinary-node theorem and
its characteristic-eleven specialization use one proof.

## Scope

Allowed paths:

- `lean/RelativeConicArcs/GoldenCubicNodeHessians.lean`;
- `lean/RelativeConicArcs/SupportOrientationNodes.lean`;
- `lean/RelativeConicArcs/Gates/GoldenCubicNodes.lean`;
- this card, the dated report, the live queue, and the Clebsch handoff and
  discovery track at closeout.

No manuscript, mirror, PDF, or unrelated Lean source may be edited.

## Outcome

The Hessian derivative identity is now stated over an arbitrary commutative
ring. The exact determinant formula needs only `(5 : K) ≠ 0`; under that
chart hypothesis, determinant nonvanishing is equivalent to
`(2 : K) ≠ 0 ∧ (3 : K) ≠ 0`. The ordinary-node theorem therefore uses
the same `(30 : K) ≠ 0` hypothesis as the singular-locus classification,
and its `ZMod 11` theorem is a direct specialization. Both scoped gates pass.
No manuscript was edited.

## Acceptance gate

- No declaration in `GoldenCubicNodeHessians` assumes `CharZero` or is
  specialized to `ℚ` without a mathematical need.
- The determinant formula uses the sharp chart hypothesis `(5 : K) ≠ 0`;
  determinant nonvanishing and the ordinary-node theorem use
  `(30 : K) ≠ 0`.
- The `ZMod 11` ordinary-node theorem is a specialization of the uniform
  theorem, not a second determinant computation.
- The touched Lean modules pass guarded elaboration and the existing
  Golden-cubic and Paper-I trust gates, with no `sorry`, compiled-evaluation
  axiom, or new project axiom.
- A dated mathematics report records the theorem, characteristic boundary,
  validation, closeout pass, and mystery ledger. No paper edit is made.
