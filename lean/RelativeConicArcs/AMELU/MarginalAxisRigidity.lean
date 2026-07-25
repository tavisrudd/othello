import RelativeConicArcs.AMELU.FourMarginalDiagonal

/-!
# Axis rigidity of a four-party MDS marginal

Coordinate relabellings transport the common shortening parameter to the
ordinary Weyl label at each party.  If the four local conjugation maps
intertwine the two marginal coefficient arrays, the diagonal-tensor
contraction theorem forces every transported factor to be monomial.
Undoing the shortening relabellings shows that the original unitary
conjugation permutes all Weyl axes and hence is Clifford.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Relabel function coordinates along an equivalence of index types. -/
def relabelCoordinateEquiv {κ κ₂ : Type*} (e : κ ≃ κ₂) :
    (κ → ℂ) ≃ₗ[ℂ] (κ₂ → ℂ) where
  toFun f := fun j => f (e.symm j)
  invFun g := fun i => g (e i)
  left_inv f := by
    funext i
    simp
  right_inv g := by
    funext j
    simp
  map_add' f g := rfl
  map_smul' z f := rfl

omit [Field 𝔽] [Fintype 𝔽] in
/-- Relabelling sends a coordinate vector to the equivalently labelled
coordinate vector. -/
theorem relabelCoordinateEquiv_coordinateVector
    {κ κ₂ : Type*} [DecidableEq κ] [DecidableEq κ₂]
    (e : κ ≃ κ₂) (i : κ) (z : ℂ) :
    relabelCoordinateEquiv e (coordinateVector i z) =
      coordinateVector (e i) z := by
  funext j
  by_cases hj : j = e i
  · subst j
    simp [relabelCoordinateEquiv, coordinateVector]
  · have hsymm : e.symm j ≠ i := by
      intro h
      apply hj
      rw [← e.apply_symm_apply j, h]
    simp [relabelCoordinateEquiv, coordinateVector, hj, hsymm]

/-- Weyl-coordinate conjugation written in the shortening parameters of
the source and target four-party marginals. -/
noncomputable def transportedLocalConjugation
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C) (hD : IsMDSCode634 D)
    {S : Finset Party} (hS : S.card = 4) {i : Party} (hi : i ∈ S)
    (U : LocalMatrix 𝔽) (hU : IsUnitaryMatrix U) :
    (𝔽 × 𝔽 → ℂ) ≃ₗ[ℂ] (𝔽 × 𝔽 → ℂ) :=
  relabelCoordinateEquiv (shorteningLocalLabelEquiv hC hS hi) ≪≫ₗ
    unitaryConjugationWeylEquiv w U hU ≪≫ₗ
      (relabelCoordinateEquiv
        (shorteningLocalLabelEquiv hD hS hi)).symm

/-- An ordered four-party marginal intertwining, expressed in the
shortening coordinates in which both MDS marginal tensors are diagonal. -/
def FourMarginalIntertwining
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C) (hD : IsMDSCode634 D)
    {S : Finset Party} (hS : S.card = 4) (e : Fin 4 ≃ S)
    (U : Party → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i)) :
    Prop :=
  mapFourArray
      (transportedLocalConjugation w hC hD hS (e 0).2
        (U (e 0)) (hU (e 0)))
      (transportedLocalConjugation w hC hD hS (e 1).2
        (U (e 1)) (hU (e 1)))
      (transportedLocalConjugation w hC hD hS (e 2).2
        (U (e 2)) (hU (e 2)))
      (transportedLocalConjugation w hC hD hS (e 3).2
        (U (e 3)) (hU (e 3)))
      (reindexedFourMarginalArray w hC hS e) =
    reindexedFourMarginalArray w hD hS e

omit [DecidableEq 𝔽] in
private theorem diagonalCoefficient_ne_zero :
    (((Fintype.card 𝔽 : ℂ) ^ 4)⁻¹ : ℂ) ≠ 0 := by
  have hcard : (Fintype.card 𝔽 : ℂ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  exact inv_ne_zero (pow_ne_zero 4 hcard)

omit [Field 𝔽] [Fintype 𝔽] in
private theorem relabelCoordinateEquiv_preserves_axis
    {κ κ₂ : Type*} [DecidableEq κ] [DecidableEq κ₂]
    (e : κ ≃ κ₂) {f : κ → ℂ}
    (hf : IsNonzeroCoordinateAxis f) :
    IsNonzeroCoordinateAxis (relabelCoordinateEquiv e f) := by
  obtain ⟨i, z, hz, rfl⟩ := hf
  exact ⟨e i, z, hz, relabelCoordinateEquiv_coordinateVector e i z⟩

/-- If the ordered four-party marginal coefficient arrays are
intertwined by the four local unitary conjugations, the first ordered
local unitary is Clifford.  Reordering the four-set gives the result for
any retained party. -/
theorem firstParty_isClifford_of_fourMarginalIntertwining
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C) (hD : IsMDSCode634 D)
    {S : Finset Party} (hS : S.card = 4) (e : Fin 4 ≃ S)
    (U : Party → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (hintertwine :
      FourMarginalIntertwining w hC hD hS e U hU) :
    IsCliffordMatrix w (U (e 0)) := by
  classical
  let A :=
    transportedLocalConjugation w hC hD hS (e 0).2
      (U (e 0)) (hU (e 0))
  let B :=
    transportedLocalConjugation w hC hD hS (e 1).2
      (U (e 1)) (hU (e 1))
  let C₂ :=
    transportedLocalConjugation w hC hD hS (e 2).2
      (U (e 2)) (hU (e 2))
  let D₂ :=
    transportedLocalConjugation w hC hD hS (e 3).2
      (U (e 3)) (hU (e 3))
  have hmap :
      mapFourArray A B C₂ D₂
          (diagonalFourArray
            (fun _ : 𝔽 × 𝔽 => ((Fintype.card 𝔽 : ℂ) ^ 4)⁻¹)) =
        diagonalFourArray
          (fun _ : 𝔽 × 𝔽 => ((Fintype.card 𝔽 : ℂ) ^ 4)⁻¹) := by
    change
      mapFourArray A B C₂ D₂ (reindexedFourMarginalArray w hC hS e) =
        reindexedFourMarginalArray w hD hS e at hintertwine
    rw [reindexedFourMarginalArray_eq_diagonal w hC hS e,
      reindexedFourMarginalArray_eq_diagonal w hD hS e] at hintertwine
    exact hintertwine
  have hAaxes :
      ∀ t : 𝔽 × 𝔽,
        IsNonzeroCoordinateAxis (A (coordinateVector t 1)) :=
    firstFactor_coordinate_axes_of_mapFourArray_diagonal A B C₂ D₂
      (fun _ => diagonalCoefficient_ne_zero)
      (fun _ => diagonalCoefficient_ne_zero) hmap
  apply isCliffordMatrix_of_weylCoordinate_axes w (U (e 0)) (hU (e 0))
  intro v
  let LC := shorteningLocalLabelEquiv hC hS (e 0).2
  let LD := shorteningLocalLabelEquiv hD hS (e 0).2
  let t := LC.symm v
  have ht :
      relabelCoordinateEquiv LC (coordinateVector t 1) =
        coordinateVector v 1 := by
    simpa [t, LC] using relabelCoordinateEquiv_coordinateVector LC t 1
  have htransport := hAaxes t
  have htarget :
      relabelCoordinateEquiv LD
        (A (coordinateVector t 1)) =
      unitaryConjugationWeylEquiv w (U (e 0)) (hU (e 0))
        (coordinateVector v 1) := by
    change
      relabelCoordinateEquiv LD
          ((relabelCoordinateEquiv LD).symm
            (unitaryConjugationWeylEquiv w (U (e 0)) (hU (e 0))
              (relabelCoordinateEquiv LC (coordinateVector t 1)))) =
        unitaryConjugationWeylEquiv w (U (e 0)) (hU (e 0))
          (coordinateVector v 1)
    rw [(relabelCoordinateEquiv LD).apply_symm_apply, ht]
  rw [← htarget]
  exact relabelCoordinateEquiv_preserves_axis LD htransport

end RelativeConicArcs.AMELU
