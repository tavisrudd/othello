import RelativeConicArcs.AMELU.Dictionary
import Mathlib.LinearAlgebra.BilinearForm.Orthogonal

/-!
# Stabilizer closure for six-party equal-phase CSS states

This module identifies the tensor-product Weyl action on six-party amplitudes,
proves the stabilizer and symplectic properties of the CSS label space, and
records the converse and minimum-support parts of the arc--code--state
dictionary.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset Matrix

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- The six-fold tensor product of the single-party Weyl matrices, acting on
state amplitudes in the row-output, column-input convention. -/
noncomputable def tensorWeylAction (w : WeylConvention 𝔽) (v : PauliLabel 𝔽)
    (ψ : State 𝔽) : State 𝔽 :=
  localAction (fun i => weylMatrix w (v.1 i) (v.2 i)) ψ

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem additiveCharacter_sum_eq_prod (χ : AddChar 𝔽 ℂ)
    (s : Finset Party) (f : Party → 𝔽) :
    χ (∑ i ∈ s, f i) = ∏ i ∈ s, χ (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert i s hi ih =>
      simp only [sum_insert hi, prod_insert hi]
      rw [AddChar.map_add_eq_mul, ih]

/-- The tensor Weyl action has the expected shift-and-character formula:
the input label is `y-a`, and the total phase is the character of
`∑ᵢ bᵢ(yᵢ-aᵢ)`. -/
theorem tensorWeylAction_apply (w : WeylConvention 𝔽) (v : PauliLabel 𝔽)
    (ψ : State 𝔽) (y : BasisLabel 𝔽) :
    tensorWeylAction w v ψ y =
      w.character (∑ i, v.2 i * (y i - v.1 i)) *
        ψ (fun i => y i - v.1 i) := by
  classical
  unfold tensorWeylAction localAction
  rw [Fintype.sum_eq_single (fun i => y i - v.1 i)]
  · congr 1
    rw [additiveCharacter_sum_eq_prod w.character Finset.univ]
    apply Finset.prod_congr rfl
    intro i _
    simp [weylMatrix, sub_add_cancel]
  · intro x hx
    have hcoord : ∃ i, x i ≠ y i - v.1 i := by
      by_contra h
      apply hx
      funext i
      by_contra hi
      exact h ⟨i, hi⟩
    obtain ⟨i, hi⟩ := hcoord
    have hzero :
        weylMatrix w (v.1 i) (v.2 i) (y i) (x i) = 0 := by
      rw [weylMatrix_apply, if_neg]
      intro heq
      apply hi
      exact (eq_sub_iff_add_eq).2 heq.symm
    have hprod :
        (∏ j, weylMatrix w (v.1 j) (v.2 j) (y j) (x j)) = 0 :=
      Finset.prod_eq_zero (f := fun j =>
        weylMatrix w (v.1 j) (v.2 j) (y j) (x j))
        (Finset.mem_univ i) hzero
    rw [hprod, zero_mul]

/-- Every label in `C × C⊥` fixes the normalized equal-phase state of `C`
under the six-party Weyl action. -/
theorem tensorWeylAction_equalPhaseState_of_mem_cssLabelSpace
    (w : WeylConvention 𝔽) (C : Submodule 𝔽 (BasisLabel 𝔽))
    (v : PauliLabel 𝔽) (hv : v ∈ cssLabelSpace C) :
    tensorWeylAction w v (equalPhaseState C) = equalPhaseState C := by
  classical
  obtain ⟨hX, hZ⟩ := mem_cssLabelSpace.mp hv
  funext y
  rw [tensorWeylAction_apply]
  let x : BasisLabel 𝔽 := fun i => y i - v.1 i
  by_cases hy : y ∈ C
  · have hx : x ∈ C := by
      apply C.sub_mem hy hX
    have hdot : (∑ i, v.2 i * x i) = 0 := by
      have hz := (FiniteGeom.mem_dualCode.mp hZ) x hx
      simpa [dotProduct, mul_comm] using hz
    simp [x, hx, hy, hdot]
  · have hx : x ∉ C := by
      intro hx
      apply hy
      have hadd : x + v.1 ∈ C := C.add_mem hx hX
      have heq : x + v.1 = y := by
        funext i
        simp [x]
      exact heq ▸ hadd
    simp [x, hx, hy]

/-- The translation operators `X(c)`, for `c ∈ C`, fix the equal-phase
state of `C`. -/
theorem tensorWeylAction_X_equalPhaseState (w : WeylConvention 𝔽)
    (C : Submodule 𝔽 (BasisLabel 𝔽)) {c : BasisLabel 𝔽} (hc : c ∈ C) :
    tensorWeylAction w (c, 0) (equalPhaseState C) = equalPhaseState C :=
  tensorWeylAction_equalPhaseState_of_mem_cssLabelSpace w C (c, 0)
    ⟨hc, (FiniteGeom.dualCode C).zero_mem⟩

/-- The phase operators `Z(h)`, for `h ∈ C⊥`, fix the equal-phase state
of `C`. -/
theorem tensorWeylAction_Z_equalPhaseState (w : WeylConvention 𝔽)
    (C : Submodule 𝔽 (BasisLabel 𝔽)) {h : BasisLabel 𝔽}
    (hh : h ∈ FiniteGeom.dualCode C) :
    tensorWeylAction w (0, h) (equalPhaseState C) = equalPhaseState C :=
  tensorWeylAction_equalPhaseState_of_mem_cssLabelSpace w C (0, h) ⟨C.zero_mem, hh⟩

/-- The standard alternating pairing on six-party Pauli labels,
`⟨(a,b),(a',b')⟩ = a·b' - b·a'`. -/
def pauliSymplecticPairing (v u : PauliLabel 𝔽) : 𝔽 :=
  v.1 ⬝ᵥ u.2 - v.2 ⬝ᵥ u.1

/-- A Pauli-label subspace is isotropic when its symplectic pairing
vanishes on every pair of its labels. -/
def IsPauliIsotropic (L : Submodule 𝔽 (PauliLabel 𝔽)) : Prop :=
  ∀ v ∈ L, ∀ u ∈ L, pauliSymplecticPairing v u = 0

/-- In the twelve-dimensional six-party phase space, a Lagrangian is an
isotropic subspace of dimension six. -/
def IsPauliLagrangian (L : Submodule 𝔽 (PauliLabel 𝔽)) : Prop :=
  IsPauliIsotropic L ∧ Module.finrank 𝔽 L = 6

omit [DecidableEq 𝔽] in
/-- The CSS label space is symplectically isotropic.  Equivalently, all
of its Weyl operators commute projectively. -/
theorem cssLabelSpace_isPauliIsotropic
    (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    IsPauliIsotropic (cssLabelSpace C) := by
  intro v hv u hu
  obtain ⟨hvX, hvZ⟩ := mem_cssLabelSpace.mp hv
  obtain ⟨huX, huZ⟩ := mem_cssLabelSpace.mp hu
  have h₁ := (FiniteGeom.mem_dualCode.mp huZ) v.1 hvX
  have h₂ := (FiniteGeom.mem_dualCode.mp hvZ) u.1 huX
  simp [pauliSymplecticPairing, h₁, dotProduct_comm _ _, h₂]

/-- The ordinary coordinate dot product as a bilinear form. -/
def standardDotBilinForm : LinearMap.BilinForm 𝔽 (BasisLabel 𝔽) :=
  dotProductBilin 𝔽 𝔽

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The ordinary coordinate dot product is nondegenerate. -/
theorem standardDotBilinForm_nondegenerate :
    (standardDotBilinForm (𝔽 := 𝔽)).Nondegenerate := by
  constructor
  · intro x hx
    exact dotProduct_eq_zero x hx
  · intro y hy
    apply dotProduct_eq_zero y
    intro x
    simpa [standardDotBilinForm, dotProduct_comm] using hy x

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The coding-theory dual is the right orthogonal complement for the
standard coordinate bilinear form. -/
theorem dualCode_eq_standardDot_orthogonal
    (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    FiniteGeom.dualCode C =
      (standardDotBilinForm (𝔽 := 𝔽)).orthogonal C := by
  ext y
  simp [FiniteGeom.mem_dualCode, LinearMap.BilinForm.mem_orthogonal_iff,
    standardDotBilinForm]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- A dimension-three length-six code has a dimension-three dual. -/
theorem finrank_dualCode_of_finrank_three
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : Module.finrank 𝔽 C = 3) :
    Module.finrank 𝔽 (FiniteGeom.dualCode C) = 3 := by
  rw [dualCode_eq_standardDot_orthogonal]
  rw [LinearMap.BilinForm.finrank_orthogonal standardDotBilinForm_nondegenerate]
  simp [hC]

/-- The subtype of the CSS product subspace is linearly equivalent to
the product of the two code subtypes. -/
def cssLabelSpaceLinearEquiv (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    cssLabelSpace C ≃ₗ[𝔽] C × FiniteGeom.dualCode C where
  toFun v :=
    (⟨v.1.1, (mem_cssLabelSpace.mp v.2).1⟩,
      ⟨v.1.2, (mem_cssLabelSpace.mp v.2).2⟩)
  invFun v := ⟨(v.1.1, v.2.1), mem_cssLabelSpace.mpr ⟨v.1.2, v.2.2⟩⟩
  left_inv v := by
    ext <;> rfl
  right_inv v := by
    ext <;> rfl
  map_add' v u := by
    ext <;> rfl
  map_smul' a v := by
    ext <;> rfl

/-- The CSS label space of an exact `[6,3,4]` code is a six-dimensional
Lagrangian subspace of the twelve-dimensional Pauli phase space. -/
theorem cssLabelSpace_isPauliLagrangian
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C) :
    IsPauliLagrangian (cssLabelSpace C) := by
  refine ⟨cssLabelSpace_isPauliIsotropic C, ?_⟩
  calc
    Module.finrank 𝔽 (cssLabelSpace C) =
        Module.finrank 𝔽 (C × FiniteGeom.dualCode C) :=
      (cssLabelSpaceLinearEquiv C).finrank_eq
    _ = Module.finrank 𝔽 C +
        Module.finrank 𝔽 (FiniteGeom.dualCode C) := Module.finrank_prod
    _ = 6 := by rw [hC.1, finrank_dualCode_of_finrank_three hC.1]

/-- Membership in `L_C(S)` is membership in the CSS label space together
with containment of the Pauli support in `S`. -/
theorem mem_cssSupportedLabelSpace_iff_support_subset
    {C : Submodule 𝔽 (BasisLabel 𝔽)} {S : Finset Party}
    {v : PauliLabel 𝔽} :
    v ∈ cssSupportedLabelSpace C S ↔
      v ∈ cssLabelSpace C ∧ pauliSupport v ⊆ S := by
  rw [mem_cssSupportedLabelSpace, pauliSupport_subset_iff]
  simp only [mem_cssLabelSpace]
  tauto

/-- The computational-basis support of a state. -/
noncomputable def computationalSupport (ψ : State 𝔽) : Finset (BasisLabel 𝔽) := by
  classical
  exact Finset.univ.filter fun x => ψ x ≠ 0

omit [DecidableEq 𝔽] in
/-- The normalization scalar used by an equal-phase code state is nonzero. -/
theorem codeStateNormalization_ne_zero :
    codeStateNormalization 𝔽 ≠ 0 := by
  change (((Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ 3))⁻¹ : ℝ) : ℂ) ≠ 0
  exact Complex.ofReal_ne_zero.mpr
    (inv_ne_zero (Real.sqrt_ne_zero'.mpr (by positivity)))

/-- The computational support of an equal-phase state is exactly its
underlying linear code. -/
theorem computationalSupport_equalPhaseState
    (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    computationalSupport (equalPhaseState C) = codewordFinset C := by
  classical
  ext x
  simp [computationalSupport, codewordFinset, equalPhaseState,
    codeStateNormalization_ne_zero]

/-- Restriction of a computational-basis label to a subsystem. -/
def restrictLabel (S : Finset Party) (x : BasisLabel 𝔽) : (i : S) → 𝔽 :=
  fun i => x i

/-- On the support of an AME state, restriction to any three parties is
surjective.  This is the support-theoretic content of a full-rank diagonal
three-party marginal. -/
theorem restrictLabel_surjective_on_computationalSupport_of_isAME
    {ψ : State 𝔽} (hψ : IsAME ψ) (S : Finset Party) (hS : S.card = 3) :
    Function.Surjective
      (fun z : computationalSupport ψ => restrictLabel S z.1) := by
  classical
  intro x
  have hmarg :
      marginalEntry ψ S x x =
        (((Fintype.card 𝔽 : ℝ) ^ S.card)⁻¹ : ℝ) := by
    simpa using hψ.2 S (by omega) x x
  have hq :
      ((((Fintype.card 𝔽 : ℝ) ^ S.card)⁻¹ : ℝ) : ℂ) ≠ 0 := by
    exact Complex.ofReal_ne_zero.mpr
      (inv_ne_zero (by positivity :
        ((Fintype.card 𝔽 : ℝ) ^ S.card) ≠ 0))
  have hmarg_ne : marginalEntry ψ S x x ≠ 0 := by
    rw [hmarg]
    exact hq
  have hex :
      ∃ e : (i : {i : Party // i ∉ S}) → 𝔽,
        ψ (assembleLabel S x e) ≠ 0 := by
    by_contra h
    have hzero :
        ∀ e : (i : {i : Party // i ∉ S}) → 𝔽,
          ψ (assembleLabel S x e) = 0 := by
      intro e
      by_contra he
      exact h ⟨e, he⟩
    apply hmarg_ne
    simp [marginalEntry, hzero]
  obtain ⟨e, he⟩ := hex
  let y := assembleLabel S x e
  have hy : y ∈ computationalSupport ψ := by
    simp [computationalSupport, y, he]
  refine ⟨⟨y, hy⟩, ?_⟩
  funext i
  exact assembleLabel_apply_mem S x e i i.2

/-- Every six-party AME state has at least `|𝔽|³` nonzero
computational-basis amplitudes. -/
theorem card_pow_three_le_computationalSupport_of_isAME
    {ψ : State 𝔽} (hψ : IsAME ψ) :
    Fintype.card 𝔽 ^ 3 ≤ (computationalSupport ψ).card := by
  classical
  let S : Finset Party := {0, 1, 2}
  have hS : S.card = 3 := by
    decide
  have hsurj :=
    restrictLabel_surjective_on_computationalSupport_of_isAME hψ S hS
  have hcard :=
    Fintype.card_le_of_surjective
      (fun z : computationalSupport ψ => restrictLabel S z.1) hsurj
  simpa [Fintype.card_pi, hS] using hcard

/-- An AME state has minimal computational support when no AME state on
the same six local spaces has fewer nonzero computational-basis
amplitudes. -/
def HasMinimalComputationalSupport (ψ : State 𝔽) : Prop :=
  IsAME ψ ∧
    ∀ φ : State 𝔽, IsAME φ →
      (computationalSupport ψ).card ≤ (computationalSupport φ).card

/-- The equal-phase state of an exact `[6,3,4]` code is an AME state with
minimum possible computational support. -/
theorem equalPhaseState_hasMinimalComputationalSupport
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C) :
    HasMinimalComputationalSupport (equalPhaseState C) := by
  refine ⟨isAME_equalPhaseState hC, ?_⟩
  intro φ hφ
  rw [computationalSupport_equalPhaseState, card_codewordFinset hC]
  exact card_pow_three_le_computationalSupport_of_isAME hφ

/-- Normalization with the fixed `|𝔽|^{-3/2}` amplitude forces an
equal-phase linear code to contain exactly `|𝔽|³` words. -/
theorem card_codewordFinset_of_isNormalized_equalPhaseState
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (hψ : IsNormalized (equalPhaseState C)) :
    (codewordFinset C).card = Fintype.card 𝔽 ^ 3 := by
  classical
  have hnorm :
      Complex.normSq (codeStateNormalization 𝔽) =
        ((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹ := by
    apply Complex.ofReal_injective
    simpa [Complex.mul_conj] using codeStateNormalization_mul_conj (𝔽 := 𝔽)
  have hterm (x : BasisLabel 𝔽) :
      Complex.normSq (equalPhaseState C x) =
        if x ∈ C then ((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹ else 0 := by
    by_cases hx : x ∈ C <;> simp [equalPhaseState, hx, hnorm]
  unfold IsNormalized at hψ
  simp_rw [hterm] at hψ
  rw [← Finset.sum_filter] at hψ
  change
    (∑ _x ∈ codewordFinset C,
      ((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹) = 1 at hψ
  rw [Finset.sum_const] at hψ
  simp only [nsmul_eq_mul] at hψ
  have hq0 : (Fintype.card 𝔽 : ℝ) ^ 3 ≠ 0 := by positivity
  have hcardR :
      ((codewordFinset C).card : ℝ) = (Fintype.card 𝔽 : ℝ) ^ 3 := by
    calc
      ((codewordFinset C).card : ℝ) =
          (((codewordFinset C).card : ℝ) *
            ((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹) *
            ((Fintype.card 𝔽 : ℝ) ^ 3) := by
              field_simp
      _ = (Fintype.card 𝔽 : ℝ) ^ 3 := by rw [hψ, one_mul]
  exact_mod_cast hcardR

/-- An AME equal-phase state with the fixed normalization comes from a
dimension-three linear code. -/
theorem finrank_three_of_isAME_equalPhaseState
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (hψ : IsAME (equalPhaseState C)) :
    Module.finrank 𝔽 C = 3 := by
  have hwords :=
    card_codewordFinset_of_isNormalized_equalPhaseState hψ.1
  have hcardC :
      Nat.card C = Nat.card 𝔽 ^ Module.finrank 𝔽 C :=
    Module.natCard_eq_pow_finrank (K := 𝔽) (V := C)
  have hcodewordCard :
      (codewordFinset C).card = Nat.card C := by
    classical
    rw [codewordFinset]
    calc
      (Finset.univ.filter fun x : BasisLabel 𝔽 => x ∈ C).card =
          Fintype.card C :=
        (Fintype.card_subtype fun x : BasisLabel 𝔽 => x ∈ C).symm
      _ = Nat.card C := Fintype.card_eq_nat_card
  have hpowers :
      Fintype.card 𝔽 ^ Module.finrank 𝔽 C = Fintype.card 𝔽 ^ 3 := by
    have hwords' :
        (codewordFinset C).card = Nat.card 𝔽 ^ 3 := by
      simpa [Nat.card_eq_fintype_card] using hwords
    rw [← Nat.card_eq_fintype_card, ← hcardC, ← hcodewordCard]
    exact hwords'
  apply Nat.pow_right_injective (a := Fintype.card 𝔽)
  · have hcard := Fintype.one_lt_card (α := 𝔽)
    omega
  · exact hpowers

/-- For an AME equal-phase state, projection of the underlying code onto
any three parties is bijective. -/
theorem codeProjection_bijective_of_isAME_equalPhaseState
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (hψ : IsAME (equalPhaseState C)) {S : Finset Party} (hS : S.card = 3) :
    Function.Bijective (codeProjection C S) := by
  classical
  have hsurjSupport :=
    restrictLabel_surjective_on_computationalSupport_of_isAME hψ S hS
  have hsurj : Function.Surjective (codeProjection C S) := by
    intro x
    obtain ⟨z, hz⟩ := hsurjSupport x
    have hzC : z.1 ∈ C := by
      have hzAmplitude : equalPhaseState C z.1 ≠ 0 :=
        (Finset.mem_filter.mp z.2).2
      by_contra hzNot
      exact hzAmplitude (equalPhaseState_apply_of_not_mem hzNot)
    refine ⟨⟨z.1, hzC⟩, ?_⟩
    exact hz
  apply (Fintype.bijective_iff_surjective_and_card (codeProjection C S)).2
  refine ⟨hsurj, ?_⟩
  have hfinrank := finrank_three_of_isAME_equalPhaseState hψ
  calc
    Fintype.card C = Nat.card C := Fintype.card_eq_nat_card
    _ = Nat.card 𝔽 ^ Module.finrank 𝔽 C :=
      Module.natCard_eq_pow_finrank (K := 𝔽) (V := C)
    _ = Fintype.card 𝔽 ^ 3 := by
      rw [Nat.card_eq_fintype_card, hfinrank]
    _ = Fintype.card (S → 𝔽) := by
      simp [Fintype.card_pi, hS]

/-- The AME condition on an equal-phase state forces minimum distance at
least four for its underlying code. -/
theorem minDist_ge_four_of_isAME_equalPhaseState
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (hψ : IsAME (equalPhaseState C)) :
    4 ≤ FiniteGeom.minDist C := by
  have hfinrank := finrank_three_of_isAME_equalPhaseState hψ
  have hCne : C ≠ ⊥ := by
    intro hbot
    rw [hbot] at hfinrank
    simp at hfinrank
  apply FiniteGeom.le_minDist hCne
  intro c hc hczero
  by_contra hweight
  have hweight_le : hammingNorm c ≤ 3 := by omega
  classical
  let T : Finset Party := Finset.univ.filter fun i => c i ≠ 0
  have hTcard : T.card = hammingNorm c := rfl
  have hcompcard : 3 ≤ Tᶜ.card := by
    rw [Finset.card_compl]
    change 3 ≤ 6 - T.card
    omega
  obtain ⟨S, hSsub, hScard⟩ :=
    Finset.exists_subset_card_eq (s := Tᶜ) (n := 3) hcompcard
  have hinj :=
    (codeProjection_bijective_of_isAME_equalPhaseState hψ hScard).1
  have hproj :
      codeProjection C S ⟨c, hc⟩ = codeProjection C S 0 := by
    ext i
    have hiComp : i.1 ∈ Tᶜ := hSsub i.2
    have hiNot : i.1 ∉ T := Finset.mem_compl.mp hiComp
    have hci : c i.1 = 0 := by
      simpa [T] using hiNot
    simp [codeProjection, hci]
  have hsubtype : (⟨c, hc⟩ : C) = 0 := hinj hproj
  apply hczero
  exact congrArg Subtype.val hsubtype

/-- An equal-phase state is AME only if its linear support is an exact
`[6,3,4]` code. -/
theorem isMDSCode634_of_isAME_equalPhaseState
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (hψ : IsAME (equalPhaseState C)) :
    IsMDSCode634 C := by
  refine ⟨finrank_three_of_isAME_equalPhaseState hψ, ?_⟩
  apply Nat.le_antisymm
  · have hsingleton := FiniteGeom.singleton_bound C
    rw [finrank_three_of_isAME_equalPhaseState hψ] at hsingleton
    omega
  · exact minDist_ge_four_of_isAME_equalPhaseState hψ

/-- For the fixed equal-phase normalization, the AME condition is
equivalent to the exact `[6,3,4]` code parameters. -/
theorem isAME_equalPhaseState_iff_isMDSCode634
    (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    IsAME (equalPhaseState C) ↔ IsMDSCode634 C :=
  ⟨isMDSCode634_of_isAME_equalPhaseState, isAME_equalPhaseState⟩

end RelativeConicArcs.AMELU
