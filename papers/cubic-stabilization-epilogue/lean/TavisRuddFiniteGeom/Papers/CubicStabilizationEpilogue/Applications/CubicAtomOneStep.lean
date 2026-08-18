import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.OrdinaryAtomLedger

/-!
# The atomic route to one-step irrationality for a cubic threefold

This module assembles the ordinary Hodge-atom argument of the manuscript for a
single smooth cubic threefold.  The atom in question is the zero packet of the
small even Euler multiplication at the small hyperplane point: its generalized
eigenbundle has even rank two and odd rank ten, and the residue of its
canonical elementary modification is the explicit rational matrix evaluated in
`TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.residueDiscriminant_cubicZeroPacketResidue`,
whose residue discriminant is `4 / 9`.

Given those data, together with the ledger premises recording the
projective-bundle formula, the ordinary non-rationality criterion, and the
surface and curve analysis, Lean derives that the atom occurs on no smooth
projective variety of dimension at most two and hence that the product of the
threefold with a projective line is not rational.

Lean does not construct the threefold, its quantum connection, the spectral
cover, the atom, or any imported formula; every such statement is a premise
visible in the theorem type.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

variable {Variety Atom : Type*}

/-- The data of the cubic zero-packet atom used by the atomic route: its parity
ranks and the value of its residue discriminant. -/
structure CubicAtomOneStepInput
    (ledger : Quantum.OrdinaryAtomLedger Variety Atom)
    (stabilization : Quantum.ProjectiveLineStabilizationInput ledger)
    (exclusion : Quantum.LowDimensionalExclusionInput ledger)
    (cubic : Variety) (atom : Atom) where
  cubicDimension : ledger.dimension cubic = 3
  atomOccurs : ledger.multiplicity cubic atom ≠ 0
  atomEvenRank : exclusion.evenRank atom = 2
  atomOddRank : exclusion.oddRank atom = 10
  atomResidueDiscriminant : exclusion.atomicResidueDiscriminant atom =
    Quantum.residueDiscriminant Quantum.cubicZeroPacketResidue

/-- The cubic zero-packet atom occurs on no smooth projective variety of
dimension at most two: its residue discriminant is `4 / 9`, whereas a curve
representative would force the value `0`, and its even rank is two, whereas a
nef-canonical surface representative would force even rank at least three. -/
theorem cubicAtom_multiplicity_eq_zero_of_dimension_le_two
    {ledger : Quantum.OrdinaryAtomLedger Variety Atom}
    {stabilization : Quantum.ProjectiveLineStabilizationInput ledger}
    {exclusion : Quantum.LowDimensionalExclusionInput ledger}
    {cubic : Variety} {atom : Atom}
    (input : CubicAtomOneStepInput ledger stabilization exclusion cubic atom)
    (witness : Variety) (witnessDimension : ledger.dimension witness ≤ 2) :
    ledger.multiplicity witness atom = 0 := by
  refine Quantum.multiplicity_eq_zero_of_residueDiscriminant_ne_zero exclusion
    input.atomEvenRank (by rw [input.atomOddRank]; omega) ?_ witness witnessDimension
  rw [input.atomResidueDiscriminant, Quantum.residueDiscriminant_cubicZeroPacketResidue]
  norm_num

/-- Under the stated atom, ledger, and exclusion premises, the product of the
cubic threefold with a projective line is not rational. -/
theorem cubicAtom_oneStepStabilization_not_rational
    {ledger : Quantum.OrdinaryAtomLedger Variety Atom}
    (stabilization : Quantum.ProjectiveLineStabilizationInput ledger)
    {exclusion : Quantum.LowDimensionalExclusionInput ledger}
    {cubic : Variety} {atom : Atom}
    (input : CubicAtomOneStepInput ledger stabilization exclusion cubic atom) :
    ¬ ledger.Rational (ledger.productWithProjectiveLine cubic) :=
  Quantum.not_rational_productWithProjectiveLine_of_atom_excluded stabilization
    input.cubicDimension input.atomOccurs
    (cubicAtom_multiplicity_eq_zero_of_dimension_le_two input)

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
