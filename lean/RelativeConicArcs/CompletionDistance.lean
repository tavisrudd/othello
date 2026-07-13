import RelativeConicArcs.Moments
import FiniteGeom.BaerCompletion.Secant

/-!
# Completion distance of a projective-plane arc

This is the concrete incidence instance of `FiniteGeom.BaerCompletion.Secant`: the minimal
obstructions to inserting an external point are exactly the endpoint pairs of secants through it.
-/

namespace RelativeConicArcs

open Configuration Finset
open FiniteGeom FiniteGeom.BaerCompletion

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- Arc independence as a finite hereditary independence system. -/
noncomputable def arcIndependenceSystem (P L : Type*) [Membership P L] [DecidableEq P] :
    IndependenceSystem P where
  indep := Arc (L := L)
  hereditary := by
    intro A B hAB hB
    exact arc_mono hAB hB

/-- The endpoint-pair hypergraph of secants through `x`. -/
noncomputable def secantPairHypergraph (A : Finset P) (x : P) : Finset (Finset P) := by
  classical
  exact (pairsThrough (L := L) A x).image fun e => e.1

omit [Fintype P] [Fintype L] [DecidableEq L] in
theorem mem_secantPairHypergraph {A : Finset P} {x : P} {S : Finset P} :
    S ∈ secantPairHypergraph (L := L) A x ↔
      ∃ e ∈ pairsThrough (L := L) A x, e.1 = S := by
  classical
  simp [secantPairHypergraph]

omit [Fintype P] [DecidableEq L] in
theorem arc_insertion_iff_no_secantPair_survives {A D : Finset P} {x : P}
    (hA : Arc (L := L) A) (hxA : x ∉ A) :
    Arc (L := L) (insert x (A \ D)) ↔
      ∀ S ∈ secantPairHypergraph (L := L) A x, ¬ S ⊆ A \ D := by
  classical
  constructor
  · intro hins S hS hsub
    obtain ⟨e, he, rfl⟩ := mem_secantPairHypergraph.mp hS
    obtain ⟨a, b, hab, heq⟩ := e.exists_eq_pair
    have haE : a ∈ e.1 := by simp [heq]
    have hbE : b ∈ e.1 := by simp [heq]
    have haAD := hsub haE
    have hbAD := hsub hbE
    have hxa : x ≠ a := fun h => hxA (h ▸ e.subset haE)
    have hxb : x ≠ b := fun h => hxA (h ▸ e.subset hbE)
    apply hins (Finset.mem_insert_self x _) (Finset.mem_insert_of_mem haAD)
      (Finset.mem_insert_of_mem hbAD) hxa hxb hab
    exact ⟨e.line (L := L), mem_pairsThrough.mp he, e.mem_line haE, e.mem_line hbE⟩
  · intro hnone
    have hrem : Arc (L := L) (A \ D) := arc_mono Finset.sdiff_subset hA
    apply arc_insert_of_not_covered hrem
    intro hcovered
    obtain ⟨l, ⟨a, ha, b, hb, hab, hal, hbl⟩, hxl⟩ :=
      covered_iff_exists_secant.mp hcovered
    let e : ArcPair A := ⟨{a, b}, by
      rw [Finset.mem_powersetCard]
      refine ⟨?_, by simp [hab]⟩
      intro p hp
      simp only [Finset.mem_insert, Finset.mem_singleton] at hp
      rcases hp with rfl | rfl
      · exact (Finset.mem_sdiff.mp ha).1
      · exact (Finset.mem_sdiff.mp hb).1⟩
    have hel : e.line (L := L) = l := by
      apply e.line_unique
      intro p hp
      simp only [e, Finset.mem_insert, Finset.mem_singleton] at hp
      rcases hp with rfl | rfl
      · exact hal
      · exact hbl
    have hethrough : e ∈ pairsThrough (L := L) A x := by
      rw [mem_pairsThrough, hel]
      exact hxl
    have hedge : e.1 ∈ secantPairHypergraph (L := L) A x :=
      mem_secantPairHypergraph.mpr ⟨e, hethrough, rfl⟩
    apply hnone e.1 hedge
    intro p hp
    simp only [e, Finset.mem_insert, Finset.mem_singleton] at hp
    rcases hp with rfl | rfl
    · exact ha
    · exact hb

omit [Fintype P] [DecidableEq L] in
theorem secantPair_isSecantObstructionFamily {A : Finset P} {x : P}
    (hA : Arc (L := L) A) (hxA : x ∉ A) :
    IsSecantObstructionFamily (arcIndependenceSystem P L) A x
      (secantPairHypergraph (L := L) A x) := by
  classical
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro S hS
    obtain ⟨e, he, rfl⟩ := mem_secantPairHypergraph.mp hS
    exact e.subset
  · intro S hS
    obtain ⟨e, he, rfl⟩ := mem_secantPairHypergraph.mp hS
    exact e.card
  · intro S hS T hT hST
    obtain ⟨e, he, rfl⟩ := mem_secantPairHypergraph.mp hS
    obtain ⟨f, hf, rfl⟩ := mem_secantPairHypergraph.mp hT
    apply pairsThrough_pairwiseDisjoint (L := L) hA hxA he hf
    intro hef
    apply hST
    exact congrArg Subtype.val hef
  · exact fun D => arc_insertion_iff_no_secantPair_survives hA hxA

/-- **Projective-plane secant resilience.** The deletion cost for inserting an external point into
an arc is exactly its secant index. -/
theorem arcInsertionDistance_eq_pointIndex {A : Finset P} {x : P}
    (hA : Arc (L := L) A) (hxA : x ∉ A) :
    insertionDistance (arcIndependenceSystem P L) A x = pointIndex (L := L) A x := by
  rw [pointIndex_eq_card_pairsThrough hA]
  rw [insertionDistance_eq_secantCount (arcIndependenceSystem P L)
    (secantPair_isSecantObstructionFamily (L := L) hA hxA)]
  unfold secantPairHypergraph
  rw [Finset.card_image_of_injective]
  intro e f hef
  exact Subtype.ext hef

/-- Global form: the completion distance of an arc is the minimum secant index over its external
points. -/
theorem arcGlobalInsertionDistance_eq_min_pointIndex {A : Finset P} (hA : Arc (L := L) A) :
    globalInsertionDistance (arcIndependenceSystem P L) A (Finset.univ \ A) =
      sInf {n | ∃ x ∈ Finset.univ \ A, pointIndex (L := L) A x = n} := by
  unfold globalInsertionDistance
  congr 1
  ext n
  constructor
  · rintro ⟨x, hx, hdist⟩
    have hxA : x ∉ A := (Finset.mem_sdiff.mp hx).2
    exact ⟨x, hx, (arcInsertionDistance_eq_pointIndex (L := L) hA hxA).symm.trans hdist⟩
  · rintro ⟨x, hx, hindex⟩
    have hxA : x ∉ A := (Finset.mem_sdiff.mp hx).2
    exact ⟨x, hx, (arcInsertionDistance_eq_pointIndex (L := L) hA hxA).trans hindex⟩

end RelativeConicArcs
