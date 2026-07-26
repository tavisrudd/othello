import RelativeConicArcs.CliquePackingCompletion
import RelativeConicArcs.MatchingPackingDefectBridge

/-!
# Completion obstruction for maximum concurrence matchings

For an arc `A`, the vertices of the disjointness graph are the two-subsets of `A`, and two
vertices are adjacent when the corresponding endpoint pairs are disjoint.  Secants through an
external point form a clique in this graph.  This module packages maximum concurrence matchings
as a clique packing and proves that such a packing cannot be exactly one block short of a full
edge decomposition unless a full decomposition exists.
-/

namespace RelativeConicArcs

open Finset

section FinitePlane

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P]
  [Configuration.ProjectivePlane P L]

/-- The graph on endpoint pairs of `A` in which adjacency means disjointness. -/
def arcPairDisjointnessGraph (A : Finset P) : SimpleGraph (ArcPair A) :=
  SimpleGraph.fromRel fun e f => Disjoint e.1 f.1

instance instDecidableArcPairDisjointnessAdj (A : Finset P) :
    DecidableRel (arcPairDisjointnessGraph A).Adj := by
  unfold arcPairDisjointnessGraph
  infer_instance

omit [Fintype P] [Fintype L] [DecidableEq P]
  [Configuration.ProjectivePlane P L] in
@[simp] theorem arcPairDisjointnessGraph_adj
    {A : Finset P} {e f : ArcPair A} :
    (arcPairDisjointnessGraph A).Adj e f ↔ Disjoint e.1 f.1 := by
  rw [arcPairDisjointnessGraph, SimpleGraph.fromRel_adj]
  constructor
  · rintro ⟨_hef, hdisj | hdisj⟩
    · exact hdisj
    · exact hdisj.symm
  · intro hdisj
    refine ⟨?_, Or.inl hdisj⟩
    intro hef
    subst f
    have hempty : e.1 = ∅ := disjoint_self.mp hdisj
    have hcard := e.card
    rw [hempty] at hcard
    simp at hcard

omit [Fintype P] in
/-- Every vertex of the endpoint-pair disjointness graph has
`choose (|A| - 2) 2` neighbors. -/
theorem degree_arcPairDisjointnessGraph
    (A : Finset P) (e : ArcPair A) :
    (arcPairDisjointnessGraph A).degree e = Nat.choose (A.card - 2) 2 := by
  classical
  rw [← SimpleGraph.card_neighborFinset_eq_degree]
  have hneighbors :
      (arcPairDisjointnessGraph A).neighborFinset e = disjointPartners A e := by
    ext f
    simp [SimpleGraph.mem_neighborFinset, mem_disjointPartners]
  rw [hneighbors, card_disjointPartners]

omit [Fintype P] in
/-- The endpoint-pair disjointness graph has `3 * choose |A| 4` edges. -/
theorem card_edgeFinset_arcPairDisjointnessGraph (A : Finset P) :
    (arcPairDisjointnessGraph A).edgeFinset.card =
      3 * Nat.choose A.card 4 := by
  classical
  have hsum := (arcPairDisjointnessGraph A).sum_degrees_eq_twice_card_edges
  have hvertices : Fintype.card (ArcPair A) = Nat.choose A.card 2 :=
    card_arcPair A
  have hproduct := choose_two_mul_choose_sub_two A.card
  simp_rw [degree_arcPairDisjointnessGraph A] at hsum
  simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul] at hsum
  change Fintype.card (ArcPair A) * Nat.choose (A.card - 2) 2 =
    2 * (arcPairDisjointnessGraph A).edgeFinset.card at hsum
  rw [hvertices, hproduct] at hsum
  omega

private theorem half_sub_one_dvd_choose_sub_two
    (n : ℕ) (hhalf : 2 ≤ n / 2) :
    n / 2 - 1 ∣ Nat.choose (n - 2) 2 := by
  let q := n / 2
  have hq : 2 ≤ q := hhalf
  have hmodlt : n % 2 < 2 := Nat.mod_lt n (by omega)
  have hn : n = 2 * q + n % 2 := by
    omega
  have hchoose := two_mul_choose_two (n - 2)
  have hmod : n % 2 = 0 ∨ n % 2 = 1 := by omega
  rcases hmod with hmod | hmod
  · refine ⟨2 * q - 3, ?_⟩
    have hn' : n = 2 * q := by omega
    have hsubtwo : n - 2 = 2 * (q - 1) := by omega
    have hfactor : 2 * (q - 1) - 1 = 2 * q - 3 := by omega
    have hdouble :
        2 * Nat.choose (n - 2) 2 =
          2 * ((q - 1) * (2 * q - 3)) := by
      calc
        2 * Nat.choose (n - 2) 2 =
            (n - 2) * (n - 2 - 1) := hchoose
        _ = 2 * ((q - 1) * (2 * q - 3)) := by
          rw [hsubtwo, hfactor]
          ring
    have := Nat.eq_of_mul_eq_mul_left (by omega : 0 < 2) hdouble
    simpa [q] using this
  · refine ⟨2 * q - 1, ?_⟩
    have hn' : n = 2 * q + 1 := by omega
    have hsubtwo : n - 2 = 2 * q - 1 := by omega
    have hfactor : 2 * q - 1 - 1 = 2 * (q - 1) := by omega
    have hdouble :
        2 * Nat.choose (n - 2) 2 =
          2 * ((q - 1) * (2 * q - 1)) := by
      calc
        2 * Nat.choose (n - 2) 2 =
            (n - 2) * (n - 2 - 1) := hchoose
        _ = 2 * ((q - 1) * (2 * q - 1)) := by
          rw [hsubtwo, hfactor]
          ring
    have := Nat.eq_of_mul_eq_mul_left (by omega : 0 < 2) hdouble
    simpa [q, Nat.mul_comm] using this

omit [Fintype P] in
/-- Degrees in the endpoint-pair disjointness graph are divisible by one less than the maximum
matching size. -/
theorem sub_one_dvd_degree_arcPairDisjointnessGraph
    (A : Finset P) (hhalf : 2 ≤ A.card / 2) (e : ArcPair A) :
    A.card / 2 - 1 ∣ (arcPairDisjointnessGraph A).degree e := by
  rw [degree_arcPairDisjointnessGraph]
  exact half_sub_one_dvd_choose_sub_two A.card hhalf

/-- Maximum concurrence matchings indexed by a set of external points form a clique packing in
the endpoint-pair disjointness graph. -/
noncomputable def concurrenceCliquePacking
    {A : Finset P} (hA : Arc (L := L) A) (X : Finset P)
    (hexternal : ∀ x ∈ X, x ∉ A)
    (hmaximum : ∀ x ∈ X, pointIndex (L := L) A x = A.card / 2) :
    CliquePacking.Packing (arcPairDisjointnessGraph A) (A.card / 2) := by
  classical
  refine
    { blocks := X.image fun x => pairsThrough (L := L) A x
      blocks_subset := ?_
      pairwise_card_inter_le_one := ?_ }
  · intro B hB
    obtain ⟨x, hx, rfl⟩ := Finset.mem_image.mp hB
    rw [SimpleGraph.mem_cliqueFinset_iff]
    refine ⟨?_, ?_⟩
    · intro e he f hf hef
      exact arcPairDisjointnessGraph_adj.mpr
        ((concurrence_matching (L := L) hA (hexternal x hx)) he hf hef)
    · rw [← pointIndex_eq_card_pairsThrough (L := L) hA, hmaximum x hx]
  · intro B hB C hC hBC
    obtain ⟨x, hx, rfl⟩ := Finset.mem_image.mp hB
    obtain ⟨y, hy, rfl⟩ := Finset.mem_image.mp hC
    rw [Finset.card_le_one_iff]
    intro e f he hf
    by_contra hef
    have heX := (Finset.mem_inter.mp he).1
    have heY := (Finset.mem_inter.mp he).2
    have hfX := (Finset.mem_inter.mp hf).1
    have hfY := (Finset.mem_inter.mp hf).2
    have hdisj :=
      (concurrence_matching (L := L) hA (hexternal x hx)) heX hfX hef
    obtain ⟨z, hz, huniq⟩ :=
      disjoint_arcPairs_existsUnique_concurrence (L := L) hA hef hdisj
    have hxy : x = y := by
      calc
        x = z := huniq x ⟨hexternal x hx, heX, hfX⟩
        _ = y := (huniq y ⟨hexternal y hy, heY, hfY⟩).symm
    exact hBC (congrArg (pairsThrough (L := L) A) hxy)

omit [Fintype P] in
/-- The number of blocks in the concurrence clique packing is the number of indexing centres,
provided the common matching size is at least two. -/
theorem card_blocks_concurrenceCliquePacking
    {A : Finset P} (hA : Arc (L := L) A) (X : Finset P)
    (hexternal : ∀ x ∈ X, x ∉ A)
    (hmaximum : ∀ x ∈ X, pointIndex (L := L) A x = A.card / 2)
    (hhalf : 2 ≤ A.card / 2) :
    (concurrenceCliquePacking (L := L) hA X hexternal hmaximum).blocks.card =
      X.card := by
  classical
  rw [concurrenceCliquePacking, Finset.card_image_iff.mpr]
  intro x hx y hy hxy
  apply concurrence_matching_injective (L := L) hA
  · rw [← pointIndex_eq_card_pairsThrough (L := L) hA,
      hmaximum x hx]
    exact hhalf
  · exact hxy

omit [Fintype P] in
/-- If a family of maximum concurrence matchings is one block short in the edge count, then it
extends to a full clique decomposition of the endpoint-pair disjointness graph. -/
theorem exists_disjointness_decomposition_of_concurrence_count_add_one
    {A : Finset P} (hA : Arc (L := L) A) (X : Finset P)
    (hexternal : ∀ x ∈ X, x ∉ A)
    (hmaximum : ∀ x ∈ X, pointIndex (L := L) A x = A.card / 2)
    (hhalf : 2 ≤ A.card / 2) (v : ℕ)
    (htotal :
      v * Nat.choose (A.card / 2) 2 = 3 * Nat.choose A.card 4)
    (hcount : X.card + 1 = v) :
    ∃ Q : CliquePacking.Packing
        (arcPairDisjointnessGraph A) (A.card / 2),
      CliquePacking.IsDecomposition (arcPairDisjointnessGraph A) Q := by
  let Q :=
    concurrenceCliquePacking (L := L) hA X hexternal hmaximum
  have hblocks : Q.blocks.card = X.card :=
    card_blocks_concurrenceCliquePacking (L := L)
      hA X hexternal hmaximum hhalf
  have hleave :
      (CliquePacking.leave (arcPairDisjointnessGraph A) Q).edgeFinset.card =
        Nat.choose (A.card / 2) 2 := by
    rw [CliquePacking.card_leave_edgeFinset, hblocks,
      card_edgeFinset_arcPairDisjointnessGraph, ← htotal, ← hcount]
    simp [add_mul]
  obtain ⟨Q', _hsub, hdecomp⟩ :=
    CliquePacking.exists_decomposition_of_card_leave_eq_choose
      (arcPairDisjointnessGraph A) Q hhalf hleave
      (sub_one_dvd_degree_arcPairDisjointnessGraph A hhalf)
  exact ⟨Q', hdecomp⟩

/-- External points at which the secants of `A` form a maximum matching, split between required
points and prescribed holes. -/
noncomputable def maximumConcurrenceCenters
    (A H : Finset P) : Finset P :=
  maximumRequiredConcurrenceCenters (L := L) A H ∪
    maximumHoleConcurrenceCenters (L := L) A H

omit [Configuration.ProjectivePlane P L] in
private theorem maximumConcurrenceCenters_external
    {A H : Finset P} (hdisj : Disjoint A H)
    {x : P} (hx : x ∈ maximumConcurrenceCenters (L := L) A H) :
    x ∉ A := by
  classical
  rw [maximumConcurrenceCenters, Finset.mem_union] at hx
  rcases hx with hx | hx
  · have hxRequired :=
      (Finset.mem_filter.mp hx).1
    have hxLocus :=
      (Finset.mem_filter.mp hxRequired).1
    exact fun hxA =>
      (Finset.mem_sdiff.mp hxLocus).2 (Finset.mem_union_left H hxA)
  · have hxH := (Finset.mem_filter.mp hx).1
    exact fun hxA => Finset.disjoint_left.mp hdisj hxA hxH

omit [Configuration.ProjectivePlane P L] in
private theorem maximumConcurrenceCenters_index
    {A H : Finset P} {x : P}
    (hx : x ∈ maximumConcurrenceCenters (L := L) A H) :
    pointIndex (L := L) A x = A.card / 2 := by
  classical
  rw [maximumConcurrenceCenters, Finset.mem_union] at hx
  rcases hx with hx | hx
  · exact (Finset.mem_filter.mp hx).2
  · exact (Finset.mem_filter.mp hx).2

omit [Configuration.ProjectivePlane P L] in
private theorem card_maximumConcurrenceCenters
    {A H : Finset P} :
    (maximumConcurrenceCenters (L := L) A H).card =
      maximumConcurrenceBlockCount (L := L) A H := by
  classical
  have hdisj :
      Disjoint
        (maximumRequiredConcurrenceCenters (L := L) A H)
        (maximumHoleConcurrenceCenters (L := L) A H) := by
    rw [Finset.disjoint_left]
    intro x hxRequired hxHole
    have hxCovered := (Finset.mem_filter.mp hxRequired).1
    have hxLocus := (Finset.mem_filter.mp hxCovered).1
    have hxH := (Finset.mem_filter.mp hxHole).1
    exact (Finset.mem_sdiff.mp hxLocus).2
      (Finset.mem_union_right A hxH)
  rw [maximumConcurrenceCenters, Finset.card_union_of_disjoint hdisj,
    maximumConcurrenceBlockCount]

/-- If the endpoint-pair disjointness graph has no decomposition into maximum concurrence
cliques, then at least two blocks are absent from the geometric maximum-concurrence packing. -/
theorem two_le_maximumConcurrenceBlockDeficiency_of_no_decomposition
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (v : ℕ)
    (htotal :
      v * Nat.choose (A.card / 2) 2 = 3 * Nat.choose A.card 4)
    (hhalf : 2 ≤ A.card / 2)
    (hnodecomp :
      ¬ ∃ Q : CliquePacking.Packing
          (arcPairDisjointnessGraph A) (A.card / 2),
        CliquePacking.IsDecomposition (arcPairDisjointnessGraph A) Q) :
    2 ≤ v - maximumConcurrenceBlockCount (L := L) A H := by
  classical
  let X := maximumConcurrenceCenters (L := L) A H
  have hexternal : ∀ x ∈ X, x ∉ A :=
    fun _x hx => maximumConcurrenceCenters_external (L := L) hdisj hx
  have hmaximum :
      ∀ x ∈ X, pointIndex (L := L) A x = A.card / 2 :=
    fun _x hx => maximumConcurrenceCenters_index (L := L) hx
  let Q :=
    concurrenceCliquePacking (L := L) hA X hexternal hmaximum
  have hcardX :
      X.card = maximumConcurrenceBlockCount (L := L) A H := by
    exact card_maximumConcurrenceCenters (L := L)
  have hblocks :
      Q.blocks.card = maximumConcurrenceBlockCount (L := L) A H := by
    rw [card_blocks_concurrenceCliquePacking (L := L)
      hA X hexternal hmaximum hhalf, hcardX]
  have hcoveredCard :
      (CliquePacking.coveredEdges (arcPairDisjointnessGraph A) Q).card =
        maximumConcurrenceBlockCount (L := L) A H *
          Nat.choose (A.card / 2) 2 := by
    rw [CliquePacking.card_coveredEdges, hblocks]
  have hcoveredSubset :=
    CliquePacking.coveredEdges_subset_edgeFinset
      (arcPairDisjointnessGraph A) Q
  have hcountLe : maximumConcurrenceBlockCount (L := L) A H ≤ v := by
    have hcardLe := Finset.card_le_card hcoveredSubset
    rw [hcoveredCard, card_edgeFinset_arcPairDisjointnessGraph,
      ← htotal] at hcardLe
    exact Nat.le_of_mul_le_mul_right hcardLe
      (Nat.choose_pos hhalf)
  have hpositive :
      0 < v - maximumConcurrenceBlockCount (L := L) A H := by
    by_contra hnotPositive
    have hcountEq :
        maximumConcurrenceBlockCount (L := L) A H = v := by omega
    apply hnodecomp
    refine ⟨Q, ?_⟩
    apply Finset.eq_of_subset_of_card_le hcoveredSubset
    rw [hcoveredCard, hcountEq,
      card_edgeFinset_arcPairDisjointnessGraph, ← htotal]
  have hnotOne :
      v - maximumConcurrenceBlockCount (L := L) A H ≠ 1 := by
    intro hone
    have hcount :
        X.card + 1 = v := by omega
    apply hnodecomp
    exact exists_disjointness_decomposition_of_concurrence_count_add_one
      (L := L) hA X hexternal hmaximum hhalf v htotal hcount
  omega

/-- Nonexistence of a maximum-clique decomposition supplies the two-missing-block hypothesis in
the prescribed-hole defect bound. -/
theorem two_mul_half_le_scaledDefect_of_no_disjointness_decomposition
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (v : ℕ)
    (htotal :
      v * Nat.choose (A.card / 2) 2 = 3 * Nat.choose A.card 4)
    (hhalf : 2 ≤ A.card / 2)
    (hnodecomp :
      ¬ ∃ Q : CliquePacking.Packing
          (arcPairDisjointnessGraph A) (A.card / 2),
        CliquePacking.IsDecomposition (arcPairDisjointnessGraph A) Q) :
    2 * ((A.card / 2 : ℕ) : ℤ) ≤ scaledDefect (L := L) A H := by
  apply two_mul_half_le_scaledDefect_of_two_le_maximumConcurrenceBlockDeficiency
    (L := L) hA hdisj v htotal hhalf
  exact two_le_maximumConcurrenceBlockDeficiency_of_no_decomposition
    (L := L) hA hdisj v htotal hhalf hnodecomp

end FinitePlane

end RelativeConicArcs
