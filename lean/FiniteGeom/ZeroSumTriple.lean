import FiniteGeom.Hypergraph
import Mathlib.Algebra.CharP.Defs
import Mathlib.FieldTheory.Finite.Basic

/-!
# Zero-sum triple hypergraphs in characteristic three

Three-element zero-sum subsets of an elementary abelian three-group are the affine lines.  This
module supplies the functorial description and the exact parallel-class matching number used by
the twisted-cubic--axis repair code.  No cap-set estimate is assumed here.
-/

namespace FiniteGeom

open Finset

/-- Three-element zero-sum subsets of a finite additive group. -/
def zeroSumTripleHypergraph (A : Type*) [AddCommGroup A] [Fintype A] [DecidableEq A] :
    Finset (Finset A) :=
  (Finset.univ.powersetCard 3).filter fun s => ∑ x ∈ s, x = 0

@[simp] theorem mem_zeroSumTripleHypergraph {A : Type*} [AddCommGroup A] [Fintype A]
    [DecidableEq A] {s : Finset A} :
    s ∈ zeroSumTripleHypergraph A ↔ s.card = 3 ∧ ∑ x ∈ s, x = 0 := by
  simp [zeroSumTripleHypergraph]

/-- Zero-sum triple hypergraphs are functorial under additive equivalences. -/
theorem relabel_zeroSumTripleHypergraph {A B : Type*} [AddCommGroup A] [AddCommGroup B]
    [Fintype A] [Fintype B] [DecidableEq A] [DecidableEq B] (e : A ≃+ B) :
    relabelHypergraph e.toEquiv (zeroSumTripleHypergraph A) = zeroSumTripleHypergraph B := by
  ext t
  constructor
  · intro ht
    obtain ⟨s, hs, rfl⟩ := Finset.mem_image.mp ht
    rw [mem_zeroSumTripleHypergraph] at hs ⊢
    refine ⟨by simpa using hs.1, ?_⟩
    have hsum : ∑ x ∈ s.map e.toEquiv.toEmbedding, x = e (∑ x ∈ s, x) := by
      rw [Finset.sum_map]
      simp
    rw [hsum, hs.2, map_zero]
  · intro ht
    rw [mem_zeroSumTripleHypergraph] at ht
    let s := t.map e.symm.toEquiv.toEmbedding
    have hsmap : s.map e.toEquiv.toEmbedding = t := by
      simp [s, Finset.map_map]
    apply Finset.mem_image.mpr
    refine ⟨s, ?_, hsmap⟩
    rw [mem_zeroSumTripleHypergraph]
    refine ⟨?_, ?_⟩
    · simpa [s] using ht.1
    · have hsum : ∑ x ∈ s, x = e.symm (∑ x ∈ t, x) := by
        change (∑ x ∈ t.map e.symm.toEquiv.toEmbedding, x) = e.symm (∑ x ∈ t, x)
        rw [Finset.sum_map]
        simp
      rw [hsum, ht.2, map_zero]

/-- Maximum cardinality of a subset containing no zero-sum triple.  For elementary abelian
three-groups this is the standard affine cap number `Z₃`. -/
noncomputable def zeroSumCapNumber (A : Type*) [AddCommGroup A] [Fintype A] [DecidableEq A] : ℕ :=
  independenceNumber (zeroSumTripleHypergraph A)

/-- The definition is semantically pinned: a maximum zero-sum-triple-free set exists. -/
theorem exists_zeroSumCap_card_eq {A : Type*} [AddCommGroup A] [Fintype A] [DecidableEq A] :
    ∃ S, IsIndependent (zeroSumTripleHypergraph A) S ∧ S.card = zeroSumCapNumber A := by
  apply exists_independent_card_eq_independenceNumber
  intro E hE
  exact Finset.card_pos.mp (by rw [(mem_zeroSumTripleHypergraph.mp hE).1]; decide)

/-- Every zero-sum-triple-free set is bounded by the cap number. -/
theorem card_le_zeroSumCapNumber {A : Type*} [AddCommGroup A] [Fintype A] [DecidableEq A]
    {S : Finset A} (hS : IsIndependent (zeroSumTripleHypergraph A) S) :
    S.card ≤ zeroSumCapNumber A := by
  apply card_le_independenceNumber
  · intro E hE
    exact Finset.card_pos.mp (by rw [(mem_zeroSumTripleHypergraph.mp hE).1]; decide)
  · exact hS

/-- Exact cover/cap complement identity. -/
theorem transversalNumber_zeroSumTripleHypergraph {A : Type*} [AddCommGroup A] [Fintype A]
    [DecidableEq A] :
    transversalNumber (zeroSumTripleHypergraph A) = Fintype.card A - zeroSumCapNumber A := by
  have hne : ∀ E ∈ zeroSumTripleHypergraph A, E.Nonempty := by
    intro E hE
    exact Finset.card_pos.mp (by rw [(mem_zeroSumTripleHypergraph.mp hE).1]; decide)
  have htau : transversalNumber (zeroSumTripleHypergraph A) ≤ Fintype.card A :=
    transversalNumber_le_card (show IsTransversal (zeroSumTripleHypergraph A) univ by
      intro E hE
      rw [Finset.univ_inter]
      exact hne E hE)
  unfold zeroSumCapNumber independenceNumber
  omega

/-- The affine-line hypergraph with the lines through zero deleted. -/
def zeroSumTripleHypergraphAvoidingZero (A : Type*) [AddCommGroup A] [Fintype A]
    [DecidableEq A] : Finset (Finset A) :=
  (zeroSumTripleHypergraph A).filter fun E => 0 ∉ E

@[simp] theorem mem_zeroSumTripleHypergraphAvoidingZero {A : Type*} [AddCommGroup A]
    [Fintype A] [DecidableEq A] {E : Finset A} :
    E ∈ zeroSumTripleHypergraphAvoidingZero A ↔
      E.card = 3 ∧ ∑ x ∈ E, x = 0 ∧ 0 ∉ E := by
  simp [zeroSumTripleHypergraphAvoidingZero, and_assoc]

section Field

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F] [CharP F 3]

omit [Fintype F] [DecidableEq F] in
private theorem one_ne_neg_one : (1 : F) ≠ -1 := by
  intro h
  have hthree : (3 : F) = 0 := CharP.cast_eq_zero F 3
  have htwo : (2 : F) = 0 := by linear_combination h
  have hone : (1 : F) = 0 := by linear_combination hthree - htwo
  exact one_ne_zero hone

/-- A characteristic-three affine cap omits at least one field element. -/
theorem zeroSumCapNumber_lt_card : zeroSumCapNumber F < Fintype.card F := by
  classical
  obtain ⟨S, hS, hScard⟩ := exists_zeroSumCap_card_eq (A := F)
  rw [← hScard]
  have hedge : ({0, 1, -1} : Finset F) ∈ zeroSumTripleHypergraph F := by
    apply mem_zeroSumTripleHypergraph.mpr
    exact ⟨by simp [one_ne_neg_one (F := F)], by simp [one_ne_neg_one (F := F)]⟩
  have hne : S ≠ univ := by
    intro hEq
    exact hS hedge (by simp [hEq])
  simpa using Finset.card_lt_card (Finset.ssubset_univ_iff.mpr hne)

/-- Translation preserves affine lines in characteristic three. -/
theorem relabel_zeroSumTripleHypergraph_addRight (c : F) :
    relabelHypergraph (Equiv.addRight c) (zeroSumTripleHypergraph F) =
      zeroSumTripleHypergraph F := by
  classical
  have hmem (d : F) (S : Finset F) (hS : S ∈ zeroSumTripleHypergraph F) :
      S.map (Equiv.addRight d).toEmbedding ∈ zeroSumTripleHypergraph F := by
    rw [mem_zeroSumTripleHypergraph] at hS ⊢
    refine ⟨by simpa using hS.1, ?_⟩
    rw [Finset.sum_map]
    change ∑ x ∈ S, (x + d) = 0
    rw [Finset.sum_add_distrib, hS.2]
    have h3 : (3 : F) = 0 := CharP.cast_eq_zero F 3
    rw [Finset.sum_const, hS.1]
    rw [nsmul_eq_mul]
    norm_num only [Nat.cast_ofNat]
    rw [h3, zero_mul, add_zero]
  ext T
  constructor
  · intro hT
    obtain ⟨S, hS, rfl⟩ := Finset.mem_image.mp hT
    exact hmem c S hS
  · intro hT
    let S := T.map (Equiv.addRight (-c)).toEmbedding
    have hS : S ∈ zeroSumTripleHypergraph F := hmem (-c) T hT
    apply Finset.mem_image.mpr
    refine ⟨S, hS, ?_⟩
    ext x
    simp [S, Finset.map_map]

/-- The affine lines in one fixed direction form a matching covering the whole field. -/
theorem zeroSumTriple_parallelClass_exists :
    ∃ M, IsMatching (zeroSumTripleHypergraph F) M ∧
      M.card = Fintype.card F / 3 ∧ M.biUnion id = univ := by
  classical
  let line : F → Finset F := fun a => {a, a + 1, a - 1}
  let M : Finset (Finset F) := univ.image line
  have hlineCard (a : F) : (line a).card = 3 := by
    have ha1 : a ≠ a + 1 := by
      intro h
      have h' : a + 1 = a + 0 := by simpa only [add_zero] using h.symm
      have hone : (1 : F) = 0 := add_left_cancel h'
      exact one_ne_zero hone
    have ham1 : a ≠ a - 1 := by
      intro h
      have hone : (1 : F) = 0 := by linear_combination h
      exact one_ne_zero hone
    have hpm : a + 1 ≠ a - 1 := by
      intro h
      apply one_ne_neg_one (F := F)
      linear_combination h
    rw [show line a = {a, a + 1, a - 1} by rfl,
      Finset.card_insert_of_notMem (by simp [ha1, ham1]), Finset.card_pair hpm]
  have hlineSum (a : F) : ∑ x ∈ line a, x = 0 := by
    have hthree : (3 : F) = 0 := CharP.cast_eq_zero F 3
    have ha1 : a ≠ a + 1 := by
      intro h
      have h' : a + 1 = a + 0 := by simpa only [add_zero] using h.symm
      have hone : (1 : F) = 0 := add_left_cancel h'
      exact one_ne_zero hone
    have ham1 : a ≠ a - 1 := by
      intro h
      have hone : (1 : F) = 0 := by linear_combination h
      exact one_ne_zero hone
    have hpm : a + 1 ≠ a - 1 := by
      intro h
      apply one_ne_neg_one (F := F)
      linear_combination h
    rw [show line a = {a, a + 1, a - 1} by rfl,
      Finset.sum_insert (by simp [ha1, ham1]), Finset.sum_pair hpm]
    linear_combination a * hthree
  have hline_add_one (a : F) : line (a + 1) = line a := by
    have hthree : (3 : F) = 0 := CharP.cast_eq_zero F 3
    ext z
    simp only [line, Finset.mem_insert, Finset.mem_singleton]
    constructor
    · rintro (rfl | rfl | rfl)
      · exact Or.inr (Or.inl rfl)
      · exact Or.inr (Or.inr (by linear_combination hthree))
      · exact Or.inl (by ring)
    · rintro (rfl | rfl | rfl)
      · exact Or.inr (Or.inr (by ring))
      · exact Or.inl rfl
      · exact Or.inr (Or.inl (by linear_combination -hthree))
  have hline_sub_one (a : F) : line (a - 1) = line a := by
    have h := hline_add_one (a - 1)
    simpa only [sub_add_cancel] using h.symm
  have hline_eq_of_mem {a v : F} (hv : v ∈ line a) : line a = line v := by
    simp only [line, Finset.mem_insert, Finset.mem_singleton] at hv
    rcases hv with rfl | rfl | rfl
    · rfl
    · exact (hline_add_one a).symm
    · exact (hline_sub_one a).symm
  have heq_of_inter {a b : F} (h : (line a ∩ line b).Nonempty) : line a = line b := by
    obtain ⟨v, hv⟩ := h
    have hv' := Finset.mem_inter.mp hv
    exact (hline_eq_of_mem hv'.1).trans (hline_eq_of_mem hv'.2).symm
  have hM : IsMatching (zeroSumTripleHypergraph F) M := by
    refine ⟨?_, ?_⟩
    · intro E hEM
      obtain ⟨a, -, rfl⟩ := Finset.mem_image.mp hEM
      exact mem_zeroSumTripleHypergraph.mpr ⟨hlineCard a, hlineSum a⟩
    · intro A hAM B hBM hAB
      obtain ⟨a, -, rfl⟩ := Finset.mem_image.mp hAM
      obtain ⟨b, -, rfl⟩ := Finset.mem_image.mp hBM
      rw [Finset.disjoint_iff_inter_eq_empty]
      by_contra hne
      exact hAB (heq_of_inter (Finset.nonempty_iff_ne_empty.mpr hne))
  have hunion : M.biUnion id = univ := by
    apply Finset.eq_univ_of_forall
    intro a
    apply Finset.mem_biUnion.mpr
    exact ⟨line a, Finset.mem_image.mpr ⟨a, Finset.mem_univ a, rfl⟩, by simp [line]⟩
  have hpairwise : (M : Set (Finset F)).PairwiseDisjoint id := by
    intro A hA B hB hAB
    change Disjoint A B
    exact hM.2 hA hB hAB
  have hcardUnion : (M.biUnion id).card = 3 * M.card := by
    rw [Finset.card_biUnion hpairwise]
    calc
      (∑ E ∈ M, E.card) = ∑ _E ∈ M, 3 := by
        apply Finset.sum_congr rfl
        intro E hEM
        exact (mem_zeroSumTripleHypergraph.mp (hM.1 hEM)).1
      _ = 3 * M.card := by simp [Nat.mul_comm]
  have hq : Fintype.card F = 3 * M.card := by
    rw [← Finset.card_univ, ← hunion]
    exact hcardUnion
  refine ⟨M, hM, ?_, hunion⟩
  omega

/-- Exact matching number of the affine-line hypergraph in every finite characteristic-three
field. -/
theorem matchingNumber_zeroSumTripleHypergraph :
    matchingNumber (zeroSumTripleHypergraph F) = Fintype.card F / 3 := by
  apply le_antisymm
  · apply matchingNumber_le_of_forall
    intro M hM
    have hpairwise : (M : Set (Finset F)).PairwiseDisjoint id := by
      intro A hA B hB hAB
      change Disjoint A B
      exact hM.2 hA hB hAB
    have hcard : (M.biUnion id).card = 3 * M.card := by
      rw [Finset.card_biUnion hpairwise]
      calc
        (∑ E ∈ M, E.card) = ∑ _E ∈ M, 3 := by
          apply Finset.sum_congr rfl
          intro E hEM
          exact (mem_zeroSumTripleHypergraph.mp (hM.1 hEM)).1
        _ = 3 * M.card := by simp [Nat.mul_comm]
    have hle : (M.biUnion id).card ≤ Fintype.card F := by
      simpa using Finset.card_le_card (Finset.subset_univ (M.biUnion id))
    rw [hcard] at hle
    omega
  · obtain ⟨M, hM, hMcard, -⟩ := zeroSumTriple_parallelClass_exists (F := F)
    rw [← hMcard]
    exact card_le_matchingNumber hM

/-- Deleting the lines through zero removes exactly one member of a parallel class, so the
remaining affine-line hypergraph has matching number `q/3-1`. -/
theorem matchingNumber_zeroSumTripleHypergraphAvoidingZero :
    matchingNumber (zeroSumTripleHypergraphAvoidingZero F) = Fintype.card F / 3 - 1 := by
  classical
  apply le_antisymm
  · apply matchingNumber_le_of_forall
    intro M hM
    have hpairwise : (M : Set (Finset F)).PairwiseDisjoint id := by
      intro A hA B hB hAB
      change Disjoint A B
      exact hM.2 hA hB hAB
    have hcard : (M.biUnion id).card = 3 * M.card := by
      rw [Finset.card_biUnion hpairwise]
      calc
        (∑ E ∈ M, E.card) = ∑ _E ∈ M, 3 := by
          apply Finset.sum_congr rfl
          intro E hEM
          exact (mem_zeroSumTripleHypergraphAvoidingZero.mp (hM.1 hEM)).1
        _ = 3 * M.card := by simp [Nat.mul_comm]
    have hsub : M.biUnion id ⊆ univ.erase 0 := by
      intro x hx
      obtain ⟨E, hEM, hxE⟩ := Finset.mem_biUnion.mp hx
      have h0 := (mem_zeroSumTripleHypergraphAvoidingZero.mp (hM.1 hEM)).2.2
      simp only [Finset.mem_erase, Finset.mem_univ, and_true]
      intro hx0
      subst x
      exact h0 hxE
    have hle := Finset.card_le_card hsub
    rw [hcard] at hle
    simp at hle
    obtain ⟨n, -, hq⟩ := FiniteField.card F 3
    obtain ⟨m, hm⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.ne_of_gt n.2)
    have hqmul : Fintype.card F = 3 * 3 ^ m := by
      calc
        Fintype.card F = 3 ^ (n : ℕ) := hq
        _ = 3 ^ (m + 1) := congrArg (fun k : ℕ => 3 ^ k) hm
        _ = 3 * 3 ^ m := by rw [pow_succ]; omega
    omega
  · obtain ⟨M, hM, hMcard, hunion⟩ := zeroSumTriple_parallelClass_exists (F := F)
    let M₀ := M.filter fun E => 0 ∉ E
    obtain ⟨E₀, hE₀M, h0E₀⟩ : ∃ E ∈ M, 0 ∈ E := by
      have : 0 ∈ M.biUnion id := by rw [hunion]; simp
      exact Finset.mem_biUnion.mp this
    have hthrough : M.filter (fun E => 0 ∈ E) = {E₀} := by
      ext E
      simp only [Finset.mem_filter, Finset.mem_singleton]
      constructor
      · rintro ⟨hEM, h0E⟩
        by_contra hne
        exact (Finset.disjoint_left.mp (hM.2 hEM hE₀M hne) h0E) h0E₀
      · rintro rfl
        exact ⟨hE₀M, h0E₀⟩
    have hM₀card : M₀.card = M.card - 1 := by
      have hsplit := Finset.card_filter_add_card_filter_not (s := M) (fun E => 0 ∈ E)
      change (M.filter fun E => 0 ∈ E).card + M₀.card = M.card at hsplit
      rw [hthrough] at hsplit
      simp at hsplit
      omega
    have hM₀ : IsMatching (zeroSumTripleHypergraphAvoidingZero F) M₀ := by
      refine ⟨?_, ?_⟩
      · intro E hE
        have hE' := Finset.mem_filter.mp hE
        exact mem_zeroSumTripleHypergraphAvoidingZero.mpr
          ⟨(mem_zeroSumTripleHypergraph.mp (hM.1 hE'.1)).1,
            (mem_zeroSumTripleHypergraph.mp (hM.1 hE'.1)).2, hE'.2⟩
      · intro A hA B hB hAB
        exact hM.2 (Finset.mem_filter.mp hA).1 (Finset.mem_filter.mp hB).1 hAB
    rw [← hMcard, ← hM₀card]
    exact card_le_matchingNumber hM₀

/-- Deleting the lines through zero leaves the full cap number available away from zero; zero
itself is then an isolated vertex.  Thus the independence number rises by exactly one. -/
theorem independenceNumber_zeroSumTripleHypergraphAvoidingZero :
    independenceNumber (zeroSumTripleHypergraphAvoidingZero F) = zeroSumCapNumber F + 1 := by
  classical
  have hneA : ∀ E ∈ zeroSumTripleHypergraphAvoidingZero F, E.Nonempty := by
    intro E hE
    exact Finset.card_pos.mp (by
      rw [(mem_zeroSumTripleHypergraphAvoidingZero.mp hE).1]
      decide)
  have hupper (T : Finset F) (hT : IsIndependent (zeroSumTripleHypergraphAvoidingZero F) T) :
      T.card ≤ zeroSumCapNumber F + 1 := by
    let T₀ := T.erase 0
    have hT₀ : IsIndependent (zeroSumTripleHypergraph F) T₀ := by
      intro E hE hET
      have h0E : 0 ∉ E := by
        intro hzE
        have hzT₀ : (0 : F) ∈ T₀ := hET hzE
        exact (Finset.mem_erase.mp hzT₀).1 rfl
      exact hT (mem_zeroSumTripleHypergraphAvoidingZero.mpr
        ⟨(mem_zeroSumTripleHypergraph.mp hE).1, (mem_zeroSumTripleHypergraph.mp hE).2,
          h0E⟩) (hET.trans (Finset.erase_subset _ _))
    have hcap := card_le_zeroSumCapNumber hT₀
    have herase : T.card ≤ T₀.card + 1 := by
      by_cases h0 : 0 ∈ T
      · rw [show T₀ = T.erase 0 by rfl, Finset.card_erase_of_mem h0]
        omega
      · simp [T₀, h0]
    omega
  apply le_antisymm
  · obtain ⟨T, hT, hTcard⟩ :=
      exists_independent_card_eq_independenceNumber
        (zeroSumTripleHypergraphAvoidingZero F) hneA
    rw [← hTcard]
    exact hupper T hT
  · obtain ⟨S, hS, hScard⟩ := exists_zeroSumCap_card_eq (A := F)
    have hSlt : S.card < Fintype.card F := by
      have hedge : ({0, 1, -1} : Finset F) ∈ zeroSumTripleHypergraph F := by
        apply mem_zeroSumTripleHypergraph.mpr
        constructor
        · simp [one_ne_neg_one (F := F)]
        · simp [one_ne_neg_one (F := F)]
      by_contra hnot
      have hEq : S = univ := by
        apply Finset.eq_univ_of_card S
        have hle : S.card ≤ Fintype.card F := by
          simpa using Finset.card_le_card (Finset.subset_univ S)
        omega
      exact hS hedge (by simp [hEq])
    obtain ⟨d, hdS⟩ : ∃ d : F, d ∉ S := by
      by_contra hnot
      have hmem : ∀ d : F, d ∈ S := by
        intro d
        by_contra hd
        exact hnot ⟨d, hd⟩
      have hEq : S = univ := Finset.eq_univ_of_forall hmem
      rw [hEq, Finset.card_univ] at hSlt
      omega
    let c : F := -d
    let e : F ≃ F := Equiv.addRight c
    let S' : Finset F := S.map e.toEmbedding
    have hS' : IsIndependent (zeroSumTripleHypergraph F) S' := by
      have h := hS.relabelHypergraph e
      rw [show relabelHypergraph e (zeroSumTripleHypergraph F) =
          zeroSumTripleHypergraph F by
        exact relabel_zeroSumTripleHypergraph_addRight c] at h
      exact h
    have h0S' : 0 ∉ S' := by
      intro h0
      obtain ⟨x, hxS, hx⟩ := Finset.mem_map.mp h0
      have hxd : x = d := by
        change x + c = 0 at hx
        have hx' := congrArg (fun y : F => y + d) hx
        simpa [c, add_assoc] using hx'
      exact hdS (hxd ▸ hxS)
    let T := insert 0 S'
    have hT : IsIndependent (zeroSumTripleHypergraphAvoidingZero F) T := by
      intro E hE hET
      have hdata := mem_zeroSumTripleHypergraphAvoidingZero.mp hE
      apply hS' (mem_zeroSumTripleHypergraph.mpr ⟨hdata.1, hdata.2.1⟩)
      intro x hxE
      have hxT := hET hxE
      simp only [T, Finset.mem_insert] at hxT
      rcases hxT with rfl | hxS'
      · exact (hdata.2.2 hxE).elim
      · exact hxS'
    have hTcard : T.card = zeroSumCapNumber F + 1 := by
      rw [show T = insert 0 S' by rfl, Finset.card_insert_of_notMem h0S',
        show S'.card = S.card by simp [S'], hScard]
    rw [← hTcard]
    exact card_le_independenceNumber hneA hT

/-- Exact cover number of the affine lines avoiding zero. -/
theorem transversalNumber_zeroSumTripleHypergraphAvoidingZero :
    transversalNumber (zeroSumTripleHypergraphAvoidingZero F) =
      Fintype.card F - 1 - zeroSumCapNumber F := by
  have hind := independenceNumber_zeroSumTripleHypergraphAvoidingZero (F := F)
  unfold independenceNumber at hind
  have htauq : transversalNumber (zeroSumTripleHypergraphAvoidingZero F) ≤
      Fintype.card F :=
    transversalNumber_le_card (show
      IsTransversal (zeroSumTripleHypergraphAvoidingZero F) univ by
        intro E hE
        rw [Finset.univ_inter]
        exact Finset.card_pos.mp (by
          rw [(mem_zeroSumTripleHypergraphAvoidingZero.mp hE).1]
          decide))
  obtain ⟨S, hS, hScard⟩ := exists_zeroSumCap_card_eq (A := F)
  have hSlt : zeroSumCapNumber F < Fintype.card F := by
    rw [← hScard]
    have hedge : ({0, 1, -1} : Finset F) ∈ zeroSumTripleHypergraph F := by
      apply mem_zeroSumTripleHypergraph.mpr
      exact ⟨by simp [one_ne_neg_one (F := F)], by simp [one_ne_neg_one (F := F)]⟩
    by_contra hnot
    have hEq : S = univ := by
      apply Finset.eq_univ_of_card S
      have hle : S.card ≤ Fintype.card F := by
        simpa using Finset.card_le_card (Finset.subset_univ S)
      omega
    exact hS hedge (by simp [hEq])
  omega

end Field

end FiniteGeom
