import RepairPorts.CoefficientPort
import Mathlib.LinearAlgebra.Dimension.Constructions

/-!
# Reconstruction from the minimum coefficient port of an MDS code

The MDS hypothesis is expressed on the dual relation space: an `[n,k]` code has a nonzero dual,
dual dimension `n-k`, and dual distance at least `k+1`.  These are the standard dual parameters of
an MDS code.  Finite-dimensional restriction then produces a dual word on every prescribed
`k+1` coordinates.  Minimum distance makes its support exact and its normalized representative
unique.

The resulting minimum coefficient words through one target span the whole dual relation space.
Their supports alone form the complete `k`-uniform clutter on the other coordinates; their
coefficients retain the represented code.
-/

namespace RepairPorts

open Finset

variable {ι : Type*} [Fintype ι] [DecidableEq ι]
  {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-- The standard dual-parameter characterization of an `[n,k]` MDS code. -/
structure HasMDSDualParameters (C : Submodule 𝔽 (ι → 𝔽)) (k : ℕ) : Prop where
  dual_ne_bot : FiniteGeom.dualCode C ≠ ⊥
  dual_finrank_add : Module.finrank 𝔽 (FiniteGeom.dualCode C) + k = Fintype.card ι
  dual_distance : k + 1 ≤ FiniteGeom.dualDist C

/-- Every prescribed `k+1` coordinate set supports a target-normalized minimum dual relation. -/
theorem HasMDSDualParameters.exists_normalized_word
    {C : Submodule 𝔽 (ι → 𝔽)} {k : ℕ} (hMDS : HasMDSDualParameters C k)
    {T : Finset ι} (hTcard : T.card = k + 1) {x : ι} (hxT : x ∈ T) :
    ∃ y ∈ FiniteGeom.dualCode C,
      y x = 1 ∧ FiniteGeom.wordSupport y = T := by
  let res : (FiniteGeom.dualCode C) →ₗ[𝔽] (↥Tᶜ → 𝔽) :=
    (LinearMap.funLeft 𝔽 𝔽 (fun j : ↥Tᶜ => (j : ι))) ∘ₗ
      (FiniteGeom.dualCode C).subtype
  have hnotinj : ¬Function.Injective res := by
    intro hinj
    have hle := LinearMap.finrank_le_finrank_of_injective hinj
    rw [Module.finrank_pi, Fintype.card_coe, Finset.card_compl, hTcard] at hle
    have hTle : k + 1 ≤ Fintype.card ι := by
      rw [← hTcard]
      exact Finset.card_le_univ T
    have hdim := hMDS.dual_finrank_add
    omega
  have hker : LinearMap.ker res ≠ ⊥ := by
    intro hbot
    exact hnotinj (LinearMap.ker_eq_bot.mp hbot)
  obtain ⟨a, ha, ha0⟩ := (Submodule.ne_bot_iff (LinearMap.ker res)).mp hker
  let y : ι → 𝔽 := a
  have hyC : y ∈ FiniteGeom.dualCode C := a.property
  have hy0 : y ≠ 0 := by
    intro hy
    apply ha0
    exact Subtype.ext hy
  have hres : res a = 0 := LinearMap.mem_ker.mp ha
  have hsuppsub : FiniteGeom.wordSupport y ⊆ T := by
    intro j hj
    by_contra hjT
    have hjTc : j ∈ Tᶜ := Finset.mem_compl.mpr hjT
    have hjzero := congrFun hres ⟨j, hjTc⟩
    simp only [res, LinearMap.comp_apply, LinearMap.funLeft_apply,
      Submodule.subtype_apply, Pi.zero_apply] at hjzero
    exact (FiniteGeom.mem_wordSupport.mp hj) hjzero
  have hsuppcard : T.card ≤ (FiniteGeom.wordSupport y).card := by
    rw [hTcard, FiniteGeom.card_wordSupport]
    exact hMDS.dual_distance.trans (FiniteGeom.dualDist_le_hammingNorm hyC hy0)
  have hsupp : FiniteGeom.wordSupport y = T :=
    Finset.eq_of_subset_of_card_le hsuppsub hsuppcard
  have hyx : y x ≠ 0 := by
    apply FiniteGeom.mem_wordSupport.mp
    rw [hsupp]
    exact hxT
  let z : ι → 𝔽 := (y x)⁻¹ • y
  have hzC : z ∈ FiniteGeom.dualCode C :=
    (FiniteGeom.dualCode C).smul_mem _ hyC
  have hzx : z x = 1 := by
    simp [z, hyx]
  have hsuppz : FiniteGeom.wordSupport z = T := by
    rw [show FiniteGeom.wordSupport z = FiniteGeom.wordSupport y by
      ext j
      simp only [FiniteGeom.mem_wordSupport, z, Pi.smul_apply, smul_eq_mul]
      exact mul_ne_zero_iff.trans <| and_iff_right (inv_ne_zero hyx)]
    exact hsupp
  exact ⟨z, hzC, hzx, hsuppz⟩

/-- The minimum support port of an MDS code is the complete `k`-uniform clutter on the helper
coordinates.  Thus support data at this radius depends only on the MDS parameters. -/
theorem HasMDSDualParameters.repairHypergraph_eq_powersetCard
    {C : Submodule 𝔽 (ι → 𝔽)} {k : ℕ} (hMDS : HasMDSDualParameters C k)
    (x : ι) :
    FiniteGeom.repairHypergraph C x k = (Finset.univ.erase x).powersetCard k := by
  ext R
  constructor
  · intro hR
    obtain ⟨hsub, hcard, y, hyC, hyx, hsupp⟩ :=
      FiniteGeom.mem_repairHypergraph.mp hR
    have hxR : x ∉ R := by
      intro hxR
      exact (Finset.mem_erase.mp (hsub hxR)).1 rfl
    have hy0 : y ≠ 0 := by
      intro hy0
      apply hyx
      simp [hy0]
    have hlow : k + 1 ≤ R.card + 1 := by
      calc
        k + 1 ≤ FiniteGeom.dualDist C := hMDS.dual_distance
        _ ≤ _ := FiniteGeom.dualDist_le_hammingNorm hyC hy0
        _ = (FiniteGeom.wordSupport y).card := (FiniteGeom.card_wordSupport y).symm
        _ = R.card + 1 := by rw [hsupp, Finset.card_insert_of_notMem hxR, Nat.add_comm]
    apply Finset.mem_powersetCard.mpr
    exact ⟨hsub, by omega⟩
  · intro hR
    obtain ⟨hsub, hcard⟩ := Finset.mem_powersetCard.mp hR
    have hxR : x ∉ R := by
      intro hxR
      exact (Finset.mem_erase.mp (hsub hxR)).1 rfl
    have hTcard : (insert x R).card = k + 1 := by
      rw [Finset.card_insert_of_notMem hxR, hcard, Nat.add_comm]
    obtain ⟨y, hyC, hyx, hsupp⟩ :=
      hMDS.exists_normalized_word hTcard (Finset.mem_insert_self x R)
    apply FiniteGeom.mem_repairHypergraph.mpr
    exact ⟨hsub, hcard.le, y, hyC, by simp [hyx], hsupp⟩

/-- For positive dimension `k`, the target-normalized minimum dual words span the entire dual
relation space.  Therefore one minimum coefficient port reconstructs the represented MDS code. -/
theorem HasMDSDualParameters.reconstructsAt
    {C : Submodule 𝔽 (ι → 𝔽)} {k : ℕ} (hMDS : HasMDSDualParameters C k)
    (hk : 1 ≤ k) (x : ι) :
    ReconstructsAt C x k := by
  classical
  let D := FiniteGeom.dualCode C
  let H := (Finset.univ : Finset ι).erase x
  haveI : Nontrivial D := Submodule.nontrivial_iff_ne_bot.mpr hMDS.dual_ne_bot
  have hdimpos : 0 < Module.finrank 𝔽 D := Module.finrank_pos
  have hkcard : k < Fintype.card ι := by
    have hdim := hMDS.dual_finrank_add
    have hdimpos' : 0 < Module.finrank 𝔽 (FiniteGeom.dualCode C) := by
      simpa [D] using hdimpos
    omega
  have hQbound : k - 1 ≤ H.card := by
    have hxuniv : x ∈ (Finset.univ : Finset ι) := Finset.mem_univ x
    simp only [H, Finset.card_erase_of_mem hxuniv, Finset.card_univ]
    omega
  obtain ⟨Q, hQsub, hQcard⟩ :=
    Finset.exists_subset_card_eq (s := H) (n := k - 1) hQbound
  let U := H \ Q
  have hxH : x ∉ H := by simp [H]
  have hxQ : x ∉ Q := fun hxQ => hxH (hQsub hxQ)
  have hUcard : U.card = Module.finrank 𝔽 D := by
    have hQk : Q.card + 1 = k := by omega
    have hdim := hMDS.dual_finrank_add
    have hxuniv : x ∈ (Finset.univ : Finset ι) := Finset.mem_univ x
    change (H \ Q).card = Module.finrank 𝔽 (FiniteGeom.dualCode C)
    rw [Finset.card_sdiff, Finset.inter_eq_left.mpr hQsub]
    change ((Finset.univ.erase x).card - Q.card) =
      Module.finrank 𝔽 (FiniteGeom.dualCode C)
    rw [Finset.card_erase_of_mem hxuniv, Finset.card_univ]
    omega
  have ht_not_Q (t : ↥U) : (t : ι) ∉ Q := by
    exact (Finset.mem_sdiff.mp t.property).2
  have ht_mem_H (t : ↥U) : (t : ι) ∈ H := by
    exact (Finset.mem_sdiff.mp t.property).1
  have ht_ne_x (t : ↥U) : (t : ι) ≠ x := by
    simpa [H] using ht_mem_H t
  have hRcard (t : ↥U) : (insert (t : ι) Q).card = k := by
    rw [Finset.card_insert_of_notMem (ht_not_Q t), hQcard]
    omega
  have hxR (t : ↥U) : x ∉ insert (t : ι) Q := by
    intro hxmem
    rcases Finset.mem_insert.mp hxmem with hxt | hxQ'
    · exact ht_ne_x t hxt.symm
    · exact hxQ hxQ'
  have hex (t : ↥U) :
      ∃ y ∈ D, y x = 1 ∧
        FiniteGeom.wordSupport y = insert x (insert (t : ι) Q) := by
    apply hMDS.exists_normalized_word
    · rw [Finset.card_insert_of_notMem (hxR t), hRcard]
    · exact Finset.mem_insert_self x _
  let y : ↥U → (ι → 𝔽) := fun t => Classical.choose (hex t)
  have hyD (t : ↥U) : y t ∈ D := (Classical.choose_spec (hex t)).1
  have hyx (t : ↥U) : y t x = 1 := (Classical.choose_spec (hex t)).2.1
  have hysupp (t : ↥U) :
      FiniteGeom.wordSupport (y t) = insert x (insert (t : ι) Q) :=
    (Classical.choose_spec (hex t)).2.2
  have hyt_ne_zero (t : ↥U) : y t (t : ι) ≠ 0 := by
    apply FiniteGeom.mem_wordSupport.mp
    rw [hysupp]
    simp
  have hyoff {s t : ↥U} (hst : s ≠ t) : y s (t : ι) = 0 := by
    by_contra hne
    have htmem : (t : ι) ∈ FiniteGeom.wordSupport (y s) :=
      FiniteGeom.mem_wordSupport.mpr hne
    rw [hysupp] at htmem
    rcases Finset.mem_insert.mp htmem with htx | htmem
    · exact ht_ne_x t htx
    · rcases Finset.mem_insert.mp htmem with hts | htQ
      · exact hst (Subtype.ext hts.symm)
      · exact ht_not_Q t htQ
  have hyLI : LinearIndependent 𝔽 y := by
    apply Fintype.linearIndependent_iff.mpr
    intro g hsum t
    have ht := congrFun hsum (t : ι)
    simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul, Pi.zero_apply] at ht
    rw [Finset.sum_eq_single t] at ht
    · exact (mul_eq_zero.mp ht).resolve_right (hyt_ne_zero t)
    · intro s _ hst
      rw [hyoff hst]
      exact mul_zero _
    · simp
  have hyPort (t : ↥U) : y t ∈ coefficientPort C x k := by
    refine ⟨hyD t, hyx t, ?_⟩
    rw [hysupp, Finset.erase_insert (hxR t), hRcard]
  have hspanYle : Submodule.span 𝔽 (Set.range y) ≤ D := by
    apply Submodule.span_le.mpr
    rintro _ ⟨t, rfl⟩
    exact hyD t
  have hspanYfinrank :
      Module.finrank 𝔽 D ≤ Module.finrank 𝔽 (Submodule.span 𝔽 (Set.range y)) := by
    rw [finrank_span_eq_card hyLI, Fintype.card_coe, hUcard]
  have hspanYeq : Submodule.span 𝔽 (Set.range y) = D :=
    Submodule.eq_of_le_of_finrank_le hspanYle hspanYfinrank
  apply le_antisymm (coefficientPortSpan_le_dualCode C x k)
  change D ≤ coefficientPortSpan C x k
  rw [← hspanYeq]
  apply Submodule.span_mono
  rintro _ ⟨t, rfl⟩
  exact hyPort t

/-- For an `[n,k]` MDS code with `k > 0`, a coefficient port reconstructs exactly from radius
`k` onward. -/
theorem HasMDSDualParameters.reconstructsAt_iff
    {C : Submodule 𝔽 (ι → 𝔽)} {k : ℕ} (hMDS : HasMDSDualParameters C k)
    (hk : 1 ≤ k) (x : ι) (r : ℕ) :
    ReconstructsAt C x r ↔ k ≤ r := by
  constructor
  · intro hr
    by_contra hkr
    have hrk : r < k := Nat.lt_of_not_ge hkr
    have hempty : coefficientPort C x r = ∅ := by
      apply Set.eq_empty_iff_forall_notMem.mpr
      show ∀ y, y ∉ coefficientPort C x r
      intro y hy
      obtain ⟨hyC, hyx, hcard⟩ := hy
      have hy0 : y ≠ 0 := by
        intro hy0
        simp [hy0] at hyx
      have hxSupp : x ∈ FiniteGeom.wordSupport y :=
        FiniteGeom.mem_wordSupport.mpr (by simp [hyx])
      have hdist :=
        hMDS.dual_distance.trans (FiniteGeom.dualDist_le_hammingNorm hyC hy0)
      rw [Finset.card_erase_of_mem hxSupp, FiniteGeom.card_wordSupport] at hcard
      omega
    have hbot : coefficientPortSpan C x r = ⊥ := by
      rw [coefficientPortSpan, hempty, Submodule.span_empty]
    exact hMDS.dual_ne_bot (hr ▸ hbot)
  · intro hkr
    exact reconstructsAt_mono hkr (hMDS.reconstructsAt hk x)

/-- The reconstruction radius of a positive-dimensional `[n,k]` MDS code is exactly `k`, the
minimum helper size. -/
theorem HasMDSDualParameters.reconstructionRadius_eq
    {C : Submodule 𝔽 (ι → 𝔽)} {k : ℕ} (hMDS : HasMDSDualParameters C k)
    (hk : 1 ≤ k) (x : ι) :
    reconstructionRadius C x = k := by
  apply le_antisymm
  · apply sInf_le
    exact ⟨k, hMDS.reconstructsAt hk x, rfl⟩
  · apply le_sInf
    intro z hz
    obtain ⟨r, hr, rfl⟩ := hz
    exact ENat.coe_le_coe.mpr ((hMDS.reconstructsAt_iff hk x r).mp hr)

#print axioms HasMDSDualParameters.exists_normalized_word
#print axioms HasMDSDualParameters.repairHypergraph_eq_powersetCard
#print axioms HasMDSDualParameters.reconstructsAt
#print axioms HasMDSDualParameters.reconstructionRadius_eq

end RepairPorts
