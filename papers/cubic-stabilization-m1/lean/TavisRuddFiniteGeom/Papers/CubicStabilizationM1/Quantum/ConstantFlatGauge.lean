import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.RingTheory.PowerSeries.Derivative

/-!
# Constant-coefficient formal flat gauges

Let `A` be a finite square matrix over a commutative `ℚ`-algebra.  The
coefficients

`Gₙ = (-1)ⁿ / n! · Aⁿ`

are the coefficients of an entrywise formal power-series matrix.  Lean proves
that the constant term is the identity, that `(n+1)Gₙ₊₁ = -A Gₙ`, and that
entrywise formal differentiation gives `dG/dt = -A G`.  The series for `A`
and `-A` are proved to be two-sided inverse matrices.  No truncation or
uniqueness statement is represented.  This is the algebraic constant-
coefficient case of the recursive finite-level gauge construction; no quantum
product, varying bulk connection, filtered coefficient quotient, Laurent loop
coordinate, convergence, or analytic gauge is represented.  Each coefficient
is proved compatible with arbitrary homomorphisms of commutative rational
algebras.

The proof is symbolic and kernel checked, with no external computation or
oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

/-- The `n`-th coefficient of the normalized constant-coefficient flat gauge
for the matrix `connection`. -/
noncomputable def constantFlatGaugeCoefficient
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) (degree : ℕ) :
    Matrix Index Index R :=
  algebraMap ℚ R (((-1 : ℚ) ^ degree) / degree.factorial) •
    connection ^ degree

/-- The entrywise formal power-series matrix with the normalized constant flat
gauge coefficients. -/
noncomputable def constantFlatGaugeSeries
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) : Matrix Index Index (PowerSeries R) :=
  fun row column => PowerSeries.mk fun degree =>
    constantFlatGaugeCoefficient connection degree row column

/-- Coefficient extraction from the formal gauge series recovers the
normalized coefficient matrix. -/
theorem constantFlatGaugeSeries_coefficient
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) (degree : ℕ) :
    (constantFlatGaugeSeries connection).map (PowerSeries.coeff degree) =
      constantFlatGaugeCoefficient connection degree := by
  ext row column
  simp [constantFlatGaugeSeries]

/-- The constant term of the normalized flat gauge is the identity matrix. -/
@[simp]
theorem constantFlatGaugeCoefficient_zero
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) :
    constantFlatGaugeCoefficient connection 0 = 1 := by
  simp [constantFlatGaugeCoefficient]

/-- Consecutive coefficients satisfy the constant-coefficient flat recursion
`(n+1)Gₙ₊₁ = -A Gₙ`. -/
theorem constantFlatGaugeCoefficient_succ
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) (degree : ℕ) :
    (degree + 1 : R) • constantFlatGaugeCoefficient connection (degree + 1) =
      -connection * constantFlatGaugeCoefficient connection degree := by
  rw [constantFlatGaugeCoefficient, constantFlatGaugeCoefficient]
  rw [pow_succ' connection degree]
  rw [Nat.factorial_succ]
  simp only [smul_smul, Matrix.mul_smul, neg_mul]
  rw [← neg_smul]
  congr 1
  rw [show (degree + 1 : R) = algebraMap ℚ R (degree + 1) by norm_num]
  rw [← map_mul, ← map_neg]
  congr 1
  push_cast
  field_simp
  ring

/-- Rational-algebra homomorphisms between commutative rational algebras carry the
normalized coefficient of a constant connection matrix to the corresponding
coefficient of the mapped matrix. -/
theorem constantFlatGaugeCoefficient_map
    {Index R S : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R] [CommRing S] [Algebra ℚ S]
    (homomorphism : R →ₐ[ℚ] S) (connection : Matrix Index Index R)
    (degree : ℕ) :
    (constantFlatGaugeCoefficient connection degree).map homomorphism.toRingHom =
      constantFlatGaugeCoefficient
        (connection.map homomorphism.toRingHom) degree := by
  have hscalar :
      homomorphism.toRingHom
          (algebraMap ℚ R (((-1 : ℚ) ^ degree) / degree.factorial)) =
        algebraMap ℚ S (((-1 : ℚ) ^ degree) / degree.factorial) := by
    exact homomorphism.commutes _
  rw [constantFlatGaugeCoefficient, constantFlatGaugeCoefficient]
  rw [Matrix.map_smul' homomorphism.toRingHom _ _
    (fun _ _ => homomorphism.map_mul _ _)]
  rw [hscalar]
  congr 1
  exact Matrix.map_pow connection homomorphism.toRingHom degree

/-- Entrywise formal differentiation of the constant flat gauge series equals
left multiplication by the negative constant connection matrix. -/
theorem constantFlatGaugeSeries_derivative
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) :
    (constantFlatGaugeSeries connection).map PowerSeries.derivativeFun =
      connection.map (fun value => PowerSeries.C (-value)) *
        constantFlatGaugeSeries connection := by
  ext row column degree
  rw [Matrix.map_apply, PowerSeries.coeff_derivativeFun]
  rw [Matrix.mul_apply]
  simp only [Matrix.map_apply, map_sum,
    constantFlatGaugeSeries, PowerSeries.coeff_mk,
    PowerSeries.coeff_C_mul]
  simpa [Matrix.mul_apply, Matrix.smul_apply, mul_comm] using
    congrArg (fun matrix => matrix row column)
    (constantFlatGaugeCoefficient_succ connection degree)

/-- Every normalized coefficient commutes with its constant connection
matrix. -/
theorem constantFlatGaugeCoefficient_commutes
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) (degree : ℕ) :
    constantFlatGaugeCoefficient connection degree * connection =
      connection * constantFlatGaugeCoefficient connection degree := by
  rw [constantFlatGaugeCoefficient, Matrix.smul_mul, Matrix.mul_smul]
  congr 1
  rw [← pow_succ, pow_succ']

/-- Entrywise differentiation satisfies the Leibniz rule for finite square
matrices over formal power series. -/
theorem matrixPowerSeries_derivative_mul
    {Index R : Type*} [Fintype Index] [DecidableEq Index] [CommRing R]
    (left right : Matrix Index Index (PowerSeries R)) :
    (left * right).map PowerSeries.derivativeFun =
      left.map PowerSeries.derivativeFun * right +
        left * right.map PowerSeries.derivativeFun := by
  ext row column
  have derivative_sum :
      PowerSeries.derivativeFun
          (∑ index, left row index * right index column) =
        ∑ index, PowerSeries.derivativeFun
          (left row index * right index column) := by
    change (PowerSeries.derivative R)
        (∑ index, left row index * right index column) = _
    exact map_sum (PowerSeries.derivative R) _ _
  rw [Matrix.map_apply, Matrix.mul_apply, derivative_sum]
  simp only [PowerSeries.derivativeFun_mul, Matrix.add_apply,
    Matrix.mul_apply, Matrix.map_apply, Finset.sum_add_distrib]
  rw [add_comm]
  simp only [smul_eq_mul, mul_comm]

/-- The formal gauge series commutes with the constant connection matrix
embedded as a constant power-series matrix. -/
theorem constantFlatGaugeSeries_commutes
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) :
    constantFlatGaugeSeries connection * connection.map PowerSeries.C =
      connection.map PowerSeries.C * constantFlatGaugeSeries connection := by
  ext row column degree
  simp only [Matrix.mul_apply, Matrix.map_apply, map_sum,
    PowerSeries.coeff_mul_C, PowerSeries.coeff_C_mul,
    constantFlatGaugeSeries, PowerSeries.coeff_mk]
  exact congrArg (fun matrix ↦ matrix row column)
    (constantFlatGaugeCoefficient_commutes connection degree)

/-- Over a commutative rational algebra, a formal power series with zero
derivative is its constant series. -/
theorem powerSeries_eq_C_constantCoeff_of_derivative_eq_zero
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (series : PowerSeries R) (derivative_zero : series.derivativeFun = 0) :
    series = PowerSeries.C (PowerSeries.coeff 0 series) := by
  ext degree
  cases degree with
  | zero => simp
  | succ degree =>
      have coefficient_equation := congrArg (PowerSeries.coeff degree) derivative_zero
      rw [PowerSeries.coeff_derivativeFun, map_zero] at coefficient_equation
      have scalar_unit : IsUnit ((degree + 1 : ℕ) : R) := by
        rw [show ((degree + 1 : ℕ) : R) =
          algebraMap ℚ R (degree + 1) by norm_num]
        exact (isUnit_iff_ne_zero.mpr (by positivity : (degree + 1 : ℚ) ≠ 0)).map _
      simp only [PowerSeries.coeff_C, Nat.succ_ne_zero, if_false]
      apply (scalar_unit.mul_left_eq_zero).mp
      simpa [Nat.cast_add, Nat.cast_one] using coefficient_equation

/-- The normalized formal series for `A` and `-A` are two-sided inverse
matrices over formal power series. -/
theorem constantFlatGaugeSeries_mul_neg_eq_one
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) :
    constantFlatGaugeSeries connection *
        constantFlatGaugeSeries (-connection) = 1 := by
  let product := constantFlatGaugeSeries connection *
    constantFlatGaugeSeries (-connection)
  have derivative_zero : product.map PowerSeries.derivativeFun = 0 := by
    rw [matrixPowerSeries_derivative_mul,
      constantFlatGaugeSeries_derivative,
      constantFlatGaugeSeries_derivative]
    rw [show (-connection).map (fun value ↦ PowerSeries.C (-value)) =
      connection.map PowerSeries.C by ext; simp]
    rw [← Matrix.mul_assoc,
      constantFlatGaugeSeries_commutes connection,
      Matrix.mul_assoc]
    have neg_map :
        connection.map (fun value ↦ PowerSeries.C (-value)) =
          -(connection.map PowerSeries.C) := by
      ext
      simp
    rw [neg_map]
    simp only [neg_mul, ← Matrix.mul_assoc]
    simp
  ext row column degree
  have entry_derivative_zero :
      (product row column).derivativeFun = 0 := by
    exact congrArg (fun matrix ↦ matrix row column) derivative_zero
  change PowerSeries.coeff degree (product row column) =
    PowerSeries.coeff degree ((1 : Matrix Index Index (PowerSeries R)) row column)
  rw [powerSeries_eq_C_constantCoeff_of_derivative_eq_zero
    (product row column) entry_derivative_zero]
  simp [product, Matrix.mul_apply, constantFlatGaugeSeries,
    constantFlatGaugeCoefficient_zero, Matrix.one_apply]

/-- The reverse product of the normalized series for `A` and `-A` is also the
identity matrix. -/
theorem constantFlatGaugeSeries_neg_mul_eq_one
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) :
    constantFlatGaugeSeries (-connection) *
        constantFlatGaugeSeries connection = 1 := by
  simpa only [neg_neg] using
    constantFlatGaugeSeries_mul_neg_eq_one (-connection)

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
