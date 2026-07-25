import RelativeConicArcs.AMELU.GenericMDS
import RelativeConicArcs.AMELU.MarginalWeylExpansion

/-!
# Shortened marginals of length-generic MDS--CSS states

For a set of retained parties, this module defines the reduced matrix and
its product-Weyl coefficients directly from a length-`2m` state.  For an
equal-phase linear-code state, a coefficient is nonzero exactly when its
zero extension belongs to `C × Cᗮ`.  On an `(m+1)`-set the two shortening
lines therefore identify the complete coefficient tensor, including the
identity coefficient, with a full diagonal tensor indexed by `𝔽 × 𝔽`.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped ComplexConjugate
open Finset Matrix Complex

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

noncomputable local instance genericSubmoduleFintype
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) : Fintype C :=
  Fintype.ofFinite C

noncomputable local instance genericSubmoduleMembershipDecidable
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) :
    DecidablePred fun x : GenericBasisLabel m 𝔽 => x ∈ C :=
  Classical.decPred _

/-- Assemble retained and discarded coordinates into a length-`2m` label. -/
def genericAssembleLabel (S : Finset (GenericParty m))
    (x : S → 𝔽) (e : (i : {i : GenericParty m // i ∉ S}) → 𝔽) :
    GenericBasisLabel m 𝔽 :=
  fun i => if hi : i ∈ S then x ⟨i, hi⟩ else e ⟨i, hi⟩

/-- Splitting a length-`2m` label into retained and discarded coordinates is
inverse to assembly. -/
def genericAssembleLabelEquiv (S : Finset (GenericParty m)) :
    ((S → 𝔽) × ((i : {i : GenericParty m // i ∉ S}) → 𝔽)) ≃
      GenericBasisLabel m 𝔽 where
  toFun p := genericAssembleLabel S p.1 p.2
  invFun z := (fun i => z i.1, fun i => z i.1)
  left_inv p := by
    apply Prod.ext
    · funext i
      simp [genericAssembleLabel, i.2]
    · funext i
      simp [genericAssembleLabel, i.2]
  right_inv z := by
    funext i
    by_cases hi : i ∈ S <;> simp [genericAssembleLabel, hi]

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- A nested retained/discarded sum is the sum over all length-`2m` labels. -/
theorem generic_sum_assembleLabel
    (S : Finset (GenericParty m)) (f : GenericBasisLabel m 𝔽 → ℂ) :
    (∑ x : S → 𝔽,
      ∑ e : (i : {i : GenericParty m // i ∉ S}) → 𝔽,
        f (genericAssembleLabel S x e)) =
      ∑ z : GenericBasisLabel m 𝔽, f z := by
  classical
  calc
    _ = ∑ p :
        (S → 𝔽) × ((i : {i : GenericParty m // i ∉ S}) → 𝔽),
        f (genericAssembleLabel S p.1 p.2) := by
          rw [Fintype.sum_prod_type]
    _ = ∑ z : GenericBasisLabel m 𝔽, f z :=
      Fintype.sum_equiv (genericAssembleLabelEquiv S) _ _ (fun _ => rfl)

/-- The reduced density-matrix entry on a retained subsystem. -/
noncomputable def genericMarginalEntry
    (ψ : GenericState m 𝔽) (S : Finset (GenericParty m))
    (x y : S → 𝔽) : ℂ :=
  ∑ e : (i : {i : GenericParty m // i ∉ S}) → 𝔽,
    ψ (genericAssembleLabel S x e) *
      conj (ψ (genericAssembleLabel S y e))

/-- Zero extension of local Weyl labels from a retained subsystem. -/
def genericExtendSubsystemPauliLabel
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽) :
    GenericBasisLabel m 𝔽 × GenericBasisLabel m 𝔽 :=
  (fun i => if hi : i ∈ S then (v ⟨i, hi⟩).1 else 0,
    fun i => if hi : i ∈ S then (v ⟨i, hi⟩).2 else 0)

/-- Membership of a length-generic Pauli label in the CSS stabilizer label
space `C × Cᗮ`. -/
def GenericCSSLabel
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (p : GenericBasisLabel m 𝔽 × GenericBasisLabel m 𝔽) : Prop :=
  p.1 ∈ C ∧ p.2 ∈ FiniteGeom.dualCode C

/-- The product-Weyl coefficient of a length-generic reduced matrix. -/
noncomputable def genericMarginalWeylCoefficient
    (w : WeylConvention 𝔽) (ψ : GenericState m 𝔽)
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽) : ℂ :=
  ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
    ∑ x : S → 𝔽,
      (∏ i : S, w.character (-(v i).2 * x i)) *
        genericMarginalEntry ψ S (fun i => x i + (v i).1) x

/-- The character on a generic code obtained from the coordinate pairing. -/
def genericCodeDotCharacter (w : WeylConvention 𝔽)
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (b : GenericBasisLabel m 𝔽) : AddChar C ℂ where
  toFun c := w.character (c.1 ⬝ᵥ b)
  map_zero_eq_one' := by simp [dotProduct]
  map_add_eq_mul' c d := by
    rw [← AddChar.map_add_eq_mul]
    simp [dotProduct, Finset.sum_add_distrib, add_mul]

omit [Fintype 𝔽] in
/-- The generic code-pairing character is trivial exactly on the dual code. -/
theorem genericCodeDotCharacter_eq_zero_iff
    (w : WeylConvention 𝔽)
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (b : GenericBasisLabel m 𝔽) :
    genericCodeDotCharacter w C b = 0 ↔
      b ∈ FiniteGeom.dualCode C := by
  classical
  constructor
  · intro hchar
    apply FiniteGeom.mem_dualCode.mpr
    intro x hx
    by_contra hdot
    obtain ⟨s, hs⟩ := DFunLike.ne_iff.mp w.character_nontrivial
    have hs1 : w.character s ≠ 1 := by simpa using hs
    let a : 𝔽 := s / (x ⬝ᵥ b)
    let c : C := ⟨a • x, C.smul_mem a hx⟩
    have hc : genericCodeDotCharacter w C b c = w.character s := by
      change w.character ((a • x) ⬝ᵥ b) = w.character s
      congr 1
      change (∑ i, (s / (x ⬝ᵥ b)) * x i * b i) = s
      calc
        _ = (s / (x ⬝ᵥ b)) * (x ⬝ᵥ b) := by
          rw [dotProduct, Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i _
          ring
        _ = s := by field_simp
    have htrivial : genericCodeDotCharacter w C b c = 1 := by
      rw [hchar]
      rfl
    exact hs1 (hc ▸ htrivial)
  · intro hb
    apply AddChar.ext
    intro c
    have hdot := (FiniteGeom.mem_dualCode.mp hb) c.1 c.2
    simp [genericCodeDotCharacter, hdot]

/-- Character orthogonality on a generic linear code. -/
theorem generic_sum_codeDotCharacter_cases
    (w : WeylConvention 𝔽)
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (b : GenericBasisLabel m 𝔽) :
    (b ∈ FiniteGeom.dualCode C →
      ∑ c : C, w.character (c.1 ⬝ᵥ b) = (Nat.card C : ℂ)) ∧
    (b ∉ FiniteGeom.dualCode C →
      ∑ c : C, w.character (c.1 ⬝ᵥ b) = 0) := by
  classical
  constructor
  · intro hb
    rw [show (∑ c : C, w.character (c.1 ⬝ᵥ b)) =
        ∑ c : C, genericCodeDotCharacter w C b c by rfl]
    rw [AddChar.sum_eq_ite, if_pos
      ((genericCodeDotCharacter_eq_zero_iff w C b).2 hb)]
    exact_mod_cast (Nat.card_eq_fintype_card (α := C)).symm
  · intro hb
    rw [show (∑ c : C, w.character (c.1 ⬝ᵥ b)) =
        ∑ c : C, genericCodeDotCharacter w C b c by rfl]
    rw [AddChar.sum_eq_ite, if_neg
      (fun h => hb ((genericCodeDotCharacter_eq_zero_iff w C b).1 h))]

omit [DecidableEq 𝔽] in
private theorem generic_sum_if_mem_submodule_eq_sum_subtype
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (f : GenericBasisLabel m 𝔽 → ℂ) :
    (∑ z : GenericBasisLabel m 𝔽, if z ∈ C then f z else 0) =
      ∑ c : C, f c.1 := by
  classical
  rw [← Finset.sum_filter]
  rw [← Finset.sum_subtype_eq_sum_filter]
  simp

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem generic_character_sum_eq_prod
    {ι : Type*} (χ : AddChar 𝔽 ℂ) (s : Finset ι) (f : ι → 𝔽) :
    χ (∑ i ∈ s, f i) = ∏ i ∈ s, χ (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert i s hi ih =>
      simp only [Finset.sum_insert hi, Finset.prod_insert hi]
      rw [AddChar.map_add_eq_mul, ih]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem generic_prod_character_dot
    (w : WeylConvention 𝔽) (S : Finset (GenericParty m))
    (b : GenericBasisLabel m 𝔽) (hb : ∀ i, i ∉ S → b i = 0)
    (x : S → 𝔽) :
    (∏ i : S, w.character (-b i.1 * x i)) =
      w.character ((genericAssembleLabel S x 0) ⬝ᵥ (-b)) := by
  classical
  rw [show (∏ i : S, w.character (-b i.1 * x i)) =
      w.character (∑ i : S, -b i.1 * x i) by
        symm
        simpa using generic_character_sum_eq_prod w.character Finset.univ
          (fun i : S => -b i.1 * x i)]
  congr 1
  let g : GenericParty m → 𝔽 :=
    fun i => if hi : i ∈ S then b i * x ⟨i, hi⟩ else 0
  have hsum : (∑ i : S, b i.1 * x i) = ∑ i, g i := by
    calc
      _ = ∑ i ∈ S, g i := by
        simpa [g] using Finset.sum_attach S g
      _ = ∑ i ∈ Finset.univ, g i := by
        apply Finset.sum_subset (Finset.subset_univ S)
        intro i _ hi
        simp [g, hi]
      _ = ∑ i, g i := by rfl
  have hpos :
      (∑ i : S, b i.1 * x i) =
        ∑ i : GenericParty m, genericAssembleLabel S x 0 i * b i := by
    rw [hsum]
    apply Finset.sum_congr rfl
    intro i _
    by_cases hi : i ∈ S
    · simp [g, genericAssembleLabel, hi, mul_comm]
    · simp [g, genericAssembleLabel, hi, hb i hi]
  calc
    _ = -(∑ i : S, b i.1 * x i) := by
      rw [← Finset.sum_neg_distrib]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ = -(∑ i : GenericParty m,
        genericAssembleLabel S x 0 i * b i) :=
      congrArg (fun z : 𝔽 => -z) hpos
    _ = ∑ i : GenericParty m,
        genericAssembleLabel S x 0 i * (-b i) := by
      rw [← Finset.sum_neg_distrib]
      apply Finset.sum_congr rfl
      intro i _
      ring

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem genericAssembleLabel_add_localShift
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽)
    (x : S → 𝔽) (e : (i : {i : GenericParty m // i ∉ S}) → 𝔽) :
    genericAssembleLabel S (fun i => x i + (v i).1) e =
      genericAssembleLabel S x e +
        (genericExtendSubsystemPauliLabel S v).1 := by
  funext i
  by_cases hi : i ∈ S <;>
    simp [genericAssembleLabel, genericExtendSubsystemPauliLabel, hi]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem genericAssembleLabel_localShift_mem_iff
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽)
    (hc : (genericExtendSubsystemPauliLabel S v).1 ∈ C)
    (x : S → 𝔽) (e : (i : {i : GenericParty m // i ∉ S}) → 𝔽) :
    genericAssembleLabel S (fun i => x i + (v i).1) e ∈ C ↔
      genericAssembleLabel S x e ∈ C := by
  rw [genericAssembleLabel_add_localShift]
  constructor
  · intro h
    simpa using C.sub_mem h hc
  · intro h
    exact C.add_mem h hc

omit [DecidableEq 𝔽] in
private theorem genericCodeStateNormalization_mul_conj :
    genericCodeStateNormalization m 𝔽 *
        conj (genericCodeStateNormalization m 𝔽) =
      ((((Fintype.card 𝔽 : ℝ) ^ m)⁻¹ : ℝ) : ℂ) := by
  have hq : 0 < (Fintype.card 𝔽 : ℝ) := by positivity
  have hpow : 0 < (Fintype.card 𝔽 : ℝ) ^ m := pow_pos hq _
  change
    (((Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ m))⁻¹ : ℝ) : ℂ) *
        conj ((((Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ m))⁻¹ : ℝ) : ℂ)) =
      ((((Fintype.card 𝔽 : ℝ) ^ m)⁻¹ : ℝ) : ℂ)
  rw [Complex.conj_ofReal, ← Complex.ofReal_mul]
  congr 1
  calc
    _ = (Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ m) *
          Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ m))⁻¹ :=
      (_root_.mul_inv_rev _ _).symm
    _ = ((Fintype.card 𝔽 : ℝ) ^ m)⁻¹ := by
      rw [Real.mul_self_sqrt hpow.le]

/-- A generic equal-phase code-state marginal has a nonzero Weyl
coefficient exactly on the zero-extended CSS label space. -/
theorem genericMarginalWeylCoefficient_equalPhaseState_cases
    (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)} (hC : IsMDSCode2m C)
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽) :
    let p := genericExtendSubsystemPauliLabel S v
    (GenericCSSLabel C p →
      genericMarginalWeylCoefficient w (genericEqualPhaseState C) S v =
        ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹) ∧
    (¬ GenericCSSLabel C p →
      genericMarginalWeylCoefficient w (genericEqualPhaseState C) S v = 0) := by
  classical
  dsimp
  let p := genericExtendSubsystemPauliLabel S v
  let c : GenericBasisLabel m 𝔽 := p.1
  let b : GenericBasisLabel m 𝔽 := p.2
  have hbOff : ∀ i, i ∉ S → b i = 0 := by
    intro i hi
    simp [b, p, genericExtendSubsystemPauliLabel, hi]
  have hphase (x : S → 𝔽)
      (e : (i : {i : GenericParty m // i ∉ S}) → 𝔽) :
      (∏ i : S, w.character (-(v i).2 * x i)) =
        w.character ((genericAssembleLabel S x e) ⬝ᵥ (-b)) := by
    calc
      _ = w.character ((genericAssembleLabel S x 0) ⬝ᵥ (-b)) := by
        simpa [b, p, genericExtendSubsystemPauliLabel] using
          generic_prod_character_dot w S b hbOff x
      _ = w.character ((genericAssembleLabel S x e) ⬝ᵥ (-b)) := by
        congr 1
        rw [dotProduct, dotProduct]
        apply Finset.sum_congr rfl
        intro i _
        by_cases hi : i ∈ S
        · simp [genericAssembleLabel, hi]
        · simp [genericAssembleLabel, hi, hbOff i hi]
  have hcardC : Nat.card C = Fintype.card 𝔽 ^ m := by
    rw [Module.natCard_eq_pow_finrank (K := 𝔽) (V := C), hC.1,
      Nat.card_eq_fintype_card]
  have hcoefficient (hc : c ∈ C) :
      genericMarginalWeylCoefficient w (genericEqualPhaseState C) S v =
        ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
          (genericCodeStateNormalization m 𝔽 *
            conj (genericCodeStateNormalization m 𝔽)) *
          ∑ z : GenericBasisLabel m 𝔽,
            if z ∈ C then w.character (z ⬝ᵥ (-b)) else 0 := by
    unfold genericMarginalWeylCoefficient genericMarginalEntry
    rw [mul_assoc]
    apply congrArg (fun q => ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ * q)
    rw [← generic_sum_assembleLabel S, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro x _
    rw [Finset.mul_sum, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro e _
    rw [hphase x e]
    have hshift :=
      genericAssembleLabel_localShift_mem_iff S v
        (by simpa [c, p] using hc) x e
    by_cases hz : genericAssembleLabel S x e ∈ C
    · have hzshift := hshift.mpr hz
      simp [genericEqualPhaseState, hz, hzshift, mul_assoc]
      ring
    · have hzshift :
        genericAssembleLabel S (fun i => x i + (v i).1) e ∉ C :=
          fun h => hz (hshift.mp h)
      simp [genericEqualPhaseState, hz, hzshift]
  constructor
  · intro hp
    rw [hcoefficient hp.1]
    have hsumSubtype :=
      (generic_sum_codeDotCharacter_cases w C (-b)).1
        ((FiniteGeom.dualCode C).neg_mem hp.2)
    have hsumAmbient :
        (∑ z : GenericBasisLabel m 𝔽,
          if z ∈ C then w.character (z ⬝ᵥ (-b)) else 0) =
          (Nat.card C : ℂ) :=
      (generic_sum_if_mem_submodule_eq_sum_subtype C _).trans hsumSubtype
    rw [hsumAmbient, genericCodeStateNormalization_mul_conj, hcardC]
    push_cast
    have hq : (Fintype.card 𝔽 : ℂ) ≠ 0 := by
      exact_mod_cast Fintype.card_ne_zero
    field_simp
  · intro hp
    by_cases hc : c ∈ C
    · have hb : b ∉ FiniteGeom.dualCode C := fun hb => hp ⟨hc, hb⟩
      rw [hcoefficient hc]
      have hsumSubtype :=
        (generic_sum_codeDotCharacter_cases w C (-b)).2
          (fun h => hb ((FiniteGeom.dualCode C).neg_mem_iff.mp h))
      have hsumAmbient :
          (∑ z : GenericBasisLabel m 𝔽,
            if z ∈ C then w.character (z ⬝ᵥ (-b)) else 0) = 0 :=
        (generic_sum_if_mem_submodule_eq_sum_subtype C _).trans hsumSubtype
      rw [hsumAmbient]
      ring
    · unfold genericMarginalWeylCoefficient
      apply mul_eq_zero_of_right
      apply Finset.sum_eq_zero
      intro x _
      apply mul_eq_zero_of_right
      unfold genericMarginalEntry
      apply Finset.sum_eq_zero
      intro e _
      by_cases hz : genericAssembleLabel S x e ∈ C
      · have hzshift :
          genericAssembleLabel S (fun i => x i + (v i).1) e ∉ C := by
            intro h
            apply hc
            have hadd :
                genericAssembleLabel S (fun i => x i + (v i).1) e -
                  genericAssembleLabel S x e = c := by
              rw [genericAssembleLabel_add_localShift]
              simp [c, p]
            exact hadd ▸ C.sub_mem h hz
        simp [genericEqualPhaseState, hzshift]
      · simp [genericEqualPhaseState, hz]

/-- At one retained coordinate, the two shortening parameters give an
equivalence with the local Weyl labels. -/
noncomputable def genericShorteningLocalLabelEquiv
    (hm : 0 < m) {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m + 1) {i : GenericParty m} (hi : i ∈ S) :
    (𝔽 × 𝔽) ≃ (𝔽 × 𝔽) :=
  Equiv.ofBijective
    (fun v : 𝔽 × 𝔽 =>
      (v.1 * (genericShorteningGenerator hm C hC S hS).word i,
        v.2 * (genericShorteningGenerator hm (FiniteGeom.dualCode C)
          (isMDSCode2m_dualCode hm hC) S hS).word i))
    (genericShorteningLocalLabel_bijective hm hC hS hi)

omit [Fintype 𝔽] in
@[simp]
theorem genericShorteningLocalLabelEquiv_apply
    (hm : 0 < m) {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m + 1) {i : GenericParty m} (hi : i ∈ S)
    (v : 𝔽 × 𝔽) :
    genericShorteningLocalLabelEquiv hm hC hS hi v =
      (v.1 * (genericShorteningGenerator hm C hC S hS).word i,
        v.2 * (genericShorteningGenerator hm (FiniteGeom.dualCode C)
          (isMDSCode2m_dualCode hm hC) S hS).word i) :=
  rfl

/-- Reindex local Weyl labels by the common shortening parameter. -/
noncomputable def genericReindexedMarginalLabels
    (hm : 0 < m) {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m + 1) (x : S → 𝔽 × 𝔽) :
    S → 𝔽 × 𝔽 :=
  fun i => genericShorteningLocalLabelEquiv hm hC hS i.2 (x i)

omit [Fintype 𝔽] in
/-- A zero-extended reindexed label is a CSS label exactly when every
retained shortening parameter is equal. -/
theorem genericReindexedMarginalLabels_css_iff
    (hm : 0 < m) {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m + 1) (x : S → 𝔽 × 𝔽) :
    GenericCSSLabel C
        (genericExtendSubsystemPauliLabel S
          (genericReindexedMarginalLabels hm hC hS x)) ↔
      ∃ v : 𝔽 × 𝔽, ∀ i, x i = v := by
  classical
  let c := genericShorteningGenerator hm C hC S hS
  let h := genericShorteningGenerator hm (FiniteGeom.dualCode C)
    (isMDSCode2m_dualCode hm hC) S hS
  constructor
  · rintro ⟨hc, hh⟩
    have hcOff : ∀ i, i ∉ S →
        (genericExtendSubsystemPauliLabel S
          (genericReindexedMarginalLabels hm hC hS x)).1 i = 0 := by
      intro i hi
      simp [genericExtendSubsystemPauliLabel, hi]
    have hhOff : ∀ i, i ∉ S →
        (genericExtendSubsystemPauliLabel S
          (genericReindexedMarginalLabels hm hC hS x)).2 i = 0 := by
      intro i hi
      simp [genericExtendSubsystemPauliLabel, hi]
    obtain ⟨a, ha⟩ := c.exists_smul_eq _ hc hcOff
    obtain ⟨b, hb⟩ := h.exists_smul_eq _ hh hhOff
    refine ⟨(a, b), ?_⟩
    intro i
    apply (genericShorteningLocalLabelEquiv hm hC hS i.2).injective
    apply Prod.ext
    · have hi := congrFun ha i
      simpa [genericReindexedMarginalLabels,
        genericExtendSubsystemPauliLabel, i.2, c,
        genericShorteningLocalLabelEquiv_apply] using hi.symm
    · have hi := congrFun hb i
      simpa [genericReindexedMarginalLabels,
        genericExtendSubsystemPauliLabel, i.2, h,
        genericShorteningLocalLabelEquiv_apply] using hi.symm
  · rintro ⟨v, hv⟩
    constructor
    · have heq :
          (genericExtendSubsystemPauliLabel S
            (genericReindexedMarginalLabels hm hC hS x)).1 =
            v.1 • c.word := by
          funext i
          by_cases hi : i ∈ S
          · simp only [genericExtendSubsystemPauliLabel, dif_pos hi,
              genericReindexedMarginalLabels, Pi.smul_apply, smul_eq_mul]
            rw [hv ⟨i, hi⟩]
            rfl
          · simp [genericExtendSubsystemPauliLabel, hi, c.eq_zero_off i hi]
      rw [heq]
      exact C.smul_mem _ c.mem_code
    · have heq :
          (genericExtendSubsystemPauliLabel S
            (genericReindexedMarginalLabels hm hC hS x)).2 =
            v.2 • h.word := by
          funext i
          by_cases hi : i ∈ S
          · simp only [genericExtendSubsystemPauliLabel, dif_pos hi,
              genericReindexedMarginalLabels, Pi.smul_apply, smul_eq_mul]
            rw [hv ⟨i, hi⟩]
            rfl
          · simp [genericExtendSubsystemPauliLabel, hi, h.eq_zero_off i hi]
      rw [heq]
      exact (FiniteGeom.dualCode C).smul_mem _ h.mem_code

/-- In shortening coordinates the complete `(m+1)`-party marginal
coefficient tensor is diagonal on all `q²` Weyl labels, including zero. -/
theorem genericReindexedMarginalCoefficient_eq_iff
    (hm : 0 < m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m + 1) (x : S → 𝔽 × 𝔽) :
    genericMarginalWeylCoefficient w (genericEqualPhaseState C) S
        (genericReindexedMarginalLabels hm hC hS x) =
      if (∃ v : 𝔽 × 𝔽, ∀ i, x i = v)
      then ((Fintype.card 𝔽 : ℂ) ^ (m + 1))⁻¹ else 0 := by
  classical
  have hcases :=
    genericMarginalWeylCoefficient_equalPhaseState_cases w hC S
      (genericReindexedMarginalLabels hm hC hS x)
  by_cases hdiag : ∃ v : 𝔽 × 𝔽, ∀ i, x i = v
  · rw [if_pos hdiag]
    rw [← hS]
    exact hcases.1
      ((genericReindexedMarginalLabels_css_iff hm hC hS x).2 hdiag)
  · rw [if_neg hdiag]
    exact hcases.2
      (fun hp => hdiag
        ((genericReindexedMarginalLabels_css_iff hm hC hS x).1 hp))

end RelativeConicArcs.AMELU
