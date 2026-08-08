import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic.LinearCombination
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

section Complex

/-- The Hermitian triangle with upper-triangular entries `a`, `b`, `c` and
their conjugates below the diagonal. -/
def hermitianTriangle (a b c : ℂ) : Matrix (Fin 3) (Fin 3) ℂ :=
  pairedTriangle a b c (starRingEnd ℂ a) (starRingEnd ℂ b) (starRingEnd ℂ c)

/-- The real triangle holonomy in the orientation `0 → 1 → 2 → 0`. -/
def realTriangleHolonomy (a b c : ℂ) : ℝ :=
  (a * c * starRingEnd ℂ b).re

/-- The normalized complementary Gram operator determined by a Hermitian
triangle principal block at conference scalar five. -/
noncomputable def hermitianExchange (a b c : ℂ) : Matrix (Fin 3) (Fin 3) ℂ :=
  (1 : Matrix (Fin 3) (Fin 3) ℂ)
    - (1 / 5 : ℂ) • (hermitianTriangle a b c * hermitianTriangle a b c)

/-- The second elementary spectral invariant, written through Newton's
identity in terms of matrix traces. -/
noncomputable def exchangeE2 (H : Matrix (Fin 3) (Fin 3) ℂ) : ℂ :=
  (H.trace ^ 2 - (H * H).trace) / 2

/-- The degree-three complete homogeneous spectral invariant. -/
noncomputable def exchangeH3 (H : Matrix (Fin 3) (Fin 3) ℂ) : ℂ :=
  H.trace ^ 3 - 2 * H.trace * exchangeE2 H + H.det

/-- The degree-three mixed Schur spectral invariant of shape `(2,1)`. -/
noncomputable def exchangeS21 (H : Matrix (Fin 3) (Fin 3) ℂ) : ℂ :=
  H.trace * exchangeE2 H - H.det

/-- For unit-modulus edge entries, the characteristic polynomial of a
Hermitian triangle is `X³ - 3X - 2r`, where `r` is its real triangle
holonomy. -/
theorem charpoly_hermitianTriangle (a b c : ℂ)
    (ha : a * starRingEnd ℂ a = 1) (hb : b * starRingEnd ℂ b = 1)
    (hc : c * starRingEnd ℂ c = 1) :
    (hermitianTriangle a b c).charpoly =
      X ^ 3 - C 3 * X - C ((2 * realTriangleHolonomy a b c : ℝ) : ℂ) := by
  rw [hermitianTriangle, charpoly_pairedTriangle a b c
    (starRingEnd ℂ a) (starRingEnd ℂ b) (starRingEnd ℂ c) ha hb hc]
  congr 2
  rw [realTriangleHolonomy]
  calc
    a * c * starRingEnd ℂ b + b * starRingEnd ℂ c * starRingEnd ℂ a
        = a * c * starRingEnd ℂ b + starRingEnd ℂ (a * c * starRingEnd ℂ b) := by
      simp only [map_mul, starRingEnd_self_apply]
      ring
    _ = ((2 * (a * c * starRingEnd ℂ b).re : ℝ) : ℂ) :=
      Complex.add_conj _

/-- The first exchange power sum is independent of triangle holonomy. -/
theorem trace_hermitianExchange (a b c : ℂ)
    (ha : a * starRingEnd ℂ a = 1) (hb : b * starRingEnd ℂ b = 1)
    (hc : c * starRingEnd ℂ c = 1) :
    (hermitianExchange a b c).trace = 9 / 5 := by
  rw [hermitianExchange, Matrix.trace_fin_three]
  simp [hermitianTriangle, pairedTriangle, Matrix.sub_apply]
  simp only [mul_comm (starRingEnd ℂ a) a, mul_comm (starRingEnd ℂ b) b,
    mul_comm (starRingEnd ℂ c) c, ha, hb, hc]
  norm_num

/-- The second exchange power sum is independent of triangle holonomy. -/
theorem trace_sq_hermitianExchange (a b c : ℂ)
    (ha : a * starRingEnd ℂ a = 1) (hb : b * starRingEnd ℂ b = 1)
    (hc : c * starRingEnd ℂ c = 1) :
    (hermitianExchange a b c * hermitianExchange a b c).trace = 33 / 25 := by
  have ha2 : a ^ 2 * starRingEnd ℂ a ^ 2 = 1 := by
    calc
      a ^ 2 * starRingEnd ℂ a ^ 2 = (a * starRingEnd ℂ a) ^ 2 := by ring
      _ = 1 := by rw [ha]; norm_num
  have hb2 : b ^ 2 * starRingEnd ℂ b ^ 2 = 1 := by
    calc
      b ^ 2 * starRingEnd ℂ b ^ 2 = (b * starRingEnd ℂ b) ^ 2 := by ring
      _ = 1 := by rw [hb]; norm_num
  have hc2 : c ^ 2 * starRingEnd ℂ c ^ 2 = 1 := by
    calc
      c ^ 2 * starRingEnd ℂ c ^ 2 = (c * starRingEnd ℂ c) ^ 2 := by ring
      _ = 1 := by rw [hc]; norm_num
  have hc' : starRingEnd ℂ c * c = 1 := by rw [mul_comm, hc]
  have hc2' : starRingEnd ℂ c ^ 2 * c ^ 2 = 1 := by rw [mul_comm, hc2]
  rw [hermitianExchange, Matrix.trace_fin_three]
  simp [hermitianTriangle, pairedTriangle, Matrix.mul_apply, Fin.sum_univ_three,
    Matrix.sub_apply, Matrix.one_apply]
  ring_nf
  simp only [ha, hb, hc', ha2, hb2, hc2']
  linear_combination (4 / 25) * hb + (8 / 25) * hc'

/-- The exterior exchange sector depends quadratically on the real triangle
holonomy. -/
theorem det_hermitianExchange (a b c : ℂ)
    (ha : a * starRingEnd ℂ a = 1) (hb : b * starRingEnd ℂ b = 1)
    (hc : c * starRingEnd ℂ c = 1) :
    (hermitianExchange a b c).det =
      ((4 * (5 - realTriangleHolonomy a b c ^ 2) / 125 : ℝ) : ℂ) := by
  have ha0 : a ≠ 0 := by
    intro h
    rw [h, zero_mul] at ha
    exact zero_ne_one ha
  have hb0 : b ≠ 0 := by
    intro h
    rw [h, zero_mul] at hb
    exact zero_ne_one hb
  have hc0 : c ≠ 0 := by
    intro h
    rw [h, zero_mul] at hc
    exact zero_ne_one hc
  have haStar : starRingEnd ℂ a = a⁻¹ := by
    apply mul_left_cancel₀ ha0
    simp [ha, ha0]
  have hbStar : starRingEnd ℂ b = b⁻¹ := by
    apply mul_left_cancel₀ hb0
    simp [hb, hb0]
  have hcStar : starRingEnd ℂ c = c⁻¹ := by
    apply mul_left_cancel₀ hc0
    simp [hc, hc0]
  let z := a * c * starRingEnd ℂ b
  have hre : ((z.re : ℝ) : ℂ) = (z + starRingEnd ℂ z) / 2 := by
    rw [Complex.add_conj]
    norm_num
  rw [hermitianExchange, Matrix.det_fin_three, realTriangleHolonomy]
  change _ = ((4 * (5 - z.re ^ 2) / 125 : ℝ) : ℂ)
  push_cast
  rw [hre]
  simp [hermitianTriangle, pairedTriangle, Matrix.sub_apply, z, map_mul,
    haStar, hbStar, hcStar]
  field_simp [ha0, hb0, hc0]
  ring

/-- The second elementary exchange invariant is independent of holonomy. -/
theorem exchangeE2_hermitianExchange (a b c : ℂ)
    (ha : a * starRingEnd ℂ a = 1) (hb : b * starRingEnd ℂ b = 1)
    (hc : c * starRingEnd ℂ c = 1) :
    exchangeE2 (hermitianExchange a b c) = 24 / 25 := by
  rw [exchangeE2, trace_hermitianExchange a b c ha hb hc,
    trace_sq_hermitianExchange a b c ha hb hc]
  norm_num

/-- The complete homogeneous degree-three exchange sector is
`(317 - 4r²)/125`. -/
theorem exchangeH3_hermitianExchange (a b c : ℂ)
    (ha : a * starRingEnd ℂ a = 1) (hb : b * starRingEnd ℂ b = 1)
    (hc : c * starRingEnd ℂ c = 1) :
    exchangeH3 (hermitianExchange a b c) =
      (((317 - 4 * realTriangleHolonomy a b c ^ 2) / 125 : ℝ) : ℂ) := by
  rw [exchangeH3, trace_hermitianExchange a b c ha hb hc,
    exchangeE2_hermitianExchange a b c ha hb hc,
    det_hermitianExchange a b c ha hb hc]
  push_cast
  ring

/-- The mixed degree-three exchange sector is `(196 + 4r²)/125`. -/
theorem exchangeS21_hermitianExchange (a b c : ℂ)
    (ha : a * starRingEnd ℂ a = 1) (hb : b * starRingEnd ℂ b = 1)
    (hc : c * starRingEnd ℂ c = 1) :
    exchangeS21 (hermitianExchange a b c) =
      (((196 + 4 * realTriangleHolonomy a b c ^ 2) / 125 : ℝ) : ℂ) := by
  rw [exchangeS21, trace_hermitianExchange a b c ha hb hc,
    exchangeE2_hermitianExchange a b c ha hb hc,
    det_hermitianExchange a b c ha hb hc]
  push_cast
  ring

end Complex

end RelativeConicArcs.HermitianConferenceExchange
