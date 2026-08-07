import Mathlib.Data.Matrix.ColumnRowPartitioned
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.NoncommRing
import RelativeConicArcs.ConferenceCutBlocks

/-!
# The exchange operator of a balanced cut

Let `C` be a symmetric matrix with `C * C = q • 1` over a field of
characteristic zero, let `s` satisfy `s * s = q`, and normalize to the
involution `Q = s⁻¹ • C`.  A cut of the index set into two halves gives the sign
involution `D` that is `1` on the first half and `-1` on the second, and the
two spectral projections `(1 ± Q)/2`.  Compressing `D * (1 - Q)/2 * D` to the
fixed space of `Q` along an isometry `U` — a matrix with `Uᵀ * U = 1` and
`U * Uᵀ = (1 + Q)/2` — gives the *exchange operator* of the cut.

This module proves that its characteristic polynomial and all of its power
traces are those of `q⁻¹ • (B * Bᵀ)`, for `B` the cross block of the cut, and
hence, by the cut identity of `RelativeConicArcs.ConferenceCutBlocks`, those of
`1 - q⁻¹ • (A * A)` for `A` the principal block.

The argument is polynomial identities and characteristic polynomials
throughout.  No eigenvalue, singular value, or diagonalization enters, and `s`
is a hypothesis rather than a square-root operation, so nothing here needs an
ordered or complete field.  Two facts about the commutator `L = D * Q - Q * D`
carry the proof: it is antisymmetric, and it anticommutes with `Q`.  The first
makes the compression of `-(L * L)/4` a Gram matrix `Sᵀ * S`, whose companion
`S * Sᵀ` is the compression to the antifixed space, so
`Matrix.charpoly_mul_comm'` equates the two compressions; the second makes
every trace `trace (L ^ j * Q)` vanish, which halves the trace of a power of
`-(L * L)/4` onto the fixed space.

The results are stated for arbitrary isometries onto the two spectral spaces
and are therefore conditional on such isometries existing; their existence is
not proved here.
-/

namespace RelativeConicArcs.BalancedExchangeSpectrum

open Matrix Polynomial

section Involution

variable {R : Type*} [Field R] [CharZero R] {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- The projection onto the fixed space of an involution `Q`. -/
def fixedProjection (Q : Matrix ι ι R) : Matrix ι ι R := (2 : R)⁻¹ • (1 + Q)

/-- The projection onto the antifixed space of an involution `Q`, that is, onto
the space on which `Q` acts as `-1`. -/
def antifixedProjection (Q : Matrix ι ι R) : Matrix ι ι R := (2 : R)⁻¹ • (1 - Q)

/-- The commutator of the cut's sign involution `D` with the normalized matrix
`Q`.  It is antisymmetric and anticommutes with `Q`. -/
def signCommutator (D Q : Matrix ι ι R) : Matrix ι ι R := D * Q - Q * D

/-- The exchange operator on the whole space: minus a quarter of the square of
the sign commutator.  In cut coordinates it is block diagonal, with blocks
`q⁻¹ • (B * Bᵀ)` and `q⁻¹ • (Bᵀ * B)` for `B` the cross block. -/
def exchangeOperator (D Q : Matrix ι ι R) : Matrix ι ι R :=
  -((4 : R)⁻¹ • (signCommutator D Q * signCommutator D Q))

/-- The exchange operator of the cut, compressed to the fixed space of `Q`
along an isometry `U`.  This is the matrix `Uᵀ D (1 - Q)/2 D U`. -/
def exchangeCompression {κ : Type*} (D Q : Matrix ι ι R) (U : Matrix ι κ R) :
    Matrix κ κ R :=
  Uᵀ * (D * (antifixedProjection Q * (D * U)))

omit [CharZero R] [Fintype ι] in
theorem fixedProjection_transpose {Q : Matrix ι ι R} (hQt : Qᵀ = Q) :
    (fixedProjection Q)ᵀ = fixedProjection Q := by
  simp [fixedProjection, Matrix.transpose_smul, Matrix.transpose_add, hQt]

omit [CharZero R] [Fintype ι] in
theorem antifixedProjection_transpose {Q : Matrix ι ι R} (hQt : Qᵀ = Q) :
    (antifixedProjection Q)ᵀ = antifixedProjection Q := by
  simp [antifixedProjection, Matrix.transpose_smul, Matrix.transpose_sub, hQt]

omit [Fintype ι] in
theorem fixedProjection_add_antifixedProjection (Q : Matrix ι ι R) :
    fixedProjection Q + antifixedProjection Q = 1 := by
  rw [fixedProjection, antifixedProjection, ← smul_add]
  rw [show (1 : Matrix ι ι R) + Q + (1 - Q) = (2 : R) • (1 : Matrix ι ι R) by
    rw [two_smul]; abel]
  rw [smul_smul, inv_mul_cancel₀ (two_ne_zero), one_smul]

theorem antifixedProjection_mul_self {Q : Matrix ι ι R} (hQ : Q * Q = 1) :
    antifixedProjection Q * antifixedProjection Q = antifixedProjection Q := by
  have hsq : (1 - Q) * (1 - Q) = (2 : R) • (1 - Q) := by
    have : (1 - Q) * (1 - Q) = 1 - Q - Q + Q * Q := by noncomm_ring
    rw [this, hQ, two_smul]
    abel
  rw [antifixedProjection, Matrix.smul_mul, Matrix.mul_smul, smul_smul, hsq, smul_smul]
  congr 1
  field_simp

theorem fixedProjection_mul_self {Q : Matrix ι ι R} (hQ : Q * Q = 1) :
    fixedProjection Q * fixedProjection Q = fixedProjection Q := by
  have hsq : (1 + Q) * (1 + Q) = (2 : R) • (1 + Q) := by
    have : (1 + Q) * (1 + Q) = 1 + Q + Q + Q * Q := by noncomm_ring
    rw [this, hQ, two_smul]
    abel
  rw [fixedProjection, Matrix.smul_mul, Matrix.mul_smul, smul_smul, hsq, smul_smul]
  congr 1
  field_simp

omit [CharZero R] in
theorem fixedProjection_mul_antifixedProjection {Q : Matrix ι ι R} (hQ : Q * Q = 1) :
    fixedProjection Q * antifixedProjection Q = 0 := by
  have hzero : (1 + Q) * (1 - Q) = 0 := by
    have : (1 + Q) * (1 - Q) = 1 - Q * Q := by noncomm_ring
    rw [this, hQ, sub_self]
  rw [fixedProjection, antifixedProjection, Matrix.smul_mul, Matrix.mul_smul, hzero]
  simp

omit [CharZero R] in
theorem antifixedProjection_mul_fixedProjection {Q : Matrix ι ι R} (hQ : Q * Q = 1) :
    antifixedProjection Q * fixedProjection Q = 0 := by
  have hzero : (1 - Q) * (1 + Q) = 0 := by
    have : (1 - Q) * (1 + Q) = 1 - Q * Q := by noncomm_ring
    rw [this, hQ, sub_self]
  rw [fixedProjection, antifixedProjection, Matrix.smul_mul, Matrix.mul_smul, hzero]
  simp

omit [CharZero R] [DecidableEq ι] in
theorem signCommutator_transpose {D Q : Matrix ι ι R} (hDt : Dᵀ = D) (hQt : Qᵀ = Q) :
    (signCommutator D Q)ᵀ = -signCommutator D Q := by
  rw [signCommutator, Matrix.transpose_sub, Matrix.transpose_mul, Matrix.transpose_mul,
    hDt, hQt]
  abel

omit [CharZero R] in
/-- The sign commutator anticommutes with the involution it is built from. -/
theorem signCommutator_mul_involution {D Q : Matrix ι ι R} (hQ : Q * Q = 1) :
    signCommutator D Q * Q = -(Q * signCommutator D Q) := by
  have h₁ : (D * Q - Q * D) * Q = D * (Q * Q) - Q * D * Q := by noncomm_ring
  have h₂ : Q * (D * Q - Q * D) = Q * D * Q - Q * Q * D := by noncomm_ring
  rw [signCommutator, h₁, h₂, hQ, mul_one, one_mul]
  abel

omit [CharZero R] in
/-- The square of the sign commutator commutes with the involution. -/
theorem sq_signCommutator_mul_involution {D Q : Matrix ι ι R} (hQ : Q * Q = 1) :
    signCommutator D Q * signCommutator D Q * Q = Q * (signCommutator D Q * signCommutator D Q) := by
  have h := signCommutator_mul_involution (D := D) hQ
  calc signCommutator D Q * signCommutator D Q * Q
      = signCommutator D Q * (signCommutator D Q * Q) := by rw [mul_assoc]
    _ = signCommutator D Q * -(Q * signCommutator D Q) := by rw [h]
    _ = -(signCommutator D Q * Q * signCommutator D Q) := by
        rw [Matrix.mul_neg, mul_assoc]
    _ = -(-(Q * signCommutator D Q) * signCommutator D Q) := by rw [h]
    _ = Q * (signCommutator D Q * signCommutator D Q) := by
        rw [Matrix.neg_mul, neg_neg, mul_assoc]

omit [CharZero R] in
theorem exchangeOperator_mul_involution {D Q : Matrix ι ι R} (hQ : Q * Q = 1) :
    exchangeOperator D Q * Q = Q * exchangeOperator D Q := by
  rw [exchangeOperator, Matrix.neg_mul, Matrix.mul_neg, Matrix.smul_mul, Matrix.mul_smul,
    sq_signCommutator_mul_involution hQ]

omit [CharZero R] in
theorem exchangeOperator_mul_fixedProjection {D Q : Matrix ι ι R} (hQ : Q * Q = 1) :
    exchangeOperator D Q * fixedProjection Q = fixedProjection Q * exchangeOperator D Q := by
  rw [fixedProjection, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_add, Matrix.add_mul,
    mul_one, one_mul, exchangeOperator_mul_involution hQ]

omit [CharZero R] in
theorem exchangeOperator_mul_antifixedProjection {D Q : Matrix ι ι R} (hQ : Q * Q = 1) :
    exchangeOperator D Q * antifixedProjection Q
      = antifixedProjection Q * exchangeOperator D Q := by
  rw [antifixedProjection, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_sub, Matrix.sub_mul,
    mul_one, one_mul, exchangeOperator_mul_involution hQ]

/-- Every trace `trace (L ^ (j + 1) * Q)` vanishes, because moving one factor of
the anticommuting `L` around the trace reverses the sign. -/
theorem trace_pow_signCommutator_mul_involution {D Q : Matrix ι ι R} (hQ : Q * Q = 1)
    (j : ℕ) : Matrix.trace (signCommutator D Q ^ (j + 1) * Q) = 0 := by
  set L := signCommutator D Q with hL
  have hstep : L ^ (j + 1) * Q = -(L ^ j * Q * L) := by
    rw [pow_succ, mul_assoc, signCommutator_mul_involution (D := D) hQ, ← hL,
      Matrix.mul_neg, mul_assoc]
  have hcyc : Matrix.trace (L ^ j * Q * L) = Matrix.trace (L ^ (j + 1) * Q) := by
    rw [Matrix.trace_mul_comm, ← mul_assoc, ← pow_succ']
  have h := congrArg Matrix.trace hstep
  rw [Matrix.trace_neg, hcyc] at h
  have h2 : (2 : R) * Matrix.trace (L ^ (j + 1) * Q) = 0 := by linear_combination h
  rcases mul_eq_zero.mp h2 with h' | h'
  · exact absurd h' two_ne_zero
  · exact h'

/-- The trace of a power of the exchange operator against the involution
vanishes. -/
theorem trace_pow_exchangeOperator_mul_involution {D Q : Matrix ι ι R} (hQ : Q * Q = 1)
    (k : ℕ) : Matrix.trace (exchangeOperator D Q ^ (k + 1) * Q) = 0 := by
  have hpow : exchangeOperator D Q ^ (k + 1)
      = (-(4 : R)⁻¹) ^ (k + 1) • signCommutator D Q ^ (2 * (k + 1)) := by
    rw [exchangeOperator, ← neg_smul, smul_pow, pow_mul, sq]
  rw [hpow, Matrix.smul_mul, Matrix.trace_smul,
    show 2 * (k + 1) = (2 * k + 1) + 1 by ring,
    trace_pow_signCommutator_mul_involution hQ, smul_zero]

end Involution

section Isometry

variable {R : Type*} [Field R] [CharZero R] {ι κ : Type*} [Fintype ι] [DecidableEq ι]
  [Fintype κ] [DecidableEq κ]

omit [CharZero R] in
/-- An isometry onto the fixed space of `Q` is fixed by `Q`. -/
theorem involution_mul_isometry {Q : Matrix ι ι R} {U : Matrix ι κ R} (hQ : Q * Q = 1)
    (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection Q) : Q * U = U := by
  have hproj : Q * fixedProjection Q = fixedProjection Q := by
    rw [fixedProjection, Matrix.mul_smul, Matrix.mul_add, mul_one, hQ]
    rw [show Q + 1 = 1 + Q by abel]
  have h₁ : Q * (U * Uᵀ) * U = (U * Uᵀ) * U := by rw [hUU, hproj]
  have h₂ : Q * (U * Uᵀ) * U = Q * U := by
    simp only [Matrix.mul_assoc, hU, Matrix.mul_one]
  have h₃ : (U * Uᵀ) * U = U := by
    simp only [Matrix.mul_assoc, hU, Matrix.mul_one]
  rw [← h₂, h₁, h₃]

theorem fixedProjection_mul_isometry {Q : Matrix ι ι R} {U : Matrix ι κ R} (hQ : Q * Q = 1)
    (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection Q) : fixedProjection Q * U = U := by
  rw [fixedProjection, Matrix.smul_mul, Matrix.add_mul, Matrix.one_mul,
    involution_mul_isometry hQ hU hUU, ← two_smul R U, smul_smul,
    inv_mul_cancel₀ (two_ne_zero), one_smul]

omit [CharZero R] in
/-- An isometry onto the antifixed space of `Q` is negated by `Q`. -/
theorem involution_mul_antiIsometry {Q : Matrix ι ι R} {W : Matrix ι κ R} (hQ : Q * Q = 1)
    (hW : Wᵀ * W = 1) (hWW : W * Wᵀ = antifixedProjection Q) : Q * W = -W := by
  have hproj : Q * antifixedProjection Q = -antifixedProjection Q := by
    rw [antifixedProjection, Matrix.mul_smul, Matrix.mul_sub, mul_one, hQ, ← smul_neg]
    rw [neg_sub]
  have h₁ : Q * (W * Wᵀ) * W = -(W * Wᵀ) * W := by rw [hWW, hproj]
  have h₂ : Q * (W * Wᵀ) * W = Q * W := by
    simp only [Matrix.mul_assoc, hW, Matrix.mul_one]
  have h₃ : -(W * Wᵀ) * W = -W := by
    simp only [Matrix.neg_mul, Matrix.mul_assoc, hW, Matrix.mul_one]
  rw [← h₂, h₁, h₃]

/-- The sign commutator carries an isometry onto the fixed space into the
antifixed space. -/
theorem signCommutator_mul_isometry {D Q : Matrix ι ι R} {U : Matrix ι κ R} (hQ : Q * Q = 1)
    (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection Q) :
    signCommutator D Q * U = (2 : R) • (antifixedProjection Q * (D * U)) := by
  have hRHS : (2 : R) • (antifixedProjection Q * (D * U)) = D * U - Q * (D * U) := by
    rw [antifixedProjection, Matrix.smul_mul, smul_smul, mul_inv_cancel₀ (two_ne_zero),
      one_smul, Matrix.sub_mul, Matrix.one_mul]
  rw [hRHS, signCommutator, Matrix.sub_mul, Matrix.mul_assoc,
    involution_mul_isometry hQ hU hUU, Matrix.mul_assoc]

theorem antifixedProjection_mul_signCommutator_mul_isometry {D Q : Matrix ι ι R}
    {U : Matrix ι κ R} (hQ : Q * Q = 1) (hU : Uᵀ * U = 1)
    (hUU : U * Uᵀ = fixedProjection Q) :
    antifixedProjection Q * (signCommutator D Q * U) = signCommutator D Q * U := by
  rw [signCommutator_mul_isometry hQ hU hUU, Matrix.mul_smul,
    ← Matrix.mul_assoc (antifixedProjection Q) (antifixedProjection Q) (D * U),
    antifixedProjection_mul_self hQ]

/-- The sign commutator carries an isometry onto the antifixed space into the
fixed space. -/
theorem fixedProjection_mul_signCommutator_mul_antiIsometry {D Q : Matrix ι ι R}
    {W : Matrix ι κ R} (hQ : Q * Q = 1) (hW : Wᵀ * W = 1)
    (hWW : W * Wᵀ = antifixedProjection Q) :
    fixedProjection Q * (signCommutator D Q * W) = signCommutator D Q * W := by
  have hRHS : (2 : R) • (fixedProjection Q * (D * W)) = D * W + Q * (D * W) := by
    rw [fixedProjection, Matrix.smul_mul, smul_smul, mul_inv_cancel₀ (two_ne_zero),
      one_smul, Matrix.add_mul, Matrix.one_mul]
  have hLW : signCommutator D Q * W = -((2 : R) • (fixedProjection Q * (D * W))) := by
    rw [hRHS, signCommutator, Matrix.sub_mul, Matrix.mul_assoc,
      involution_mul_antiIsometry hQ hW hWW, Matrix.mul_assoc, Matrix.mul_neg]
    abel
  rw [hLW, Matrix.mul_neg, Matrix.mul_smul,
    ← Matrix.mul_assoc (fixedProjection Q) (fixedProjection Q) (D * W),
    fixedProjection_mul_self hQ]

omit [DecidableEq ι] [DecidableEq κ] [Fintype κ] in
/-- Four times a compression of the exchange operator is minus the compression
of the square of the sign commutator.  No property of the compressing matrix is
used. -/
theorem smul_compression_exchangeOperator (D Q : Matrix ι ι R) (V : Matrix ι κ R) :
    (4 : R) • (Vᵀ * (exchangeOperator D Q * V))
      = -(Vᵀ * (signCommutator D Q * signCommutator D Q * V)) := by
  rw [exchangeOperator, Matrix.neg_mul, Matrix.mul_neg, Matrix.smul_mul, Matrix.mul_smul,
    smul_neg, smul_smul, mul_inv_cancel₀ (by norm_num : (4 : R) ≠ 0), one_smul]

omit [DecidableEq ι] [DecidableEq κ] [Fintype κ] in
/-- A compression of the exchange operator, written through the square of the
sign commutator. -/
theorem compression_exchangeOperator_eq (D Q : Matrix ι ι R) (V : Matrix ι κ R) :
    Vᵀ * (exchangeOperator D Q * V)
      = (4 : R)⁻¹ • (-(Vᵀ * (signCommutator D Q * signCommutator D Q * V))) := by
  rw [← smul_compression_exchangeOperator, smul_smul,
    inv_mul_cancel₀ (by norm_num : (4 : R) ≠ 0), one_smul]

/-- The Gram matrix of the sign commutator against an isometry onto the fixed
space is four times the exchange operator of the cut. -/
theorem gram_signCommutator_mul_isometry {D Q : Matrix ι ι R} {U : Matrix ι κ R}
    (hQ : Q * Q = 1) (hDt : Dᵀ = D) (hQt : Qᵀ = Q) (hU : Uᵀ * U = 1)
    (hUU : U * Uᵀ = fixedProjection Q) :
    (signCommutator D Q * U)ᵀ * (signCommutator D Q * U)
      = (4 : R) • exchangeCompression D Q U := by
  rw [signCommutator_mul_isometry hQ hU hUU, Matrix.transpose_smul, Matrix.smul_mul,
    Matrix.mul_smul, smul_smul, show (2 : R) * 2 = 4 by norm_num, exchangeCompression]
  congr 1
  rw [Matrix.transpose_mul, Matrix.transpose_mul, antifixedProjection_transpose hQt, hDt]
  simp only [Matrix.mul_assoc]
  rw [← Matrix.mul_assoc (antifixedProjection Q) (antifixedProjection Q) (D * U),
    antifixedProjection_mul_self hQ]

omit [DecidableEq ι] [DecidableEq κ] [Fintype κ] in
/-- The same Gram matrix, written through the exchange operator on the whole
space.  Comparing the two forms identifies the compression. -/
theorem gram_signCommutator_mul_isometry' {D Q : Matrix ι ι R} {U : Matrix ι κ R}
    (hDt : Dᵀ = D) (hQt : Qᵀ = Q) :
    (signCommutator D Q * U)ᵀ * (signCommutator D Q * U)
      = (4 : R) • (Uᵀ * (exchangeOperator D Q * U)) := by
  rw [smul_compression_exchangeOperator, Matrix.transpose_mul,
    signCommutator_transpose hDt hQt, Matrix.mul_neg, Matrix.neg_mul]
  congr 1
  simp only [Matrix.mul_assoc]

/-- The exchange operator of the cut is the compression of `-(L * L)/4`, for
`L` the sign commutator. -/
theorem exchangeCompression_eq {D Q : Matrix ι ι R} {U : Matrix ι κ R} (hQ : Q * Q = 1)
    (hDt : Dᵀ = D) (hQt : Qᵀ = Q) (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection Q) :
    exchangeCompression D Q U = Uᵀ * (exchangeOperator D Q * U) := by
  have h4 : (4 : R) • exchangeCompression D Q U
      = (4 : R) • (Uᵀ * (exchangeOperator D Q * U)) := by
    rw [← gram_signCommutator_mul_isometry hQ hDt hQt hU hUU,
      gram_signCommutator_mul_isometry' hDt hQt]
  calc exchangeCompression D Q U = (4 : R)⁻¹ • ((4 : R) • exchangeCompression D Q U) := by
        rw [smul_smul, inv_mul_cancel₀ (by norm_num : (4 : R) ≠ 0), one_smul]
    _ = (4 : R)⁻¹ • ((4 : R) • (Uᵀ * (exchangeOperator D Q * U))) := by rw [h4]
    _ = Uᵀ * (exchangeOperator D Q * U) := by
        rw [smul_smul, inv_mul_cancel₀ (by norm_num : (4 : R) ≠ 0), one_smul]

/-- Powers of the compression are compressions of powers, because the exchange
operator commutes with the projection the isometry ranges over. -/
theorem exchangeCompression_pow {D Q : Matrix ι ι R} {U : Matrix ι κ R} (hQ : Q * Q = 1)
    (hDt : Dᵀ = D) (hQt : Qᵀ = Q) (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection Q)
    (k : ℕ) :
    exchangeCompression D Q U ^ (k + 1) = Uᵀ * (exchangeOperator D Q ^ (k + 1) * U) := by
  have hcomm : fixedProjection Q * (exchangeOperator D Q * U) = exchangeOperator D Q * U := by
    rw [← Matrix.mul_assoc, ← exchangeOperator_mul_fixedProjection hQ, Matrix.mul_assoc,
      fixedProjection_mul_isometry hQ hU hUU]
  induction k with
  | zero => rw [pow_one, pow_one, exchangeCompression_eq hQ hDt hQt hU hUU]
  | succ k ih =>
      rw [pow_succ, ih, exchangeCompression_eq hQ hDt hQt hU hUU]
      simp only [Matrix.mul_assoc]
      rw [← Matrix.mul_assoc U Uᵀ (exchangeOperator D Q * U), hUU, hcomm,
        ← Matrix.mul_assoc (exchangeOperator D Q ^ (k + 1)) (exchangeOperator D Q) U,
        ← pow_succ]

/-- Half of the trace of a power of the exchange operator on the whole space is
the trace of the corresponding power of its compression: the projection
contributes its identity part only, since the trace of a power of the operator
against the involution vanishes. -/
theorem trace_exchangeCompression_pow {D Q : Matrix ι ι R} {U : Matrix ι κ R} (hQ : Q * Q = 1)
    (hDt : Dᵀ = D) (hQt : Qᵀ = Q) (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection Q)
    (k : ℕ) :
    Matrix.trace (exchangeCompression D Q U ^ (k + 1))
      = (2 : R)⁻¹ * Matrix.trace (exchangeOperator D Q ^ (k + 1)) := by
  rw [exchangeCompression_pow hQ hDt hQt hU hUU k, Matrix.trace_mul_comm, Matrix.mul_assoc,
    hUU, fixedProjection, Matrix.mul_smul, Matrix.trace_smul, Matrix.mul_add, mul_one,
    Matrix.trace_add, trace_pow_exchangeOperator_mul_involution hQ, add_zero, smul_eq_mul]

end Isometry

section Charpoly

variable {R : Type*} [Field R] [CharZero R] {ι κ κ' : Type*} [Fintype ι] [DecidableEq ι]
  [Fintype κ] [DecidableEq κ] [Fintype κ'] [DecidableEq κ']

/-- The compressions of the exchange operator to the two spectral spaces of `Q`
have the same characteristic polynomial: they are `Sᵀ * S` and `S * Sᵀ` for the
matrix `S` obtained from the sign commutator, which intertwines the two
spaces. -/
theorem charpoly_compression_eq {D Q : Matrix ι ι R} {U : Matrix ι κ R} {W : Matrix ι κ' R}
    (hQ : Q * Q = 1) (hDt : Dᵀ = D) (hQt : Qᵀ = Q) (hU : Uᵀ * U = 1)
    (hUU : U * Uᵀ = fixedProjection Q) (hW : Wᵀ * W = 1)
    (hWW : W * Wᵀ = antifixedProjection Q) (hcard : Fintype.card κ = Fintype.card κ') :
    (Uᵀ * (exchangeOperator D Q * U)).charpoly
      = (Wᵀ * (exchangeOperator D Q * W)).charpoly := by
  set S : Matrix κ' κ R := (2 : R)⁻¹ • (Wᵀ * (signCommutator D Q * U)) with hS
  have hSt : Sᵀ = (2 : R)⁻¹ • ((signCommutator D Q * U)ᵀ * W) := by
    rw [hS, Matrix.transpose_smul, Matrix.transpose_mul, Matrix.transpose_transpose]
  have hfour : (2 : R)⁻¹ * (2 : R)⁻¹ * 4 = 1 := by norm_num
  have hleft : Sᵀ * S = Uᵀ * (exchangeOperator D Q * U) := by
    rw [hSt, hS, Matrix.smul_mul, Matrix.mul_smul, smul_smul]
    simp only [Matrix.mul_assoc]
    rw [← Matrix.mul_assoc W Wᵀ (signCommutator D Q * U), hWW,
      antifixedProjection_mul_signCommutator_mul_isometry hQ hU hUU,
      gram_signCommutator_mul_isometry' hDt hQt, smul_smul, hfour, one_smul]
  have hinner : (Wᵀ * (signCommutator D Q * U)) * ((signCommutator D Q * U)ᵀ * W)
      = -(Wᵀ * (signCommutator D Q * signCommutator D Q * W)) := by
    rw [Matrix.transpose_mul, signCommutator_transpose hDt hQt, Matrix.mul_neg,
      Matrix.neg_mul, Matrix.mul_neg]
    congr 1
    simp only [Matrix.mul_assoc]
    rw [← Matrix.mul_assoc U Uᵀ (signCommutator D Q * W), hUU,
      fixedProjection_mul_signCommutator_mul_antiIsometry hQ hW hWW]
  have hright : S * Sᵀ = Wᵀ * (exchangeOperator D Q * W) := by
    rw [hSt, hS, Matrix.smul_mul, Matrix.mul_smul, smul_smul, hinner,
      compression_exchangeOperator_eq,
      show (2 : R)⁻¹ * (2 : R)⁻¹ = (4 : R)⁻¹ by norm_num]
  have hcomm := Matrix.charpoly_mul_comm' Sᵀ S
  rw [hleft, hright, hcard] at hcomm
  exact (isRegular_X_pow (Fintype.card κ')).left hcomm

/-- The characteristic polynomial of the exchange operator on the whole space
is the product of those of its two compressions. -/
theorem charpoly_compression_mul {D Q : Matrix ι ι R} {U : Matrix ι κ R} {W : Matrix ι κ' R}
    (hQ : Q * Q = 1) (hQt : Qᵀ = Q) (hU : Uᵀ * U = 1)
    (hUU : U * Uᵀ = fixedProjection Q) (hW : Wᵀ * W = 1)
    (hWW : W * Wᵀ = antifixedProjection Q)
    (hcard : Fintype.card ι = Fintype.card κ + Fintype.card κ') :
    (Uᵀ * (exchangeOperator D Q * U)).charpoly * (Wᵀ * (exchangeOperator D Q * W)).charpoly
      = (exchangeOperator D Q).charpoly := by
  set M := exchangeOperator D Q with hM
  set V : Matrix ι (κ ⊕ κ') R := Matrix.fromCols U W with hV
  have hVt : Vᵀ = Matrix.fromRows Uᵀ Wᵀ := by rw [hV, Matrix.transpose_fromCols]
  have hVV : V * Vᵀ = 1 := by
    rw [hV, hVt, Matrix.fromCols_mul_fromRows, hUU, hWW,
      fixedProjection_add_antifixedProjection]
  have hPU : fixedProjection Q * U = U := fixedProjection_mul_isometry hQ hU hUU
  have hUP : Uᵀ * fixedProjection Q = Uᵀ := by
    have h := congrArg Matrix.transpose hPU
    rwa [Matrix.transpose_mul, fixedProjection_transpose hQt] at h
  have hPW : antifixedProjection Q * W = W := by
    have h := congrArg (fun X => X * W) hWW
    simp only [Matrix.mul_assoc, hW, Matrix.mul_one] at h
    exact h.symm
  have hWP : Wᵀ * antifixedProjection Q = Wᵀ := by
    have h := congrArg Matrix.transpose hPW
    rwa [Matrix.transpose_mul, antifixedProjection_transpose hQt] at h
  have hcross : Uᵀ * (M * W) = 0 := by
    calc Uᵀ * (M * W) = (Uᵀ * fixedProjection Q) * (M * (antifixedProjection Q * W)) := by
          rw [hUP, hPW]
      _ = Uᵀ * ((fixedProjection Q * M) * (antifixedProjection Q * W)) := by
          simp only [Matrix.mul_assoc]
      _ = Uᵀ * ((M * fixedProjection Q) * (antifixedProjection Q * W)) := by
          rw [hM, exchangeOperator_mul_fixedProjection hQ]
      _ = Uᵀ * (M * ((fixedProjection Q * antifixedProjection Q) * W)) := by
          simp only [Matrix.mul_assoc]
      _ = 0 := by rw [fixedProjection_mul_antifixedProjection hQ]; simp
  have hcross' : Wᵀ * (M * U) = 0 := by
    calc Wᵀ * (M * U) = (Wᵀ * antifixedProjection Q) * (M * (fixedProjection Q * U)) := by
          rw [hWP, hPU]
      _ = Wᵀ * ((antifixedProjection Q * M) * (fixedProjection Q * U)) := by
          simp only [Matrix.mul_assoc]
      _ = Wᵀ * ((M * antifixedProjection Q) * (fixedProjection Q * U)) := by
          rw [hM, exchangeOperator_mul_antifixedProjection hQ]
      _ = Wᵀ * (M * ((antifixedProjection Q * fixedProjection Q) * U)) := by
          simp only [Matrix.mul_assoc]
      _ = 0 := by rw [antifixedProjection_mul_fixedProjection hQ]; simp
  have hblocks : Vᵀ * (M * V) = Matrix.fromBlocks (Uᵀ * (M * U)) 0 0 (Wᵀ * (M * W)) := by
    rw [hVt, hV, Matrix.mul_fromCols, Matrix.fromRows_mul_fromCols, hcross, hcross']
  have hcp := Matrix.charpoly_mul_comm' Vᵀ (M * V)
  rw [hblocks, ← Matrix.mul_assoc, Matrix.mul_assoc M V Vᵀ, hVV, Matrix.mul_one,
    Matrix.charpoly_fromBlocks_zero₁₂, Fintype.card_sum, hcard] at hcp
  have hreg := (isRegular_X_pow (Fintype.card κ + Fintype.card κ')).left hcp
  simp only [Matrix.mul_assoc] at hreg ⊢
  exact hreg

end Charpoly

/-- Two monic polynomials of the same degree with equal squares are equal: their
difference and their sum multiply to zero, and their sum has leading
coefficient `2`. -/
private theorem monic_eq_of_mul_self_eq {R : Type*} [Field R] [CharZero R] {p r : R[X]}
    (hp : p.Monic) (hr : r.Monic) (hdeg : p.natDegree = r.natDegree) (h : p * p = r * r) :
    p = r := by
  have hfac : (p - r) * (p + r) = 0 := by
    have hexp : (p - r) * (p + r) = p * p - r * r := by ring
    rw [hexp, h, sub_self]
  have hne : p + r ≠ 0 := by
    intro h0
    have hcoeff : (p + r).coeff p.natDegree = 2 := by
      rw [Polynomial.coeff_add, hp.coeff_natDegree, hdeg, hr.coeff_natDegree]
      norm_num
    rw [h0] at hcoeff
    norm_num at hcoeff
  rcases mul_eq_zero.mp hfac with h1 | h1
  · exact sub_eq_zero.mp h1
  · exact absurd h1 hne

section Cut

variable {R : Type*} [Field R] [CharZero R] {n m : Type*} [Fintype n] [DecidableEq n]
  [Fintype m] [DecidableEq m]

/-- The sign involution of a cut: the identity on the first half of the index
set and its negative on the second. -/
def cutInvolution (n m : Type*) [DecidableEq n] [DecidableEq m] (R : Type*) [CommRing R] :
    Matrix (n ⊕ m) (n ⊕ m) R :=
  Matrix.fromBlocks 1 0 0 (-1)

omit [CharZero R] [Fintype n] [DecidableEq n] [Fintype m] [DecidableEq m] in
private theorem fromBlocks_sub' (A₁ A₂ : Matrix n n R) (B₁ B₂ : Matrix n m R)
    (C₁ C₂ : Matrix m n R) (E₁ E₂ : Matrix m m R) :
    Matrix.fromBlocks A₁ B₁ C₁ E₁ - Matrix.fromBlocks A₂ B₂ C₂ E₂
      = Matrix.fromBlocks (A₁ - A₂) (B₁ - B₂) (C₁ - C₂) (E₁ - E₂) := by
  ext (i | i) (j | j) <;> simp

omit [CharZero R] [DecidableEq n] [DecidableEq m] in
private theorem trace_fromBlocks' (A₁ : Matrix n n R) (B₁ : Matrix n m R) (C₁ : Matrix m n R)
    (E₁ : Matrix m m R) :
    Matrix.trace (Matrix.fromBlocks A₁ B₁ C₁ E₁) = Matrix.trace A₁ + Matrix.trace E₁ := by
  simp [Matrix.trace, Fintype.sum_sum_type]

omit [CharZero R] in
private theorem fromBlocks_pow (A₁ : Matrix n n R) (E₁ : Matrix m m R) (k : ℕ) :
    Matrix.fromBlocks A₁ 0 0 E₁ ^ (k + 1)
      = Matrix.fromBlocks (A₁ ^ (k + 1)) 0 0 (E₁ ^ (k + 1)) := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [pow_succ, ih, Matrix.fromBlocks_multiply]
      simp [pow_succ]

omit [CharZero R] in
private theorem pow_mul_comm_aux (X : Matrix n m R) (Y : Matrix m n R) (k : ℕ) :
    (X * Y) ^ (k + 1) = X * ((Y * X) ^ k * Y) := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [pow_succ, ih, pow_succ]
      simp only [Matrix.mul_assoc]

omit [CharZero R] in
/-- The two products of a rectangular pair have the same power traces. -/
private theorem trace_pow_mul_comm (X : Matrix n m R) (Y : Matrix m n R) (k : ℕ) :
    Matrix.trace ((X * Y) ^ (k + 1)) = Matrix.trace ((Y * X) ^ (k + 1)) := by
  rw [pow_mul_comm_aux, Matrix.trace_mul_comm, Matrix.mul_assoc, ← pow_succ]

/-- In cut coordinates the exchange operator on the whole space is block
diagonal: the two blocks are the two products of the cross block with its
transpose, divided by the scalar the matrix squares to. -/
theorem exchangeOperator_cut {A : Matrix n n R} {B : Matrix n m R} {E : Matrix m m R}
    {q s : R} (hs : s * s = q) (hs0 : s ≠ 0) :
    exchangeOperator (cutInvolution n m R) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E)
      = Matrix.fromBlocks (q⁻¹ • (B * Bᵀ)) 0 0 (q⁻¹ • (Bᵀ * B)) := by
  have hq : q ≠ 0 := by rw [← hs]; exact mul_ne_zero hs0 hs0
  have hDC : cutInvolution n m R * Matrix.fromBlocks A B Bᵀ E
      = Matrix.fromBlocks A B (-Bᵀ) (-E) := by
    rw [cutInvolution, Matrix.fromBlocks_multiply]
    simp
  have hCD : Matrix.fromBlocks A B Bᵀ E * cutInvolution n m R
      = Matrix.fromBlocks A (-B) Bᵀ (-E) := by
    rw [cutInvolution, Matrix.fromBlocks_multiply]
    simp
  have hL : signCommutator (cutInvolution n m R) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E)
      = s⁻¹ • Matrix.fromBlocks 0 ((2 : R) • B) (-((2 : R) • Bᵀ)) 0 := by
    rw [signCommutator, Matrix.mul_smul, Matrix.smul_mul, hDC, hCD, ← smul_sub, fromBlocks_sub',
      show A - A = (0 : Matrix n n R) by abel,
      show B - -B = (2 : R) • B by rw [two_smul]; abel,
      show -Bᵀ - Bᵀ = -((2 : R) • Bᵀ) by rw [two_smul]; abel,
      show -E - -E = (0 : Matrix m m R) by abel]
  have hLL : signCommutator (cutInvolution n m R) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E)
        * signCommutator (cutInvolution n m R) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E)
      = Matrix.fromBlocks (-((4 * q⁻¹ : R) • (B * Bᵀ))) 0 0 (-((4 * q⁻¹ : R) • (Bᵀ * B))) := by
    rw [hL, Matrix.smul_mul, Matrix.mul_smul, smul_smul, Matrix.fromBlocks_multiply,
      show s⁻¹ * s⁻¹ = q⁻¹ by rw [← mul_inv, hs], Matrix.fromBlocks_smul]
    congr 1
    · simp only [Matrix.zero_mul, zero_add, Matrix.mul_neg, Matrix.smul_mul, Matrix.mul_smul,
        smul_smul, smul_neg]
      rw [show (2 : R) * 2 = 4 by norm_num, mul_comm q⁻¹ (4 : R)]
    · simp
    · simp
    · simp only [Matrix.mul_zero, add_zero, Matrix.neg_mul, Matrix.smul_mul, Matrix.mul_smul,
        smul_smul, smul_neg]
      rw [show (2 : R) * 2 = 4 by norm_num, mul_comm q⁻¹ (4 : R)]
  rw [exchangeOperator, hLL, Matrix.fromBlocks_smul, Matrix.fromBlocks_neg]
  congr 1
  · rw [smul_neg, neg_neg, smul_smul, show (4 : R)⁻¹ * (4 * q⁻¹) = q⁻¹ by field_simp]
  · simp
  · simp
  · rw [smul_neg, neg_neg, smul_smul, show (4 : R)⁻¹ * (4 * q⁻¹) = q⁻¹ by field_simp]

omit [CharZero R] in
/-- The cross-block form of the principal block: the first diagonal block of the
exchange operator is `1 - q⁻¹ A²`. -/
theorem cutBlock_eq {A : Matrix n n R} {B : Matrix n m R} {E : Matrix m m R} {q : R}
    (hq : q ≠ 0)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = q • 1) :
    q⁻¹ • (B * Bᵀ) = 1 - q⁻¹ • (A * A) := by
  rw [ConferenceCutBlocks.mul_transpose_eq_of_sq_smul A B E q hCC, smul_sub, smul_smul,
    inv_mul_cancel₀ hq, one_smul]

/-- The characteristic polynomial of the exchange operator of a balanced cut is
that of `1 - q⁻¹ A²`, for `A` the principal block on the chosen half. -/
theorem charpoly_exchangeCompression_cut {A : Matrix n n R} {B : Matrix n m R}
    {E : Matrix m m R} {q s : R} {U : Matrix (n ⊕ m) n R} {W : Matrix (n ⊕ m) m R}
    (hAt : Aᵀ = A) (hEt : Eᵀ = E)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0)
    (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E))
    (hW : Wᵀ * W = 1)
    (hWW : W * Wᵀ = antifixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E))
    (hcard : Fintype.card n = Fintype.card m) :
    (exchangeCompression (cutInvolution n m R) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E) U).charpoly
      = (1 - q⁻¹ • (A * A)).charpoly := by
  have hq : q ≠ 0 := by rw [← hs]; exact mul_ne_zero hs0 hs0
  set C := Matrix.fromBlocks A B Bᵀ E with hC
  set Q := s⁻¹ • C with hQdef
  set D := cutInvolution n m R with hDdef
  have hQ : Q * Q = 1 := by
    rw [hQdef, Matrix.smul_mul, Matrix.mul_smul, smul_smul, hC, hCC, smul_smul,
      show s⁻¹ * s⁻¹ * q = 1 by rw [← mul_inv, hs, inv_mul_cancel₀ hq], one_smul]
  have hQt : Qᵀ = Q := by
    rw [hQdef, Matrix.transpose_smul, hC, Matrix.fromBlocks_transpose, hAt, hEt,
      Matrix.transpose_transpose]
  have hDt : Dᵀ = D := by
    rw [hDdef, cutInvolution, Matrix.fromBlocks_transpose]
    simp
  have hD : D * D = 1 := by
    rw [hDdef, cutInvolution, Matrix.fromBlocks_multiply]
    simp
  have hM : exchangeOperator D Q
      = Matrix.fromBlocks (q⁻¹ • (B * Bᵀ)) 0 0 (q⁻¹ • (Bᵀ * B)) :=
    exchangeOperator_cut hs hs0
  have hNN : (q⁻¹ • (Bᵀ * B)).charpoly = (q⁻¹ • (B * Bᵀ)).charpoly := by
    have h := Matrix.charpoly_mul_comm' (q⁻¹ • B) Bᵀ
    rw [Matrix.smul_mul, Matrix.mul_smul, hcard] at h
    exact ((isRegular_X_pow (Fintype.card m)).left h).symm
  have hsq : (exchangeCompression D Q U).charpoly * (exchangeCompression D Q U).charpoly
      = (q⁻¹ • (B * Bᵀ)).charpoly * (q⁻¹ • (B * Bᵀ)).charpoly := by
    rw [exchangeCompression_eq hQ hDt hQt hU hUU]
    nth_rewrite 2 [charpoly_compression_eq hQ hDt hQt hU hUU hW hWW hcard]
    rw [charpoly_compression_mul hQ hQt hU hUU hW hWW Fintype.card_sum, hM,
      Matrix.charpoly_fromBlocks_zero₁₂, hNN]
  have hmonic := Matrix.charpoly_monic (exchangeCompression D Q U)
  have hmonic' := Matrix.charpoly_monic (q⁻¹ • (B * Bᵀ))
  have hdeg : (exchangeCompression D Q U).charpoly.natDegree
      = (q⁻¹ • (B * Bᵀ)).charpoly.natDegree := by
    rw [Matrix.charpoly_natDegree_eq_dim, Matrix.charpoly_natDegree_eq_dim]
  have := monic_eq_of_mul_self_eq hmonic hmonic' hdeg hsq
  rw [this, cutBlock_eq hq hCC]

/-- Every power trace of the exchange operator of a balanced cut is that of
`1 - q⁻¹ A²`. -/
theorem trace_exchangeCompression_pow_cut {A : Matrix n n R} {B : Matrix n m R}
    {E : Matrix m m R} {q s : R} {U : Matrix (n ⊕ m) n R}
    (hAt : Aᵀ = A) (hEt : Eᵀ = E)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0)
    (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E))
    (k : ℕ) :
    Matrix.trace
        (exchangeCompression (cutInvolution n m R) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E) U
          ^ (k + 1))
      = Matrix.trace ((1 - q⁻¹ • (A * A)) ^ (k + 1)) := by
  have hq : q ≠ 0 := by rw [← hs]; exact mul_ne_zero hs0 hs0
  set C := Matrix.fromBlocks A B Bᵀ E with hC
  set Q := s⁻¹ • C with hQdef
  set D := cutInvolution n m R with hDdef
  have hQ : Q * Q = 1 := by
    rw [hQdef, Matrix.smul_mul, Matrix.mul_smul, smul_smul, hC, hCC, smul_smul,
      show s⁻¹ * s⁻¹ * q = 1 by rw [← mul_inv, hs, inv_mul_cancel₀ hq], one_smul]
  have hQt : Qᵀ = Q := by
    rw [hQdef, Matrix.transpose_smul, hC, Matrix.fromBlocks_transpose, hAt, hEt,
      Matrix.transpose_transpose]
  have hDt : Dᵀ = D := by
    rw [hDdef, cutInvolution, Matrix.fromBlocks_transpose]
    simp
  have htr : Matrix.trace ((q⁻¹ • (Bᵀ * B)) ^ (k + 1))
      = Matrix.trace ((q⁻¹ • (B * Bᵀ)) ^ (k + 1)) := by
    rw [← Matrix.mul_smul, ← Matrix.smul_mul]
    exact trace_pow_mul_comm Bᵀ (q⁻¹ • B) k
  rw [trace_exchangeCompression_pow hQ hDt hQt hU hUU k, exchangeOperator_cut hs hs0,
    fromBlocks_pow, trace_fromBlocks', htr, ← two_mul, ← mul_assoc,
    inv_mul_cancel₀ (two_ne_zero), one_mul, cutBlock_eq hq hCC]

/-- The first exchange moment of a balanced cut of a symmetric conference
matrix: the trace of the exchange operator is `d² / q`, where `d` is the size of
the half and `q = 2d - 1`.  It does not depend on the half. -/
theorem trace_exchangeCompression_cut {A : Matrix n n R} {B : Matrix n m R}
    {E : Matrix m m R} {q s : R} {U : Matrix (n ⊕ m) n R}
    (hAt : Aᵀ = A) (hEt : Eᵀ = E)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0)
    (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E))
    (hdiag : ∀ i, A i i = 0) (hone : ∀ i j, i ≠ j → A i j * A j i = 1)
    (hqval : q = 2 * (Fintype.card n : R) - 1) :
    Matrix.trace
        (exchangeCompression (cutInvolution n m R) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E) U)
      = (Fintype.card n : R) ^ 2 / q := by
  subst hqval
  have hqne : 2 * (Fintype.card n : R) - 1 ≠ 0 := by
    rw [← hs]; exact mul_ne_zero hs0 hs0
  have h := trace_exchangeCompression_pow_cut hAt hEt hCC hs hs0 hU hUU 0
  rw [pow_one, pow_one] at h
  have hinv : (2 * (Fintype.card n : R) - 1)⁻¹ * (2 * (Fintype.card n : R) - 1) = 1 :=
    inv_mul_cancel₀ hqne
  rw [h, Matrix.trace_sub, Matrix.trace_one, Matrix.trace_smul,
    ConferenceCutBlocks.trace_mul_self A hdiag hone, smul_eq_mul, eq_div_iff hqne]
  linear_combination (-((Fintype.card n : R) * ((Fintype.card n : R) - 1))) * hinv

end Cut

end RelativeConicArcs.BalancedExchangeSpectrum
