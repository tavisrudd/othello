import RelativeConicArcs.AMELU.MDSShortening
import RelativeConicArcs.AMELU.UnitaryConjugation
import RelativeConicArcs.AMELU.DiagonalTensorEquiv

/-!
# Weyl expansion of four-party code-state marginals

For a subsystem `S`, the Fourier coefficient of its reduced density
matrix at local Weyl labels `v : S → 𝔽 × 𝔽` is the normalized trace
coefficient in the product Weyl basis.  For an equal-phase linear-code
state this coefficient is `|𝔽|^{-|S|}` exactly when the extension of
`v` by zero belongs to `C × C⊥`, and is zero otherwise.

When `C` is an exact `[6,3,4]` code and `|S|=4`, shortening identifies
the supported label space with `𝔽²`.  At each retained party the local
projection is invertible.  Reindexing by these projections therefore
turns the nonidentity part of the marginal coefficient tensor into the
full diagonal tensor on the `|𝔽|²-1` nonzero Weyl labels.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped ComplexConjugate
open Finset Matrix Complex

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

noncomputable local instance submoduleFintype
    (C : Submodule 𝔽 (BasisLabel 𝔽)) : Fintype C :=
  Fintype.ofFinite C

noncomputable local instance submoduleMembershipDecidable
    (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    DecidablePred fun x : BasisLabel 𝔽 => x ∈ C :=
  Classical.decPred _

/-- Splitting a six-party label into subsystem and environment
coordinates is inverse to `assembleLabel`. -/
def assembleLabelEquiv (S : Finset Party) :
    ((S → 𝔽) × ((i : {i : Party // i ∉ S}) → 𝔽)) ≃ BasisLabel 𝔽 where
  toFun p := assembleLabel S p.1 p.2
  invFun z :=
    (fun i => z i.1, fun i => z i.1)
  left_inv p := by
    apply Prod.ext
    · funext i
      simp [assembleLabel, i.2]
    · funext i
      simp [assembleLabel, i.2]
  right_inv z := by
    funext i
    by_cases hi : i ∈ S <;> simp [assembleLabel, hi]

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- A nested subsystem/environment sum is the sum over all six-party
labels obtained by assembly. -/
theorem sum_assembleLabel (S : Finset Party) (f : BasisLabel 𝔽 → ℂ) :
    (∑ x : S → 𝔽,
      ∑ e : (i : {i : Party // i ∉ S}) → 𝔽,
        f (assembleLabel S x e)) =
      ∑ z : BasisLabel 𝔽, f z := by
  classical
  calc
    (∑ x : S → 𝔽,
      ∑ e : (i : {i : Party // i ∉ S}) → 𝔽,
        f (assembleLabel S x e)) =
        ∑ p :
          (S → 𝔽) × ((i : {i : Party // i ∉ S}) → 𝔽),
          f (assembleLabel S p.1 p.2) := by
            rw [Fintype.sum_prod_type]
    _ = ∑ z : BasisLabel 𝔽, f z :=
      Fintype.sum_equiv (assembleLabelEquiv S) _ _ (fun _ => rfl)

/-- Extension by zero of local Pauli labels on a subsystem. -/
def extendSubsystemPauliLabel (S : Finset Party)
    (v : S → 𝔽 × 𝔽) : PauliLabel 𝔽 :=
  (fun i => if hi : i ∈ S then (v ⟨i, hi⟩).1 else 0,
    fun i => if hi : i ∈ S then (v ⟨i, hi⟩).2 else 0)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The extended label is supported on its defining subsystem. -/
theorem extendSubsystemPauliLabel_supportedOn
    (S : Finset Party) (v : S → 𝔽 × 𝔽) :
    PauliSupportedOn S (extendSubsystemPauliLabel S v) := by
  intro i hi
  simp [extendSubsystemPauliLabel, hi]

/-- The additive character on a code induced by pairing its codewords
with a fixed ambient label. -/
def codeDotCharacter (w : WeylConvention 𝔽)
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (b : BasisLabel 𝔽) :
    AddChar C ℂ where
  toFun c := w.character (c.1 ⬝ᵥ b)
  map_zero_eq_one' := by simp [dotProduct]
  map_add_eq_mul' c d := by
    rw [← AddChar.map_add_eq_mul]
    simp [dotProduct, Finset.sum_add_distrib, add_mul]

omit [Fintype 𝔽] in
/-- The code pairing character is trivial exactly when the ambient
label belongs to the dual code. -/
theorem codeDotCharacter_eq_zero_iff
    (w : WeylConvention 𝔽)
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (b : BasisLabel 𝔽) :
    codeDotCharacter w C b = 0 ↔ b ∈ FiniteGeom.dualCode C := by
  classical
  constructor
  · intro hchar
    apply FiniteGeom.mem_dualCode.mpr
    intro x hx
    by_contra hdot
    obtain ⟨s, hs⟩ := DFunLike.ne_iff.mp w.character_nontrivial
    have hs1 : w.character s ≠ 1 := by
      simpa using hs
    let a : 𝔽 := s / (x ⬝ᵥ b)
    let c : C := ⟨a • x, C.smul_mem a hx⟩
    have hc :
        codeDotCharacter w C b c = w.character s := by
      change w.character ((a • x) ⬝ᵥ b) = w.character s
      congr 1
      change (∑ i, (s / (x ⬝ᵥ b)) * x i * b i) = s
      calc
        (∑ i, (s / (x ⬝ᵥ b)) * x i * b i) =
            (s / (x ⬝ᵥ b)) * (x ⬝ᵥ b) := by
              rw [dotProduct, Finset.mul_sum]
              apply Finset.sum_congr rfl
              intro i _
              ring
        _ = s := by field_simp
    have htrivial : codeDotCharacter w C b c = 1 := by
      rw [hchar]
      rfl
    exact hs1 (hc ▸ htrivial)
  · intro hb
    apply AddChar.ext
    intro c
    have hdot := (FiniteGeom.mem_dualCode.mp hb) c.1 c.2
    simp [codeDotCharacter, hdot]

/-- Character orthogonality on a linear code, split into its dual and
nondual cases. -/
theorem sum_codeDotCharacter_cases
    (w : WeylConvention 𝔽)
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (b : BasisLabel 𝔽) :
    (b ∈ FiniteGeom.dualCode C →
      ∑ c : C, w.character (c.1 ⬝ᵥ b) = (Nat.card C : ℂ)) ∧
    (b ∉ FiniteGeom.dualCode C →
      ∑ c : C, w.character (c.1 ⬝ᵥ b) = 0) := by
  classical
  constructor
  · intro hb
    rw [show (∑ c : C, w.character (c.1 ⬝ᵥ b)) =
        ∑ c : C, codeDotCharacter w C b c by rfl]
    rw [AddChar.sum_eq_ite, if_pos
      ((codeDotCharacter_eq_zero_iff w C b).2 hb)]
    exact_mod_cast (Nat.card_eq_fintype_card (α := C)).symm
  · intro hb
    rw [show (∑ c : C, w.character (c.1 ⬝ᵥ b)) =
        ∑ c : C, codeDotCharacter w C b c by rfl]
    rw [AddChar.sum_eq_ite, if_neg
      (fun h => hb ((codeDotCharacter_eq_zero_iff w C b).1 h))]

omit [DecidableEq 𝔽] in
private theorem sum_if_mem_submodule_eq_sum_subtype
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (f : BasisLabel 𝔽 → ℂ) :
    (∑ z : BasisLabel 𝔽, if z ∈ C then f z else 0) =
      ∑ c : C, f c.1 := by
  classical
  rw [← Finset.sum_filter]
  rw [← Finset.sum_subtype_eq_sum_filter]
  simp

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem character_sum_eq_prod
    {ι : Type*} (χ : AddChar 𝔽 ℂ) (s : Finset ι) (f : ι → 𝔽) :
    χ (∑ i ∈ s, f i) = ∏ i ∈ s, χ (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert i s hi ih =>
      simp only [Finset.sum_insert hi, Finset.prod_insert hi]
      rw [AddChar.map_add_eq_mul, ih]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Product of local character values is the character of the ambient
dot product when the phase label vanishes off the subsystem. -/
theorem prod_character_eq_character_dot_of_eq_zero_off
    (w : WeylConvention 𝔽) (S : Finset Party)
    (b : BasisLabel 𝔽) (hb : ∀ i, i ∉ S → b i = 0)
    (x : S → 𝔽) :
    (∏ i : S, w.character (-b i.1 * x i)) =
      w.character ((assembleLabel S x 0) ⬝ᵥ (-b)) := by
  classical
  rw [show (∏ i : S, w.character (-b i.1 * x i)) =
      w.character (∑ i : S, -b i.1 * x i) by
        symm
        simpa using character_sum_eq_prod w.character Finset.univ
          (fun i : S => -b i.1 * x i)]
  congr 1
  let g : Party → 𝔽 :=
    fun i => if hi : i ∈ S then b i * x ⟨i, hi⟩ else 0
  have hsum :
      (∑ i : S, b i.1 * x i) = ∑ i, g i := by
    calc
      (∑ i : S, b i.1 * x i) =
          ∑ i ∈ S, g i := by
            simpa [g] using Finset.sum_attach S g
      _ = ∑ i ∈ Finset.univ, g i := by
        apply Finset.sum_subset (Finset.subset_univ S)
        intro i _ hi
        simp [g, hi]
      _ = ∑ i, g i := by rfl
  have hpos :
      (∑ i : S, b i.1 * x i) =
        ∑ i : Party, assembleLabel S x 0 i * b i := by
    rw [hsum]
    apply Finset.sum_congr rfl
    intro i _
    by_cases hi : i ∈ S
    · simp [g, assembleLabel, hi, mul_comm]
    · simp [g, assembleLabel, hi, hb i hi]
  calc
    (∑ i : S, -b i.1 * x i) =
        -(∑ i : S, b i.1 * x i) := by
          rw [← Finset.sum_neg_distrib]
          apply Finset.sum_congr rfl
          intro i _
          ring
    _ = -(∑ i : Party, assembleLabel S x 0 i * b i) :=
      congrArg (fun z : 𝔽 => -z) hpos
    _ = ∑ i : Party, assembleLabel S x 0 i * (-b i) := by
      rw [← Finset.sum_neg_distrib]
      apply Finset.sum_congr rfl
      intro i _
      ring

/-- The product-Weyl Fourier coefficient of a subsystem marginal. -/
noncomputable def marginalWeylCoefficient
    (w : WeylConvention 𝔽) (ψ : State 𝔽)
    (S : Finset Party) (v : S → 𝔽 × 𝔽) : ℂ :=
  ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
    ∑ x : S → 𝔽,
      (∏ i : S, w.character (-(v i).2 * x i)) *
        marginalEntry ψ S (fun i => x i + (v i).1) x

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Adding the local translation labels before assembly is the same as
adding their zero extension to the assembled six-party label. -/
theorem assembleLabel_add_localShift
    (S : Finset Party) (v : S → 𝔽 × 𝔽)
    (x : S → 𝔽) (e : (i : {i : Party // i ∉ S}) → 𝔽) :
    assembleLabel S (fun i => x i + (v i).1) e =
      assembleLabel S x e + (extendSubsystemPauliLabel S v).1 := by
  funext i
  by_cases hi : i ∈ S
  · simp [assembleLabel, extendSubsystemPauliLabel, hi]
  · simp [assembleLabel, extendSubsystemPauliLabel, hi]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Under a code translation, membership of an assembled label and its
shift agree. -/
theorem assembleLabel_localShift_mem_iff
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (S : Finset Party) (v : S → 𝔽 × 𝔽)
    (hc : (extendSubsystemPauliLabel S v).1 ∈ C)
    (x : S → 𝔽) (e : (i : {i : Party // i ∉ S}) → 𝔽) :
    assembleLabel S (fun i => x i + (v i).1) e ∈ C ↔
      assembleLabel S x e ∈ C := by
  rw [assembleLabel_add_localShift]
  constructor
  · intro h
    simpa using C.sub_mem h hc
  · intro h
    exact C.add_mem h hc

/-- The Fourier coefficient of an equal-phase code-state marginal is
supported exactly on the zero-extended CSS label space.  The two
implications avoid building a classical decision into the public
statement. -/
theorem marginalWeylCoefficient_equalPhaseState_cases
    (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    (S : Finset Party) (v : S → 𝔽 × 𝔽) :
    let p := extendSubsystemPauliLabel S v
    (p ∈ cssLabelSpace C →
      marginalWeylCoefficient w (equalPhaseState C) S v =
        ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹) ∧
    (p ∉ cssLabelSpace C →
      marginalWeylCoefficient w (equalPhaseState C) S v = 0) := by
  classical
  dsimp
  let p := extendSubsystemPauliLabel S v
  let c : BasisLabel 𝔽 := p.1
  let b : BasisLabel 𝔽 := p.2
  have hbOff : ∀ i, i ∉ S → b i = 0 := by
    intro i hi
    simp [b, p, extendSubsystemPauliLabel, hi]
  have hphase (x : S → 𝔽)
      (e : (i : {i : Party // i ∉ S}) → 𝔽) :
      (∏ i : S, w.character (-(v i).2 * x i)) =
        w.character ((assembleLabel S x e) ⬝ᵥ (-b)) := by
    calc
      (∏ i : S, w.character (-(v i).2 * x i)) =
          w.character ((assembleLabel S x 0) ⬝ᵥ (-b)) := by
            simpa [b, p, extendSubsystemPauliLabel] using
              prod_character_eq_character_dot_of_eq_zero_off w S b hbOff x
      _ = w.character ((assembleLabel S x e) ⬝ᵥ (-b)) := by
        congr 1
        rw [dotProduct, dotProduct]
        apply Finset.sum_congr rfl
        intro i _
        by_cases hi : i ∈ S
        · simp [assembleLabel, hi]
        · simp [assembleLabel, hi, hbOff i hi]
  have hcardC : Nat.card C = Fintype.card 𝔽 ^ 3 := by
    calc
      Nat.card C = Fintype.card C := Nat.card_eq_fintype_card
      _ = (codewordFinset C).card := by
        rw [codewordFinset]
        exact Fintype.card_subtype fun x : BasisLabel 𝔽 => x ∈ C
      _ = Fintype.card 𝔽 ^ 3 := card_codewordFinset hC
  have hnormalization :
      codeStateNormalization 𝔽 * conj (codeStateNormalization 𝔽) =
        (((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹ : ℝ) := by
    exact codeStateNormalization_mul_conj
  have hcoefficient
      (hc : c ∈ C) :
      marginalWeylCoefficient w (equalPhaseState C) S v =
        ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
          (codeStateNormalization 𝔽 * conj (codeStateNormalization 𝔽)) *
            ∑ z : BasisLabel 𝔽,
              if z ∈ C then w.character (z ⬝ᵥ (-b)) else 0 := by
    unfold marginalWeylCoefficient marginalEntry
    rw [mul_assoc]
    apply congrArg (fun q =>
      ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ * q)
    rw [← sum_assembleLabel S, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro x _
    rw [Finset.mul_sum, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro e _
    rw [hphase x e]
    have hshift :=
      assembleLabel_localShift_mem_iff S v (by simpa [c, p] using hc) x e
    by_cases hz : assembleLabel S x e ∈ C
    · have hzshift := hshift.mpr hz
      simp [equalPhaseState, hz, hzshift, mul_assoc]
      ring
    · have hzshift : assembleLabel S (fun i => x i + (v i).1) e ∉ C :=
        fun h => hz (hshift.mp h)
      simp [equalPhaseState, hz, hzshift]
  constructor
  · intro hp
    have hc : c ∈ C := by
      exact (mem_cssLabelSpace.mp hp).1
    have hb : b ∈ FiniteGeom.dualCode C := by
      exact (mem_cssLabelSpace.mp hp).2
    rw [hcoefficient hc]
    have hsumSubtype :=
      (sum_codeDotCharacter_cases w C (-b)).1
        ((FiniteGeom.dualCode C).neg_mem hb)
    have hsumAmbient :
        (∑ z : BasisLabel 𝔽,
          if z ∈ C then w.character (z ⬝ᵥ (-b)) else 0) =
          (Nat.card C : ℂ) := by
      exact (sum_if_mem_submodule_eq_sum_subtype C _).trans hsumSubtype
    rw [hsumAmbient, hnormalization, hcardC]
    push_cast
    have hq : (Fintype.card 𝔽 : ℂ) ≠ 0 := by
      exact_mod_cast Fintype.card_ne_zero
    field_simp
  · intro hp
    by_cases hc : c ∈ C
    · have hb : b ∉ FiniteGeom.dualCode C := by
        intro hb
        exact hp (mem_cssLabelSpace.mpr ⟨hc, hb⟩)
      rw [hcoefficient hc]
      have hsumSubtype :=
        (sum_codeDotCharacter_cases w C (-b)).2
          (fun h => hb ((FiniteGeom.dualCode C).neg_mem_iff.mp h))
      have hsumAmbient :
          (∑ z : BasisLabel 𝔽,
            if z ∈ C then w.character (z ⬝ᵥ (-b)) else 0) = 0 := by
        exact (sum_if_mem_submodule_eq_sum_subtype C _).trans hsumSubtype
      rw [hsumAmbient]
      ring
    · unfold marginalWeylCoefficient
      apply mul_eq_zero_of_right
      apply Finset.sum_eq_zero
      intro x _
      apply mul_eq_zero_of_right
      unfold marginalEntry
      apply Finset.sum_eq_zero
      intro e _
      by_cases hz : assembleLabel S x e ∈ C
      · have hzshift :
            assembleLabel S (fun i => x i + (v i).1) e ∉ C := by
          intro h
          apply hc
          have hadd :
              assembleLabel S (fun i => x i + (v i).1) e -
                  assembleLabel S x e = c := by
            rw [assembleLabel_add_localShift]
            simp [c, p]
          exact hadd ▸ C.sub_mem h hz
        simp [equalPhaseState, hzshift]
      · simp [equalPhaseState, hz]

end RelativeConicArcs.AMELU
