import Mathlib.Tactic
import RelativeConicArcs.ClebschGoldenConference

/-!
# Centered Golden cubic gradient

This module fixes five centered coordinates for the augmentation space of six
homogeneous coordinates and records the explicit gradient quadrics of the
Golden orientation cubic.  The omitted coordinate is the negative sum of the
five displayed coordinates.
-/

namespace RelativeConicArcs.GoldenCubicNodesBase

open ClebschGoldenConference

/-- The five-coordinate representative of the centered vector \(1 - 6 e_i\).
For \(i = 5\), the omitted sixth coordinate is \(-5\), so all five displayed
coordinates equal one. -/
def centeredNode {R : Type*} [Ring R] (i : Fin 6) : Fin 5 → R := fun j =>
  if (i : ℕ) = (j : ℕ) then -5 else 1

/-- The coordinate gradient of the Golden cubic after substituting
\(x_5 = -(x_0 + x_1 + x_2 + x_3 + x_4)\). -/
def gradient {R : Type*} [CommRing R] (x : Fin 5 → R) : Fin 5 → R :=
  ![-2*x 0*x 1 - 2*x 0*x 2 + 2*x 0*x 3 + 2*x 0*x 4 - (x 1)^2
      - 2*x 1*x 2 - 2*x 1*x 3 + 2*x 1*x 4 - (x 2)^2
      + 2*x 2*x 3 - 2*x 2*x 4 + (x 3)^2 + 2*x 3*x 4 + (x 4)^2,
    -(x 0)^2 - 2*x 0*x 1 - 2*x 0*x 2 - 2*x 0*x 3 + 2*x 0*x 4
      + 2*x 1*x 2 - 2*x 1*x 3 + 2*x 1*x 4 + (x 2)^2
      + 2*x 2*x 3 + 2*x 2*x 4 - (x 3)^2 - 2*x 3*x 4 + (x 4)^2,
    -(x 0)^2 - 2*x 0*x 1 - 2*x 0*x 2 + 2*x 0*x 3 - 2*x 0*x 4
      + (x 1)^2 + 2*x 1*x 2 + 2*x 1*x 3 + 2*x 1*x 4
      + 2*x 2*x 3 - 2*x 2*x 4 + (x 3)^2 - 2*x 3*x 4 - (x 4)^2,
    (x 0)^2 - 2*x 0*x 1 + 2*x 0*x 2 + 2*x 0*x 3 + 2*x 0*x 4
      - (x 1)^2 + 2*x 1*x 2 - 2*x 1*x 3 - 2*x 1*x 4 + (x 2)^2
      + 2*x 2*x 3 - 2*x 2*x 4 - 2*x 3*x 4 - (x 4)^2,
    (x 0)^2 + 2*x 0*x 1 - 2*x 0*x 2 + 2*x 0*x 3 + 2*x 0*x 4
      + (x 1)^2 + 2*x 1*x 2 - 2*x 1*x 3 + 2*x 1*x 4 - (x 2)^2
      - 2*x 2*x 3 - 2*x 2*x 4 - (x 3)^2 - 2*x 3*x 4]

/-- The centered Golden cubic reconstructed from its homogeneous quadratic
gradient by Euler's degree-three identity. -/
def cubic {K : Type*} [Field K] (x : Fin 5 → K) : K :=
  (1 / 3) * ∑ i, x i * gradient x i

/-- The six-coordinate centered lift whose coordinates sum to zero. -/
def centeredLift {R : Type*} [CommRing R] (x : Fin 5 → R) : Fin 6 → R :=
  ![x 0, x 1, x 2, x 3, x 4, -(x 0+x 1+x 2+x 3+x 4)]

/-- The Euler-reconstructed cubic is exactly the oriented triangle cubic of
the fixed Golden conference matrix on the centered lift. -/
theorem cubic_eq_conference_triangleCubic (x : Fin 5 → ℚ) :
    cubic x =
      triangleCubic (conferenceMatrixOver ℚ) (centeredLift x) := by
  simp [cubic, gradient, centeredLift, triangleCubic, cubicTerm, triangleSign,
    conferenceMatrixOver, conferenceMatrix, Fin.sum_univ_succ]
  ring

/-- The Golden cubic restricted to one coordinate line, as a univariate
polynomial over the rationals. -/
noncomputable def coordinatePolynomial (x : Fin 5 → ℚ) (i : Fin 5) : Polynomial ℚ :=
  let y := Function.update (fun j => Polynomial.C (x j)) i Polynomial.X
  Polynomial.C (1 / 3) * ∑ j, y j * gradient y j

/-- Differentiating the coordinate-line polynomial and evaluating at the
original coordinate gives the displayed gradient component. -/
theorem derivative_coordinatePolynomial_eval (x : Fin 5 → ℚ) (i : Fin 5) :
    (coordinatePolynomial x i).derivative.eval (x i) = gradient x i := by
  fin_cases i <;>
    simp [coordinatePolynomial, gradient, Fin.sum_univ_succ,
      Function.update, Polynomial.derivative_pow] <;>
    ring

end RelativeConicArcs.GoldenCubicNodesBase
