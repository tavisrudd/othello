import RelativeConicArcs.EvaluationObstruction
import Mathlib.FieldTheory.Finiteness
import Mathlib.LinearAlgebra.Dual.Lemmas

/-!
# Exact evaluation avoidance over finite fields

At most `q` proper linear hyperplanes cannot cover a nonzero finite-dimensional vector space over
the field with `q` elements.  We package the common-zero improvement of the elementary union bound,
then apply it to kernels of evaluation maps.  The boundary is sharp: `q + 1` hyperplanes can cover a
two-dimensional space.
-/

namespace RelativeConicArcs

section FiniteFieldAvoidance

variable {K W ι : Type*} [Field K] [Fintype K] [DecidableEq K]
  [AddCommGroup W] [Module K W] [Fintype W] [DecidableEq W]
  [FiniteDimensional K W]

private def zeroFinset (f : W →ₗ[K] K) : Finset W :=
  Finset.univ.filter fun x => f x = 0

/-- Vectors which are nonzero and avoid every functional in a finite family. -/
def avoidanceFinset (s : Finset ι) (L : ι → W →ₗ[K] K) : Finset W :=
  Finset.univ.filter fun x => x ≠ 0 ∧ ∀ i ∈ s, L i x ≠ 0

omit [Fintype K] [DecidableEq W] [FiniteDimensional K W] in
@[simp] private theorem mem_zeroFinset (f : W →ₗ[K] K) (x : W) :
    x ∈ zeroFinset f ↔ f x = 0 := by
  simp [zeroFinset]

omit [DecidableEq W] in
private theorem card_zeroFinset_of_ne_zero {f : W →ₗ[K] K} (hf : f ≠ 0) :
    (zeroFinset f).card = Fintype.card K ^ (Module.finrank K W - 1) := by
  classical
  simp only [zeroFinset]
  rw [← Fintype.card_subtype (fun x : W => f x = 0)]
  let e : {x : W // f x = 0} ≃ LinearMap.ker f :=
    Equiv.subtypeEquivRight fun x => by simp [LinearMap.mem_ker]
  rw [Fintype.card_congr e]
  rw [Module.card_eq_pow_finrank (K := K) (V := LinearMap.ker f)]
  congr 1
  have hdim := Module.Dual.finrank_ker_add_one_of_ne_zero hf
  omega

/-- The common-zero union bound for kernels of nonzero functionals.  Including `{0}` makes the
statement uniform for the empty family and exposes the saving over the plain union bound. -/
theorem card_zero_union_le (s : Finset ι) (L : ι → W →ₗ[K] K)
    (hne : ∀ i ∈ s, L i ≠ 0) :
    ({0} ∪ s.biUnion fun i => zeroFinset (L i)).card ≤
      1 + s.card * (Fintype.card K ^ (Module.finrank K W - 1) - 1) := by
  classical
  let punctured (i : ι) := zeroFinset (L i) \ {0}
  have hunion : {0} ∪ s.biUnion (fun i => zeroFinset (L i)) =
      {0} ∪ s.biUnion punctured := by
    ext x
    simp only [Finset.mem_union, Finset.mem_singleton, Finset.mem_biUnion,
      Finset.mem_sdiff, punctured]
    constructor
    · rintro (rfl | ⟨i, hi, hx⟩)
      · exact Or.inl rfl
      · by_cases hx0 : x = 0
        · exact Or.inl hx0
        · exact Or.inr ⟨i, hi, hx, hx0⟩
    · rintro (rfl | ⟨i, hi, hx, _⟩)
      · exact Or.inl rfl
      · exact Or.inr ⟨i, hi, hx⟩
  rw [hunion]
  calc
    ({0} ∪ s.biUnion punctured).card ≤ 1 + (s.biUnion punctured).card := by
      simpa using Finset.card_union_le ({0} : Finset W) (s.biUnion punctured)
    _ ≤ 1 + s.card * (Fintype.card K ^ (Module.finrank K W - 1) - 1) :=
      Nat.add_le_add_left
        (Finset.card_biUnion_le_card_mul s punctured
          (Fintype.card K ^ (Module.finrank K W - 1) - 1) (by
            intro i hi
            rw [Finset.card_sdiff_of_subset (Finset.singleton_subset_iff.mpr (by
              simp [zeroFinset])), card_zeroFinset_of_ne_zero (hne i hi),
              Finset.card_singleton])) 1

/-- Quantitative common-zero bound: this many nonzero vectors simultaneously avoid the family.
The positivity at `s.card ≤ q` is the exact threshold used below. -/
theorem card_avoidanceFinset_lower_bound (s : Finset ι) (L : ι → W →ₗ[K] K)
    (hne : ∀ i ∈ s, L i ≠ 0) :
    Fintype.card K ^ Module.finrank K W -
        (1 + s.card * (Fintype.card K ^ (Module.finrank K W - 1) - 1)) ≤
      (avoidanceFinset s L).card := by
  classical
  let bad : Finset W := {0} ∪ s.biUnion fun i => zeroFinset (L i)
  have hbad : bad.card ≤
      1 + s.card * (Fintype.card K ^ (Module.finrank K W - 1) - 1) :=
    card_zero_union_le s L hne
  have havoid : avoidanceFinset s L = Finset.univ \ bad := by
    ext x
    simp only [avoidanceFinset, Finset.mem_filter, Finset.mem_univ, true_and,
      Finset.mem_sdiff, Finset.mem_union, Finset.mem_singleton, Finset.mem_biUnion,
      mem_zeroFinset, bad]
    aesop
  rw [havoid, Finset.card_sdiff_of_subset (Finset.subset_univ bad), Finset.card_univ,
    Module.card_eq_pow_finrank (K := K) (V := W)]
  exact Nat.sub_le_sub_left hbad _

noncomputable def submoduleFinset (H : Submodule K W) : Finset W :=
  by
    classical
    exact Finset.univ.filter fun x => x ∈ H

omit [Fintype K] [DecidableEq K] [DecidableEq W] [FiniteDimensional K W] in
@[simp] private theorem mem_submoduleFinset (H : Submodule K W) (x : W) :
    x ∈ submoduleFinset H ↔ x ∈ H := by
  simp [submoduleFinset]

omit [DecidableEq K] [DecidableEq W] [FiniteDimensional K W] in
private theorem card_submoduleFinset (H : Submodule K W) :
    (submoduleFinset H).card = Fintype.card K ^ Module.finrank K H := by
  classical
  simp only [submoduleFinset]
  rw [← Fintype.card_subtype (fun x : W => x ∈ H)]
  exact Module.card_eq_pow_finrank

omit [AddCommGroup W] [Fintype W] in
private theorem card_biUnion_le_anchored [DecidableEq ι] (s : Finset ι)
    (B : ι → Finset W) (i₀ : ι) (hi₀ : i₀ ∈ s) (base step : ℕ)
    (hbase : (B i₀).card ≤ base)
    (hstep : ∀ i ∈ s, i ≠ i₀ → (B i \ B i₀).card ≤ step) :
    (s.biUnion B).card ≤ base + (s.card - 1) * step := by
  classical
  have hsubset : s.biUnion B ⊆
      B i₀ ∪ (s.erase i₀).biUnion fun i => B i \ B i₀ := by
    intro x hx
    obtain ⟨i, hi, hxi⟩ := Finset.mem_biUnion.mp hx
    by_cases hii : i = i₀
    · subst i
      exact Finset.mem_union_left _ hxi
    by_cases hxbase : x ∈ B i₀
    · exact Finset.mem_union_left _ hxbase
    · exact Finset.mem_union_right _ (Finset.mem_biUnion.mpr
        ⟨i, Finset.mem_erase.mpr ⟨hii, hi⟩, Finset.mem_sdiff.mpr ⟨hxi, hxbase⟩⟩)
  calc
    (s.biUnion B).card ≤
        (B i₀ ∪ (s.erase i₀).biUnion fun i => B i \ B i₀).card :=
      Finset.card_le_card hsubset
    _ ≤ (B i₀).card + ((s.erase i₀).biUnion fun i => B i \ B i₀).card :=
      Finset.card_union_le _ _
    _ ≤ base + (s.erase i₀).card * step := Nat.add_le_add hbase
      (Finset.card_biUnion_le_card_mul (s.erase i₀) (fun i => B i \ B i₀) step (by
        intro i hi
        exact hstep i (Finset.mem_of_mem_erase hi) (Finset.ne_of_mem_erase hi)))
    _ = base + (s.card - 1) * step := by rw [Finset.card_erase_of_mem hi₀]

omit [Fintype K] [DecidableEq K] [Fintype W] [DecidableEq W] in
private theorem finrank_inf_hyperplanes {H G : Submodule K W}
    (hH : Module.finrank K H + 1 = Module.finrank K W)
    (hG : Module.finrank K G + 1 = Module.finrank K W) (hne : H ≠ G) :
    Module.finrank K (H ⊓ G : Submodule K W) = Module.finrank K W - 2 := by
  have hsup : H ⊔ G = ⊤ := by
    by_contra htop
    have hlt : Module.finrank K (H ⊔ G : Submodule K W) < Module.finrank K W := by
      have hproper : H ⊔ G < (⊤ : Submodule K W) := lt_top_iff_ne_top.mpr htop
      simpa using Submodule.finrank_lt_finrank_of_lt hproper
    have hHle : Module.finrank K H ≤ Module.finrank K (H ⊔ G : Submodule K W) :=
      Submodule.finrank_mono le_sup_left
    have hGle : Module.finrank K G ≤ Module.finrank K (H ⊔ G : Submodule K W) :=
      Submodule.finrank_mono le_sup_right
    have hHeq : H = H ⊔ G := Submodule.eq_of_le_of_finrank_eq le_sup_left (by omega)
    have hGeq : G = H ⊔ G := Submodule.eq_of_le_of_finrank_eq le_sup_right (by omega)
    exact hne (hHeq.trans hGeq.symm)
  have hdim := Submodule.finrank_sup_add_finrank_inf_eq H G
  rw [hsup, finrank_top] at hdim
  omega

/-- Vectors outside every member of a finite family of subspaces. -/
noncomputable def outsideSubmodules (s : Finset (Submodule K W)) : Finset W :=
  Finset.univ \ s.biUnion submoduleFinset

omit [DecidableEq K] in
/-- Dimension-sensitive hyperplane-union bound.  Distinctness is built into the finset `s`:
after anchoring one hyperplane, every other contributes at most `q^(r-1)-q^(r-2)` new vectors. -/
theorem card_outside_hyperplanes_lower_bound (s : Finset (Submodule K W))
    (hdim : 2 ≤ Module.finrank K W)
    (hhyper : ∀ H ∈ s, Module.finrank K H + 1 = Module.finrank K W) :
    Fintype.card K ^ Module.finrank K W -
        (Fintype.card K ^ (Module.finrank K W - 1) +
          (s.card - 1) * (Fintype.card K ^ (Module.finrank K W - 1) -
            Fintype.card K ^ (Module.finrank K W - 2))) ≤
      (outsideSubmodules s).card := by
  classical
  by_cases hs : s = ∅
  · subst s
    simp [outsideSubmodules, Module.card_eq_pow_finrank (K := K) (V := W)]
  obtain ⟨H₀, hH₀⟩ := Finset.nonempty_iff_ne_empty.mpr hs
  let base := Fintype.card K ^ (Module.finrank K W - 1)
  let step := Fintype.card K ^ (Module.finrank K W - 1) -
    Fintype.card K ^ (Module.finrank K W - 2)
  have hbase : (submoduleFinset H₀).card = base := by
    rw [card_submoduleFinset]
    congr 1
    have := hhyper H₀ hH₀
    omega
  have hstep : ∀ H ∈ s, H ≠ H₀ →
      (submoduleFinset H \ submoduleFinset H₀).card = step := by
    intro H hH hne
    rw [Finset.card_sdiff]
    have hinter : submoduleFinset H₀ ∩ submoduleFinset H =
        submoduleFinset (H₀ ⊓ H) := by
      ext x
      simp
    have hHrank : Module.finrank K H = Module.finrank K W - 1 := by
      have := hhyper H hH
      omega
    have hIrank : Module.finrank K (H₀ ⊓ H : Submodule K W) =
        Module.finrank K W - 2 :=
      finrank_inf_hyperplanes (hhyper H₀ hH₀) (hhyper H hH) hne.symm
    rw [hinter, card_submoduleFinset, card_submoduleFinset]
    simp [hHrank, hIrank, step]
  have hunion := card_biUnion_le_anchored s submoduleFinset H₀ hH₀ base step
    hbase.le (fun H hH hne => (hstep H hH hne).le)
  rw [outsideSubmodules, Finset.card_sdiff_of_subset
    (Finset.subset_univ (s.biUnion submoduleFinset)), Finset.card_univ,
    Module.card_eq_pow_finrank (K := K) (V := W)]
  exact Nat.sub_le_sub_left hunion _

omit [DecidableEq K] in
/-- Factored form of the dimension-sensitive bound.  Thus `m ≤ q` distinct hyperplanes leave at
least `(q - 1) q^(r-2) (q + 1 - m)` vectors outside their union. -/
theorem card_outside_hyperplanes_factored_lower_bound (s : Finset (Submodule K W))
    (hs : s.Nonempty) (hdim : 2 ≤ Module.finrank K W)
    (hcard : s.card ≤ Fintype.card K)
    (hhyper : ∀ H ∈ s, Module.finrank K H + 1 = Module.finrank K W) :
    (Fintype.card K - 1) * Fintype.card K ^ (Module.finrank K W - 2) *
        (Fintype.card K + 1 - s.card) ≤ (outsideSubmodules s).card := by
  let q := Fintype.card K
  let r := Module.finrank K W
  let m := s.card
  let p := q ^ (r - 2)
  have hq : 2 ≤ q := by
    exact Fintype.one_lt_card (α := K)
  have hm : 1 ≤ m := Finset.card_pos.mpr hs
  have hpow1 : q ^ (r - 1) = q * p := by
    rw [show r - 1 = (r - 2) + 1 by omega, pow_succ, Nat.mul_comm]
  have hpowr : q ^ r = q * q * p := by
    rw [show r = (r - 1) + 1 by omega, pow_succ, hpow1]
    ring
  have hstep : q * p - p = (q - 1) * p := by
    simpa using (Nat.sub_mul q 1 p).symm
  have hsum : (q + 1 - m) + (m - 1) = q := by omega
  have hqsum : 1 + (q - 1) = q := by omega
  have htotal :
      q * q * p =
        (q - 1) * p * (q + 1 - m) +
          (q * p + (m - 1) * (q * p - p)) := by
    calc
      q * q * p = q * (1 + (q - 1)) * p := by rw [hqsum]
      _ = q * p + q * ((q - 1) * p) := by ring
      _ = q * p + ((q + 1 - m) + (m - 1)) * ((q - 1) * p) := by rw [hsum]
      _ = (q - 1) * p * (q + 1 - m) +
          (q * p + (m - 1) * (q * p - p)) := by rw [hstep]; ring
  have hformula :
      q * q * p - (q * p + (m - 1) * (q * p - p)) =
        (q - 1) * p * (q + 1 - m) :=
    Nat.sub_eq_of_eq_add htotal
  have hbound := card_outside_hyperplanes_lower_bound s hdim hhyper
  change q ^ r - (q ^ (r - 1) + (m - 1) * (q ^ (r - 1) - q ^ (r - 2))) ≤
    (outsideSubmodules s).card at hbound
  rw [hpowr, hpow1, show q ^ (r - 2) = p by rfl] at hbound
  change (q - 1) * p * (q + 1 - m) ≤ (outsideSubmodules s).card
  rwa [hformula] at hbound

/-- A family of at most `q` nonzero linear functionals on a nonzero finite-dimensional
`F_q`-space has a common nonzero avoidance vector. -/
theorem exists_ne_zero_forall_apply_ne_zero (s : Finset ι) (L : ι → W →ₗ[K] K)
    (hW : Nontrivial W) (hcard : s.card ≤ Fintype.card K)
    (hne : ∀ i ∈ s, L i ≠ 0) :
    ∃ x : W, x ≠ 0 ∧ ∀ i ∈ s, L i x ≠ 0 := by
  classical
  let bad : Finset W := {0} ∪ s.biUnion fun i => zeroFinset (L i)
  have hq : 2 ≤ Fintype.card K := by
    have := Fintype.one_lt_card (α := K)
    omega
  have hdim : 1 ≤ Module.finrank K W := by
    rw [Nat.succ_le_iff, Module.finrank_pos_iff]
    exact hW
  let p := Fintype.card K ^ (Module.finrank K W - 1)
  have hp : 1 ≤ p := one_le_pow₀ (by omega : 1 ≤ Fintype.card K)
  have hpow : Fintype.card W = Fintype.card K * p := by
    rw [Module.card_eq_pow_finrank (K := K) (V := W)]
    change Fintype.card K ^ Module.finrank K W =
      Fintype.card K * Fintype.card K ^ (Module.finrank K W - 1)
    have hn : Module.finrank K W = (Module.finrank K W - 1) + 1 := by omega
    calc
      Fintype.card K ^ Module.finrank K W =
          Fintype.card K ^ ((Module.finrank K W - 1) + 1) := congrArg _ hn
      _ = Fintype.card K ^ (Module.finrank K W - 1) * Fintype.card K := pow_succ _ _
      _ = Fintype.card K * Fintype.card K ^ (Module.finrank K W - 1) := Nat.mul_comm _ _
  have hbad : bad.card ≤ 1 + s.card * (p - 1) := by
    exact card_zero_union_le s L hne
  have hlt : bad.card < Fintype.card W := by
    rw [hpow]
    calc
      bad.card ≤ 1 + s.card * (p - 1) := hbad
      _ ≤ 1 + Fintype.card K * (p - 1) :=
        Nat.add_le_add_left (Nat.mul_le_mul_right (p - 1) hcard) 1
      _ < Fintype.card K + Fintype.card K * (p - 1) :=
        Nat.add_lt_add_right (Fintype.one_lt_card (α := K)) _
      _ = Fintype.card K * p := by
        calc
          Fintype.card K + Fintype.card K * (p - 1) =
              Fintype.card K * (p - 1) + Fintype.card K := Nat.add_comm _ _
          _ = Fintype.card K * (p - 1) + Fintype.card K * 1 := by rw [Nat.mul_one]
          _ = Fintype.card K * ((p - 1) + 1) := (Nat.mul_add _ _ _).symm
          _ = Fintype.card K * p := by rw [Nat.sub_add_cancel hp]
  obtain ⟨x, _, hx⟩ := Finset.exists_mem_notMem_of_card_lt_card
    (s := bad) (t := Finset.univ) (by simpa using hlt)
  refine ⟨x, ?_, ?_⟩
  · intro hx0
    apply hx
    exact Finset.mem_union_left _ (by simp [hx0])
  · intro i hi hzero
    apply hx
    exact Finset.mem_union_right _ (Finset.mem_biUnion.mpr
      ⟨i, hi, mem_zeroFinset (L i) x |>.mpr hzero⟩)

end FiniteFieldAvoidance

section SharpBoundary

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/-- The `q + 1` functionals whose kernels are all projective directions in `K²`. -/
def planeCoverFunctional : Option K → (K × K →ₗ[K] K)
  | none => LinearMap.snd K K K
  | some c => LinearMap.fst K K K - c • LinearMap.snd K K K

/-- The projective line of vectors killed by a member of the sharp plane cover. -/
def planeCoverHyperplane (t : Option K) : Submodule K (K × K) :=
  LinearMap.ker (planeCoverFunctional t)

omit [Fintype K] [DecidableEq K] in
@[simp] theorem planeCoverFunctional_none (x : K × K) :
    planeCoverFunctional (K := K) none x = x.2 := rfl

omit [Fintype K] [DecidableEq K] in
@[simp] theorem planeCoverFunctional_some (c : K) (x : K × K) :
    planeCoverFunctional (K := K) (some c) x = x.1 - c * x.2 := by
  simp [planeCoverFunctional]

omit [Fintype K] in
/-- Every vector in `K²` lies in one of the `q + 1` kernels. -/
theorem exists_planeCoverFunctional_eq_zero (x : K × K) :
    ∃ t : Option K, planeCoverFunctional t x = 0 := by
  by_cases hx : x.2 = 0
  · exact ⟨none, by simpa using hx⟩
  · refine ⟨some (x.1 / x.2), ?_⟩
    simp [hx]

omit [Fintype K] [DecidableEq K] in
/-- Every member of the sharp `q + 1` cover is a nonzero functional, hence has a proper kernel. -/
theorem planeCoverFunctional_ne_zero (t : Option K) :
    planeCoverFunctional t ≠ 0 := by
  cases t with
  | none =>
      intro h
      have := LinearMap.congr_fun h (0, 1)
      simp at this
  | some c =>
      intro h
      have := LinearMap.congr_fun h (1, 0)
      simp at this

omit [Fintype K] [DecidableEq K] in
/-- The `q + 1` kernels in the plane cover are pairwise distinct. -/
theorem planeCoverHyperplane_injective :
    Function.Injective (planeCoverHyperplane (K := K)) := by
  intro a b hab
  cases a with
  | none =>
      cases b with
      | none => rfl
      | some d =>
          exfalso
          have hx : (1, 0) ∈ planeCoverHyperplane (K := K) none := by
            simp [planeCoverHyperplane, LinearMap.mem_ker]
          rw [hab] at hx
          simp [planeCoverHyperplane, LinearMap.mem_ker] at hx
  | some c =>
      cases b with
      | none =>
          exfalso
          have hx : (1, 0) ∈ planeCoverHyperplane (K := K) none := by
            simp [planeCoverHyperplane, LinearMap.mem_ker]
          rw [← hab] at hx
          simp [planeCoverHyperplane, LinearMap.mem_ker] at hx
      | some d =>
          have hx : (c, 1) ∈ planeCoverHyperplane (K := K) (some c) := by
            simp [planeCoverHyperplane, LinearMap.mem_ker]
          rw [hab] at hx
          have hcd : c = d := sub_eq_zero.mp (by
            simpa [planeCoverHyperplane, LinearMap.mem_ker] using hx)
          simp [hcd]

/-- Every selected subfamily of the sharp plane cover attains the anchored-intersection union
count.  This is the rank-two equality model for the dimension-sensitive avoidance bound. -/
theorem card_outside_planeCoverHyperplanes
    (s : Finset (Option K)) (hs : s.Nonempty) :
    (outsideSubmodules (s.image (planeCoverHyperplane (K := K)))).card =
      Fintype.card K ^ 2 - (1 + s.card * (Fintype.card K - 1)) := by
  classical
  let H := planeCoverHyperplane (K := K)
  let punctured (t : Option K) := submoduleFinset (H t) \ {0}
  obtain ⟨t₀, ht₀⟩ := hs
  have hhyper (t : Option K) :
      Module.finrank K (H t) + 1 = Module.finrank K (K × K) := by
    exact Module.Dual.finrank_ker_add_one_of_ne_zero (planeCoverFunctional_ne_zero t)
  have hinter {a b : Option K} (hab : a ≠ b) : H a ⊓ H b = ⊥ := by
    apply Submodule.finrank_eq_zero.mp
    rw [finrank_inf_hyperplanes (hhyper a) (hhyper b) (fun h =>
      hab (planeCoverHyperplane_injective h))]
    simp
  have hpairwise : (s : Set (Option K)).PairwiseDisjoint punctured := by
    intro a _ b _ hab
    change Disjoint (punctured a) (punctured b)
    rw [Finset.disjoint_left]
    intro x hxa hxb
    have hxinf : x ∈ H a ⊓ H b :=
      ⟨mem_submoduleFinset (H a) x |>.mp (Finset.mem_sdiff.mp hxa).1,
        mem_submoduleFinset (H b) x |>.mp (Finset.mem_sdiff.mp hxb).1⟩
    rw [hinter hab] at hxinf
    exact (Finset.mem_sdiff.mp hxa).2 (by simpa using hxinf)
  have hpunctured (t : Option K) : (punctured t).card = Fintype.card K - 1 := by
    rw [Finset.card_sdiff_of_subset (Finset.singleton_subset_iff.mpr (by
      simp [H, submoduleFinset])), card_submoduleFinset]
    have ht := hhyper t
    simp at ht
    rw [ht]
    simp
  have hunion :
      (s.image H).biUnion submoduleFinset = {0} ∪ s.biUnion punctured := by
    ext x
    simp only [Finset.mem_biUnion, Finset.mem_image, Finset.mem_union,
      Finset.mem_singleton, Finset.mem_sdiff, punctured]
    constructor
    · rintro ⟨_, ⟨t, ht, rfl⟩, hx⟩
      by_cases hx0 : x = 0
      · exact Or.inl hx0
      · exact Or.inr ⟨t, ht, hx, hx0⟩
    · rintro (rfl | ⟨t, ht, hx, _⟩)
      · exact ⟨H t₀, ⟨t₀, ht₀, rfl⟩, by simp [submoduleFinset]⟩
      · exact ⟨H t, ⟨t, ht, rfl⟩, hx⟩
  have hcardUnion : ((s.image H).biUnion submoduleFinset).card =
      1 + s.card * (Fintype.card K - 1) := by
    rw [hunion, Finset.card_union_of_disjoint]
    · rw [Finset.card_singleton, Finset.card_biUnion hpairwise]
      simp [hpunctured]
    · rw [Finset.disjoint_left]
      simp [punctured]
  rw [outsideSubmodules, Finset.card_sdiff_of_subset
    (Finset.subset_univ ((s.image H).biUnion submoduleFinset)), Finset.card_univ,
    Module.card_eq_pow_finrank (K := K) (V := K × K), hcardUnion]
  simp

omit [Field K] [DecidableEq K] in
/-- The covering family at the sharp boundary has cardinality exactly `q + 1`. -/
theorem card_planeCover_index : Fintype.card (Option K) = Fintype.card K + 1 := by
  simp

end SharpBoundary

section KernelDichotomy

variable {K V X : Type*} [Field K] [Fintype K] [DecidableEq K]
  [AddCommGroup V] [Module K V] [Fintype V] [DecidableEq V]
  [FiniteDimensional K V]

omit [Fintype K] [DecidableEq K] [Fintype V] [DecidableEq V]
  [FiniteDimensional K V] in
private theorem domRestrict_ne_zero_iff_not_le_ker (S : Submodule K V)
    (f : V →ₗ[K] K) : f.domRestrict S ≠ 0 ↔ ¬S ≤ LinearMap.ker f := by
  constructor
  · intro hne hle
    apply hne
    ext x
    exact LinearMap.mem_ker.mp (hle x.property)
  · intro hnle heq
    apply hnle
    intro x hx
    rw [LinearMap.mem_ker]
    have := LinearMap.congr_fun heq (⟨x, hx⟩ : S)
    simpa using this

/-- Exact finite-field evaluation avoidance.  The right side says that the vanishing space on `U`
is nonzero and that no requested evaluation vanishes identically on it. -/
theorem evaluation_avoidance_iff (ev : X → V →ₗ[K] K) (U A : Finset X)
    (hcard : A.card ≤ Fintype.card K) :
    (∃ f : V, f ∈ LinearMap.ker (evaluationMap ev U) ∧ f ≠ 0 ∧
        ∀ a ∈ A, ev a f ≠ 0) ↔
      LinearMap.ker (evaluationMap ev U) ≠ ⊥ ∧
        ∀ a ∈ A, ¬LinearMap.ker (evaluationMap ev U) ≤ LinearMap.ker (ev a) := by
  classical
  let S := LinearMap.ker (evaluationMap ev U)
  constructor
  · rintro ⟨f, hfS, hf0, havoid⟩
    refine ⟨(Submodule.ne_bot_iff _).mpr ⟨f, hfS, hf0⟩, ?_⟩
    intro a ha hle
    exact havoid a ha (LinearMap.mem_ker.mp (hle hfS))
  · rintro ⟨hS, hproper⟩
    letI : Nontrivial S := Submodule.nontrivial_iff_ne_bot.mpr hS
    obtain ⟨f, hf0, havoid⟩ := exists_ne_zero_forall_apply_ne_zero
      (K := K) (W := S) A (fun a => (ev a).domRestrict S) inferInstance hcard (by
        intro a ha
        exact (domRestrict_ne_zero_iff_not_le_ker S (ev a)).mpr (hproper a ha))
    exact ⟨f.1, f.2, (fun hfval => hf0 (Subtype.ext hfval)), fun a ha => havoid a ha⟩

end KernelDichotomy

section DualSpan

variable {K E ι X : Type*} [Field K] [AddCommGroup E] [Module K E]
  [FiniteDimensional K E]

/-- Finite-dimensional kernel containment is exactly dual-span membership. -/
theorem mem_span_range_iff_iInf_ker_le_ker [Finite ι]
    (L : ι → E →ₗ[K] K) (f : E →ₗ[K] K) :
    f ∈ Submodule.span K (Set.range L) ↔
      (⨅ i, LinearMap.ker (L i)) ≤ LinearMap.ker f := by
  constructor
  · intro hf x hx
    rw [LinearMap.mem_ker]
    refine Submodule.span_induction (p := fun g _ => g x = 0) ?_ ?_ ?_ ?_ hf
    · rintro g ⟨i, rfl⟩
      exact LinearMap.mem_ker.mp
        ((Submodule.mem_iInf (fun i => LinearMap.ker (L i))).mp hx i)
    · exact LinearMap.zero_apply x
    · intro g h _ _ hg hh
      simp [hg, hh]
    · intro c g _ hg
      simp [hg]
  · exact FiniteDimensional.mem_span_of_iInf_ker_le_ker

/-- Vanishing on the common evaluation kernel is equivalent to membership in the span of the
evaluations defining that kernel. -/
theorem evaluation_ker_le_ker_iff_mem_span (ev : X → E →ₗ[K] K) (U : Finset X) (a : X) :
    LinearMap.ker (evaluationMap ev U) ≤ LinearMap.ker (ev a) ↔
      ev a ∈ Submodule.span K (Set.range fun u : U => ev u.1) := by
  rw [evaluationMap, LinearMap.ker_pi]
  exact (mem_span_range_iff_iInf_ker_le_ker (fun u : U => ev u.1) (ev a)).symm

end DualSpan

noncomputable section FeatureEvaluation

variable {K W X : Type*} [Field K] [Fintype K] [DecidableEq K]
  [AddCommGroup W] [Module K W] [Fintype W] [DecidableEq W] [FiniteDimensional K W]

/-- Evaluation of a linear form on a feature vector.  Taking the feature map to be a degree-`d`
Veronese map gives evaluation of homogeneous degree-`d` forms. -/
def featureEvaluation (ν : X → W) (x : X) : Module.Dual K W →ₗ[K] K :=
  Module.Dual.eval K W (ν x)

omit [Fintype K] [DecidableEq K] [Fintype W] [DecidableEq W]
  [FiniteDimensional K W] in
@[simp] theorem featureEvaluation_apply (ν : X → W) (x : X) (f : Module.Dual K W) :
    featureEvaluation ν x f = f (ν x) := rfl

omit [Fintype K] [DecidableEq K] [Fintype W] [DecidableEq W]
  [FiniteDimensional K W] in
private theorem eval_mem_span_iff (ν : X → W) (U : Finset X) (a : X) :
    Module.Dual.eval K W (ν a) ∈
        Submodule.span K (Set.range fun u : U => Module.Dual.eval K W (ν u.1)) ↔
      ν a ∈ Submodule.span K (Set.range fun u : U => ν u.1) := by
  let S := Submodule.span K (Set.range fun u : U => ν u.1)
  have hmap : S.map (Module.Dual.eval K W) =
      Submodule.span K (Set.range fun u : U => Module.Dual.eval K W (ν u.1)) := by
    rw [Submodule.map_span]
    congr 1
    ext y
    simp only [Set.mem_image, Set.mem_range]
    constructor
    · rintro ⟨_, ⟨u, rfl⟩, rfl⟩
      exact ⟨u, rfl⟩
    · rintro ⟨u, rfl⟩
      exact ⟨ν u.1, ⟨u, rfl⟩, rfl⟩
  rw [← hmap]
  constructor
  · intro ha
    obtain ⟨y, hy, hya⟩ := Submodule.mem_map.mp ha
    have : y = ν a := Module.eval_apply_injective K hya
    simpa [this] using hy
  · intro ha
    exact Submodule.mem_map.mpr ⟨ν a, ha, rfl⟩

omit [Fintype K] [DecidableEq K] [Fintype W] [DecidableEq W]
  [FiniteDimensional K W] in
private theorem ker_featureEvaluation_eq_dualAnnihilator (ν : X → W) (U : Finset X) :
    LinearMap.ker (evaluationMap (featureEvaluation ν) U) =
      (Submodule.span K (Set.range fun u : U => ν u.1)).dualAnnihilator := by
  ext f
  simp only [LinearMap.mem_ker, Submodule.mem_dualAnnihilator]
  constructor
  · intro h y hy
    refine Submodule.span_induction (p := fun z _ => f z = 0) ?_ ?_ ?_ ?_ hy
    · rintro z ⟨u, rfl⟩
      exact congrFun h u
    · exact f.map_zero
    · intro x y _ _ hx hy
      simp [hx, hy]
    · intro c x _ hx
      simp [hx]
  · intro h
    ext u
    exact h _ (Submodule.subset_span ⟨u, rfl⟩)

omit [DecidableEq W] in
/-- Feature-closure form of the exact dichotomy.  For a Veronese feature map this says that a
homogeneous form can vanish on `U` and avoid every point of `A` exactly when `U` does not span the
whole feature space and no point of `A` lies in its feature span. -/
theorem feature_evaluation_avoidance_iff (ν : X → W) (U A : Finset X)
    (hcard : A.card ≤ Fintype.card K) :
    (∃ f : Module.Dual K W,
        (∀ u ∈ U, f (ν u) = 0) ∧ f ≠ 0 ∧ ∀ a ∈ A, f (ν a) ≠ 0) ↔
      Submodule.span K (Set.range fun u : U => ν u.1) ≠ ⊤ ∧
        ∀ a ∈ A, ν a ∉ Submodule.span K (Set.range fun u : U => ν u.1) := by
  classical
  letI : Finite (Module.Dual K W) :=
    Finite.of_injective (fun f : Module.Dual K W => (f : W → K)) LinearMap.coe_injective
  letI : Fintype (Module.Dual K W) := Fintype.ofFinite _
  letI : DecidableEq (Module.Dual K W) := Classical.decEq _
  let ev : X → Module.Dual K W →ₗ[K] K := featureEvaluation (K := K) ν
  rw [show (∃ f : Module.Dual K W,
      (∀ u ∈ U, f (ν u) = 0) ∧ f ≠ 0 ∧ ∀ a ∈ A, f (ν a) ≠ 0) ↔
      (∃ f : Module.Dual K W, f ∈ LinearMap.ker (evaluationMap ev U) ∧ f ≠ 0 ∧
        ∀ a ∈ A, ev a f ≠ 0) by
      constructor
      · rintro ⟨f, hU, hf, hA⟩
        refine ⟨f, ?_, hf, ?_⟩
        · rw [LinearMap.mem_ker]
          ext u
          exact hU u.1 u.2
        · simpa [ev, featureEvaluation] using hA
      · rintro ⟨f, hU, hf, hA⟩
        refine ⟨f, ?_, hf, ?_⟩
        · intro u hu
          exact congrFun (LinearMap.mem_ker.mp hU) (⟨u, hu⟩ : U)
        · simpa [ev, featureEvaluation] using hA]
  rw [evaluation_avoidance_iff ev U A hcard]
  let T := Submodule.span K (Set.range fun u : U => ν u.1)
  have hker : LinearMap.ker (evaluationMap ev U) = T.dualAnnihilator := by
    exact ker_featureEvaluation_eq_dualAnnihilator ν U
  rw [hker]
  refine and_congr (not_congr Submodule.dualAnnihilator_eq_bot_iff) ?_
  refine forall_congr' fun a => forall_congr' fun _ => not_congr ?_
  calc
    T.dualAnnihilator ≤ LinearMap.ker (ev a) ↔
        LinearMap.ker (evaluationMap ev U) ≤ LinearMap.ker (ev a) := by rw [hker]
    _ ↔ ev a ∈ Submodule.span K (Set.range fun u : U => ev u.1) :=
      evaluation_ker_le_ker_iff_mem_span ev U a
    _ ↔ ν a ∈ T := by
      exact eval_mem_span_iff ν U a

end FeatureEvaluation

end RelativeConicArcs
