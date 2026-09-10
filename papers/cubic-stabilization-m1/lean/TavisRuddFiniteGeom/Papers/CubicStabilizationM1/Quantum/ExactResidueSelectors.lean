import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoCanonicalLattice
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.EffectiveBlockLedger
import Mathlib.Data.Finsupp.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Basic

/-!
# Exact residue spectra and full-rank odd selectors

The effective exact spectrum is a finitely supported natural-valued function
on the coefficient ring. A nonzero exact rank-two residue discriminant adds
one occurrence at its actual value; zero adds nothing. Its augmentation counts
occurrences. In particular discriminant one is retained. The rank-three odd
weight uses the full even and odd submodule dimensions and is half the odd
dimension when the even dimension is three. No invariant-vector subspace or
quotient of exponents modulo integers occurs in either definition.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

open Classical

/-- The effective singleton at a nonzero exact discriminant; zero contributes
nothing. Repeated additions retain all occurrence multiplicities. -/
noncomputable def exactDiscriminantAtom {B : Type*} [Zero B] (δ : B) : B →₀ ℕ :=
  if δ=0 then 0 else Finsupp.single δ 1

/-- Augmentation of an effective exact spectrum to its total occurrence count. -/
noncomputable def exactSpectrumAugmentation {B : Type*} : (B →₀ ℕ) →+ ℕ where
  toFun s := s.sum fun _ n => n
  map_zero' := by simp
  map_add' s t := by
    exact Finsupp.sum_add_index' (fun _ => rfl) (fun _ _ _ => rfl)

/-- The augmentation counts one precisely when the discriminant is nonzero. -/
theorem exactDiscriminantAtom_augmentation {B : Type*} [Zero B] (δ : B) :
    exactSpectrumAugmentation (exactDiscriminantAtom δ) = if δ=0 then 0 else 1 := by
  classical
  by_cases h : δ=0 <;> simp [exactDiscriminantAtom, exactSpectrumAugmentation, h]

/-- The exact-spectrum atom of an actual rank-two elementary-modification residue. -/
noncomputable def rankTwoExactSpectrumAtom {B : Type*} [CommRing B]
    (loop : PowerSeries (Matrix (Fin 2) (Fin 2) B)) : B →₀ ℕ :=
  exactDiscriminantAtom (residueDiscriminant (modifiedResidue loop))

/-- Injective coefficient extension transports exact spectrum labels and
preserves their multiplicity, including resonant nonzero values. -/
theorem exactDiscriminantAtom_coefficientExtension {B C : Type*} [CommRing B] [CommRing C]
    (f : B →+* C) (injective : Function.Injective f) (δ : B) :
    Finsupp.mapDomain f (exactDiscriminantAtom δ) = exactDiscriminantAtom (f δ) := by
  classical
  have zero : f δ=0 ↔ δ=0 :=
    ⟨fun h => injective (h.trans (map_zero f).symm), fun h => by rw [h,map_zero]⟩
  by_cases h : δ=0 <;> simp [exactDiscriminantAtom, zero, h, Finsupp.mapDomain_single]

/-- Discriminant one has augmentation one: exact spectra do not discard
integer differences of residue eigenvalues. -/
theorem exactDiscriminantAtom_one_detected :
    exactSpectrumAugmentation (exactDiscriminantAtom (1 : ℚ)) = 1 := by
  rw [exactDiscriminantAtom_augmentation]
  norm_num

/-- Regular horizontal comparisons with regular inverses preserve the exact
rank-two spectrum. The discriminant equality is derived from the comparison,
its adapted leading terms, and horizontal nondegenerate pairings. -/
theorem rankTwoExactSpectrumAtom_regularComparison
    {B : Type*} [CommRing B]
    {source target comparison inverse sourcePairing targetPairing :
      PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B} (twoUnit : IsUnit (2 : B))
    (horizontal : IsHorizontalLoopComparison source target comparison)
    (inverseHorizontal : IsHorizontalLoopComparison target source inverse)
    (sourceAdapted : PowerSeries.coeff 0 source = adaptedLeadingOperator sourceUnit)
    (targetAdapted : PowerSeries.coeff 0 target = adaptedLeadingOperator targetUnit)
    (sourceInvertible : IsUnit sourceUnit) (targetInvertible : IsUnit targetUnit)
    (sourceNondegenerate : IsUnit ((PowerSeries.coeff 0 sourcePairing).det))
    (targetNondegenerate : IsUnit ((PowerSeries.coeff 0 targetPairing).det))
    (sourceHorizontal : IsHorizontalPairing source sourcePairing)
    (targetHorizontal : IsHorizontalPairing target targetPairing)
    (leftInverse : comparison * inverse = 1) (rightInverse : inverse * comparison = 1) :
    rankTwoExactSpectrumAtom target = rankTwoExactSpectrumAtom source := by
  unfold rankTwoExactSpectrumAtom
  rw [residueDiscriminant_eq_of_horizontal_pairings_and_inverse twoUnit horizontal
    inverseHorizontal sourceAdapted targetAdapted sourceInvertible targetInvertible
    sourceNondegenerate targetNondegenerate sourceHorizontal targetHorizontal
    leftInverse rightInverse]

/-- The rank-three odd selector uses the full submodule dimensions. Its value
is half the odd dimension when the full even dimension is exactly three. -/
noncomputable def rankThreeFullOddWeight
    {K A : Type*} [Field K] [AddCommGroup A] [Module K A]
    (even odd : Submodule K A) : ℕ :=
  if Module.finrank K even=3 then Module.finrank K odd / 2 else 0

/-- Isomorphisms of the full even and odd subspaces preserve the odd selector. -/
theorem rankThreeFullOddWeight_linearEquiv
    {K A B : Type*} [Field K] [AddCommGroup A] [Module K A]
    [AddCommGroup B] [Module K B]
    (evenA oddA : Submodule K A) (evenB oddB : Submodule K B)
    (evenEquiv : evenA ≃ₗ[K] evenB) (oddEquiv : oddA ≃ₗ[K] oddB) :
    rankThreeFullOddWeight evenA oddA = rankThreeFullOddWeight evenB oddB := by
  simp only [rankThreeFullOddWeight, evenEquiv.finrank_eq, oddEquiv.finrank_eq]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
