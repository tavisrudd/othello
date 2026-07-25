import RelativeConicArcs.AMELU.GenericDefinitions
import RelativeConicArcs.AMELU.StabilizerDictionary
import Mathlib.LinearAlgebra.BilinearForm.Orthogonal

/-!
# Length-generic MDS projection and shortening theory

For a length-`2m`, dimension-`m`, distance-`m+1` linear code, projection
onto every `m` coordinates is a linear equivalence.  Conversely, when
`m > 0`, these projection equivalences characterize the exact MDS
parameters.  The dual code satisfies the same condition.

The shortening of either code to any `m+1` coordinates is consequently a
line with a generator nonzero on every retained coordinate.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset Matrix

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- The exact length-`2m`, dimension-`m`, distance-`m+1` convention. -/
def IsMDSCode2m
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) : Prop :=
  Module.finrank 𝔽 C = m ∧ FiniteGeom.minDist C = m + 1

/-- The generic exact-parameter convention specializes to `[6,3,4]`. -/
theorem isMDSCode2m_three_iff
    (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    IsMDSCode2m (m := 3) C ↔ IsMDSCode634 C := by
  rfl

/-- Coordinate projection of a length-`2m` code. -/
def genericCodeProjection
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (S : Finset (GenericParty m)) :
    C →ₗ[𝔽] (S → 𝔽) :=
  LinearMap.funLeft 𝔽 𝔽 (fun i : S => (i : GenericParty m)) ∘ₗ C.subtype

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- At `m = 3`, generic coordinate projection is the established
six-party code projection. -/
theorem genericCodeProjection_three
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (S : Finset Party) :
    genericCodeProjection (m := 3) C S = codeProjection C S := by
  rfl

omit [Fintype 𝔽] in
/-- An exact MDS code projects injectively to every `m`-set. -/
theorem genericCodeProjection_injective
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m) :
    Function.Injective (genericCodeProjection C S) := by
  classical
  intro x y hxy
  apply Subtype.ext
  let d : GenericBasisLabel m 𝔽 := x.1 - y.1
  have hdC : d ∈ C := C.sub_mem x.2 y.2
  by_contra hd0
  have hdne : d ≠ 0 := by
    intro h
    apply hd0
    exact sub_eq_zero.mp h
  have hdS : ∀ i ∈ S, d i = 0 := by
    intro i hi
    have hiEq := congrFun hxy ⟨i, hi⟩
    exact sub_eq_zero.mpr hiEq
  have hsupp :
      (Finset.univ.filter fun i => d i ≠ 0) ⊆ Sᶜ := by
    intro i hi
    exact Finset.mem_compl.mpr (fun hiS =>
      (Finset.mem_filter.mp hi).2 (hdS i hiS))
  have hweight : hammingNorm d ≤ m := by
    calc
      hammingNorm d ≤ Sᶜ.card := Finset.card_le_card hsupp
      _ = m := by
        rw [Finset.card_compl, hS, Fintype.card_fin]
        omega
  have hmin := FiniteGeom.minDist_le_hammingNorm hdC hdne
  rw [hC.2] at hmin
  omega

omit [Fintype 𝔽] in
/-- Projection of an exact MDS code onto every `m`-set is bijective. -/
theorem genericCodeProjection_bijective
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m) :
    Function.Bijective (genericCodeProjection C S) := by
  have hinj := genericCodeProjection_injective hC hS
  refine
    ⟨hinj, (LinearMap.injective_iff_surjective_of_finrank_eq_finrank ?_).mp hinj⟩
  rw [Module.finrank_pi, Fintype.card_coe, hS, hC.1]

omit [Fintype 𝔽] in
/-- Bijectivity of all `m`-coordinate projections characterizes the exact
MDS parameters when `m` is positive. -/
theorem isMDSCode2m_iff_projection_bijective
    (hm : 0 < m) (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) :
    IsMDSCode2m C ↔
      ∀ (S : Finset (GenericParty m)), S.card = m →
        Function.Bijective (genericCodeProjection C S) := by
  classical
  constructor
  · intro hC S hS
    exact genericCodeProjection_bijective hC hS
  · intro hproj
    obtain ⟨S, -, hS⟩ :=
      Finset.exists_subset_card_eq
        (s := (Finset.univ : Finset (GenericParty m))) (n := m)
        (by rw [Finset.card_univ, Fintype.card_fin]; omega)
    have hbij := hproj S hS
    have hfin : Module.finrank 𝔽 C = m := by
      have hequiv :=
        LinearEquiv.ofBijective (genericCodeProjection C S) hbij
      calc
        Module.finrank 𝔽 C =
            Module.finrank 𝔽 (S → 𝔽) :=
          LinearEquiv.finrank_eq hequiv
        _ = S.card := by
          rw [Module.finrank_pi, Fintype.card_coe]
        _ = m := hS
    have hCne : C ≠ ⊥ := by
      intro hbot
      rw [hbot] at hfin
      simp at hfin
      omega
    have hlower : m + 1 ≤ FiniteGeom.minDist C := by
      apply FiniteGeom.le_minDist hCne
      intro c hcC hc0
      by_contra hweight
      let T : Finset (GenericParty m) :=
        Finset.univ.filter fun i => c i ≠ 0
      have hTcard : T.card = hammingNorm c := rfl
      have hcomp : m ≤ Tᶜ.card := by
        rw [Finset.card_compl, Fintype.card_fin, hTcard]
        omega
      obtain ⟨R, hRsub, hRcard⟩ :=
        Finset.exists_subset_card_eq (s := Tᶜ) (n := m) hcomp
      have hzero :
          genericCodeProjection C R ⟨c, hcC⟩ =
            genericCodeProjection C R 0 := by
        funext i
        have hiT : i.1 ∉ T := Finset.mem_compl.mp (hRsub i.2)
        simp [genericCodeProjection, T] at hiT ⊢
        exact hiT
      have := congrArg Subtype.val ((hproj R hRcard).1 hzero)
      exact hc0 (by simpa using this)
    have hupper := FiniteGeom.singleton_bound C
    rw [hfin] at hupper
    have hupper' : FiniteGeom.minDist C ≤ m + 1 := by omega
    exact ⟨hfin, Nat.le_antisymm hupper' hlower⟩

/-- The coordinate dot product as a bilinear form on length-`2m` labels. -/
def genericStandardDotBilinForm :
    LinearMap.BilinForm 𝔽 (GenericBasisLabel m 𝔽) :=
  dotProductBilin 𝔽 𝔽

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The length-generic coordinate dot product is nondegenerate. -/
theorem genericStandardDotBilinForm_nondegenerate :
    (genericStandardDotBilinForm (m := m) (𝔽 := 𝔽)).Nondegenerate := by
  constructor
  · intro x hx
    exact dotProduct_eq_zero x hx
  · intro y hy
    apply dotProduct_eq_zero y
    intro x
    simpa [genericStandardDotBilinForm, dotProduct_comm] using hy x

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The coding dual is the orthogonal complement for the generic coordinate
dot product. -/
theorem genericDualCode_eq_orthogonal
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) :
    FiniteGeom.dualCode C =
      (genericStandardDotBilinForm (m := m) (𝔽 := 𝔽)).orthogonal C := by
  ext y
  simp [FiniteGeom.mem_dualCode, LinearMap.BilinForm.mem_orthogonal_iff,
    genericStandardDotBilinForm]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- A dimension-`m` length-`2m` code has a dimension-`m` dual. -/
theorem finrank_genericDualCode
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : Module.finrank 𝔽 C = m) :
    Module.finrank 𝔽 (FiniteGeom.dualCode C) = m := by
  rw [genericDualCode_eq_orthogonal]
  rw [LinearMap.BilinForm.finrank_orthogonal
    genericStandardDotBilinForm_nondegenerate]
  rw [Module.finrank_pi, Fintype.card_fin, hC]
  omega

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem generic_sum_eq_single_of_eq_zero_off
    (f : GenericParty m → 𝔽) (i : GenericParty m)
    (h : ∀ j, j ≠ i → f j = 0) :
    ∑ j, f j = f i := by
  classical
  exact Fintype.sum_eq_single i (fun j hj => h j hj)

omit [Fintype 𝔽] in
/-- The dual of an exact length-`2m` MDS code projects bijectively onto
every `m` coordinates. -/
theorem genericDualCodeProjection_bijective
    (hm : 0 < m) {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m) :
    Function.Bijective
      (genericCodeProjection (FiniteGeom.dualCode C) S) := by
  classical
  have hinj :
      Function.Injective
        (genericCodeProjection (FiniteGeom.dualCode C) S) := by
    intro x y hxy
    apply Subtype.ext
    let d : GenericBasisLabel m 𝔽 := x.1 - y.1
    have hd : d ∈ FiniteGeom.dualCode C :=
      (FiniteGeom.dualCode C).sub_mem x.2 y.2
    have hdS : ∀ i ∈ S, d i = 0 := by
      intro i hi
      exact sub_eq_zero.mpr (congrFun hxy ⟨i, hi⟩)
    funext i
    apply sub_eq_zero.mp
    by_cases hiS : i ∈ S
    · exact hdS i hiS
    · let T := Sᶜ
      have hT : T.card = m := by
        rw [Finset.card_compl, Fintype.card_fin, hS]
        omega
      let z : T → 𝔽 := fun j => if j.1 = i then 1 else 0
      obtain ⟨c, hc⟩ := (genericCodeProjection_bijective hC hT).2 z
      have hdot := (FiniteGeom.mem_dualCode.mp hd) c.1 c.2
      have hterm : ∀ j, j ≠ i → c.1 j * d j = 0 := by
        intro j hji
        by_cases hjS : j ∈ S
        · simp [hdS j hjS]
        · have hjT : j ∈ T := Finset.mem_compl.mpr hjS
          have hj := congrFun hc ⟨j, hjT⟩
          simp [genericCodeProjection, z, hji] at hj
          simp [hj]
      have hsum :
          (∑ j, c.1 j * d j) = c.1 i * d i :=
        generic_sum_eq_single_of_eq_zero_off
          (fun j => c.1 j * d j) i hterm
      have hiT : i ∈ T := Finset.mem_compl.mpr hiS
      have hi := congrFun hc ⟨i, hiT⟩
      have hci : c.1 i = 1 := by
        simpa [genericCodeProjection, z] using hi
      rw [dotProduct, hsum, hci, one_mul] at hdot
      exact hdot
  refine
    ⟨hinj, (LinearMap.injective_iff_surjective_of_finrank_eq_finrank ?_).mp hinj⟩
  rw [finrank_genericDualCode hC.1, Module.finrank_pi,
    Fintype.card_coe, hS]

omit [Fintype 𝔽] in
/-- The dual of an exact length-`2m` MDS code is exact MDS. -/
theorem isMDSCode2m_dualCode
    (hm : 0 < m) {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    IsMDSCode2m (FiniteGeom.dualCode C) := by
  rw [isMDSCode2m_iff_projection_bijective hm]
  intro S hS
  exact genericDualCodeProjection_bijective hm hC hS

/-- A generator for the shortening of a length-`2m` code to `m+1`
coordinates. -/
structure GenericShorteningGenerator
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (S : Finset (GenericParty m)) where
  /-- The chosen shortened word. -/
  word : GenericBasisLabel m 𝔽
  /-- The word belongs to the code. -/
  mem_code : word ∈ C
  /-- It vanishes outside the retained set. -/
  eq_zero_off : ∀ i, i ∉ S → word i = 0
  /-- It is nonzero at every retained coordinate. -/
  ne_zero_on : ∀ i, i ∈ S → word i ≠ 0
  /-- Every codeword supported on the retained set is a scalar multiple. -/
  exists_smul_eq :
    ∀ d ∈ C, (∀ i, i ∉ S → d i = 0) → ∃ a : 𝔽, a • word = d
  /-- The scalar parametrization is injective. -/
  smul_right_injective : Function.Injective fun a : 𝔽 => a • word

/-- Every `m+1`-coordinate shortening of an exact length-`2m` MDS code
has a full-support generator. -/
noncomputable def genericShorteningGenerator
    (hm : 0 < m) (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (hC : IsMDSCode2m C) (S : Finset (GenericParty m))
    (hS : S.card = m + 1) :
    GenericShorteningGenerator C S := by
  classical
  have hSne : S.Nonempty := by
    rw [← Finset.card_pos, hS]
    omega
  let i := hSne.choose
  have hiS : i ∈ S := hSne.choose_spec
  let T : Finset (GenericParty m) := Sᶜ ∪ {i}
  have hT : T.card = m := by
    rw [Finset.card_union_of_disjoint]
    · rw [Finset.card_compl, Fintype.card_fin, hS]
      rw [two_mul, Nat.add_sub_add_left]
      exact Nat.sub_add_cancel hm
    · exact Finset.disjoint_singleton_right.mpr (by simpa using hiS)
  let z : T → 𝔽 := fun j => if j.1 = i then 1 else 0
  let hex := (genericCodeProjection_bijective hC hT).2 z
  let c := Classical.choose hex
  have hc : genericCodeProjection C T c = z :=
    Classical.choose_spec hex
  have hci : c.1 i = 1 := by
    have hiT : i ∈ T := by simp [T]
    simpa [genericCodeProjection, z] using congrFun hc ⟨i, hiT⟩
  have hcOff : ∀ j, j ∉ S → c.1 j = 0 := by
    intro j hjS
    have hjT : j ∈ T := by simp [T, hjS]
    have hji : j ≠ i := fun h => hjS (h ▸ hiS)
    simpa [genericCodeProjection, z, hji] using congrFun hc ⟨j, hjT⟩
  have hcOn : ∀ j, j ∈ S → c.1 j ≠ 0 := by
    intro j hjS hcj
    have hc0 : c.1 ≠ 0 := by
      intro hzero
      have := congrFun hzero i
      simp [hci] at this
    have hweight := FiniteGeom.minDist_le_hammingNorm c.2 hc0
    rw [hC.2] at hweight
    have hsupport :
        (Finset.univ.filter fun k => c.1 k ≠ 0) ⊆ S.erase j := by
      intro k hk
      have hk0 := (Finset.mem_filter.mp hk).2
      have hkS : k ∈ S := by
        by_contra hkS
        exact hk0 (hcOff k hkS)
      exact Finset.mem_erase.mpr
        ⟨fun hkj => hk0 (hkj ▸ hcj), hkS⟩
    have hcard : hammingNorm c.1 ≤ m := by
      calc
        hammingNorm c.1 ≤ (S.erase j).card :=
          Finset.card_le_card hsupport
        _ = m := by simp [hS, hjS]
    omega
  refine
    { word := c.1
      mem_code := c.2
      eq_zero_off := hcOff
      ne_zero_on := hcOn
      exists_smul_eq := ?_
      smul_right_injective := ?_ }
  · intro d hd hdOff
    refine ⟨d i, ?_⟩
    let dc : C := ⟨d i • c.1, C.smul_mem (d i) c.2⟩
    let dd : C := ⟨d, hd⟩
    have heq : dc = dd := (genericCodeProjection_bijective hC hT).1 (by
      funext j
      by_cases hji : j.1 = i
      · simp [dc, dd, genericCodeProjection, hji, hci]
      · have hjSc : j.1 ∈ Sᶜ := by
          have hjT := j.2
          simp only [T, Finset.mem_union, Finset.mem_singleton] at hjT
          exact hjT.resolve_right hji
        have hjS : j.1 ∉ S := Finset.mem_compl.mp hjSc
        simp [dc, dd, genericCodeProjection, hcOff j.1 hjS,
          hdOff j.1 hjS])
    exact congrArg Subtype.val heq
  · intro a b hab
    have hi := congrFun hab i
    simpa [hci] using hi

end RelativeConicArcs.AMELU
