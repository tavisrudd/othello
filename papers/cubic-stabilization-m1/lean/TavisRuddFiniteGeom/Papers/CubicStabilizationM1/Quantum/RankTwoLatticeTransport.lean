import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.AtomicRankTwoFlatRigidity

/-!
# Regular comparisons on the rank-two modified lattice

Over a commutative ring, let two loop connections be represented by the formal
matrix series obtained by clearing their simple poles. Their leading matrices
are unit multiples of the upper-right matrix unit. A horizontal comparison `G`
satisfies `target * G - G * source = u * (u ∂_u G)`.

The leading coefficient of this identity makes `G` preserve the first coordinate
line modulo `u`. Consequently conjugation by `S = diag(1,u)` is regular: the
series `modifiedBase G` satisfies `S * modifiedBase G = G * S`. The same holds
for a regular horizontal inverse. The transformed series are mutually inverse,
and their constant coefficients intertwine the modified residues. This constant
coefficient contains the lower-left entry of the first jet of `G`, so it need
not be the original constant comparison matrix.

All statements concern actual formal matrix series in adapted frames. No
geometric quantum connection or spectral cover is constructed. No assumption
on residue eigenvalue differences, and in particular no nonresonance assumption,
is imposed. The elementary modification is represented by its gauge and its
transformation identities, not by a separately constructed sheaf.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1
namespace Quantum

open Matrix PowerSeries

variable {B : Type*} [CommRing B]

/-- Horizontality of a regular comparison from the source loop connection to
the target, with both loop matrices cleared of their simple poles. -/
def IsHorizontalLoopComparison
    (source target comparison : PowerSeries (Matrix (Fin 2) (Fin 2) B)) : Prop :=
  target * comparison - comparison * source = PowerSeries.X * loopEulerOperator comparison

/-- A horizontal comparison intertwines the leading operators. -/
theorem IsHorizontalLoopComparison.leading
    {source target comparison : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    (horizontal : IsHorizontalLoopComparison source target comparison) :
    coeff 0 target * coeff 0 comparison = coeff 0 comparison * coeff 0 source := by
  have equality := congrArg (fun f => coeff 0 f) horizontal
  simpa only [map_sub, coeff_zero_mul_matrixSeries, PowerSeries.coeff_zero_X_mul,
    sub_eq_zero] using equality

/-- With unit upper-right leading entries, the constant comparison preserves
the nilpotent line: its lower-left entry is zero. -/
theorem IsHorizontalLoopComparison.preserves_nilpotentLine
    {source target comparison : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B}
    (horizontal : IsHorizontalLoopComparison source target comparison)
    (sourceAdapted : coeff 0 source = adaptedLeadingOperator sourceUnit)
    (targetAdapted : coeff 0 target = adaptedLeadingOperator targetUnit)
    (targetInvertible : IsUnit targetUnit) :
    (coeff 0 comparison) 1 0 = 0 := by
  apply eq_zero_of_isUnit_mul targetInvertible
  have entry := congrFun (congrFun horizontal.leading 0) 0
  simpa [sourceAdapted, targetAdapted, adaptedLeadingOperator,
    Matrix.mul_apply, Fin.sum_univ_two] using entry

/-- Left multiplication by `diag(1,u)` reflects equality of formal matrix
series. This is the cancellation used to transport inverse comparisons. -/
theorem modificationGauge_mul_injective :
    Function.Injective (fun f : PowerSeries (Matrix (Fin 2) (Fin 2) B) =>
      modificationGauge * f) := by
  intro f g equality
  change modificationGauge * f = modificationGauge * g at equality
  apply sub_eq_zero.mp
  apply eq_zero_of_modificationGauge_mul_eq_zero
  rw [mul_sub, equality, sub_self]

/-- The regular comparison on the modified lattice has lower-left constant
entry equal to the first lower-left jet of the original comparison. -/
theorem modifiedComparison_constantCoeff
    (comparison : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    coeff 0 (modifiedBase comparison) =
      !![(coeff 0 comparison) 0 0, 0;
         (coeff 1 comparison) 1 0, (coeff 0 comparison) 1 1] := by
  simp [modifiedBase]

/-- Regular comparisons preserving the nilpotent line retain their inverse
identity after modification. Only this one inverse identity is needed here. -/
theorem modifiedComparison_mul_inverse
    {comparison inverse : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    (comparisonLine : (coeff 0 comparison) 1 0 = 0)
    (inverseLine : (coeff 0 inverse) 1 0 = 0)
    (inverseIdentity : comparison * inverse = 1) :
    modifiedBase comparison * modifiedBase inverse = 1 := by
  apply modificationGauge_mul_injective
  calc
    modificationGauge * (modifiedBase comparison * modifiedBase inverse)
        = comparison * (modificationGauge * modifiedBase inverse) := by
          rw [← mul_assoc, modificationGauge_mul_modifiedBase comparisonLine, mul_assoc]
    _ = comparison * (inverse * modificationGauge) := by
          rw [modificationGauge_mul_modifiedBase inverseLine]
    _ = modificationGauge * 1 := by rw [← mul_assoc, inverseIdentity, one_mul, mul_one]

/-- The constant coefficients of mutually inverse modified comparisons are
mutually inverse matrices. -/
theorem modifiedComparison_constantCoeff_inverse
    {comparison inverse : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    (comparisonLine : (coeff 0 comparison) 1 0 = 0)
    (inverseLine : (coeff 0 inverse) 1 0 = 0)
    (leftInverse : comparison * inverse = 1)
    (rightInverse : inverse * comparison = 1) :
    coeff 0 (modifiedBase comparison) * coeff 0 (modifiedBase inverse) = 1 ∧
      coeff 0 (modifiedBase inverse) * coeff 0 (modifiedBase comparison) = 1 := by
  constructor
  · simpa [coeff_zero_mul_matrixSeries] using
      congrArg (fun f => coeff 0 f)
        (modifiedComparison_mul_inverse comparisonLine inverseLine leftInverse)
  · simpa [coeff_zero_mul_matrixSeries] using
      congrArg (fun f => coeff 0 f)
        (modifiedComparison_mul_inverse inverseLine comparisonLine rightInverse)

/-- The first two nonleading coefficients of horizontality imply that the
constant modified comparison intertwines the modified residues. The lower-left
entry uses the coefficient of order two, accounting for the first comparison
jet and the `-1` shift in the second diagonal residue entry. -/
theorem IsHorizontalLoopComparison.modifiedResidue_intertwines
    {source target comparison : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B}
    (horizontal : IsHorizontalLoopComparison source target comparison)
    (sourceAdapted : coeff 0 source = adaptedLeadingOperator sourceUnit)
    (targetAdapted : coeff 0 target = adaptedLeadingOperator targetUnit)
    (targetInvertible : IsUnit targetUnit)
    (sourceLine : (coeff 1 source) 1 0 = 0)
    (targetLine : (coeff 1 target) 1 0 = 0) :
    modifiedResidue target * coeff 0 (modifiedBase comparison)
      = coeff 0 (modifiedBase comparison) * modifiedResidue source := by
  have comparisonLine := horizontal.preserves_nilpotentLine
    sourceAdapted targetAdapted targetInvertible
  have comparisonConstant : (constantCoeff comparison) 1 0 = 0 := by
    simpa only [PowerSeries.coeff_zero_eq_constantCoeff_apply] using comparisonLine
  have orderZero := horizontal.leading
  have orderOne := congrArg (fun f => coeff 1 f) horizontal
  have orderTwo := congrArg (fun f => coeff 2 f) horizontal
  simp only [map_sub, coeff_one_mul_matrixSeries, PowerSeries.coeff_succ_X_mul,
    coeff_loopEulerOperator, zero_smul] at orderOne
  simp only [map_sub, coeff_two_mul_matrixSeries, PowerSeries.coeff_succ_X_mul,
    coeff_loopEulerOperator, one_smul] at orderTwo
  have zero01 := congrFun (congrFun orderZero 0) 1
  have one00 := congrFun (congrFun orderOne 0) 0
  have one11 := congrFun (congrFun orderOne 1) 1
  have two10 := congrFun (congrFun orderTwo 1) 0
  simp [sourceAdapted, targetAdapted, adaptedLeadingOperator, Matrix.mul_apply,
    Fin.sum_univ_two, Matrix.vecMul, dotProduct, comparisonConstant, sourceLine, targetLine]
    at zero01 one00 one11 two10
  rw [modifiedResidue_eq, modifiedResidue_eq, modifiedComparison_constantCoeff]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, sourceAdapted, targetAdapted,
      adaptedLeadingOperator]
  · linear_combination one00
  · exact zero01
  · linear_combination two10
  · linear_combination one11

/-- A regular horizontal isomorphism with a regular horizontal inverse
conjugates the canonical modified residues. Both original connections are in
adapted frames, and their regular coefficients preserve the leading nilpotent
line. No condition on residue eigenvalue differences is required. -/
theorem modifiedResidue_conjugate_of_regular_horizontal_inverse
    {source target comparison inverse : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B}
    (horizontal : IsHorizontalLoopComparison source target comparison)
    (inverseHorizontal : IsHorizontalLoopComparison target source inverse)
    (sourceAdapted : coeff 0 source = adaptedLeadingOperator sourceUnit)
    (targetAdapted : coeff 0 target = adaptedLeadingOperator targetUnit)
    (sourceInvertible : IsUnit sourceUnit) (targetInvertible : IsUnit targetUnit)
    (sourceLine : (coeff 1 source) 1 0 = 0)
    (targetLine : (coeff 1 target) 1 0 = 0)
    (leftInverse : comparison * inverse = 1)
    (rightInverse : inverse * comparison = 1) :
    modifiedResidue target = coeff 0 (modifiedBase comparison) * modifiedResidue source
      * coeff 0 (modifiedBase inverse) := by
  have comparisonLine := horizontal.preserves_nilpotentLine
    sourceAdapted targetAdapted targetInvertible
  have inverseLine := inverseHorizontal.preserves_nilpotentLine
    targetAdapted sourceAdapted sourceInvertible
  have inverses := modifiedComparison_constantCoeff_inverse
    comparisonLine inverseLine leftInverse rightInverse
  have intertwines := horizontal.modifiedResidue_intertwines
    sourceAdapted targetAdapted targetInvertible sourceLine targetLine
  calc
    modifiedResidue target = modifiedResidue target *
        (coeff 0 (modifiedBase comparison) * coeff 0 (modifiedBase inverse)) := by
          rw [inverses.1, mul_one]
    _ = coeff 0 (modifiedBase comparison) * modifiedResidue source *
        coeff 0 (modifiedBase inverse) := by rw [← mul_assoc, intertwines]

/-- The exact modified-residue discriminant is preserved by a regular
horizontal isomorphism and its regular horizontal inverse. Integer differences
of residue eigenvalues are allowed. -/
theorem residueDiscriminant_eq_of_regular_horizontal_inverse
    {source target comparison inverse : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B}
    (horizontal : IsHorizontalLoopComparison source target comparison)
    (inverseHorizontal : IsHorizontalLoopComparison target source inverse)
    (sourceAdapted : coeff 0 source = adaptedLeadingOperator sourceUnit)
    (targetAdapted : coeff 0 target = adaptedLeadingOperator targetUnit)
    (sourceInvertible : IsUnit sourceUnit) (targetInvertible : IsUnit targetUnit)
    (sourceLine : (coeff 1 source) 1 0 = 0)
    (targetLine : (coeff 1 target) 1 0 = 0)
    (leftInverse : comparison * inverse = 1)
    (rightInverse : inverse * comparison = 1) :
    residueDiscriminant (modifiedResidue target) =
      residueDiscriminant (modifiedResidue source) := by
  have comparisonLine := horizontal.preserves_nilpotentLine
    sourceAdapted targetAdapted targetInvertible
  have inverseLine := inverseHorizontal.preserves_nilpotentLine
    targetAdapted sourceAdapted sourceInvertible
  have inverses := modifiedComparison_constantCoeff_inverse
    comparisonLine inverseLine leftInverse rightInverse
  rw [modifiedResidue_conjugate_of_regular_horizontal_inverse horizontal inverseHorizontal
    sourceAdapted targetAdapted sourceInvertible targetInvertible sourceLine targetLine
    leftInverse rightInverse]
  exact residueDiscriminant_conjugate _ _ _ inverses.1 inverses.2


/-- Horizontal nondegenerate pairings supply preservation of the nilpotent
lines, so exact residue-discriminant invariance follows from the regular
horizontal comparison, its inverse, and the two pairings alone. -/
theorem residueDiscriminant_eq_of_horizontal_pairings_and_inverse
    {source target comparison inverse sourcePairing targetPairing :
      PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B} (twoUnit : IsUnit (2 : B))
    (horizontal : IsHorizontalLoopComparison source target comparison)
    (inverseHorizontal : IsHorizontalLoopComparison target source inverse)
    (sourceAdapted : coeff 0 source = adaptedLeadingOperator sourceUnit)
    (targetAdapted : coeff 0 target = adaptedLeadingOperator targetUnit)
    (sourceInvertible : IsUnit sourceUnit) (targetInvertible : IsUnit targetUnit)
    (sourceNondegenerate : IsUnit ((coeff 0 sourcePairing).det))
    (targetNondegenerate : IsUnit ((coeff 0 targetPairing).det))
    (sourceHorizontal : IsHorizontalPairing source sourcePairing)
    (targetHorizontal : IsHorizontalPairing target targetPairing)
    (leftInverse : comparison * inverse = 1)
    (rightInverse : inverse * comparison = 1) :
    residueDiscriminant (modifiedResidue target) =
      residueDiscriminant (modifiedResidue source) :=
  residueDiscriminant_eq_of_regular_horizontal_inverse horizontal inverseHorizontal
    sourceAdapted targetAdapted sourceInvertible targetInvertible
    (nilpotentLine_of_isHorizontalPairing twoUnit sourceInvertible sourceAdapted
      sourceNondegenerate sourceHorizontal)
    (nilpotentLine_of_isHorizontalPairing twoUnit targetInvertible targetAdapted
      targetNondegenerate targetHorizontal) leftInverse rightInverse

end Quantum
end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
