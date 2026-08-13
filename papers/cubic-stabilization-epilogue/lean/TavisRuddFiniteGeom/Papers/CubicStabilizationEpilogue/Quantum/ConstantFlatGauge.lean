import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.RingTheory.PowerSeries.Derivative

/-!
# Constant-coefficient formal flat gauges

Let `A` be a finite square matrix over a commutative `ℚ`-algebra.  The
coefficients

`Gₙ = (-1)ⁿ / n! · Aⁿ`

are the coefficients of an entrywise formal power-series matrix.  Lean proves
that the constant term is the identity, that `(n+1)Gₙ₊₁ = -A Gₙ`, and that
entrywise formal differentiation gives `dG/dt = -A G`.  No truncation,
uniqueness, or invertibility statement is represented.  This is the algebraic constant-
coefficient case of the recursive finite-level gauge construction; no quantum
product, varying bulk connection, filtered coefficient quotient, Laurent loop
coordinate, convergence, or analytic gauge is represented.  Each coefficient
is proved compatible with arbitrary homomorphisms of commutative rational
algebras.

The proof is symbolic and kernel checked, with no external computation or
oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

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

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
