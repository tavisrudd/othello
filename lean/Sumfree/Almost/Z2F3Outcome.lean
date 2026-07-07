import Sumfree.Z2F3Labels

/-!
# Almost target: `Z_2 x F_3^b`

The labelled pair-completion lemma is now formalized in `Sumfree.Z2F3Labels`.
This file keeps the remaining global game theorem separate until the game
semantics and the `s_2 = 1` reduction are formalized.
-/

namespace Sumfree
namespace Almost

/-- Placeholder interface for the future `Z_2 x F_3^b` game semantics. -/
structure Z2F3OutcomeModel (V : Type*) where
  Position : Type*
  empty : Position
  afterOrderTwoMove : Position
  IsP : Position -> Prop
  IsN : Position -> Prop

/--
Target statement for the theorem currently proved only in prose:
`empty` is a P-position in `Z_2 x F_3^b`.
-/
def Z2F3EmptyTarget {V : Type*} [AddCommGroup V]
    (model : Z2F3OutcomeModel V) : Prop :=
  model.IsP model.empty

/--
Intermediate target used by the prose proof: after the order-two move, the
mover can reach and maintain the labelled mirror invariant.
-/
def Z2F3ResidualTarget {V : Type*} [AddCommGroup V]
    (model : Z2F3OutcomeModel V) : Prop :=
  model.IsN model.afterOrderTwoMove

end Almost
end Sumfree
