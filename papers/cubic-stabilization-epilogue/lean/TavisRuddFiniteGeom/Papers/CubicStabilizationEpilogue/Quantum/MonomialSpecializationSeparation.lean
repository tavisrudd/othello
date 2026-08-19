import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.NovikovAdmissibility
import Mathlib.LinearAlgebra.LinearIndependent.Basic
import Mathlib.Analysis.SpecialFunctions.Complex.Circle

/-!
# Separating the specialized Novikov values of a minimal rational ruled surface

The Euler spectrum of a specialized minimal rational ruled surface degenerates
exactly on one locus in the two specialized values `u`, the image of the fibre
monomial, and `w`, the image of the section monomial shifted by `k` fibres:
`u = w` when the index is even, and `256 u + 27 w ^ 2 = 0` when it is odd.  This
module proves that neither locus is met, by two arguments of different strength.

The first argument uses only the valuation law of a strictly Novikov-admissible
specialization.  The length of the shifted section class is the length of the
section class plus `k` times the length of the fibre class, and lengths are
positive on nonzero effective classes, so for `k` at least one the two values
have different valuations.  Two elements of different valuation are distinct,
and a combination of them with unit coefficients is nonzero, because a vanishing
combination would make one the negative of the other and the valuation of a
negative is unchanged.  This settles every index of at least two.

The second argument is needed only for index one, where the shift is zero and
the two lengths may agree.  It uses that the specializations produced by the
blowup comparison are monomial: the image of each effective monomial has, in the
associated graded ring, a leading term belonging to one linearly independent
family.  A vanishing combination of two such leading terms with coefficients
`256` and `27` would force the two leading terms to be equal, since distinct
members of a linearly independent family admit no vanishing combination with
nonzero coefficients, and then `256 + 27` would have to vanish.

Lean constructs no completed monoid ring, no associated graded ring, and no
Novikov specialization.  The valuation arguments are proved inside the algebraic
core of strict Novikov admissibility; the leading-term argument takes the
leading-term map and the independent family as data.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

section Valuation

variable {Curve Target : Type*}
variable [AddCommMonoid Curve] [CommRing Target] [IsDomain Target]
variable [UniformSpace Target] [CompleteSpace Target] [T2Space Target]
variable [IsTopologicalRing Target]

variable (specialization : StrictNovikovAdmissible (Curve := Curve) (Target := Target))

/-- The unit of the coefficient ring has valuation zero. -/
theorem StrictNovikovAdmissible.valuation_one : specialization.valuation 1 = 0 := by
  have doubled := specialization.valuation_mul (left := (1 : Target)) (right := (1 : Target))
    one_ne_zero one_ne_zero
  rw [one_mul] at doubled
  omega

/-- The negative of the unit has valuation zero. -/
theorem StrictNovikovAdmissible.valuation_neg_one : specialization.valuation (-1) = 0 := by
  have negativeNonzero : (-1 : Target) ≠ 0 := by
    simp
  have doubled := specialization.valuation_mul negativeNonzero negativeNonzero
  rw [neg_mul_neg, one_mul, specialization.valuation_one] at doubled
  omega

/-- Negation does not change the valuation of a nonzero element. -/
theorem StrictNovikovAdmissible.valuation_neg {value : Target} (nonzero : value ≠ 0) :
    specialization.valuation (-value) = specialization.valuation value := by
  have negativeNonzero : (-1 : Target) ≠ 0 := by
    simp
  have product := specialization.valuation_mul negativeNonzero nonzero
  rw [neg_one_mul, specialization.valuation_neg_one] at product
  omega

/-- A unit of the coefficient ring has valuation zero. -/
theorem StrictNovikovAdmissible.valuation_isUnit {value : Target} (unit : IsUnit value) :
    specialization.valuation value = 0 := by
  obtain ⟨element, inverse⟩ := unit.exists_right_inv
  have valueNonzero : value ≠ 0 := unit.ne_zero
  have inverseNonzero : element ≠ 0 := by
    intro vanishing
    rw [vanishing, mul_zero] at inverse
    exact one_ne_zero inverse.symm
  have product := specialization.valuation_mul valueNonzero inverseNonzero
  rw [inverse, specialization.valuation_one] at product
  omega

/-- Lengths of effective classes are additive, because the valuation of a
product of nonzero elements is the sum of the valuations. -/
theorem StrictNovikovAdmissible.length_add (left right : Curve) :
    specialization.length (left + right)
      = specialization.length left + specialization.length right := by
  have product := specialization.valuation_mul
    (specialization.monomialImage_ne_zero left) (specialization.monomialImage_ne_zero right)
  rw [← specialization.monomialImage_add, specialization.valuation_law,
    specialization.valuation_law, specialization.valuation_law] at product
  exact product

/-- The length of a repeated class is the multiple of its length. -/
theorem StrictNovikovAdmissible.length_nsmul (multiple : ℕ) (degree : Curve) :
    specialization.length (multiple • degree) = multiple * specialization.length degree := by
  induction multiple with
  | zero =>
      have zeroLength : specialization.length 0 = 0 := by
        have := specialization.valuation_law (0 : Curve)
        rw [specialization.monomialImage_zero, specialization.valuation_one] at this
        exact this.symm
      simpa using zeroLength
  | succ multiple inductionHypothesis =>
      rw [succ_nsmul, specialization.length_add, inductionHypothesis]
      ring

/-- Two elements of different valuation are distinct. -/
theorem StrictNovikovAdmissible.ne_of_valuation_ne {left right : Target}
    (different : specialization.valuation left ≠ specialization.valuation right) :
    left ≠ right := by
  intro equal
  exact different (by rw [equal])

/-- A combination with unit coefficients of two nonzero elements of different
valuation is nonzero: a vanishing combination would make one of them the
negative of the other, and negation preserves the valuation. -/
theorem StrictNovikovAdmissible.combination_ne_zero_of_valuation_ne
    {first second coefficientFirst coefficientSecond : Target}
    (firstUnit : IsUnit coefficientFirst) (secondUnit : IsUnit coefficientSecond)
    (firstNonzero : first ≠ 0) (secondNonzero : second ≠ 0)
    (different : specialization.valuation first ≠ specialization.valuation second) :
    coefficientFirst * first + coefficientSecond * second ≠ 0 := by
  intro vanishing
  have firstProductNonzero : coefficientFirst * first ≠ 0 :=
    mul_ne_zero firstUnit.ne_zero firstNonzero
  have secondProductNonzero : coefficientSecond * second ≠ 0 :=
    mul_ne_zero secondUnit.ne_zero secondNonzero
  have opposite : coefficientFirst * first = -(coefficientSecond * second) := by
    linear_combination vanishing
  have firstValuation : specialization.valuation (coefficientFirst * first)
      = specialization.valuation first := by
    rw [specialization.valuation_mul firstUnit.ne_zero firstNonzero,
      specialization.valuation_isUnit firstUnit]
    omega
  have secondValuation : specialization.valuation (-(coefficientSecond * second))
      = specialization.valuation second := by
    rw [specialization.valuation_neg secondProductNonzero,
      specialization.valuation_mul secondUnit.ne_zero secondNonzero,
      specialization.valuation_isUnit secondUnit]
    omega
  exact different (by rw [← firstValuation, opposite, secondValuation])

/-- The specialized fibre value and the specialized shifted-section value are
distinct once the shift is positive: this is the even degeneracy locus, and it
is excluded by the valuation law alone. -/
theorem StrictNovikovAdmissible.fibre_ne_shiftedSection
    {fibre sectionClass : Curve} (fibreNonzero : fibre ≠ 0) (sectionNonzero : sectionClass ≠ 0)
    {shift : ℕ} (positiveShift : 0 < shift) :
    specialization.monomialImage fibre
      ≠ specialization.monomialImage (sectionClass + shift • fibre) := by
  refine specialization.ne_of_valuation_ne ?_
  rw [specialization.valuation_law, specialization.valuation_law,
    specialization.length_add, specialization.length_nsmul]
  have positiveFibre := specialization.positive fibre fibreNonzero
  have positiveSection := specialization.positive sectionClass sectionNonzero
  have : specialization.length fibre ≤ shift * specialization.length fibre :=
    Nat.le_mul_of_pos_left _ positiveShift
  omega

/-- The odd degeneracy locus is not met once the shift is positive: the fibre
value and the square of the shifted-section value have different valuations, so
no combination of them with unit coefficients vanishes. -/
theorem StrictNovikovAdmissible.oddCombination_ne_zero
    {fibre sectionClass : Curve} (fibreNonzero : fibre ≠ 0) (sectionNonzero : sectionClass ≠ 0)
    {shift : ℕ} (positiveShift : 0 < shift)
    {coefficientFibre coefficientSection : Target}
    (fibreUnit : IsUnit coefficientFibre) (sectionUnit : IsUnit coefficientSection) :
    coefficientFibre * specialization.monomialImage fibre
        + coefficientSection * specialization.monomialImage (sectionClass + shift • fibre) ^ 2
      ≠ 0 := by
  have squareNonzero :
      specialization.monomialImage (sectionClass + shift • fibre) ^ 2 ≠ 0 :=
    pow_ne_zero 2 (specialization.monomialImage_ne_zero _)
  refine specialization.combination_ne_zero_of_valuation_ne fibreUnit sectionUnit
    (specialization.monomialImage_ne_zero fibre) squareNonzero ?_
  have squareValuation :
      specialization.valuation (specialization.monomialImage (sectionClass + shift • fibre) ^ 2)
        = 2 * specialization.length (sectionClass + shift • fibre) := by
    have nonzero := specialization.monomialImage_ne_zero (sectionClass + shift • fibre)
    rw [sq, specialization.valuation_mul nonzero nonzero, specialization.valuation_law]
    ring
  rw [specialization.valuation_law, squareValuation, specialization.length_add,
    specialization.length_nsmul]
  have positiveFibre := specialization.positive fibre fibreNonzero
  have positiveSection := specialization.positive sectionClass sectionNonzero
  have : specialization.length fibre ≤ shift * specialization.length fibre :=
    Nat.le_mul_of_pos_left _ positiveShift
  omega

end Valuation

/-- An element with nonzero leading term is nonzero. -/
theorem ne_zero_of_leadingTerm_ne_zero {Target Leading : Type*} [Zero Target] [Zero Leading]
    (leadingTerm : Target → Leading) (leadingTerm_zero : leadingTerm 0 = 0)
    {value : Target} (nonzero : leadingTerm value ≠ 0) : value ≠ 0 := by
  intro vanishing
  exact nonzero (by rw [vanishing, leadingTerm_zero])

section LeadingTerms

variable {Index Graded : Type*} [AddCommGroup Graded] [Module ℂ Graded]

/-- No combination of two members of a linearly independent family vanishes when
the first coefficient and the sum of the two coefficients are nonzero.  For
members with a common index the statement is that the sum of the coefficients
does not annihilate a nonzero vector; for distinct indices it is linear
independence of the pair, which forces the first coefficient to vanish. -/
theorem monomialCombination_ne_zero {monomial : Index → Graded}
    (independent : LinearIndependent ℂ monomial) {first second : Index}
    {coefficientFirst coefficientSecond : ℂ}
    (firstNonzero : coefficientFirst ≠ 0)
    (sumNonzero : coefficientFirst + coefficientSecond ≠ 0) :
    coefficientFirst • monomial first + coefficientSecond • monomial second ≠ 0 := by
  classical
  by_cases equalIndices : first = second
  · subst equalIndices
    rw [← add_smul]
    exact smul_ne_zero sumNonzero (independent.ne_zero first)
  · intro vanishing
    have injective : Function.Injective (![first, second] : Fin 2 → Index) := by
      intro left right equality
      fin_cases left <;> fin_cases right <;> simp_all
    have equalFamily : (monomial ∘ ![first, second]) = ![monomial first, monomial second] := by
      funext position
      fin_cases position <;> rfl
    have pairIndependent : LinearIndependent ℂ ![monomial first, monomial second] := by
      rw [← equalFamily]
      exact independent.comp _ injective
    obtain ⟨firstZero, _⟩ := LinearIndependent.pair_iff.mp pairIndependent
      coefficientFirst coefficientSecond vanishing
    exact firstNonzero firstZero

/-- The odd degeneracy locus is not met by a monomial specialization, whatever
the shift.  The premise is that the leading term of the combination is the
corresponding combination of two members of a linearly independent family of
monomials, which is what a specialization with monomial associated graded image
supplies once the two terms have equal valuation. -/
theorem oddCombination_ne_zero_of_monomialLeadingTerms {Target : Type*} [CommRing Target]
    (leadingTerm : Target → Graded) (leadingTerm_zero : leadingTerm 0 = 0)
    {monomial : Index → Graded} (independent : LinearIndependent ℂ monomial)
    {first second : Index} {fibreValue sectionValue : Target}
    (leading : leadingTerm (256 * fibreValue + 27 * sectionValue ^ 2)
      = (256 : ℂ) • monomial first + (27 : ℂ) • monomial second) :
    256 * fibreValue + 27 * sectionValue ^ 2 ≠ 0 := by
  refine ne_zero_of_leadingTerm_ne_zero leadingTerm leadingTerm_zero ?_
  rw [leading]
  exact monomialCombination_ne_zero independent (by norm_num) (by norm_num)

end LeadingTerms

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
