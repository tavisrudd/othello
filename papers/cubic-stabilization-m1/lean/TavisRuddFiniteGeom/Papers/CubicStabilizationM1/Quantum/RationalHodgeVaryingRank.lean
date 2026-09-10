import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RationalWholeHodgeConservation

/-!
# Rational conservation with independently specified endpoint ranks

A complex comparison in rationally indexed bases consists of its rank equality
and an invertible complex matrix. Realizing the whole conserved comparison in
this form does not require the two endpoint ranks to be identified in advance.
Scalar-extension fullness for the whole rational Hodge-morphism space then
yields the rank equality together with a rational Hodge isomorphism. No
rational descent of individual branches is used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

universe u v

/-- An actual complex comparison between finite coordinate spaces forces
equality of their ranks. -/
theorem complexLinearComparison_rank_eq {leftRank rightRank : ℕ}
    (comparison : (Fin leftRank → ℂ) ≃ₗ[ℂ] (Fin rightRank → ℂ)) : leftRank=rightRank := by
  simpa using comparison.finrank_eq

/-- Whole-object rational Hodge conservation for endpoints whose ranks are
specified independently. Rank equality is part of the realized complex
comparison; the rational isomorphism is derived by determinant descent. -/
noncomputable def rationalWholeHodgeIso_of_stabilizedBirationality_varyingRanks
    {K Variety Center Occurrence Family : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (data : StabilizedWholeOddData K Variety Center Occurrence Family ι division)
    {left right : Family} (leftSmooth : data.smooth left) (rightSmooth : data.smooth right)
    (related : data.birational.r (data.stabilized left) (data.stabilized right))
    {leftRank rightRank : ℕ} {Index : Type*} [Fintype Index]
    (leftHodge : RationalWeightThreeHodgeMatrices leftRank)
    (rightHodge : RationalWeightThreeHodgeMatrices rightRank)
    (family : (equality : leftRank=rightRank) → Index → Matrix (Fin leftRank) (Fin leftRank) ℚ)
    (members : ∀ (equality : leftRank=rightRank) (i : Index), family equality i ∈
      rationalHodgeMorphismSubspace leftHodge (equality.symm ▸ rightHodge))
    (realizeWholeComparison : CategoryTheory.Iso (data.wholeOdd left) (data.wholeOdd right) →
      PSigma (fun _ : leftRank=rightRank => (Matrix (Fin leftRank) (Fin leftRank) ℂ)ˣ))
    (scalarExtensionFull : ∀ comparison, ∃ coefficient : Index → ℂ,
      ∑ i, coefficient i • (family (realizeWholeComparison comparison).1 i).map (algebraMap ℚ ℂ)=
        ((realizeWholeComparison comparison).2 : Matrix (Fin leftRank) (Fin leftRank) ℂ)) :
    PSigma (fun equality : leftRank=rightRank =>
      RationalWeightThreeHodgeMatrixIso leftHodge (equality.symm ▸ rightHodge)) := by
  let comparison := data.wholeOddIso leftSmooth rightSmooth related
  let realized := realizeWholeComparison comparison
  refine ⟨realized.1,?_⟩
  let coefficient := Classical.choose (scalarExtensionFull comparison)
  have equation := Classical.choose_spec (scalarExtensionFull comparison)
  apply rationalHodgeMatrixIso_of_extendedCombination leftHodge _ (family realized.1)
    (members realized.1) coefficient
  rw [equation]
  exact isUnit_iff_ne_zero.mp (Matrix.isUnits_det_units realized.2)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
