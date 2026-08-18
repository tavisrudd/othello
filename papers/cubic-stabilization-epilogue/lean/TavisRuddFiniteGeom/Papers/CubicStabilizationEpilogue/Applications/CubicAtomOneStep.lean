import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.OrdinaryAtomLedger
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.LowDimensionalAtomRepresentatives

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

The exclusion is available in two forms.  The first takes the surface and curve
analysis as two bundled implications.  The second takes it in the refined form
of the curve and surface representative inputs, where the point-blowup formula,
the passage to a minimal model, the nef-canonical lemma, the classification of
minimal surfaces, and the parity ranks of a curve atom appear as separate
premises; it yields the two exclusion statements of the manuscript separately,
including the intermediate identification of genus five as the only genus
compatible with the parity ranks.

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

/-- The invariants of the cubic zero-packet atom, as consumed by the refined
curve and surface analyses: even rank two, odd rank ten, and the residue
discriminant of the displayed cubic residue matrix. -/
structure CubicAtomRepresentativeInput
    (ledger : Quantum.OrdinaryAtomLedger Variety Atom)
    (curveInput : Quantum.CurveRepresentativeInput ledger) (atom : Atom) where
  atomEvenRank : curveInput.evenRank atom = 2
  atomOddRank : curveInput.oddRank atom = 10
  atomResidueDiscriminant : curveInput.atomicResidueDiscriminant atom =
    Quantum.residueDiscriminant Quantum.cubicZeroPacketResidue

/-- The residue discriminant of the cubic zero-packet atom is nonzero: it equals
four ninths. -/
theorem cubicAtom_residueDiscriminant_ne_zero
    {ledger : Quantum.OrdinaryAtomLedger Variety Atom}
    {curveInput : Quantum.CurveRepresentativeInput ledger} {atom : Atom}
    (input : CubicAtomRepresentativeInput ledger curveInput atom) :
    curveInput.atomicResidueDiscriminant atom ≠ 0 := by
  rw [input.atomResidueDiscriminant, Quantum.residueDiscriminant_cubicZeroPacketResidue]
  norm_num

/-- A smooth projective variety of dimension at most one carrying the cubic
zero-packet atom would have genus five: the atom is not a point atom, so its odd
rank is twice the genus.  The next statement shows no such variety exists. -/
theorem cubicAtom_genus_eq_five_of_representative
    {ledger : Quantum.OrdinaryAtomLedger Variety Atom}
    {curveInput : Quantum.CurveRepresentativeInput ledger} {atom : Atom}
    (input : CubicAtomRepresentativeInput ledger curveInput atom)
    (curve : Variety) (curveDimension : ledger.dimension curve ≤ 1)
    (occurs : ledger.multiplicity curve atom ≠ 0) :
    curveInput.genus curve = 5 :=
  Quantum.genus_eq_five_of_parityRanks curveInput curveDimension occurs input.atomEvenRank
    input.atomOddRank

/-- The cubic zero-packet atom occurs on no smooth projective variety of
dimension at most one: a point atom has even rank one, whereas this atom has
even rank two, and a curve atom has vanishing residue discriminant, whereas this
one has residue discriminant four ninths. -/
theorem cubicAtom_multiplicity_eq_zero_of_dimension_le_one
    {ledger : Quantum.OrdinaryAtomLedger Variety Atom}
    {curveInput : Quantum.CurveRepresentativeInput ledger} {atom : Atom}
    (input : CubicAtomRepresentativeInput ledger curveInput atom)
    (curve : Variety) (curveDimension : ledger.dimension curve ≤ 1) :
    ledger.multiplicity curve atom = 0 :=
  Quantum.multiplicity_eq_zero_of_dimension_le_one curveInput input.atomEvenRank
    (cubicAtom_residueDiscriminant_ne_zero input) curve curveDimension

/-- The cubic zero-packet atom occurs on no smooth projective variety of
dimension at most two, through the refined surface analysis: it survives the
blow-down to a minimal model, the nef case would force even rank at least three,
and the remaining minimal surfaces carry only point and curve atoms, which the
curve analysis has excluded. -/
theorem cubicAtom_multiplicity_eq_zero_of_surface_analysis
    {ledger : Quantum.OrdinaryAtomLedger Variety Atom}
    {curveInput : Quantum.CurveRepresentativeInput ledger}
    (surfaceInput : Quantum.SurfaceRepresentativeInput ledger curveInput) {atom : Atom}
    (input : CubicAtomRepresentativeInput ledger curveInput atom)
    (witness : Variety) (witnessDimension : ledger.dimension witness ≤ 2) :
    ledger.multiplicity witness atom = 0 :=
  Quantum.multiplicity_eq_zero_of_dimension_le_two surfaceInput input.atomEvenRank
    (cubicAtom_residueDiscriminant_ne_zero input) witness witnessDimension

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
