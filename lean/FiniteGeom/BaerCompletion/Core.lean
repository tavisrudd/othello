import FiniteGeom.BaerCompletion.RobustHole

/-!
# Completion cores and sharp deletion radii

This module proves the set-theoretic sharp deletion theorem for an explicitly supplied finite
family of maximal completions.  Maximality is irrelevant to the proof once that family is fixed.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Intersection of all listed completions containing `K`. -/
def completionCore (facets : Finset (Finset V)) (K : Finset V) : Finset V :=
  univ.filter fun x => ∀ F ∈ facets, K ⊆ F → x ∈ F

theorem mem_completionCore_iff {facets : Finset (Finset V)} {K : Finset V} {x : V} :
    x ∈ completionCore facets K ↔ ∀ F ∈ facets, K ⊆ F → x ∈ F := by
  simp [completionCore]

/-- If `C` is the unique listed completion containing `K`, then the completion core is `C`. -/
theorem completionCore_eq_of_unique {facets : Finset (Finset V)} {K C : Finset V}
    (hC : C ∈ facets) (hKC : K ⊆ C)
    (hunique : ∀ F ∈ facets, K ⊆ F → F = C) :
    completionCore facets K = C := by
  ext x
  constructor
  · intro hx
    exact (mem_completionCore_iff.mp hx) C hC hKC
  · intro hx
    apply mem_completionCore_iff.mpr
    intro F hF hKF
    simpa [hunique F hF hKF] using hx

/-- If two listed completions meet exactly in `K`, their common core is exactly `K`. -/
theorem completionCore_eq_of_two_facets {facets : Finset (Finset V)} {K C F : Finset V}
    (hC : C ∈ facets) (hF : F ∈ facets) (hKC : K ⊆ C) (hKF : K ⊆ F)
    (hinter : C ∩ F = K) : completionCore facets K = K := by
  apply Finset.Subset.antisymm
  · intro x hx
    have hxC := (mem_completionCore_iff.mp hx) C hC hKC
    have hxF := (mem_completionCore_iff.mp hx) F hF hKF
    rw [← hinter]
    exact Finset.mem_inter.mpr ⟨hxC, hxF⟩
  · intro x hx
    apply mem_completionCore_iff.mpr
    intro E hE hKE
    exact hKE hx

omit [Fintype V] in
/-- **Sharp deletion theorem, uniqueness half.** If every alternative completion omits at least
`r` elements of `C`, deleting fewer than `r` elements leaves `C` as the unique completion. -/
theorem unique_completion_of_small_deletion {facets : Finset (Finset V)} {C D : Finset V}
    {r : ℕ}
    (hsep : ∀ F ∈ facets, F ≠ C → r ≤ (C \ F).card) (hsmall : D.card < r) :
    ∀ F ∈ facets, C \ D ⊆ F → F = C := by
  intro F hF hsub
  by_contra hFC
  have hCFsub : C \ F ⊆ D := by
    intro x hx
    have hxC := (Finset.mem_sdiff.mp hx).1
    by_contra hxD
    have hxCD : x ∈ C \ D := Finset.mem_sdiff.mpr ⟨hxC, hxD⟩
    exact (Finset.mem_sdiff.mp hx).2 (hsub hxCD)
  have hle : (C \ F).card ≤ D.card := Finset.card_le_card hCFsub
  have := hsep F hF hFC
  omega

/-- Core form of the sharp deletion theorem. -/
theorem completionCore_sdiff_eq {facets : Finset (Finset V)} {C D : Finset V}
    {r : ℕ} (hC : C ∈ facets)
    (hsep : ∀ F ∈ facets, F ≠ C → r ≤ (C \ F).card) (hsmall : D.card < r) :
    completionCore facets (C \ D) = C := by
  apply completionCore_eq_of_unique hC Finset.sdiff_subset
  exact unique_completion_of_small_deletion hsep hsmall

/-- **Sharpness witness.** For two listed completions `C` and `F`, deleting exactly `C \ F`
leaves their intersection, whose completion core is already that intersection. -/
theorem completionCore_delete_difference_eq_intersection
    {facets : Finset (Finset V)} {C F : Finset V}
    (hC : C ∈ facets) (hF : F ∈ facets) :
    completionCore facets (C \ (C \ F)) = C ∩ F := by
  have hK : C \ (C \ F) = C ∩ F := by
    ext x
    simp only [Finset.mem_sdiff, Finset.mem_inter]
    tauto
  rw [hK]
  exact completionCore_eq_of_two_facets hC hF Finset.inter_subset_left
    Finset.inter_subset_right rfl

end FiniteGeom.BaerCompletion
