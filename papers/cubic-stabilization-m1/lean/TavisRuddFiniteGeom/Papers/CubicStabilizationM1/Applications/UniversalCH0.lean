import Mathlib.Logic.Basic

/-!
# Universal zero-cycle triviality from the primitive minimal class

This module isolates the final logical step of the manuscript's cycle-side
argument.  It gives separate types to cubic threefolds and their intermediate
Jacobians, records algebraicity of the primitive minimal class as a predicate,
and states Voisin's criterion as an explicit equivalence premise for every
smooth complex cubic threefold under consideration.

No Chow group, intermediate Jacobian, minimal cycle, or cited geometric
criterion is constructed by Lean in this module.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

/-- Typed geometric signature for the primitive-minimal-class criterion. -/
structure CubicCycleTrivialityGeometry
    (CubicObject JacobianObject : Type*) where
  /-- Predicate identifying smooth complex cubic threefolds. -/
  isSmoothComplexCubicThreefold : CubicObject → Prop
  /-- Intermediate Jacobian attached to a cubic threefold. -/
  intermediateJacobian : CubicObject → JacobianObject
  /-- Algebraicity of the primitive minimal class on a Jacobian. -/
  primitiveMinimalClassAlgebraic : JacobianObject → Prop
  /-- Predicate intended to mean that the degree map on `CH₀` is an
  isomorphism after every field extension. -/
  universallyCH0Trivial : CubicObject → Prop

/-- Voisin's primitive-minimal-class criterion, retained as an explicit
external premise rather than declared as a Lean axiom.  The supplied statement
is the smooth complex cubic-threefold equivalence used from Claire Voisin,
*On the universal CH₀ group of cubic hypersurfaces*, Journal of the European
Mathematical Society 19 (2017), arXiv:1407.7261, Corollary 4.4. -/
def VoisinPrimitiveMinimalClassCriterion
    {CubicObject JacobianObject : Type*}
    (geometry : CubicCycleTrivialityGeometry
      CubicObject JacobianObject) : Prop :=
  ∀ cubic,
    geometry.isSmoothComplexCubicThreefold cubic →
      (geometry.primitiveMinimalClassAlgebraic
          (geometry.intermediateJacobian cubic) ↔
        geometry.universallyCH0Trivial cubic)

/-- Data supplied by the six-axis calculation for every smooth fibre of a
specified family: smooth cubic-threefold status and algebraicity of the
primitive minimal class of its intermediate Jacobian. -/
structure SixAxisMinimalClassFamilyInput
    {Base CubicObject JacobianObject : Type*}
    (geometry : CubicCycleTrivialityGeometry
      CubicObject JacobianObject)
    (fibre : Base → CubicObject) where
  /-- Every indexed fibre lies in the smooth cubic-threefold locus. -/
  fibreIsSmooth : ∀ parameter,
    geometry.isSmoothComplexCubicThreefold (fibre parameter)
  /-- The primitive minimal class is algebraic on every fibre's intermediate
  Jacobian. -/
  primitiveMinimalClassIsAlgebraic : ∀ parameter,
    geometry.primitiveMinimalClassAlgebraic
      (geometry.intermediateJacobian (fibre parameter))

/-- Exact deduction used in the manuscript: algebraicity of the primitive
minimal class on every smooth fibre, together with Voisin's equivalence,
implies universal `CH₀`-triviality of every fibre. -/
theorem universalCH0Triviality_of_primitiveMinimalClassFamily
    {Base CubicObject JacobianObject : Type*}
    (geometry : CubicCycleTrivialityGeometry
      CubicObject JacobianObject)
    (fibre : Base → CubicObject)
    (familyInput : SixAxisMinimalClassFamilyInput geometry fibre)
    (voisinCriterion : VoisinPrimitiveMinimalClassCriterion geometry) :
    ∀ parameter, geometry.universallyCH0Trivial (fibre parameter) := by
  intro parameter
  exact (voisinCriterion (fibre parameter)
    (familyInput.fibreIsSmooth parameter)).mp
      (familyInput.primitiveMinimalClassIsAlgebraic parameter)

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
