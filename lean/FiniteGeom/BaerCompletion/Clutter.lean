import FiniteGeom.Hypergraph

/-!
# Minimal-edge clutters

Removing every hyperedge that properly contains another edge preserves transversals and transversal
number. This is the formal distinction between all dependent traces and their canonical minimal
obstruction clutter.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- The inclusion-minimal edges of a finite hypergraph. -/
def minimalEdges (H : Finset (Finset V)) : Finset (Finset V) :=
  H.filter fun A => ∀ B ∈ H, B ⊆ A → A ⊆ B

theorem mem_minimalEdges {H : Finset (Finset V)} {A : Finset V} :
    A ∈ minimalEdges H ↔ A ∈ H ∧ ∀ B ∈ H, B ⊆ A → A ⊆ B := by
  simp [minimalEdges]

/-- Every edge contains an inclusion-minimal edge. -/
theorem exists_minimalEdge_subset {H : Finset (Finset V)} {A : Finset V} (hA : A ∈ H) :
    ∃ B ∈ minimalEdges H, B ⊆ A := by
  classical
  let sizes : Set ℕ := {n | ∃ B ∈ H, B ⊆ A ∧ B.card = n}
  have hsizes : sizes.Nonempty := ⟨A.card, A, hA, subset_refl _, rfl⟩
  obtain ⟨B, hBH, hBA, hBcard⟩ := Nat.sInf_mem hsizes
  refine ⟨B, (mem_minimalEdges).mpr ⟨hBH, ?_⟩, hBA⟩
  intro C hCH hCB
  have hle : B.card ≤ C.card := by
    rw [hBcard]
    exact Nat.sInf_le ⟨C, hCH, hCB.trans hBA, rfl⟩
  have hEq : C = B := Finset.eq_of_subset_of_card_le hCB hle
  simp [hEq]

/-- A set hits every edge iff it hits every minimal edge. -/
theorem isTransversal_minimalEdges_iff {H : Finset (Finset V)} {T : Finset V} :
    IsTransversal (minimalEdges H) T ↔ IsTransversal H T := by
  constructor
  · intro hT A hA
    obtain ⟨B, hB, hBA⟩ := exists_minimalEdge_subset hA
    obtain ⟨v, hv⟩ := hT hB
    exact ⟨v, Finset.mem_inter.mpr ⟨(Finset.mem_inter.mp hv).1,
      hBA (Finset.mem_inter.mp hv).2⟩⟩
  · intro hT A hA
    exact hT ((mem_minimalEdges.mp hA).1)

/-- **Clutter reduction preserves transversal number.** -/
theorem transversalNumber_minimalEdges (H : Finset (Finset V)) :
    transversalNumber (minimalEdges H) = transversalNumber H := by
  unfold transversalNumber
  congr 1
  ext n
  constructor
  · rintro ⟨T, hT, rfl⟩
    exact ⟨T, isTransversal_minimalEdges_iff.mp hT, rfl⟩
  · rintro ⟨T, hT, rfl⟩
    exact ⟨T, isTransversal_minimalEdges_iff.mpr hT, rfl⟩

end FiniteGeom.BaerCompletion
