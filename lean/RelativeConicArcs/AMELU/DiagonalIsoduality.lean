import RelativeConicArcs.AMELU.EncoderTransversal

/-!
# Diagonal multiplier spaces of half-dimensional MDS codes

For two length-`2m` linear codes, the diagonal multipliers carrying the first
code into the second form a linear subspace of the coordinate-scalar space.
When both codes have exact parameters `[2m,m,m+1]`, every nonzero member of
this space has full coordinate support.  Consequently the multiplier space has
dimension at most one.

Specializing the target to the Euclidean dual gives an intrinsic linear test
for diagonal isoduality.  The zero-dimensional case has no diagonal-duality
witness; in the one-dimensional case the witness is unique up to scalar and
all ratios between its coordinates are independent of the chosen witness.

All arguments are symbolic and kernel checked.  This module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

noncomputable section

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Coordinatewise multiplication by an arbitrary, possibly singular,
diagonal multiplier. -/
def diagonalScaleGenericLabel
    (s x : GenericBasisLabel m 𝔽) :
    GenericBasisLabel m 𝔽 :=
  fun i => s i * x i

/-- Coordinatewise multiplication by a fixed diagonal is a linear map. -/
def diagonalScaleLinearMap
    (s : GenericBasisLabel m 𝔽) :
    GenericBasisLabel m 𝔽 →ₗ[𝔽] GenericBasisLabel m 𝔽 where
  toFun := diagonalScaleGenericLabel s
  map_add' := by
    intro x y
    funext i
    simp [diagonalScaleGenericLabel, mul_add]
  map_smul' := by
    intro a x
    funext i
    change s i * (a * x i) = a * (s i * x i)
    ring

/-- The linear space of diagonal multipliers carrying `C` into `D`. -/
def diagonalMultiplierSpace
    (C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)) :
    Submodule 𝔽 (GenericBasisLabel m 𝔽) where
  carrier := {s | ∀ x ∈ C, diagonalScaleGenericLabel s x ∈ D}
  zero_mem' := by
    intro x hx
    convert D.zero_mem using 1
    funext i
    simp [diagonalScaleGenericLabel]
  add_mem' := by
    intro s t hs ht x hx
    convert D.add_mem (hs x hx) (ht x hx) using 1
    funext i
    simp [diagonalScaleGenericLabel, add_mul]
  smul_mem' := by
    intro a s hs x hx
    convert D.smul_mem a (hs x hx) using 1
    funext i
    simp [diagonalScaleGenericLabel, mul_assoc]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Membership in the diagonal multiplier space is the pointwise code-image
condition used in its definition. -/
theorem mem_diagonalMultiplierSpace_iff
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    {s : GenericBasisLabel m 𝔽} :
    s ∈ diagonalMultiplierSpace C D ↔
      ∀ x ∈ C, diagonalScaleGenericLabel s x ∈ D :=
  Iff.rfl

omit [Fintype 𝔽] in
/-- Between exact `[2m,m,m+1]` MDS codes, a nonzero diagonal multiplier
carrying one code into the other is nonzero in every coordinate. -/
theorem diagonalMultiplier_ne_zero_at
    (hm : 0 < m)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    {s : GenericBasisLabel m 𝔽}
    (hs : s ∈ diagonalMultiplierSpace C D)
    (hs0 : s ≠ 0) (i : GenericParty m) :
    s i ≠ 0 := by
  classical
  obtain ⟨k, hk⟩ : ∃ k, s k ≠ 0 := by
    by_contra h
    push Not at h
    exact hs0 (funext h)
  obtain ⟨S, hikS, -, hScard⟩ :=
    Finset.exists_subsuperset_card_eq
      (s := ({i, k} : Finset (GenericParty m)))
      (t := Finset.univ) (n := m + 1)
      (by simp)
      (by
        calc
          ({i, k} : Finset (GenericParty m)).card ≤ 2 := Finset.card_le_two
          _ ≤ m + 1 := by omega)
      (by
        rw [Finset.card_univ, Fintype.card_fin]
        omega)
  let shortening := genericShorteningGenerator hm C hC S hScard
  let y := diagonalScaleGenericLabel s shortening.word
  have hyD : y ∈ D := hs shortening.word shortening.mem_code
  have hy0 : y ≠ 0 := by
    intro hy
    have hyk := congrFun hy k
    have hkS : k ∈ S := hikS (by simp)
    have hproduct : s k * shortening.word k = 0 := by
      simpa [y, diagonalScaleGenericLabel] using hyk
    exact (mul_ne_zero hk (shortening.ne_zero_on k hkS)) hproduct
  intro hi0
  have hsupp :
      (Finset.univ.filter fun j => y j ≠ 0) ⊆ S.erase i := by
    intro j hj
    have hyj := (Finset.mem_filter.mp hj).2
    have hjS : j ∈ S := by
      by_contra hjS
      exact hyj (by
        simp [y, diagonalScaleGenericLabel, shortening.eq_zero_off j hjS])
    refine Finset.mem_erase.mpr ⟨?_, hjS⟩
    intro hji
    subst j
    exact hyj (by simp [y, diagonalScaleGenericLabel, hi0])
  have hweight : hammingNorm y ≤ m := by
    calc
      hammingNorm y ≤ (S.erase i).card := Finset.card_le_card hsupp
      _ = m := by
        have hiS : i ∈ S := hikS (by simp)
        simp [hScard, hiS]
  have hmin := FiniteGeom.minDist_le_hammingNorm hyD hy0
  rw [hD.2] at hmin
  omega

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- A diagonal linear map with no zero coordinate multiplier is injective. -/
theorem diagonalScaleLinearMap_injective
    {s : GenericBasisLabel m 𝔽}
    (hfull : ∀ i, s i ≠ 0) :
    Function.Injective (diagonalScaleLinearMap s) := by
  intro x y hxy
  funext i
  have hi := congrFun hxy i
  exact mul_left_cancel₀ (hfull i) (by
    simpa [diagonalScaleLinearMap, diagonalScaleGenericLabel] using hi)

/-- A diagonal multiplier carrying `C` into `D` induces the corresponding
linear map between the two code submodules. -/
def diagonalMultiplierLinearMap
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    {s : GenericBasisLabel m 𝔽}
    (hs : s ∈ diagonalMultiplierSpace C D) :
    C →ₗ[𝔽] D :=
  (diagonalScaleLinearMap s).domRestrict C |>.codRestrict D (fun x => hs x.1 x.2)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- A full-support diagonal multiplier induces an injective map between code
submodules. -/
theorem diagonalMultiplierLinearMap_injective
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    {s : GenericBasisLabel m 𝔽}
    (hs : s ∈ diagonalMultiplierSpace C D)
    (hfull : ∀ i, s i ≠ 0) :
    Function.Injective (diagonalMultiplierLinearMap hs) := by
  intro x y hxy
  apply Subtype.ext
  apply diagonalScaleLinearMap_injective hfull
  exact congrArg Subtype.val hxy

omit [Fintype 𝔽] in
/-- A nonzero diagonal multiplier between exact MDS codes induces a linear
equivalence of their underlying code spaces. -/
theorem diagonalMultiplierLinearMap_bijective
    (hm : 0 < m)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    {s : GenericBasisLabel m 𝔽}
    (hs : s ∈ diagonalMultiplierSpace C D)
    (hs0 : s ≠ 0) :
    Function.Bijective (diagonalMultiplierLinearMap hs) := by
  have hfull := diagonalMultiplier_ne_zero_at hm hC hD hs hs0
  have hinj := diagonalMultiplierLinearMap_injective hs hfull
  refine ⟨hinj, (LinearMap.injective_iff_surjective_of_finrank_eq_finrank ?_).mp hinj⟩
  rw [hC.1, hD.1]

/-- A subspace of coordinate vectors whose nonzero members have full support
has dimension at most one.  A single coordinate detects the scalar relating
any member to a fixed nonzero member. -/
theorem finrank_le_one_of_forall_ne_zero_at
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (W : Submodule 𝔽 (ι → 𝔽)) (i : ι)
    (hfull : ∀ w ∈ W, w ≠ 0 → ∀ j, w j ≠ 0) :
    Module.finrank 𝔽 W ≤ 1 := by
  by_cases hW : ∃ v : W, v ≠ 0
  · obtain ⟨v, hv0⟩ := hW
    apply finrank_le_one v
    intro w
    let a : 𝔽 := w.1 i / v.1 i
    refine ⟨a, Subtype.ext ?_⟩
    funext j
    let d : W := w - a • v
    have hdi : d.1 i = 0 := by
      have hvi : v.1 i ≠ 0 := hfull v.1 v.2 (by
        intro hv
        apply hv0
        exact Subtype.ext hv) i
      simp [d, a, div_eq_mul_inv, hvi]
    have hd0 : d = 0 := by
      by_contra hd0
      exact (hfull d.1 d.2 (by
        intro hd
        apply hd0
        exact Subtype.ext hd) i) hdi
    have hdj := congrFun (congrArg Subtype.val hd0) j
    have hw : w.1 j - a * v.1 j = 0 := by
      simpa [d] using hdj
    exact (sub_eq_zero.mp hw).symm
  · push Not at hW
    apply finrank_le_one (0 : W)
    intro w
    exact ⟨0, by simpa using (hW w).symm⟩

/-- The diagonal multipliers from an exact MDS code to another exact MDS code
form a space of dimension at most one. -/
theorem diagonalMultiplierSpace_finrank_le_one
    (hm : 0 < m)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D) :
    Module.finrank 𝔽 (diagonalMultiplierSpace C D) ≤ 1 := by
  let i : GenericParty m := ⟨0, by omega⟩
  apply finrank_le_one_of_forall_ne_zero_at
    (diagonalMultiplierSpace C D) i
  intro s hs hs0 j
  exact diagonalMultiplier_ne_zero_at hm hC hD hs hs0 j

/-- The linear space of diagonal multipliers carrying a code into its
Euclidean dual. -/
def diagonalDualityMultiplierSpace
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) :
    Submodule 𝔽 (GenericBasisLabel m 𝔽) :=
  diagonalMultiplierSpace C (FiniteGeom.dualCode C)

/-- For an exact MDS code, the diagonal code-to-dual multiplier space has
dimension at most one. -/
theorem diagonalDualityMultiplierSpace_finrank_le_one
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Module.finrank 𝔽 (diagonalDualityMultiplierSpace C) ≤ 1 := by
  exact diagonalMultiplierSpace_finrank_le_one hm hC
    (isMDSCode2m_dualCode hm hC)

/-- The diagonal code-to-dual multiplier nullity of an exact MDS code is
either zero or one. -/
theorem diagonalDualityMultiplierSpace_finrank_eq_zero_or_one
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Module.finrank 𝔽 (diagonalDualityMultiplierSpace C) = 0 ∨
      Module.finrank 𝔽 (diagonalDualityMultiplierSpace C) = 1 := by
  have hle := diagonalDualityMultiplierSpace_finrank_le_one hm hC
  omega

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The unit-valued multiplier of a diagonal-duality witness belongs to the
linear diagonal code-to-dual multiplier space. -/
theorem GenericDiagonalDuality.multiplier_mem
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (duality : GenericDiagonalDuality C) :
    (fun i => (duality.multiplier i : 𝔽)) ∈
      diagonalDualityMultiplierSpace C := by
  intro x hx
  exact (duality.scale_mem_dual_iff x).2 hx

/-- The diagonal symmetric form associated with an arbitrary coordinate
multiplier.  Its value on `x,y` is the standard dot product of `x` with the
diagonally scaled vector `y`. -/
def diagonalMultiplierBilinForm
    (s : GenericBasisLabel m 𝔽) :
    LinearMap.BilinForm 𝔽 (GenericBasisLabel m 𝔽) :=
  genericStandardDotBilinForm.compRight (diagonalScaleLinearMap s)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- A diagonal-duality witness makes the code totally isotropic for its
associated diagonal symmetric form. -/
theorem GenericDiagonalDuality.diagonalMultiplierBilinForm_eq_zero
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (duality : GenericDiagonalDuality C)
    {x y : GenericBasisLabel m 𝔽}
    (hx : x ∈ C) (hy : y ∈ C) :
    diagonalMultiplierBilinForm
      (fun i => (duality.multiplier i : 𝔽)) x y = 0 := by
  exact
    (FiniteGeom.mem_dualCode.mp
      ((duality.scale_mem_dual_iff y).2 hy)) x hx

/-- A nonzero member of the diagonal code-to-dual multiplier space determines
a unit-valued diagonal-duality witness. -/
def genericDiagonalDualityOfMultiplier
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (s : GenericBasisLabel m 𝔽)
    (hs : s ∈ diagonalDualityMultiplierSpace C)
    (hs0 : s ≠ 0) :
    GenericDiagonalDuality C := by
  let D := FiniteGeom.dualCode C
  have hD : IsMDSCode2m D := isMDSCode2m_dualCode hm hC
  have hfull : ∀ i, s i ≠ 0 :=
    diagonalMultiplier_ne_zero_at hm hC hD hs hs0
  let u : GenericParty m → 𝔽ˣ := fun i => Units.mk0 (s i) (hfull i)
  have hbij := diagonalMultiplierLinearMap_bijective hm hC hD hs hs0
  refine
    { multiplier := u
      scale_mem_dual_iff := ?_
      inverseScale_mem_code_iff := ?_ }
  · intro x
    constructor
    · intro hxD
      obtain ⟨c, hc⟩ := hbij.2 ⟨scaleGenericLabel u x, hxD⟩
      have hscaled :
          diagonalScaleLinearMap s c.1 = diagonalScaleLinearMap s x := by
        exact congrArg Subtype.val hc
      have hcx : c.1 = x := diagonalScaleLinearMap_injective hfull hscaled
      exact hcx ▸ c.2
    · intro hxC
      exact hs x hxC
  · intro x
    constructor
    · intro hxC
      have hscaled :
          scaleGenericLabel u (inverseScaleGenericLabel u x) = x := by
        funext i
        simp [scaleGenericLabel, inverseScaleGenericLabel, u, hfull i]
      rw [← hscaled]
      exact hs _ hxC
    · intro hxD
      have hscaled :
          scaleGenericLabel u (inverseScaleGenericLabel u x) = x := by
        funext i
        simp [scaleGenericLabel, inverseScaleGenericLabel, u, hfull i]
      have :
          scaleGenericLabel u (inverseScaleGenericLabel u x) ∈
            FiniteGeom.dualCode C := hscaled.symm ▸ hxD
      obtain ⟨c, hc⟩ := hbij.2
        ⟨scaleGenericLabel u (inverseScaleGenericLabel u x), this⟩
      have hdiag :
          diagonalScaleLinearMap s c.1 =
            diagonalScaleLinearMap s (inverseScaleGenericLabel u x) := by
        exact congrArg Subtype.val hc
      have hcEq :
          c.1 = inverseScaleGenericLabel u x :=
        diagonalScaleLinearMap_injective hfull hdiag
      exact hcEq ▸ c.2

/-- For an exact MDS code, diagonal isoduality is equivalent to nullity one
of the linear diagonal code-to-dual multiplier space. -/
theorem isDiagonallyIsodual_iff_finrank_eq_one
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    IsDiagonallyIsodual C ↔
      Module.finrank 𝔽 (diagonalDualityMultiplierSpace C) = 1 := by
  constructor
  · rintro ⟨duality⟩
    have hs := duality.multiplier_mem
    have hs0 : (⟨_, hs⟩ : diagonalDualityMultiplierSpace C) ≠ 0 := by
      intro h
      let i : GenericParty m := ⟨0, by omega⟩
      have hi := congrFun (congrArg Subtype.val h) i
      change (duality.multiplier i : 𝔽) = 0 at hi
      exact (duality.multiplier i).ne_zero hi
    have hpos :
        0 < Module.finrank 𝔽 (diagonalDualityMultiplierSpace C) :=
      Module.finrank_pos_iff_exists_ne_zero.mpr ⟨_, hs0⟩
    have hle := diagonalDualityMultiplierSpace_finrank_le_one hm hC
    omega
  · intro hdim
    have hpos :
        0 < Module.finrank 𝔽 (diagonalDualityMultiplierSpace C) := by
      omega
    obtain ⟨s, hs0⟩ :=
      Module.finrank_pos_iff_exists_ne_zero.mp hpos
    exact ⟨genericDiagonalDualityOfMultiplier hm hC s.1 s.2 (by
      intro hs
      apply hs0
      exact Subtype.ext hs)⟩

/-- For an exact MDS code, failure of diagonal isoduality is equivalent to
nullity zero of the diagonal code-to-dual multiplier space. -/
theorem not_isDiagonallyIsodual_iff_finrank_eq_zero
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    ¬ IsDiagonallyIsodual C ↔
      Module.finrank 𝔽 (diagonalDualityMultiplierSpace C) = 0 := by
  rw [isDiagonallyIsodual_iff_finrank_eq_one hm hC]
  have hle := diagonalDualityMultiplierSpace_finrank_le_one hm hC
  omega

/-- The nullity-one/nullity-zero multiplier test selects the exact
special-linear/split-torus fixed-party projective carrier. -/
theorem diagonalDualityNullity_fixedPartyProjectiveTransversal_dichotomy
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    {transversal : Set (ProjectiveLogicalAction 𝔽)}
    (inputs : DiagonalIsodualityTransversalInputs C transversal) :
    (Module.finrank 𝔽 (diagonalDualityMultiplierSpace C) = 1 →
      transversal = affineSpecialLinearSet) ∧
    (Module.finrank 𝔽 (diagonalDualityMultiplierSpace C) = 0 →
      transversal = affineSplitTorusSet) := by
  obtain ⟨hisodual, hnonisodual⟩ :=
    diagonallyIsodual_fixedPartyProjectiveTransversal_dichotomy inputs
  constructor
  · intro hdim
    exact hisodual ((isDiagonallyIsodual_iff_finrank_eq_one hm hC).2 hdim)
  · intro hdim
    exact hnonisodual
      ((not_isDiagonallyIsodual_iff_finrank_eq_zero hm hC).2 hdim)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- One realized nondiagonal block forces the full affine special-linear
fixed-party projective carrier. -/
theorem offDiagonalBlock_fixedPartyProjectiveTransversal_eq_affineSpecialLinear
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    {transversal : Set (ProjectiveLogicalAction 𝔽)}
    (inputs : DiagonalIsodualityTransversalInputs C transversal)
    {A : LogicalBlock 𝔽} (hA : A ∈ inputs.kernel)
    (hoff : A 0 1 ≠ 0 ∨ A 1 0 ≠ 0) :
    transversal = affineSpecialLinearSet := by
  exact
    (diagonallyIsodual_fixedPartyProjectiveTransversal_dichotomy inputs).1
      (inputs.offDiagonal_kernel_implies_isodual hA hoff)

omit [Fintype 𝔽] in
/-- Any two nonzero diagonal multipliers between exact MDS codes are scalar
multiples. -/
theorem diagonalMultiplier_exists_smul_eq
    (hm : 0 < m)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    {s t : GenericBasisLabel m 𝔽}
    (hs : s ∈ diagonalMultiplierSpace C D)
    (ht : t ∈ diagonalMultiplierSpace C D)
    (ht0 : t ≠ 0) :
    ∃ a : 𝔽, a • t = s := by
  let i : GenericParty m := ⟨0, by omega⟩
  let a : 𝔽 := s i / t i
  refine ⟨a, ?_⟩
  let d := s - a • t
  have hd : d ∈ diagonalMultiplierSpace C D :=
    (diagonalMultiplierSpace C D).sub_mem hs
      ((diagonalMultiplierSpace C D).smul_mem a ht)
  have hdi : d i = 0 := by
    have hti : t i ≠ 0 :=
      diagonalMultiplier_ne_zero_at hm hC hD ht ht0 i
    simp [d, a, div_eq_mul_inv, hti]
  have hd0 : d = 0 := by
    by_contra hd0
    exact (diagonalMultiplier_ne_zero_at hm hC hD hd hd0 i) hdi
  have hst : s = a • t := sub_eq_zero.mp hd0
  exact hst.symm

omit [Fintype 𝔽] in
/-- The diagonal self-multipliers of an exact MDS code are precisely the
scalar multiples of the all-ones multiplier. -/
theorem diagonalMultiplierSpace_self_eq_span_one
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    diagonalMultiplierSpace C C =
      Submodule.span 𝔽 {(fun _ => 1 : GenericBasisLabel m 𝔽)} := by
  let one : GenericBasisLabel m 𝔽 := fun _ => 1
  have hone : one ∈ diagonalMultiplierSpace C C := by
    intro x hx
    convert hx using 1
    funext i
    simp [one, diagonalScaleGenericLabel]
  have hone0 : one ≠ 0 := by
    intro h
    let i : GenericParty m := ⟨0, by omega⟩
    have hi := congrFun h i
    simp [one] at hi
  apply le_antisymm
  · intro s hs
    obtain ⟨a, ha⟩ :=
      diagonalMultiplier_exists_smul_eq hm hC hC hs hone hone0
    rw [← ha]
    exact (Submodule.span 𝔽 {one}).smul_mem a
      (Submodule.subset_span (by simp))
  · apply Submodule.span_le.mpr
    intro s hs
    have hso : s = one := by simpa [one] using hs
    exact hso ▸ hone

omit [Fintype 𝔽] in
/-- Diagonal-duality witnesses of an exact MDS code are unique up to a
nonzero scalar multiplier. -/
theorem diagonalDuality_exists_unit_smul_eq
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (duality₁ duality₂ : GenericDiagonalDuality C) :
    ∃ a : 𝔽ˣ, ∀ i,
      (duality₁.multiplier i : 𝔽) =
        (a : 𝔽) * (duality₂.multiplier i : 𝔽) := by
  let s : GenericBasisLabel m 𝔽 := fun i => (duality₁.multiplier i : 𝔽)
  let t : GenericBasisLabel m 𝔽 := fun i => (duality₂.multiplier i : 𝔽)
  have hs : s ∈ diagonalDualityMultiplierSpace C := duality₁.multiplier_mem
  have ht : t ∈ diagonalDualityMultiplierSpace C := duality₂.multiplier_mem
  have ht0 : t ≠ 0 := by
    intro htzero
    let i : GenericParty m := ⟨0, by omega⟩
    have hi := congrFun htzero i
    change (duality₂.multiplier i : 𝔽) = 0 at hi
    exact (duality₂.multiplier i).ne_zero hi
  obtain ⟨a, ha⟩ :=
    diagonalMultiplier_exists_smul_eq hm hC
      (isMDSCode2m_dualCode hm hC) hs ht ht0
  have ha0 : a ≠ 0 := by
    intro ha0
    have hs0 : s = 0 := by simpa [ha0] using ha.symm
    let i : GenericParty m := ⟨0, by omega⟩
    have hi := congrFun hs0 i
    change (duality₁.multiplier i : 𝔽) = 0 at hi
    exact (duality₁.multiplier i).ne_zero hi
  refine ⟨Units.mk0 a ha0, ?_⟩
  intro i
  have hi := congrFun ha i
  simpa [s, t, mul_comm] using hi.symm

omit [Fintype 𝔽] in
/-- Between two diagonal-duality witnesses of an exact MDS code there is a
unique nonzero scalar relating all coordinate multipliers. -/
theorem diagonalDuality_existsUnique_unit_smul_eq
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (duality₁ duality₂ : GenericDiagonalDuality C) :
    ∃! a : 𝔽ˣ, ∀ i,
      (duality₁.multiplier i : 𝔽) =
        (a : 𝔽) * (duality₂.multiplier i : 𝔽) := by
  obtain ⟨a, ha⟩ :=
    diagonalDuality_exists_unit_smul_eq hm hC duality₁ duality₂
  refine ⟨a, ha, ?_⟩
  intro b hb
  apply Units.ext
  let i : GenericParty m := ⟨0, by omega⟩
  exact mul_right_cancel₀ (duality₂.multiplier i).ne_zero
    ((hb i).symm.trans (ha i))

omit [Fintype 𝔽] in
/-- Ratios of diagonal-duality multipliers are independent of the chosen
witness for an exact MDS code. -/
theorem diagonalDuality_multiplier_ratio_eq
    (hm : 0 < m)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (duality₁ duality₂ : GenericDiagonalDuality C)
    (i j : GenericParty m) :
    (duality₁.multiplier i : 𝔽) / (duality₁.multiplier j : 𝔽) =
      (duality₂.multiplier i : 𝔽) / (duality₂.multiplier j : 𝔽) := by
  obtain ⟨a, ha⟩ :=
    diagonalDuality_exists_unit_smul_eq hm hC duality₁ duality₂
  rw [ha i, ha j]
  field_simp

end

end RelativeConicArcs.AMELU
