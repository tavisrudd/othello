import Mathlib.Data.Matrix.Mul
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# Three-vertex principal blocks of symmetric conference matrices

A balanced half of an order-six symmetric conference matrix has three
vertices.  Its principal block is therefore a zero-diagonal symmetric sign
matrix with three edge signs.  This module proves the polynomial identity
that makes the squared spectrum of every such block independent of those
signs.

The unrestricted exclusion of the analogous property in higher conference
orders uses inclusion-matrix rank and the Ramsey equality `R(3,3) = 6`; those
combinatorial results are not formalized here.
-/

namespace RelativeConicArcs.ConferenceCutSpectrum

open Matrix
open scoped Matrix

/-- The symmetric zero-diagonal matrix on three vertices with edge signs
`a`, `b`, and `c`. -/
def signedTriangle {R : Type*} [Zero R] (a b c : R) :
    Matrix (Fin 3) (Fin 3) R :=
  !![0, a, b;
     a, 0, c;
     b, c, 0]

/-- Squaring a three-vertex sign matrix depends on its edge signs only through
their product.  In particular, when the signs square to one, its square is
`2I + (abc)A`. -/
theorem signedTriangle_sq {R : Type*} [CommRing R] (a b c : R)
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1) :
    signedTriangle a b c * signedTriangle a b c =
      (2 : R) • (1 : Matrix (Fin 3) (Fin 3) R) +
        (a * b * c) • signedTriangle a b c := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [signedTriangle, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    ring_nf at ha hb hc ⊢ <;>
    simp [ha, hb, hc] <;>
    norm_num

end RelativeConicArcs.ConferenceCutSpectrum
