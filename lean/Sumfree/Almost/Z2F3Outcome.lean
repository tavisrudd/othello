import Sumfree.Z2F3Game

/-!
# `ZMod 2 × F_3^b` outcome theorem

The former placeholder target is now backed by the finite-game theorem
`Sumfree.Z2F3Game.initial_isP`.
-/

namespace Sumfree
namespace Almost

variable {V : Type*} [AddCommGroup V] [Fintype V] [DecidableEq V]

/-- Concrete statement: the order-two singleton is N after choosing any nonzero anchor. -/
def Z2F3ResidualStatement [Nontrivial V] : Prop :=
  (∀ z : V, z + z + z = 0) ->
    ∃ a : V, a ≠ 0 ∧
      Z2F3Game.Win ({LabelledPoint 0 1} : Finset (Z2V V))

/-- Concrete statement: the empty `ZMod 2 × V` game is P. -/
def Z2F3EmptyStatement [Nontrivial V] : Prop :=
  (∀ z : V, z + z + z = 0) ->
    Z2F3Game.IsP (∅ : Finset (Z2V V))

theorem z2f3ResidualStatement_proved [Nontrivial V] :
    Z2F3ResidualStatement (V := V) := by
  intro hchar3
  obtain ⟨a, ha0⟩ := exists_ne (0 : V)
  exact ⟨a, ha0, Z2F3Game.afterOrderTwo_win hchar3 ha0⟩

theorem z2f3EmptyStatement_proved [Nontrivial V] :
    Z2F3EmptyStatement (V := V) := by
  intro hchar3
  exact Z2F3Game.initial_isP hchar3

end Almost
end Sumfree
