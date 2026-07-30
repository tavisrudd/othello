# C698 — Paper I signed two-graph core

**Lane:** `build-sys`
**Opened:** 2026-07-29
**Status:** queued; first Paper I v2 formalization task.

## Objective

Formalize the human-scale signed-two-graph, golden-operator, cubic, node,
symmetry, and integral-commutant results needed by Paper I v2 in
`~/src/lean/finitegeom`.

## Acceptance

- Add reusable signed complete graph/Seidel switching and triangle-holonomy
  APIs, including four-point reconstruction and pair balance.
- Prove the explicit six-vertex identities \(B^2=5I\), the diagonal-pencil
  determinant formula, and uniqueness of the balanced switching class.
- Prove that the cubic has exactly six ordinary nodes forming a projective
  frame before identifying its full projective automorphism group.
- Distinguish the order-120 cubic symmetry from the oriented order-60
  subgroup.
- Prove the integral centralizer/order statement needed for
  \(\mathbf Z[\sqrt5]\).
- Add narrow terminals, a human aggregate gate, trust declaration, exact
  axiom audit, and clean-checkout replay on the pinned toolchain.
- Cite the standard two-graph dictionary and record the exact coordinate
  equivalence with Cheltsov--Tschinkel--Zhang's six-nodal cubic.

## Boundaries

No q11/q13 generated data enters `finitegeom`.  Preserve the v1 Paper I
gate.  A computed polynomial-line stabilizer is not yet the full
projective automorphism group without the singular-locus/frame bridge.

## Plan

`notes/2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md`
