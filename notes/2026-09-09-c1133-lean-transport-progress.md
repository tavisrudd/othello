# C1133 — exact rank-two transport in Lean

**Date:** 2026-09-09 (local). **Status:** first formal implementation slice passes.
This checkpoint concerns the formal matrix-series comparison algebra; it does
not close the geometric fixed-base transport, the full upgrade, or its literature
audit.

## Proved statement

Module:
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/Quantum/RankTwoLatticeTransport.lean`.
Public terminal in `PaperInterface/Main.lean`:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.rankTwo_modifiedResidueDiscriminant_invariant_under_regular_comparison`.

Over a commutative coefficient ring with 2 invertible, take two centered
rank-two loop connections in adapted frames, with unit upper-right leading
entries, horizontal pairings with invertible constant determinants, and a
regular horizontal comparison with a regular horizontal inverse. Lean proves
equality of the exact discriminants of the canonical modified residues.
There is no nonresonance premise, and no residue conjugacy or discriminant
invariance is assumed.

The proof uses the full power-series identity
`target * G - G * source = z * (z∂z G)`. Its order-zero part forces the
lower-left entry of G(0) to vanish. Conjugation by S=diag(1,z) is then a
regular series represented by the existing `modifiedBase G`. Left
multiplication by S is injective, and the original inverse identities give
inverse modified comparisons. Their constant matrices intertwine the residues:
three entries follow at orders zero/one and the lower-left entry at order two.
The latter accounts for both G's first jet and the -1 diagonal shift.

Exact supporting declarations in the module, all under
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum`:

- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.IsHorizontalLoopComparison.preserves_nilpotentLine`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.modificationGauge_mul_injective`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.modifiedComparison_mul_inverse`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.modifiedComparison_constantCoeff_inverse`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.IsHorizontalLoopComparison.modifiedResidue_intertwines`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.modifiedResidue_conjugate_of_regular_horizontal_inverse`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.residueDiscriminant_eq_of_horizontal_pairings_and_inverse`.

The last theorem composes with the pre-existing pairing argument to derive the
regular coefficients' line preservation. The elementary modification is
represented by its gauge and transformation identities. No sheaf, spectral
cover or quantum comparison is constructed. General coefficient extension,
fixed-base injection and gluing are separate obligations.

## Verification

Working root `/home/tavis/src/othello`; all Lean operations used guarded tools.
The prerequisite AtomicRankTwoFlatRigidity target was trace-current. The new
module was elaborated, built through the queue, and only then imported by the
public interface. Main and the 320-terminal AxiomAudit both built, and the
queue's final aggregate trace check passed.

```sh
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoLatticeTransport \
  --lean-root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean --cores 20-23
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.Main \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit \
  --lean-root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean --cores 20-23
```

The public terminal reports exactly `propext`, `Classical.choice`, `Quot.sound`.
The checker compared the captured audit against the exact expected list and
passed: 187 source files, 320 terminals, 67 claims, 84 machinery declarations,
22 imported sources and 5 evidence bundles. Existing manuscript coverage counts
remain 14 absent / 26 fragment / 26 conditional / 1 complete. This new terminal
is registered as machinery; no manuscript statement has been promoted.

The successful queue directories are
`/home/tavis/.cache/othello-lean-build/run-20260910-004904-504a5f05` (leaf) and
`/home/tavis/.cache/othello-lean-build/run-20260910-005035-c6b286e2` (interface/audit).
The leaf build used 1,834,800 kB peak RSS; the audit used 2,074,800 kB.
The source, exact terminal registry, and expected axiom list are the enduring
verification evidence; local logs record execution, not mathematical premises.
No PDF build or standalone export was needed for this algebra-only checkpoint.

## EJ+TT and Mystery ledger

- **Settled:** the first comparison jet is essential. The constant modified
  comparison is [[G0_00,0],[G1_10,G0_11]], not simply G0. This is now a proved
  formula and feeds residue conjugacy directly.
- **Settled:** resonance poses no obstruction to this algebra. The proof works
  over arbitrary commutative rings subject to the stated unit hypotheses; it
  never divides by a residue eigenvalue difference.
- **Open, precise boundary:** realization by geometric quantum comparisons,
  coefficient-domain faithfulness and common-constant-field descent are not
  proved by this terminal. Owners are L4 and the retained geometric inputs in
  the Lean upgrade map. General-rank analogues are not inferred.
- **Next formal step:** universal residue reduction and its finite Fano
  specializations (L2); rank-three cluster persistence remains core L3, separate
  from optional rank-three residue theory.
