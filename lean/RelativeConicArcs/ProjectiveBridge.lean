import RelativeConicArcs.Arc
import ProjectiveCap.PlaneTransitivity
import Mathlib.Combinatorics.Configuration
import Mathlib.LinearAlgebra.CrossProduct
import Mathlib.LinearAlgebra.Projectivization.Cardinality

/-!
# Bridge to the coordinate projective plane

Mathlib represents both points and dual lines of `PG(2,K)` by projective vectors, with incidence
given by orthogonality.  This file proves that the incidence-theoretic `Arc` predicate agrees with
the existing `ProjectiveCap.Projective.Cap` predicate.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace ProjectiveBridge

open Configuration Matrix Projectivization

variable {K : Type*} [Field K]

abbrev Point (K : Type*) [Field K] := Projectivization K (Fin 3 → K)

private theorem collinear_iff_det_eq_zero {a b c : Point K} :
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) a b c ↔
      Matrix.det ![a.rep, b.rep, c.rep] = 0 := by
  rw [ProjectiveCap.Projective.collinear_iff_dependent,
    Projectivization.dependent_iff_not_independent,
    ProjectiveCap.Projective.independent_triple_iff]
  constructor
  · intro hnli
    exact Matrix.det_eq_zero_of_not_linearIndependent_rows (by simpa [Matrix.row] using hnli)
  · intro hdet hli
    let A : Matrix (Fin 3) (Fin 3) K := ![a.rep, b.rep, c.rep]
    have hliA : LinearIndependent K A.row := by simpa [A, Matrix.row] using hli
    have hunit : IsUnit A.det :=
      (Matrix.isUnit_iff_isUnit_det A).mp
        ((Matrix.linearIndependent_rows_iff_isUnit (A := A)).mp hliA)
    exact hunit.ne_zero (by simpa [A] using hdet)

variable [DecidableEq K]

/-- The coordinate incidence model is a projective plane whose order is the field cardinality. -/
theorem planeOrder_eq_card [Fintype K] :
    PlaneOrder (Point K) (Point K) = Fintype.card K := by
  letI : Fintype (Point K) := Fintype.ofFinite (Point K)
  have hAbstract := RelativeConicArcs.card_points
    (P := Point K) (L := Point K)
  have hCoordinate : Fintype.card (Point K) =
      Fintype.card K ^ 2 + Fintype.card K + 1 := by
    rw [← Nat.card_eq_fintype_card,
      Projectivization.card_of_finrank K (Fin 3 → K) (n := 3) (by simp)]
    norm_num [Finset.sum_range_succ]
    ring
  rw [hCoordinate] at hAbstract
  nlinarith

private theorem incidence_collinear_of_projective_collinear
    {a b c : Point K} (_hab : a ≠ b) (_hac : a ≠ c) (hbc : b ≠ c)
    (hcol : ProjectiveCap.Projective.Collinear K (Fin 3 → K) a b c) :
    RelativeConicArcs.Collinear (L := Point K) a b c := by
  let l : Point K := Projectivization.cross b c
  refine ⟨l, ?_, Projectivization.orthogonal_cross_left hbc,
    Projectivization.orthogonal_cross_right hbc⟩
  change a.orthogonal l
  dsimp [l]
  have hdet := collinear_iff_det_eq_zero.mp hcol
  have hbc' : Projectivization.mk K b.rep b.rep_nonzero ≠
      Projectivization.mk K c.rep c.rep_nonzero := by simpa using hbc
  rw [← Projectivization.mk_rep a, ← Projectivization.mk_rep b,
    ← Projectivization.mk_rep c]
  rw [Projectivization.cross_mk_of_ne b.rep_nonzero c.rep_nonzero hbc',
    Projectivization.orthogonal_mk]
  rw [triple_product_eq_det]
  exact hdet

private theorem projective_collinear_of_incidence_collinear
    {a b c : Point K} (_hab : a ≠ b) (_hac : a ≠ c) (hbc : b ≠ c)
    (hcol : RelativeConicArcs.Collinear (L := Point K) a b c) :
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) a b c := by
  obtain ⟨l, hla, hlb, hlc⟩ := hcol
  have hlcross : l = Projectivization.cross b c := by
    exact (Configuration.HasLines.existsUnique_line (P := Point K) (L := Point K) b c hbc).unique
      ⟨hlb, hlc⟩ ⟨Projectivization.orthogonal_cross_left hbc,
        Projectivization.orthogonal_cross_right hbc⟩
  have haorth : a.orthogonal (Projectivization.cross b c) := by
    rw [← hlcross]
    exact hla
  apply collinear_iff_det_eq_zero.mpr
  have hbc' : Projectivization.mk K b.rep b.rep_nonzero ≠
      Projectivization.mk K c.rep c.rep_nonzero := by simpa using hbc
  rw [← Projectivization.mk_rep a, ← Projectivization.mk_rep b,
    ← Projectivization.mk_rep c] at haorth
  rw [Projectivization.cross_mk_of_ne b.rep_nonzero c.rep_nonzero hbc',
    Projectivization.orthogonal_mk, triple_product_eq_det] at haorth
  exact haorth

/-- Mathlib incidence collinearity agrees with the existing projectivization predicate, including
the degenerate cases where two of the three points coincide. -/
theorem collinear_iff_projective_collinear {a b c : Point K} :
    RelativeConicArcs.Collinear (L := Point K) a b c ↔
      ProjectiveCap.Projective.Collinear K (Fin 3 → K) a b c := by
  by_cases hab : a = b
  · subst b
    constructor
    · intro _
      unfold ProjectiveCap.Projective.Collinear
      simpa using Projectivization.isCollinear_pair a c
    · intro _
      by_cases hac : a = c
      · subst c
        obtain ⟨p₁, p₂, _p₃, _l₁, l₂, _l₃, hp₁l₂, _hp₁l₃, _hp₂l₁,
          hp₂l₂, _hp₂l₃, _hp₃l₁, _hp₃l₂, _hp₃l₃⟩ :=
          Configuration.ProjectivePlane.exists_config (P := Point K) (L := Point K)
        have hp₁p₂ : p₁ ≠ p₂ := fun h => hp₁l₂ (h ▸ hp₂l₂)
        by_cases ha : a = p₁
        · have hap₂ : a ≠ p₂ := ha ▸ hp₁p₂
          obtain ⟨l, hl, _huniq⟩ :=
            Configuration.HasLines.existsUnique_line (P := Point K) (L := Point K) a p₂ hap₂
          exact ⟨l, hl.1, hl.1, hl.1⟩
        · obtain ⟨l, hl, _huniq⟩ :=
            Configuration.HasLines.existsUnique_line (P := Point K) (L := Point K) a p₁ ha
          exact ⟨l, hl.1, hl.1, hl.1⟩
      · obtain ⟨l, hl, _huniq⟩ :=
          Configuration.HasLines.existsUnique_line (P := Point K) (L := Point K) a c hac
        exact ⟨l, hl.1, hl.1, hl.2⟩
  by_cases hac : a = c
  · subst c
    constructor
    · intro _
      unfold ProjectiveCap.Projective.Collinear
      simpa [Set.pair_comm] using Projectivization.isCollinear_pair a b
    · intro _
      obtain ⟨l, hl, _huniq⟩ :=
        Configuration.HasLines.existsUnique_line (P := Point K) (L := Point K) a b hab
      exact ⟨l, hl.1, hl.2, hl.1⟩
  by_cases hbc : b = c
  · subst c
    constructor
    · intro _
      unfold ProjectiveCap.Projective.Collinear
      simpa using Projectivization.isCollinear_pair a b
    · intro _
      obtain ⟨l, hl, _huniq⟩ :=
        Configuration.HasLines.existsUnique_line (P := Point K) (L := Point K) a b hab
      exact ⟨l, hl.1, hl.2, hl.2⟩
  exact ⟨projective_collinear_of_incidence_collinear hab hac hbc,
    incidence_collinear_of_projective_collinear hab hac hbc⟩

/-- Incidence arcs in Mathlib's coordinate projective plane are exactly the projective caps used
by the existing `ProjectiveCap` library. -/
theorem arc_iff_projectiveCap (A : Finset (Point K)) :
    RelativeConicArcs.Arc (L := Point K) A ↔
      ProjectiveCap.Projective.Cap K (Fin 3 → K) A := by
  constructor
  · intro hArc a b c ha hb hc hab hac hbc hcol
    exact hArc ha hb hc hab hac hbc
      (incidence_collinear_of_projective_collinear hab hac hbc hcol)
  · intro hCap a b c ha hb hc hab hac hbc hcol
    exact hCap ha hb hc hab hac hbc
      (projective_collinear_of_incidence_collinear hab hac hbc hcol)

end ProjectiveBridge
end RelativeConicArcs
