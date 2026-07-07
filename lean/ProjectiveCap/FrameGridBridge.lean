import ProjectiveCap.Projective
import ProjectiveCap.GridGame
import ProjectiveCap.GridSeed
import Mathlib.Tactic

/-!
# Frame-to-grid bridge interface

This module isolates the WP-1 proof obligation from the projective-cap plan.
After two projective directions are fixed, the remaining affine chart should be
equivalent to the residual grid game with the two burned parallel classes.

The coordinate construction of the bridge is still deferred.  What is proved
here is the game-theoretic consequence: once the coordinate bridge supplies the
validity equivalence, normal-play values transport from the fixed projective
residual to the residual grid game.
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

/-- Coordinate model for the projective plane used by the residual-grid bridge. -/
abbrev PlaneVec (K : Type*) := Fin 3 -> K

def rowDirectionVec : PlaneVec K :=
  ![(1 : K), 0, 0]

def colDirectionVec : PlaneVec K :=
  ![(0 : K), 1, 0]

def affineVec (p : GridPoint K) : PlaneVec K :=
  ![p.1, p.2, (1 : K)]

theorem rowDirectionVec_ne_zero : rowDirectionVec (K := K) ≠ 0 := by
  intro h
  have h0 := congrFun h 0
  simp [rowDirectionVec] at h0

theorem colDirectionVec_ne_zero : colDirectionVec (K := K) ≠ 0 := by
  intro h
  have h1 := congrFun h 1
  simp [colDirectionVec] at h1

theorem affineVec_ne_zero (p : GridPoint K) : affineVec (K := K) p ≠ 0 := by
  intro h
  have h2 := congrFun h 2
  simp [affineVec] at h2

/-- The first burned direction in the normalized coordinate plane. -/
def rowDirection : Point K (PlaneVec K) :=
  Projectivization.mk K (rowDirectionVec (K := K)) rowDirectionVec_ne_zero

/-- The second burned direction in the normalized coordinate plane. -/
def colDirection : Point K (PlaneVec K) :=
  Projectivization.mk K (colDirectionVec (K := K)) colDirectionVec_ne_zero

/-- Affine chart point `(r,c) ↦ [r:c:1]`. -/
def affinePoint (p : GridPoint K) : Point K (PlaneVec K) :=
  Projectivization.mk K (affineVec (K := K) p) (affineVec_ne_zero p)

theorem rowDirection_ne_colDirection :
    rowDirection (K := K) ≠ colDirection (K := K) := by
  intro h
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (rowDirectionVec (K := K)) (colDirectionVec (K := K))
    rowDirectionVec_ne_zero colDirectionVec_ne_zero).mp h
  have h1 := congrFun ha 1
  have ha0 : a = 0 := by
    simpa [rowDirectionVec, colDirectionVec] using h1
  have h0 := congrFun ha 0
  simp [rowDirectionVec, colDirectionVec, ha0] at h0

theorem affinePoint_ne_rowDirection (p : GridPoint K) :
    affinePoint (K := K) p ≠ rowDirection (K := K) := by
  intro h
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (affineVec (K := K) p) (rowDirectionVec (K := K))
    (affineVec_ne_zero p) rowDirectionVec_ne_zero).mp h
  have h2 := congrFun ha 2
  simp [affineVec, rowDirectionVec] at h2

theorem affinePoint_ne_colDirection (p : GridPoint K) :
    affinePoint (K := K) p ≠ colDirection (K := K) := by
  intro h
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (affineVec (K := K) p) (colDirectionVec (K := K))
    (affineVec_ne_zero p) colDirectionVec_ne_zero).mp h
  have h2 := congrFun ha 2
  simp [affineVec, colDirectionVec] at h2

theorem affinePoint_injective : Function.Injective (affinePoint (K := K)) := by
  intro p q hpq
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (affineVec (K := K) p) (affineVec (K := K) q)
    (affineVec_ne_zero p) (affineVec_ne_zero q)).mp hpq
  have ha1 : a = 1 := by
    have h2 := congrFun ha 2
    simpa [affineVec] using h2
  have hrow : p.1 = q.1 := by
    have h0 := congrFun ha 0
    have h0' : q.1 = p.1 := by
      simpa [affineVec, ha1] using h0
    exact h0'.symm
  have hcol : p.2 = q.2 := by
    have h1 := congrFun ha 1
    have h1' : q.2 = p.2 := by
      simpa [affineVec, ha1] using h1
    exact h1'.symm
  exact Prod.ext hrow hcol

/-- The affine chart as an embedding into projective points. -/
def affineEmbedding : GridPoint K ↪ Point K (PlaneVec K) where
  toFun := affinePoint (K := K)
  inj' := affinePoint_injective (K := K)

variable [DecidableEq (Point K (PlaneVec K))]

/-- The fixed pair of burned directions in the standard coordinate model. -/
def fixedDirections : Finset (Point K (PlaneVec K)) :=
  ({rowDirection (K := K), colDirection (K := K)} : Finset (Point K (PlaneVec K)))

/--
Concrete coordinate statement still left for WP-1: the projective cap condition
with the two direction points adjoined is exactly the residual grid cap
condition.
-/
def ValidityStatement [Fintype K] [DecidableEq K] : Prop :=
  ∀ S : Finset (GridPoint K),
    Cap K (PlaneVec K) (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) ↔
      GridCap S

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

end Coordinate
end FrameGridBridge

end Projective
end ProjectiveCap
