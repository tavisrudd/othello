import ProjectiveCap.Grid
import ProjectiveCap.BuildGame

/-!
# Residual grid cap game

The projective-plane opening-pair reduction leaves a constrained affine grid
game.  This file gives that residual game the same normal-play interface as the
affine and projective cap games.
-/

namespace ProjectiveCap
namespace GridGame

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/-- Legal one-step extensions of a residual grid cap. -/
noncomputable def LegalExtensions (S : Finset (GridPoint K)) : Finset (GridPoint K) :=
  FiniteBuildGame.LegalExtensions (GridCap (K := K)) S

theorem mem_legalExtensions {S : Finset (GridPoint K)} {x : GridPoint K} :
    x ∈ LegalExtensions (K := K) S ↔ x ∉ S ∧ GridCap (insert x S) :=
  FiniteBuildGame.mem_legalExtensions

/-- Normal-play residual grid-game win predicate. -/
abbrev Win (S : Finset (GridPoint K)) : Prop :=
  FiniteBuildGame.Win (GridCap (K := K)) S

/-- Residual grid P-position predicate. -/
abbrev IsP (S : Finset (GridPoint K)) : Prop :=
  FiniteBuildGame.IsP (GridCap (K := K)) S

/-- The odd-plane escape target using the real residual-game P predicate. -/
def OddEscapeStatement : Prop :=
  ∀ S : Finset (GridPoint K),
    S.card = 3 ->
    GridCap S ->
    ∃ p : GridPoint K,
      p ∈ LegalExtensions (K := K) S ∧ IsP (insert p S)

end GridGame
end ProjectiveCap
