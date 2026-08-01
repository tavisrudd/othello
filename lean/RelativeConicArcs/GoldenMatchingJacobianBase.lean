import RelativeConicArcs.GoldenMatchingCubics
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Tactic.Ring

/-!
# Jacobian minors of the six-point matching cubics

After translation sets the sixth coordinate to zero, the five noncrossing
matching cubics form a polynomial map in five affine coordinates.  This module
defines its transposed differential, explicit determinant formulas, the six
selected minors used on collision charts, and representatives of those charts.
The three collision identities are proved in separate modules so each symbolic
normalization has a bounded elaboration unit.
-/

namespace RelativeConicArcs.GoldenMatchingJacobian

/-- The transposed differential of the five matching cubics in the chart
where the sixth affine coordinate is zero. -/
def matchingJacobian {R : Type*} [CommRing R] (x : Fin 5 → R) :
    Matrix (Fin 5) (Fin 5) R :=
  let a := x 0
  let b := x 1
  let c := x 2
  let d := x 3
  let e := x 4
  ![![(c - d) * e, c * (d - e), (b - c) * e,
      (b - c) * (d - e), (b - e) * (c - d)],
    ![-(c - d) * e, -c * (d - e), (a - d) * e,
      a * (d - e), a * (c - d)],
    ![(a - b) * e, (a - b) * (d - e), -(a - d) * e,
      -a * (d - e), a * (b - e)],
    ![-(a - b) * e, (a - b) * c, -(b - c) * e,
      a * (b - c), -a * (b - e)],
    ![(a - b) * (c - d), -(a - b) * c, (a - d) * (b - c),
      -a * (b - c), -a * (c - d)]]

/-- The explicit determinant of a three-by-three matrix. -/
def detThree {R : Type*} [CommRing R] (m : Matrix (Fin 3) (Fin 3) R) : R :=
  m 0 0 * (m 1 1 * m 2 2 - m 1 2 * m 2 1) -
  m 0 1 * (m 1 0 * m 2 2 - m 1 2 * m 2 0) +
  m 0 2 * (m 1 0 * m 2 1 - m 1 1 * m 2 0)

/-- The explicit three-by-three formula agrees with `Matrix.det`. -/
theorem detThree_eq_det {R : Type*} [CommRing R]
    (m : Matrix (Fin 3) (Fin 3) R) : detThree m = Matrix.det m := by
  rw [Matrix.det_fin_three]
  simp [detThree]
  ring

/-- The explicit first-row Laplace expansion of a four-by-four determinant. -/
def detFour {R : Type*} [CommRing R] (m : Matrix (Fin 4) (Fin 4) R) : R :=
  m 0 0 * detThree ![![m 1 1, m 1 2, m 1 3],
                        ![m 2 1, m 2 2, m 2 3],
                        ![m 3 1, m 3 2, m 3 3]] -
  m 0 1 * detThree ![![m 1 0, m 1 2, m 1 3],
                        ![m 2 0, m 2 2, m 2 3],
                        ![m 3 0, m 3 2, m 3 3]] +
  m 0 2 * detThree ![![m 1 0, m 1 1, m 1 3],
                        ![m 2 0, m 2 1, m 2 3],
                        ![m 3 0, m 3 1, m 3 3]] -
  m 0 3 * detThree ![![m 1 0, m 1 1, m 1 2],
                        ![m 2 0, m 2 1, m 2 2],
                        ![m 3 0, m 3 1, m 3 2]]

/-- The explicit four-by-four Laplace formula agrees with `Matrix.det`. -/
theorem detFour_eq_det {R : Type*} [CommRing R]
    (m : Matrix (Fin 4) (Fin 4) R) : detFour m = Matrix.det m := by
  rw [Matrix.det_succ_row_zero]
  simp [detFour, detThree, Matrix.det_fin_three, Fin.sum_univ_succ,
    Fin.succAbove]
  ring

/-- The increasing embedding omitting coordinate zero. -/
def withoutZero : Fin 4 → Fin 5 := ![1, 2, 3, 4]
/-- The increasing embedding omitting coordinate one. -/
def withoutOne : Fin 4 → Fin 5 := ![0, 2, 3, 4]
/-- The increasing embedding omitting coordinate three. -/
def withoutThree : Fin 4 → Fin 5 := ![0, 1, 2, 4]
/-- The increasing embedding omitting coordinate four. -/
def withoutFour : Fin 4 → Fin 5 := ![0, 1, 2, 3]

/-- A four-by-four minor selected by ordered row and column embeddings. -/
def selectedMinor {R : Type*} [CommRing R] (x : Fin 5 → R)
    (rows cols : Fin 4 → Fin 5) : R :=
  detFour (fun i j => matchingJacobian x (rows i) (cols j))

/-- A selected minor is the determinant of the corresponding four-by-four
submatrix of the matching Jacobian. -/
theorem selectedMinor_eq_det {R : Type*} [CommRing R] (x : Fin 5 → R)
    (rows cols : Fin 4 → Fin 5) :
    selectedMinor x rows cols =
      Matrix.det (fun i j => matchingJacobian x (rows i) (cols j)) := by
  exact detFour_eq_det _

/-- Minor 5 in column-subset-first lexicographic order. -/
def minorFive {R : Type*} [CommRing R] (x : Fin 5 → R) : R :=
  selectedMinor x withoutZero withoutFour

/-- Minor 16 in column-subset-first lexicographic order. -/
def minorSixteen {R : Type*} [CommRing R] (x : Fin 5 → R) : R :=
  selectedMinor x withoutFour withoutOne

/-- Minor 17 in column-subset-first lexicographic order. -/
def minorSeventeen {R : Type*} [CommRing R] (x : Fin 5 → R) : R :=
  selectedMinor x withoutThree withoutOne

/-- Minor 20 in column-subset-first lexicographic order. -/
def minorTwenty {R : Type*} [CommRing R] (x : Fin 5 → R) : R :=
  selectedMinor x withoutZero withoutOne

/-- Minor 21 in column-subset-first lexicographic order. -/
def minorTwentyOne {R : Type*} [CommRing R] (x : Fin 5 → R) : R :=
  selectedMinor x withoutFour withoutZero

/-- Minor 25 in column-subset-first lexicographic order. -/
def minorTwentyFive {R : Type*} [CommRing R] (x : Fin 5 → R) : R :=
  selectedMinor x withoutZero withoutZero

/-- A representative affine chart for a `4+1+1` collision stratum. -/
def chartFourOneOne (a b c d : ℚ) : Fin 5 → ℚ :=
  ![1, 1 + a, 1 + b, 1 + c, -1 + d]

/-- A representative affine chart for a `4+2` collision stratum. -/
def chartFourTwo (a b c d : ℚ) : Fin 5 → ℚ :=
  ![1, 1 + a, 1 + b, 1 + c, d]

/-- A representative affine chart for a `5+1` collision stratum. -/
def chartFiveOne (a b c d : ℚ) : Fin 5 → ℚ :=
  ![1, 1 + a, 1 + b, 1 + c, 1 + d]

end RelativeConicArcs.GoldenMatchingJacobian
