import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.RankOneGeneration
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.BirationalDeduction

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

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
