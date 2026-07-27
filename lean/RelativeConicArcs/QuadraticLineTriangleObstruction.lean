import Mathlib.LinearAlgebra.Matrix.Nondegenerate

/-!
# A line--triangle obstruction for ternary quadratics

Let a ternary quadratic vanish at the three projective points represented by
`(1,0,0)`, `(0,1,0)`, and `(1,1,0)`.  Its restriction to the line `Z = 0` is then zero, so only
the terms divisible by `Z` remain.  If the quadratic also vanishes at three points off that line
whose coordinate rows are independent, division by their nonzero `Z`-coordinates gives a
nonsingular linear evaluation system.  The residual linear factor, and hence the quadratic, is
zero.

The terminal theorem is valid over every field.  It formalizes the coordinate-normalized algebraic
core of the geometric fact that a quadratic containing three distinct points of a line and three
noncollinear points outside that line must be zero.
-/

namespace RelativeConicArcs

section LineTriangle

variable {K : Type*} [Field K]

/-- Evaluation of a ternary quadratic whose coefficient order is
`X², Y², Z², XY, XZ, YZ`. -/
def ternaryQuadraticEvaluation (q : Fin 6 → K) (v : Fin 3 → K) : K :=
  q 0 * v 0 ^ 2 + q 1 * v 1 ^ 2 + q 2 * v 2 ^ 2 +
    q 3 * (v 0 * v 1) + q 4 * (v 0 * v 2) + q 5 * (v 1 * v 2)

/-- The three residual-linear evaluation rows attached to points off `Z = 0`.
The column order is `Z, X, Y`, matching the residual coefficients of
`Z (c_Z Z + c_X X + c_Y Y)`. -/
def offLineLinearEvaluationMatrix (p : Fin 3 → Fin 3 → K) : Matrix (Fin 3) (Fin 3) K :=
  fun i => ![p i 2, p i 0, p i 1]

/-- A ternary quadratic that vanishes at three normalized points of `Z = 0` and at an off-line
triangle is zero.  Nonzero `Z`-coordinates say that the latter points lie off the line; the
nonzero determinant says that their projective representatives are noncollinear. -/
theorem ternaryQuadratic_eq_zero_of_standardLine_and_offLineTriangle
    (q : Fin 6 → K) (p : Fin 3 → Fin 3 → K)
    (hoff : ∀ i, p i 2 ≠ 0)
    (htriangle : (offLineLinearEvaluationMatrix p).det ≠ 0)
    (hX : ternaryQuadraticEvaluation q ![1, 0, 0] = 0)
    (hY : ternaryQuadraticEvaluation q ![0, 1, 0] = 0)
    (hXY : ternaryQuadraticEvaluation q ![1, 1, 0] = 0)
    (hp : ∀ i, ternaryQuadraticEvaluation q (p i) = 0) :
    q = 0 := by
  have hq0 : q 0 = 0 := by
    simpa [ternaryQuadraticEvaluation] using hX
  have hq1 : q 1 = 0 := by
    simpa [ternaryQuadraticEvaluation] using hY
  have hq3 : q 3 = 0 := by
    simpa [ternaryQuadraticEvaluation, hq0, hq1] using hXY
  let c : Fin 3 → K := ![q 2, q 4, q 5]
  have hlinear : ∀ i, p i 2 * q 2 + p i 0 * q 4 + p i 1 * q 5 = 0 := by
    intro i
    have hvanish := hp i
    rw [ternaryQuadraticEvaluation, hq0, hq1, hq3] at hvanish
    simp only [zero_mul, zero_add, add_zero] at hvanish
    have hproduct :
        p i 2 * (p i 2 * q 2 + p i 0 * q 4 + p i 1 * q 5) = 0 := by
      calc
        p i 2 * (p i 2 * q 2 + p i 0 * q 4 + p i 1 * q 5) =
            q 2 * p i 2 ^ 2 + q 4 * (p i 0 * p i 2) + q 5 * (p i 1 * p i 2) := by
              ring
        _ = 0 := hvanish
    exact (mul_eq_zero.mp hproduct).resolve_left (hoff i)
  have hmul : Matrix.mulVec (offLineLinearEvaluationMatrix p) c = 0 := by
    funext i
    simpa [offLineLinearEvaluationMatrix, c, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ, add_assoc] using hlinear i
  have hc : c = 0 :=
    Matrix.eq_zero_of_mulVec_eq_zero htriangle hmul
  have hq2 : q 2 = 0 := by
    simpa [c] using congrFun hc 0
  have hq4 : q 4 = 0 := by
    simpa [c] using congrFun hc 1
  have hq5 : q 5 = 0 := by
    simpa [c] using congrFun hc 2
  funext i
  fin_cases i <;> assumption

end LineTriangle

end RelativeConicArcs
