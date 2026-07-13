import FiniteGeom.Completion

/-!
# Obstruction hypergraphs of finite hereditary independence systems

This module discharges the semantic premise deliberately folded into
`FiniteGeom.Completion`: inserting `x` after deleting `D` is independent exactly when no
dependent trace survives.  We work with all dependent traces, rather than only inclusion-minimal
circuits; this gives the same transversals and avoids needing a matroid circuit API.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- A finite hereditary independence system on `V`. -/
structure IndependenceSystem (V : Type*) [DecidableEq V] where
  indep : Finset V → Prop
  hereditary : ∀ ⦃A B : Finset V⦄, A ⊆ B → indep B → indep A

variable (I : IndependenceSystem V) [DecidablePred I.indep]

/-- Every trace in `C` whose union with the proposed point `x` is dependent.

The inclusion-minimal members are the usual circuit traces. Keeping all dependent traces does not
change the transversal condition: a set meets every dependent trace iff it meets every minimal one.
-/
def obstructionHypergraph (C : Finset V) (x : V) : Finset (Finset V) :=
  C.powerset.filter fun A => ¬ I.indep (insert x A)

omit [Fintype V] in
theorem mem_obstructionHypergraph {C A : Finset V} {x : V} :
    A ∈ obstructionHypergraph I C x ↔ A ⊆ C ∧ ¬ I.indep (insert x A) := by
  simp [obstructionHypergraph]

omit [Fintype V] in
theorem obstruction_edge_subset {C A : Finset V} {x : V}
    (hA : A ∈ obstructionHypergraph I C x) : A ⊆ C :=
  (mem_obstructionHypergraph I).mp hA |>.1

omit [Fintype V] in
theorem obstruction_edge_nonempty {C A : Finset V} {x : V}
    (hx : I.indep {x}) (hA : A ∈ obstructionHypergraph I C x) : A.Nonempty := by
  rw [Finset.nonempty_iff_ne_empty]
  intro h
  have hdep := (mem_obstructionHypergraph I).mp hA |>.2
  apply hdep
  simpa [h] using hx

omit [Fintype V] in
/-- The semantic bridge omitted from the abstract-first completion layer. -/
theorem insertion_indep_iff_no_surviving_trace {C D : Finset V} {x : V} :
    I.indep (insert x (C \ D)) ↔
      ∀ A ∈ obstructionHypergraph I C x, ¬ A ⊆ C \ D := by
  constructor
  · intro hins A hA hAsub
    have hdep := (mem_obstructionHypergraph I).mp hA |>.2
    apply hdep
    apply I.hereditary _ hins
    exact Finset.insert_subset_insert x hAsub
  · intro h
    by_contra hdep
    have hedge : C \ D ∈ obstructionHypergraph I C x :=
      (mem_obstructionHypergraph I).mpr ⟨Finset.sdiff_subset, hdep⟩
    exact h (C \ D) hedge (subset_refl _)

/-- The genuine insertion cost, stated directly using the independence predicate. -/
noncomputable def insertionDistance (C : Finset V) (x : V) : ℕ :=
  sInf {n | ∃ D, D ⊆ C ∧ I.indep (insert x (C \ D)) ∧ D.card = n}

omit [Fintype V] in
theorem insertionDistance_eq_completionDistance (C : Finset V) (x : V) :
    insertionDistance I C x =
      completionDistance (obstructionHypergraph I C x) C := by
  unfold insertionDistance completionDistance
  congr 1
  ext n
  simp only [Set.mem_setOf_eq]
  constructor
  · rintro ⟨D, hDC, hI, rfl⟩
    exact ⟨D, hDC, (insertion_indep_iff_no_surviving_trace I).mp hI, rfl⟩
  · rintro ⟨D, hDC, hH, rfl⟩
    exact ⟨D, hDC, (insertion_indep_iff_no_surviving_trace I).mpr hH, rfl⟩

/-- **Semantic completion theorem.** If the singleton `{x}` is independent, the minimum number of
elements deleted from `C` before `x` can be inserted is the transversal number of the complete
obstruction hypergraph at `x`. -/
theorem insertionDistance_eq_transversalNumber (C : Finset V) (x : V)
    (hx : I.indep {x}) :
    insertionDistance I C x = transversalNumber (obstructionHypergraph I C x) := by
  rw [insertionDistance_eq_completionDistance]
  apply completionDistance_eq_transversalNumber
  · intro A hA
    exact obstruction_edge_subset I hA
  · intro A hA
    exact obstruction_edge_nonempty I hx hA

end FiniteGeom.BaerCompletion
