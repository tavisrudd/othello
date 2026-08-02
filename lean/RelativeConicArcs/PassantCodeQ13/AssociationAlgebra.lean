import RelativeConicArcs.PassantCodeQ13.Geometry

/-!
# Elliptic relations and concurrence colors over `ZMod 13`

For two internal points `u,v`, the normalized polar invariant is

`rho(u,v) = B(u,v)^2 / (Q(u) Q(v))`,

where `Q(X,Y,Z)=Y^2-XZ` and
`B(u,v)=2u_Yv_Y-u_Xv_Z-u_Zv_X`.  On distinct internal points its six values are
`0,1,3,9,10,12`.  These are the six elliptic relations used by the reconstruction argument.

This module defines the relations and a finite-certificate interface.  It does not assert the
q=13 intersection table or identify concurrence colors; those bounded leaves are supplied by a
certificate package and transported through `ConcurrenceRecoversRelations`.
-/

namespace RelativeConicArcs.PassantCodeQ13

open Finset

/-- The symmetric polar value associated with `Y^2-XZ`. -/
def polarValue (first second : Triple) : Field13 :=
  2 * first.y * second.y - first.x * second.z - first.z * second.x

/-- The projectively invariant elliptic parameter of two internal points. -/
def rho (first second : InternalPoint) : Field13 :=
  polarValue first.1 second.1 ^ 2 *
    (pointDiscriminant first.1 * pointDiscriminant second.1)⁻¹

/-- The six off-diagonal elliptic relation labels. -/
inductive EllipticRelation
  | rhoZero
  | rhoOne
  | rhoThree
  | rhoNine
  | rhoTen
  | rhoTwelve
deriving DecidableEq, Fintype, Repr

/-- The field value represented by an elliptic relation label. -/
def EllipticRelation.value : EllipticRelation → Field13
  | .rhoZero => 0
  | .rhoOne => 1
  | .rhoThree => 3
  | .rhoNine => 9
  | .rhoTen => 10
  | .rhoTwelve => 12

/-- Membership of an ordered pair in one off-diagonal elliptic relation. -/
def HasRelation (relation : EllipticRelation) (first second : InternalPoint) : Prop :=
  first ≠ second ∧ rho first second = relation.value

instance (relation : EllipticRelation) : DecidableRel (HasRelation relation) :=
  fun first second =>
    if pointsEqual : first = second then isFalse fun relationProof => relationProof.1 pointsEqual
    else
      if valuesEqual : rho first second = relation.value then isTrue ⟨pointsEqual, valuesEqual⟩
      else isFalse fun relationProof => valuesEqual relationProof.2

/-- The neighbors of a point in one elliptic relation. -/
def relationRow (relation : EllipticRelation) (point : InternalPoint) : Finset InternalPoint :=
  Finset.univ.filter (HasRelation relation point)

/-- The number of intermediate points joining an ordered pair through two specified relations. -/
def intersectionCount (left right : EllipticRelation)
    (first second : InternalPoint) : ℕ :=
  (Finset.univ.filter fun middle =>
    HasRelation left first middle ∧ HasRelation right middle second).card

/-- Exact finite data sufficient to identify the six geometric relations from concurrence colors.
The forward and reverse implications make the color assignment a genuine recovery theorem rather
than a one-way correlation. -/
structure ConcurrenceRecoversRelations (minimumSupports : Finset (Finset InternalPoint)) where
  color : EllipticRelation → ℕ × (Finset (ℕ × ℕ))
  color_injective : Function.Injective color
  forward : ∀ relation first second, HasRelation relation first second →
    (ConicPassantCode.pairConcurrence minimumSupports first second,
      (Finset.univ.erase first |>.erase second |>.image fun third =>
        (ConicPassantCode.tripleConcurrence minimumSupports first second third,
          (Finset.univ.erase first |>.erase second |>.filter fun fourth =>
            ConicPassantCode.tripleConcurrence minimumSupports first second fourth =
              ConicPassantCode.tripleConcurrence minimumSupports first second third).card))) =
      color relation
  reverse : ∀ relation first second,
    first ≠ second →
    (ConicPassantCode.pairConcurrence minimumSupports first second,
      (Finset.univ.erase first |>.erase second |>.image fun third =>
        (ConicPassantCode.tripleConcurrence minimumSupports first second third,
          (Finset.univ.erase first |>.erase second |>.filter fun fourth =>
            ConicPassantCode.tripleConcurrence minimumSupports first second fourth =
              ConicPassantCode.tripleConcurrence minimumSupports first second third).card))) =
      color relation → HasRelation relation first second

end RelativeConicArcs.PassantCodeQ13
