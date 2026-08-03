# C832 Paper IV structural Lean — closeout

**Date:** 2026-08-02

**Lane:** `clebsch`

**Verdict:** complete at the manuscript's declared formal boundary

## Frozen formal surface

The shared module
`lean/RelativeConicArcs/PassantCodeQ13/StructuralUpgrade.lean` supplies
kernel-checked definitions and implications for pair-neighborhood recovery,
unary constancy, the theta quadratic inequality, the two weight-ten moment
shapes, pencil-conic discriminants, hidden-cubic cancellation, and the abstract
recovered-plane interface.

The paper-owned `PassantCodeQ13.StructuralUpgrade` checks the concrete q=13
leaves for unary degree 56, color-eight polar rows, the 2/4 splitter of the
fused color, all three toric sizes and passant parities, the relation-operator
cubic on its image, the 183 normalized projective coordinates, the 14-point
determinant conic, and both projective-plane uniqueness axioms.  The aggregate
exports `pairOnlyReconstruction`, `toricMinimumSupports`,
`hiddenFieldCubicOnImage`, and `ambientPlaneIncidence`; every new native leaf
and aggregate appears in the tracked axiom audit.

The exact theta positivity/kernel calculation, stabilizer-prefix tables,
octahedral matching leaf, and Sylow/involution census remain hashed Python
executions.  The transport from those finite/group-theoretic facts to the
paper theorem remains human.  No claim of full kernel formalization is made.

## Gates

- shared focused Lake build: PASS (3017 jobs);
- standalone paper aggregate and axiom-audit build: PASS;
- paper `make check`: PASS;
- evidence-manifest source identities: PASS;
- private-workflow source screen and `git diff --check`: PASS.

The build reports only pre-existing unused-`simp` lints in the older
row-uniqueness aggregate.

## `ej` — strongest objection

A concrete 183-point incidence check is not itself a formal proof that the
abstract Sylow/involution construction is that plane, and the cubic identity
on the operator image is not a complete construction of \(\mathbf F_8^{12}\).
The manuscript therefore labels these exactly as a Lean incidence gate and a
Lean hidden-cubic theorem, while retaining the adjoint transport and field
interpretation as human algebra backed by exact matrix data.

## `tt` — formal architecture

Generic implications live in the shared library; bounded q=13 evaluation
lives in the paper package; aggregate theorem names match the trust table; the
axiom audit reveals all native execution.  This prevents either coordinate
enumeration or trusted Python from masquerading as kernel proof.

## `ej2`, mystery ledger, and vibe

The reusable gain is the pair-only reconstruction certificate: future conic
codes can target the same interface without inheriting q=13 coordinates.
Still open are full formal Sylow/involution transport, an internal PSD matrix
certificate, the stabilizer leaves, the octahedral construction, and an
explicit finite-field module equivalence.  Those are accurately outside the
present paper's formal claim.

**Vibe:** small semantic spine, explicit finite leaves, no theorem-shaped fog.
