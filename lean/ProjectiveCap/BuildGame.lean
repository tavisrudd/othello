import Mathlib.Data.Finset.Basic
import Mathlib.Tactic

/-!
# Finite normal-play building games

This is a small reusable kernel for games where a position is a finite set of
chosen objects and a move adds one fresh object while preserving a validity
predicate.  The cap achievement games are instances with `Valid = Cap`.
-/

namespace FiniteBuildGame

variable {α : Type*} [Fintype α] [DecidableEq α]

/-- A legal move adds a fresh element and leaves a valid position. -/
def Move (Valid : Finset α -> Prop) (S : Finset α) (x : α) : Prop :=
  x ∉ S ∧ Valid (insert x S)

/-- All legal one-point extensions of a position. -/
noncomputable def LegalExtensions (Valid : Finset α -> Prop) (S : Finset α) : Finset α := by
  classical
  exact Finset.univ.filter (fun x => Move Valid S x)

theorem mem_legalExtensions {Valid : Finset α -> Prop} {S : Finset α} {x : α} :
    x ∈ LegalExtensions Valid S ↔ Move Valid S x := by
  classical
  simp [LegalExtensions]

omit [DecidableEq α] in
private theorem card_lt_univ_of_notMem {S : Finset α} {x : α} (hx : x ∉ S) :
    S.card < Fintype.card α := by
  have hsubset : S ⊆ (Finset.univ : Finset α) := by
    intro y _; exact Finset.mem_univ y
  have hproper : S ⊂ (Finset.univ : Finset α) :=
    (Finset.ssubset_iff_of_subset hsubset).mpr ⟨x, Finset.mem_univ x, hx⟩
  simpa using Finset.card_lt_card hproper

/--
Normal-play win predicate for a finite building game.

The player to move wins from `S` iff there is a legal extension whose child is
losing for the next player.
-/
def Win (Valid : Finset α -> Prop) (S : Finset α) : Prop :=
  ∃ x : LegalExtensions Valid S, ¬ Win Valid (insert (x : α) S)
termination_by Fintype.card α - S.card
decreasing_by
  classical
  have hxmove : Move Valid S (x : α) := mem_legalExtensions.mp x.2
  have hx : (x : α) ∉ S := hxmove.1
  have hcard : (insert (x : α) S).card = S.card + 1 :=
    Finset.card_insert_of_notMem hx
  have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
  rw [hcard]
  omega

/-- A P-position is a position from which the next player has no winning move. -/
def IsP (Valid : Finset α -> Prop) (S : Finset α) : Prop :=
  ¬ Win Valid S

theorem win_iff_exists_move {Valid : Finset α -> Prop} {S : Finset α} :
    Win Valid S ↔ ∃ x : α, Move Valid S x ∧ ¬ Win Valid (insert x S) := by
  rw [Win.eq_def]
  constructor
  · rintro ⟨x, hxlose⟩
    exact ⟨x, mem_legalExtensions.mp x.2, hxlose⟩
  · rintro ⟨x, hxmove, hxlose⟩
    exact ⟨⟨x, mem_legalExtensions.mpr hxmove⟩, hxlose⟩

/-- The empty game is P if there are no legal first moves. -/
theorem isP_of_no_moves {Valid : Finset α -> Prop} {S : Finset α}
    (h : ∀ x : α, ¬ Move Valid S x) : IsP Valid S := by
  rw [IsP, win_iff_exists_move]
  rintro ⟨x, hx, _⟩
  exact h x hx

/-- A single certified move to a P-position proves an N-position. -/
theorem win_of_move_to_isP {Valid : Finset α -> Prop} {S : Finset α} {x : α}
    (hx : Move Valid S x) (hchild : IsP Valid (insert x S)) : Win Valid S := by
  rw [win_iff_exists_move]
  exact ⟨x, hx, hchild⟩

end FiniteBuildGame
