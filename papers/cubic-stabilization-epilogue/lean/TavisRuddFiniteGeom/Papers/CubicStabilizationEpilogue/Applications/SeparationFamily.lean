import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.UniversalCH0
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.CubicThreefold

/-!
# Separation after one stabilization

This module formalizes the final composition in the manuscript.  One typed
family of cubic objects is used simultaneously by the cycle-triviality and
one-step irrationality interfaces.  Universal `CH₀`-triviality of each fibre
is obtained from the primitive minimal class and Voisin's criterion; its
stabilization is supplied by the projective-bundle formula; irrationality is
obtained from the packet input; and non-isotriviality is retained as the
explicit period-map premise used by the human proof.

No invariant pencil, Chow group, period map, or quantum connection is
constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

/-- The four conclusions asserted for a family in the separation theorem. -/
structure SeparationFamilyConclusion
    {Base Variety Jacobian : Type*}
    (cycleGeometry : CubicCycleTrivialityGeometry Variety Jacobian)
    (rationalGeometry : CubicThreefoldGeometry Variety)
    (isNonIsotrivial : (Base → Variety) → Prop)
    (fibre : Base → Variety) : Prop where
  /-- Every fibre is universally `CH₀`-trivial. -/
  fibreUniversallyCH0Trivial : ∀ parameter,
    cycleGeometry.universallyCH0Trivial (fibre parameter)
  /-- Every projective-line stabilization is universally `CH₀`-trivial. -/
  stabilizationUniversallyCH0Trivial : ∀ parameter,
    cycleGeometry.universallyCH0Trivial
      (rationalGeometry.productWithProjectiveLine (fibre parameter))
  /-- Every projective-line stabilization is irrational. -/
  stabilizationIrrational : ∀ parameter,
    ¬ rationalGeometry.Rational
      (rationalGeometry.productWithProjectiveLine (fibre parameter))
  /-- The family is non-isotrivial in coarse moduli. -/
  familyNonIsotrivial : isNonIsotrivial fibre

/-- Exact external inputs used when assembling the separation theorem. -/
structure SeparationFamilyInput
    {Base Variety Jacobian : Type*}
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (cycleGeometry : CubicCycleTrivialityGeometry Variety Jacobian)
    (rationalGeometry : CubicThreefoldGeometry Variety)
    (isNonIsotrivial : (Base → Variety) → Prop)
    (fibre : Base → Variety) where
  /-- Six-axis minimal-class input for every fibre. -/
  minimalClassInput : SixAxisMinimalClassFamilyInput cycleGeometry fibre
  /-- Voisin's equivalence for smooth complex cubic threefolds. -/
  voisinCriterion : VoisinPrimitiveMinimalClassCriterion cycleGeometry
  /-- The projective-bundle formula preserves universal `CH₀`-triviality under
  product with the projective line. -/
  projectiveBundleCH0 : ∀ variety,
    cycleGeometry.universallyCH0Trivial variety →
      cycleGeometry.universallyCH0Trivial
        (rationalGeometry.productWithProjectiveLine variety)
  /-- Packet and birational-comparison inputs proving one-step irrationality
  for every indexed cubic fibre. -/
  oneStepInput : ∀ parameter,
    CubicThreefoldOneStepInput packet birationalInput rationalGeometry
      (fibre parameter)
  /-- Non-isotriviality supplied by the nonconstant intermediate-Jacobian
  period map on the family component. -/
  nonIsotrivial : isNonIsotrivial fibre

/-- Conditional separation theorem with every geometric, Chow-theoretic,
quantum, and period-map input visible in the theorem type. -/
theorem separationFamily_of_cycle_packet_and_period_inputs
    {Base Variety Jacobian : Type*}
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (cycleGeometry : CubicCycleTrivialityGeometry Variety Jacobian)
    (rationalGeometry : CubicThreefoldGeometry Variety)
    (isNonIsotrivial : (Base → Variety) → Prop)
    (fibre : Base → Variety)
    (input : SeparationFamilyInput packet birationalInput cycleGeometry
      rationalGeometry isNonIsotrivial fibre) :
    SeparationFamilyConclusion cycleGeometry rationalGeometry
      isNonIsotrivial fibre := by
  have fibreCH0 : ∀ parameter,
      cycleGeometry.universallyCH0Trivial (fibre parameter) :=
    universalCH0Triviality_of_primitiveMinimalClassFamily
      cycleGeometry fibre input.minimalClassInput input.voisinCriterion
  exact
    { fibreUniversallyCH0Trivial := fibreCH0
      stabilizationUniversallyCH0Trivial := fun parameter ↦
        input.projectiveBundleCH0 (fibre parameter) (fibreCH0 parameter)
      stabilizationIrrational := fun parameter ↦
        cubicThreefold_oneStepStabilization_not_rational packet
          birationalInput rationalGeometry (input.oneStepInput parameter)
      familyNonIsotrivial := input.nonIsotrivial }

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
