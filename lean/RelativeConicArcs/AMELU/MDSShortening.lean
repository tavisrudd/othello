import RelativeConicArcs.AMELU.StabilizerDictionary

/-!
# Four-coordinate shortenings of six-coordinate MDS codes

Let `C` be a linear `[6,3,4]` code over a finite field.  Projection onto
any three coordinates is a linear equivalence.  The same is true for the
dual code.  Consequently, the words of either code supported on a fixed
four-coordinate set form a line: a chosen generator is nonzero at every
coordinate of that set, and every supported word is its unique scalar
multiple.

The final results identify the CSS labels supported on four coordinates
with `𝔽 × 𝔽`.  At each retained coordinate this parametrization is a linear
equivalence onto the local pair of Weyl labels.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem sum_eq_single_of_eq_zero_off
    (f : Party → 𝔽) (i : Party) (h : ∀ j, j ≠ i → f j = 0) :
    ∑ j, f j = f i := by
  classical
  exact Fintype.sum_eq_single i (fun j hj => h j hj)

/-- Projection of the dual of an exact `[6,3,4]` code onto any three
coordinates is injective. -/
theorem dualCodeProjection_injective_of_card_three
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 3) :
    Function.Injective (codeProjection (FiniteGeom.dualCode C) S) := by
  classical
  intro x y hxy
  apply Subtype.ext
  let d : BasisLabel 𝔽 := x.1 - y.1
  have hd : d ∈ FiniteGeom.dualCode C :=
    (FiniteGeom.dualCode C).sub_mem x.2 y.2
  have hdS : ∀ i ∈ S, d i = 0 := by
    intro i hi
    have h := congrFun hxy ⟨i, hi⟩
    exact sub_eq_zero.mpr h
  funext i
  apply sub_eq_zero.mp
  by_cases hiS : i ∈ S
  · exact hdS i hiS
  · let T := Sᶜ
    have hT : T.card = 3 := by
      rw [Finset.card_compl]
      change 6 - S.card = 3
      omega
    let z : T → 𝔽 := fun j => if j.1 = i then 1 else 0
    obtain ⟨c, hc⟩ :=
      (codeProjection_bijective_of_card_three hC hT).2 z
    have hdot := (FiniteGeom.mem_dualCode.mp hd) c.1 c.2
    have hterm : ∀ j, j ≠ i → c.1 j * d j = 0 := by
      intro j hji
      by_cases hjS : j ∈ S
      · simp [hdS j hjS]
      · have hjT : j ∈ T := Finset.mem_compl.mpr hjS
        have hj := congrFun hc ⟨j, hjT⟩
        simp [codeProjection, z, hji] at hj
        simp [hj]
    have hsum :
        (∑ j, c.1 j * d j) = c.1 i * d i :=
      sum_eq_single_of_eq_zero_off (fun j => c.1 j * d j) i hterm
    have hiT : i ∈ T := Finset.mem_compl.mpr hiS
    have hi := congrFun hc ⟨i, hiT⟩
    have hci : c.1 i = 1 := by
      simpa [codeProjection, z] using hi
    rw [dotProduct, hsum, hci, one_mul] at hdot
    exact hdot

/-- Projection of the dual of an exact `[6,3,4]` code onto any three
coordinates is bijective. -/
theorem dualCodeProjection_bijective_of_card_three
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 3) :
    Function.Bijective (codeProjection (FiniteGeom.dualCode C) S) := by
  have hinj := dualCodeProjection_injective_of_card_three hC hS
  refine
    ⟨hinj, (LinearMap.injective_iff_surjective_of_finrank_eq_finrank ?_).mp hinj⟩
  rw [finrank_dualCode_of_finrank_three hC.1, Module.finrank_pi,
    Fintype.card_coe, hS]

/-- The dual of a linear `[6,3,4]` code is again a linear `[6,3,4]` code. -/
theorem isMDSCode634_dualCode
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C) :
    IsMDSCode634 (FiniteGeom.dualCode C) := by
  constructor
  · exact finrank_dualCode_of_finrank_three hC.1
  · apply le_antisymm
    · have hsingleton :=
        FiniteGeom.singleton_bound (FiniteGeom.dualCode C)
      rw [finrank_dualCode_of_finrank_three hC.1] at hsingleton
      omega
    · apply FiniteGeom.le_minDist
      · intro hbot
        have hfin := finrank_dualCode_of_finrank_three hC.1
        rw [hbot] at hfin
        simp at hfin
      · intro d hd hd0
        by_contra hweight
        have hweight_le : hammingNorm d ≤ 3 := by omega
        let T : Finset Party := Finset.univ.filter fun i => d i ≠ 0
        have hTcard : T.card = hammingNorm d := rfl
        have hcompcard : 3 ≤ Tᶜ.card := by
          rw [Finset.card_compl]
          change 3 ≤ 6 - T.card
          omega
        obtain ⟨S, hSsub, hScard⟩ :=
          Finset.exists_subset_card_eq (s := Tᶜ) (n := 3) hcompcard
        have hinj := dualCodeProjection_injective_of_card_three hC hScard
        have hproj :
            codeProjection (FiniteGeom.dualCode C) S ⟨d, hd⟩ =
              codeProjection (FiniteGeom.dualCode C) S 0 := by
          funext i
          have hiT : i.1 ∉ T := by
            exact Finset.mem_compl.mp (hSsub i.2)
          simp [codeProjection, T] at hiT ⊢
          exact hiT
        have := congrArg Subtype.val (hinj hproj)
        exact hd0 (by simpa using this)

/-- A generator for the one-dimensional shortening of a code to a
four-coordinate set.  The generator is nonzero on every retained
coordinate, and every codeword supported there is its unique scalar
multiple. -/
structure FourShorteningGenerator
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (S : Finset Party) where
  /-- The chosen shortened codeword. -/
  word : BasisLabel 𝔽
  /-- The generator belongs to the code. -/
  mem_code : word ∈ C
  /-- The generator vanishes off the retained set. -/
  eq_zero_off : ∀ i, i ∉ S → word i = 0
  /-- Every retained coordinate of the generator is nonzero. -/
  ne_zero_on : ∀ i, i ∈ S → word i ≠ 0
  /-- Every codeword supported on the retained set is a scalar multiple
  of the generator. -/
  exists_smul_eq :
    ∀ d ∈ C, (∀ i, i ∉ S → d i = 0) → ∃ a : 𝔽, a • word = d
  /-- The scalar in the preceding representation is unique. -/
  smul_right_injective : Function.Injective fun a : 𝔽 => a • word

/-- Every four-coordinate shortening of an exact `[6,3,4]` code has a
generator with full support on those four coordinates. -/
noncomputable def fourShorteningGenerator
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (hC : IsMDSCode634 C)
    (S : Finset Party) (hS : S.card = 4) :
    FourShorteningGenerator C S := by
  classical
  have hSne : S.Nonempty := by
    rw [← Finset.card_pos, hS]
    decide
  let i := hSne.choose
  have hiS : i ∈ S := hSne.choose_spec
  let T : Finset Party := Sᶜ ∪ {i}
  have hT : T.card = 3 := by
    rw [Finset.card_union_of_disjoint]
    · rw [Finset.card_compl, hS]
      simp
    · exact Finset.disjoint_singleton_right.mpr
        (by simpa using hiS)
  let z : T → 𝔽 := fun j => if j.1 = i then 1 else 0
  let hex := (codeProjection_bijective_of_card_three hC hT).2 z
  let c := Classical.choose hex
  have hc : codeProjection C T c = z := Classical.choose_spec hex
  have hci : c.1 i = 1 := by
    have hiT : i ∈ T := by simp [T]
    have hi := congrFun hc ⟨i, hiT⟩
    simpa [codeProjection, z] using hi
  have hcOff : ∀ j, j ∉ S → c.1 j = 0 := by
    intro j hjS
    have hjT : j ∈ T := by simp [T, hjS]
    have hj := congrFun hc ⟨j, hjT⟩
    have hji : j ≠ i := by
      intro h
      exact hjS (h ▸ hiS)
    simpa [codeProjection, z, hji] using hj
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
      exact Finset.mem_erase.mpr ⟨by
        intro hkj
        exact hk0 (hkj ▸ hcj), hkS⟩
    have hcard :
        hammingNorm c.1 ≤ 3 := by
      calc
        hammingNorm c.1 ≤ (S.erase j).card :=
          Finset.card_le_card hsupport
        _ = 3 := by simp [hS, hjS]
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
    have heq : dc = dd := (codeProjection_bijective_of_card_three hC hT).1 (by
      funext j
      by_cases hji : j.1 = i
      · simp [dc, dd, codeProjection, hji, hci]
      · have hjSc : j.1 ∈ Sᶜ := by
          have hjT := j.2
          simp only [T, Finset.mem_union, Finset.mem_singleton] at hjT
          exact hjT.resolve_right hji
        have hjS : j.1 ∉ S := Finset.mem_compl.mp hjSc
        simp [dc, dd, codeProjection, hcOff j.1 hjS, hdOff j.1 hjS])
    exact congrArg Subtype.val heq
  · intro a b hab
    have hi := congrFun hab i
    simpa [hci] using hi

/-- The chosen shortening generators for `C` and `C⊥` parametrize every
CSS label supported on a four-coordinate set. -/
theorem cssSupportedLabelSpace_eq_shortening_plane
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4) :
    let c := fourShorteningGenerator C hC S hS
    let h := fourShorteningGenerator (FiniteGeom.dualCode C)
      (isMDSCode634_dualCode hC) S hS
    ∀ v : PauliLabel 𝔽,
      v ∈ cssSupportedLabelSpace C S ↔
        ∃ a b : 𝔽, v = (a • c.word, b • h.word) := by
  classical
  dsimp
  intro v
  constructor
  · intro hv
    obtain ⟨hvC, hvD, hvS⟩ := mem_cssSupportedLabelSpace.mp hv
    obtain ⟨a, ha⟩ :=
      (fourShorteningGenerator C hC S hS).exists_smul_eq v.1 hvC
        (fun i hi => (hvS i hi).1)
    obtain ⟨b, hb⟩ :=
      (fourShorteningGenerator (FiniteGeom.dualCode C)
        (isMDSCode634_dualCode hC) S hS).exists_smul_eq v.2 hvD
        (fun i hi => (hvS i hi).2)
    exact ⟨a, b, Prod.ext ha.symm hb.symm⟩
  · rintro ⟨a, b, rfl⟩
    apply mem_cssSupportedLabelSpace.mpr
    refine
      ⟨C.smul_mem a (fourShorteningGenerator C hC S hS).mem_code,
        (FiniteGeom.dualCode C).smul_mem b
          (fourShorteningGenerator (FiniteGeom.dualCode C)
            (isMDSCode634_dualCode hC) S hS).mem_code, ?_⟩
    intro i hi
    simp [(fourShorteningGenerator C hC S hS).eq_zero_off i hi,
      (fourShorteningGenerator (FiniteGeom.dualCode C)
        (isMDSCode634_dualCode hC) S hS).eq_zero_off i hi]

/-- At every retained coordinate, the shortening-plane parameters map
bijectively to the two local Weyl labels. -/
theorem shorteningLocalLabel_bijective
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4) {i : Party} (hi : i ∈ S) :
    let c := fourShorteningGenerator C hC S hS
    let h := fourShorteningGenerator (FiniteGeom.dualCode C)
      (isMDSCode634_dualCode hC) S hS
    Function.Bijective fun v : 𝔽 × 𝔽 =>
      (v.1 * c.word i, v.2 * h.word i) := by
  classical
  dsimp
  let ci := (fourShorteningGenerator C hC S hS).word i
  let hi' := (fourShorteningGenerator (FiniteGeom.dualCode C)
    (isMDSCode634_dualCode hC) S hS).word i
  have hci : ci ≠ 0 :=
    (fourShorteningGenerator C hC S hS).ne_zero_on i hi
  have hhi : hi' ≠ 0 :=
    (fourShorteningGenerator (FiniteGeom.dualCode C)
      (isMDSCode634_dualCode hC) S hS).ne_zero_on i hi
  constructor
  · rintro ⟨a, b⟩ ⟨a', b'⟩ hab
    apply Prod.ext
    · exact mul_right_cancel₀ hci (congrArg Prod.fst hab)
    · exact mul_right_cancel₀ hhi (congrArg Prod.snd hab)
  · rintro ⟨x, y⟩
    exact ⟨(x / ci, y / hi'), by
      simp [ci, hi', hci, hhi]⟩

end RelativeConicArcs.AMELU
