import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.CubicThreefold

/-!
# Transport from a cubic threefold to a genus-eight Fano threefold

The formal argument uses two rank-two projective-bundle formulas and a
birational map between the total spaces.  The existence of the Pfaffian cubic,
the bundles, and their flop is retained as typed external input.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

variable {Variety : Type*}

/-- External mathematical input for packet transport from a Pfaffian cubic to
a genus-eight prime Fano threefold and for the subsequent one-step rationality
obstruction. -/
structure GenusEightOneStepInput
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (fano cubic : Variety) where
  fanoBundle : Variety
  cubicBundle : Variety
  stabilizedFano : Variety
  projectiveFourSpace : Variety
  Rational : Variety → Prop
  fanoBundleFormula : packet.multiplicity fanoBundle =
    2 * packet.multiplicity fano
  cubicBundleFormula : packet.multiplicity cubicBundle =
    2 * packet.multiplicity cubic
  fanoBundleDimension : packet.dimension fanoBundle ≤ 4
  bundleFlopBirational : birationalInput.birational fanoBundle cubicBundle
  cubicPacket : packet.multiplicity cubic = 2
  stabilizationFormula : packet.multiplicity stabilizedFano =
    2 * packet.multiplicity fano
  stabilizedDimension : packet.dimension stabilizedFano ≤ 4
  projectiveSpacePacket : packet.multiplicity projectiveFourSpace = 0
  rationalComparison : Rational stabilizedFano →
    birationalInput.birational stabilizedFano projectiveFourSpace

/-- The rank-two projective-bundle flop transports packet multiplicity two
from the associated cubic threefold to the genus-eight Fano threefold. -/
theorem genusEight_packet_eq_two_of_projectiveBundle_flop
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    {fano cubic : Variety}
    (input : GenusEightOneStepInput packet birationalInput fano cubic) :
    packet.multiplicity fano = 2 := by
  calc
    packet.multiplicity fano = packet.multiplicity cubic :=
      Quantum.rankTwoProjectiveBundle_transport packet birationalInput
        input.fanoBundleFormula input.cubicBundleFormula
        input.fanoBundleDimension input.bundleFlopBirational
    _ = 2 := input.cubicPacket

/-- Under the explicit projective-bundle, flop, packet, and rational-comparison
premises, one projective-line stabilization of the genus-eight Fano threefold
is irrational. -/
theorem genusEight_oneStepStabilization_not_rational
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    {fano cubic : Variety}
    (input : GenusEightOneStepInput packet birationalInput fano cubic) :
    ¬ input.Rational input.stabilizedFano := by
  apply Quantum.rankTwoStabilization_not_rational packet birationalInput input.Rational
    input.stabilizationFormula input.stabilizedDimension
  · rw [genusEight_packet_eq_two_of_projectiveBundle_flop packet birationalInput input]
    omega
  · exact input.projectiveSpacePacket
  · exact input.rationalComparison

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
