import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.LowDimensionalVanishingCore
import Mathlib.RingTheory.PowerSeries.Derivative

/-!
# Multiplicity-one blocks of Euler multiplication

A generalized eigenspace of Euler multiplication of rank one carries a scalar
irregular factor and nothing else.  This module proves the three algebraic steps
behind that statement, each about matrices or formal power series over a field.

First, the grading operator compresses to zero on such a block.  Generalized
eigenspaces of distinct eigenvalues of an operator self-adjoint for a
nondegenerate pairing are orthogonal, so the pairing restricts nondegenerately to
the block; on a rank-one block the restricted pairing is a single nonzero scalar,
and the anti-self-adjointness identity of the grading operator then reads twice
that scalar times the grading value, hence forces the grading value to vanish.

Second, the compression of a commutator by a projector vanishes when the
projector commutes with one factor and annihilates the other on both sides.  With
the block-off-diagonal normalized gauge that splits the block from the remaining
Euler eigenspaces, this is the statement that the gauge contributes nothing to the
order-`z` coefficient of the resulting scalar equation.  Together with the first
step, the whole order-`z` coefficient of the scalar block vanishes.

Third, the scalar equation with no term of order `z` has a normalized formal
solution with no logarithm and no fractional power.  Removing the irregular
exponential factor `exp(-u/z)` from `z ^ 2 * y' = (u + z ^ 2 * h) * y` leaves the
equation `v' = h * v`, and over a field of characteristic zero that equation has a
unique formal power-series solution with constant coefficient one, constructed
here by its coefficient recursion.  Because the regular factor is an ordinary
power series in the original loop coordinate, the framed regular monodromy of the
block is the identity, so every characteristic root of the framed monodromy
contributed by the block equals one and the block contributes nothing to the
primitive-sixth count.  The last statement records that consequence at the level
of the characteristic polynomial.

Lean does not construct the quantum connection, Euler multiplication, the
Poincare pairing, the Levelt--Turrittin decomposition, or the gauge splitting a
spectral block off; those enter as the matrix and power-series data of the
statements below.  In particular the passage from the scalar equation to a framed
monodromy matrix is not formalized: the final statement takes the characteristic
polynomial of the block's framed monodromy as given.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

section RankOneCompression

variable {K : Type*} [Field K]

/-- The grading operator vanishes on a rank-one Euler block.  The pairing
restricted to the block is the single scalar `pairing 0 0`, nonzero because
distinct Euler eigenvalues are orthogonal for a nondegenerate pairing;
anti-self-adjointness of the grading operator on that line then reads
`grading * pairing + pairing * grading = 0`, so twice the product vanishes. -/
theorem rankOne_grading_eq_zero (twoNeZero : (2 : K) ≠ 0)
    {pairing grading : Matrix (Fin 1) (Fin 1) K}
    (nondegenerate : pairing 0 0 ≠ 0)
    (antiSelfAdjoint : gradingᵀ * pairing + pairing * grading = 0) :
    grading = 0 := by
  have entry : 2 * (pairing 0 0 * grading 0 0) = 0 := by
    have coefficient := congrFun (congrFun antiSelfAdjoint 0) 0
    simp only [Matrix.add_apply, Matrix.mul_apply, Matrix.transpose_apply, Fin.sum_univ_one,
      Matrix.zero_apply] at coefficient
    linear_combination coefficient
  have vanishing : grading 0 0 = 0 := by
    rcases mul_eq_zero.mp entry with two | product
    · exact absurd two twoNeZero
    · exact (mul_eq_zero.mp product).resolve_left nondegenerate
  ext row column
  fin_cases row
  fin_cases column
  simpa using vanishing

variable {index : Type*} [Fintype index] {A : Type*} [CommRing A]

/-- Compression of a commutator by a projector that commutes with one factor and
annihilates the other on both sides.  Applied to the spectral projector of an
Euler block, to Euler multiplication, and to the first coefficient of a
block-off-diagonal normalized gauge, this says that the gauge contributes nothing
to the order-`z` coefficient of the scalar equation on the block. -/
theorem projector_commutator_compression_eq_zero
    (projector euler gauge : Matrix index index A)
    (commutes : projector * euler = euler * projector)
    (offDiagonal : projector * gauge * projector = 0) :
    projector * (euler * gauge - gauge * euler) * projector = 0 := by
  have first : projector * (euler * gauge) * projector = 0 := by
    calc projector * (euler * gauge) * projector
        = (projector * euler) * (gauge * projector) := by
          simp [Matrix.mul_assoc]
      _ = euler * (projector * gauge * projector) := by
          rw [commutes]; simp [Matrix.mul_assoc]
      _ = 0 := by rw [offDiagonal, Matrix.mul_zero]
  have second : projector * (gauge * euler) * projector = 0 := by
    calc projector * (gauge * euler) * projector
        = (projector * gauge) * (euler * projector) := by
          simp [Matrix.mul_assoc]
      _ = (projector * gauge * projector) * euler := by
          rw [← commutes]; simp [Matrix.mul_assoc]
      _ = 0 := by rw [offDiagonal, Matrix.zero_mul]
  rw [Matrix.mul_sub, Matrix.sub_mul, first, second, sub_zero]

/-- The order-`z` coefficient of the scalar equation on a rank-one Euler block
vanishes: it is the compression of the grading operator, taken with a minus sign,
plus the compression of the commutator of Euler multiplication with the first
gauge coefficient. -/
theorem rankOne_linearCoefficient_eq_zero
    (projector euler gauge grading : Matrix index index A)
    (commutes : projector * euler = euler * projector)
    (offDiagonal : projector * gauge * projector = 0)
    (gradingCompression : projector * grading * projector = 0) :
    -(projector * grading * projector)
        + projector * (euler * gauge - gauge * euler) * projector = 0 := by
  rw [gradingCompression, neg_zero, zero_add,
    projector_commutator_compression_eq_zero projector euler gauge commutes offDiagonal]

end RankOneCompression

section ScalarEquation

variable {K : Type*} [Field K] [CharZero K]

/-- Coefficients of the normalized formal solution of the scalar equation
`v' = logarithmic * v`.  The constant coefficient is one and each later
coefficient is determined by the convolution of the earlier ones with
`logarithmic`, divided by its index. -/
noncomputable def normalizedExponentialCoefficient
    (logarithmic : PowerSeries K) : ℕ → K
  | 0 => 1
  | Nat.succ order => ((order : K) + 1)⁻¹ *
      ∑ index ∈ Finset.range (order + 1),
        PowerSeries.coeff index logarithmic *
          normalizedExponentialCoefficient logarithmic (order - index)
  decreasing_by omega

/-- The normalized formal solution of `v' = logarithmic * v`: the power series
whose coefficients are given by the recursion above. -/
noncomputable def normalizedExponential (logarithmic : PowerSeries K) : PowerSeries K :=
  PowerSeries.mk (normalizedExponentialCoefficient logarithmic)

omit [CharZero K] in
/-- The normalized formal solution has constant coefficient one. -/
theorem normalizedExponential_constantCoeff (logarithmic : PowerSeries K) :
    PowerSeries.coeff 0 (normalizedExponential logarithmic) = 1 := by
  simp [normalizedExponential, normalizedExponentialCoefficient]

/-- The normalized formal solution solves the scalar equation
`v' = logarithmic * v`. -/
theorem normalizedExponential_derivative (logarithmic : PowerSeries K) :
    PowerSeries.derivativeFun (normalizedExponential logarithmic)
      = logarithmic * normalizedExponential logarithmic := by
  ext order
  rw [PowerSeries.coeff_derivativeFun, PowerSeries.coeff_mul,
    Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk]
  have successor : PowerSeries.coeff (order + 1) (normalizedExponential logarithmic)
      = ((order : K) + 1)⁻¹ *
        ∑ index ∈ Finset.range (order + 1),
          PowerSeries.coeff index logarithmic *
            PowerSeries.coeff (order - index) (normalizedExponential logarithmic) := by
    simp [normalizedExponential, normalizedExponentialCoefficient]
  rw [successor]
  have nonzero : ((order : K) + 1) ≠ 0 := by
    have := Nat.cast_add_one_ne_zero (R := K) order
    simpa using this
  field_simp

/-- The normalized formal solution is the only power series with constant
coefficient one solving the scalar equation, so the regular factor of the block
is an ordinary power series in the loop coordinate: no logarithm and no
fractional power occurs. -/
theorem eq_normalizedExponential_of_derivative
    {logarithmic solution : PowerSeries K}
    (normalized : PowerSeries.coeff 0 solution = 1)
    (equation : PowerSeries.derivativeFun solution = logarithmic * solution) :
    solution = normalizedExponential logarithmic := by
  ext order
  induction order using Nat.strong_induction_on with
  | _ order induction =>
    match order with
    | 0 => rw [normalized, normalizedExponential_constantCoeff]
    | Nat.succ predecessor =>
      have coefficient := congrArg (PowerSeries.coeff predecessor) equation
      rw [PowerSeries.coeff_derivativeFun, PowerSeries.coeff_mul,
        Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk] at coefficient
      have transferred :
          ∑ index ∈ Finset.range (predecessor + 1),
              PowerSeries.coeff index logarithmic *
                PowerSeries.coeff (predecessor - index) solution
            = ∑ index ∈ Finset.range (predecessor + 1),
              PowerSeries.coeff index logarithmic *
                PowerSeries.coeff (predecessor - index)
                  (normalizedExponential logarithmic) := by
        refine Finset.sum_congr rfl fun index _ => ?_
        rw [induction (predecessor - index) (by omega)]
      have successor :
          PowerSeries.coeff (predecessor + 1) (normalizedExponential logarithmic)
            = ((predecessor : K) + 1)⁻¹ *
              ∑ index ∈ Finset.range (predecessor + 1),
                PowerSeries.coeff index logarithmic *
                  PowerSeries.coeff (predecessor - index)
                    (normalizedExponential logarithmic) := by
        simp [normalizedExponential, normalizedExponentialCoefficient]
      have nonzero : ((predecessor : K) + 1) ≠ 0 := by
        have := Nat.cast_add_one_ne_zero (R := K) predecessor
        simpa using this
      rw [successor, ← transferred]
      field_simp at coefficient ⊢
      linear_combination coefficient

end ScalarEquation

section FramedContribution

open Polynomial

/-- A framed characteristic polynomial all of whose roots are one has no
primitive sixth root among them, hence primitive-sixth multiplicity zero.  This is
the contribution of a rank-one Euler block, whose framed regular monodromy is the
identity. -/
theorem sixthMultiplicityPolynomial_eq_zero_of_unit_roots
    {characteristic : Polynomial ℂ}
    (unitRoots : ∀ value : ℂ, characteristic.IsRoot value → value = 1) :
    sixthMultiplicityPolynomial characteristic = 0 := by
  have positiveNotRoot : ¬characteristic.IsRoot primitiveSixthRootPositive := by
    intro root
    have equality := unitRoots primitiveSixthRootPositive root
    exact primitiveSixthRoots_sq_ne_one.1 (by rw [equality]; norm_num)
  have negativeNotRoot : ¬characteristic.IsRoot primitiveSixthRootNegative := by
    intro root
    have equality := unitRoots primitiveSixthRootNegative root
    exact primitiveSixthRoots_sq_ne_one.2 (by rw [equality]; norm_num)
  simp [sixthMultiplicityPolynomial, Polynomial.rootMultiplicity_eq_zero positiveNotRoot,
    Polynomial.rootMultiplicity_eq_zero negativeNotRoot]

/-- A framed monodromy that is the identity on a block of any rank contributes
nothing to the primitive-sixth count: its characteristic polynomial is a power of
`X - 1`. -/
theorem sixthMultiplicityPolynomial_unitPower_eq_zero (rank : ℕ) :
    sixthMultiplicityPolynomial ((X - C (1 : ℂ)) ^ rank) = 0 := by
  refine sixthMultiplicityPolynomial_eq_zero_of_unit_roots fun value root => ?_
  have factorZero : (value - 1) ^ rank = 0 := by
    simpa [Polynomial.IsRoot, Polynomial.eval_pow] using root
  have difference : value - 1 = 0 := (pow_eq_zero_iff'.mp factorZero).1
  exact sub_eq_zero.mp difference

end FramedContribution

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
