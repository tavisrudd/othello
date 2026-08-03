import ProjectiveCap.PlaneTransitivity
import ProjectiveCap.PlaneAffineChart
import ProjectiveCap.PlaneTransitivityGame
import ProjectiveCap.GridGame
import ProjectiveCap.GridSeed
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Tactic

/-!
# Frame-to-grid bridge interface

This module isolates the WP-1 proof obligation from the projective-cap plan.
After two projective directions are fixed, the remaining affine chart should be
equivalent to the residual grid game with the two burned parallel classes.

The coordinate construction and validity bridge are proved in the standard
coordinate model.  The game-theoretic consequence is isolated separately:
normal-play values transport from the fixed projective residual to the residual
grid game through any `FrameGridBridge`.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

variable (K V A : Type*) [Field K] [AddCommGroup V] [Module K V]
variable [Fintype K] [DecidableEq K] [DecidableEq (Point K V)]

/--
Data for the residual projective-to-grid bridge.

`fixed` is the already-played projective prefix, normally the two burned
directions.  `A` is the affine-chart board inside projective space.  The
load-bearing field is `valid_iff_grid`: adjoining the fixed projective prefix to
the image of a grid position is a projective cap exactly when the grid position
is a residual `GridCap`.
-/
structure FrameGridBridge where
  fixed : Finset (Point K V)
  toAffine : GridPoint K ≃ A
  project : A ↪ Point K V
  valid_iff_grid : ∀ S : Finset (GridPoint K),
    Cap K V (fixed ∪ ((S.map toAffine.toEmbedding).map project)) ↔ GridCap S

namespace FrameGridBridge

variable {K V A}
variable [Fintype A] [DecidableEq A]

/-- The finite building-game validity predicate on the affine-chart board, with
the fixed projective prefix always adjoined. -/
def FixedValid (B : FrameGridBridge K V A) (T : Finset A) : Prop :=
  Cap K V (B.fixed ∪ T.map B.project)

/-- The projective frame represented by a bridge and the normalized residual
seed `{(0,0),(1,1)}`. -/
def projectiveFrame (B : FrameGridBridge K V A) : Finset (Point K V) :=
  B.fixed ∪ ((StandardResidualSeed (K := K)).map B.toAffine.toEmbedding).map B.project

omit [Fintype K] [DecidableEq K] [Fintype A] [DecidableEq A] in
theorem fixedValid_image_iff_grid (B : FrameGridBridge K V A)
    (S : Finset (GridPoint K)) :
    FixedValid B (S.map B.toAffine.toEmbedding) ↔ GridCap S :=
  B.valid_iff_grid S

/--
WP-1 game-value consequence: a completed frame-grid bridge transports the
normal-play value of every residual grid position to the corresponding
fixed-prefix projective residual position.
-/
theorem win_fixedValid_iff_grid (B : FrameGridBridge K V A)
    (S : Finset (GridPoint K)) :
    FiniteBuildGame.Win (FixedValid B) (S.map B.toAffine.toEmbedding) ↔
      GridGame.Win (K := K) S :=
  FiniteBuildGame.win_equiv (α := GridPoint K) (β := A)
    (Validα := GridCap (K := K)) (Validβ := FixedValid B)
    B.toAffine B.valid_iff_grid S

/-- The P-position form of `win_fixedValid_iff_grid`. -/
theorem isP_fixedValid_iff_grid (B : FrameGridBridge K V A)
    (S : Finset (GridPoint K)) :
    FiniteBuildGame.IsP (FixedValid B) (S.map B.toAffine.toEmbedding) ↔
      GridGame.IsP (K := K) S :=
  FiniteBuildGame.isP_equiv (α := GridPoint K) (β := A)
    (Validα := GridCap (K := K)) (Validβ := FixedValid B)
    B.toAffine B.valid_iff_grid S

/-- The normalized projective frame has the residual-grid value of
`StandardResidualSeed`. -/
theorem isP_projectiveFrame_iff_standardResidualSeed (B : FrameGridBridge K V A) :
    FiniteBuildGame.IsP (FixedValid B)
        ((StandardResidualSeed (K := K)).map B.toAffine.toEmbedding) ↔
      GridGame.IsP (K := K) (StandardResidualSeed (K := K)) :=
  isP_fixedValid_iff_grid B (StandardResidualSeed (K := K))

/-- Statement target for WP-1: construct an affine-chart board and a bridge. -/
def Statement : Prop :=
  Nonempty (FrameGridBridge K V (GridPoint K))

end FrameGridBridge

namespace FrameGridBridge
namespace Coordinate

variable {K : Type*} [Field K]
variable [DecidableEq (Point K (PlaneVec K))]

/-- After the two coordinate directions are fixed, every legal full-projective
move is represented by a fresh affine-grid move. -/
theorem projectiveMove_exists_gridMove [Fintype K] [DecidableEq K]
    {S : Finset (GridPoint K)} {x : Point K (PlaneVec K)}
    (hxmove : FiniteBuildGame.Move (Cap K (PlaneVec K))
      (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) x) :
    ∃ p : GridPoint K, x = affinePoint (K := K) p ∧ GridGame.Move (K := K) S p := by
  rcases point_eq_affine_or_collinear_row_col (K := K) x with ⟨p, hxaff⟩ | hline
  · subst x
    have hpnot : p ∉ S := by
      intro hp
      exact hxmove.1 (Finset.mem_union_right _
        (affinePoint_mem_map (K := K) hp))
    have hcap :
        Cap K (PlaneVec K)
          (fixedDirections (K := K) ∪ (insert p S).map (affineEmbedding (K := K))) := by
      simpa [insert_affine_fixed_union_image (K := K) (S := S) p] using hxmove.2
    have hgrid : GridCap (K := K) (insert p S) :=
      gridCap_of_projectiveCap (K := K) hcap
    exact ⟨p, rfl, ⟨hpnot, hgrid⟩⟩
  · exfalso
    have hrowOld :
        rowDirection (K := K) ∈
          fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
      Finset.mem_union_left _ (rowDirection_mem_fixedDirections (K := K))
    have hcolOld :
        colDirection (K := K) ∈
          fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
      Finset.mem_union_left _ (colDirection_mem_fixedDirections (K := K))
    have hrowMem :
        rowDirection (K := K) ∈
          insert x (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) :=
      Finset.mem_insert_of_mem hrowOld
    have hcolMem :
        colDirection (K := K) ∈
          insert x (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) :=
      Finset.mem_insert_of_mem hcolOld
    have hxMem :
        x ∈ insert x (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) :=
      Finset.mem_insert_self _ _
    have hx_ne_row : x ≠ rowDirection (K := K) := by
      intro h
      exact hxmove.1 (h ▸ hrowOld)
    have hx_ne_col : x ≠ colDirection (K := K) := by
      intro h
      exact hxmove.1 (h ▸ hcolOld)
    exact hxmove.2 hrowMem hcolMem hxMem
      (rowDirection_ne_colDirection (K := K))
      (Ne.symm hx_ne_row) (Ne.symm hx_ne_col) hline

/-- Every legal residual-grid move gives the corresponding legal full-projective
move from the fixed coordinate-direction prefix. -/
theorem gridMove_to_projectiveMove [Fintype K] [DecidableEq K]
    {S : Finset (GridPoint K)} {p : GridPoint K}
    (hpmove : GridGame.Move (K := K) S p) :
    FiniteBuildGame.Move (Cap K (PlaneVec K))
      (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)))
      (affinePoint (K := K) p) := by
  constructor
  · intro hpold
    rcases mem_fixed_union_image_cases (K := K) hpold with hrow | hcol | ⟨q, hq, hpq⟩
    · exact affinePoint_ne_rowDirection (K := K) p hrow
    · exact affinePoint_ne_colDirection (K := K) p hcol
    · exact hpmove.1 (((affinePoint_injective (K := K)) hpq).symm ▸ hq)
  · have hcap :
        Cap K (PlaneVec K)
          (fixedDirections (K := K) ∪ (insert p S).map (affineEmbedding (K := K))) :=
      projectiveCap_of_gridCap (K := K) hpmove.2
    simpa [insert_affine_fixed_union_image (K := K) (S := S) p] using hcap

/-- The fixed-prefix full projective game has the same normal-play value as
the residual grid game.  The proof uses `projectiveMove_exists_gridMove` to
show that the full board has no legal non-affine continuations after the two
coordinate directions have been played. -/
theorem win_fixedDirections_iff_grid [Fintype K] [DecidableEq K]
    [Fintype (Point K (PlaneVec K))]
    (S : Finset (GridPoint K)) :
    FiniteBuildGame.Win (Cap K (PlaneVec K))
        (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) ↔
      GridGame.Win (K := K) S := by
  change FiniteBuildGame.Win (Cap K (PlaneVec K))
        (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) ↔
      FiniteBuildGame.Win (GridCap (K := K)) S
  rw [FiniteBuildGame.win_iff_exists_move, FiniteBuildGame.win_iff_exists_move]
  constructor
  · rintro ⟨x, hxmove, hxlose⟩
    rcases projectiveMove_exists_gridMove (K := K) (S := S) hxmove with
      ⟨p, hxaff, hpmove⟩
    refine ⟨p, hpmove, ?_⟩
    intro hgridWin
    subst x
    exact hxlose (by
      simpa [insert_affine_fixed_union_image (K := K) (S := S) p] using
        (win_fixedDirections_iff_grid (insert p S)).mpr hgridWin)
  · rintro ⟨p, hpmove, hpLose⟩
    refine ⟨affinePoint (K := K) p, gridMove_to_projectiveMove (K := K) hpmove, ?_⟩
    intro hprojWin
    apply hpLose
    exact (win_fixedDirections_iff_grid (insert p S)).mp (by
      simpa [insert_affine_fixed_union_image (K := K) (S := S) p] using hprojWin)
termination_by Fintype.card (GridPoint K) - S.card
decreasing_by
  · classical
    have hp : p ∉ S := hpmove.1
    have hcard : (insert p S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hp
    have hlt : S.card < Fintype.card (GridPoint K) := by
      have hsubset : S ⊆ (Finset.univ : Finset (GridPoint K)) := by
        intro y _
        exact Finset.mem_univ y
      have hproper : S ⊂ (Finset.univ : Finset (GridPoint K)) :=
        (Finset.ssubset_iff_of_subset hsubset).mpr ⟨p, Finset.mem_univ p, hp⟩
      simpa using Finset.card_lt_card hproper
    rw [hcard]
    omega
  · classical
    have hp : p ∉ S := hpmove.1
    have hcard : (insert p S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hp
    have hlt : S.card < Fintype.card (GridPoint K) := by
      have hsubset : S ⊆ (Finset.univ : Finset (GridPoint K)) := by
        intro y _
        exact Finset.mem_univ y
      have hproper : S ⊂ (Finset.univ : Finset (GridPoint K)) :=
        (Finset.ssubset_iff_of_subset hsubset).mpr ⟨p, Finset.mem_univ p, hp⟩
      simpa using Finset.card_lt_card hproper
    rw [hcard]
    omega

/-- P-position form of `win_fixedDirections_iff_grid`. -/
theorem isP_fixedDirections_iff_grid [Fintype K] [DecidableEq K]
    [Fintype (Point K (PlaneVec K))]
    (S : Finset (GridPoint K)) :
    FiniteBuildGame.IsP (Cap K (PlaneVec K))
        (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) ↔
      GridGame.IsP (K := K) S :=
  not_congr (win_fixedDirections_iff_grid S)

/--
Concrete coordinate bridge for WP-1: the projective cap condition with the two
direction points adjoined is exactly the residual grid cap condition.
-/
def ValidityStatement [Fintype K] [DecidableEq K] : Prop :=
  ∀ S : Finset (GridPoint K),
    Cap K (PlaneVec K) (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) ↔
      GridCap S

/-- The coordinate frame-to-grid validity bridge. -/
theorem validityStatement [Fintype K] [DecidableEq K] :
    ValidityStatement (K := K) := by
  intro S
  constructor
  · exact gridCap_of_projectiveCap (K := K)
  · exact projectiveCap_of_gridCap (K := K)

/-- The coordinate validity statement instantiates the abstract bridge. -/
noncomputable def bridgeOfValidity [Fintype K] [DecidableEq K]
    (h : ValidityStatement (K := K)) :
    FrameGridBridge K (PlaneVec K) (GridPoint K) where
  fixed := fixedDirections (K := K)
  toAffine := Equiv.refl (GridPoint K)
  project := affineEmbedding (K := K)
  valid_iff_grid := by
    intro S
    simpa using h S

theorem statement_of_validity [Fintype K] [DecidableEq K]
    (h : ValidityStatement (K := K)) :
    Statement (K := K) (V := PlaneVec K) := by
  exact ⟨bridgeOfValidity (K := K) h⟩

/-- The standard coordinate frame-grid bridge. -/
noncomputable def coordinateBridge [Fintype K] [DecidableEq K] :
    FrameGridBridge K (PlaneVec K) (GridPoint K) :=
  bridgeOfValidity (K := K) (validityStatement (K := K))

/-- WP-1 completed in the standard coordinate projective plane. -/
theorem coordinateStatement [Fintype K] [DecidableEq K] :
    Statement (K := K) (V := PlaneVec K) :=
  statement_of_validity (K := K) (validityStatement (K := K))

end Coordinate
end FrameGridBridge

end Projective
end ProjectiveCap
