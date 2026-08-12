import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.RankOneGeneration
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.GenusEightThreefold

/-!
# Reviewer interface for the cubic-stabilization companion

This is the public mathematical entry point for the Lean companion.  It
exports the division-free rank-one identity and the abstract telescope behind
birational invariance of packet multiplicities.  The manuscript-to-declaration
map distinguishes these kernel-checked deductions from geometric and quantum
comparison theorems that have not been formalized from foundations.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

/-- Public form of the division-free identity used in the rank-one generation
argument for symmetric matrix-of-ideals lattices. -/
theorem rankOne_mixed_coefficient_identity
    {R : Type*} [CommRing R] (c a b : R) :
    GraphLattices.SymmetricPair.sub
          (GraphLattices.SymmetricPair.sub
            (GraphLattices.SymmetricPair.scale c
              (GraphLattices.SymmetricPair.rankOne a b))
            (GraphLattices.SymmetricPair.scale (c * a * a)
              GraphLattices.SymmetricPair.firstSquare))
          (GraphLattices.SymmetricPair.scale (c * b * b)
            GraphLattices.SymmetricPair.secondSquare) =
      { diagonalFirst := 0, mixed := c * a * b, diagonalSecond := 0 } :=
  GraphLattices.SymmetricPair.scaled_rankOne_sub_diagonals c a b

/-- Public form of the weak-factorization telescope: composable steps that
preserve a packet multiplicity preserve it between their endpoints. -/
theorem packet_multiplicity_eq_of_preserving_chain
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    {source target : Variety}
    (chain : Quantum.PreservingChain packet source target) :
    packet.multiplicity source = packet.multiplicity target :=
  chain.multiplicity_eq packet

/-- Reviewer-facing birational-invariance deduction.  Its typed input records
the geometric weak-factorization and operation-formula premise explicitly. -/
theorem packet_multiplicity_birational_in_dimension_four
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (input : Quantum.DimensionFourBirationalInput packet)
    {source target : Variety} (sourceDimension : packet.dimension source ≤ 4)
    (birational : input.birational source target) :
    packet.multiplicity source = packet.multiplicity target :=
  input.multiplicity_eq packet sourceDimension birational

/-- Reviewer-facing transport across two birational rank-two projective
bundles, the formal deduction used for the genus-eight Fano application. -/
theorem rankTwoProjectiveBundle_packet_transport
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (input : Quantum.DimensionFourBirationalInput packet)
    {leftBase rightBase leftBundle rightBundle : Variety}
    (leftFormula : packet.multiplicity leftBundle =
      2 * packet.multiplicity leftBase)
    (rightFormula : packet.multiplicity rightBundle =
      2 * packet.multiplicity rightBase)
    (bundleDimension : packet.dimension leftBundle ≤ 4)
    (bundlesBirational : input.birational leftBundle rightBundle) :
    packet.multiplicity leftBase = packet.multiplicity rightBase :=
  Quantum.rankTwoProjectiveBundle_transport packet input leftFormula rightFormula
    bundleDimension bundlesBirational

/-- Reviewer-facing irrationality deduction from a nonzero packet invariant. -/
theorem irrational_of_nonzero_packet
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (input : Quantum.DimensionFourBirationalInput packet)
    (Rational : Variety → Prop)
    {object comparison : Variety}
    (objectDimension : packet.dimension object ≤ 4)
    (objectNonzero : packet.multiplicity object ≠ 0)
    (comparisonZero : packet.multiplicity comparison = 0)
    (rationalComparison : Rational object → input.birational object comparison) :
    ¬ Rational object :=
  Quantum.not_rational_of_nonzero_multiplicity packet input Rational objectDimension
    objectNonzero comparisonZero rationalComparison

/-- Reviewer-facing form of the cubic-threefold one-step irrationality
deduction.  The input structure exposes every external quantum and geometric
premise used by the proof. -/
theorem cubicThreefold_oneStep_irrational_of_packet_inputs
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    {cubic : Variety}
    (input : Applications.CubicThreefoldOneStepInput packet birationalInput cubic) :
    ¬ input.Rational input.stabilized :=
  Applications.cubicThreefold_oneStepStabilization_not_rational
    packet birationalInput input

/-- Reviewer-facing packet transport from an associated cubic threefold to a
genus-eight Fano threefold, conditional on the typed projective-bundle and flop
premises. -/
theorem genusEight_packet_eq_two_of_flop_inputs
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    {fano cubic : Variety}
    (input : Applications.GenusEightOneStepInput packet birationalInput fano cubic) :
    packet.multiplicity fano = 2 :=
  Applications.genusEight_packet_eq_two_of_projectiveBundle_flop
    packet birationalInput input

/-- Reviewer-facing one-step irrationality deduction for a genus-eight Fano
threefold.  Its typed input keeps the cubic packet, projective-bundle flop, and
rational comparison visible. -/
theorem genusEight_oneStep_irrational_of_flop_inputs
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    {fano cubic : Variety}
    (input : Applications.GenusEightOneStepInput packet birationalInput fano cubic) :
    ¬ input.Rational input.stabilizedFano :=
  Applications.genusEight_oneStepStabilization_not_rational
    packet birationalInput input

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
