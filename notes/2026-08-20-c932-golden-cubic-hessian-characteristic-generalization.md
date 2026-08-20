# Golden cubic Hessians away from characteristics 2, 3, and 5

**Lane:** `clebsch`
**Task:** C932
**Date:** 2026-08-20
**Scope:** mathematics and Lean artifact only; no manuscript edit

## Result

The characteristic-zero assumption has been removed from the Golden cubic
Hessian and ordinary-node chain.

Let `K` be a field. The six normalized chart representatives are defined as
soon as `(5 : K) ≠ 0`, and their dehomogenized Hessian determinants are

\[
  \det \operatorname{Hess}_{\mathrm{chart}}(p_i)=
  \begin{cases}
    1296/5,& i=4,\\
    6480,& i\ne4.
  \end{cases}
\]

Under the same chart hypothesis, the determinant is nonzero if and only if

\[
  (2:K)\ne0 \quad\text{and}\quad (3:K)\ne0.
\]

Thus all six singular frame points are ordinary double points over every field
with `(30 : K) ≠ 0`. This is the sharp range for these displayed Hessians:
characteristic five destroys the chosen normalization, while in
characteristics two and three the determinant formula vanishes.

The formal statements are

- `RelativeConicArcs.GoldenCubicNodeHessians.derivative_gradientCoordinatePolynomial_chart`;
- `RelativeConicArcs.GoldenCubicNodeHessians.det_chartHessian_chartNode`;
- `RelativeConicArcs.GoldenCubicNodeHessians.det_chartHessian_chartNode_ne_zero_iff`;
- `RelativeConicArcs.GoldenCubicNodeHessians.det_chartHessian_chartNode_ne_zero`;
- `RelativeConicArcs.SupportOrientationNodes.supportCubic_framePoints_ordinaryNodes`.

The derivative identity is stronger than needed for the field theorem: it is
now proved over an arbitrary commutative ring rather than only over the
rationals. The characteristic-eleven ordinary-node theorem is no longer a
parallel finite calculation; it specializes the uniform theorem using
`thirty_ne_zero_zmod_eleven`.

## Proof

The determinant evaluation is the same four-by-four Laplace expansion as
before, but its divisions are cleared using only `(5 : K) ≠ 0`. The exact
factorizations

\[
  1296=2^4 3^4,
  \qquad
  6480=2^4 3^4 5
\]

give both directions of the nonvanishing criterion in a field. From
`(30 : K) ≠ 0`, the nonvanishing of `2`, `3`, and `5` follows by the
factorizations `30=15·2=10·3=6·5`; the ordinary-node theorem then combines
the existing rational rank-four deleted-block theorem with the generalized
Hessian result.

## Verification

Focused guarded elaboration passed for
`RelativeConicArcs/GoldenCubicNodeHessians.lean` and
`RelativeConicArcs/SupportOrientationNodes.lean`.

The final queued gate run `20260820-215313-3a77d4f9` passed:

```text
built RelativeConicArcs.Gates.GoldenCubicNodes       0:37.86, 2020604 kB peak
built RelativeConicArcs.Gates.ClebschRigidityTrust  4:09.57, 9600448 kB peak
gate-passed <aggregate>
```

The new iff terminal reports exactly the standard axiom base
`[propext, Classical.choice, Quot.sound]`. The gate logs contain no
`sorryAx`, `native_decide`, `ofReduceBool`, or `trustCompiler` occurrence.

The complete touched-module prose audit found no task identifier, workflow
status, internal-note dependency, unsupported strength claim, or mismatched
mathematical description in the referee-facing Lean artifact.

## Closeout passes

**ej.** Two cheap upgrades were retained: the derivative/Hessian identification
was generalized all the way to commutative rings, and the duplicated `ZMod 11`
determinant computation was replaced by specialization of the uniform theorem.

**tt.** Merely proving sufficiency of `(30 : K) ≠ 0` left the exceptional
characteristics conceptually opaque. Factoring both determinants gives the
stronger iff theorem: after the chart exists, characteristics two and three are
exactly the degeneracy locus.

## Mystery ledger

- **Settled:** characteristic zero was a proof-engineering artifact; the
  ordinary-node chain holds whenever `30` is nonzero.
- **Settled:** the chart formula itself consumes only `5 ≠ 0`.
- **Settled:** under that chart hypothesis, characteristics two and three are
  not merely excluded by the proof; they force Hessian degeneracy.
- **Open boundary:** in characteristic five the selected chart misses one
  displayed node, so this calculation does not separate failure of the chart
  from degeneration of an intrinsic integral model. No claim in the generalized
  theorem requires that analysis, and no successor is allocated.
- **No further task-owned mystery remains.**

The Clebsch discovery-track review found no incidental observation outside the
planned characteristic-boundary analysis, so no discovery entry was added.
