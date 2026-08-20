import RelativeConicArcs.GoldenCubicNodesBase
import RelativeConicArcs.GoldenMatchingJacobianBase

/-!
# Projective Hessians at the six Golden cubic nodes

The six singular lines of the centered Golden cubic all meet the affine chart
whose fifth displayed coordinate is one.  This module records the four-by-four
Hessian on that chart and proves that its determinant is nonzero at every
normalized node over every field of characteristic different from two, three,
and five.  This is the coordinate ordinary-double-point criterion.
-/

namespace RelativeConicArcs.GoldenCubicNodeHessians

open GoldenCubicNodesBase
open GoldenMatchingJacobian

/-- The Hessian of the dehomogenized Golden cubic on the chart \(x_4=1\). -/
def chartHessian {R : Type*} [CommRing R] (x : Fin 4 → R) :
    Matrix (Fin 4) (Fin 4) R :=
  !![2*(-x 1-x 2+x 3+1),
      2*(-x 0-x 1-x 2-x 3+1),
      2*(-x 0-x 1-x 2+x 3-1),
      2*(x 0-x 1+x 2+x 3+1);
     2*(-x 0-x 1-x 2-x 3+1),
      2*(-x 0+x 2-x 3+1),
      2*(-x 0+x 1+x 2+x 3+1),
      2*(-x 0-x 1+x 2-x 3-1);
     2*(-x 0-x 1-x 2+x 3-1),
      2*(-x 0+x 1+x 2+x 3+1),
      2*(-x 0+x 1+x 3-1),
      2*(x 0+x 1+x 2+x 3-1);
     2*(x 0-x 1+x 2+x 3+1),
      2*(-x 0-x 1+x 2-x 3-1),
      2*(x 0+x 1+x 2+x 3-1),
      2*(x 0-x 1+x 2-1)]

/-- The \(i\)-th gradient component restricted to the \(j\)-th coordinate
line, represented as a univariate polynomial. -/
noncomputable def gradientCoordinatePolynomial
    {R : Type*} [CommRing R] (i : Fin 5) (x : Fin 5 → R) (j : Fin 5) :
    Polynomial R :=
  let y := Function.update (fun a => Polynomial.C (x a)) j Polynomial.X
  gradient y i

/-- The displayed chart matrix is the matrix of second coordinate
derivatives of the centered Golden cubic. -/
theorem derivative_gradientCoordinatePolynomial_chart
    {R : Type*} [CommRing R] (x : Fin 4 → R) (i j : Fin 4) :
    (gradientCoordinatePolynomial i.castSucc ![x 0, x 1, x 2, x 3, 1]
      j.castSucc).derivative.eval (x j) = chartHessian x i j := by
  fin_cases i <;> fin_cases j <;>
    simp [gradientCoordinatePolynomial, gradient, chartHessian,
      Function.update, Polynomial.derivative_pow] <;>
    ring

/-- The first four coordinates of the \(i\)-th centered node, normalized so
that its fifth displayed coordinate equals one. -/
def chartNode {K : Type*} [Field K] (i : Fin 6) : Fin 4 → K := fun j =>
  centeredNode i (Fin.castSucc j) / centeredNode i 4

/-- Every centered node meets the chosen affine chart when five is nonzero. -/
theorem centeredNode_four_ne_zero
    {K : Type*} [Field K] (h5 : (5 : K) ≠ 0) (i : Fin 6) :
    (centeredNode i 4 : K) ≠ 0 := by
  fin_cases i <;> simp [centeredNode, h5]

/-- The exact dehomogenized Hessian determinant is \(1296/5\) at the node
whose exceptional coordinate is the chart denominator and \(6480\) at each
of the other five nodes. -/
theorem det_chartHessian_chartNode
    {K : Type*} [Field K] (h5 : (5 : K) ≠ 0) (i : Fin 6) :
    Matrix.det (chartHessian (chartNode i)) =
      if i = 4 then (1296 / 5 : K) else 6480 := by
  rw [← detFour_eq_det]
  fin_cases i <;>
    simp [chartNode, centeredNode, chartHessian, detFour, detThree] <;>
    field_simp [h5] <;>
    ring

/-- Once the chosen chart exists, its node Hessian is nondegenerate exactly
when two and three are nonzero in the base field. -/
theorem det_chartHessian_chartNode_ne_zero_iff
    {K : Type*} [Field K] (h5 : (5 : K) ≠ 0) (i : Fin 6) :
    Matrix.det (chartHessian (chartNode (K := K) i)) ≠ 0 ↔
      (2 : K) ≠ 0 ∧ (3 : K) ≠ 0 := by
  rw [det_chartHessian_chartNode h5]
  split_ifs
  · constructor
    · intro h
      constructor
      · intro h2
        apply h
        rw [show (1296 : K) = 2 ^ 4 * 3 ^ 4 by ring, h2]
        simp
      · intro h3
        apply h
        rw [show (1296 : K) = 2 ^ 4 * 3 ^ 4 by ring, h3]
        simp
    · rintro ⟨h2, h3⟩
      apply div_ne_zero
      · rw [show (1296 : K) = 2 ^ 4 * 3 ^ 4 by ring]
        exact mul_ne_zero (pow_ne_zero 4 h2) (pow_ne_zero 4 h3)
      · exact h5
  · constructor
    · intro h
      constructor
      · intro h2
        apply h
        rw [show (6480 : K) = (2 ^ 4 * 3 ^ 4) * 5 by ring, h2]
        simp
      · intro h3
        apply h
        rw [show (6480 : K) = (2 ^ 4 * 3 ^ 4) * 5 by ring, h3]
        simp
    · rintro ⟨h2, h3⟩
      rw [show (6480 : K) = (2 ^ 4 * 3 ^ 4) * 5 by ring]
      exact mul_ne_zero (mul_ne_zero (pow_ne_zero 4 h2) (pow_ne_zero 4 h3)) h5

/-- Each of the six displayed projective singularities has nondegenerate
dehomogenized Hessian and hence is an ordinary double point in this chart. -/
theorem det_chartHessian_chartNode_ne_zero
    {K : Type*} [Field K] (h30 : (30 : K) ≠ 0) (i : Fin 6) :
    Matrix.det (chartHessian (chartNode (K := K) i)) ≠ 0 := by
  have h2 : (2 : K) ≠ 0 := by
    intro h
    apply h30
    calc
      (30 : K) = 15 * 2 := by ring
      _ = 0 := by rw [h, mul_zero]
  have h3 : (3 : K) ≠ 0 := by
    intro h
    apply h30
    calc
      (30 : K) = 10 * 3 := by ring
      _ = 0 := by rw [h, mul_zero]
  have h5 : (5 : K) ≠ 0 := by
    intro h
    apply h30
    calc
      (30 : K) = 6 * 5 := by ring
      _ = 0 := by rw [h, mul_zero]
  exact (det_chartHessian_chartNode_ne_zero_iff h5 i).2 ⟨h2, h3⟩

end RelativeConicArcs.GoldenCubicNodeHessians
