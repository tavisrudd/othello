import ProjectiveCap.Grid
import CapGame.BuildGame
import Mathlib.Data.Finset.Card

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

/-- Legal residual-grid move. -/
abbrev Move (S : Finset (GridPoint K)) (x : GridPoint K) : Prop :=
  FiniteBuildGame.Move (GridCap (K := K)) S x

theorem mem_legalExtensions {S : Finset (GridPoint K)} {x : GridPoint K} :
    x ∈ LegalExtensions (K := K) S ↔ x ∉ S ∧ GridCap (insert x S) :=
  FiniteBuildGame.mem_legalExtensions

/-- Normal-play residual grid-game win predicate. -/
abbrev Win (S : Finset (GridPoint K)) : Prop :=
  FiniteBuildGame.Win (GridCap (K := K)) S

/-- Residual grid P-position predicate. -/
abbrev IsP (S : Finset (GridPoint K)) : Prop :=
  FiniteBuildGame.IsP (GridCap (K := K)) S

/-- N-position iff some legal residual-grid move reaches a P-position. -/
theorem win_iff_exists_isP_child {S : Finset (GridPoint K)} :
    Win (K := K) S ↔ ∃ x : GridPoint K, Move (K := K) S x ∧ IsP (K := K) (insert x S) :=
  FiniteBuildGame.win_iff_exists_isP_child

/-- P-position iff all legal residual-grid children are N-positions. -/
theorem isP_iff_all_children_win {S : Finset (GridPoint K)} :
    IsP (K := K) S ↔ ∀ x : GridPoint K, Move (K := K) S x -> Win (K := K) (insert x S) :=
  FiniteBuildGame.isP_iff_all_children_win

/-- Legal children of `S` that are P-positions in the residual grid game. -/
noncomputable def EscapeExtensions (S : Finset (GridPoint K)) : Finset (GridPoint K) := by
  classical
  exact (LegalExtensions (K := K) S).filter fun p => IsP (K := K) (insert p S)

/-- Legal children of `S` that are N-positions in the residual grid game. -/
noncomputable def BadExtensions (S : Finset (GridPoint K)) : Finset (GridPoint K) := by
  classical
  exact (LegalExtensions (K := K) S).filter fun p => ¬ IsP (K := K) (insert p S)

theorem mem_escapeExtensions {S : Finset (GridPoint K)} {p : GridPoint K} :
    p ∈ EscapeExtensions (K := K) S ↔
      p ∈ LegalExtensions (K := K) S ∧ IsP (K := K) (insert p S) := by
  classical
  simp [EscapeExtensions]

theorem mem_badExtensions {S : Finset (GridPoint K)} {p : GridPoint K} :
    p ∈ BadExtensions (K := K) S ↔
      p ∈ LegalExtensions (K := K) S ∧ ¬ IsP (K := K) (insert p S) := by
  classical
  simp [BadExtensions]

/-- Legal residual-grid children split into game-valued escape and bad children. -/
theorem legalExtensions_card_eq_escape_add_bad (S : Finset (GridPoint K)) :
    (LegalExtensions (K := K) S).card =
      (EscapeExtensions (K := K) S).card + (BadExtensions (K := K) S).card := by
  classical
  unfold EscapeExtensions BadExtensions
  exact (Finset.card_filter_add_card_filter_not
    (s := LegalExtensions (K := K) S)
    (p := fun p => IsP (K := K) (insert p S))).symm

/-- The odd-plane escape target using the real residual-game P predicate. -/
def OddEscapeStatement : Prop :=
  ∀ S : Finset (GridPoint K),
    S.card = 3 ->
    GridCap S ->
    ∃ p : GridPoint K,
      p ∈ LegalExtensions (K := K) S ∧ IsP (insert p S)

/-- Odd escape is equivalently nonemptiness of the game-valued escape set. -/
theorem oddEscapeStatement_iff_escapeExtensions_nonempty :
    OddEscapeStatement (K := K) ↔
      ∀ S : Finset (GridPoint K),
        S.card = 3 -> GridCap S -> (EscapeExtensions (K := K) S).Nonempty := by
  constructor
  · intro h S hcard hcap
    rcases h S hcard hcap with ⟨p, hpLegal, hpP⟩
    exact ⟨p, mem_escapeExtensions.mpr ⟨hpLegal, hpP⟩⟩
  · intro h S hcard hcap
    rcases h S hcard hcap with ⟨p, hp⟩
    exact ⟨p, mem_escapeExtensions.mp hp⟩

end GridGame
end ProjectiveCap
