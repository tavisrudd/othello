import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisLocalChart
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff

/-!
# Explicit residue-field slope models for the six-axis chart

This module records literal four-dimensional matrices having the two slope
types quoted in the manuscript: two copies of the irreducible quadratic
companion block in characteristic two, and a scalar block in characteristic
three.  It does not identify either matrix with the geometric principal
kernel.

The two finite characteristic-two checks below are evaluated by ordinary
kernel reduction with `decide`: one equality of explicit `4 × 4` matrices and
one exhaustive check over the two elements of `ZMod 2`.  No native-code
decision procedure, external certificate, or oracle is used.  The
characteristic-three scalar claims are proved symbolically.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- Two copies of the companion matrix of `t²+t+1` over `F₂`, written on the
four-dimensional depth-one block. -/
def sixAxisTwoQuadraticSlope : Matrix (Fin 4) (Fin 4) (ZMod 2) :=
  !![0, 1, 0, 0;
     1, 1, 0, 0;
     0, 0, 0, 1;
     0, 0, 1, 1]

/-- The displayed characteristic-two slope satisfies its quadratic
polynomial `T²+T+1=0`.  Ordinary kernel `decide` evaluates the explicit
`4 × 4` equality. -/
theorem sixAxisTwoQuadraticSlope_polynomial :
    sixAxisTwoQuadraticSlope * sixAxisTwoQuadraticSlope +
        sixAxisTwoQuadraticSlope + 1 = 0 := by
  decide

/-- The polynomial `t²+t+1` has no root in `F₂`.  Ordinary kernel `decide`
checks the two possible inputs. -/
theorem zmodTwo_quadraticSlopePolynomial_no_root :
    ∀ value : ZMod 2, value ^ 2 + value + 1 ≠ 0 := by
  decide

/-- Consequently the displayed quadratic slope is not a scalar matrix. -/
theorem sixAxisTwoQuadraticSlope_not_scalar
    (value : ZMod 2) :
    sixAxisTwoQuadraticSlope ≠ Matrix.scalar (Fin 4) value := by
  intro equality
  have offDiagonal := congrArg
    (fun matrix : Matrix (Fin 4) (Fin 4) (ZMod 2) ↦ matrix 0 1) equality
  norm_num [sixAxisTwoQuadraticSlope, Matrix.scalar_apply] at offDiagonal

/-- The characteristic-three one-point model is a scalar slope on the full
four-dimensional depth-one block. -/
def sixAxisThreeScalarSlope (value : ZMod 3) :
    Matrix (Fin 4) (Fin 4) (ZMod 3) :=
  Matrix.scalar (Fin 4) value

/-- The characteristic-three model is literally the image of its scalar
under the matrix-algebra structure. -/
theorem sixAxisThreeScalarSlope_eq_algebraMap (value : ZMod 3) :
    sixAxisThreeScalarSlope value =
      algebraMap (ZMod 3) (Matrix (Fin 4) (Fin 4) (ZMod 3)) value := by
  rfl

/-- A scalar slope commutes with every coefficient block, so it contributes
no residual commutator condition beyond the diagonal depth. -/
theorem sixAxisThreeScalarSlope_commutes
    (value : ZMod 3) (coefficient : Matrix (Fin 4) (Fin 4) (ZMod 3)) :
    coefficient * sixAxisThreeScalarSlope value =
      sixAxisThreeScalarSlope value * coefficient := by
  exact (Matrix.scalar_comm value (fun otherValue =>
    Commute.all value otherValue) coefficient).symm

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
