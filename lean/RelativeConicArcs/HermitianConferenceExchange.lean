import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Tactic.Ring

/-!
# Hermitian triangle blocks in conference exchange

A three-element principal block of a Hermitian conference matrix has three
oriented upper-triangular entries and their conjugates below the diagonal.  The
determinant calculation underlying its exchange spectrum is algebraic: one may
replace conjugation by three paired reverse entries whose products with the
forward entries are one.

This module defines that paired triangle over a commutative ring and proves its
characteristic polynomial.  The only nonconstant coefficient is the sum of the
two oriented triangle products.  For complex conjugate pairs this sum is twice
the real part of one triangle product, which is the real triangle holonomy.

Every result is a symbolic kernel proof.  No classification of Hermitian
conference matrices or finite enumeration is used.
-/

namespace RelativeConicArcs.HermitianConferenceExchange

open Matrix Polynomial
open scoped Matrix

variable {R : Type*} [CommRing R]

/-- A zero-diagonal three-by-three matrix with forward edge entries `a`, `b`,
`c` and independently named reverse entries `ar`, `br`, `cr`.  A Hermitian
triangle is obtained by taking the reverse entries to be the conjugates of the
forward entries. -/
def pairedTriangle (a b c ar br cr : R) : Matrix (Fin 3) (Fin 3) R :=
  !![0, a, b; ar, 0, c; br, cr, 0]

/-- The characteristic polynomial of a paired unit triangle is
`X³ - 3X - (acbr + bcrar)`.  Thus the three edge pairs contribute the fixed
linear coefficient, while the two orientations of the triangle contribute the
constant coefficient. -/
theorem charpoly_pairedTriangle (a b c ar br cr : R)
    (ha : a * ar = 1) (hb : b * br = 1) (hc : c * cr = 1) :
    (pairedTriangle a b c ar br cr).charpoly =
      X ^ 3 - C 3 * X - C (a * c * br + b * cr * ar) := by
  have haC : (C a : R[X]) * C ar = 1 := by rw [← map_mul, ha, map_one]
  have hbC : (C b : R[X]) * C br = 1 := by rw [← map_mul, hb, map_one]
  have hcC : (C c : R[X]) * C cr = 1 := by rw [← map_mul, hc, map_one]
  have haX : (C a : R[X]) * C ar * X = X := by rw [haC, one_mul]
  have hbX : (C b : R[X]) * X * C br = X := by
    calc
      C b * X * C br = X * (C b * C br) := by ring
      _ = X := by rw [hbC, mul_one]
  have hcX : (C c : R[X]) * X * C cr = X := by
    calc
      C c * X * C cr = X * (C c * C cr) := by ring
      _ = X := by rw [hcC, mul_one]
  rw [Matrix.charpoly, Matrix.det_fin_three]
  simp [pairedTriangle]
  rw [haX, hbX, hcX]
  simp only [map_ofNat]
  ring

end RelativeConicArcs.HermitianConferenceExchange
