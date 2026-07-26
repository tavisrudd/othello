import Mathlib.Combinatorics.SimpleGraph.Clique
import Mathlib.Combinatorics.SimpleGraph.DegreeSum

/-!
# Matching-packing deficiency and the one-block completion gap

This file isolates a finite-graph argument for maximum-matching packings.  A leave with exactly
`choose m 2` edges whose positive degrees are divisible by `m - 1` is forced to be one clique on
`m` vertices.
-/

namespace RelativeConicArcs

open Finset

namespace MatchingPacking

private theorem two_mul_choose_two (n : ℕ) :
    2 * Nat.choose n 2 = n * (n - 1) := by
  have h := Nat.choose_succ_right_eq n 1
  simpa [Nat.mul_comm] using h

/-- A graph with `choose m 2` edges and positive degrees divisible by `m - 1` is the complete
graph on its support.  This is the leave lemma which says that a maximum-matching packing cannot
be exactly one block short. -/
theorem oneBlockShort_leave_isClique
    {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (m : ℕ) (hm : 2 ≤ m)
    (hedges : G.edgeFinset.card = Nat.choose m 2)
    (hdegree : ∀ v : V, 0 < G.degree v → m - 1 ∣ G.degree v) :
    G.support.toFinset.card = m ∧ G.IsClique G.support := by
  classical
  let W := G.support.toFinset
  have hpositive (v : V) (hv : v ∈ W) : m - 1 ≤ G.degree v := by
    have hvpos : 0 < G.degree v := by
      rw [G.degree_pos_iff_mem_support]
      simpa [W] using hv
    exact Nat.le_of_dvd (by omega) (hdegree v hvpos)
  have hsum :
      ∑ v ∈ W, G.degree v = m * (m - 1) := by
    rw [show W = G.support.toFinset by rfl,
      G.sum_degrees_support_eq_twice_card_edges, hedges, two_mul_choose_two]
  have hcard_le : W.card ≤ m := by
    have hlower : W.card * (m - 1) ≤ ∑ v ∈ W, G.degree v := by
      calc
        W.card * (m - 1) = ∑ _v ∈ W, (m - 1) := by
          simp [Nat.mul_comm]
        _ ≤ ∑ v ∈ W, G.degree v :=
          Finset.sum_le_sum fun v hv => hpositive v hv
    rw [hsum] at hlower
    exact Nat.le_of_mul_le_mul_right hlower (by omega)
  have hWnonempty : W.Nonempty := by
    by_contra h
    have hzero : W = ∅ := Finset.not_nonempty_iff_eq_empty.mp h
    have hprodpos : 0 < m * (m - 1) := Nat.mul_pos (by omega) (by omega)
    rw [hzero] at hsum
    simp at hsum
    omega
  have hWcardpos : 0 < W.card := Finset.card_pos.mpr hWnonempty
  obtain ⟨v, hvW⟩ := hWnonempty
  have hneighbor_subset :
      G.neighborFinset v ⊆ W.erase v := by
    intro w hw
    have hadj : G.Adj v w := by
      simpa only [SimpleGraph.mem_neighborFinset] using hw
    have hwW : w ∈ W := by
      dsimp [W]
      rw [Set.mem_toFinset]
      exact G.mem_support.mpr ⟨v, hadj.symm⟩
    exact Finset.mem_erase.mpr ⟨hadj.ne.symm, hwW⟩
  have hdegree_lt : G.degree v < W.card := by
    have hle := Finset.card_le_card hneighbor_subset
    rw [G.card_neighborFinset_eq_degree, Finset.card_erase_of_mem hvW] at hle
    omega
  have hcard_ge : m ≤ W.card := by
    have := hpositive v hvW
    omega
  have hcard : W.card = m := Nat.le_antisymm hcard_le hcard_ge
  refine ⟨hcard, ?_⟩
  intro x hx y hy hxy
  have hxW : x ∈ W := by simpa [W] using hx
  have hyW : y ∈ W := by simpa [W] using hy
  have hneighbor_subset_x :
      G.neighborFinset x ⊆ W.erase x := by
    intro z hz
    have hadj : G.Adj x z := by
      simpa only [SimpleGraph.mem_neighborFinset] using hz
    have hzW : z ∈ W := by
      dsimp [W]
      rw [Set.mem_toFinset]
      exact G.mem_support.mpr ⟨x, hadj.symm⟩
    exact Finset.mem_erase.mpr ⟨hadj.ne.symm, hzW⟩
  have hxpositive : m - 1 ≤ G.degree x := hpositive x hxW
  have hdegree_x_le :
      G.degree x ≤ (W.erase x).card := by
    simpa only [G.card_neighborFinset_eq_degree] using
      Finset.card_le_card hneighbor_subset_x
  have herase_card : (W.erase x).card = m - 1 := by
    rw [Finset.card_erase_of_mem hxW, hcard]
  have hneighbor_eq : G.neighborFinset x = W.erase x := by
    apply Finset.eq_of_subset_of_card_le hneighbor_subset_x
    rw [G.card_neighborFinset_eq_degree, herase_card]
    exact hxpositive
  have : y ∈ G.neighborFinset x := by
    rw [hneighbor_eq]
    exact Finset.mem_erase.mpr ⟨hxy.symm, hyW⟩
  simpa only [SimpleGraph.mem_neighborFinset] using this

end MatchingPacking

end RelativeConicArcs
