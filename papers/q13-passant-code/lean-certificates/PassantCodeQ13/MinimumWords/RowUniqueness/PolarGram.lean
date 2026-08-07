import PassantCodeQ13.PlaneJoin

/-!
# The polar Gram determinant of three points of the conic plane

The nonsingular conic `Y^2 - XZ = 0` over `ZMod 13` carries the symmetric bilinear form
`polarValue P R = 2 P.y R.y - P.x R.z - P.z R.x` on homogeneous coordinate triples, whose diagonal
`polarValue P P` is twice `pointDiscriminant P = P.y^2 - P.x P.z`.  A point is internal exactly when
its discriminant is a nonzero nonsquare.

This module computes the determinant of the three-by-three matrix of polar values of three triples
and normalizes it by the three discriminants:

  `normalizedPolarGram P R S = det (polarValue Pᵢ Pⱼ) / (2 · Δ(P) Δ(R) Δ(S))`.

Two readings of that quantity meet here.  Expanding the determinant expresses it in the projective
invariants of the triple, `4` minus the three elliptic parameters `polarInvariant` of its pairs
minus the triple parameter `polarTripleInvariant`; that is the form in which the invariants of a
triple of internal points are compared.  Substituting the Gram factorization instead expresses it as
`-(det V)^2 / (Δ(P) Δ(R) Δ(S))` for the coordinate matrix `V` with rows `P`, `R`, `S`, since the
form's own matrix has determinant `-2`.

The second reading is the discriminant law.  The normalized Gram vanishes exactly when the three
coordinate triples are dependent, that is when the three points are collinear; and when they are not
collinear it is the product of a nonzero square with the negated inverse of a product of three
nonsquares, so it is a nonsquare.  It is never a nonzero square.  Geometrically this is the
statement that three independent lifts span the ambient three-dimensional quadratic space, so the
form they carry is the ambient form, and over a finite field a nondegenerate ternary form is
determined by its discriminant.

A final section records the companion fact for four triples: the four-by-four matrix of their polar
values is singular, because four coordinate triples are dependent.

Every identity here is a polynomial identity in the coordinates.  The finite content is two
exhaustions over the elements of `ZMod 13`, both discharged by kernel reduction: that a product of
three nonsquares has nonsquare negated inverse, over ordered triples of elements, and one scalar
identity clearing the factor two, over ordered pairs.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.PlaneJoin
open PassantCodeQ13.SymmetricSquare

/-- The determinant of the matrix whose rows are the three coordinate triples.  It vanishes exactly
when the three triples are linearly dependent. -/
def coordinateDeterminant (first second third : Triple) : Field13 :=
  first.x * (second.y * third.z - second.z * third.y)
    - first.y * (second.x * third.z - second.z * third.x)
    + first.z * (second.x * third.y - second.y * third.x)

/-- The join of the first two triples pairs with the third to the coordinate determinant, so the
determinant vanishes exactly when the third triple lies on the line joining the first two. -/
theorem dotTriple_joinTriple_eq_coordinateDeterminant (first second third : Triple) :
    dotTriple (joinTriple first second) third = coordinateDeterminant first second third := by
  simp only [dotTriple, joinTriple, coordinateDeterminant]
  ring

/-- The determinant of the three-by-three matrix of polar values of three coordinate triples. -/
def polarGramDeterminant (first second third : Triple) : Field13 :=
  polarValue first first *
      (polarValue second second * polarValue third third
        - polarValue second third * polarValue third second)
    - polarValue first second *
      (polarValue second first * polarValue third third
        - polarValue second third * polarValue third first)
    + polarValue first third *
      (polarValue second first * polarValue third second
        - polarValue second second * polarValue third first)

/-- The polar form has matrix determinant `-2` in the standard coordinates, so the Gram determinant
of three triples is `-2` times the square of their coordinate determinant. -/
theorem polarGramDeterminant_eq_neg_two_mul_sq (first second third : Triple) :
    polarGramDeterminant first second third
      = -2 * coordinateDeterminant first second third ^ 2 := by
  simp only [polarGramDeterminant, polarValue, coordinateDeterminant]
  ring

/-- The triple parameter of three coordinate triples: the negated product of the three polar values,
normalized by the three discriminants.  Like the elliptic parameter `polarInvariant` of a pair it is
unchanged by rescaling any of the three triples, because each triple occurs in exactly two of the
three factors of the numerator. -/
def polarTripleInvariant (first second third : Triple) : Field13 :=
  -(polarValue first second * polarValue first third * polarValue second third) *
    (pointDiscriminant first * pointDiscriminant second * pointDiscriminant third)⁻¹

/-- The polar Gram determinant of three coordinate triples, normalized by twice the product of their
discriminants. -/
def normalizedPolarGram (first second third : Triple) : Field13 :=
  polarGramDeterminant first second third *
    (2 * (pointDiscriminant first * pointDiscriminant second * pointDiscriminant third))⁻¹

/-- Expanding the Gram determinant writes the normalized Gram in the projective invariants of the
triple: `4` minus the elliptic parameters of the three pairs minus the triple parameter. -/
theorem normalizedPolarGram_eq_four_sub_invariants {first second third : Triple}
    (first_nondegenerate : pointDiscriminant first ≠ 0)
    (second_nondegenerate : pointDiscriminant second ≠ 0)
    (third_nondegenerate : pointDiscriminant third ≠ 0) :
    normalizedPolarGram first second third
      = 4 - (polarInvariant first second + polarInvariant first third
          + polarInvariant second third)
        - polarTripleInvariant first second third := by
  have two_nonzero : (2 : Field13) ≠ 0 := by decide
  haveI : Fact (Nat.Prime 13) := ⟨by norm_num⟩
  simp only [normalizedPolarGram, polarGramDeterminant, polarTripleInvariant, polarInvariant]
  have diagonal : ∀ point : Triple, polarValue point point = 2 * pointDiscriminant point := by
    intro point
    simp only [polarValue, pointDiscriminant]
    ring
  rw [diagonal, diagonal, diagonal]
  have symmetry : ∀ left right : Triple, polarValue right left = polarValue left right := by
    intro left right
    simp only [polarValue]
    ring
  rw [symmetry second first, symmetry third first, symmetry third second]
  field_simp
  ring

/-- Twice the inverse of twice a field element is the inverse of that element, with the sign carried
across.  This is the scalar step turning the Gram factorization into the displayed quotient. -/
private theorem neg_two_mul_inv_two_mul :
    ∀ value factor : Field13, -2 * value * ((2 : Field13)⁻¹ * factor) = value * -factor := by
  decide +kernel

/-- Substituting the Gram factorization instead writes the normalized Gram as the negated square of
the coordinate determinant over the product of the three discriminants. -/
theorem normalizedPolarGram_eq_neg_sq_mul_inv (first second third : Triple) :
    normalizedPolarGram first second third
      = coordinateDeterminant first second third ^ 2 *
        (-(pointDiscriminant first * pointDiscriminant second * pointDiscriminant third)⁻¹) := by
  rw [normalizedPolarGram, polarGramDeterminant_eq_neg_two_mul_sq, mul_inv_field]
  exact neg_two_mul_inv_two_mul _ _

/-- The normalized Gram vanishes exactly when the three coordinate triples are dependent. -/
theorem normalizedPolarGram_eq_zero_iff {first second third : Triple}
    (first_nondegenerate : pointDiscriminant first ≠ 0)
    (second_nondegenerate : pointDiscriminant second ≠ 0)
    (third_nondegenerate : pointDiscriminant third ≠ 0) :
    normalizedPolarGram first second third = 0
      ↔ coordinateDeterminant first second third = 0 := by
  rw [normalizedPolarGram_eq_neg_sq_mul_inv]
  constructor
  · intro vanishing
    by_contra determinant_nonzero
    have product_nonzero :
        pointDiscriminant first * pointDiscriminant second * pointDiscriminant third ≠ 0 :=
      mul_ne_zero_field _ _ (mul_ne_zero_field _ _ first_nondegenerate second_nondegenerate)
        third_nondegenerate
    have inverse_zero := (sq_mul_eq_zero_iff _ _ determinant_nonzero).mp vanishing
    exact inv_ne_zero_field _ product_nonzero (neg_eq_zero.mp inverse_zero)
  · intro determinant_zero
    rw [determinant_zero]
    ring

/-- A product of three nonsquares of `ZMod 13` has nonsquare negated inverse.  The negation is
harmless because `-1` is a square modulo thirteen; the three nonsquare factors leave the product a
nonsquare. -/
private theorem isNonzeroSquare_neg_inv_triple_nonsquare :
    ∀ first second third : Field13,
      first ≠ 0 → isNonzeroSquare first = false →
      second ≠ 0 → isNonzeroSquare second = false →
      third ≠ 0 → isNonzeroSquare third = false →
      isNonzeroSquare (-(first * second * third)⁻¹) = false := by
  decide +kernel

/-- **The discriminant law.**  The normalized polar Gram of three internal points is never a nonzero
square.  With `normalizedPolarGram_eq_zero_iff` this says that it vanishes on collinear triples and
is a nonsquare on all others. -/
theorem isNonzeroSquare_normalizedPolarGram_eq_false {first second third : Triple}
    (first_nondegenerate : pointDiscriminant first ≠ 0)
    (first_nonsquare : isNonzeroSquare (pointDiscriminant first) = false)
    (second_nondegenerate : pointDiscriminant second ≠ 0)
    (second_nonsquare : isNonzeroSquare (pointDiscriminant second) = false)
    (third_nondegenerate : pointDiscriminant third ≠ 0)
    (third_nonsquare : isNonzeroSquare (pointDiscriminant third) = false) :
    isNonzeroSquare (normalizedPolarGram first second third) = false := by
  by_cases determinant_zero : coordinateDeterminant first second third = 0
  · rw [(normalizedPolarGram_eq_zero_iff first_nondegenerate second_nondegenerate
      third_nondegenerate).mpr determinant_zero]
    decide
  · rw [normalizedPolarGram_eq_neg_sq_mul_inv,
      isNonzeroSquare_sq_mul _ _ determinant_zero]
    exact isNonzeroSquare_neg_inv_triple_nonsquare _ _ _ first_nondegenerate first_nonsquare
      second_nondegenerate second_nonsquare third_nondegenerate third_nonsquare

/-! ## Four points

A fourth point adds no freedom: coordinate triples live in a three-dimensional space, so any four of
them are dependent and the four-by-four matrix of their polar values is singular.  This is the
relation that the six normalized traces of a quadruple of internal points satisfy. -/

/-- The determinant of the three-by-three matrix with the displayed entries, read row by row. -/
private def minorDeterminant (topLeft topMiddle topRight middleLeft middleMiddle middleRight
    bottomLeft bottomMiddle bottomRight : Field13) : Field13 :=
  topLeft * (middleMiddle * bottomRight - middleRight * bottomMiddle)
    - topMiddle * (middleLeft * bottomRight - middleRight * bottomLeft)
    + topRight * (middleLeft * bottomMiddle - middleMiddle * bottomLeft)

/-- The determinant of the four-by-four matrix of polar values of four coordinate triples, expanded
along its first row. -/
def polarGramDeterminantFour (first second third fourth : Triple) : Field13 :=
  polarValue first first *
      minorDeterminant (polarValue second second) (polarValue second third)
        (polarValue second fourth) (polarValue third second) (polarValue third third)
        (polarValue third fourth) (polarValue fourth second) (polarValue fourth third)
        (polarValue fourth fourth)
    - polarValue first second *
      minorDeterminant (polarValue second first) (polarValue second third)
        (polarValue second fourth) (polarValue third first) (polarValue third third)
        (polarValue third fourth) (polarValue fourth first) (polarValue fourth third)
        (polarValue fourth fourth)
    + polarValue first third *
      minorDeterminant (polarValue second first) (polarValue second second)
        (polarValue second fourth) (polarValue third first) (polarValue third second)
        (polarValue third fourth) (polarValue fourth first) (polarValue fourth second)
        (polarValue fourth fourth)
    - polarValue first fourth *
      minorDeterminant (polarValue second first) (polarValue second second)
        (polarValue second third) (polarValue third first) (polarValue third second)
        (polarValue third third) (polarValue fourth first) (polarValue fourth second)
        (polarValue fourth third)

/-- The polar Gram determinant of four coordinate triples vanishes, for every four triples. -/
theorem polarGramDeterminantFour_eq_zero (first second third fourth : Triple) :
    polarGramDeterminantFour first second third fourth = 0 := by
  simp only [polarGramDeterminantFour, minorDeterminant, polarValue]
  ring

end PassantCodeQ13.MinimumWords.RowUniqueness
