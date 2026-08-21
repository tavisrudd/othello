import Mathlib.Algebra.Group.Action.Defs
import Mathlib.Data.Set.Insert

/-!
# Descent packets with a group action

A unary correction is not automatically a fixed point of a descent action.
It becomes fixed only when its singleton summand is stable under that action.
This module isolates that hypothesis and the elementary obstruction separating
a regular orbit from three fixed points.

The results are set-level algebra. They do not construct the deck action on a
quantum differential module or prove that a blow-up comparison preserves its
ambient and exceptional summands.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.DescentPacket

universe uG uA uB

/-- An element fixed by every member of a group action. -/
def IsFixed
    (G : Type uG) {A : Type uA} [Group G] [MulAction G A] (x : A) : Prop :=
  ∀ g : G, g • x = x

/-- A stable singleton is pointwise fixed. This is the extra equivariance
hypothesis needed before a one-element correction may be called trivial under
the descent action. -/
theorem fixed_of_stable_singleton
    {G : Type uG} {A : Type uA} [Group G] [MulAction G A]
    (x : A) (stable : ∀ g : G, g • x ∈ ({x} : Set A)) :
    IsFixed G x := by
  intro g
  exact Set.mem_singleton_iff.mp (stable g)

/-- Three labelled points with the trivial action of `G`. -/
inductive FixedThree (G : Type uG) : Type
  | first
  | second
  | third
  deriving DecidableEq

instance fixedThreeSMul {G : Type uG} [Group G] : SMul G (FixedThree G) where
  smul _ x := x

instance fixedThreeMulAction {G : Type uG} [Group G] : MulAction G (FixedThree G) where
  one_smul _ := rfl
  mul_smul _ _ _ := rfl

/-- Every point of the three-point trivial action is fixed. -/
theorem fixedThree_isFixed
    {G : Type uG} [Group G] (x : FixedThree G) :
    IsFixed G x := by
  intro g
  rfl

/-- An equivariant equivalence of two `G`-sets. -/
structure EquivariantEquiv
    (G : Type uG) (A : Type uA) (B : Type uB)
  [Group G] [MulAction G A] [MulAction G B] where
  toEquiv : A ≃ B
  map_smul : ∀ (g : G) (x : A), toEquiv (g • x) = g • toEquiv x

/-- A one-copy outer packet retaining an arbitrary inner `G`-set. -/
structure UnaryPacket (G : Type uG) (A : Type uA) where
  value : A

instance unaryPacketSMul
    {G : Type uG} {A : Type uA} [Group G] [MulAction G A] :
    SMul G (UnaryPacket G A) where
  smul g x := ⟨g • x.value⟩

instance unaryPacketMulAction
    {G : Type uG} {A : Type uA} [Group G] [MulAction G A] :
    MulAction G (UnaryPacket G A) where
  one_smul x := by
    cases x with
    | mk value => exact congrArg UnaryPacket.mk (one_smul G value)
  mul_smul g h x := by
    cases x with
    | mk value => exact congrArg UnaryPacket.mk (mul_smul g h value)

/-- A unary outer constructor preserves the entire inner descent action. It
does not turn a nontrivial orbit into a fixed point. -/
def unaryPacketEquivariantEquiv
    {G : Type uG} {A : Type uA} [Group G] [MulAction G A] :
    EquivariantEquiv G (UnaryPacket G A) A where
  toEquiv :=
    { toFun := UnaryPacket.value
      invFun := UnaryPacket.mk
      left_inv := by intro x; cases x; rfl
      right_inv := by intro x; rfl }
  map_smul _ _ := rfl

/-- The left regular action of a nontrivial group has no fixed point. -/
theorem leftRegular_not_fixed
    {G : Type uG} [Group G] [Nontrivial G] (x : G) :
    ¬ IsFixed G x := by
  intro fixed
  obtain ⟨g, hg⟩ := exists_ne (1 : G)
  apply hg
  apply mul_right_cancel (b := x)
  simpa using fixed g

/-- A regular orbit is not equivariantly equivalent to three fixed points.
For a cyclic group of order three this distinguishes the free three-packet
from three copies after their action has been forgotten. -/
theorem regular_not_equivariantly_equivalent_fixedThree
    {G : Type uG} [Group G] [Nontrivial G] :
    ¬ Nonempty (EquivariantEquiv G G (FixedThree G)) := by
  rintro ⟨equivalence⟩
  let x : G := equivalence.toEquiv.symm FixedThree.first
  apply leftRegular_not_fixed x
  intro g
  apply equivalence.toEquiv.injective
  rw [equivalence.map_smul]
  rfl

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.DescentPacket
