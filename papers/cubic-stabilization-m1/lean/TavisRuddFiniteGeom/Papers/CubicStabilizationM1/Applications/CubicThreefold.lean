import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.BirationalDeduction

/-!
# The one-step cubic-threefold deduction

This module isolates the formal consequence of the packet calculation for a
smooth cubic threefold.  The construction of framed quantum monodromy, the
packet computation, the projective-bundle formula, weak factorization, and the
rational comparison with projective four-space remain explicit premises.

The packet premise records the consequence used from Jialei Cai, *The cubic
threefold is symplectically irrational* (2026), arXiv:2608.01577, Section 3
and Proposition 6.  The projective-bundle and weak-factorization premises are
documented in the modules that define them.  No cited theorem is declared as a
Lean axiom.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

variable {Variety : Type*}

/-- The geometric operations and predicates appearing in the one-step cubic
threefold theorem.  This abstract signature names the exact objects used by the
manuscript without claiming a foundational construction of complex projective
geometry. -/
structure CubicThreefoldGeometry (Variety : Type*) where
  isSmoothComplexCubicThreefold : Variety → Prop
  productWithProjectiveLine : Variety → Variety
  projectiveFourSpace : Variety
  Rational : Variety → Prop

/-- External mathematical input for the one-projective-line stabilization of
a specified smooth complex cubic threefold.  The packet calculation,
projective-bundle formula, dimension statement, weak-factorization consequence,
and rational comparison remain explicit premises. -/
structure CubicThreefoldOneStepInput
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : CubicThreefoldGeometry Variety)
    (cubic : Variety) where
  cubicIsSmooth : geometry.isSmoothComplexCubicThreefold cubic
  cubicPacket : packet.multiplicity cubic = 2
  stabilizationFormula : packet.multiplicity (geometry.productWithProjectiveLine cubic) =
    2 * packet.multiplicity cubic
  stabilizedDimension : packet.dimension (geometry.productWithProjectiveLine cubic) ≤ 4
  projectiveSpacePacket : packet.multiplicity geometry.projectiveFourSpace = 0
  rationalComparison : geometry.Rational (geometry.productWithProjectiveLine cubic) →
    birationalInput.birational
      (geometry.productWithProjectiveLine cubic) geometry.projectiveFourSpace

/-- Under the stated packet and birational-comparison premises, the product of
a cubic threefold with a projective line is not rational. -/
theorem cubicThreefold_oneStepStabilization_not_rational
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : CubicThreefoldGeometry Variety)
    {cubic : Variety}
    (input : CubicThreefoldOneStepInput packet birationalInput geometry cubic) :
    ¬ geometry.Rational (geometry.productWithProjectiveLine cubic) := by
  apply Quantum.rankTwoStabilization_not_rational packet birationalInput geometry.Rational
    input.stabilizationFormula input.stabilizedDimension
  · rw [input.cubicPacket]
    omega
  · exact input.projectiveSpacePacket
  · exact input.rationalComparison

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
