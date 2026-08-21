import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.DescentPacket
import Mathlib.Algebra.Group.Prod
import Mathlib.Algebra.Group.Action.Sum

/-!
# Two-layer descent packets

Suppose a marked packet carries two independent group actions.  The first is
an external deck action introduced by a projective-bundle construction, while
the second is an arbitrary internal action already carried by the underlying
object.  Independence is represented by an action of the product group.

An externally trivial packet may retain any internal action.  Nevertheless,
every one of its points is fixed by the external subgroup.  By contrast, the
regular product packet has no externally fixed point when the external group
is nontrivial.  Hence the two packets cannot be equivariantly equivalent.

These are set-level implications.  They do not construct either action on a
quantum differential module, identify the two actions as independent, or prove
that a blow-up comparison is equivariant for their product.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoLayerDescentPacket

open DescentPacket

universe uExt uInt uA

/-- A packet with a phantom external group and an arbitrary internal carrier.
The product action below makes the external factor act trivially and preserves
the supplied internal action. -/
structure ExternalTrivialPacket (Gext : Type uExt) (A : Type uA) where
  value : A

/-- A packet with a regular external coordinate and an arbitrary internal
carrier.  The two factors act independently through the product group. -/
structure ExternalRegularPacket (Gext : Type uExt) (A : Type uA) where
  external : Gext
  internal : A

instance externalTrivialPacketSMul
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA}
    [Group Gext] [Group Gint] [MulAction Gint A] :
    SMul (Gext × Gint) (ExternalTrivialPacket Gext A) where
  smul g x := ⟨g.2 • x.value⟩

instance externalTrivialPacketMulAction
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA}
    [Group Gext] [Group Gint] [MulAction Gint A] :
    MulAction (Gext × Gint) (ExternalTrivialPacket Gext A) where
  one_smul x := by
    cases x with
    | mk value => exact congrArg ExternalTrivialPacket.mk (one_smul Gint value)
  mul_smul g h x := by
    cases x with
    | mk value => exact congrArg ExternalTrivialPacket.mk (mul_smul g.2 h.2 value)

instance externalRegularPacketSMul
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA}
    [Group Gext] [Group Gint] [MulAction Gint A] :
    SMul (Gext × Gint) (ExternalRegularPacket Gext A) where
  smul g x := ⟨g.1 * x.external, g.2 • x.internal⟩

instance externalRegularPacketMulAction
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA}
    [Group Gext] [Group Gint] [MulAction Gint A] :
    MulAction (Gext × Gint) (ExternalRegularPacket Gext A) where
  one_smul x := by
    cases x with
    | mk external internal =>
        change ExternalRegularPacket.mk (1 * external) (1 • internal) =
          ExternalRegularPacket.mk external internal
        rw [one_mul, one_smul]
  mul_smul g h x := by
    cases g with
    | mk gext gint =>
        cases h with
        | mk hext hint =>
            cases x with
            | mk external internal =>
                change
                  ExternalRegularPacket.mk ((gext * hext) * external)
                      ((gint * hint) • internal) =
                    ExternalRegularPacket.mk (gext * (hext * external))
                      (gint • hint • internal)
                rw [mul_assoc, mul_smul]

/-- A point is externally fixed when the subgroup `Gext × {1}` fixes it.
The internal factor may still act nontrivially. -/
def IsExternallyFixed
    (Gext : Type uExt) (Gint : Type uInt) {A : Type uA}
    [Group Gext] [Group Gint] [MulAction (Gext × Gint) A]
    (x : A) : Prop :=
  ∀ g : Gext, ((g, (1 : Gint)) : Gext × Gint) • x = x

/-- Every externally trivial packet is pointwise fixed by the external
subgroup, regardless of its internal action. -/
theorem externalTrivialPacket_isExternallyFixed
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA}
    [Group Gext] [Group Gint] [MulAction Gint A]
    (x : ExternalTrivialPacket Gext A) :
    IsExternallyFixed Gext Gint x := by
  unfold IsExternallyFixed
  intro g
  cases x with
  | mk value => exact congrArg ExternalTrivialPacket.mk (one_smul Gint value)

/-- The regular product packet has no externally fixed point when the
external group is nontrivial. -/
theorem regularProduct_not_externallyFixed
    {Gext : Type uExt} {Gint : Type uInt}
    [Group Gext] [Group Gint] [Nontrivial Gext]
    (x : Gext × Gint) :
    ¬ IsExternallyFixed Gext Gint x := by
  intro fixed
  unfold IsExternallyFixed at fixed
  obtain ⟨g, hg⟩ := exists_ne (1 : Gext)
  apply hg
  apply mul_right_cancel (b := x.1)
  have equality := congrArg Prod.fst (fixed g)
  simpa using equality

/-- A packet with a regular external coordinate has no externally fixed point,
independently of the action on its internal carrier. -/
theorem externalRegularPacket_not_externallyFixed
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA}
    [Group Gext] [Group Gint] [Nontrivial Gext] [MulAction Gint A]
    (x : ExternalRegularPacket Gext A) :
    ¬ IsExternallyFixed Gext Gint x := by
  intro fixed
  unfold IsExternallyFixed at fixed
  obtain ⟨g, hg⟩ := exists_ne (1 : Gext)
  apply hg
  apply mul_right_cancel (b := x.external)
  have equality := congrArg ExternalRegularPacket.external (fixed g)
  change g * x.external = x.external at equality
  simpa using equality

/-- A regular two-layer packet cannot be equivariantly identified with any
packet on which the external factor acts trivially.  The internal carrier may
have an arbitrary action, including its own regular orbit. -/
theorem regularProduct_not_equivariantlyEquivalent_externalTrivial
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA}
    [Group Gext] [Group Gint] [Nontrivial Gext] [MulAction Gint A]
    (a : A) :
    ¬ Nonempty
      (EquivariantEquiv (Gext × Gint) (Gext × Gint)
        (ExternalTrivialPacket Gext A)) := by
  rintro ⟨equivalence⟩
  let x : Gext × Gint := equivalence.toEquiv.symm ⟨a⟩
  apply regularProduct_not_externallyFixed x
  unfold IsExternallyFixed
  intro g
  apply equivalence.toEquiv.injective
  calc
    equivalence.toEquiv (((g, (1 : Gint)) : Gext × Gint) • x) =
        ((g, (1 : Gint)) : Gext × Gint) • equivalence.toEquiv x :=
      equivalence.map_smul (g, (1 : Gint)) x
    _ = equivalence.toEquiv x :=
      externalTrivialPacket_isExternallyFixed (equivalence.toEquiv x) g

/-- A packet with an independent regular external coordinate cannot be
equivariantly identified with any externally trivial packet.  This remains
true when both sides carry arbitrary, possibly nontrivial internal actions. -/
theorem externalRegular_not_equivariantlyEquivalent_externalTrivial
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA} {B : Type*}
    [Group Gext] [Group Gint] [Nontrivial Gext]
    [MulAction Gint A] [MulAction Gint B]
    (a : A) :
    ¬ Nonempty
      (EquivariantEquiv (Gext × Gint) (ExternalRegularPacket Gext A)
        (ExternalTrivialPacket Gext B)) := by
  rintro ⟨equivalence⟩
  let x : ExternalRegularPacket Gext A := ⟨1, a⟩
  apply externalRegularPacket_not_externallyFixed
    (Gext := Gext) (Gint := Gint) (A := A) x
  unfold IsExternallyFixed
  intro g
  apply equivalence.toEquiv.injective
  calc
    equivalence.toEquiv (((g, (1 : Gint)) : Gext × Gint) • x) =
        ((g, (1 : Gint)) : Gext × Gint) • equivalence.toEquiv x :=
      equivalence.map_smul (g, (1 : Gint)) x
    _ = equivalence.toEquiv x :=
      externalTrivialPacket_isExternallyFixed
        (Gext := Gext) (Gint := Gint) (A := B) (equivalence.toEquiv x) g

/-- Adding any externally trivial correction ledger to the regular source
packet does not remove the obstruction to an externally trivial target. -/
theorem externalRegularSum_not_equivariantlyEquivalent_externalTrivial
    {Gext : Type uExt} {Gint : Type uInt}
    {A : Type uA} {B C : Type*}
    [Group Gext] [Group Gint] [Nontrivial Gext]
    [MulAction Gint A] [MulAction Gint B] [MulAction Gint C]
    (a : A) :
    ¬ Nonempty
      (EquivariantEquiv (Gext × Gint)
        (ExternalRegularPacket Gext A ⊕ ExternalTrivialPacket Gext B)
        (ExternalTrivialPacket Gext C)) := by
  rintro ⟨equivalence⟩
  let x : ExternalRegularPacket Gext A := ⟨1, a⟩
  let sourcePoint :
      ExternalRegularPacket Gext A ⊕ ExternalTrivialPacket Gext B := Sum.inl x
  have sumFixed : IsExternallyFixed Gext Gint sourcePoint := by
    unfold IsExternallyFixed
    intro g
    apply equivalence.toEquiv.injective
    calc
      equivalence.toEquiv
          (((g, (1 : Gint)) : Gext × Gint) • sourcePoint) =
          ((g, (1 : Gint)) : Gext × Gint) •
            equivalence.toEquiv sourcePoint :=
        equivalence.map_smul (g, (1 : Gint)) sourcePoint
      _ = equivalence.toEquiv sourcePoint :=
        externalTrivialPacket_isExternallyFixed
          (Gext := Gext) (Gint := Gint) (A := C)
          (equivalence.toEquiv sourcePoint) g
  apply externalRegularPacket_not_externallyFixed
    (Gext := Gext) (Gint := Gint) (A := A) x
  unfold IsExternallyFixed
  intro g
  have equality := sumFixed g
  change Sum.inl (((g, (1 : Gint)) : Gext × Gint) • x) = Sum.inl x at equality
  exact Sum.inl.inj equality

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoLayerDescentPacket
