import RelativeConicArcs.AMELU.StabilizerDictionary

/-!
# Coset states and three-party syndrome geometry

For a length-six linear code, translating its equal-phase state by a label
`e` replaces the computational support `C` by the affine coset `e + C`.
This module proves that two translated states agree exactly when their labels
represent the same coset, and that states belonging to distinct cosets are
orthogonal.  A phase label in the dual code acts on the translated state by
the additive character obtained by pairing it with `e`; this is the
stabilizer-syndrome dictionary in basis-free form.

For the parity-check kernel of a six-arc, the syndrome map restricted to any
three coordinates is an isomorphism.  Consequently every syndrome has one
and only one representative on each three-party support.  If the syndrome
has minimum representative weight three, that representative uses all three
coordinates.  The proofs use only linearity, distance four, and equality of
the two three-dimensional spaces.  They contain no finite enumeration,
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped ComplexConjugate
open Finset Matrix

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- The equal-phase state of `C`, translated so that its computational
support is the affine coset `e + C`. -/
noncomputable def translatedEqualPhaseState
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (e : BasisLabel 𝔽) : State 𝔽 :=
  fun x => equalPhaseState C (x - e)

@[simp]
theorem translatedEqualPhaseState_apply
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (e x : BasisLabel 𝔽) :
    translatedEqualPhaseState C e x = equalPhaseState C (x - e) :=
  rfl

/-- Translation by `e` through the tensor Weyl action gives the coset state
with support `e + C`. -/
theorem tensorWeylAction_X_equalPhaseState_eq_translated
    (w : WeylConvention 𝔽) (C : Submodule 𝔽 (BasisLabel 𝔽))
    (e : BasisLabel 𝔽) :
    tensorWeylAction w (e, 0) (equalPhaseState C) =
      translatedEqualPhaseState C e := by
  funext x
  rw [tensorWeylAction_apply]
  simp [translatedEqualPhaseState]
  congr 1

/-- Two translated equal-phase states are equal precisely when their
translation labels represent the same coset of `C`. -/
theorem translatedEqualPhaseState_eq_iff
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (e f : BasisLabel 𝔽) :
    translatedEqualPhaseState C e = translatedEqualPhaseState C f ↔
      e - f ∈ C := by
  constructor
  · intro h
    have he := congrFun h e
    have hleft : translatedEqualPhaseState C e e = codeStateNormalization 𝔽 := by
      simp [translatedEqualPhaseState]
    have hright : translatedEqualPhaseState C f e = codeStateNormalization 𝔽 := by
      rw [← he, hleft]
    by_contra hef
    have : translatedEqualPhaseState C f e = 0 := by
      simp [translatedEqualPhaseState, equalPhaseState, hef]
    rw [this] at hright
    exact codeStateNormalization_ne_zero hright.symm
  · intro hef
    funext x
    by_cases hx : x - e ∈ C
    · have hxf : x - f ∈ C := by
        have : x - f = (x - e) + (e - f) := by abel
        rw [this]
        exact C.add_mem hx hef
      simp [translatedEqualPhaseState, hx, hxf]
    · have hxf : x - f ∉ C := by
        intro hxf
        apply hx
        have hfe : f - e ∈ C := by
          simpa [sub_eq_add_neg] using C.neg_mem hef
        have : x - e = (x - f) + (f - e) := by abel
        rw [this]
        exact C.add_mem hxf hfe
      simp [translatedEqualPhaseState, hx, hxf]

/-- The finite-dimensional inner product of two amplitude functions. -/
noncomputable def stateInnerProduct (ψ φ : State 𝔽) : ℂ :=
  ∑ x, conj (ψ x) * φ x

/-- Translated equal-phase states from different cosets are orthogonal. -/
theorem stateInnerProduct_translatedEqualPhaseState_eq_zero
    (C : Submodule 𝔽 (BasisLabel 𝔽)) {e f : BasisLabel 𝔽}
    (hef : e - f ∉ C) :
    stateInnerProduct (translatedEqualPhaseState C e)
      (translatedEqualPhaseState C f) = 0 := by
  classical
  unfold stateInnerProduct
  apply Finset.sum_eq_zero
  intro x _
  by_cases hxe : x - e ∈ C
  · have hxf : x - f ∉ C := by
      intro hxf
      apply hef
      have : e - f = -(x - e) + (x - f) := by abel
      rw [this]
      exact C.add_mem (C.neg_mem hxe) hxf
    have hzero : translatedEqualPhaseState C f x = 0 := by
      exact equalPhaseState_apply_of_not_mem hxf
    rw [hzero, mul_zero]
  · have hzero : translatedEqualPhaseState C e x = 0 := by
      exact equalPhaseState_apply_of_not_mem hxe
    rw [hzero]
    simp

/-- A dual-code phase stabilizer reads the translation label through the
standard dot pairing.  This is the character-valued syndrome equation. -/
theorem tensorWeylAction_Z_translatedEqualPhaseState
    (w : WeylConvention 𝔽) (C : Submodule 𝔽 (BasisLabel 𝔽))
    (e h : BasisLabel 𝔽) (hh : h ∈ FiniteGeom.dualCode C) :
    tensorWeylAction w (0, h) (translatedEqualPhaseState C e) =
      w.character (h ⬝ᵥ e) • translatedEqualPhaseState C e := by
  funext x
  rw [tensorWeylAction_apply]
  by_cases hx : x - e ∈ C
  · have horth := (FiniteGeom.mem_dualCode.mp hh) (x - e) hx
    have horth' : h ⬝ᵥ (x - e) = 0 := by
      simpa [dotProduct, mul_comm] using horth
    rw [dotProduct_sub] at horth'
    have hdot : (∑ i, h i * x i) = h ⬝ᵥ e := by
      simpa [dotProduct] using sub_eq_zero.mp horth'
    simp [translatedEqualPhaseState, hx, hdot, dotProduct]
  · simp [translatedEqualPhaseState, equalPhaseState, hx]

/-- The parity-check syndrome of a six-party label. -/
def arcSyndrome (P : Party → PlaneCoordinate → 𝔽) (e : BasisLabel 𝔽) :
    PlaneCoordinate → 𝔽 :=
  parityCheckMatrix P *ᵥ e

/-- Extend a label on `S` by zero outside `S`. -/
def supportedLabel (S : Finset Party) (a : S → 𝔽) : BasisLabel 𝔽 :=
  fun i => if hi : i ∈ S then a ⟨i, hi⟩ else 0

/-- Extension by zero is a linear map from labels on `S` to six-party
labels. -/
def supportedLabelLinearMap (S : Finset Party) :
    (S → 𝔽) →ₗ[𝔽] BasisLabel 𝔽 where
  toFun := supportedLabel S
  map_add' a b := by
    funext i
    by_cases hi : i ∈ S <;> simp [supportedLabel, hi]
  map_smul' c a := by
    funext i
    by_cases hi : i ∈ S <;> simp [supportedLabel, hi]

/-- The parity-check syndrome map restricted to labels supported on `S`. -/
def supportedArcSyndromeLinearMap
    (P : Party → PlaneCoordinate → 𝔽) (S : Finset Party) :
    (S → 𝔽) →ₗ[𝔽] (PlaneCoordinate → 𝔽) :=
  (parityCheckMatrix P).mulVecLin.comp (supportedLabelLinearMap S)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp]
theorem supportedArcSyndromeLinearMap_apply
    (P : Party → PlaneCoordinate → 𝔽) (S : Finset Party) (a : S → 𝔽) :
    supportedArcSyndromeLinearMap P S a = arcSyndrome P (supportedLabel S a) :=
  rfl

omit [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp]
theorem supportedLabel_apply_mem (S : Finset Party) (a : S → 𝔽)
    {i : Party} (hi : i ∈ S) :
    supportedLabel S a i = a ⟨i, hi⟩ := by
  simp [supportedLabel, hi]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp]
theorem supportedLabel_apply_not_mem (S : Finset Party) (a : S → 𝔽)
    {i : Party} (hi : i ∉ S) :
    supportedLabel S a i = 0 := by
  simp [supportedLabel, hi]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Extension by zero is injective. -/
theorem supportedLabel_injective (S : Finset Party) :
    Function.Injective (supportedLabel (𝔽 := 𝔽) S) := by
  intro a b hab
  funext i
  have := congrFun hab i.1
  simpa [supportedLabel, i.2] using this

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every label vanishing outside `S` is the zero extension of its
restriction to `S`. -/
theorem supportedLabel_restrict
    (S : Finset Party) (e : BasisLabel 𝔽)
    (he : ∀ i, i ∉ S → e i = 0) :
    supportedLabel S (fun i => e i.1) = e := by
  funext i
  by_cases hi : i ∈ S
  · simp [supportedLabel, hi]
  · simp [supportedLabel, hi, he i hi]

/-- On every three-party support, the syndrome map of an exact six-arc
kernel is an isomorphism. -/
theorem supportedArcSyndrome_bijective_of_card_three
    (A : SixArcMDSKernel 𝔽) {S : Finset Party} (hS : S.card = 3) :
    Function.Bijective (supportedArcSyndromeLinearMap A.points S) := by
  have hinj : Function.Injective (supportedArcSyndromeLinearMap A.points S) := by
    intro a b hab
    have hdiff : supportedLabel S (a - b) ∈ arcKernel A.points := by
      rw [mem_arcKernel]
      change supportedArcSyndromeLinearMap A.points S (a - b) = 0
      rw [map_sub, hab, sub_self]
    have hzero : supportedLabel S (a - b) = 0 :=
      codeword_eq_of_eq_outside (S := S) A.kernel_isMDSCode634 (by omega)
        hdiff (arcKernel A.points).zero_mem (by
          intro i hi
          simp [supportedLabel, hi])
    have hab0 : a - b = 0 := by
      apply supportedLabel_injective S
      rw [hzero]
      ext i
      simp [supportedLabel]
    exact sub_eq_zero.mp hab0
  refine ⟨hinj, (LinearMap.injective_iff_surjective_of_finrank_eq_finrank ?_).mp hinj⟩
  simp [Fintype.card_coe, hS, PlaneCoordinate]

/-- Every syndrome has one and only one representative supported on any
chosen three parties. -/
theorem existsUnique_arcSyndrome_supported_on_three
    (A : SixArcMDSKernel 𝔽) {S : Finset Party} (hS : S.card = 3)
    (s : PlaneCoordinate → 𝔽) :
    ∃! e : BasisLabel 𝔽,
      arcSyndrome A.points e = s ∧ ∀ i, i ∉ S → e i = 0 := by
  obtain ⟨a, ha⟩ :=
    (supportedArcSyndrome_bijective_of_card_three A hS).2 s
  refine ⟨supportedLabel S a, ?_, ?_⟩
  · constructor
    · exact ha
    · exact fun i hi => supportedLabel_apply_not_mem S a hi
  · intro e he
    rw [← supportedLabel_restrict S e he.2]
    apply congrArg (supportedLabel S)
    have hmap :
        supportedArcSyndromeLinearMap A.points S (fun i => e i.1) =
          arcSyndrome A.points e := by
      rw [supportedArcSyndromeLinearMap_apply,
        supportedLabel_restrict S e he.2]
    exact (supportedArcSyndrome_bijective_of_card_three A hS).1
      (hmap.trans (he.1.trans ha.symm))

/-- If a syndrome has no representative of weight below three, then its
unique representative on each three-party support has weight exactly three. -/
theorem existsUnique_arcSyndrome_weight_three_on_support
    (A : SixArcMDSKernel 𝔽) {S : Finset Party} (hS : S.card = 3)
    (s : PlaneCoordinate → 𝔽)
    (hmin : ∀ e, arcSyndrome A.points e = s → 3 ≤ hammingNorm e) :
    ∃! e : BasisLabel 𝔽,
      arcSyndrome A.points e = s ∧
      (∀ i, i ∉ S → e i = 0) ∧ hammingNorm e = 3 := by
  obtain ⟨e, he, huniq⟩ := existsUnique_arcSyndrome_supported_on_three A hS s
  have hupper : hammingNorm e ≤ S.card := by
    unfold hammingNorm
    apply Finset.card_le_card
    intro i hi
    by_contra hiS
    exact (Finset.mem_filter.mp hi).2 (he.2 i hiS)
  have heweight : hammingNorm e = 3 := by
    have := hmin e he.1
    omega
  refine ⟨e, ⟨he.1, he.2, heweight⟩, ?_⟩
  intro f hf
  exact huniq f ⟨hf.1, hf.2.1⟩

end RelativeConicArcs.AMELU
