import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.CubicThreefold

/-!
# Transport from a cubic threefold to a genus-eight Fano threefold

The formal argument uses two rank-two projective-bundle formulas and a
birational map between the total spaces.  The existence of the Pfaffian cubic,
the bundles, and their flop is retained as typed external input.

The geometric premise is the construction in Alexander Kuznetsov, *Derived
categories of cubic and V14 threefolds* (2004), Proceedings of the Steklov
Institute of Mathematics 246, Theorems 2.17--2.18; arXiv:math/0303037.  The
associated cubic packet is the premise documented in the cubic-threefold
module.  Neither source is imported as a Lean axiom.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

variable {Variety : Type*}

/-- The geometric operations and predicates in the genus-eight application.
The associated cubic and the two projective-bundle total spaces are functions
of the specified Fano carrier, preventing unrelated abstract objects from being
substituted for the constructions in the theorem. -/
structure GenusEightGeometry (Variety : Type*) where
  isSmoothPrimeFanoThreefoldOfGenusEight : Variety → Prop
  isSmoothComplexCubicThreefold : Variety → Prop
  associatedPfaffianCubic : Variety → Variety
  fanoRankTwoBundleTotalSpace : Variety → Variety
  cubicRankTwoBundleTotalSpace : Variety → Variety
  productWithProjectiveLine : Variety → Variety
  projectiveFourSpace : Variety
  Rational : Variety → Prop

/-- External mathematical input for packet transport from the associated
Pfaffian cubic to a specified smooth prime Fano threefold of genus eight and
for the subsequent one-step rationality obstruction. -/
structure GenusEightOneStepInput
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : GenusEightGeometry Variety)
    (fano : Variety) where
  fanoIsSmoothPrimeGenusEight :
    geometry.isSmoothPrimeFanoThreefoldOfGenusEight fano
  associatedCubicIsSmooth :
    geometry.isSmoothComplexCubicThreefold (geometry.associatedPfaffianCubic fano)
  fanoBundleFormula : packet.multiplicity (geometry.fanoRankTwoBundleTotalSpace fano) =
    2 * packet.multiplicity fano
  cubicBundleFormula :
    packet.multiplicity (geometry.cubicRankTwoBundleTotalSpace fano) =
      2 * packet.multiplicity (geometry.associatedPfaffianCubic fano)
  fanoBundleDimension :
    packet.dimension (geometry.fanoRankTwoBundleTotalSpace fano) ≤ 4
  bundleFlopBirational : birationalInput.birational
    (geometry.fanoRankTwoBundleTotalSpace fano)
    (geometry.cubicRankTwoBundleTotalSpace fano)
  cubicPacket : packet.multiplicity (geometry.associatedPfaffianCubic fano) = 2
  stabilizationFormula : packet.multiplicity (geometry.productWithProjectiveLine fano) =
    2 * packet.multiplicity fano
  stabilizedDimension : packet.dimension (geometry.productWithProjectiveLine fano) ≤ 4
  projectiveSpacePacket : packet.multiplicity geometry.projectiveFourSpace = 0
  rationalComparison : geometry.Rational (geometry.productWithProjectiveLine fano) →
    birationalInput.birational
      (geometry.productWithProjectiveLine fano) geometry.projectiveFourSpace

/-- The rank-two projective-bundle flop transports packet multiplicity two
from the associated cubic threefold to the genus-eight Fano threefold. -/
theorem genusEight_packet_eq_two_of_projectiveBundle_flop
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : GenusEightGeometry Variety)
    {fano : Variety}
    (input : GenusEightOneStepInput packet birationalInput geometry fano) :
    packet.multiplicity fano = 2 := by
  calc
    packet.multiplicity fano =
        packet.multiplicity (geometry.associatedPfaffianCubic fano) :=
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
    (geometry : GenusEightGeometry Variety)
    {fano : Variety}
    (input : GenusEightOneStepInput packet birationalInput geometry fano) :
    ¬ geometry.Rational (geometry.productWithProjectiveLine fano) := by
  apply Quantum.rankTwoStabilization_not_rational packet birationalInput geometry.Rational
    input.stabilizationFormula input.stabilizedDimension
  · rw [genusEight_packet_eq_two_of_projectiveBundle_flop
      packet birationalInput geometry input]
    omega
  · exact input.projectiveSpacePacket
  · exact input.rationalComparison

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
