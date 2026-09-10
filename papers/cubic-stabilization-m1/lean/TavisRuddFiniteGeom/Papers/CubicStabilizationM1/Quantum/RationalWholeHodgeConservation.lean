import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RationalHodgeMatrixDescent
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.StabilizedWholeOddConservation

/-!
# Rational Hodge conservation by descent of the whole comparison

The proved safe-object conservation supplies a comparison of whole endpoint
objects. Its realization is an invertible complex matrix. Scalar-extension
fullness places this one matrix in the complex span of actual rational Hodge
morphisms. Determinant-polynomial descent then constructs an invertible
rational Hodge morphism and its rational inverse.

The endpoint projectors are effective pure weight-three rational Hodge
structures in chosen rational bases. Geometric endpoint identification,
realization of the whole comparison, and scalar-extension fullness of its
Hodge-morphism space are explicit inputs. No rational descent of individual
splitting branches or equivalence of an entire complex representation category
with the rational Hodge category is required.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

universe u v

/-- Stabilized birationality gives an actual rational Hodge isomorphism of
whole endpoint objects by descending their conserved complex comparison.
The scalar-extension hypothesis concerns only the whole morphism space. -/
noncomputable def rationalWholeHodgeIso_of_stabilizedBirationality
    {K Variety Center Occurrence Family : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (data : StabilizedWholeOddData K Variety Center Occurrence Family ι division)
    {left right : Family} (leftSmooth : data.smooth left) (rightSmooth : data.smooth right)
    (related : data.birational.r (data.stabilized left) (data.stabilized right))
    {rank : ℕ} {Index : Type*} [Fintype Index]
    (leftHodge rightHodge : RationalWeightThreeHodgeMatrices rank)
    (family : Index → Matrix (Fin rank) (Fin rank) ℚ)
    (members : ∀ i, family i ∈ rationalHodgeMorphismSubspace leftHodge rightHodge)
    (realizeWholeComparison : CategoryTheory.Iso (data.wholeOdd left) (data.wholeOdd right) →
      (Matrix (Fin rank) (Fin rank) ℂ)ˣ)
    (scalarExtensionFull : ∀ comparison, ∃ coefficient : Index → ℂ,
      ∑ i, coefficient i • (family i).map (algebraMap ℚ ℂ)=
        (realizeWholeComparison comparison : Matrix (Fin rank) (Fin rank) ℂ)) :
    RationalWeightThreeHodgeMatrixIso leftHodge rightHodge := by
  let comparison := data.wholeOddIso leftSmooth rightSmooth related
  let coefficient := Classical.choose (scalarExtensionFull comparison)
  have equation := Classical.choose_spec (scalarExtensionFull comparison)
  apply rationalHodgeMatrixIso_of_extendedCombination leftHodge rightHodge family members coefficient
  rw [equation]
  exact isUnit_iff_ne_zero.mp (Matrix.isUnits_det_units (realizeWholeComparison comparison))

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
