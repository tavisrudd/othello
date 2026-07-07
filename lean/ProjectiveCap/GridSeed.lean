import ProjectiveCap.Grid
import Mathlib.Data.Finset.Card

/-!
# Standard residual grid seed

This module contains the small stable facts about the normalized residual seed
`{(0,0), (1,1)}` used by the projective frame-reduction story.
-/

namespace ProjectiveCap

variable {K : Type*} [Field K] [DecidableEq K]

/-- Normal residual size-two seed corresponding to a projective frame. -/
def StandardResidualSeed : Finset (GridPoint K) :=
  ({((0 : K), (0 : K)), ((1 : K), (1 : K))} : Finset (GridPoint K))

theorem standardResidualSeed_card :
    (StandardResidualSeed (K := K)).card = 2 := by
  classical
  simp [StandardResidualSeed, zero_ne_one]

theorem standardResidualSeed_rowSparse :
    RowSparse (K := K) (StandardResidualSeed (K := K)) := by
  intro p q hp hq hrow
  simp only [StandardResidualSeed, Finset.mem_insert, Finset.mem_singleton] at hp hq
  rcases hp with rfl | rfl <;> rcases hq with rfl | rfl
  · rfl
  · exact (zero_ne_one hrow).elim
  · exact (zero_ne_one hrow.symm).elim
  · rfl

theorem standardResidualSeed_colSparse :
    ColSparse (K := K) (StandardResidualSeed (K := K)) := by
  intro p q hp hq hcol
  simp only [StandardResidualSeed, Finset.mem_insert, Finset.mem_singleton] at hp hq
  rcases hp with rfl | rfl <;> rcases hq with rfl | rfl
  · rfl
  · exact (zero_ne_one hcol).elim
  · exact (zero_ne_one hcol.symm).elim
  · rfl

theorem standardResidualSeed_partialPermutation :
    PartialPermutation (K := K) (StandardResidualSeed (K := K)) :=
  ⟨standardResidualSeed_rowSparse, standardResidualSeed_colSparse⟩

theorem standardResidualSeed_affineCap :
    AffineCap (K := K) (StandardResidualSeed (K := K)) := by
  intro a b c ha hb hc hab hac hbc
  simp only [StandardResidualSeed, Finset.mem_insert, Finset.mem_singleton] at ha hb hc
  rcases ha with rfl | rfl <;> rcases hb with rfl | rfl <;> rcases hc with rfl | rfl
  · exact (hab rfl).elim
  · exact (hab rfl).elim
  · exact (hac rfl).elim
  · exact (hbc rfl).elim
  · exact (hbc rfl).elim
  · exact (hac rfl).elim
  · exact (hab rfl).elim
  · exact (hab rfl).elim

theorem standardResidualSeed_gridCap :
    GridCap (K := K) (StandardResidualSeed (K := K)) :=
  ⟨standardResidualSeed_partialPermutation, standardResidualSeed_affineCap⟩

end ProjectiveCap
