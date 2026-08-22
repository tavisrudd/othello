import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PacketInvariant
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic

/-!
# Blowup-formula telescope in dimension four

This module exposes the geometric bookkeeping hidden by an abstract
"preserving step": smooth endpoint and center predicates, codimension at
least two, the center/ambient dimension relation, every specialized center
summand, and both orientations of a weak-factorization link.

Weak factorization and the quantum blowup formula are still supplied as typed
data.  Lean proves that low-dimensional vanishing makes each link preserve the
packet and that preservation telescopes along the chain.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open scoped BigOperators

variable {Variety Center : Type*}

/-- Predicates and numerical data used to state a blowup step without hiding
its center contributions. -/
structure BlowupGeometry (packet : PacketData Variety) (Center : Type*) where
  smoothProjectiveComplex : Variety → Prop
  smoothCenter : Center → Prop
  centerDimension : Center → ℕ
  centerContribution : Center → ℕ → ℕ

/-- A directed blowup step from `lower` to `upper`.  Its operation formula
contains one specialized center contribution for each index `0 ≤ j ≤ c-2`.
-/
structure BlowupStep
    (packet : PacketData Variety) (geometry : BlowupGeometry packet Center)
    (lower upper : Variety) where
  center : Center
  codimension : ℕ
  lowerSmooth : geometry.smoothProjectiveComplex lower
  upperSmooth : geometry.smoothProjectiveComplex upper
  centerSmooth : geometry.smoothCenter center
  codimensionAtLeastTwo : 2 ≤ codimension
  centerAmbientDimension :
    geometry.centerDimension center + codimension = packet.dimension lower
  dimensionPreserved : packet.dimension upper = packet.dimension lower
  operationFormula :
    packet.multiplicity upper = packet.multiplicity lower +
      ∑ j ∈ Finset.range (codimension - 1), geometry.centerContribution center j

/-- An unoriented weak-factorization link: either the right endpoint is the
blowup of the left endpoint, or conversely. -/
inductive BlowupLink
    (packet : PacketData Variety) (geometry : BlowupGeometry packet Center) :
    Variety → Variety → Type _
  | forward {lower upper} (step : BlowupStep packet geometry lower upper) :
      BlowupLink packet geometry lower upper
  | backward {lower upper} (step : BlowupStep packet geometry lower upper) :
      BlowupLink packet geometry upper lower

/-- A composable chain of typed blowup and blowdown links. -/
inductive WeakFactorizationChain
    (packet : PacketData Variety) (geometry : BlowupGeometry packet Center) :
    Variety → Variety → Type _
  | refl (object : Variety) : WeakFactorizationChain packet geometry object object
  | step {source middle target}
      (link : BlowupLink packet geometry source middle)
      (tail : WeakFactorizationChain packet geometry middle target) :
      WeakFactorizationChain packet geometry source target

/-- Low-dimensional vanishing means that every specialized contribution of
every smooth center of dimension at most two is zero. -/
def CenterContributionsVanishThroughDimensionTwo
    (geometry : BlowupGeometry packet Center) : Prop :=
  ∀ center, geometry.smoothCenter center → geometry.centerDimension center ≤ 2 →
    ∀ specialization, geometry.centerContribution center specialization = 0

/-- A typed factorization link preserves ambient dimension. -/
theorem BlowupLink.dimension_eq
    {packet : PacketData Variety} {geometry : BlowupGeometry packet Center}
    {left right : Variety} (link : BlowupLink packet geometry left right) :
    packet.dimension left = packet.dimension right := by
  cases link with
  | forward step => exact step.dimensionPreserved.symm
  | backward step => exact step.dimensionPreserved

/-- In ambient dimension at most four, the center of a codimension-at-least-two
blowup has dimension at most two. -/
theorem BlowupStep.center_dimension_le_two
    {packet : PacketData Variety} {geometry : BlowupGeometry packet Center}
    {lower upper : Variety} (step : BlowupStep packet geometry lower upper)
    (ambientDimension : packet.dimension lower ≤ 4) :
    geometry.centerDimension step.center ≤ 2 := by
  have dimensionRelation := step.centerAmbientDimension
  have codimensionBound := step.codimensionAtLeastTwo
  omega

/-- Vanishing of all permitted center summands turns the blowup formula into
equality of the two endpoint packet multiplicities. -/
theorem BlowupStep.multiplicity_eq_of_center_vanishing
    {packet : PacketData Variety} {geometry : BlowupGeometry packet Center}
    {lower upper : Variety} (step : BlowupStep packet geometry lower upper)
    (ambientDimension : packet.dimension lower ≤ 4)
    (vanishing : CenterContributionsVanishThroughDimensionTwo geometry) :
    packet.multiplicity lower = packet.multiplicity upper := by
  have centerDimension := step.center_dimension_le_two ambientDimension
  have contributionSum :
      (∑ j ∈ Finset.range (step.codimension - 1),
        geometry.centerContribution step.center j) = 0 := by
    apply Finset.sum_eq_zero
    intro specialization _
    exact vanishing step.center step.centerSmooth centerDimension specialization
  rw [step.operationFormula, contributionSum, Nat.add_zero]

/-- Either orientation of a blowup link preserves packet multiplicity once
its center contributions vanish. -/
theorem BlowupLink.multiplicity_eq_of_center_vanishing
    {packet : PacketData Variety} {geometry : BlowupGeometry packet Center}
    {left right : Variety} (link : BlowupLink packet geometry left right)
    (leftDimension : packet.dimension left ≤ 4)
    (vanishing : CenterContributionsVanishThroughDimensionTwo geometry) :
    packet.multiplicity left = packet.multiplicity right := by
  cases link with
  | forward step =>
      exact step.multiplicity_eq_of_center_vanishing leftDimension vanishing
  | backward step =>
      apply (step.multiplicity_eq_of_center_vanishing ?_ vanishing).symm
      rw [← step.dimensionPreserved]
      exact leftDimension

/-- The explicit weak-factorization telescope: in dimension at most four,
typed blowup formulas and vanishing of all smooth center terms imply equality
of packet multiplicities at the endpoints. -/
theorem WeakFactorizationChain.multiplicity_eq_of_center_vanishing
    {packet : PacketData Variety} {geometry : BlowupGeometry packet Center}
    {source target : Variety}
    (chain : WeakFactorizationChain packet geometry source target)
    (sourceDimension : packet.dimension source ≤ 4)
    (vanishing : CenterContributionsVanishThroughDimensionTwo geometry) :
    packet.multiplicity source = packet.multiplicity target := by
  induction chain with
  | refl => rfl
  | step link tail inductionHypothesis =>
      have linkEquality :=
        link.multiplicity_eq_of_center_vanishing sourceDimension vanishing
      exact linkEquality.trans (inductionHypothesis (by
        rw [← link.dimension_eq]
        exact sourceDimension))

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
