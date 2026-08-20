import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisPrimaryKernelStability
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointStableHalfFrobenius

/-!
# Selecting the exotic member for the two-primary kernel of the six-axis source

An integral comparison matrix pulling a unimodular alternating form back to the
six-axis source polarization has a two-primary kernel whose transport into the
standard symplectic coordinates is maximal isotropic, and, when the comparison
is equivariant for the two displayed generators of the six-label action, is one
of the five members of the packet of diagonally stable halves of the
coefficient heart.

Equivariance cannot go further: the packet is exactly the set of diagonally
stable maximal-isotropic subspaces, so every one of its five members satisfies
the same group hypothesis.  What distinguishes the two exotic members is
Frobenius marking, the assertion that the packet class of the transported
kernel is moved by the Frobenius involution of the packet.  This module records
that the marked transported kernel is one of the two exotic members, and that
its graph slope then has minimal polynomial `t²+t+1` over the field with two
elements, which is the coefficient-side slope datum of the marked finite-etale
graph presentation at the prime two.

Trust boundary.  All objects here are explicit integral or `F₂`-valued matrices
and subspaces.  The comparison matrix, its equivariance, and the marking are
hypotheses; no relative isogeny, torsion group scheme, Weil pairing, geometric
group action, or arithmetic Frobenius of a family is constructed, and nothing
identifies the marking with a geometric Galois or normalizer action.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open Polynomial

open scoped Matrix

noncomputable section

variable {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}

/-- The packet class of the transported two-primary kernel of an equivariant
comparison matrix, as a member of the five-member packet of diagonally stable
halves of the coefficient heart. -/
def sixAxisSourceTwoPrimaryKernelPacketMember
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (equivariant : SixAxisComparisonAlternatingEquivariant comparison) :
    {subspace // subspace ∈ SixPointHeartStableHalfPacket} :=
  ⟨(sixAxisSourceTwoPrimaryKernelCoordinates pullback).map
      sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap,
    sixAxisSourceTwoPrimaryKernelCoordinates_equivariantPacket principal pullback
      equivariant⟩

/-- Frobenius marking of the transported two-primary kernel is exactly
membership in the exotic pair: the three members defined over the prime field
are fixed by the Frobenius involution of the packet. -/
theorem sixAxisSourceTwoPrimaryKernelCoordinates_marked_iff_exotic
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (equivariant : SixAxisComparisonAlternatingEquivariant comparison) :
    SixPointHeartFrobeniusMarked
        ((sixAxisSourceTwoPrimaryKernelCoordinates pullback).map
          sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap) ↔
      (sixAxisSourceTwoPrimaryKernelCoordinates pullback).map
          sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
        SixPointHeartExoticHalfPair :=
  sixPointHeartFrobeniusMarked_iff_exotic
    (sixAxisSourceTwoPrimaryKernelCoordinates_equivariantPacket principal pullback
      equivariant)

/-- Marked selection of the exotic member.  For an equivariant comparison
matrix whose transported two-primary kernel is moved by the Frobenius
involution of the packet, that kernel is one of the two exotic members, hence
the graph of a slope annihilated by the irreducible quadratic `t²+t+1`, whose
minimal polynomial over the field with two elements is that polynomial. -/
theorem sixAxisSourceTwoPrimaryKernelCoordinates_exoticSelection
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (equivariant : SixAxisComparisonAlternatingEquivariant comparison)
    (marked : SixPointHeartFrobeniusMarked
      ((sixAxisSourceTwoPrimaryKernelCoordinates pullback).map
        sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap)) :
    (sixAxisSourceTwoPrimaryKernelCoordinates pullback).map
          sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
        SixPointHeartExoticHalfPair ∧
      ∃ slope : Matrix (Fin 4) (Fin 4) F2,
        (sixAxisSourceTwoPrimaryKernelCoordinates pullback).map
            sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap =
            LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' slope)) ∧
          slope ^ 2 + slope + 1 = 0 ∧
          minpoly F2 slope = sixAxisQuadraticSlopePolynomial := by
  have exotic :=
    (sixAxisSourceTwoPrimaryKernelCoordinates_marked_iff_exotic principal pullback
      equivariant).mp marked
  exact ⟨exotic, sixPointHeartExoticHalfPair_graphSlope exotic⟩

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
