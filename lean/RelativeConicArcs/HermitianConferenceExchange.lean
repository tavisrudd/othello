import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Data.Complex.Basic
import Mathlib.Analysis.Convex.Jensen
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Module
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

/-- The positive spectral projection of a complex involution. -/
noncomputable def hermitianPositiveProjection {m : Type*} [DecidableEq m]
    (Q : Matrix m m ℂ) : Matrix m m ℂ :=
  (2⁻¹ : ℂ) • (1 + Q)

/-- The negative spectral projection of a complex involution. -/
noncomputable def hermitianNegativeProjection {m : Type*} [DecidableEq m]
    (Q : Matrix m m ℂ) : Matrix m m ℂ :=
  (2⁻¹ : ℂ) • (1 - Q)

theorem hermitianPositiveProjection_add_negativeProjection
    {m : Type*} [Fintype m] [DecidableEq m] (Q : Matrix m m ℂ) :
    hermitianPositiveProjection Q + hermitianNegativeProjection Q = 1 := by
  simp [hermitianPositiveProjection, hermitianNegativeProjection, smul_add, smul_sub]
  module

/-- The positive projection of an involution is idempotent. -/
theorem hermitianPositiveProjection_mul_self
    {m : Type*} [Fintype m] [DecidableEq m] (Q : Matrix m m ℂ)
    (hQ : Q * Q = 1) :
    hermitianPositiveProjection Q * hermitianPositiveProjection Q =
      hermitianPositiveProjection Q := by
  simp only [hermitianPositiveProjection, Matrix.smul_mul, Matrix.mul_smul,
    add_mul, mul_add, Matrix.one_mul, Matrix.mul_one, hQ]
  module

/-- The negative projection of an involution is idempotent. -/
theorem hermitianNegativeProjection_mul_self
    {m : Type*} [Fintype m] [DecidableEq m] (Q : Matrix m m ℂ)
    (hQ : Q * Q = 1) :
    hermitianNegativeProjection Q * hermitianNegativeProjection Q =
      hermitianNegativeProjection Q := by
  simp only [hermitianNegativeProjection, Matrix.smul_mul, Matrix.mul_smul,
    sub_mul, mul_sub, Matrix.one_mul, Matrix.mul_one, hQ]
  module

/-- The two spectral projections of an involution are orthogonal. -/
theorem hermitianPositiveProjection_mul_negativeProjection
    {m : Type*} [Fintype m] [DecidableEq m] (Q : Matrix m m ℂ)
    (hQ : Q * Q = 1) :
    hermitianPositiveProjection Q * hermitianNegativeProjection Q = 0 := by
  simp only [hermitianPositiveProjection, hermitianNegativeProjection,
    Matrix.smul_mul, Matrix.mul_smul, add_mul, mul_sub, Matrix.one_mul,
    Matrix.mul_one, hQ]
  module

/-- The spectral projections of a Hermitian involution are Hermitian. -/
theorem hermitianNegativeProjection_conjTranspose
    {m : Type*} [Fintype m] [DecidableEq m] (Q : Matrix m m ℂ)
    (hQ : Qᴴ = Q) :
    (hermitianNegativeProjection Q)ᴴ = hermitianNegativeProjection Q := by
  simp [hermitianNegativeProjection, Matrix.conjTranspose_smul,
    Matrix.conjTranspose_sub, hQ]

/-- A real diagonal control embedded in complex matrix space. -/
def realDiagonalControl {m : Type*} [DecidableEq m] (x : m → ℝ) : Matrix m m ℂ :=
  diagonal fun i => (x i : ℂ)

/-- A real diagonal control is Hermitian. -/
theorem realDiagonalControl_conjTranspose {m : Type*} [DecidableEq m] (x : m → ℝ) :
    (realDiagonalControl x)ᴴ = realDiagonalControl x := by
  ext i j
  by_cases h : i = j
  · subst j
    simp [realDiagonalControl, Matrix.conjTranspose_apply]
  · simp [realDiagonalControl, Matrix.conjTranspose_apply, h, Ne.symm h]

/-- Negating a real control negates its diagonal control matrix. -/
theorem realDiagonalControl_neg {m : Type*} [DecidableEq m] (x : m → ℝ) :
    realDiagonalControl (-x) = -realDiagonalControl x := by
  ext i j
  by_cases h : i = j
  · subst j
    simp [realDiagonalControl]
  · simp [realDiagonalControl, h]

/-- The transfer block of a complex control between two ordered orthonormal
frames. -/
def hermitianTransferBlock {m ι : Type*} [Fintype m]
    (D : Matrix m m ℂ) (Qp Qm : Matrix m ι ℂ) : Matrix ι ι ℂ :=
  Qmᴴ * D * Qp

/-- Complementing a Boolean control negates the transfer block. -/
theorem hermitianTransferBlock_neg {m ι : Type*} [Fintype m]
    (D : Matrix m m ℂ) (Qp Qm : Matrix m ι ℂ) :
    hermitianTransferBlock (-D) Qp Qm = -hermitianTransferBlock D Qp Qm := by
  simp [hermitianTransferBlock, Matrix.mul_neg]

/-- Complementing a control leaves its exchange Gram matrix unchanged. -/
theorem hermitianTransferBlock_neg_gram {m ι : Type*} [Fintype m] [Fintype ι]
    (D : Matrix m m ℂ) (Qp Qm : Matrix m ι ℂ) :
    (hermitianTransferBlock (-D) Qp Qm)ᴴ * hermitianTransferBlock (-D) Qp Qm =
      (hermitianTransferBlock D Qp Qm)ᴴ * hermitianTransferBlock D Qp Qm := by
  rw [hermitianTransferBlock_neg]
  simp

/-- The Hermitian transfer Gram matrix is the compression of the
control-conjugated complementary frame projection. -/
theorem hermitianTransferBlock_gram {m ι : Type*} [Fintype m] [Fintype ι]
    (D Pm : Matrix m m ℂ) (Qp Qm : Matrix m ι ℂ)
    (hD : Dᴴ = D) (hQm : Qm * Qmᴴ = Pm) :
    (hermitianTransferBlock D Qp Qm)ᴴ * hermitianTransferBlock D Qp Qm =
      Qpᴴ * (D * Pm * D) * Qp := by
  simp only [hermitianTransferBlock, Matrix.conjTranspose_mul,
    Matrix.conjTranspose_conjTranspose, hD, Matrix.mul_assoc]
  rw [← Matrix.mul_assoc Qm Qmᴴ, hQm]

/-- A frame compression has the same trace as multiplication by its range
projection. -/
theorem trace_frameCompression {m ι : Type*} [Fintype m] [Fintype ι]
    (A P : Matrix m m ℂ) (Qp : Matrix m ι ℂ) (hP : Qp * Qpᴴ = P) :
    (Qpᴴ * A * Qp).trace = (A * P).trace := by
  calc
    (Qpᴴ * A * Qp).trace = (Qp * (Qpᴴ * A)).trace :=
      Matrix.trace_mul_comm (Qpᴴ * A) Qp
    _ = ((Qp * Qpᴴ) * A).trace := by rw [Matrix.mul_assoc]
    _ = (P * A).trace := by rw [hP]
    _ = (A * P).trace := Matrix.trace_mul_comm P A

/-- For positive and negative eigenframes of a Hermitian involution, the first
transfer moment is a full-space trace involving its two spectral projections. -/
theorem trace_hermitianTransferBlock_gram {m ι : Type*}
    [Fintype m] [DecidableEq m] [Fintype ι]
    (D Q : Matrix m m ℂ) (Qp Qm : Matrix m ι ℂ)
    (hD : Dᴴ = D)
    (hPp : Qp * Qpᴴ = hermitianPositiveProjection Q)
    (hPm : Qm * Qmᴴ = hermitianNegativeProjection Q) :
    ((hermitianTransferBlock D Qp Qm)ᴴ * hermitianTransferBlock D Qp Qm).trace =
      (D * hermitianNegativeProjection Q * D * hermitianPositiveProjection Q).trace := by
  rw [hermitianTransferBlock_gram D (hermitianNegativeProjection Q) Qp Qm hD hPm]
  exact trace_frameCompression (D * hermitianNegativeProjection Q * D)
    (hermitianPositiveProjection Q) Qp hPp

/-- For a six-dimensional zero-diagonal Hermitian conference involution, the
full-space transfer trace is the projector-diagonal control formula. -/
theorem trace_realDiagonalControl_projections_fin_six
    (Q : Matrix (Fin 6) (Fin 6) ℂ) (x : Fin 6 → ℝ)
    (hdiag : ∀ i, Q i i = 0)
    (hpair : ∀ i j, i ≠ j → Q i j * Q j i = 1 / 5) :
    (realDiagonalControl x * hermitianNegativeProjection Q * realDiagonalControl x *
        hermitianPositiveProjection Q).trace =
      (((6 * ∑ i, x i ^ 2) - (∑ i, x i) ^ 2) / 20 : ℝ) := by
  have h01 := hpair 0 1 (by decide)
  have h02 := hpair 0 2 (by decide)
  have h03 := hpair 0 3 (by decide)
  have h04 := hpair 0 4 (by decide)
  have h05 := hpair 0 5 (by decide)
  have h12 := hpair 1 2 (by decide)
  have h13 := hpair 1 3 (by decide)
  have h14 := hpair 1 4 (by decide)
  have h15 := hpair 1 5 (by decide)
  have h23 := hpair 2 3 (by decide)
  have h24 := hpair 2 4 (by decide)
  have h25 := hpair 2 5 (by decide)
  have h34 := hpair 3 4 (by decide)
  have h35 := hpair 3 5 (by decide)
  have h45 := hpair 4 5 (by decide)
  simp [Matrix.trace, hermitianNegativeProjection, hermitianPositiveProjection,
    realDiagonalControl, Matrix.mul_apply, Fin.sum_univ_six, hdiag]
  linear_combination
    (-(1 / 2) * (x 0 : ℂ) * x 1) * h01
      + (-(1 / 2) * (x 0 : ℂ) * x 2) * h02
      + (-(1 / 2) * (x 0 : ℂ) * x 3) * h03
      + (-(1 / 2) * (x 0 : ℂ) * x 4) * h04
      + (-(1 / 2) * (x 0 : ℂ) * x 5) * h05
      + (-(1 / 2) * (x 1 : ℂ) * x 2) * h12
      + (-(1 / 2) * (x 1 : ℂ) * x 3) * h13
      + (-(1 / 2) * (x 1 : ℂ) * x 4) * h14
      + (-(1 / 2) * (x 1 : ℂ) * x 5) * h15
      + (-(1 / 2) * (x 2 : ℂ) * x 3) * h23
      + (-(1 / 2) * (x 2 : ℂ) * x 4) * h24
      + (-(1 / 2) * (x 2 : ℂ) * x 5) * h25
      + (-(1 / 2) * (x 3 : ℂ) * x 4) * h34
      + (-(1 / 2) * (x 3 : ℂ) * x 5) * h35
      + (-(1 / 2) * (x 4 : ℂ) * x 5) * h45

/-- The projector-diagonal first-moment expression is at most `9/5` on the
six-dimensional real control cube. -/
theorem controlFirstMoment_le_nine_fifths (x : Fin 6 → ℝ)
    (hx : ∀ i, x i ∈ Set.Icc (-1 : ℝ) 1) :
    (6 * ∑ i, x i ^ 2 - (∑ i, x i) ^ 2) / 20 ≤ 9 / 5 := by
  have hi : ∀ i, x i ^ 2 ≤ 1 := by
    intro i
    have hprod : 0 ≤ (1 - x i) * (1 + x i) :=
      mul_nonneg (sub_nonneg.mpr (hx i).2) (by linarith [(hx i).1])
    nlinarith
  have hsquares : (∑ i, x i ^ 2) ≤ 6 := by
    simp only [Fin.sum_univ_six]
    linarith [hi 0, hi 1, hi 2, hi 3, hi 4, hi 5]
  nlinarith [sq_nonneg (∑ i, x i)]

/-- The first exchange moment of an actual Hermitian conference transfer is
bounded by `9/5` throughout the real control cube. -/
theorem re_trace_hermitianTransferBlock_gram_le_nine_fifths
    (Q : Matrix (Fin 6) (Fin 6) ℂ) (Qp Qm : Matrix (Fin 6) (Fin 3) ℂ)
    (x : Fin 6 → ℝ)
    (hPp : Qp * Qpᴴ = hermitianPositiveProjection Q)
    (hPm : Qm * Qmᴴ = hermitianNegativeProjection Q)
    (hdiag : ∀ i, Q i i = 0)
    (hpair : ∀ i j, i ≠ j → Q i j * Q j i = 1 / 5)
    (hx : ∀ i, x i ∈ Set.Icc (-1 : ℝ) 1) :
    (((hermitianTransferBlock (realDiagonalControl x) Qp Qm)ᴴ *
        hermitianTransferBlock (realDiagonalControl x) Qp Qm).trace).re ≤ 9 / 5 := by
  rw [trace_hermitianTransferBlock_gram (realDiagonalControl x) Q Qp Qm
    (realDiagonalControl_conjTranspose x) hPp hPm,
    trace_realDiagonalControl_projections_fin_six Q x hdiag hpair]
  simpa [pow_two, Complex.mul_re] using controlFirstMoment_le_nine_fifths x hx

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

/-- The fixed-six complementary normalization `I - A²/5` for a principal
block of any support size. -/
noncomputable def fixedSixComplement {n : Type*} [Fintype n] [DecidableEq n]
    (A : Matrix n n ℂ) : Matrix n n ℂ :=
  1 - (1 / 5 : ℂ) • (A * A)

/-- A one-coordinate principal block has fixed-six second moment one. -/
theorem trace_sq_fixedSixComplement_fin_one (A : Matrix (Fin 1) (Fin 1) ℂ)
    (hdiag : A 0 0 = 0) :
    (fixedSixComplement A * fixedSixComplement A).trace = 1 := by
  rw [Matrix.trace_fin_one]
  simp [fixedSixComplement, Matrix.mul_apply, hdiag]

/-- The Hermitian principal block on two coordinates. -/
def hermitianEdge (a : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, a; starRingEnd ℂ a, 0]

/-- A two-coordinate unit-modulus principal block has fixed-six second moment
`32/25`. -/
theorem trace_sq_fixedSixComplement_hermitianEdge (a : ℂ)
    (ha : a * starRingEnd ℂ a = 1) :
    (fixedSixComplement (hermitianEdge a) *
        fixedSixComplement (hermitianEdge a)).trace = 32 / 25 := by
  have ha2 : a ^ 2 * starRingEnd ℂ a ^ 2 = 1 := by
    calc
      a ^ 2 * starRingEnd ℂ a ^ 2 = (a * starRingEnd ℂ a) ^ 2 := by ring
      _ = 1 := by rw [ha]; norm_num
  rw [Matrix.trace_fin_two]
  simp [fixedSixComplement, hermitianEdge, Matrix.mul_apply, Fin.sum_univ_two]
  ring_nf
  rw [ha, ha2]
  norm_num

/-- The three-coordinate fixed-six normalization is the Hermitian exchange
matrix already used for balanced supports. -/
theorem fixedSixComplement_hermitianTriangle (a b c : ℂ) :
    fixedSixComplement (hermitianTriangle a b c) = hermitianExchange a b c := rfl

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

/-- The algebraic Hermitian exchange landscape for a unit-modulus triangle:
the triangle characteristic polynomial and all degree-at-most-three exchange
invariants are controlled by the squared real holonomy. -/
theorem hermitianExchange_landscape (a b c : ℂ)
    (ha : a * starRingEnd ℂ a = 1) (hb : b * starRingEnd ℂ b = 1)
    (hc : c * starRingEnd ℂ c = 1) :
    (hermitianTriangle a b c).charpoly =
        X ^ 3 - C 3 * X - C ((2 * realTriangleHolonomy a b c : ℝ) : ℂ)
      ∧ (hermitianExchange a b c).trace = 9 / 5
      ∧ (hermitianExchange a b c * hermitianExchange a b c).trace = 33 / 25
      ∧ exchangeE2 (hermitianExchange a b c) = 24 / 25
      ∧ (hermitianExchange a b c).det =
          ((4 * (5 - realTriangleHolonomy a b c ^ 2) / 125 : ℝ) : ℂ)
      ∧ exchangeH3 (hermitianExchange a b c) =
          (((317 - 4 * realTriangleHolonomy a b c ^ 2) / 125 : ℝ) : ℂ)
      ∧ exchangeS21 (hermitianExchange a b c) =
          (((196 + 4 * realTriangleHolonomy a b c ^ 2) / 125 : ℝ) : ℂ) := by
  exact ⟨charpoly_hermitianTriangle a b c ha hb hc,
    trace_hermitianExchange a b c ha hb hc,
    trace_sq_hermitianExchange a b c ha hb hc,
    exchangeE2_hermitianExchange a b c ha hb hc,
    det_hermitianExchange a b c ha hb hc,
    exchangeH3_hermitianExchange a b c ha hb hc,
    exchangeS21_hermitianExchange a b c ha hb hc⟩

end Complex

section ParetoGeometry

/-- A point in the three degree-three exchange sectors. -/
structure SectorPoint where
  h3 : ℝ
  s21 : ℝ
  e3 : ℝ

/-- Componentwise dominance of degree-three sector points. -/
def SectorPoint.Dominates (p q : SectorPoint) : Prop :=
  q.h3 ≤ p.h3 ∧ q.s21 ≤ p.s21 ∧ q.e3 ≤ p.e3

/-- The Hermitian exchange frontier parametrized by squared holonomy. -/
noncomputable def hermitianFrontier (t : ℝ) : SectorPoint where
  h3 := (317 - 4 * t) / 125
  s21 := (196 + 4 * t) / 125
  e3 := (20 - 4 * t) / 125

/-- The individual sector bounds and the two supporting inequalities force
every feasible point below some point of the squared-holonomy frontier. -/
theorem exists_hermitianFrontier_dominates (p : SectorPoint)
    (hh : p.h3 ≤ 317 / 125) (hs : p.s21 ≤ 8 / 5) (he : p.e3 ≤ 4 / 25)
    (hse : p.s21 + p.e3 ≤ 216 / 125)
    (hhs : p.h3 + p.s21 ≤ 513 / 125) :
    ∃ t ∈ Set.Icc (0 : ℝ) 1, (hermitianFrontier t).Dominates p := by
  let t := max 0 ((125 * p.s21 - 196) / 4)
  have ht0 : 0 ≤ t := le_max_left _ _
  have htLower : (125 * p.s21 - 196) / 4 ≤ t := le_max_right _ _
  have ht1 : t ≤ 1 := by
    apply max_le
    · norm_num
    · linarith
  have hth : t ≤ (317 - 125 * p.h3) / 4 := by
    apply max_le
    · linarith
    · linarith
  have hte : t ≤ (20 - 125 * p.e3) / 4 := by
    apply max_le
    · linarith
    · linarith
  refine ⟨t, ⟨ht0, ht1⟩, ?_⟩
  constructor
  · change p.h3 ≤ (317 - 4 * t) / 125
    linarith
  constructor
  · change p.s21 ≤ (196 + 4 * t) / 125
    linarith
  · change p.e3 ≤ (20 - 4 * t) / 125
    linarith

/-- Distinct squared-holonomy frontier points are componentwise incomparable. -/
theorem hermitianFrontier_dominates_iff {t u : ℝ} :
    (hermitianFrontier t).Dominates (hermitianFrontier u) ↔ t = u := by
  constructor
  · rintro ⟨hh, hs, _⟩
    simp only [hermitianFrontier] at hh hs
    apply le_antisymm <;> linarith
  · rintro rfl
    exact ⟨le_rfl, le_rfl, le_rfl⟩

/-- Componentwise dominance is transitive. -/
theorem SectorPoint.Dominates.trans {p q r : SectorPoint}
    (hpq : p.Dominates q) (hqr : q.Dominates r) : p.Dominates r :=
  ⟨hqr.1.trans hpq.1, hqr.2.1.trans hpq.2.1, hqr.2.2.trans hpq.2.2⟩

/-- Componentwise dominance is antisymmetric. -/
theorem SectorPoint.Dominates.antisymm {p q : SectorPoint}
    (hpq : p.Dominates q) (hqp : q.Dominates p) : p = q := by
  cases p with
  | mk ph ps pe =>
    cases q with
    | mk qh qs qe =>
      simp only [SectorPoint.Dominates] at hpq hqp
      congr
      · exact le_antisymm hqp.1 hpq.1
      · exact le_antisymm hqp.2.1 hpq.2.1
      · exact le_antisymm hqp.2.2 hpq.2.2

/-- A feasible point is componentwise maximal if no feasible point dominates
it without being equal to it. -/
def SectorPoint.MaximalIn (F : Set SectorPoint) (p : SectorPoint) : Prop :=
  p ∈ F ∧ ∀ q ∈ F, q.Dominates p → q = p

/-- If every feasible point is dominated by the frontier and every frontier
point is feasible, then the componentwise-maximal feasible set is exactly the
squared-holonomy frontier. -/
theorem maximalIn_iff_mem_hermitianFrontier (F : Set SectorPoint)
    (hdom : ∀ p ∈ F, ∃ t ∈ Set.Icc (0 : ℝ) 1, (hermitianFrontier t).Dominates p)
    (hreal : ∀ t ∈ Set.Icc (0 : ℝ) 1, hermitianFrontier t ∈ F) (p : SectorPoint) :
    p.MaximalIn F ↔ p ∈ hermitianFrontier '' Set.Icc (0 : ℝ) 1 := by
  constructor
  · rintro ⟨hpF, hpmax⟩
    rcases hdom p hpF with ⟨t, ht, htp⟩
    exact ⟨t, ht, hpmax (hermitianFrontier t) (hreal t ht) htp⟩
  · rintro ⟨t, ht, rfl⟩
    refine ⟨hreal t ht, ?_⟩
    intro q hq hqt
    rcases hdom q hq with ⟨u, hu, huq⟩
    have hut : u = t := hermitianFrontier_dominates_iff.mp (huq.trans hqt)
    subst u
    exact hqt.antisymm huq

/-- Along the Hermitian frontier, the symmetric and exterior sectors are
maximized exactly at `t = 0`, while the mixed sector is maximized exactly at
`t = 1`. -/
theorem hermitianFrontier_endpoint_equalities (t : ℝ) :
    (hermitianFrontier t).h3 = 317 / 125 ↔ t = 0 := by
  simp only [hermitianFrontier]
  constructor <;> intro h <;> linarith

theorem hermitianFrontier_exterior_endpoint (t : ℝ) :
    (hermitianFrontier t).e3 = 4 / 25 ↔ t = 0 := by
  simp only [hermitianFrontier]
  constructor <;> intro h <;> linarith

theorem hermitianFrontier_mixed_endpoint (t : ℝ) :
    (hermitianFrontier t).s21 = 8 / 5 ↔ t = 1 := by
  simp only [hermitianFrontier]
  constructor <;> intro h <;> linarith

end ParetoGeometry

section MixedSectorBound

/-- The elementary three-variable inequality underlying the continuous-control
bound for the mixed Schur sector.  The variables need only be nonnegative; the
spectral upper bounds enter through their first two elementary invariants. -/
theorem mixedSector_le_eight_fifths (a b c : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (he1 : a + b + c ≤ 9 / 5)
    (he2 : a * b + a * c + b * c ≤ 24 / 25) :
    (a + b + c) * (a * b + a * c + b * c) - a * b * c ≤ 8 / 5 := by
  let u := a + b
  let v := a * b
  let w := 9 / 5 - c
  have hu : 0 ≤ u := by dsimp [u]; positivity
  have huw : u ≤ w := by dsimp [u, w]; linarith
  have hw : 0 ≤ w := hu.trans huw
  have hvSquare : v ≤ u ^ 2 / 4 := by
    dsimp [u, v]
    nlinarith [sq_nonneg (a - b)]
  have hvE2 : v ≤ 24 / 25 - c * u := by
    dsimp [u, v]
    nlinarith
  have hsector :
      (a + b + c) * (a * b + a * c + b * c) - a * b * c =
        u * v + c * u ^ 2 + c ^ 2 * u := by
    dsimp [u, v]
    ring
  rw [hsector]
  by_cases hsmall : c ≤ 1 / 5
  · have huv : u * v ≤ u * (u ^ 2 / 4) :=
      mul_le_mul_of_nonneg_left hvSquare hu
    have hu2 : u ^ 2 ≤ w ^ 2 := by
      have hprod : 0 ≤ (w - u) * (w + u) :=
        mul_nonneg (sub_nonneg.mpr huw) (add_nonneg hw hu)
      nlinarith
    have hu3 : u ^ 3 ≤ w ^ 3 := by
      have hprod : 0 ≤ (w - u) * (w ^ 2 + w * u + u ^ 2) :=
        mul_nonneg (sub_nonneg.mpr huw) (by positivity)
      nlinarith
    have hcu2 : c * u ^ 2 ≤ c * w ^ 2 :=
      mul_le_mul_of_nonneg_left hu2 hc
    have hc2u : c ^ 2 * u ≤ c ^ 2 * w :=
      mul_le_mul_of_nonneg_left huw (sq_nonneg c)
    have hc2bound : c ^ 2 ≤ (1 / 5 : ℝ) ^ 2 := by
      have hprod : 0 ≤ (1 / 5 - c) * (1 / 5 + c) :=
        mul_nonneg (sub_nonneg.mpr hsmall) (by positivity)
      nlinarith
    have hquad : 25 * c ^ 2 + 50 * c - 71 ≤ 0 := by
      nlinarith
    have hfactor : 0 ≤ (5 * c - 1) * (25 * c ^ 2 + 50 * c - 71) :=
      mul_nonneg_of_nonpos_of_nonpos (by linarith) hquad
    calc
      u * v + c * u ^ 2 + c ^ 2 * u
          ≤ u * (u ^ 2 / 4) + c * u ^ 2 + c ^ 2 * u := by linarith
      _ ≤ w ^ 3 / 4 + c * w ^ 2 + c ^ 2 * w := by
        nlinarith
      _ ≤ 8 / 5 := by
        dsimp [w]
        nlinarith
  · have hlarge : 1 / 5 ≤ c := le_of_not_ge hsmall
    have huv : u * v ≤ u * (24 / 25 - c * u) :=
      mul_le_mul_of_nonneg_left hvE2 hu
    have hcoef : 0 ≤ 24 / 25 + c ^ 2 := by positivity
    have hmono : u * (24 / 25 + c ^ 2) ≤ w * (24 / 25 + c ^ 2) :=
      mul_le_mul_of_nonneg_right huw hcoef
    have hfactor : 0 ≤ (5 * c - 4) ^ 2 * (5 * c - 1) :=
      mul_nonneg (sq_nonneg _) (by linarith)
    calc
      u * v + c * u ^ 2 + c ^ 2 * u
          ≤ u * (24 / 25 - c * u) + c * u ^ 2 + c ^ 2 * u := by linarith
      _ = u * (24 / 25 + c ^ 2) := by ring
      _ ≤ w * (24 / 25 + c ^ 2) := hmono
      _ ≤ 8 / 5 := by
        dsimp [w]
        nlinarith

end MixedSectorBound

section CubeVertexReduction

/-- Membership in the real control cube. -/
def InControlCube {ι : Type*} (x : ι → ℝ) : Prop :=
  ∀ i, x i ∈ Set.Icc (-1 : ℝ) 1

/-- A Boolean control has every coordinate at an endpoint of the real cube. -/
def IsBooleanControl {ι : Type*} (x : ι → ℝ) : Prop :=
  ∀ i, x i = -1 ∨ x i = 1

/-- A function has coordinatewise endpoint domination if its value at every
cube point is bounded by the larger value obtained by moving any chosen
coordinate to one of the two endpoints.  Separate convexity implies this
property. -/
def CoordinatewiseEndpointDominated {ι : Type*} [DecidableEq ι]
    (f : (ι → ℝ) → ℝ) : Prop :=
  ∀ x, InControlCube x → ∀ i,
    f x ≤ max (f (Function.update x i (-1))) (f (Function.update x i 1))

/-- Separate convexity of a function along every coordinate line of the real
control cube. -/
def CoordinatewiseConvexOnCube {ι : Type*} [DecidableEq ι]
    (f : (ι → ℝ) → ℝ) : Prop :=
  ∀ x, InControlCube x → ∀ i,
    ConvexOn ℝ (Set.Icc (-1 : ℝ) 1) fun t => f (Function.update x i t)

/-- Separate convexity implies coordinatewise endpoint domination. -/
theorem coordinatewiseEndpointDominated_of_convexOnCube
    {ι : Type*} [DecidableEq ι] (f : (ι → ℝ) → ℝ)
    (hf : CoordinatewiseConvexOnCube f) :
    CoordinatewiseEndpointDominated f := by
  intro x hx i
  have hmax := (hf x hx i).le_max_of_mem_Icc
    (show (-1 : ℝ) ∈ Set.Icc (-1) 1 by simp)
    (show (1 : ℝ) ∈ Set.Icc (-1) 1 by simp) (hx i)
  simpa [Function.update] using hmax

theorem inControlCube_update_endpoint {ι : Type*} [DecidableEq ι]
    {x : ι → ℝ} (hx : InControlCube x) (i : ι) {b : ℝ}
    (hb : b = -1 ∨ b = 1) :
    InControlCube (Function.update x i b) := by
  intro j
  by_cases hji : j = i
  · subst j
    rcases hb with rfl | rfl <;> simp
  · simpa [Function.update, hji] using hx j

/-- One endpoint-dominated coordinate can be moved to a Boolean endpoint
without decreasing the function. -/
theorem exists_endpoint_update {ι : Type*} [DecidableEq ι]
    (f : (ι → ℝ) → ℝ) (hf : CoordinatewiseEndpointDominated f)
    (x : ι → ℝ) (hx : InControlCube x) (i : ι) :
    ∃ b : ℝ, (b = -1 ∨ b = 1)
      ∧ InControlCube (Function.update x i b)
      ∧ f x ≤ f (Function.update x i b) := by
  have hmax := hf x hx i
  by_cases hle : f (Function.update x i (-1)) ≤ f (Function.update x i 1)
  · refine ⟨1, Or.inr rfl, inControlCube_update_endpoint hx i (Or.inr rfl), ?_⟩
    simpa [max_eq_right hle] using hmax
  · have hle' : f (Function.update x i 1) ≤ f (Function.update x i (-1)) :=
      le_of_not_ge hle
    refine ⟨-1, Or.inl rfl, inControlCube_update_endpoint hx i (Or.inl rfl), ?_⟩
    simpa [max_eq_left hle'] using hmax

/-- Endpoint domination on a finite cube reduces every value to a value at a
Boolean vertex. -/
theorem exists_booleanControl_ge {ι : Type*} [Fintype ι] [DecidableEq ι]
    (f : (ι → ℝ) → ℝ) (hf : CoordinatewiseEndpointDominated f)
    (x : ι → ℝ) (hx : InControlCube x) :
    ∃ y : ι → ℝ, InControlCube y ∧ IsBooleanControl y ∧ f x ≤ f y := by
  have aux : ∀ (s : Finset ι) (x : ι → ℝ), InControlCube x →
      ∃ y : ι → ℝ, InControlCube y
        ∧ (∀ j ∉ s, y j = x j)
        ∧ (∀ j ∈ s, y j = -1 ∨ y j = 1)
        ∧ f x ≤ f y := by
    intro s
    induction s using Finset.induction_on with
    | empty =>
        intro x hx
        exact ⟨x, hx, by simp, by simp, le_rfl⟩
    | @insert i s hi ih =>
        intro x hx
        rcases exists_endpoint_update f hf x hx i with ⟨b, hb, hxb, hfxb⟩
        rcases ih (Function.update x i b) hxb with ⟨y, hy, hout, hbool, hby⟩
        refine ⟨y, hy, ?_, ?_, hfxb.trans hby⟩
        · intro j hj
          have hjs : j ∉ s := fun h => hj (Finset.mem_insert_of_mem h)
          have hji : j ≠ i := fun h => hj (h ▸ Finset.mem_insert_self i s)
          rw [hout j hjs]
          simp [Function.update, hji]
        · intro j hj
          rcases Finset.mem_insert.mp hj with hji | hjs
          · have hjns : j ∉ s := by
              intro hjs
              exact hi (hji ▸ hjs)
            rw [hout j hjns]
            simpa [Function.update, hji] using hb
          · exact hbool j hjs
  rcases aux Finset.univ x hx with ⟨y, hy, _, hbool, hfy⟩
  exact ⟨y, hy, fun i => hbool i (Finset.mem_univ i), hfy⟩

/-- A uniform Boolean-vertex bound extends to the whole finite cube for every
coordinatewise convex objective. -/
theorem le_of_coordinatewiseConvexOnCube_of_booleanControl_le
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (f : (ι → ℝ) → ℝ) (M : ℝ) (hf : CoordinatewiseConvexOnCube f)
    (hvertex : ∀ y, IsBooleanControl y → f y ≤ M)
    (x : ι → ℝ) (hx : InControlCube x) : f x ≤ M := by
  rcases exists_booleanControl_ge f
      (coordinatewiseEndpointDominated_of_convexOnCube f hf) x hx with
    ⟨y, _, hy, hxy⟩
  exact hxy.trans (hvertex y hy)

end CubeVertexReduction

end RelativeConicArcs.HermitianConferenceExchange
