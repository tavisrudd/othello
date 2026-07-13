import FiniteGeom.BaerCompletion.MultiInsertion

/-!
# Weighted completion distance

Deletion costs may vary by vertex. The semantic completion/transversal equivalence is unchanged.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Minimum total weight of a deletion enabling insertion. -/
noncomputable def weightedInsertionDistance (I : IndependenceSystem V) (C : Finset V) (x : V)
    (w : V → ℕ) : ℕ :=
  sInf {n | ∃ D, D ⊆ C ∧ I.indep (insert x (C \ D)) ∧ (∑ v ∈ D, w v) = n}

/-- Minimum total weight of a transversal constrained to lie in `C`. -/
noncomputable def weightedTransversalCostWithin (H : Finset (Finset V)) (C : Finset V)
    (w : V → ℕ) : ℕ :=
  sInf {n | ∃ D, D ⊆ C ∧ IsTransversal H D ∧ (∑ v ∈ D, w v) = n}

omit [Fintype V] in
/-- **Weighted completion/transversal identity.** -/
theorem weightedInsertionDistance_eq_weightedTransversalCostWithin
    (I : IndependenceSystem V) [DecidablePred I.indep] (C : Finset V) (x : V) (w : V → ℕ) :
    weightedInsertionDistance I C x w =
      weightedTransversalCostWithin (obstructionHypergraph I C x) C w := by
  unfold weightedInsertionDistance weightedTransversalCostWithin
  congr 1
  ext n
  simp only [Set.mem_setOf_eq]
  constructor
  · rintro ⟨D, hDC, hI, hw⟩
    have hsub : ∀ A ∈ obstructionHypergraph I C x, A ⊆ C := by
      intro A hA
      exact obstruction_edge_subset I hA
    exact ⟨D, hDC,
      (insertIndep_iff_transversal hsub).mp
        ((insertion_indep_iff_no_surviving_trace I).mp hI), hw⟩
  · rintro ⟨D, hDC, hT, hw⟩
    have hsub : ∀ A ∈ obstructionHypergraph I C x, A ⊆ C := by
      intro A hA
      exact obstruction_edge_subset I hA
    exact ⟨D, hDC,
      (insertion_indep_iff_no_surviving_trace I).mpr
        ((insertIndep_iff_transversal hsub).mpr hT), hw⟩

/-- Minimum total weight of a deletion enabling simultaneous insertion of `X`. -/
noncomputable def weightedMultiInsertionDistance (I : IndependenceSystem V) (C X : Finset V)
    (w : V → ℕ) : ℕ :=
  sInf {n | ∃ D, D ⊆ C ∧ I.indep (X ∪ (C \ D)) ∧ (∑ v ∈ D, w v) = n}

omit [Fintype V] in
/-- **Weighted multi-insertion/transversal identity.** The weighted and multi-insertion
generalizations compose without any additional hypothesis. -/
theorem weightedMultiInsertionDistance_eq_weightedTransversalCostWithin
    (I : IndependenceSystem V) [DecidablePred I.indep] (C X : Finset V) (w : V → ℕ) :
    weightedMultiInsertionDistance I C X w =
      weightedTransversalCostWithin (multiObstructionHypergraph I C X) C w := by
  unfold weightedMultiInsertionDistance weightedTransversalCostWithin
  congr 1
  ext n
  simp only [Set.mem_setOf_eq]
  constructor
  · rintro ⟨D, hDC, hI, hw⟩
    have hsub : ∀ A ∈ multiObstructionHypergraph I C X, A ⊆ C := by
      intro A hA
      exact multiObstruction_edge_subset I hA
    exact ⟨D, hDC,
      (insertIndep_iff_transversal hsub).mp
        ((multiInsertion_indep_iff_no_surviving_trace I).mp hI), hw⟩
  · rintro ⟨D, hDC, hT, hw⟩
    have hsub : ∀ A ∈ multiObstructionHypergraph I C X, A ⊆ C := by
      intro A hA
      exact multiObstruction_edge_subset I hA
    exact ⟨D, hDC,
      (multiInsertion_indep_iff_no_surviving_trace I).mpr
        ((insertIndep_iff_transversal hsub).mpr hT), hw⟩

end FiniteGeom.BaerCompletion
