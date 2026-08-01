import RelativeConicArcs.ClebschArithmeticGluingData
import RelativeConicArcs.ClebschInvariantMatchingCriterion

/-!
# The fused cardinality-five matching row

The displayed square-determinant subgroup at field cardinality five forces
the antipodal partner at every endpoint.  Hence every fixed-point-free
partner map equivariant for that subgroup is the displayed matching.  The
full projective orbit and square-determinant orbit coincide and have five
members, and a nonsquare-determinant projectivity stabilizes the matching.

The point-stabilizer condition and outer stabilizer are checked by kernel
reduction on the explicit projective matrices and six endpoints.  No abstract
tetrahedral-group identification is used.
-/

namespace RelativeConicArcs.ClebschA3InvariantMatching

open ClebschArithmeticGluing
open ClebschInvariantMatchingCriterion

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

/-- The square-determinant stabilizer of the displayed cardinality-five
matching. -/
def squareStabilizer : Finset (ProjectiveMatrix 5) :=
  mateStabilizer a3MatchingEdges ∩ psl

/-- A matrix together with evidence that it belongs to the displayed
square-determinant stabilizer. -/
abbrev SquareStabilizerElement := {g // g ∈ squareStabilizer}

/-- Each endpoint stabilizer forces the displayed antipodal partner. -/
theorem pointStabilizers_force_partner :
    PointStabilizersForcePartner (fun g : SquareStabilizerElement ↦ g.1) projectiveAction
      (matchingMate a3MatchingEdges) := by
  unfold PointStabilizersForcePartner
  decide

/-- Every fixed-point-free partner map equivariant for the displayed
square-determinant stabilizer is the antipodal matching. -/
theorem invariantMatching_eq (m : ProjectivePoint 5 → ProjectivePoint 5)
    (hfree : ∀ x, m x ≠ x)
    (hequivariant : ∀ g ∈ squareStabilizer, ∀ x,
      projectiveAction g (m x) = m (projectiveAction g x)) :
    m = matchingMate a3MatchingEdges :=
  equivariant_fixedPointFree_eq_of_pointStabilizersForcePartner
    pointStabilizers_force_partner hfree (fun g x ↦ hequivariant g.1 g.2 x)

/-- The full and square-determinant projective orbits of the displayed
matching coincide and have five elements. -/
theorem fullOrbit_eq_squareOrbit_and_card :
    mateOrbit pgl a3MatchingEdges = mateOrbit psl a3MatchingEdges ∧
      (mateOrbit pgl a3MatchingEdges).card = 5 := by
  constructor
  · decide
  · exact a3_fused_stabilizer_and_orbit.2.2.1

/-- A nonsquare-determinant projectivity stabilizes the displayed matching. -/
theorem has_outer_matching_stabilizer :
    ∃ g : ProjectiveMatrix 5,
      g ∈ mateStabilizer a3MatchingEdges ∧ g ∈ pgl ∧ g ∉ psl := by
  decide

end RelativeConicArcs.ClebschA3InvariantMatching
