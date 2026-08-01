import RelativeConicArcs.ClebschArithmeticGluingData
import RelativeConicArcs.ClebschInvariantMatchingCriterion

/-!
# The two cardinality-seven invariant matchings

The explicit square-determinant action at field cardinality seven has two
displayed matching stabilizers.  In either stabilizer, the common fixed
points of an endpoint stabilizer are exactly that endpoint and its displayed
partner.  Therefore every fixed-point-free equivariant partner map is the
corresponding matching.

The point-stabilizer assertions are checked by kernel reduction on the
explicit matrices and eight projective endpoints.  The two resulting
matching orbits and their outer exchange are supplied by the arithmetic
gluing data imported below.
-/

namespace RelativeConicArcs.ClebschB3InvariantMatchings

open ClebschArithmeticGluing
open ClebschInvariantMatchingCriterion

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

/-- The stabilizer of the first displayed cardinality-seven matching. -/
def negativeStabilizer : Finset (ProjectiveMatrix 7) :=
  mateStabilizer b3NegativeMatchingEdges

/-- The stabilizer of the second displayed cardinality-seven matching. -/
def positiveStabilizer : Finset (ProjectiveMatrix 7) :=
  mateStabilizer b3PositiveMatchingEdges

/-- A matrix together with membership in the first displayed stabilizer. -/
abbrev NegativeStabilizerElement := {g // g ∈ negativeStabilizer}

/-- A matrix together with membership in the second displayed stabilizer. -/
abbrev PositiveStabilizerElement := {g // g ∈ positiveStabilizer}

/-- Each endpoint stabilizer for the first matching forces its displayed
partner. -/
theorem negative_pointStabilizers_force_partner :
    PointStabilizersForcePartner (fun g : NegativeStabilizerElement ↦ g.1) projectiveAction
      (matchingMate b3NegativeMatchingEdges) := by
  unfold PointStabilizersForcePartner
  decide

/-- Each endpoint stabilizer for the second matching forces its displayed
partner. -/
theorem positive_pointStabilizers_force_partner :
    PointStabilizersForcePartner (fun g : PositiveStabilizerElement ↦ g.1) projectiveAction
      (matchingMate b3PositiveMatchingEdges) := by
  unfold PointStabilizersForcePartner
  decide

/-- Every fixed-point-free partner map equivariant for the first displayed
stabilizer is the first matching. -/
theorem negative_invariantMatching_eq
    (m : ProjectivePoint 7 → ProjectivePoint 7)
    (hfree : ∀ x, m x ≠ x)
    (hequivariant : ∀ g ∈ negativeStabilizer, ∀ x,
      projectiveAction g (m x) = m (projectiveAction g x)) :
    m = matchingMate b3NegativeMatchingEdges :=
  equivariant_fixedPointFree_eq_of_pointStabilizersForcePartner
    negative_pointStabilizers_force_partner hfree
      (fun g x ↦ hequivariant g.1 g.2 x)

/-- Every fixed-point-free partner map equivariant for the second displayed
stabilizer is the second matching. -/
theorem positive_invariantMatching_eq
    (m : ProjectivePoint 7 → ProjectivePoint 7)
    (hfree : ∀ x, m x ≠ x)
    (hequivariant : ∀ g ∈ positiveStabilizer, ∀ x,
      projectiveAction g (m x) = m (projectiveAction g x)) :
    m = matchingMate b3PositiveMatchingEdges :=
  equivariant_fixedPointFree_eq_of_pointStabilizersForcePartner
    positive_pointStabilizers_force_partner hfree
      (fun g x ↦ hequivariant g.1 g.2 x)

end RelativeConicArcs.ClebschB3InvariantMatchings
