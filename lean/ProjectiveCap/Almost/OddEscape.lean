import ProjectiveCap.StableFacts
import ProjectiveCap.GridGame

/-!
# Almost target: odd projective-plane escape theorem

This file isolates the central open/proof-search target from the stable grid
vocabulary.  The legacy `OddEscapeStatement` permits an external P-position
predicate, while `OddEscapeGameStatement` is tied to the formal residual game in
`ProjectiveCap.GridGame`.
-/

namespace ProjectiveCap
namespace Almost

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/-- The abstract P-position predicate parameter for the *legacy* `OddEscapeStatement`
below (which permits an external P-predicate).  The concrete residual game is
`GridGame.IsP`; the game-tied target is `OddEscapeGameStatement`. -/
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

/--
The same escape target, now tied to the formal normal-play residual grid game.
This is still a target statement, not a theorem.
-/
def OddEscapeGameStatement : Prop :=
  GridGame.OddEscapeStatement (K := K)

theorem oddEscapeGameStatement_iff_escapeExtensions_nonempty :
    OddEscapeGameStatement (K := K) ↔
      ∀ S : Finset (GridPoint K),
        S.card = 3 -> GridCap S -> (GridGame.EscapeExtensions (K := K) S).Nonempty :=
  GridGame.oddEscapeStatement_iff_escapeExtensions_nonempty

end Almost
end ProjectiveCap
