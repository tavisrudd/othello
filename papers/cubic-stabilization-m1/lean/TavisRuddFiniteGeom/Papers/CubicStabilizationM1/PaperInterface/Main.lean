import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoLatticeTransport
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ParameterizedRankTwoResidue
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

/-- Exact finite-coefficient reduction of the parameterized four-dimensional
system. The leading matrix has a double zero root, the displayed rational basis
splits its leading blocks, and the first gauge solves the first-order equation.
The modified zero-block residue has the displayed characteristic polynomial
and exact discriminant. The nonvanishing hypotheses are precisely those needed
by the rational block basis. These are identities of explicit matrices over an
arbitrary characteristic-zero field; no geometric quantum product or complete
formal gauge is constructed by this statement. -/
theorem parameterizedRankTwo_finiteReduction
    {K : Type*} [Field K] [CharZero K] {a b q : K}
    (sumNonzero : 2*a+b ≠ 0) (qNonzero : q ≠ 0) :
    (Quantum.parameterizedEulerMatrix a b q).charpoly =
        Polynomial.X^2 * (Polynomial.X^2 - Polynomial.C ((2*a+b)*q)) ∧
    (Quantum.parameterizedBlockBasis a b q * Quantum.parameterizedBlockBasisInverse a b q = 1 ∧
      Quantum.parameterizedBlockBasisInverse a b q * Quantum.parameterizedBlockBasis a b q = 1) ∧
    Quantum.parameterizedEulerMatrix a b q * Quantum.parameterizedBlockBasis a b q =
      Quantum.parameterizedBlockBasis a b q * Quantum.parameterizedEulerBlocks a b q ∧
    Quantum.parameterizedGradingBlocks a b +
        Quantum.parameterizedEulerBlocks a b q * Quantum.parameterizedGaugeFirst a b q -
        Quantum.parameterizedGaugeFirst a b q * Quantum.parameterizedEulerBlocks a b q =
      Quantum.parameterizedReducedFirst a b ∧
    (Quantum.parameterizedModifiedResidue a b).charpoly =
      Polynomial.X^2 + Polynomial.X + Polynomial.C ((10*a-3*b)/(4*(2*a+b))) ∧
    Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue a b) =
      4*(b-2*a)/(2*a+b) :=
  ⟨Quantum.parameterizedEulerMatrix_charpoly a b q,
    Quantum.parameterizedBlockBasis_inverse sumNonzero qNonzero,
    Quantum.parameterizedEulerMatrix_mul_blockBasis a b q,
    Quantum.parameterizedReduction_first_order sumNonzero qNonzero,
    Quantum.parameterizedModifiedResidue_charpoly sumNonzero,
    Quantum.parameterizedModifiedResidue_discriminant sumNonzero⟩

/-- The four rational input pairs give exact modified-residue discriminants
16/9, 1, 4/9 and 0. In particular the discriminant-one case is retained without
reducing exponents modulo integers. This terminal evaluates explicit matrices;
it does not identify them with geometric Fano quantum products. -/
theorem parameterizedRankTwo_fourDiscriminants :
    Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue (240 : ℚ) 1248) = 16/9 ∧
      Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue (48 : ℚ) 160) = 1 ∧
      Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue (24 : ℚ) 60) = 4/9 ∧
      Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue (16 : ℚ) 32) = 0 :=
  Quantum.parameterizedModifiedResidue_fano_values

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
