import RelativeConicArcs.AlignedTwoGraph
import Mathlib.Data.Finset.Powerset

/-!
# The query family of an aligned anchor

The decoder behind aligned-design faithfulness fixes one aligned four-set `Q`
and then tests only those four-sets that meet `Q` in at least two points.  This
module defines that family as a finite set of four-element subsets and computes
its cardinality.

Writing `n` for the number of points, the family splits by how many points a
four-set shares with the anchor.  Sharing all four leaves the anchor itself;
sharing three chooses three anchor points and one outside point; sharing two
chooses two of each.  The counts are `1`, `4(n-4)` and `6` times `n-4` choose
`2`, and their sum is `3n^2 - 23n + 45`.

The count is a cardinality of an explicitly described family, so the tests it
counts are distinct by construction.  Nothing here asserts that these tests
suffice to reconstruct a two-graph, or bounds the cost of finding the anchor;
the reconstruction theorem is `exists_complementBit_of_alignedFamily_eq`, whose
seven-point restrictions each locate their own anchor.
-/

namespace RelativeConicArcs
namespace AlignedTwoGraph

variable {α : Type*} [DecidableEq α] [Fintype α]

/-- The four-point subsets meeting a fixed four-point anchor in at least two
points. -/
def selectedQueryFamily (Q : Finset α) : Finset (Finset α) :=
  (Finset.univ.powersetCard 4).filter fun S => 2 ≤ (S ∩ Q).card

/-- The four-point subsets meeting the anchor in exactly `k` points. -/
private def queryFibre (Q : Finset α) (k : ℕ) : Finset (Finset α) :=
  (Finset.univ.powersetCard 4).filter fun S => (S ∩ Q).card = k

private theorem mem_queryFibre {Q : Finset α} {k : ℕ} {S : Finset α} :
    S ∈ queryFibre Q k ↔ S.card = 4 ∧ (S ∩ Q).card = k := by
  simp only [queryFibre, Finset.mem_filter, Finset.mem_powersetCard]
  exact ⟨fun h => ⟨h.1.2, h.2⟩, fun h => ⟨⟨Finset.subset_univ _, h.1⟩, h.2⟩⟩

private theorem mem_selectedQueryFamily {Q : Finset α} {S : Finset α} :
    S ∈ selectedQueryFamily Q ↔ S.card = 4 ∧ 2 ≤ (S ∩ Q).card := by
  simp only [selectedQueryFamily, Finset.mem_filter, Finset.mem_powersetCard]
  exact ⟨fun h => ⟨h.1.2, h.2⟩, fun h => ⟨⟨Finset.subset_univ _, h.1⟩, h.2⟩⟩

/-- Splitting a four-set into its anchor part and its outside part is a
bijection onto the pairs consisting of a `k`-subset of the anchor and a
`(4-k)`-subset of the complement.  The number of four-sets meeting the anchor
in exactly `k` points is therefore the corresponding product of binomial
coefficients. -/
private theorem card_queryFibre (Q : Finset α) {k : ℕ} (hk : k ≤ 4) :
    (queryFibre Q k).card = Q.card.choose k * Qᶜ.card.choose (4 - k) := by
  classical
  have hbij :
      (queryFibre Q k).card =
        ((Q.powersetCard k) ×ˢ (Qᶜ.powersetCard (4 - k))).card := by
    refine Finset.card_nbij' (fun S => (S ∩ Q, S \ Q)) (fun p => p.1 ∪ p.2) ?_ ?_ ?_ ?_
    · intro S hS
      simp only [Finset.mem_coe, mem_queryFibre] at hS
      simp only [Finset.mem_coe, Finset.mem_product, Finset.mem_powersetCard]
      refine ⟨⟨Finset.inter_subset_right, hS.2⟩, ?_, ?_⟩
      · intro a ha
        simp only [Finset.mem_sdiff] at ha
        simpa using ha.2
      · have hsplit : (S ∩ Q).card + (S \ Q).card = S.card :=
          Finset.card_inter_add_card_sdiff S Q
        omega
    · intro p hp
      simp only [Finset.mem_coe, Finset.mem_product, Finset.mem_powersetCard] at hp
      obtain ⟨⟨hA, hAcard⟩, hB, hBcard⟩ := hp
      have hQB : ∀ a ∈ p.2, a ∉ Q := by
        intro a ha
        simpa using hB ha
      have hdisj : Disjoint p.1 p.2 :=
        Finset.disjoint_left.mpr fun a ha hb => hQB a hb (hA ha)
      have hinter : (p.1 ∪ p.2) ∩ Q = p.1 := by
        ext a
        simp only [Finset.mem_inter, Finset.mem_union]
        exact ⟨fun h => h.1.resolve_right fun hb => absurd h.2 (hQB a hb),
          fun ha => ⟨Or.inl ha, hA ha⟩⟩
      simp only [Finset.mem_coe, mem_queryFibre, hinter, hAcard, and_true]
      rw [Finset.card_union_of_disjoint hdisj, hAcard, hBcard]
      omega
    · intro S hS
      ext a
      simp only [Finset.mem_union, Finset.mem_inter, Finset.mem_sdiff]
      constructor
      · rintro (⟨ha, -⟩ | ⟨ha, -⟩) <;> exact ha
      · intro ha
        by_cases hQ : a ∈ Q
        · exact Or.inl ⟨ha, hQ⟩
        · exact Or.inr ⟨ha, hQ⟩
    · intro p hp
      simp only [Finset.mem_coe, Finset.mem_product, Finset.mem_powersetCard] at hp
      obtain ⟨⟨hA, -⟩, hB, -⟩ := hp
      have hQB : ∀ a ∈ p.2, a ∉ Q := by
        intro a ha
        simpa using hB ha
      refine Prod.ext ?_ ?_
      · ext a
        simp only [Finset.mem_inter, Finset.mem_union]
        exact ⟨fun h => h.1.resolve_right fun hb => absurd h.2 (hQB a hb),
          fun ha => ⟨Or.inl ha, hA ha⟩⟩
      · ext a
        simp only [Finset.mem_sdiff, Finset.mem_union]
        exact ⟨fun h => h.1.resolve_left fun ha => absurd (hA ha) h.2,
          fun ha => ⟨Or.inr ha, hQB a ha⟩⟩
  rw [hbij, Finset.card_product, Finset.card_powersetCard, Finset.card_powersetCard]

/-- The query family is the union of the fibres over two, three and four shared
points. -/
private theorem selectedQueryFamily_eq_union (Q : Finset α) (hQ : Q.card = 4) :
    selectedQueryFamily Q = queryFibre Q 2 ∪ queryFibre Q 3 ∪ queryFibre Q 4 := by
  ext S
  simp only [Finset.mem_union, mem_selectedQueryFamily, mem_queryFibre]
  constructor
  · rintro ⟨hS, hge⟩
    have hle : (S ∩ Q).card ≤ 4 := hQ ▸ Finset.card_le_card Finset.inter_subset_right
    have hcases : (S ∩ Q).card = 2 ∨ (S ∩ Q).card = 3 ∨ (S ∩ Q).card = 4 := by omega
    rcases hcases with h | h | h
    · exact Or.inl (Or.inl ⟨hS, h⟩)
    · exact Or.inl (Or.inr ⟨hS, h⟩)
    · exact Or.inr ⟨hS, h⟩
  · rintro ((⟨hS, h⟩ | ⟨hS, h⟩) | ⟨hS, h⟩) <;> exact ⟨hS, by omega⟩

/-- Twice a binomial coefficient of the second kind is the falling product. -/
private theorem choose_two_mul_two (t : ℕ) :
    ((t.choose 2 : ℤ)) * 2 = (t : ℤ) * ((t : ℤ) - 1) := by
  induction t with
  | zero => norm_num
  | succ s ih =>
    have hstep : (s + 1).choose 2 = s + s.choose 2 := by
      rw [Nat.choose_succ_succ, Nat.choose_one_right]
    rw [hstep]
    push_cast
    rw [add_mul, ih]
    ring

/-- The number of selected tests, as the manuscript's polynomial in the number
of points.  The three summands are the tests meeting the anchor in two, three
and four points. -/
theorem card_selectedQueryFamily {Q : Finset α} (hQ : Q.card = 4)
    (hn : 4 ≤ Fintype.card α) :
    ((selectedQueryFamily Q).card : ℤ) =
      3 * (Fintype.card α : ℤ) ^ 2 - 23 * (Fintype.card α : ℤ) + 45 := by
  classical
  have hdisj₂₃ : Disjoint (queryFibre Q 2) (queryFibre Q 3) := by
    refine Finset.disjoint_left.mpr fun S h2 h3 => ?_
    rw [mem_queryFibre] at h2 h3
    omega
  have hdisj₄ : Disjoint (queryFibre Q 2 ∪ queryFibre Q 3) (queryFibre Q 4) := by
    refine Finset.disjoint_left.mpr fun S h23 h4 => ?_
    rw [Finset.mem_union, mem_queryFibre, mem_queryFibre] at h23
    rw [mem_queryFibre] at h4
    omega
  have hcard : (selectedQueryFamily Q).card =
      (queryFibre Q 2).card + (queryFibre Q 3).card + (queryFibre Q 4).card := by
    rw [selectedQueryFamily_eq_union Q hQ, Finset.card_union_of_disjoint hdisj₄,
      Finset.card_union_of_disjoint hdisj₂₃]
  set m : ℕ := Qᶜ.card with hm
  have hmn : m + 4 = Fintype.card α := by
    have := Finset.card_compl Q
    rw [hm, this, hQ]
    omega
  have h2 : (queryFibre Q 2).card = 6 * m.choose 2 := by
    have hc : Nat.choose 4 2 = 6 := by decide
    rw [card_queryFibre Q (by norm_num : (2 : ℕ) ≤ 4), hQ, ← hm, hc]
  have h3 : (queryFibre Q 3).card = 4 * m := by
    have hc : Nat.choose 4 3 = 4 := by decide
    rw [card_queryFibre Q (by norm_num : (3 : ℕ) ≤ 4), hQ, ← hm, hc,
      Nat.choose_one_right]
  have h4 : (queryFibre Q 4).card = 1 := by
    have hc : Nat.choose 4 4 = 1 := by decide
    rw [card_queryFibre Q (by norm_num : (4 : ℕ) ≤ 4), hQ, ← hm, hc,
      Nat.choose_zero_right]
  have hnZ : (Fintype.card α : ℤ) = (m : ℤ) + 4 := by
    exact_mod_cast congrArg (fun x : ℕ => (x : ℤ)) hmn.symm
  have hsix : (6 * (m.choose 2 : ℤ)) = 3 * ((m : ℤ) * ((m : ℤ) - 1)) := by
    rw [← choose_two_mul_two m]
    ring
  rw [hcard, h2, h3, h4, hnZ]
  push_cast
  rw [hsix]
  ring

end AlignedTwoGraph
end RelativeConicArcs
