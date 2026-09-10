import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoLatticeTransport
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.Introduction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.CategoricalOneStep
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.FormalConnections
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.ResiduePairing

/-!
# Reviewer interface for the primary one-stabilization paper

This is the public formal entry point for *Irrationality of Cubic Threefolds
after One Stabilization*.  It exports the generic-even-QDM ledger, the
formal-exponent marker, the cubic calculation, low-dimensional nullity, and
the primary paper's applications.  Geometric and literature inputs remain
explicit in the declaration types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

/-- Exact residue-discriminant transport for formal rank-two connections over
a commutative ring in which two is invertible. Both connections are centered
and adapted, with unit upper-right leading entries and horizontal pairings
whose constant coefficients are invertible. A regular horizontal comparison
and a regular horizontal inverse induce mutually inverse comparisons on the
modified lattice and conjugate its residues. Thus the exact discriminant is
preserved, including when the residue eigenvalues differ by an integer.

The connections and pairings are actual formal matrix series. Lean constructs
neither geometric quantum connections nor their comparison isomorphisms;
identification of a geometric factor with these data is outside the statement.
The induced comparison depends on the first jet of the original comparison.
No modified-residue conjugacy or discriminant equality is supplied as a premise. -/
theorem rankTwo_modifiedResidueDiscriminant_invariant_under_regular_comparison
    {B : Type*} [CommRing B]
    {source target comparison inverse sourcePairing targetPairing :
      PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B} (twoUnit : IsUnit (2 : B))
    (horizontal : Quantum.IsHorizontalLoopComparison source target comparison)
    (inverseHorizontal : Quantum.IsHorizontalLoopComparison target source inverse)
    (sourceAdapted : PowerSeries.coeff 0 source = Quantum.adaptedLeadingOperator sourceUnit)
    (targetAdapted : PowerSeries.coeff 0 target = Quantum.adaptedLeadingOperator targetUnit)
    (sourceInvertible : IsUnit sourceUnit) (targetInvertible : IsUnit targetUnit)
    (sourceNondegenerate : IsUnit ((PowerSeries.coeff 0 sourcePairing).det))
    (targetNondegenerate : IsUnit ((PowerSeries.coeff 0 targetPairing).det))
    (sourceHorizontal : Quantum.IsHorizontalPairing source sourcePairing)
    (targetHorizontal : Quantum.IsHorizontalPairing target targetPairing)
    (leftInverse : comparison * inverse = 1)
    (rightInverse : inverse * comparison = 1) :
    Quantum.residueDiscriminant (Quantum.modifiedResidue target) =
      Quantum.residueDiscriminant (Quantum.modifiedResidue source) :=
  Quantum.residueDiscriminant_eq_of_horizontal_pairings_and_inverse twoUnit horizontal
    inverseHorizontal sourceAdapted targetAdapted sourceInvertible targetInvertible
    sourceNondegenerate targetNondegenerate sourceHorizontal targetHorizontal
    leftInverse rightInverse

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
