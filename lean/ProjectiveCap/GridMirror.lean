import ProjectiveCap.GridGame
import ProjectiveCap.GridSeed
import Mathlib.Tactic

/-!
# Characteristic-two residual grid mirror

This file starts WP-2: the residual grid game after the normalized projective
frame has a diagonal translation mirror in characteristic two.
-/

namespace ProjectiveCap
namespace GridMirror

variable {K : Type*} [Field K]

/-- Diagonal translation by `(1,1)` on the residual grid. -/
def diagTranslate (p : GridPoint K) : GridPoint K :=
  (p.1 + 1, p.2 + 1)

theorem diagTranslate_involutive (h2 : (2 : K) = 0) (p : GridPoint K) :
    diagTranslate (K := K) (diagTranslate (K := K) p) = p := by
  ext <;> dsimp [diagTranslate] <;> linear_combination h2

theorem diagTranslate_fpf (p : GridPoint K) :
    diagTranslate (K := K) p ≠ p := by
  intro h
  have h1 : p.1 + 1 = p.1 := congrArg Prod.fst h
  have hone : (1 : K) = 0 := by
    linear_combination h1
  exact one_ne_zero hone

theorem diagTranslate_row_ne (p : GridPoint K) :
    (diagTranslate (K := K) p).1 ≠ p.1 := by
  intro h
  change p.1 + 1 = p.1 at h
  have hone : (1 : K) = 0 := by
    linear_combination h
  exact one_ne_zero hone

theorem diagTranslate_col_ne (p : GridPoint K) :
    (diagTranslate (K := K) p).2 ≠ p.2 := by
  intro h
  change p.2 + 1 = p.2 at h
  have hone : (1 : K) = 0 := by
    linear_combination h
  exact one_ne_zero hone

/-- Diagonal translation as a grid equivalence in characteristic two. -/
def diagEquiv (h2 : (2 : K) = 0) : GridPoint K ≃ GridPoint K where
  toFun := diagTranslate (K := K)
  invFun := diagTranslate (K := K)
  left_inv := diagTranslate_involutive (K := K) h2
  right_inv := diagTranslate_involutive (K := K) h2

theorem diagEquiv_apply (h2 : (2 : K) = 0) (p : GridPoint K) :
    diagEquiv (K := K) h2 p = diagTranslate (K := K) p :=
  rfl

theorem collinear_diagTranslate_iff (_h2 : (2 : K) = 0) (p q r : GridPoint K) :
    Collinear (K := K) (diagTranslate (K := K) p)
      (diagTranslate (K := K) q) (diagTranslate (K := K) r) ↔
      Collinear (K := K) p q r := by
  unfold Collinear diagTranslate
  constructor <;> intro h <;> linear_combination h

theorem collinear_diagTranslate_left_iff (h2 : (2 : K) = 0) (p q r : GridPoint K) :
    Collinear (K := K) (diagTranslate (K := K) p) q r ↔
      Collinear (K := K) p (diagTranslate (K := K) q)
        (diagTranslate (K := K) r) := by
  have h := collinear_diagTranslate_iff (K := K) h2
    (diagTranslate (K := K) p) q r
  simpa [diagTranslate_involutive (K := K) h2 p] using h.symm

theorem collinear_with_mirror_forces_old_line (h2 : (2 : K) = 0)
    {x p : GridPoint K}
    (hcol : Collinear (K := K) x (diagTranslate (K := K) x) p) :
    Collinear (K := K) x p (diagTranslate (K := K) p) := by
  unfold Collinear diagTranslate at hcol ⊢
  linear_combination hcol + (p.1 - x.1 - p.2 + x.2) * h2

section Game

variable [DecidableEq K]

/-- A residual grid position symmetric under the characteristic-two diagonal mirror. -/
def DiagMirrorGood (h2 : (2 : K) = 0) (S : Finset (GridPoint K)) : Prop :=
  GridCap (K := K) S ∧ S.map (diagEquiv (K := K) h2).toEmbedding = S

theorem standardResidualSeed_diagMirrorGood (h2 : (2 : K) = 0) :
    DiagMirrorGood (K := K) h2 (StandardResidualSeed (K := K)) := by
  refine ⟨standardResidualSeed_gridCap (K := K), ?_⟩
  ext p
  simp only [Finset.mem_map, Equiv.toEmbedding_apply, diagEquiv_apply]
  constructor
  · rintro ⟨q, hq, rfl⟩
    simp only [StandardResidualSeed, Finset.mem_insert, Finset.mem_singleton] at hq ⊢
    rcases hq with rfl | rfl
    · right
      ext <;> simp [diagTranslate]
    · left
      ext <;> dsimp [diagTranslate] <;> linear_combination h2
  · intro hp
    simp only [StandardResidualSeed, Finset.mem_insert, Finset.mem_singleton] at hp
    rcases hp with rfl | rfl
    · refine ⟨((1 : K), (1 : K)), ?_, ?_⟩
      · simp [StandardResidualSeed]
      · ext <;> dsimp [diagTranslate] <;> linear_combination h2
    · refine ⟨((0 : K), (0 : K)), ?_, ?_⟩
      · simp [StandardResidualSeed]
      · ext <;> simp [diagTranslate]

end Game

end GridMirror
end ProjectiveCap
