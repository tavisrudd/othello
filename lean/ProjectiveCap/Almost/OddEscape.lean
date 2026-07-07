import ProjectiveCap.StableFacts

/-!
# Almost target: odd projective-plane escape theorem

This file isolates the central open/proof-search target from the stable grid
vocabulary.  It is a statement stub only: `IsP` is still an external game-value
predicate.
-/

namespace ProjectiveCap
namespace Almost

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/-- Placeholder for the future residual-game P-position predicate. -/
abbrev GridPPosition (K : Type*) [Field K] [Fintype K] [DecidableEq K] :=
  Finset (GridPoint K) -> Prop

/--
Target theorem for odd planes: every legal size-three residual position has a
legal size-four child that is a P-position.
-/
def OddEscapeStatement (IsP : GridPPosition K) : Prop :=
  ∀ S : Finset (GridPoint K),
    S.card = 3 ->
    GridCap S ->
    ∃ p : GridPoint K,
      p ∈ Stable.LegalGridExtensions (K := K) S ∧ IsP (insert p S)

end Almost
end ProjectiveCap
