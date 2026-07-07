import Sumfree.MirrorLemmas

/-!
# Almost target: the `F_3^n` outcome theorem

This file intentionally contains no theorem claim or trusted declaration.  It names the
global game-outcome target that should eventually be proved from the local
kernel `f3_affine_mirror_legal`, once the impartial sum-free game semantics are
formalized.
-/

namespace Sumfree
namespace Almost

/--
Minimal placeholder for a future sum-free game model.

The current formalization proves local legality of the affine mirror reply; it
does not yet define game positions, P/N values, or strategy soundness.
-/
structure OutcomeModel (G : Type*) where
  Position : Type*
  empty : Position
  afterOpening : G -> Position
  IsP : Position -> Prop
  IsN : Position -> Prop

/--
Target statement for the future global `F_3^n = N` theorem.

This is a statement stub only: the concrete `OutcomeModel` should later be
replaced by the actual finite-game semantics.
-/
def F3OutcomeTarget {V : Type*} [AddCommGroup V] (model : OutcomeModel V) : Prop :=
  model.IsN model.empty

/--
Target statement for the post-opening mirror strategy.

The intended proof input is `f3_affine_mirror_legal`; the missing part is the
generic theorem that a legal reply-preserving mirror strategy proves `N`.
-/
def F3PostOpeningMirrorTarget {V : Type*} [AddCommGroup V]
    (model : OutcomeModel V) : Prop :=
  ∀ ⦃o : V⦄, o ≠ 0 -> model.IsP (model.afterOpening o)

end Almost
end Sumfree
