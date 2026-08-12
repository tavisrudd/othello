import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.BirationalDeduction

/-!
# The one-step cubic-threefold deduction

This module isolates the formal consequence of the packet calculation for a
smooth cubic threefold.  The construction of framed quantum monodromy, the
packet computation, the projective-bundle formula, weak factorization, and the
rational comparison with projective four-space remain explicit premises.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

variable {Variety : Type*}

/-- External mathematical input for the one-projective-line stabilization of
a cubic threefold.  The field names distinguish the packet computation and
projective-bundle formula from the kernel-checked irrationality deduction. -/
structure CubicThreefoldOneStepInput
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (cubic : Variety) where
  stabilized : Variety
  projectiveFourSpace : Variety
  Rational : Variety → Prop
  cubicPacket : packet.multiplicity cubic = 2
  stabilizationFormula : packet.multiplicity stabilized =
    2 * packet.multiplicity cubic
  stabilizedDimension : packet.dimension stabilized ≤ 4
  projectiveSpacePacket : packet.multiplicity projectiveFourSpace = 0
  rationalComparison : Rational stabilized →
    birationalInput.birational stabilized projectiveFourSpace

/-- Under the stated packet and birational-comparison premises, the product of
a cubic threefold with a projective line is not rational. -/
theorem cubicThreefold_oneStepStabilization_not_rational
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    {cubic : Variety}
    (input : CubicThreefoldOneStepInput packet birationalInput cubic) :
    ¬ input.Rational input.stabilized := by
  apply Quantum.rankTwoStabilization_not_rational packet birationalInput input.Rational
    input.stabilizationFormula input.stabilizedDimension
  · rw [input.cubicPacket]
    omega
  · exact input.projectiveSpacePacket
  · exact input.rationalComparison

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
