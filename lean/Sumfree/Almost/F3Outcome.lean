import Sumfree.Game

/-!
# `F_3^n` outcome theorem

The former target in this file is now proved for any finite nontrivial
exponent-three additive commutative group by `Sumfree.Game.f3_initial_win`.
This module keeps stable cross-reference names for the prose notes.
-/

namespace Sumfree
namespace Almost

open Sumfree.Game

variable {V : Type*} [AddCommGroup V] [Fintype V] [DecidableEq V]

/-- Concrete post-opening theorem statement for the exponent-three sum-free game. -/
def F3PostOpeningStatement : Prop :=
  (∀ z : V, z + z + z = 0) -> ∀ ⦃o : V⦄, o ≠ 0 -> IsP ({o} : Finset V)

/-- Concrete root-outcome theorem statement for the exponent-three sum-free game. -/
def F3OutcomeStatement [Nontrivial V] : Prop :=
  (∀ z : V, z + z + z = 0) -> Win (∅ : Finset V)

theorem f3PostOpeningStatement_proved :
    F3PostOpeningStatement (V := V) := by
  intro hchar3 o ho0
  exact f3_postOpening_isP hchar3 ho0

theorem f3OutcomeStatement_proved [Nontrivial V] :
    F3OutcomeStatement (V := V) := by
  intro hchar3
  exact f3_initial_win hchar3

end Almost
end Sumfree
