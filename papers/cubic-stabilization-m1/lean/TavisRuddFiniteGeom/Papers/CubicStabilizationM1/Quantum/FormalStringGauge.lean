import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.RingTheory.PowerSeries.Exp

/-!
# Scalar formal string gauges

Over a commutative rational algebra, `exp(aX)` and `exp(-aX)` are inverse
formal power series.  Placing either series on the diagonal gives a scalar
matrix gauge.  Lean proves that this gauge is two-sided invertible, commutes
with every square matrix, and therefore conjugates every formal monodromy
matrix to itself and preserves its characteristic polynomial.

This is the algebraic scalar-gauge step used when a string equation removes a
unit-direction parameter.  The formal variable can model an integral power of
an inverse loop coordinate, but this module does not construct a quantum string
equation, identify the scalar with a geometric bulk coordinate, or prove an
analytic single-valuedness statement.  All proofs are symbolic and kernel
checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open scoped Matrix

/-- The formal scalar exponential `exp(aX)`. -/
noncomputable def formalStringExponential
    (R : Type*) [CommRing R] [Algebra ℚ R] (scalar : R) : PowerSeries R :=
  PowerSeries.rescale scalar (PowerSeries.exp R)

/-- Coefficients of the formal scalar exponential are `a^n/n!`. -/
theorem formalStringExponential_coefficient
    (R : Type*) [CommRing R] [Algebra ℚ R] (scalar : R) (degree : ℕ) :
    PowerSeries.coeff degree (formalStringExponential R scalar) =
      scalar ^ degree * algebraMap ℚ R (1 / degree.factorial) := by
  rw [formalStringExponential, PowerSeries.coeff_rescale,
    PowerSeries.coeff_exp]

/-- Opposite scalar exponentials are two-sided inverses. -/
theorem formalStringExponential_mul_neg
    (R : Type*) [CommRing R] [Algebra ℚ R] (scalar : R) :
    formalStringExponential R scalar *
        formalStringExponential R (-scalar) = 1 := by
  simpa [formalStringExponential] using
    PowerSeries.exp_mul_exp_eq_exp_add scalar (-scalar)

/-- The scalar formal string gauge on a finite free frame. -/
noncomputable def formalStringGauge
    (Index R : Type*) [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R] (scalar : R) :
    Matrix Index Index (PowerSeries R) :=
  Matrix.scalar Index (formalStringExponential R scalar)

/-- The opposite exponential is the explicit inverse scalar gauge. -/
theorem formalStringGauge_mul_inverse
    (Index R : Type*) [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R] (scalar : R) :
    formalStringGauge Index R scalar * formalStringGauge Index R (-scalar) = 1 := by
  rw [formalStringGauge, formalStringGauge, ← map_mul]
  simp [formalStringExponential_mul_neg]

/-- The inverse scalar gauge also multiplies the original gauge to one. -/
theorem formalStringGauge_inverse_mul
    (Index R : Type*) [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R] (scalar : R) :
    formalStringGauge Index R (-scalar) * formalStringGauge Index R scalar = 1 := by
  simpa [add_comm] using formalStringGauge_mul_inverse Index R (-scalar)

/-- Scalar formal string gauges conjugate every square matrix trivially. -/
theorem formalStringGauge_conjugation
    (Index R : Type*) [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R] (scalar : R)
    (monodromy : Matrix Index Index (PowerSeries R)) :
    formalStringGauge Index R scalar * monodromy *
        formalStringGauge Index R (-scalar) = monodromy := by
  change
    Matrix.scalar Index (formalStringExponential R scalar) * monodromy *
      Matrix.scalar Index (formalStringExponential R (-scalar)) = monodromy
  rw [Matrix.scalar_comm _ (fun other => Commute.all _ other) monodromy,
    mul_assoc, ← map_mul]
  simp [formalStringExponential_mul_neg]

/-- Trivial scalar conjugation preserves the characteristic polynomial. -/
theorem formalStringGauge_conjugation_charpoly
    (Index R : Type*) [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R] (scalar : R)
    (monodromy : Matrix Index Index (PowerSeries R)) :
    (formalStringGauge Index R scalar * monodromy *
      formalStringGauge Index R (-scalar)).charpoly = monodromy.charpoly := by
  rw [formalStringGauge_conjugation]

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
