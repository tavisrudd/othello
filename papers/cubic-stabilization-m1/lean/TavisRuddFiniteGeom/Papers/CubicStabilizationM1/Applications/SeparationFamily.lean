import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.UniversalCH0
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.CubicThreefold
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.CubicResidueMarkerOneStep
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.SeparatedVariableModuliExclusion

/-!
# Separation after one stabilization

This module formalizes the final composition in the manuscript.  One typed
family of cubic objects is used simultaneously by the cycle-triviality and
one-step irrationality interfaces.  Universal `CH₀`-triviality of each fibre
is obtained from the primitive minimal class and Voisin's criterion; its
stabilization is supplied by the projective-bundle formula; irrationality is
obtained from the direct residue-marker input; non-isotriviality is deduced
from a nonconstant typed period map through the comparison used by the human
proof; and the moduli points
represented by cubics of separated-variable type are pinned to the single
distinguished point by the Eckardt-locus premises.

No invariant pencil, Chow group, period map, or quantum connection is
constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

universe u v w x

/-- The four conclusions asserted for a family in the separation theorem. -/
structure SeparationFamilyConclusion
    {Base Variety Jacobian Moduli : Type*}
    (cycleGeometry : CubicCycleTrivialityGeometry Variety Jacobian)
    (rationalGeometry : CubicThreefoldGeometry Variety)
    (isNonIsotrivial : (Base → Variety) → Prop)
    (fibre : Base → Variety) (moduliPoint : Base → Moduli)
    (separatedVariableType : Variety → Prop)
    (projectivelyEquivalent : Variety → Variety → Prop)
    (distinguishedPoint : Moduli) : Prop where
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
  /-- A member represented by a cubic of separated-variable type has the
  distinguished moduli point. -/
  separatedVariableOnlyAtDistinguishedPoint : ∀ parameter,
    RepresentedBySeparatedVariable separatedVariableType projectivelyEquivalent
        (fibre parameter) →
      moduliPoint parameter = distinguishedPoint
  /-- The distinguished moduli point is itself represented by such a cubic, so
  the separated-variable locus of the family is exactly that point. -/
  distinguishedPointRepresented : ∃ parameter,
    moduliPoint parameter = distinguishedPoint ∧
      RepresentedBySeparatedVariable separatedVariableType projectivelyEquivalent
        (fibre parameter)

/-- Exact external inputs used when assembling the separation theorem. -/
structure SeparationFamilyInput
    {K : Type x} [CommRing K]
    {Base : Type*} {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {Jacobian Moduli Period : Type*}
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (projectiveFourSpace : Variety)
    (cycleGeometry : CubicCycleTrivialityGeometry Variety Jacobian)
    (rationalGeometry : CubicThreefoldGeometry Variety)
    (isNonIsotrivial : (Base → Variety) → Prop)
    (fibre : Base → Variety) (moduliPoint : Base → Moduli)
    (hasEckardtPoint separatedVariableType : Variety → Prop)
    (projectivelyEquivalent : Variety → Variety → Prop)
    (distinguishedPoint : Moduli) where
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
  /-- Direct residue-marker and birational-comparison inputs proving one-step irrationality
  for every indexed cubic fibre. -/
  oneStepInput : ∀ parameter,
    CubicResidueMarkerOneStepInput context
      rationalGeometry.productWithProjectiveLine projectiveFourSpace
      rationalGeometry.Rational (fibre parameter)
  /-- The intermediate-Jacobian period map used by the human proof. -/
  periodMap : Base → Period
  /-- Two parameters have distinct periods. -/
  periodMapNonconstant : ∃ left right, periodMap left ≠ periodMap right
  /-- Nonconstancy of the period map implies non-isotriviality in coarse
  moduli.  This comparison is the imported geometric premise. -/
  nonIsotrivial_of_periodMap_nonconstant :
    (∃ left right, periodMap left ≠ periodMap right) → isNonIsotrivial fibre
  /-- Eckardt-locus inputs pinning the separated-variable locus of the family
  to the distinguished moduli point. -/
  separatedVariableInput : SeparatedVariableModuliInput fibre moduliPoint
    hasEckardtPoint separatedVariableType projectivelyEquivalent
    distinguishedPoint

/-- Conditional separation theorem with every geometric, Chow-theoretic,
quantum, and period-map input visible in the theorem type. -/
theorem separationFamily_of_cycle_residue_and_period_inputs
    {K : Type x} [CommRing K]
    {Base : Type*} {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {Jacobian Moduli Period : Type*}
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (projectiveFourSpace : Variety)
    (cycleGeometry : CubicCycleTrivialityGeometry Variety Jacobian)
    (rationalGeometry : CubicThreefoldGeometry Variety)
    (isNonIsotrivial : (Base → Variety) → Prop)
    (fibre : Base → Variety) (moduliPoint : Base → Moduli)
    (hasEckardtPoint separatedVariableType : Variety → Prop)
    (projectivelyEquivalent : Variety → Variety → Prop)
    (distinguishedPoint : Moduli)
    (input : SeparationFamilyInput (Period := Period) context projectiveFourSpace cycleGeometry
      rationalGeometry isNonIsotrivial fibre moduliPoint hasEckardtPoint
      separatedVariableType projectivelyEquivalent distinguishedPoint) :
    SeparationFamilyConclusion cycleGeometry rationalGeometry
      isNonIsotrivial fibre moduliPoint separatedVariableType
      projectivelyEquivalent distinguishedPoint := by
  have fibreCH0 : ∀ parameter,
      cycleGeometry.universallyCH0Trivial (fibre parameter) :=
    universalCH0Triviality_of_primitiveMinimalClassFamily
      cycleGeometry fibre input.minimalClassInput input.voisinCriterion
  exact
    { fibreUniversallyCH0Trivial := fibreCH0
      stabilizationUniversallyCH0Trivial := fun parameter ↦
        input.projectiveBundleCH0 (fibre parameter) (fibreCH0 parameter)
      stabilizationIrrational := fun parameter ↦
        cubicThreefold_oneProjectiveLine_not_rational_of_residueMarker context
          rationalGeometry.productWithProjectiveLine projectiveFourSpace
          rationalGeometry.Rational (fibre parameter) (input.oneStepInput parameter)
      familyNonIsotrivial :=
        input.nonIsotrivial_of_periodMap_nonconstant input.periodMapNonconstant
      separatedVariableOnlyAtDistinguishedPoint :=
        (separatedVariableModuli_eq_distinguishedPoint fibre moduliPoint
          hasEckardtPoint separatedVariableType projectivelyEquivalent
          distinguishedPoint input.separatedVariableInput).1
      distinguishedPointRepresented :=
        (separatedVariableModuli_eq_distinguishedPoint fibre moduliPoint
          hasEckardtPoint separatedVariableType projectivelyEquivalent
          distinguishedPoint input.separatedVariableInput).2 }

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
