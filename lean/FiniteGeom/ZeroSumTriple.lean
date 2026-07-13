import FiniteGeom.Hypergraph
import Mathlib.Algebra.CharP.Defs

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

section Field

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F] [CharP F 3]

omit [Fintype F] [DecidableEq F] in
private theorem one_ne_neg_one : (1 : F) ≠ -1 := by
  intro h
  have hthree : (3 : F) = 0 := CharP.cast_eq_zero F 3
  have htwo : (2 : F) = 0 := by linear_combination h
  have hone : (1 : F) = 0 := by linear_combination hthree - htwo
  exact one_ne_zero hone

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

end Field

end FiniteGeom
