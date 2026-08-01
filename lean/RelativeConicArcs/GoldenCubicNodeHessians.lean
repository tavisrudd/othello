import RelativeConicArcs.GoldenCubicNodesBase
import RelativeConicArcs.GoldenMatchingJacobianBase

/-!
# Projective Hessians at the six Golden cubic nodes

The six singular lines of the centered Golden cubic all meet the affine chart
whose fifth displayed coordinate is one.  This module records the four-by-four
Hessian on that chart and proves that its determinant is nonzero at every
normalized node.  This is the coordinate ordinary-double-point criterion.
-/

namespace RelativeConicArcs.GoldenCubicNodeHessians

open GoldenCubicNodesBase
open GoldenMatchingJacobian

/-- The Hessian of the dehomogenized Golden cubic on the chart \(x_4=1\). -/
def chartHessian (x : Fin 4 → ℚ) : Matrix (Fin 4) (Fin 4) ℚ :=
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
    (i : Fin 5) (x : Fin 5 → ℚ) (j : Fin 5) : Polynomial ℚ :=
  let y := Function.update (fun a => Polynomial.C (x a)) j Polynomial.X
  gradient y i

/-- The displayed chart matrix is the matrix of second coordinate
derivatives of the centered Golden cubic. -/
theorem derivative_gradientCoordinatePolynomial_chart
    (x : Fin 4 → ℚ) (i j : Fin 4) :
    (gradientCoordinatePolynomial i.castSucc ![x 0, x 1, x 2, x 3, 1]
      j.castSucc).derivative.eval (x j) = chartHessian x i j := by
  fin_cases i <;> fin_cases j <;>
    simp [gradientCoordinatePolynomial, gradient, chartHessian,
      Function.update, Polynomial.derivative_pow] <;>
    ring

/-- The first four coordinates of the \(i\)-th centered node, normalized so
that its fifth displayed coordinate equals one. -/
def chartNode (i : Fin 6) : Fin 4 → ℚ := fun j =>
  centeredNode i (Fin.castSucc j) / centeredNode i 4

/-- Every centered node meets the chosen affine chart. -/
theorem centeredNode_four_ne_zero (i : Fin 6) : centeredNode i 4 ≠ 0 := by
  fin_cases i <;> norm_num [centeredNode]

/-- The exact dehomogenized Hessian determinant is \(1296/5\) at the node
whose exceptional coordinate is the chart denominator and \(6480\) at each
of the other five nodes. -/
theorem det_chartHessian_chartNode (i : Fin 6) :
    Matrix.det (chartHessian (chartNode i)) =
      if i = 4 then 1296 / 5 else 6480 := by
  rw [← detFour_eq_det]
  fin_cases i <;>
    simp [chartNode, centeredNode, chartHessian, detFour, detThree] <;>
    norm_num

/-- Each of the six rational projective singularities has nondegenerate
dehomogenized Hessian and hence is an ordinary double point in this chart. -/
theorem det_chartHessian_chartNode_ne_zero (i : Fin 6) :
    Matrix.det (chartHessian (chartNode i)) ≠ 0 := by
  rw [det_chartHessian_chartNode]
  split_ifs <;> norm_num

end RelativeConicArcs.GoldenCubicNodeHessians
