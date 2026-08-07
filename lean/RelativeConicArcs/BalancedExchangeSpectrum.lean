import Mathlib.Data.Matrix.ColumnRowPartitioned
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
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

end RelativeConicArcs.BalancedExchangeSpectrum
