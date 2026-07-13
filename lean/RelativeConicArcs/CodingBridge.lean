import RelativeConicArcs.SyndromeGeometry
import RelativeConicArcs.ProjectiveBridge
import Mathlib.LinearAlgebra.Finsupp.LinearCombination

/-!
# Rank-three parity-check and MDS semantics

This file keeps coding terminology transparent: a code is the kernel of the finite linear
combination of its parity-check columns, and Hamming weight is the cardinality of coefficient
support.  No external coding-theory API is part of the trust boundary.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs.CodingBridge

open Finset Projectivization

section ParityCheck

variable {K W ι : Type*} [Field K] [DecidableEq K]
  [AddCommGroup W] [Module K W] [FiniteDimensional K W]
  [Fintype ι] [DecidableEq ι]

/-- The parity-check map with indexed columns `v`. -/
def parityCheckMap (v : ι → W) : (ι → K) →ₗ[K] W :=
  Fintype.linearCombination K v

/-- The linear code checked by the columns `v`. -/
def parityCheckCode (v : ι → W) : Submodule K (ι → K) :=
  LinearMap.ker (parityCheckMap v)

/-- The nonzero coordinate support of a word. -/
def hammingSupport (c : ι → K) : Finset ι :=
  Finset.univ.filter fun i => c i ≠ 0

/-- Hamming weight. -/
def hammingWeight (c : ι → K) : ℕ :=
  (hammingSupport c).card

/-- An affine syndrome has distance at least `d` from the code when every coefficient word
mapping to it has Hamming weight at least `d`. -/
def SyndromeDistanceAtLeast (v : ι → W) (s : W) (d : ℕ) : Prop :=
  ∀ c : ι → K, parityCheckMap (K := K) v c = s → d ≤ hammingWeight c

/-- An affine syndrome has exact distance `d` when no lighter coefficient word maps to it and
some word of weight exactly `d` does. -/
def SyndromeDistanceExactly (v : ι → W) (s : W) (d : ℕ) : Prop :=
  SyndromeDistanceAtLeast (K := K) v s d ∧
    ∃ c : ι → K, parityCheckMap (K := K) v c = s ∧ hammingWeight c = d

/-- A transparent exact-covering-radius-three predicate for a parity-check system: every affine
syndrome has a representative of weight at most three, and some syndrome has no representative
of smaller weight. -/
def HasCoveringRadiusThree (v : ι → W) : Prop :=
  (∀ s : W, ∃ c : ι → K,
    parityCheckMap (K := K) v c = s ∧ hammingWeight c ≤ 3) ∧
  ∃ s : W, SyndromeDistanceAtLeast (K := K) v s 3

section FiniteSyndromes

variable [Fintype K] [DecidableEq W]

/-- All coefficient words of specified weight mapping to an affine syndrome.  They are
minimum-weight leaders only when the syndrome is separately known to have that distance. -/
def syndromeLeadersOfWeight (v : ι → W) (s : W) (d : ℕ) : Finset (ι → K) :=
  Finset.univ.filter fun c =>
    hammingWeight c = d ∧ parityCheckMap (K := K) v c = s

/-- The supports occurring among the actual affine syndrome leaders of weight `d`. -/
def syndromeLeaderSupportsOfWeight (v : ι → W) (s : W) (d : ℕ) : Finset (Finset ι) :=
  (syndromeLeadersOfWeight (K := K) v s d).image hammingSupport

omit [FiniteDimensional K W] in
@[simp] theorem mem_syndromeLeadersOfWeight {v : ι → W} {s : W} {d : ℕ} {c : ι → K} :
    c ∈ syndromeLeadersOfWeight (K := K) v s d ↔
      hammingWeight c = d ∧ parityCheckMap (K := K) v c = s := by
  simp [syndromeLeadersOfWeight]

omit [FiniteDimensional K W] in
@[simp] theorem mem_syndromeLeaderSupportsOfWeight {v : ι → W} {s : W} {d : ℕ}
    {S : Finset ι} :
    S ∈ syndromeLeaderSupportsOfWeight (K := K) v s d ↔
      ∃ c : ι → K, hammingWeight c = d ∧
        parityCheckMap (K := K) v c = s ∧ hammingSupport c = S := by
  simp [syndromeLeaderSupportsOfWeight, and_assoc]

end FiniteSyndromes

omit [DecidableEq ι] in
@[simp] theorem mem_hammingSupport {c : ι → K} {i : ι} :
    i ∈ hammingSupport c ↔ c i ≠ 0 := by
  simp [hammingSupport]

omit [FiniteDimensional K W] [DecidableEq ι] in
theorem hammingSupport_smul_of_ne_zero (a : K) (ha : a ≠ 0) (c : ι → K) :
    hammingSupport (a • c) = hammingSupport c := by
  ext i
  simp [mem_hammingSupport, ha]

omit [FiniteDimensional K W] [DecidableEq ι] in
theorem hammingWeight_smul_of_ne_zero (a : K) (ha : a ≠ 0) (c : ι → K) :
    hammingWeight (a • c) = hammingWeight c := by
  simp [hammingWeight, hammingSupport_smul_of_ne_zero a ha c]

omit [DecidableEq K] [FiniteDimensional K W] [DecidableEq ι] in
theorem parityCheckMap_smul (v : ι → W) (a : K) (c : ι → K) :
    parityCheckMap (K := K) v (a • c) = a • parityCheckMap (K := K) v c := by
  exact (parityCheckMap (K := K) v).map_smul a c

section FiniteSyndromeScaling

variable [Fintype K] [DecidableEq W]

omit [FiniteDimensional K W] in
/-- Multiplying a syndrome by a nonzero field scalar bijects its weight-`d` coefficient words.
These words are minimum-weight leaders whenever the common syndrome distance is `d`. -/
theorem card_syndromeLeadersOfWeight_smul_of_ne_zero (v : ι → W)
    (s : W) (d : ℕ) (a : K) (ha : a ≠ 0) :
    (syndromeLeadersOfWeight (K := K) v (a • s) d).card =
      (syndromeLeadersOfWeight (K := K) v s d).card := by
  let forward : {c // c ∈ syndromeLeadersOfWeight (K := K) v s d} →
      {c // c ∈ syndromeLeadersOfWeight (K := K) v (a • s) d} := fun c =>
    ⟨a • c.1, by
      rw [mem_syndromeLeadersOfWeight]
      have hc := mem_syndromeLeadersOfWeight.mp c.2
      exact ⟨(hammingWeight_smul_of_ne_zero a ha c.1).trans hc.1,
        by rw [parityCheckMap_smul, hc.2]⟩⟩
  let backward : {c // c ∈ syndromeLeadersOfWeight (K := K) v (a • s) d} →
      {c // c ∈ syndromeLeadersOfWeight (K := K) v s d} := fun c =>
    ⟨a⁻¹ • c.1, by
      rw [mem_syndromeLeadersOfWeight]
      have hc := mem_syndromeLeadersOfWeight.mp c.2
      refine ⟨(hammingWeight_smul_of_ne_zero a⁻¹ (inv_ne_zero ha) c.1).trans hc.1, ?_⟩
      rw [parityCheckMap_smul, hc.2]
      simp [ha]⟩
  let e : {c // c ∈ syndromeLeadersOfWeight (K := K) v s d} ≃
      {c // c ∈ syndromeLeadersOfWeight (K := K) v (a • s) d} :=
    { toFun := forward
      invFun := backward
      left_inv := by
        intro c
        apply Subtype.ext
        simp [forward, backward, ha]
      right_inv := by
        intro c
        apply Subtype.ext
        simp [forward, backward, ha] }
  simpa only [Fintype.card_coe] using (Fintype.card_congr e).symm

end FiniteSyndromeScaling

omit [FiniteDimensional K W] [DecidableEq ι] in
theorem syndromeDistanceAtLeast_smul_of_ne_zero (v : ι → W)
    {s : W} {d : ℕ} (a : K) (ha : a ≠ 0)
    (h : SyndromeDistanceAtLeast (K := K) v s d) :
    SyndromeDistanceAtLeast (K := K) v (a • s) d := by
  intro c hc
  let c' : ι → K := a⁻¹ • c
  have hc' : parityCheckMap (K := K) v c' = s := by
    rw [parityCheckMap_smul, hc]
    simp [ha]
  have hweight : hammingWeight c' = hammingWeight c :=
    hammingWeight_smul_of_ne_zero a⁻¹ (inv_ne_zero ha) c
  rw [← hweight]
  exact h c' hc'

omit [FiniteDimensional K W] [DecidableEq ι] in
theorem syndromeDistanceExactly_smul_of_ne_zero (v : ι → W)
    {s : W} {d : ℕ} (a : K) (ha : a ≠ 0)
    (h : SyndromeDistanceExactly (K := K) v s d) :
    SyndromeDistanceExactly (K := K) v (a • s) d := by
  refine ⟨syndromeDistanceAtLeast_smul_of_ne_zero v a ha h.1, ?_⟩
  obtain ⟨c, hc, hweight⟩ := h.2
  refine ⟨a • c, ?_, ?_⟩
  · rw [parityCheckMap_smul, hc]
  · exact (hammingWeight_smul_of_ne_zero a ha c).trans hweight

omit [FiniteDimensional K W] [DecidableEq ι] in
theorem SyndromeDistanceExactly.unique {v : ι → W} {s : W} {d e : ℕ}
    (hd : SyndromeDistanceExactly (K := K) v s d)
    (he : SyndromeDistanceExactly (K := K) v s e) : d = e := by
  obtain ⟨cd, hcd, hwd⟩ := hd.2
  obtain ⟨ce, hce, hwe⟩ := he.2
  apply Nat.le_antisymm
  · simpa [hwe] using hd.1 ce hce
  · simpa [hwd] using he.1 cd hcd

omit [FiniteDimensional K W] [DecidableEq ι] in
/-- A nonzero syndrome has distance at least one. -/
theorem syndromeDistanceAtLeast_one_of_ne_zero (v : ι → W) {s : W} (hs : s ≠ 0) :
    SyndromeDistanceAtLeast (K := K) v s 1 := by
  intro c hc
  by_contra hweight
  have hzeroSupport : hammingSupport c = ∅ := by
    apply Finset.card_eq_zero.mp
    simpa [hammingWeight] using Nat.eq_zero_of_not_pos hweight
  have hc0 : c = 0 := by
    funext i
    by_contra hi
    have : i ∈ hammingSupport c := mem_hammingSupport.mpr hi
    simp [hzeroSupport] at this
  exact hs (by simpa [hc0] using hc.symm)

omit [FiniteDimensional K W] [DecidableEq ι] in
/-- Avoidance of every one-column affine span forces syndrome distance at least two. -/
theorem syndromeDistanceAtLeast_two_of_one_avoidance (v : ι → W)
    (hcard : 1 ≤ Fintype.card ι) {s : W}
    (havoid : ∀ i : ι, ∀ a : K, a • v i ≠ s) :
    SyndromeDistanceAtLeast (K := K) v s 2 := by
  classical
  intro c hc
  by_contra hweight
  have hsupportCard : (hammingSupport c).card ≤ 1 := by
    change ¬2 ≤ hammingWeight c at hweight
    simpa [hammingWeight] using (Nat.le_of_lt_succ (Nat.lt_of_not_ge hweight))
  obtain ⟨T, hsub, _hTuniv, hTcard⟩ := Finset.exists_subsuperset_card_eq
    (Finset.subset_univ (hammingSupport c)) hsupportCard hcard
  obtain ⟨i, rfl⟩ := Finset.card_eq_one.mp hTcard
  have hsum : ∑ k, c k • v k = s := by
    simpa [parityCheckMap, Fintype.linearCombination_apply] using hc
  have hsumOne : ∑ k ∈ ({i} : Finset ι), c k • v k = s := by
    rw [← hsum]
    apply Finset.sum_subset (Finset.subset_univ _)
    intro k _ hk
    have hkSupport : k ∉ hammingSupport c := fun hk' => hk (hsub hk')
    have hck : c k = 0 := not_ne_iff.mp (by simpa using hkSupport)
    simp [hck]
  exact havoid i (c i) (by simpa using hsumOne)

omit [DecidableEq K] [FiniteDimensional K W] [DecidableEq ι] in
theorem mem_parityCheckCode_iff (v : ι → W) (c : ι → K) :
    c ∈ parityCheckCode (K := K) v ↔ ∑ i, c i • v i = 0 := by
  simp [parityCheckCode, parityCheckMap, LinearMap.mem_ker,
    Fintype.linearCombination_apply]

omit [DecidableEq K] [FiniteDimensional K W] [DecidableEq ι] in
/-- On an index set of size at least three, independence of every three-subset implies
independence of every subset of size at most three. -/
theorem small_independent_of_triple_independent (v : ι → W)
    (hcard : 3 ≤ Fintype.card ι)
    (htriple : ∀ T : Finset ι, T.card = 3 →
      LinearIndependent K (fun i : T => v i.1)) :
    ∀ S : Finset ι, S.card ≤ 3 → LinearIndependent K (fun i : S => v i.1) := by
  classical
  intro S hS
  obtain ⟨T, hST, _hTuniv, hTcard⟩ := Finset.exists_subsuperset_card_eq
    (Finset.subset_univ S) hS hcard
  have hT := htriple T hTcard
  let e : S → T := fun i => ⟨i.1, hST i.2⟩
  have he : Function.Injective e := by
    intro x y h
    apply Subtype.ext
    exact congrArg (fun z : T => z.1) h
  change LinearIndependent K ((fun i : T => v i.1) ∘ e)
  exact hT.comp e he

omit [DecidableEq K] [FiniteDimensional K W] [DecidableEq ι] in
/-- A surjective rank-three parity-check system has code dimension `n-3`. -/
theorem finrank_parityCheckCode (v : ι → W)
    (hrank : Module.finrank K W = 3)
    (hspan : Submodule.span K (Set.range v) = ⊤) :
    Module.finrank K (parityCheckCode (K := K) v) = Fintype.card ι - 3 := by
  have hrange : LinearMap.range (parityCheckMap (K := K) v) = ⊤ := by
    simpa [parityCheckMap] using hspan
  have hnull := (parityCheckMap (K := K) v).finrank_range_add_finrank_ker
  rw [hrange, finrank_top, hrank, Module.finrank_pi] at hnull
  change Module.finrank K (LinearMap.ker (parityCheckMap (K := K) v)) = _
  omega

omit [FiniteDimensional K W] in
/-- If every set of at most three columns is independent, every nonzero codeword has Hamming
weight at least four. -/
theorem hammingWeight_ge_four_of_small_independent (v : ι → W)
    (hsmall : ∀ S : Finset ι, S.card ≤ 3 →
      LinearIndependent K (fun i : S => v i.1))
    {c : ι → K} (hc : c ∈ parityCheckCode (K := K) v) (hc0 : c ≠ 0) :
    4 ≤ hammingWeight c := by
  by_contra hweight
  let S := hammingSupport c
  have hScard : S.card ≤ 3 := by
    change ¬4 ≤ S.card at hweight
    omega
  have hsum : ∑ i ∈ S, c i • v i = 0 := by
    have hall : ∑ i, c i • v i = 0 := (mem_parityCheckCode_iff (K := K) v c).mp hc
    rw [← hall]
    apply Finset.sum_subset (Finset.subset_univ S)
    intro i _ hi
    have hci : c i = 0 := not_ne_iff.mp (by simpa [S] using hi)
    simp [hci]
  have hcoeff : ∀ i : S, c i.1 = 0 := by
    apply (Fintype.linearIndependent_iff.mp (hsmall S hScard)) (fun i : S => c i.1)
    calc
      (∑ i : S, c i.1 • v i.1) = ∑ i ∈ S, c i • v i :=
        Finset.sum_coe_sort S (fun i => c i • v i)
      _ = 0 := hsum
  apply hc0
  funext i
  by_cases hi : i ∈ S
  · exact hcoeff ⟨i, hi⟩
  · exact not_ne_iff.mp (by simpa [S] using hi)

/-- In a three-dimensional ambient space, four available columns also force a weight-four
codeword. Combined with three-column independence, the minimum distance is exactly four. -/
theorem exists_codeword_hammingWeight_eq_four (v : ι → W)
    (hrank : Module.finrank K W = 3) (hcard : 4 ≤ Fintype.card ι)
    (hsmall : ∀ S : Finset ι, S.card ≤ 3 →
      LinearIndependent K (fun i : S => v i.1)) :
    ∃ c : ι → K, c ∈ parityCheckCode (K := K) v ∧ c ≠ 0 ∧ hammingWeight c = 4 := by
  classical
  obtain ⟨S, _hSuniv, hScard⟩ := Finset.exists_subset_card_eq
    (s := (Finset.univ : Finset ι)) hcard
  let f : (S → K) →ₗ[K] W := Fintype.linearCombination K (fun i : S => v i.1)
  have hdim : Module.finrank K W < Module.finrank K (S → K) := by
    rw [hrank, Module.finrank_pi, Fintype.card_coe, hScard]
    omega
  have hker : LinearMap.ker f ≠ ⊥ := LinearMap.ker_ne_bot_of_finrank_lt hdim
  obtain ⟨g, hg, hg0⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hker
  let c : ι → K := fun i => if hi : i ∈ S then g ⟨i, hi⟩ else 0
  have hc0 : c ≠ 0 := by
    intro hc
    apply hg0
    funext i
    have hi := congrFun hc i.1
    simpa [c, i.2] using hi
  have hsumS : ∑ i ∈ S, c i • v i = 0 := by
    calc
      (∑ i ∈ S, c i • v i) = ∑ i : S, c i.1 • v i.1 :=
        (Finset.sum_coe_sort S (fun i => c i • v i)).symm
      _ = ∑ i : S, g i • v i.1 := by
        apply Finset.sum_congr rfl
        intro i _
        simp [c, i.2]
      _ = f g := by simp [f, Fintype.linearCombination_apply]
      _ = 0 := LinearMap.mem_ker.mp hg
  have hc : c ∈ parityCheckCode (K := K) v := by
    rw [mem_parityCheckCode_iff]
    have hsubset : ∑ i ∈ S, c i • v i = ∑ i, c i • v i := by
      apply Finset.sum_subset (Finset.subset_univ S)
      intro i _ hi
      simp [c, hi]
    rw [← hsubset]
    exact hsumS
  have hsupport : hammingSupport c ⊆ S := by
    intro i hi
    by_contra hiS
    exact (mem_hammingSupport.mp hi) (by simp [c, hiS])
  have hle : hammingWeight c ≤ 4 := by
    rw [hammingWeight, ← hScard]
    exact Finset.card_le_card hsupport
  have hge := hammingWeight_ge_four_of_small_independent v hsmall hc hc0
  exact ⟨c, hc, hc0, by omega⟩

omit [FiniteDimensional K W] in
/-- Avoidance of every two-column affine span forces syndrome distance at least three.  Repeated
indices in the hypothesis include the one-column case. -/
theorem syndromeDistanceAtLeast_three_of_pair_avoidance (v : ι → W)
    (hcard : 2 ≤ Fintype.card ι) {s : W}
    (havoid : ∀ i j : ι, ∀ a b : K, a • v i + b • v j ≠ s) :
    SyndromeDistanceAtLeast (K := K) v s 3 := by
  classical
  intro c hc
  by_contra hweight
  have hsupportCard : (hammingSupport c).card ≤ 2 := by
    change ¬3 ≤ hammingWeight c at hweight
    simpa [hammingWeight] using (Nat.le_of_lt_succ (Nat.lt_of_not_ge hweight))
  obtain ⟨T, hsub, _hTuniv, hTcard⟩ := Finset.exists_subsuperset_card_eq
    (Finset.subset_univ (hammingSupport c)) hsupportCard hcard
  obtain ⟨i, j, hij, rfl⟩ := Finset.card_eq_two.mp hTcard
  have hsum : ∑ k, c k • v k = s := by
    simpa [parityCheckMap, Fintype.linearCombination_apply] using hc
  have hsumPair : ∑ k ∈ ({i, j} : Finset ι), c k • v k = s := by
    rw [← hsum]
    apply Finset.sum_subset (Finset.subset_univ _)
    intro k _ hk
    have hkSupport : k ∉ hammingSupport c := fun hk' => hk (hsub hk')
    have hck : c k = 0 := not_ne_iff.mp (by simpa using hkSupport)
    simp [hck]
  have hpresent : c i • v i + c j • v j = s := by
    simpa [hij, hij.symm] using hsumPair
  exact havoid i j (c i) (c j) hpresent

/-- Three independent columns spanning a rank-three syndrome space represent every affine
syndrome with weight at most three. -/
theorem every_syndrome_has_weight_le_three (v : ι → W)
    (hrank : Module.finrank K W = 3) (hcard : 3 ≤ Fintype.card ι)
    (hsmall : ∀ S : Finset ι, S.card ≤ 3 →
      LinearIndependent K (fun i : S => v i.1)) :
    ∀ s : W, ∃ c : ι → K,
      parityCheckMap (K := K) v c = s ∧ hammingWeight c ≤ 3 := by
  classical
  obtain ⟨S, _hSuniv, hS⟩ := Finset.exists_subset_card_eq
    (s := (Finset.univ : Finset ι)) hcard
  have hLI := hsmall S (by omega)
  have hspan : Submodule.span K (Set.range fun i : S => v i.1) = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    rw [finrank_span_eq_card hLI, Fintype.card_coe, hS, hrank]
  have hrange : LinearMap.range (Fintype.linearCombination K (fun i : S => v i.1)) = ⊤ := by
    rw [Fintype.range_linearCombination, hspan]
  intro s
  obtain ⟨g, hg⟩ := (LinearMap.range_eq_top.mp hrange) s
  let c : ι → K := fun i => if hi : i ∈ S then g ⟨i, hi⟩ else 0
  have hc : parityCheckMap (K := K) v c = s := by
    change (∑ i, c i • v i) = s
    calc
      (∑ i, c i • v i) = ∑ i ∈ S, c i • v i := by
        symm
        apply Finset.sum_subset (Finset.subset_univ S)
        intro i _ hi
        simp [c, hi]
      _ = ∑ i : S, c i.1 • v i.1 :=
        (Finset.sum_coe_sort S (fun i => c i • v i)).symm
      _ = ∑ i : S, g i • v i.1 := by
        apply Finset.sum_congr rfl
        intro i _
        simp [c, i.2]
      _ = (Fintype.linearCombination K (fun i : S => v i.1)) g := by
        simp [Fintype.linearCombination_apply]
      _ = s := hg
  refine ⟨c, hc, ?_⟩
  rw [hammingWeight, ← hS]
  apply Finset.card_le_card
  intro i hi
  by_contra hiS
  exact (mem_hammingSupport.mp hi) (by simp [c, hiS])

omit [FiniteDimensional K W] in
/-- On an independent support of size at most three, an affine syndrome has at most one
coefficient word with that exact support. -/
theorem syndrome_leader_unique_of_support (v : ι → W)
    (hsmall : ∀ S : Finset ι, S.card ≤ 3 →
      LinearIndependent K (fun i : S => v i.1))
    {s : W} {S : Finset ι} (hS : S.card ≤ 3) {c d : ι → K}
    (hcS : hammingSupport c = S) (hdS : hammingSupport d = S)
    (hc : parityCheckMap (K := K) v c = s)
    (hd : parityCheckMap (K := K) v d = s) : c = d := by
  have hzero : parityCheckMap (K := K) v (c - d) = 0 := by
    rw [map_sub, hc, hd, sub_self]
  have hsum : ∑ i, (c i - d i) • v i = 0 := by
    simpa [parityCheckMap, Fintype.linearCombination_apply] using hzero
  have hsumS : ∑ i : S, (c i.1 - d i.1) • v i.1 = 0 := by
    calc
      (∑ i : S, (c i.1 - d i.1) • v i.1) =
          ∑ i ∈ S, (c i - d i) • v i :=
        Finset.sum_coe_sort S (fun i => (c i - d i) • v i)
      _ = ∑ i, (c i - d i) • v i := by
        apply Finset.sum_subset (Finset.subset_univ S)
        intro i _ hi
        have hci : c i = 0 := by
          by_contra hne
          have hmem := mem_hammingSupport.mpr hne
          rw [hcS] at hmem
          exact hi hmem
        have hdi : d i = 0 := by
          by_contra hne
          have hmem := mem_hammingSupport.mpr hne
          rw [hdS] at hmem
          exact hi hmem
        simp [hci, hdi]
      _ = 0 := hsum
  have hcoeff : ∀ i : S, c i.1 - d i.1 = 0 :=
    (Fintype.linearIndependent_iff.mp (hsmall S hS)) _ hsumS
  funext i
  by_cases hi : i ∈ S
  · exact sub_eq_zero.mp (hcoeff ⟨i, hi⟩)
  · have hci : c i = 0 := by
      by_contra hne
      have hmem := mem_hammingSupport.mpr hne
      rw [hcS] at hmem
      exact hi hmem
    have hdi : d i = 0 := by
      by_contra hne
      have hmem := mem_hammingSupport.mpr hne
      rw [hdS] at hmem
      exact hi hmem
    rw [hci, hdi]

section FiniteSyndromes

variable [Fintype K] [DecidableEq W]

omit [FiniteDimensional K W] in
/-- For weights at most three in an MDS parity-check system, taking support is a bijection from
actual affine leaders onto the supports that occur.  In particular, counting leader supports is
literally the same as counting coefficient words, not merely an incidence analogy. -/
theorem card_syndromeLeadersOfWeight_eq_supports (v : ι → W)
    (hsmall : ∀ S : Finset ι, S.card ≤ 3 →
      LinearIndependent K (fun i : S => v i.1))
    (s : W) {d : ℕ} (hd : d ≤ 3) :
    (syndromeLeadersOfWeight (K := K) v s d).card =
      (syndromeLeaderSupportsOfWeight (K := K) v s d).card := by
  classical
  let leaders := syndromeLeadersOfWeight (K := K) v s d
  have hinj : Set.InjOn (fun c : ι → K => hammingSupport c)
      (↑leaders : Set (ι → K)) := by
    intro c hc e he hsupport
    have hc' := mem_syndromeLeadersOfWeight.mp hc
    have he' := mem_syndromeLeadersOfWeight.mp he
    have hcard : (hammingSupport c).card ≤ 3 := by
      rw [← hammingWeight, hc'.1]
      exact hd
    exact syndrome_leader_unique_of_support v hsmall hcard rfl hsupport.symm hc'.2 he'.2
  exact (Finset.card_image_of_injOn hinj).symm

end FiniteSyndromes

/-- Every three-column support carries a unique weight-three leader of an affine syndrome whose
distance is at least three.  Existence uses that the three independent columns span the
three-dimensional syndrome space; the distance hypothesis forces all three coefficients nonzero. -/
theorem exists_unique_weightThree_leader_on_support (v : ι → W)
    (hrank : Module.finrank K W = 3)
    (hsmall : ∀ S : Finset ι, S.card ≤ 3 →
      LinearIndependent K (fun i : S => v i.1))
    {s : W} (hdist : SyndromeDistanceAtLeast (K := K) v s 3)
    {S : Finset ι} (hS : S.card = 3) :
    ∃! c : ι → K, hammingSupport c = S ∧ parityCheckMap (K := K) v c = s := by
  classical
  have hLI := hsmall S (by omega)
  have hspan : Submodule.span K (Set.range fun i : S => v i.1) = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    rw [finrank_span_eq_card hLI, Fintype.card_coe, hS, hrank]
  have hrange : LinearMap.range (Fintype.linearCombination K (fun i : S => v i.1)) = ⊤ := by
    rw [Fintype.range_linearCombination, hspan]
  obtain ⟨g, hg⟩ := (LinearMap.range_eq_top.mp hrange) s
  let c : ι → K := fun i => if hi : i ∈ S then g ⟨i, hi⟩ else 0
  have hc : parityCheckMap (K := K) v c = s := by
    change (∑ i, c i • v i) = s
    calc
      (∑ i, c i • v i) = ∑ i ∈ S, c i • v i := by
        symm
        apply Finset.sum_subset (Finset.subset_univ S)
        intro i _ hi
        simp [c, hi]
      _ = ∑ i : S, c i.1 • v i.1 :=
        (Finset.sum_coe_sort S (fun i => c i • v i)).symm
      _ = ∑ i : S, g i • v i.1 := by
        apply Finset.sum_congr rfl
        intro i _
        simp [c, i.2]
      _ = (Fintype.linearCombination K (fun i : S => v i.1)) g := by
        simp [Fintype.linearCombination_apply]
      _ = s := hg
  have hsupport : hammingSupport c ⊆ S := by
    intro i hi
    by_contra hiS
    exact (mem_hammingSupport.mp hi) (by simp [c, hiS])
  have hcardLower : 3 ≤ (hammingSupport c).card := hdist c hc
  have hsupportEq : hammingSupport c = S := by
    apply Finset.eq_of_subset_of_card_le hsupport
    omega
  refine ⟨c, ⟨hsupportEq, hc⟩, ?_⟩
  intro d hd
  exact syndrome_leader_unique_of_support v hsmall (by omega)
    hd.1 hsupportEq hd.2 hc

section FiniteSyndromes

variable [Fintype K] [DecidableEq W]

/-- Exact affine leader count in codimension three: a distance-three syndrome of an MDS
parity-check system has one weight-three leader on every three-column support. -/
theorem card_syndromeLeadersOfWeight_three (v : ι → W)
    (hrank : Module.finrank K W = 3)
    (hsmall : ∀ S : Finset ι, S.card ≤ 3 →
      LinearIndependent K (fun i : S => v i.1))
    {s : W} (hdist : SyndromeDistanceAtLeast (K := K) v s 3) :
    (syndromeLeadersOfWeight (K := K) v s 3).card = Nat.choose (Fintype.card ι) 3 := by
  classical
  let leaders := syndromeLeadersOfWeight (K := K) v s 3
  have himage : leaders.image (fun c : ι → K => hammingSupport c) =
      Finset.univ.powersetCard 3 := by
    ext S
    constructor
    · intro h
      obtain ⟨c, hc, rfl⟩ := Finset.mem_image.mp h
      have hc' := mem_syndromeLeadersOfWeight.mp hc
      exact Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _, by simpa [hammingWeight] using hc'.1⟩
    · intro h
      have hS : S.card = 3 := (Finset.mem_powersetCard.mp h).2
      obtain ⟨c, hc, _⟩ := exists_unique_weightThree_leader_on_support v hrank hsmall hdist hS
      apply Finset.mem_image.mpr
      refine ⟨c, ?_, hc.1⟩
      exact mem_syndromeLeadersOfWeight.mpr ⟨by simp [hammingWeight, hc.1, hS], hc.2⟩
  have hinj : Set.InjOn (fun c : ι → K => hammingSupport c)
      (↑leaders : Set (ι → K)) := by
    intro c hc d hd heq
    have hc' := mem_syndromeLeadersOfWeight.mp hc
    have hd' := mem_syndromeLeadersOfWeight.mp hd
    have hcard : (hammingSupport c).card ≤ 3 := by
      have hcweight : (hammingSupport c).card = 3 := by
        simpa only [hammingWeight] using hc'.1
      exact hcweight.le
    exact syndrome_leader_unique_of_support v hsmall
      hcard rfl heq.symm hc'.2 hd'.2
  calc
    leaders.card = (leaders.image (fun c : ι → K => hammingSupport c)).card :=
      (Finset.card_image_of_injOn hinj).symm
    _ = (Finset.univ.powersetCard 3).card := congrArg Finset.card himage
    _ = Nat.choose (Fintype.card ι) 3 := by simp

end FiniteSyndromes

/-- Transparent `[n,n-3,≥4]` parity-check package. -/
structure CodimThreeMDSColumns (v : ι → W) : Prop where
  ambient_finrank : Module.finrank K W = 3
  spans : Submodule.span K (Set.range v) = ⊤
  small_independent : ∀ S : Finset ι, S.card ≤ 3 →
    LinearIndependent K (fun i : S => v i.1)

omit [DecidableEq K] [FiniteDimensional K W] [DecidableEq ι] in
theorem CodimThreeMDSColumns.code_finrank {v : ι → W}
    (h : CodimThreeMDSColumns (K := K) v) :
    Module.finrank K (parityCheckCode (K := K) v) = Fintype.card ι - 3 :=
  finrank_parityCheckCode (K := K) v h.ambient_finrank h.spans

omit [FiniteDimensional K W] in
theorem CodimThreeMDSColumns.minimumDistance_ge_four {v : ι → W}
    (h : CodimThreeMDSColumns (K := K) v) {c : ι → K}
    (hc : c ∈ parityCheckCode (K := K) v) (hc0 : c ≠ 0) :
    4 ≤ hammingWeight c :=
  hammingWeight_ge_four_of_small_independent (K := K) v h.small_independent hc hc0

theorem CodimThreeMDSColumns.exists_minimumWeight_word {v : ι → W}
    (h : CodimThreeMDSColumns (K := K) v) (hcard : 4 ≤ Fintype.card ι) :
    ∃ c : ι → K, c ∈ parityCheckCode (K := K) v ∧ c ≠ 0 ∧ hammingWeight c = 4 :=
  exists_codeword_hammingWeight_eq_four v h.ambient_finrank hcard h.small_independent

end ParityCheck

section ProjectivePlane

variable {K ι : Type*} [Field K] [DecidableEq K] [Fintype ι] [DecidableEq ι]

abbrev PlanePoint (K : Type*) [Field K] := ProjectiveBridge.Point K

noncomputable local instance : DecidableEq (PlanePoint K) := Classical.decEq _

omit [DecidableEq ι] in
/-- Indexed projective columns form an arc exactly when every distinct triple of representative
vectors is linearly independent. -/
theorem arc_image_iff_triples_linearIndependent (p : ι → PlanePoint K)
    (hp : Function.Injective p) :
    Arc (L := PlanePoint K) (Finset.univ.image p) ↔
      ∀ ⦃i j k : ι⦄, i ≠ j → i ≠ k → j ≠ k →
        LinearIndependent K ![(p i).rep, (p j).rep, (p k).rep] := by
  rw [ProjectiveBridge.arc_iff_projectiveCap]
  constructor
  · intro hcap i j k hij hik hjk
    apply ProjectiveCap.Projective.independent_triple_iff.mp
    apply (ProjectiveCap.Projective.not_collinear_iff_independent).mp
    exact hcap (Finset.mem_image.mpr ⟨i, Finset.mem_univ _, rfl⟩)
      (Finset.mem_image.mpr ⟨j, Finset.mem_univ _, rfl⟩)
      (Finset.mem_image.mpr ⟨k, Finset.mem_univ _, rfl⟩)
      (fun h => hij (hp h)) (fun h => hik (hp h)) (fun h => hjk (hp h))
  · intro hli a b c ha hb hc hab hac hbc
    obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp ha
    obtain ⟨j, _, rfl⟩ := Finset.mem_image.mp hb
    obtain ⟨k, _, rfl⟩ := Finset.mem_image.mp hc
    have hij : i ≠ j := fun h => hab (congrArg p h)
    have hik : i ≠ k := fun h => hac (congrArg p h)
    have hjk : j ≠ k := fun h => hbc (congrArg p h)
    exact (ProjectiveCap.Projective.not_collinear_iff_independent).mpr
      (ProjectiveCap.Projective.independent_triple_iff.mpr (hli hij hik hjk))

end ProjectivePlane

end RelativeConicArcs.CodingBridge
