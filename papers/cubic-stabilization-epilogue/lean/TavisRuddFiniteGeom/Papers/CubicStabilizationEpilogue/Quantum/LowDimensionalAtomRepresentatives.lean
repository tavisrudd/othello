import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.OrdinaryAtomLedger

/-!
# Curve and surface representatives of an ordinary Hodge atom

This module refines the low-dimensional exclusion step of the atomic argument
into the two analyses the manuscript performs, with the imported geometry named
premise by premise rather than bundled into one implication.

The curve analysis.  On a smooth projective variety of dimension at most one,
every occurring atom is either a point atom, of even rank one, or the single
atom of a curve with nef canonical class, whose parity ranks are `(2, 2g)` for
the genus `g` and whose residue discriminant vanishes.  The first case comes
from the projective-bundle formula for a projective line together with the
point calculation, the second from the nef-canonical lemma, the classical cup
product on a curve of positive genus, and the residue computation of the
modified lattice.  Two consequences follow: the parity ranks of an atom of even
rank two and odd rank ten force the genus to be five, and such an atom with
nonzero residue discriminant occurs on no variety of dimension at most one.

The surface analysis.  Blowing down at a point adds a point atom, so an atom of
even rank at least two occurring on a surface already occurs on a minimal
model; and on a minimal model either the canonical class is nef, forcing even
rank at least three, or the classification of minimal smooth complex projective
surfaces leaves the projective plane and the geometrically ruled surfaces, on
which the projective-bundle formulas make every occurring atom a point or curve
atom.  Combining this with the curve analysis excludes an atom of even rank two
and nonzero residue discriminant from every variety of dimension at most two.

The parity ranks and the residue discriminant of an atom, the genus of a curve,
and the passage to a minimal model are supplied functions.  Lean constructs no
variety, atom, atomic composition, blow-down, or minimal model, proves none of
the imported formulas, and declares none of them as an axiom; each is a field of
the input structures and therefore visible in every theorem type below.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

variable {Variety Atom : Type*}

/-- The curve analysis as external mathematical input.  The parity ranks and the
residue discriminant are the invariants of an ordinary Hodge atom, `genus` is
the genus of a curve, and the dichotomy records what occurs on a smooth
projective variety of dimension at most one: a point atom, of even rank one, or
the single nef-canonical atom of a curve, of parity ranks `(2, 2g)` and
vanishing residue discriminant. -/
structure CurveRepresentativeInput (ledger : OrdinaryAtomLedger Variety Atom) where
  evenRank : Atom → ℕ
  oddRank : Atom → ℕ
  atomicResidueDiscriminant : Atom → ℚ
  genus : Variety → ℕ
  lowDimensionalAtom : ∀ (curve : Variety) (atom : Atom),
    ledger.dimension curve ≤ 1 → ledger.multiplicity curve atom ≠ 0 →
      evenRank atom = 1 ∨
        (evenRank atom = 2 ∧ oddRank atom = 2 * genus curve ∧
          atomicResidueDiscriminant atom = 0)

/-- An atom of even rank two and odd rank ten occurring on a smooth projective
variety of dimension at most one forces that variety to have genus five: it
cannot be a point atom, so its odd rank is twice the genus. -/
theorem genus_eq_five_of_parityRanks {ledger : OrdinaryAtomLedger Variety Atom}
    (input : CurveRepresentativeInput ledger) {curve : Variety} {atom : Atom}
    (curveDimension : ledger.dimension curve ≤ 1)
    (occurs : ledger.multiplicity curve atom ≠ 0)
    (evenRankTwo : input.evenRank atom = 2) (oddRankTen : input.oddRank atom = 10) :
    input.genus curve = 5 := by
  rcases input.lowDimensionalAtom curve atom curveDimension occurs with pointAtom | curveAtom
  · omega
  · omega

/-- No smooth projective variety of dimension at most one represents an atom of
even rank two whose residue discriminant is nonzero.  A point atom has even rank
one, and the only alternative is a curve atom, whose residue discriminant
vanishes. -/
theorem multiplicity_eq_zero_of_dimension_le_one
    {ledger : OrdinaryAtomLedger Variety Atom}
    (input : CurveRepresentativeInput ledger) {atom : Atom}
    (evenRankTwo : input.evenRank atom = 2)
    (discriminantNonzero : input.atomicResidueDiscriminant atom ≠ 0)
    (curve : Variety) (curveDimension : ledger.dimension curve ≤ 1) :
    ledger.multiplicity curve atom = 0 := by
  by_contra occurs
  rcases input.lowDimensionalAtom curve atom curveDimension occurs with pointAtom | curveAtom
  · omega
  · exact discriminantNonzero curveAtom.2.2

/-- The surface analysis as external mathematical input, over the invariants of
the curve analysis.  `minimalModel` records the result of blowing down
`(-1)`-curves.  The first premise is the point-blowup formula in the form used:
an atom of even rank at least two, so not a point atom, survives the blow-down.
The second is the classification of minimal smooth complex projective surfaces
together with the nef-canonical lemma and the projective-bundle formulas: on a
minimal model an occurring atom either has even rank at least three or occurs
already on a smooth projective variety of dimension at most one. -/
structure SurfaceRepresentativeInput (ledger : OrdinaryAtomLedger Variety Atom)
    (curveInput : CurveRepresentativeInput ledger) where
  minimalModel : Variety → Variety
  pointBlowupDescent : ∀ (surface : Variety) (atom : Atom),
    ledger.dimension surface ≤ 2 → ledger.multiplicity surface atom ≠ 0 →
    2 ≤ curveInput.evenRank atom →
      ledger.multiplicity (minimalModel surface) atom ≠ 0
  minimalModelAtom : ∀ (surface : Variety) (atom : Atom),
    ledger.dimension surface ≤ 2 →
    ledger.multiplicity (minimalModel surface) atom ≠ 0 →
      3 ≤ curveInput.evenRank atom ∨
        ∃ curve : Variety,
          ledger.dimension curve ≤ 1 ∧ ledger.multiplicity curve atom ≠ 0

/-- No smooth projective variety of dimension at most two represents an atom of
even rank two whose residue discriminant is nonzero.  The atom survives the
blow-down to a minimal model, where the nef case would force even rank at least
three and the remaining minimal surfaces carry only point and curve atoms; the
curve analysis excludes those. -/
theorem multiplicity_eq_zero_of_dimension_le_two
    {ledger : OrdinaryAtomLedger Variety Atom}
    {curveInput : CurveRepresentativeInput ledger}
    (surfaceInput : SurfaceRepresentativeInput ledger curveInput) {atom : Atom}
    (evenRankTwo : curveInput.evenRank atom = 2)
    (discriminantNonzero : curveInput.atomicResidueDiscriminant atom ≠ 0)
    (witness : Variety) (witnessDimension : ledger.dimension witness ≤ 2) :
    ledger.multiplicity witness atom = 0 := by
  by_contra occurs
  have descent : ledger.multiplicity (surfaceInput.minimalModel witness) atom ≠ 0 :=
    surfaceInput.pointBlowupDescent witness atom witnessDimension occurs (by omega)
  rcases surfaceInput.minimalModelAtom witness atom witnessDimension descent with
    nefRank | ⟨curve, curveDimension, curveOccurs⟩
  · omega
  · exact curveOccurs
      (multiplicity_eq_zero_of_dimension_le_one curveInput evenRankTwo discriminantNonzero
        curve curveDimension)

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
