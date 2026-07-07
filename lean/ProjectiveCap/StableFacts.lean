import ProjectiveCap.GridGame
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Fintype.Prod
import Mathlib.Data.Finset.Card

/-!
# Stable projective-cap statement stubs

This module contains buildable statements for the stable theorem layer.  It does
not assert the statements as theorems yet; each definition is a `Prop` target to
be proved after the surrounding finite-projective-plane vocabulary is complete.
-/

namespace ProjectiveCap
namespace Stable

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/-- Legal one-step extensions of a residual grid cap. -/
noncomputable def LegalGridExtensions (S : Finset (GridPoint K)) : Finset (GridPoint K) := by
  classical
  exact Finset.univ.filter fun p => p ∉ S ∧ GridCap (insert p S)

theorem legalGridExtensions_eq_gridGame (S : Finset (GridPoint K)) :
    LegalGridExtensions (K := K) S = GridGame.LegalExtensions (K := K) S := by
  classical
  ext p
  simp [LegalGridExtensions, GridGame.LegalExtensions,
    FiniteBuildGame.LegalExtensions, FiniteBuildGame.Move]

theorem mem_legalGridExtensions {S : Finset (GridPoint K)} {p : GridPoint K} :
    p ∈ LegalGridExtensions (K := K) S ↔ p ∉ S ∧ GridCap (K := K) (insert p S) := by
  classical
  simp [LegalGridExtensions]

/--
Target statement for the total size-three extension lemma:
every size-three residual grid cap has exactly `q^2 - 9q + 21` legal children.
-/
def SizeThreeExtensionCountStatement (K : Type*) [Field K] [Fintype K] [DecidableEq K] :
    Prop :=
  ∀ S : Finset (GridPoint K),
    S.card = 3 ->
    GridCap S ->
    ((LegalGridExtensions (K := K) S).card : Int) =
      (Fintype.card K : Int) ^ 2 - 9 * (Fintype.card K : Int) + 21

/--
Placeholder interface for the frame-reduction theorem.

The actual projective-plane position type and frame extraction still need to be
formalized.
-/
structure FrameReductionInterface where
  Position : Type*
  IsP : Position -> Prop
  frame : Position -> Position

/-- Target statement for the frame reduction `PG(2,q)=P iff frame=P`. -/
def FrameReductionStatement (I : FrameReductionInterface) : Prop :=
  ∀ P : I.Position, I.IsP P ↔ I.IsP (I.frame P)

end Stable
end ProjectiveCap
