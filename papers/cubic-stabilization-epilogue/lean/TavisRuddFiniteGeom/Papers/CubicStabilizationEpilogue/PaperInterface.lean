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

/-- The midpoint inequality produces the parity-compatible exponents used in
the integral rank-one decomposition. -/
theorem rankOne_midpoint_exponents
    (diagonalFirst diagonalSecond cross : ℕ)
    (midpoint : diagonalFirst + diagonalSecond ≤ 2 * cross) :
    ∃ t r s : ℕ,
      diagonalFirst ≤ t + 2 * r ∧
      diagonalSecond ≤ t + 2 * s ∧
      cross = t + r + s :=
  GraphLattices.exists_midpoint_exponents
    diagonalFirst diagonalSecond cross midpoint

/-- Every multiple of a cross-ideal generator has the explicit division-free
three-rank-one decomposition supplied by the midpoint inequality. -/
theorem rankOne_cross_coefficient_decomposition
    {R : Type*} [CommRing R]
    (π z : R) (diagonalFirst diagonalSecond cross : ℕ)
    (midpoint : diagonalFirst + diagonalSecond ≤ 2 * cross) :
    ∃ t r s : ℕ,
      diagonalFirst ≤ t + 2 * r ∧
      diagonalSecond ≤ t + 2 * s ∧
      GraphLattices.SymmetricPair.sub
          (GraphLattices.SymmetricPair.sub
            (GraphLattices.SymmetricPair.scale (z * π ^ t)
              (GraphLattices.SymmetricPair.rankOne (π ^ r) (π ^ s)))
            (GraphLattices.SymmetricPair.scale
              ((z * π ^ t) * π ^ r * π ^ r)
              GraphLattices.SymmetricPair.firstSquare))
          (GraphLattices.SymmetricPair.scale
            ((z * π ^ t) * π ^ s * π ^ s)
            GraphLattices.SymmetricPair.secondSquare) =
        { diagonalFirst := 0, mixed := z * π ^ cross, diagonalSecond := 0 } :=
  GraphLattices.SymmetricPair.cross_coefficient_rankOne_decomposition
    π z diagonalFirst diagonalSecond cross midpoint

/-- Every member of a two-coordinate matrix-of-ideals lattice satisfying the
midpoint inequality is assembled from five explicitly displayed rank-one forms
that all remain in that same lattice. -/
theorem rankOne_weightedPair_decomposition_of_midpoint
    {R : Type*} [CommRing R]
    (π : R) (diagonalFirst diagonalSecond cross : ℕ)
    (midpoint : diagonalFirst + diagonalSecond ≤ 2 * cross)
    (form : GraphLattices.SymmetricPair R)
    (member : GraphLattices.SymmetricPair.MemWeightedPair
      π diagonalFirst diagonalSecond cross form) :
    ∃ firstCoefficient mixedCoefficient secondCoefficient : R,
      ∃ t r s : ℕ,
        diagonalFirst ≤ t + 2 * r ∧
        diagonalSecond ≤ t + 2 * s ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale
            (π ^ diagonalFirst * firstCoefficient)
            GraphLattices.SymmetricPair.firstSquare) ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale
            (π ^ diagonalSecond * secondCoefficient)
            GraphLattices.SymmetricPair.secondSquare) ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale (mixedCoefficient * π ^ t)
            (GraphLattices.SymmetricPair.rankOne (π ^ r) (π ^ s))) ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale
            ((mixedCoefficient * π ^ t) * π ^ r * π ^ r)
            GraphLattices.SymmetricPair.firstSquare) ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale
            ((mixedCoefficient * π ^ t) * π ^ s * π ^ s)
            GraphLattices.SymmetricPair.secondSquare) ∧
        form =
          GraphLattices.SymmetricPair.add
            (GraphLattices.SymmetricPair.scale
              (π ^ diagonalFirst * firstCoefficient)
              GraphLattices.SymmetricPair.firstSquare)
            (GraphLattices.SymmetricPair.add
              (GraphLattices.SymmetricPair.scale
                (π ^ diagonalSecond * secondCoefficient)
                GraphLattices.SymmetricPair.secondSquare)
              (GraphLattices.SymmetricPair.sub
                (GraphLattices.SymmetricPair.sub
                  (GraphLattices.SymmetricPair.scale (mixedCoefficient * π ^ t)
                    (GraphLattices.SymmetricPair.rankOne (π ^ r) (π ^ s)))
                  (GraphLattices.SymmetricPair.scale
                    ((mixedCoefficient * π ^ t) * π ^ r * π ^ r)
                    GraphLattices.SymmetricPair.firstSquare))
                (GraphLattices.SymmetricPair.scale
                  ((mixedCoefficient * π ^ t) * π ^ s * π ^ s)
                  GraphLattices.SymmetricPair.secondSquare))) :=
  GraphLattices.SymmetricPair.weightedPair_decomposition_of_midpoint
    π diagonalFirst diagonalSecond cross midpoint form member

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
    (geometry : Applications.CubicThreefoldGeometry Variety)
    {cubic : Variety}
    (input : Applications.CubicThreefoldOneStepInput
      packet birationalInput geometry cubic) :
    ¬ geometry.Rational (geometry.productWithProjectiveLine cubic) :=
  Applications.cubicThreefold_oneStepStabilization_not_rational
    packet birationalInput geometry input

/-- Reviewer-facing packet transport from an associated cubic threefold to a
genus-eight Fano threefold, conditional on the typed projective-bundle and flop
premises. -/
theorem genusEight_packet_eq_two_of_flop_inputs
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : Applications.GenusEightGeometry Variety)
    {fano : Variety}
    (input : Applications.GenusEightOneStepInput
      packet birationalInput geometry fano) :
    packet.multiplicity fano = 2 :=
  Applications.genusEight_packet_eq_two_of_projectiveBundle_flop
    packet birationalInput geometry input

/-- Reviewer-facing one-step irrationality deduction for a genus-eight Fano
threefold.  Its typed input keeps the cubic packet, projective-bundle flop, and
rational comparison visible. -/
theorem genusEight_oneStep_irrational_of_flop_inputs
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : Applications.GenusEightGeometry Variety)
    {fano : Variety}
    (input : Applications.GenusEightOneStepInput
      packet birationalInput geometry fano) :
    ¬ geometry.Rational (geometry.productWithProjectiveLine fano) :=
  Applications.genusEight_oneStepStabilization_not_rational
    packet birationalInput geometry input

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
