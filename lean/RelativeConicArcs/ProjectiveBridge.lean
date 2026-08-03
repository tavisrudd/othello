import RelativeConicArcs.Arc
import ProjectiveCap.PlaneTransitivity
import ProjectiveCap.ProjectiveCapGame
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

/-- A point of the coordinate projective plane `PG(2,K)`, represented as in Mathlib by a
projective class of nonzero vectors in `K³`.  Dual lines are represented by the same type, with
incidence given by orthogonality. -/
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

noncomputable section GameLocalization

variable [Fintype K]

local instance : Fintype (Point K) := Fintype.ofFinite (Point K)
local instance : DecidableEq (Point K) := Classical.decEq (Point K)

/-- A cap containing a relatively complete seed can add points only from the prescribed hole set.
This is the static form of the cap-game localization bridge. -/
theorem projectiveCap_subset_union_of_completeOutside {A H S : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A H) (hAS : A ⊆ S)
    (hS : ProjectiveCap.Projective.Cap K (Fin 3 → K) S) :
    S ⊆ A ∪ H := by
  intro x hxS
  by_contra hxUnion
  have hxA : x ∉ A := by simpa using fun hx => hxUnion (Finset.mem_union_left H hx)
  have hxH : x ∉ H := by simpa using fun hx => hxUnion (Finset.mem_union_right A hx)
  obtain ⟨l, ⟨a, ha, b, hb, hab, hal, hbl⟩, hxl⟩ :=
    covered_iff_exists_secant.mp (hcomplete.2.2 x hxA hxH)
  have hxa : x ≠ a := fun h => hxA (h ▸ ha)
  have hxb : x ≠ b := fun h => hxA (h ▸ hb)
  apply hS hxS (hAS ha) (hAS hb) hxa hxb hab
  apply collinear_iff_projective_collinear.mp
  exact ⟨l, hxl, hal, hbl⟩

/-- Every legal move from any cap extending a relatively complete seed lies in the prescribed
hole set. In particular, confinement persists after arbitrary subsequent legal hole moves. -/
theorem move_mem_holes_of_completeOutside {A H S : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A H) (hAS : A ⊆ S) {x : Point K}
    (hx : FiniteBuildGame.Move (ProjectiveCap.Projective.Cap K (Fin 3 → K)) S x) :
    x ∈ H := by
  have hsubset := projectiveCap_subset_union_of_completeOutside hcomplete
    (Finset.Subset.trans hAS (Finset.subset_insert x S)) hx.2
  have hxUnion : x ∈ A ∪ H := hsubset (Finset.mem_insert_self x S)
  rcases Finset.mem_union.mp hxUnion with hxA | hxH
  · exact False.elim (hx.1 (hAS hxA))
  · exact hxH

/-- The legal-extension set of every cap-game continuation containing a relatively complete seed
is contained in the prescribed hole set. -/
theorem legalExtensions_subset_holes_of_completeOutside {A H S : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A H) (hAS : A ⊆ S) :
    ProjectiveCap.Projective.LegalExtensions (K := K) (V := Fin 3 → K) S ⊆ H := by
  intro x hx
  exact move_mem_holes_of_completeOutside hcomplete hAS
    (ProjectiveCap.Projective.mem_legalExtensions.mp hx)

/-- At the relatively complete seed itself, every legal projective cap-game extension is a hole. -/
theorem legalExtensions_subset_holes {A H : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A H) :
    ProjectiveCap.Projective.LegalExtensions (K := K) (V := Fin 3 → K) A ⊆ H :=
  legalExtensions_subset_holes_of_completeOutside hcomplete Finset.Subset.rfl

/-- Off-hole legal cap moves are exactly the uncovered required locus.  This identifies the
static defect variable with a game-domain count without asserting any game value or monotonicity. -/
theorem legalExtensions_sdiff_holes_eq_uncovered {A H : Finset (Point K)}
    (hA : RelativeConicArcs.Arc (L := Point K) A) :
    ProjectiveCap.Projective.LegalExtensions (K := K) (V := Fin 3 → K) A \ H =
      uncovered (L := Point K) A H := by
  classical
  ext x
  rw [Finset.mem_sdiff]
  constructor
  · rintro ⟨hxlegal, hxH⟩
    have hxmove := ProjectiveCap.Projective.mem_legalExtensions.mp hxlegal
    have hxnotCovered : ¬ Covered (L := Point K) A x :=
      (arc_insert_iff_not_covered hA hxmove.1).mp
        ((arc_iff_projectiveCap (K := K) (insert x A)).mpr hxmove.2)
    simp [uncovered, requiredLocus, hxmove.1, hxH, hxnotCovered]
  · intro hx
    have hxparts : (x ∉ A ∧ x ∉ H) ∧ ¬ Covered (L := Point K) A x := by
      simpa [uncovered, requiredLocus] using hx
    refine ⟨ProjectiveCap.Projective.mem_legalExtensions.mpr ⟨hxparts.1.1, ?_⟩, hxparts.1.2⟩
    rw [← arc_iff_projectiveCap]
    exact arc_insert_of_not_covered hA hxparts.2

/-! ## Exact game localization through a finite parametrization -/

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- Validity of a hole-parameter position after adjoining it to a fixed projective seed. -/
noncomputable def ParametrizedHoleValid (A : Finset (Point K))
    (e : I ↪ Point K) (T : Finset I) : Prop :=
  ProjectiveCap.Projective.Cap K (Fin 3 → K) (A ∪ T.map e)

/-- A relatively complete seed has exactly the same normal-play game as any injective
parametrization of its prescribed holes.  This is the dynamic bridge from the static
`CompleteOutside` predicate: it handles every continuation, not only the first move. -/
theorem win_parametrizedHoles_iff {A H : Finset (Point K)} (e : I ↪ Point K)
    (hcomplete : CompleteOutside (L := Point K) A H)
    (hrange : ∀ x : Point K, x ∈ H ↔ ∃ i : I, e i = x)
    (T : Finset I) :
    FiniteBuildGame.Win (ProjectiveCap.Projective.Cap K (Fin 3 → K)) (A ∪ T.map e) ↔
      FiniteBuildGame.Win (ParametrizedHoleValid (K := K) A e) T := by
  rw [FiniteBuildGame.win_iff_exists_move, FiniteBuildGame.win_iff_exists_move]
  constructor
  · rintro ⟨x, hxmove, hxlose⟩
    have hAS : A ⊆ A ∪ T.map e := Finset.subset_union_left
    have hxH := move_mem_holes_of_completeOutside hcomplete hAS hxmove
    obtain ⟨i, hi⟩ := (hrange x).mp hxH
    have hiT : i ∉ T := by
      intro hiT
      apply hxmove.1
      rw [← hi]
      exact Finset.mem_union_right A (Finset.mem_map.mpr ⟨i, hiT, rfl⟩)
    have hsets : insert x (A ∪ T.map e) = A ∪ (insert i T).map e := by
      ext z
      simp [hi]
    have himove : FiniteBuildGame.Move (ParametrizedHoleValid (K := K) A e) T i := by
      refine ⟨hiT, ?_⟩
      change ProjectiveCap.Projective.Cap K (Fin 3 → K) (A ∪ (insert i T).map e)
      rw [← hsets]
      exact hxmove.2
    refine ⟨i, himove, fun hiwin => hxlose ?_⟩
    rw [hsets]
    exact (win_parametrizedHoles_iff e hcomplete hrange (insert i T)).mpr hiwin
  · rintro ⟨i, himove, hilose⟩
    let x : Point K := e i
    have hxiH : x ∈ H := (hrange x).mpr ⟨i, rfl⟩
    have hxiA : x ∉ A := fun hxiA =>
      (Finset.disjoint_left.mp hcomplete.2.1) hxiA hxiH
    have hxiMap : x ∉ T.map e := by
      intro hxmap
      obtain ⟨j, hjT, hji⟩ := Finset.mem_map.mp hxmap
      have hji' : j = i := e.injective hji
      exact himove.1 (hji' ▸ hjT)
    have hxFresh : x ∉ A ∪ T.map e := by
      intro hx
      rcases Finset.mem_union.mp hx with hxA | hxMap
      · exact hxiA hxA
      · exact hxiMap hxMap
    have hsets : insert x (A ∪ T.map e) = A ∪ (insert i T).map e := by
      ext z
      simp [x]
    have hxmove : FiniteBuildGame.Move
        (ProjectiveCap.Projective.Cap K (Fin 3 → K)) (A ∪ T.map e) x := by
      refine ⟨hxFresh, ?_⟩
      rw [hsets]
      exact himove.2
    refine ⟨x, hxmove, fun hxwin => hilose ?_⟩
    rw [hsets] at hxwin
    exact (win_parametrizedHoles_iff e hcomplete hrange (insert i T)).mp hxwin
termination_by Fintype.card I - T.card
decreasing_by
  · have hcard : (insert i T).card = T.card + 1 := Finset.card_insert_of_notMem hiT
    have hle : T.card + 1 ≤ Fintype.card I := by
      rw [← hcard]
      exact Finset.card_le_univ _
    rw [hcard]
    omega
  · have hcard : (insert i T).card = T.card + 1 :=
      Finset.card_insert_of_notMem himove.1
    have hle : T.card + 1 ≤ Fintype.card I := by
      rw [← hcard]
      exact Finset.card_le_univ _
    rw [hcard]
    omega

/-- P-positions transport across the exact parametrized-hole localization bridge. -/
theorem isP_parametrizedHoles_iff {A H : Finset (Point K)} (e : I ↪ Point K)
    (hcomplete : CompleteOutside (L := Point K) A H)
    (hrange : ∀ x : Point K, x ∈ H ↔ ∃ i : I, e i = x)
    (T : Finset I) :
    FiniteBuildGame.IsP (ProjectiveCap.Projective.Cap K (Fin 3 → K)) (A ∪ T.map e) ↔
      FiniteBuildGame.IsP (ParametrizedHoleValid (K := K) A e) T :=
  not_congr (win_parametrizedHoles_iff e hcomplete hrange T)

end GameLocalization

end ProjectiveBridge
end RelativeConicArcs
