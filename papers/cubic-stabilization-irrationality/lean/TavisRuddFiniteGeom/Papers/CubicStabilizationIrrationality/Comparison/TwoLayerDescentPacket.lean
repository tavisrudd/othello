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

A second obstruction uses external freeness instead of fixedness.  A regular
source point cannot map equivariantly to a target with no externally free
point.  This permits target packets with nontrivial actions through proper
quotients of the external group.

The weakest obstruction in this module records the complete stabilizer of one
source point under an arbitrary loop group.  An equivariant stable-ledger
bijection must carry that point to a point with the same stabilizer.  This
formulation does not require a cyclic quotient action to split.

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

/-- A point is externally free when only the identity in the external
subgroup fixes it.  The internal factor is held at the identity. -/
def IsExternallyFree
    (Gext : Type uExt) (Gint : Type uInt) {A : Type uA}
    [Group Gext] [Group Gint] [MulAction (Gext × Gint) A]
    (x : A) : Prop :=
  ∀ g : Gext,
    ((g, (1 : Gint)) : Gext × Gint) • x = x → g = 1

/-- Two points in possibly different `G`-sets have the same stabilizer when
exactly the same group elements fix them. -/
def HasSameStabilizer
    (G : Type*) {A B : Type*}
    [Group G] [MulAction G A] [MulAction G B]
    (x : A) (y : B) : Prop :=
  ∀ g : G, g • x = x ↔ g • y = y

/-- An equivariant equivalence preserves the full stabilizer of every point. -/
theorem hasSameStabilizer_map
    {G : Type*} {A B : Type*}
    [Group G] [MulAction G A] [MulAction G B]
    (equivalence : EquivariantEquiv G A B) (x : A) :
    HasSameStabilizer G x (equivalence.toEquiv x) := by
  intro g
  constructor
  · intro fixed
    calc
      g • equivalence.toEquiv x = equivalence.toEquiv (g • x) :=
        (equivalence.map_smul g x).symm
      _ = equivalence.toEquiv x := congrArg equivalence.toEquiv fixed
  · intro fixed
    apply equivalence.toEquiv.injective
    calc
      equivalence.toEquiv (g • x) = g • equivalence.toEquiv x :=
        equivalence.map_smul g x
      _ = equivalence.toEquiv x := fixed

/-- A point fixed by a nonidentity external element is not externally free. -/
theorem not_externallyFree_of_nontrivial_stabilizer
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA}
    [Group Gext] [Group Gint] [MulAction (Gext × Gint) A]
    (x : A) {g : Gext} (g_ne_one : g ≠ 1)
    (fixed : ((g, (1 : Gint)) : Gext × Gint) • x = x) :
    ¬ IsExternallyFree Gext Gint x := by
  intro free
  exact g_ne_one (free g fixed)

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

/-- Every point of an external-regular packet is externally free. -/
theorem externalRegularPacket_isExternallyFree
    {Gext : Type uExt} {Gint : Type uInt} {A : Type uA}
    [Group Gext] [Group Gint] [MulAction Gint A]
    (x : ExternalRegularPacket Gext A) :
    IsExternallyFree Gext Gint x := by
  intro g fixed
  have equality := congrArg ExternalRegularPacket.external fixed
  change g * x.external = x.external at equality
  apply mul_right_cancel (b := x.external)
  simpa using equality

/-- Equivariant equivalences preserve external freeness. -/
theorem externallyFree_map
    {Gext : Type uExt} {Gint : Type uInt} {A B : Type*}
    [Group Gext] [Group Gint]
    [MulAction (Gext × Gint) A] [MulAction (Gext × Gint) B]
    (equivalence : EquivariantEquiv (Gext × Gint) A B)
    {x : A} (free : IsExternallyFree Gext Gint x) :
    IsExternallyFree Gext Gint (equivalence.toEquiv x) := by
  intro g fixed
  apply free g
  apply equivalence.toEquiv.injective
  calc
    equivalence.toEquiv
        (((g, (1 : Gint)) : Gext × Gint) • x) =
        ((g, (1 : Gint)) : Gext × Gint) • equivalence.toEquiv x :=
      equivalence.map_smul (g, (1 : Gint)) x
    _ = equivalence.toEquiv x := fixed

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

/--
Adding an arbitrary correction ledger to the regular source packet cannot
produce a target ledger with no externally free point.  Target points may
carry nontrivial external actions through proper quotients; pointwise
external triviality is not required.
-/
theorem externalRegularSum_not_equivariantlyEquivalent_withoutExternallyFreePoint
    {Gext : Type uExt} {Gint : Type uInt}
    {A : Type uA} {B C : Type*}
    [Group Gext] [Group Gint]
    [MulAction Gint A]
    [MulAction (Gext × Gint) B] [MulAction (Gext × Gint) C]
    (a : A) (targetHasNoFreePoint : ∀ y : C, ¬ IsExternallyFree Gext Gint y) :
    ¬ Nonempty
      (EquivariantEquiv (Gext × Gint)
        (ExternalRegularPacket Gext A ⊕ B) C) := by
  rintro ⟨equivalence⟩
  let x : ExternalRegularPacket Gext A := ⟨1, a⟩
  let sourcePoint : ExternalRegularPacket Gext A ⊕ B := Sum.inl x
  have sourceFree : IsExternallyFree Gext Gint sourcePoint := by
    intro g fixed
    change Sum.inl (((g, (1 : Gint)) : Gext × Gint) • x) = Sum.inl x at fixed
    exact externalRegularPacket_isExternallyFree x g (Sum.inl.inj fixed)
  exact targetHasNoFreePoint (equivalence.toEquiv sourcePoint)
    (externallyFree_map equivalence sourceFree)

/--
An arbitrary source witness, together with any correction ledger, cannot be
equivariantly identified with a target ledger containing no point with the
same loop stabilizer.  This uses the original loop group directly; no quotient
action or splitting of a cyclic extension is assumed.
-/
theorem sourceSum_not_equivariantlyEquivalent_withoutSameStabilizer
    {G : Type*} {A B C : Type*}
    [Group G] [MulAction G A] [MulAction G B] [MulAction G C]
    (x : A)
    (targetHasDifferentStabilizer :
      ∀ y : C, ¬ HasSameStabilizer G (Sum.inl x : A ⊕ B) y) :
    ¬ Nonempty (EquivariantEquiv G (A ⊕ B) C) := by
  rintro ⟨equivalence⟩
  exact targetHasDifferentStabilizer (equivalence.toEquiv (Sum.inl x))
    (hasSameStabilizer_map equivalence (Sum.inl x))

/--
An equivariant stable-ledger equivalence is impossible when every target point
has some loop element whose fixedness differs from that of the chosen source
point.  The distinguishing loop element may depend on the target point.  This
is a witness-oriented form of stabilizer separation suited to finite
computation: it does not require materializing either full stabilizer.
-/
theorem sourceSum_not_equivariantlyEquivalent_of_fixednessFingerprintSeparated
    {G : Type*} {A B C : Type*}
    [Group G] [MulAction G A] [MulAction G B] [MulAction G C]
    (x : A)
    (targetSeparated :
      ∀ y : C, ∃ g : G,
        ¬ (g • (Sum.inl x : A ⊕ B) = Sum.inl x ↔ g • y = y)) :
    ¬ Nonempty (EquivariantEquiv G (A ⊕ B) C) := by
  rintro ⟨equivalence⟩
  obtain ⟨g, separated⟩ :=
    targetSeparated (equivalence.toEquiv (Sum.inl x))
  exact separated
    (hasSameStabilizer_map equivalence (Sum.inl x) g)

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoLayerDescentPacket
