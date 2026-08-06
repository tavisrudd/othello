import RelativeConicArcs.PassantCodeQ13.StructuralUpgrade
import PassantCodeQ13.MinimumWords.RowUniqueness.Base
import PassantCodeQ13.AssociationTransport.RelationCubic

/-!
# Paper-owned structural certificates for the q=13 passant code

The generic implications live in `RelativeConicArcs.PassantCodeQ13.StructuralUpgrade`.  This module
checks the bounded q=13 inputs that are small enough to evaluate in Lean.  Every check stated in this
module is discharged in one of two ways.

The checks whose domain is the 364-member decoded support family — pair-only row recovery, unary
constancy, and the fused pair-color split — and the point and line axioms of the normalized
183-point plane, whose domain is the ordered pairs of that plane, are discharged by native
evaluation, so each carries the declaration-local axiom that compiled evaluation introduces.

The checks whose domain is the 78 internal points or the 183 plane coordinates — the three toric
support cardinalities, their passant parities, and the determinant-conic cardinality — are
discharged by kernel reduction and carry no evaluation axiom.

The hidden-field quartic satisfied by the rho-nine relation operator is inherited from
`PassantCodeQ13.AssociationTransport.RelationCubic`, where it is derived from the squaring
identities of the elliptic relations.  The larger theta positivity and stabilizer-prefix tables
remain separately hashed exact certificates.
-/

namespace PassantCodeQ13.StructuralUpgrade

open Finset
open RelativeConicArcs
open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.MinimumWords.RowUniqueness
open PassantCodeQ13.AssociationTransport

/-- The decoded four-orbit support family has constant unary degree 56. -/
theorem unaryDegree_fiftySix (point : InternalPoint) :
    (semanticMinimumSupports.filter fun support => point ∈ support).card = 56 := by
  native_decide +revert

/-- Concurrence-eight neighborhoods recover exactly the internal--internal polarity rows. -/
theorem pairColorEight_recovers_polarRows :
    pairRecoveredRows semanticMinimumSupports 8 = polarRowFamily := by
  native_decide

/-- The pair-derived common-color-seven count splits every concurrence-six pair into values two
and four. -/
theorem fusedColorSix_splits (first second : InternalPoint) (different : first ≠ second)
    (colorSix : ConicPassantCode.pairConcurrence semanticMinimumSupports first second = 6) :
    (Finset.univ.filter fun middle =>
      ConicPassantCode.pairConcurrence semanticMinimumSupports first middle = 7 ∧
      ConicPassantCode.pairConcurrence semanticMinimumSupports middle second = 7).card = 2 ∨
    (Finset.univ.filter fun middle =>
      ConicPassantCode.pairConcurrence semanticMinimumSupports first middle = 7 ∧
      ConicPassantCode.pairConcurrence semanticMinimumSupports middle second = 7).card = 4 := by
  native_decide +revert

/-- Complete pair-only reconstruction certificate for the decoded minimum layer. -/
def pairOnlyCertificate : PairOnlyReconstructionCertificate semanticMinimumSupports where
  colorEightRows := pairColorEight_recovers_polarRows
  unaryDegree := 56
  unaryConstant := unaryDegree_fiftySix
  fusedColorSplit := fusedColorSix_splits

/-- The pencil-conic level selected by `Y² = r XZ` among the internal points. -/
def toricSupport (r : Field13) : Finset InternalPoint :=
  Finset.univ.filter fun point => point.1.y ^ 2 = r * point.1.x * point.1.z

/-- Every passant meets a finite support evenly. -/
def HasEvenPassantIntersections (support : Finset InternalPoint) : Prop :=
  ∀ line : PassantLine, ((support.filter fun point => Incident line point).card % 2 = 0)

/-- The parity condition is decidable, being a bounded quantifier over the finite passant lines
with a decidable body; stating the instance lets the condition be evaluated as written. -/
instance (support : Finset InternalPoint) :
    Decidable (HasEvenPassantIntersections support) := by
  unfold HasEvenPassantIntersections
  infer_instance

/-- The three toric levels have twelve internal points. -/
theorem toricSupport_cards :
    (toricSupport 2).card = 12 ∧ (toricSupport 5).card = 12 ∧
      (toricSupport 11).card = 12 := by
  decide +kernel

/-- The three toric levels satisfy every passant parity check. -/
theorem toricSupport_even_passants :
    HasEvenPassantIntersections (toricSupport 2) ∧
      HasEvenPassantIntersections (toricSupport 5) ∧
      HasEvenPassantIntersections (toricSupport 11) := by
  decide +kernel

/-- The relation operator `A₉` satisfies the hidden irreducible cubic on its image: multiplying
`B³+B²+I` by `B` gives the zero ambient matrix. -/
theorem hiddenField_cubic_on_image :
    let B := relationLinearMatrix 9
    B ^ 4 + B ^ 3 + B = 0 := by
  intro B
  exact rhoNine_quartic_vanishes

/-- A normalized projective point, used equally for the dual line set. -/
abbrev PlaneCoordinate := {coordinate : Triple // coordinate ∈ projectiveTriples}

/-- Incidence in the full normalized projective plane. -/
def PlaneIncident (line point : PlaneCoordinate) : Prop :=
  line.1.x * point.1.x + line.1.y * point.1.y + line.1.z * point.1.z = 0

instance : DecidableRel PlaneIncident := fun line point =>
  decEq (line.1.x * point.1.x + line.1.y * point.1.y + line.1.z * point.1.z) 0

/-- The normalized full-plane point and line sets both have size 183. -/
theorem planeCoordinate_card : Fintype.card PlaneCoordinate = 183 := by
  simpa only [Fintype.card_coe] using projectiveTriples_card

/-- The determinant conic has fourteen normalized points. -/
theorem determinantConic_card :
    (Finset.univ.filter fun point : PlaneCoordinate => pointDiscriminant point.1 = 0).card = 14 := by
  decide +kernel

/-- Unique existence over the finite normalized plane is decidable: it unfolds to an existential
and a bounded uniqueness clause, both over a fintype with decidable incidence and equality. -/
instance (predicate : PlaneCoordinate → Prop) [DecidablePred predicate] :
    Decidable (∃! coordinate : PlaneCoordinate, predicate coordinate) := by
  unfold ExistsUnique
  infer_instance

/-- Every two distinct normalized points lie on a unique normalized line. -/
theorem uniqueLine_through_two_points (first second : PlaneCoordinate)
    (different : first ≠ second) :
    ∃! line : PlaneCoordinate, PlaneIncident line first ∧ PlaneIncident line second := by
  native_decide +revert

/-- Every two distinct normalized lines meet in a unique normalized point. -/
theorem uniquePoint_on_two_lines (first second : PlaneCoordinate)
    (different : first ≠ second) :
    ∃! point : PlaneCoordinate, PlaneIncident first point ∧ PlaneIncident second point := by
  native_decide +revert

end PassantCodeQ13.StructuralUpgrade
