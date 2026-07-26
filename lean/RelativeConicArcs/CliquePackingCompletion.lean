import Mathlib.Combinatorics.SimpleGraph.DeleteEdges
import RelativeConicArcs.MatchingPackingDefect

/-!
# Completion of a clique packing one block short

Let `G` be a finite simple graph.  A packing by `m`-cliques is represented by a finite family of
vertex sets, each an `m`-clique, such that two distinct blocks meet in at most one vertex.  Thus no
edge of `G` occurs in two blocks.  This module defines the uncovered leave and proves that a
packing one block short of an edge decomposition completes whenever the degrees of `G` are
divisible by `m - 1`.
-/

namespace RelativeConicArcs

open Finset

namespace CliquePacking

variable {V : Type*} [Fintype V] [DecidableEq V]
  (G : SimpleGraph V) [DecidableRel G.Adj]

/-- Edges of `G` whose two endpoints belong to `B`.  For a clique `B`, these are all
`choose B.card 2` unordered pairs of distinct vertices of `B`. -/
def blockEdges (B : Finset V) : Finset (Sym2 V) :=
  G.edgeFinset ∩ B.sym2

/-- A finite packing by `m`-cliques.  The intersection condition is the simple-design condition:
two distinct clique blocks share at most one vertex, hence no graph edge. -/
structure Packing (m : ℕ) where
  blocks : Finset (Finset V)
  blocks_subset : blocks ⊆ G.cliqueFinset m
  pairwise_card_inter_le_one :
    (blocks : Set (Finset V)).Pairwise fun B C => (B ∩ C).card ≤ 1

/-- Edges covered by at least one block of a clique packing. -/
def coveredEdges {m : ℕ} (P : Packing G m) : Finset (Sym2 V) :=
  P.blocks.biUnion (blockEdges G)

/-- Vertices joined to `x` by an edge covered by a packing block. -/
def coveredNeighbors {m : ℕ} (P : Packing G m) (x : V) : Finset V :=
  P.blocks.biUnion fun B => if x ∈ B then B.erase x else ∅

/-- The graph left after deleting all edges covered by the packing blocks. -/
def leave {m : ℕ} (P : Packing G m) : SimpleGraph V :=
  G.deleteEdges (coveredEdges G P)

instance instDecidableLeaveAdj {m : ℕ} (P : Packing G m) :
    DecidableRel (leave G P).Adj := by
  unfold leave
  infer_instance

/-- A packing is a decomposition when its blocks cover every edge of the ambient graph. -/
def IsDecomposition {m : ℕ} (P : Packing G m) : Prop :=
  coveredEdges G P = G.edgeFinset

private theorem blockEdges_eq_map_edgeFinset_induce
    {B : Finset V} :
    blockEdges G B =
      (G.induce (B : Set V)).edgeFinset.map
        (Function.Embedding.subtype (· ∈ (B : Set V))).sym2Map := by
  classical
  ext e
  simp only [blockEdges, Finset.mem_inter, SimpleGraph.mem_edgeFinset,
    Finset.mem_sym2_iff, Finset.mem_map]
  induction e using Sym2.inductionOn with
  | _ x y =>
      simp only [Sym2.mem_iff, forall_eq_or_imp, forall_eq]
      constructor
      · rintro ⟨hxy, hx, hy⟩
        refine ⟨s(⟨x, hx⟩, ⟨y, hy⟩), ?_, ?_⟩
        · simpa using hxy
        · rfl
      · rintro ⟨e, he, hmap⟩
        induction e using Sym2.inductionOn with
        | _ u v =>
            simp only [SimpleGraph.mem_edgeSet, SimpleGraph.induce_adj] at he
            change s((u : V), (v : V)) = s(x, y) at hmap
            rw [Sym2.eq_iff] at hmap
            rcases hmap with hmap | hmap
            · refine ⟨?_, ?_, ?_⟩
              · simpa [hmap.1, hmap.2] using he
              · simpa [← hmap.1] using u.property
              · simpa [← hmap.2] using v.property
            · refine ⟨?_, ?_, ?_⟩
              · simpa [hmap.1, hmap.2] using he.symm
              · simpa [← hmap.2] using v.property
              · simpa [← hmap.1] using u.property

/-- An `m`-clique covers exactly `choose m 2` edges. -/
theorem card_blockEdges {m : ℕ} {B : Finset V}
    (hB : G.IsNClique m B) :
    (blockEdges G B).card = Nat.choose m 2 := by
  rw [blockEdges_eq_map_edgeFinset_induce G, Finset.card_map]
  have hinduce : G.induce (B : Set V) = ⊤ :=
    SimpleGraph.induce_eq_top.mpr hB.1
  have hedge :
      (G.induce (B : Set V)).edgeFinset =
        (⊤ : SimpleGraph {x // x ∈ (B : Set V)}).edgeFinset :=
    SimpleGraph.edgeFinset_inj.mpr hinduce
  rw [hedge, SimpleGraph.card_edgeFinset_top_eq_card_choose_two]
  simp [hB.2]

/-- Clique blocks meeting in at most one vertex cover disjoint edge sets. -/
theorem disjoint_blockEdges {B C : Finset V}
    (hinter : (B ∩ C).card ≤ 1) :
    Disjoint (blockEdges G B) (blockEdges G C) := by
  rw [Finset.disjoint_left]
  intro e heB heC
  have heG : e ∈ G.edgeFinset := (Finset.mem_inter.mp heB).1
  have heB' : ∀ x ∈ e, x ∈ B :=
    Finset.mem_sym2_iff.mp (Finset.mem_inter.mp heB).2
  have heC' : ∀ x ∈ e, x ∈ C :=
    Finset.mem_sym2_iff.mp (Finset.mem_inter.mp heC).2
  have hsubset : e.toFinset ⊆ B ∩ C := by
    intro x hx
    have hxe : x ∈ e := Sym2.mem_toFinset.mp hx
    exact Finset.mem_inter.mpr ⟨heB' x hxe, heC' x hxe⟩
  have hcardEdge : e.toFinset.card = 2 :=
    Sym2.card_toFinset_of_not_isDiag e (G.not_isDiag_of_mem_edgeFinset heG)
  have := Finset.card_le_card hsubset
  omega

/-- The block-edge sets of a clique packing are pairwise disjoint. -/
theorem pairwiseDisjoint_blockEdges {m : ℕ} (P : Packing G m) :
    (P.blocks : Set (Finset V)).PairwiseDisjoint (blockEdges G) := by
  intro B hB C hC hBC
  exact disjoint_blockEdges G
    (P.pairwise_card_inter_le_one hB hC hBC)

/-- A packing of `b` `m`-cliques covers exactly `b * choose m 2` graph edges. -/
theorem card_coveredEdges {m : ℕ} (P : Packing G m) :
    (coveredEdges G P).card = P.blocks.card * Nat.choose m 2 := by
  rw [coveredEdges, Finset.card_biUnion (pairwiseDisjoint_blockEdges G P)]
  calc
    (∑ B ∈ P.blocks, (blockEdges G B).card) =
        ∑ _B ∈ P.blocks, Nat.choose m 2 := by
      apply Finset.sum_congr rfl
      intro B hB
      exact card_blockEdges G
        (SimpleGraph.mem_cliqueFinset_iff.mp (P.blocks_subset hB))
    _ = P.blocks.card * Nat.choose m 2 := by simp

/-- Every covered edge is an edge of the ambient graph. -/
theorem coveredEdges_subset_edgeFinset {m : ℕ} (P : Packing G m) :
    coveredEdges G P ⊆ G.edgeFinset := by
  intro e he
  obtain ⟨B, hB, heB⟩ := Finset.mem_biUnion.mp he
  exact (Finset.mem_inter.mp heB).1

/-- Cardinality of the leave after deleting the packing blocks. -/
theorem card_leave_edgeFinset {m : ℕ} (P : Packing G m) :
    (leave G P).edgeFinset.card =
      G.edgeFinset.card - P.blocks.card * Nat.choose m 2 := by
  classical
  change (G.deleteEdges (coveredEdges G P)).edgeFinset.card = _
  rw [SimpleGraph.edgeFinset_deleteEdges,
    Finset.card_sdiff_of_subset (coveredEdges_subset_edgeFinset G P),
    card_coveredEdges G P]

omit [Fintype V] in
private theorem disjoint_erase_of_card_inter_le_one
    {B C : Finset V} {x : V} (hxB : x ∈ B) (hxC : x ∈ C)
    (hinter : (B ∩ C).card ≤ 1) :
    Disjoint (B.erase x) (C.erase x) := by
  rw [Finset.disjoint_left]
  intro y hyB hyC
  have hyB' := (Finset.mem_erase.mp hyB).2
  have hyC' := (Finset.mem_erase.mp hyC).2
  have hxy : x ≠ y := (Finset.mem_erase.mp hyB).1.symm
  have hsubset : {x, y} ⊆ B ∩ C := by
    intro z hz
    simp only [Finset.mem_insert, Finset.mem_singleton] at hz
    rcases hz with rfl | rfl
    · exact Finset.mem_inter.mpr ⟨hxB, hxC⟩
    · exact Finset.mem_inter.mpr ⟨hyB', hyC'⟩
  have hcardPair : ({x, y} : Finset V).card = 2 := Finset.card_pair hxy
  have := Finset.card_le_card hsubset
  omega

private theorem pairwiseDisjoint_coveredNeighborPieces
    {m : ℕ} (P : Packing G m) (x : V) :
    (P.blocks : Set (Finset V)).PairwiseDisjoint
      (fun B => if x ∈ B then B.erase x else ∅) := by
  intro B hB C hC hBC
  change Disjoint (if x ∈ B then B.erase x else ∅)
    (if x ∈ C then C.erase x else ∅)
  by_cases hxB : x ∈ B
  · by_cases hxC : x ∈ C
    · simpa only [if_pos hxB, if_pos hxC] using
        disjoint_erase_of_card_inter_le_one hxB hxC
          (P.pairwise_card_inter_le_one hB hC hBC)
    · simpa only [if_pos hxB, if_neg hxC] using
        Finset.disjoint_empty_right (B.erase x)
  · simpa only [if_neg hxB] using
      Finset.disjoint_empty_left (if x ∈ C then C.erase x else ∅)

/-- The number of covered neighbors of `x` is a multiple of `m - 1`. -/
theorem card_coveredNeighbors_eq
    {m : ℕ} (P : Packing G m) (x : V) :
    (coveredNeighbors G P x).card =
      (P.blocks.filter fun B => x ∈ B).card * (m - 1) := by
  rw [coveredNeighbors,
    Finset.card_biUnion (pairwiseDisjoint_coveredNeighborPieces G P x)]
  calc
    (∑ B ∈ P.blocks, (if x ∈ B then B.erase x else ∅).card) =
        ∑ B ∈ P.blocks, if x ∈ B then m - 1 else 0 := by
      apply Finset.sum_congr rfl
      intro B hB
      by_cases hxB : x ∈ B
      · have hcardB :
            B.card = m :=
          (SimpleGraph.mem_cliqueFinset_iff.mp (P.blocks_subset hB)).2
        simp [hxB, Finset.card_erase_of_mem hxB, hcardB]
      · simp [hxB]
    _ = (P.blocks.filter fun B => x ∈ B).card * (m - 1) := by
      rw [← Finset.sum_filter]
      simp

/-- The leave neighbors are precisely the ambient neighbors not covered by a packing block. -/
theorem neighborFinset_leave
    {m : ℕ} (P : Packing G m) (x : V) :
    (leave G P).neighborFinset x =
      G.neighborFinset x \ coveredNeighbors G P x := by
  classical
  ext y
  rw [SimpleGraph.mem_neighborFinset, Finset.mem_sdiff,
    SimpleGraph.mem_neighborFinset]
  change
    (G.deleteEdges (coveredEdges G P)).Adj x y ↔
      G.Adj x y ∧ y ∉ coveredNeighbors G P x
  rw [SimpleGraph.deleteEdges_adj]
  change
    (G.Adj x y ∧ s(x, y) ∉ coveredEdges G P) ↔
      G.Adj x y ∧ y ∉ coveredNeighbors G P x
  constructor
  · rintro ⟨hxy, hnotCovered⟩
    refine ⟨hxy, ?_⟩
    intro hcoveredNeighbor
    rw [coveredNeighbors, Finset.mem_biUnion] at hcoveredNeighbor
    obtain ⟨B, hB, hpiece⟩ := hcoveredNeighbor
    split at hpiece
    next hxB =>
      have hyB : y ∈ B := (Finset.mem_erase.mp hpiece).2
      apply hnotCovered
      rw [coveredEdges, Finset.mem_biUnion]
      refine ⟨B, hB, ?_⟩
      rw [blockEdges, Finset.mem_inter]
      refine ⟨SimpleGraph.mem_edgeFinset.mpr hxy, Finset.mem_sym2_iff.mpr ?_⟩
      intro z hz
      rcases (Sym2.mem_iff.mp hz) with rfl | rfl
      · exact hxB
      · exact hyB
    next hxB => simp at hpiece
  · rintro ⟨hxy, hnotNeighbor⟩
    refine ⟨hxy, ?_⟩
    intro hcovered
    rw [coveredEdges, Finset.mem_biUnion] at hcovered
    obtain ⟨B, hB, heB⟩ := hcovered
    have heB' := (Finset.mem_inter.mp heB).2
    have hxB : x ∈ B :=
      Finset.mem_sym2_iff.mp heB' x (by simp)
    have hyB : y ∈ B :=
      Finset.mem_sym2_iff.mp heB' y (by simp)
    apply hnotNeighbor
    rw [coveredNeighbors, Finset.mem_biUnion]
    refine ⟨B, hB, ?_⟩
    rw [if_pos hxB, Finset.mem_erase]
    exact ⟨hxy.ne.symm, hyB⟩

/-- If every ambient degree is divisible by `m - 1`, then every leave degree is also divisible by
`m - 1`. -/
theorem sub_one_dvd_degree_leave
    {m : ℕ} (P : Packing G m)
    (hdegree : ∀ x : V, m - 1 ∣ G.degree x) (x : V) :
    m - 1 ∣ (leave G P).degree x := by
  have hcoveredSubset :
      coveredNeighbors G P x ⊆ G.neighborFinset x := by
    intro y hy
    obtain ⟨B, hB, hpiece⟩ := Finset.mem_biUnion.mp hy
    split at hpiece
    next hxB =>
      have hyB : y ∈ B := (Finset.mem_erase.mp hpiece).2
      have hxy : x ≠ y := (Finset.mem_erase.mp hpiece).1.symm
      have hclique :=
        (SimpleGraph.mem_cliqueFinset_iff.mp (P.blocks_subset hB)).1
      simpa only [SimpleGraph.mem_neighborFinset] using
        (hclique hxB hyB hxy)
    next hxB => simp at hpiece
  have hdegreeEq :
      (leave G P).degree x =
        G.degree x - (P.blocks.filter fun B => x ∈ B).card * (m - 1) := by
    rw [← SimpleGraph.card_neighborFinset_eq_degree,
      neighborFinset_leave G P x,
      Finset.card_sdiff_of_subset hcoveredSubset,
      SimpleGraph.card_neighborFinset_eq_degree,
      card_coveredNeighbors_eq G P x]
  rw [hdegreeEq]
  obtain ⟨q, hq⟩ := hdegree x
  refine ⟨q - (P.blocks.filter fun B => x ∈ B).card, ?_⟩
  rw [hq, Nat.mul_comm (m - 1) q,
    ← Nat.sub_mul, Nat.mul_comm]

/-- If the leave has exactly `choose m 2` edges and ambient degrees are divisible by `m - 1`,
then adjoining the support of the leave completes the packing to an edge decomposition. -/
theorem exists_decomposition_of_card_leave_eq_choose
    {m : ℕ} (P : Packing G m) (hm : 2 ≤ m)
    (hedges : (leave G P).edgeFinset.card = Nat.choose m 2)
    (hdegree : ∀ x : V, m - 1 ∣ G.degree x) :
    ∃ P' : Packing G m,
      P.blocks ⊆ P'.blocks ∧ IsDecomposition G P' := by
  classical
  let L := leave G P
  let W := L.support.toFinset
  have hleaveDegree :
      ∀ x : V, 0 < L.degree x → m - 1 ∣ L.degree x := by
    intro x _
    exact sub_one_dvd_degree_leave G P hdegree x
  have hleave :=
    MatchingPacking.oneBlockShort_leave_isClique L m hm hedges hleaveDegree
  have hcardW : W.card = m := by
    simpa [W, L] using hleave.1
  have hcliqueL : L.IsClique (W : Set V) := by
    simpa [W] using hleave.2
  have hcliqueG : G.IsClique (W : Set V) := by
    intro x hx y hy hxy
    have hLxy := hcliqueL hx hy hxy
    exact (SimpleGraph.deleteEdges_le (G := G) (coveredEdges G P)) hLxy
  have hblockLeave :
      blockEdges G W = L.edgeFinset := by
    ext e
    induction e using Sym2.inductionOn with
    | _ x y =>
        simp only [blockEdges, Finset.mem_inter,
          SimpleGraph.mem_edgeFinset, Finset.mem_sym2_iff,
          Sym2.mem_iff, forall_eq_or_imp, forall_eq]
        constructor
        · rintro ⟨hGxy, hxW, hyW⟩
          have hxy : x ≠ y := hGxy.ne
          exact hcliqueL hxW hyW hxy
        · intro hLxy
          refine ⟨(SimpleGraph.deleteEdges_le (G := G) (coveredEdges G P)) hLxy,
            ?_, ?_⟩
          · exact Set.mem_toFinset.mpr hLxy.mem_support_left
          · exact Set.mem_toFinset.mpr hLxy.mem_support_right
  have hmeets :
      ∀ B ∈ P.blocks, (W ∩ B).card ≤ 1 := by
    intro B hB
    rw [Finset.card_le_one_iff]
    intro x y hx hy
    by_contra hxy
    have hxW := (Finset.mem_inter.mp hx).1
    have hyW := (Finset.mem_inter.mp hy).1
    have hxB := (Finset.mem_inter.mp hx).2
    have hyB := (Finset.mem_inter.mp hy).2
    have hLxy : L.Adj x y := hcliqueL hxW hyW hxy
    have hcovered : s(x, y) ∈ coveredEdges G P := by
      rw [coveredEdges, Finset.mem_biUnion]
      refine ⟨B, hB, ?_⟩
      rw [blockEdges, Finset.mem_inter]
      refine ⟨SimpleGraph.mem_edgeFinset.mpr
        ((SimpleGraph.deleteEdges_le (G := G) (coveredEdges G P)) hLxy), ?_⟩
      rw [Finset.mem_sym2_iff]
      intro z hz
      rcases Sym2.mem_iff.mp hz with rfl | rfl
      · exact hxB
      · exact hyB
    have hnotCovered : s(x, y) ∉ coveredEdges G P := by
      have hLxy' : G.Adj x y ∧ s(x, y) ∉ coveredEdges G P := by
        simpa [L, leave] using hLxy
      exact hLxy'.2
    exact hnotCovered hcovered
  let P' : Packing G m :=
    { blocks := insert W P.blocks
      blocks_subset := by
        intro B hB
        rw [Finset.mem_insert] at hB
        rcases hB with rfl | hB
        · exact SimpleGraph.mem_cliqueFinset_iff.mpr ⟨hcliqueG, hcardW⟩
        · exact P.blocks_subset hB
      pairwise_card_inter_le_one := by
        intro B hB C hC hBC
        simp only [Finset.coe_insert, Set.mem_insert_iff,
          Finset.mem_coe] at hB hC
        rcases hB with rfl | hB
        · rcases hC with rfl | hC
          · exact (hBC rfl).elim
          · exact hmeets C hC
        · rcases hC with rfl | hC
          · simpa [Finset.inter_comm] using hmeets B hB
          · exact P.pairwise_card_inter_le_one hB hC hBC }
  refine ⟨P', ?_, ?_⟩
  · intro B hB
    exact Finset.mem_insert_of_mem hB
  · change coveredEdges G P' = G.edgeFinset
    have hpartition :
        coveredEdges G P ∪ L.edgeFinset = G.edgeFinset := by
      ext e
      simp only [Finset.mem_union]
      constructor
      · rintro (hcovered | hL)
        · exact coveredEdges_subset_edgeFinset G P hcovered
        · exact SimpleGraph.edgeFinset_mono
            (SimpleGraph.deleteEdges_le (G := G) (coveredEdges G P)) hL
      · intro hG
        by_cases hcovered : e ∈ coveredEdges G P
        · exact Or.inl hcovered
        · exact Or.inr (by
            change e ∈ (G.deleteEdges (coveredEdges G P)).edgeFinset
            rw [SimpleGraph.edgeFinset_deleteEdges]
            exact Finset.mem_sdiff.mpr ⟨hG, hcovered⟩)
    rw [coveredEdges, show P'.blocks = insert W P.blocks by rfl,
      Finset.biUnion_insert, hblockLeave]
    simpa only [coveredEdges, Finset.union_comm] using hpartition

end CliquePacking

end RelativeConicArcs
