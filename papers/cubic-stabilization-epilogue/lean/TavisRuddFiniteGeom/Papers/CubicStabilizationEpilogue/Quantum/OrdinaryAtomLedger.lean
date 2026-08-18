import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.AtomicResidueDiscriminant

/-!
# The ordinary Hodge-atom ledger and its non-rationality criterion

This module records, as an abstract signature with explicit premises, the part
of the ordinary Hodge-atom package used by the atomic proof of one-step
irrationality.  A ledger assigns to each variety a dimension, a rationality
predicate, the operation of taking the product with a projective line, and the
multiplicity with which each atom occurs in its atomic composition.

The premises are the statements imported from L. Katzarkov, M. Kontsevich,
T. Pantev, and T. Y. Yu, *Birational invariants from Hodge structures and
quantum multiplication*, arXiv:2508.05105v2 (2026): the projective-bundle
formula for the atomic composition, which gives `CF (X × P¹) = 2 CF X`
(Proposition 5.22 and the chemical formulas used in its proof), and the
ordinary non-rationality criterion, which states that a smooth projective
`d`-fold whose atomic composition contains an atom occurring on no smooth
projective variety of dimension at most `d - 2` is not rational
(Proposition 5.30).

The exclusion premises record the surface and curve analysis: on a variety of
dimension at most two every occurring atom either already occurs on a variety
of dimension at most one, through the point-blowup and projective-bundle
formulas and the classification of minimal smooth projective surfaces, or has
even rank at least three, through the nef-canonical case; and an atom of even
rank two and odd rank at least four occurring on a variety of dimension at most
one has vanishing residue discriminant, by the curve computation of the
manuscript.

Lean proves only the combinatorial deduction on top of these premises.  It does
not construct varieties, `A`-model `F`-bundles, atoms, atomic compositions, or
any of the imported formulas, and it declares none of them as an axiom.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

variable {Variety Atom : Type*}

/-- The data appearing in the ordinary Hodge-atom argument: the dimension and
rationality of a variety, the product with a projective line, and the
multiplicity with which an atom occurs in the atomic composition of a variety.
This abstract signature names the objects used by the manuscript without
claiming a foundational construction of complex projective geometry or of the
atomic composition. -/
structure OrdinaryAtomLedger (Variety Atom : Type*) where
  dimension : Variety → ℕ
  multiplicity : Variety → Atom → ℕ
  Rational : Variety → Prop
  productWithProjectiveLine : Variety → Variety

/-- External mathematical input for the one-projective-line stabilization step:
the dimension of the product, the projective-bundle formula for the atomic
composition, and the ordinary non-rationality criterion. -/
structure ProjectiveLineStabilizationInput (ledger : OrdinaryAtomLedger Variety Atom) where
  productDimension : ∀ carrier : Variety,
    ledger.dimension (ledger.productWithProjectiveLine carrier) = ledger.dimension carrier + 1
  productMultiplicity : ∀ (carrier : Variety) (atom : Atom),
    ledger.multiplicity (ledger.productWithProjectiveLine carrier) atom =
      2 * ledger.multiplicity carrier atom
  nonRationality : ∀ (carrier : Variety) (atom : Atom),
    ledger.multiplicity carrier atom ≠ 0 →
    (∀ witness : Variety, ledger.dimension witness + 2 ≤ ledger.dimension carrier →
      ledger.multiplicity witness atom = 0) →
    ¬ ledger.Rational carrier

/-- An atom occurring in the atomic composition of a variety also occurs in the
atomic composition of its product with a projective line. -/
theorem multiplicity_productWithProjectiveLine_ne_zero
    {ledger : OrdinaryAtomLedger Variety Atom}
    (input : ProjectiveLineStabilizationInput ledger)
    {carrier : Variety} {atom : Atom}
    (occurs : ledger.multiplicity carrier atom ≠ 0) :
    ledger.multiplicity (ledger.productWithProjectiveLine carrier) atom ≠ 0 := by
  rw [input.productMultiplicity]
  omega

/-- If an atom occurs on a variety of dimension three and occurs on no variety
of dimension at most two, then the product of that variety with a projective
line is not rational. -/
theorem not_rational_productWithProjectiveLine_of_atom_excluded
    {ledger : OrdinaryAtomLedger Variety Atom}
    (input : ProjectiveLineStabilizationInput ledger)
    {carrier : Variety} {atom : Atom}
    (carrierDimension : ledger.dimension carrier = 3)
    (occurs : ledger.multiplicity carrier atom ≠ 0)
    (excluded : ∀ witness : Variety, ledger.dimension witness ≤ 2 →
      ledger.multiplicity witness atom = 0) :
    ¬ ledger.Rational (ledger.productWithProjectiveLine carrier) := by
  refine input.nonRationality _ atom
    (multiplicity_productWithProjectiveLine_ne_zero input occurs) ?_
  intro witness hwitness
  rw [input.productDimension, carrierDimension] at hwitness
  exact excluded witness (by omega)

/-- External mathematical input excluding low-dimensional representatives of an
atom.  The residue discriminant and the parity ranks are the invariants of an
ordinary Hodge atom used by the manuscript; the two implications record the
surface and curve analysis imported from the sources. -/
structure LowDimensionalExclusionInput (ledger : OrdinaryAtomLedger Variety Atom) where
  atomicResidueDiscriminant : Atom → ℚ
  evenRank : Atom → ℕ
  oddRank : Atom → ℕ
  surfaceDecomposition : ∀ (surface : Variety) (atom : Atom),
    ledger.dimension surface ≤ 2 → ledger.multiplicity surface atom ≠ 0 →
    (∃ curve : Variety, ledger.dimension curve ≤ 1 ∧ ledger.multiplicity curve atom ≠ 0) ∨
      3 ≤ evenRank atom
  curveResidueDiscriminant : ∀ (curve : Variety) (atom : Atom),
    ledger.dimension curve ≤ 1 → ledger.multiplicity curve atom ≠ 0 →
    evenRank atom = 2 → 4 ≤ oddRank atom → atomicResidueDiscriminant atom = 0

/-- An atom of even rank two, odd rank at least four, and nonzero residue
discriminant occurs on no smooth projective variety of dimension at most two. -/
theorem multiplicity_eq_zero_of_residueDiscriminant_ne_zero
    {ledger : OrdinaryAtomLedger Variety Atom}
    (exclusion : LowDimensionalExclusionInput ledger)
    {atom : Atom}
    (evenRankTwo : exclusion.evenRank atom = 2)
    (oddRankBound : 4 ≤ exclusion.oddRank atom)
    (nonzero : exclusion.atomicResidueDiscriminant atom ≠ 0)
    (witness : Variety) (witnessDimension : ledger.dimension witness ≤ 2) :
    ledger.multiplicity witness atom = 0 := by
  by_contra occurs
  rcases exclusion.surfaceDecomposition witness atom witnessDimension occurs with
    ⟨curve, curveDimension, curveOccurs⟩ | rankBound
  · exact nonzero
      (exclusion.curveResidueDiscriminant curve atom curveDimension curveOccurs evenRankTwo
        oddRankBound)
  · omega

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
