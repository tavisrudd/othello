import RelativeConicArcs.AMELU.FourCopyContraction
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# Cycle-cover factors of the four-copy transport operator

The four-sheet contraction reduces, after quotienting constant copy vectors
and choosing systematic code coordinates, to three distinguished `9 × 9`
transport operators.  Their signed cycle-cover polynomials depend on two
coefficients `b,c`.  With

`A = (b+c)(c-b)` and `B = bc`,

the two oriented polynomials factor through `3B-2A` and `3B+2A`, while the
axial polynomial factors through `B²-2A²`.  This module proves those
factorizations over every commutative ring.  It also proves the reduced
divisor formula, its expression in the quotient coordinate
`z=(B/A)²`, and the integral identity that merges the two reduced
components in characteristic seven.

`TransportCycleCoverInputs` names the three concrete transport matrices and
states that their determinant expansions are the displayed cycle-cover
polynomials.  `TransportOrbitGeometryInputs` separately records the finite
sets of party assignments belonging to the axial and two oriented relative
cover types.  Thus the polynomial algebra and its arithmetic specialization
are kernel-checked here, while the determinant expansion, generic-rank
statement, and double-coset recognition remain explicit inputs.  There is no
generated certificate, native evaluation, project-specific axiom, or admitted
declaration in this module.
-/

namespace RelativeConicArcs.AMELU

/-- The coefficient `A=(b+c)(c-b)` in transport coordinates. -/
def transportA {R : Type*} [CommRing R] (b c : R) : R :=
  (b + c) * (c - b)

/-- The coefficient `B=bc` in transport coordinates. -/
def transportB {R : Type*} [CommRing R] (b c : R) : R :=
  b * c

/-- The signed cycle-cover polynomial for the orientation with obstruction
`3B-2A`. -/
def negativeSignedCyclePolynomial {R : Type*} [CommRing R] (b c : R) : R :=
  -2 * b * c ^ 5 + 3 * b ^ 2 * c ^ 4 + 4 * b ^ 3 * c ^ 3
    - 3 * b ^ 4 * c ^ 2 - 2 * b ^ 5 * c

/-- The signed cycle-cover polynomial for the opposite orientation, whose
obstruction is `3B+2A`. -/
def positiveSignedCyclePolynomial {R : Type*} [CommRing R] (b c : R) : R :=
  2 * b * c ^ 5 + 3 * b ^ 2 * c ^ 4 - 4 * b ^ 3 * c ^ 3
    - 3 * b ^ 4 * c ^ 2 + 2 * b ^ 5 * c

/-- The axial cycle-cover polynomial, whose obstruction is `B²-2A²`. -/
def axialCyclePolynomial {R : Type*} [CommRing R] (b c : R) : R :=
  -2 * c ^ 6 + 7 * b ^ 2 * c ^ 4 - 7 * b ^ 4 * c ^ 2 + 2 * b ^ 6

/-- The negative oriented cycle ledger factors as `AB(3B-2A)`. -/
theorem negativeSignedCyclePolynomial_factor
    {R : Type*} [CommRing R] (b c : R) :
    negativeSignedCyclePolynomial b c =
      transportA b c * transportB b c *
        (3 * transportB b c - 2 * transportA b c) := by
  simp only [negativeSignedCyclePolynomial, transportA, transportB]
  ring

/-- The positive oriented cycle ledger factors as `AB(3B+2A)`. -/
theorem positiveSignedCyclePolynomial_factor
    {R : Type*} [CommRing R] (b c : R) :
    positiveSignedCyclePolynomial b c =
      transportA b c * transportB b c *
        (3 * transportB b c + 2 * transportA b c) := by
  simp only [positiveSignedCyclePolynomial, transportA, transportB]
  ring

/-- The axial cycle ledger factors as `A(B²-2A²)`. -/
theorem axialCyclePolynomial_factor
    {R : Type*} [CommRing R] (b c : R) :
    axialCyclePolynomial b c =
      transportA b c *
        (transportB b c ^ 2 - 2 * transportA b c ^ 2) := by
  simp only [axialCyclePolynomial, transportA, transportB]
  ring

/-- The axial obstruction factor `B²-2A²`. -/
def axialTransportFactor {R : Type*} [CommRing R] (A B : R) : R :=
  B ^ 2 - 2 * A ^ 2

/-- The union of the two oriented obstruction factors. -/
def signedTransportFactor {R : Type*} [CommRing R] (A B : R) : R :=
  (3 * B - 2 * A) * (3 * B + 2 * A)

/-- The reduced transport divisor before passing to the coordinate `z`. -/
def reducedTransportDivisor {R : Type*} [CommRing R] (A B : R) : R :=
  axialTransportFactor A B * signedTransportFactor A B

/-- Multiplying the two oriented factors forgets their orientation and gives
`9B²-4A²`. -/
theorem signedTransportFactor_eq
    {R : Type*} [CommRing R] (A B : R) :
    signedTransportFactor A B = 9 * B ^ 2 - 4 * A ^ 2 := by
  simp only [signedTransportFactor]
  ring

/-- The reduced transport divisor is
`(B²-2A²)(9B²-4A²)`. -/
theorem reducedTransportDivisor_eq
    {R : Type*} [CommRing R] (A B : R) :
    reducedTransportDivisor A B =
      (B ^ 2 - 2 * A ^ 2) * (9 * B ^ 2 - 4 * A ^ 2) := by
  rw [reducedTransportDivisor, axialTransportFactor,
    signedTransportFactor_eq]

/-- Over a field, the reduced divisor vanishes exactly when one of the
axial or two oriented obstruction factors vanishes. -/
theorem reducedTransportDivisor_eq_zero_iff_three_factors
    {K : Type*} [Field K] (A B : K) :
    reducedTransportDivisor A B = 0 ↔
      axialTransportFactor A B = 0 ∨
        3 * B - 2 * A = 0 ∨ 3 * B + 2 * A = 0 := by
  simp only [reducedTransportDivisor, signedTransportFactor, mul_eq_zero]

/-- Away from `A=0`, the homogeneous reduced divisor is `A⁴` times
`(z-2)(9z-4)` for `z=(B/A)²`. -/
theorem reducedTransportDivisor_eq_z
    {K : Type*} [Field K] (A B : K) (hA : A ≠ 0) :
    reducedTransportDivisor A B =
      A ^ 4 * (((B / A) ^ 2 - 2) * (9 * (B / A) ^ 2 - 4)) := by
  rw [reducedTransportDivisor_eq]
  field_simp

/-- On a field and away from `A=0`, the homogeneous transport divisor
vanishes exactly on `(z-2)(9z-4)=0`, where `z=(B/A)²`. -/
theorem reducedTransportDivisor_eq_zero_iff_z
    {K : Type*} [Field K] (A B : K) (hA : A ≠ 0) :
    reducedTransportDivisor A B = 0 ↔
      ((B / A) ^ 2 - 2) * (9 * (B / A) ^ 2 - 4) = 0 := by
  rw [reducedTransportDivisor_eq_z A B hA, mul_eq_zero]
  simp [hA]

/-- Integral scheme identity comparing the oriented union with twice the
axial obstruction.  Its residual term is exactly `7B²`. -/
theorem signedTransportFactor_sub_two_mul_axial
    {R : Type*} [CommRing R] (A B : R) :
    signedTransportFactor A B - 2 * axialTransportFactor A B = 7 * B ^ 2 := by
  simp only [signedTransportFactor, axialTransportFactor]
  ring

/-- In characteristic seven, the oriented union and twice the axial
obstruction are the same polynomial. -/
theorem signedTransportFactor_eq_two_mul_axial_of_charSeven
    {R : Type*} [CommRing R] [CharP R 7] (A B : R) :
    signedTransportFactor A B = 2 * axialTransportFactor A B := by
  have hseven : (7 : R) = 0 := by
    exact CharP.cast_eq_zero R 7
  have h := signedTransportFactor_sub_two_mul_axial A B
  rw [hseven, zero_mul] at h
  exact sub_eq_zero.mp h

/-- In characteristic seven the reduced scheme is the doubled axial
pullback: `2(B²-2A²)²`. -/
theorem reducedTransportDivisor_eq_two_mul_axial_sq_of_charSeven
    {R : Type*} [CommRing R] [CharP R 7] (A B : R) :
    reducedTransportDivisor A B = 2 * axialTransportFactor A B ^ 2 := by
  rw [reducedTransportDivisor,
    signedTransportFactor_eq_two_mul_axial_of_charSeven]
  ring

/-- Over a field of characteristic seven, the reduced divisor and the axial
factor have exactly the same zero set. -/
theorem reducedTransportDivisor_eq_zero_iff_axial_of_charSeven
    {K : Type*} [Field K] [CharP K 7] (A B : K) :
    reducedTransportDivisor A B = 0 ↔ axialTransportFactor A B = 0 := by
  have htwo : (2 : K) ≠ 0 := by
    intro htwo
    have hseven : (7 : K) = 0 := CharP.cast_eq_zero K 7
    have hone : (1 : K) = 0 := calc
      (1 : K) = 7 - 3 * 2 := by norm_num
      _ = 0 := by rw [hseven, htwo]; ring
    exact one_ne_zero hone
  rw [reducedTransportDivisor_eq_two_mul_axial_sq_of_charSeven]
  simp [htwo]

/-- The constrained party indexed by a systematic row. -/
def constrainedTransportParty (i : Fin 3) : Party :=
  ⟨i, by omega⟩

/-- The free party indexed by a systematic column. -/
def freeTransportParty (i : Fin 3) : Party :=
  ⟨3 + i, by omega⟩

/-- The systematic `3 × 3` coefficient matrix
`[[b+c,b,c],[b+c,c,b],[d,d,d]]` of the pencil. -/
def transportCoefficientMatrix
    {R : Type*} [CommRing R] (b c d : R) : Matrix (Fin 3) (Fin 3) R :=
  !![
    b + c, b, c;
    b + c, c, b;
    d, d, d
  ]

/-- The reduced transport operator on three systematic message coordinates
and the three-dimensional copy quotient.  Its `(i,k)` block is
`Qᵢₖ(ρᵢ-ρ₍₃₊ₖ₎)`. -/
def reducedTransportOperator
    {R : Type*} [CommRing R]
    (b c d : R) (ρ : Party → Matrix (Fin 3) (Fin 3) R) :
    Matrix (Fin 3 × Fin 3) (Fin 3 × Fin 3) R :=
  fun row column =>
    transportCoefficientMatrix b c d row.1 column.1 *
      (ρ (constrainedTransportParty row.1) row.2 column.2 -
        ρ (freeTransportParty column.1) row.2 column.2)

universe u

/-- Cycle-cover determinant inputs for the three `9 × 9` reduced transport
operators.  Each copy action is a six-tuple of `3 × 3` matrices on the
constant-line quotient.  Each equality is the result of expanding the
corresponding concrete block operator by signed cycle covers in a fixed
integral basis. -/
structure TransportCycleCoverInputs
    (R : Type u) [CommRing R] (b c d : R) : Type (u + 1) where
  /-- Copy-quotient actions for the orientation with obstruction `3B-2A`. -/
  negativeSignedActions : Party → Matrix (Fin 3) (Fin 3) R
  /-- Copy-quotient actions for the orientation with obstruction `3B+2A`. -/
  positiveSignedActions : Party → Matrix (Fin 3) (Fin 3) R
  /-- Copy-quotient actions for the marked-axis relative-cover type. -/
  axialActions : Party → Matrix (Fin 3) (Fin 3) R
  /-- Signed cycle-cover expansion of the negative oriented determinant. -/
  negativeSigned_det_cycleCover :
    (reducedTransportOperator b c d negativeSignedActions).det =
      64 * d ^ 3 * negativeSignedCyclePolynomial b c
  /-- Signed cycle-cover expansion of the positive oriented determinant. -/
  positiveSigned_det_cycleCover :
    (reducedTransportOperator b c d positiveSignedActions).det =
      64 * d ^ 3 * positiveSignedCyclePolynomial b c
  /-- Signed cycle-cover expansion of the axial determinant. -/
  axial_det_cycleCover :
    (reducedTransportOperator b c d axialActions).det =
      64 * d ^ 3 * axialCyclePolynomial b c

/-- The negative oriented transport determinant has the localized factor
`3B-2A`. -/
theorem TransportCycleCoverInputs.negativeSigned_det_factor
    {R : Type*} [CommRing R] {b c d : R}
    (inputs : TransportCycleCoverInputs R b c d) :
    (reducedTransportOperator b c d inputs.negativeSignedActions).det =
      64 * d ^ 3 * transportA b c * transportB b c *
        (3 * transportB b c - 2 * transportA b c) := by
  rw [inputs.negativeSigned_det_cycleCover,
    negativeSignedCyclePolynomial_factor]
  ring

/-- The positive oriented transport determinant has the localized factor
`3B+2A`. -/
theorem TransportCycleCoverInputs.positiveSigned_det_factor
    {R : Type*} [CommRing R] {b c d : R}
    (inputs : TransportCycleCoverInputs R b c d) :
    (reducedTransportOperator b c d inputs.positiveSignedActions).det =
      64 * d ^ 3 * transportA b c * transportB b c *
        (3 * transportB b c + 2 * transportA b c) := by
  rw [inputs.positiveSigned_det_cycleCover,
    positiveSignedCyclePolynomial_factor]
  ring

/-- The axial transport determinant has the localized factor
`B²-2A²`. -/
theorem TransportCycleCoverInputs.axial_det_factor
    {R : Type*} [CommRing R] {b c d : R}
    (inputs : TransportCycleCoverInputs R b c d) :
    (reducedTransportOperator b c d inputs.axialActions).det =
      64 * d ^ 3 * transportA b c *
        (transportB b c ^ 2 - 2 * transportA b c ^ 2) := by
  rw [inputs.axial_det_cycleCover, axialCyclePolynomial_factor]
  ring

/-- Rank data for the elimination from the `24 × 21` quotient matching
matrix to the `9 × 9` reduced transport operator.  The equation states
that the two matrices have the same kernel excess after the universal
three-dimensional constant-section kernel has been removed. -/
structure TransportRankBridgeInputs : Type where
  /-- Rank of the quotient matching matrix. -/
  matchingRank : ℕ
  /-- Rank of the reduced transport operator. -/
  transportRank : ℕ
  /-- A `24 × 21` matrix has rank at most 21. -/
  matchingRank_le : matchingRank ≤ 21
  /-- A `9 × 9` matrix has rank at most 9. -/
  transportRank_le : transportRank ≤ 9
  /-- Equality of the matching and transport kernel excesses. -/
  kernelExcess_eq : 21 - matchingRank = 9 - transportRank

/-- A one-dimensional reduced transport kernel corresponds to matching
rank 20. -/
theorem TransportRankBridgeInputs.matchingRank_eq_twenty_of_transportRank_eq_eight
    (inputs : TransportRankBridgeInputs) (hrank : inputs.transportRank = 8) :
    inputs.matchingRank = 20 := by
  have hexcess : 21 - inputs.matchingRank = 1 := by
    simpa [hrank] using inputs.kernelExcess_eq
  have hle := inputs.matchingRank_le
  omega

/-- An invertible reduced transport operator corresponds to generic matching
rank 21. -/
theorem TransportRankBridgeInputs.matchingRank_eq_twentyOne_of_transportRank_eq_nine
    (inputs : TransportRankBridgeInputs) (hrank : inputs.transportRank = 9) :
    inputs.matchingRank = 21 := by
  have hexcess : 21 - inputs.matchingRank = 0 := by
    simpa [hrank] using inputs.kernelExcess_eq
  have hle := inputs.matchingRank_le
  omega

/-- Orbit-geometry inputs for the three relative-cover types.  The sets
contain party assignments, represented by permutations of the six parties.
Their cardinalities and disjointness arise from the corresponding
double-coset descriptions. -/
structure TransportOrbitGeometryInputs : Type where
  /-- Assignments supporting the marked-axis transport type. -/
  axialSupport : Finset (Equiv.Perm Party)
  /-- Assignments supporting the orientation with factor `3B-2A`. -/
  negativeSignedSupport : Finset (Equiv.Perm Party)
  /-- Assignments supporting the orientation with factor `3B+2A`. -/
  positiveSignedSupport : Finset (Equiv.Perm Party)
  /-- The marked-axis double coset has size 96. -/
  axial_card : axialSupport.card = 96
  /-- Each negative oriented double coset has size 192. -/
  negativeSigned_card : negativeSignedSupport.card = 192
  /-- Each positive oriented double coset has size 192. -/
  positiveSigned_card : positiveSignedSupport.card = 192
  /-- Axial and negative oriented assignments are disjoint. -/
  axial_disjoint_negative :
    Disjoint axialSupport negativeSignedSupport
  /-- Axial and positive oriented assignments are disjoint. -/
  axial_disjoint_positive :
    Disjoint axialSupport positiveSignedSupport
  /-- The two oriented assignment sets are disjoint. -/
  negative_disjoint_positive :
    Disjoint negativeSignedSupport positiveSignedSupport

/-- When characteristic seven merges the axial type with the negative
oriented type, exactly `96+192=288` party assignments are active. -/
theorem TransportOrbitGeometryInputs.card_axial_union_negative
    (inputs : TransportOrbitGeometryInputs) :
    (inputs.axialSupport ∪ inputs.negativeSignedSupport).card = 288 := by
  rw [Finset.card_union_of_disjoint inputs.axial_disjoint_negative,
    inputs.axial_card, inputs.negativeSigned_card]

/-- When characteristic seven merges the axial type with the positive
oriented type, exactly `96+192=288` party assignments are active. -/
theorem TransportOrbitGeometryInputs.card_axial_union_positive
    (inputs : TransportOrbitGeometryInputs) :
    (inputs.axialSupport ∪ inputs.positiveSignedSupport).card = 288 := by
  rw [Finset.card_union_of_disjoint inputs.axial_disjoint_positive,
    inputs.axial_card, inputs.positiveSigned_card]

end RelativeConicArcs.AMELU
