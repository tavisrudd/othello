import FiniteGeom.Completion
import FiniteGeom.BaerCompletion.Obstruction

/-!
# Inserting a prescribed finite set

The completion/transversal identity does not depend on adding a singleton.  This module packages
the corresponding theorem for simultaneous insertion of an arbitrary prescribed finite set `X`.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V]

variable (I : IndependenceSystem V) [DecidablePred I.indep]

/-- Every trace in `C` whose union with the prescribed insertion set `X` is dependent. -/
def multiObstructionHypergraph (C X : Finset V) : Finset (Finset V) :=
  C.powerset.filter fun A => ¬ I.indep (X ∪ A)

omit [Fintype V] in
@[simp] theorem multiObstructionHypergraph_singleton (C : Finset V) (x : V) :
    multiObstructionHypergraph I C {x} = obstructionHypergraph I C x := by
  ext A
  simp [multiObstructionHypergraph, obstructionHypergraph]

omit [Fintype V] in
theorem mem_multiObstructionHypergraph {C X A : Finset V} :
    A ∈ multiObstructionHypergraph I C X ↔ A ⊆ C ∧ ¬ I.indep (X ∪ A) := by
  simp [multiObstructionHypergraph]

omit [Fintype V] in
theorem multiObstruction_edge_subset {C X A : Finset V}
    (hA : A ∈ multiObstructionHypergraph I C X) : A ⊆ C :=
  (mem_multiObstructionHypergraph I).mp hA |>.1

omit [Fintype V] in
theorem multiObstruction_edge_nonempty {C X A : Finset V}
    (hX : I.indep X) (hA : A ∈ multiObstructionHypergraph I C X) : A.Nonempty := by
  rw [Finset.nonempty_iff_ne_empty]
  intro h
  have hdep := (mem_multiObstructionHypergraph I).mp hA |>.2
  apply hdep
  simpa [h] using hX

omit [Fintype V] in
/-- Simultaneous insertion succeeds exactly when every dependent trace is hit. -/
theorem multiInsertion_indep_iff_no_surviving_trace {C D X : Finset V} :
    I.indep (X ∪ (C \ D)) ↔
      ∀ A ∈ multiObstructionHypergraph I C X, ¬ A ⊆ C \ D := by
  constructor
  · intro hins A hA hAsub
    have hdep := (mem_multiObstructionHypergraph I).mp hA |>.2
    apply hdep
    apply I.hereditary _ hins
    exact Finset.union_subset_union (subset_refl X) hAsub
  · intro h
    by_contra hdep
    have hedge : C \ D ∈ multiObstructionHypergraph I C X :=
      (mem_multiObstructionHypergraph I).mpr ⟨Finset.sdiff_subset, hdep⟩
    exact h (C \ D) hedge (subset_refl _)

/-- Minimum deletions from `C` enabling simultaneous insertion of `X`. -/
noncomputable def multiInsertionDistance (C X : Finset V) : ℕ :=
  sInf {n | ∃ D, D ⊆ C ∧ I.indep (X ∪ (C \ D)) ∧ D.card = n}

omit [Fintype V] [DecidablePred I.indep] in
@[simp] theorem multiInsertionDistance_singleton (C : Finset V) (x : V) :
    multiInsertionDistance I C {x} = insertionDistance I C x := by
  unfold multiInsertionDistance insertionDistance
  simp only [singleton_union]

omit [Fintype V] in
theorem multiInsertionDistance_eq_completionDistance (C X : Finset V) :
    multiInsertionDistance I C X =
      completionDistance (multiObstructionHypergraph I C X) C := by
  unfold multiInsertionDistance completionDistance
  congr 1
  ext n
  simp only [Set.mem_setOf_eq]
  constructor
  · rintro ⟨D, hDC, hI, rfl⟩
    exact ⟨D, hDC, (multiInsertion_indep_iff_no_surviving_trace I).mp hI, rfl⟩
  · rintro ⟨D, hDC, hH, rfl⟩
    exact ⟨D, hDC, (multiInsertion_indep_iff_no_surviving_trace I).mpr hH, rfl⟩

/-- **Multi-insertion completion theorem.** If `X` is independent, its simultaneous insertion
distance is the transversal number of the complete obstruction hypergraph at `X`. -/
theorem multiInsertionDistance_eq_transversalNumber (C X : Finset V) (hX : I.indep X) :
    multiInsertionDistance I C X = transversalNumber (multiObstructionHypergraph I C X) := by
  rw [multiInsertionDistance_eq_completionDistance]
  apply completionDistance_eq_transversalNumber
  · intro A hA
    exact multiObstruction_edge_subset I hA
  · intro A hA
    exact multiObstruction_edge_nonempty I hX hA

end FiniteGeom.BaerCompletion
