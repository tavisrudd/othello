import Mathlib.Data.Matrix.ColumnRowPartitioned
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.Module
import Mathlib.Tactic.NoncommRing
import RelativeConicArcs.ConferenceCutBlocks
import RelativeConicArcs.BalancedExchangeRigidity

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

Two consequences are drawn from the power traces.  The second exchange moment
is expressed through the number of aligned four-sets of the chosen half, the
four-subsets whose three signed Hamilton-cycle products sum to `3` rather than
to `-1`; that count is the only part of the moment that depends on the half, and
it is not constant once each half has at least four labels.  At the orders in
which each half has at most three labels the characteristic polynomial is
computed outright and does not depend on the half: for a three-label half the
principal block satisfies `A * A = 2 • 1 + τ • A` with `τ` the product of its
three edge signs, and `τ` cancels from the characteristic polynomial of
`1 - A²/5`, which is `(X - 1/5)(X - 4/5)²`.  The same fourth-trace count that
makes the aligned count nonconstant also excludes a half of two labels: no
symmetric sign matrix with zero diagonal on four labels squares to a scalar
matrix, so order six is the only order above two at which a cut-independent
exchange spectrum occurs.

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

section AlignedFourSets

open Finset

variable {R : Type*} [CommRing R] [DecidableEq R] {n : Type*} [DecidableEq n]

/-- The number of aligned four-subsets of a set `Y` of labels: those
four-element subsets whose three signed Hamilton-cycle products sum to `3`,
equivalently whose closed four-walk weight is `24`.  For a symmetric matrix
with zero diagonal whose off-diagonal entries square to one those are the only
two possible weights, the other being `-8`. -/
def alignedFourSetCount (A : Matrix n n R) (Y : Finset n) : ℕ :=
  ((Y.powersetCard 4).filter fun K => ConferenceCutBlocks.closedFourWalkSum A K = 24).card

/-- The sum of the closed four-walk weights over the four-subsets of `Y`, sorted
by the four-set dichotomy: each aligned four-subset contributes `24` and each of
the remaining four-subsets contributes `-8`, so the sum is
`32 c - 8 C(|Y|, 4)` for `c` the number of aligned four-subsets. -/
theorem sum_closedFourWalkSum_eq_alignedFourSetCount [NoZeroDivisors R] (A : Matrix n n R)
    (hsym : ∀ i j, A j i = A i j) (hsq : ∀ i j, i ≠ j → A i j * A i j = 1) (Y : Finset n) :
    ∑ K ∈ Y.powersetCard 4, ConferenceCutBlocks.closedFourWalkSum A K
      = 32 * (alignedFourSetCount A Y : R) - 8 * (Y.card.choose 4 : R) := by
  have hsplit :
      (∑ K ∈ (Y.powersetCard 4).filter
          (fun K => ConferenceCutBlocks.closedFourWalkSum A K = 24),
            ConferenceCutBlocks.closedFourWalkSum A K)
        + ∑ K ∈ (Y.powersetCard 4).filter
            (fun K => ¬ ConferenceCutBlocks.closedFourWalkSum A K = 24),
              ConferenceCutBlocks.closedFourWalkSum A K
        = ∑ K ∈ Y.powersetCard 4, ConferenceCutBlocks.closedFourWalkSum A K :=
    Finset.sum_filter_add_sum_filter_not _ _ _
  have hcards : ((Y.powersetCard 4).filter
        (fun K => ConferenceCutBlocks.closedFourWalkSum A K = 24)).card
      + ((Y.powersetCard 4).filter
        (fun K => ¬ ConferenceCutBlocks.closedFourWalkSum A K = 24)).card
      = Y.card.choose 4 := by
    rw [Finset.card_filter_add_card_filter_not, Finset.card_powersetCard]
  have haligned : ∀ K ∈ (Y.powersetCard 4).filter
      (fun K => ConferenceCutBlocks.closedFourWalkSum A K = 24),
        ConferenceCutBlocks.closedFourWalkSum A K = (24 : R) :=
    fun K hK => (Finset.mem_filter.mp hK).2
  have hother : ∀ K ∈ (Y.powersetCard 4).filter
      (fun K => ¬ ConferenceCutBlocks.closedFourWalkSum A K = 24),
        ConferenceCutBlocks.closedFourWalkSum A K = (-8 : R) := by
    intro K hK
    obtain ⟨hKmem, hKne⟩ := Finset.mem_filter.mp hK
    have hKcard : K.card = 4 := (Finset.mem_powersetCard.mp hKmem).2
    have hdich :=
      ConferenceCutBlocks.closedFourWalkSum_eq_twentyFour_or_neg_eight A hsym hsq hKcard
    rcases mul_eq_zero.mp hdich with h | h
    · exact absurd (by linear_combination h) hKne
    · linear_combination h
  have hcast : (((Y.powersetCard 4).filter
        (fun K => ConferenceCutBlocks.closedFourWalkSum A K = 24)).card : R)
      + (((Y.powersetCard 4).filter
        (fun K => ¬ ConferenceCutBlocks.closedFourWalkSum A K = 24)).card : R)
      = (Y.card.choose 4 : R) := by
    exact_mod_cast congrArg (fun k : ℕ => (k : R)) hcards
  rw [← hsplit, Finset.sum_congr rfl haligned, Finset.sum_congr rfl hother,
    Finset.sum_const, Finset.sum_const, nsmul_eq_mul, nsmul_eq_mul]
  show (((Y.powersetCard 4).filter
      (fun K => ConferenceCutBlocks.closedFourWalkSum A K = 24)).card : R) * 24
    + (((Y.powersetCard 4).filter
      (fun K => ¬ ConferenceCutBlocks.closedFourWalkSum A K = 24)).card : R) * (-8)
    = 32 * (alignedFourSetCount A Y : R) - 8 * (Y.card.choose 4 : R)
  rw [show (alignedFourSetCount A Y : R)
      = (((Y.powersetCard 4).filter
        (fun K => ConferenceCutBlocks.closedFourWalkSum A K = 24)).card : R) from rfl]
  linear_combination (-8 : R) * hcast

end AlignedFourSets

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

/-- The second exchange moment of a balanced cut of a symmetric conference
matrix, in terms of the aligned four-sets of the chosen half.  With `d` the size
of the half, `q` the scalar the matrix squares to, and `c` the number of
four-subsets of the half whose three signed Hamilton-cycle products sum to `3`,

`tr(H²) = (d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c) / q²`.

Every summand except the last is determined by the order, so the aligned count
carries the whole dependence of the second moment on the half. -/
theorem trace_pow_two_exchangeCompression_cut [DecidableEq R] {A : Matrix n n R}
    {B : Matrix n m R} {E : Matrix m m R} {q s : R} {U : Matrix (n ⊕ m) n R}
    (hAt : Aᵀ = A) (hEt : Eᵀ = E)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0)
    (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E))
    (hdiag : ∀ i, A i i = 0) (hsym : ∀ i j, A j i = A i j)
    (hsq : ∀ i j, i ≠ j → A i j * A i j = 1) :
    Matrix.trace
        (exchangeCompression (cutInvolution n m R) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E) U ^ 2)
      = ((Fintype.card n : R) * q ^ 2
          - 2 * q * ((Fintype.card n : R) * ((Fintype.card n : R) - 1))
          + ((Fintype.card n : R) * ((Fintype.card n : R) - 1)
            + 12 * ((Fintype.card n).choose 3 : R)
            - 8 * ((Fintype.card n).choose 4 : R)
            + 32 * (alignedFourSetCount A Finset.univ : R))) / q ^ 2 := by
  have hq : q ≠ 0 := by rw [← hs]; exact mul_ne_zero hs0 hs0
  have hone : ∀ i j : n, i ≠ j → A i j * A j i = 1 := by
    intro i j hij
    rw [hsym i j]
    exact hsq i j hij
  have h := trace_exchangeCompression_pow_cut hAt hEt hCC hs hs0 hU hUU 1
  norm_num at h
  have hmul : (q⁻¹ • (A * A)) * (q⁻¹ • (A * A)) = (q⁻¹ * q⁻¹) • (A * A * A * A) := by
    rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul, ← Matrix.mul_assoc]
  have hexp : ((1 : Matrix n n R) - q⁻¹ • (A * A)) ^ 2
      = 1 - (q⁻¹ • (A * A) + q⁻¹ • (A * A)) + (q⁻¹ * q⁻¹) • (A * A * A * A) := by
    simp only [sq, sub_mul, mul_sub, one_mul, mul_one]
    rw [hmul]
    abel
  rw [h, hexp]
  simp only [Matrix.trace_add, Matrix.trace_sub, Matrix.trace_one, Matrix.trace_smul,
    smul_eq_mul]
  rw [ConferenceCutBlocks.trace_mul_self A hdiag hone,
    ConferenceCutBlocks.trace_pow_four A hdiag hone,
    sum_closedFourWalkSum_eq_alignedFourSetCount A hsym hsq Finset.univ, Finset.card_univ,
    eq_div_iff (pow_ne_zero 2 hq)]
  field_simp
  ring

end Cut

section SmallOrders

variable {R : Type*} [Field R] [CharZero R] {n : Type*} [Fintype n] [DecidableEq n]

omit [CharZero R] in
/-- The characteristic polynomial of a scalar matrix. -/
private theorem charpoly_smul_one (c : R) :
    ((c • (1 : Matrix n n R))).charpoly = (X - C c) ^ Fintype.card n := by
  rw [Matrix.smul_one_eq_diagonal, Matrix.charpoly_diagonal, Finset.prod_const,
    Finset.card_univ]

omit [CharZero R] [DecidableEq n] in
/-- A matrix with zero diagonal on a one-element label set is zero. -/
theorem eq_zero_of_card_one (A : Matrix n n R) (hdiag : ∀ i, A i i = 0)
    (hcard : Fintype.card n = 1) : A = 0 := by
  have hsub : Subsingleton n := Fintype.card_le_one_iff_subsingleton.mp (le_of_eq hcard)
  ext i j
  rw [Subsingleton.elim j i, hdiag i, Matrix.zero_apply]

omit [CharZero R] in
/-- Transport of the exchange normalization along a labelling of the index set:
the characteristic polynomial does not see the labelling. -/
private theorem charpoly_one_sub_smul_mul_self_submatrix {k : ℕ} (A : Matrix n n R) (v : R)
    (e : n ≃ Fin k) :
    ((1 : Matrix (Fin k) (Fin k) R)
        - v • (A.submatrix e.symm e.symm * A.submatrix e.symm e.symm)).charpoly
      = ((1 : Matrix n n R) - v • (A * A)).charpoly := by
  have hreindex := Matrix.charpoly_reindex e ((1 : Matrix n n R) - v • (A * A))
  rw [Matrix.reindex_apply] at hreindex
  rw [Matrix.submatrix_mul_equiv A A e.symm e.symm e.symm, ← hreindex]
  congr 1
  ext i j
  simp [Matrix.submatrix_apply, Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply,
    e.symm.injective.eq_iff]

omit [CharZero R] in
/-- A symmetric matrix with zero diagonal whose off-diagonal entries square to
one is an involution on two labels. -/
private theorem mul_self_fin_two (A : Matrix (Fin 2) (Fin 2) R) (hdiag : ∀ i, A i i = 0)
    (hsym : ∀ i j, A j i = A i j) (hsq : ∀ i j, i ≠ j → A i j * A i j = 1) :
    A * A = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, hdiag, hsym 0 1] <;>
    exact hsq 0 1 (by decide)

omit [CharZero R] in
/-- On three labels a symmetric sign matrix with zero diagonal satisfies
`A * A = 2 • 1 + τ • A`, where `τ` is the product of its three edge signs: the
`(i, j)` entry of `A * A` is the product of the two edges of the triangle other
than `ij`, which is `τ` times the entry `A i j`. -/
private theorem mul_self_fin_three (A : Matrix (Fin 3) (Fin 3) R) (hdiag : ∀ i, A i i = 0)
    (hsym : ∀ i j, A j i = A i j) (hsq : ∀ i j, i ≠ j → A i j * A i j = 1) :
    A * A = (2 : R) • 1 + (A 0 1 * A 0 2 * A 1 2) • A := by
  have s01 := hsq 0 1 (by decide)
  have s02 := hsq 0 2 (by decide)
  have s12 := hsq 1 2 (by decide)
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_three, hdiag, hsym 0 1, hsym 0 2, hsym 1 2]
  · linear_combination s01 + s02
  · linear_combination (-(A 0 2 * A 1 2)) * s01
  · linear_combination (-(A 0 1 * A 1 2)) * s02
  · linear_combination (-(A 0 2 * A 1 2)) * s01
  · linear_combination s01 + s12
  · linear_combination (-(A 0 1 * A 0 2)) * s12
  · linear_combination (-(A 0 1 * A 1 2)) * s02
  · linear_combination (-(A 0 1 * A 0 2)) * s12
  · linear_combination s02 + s12

omit [CharZero R] in
/-- The characteristic polynomial of `3v • 1 - v • N` for a three-label
symmetric sign matrix `N` with zero diagonal whose three edge signs multiply to
one: it is `(X - v)(X - 4v)²`, with no dependence on the individual signs.  The
three off-diagonal squares contribute `-3 v² (X - 3v)` and the two triangle
products contribute `2 v³`, so the cubic is `u³ - 3v²u + 2v³ = (u - v)²(u + 2v)`
in `u = X - 3v`. -/
private theorem charpoly_scaled_sign_fin_three (v : R) (N : Matrix (Fin 3) (Fin 3) R)
    (hdiag : ∀ i, N i i = 0) (hsym : ∀ i j, N j i = N i j)
    (hsq : ∀ i j, i ≠ j → N i j * N i j = 1) (hprod : N 0 1 * N 0 2 * N 1 2 = 1) :
    (((3 : R) * v) • (1 : Matrix (Fin 3) (Fin 3) R) - v • N).charpoly
      = (X - C v) * (X - C (4 * v)) ^ 2 := by
  have hd : ∀ i, (((3 : R) * v) • (1 : Matrix (Fin 3) (Fin 3) R) - v • N) i i = 3 * v := by
    intro i
    simp [Matrix.sub_apply, Matrix.smul_apply, hdiag i]
  have ho : ∀ i j, i ≠ j →
      (((3 : R) * v) • (1 : Matrix (Fin 3) (Fin 3) R) - v • N) i j = -(v * N i j) := by
    intro i j hij
    simp [Matrix.sub_apply, Matrix.smul_apply, hij]
  have hs01 : (C (N 0 1) : R[X]) * C (N 0 1) = 1 := by
    rw [← map_mul, hsq 0 1 (by decide), map_one]
  have hs02 : (C (N 0 2) : R[X]) * C (N 0 2) = 1 := by
    rw [← map_mul, hsq 0 2 (by decide), map_one]
  have hs12 : (C (N 1 2) : R[X]) * C (N 1 2) = 1 := by
    rw [← map_mul, hsq 1 2 (by decide), map_one]
  have hpr : (C (N 0 1) : R[X]) * C (N 0 2) * C (N 1 2) = 1 := by
    rw [← map_mul, ← map_mul, hprod, map_one]
  have hcd : ∀ i : Fin 3,
      (((3 : R) * v) • (1 : Matrix (Fin 3) (Fin 3) R) - v • N).charmatrix i i
        = X - C (3 * v) := by
    intro i
    rw [Matrix.charmatrix_apply_eq, hd i]
  have hco : ∀ i j : Fin 3, i ≠ j →
      (((3 : R) * v) • (1 : Matrix (Fin 3) (Fin 3) R) - v • N).charmatrix i j
        = C (v * N i j) := by
    intro i j hij
    rw [Matrix.charmatrix_apply, Matrix.diagonal_apply_ne _ hij, ho i j hij, map_neg]
    ring
  rw [Matrix.charpoly, Matrix.det_fin_three, hcd 0, hcd 1, hcd 2, hco 0 1 (by decide),
    hco 0 2 (by decide),
    hco 1 0 (by decide), hco 1 2 (by decide), hco 2 0 (by decide), hco 2 1 (by decide),
    hsym 0 1, hsym 0 2, hsym 1 2]
  simp only [map_mul, map_ofNat]
  linear_combination (-(X - 3 * C v) * C v ^ 2) * hs01 + (-(X - 3 * C v) * C v ^ 2) * hs02
    + (-(X - 3 * C v) * C v ^ 2) * hs12 + (2 * C v ^ 3) * hpr

omit [CharZero R] in
/-- The exchange normalization of a three-label principal block: for `5 v = 1`
the characteristic polynomial of `1 - v • (A * A)` is `(X - v)(X - 4v)²`.  The
product `τ` of the three edge signs enters `A * A = 2 • 1 + τ • A` but cancels
from the characteristic polynomial, so the polynomial is the same for every such
block. -/
theorem charpoly_one_sub_smul_mul_self_fin_three (A : Matrix (Fin 3) (Fin 3) R)
    (hdiag : ∀ i, A i i = 0) (hsym : ∀ i j, A j i = A i j)
    (hsq : ∀ i j, i ≠ j → A i j * A i j = 1) {v : R} (hv : 5 * v = 1) :
    ((1 : Matrix (Fin 3) (Fin 3) R) - v • (A * A)).charpoly
      = (X - C v) * (X - C (4 * v)) ^ 2 := by
  have s01 := hsq 0 1 (by decide)
  have s02 := hsq 0 2 (by decide)
  have s12 := hsq 1 2 (by decide)
  have hdiagN : ∀ i, ((A 0 1 * A 0 2 * A 1 2) • A) i i = 0 := by
    intro i
    simp [Matrix.smul_apply, hdiag i]
  have hsymN : ∀ i j, ((A 0 1 * A 0 2 * A 1 2) • A) j i = ((A 0 1 * A 0 2 * A 1 2) • A) i j := by
    intro i j
    simp [Matrix.smul_apply, hsym i j]
  have hsqN : ∀ i j, i ≠ j →
      ((A 0 1 * A 0 2 * A 1 2) • A) i j * ((A 0 1 * A 0 2 * A 1 2) • A) i j = 1 := by
    intro i j hij
    have hij' := hsq i j hij
    simp only [Matrix.smul_apply, smul_eq_mul]
    linear_combination (A 0 1 ^ 2 * A 0 2 ^ 2 * A 1 2 ^ 2) * hij'
      + (A 0 2 ^ 2 * A 1 2 ^ 2) * s01 + (A 1 2 ^ 2) * s02 + s12
  have hprodN : ((A 0 1 * A 0 2 * A 1 2) • A) 0 1 * ((A 0 1 * A 0 2 * A 1 2) • A) 0 2
      * ((A 0 1 * A 0 2 * A 1 2) • A) 1 2 = 1 := by
    simp only [Matrix.smul_apply, smul_eq_mul]
    linear_combination ((A 0 1 ^ 2 + 1) * A 0 2 ^ 4 * A 1 2 ^ 4) * s01
      + ((A 0 2 ^ 2 + 1) * A 1 2 ^ 4) * s02 + (A 1 2 ^ 2 + 1) * s12
  have hM : (1 : Matrix (Fin 3) (Fin 3) R) - v • (A * A)
      = ((3 : R) * v) • 1 - v • ((A 0 1 * A 0 2 * A 1 2) • A) := by
    rw [mul_self_fin_three A hdiag hsym hsq]
    match_scalars
    · linear_combination -hv
    · ring
  rw [hM]
  exact charpoly_scaled_sign_fin_three v _ hdiagN hsymN hsqN hprodN

omit [CharZero R] in
/-- The exchange normalization of a principal block on any three-element label
set: its characteristic polynomial is `(X - v)(X - 4v)²` for `5 v = 1`, so at
order six the exchange spectrum does not depend on the half. -/
theorem charpoly_one_sub_smul_mul_self_of_card_three (A : Matrix n n R)
    (hdiag : ∀ i, A i i = 0) (hsym : ∀ i j, A j i = A i j)
    (hsq : ∀ i j, i ≠ j → A i j * A i j = 1) {v : R} (hv : 5 * v = 1)
    (hcard : Fintype.card n = 3) :
    ((1 : Matrix n n R) - v • (A * A)).charpoly = (X - C v) * (X - C (4 * v)) ^ 2 := by
  let e : n ≃ Fin 3 := Fintype.equivFinOfCardEq hcard
  rw [← charpoly_one_sub_smul_mul_self_submatrix A v e]
  exact charpoly_one_sub_smul_mul_self_fin_three (A.submatrix e.symm e.symm)
    (fun i => hdiag _) (fun i j => hsym _ _)
    (fun i j hij => hsq _ _ fun h => hij (e.symm.injective h)) hv

omit [CharZero R] in
/-- The exchange normalization of a principal block on a two-element label set:
the block is an involution, so the polynomial is `(X - 2v)²` for `3 v = 1`. -/
theorem charpoly_one_sub_smul_mul_self_of_card_two (A : Matrix n n R)
    (hdiag : ∀ i, A i i = 0) (hsym : ∀ i j, A j i = A i j)
    (hsq : ∀ i j, i ≠ j → A i j * A i j = 1) {v : R} (hv : 3 * v = 1)
    (hcard : Fintype.card n = 2) :
    ((1 : Matrix n n R) - v • (A * A)).charpoly = (X - C (2 * v)) ^ 2 := by
  let e : n ≃ Fin 2 := Fintype.equivFinOfCardEq hcard
  rw [← charpoly_one_sub_smul_mul_self_submatrix A v e,
    mul_self_fin_two (A.submatrix e.symm e.symm) (fun i => hdiag _) (fun i j => hsym _ _)
      (fun i j hij => hsq _ _ fun h => hij (e.symm.injective h))]
  have hscalar : (1 : Matrix (Fin 2) (Fin 2) R) - v • 1 = ((2 : R) * v) • 1 := by
    match_scalars
    linear_combination -hv
  rw [hscalar, charpoly_smul_one, Fintype.card_fin]

omit [CharZero R] in
/-- The exchange normalization of a principal block on a one-element label set:
the block vanishes, so the polynomial is `X - 1`. -/
theorem charpoly_one_sub_smul_mul_self_of_card_one (A : Matrix n n R)
    (hdiag : ∀ i, A i i = 0) (v : R) (hcard : Fintype.card n = 1) :
    ((1 : Matrix n n R) - v • (A * A)).charpoly = X - 1 := by
  rw [eq_zero_of_card_one A hdiag hcard, Matrix.mul_zero, smul_zero, sub_zero,
    Matrix.charpoly_one, hcard, pow_one]

/-- No symmetric matrix with zero diagonal whose off-diagonal entries square to
one has a scalar square on four labels.  Such a matrix would satisfy
`q = 3` by the trace of its square, hence have fourth trace `36`; the
support-sorted fourth trace makes that `4·3 + 12·C(4,3)` plus the closed
four-walk weight of its only four-set, forcing that weight to be `-24`, while
every four-set of such a matrix carries weight `24` or `-8`.  Together with the
constancy of the exchange spectrum for a half of at most three labels, this
leaves order six as the only order above two at which a cut-independent
exchange spectrum is realized. -/
theorem ne_smul_one_of_card_four (A : Matrix n n R) (hdiag : ∀ i, A i i = 0)
    (hsym : ∀ i j, A j i = A i j) (hsq : ∀ i j, i ≠ j → A i j * A i j = 1)
    (hcard : Fintype.card n = 4) (q : R) : A * A ≠ q • 1 := by
  intro hAA
  have hone : ∀ i j : n, i ≠ j → A i j * A j i = 1 := by
    intro i j hij
    rw [hsym i j]
    exact hsq i j hij
  have hfour : ((4 : ℕ) : R) ≠ 0 := by exact_mod_cast (by norm_num : (4 : ℕ) ≠ 0)
  have hq : q = 3 := by
    have h1 := ConferenceCutBlocks.trace_mul_self A hdiag hone
    rw [hAA, Matrix.trace_smul, Matrix.trace_one, smul_eq_mul, hcard] at h1
    have hzero : ((4 : ℕ) : R) * (q - 3) = 0 := by linear_combination h1
    rcases mul_eq_zero.mp hzero with h | h
    · exact absurd h hfour
    · linear_combination h
  have hsq4 : A * A * A * A = (q * q) • (1 : Matrix n n R) := by
    calc A * A * A * A = (A * A) * (A * A) := by rw [Matrix.mul_assoc]
      _ = (q • (1 : Matrix n n R)) * (q • (1 : Matrix n n R)) := by rw [hAA]
      _ = (q * q) • (1 : Matrix n n R) := by simp [smul_smul]
  have hpow := ConferenceCutBlocks.trace_pow_four A hdiag hone
  have hsingle :
      ∑ K ∈ (Finset.univ : Finset n).powersetCard 4, ConferenceCutBlocks.closedFourWalkSum A K
        = ConferenceCutBlocks.closedFourWalkSum A Finset.univ := by
    rw [show (4 : ℕ) = (Finset.univ : Finset n).card by rw [Finset.card_univ, hcard],
      Finset.powersetCard_self, Finset.sum_singleton]
  rw [hsq4, Matrix.trace_smul, Matrix.trace_one, smul_eq_mul, hsingle, hcard, hq] at hpow
  norm_num at hpow
  have hdich := ConferenceCutBlocks.closedFourWalkSum_eq_twentyFour_or_neg_eight A hsym hsq
    (show (Finset.univ : Finset n).card = 4 by rw [Finset.card_univ, hcard])
  rw [show ConferenceCutBlocks.closedFourWalkSum A Finset.univ = -24 by
    linear_combination -hpow] at hdich
  norm_num at hdich

end SmallOrders

section OrderSix

variable {R : Type*} [Field R] [CharZero R] {n m : Type*} [Fintype n] [DecidableEq n]
  [Fintype m] [DecidableEq m]

/-- At order six the exchange operator of a balanced cut has characteristic
polynomial `(X - 1/5)(X - 4/5)²` whatever the cut, so its spectrum is
`{1/5, 4/5, 4/5}` and does not depend on the half. -/
theorem charpoly_exchangeCompression_cut_card_three {A : Matrix n n R} {B : Matrix n m R}
    {E : Matrix m m R} {s : R} {U : Matrix (n ⊕ m) n R} {W : Matrix (n ⊕ m) m R}
    (hAt : Aᵀ = A) (hEt : Eᵀ = E)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = (5 : R) • 1)
    (hs : s * s = (5 : R)) (hs0 : s ≠ 0)
    (hU : Uᵀ * U = 1) (hUU : U * Uᵀ = fixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E))
    (hW : Wᵀ * W = 1)
    (hWW : W * Wᵀ = antifixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E))
    (hdiag : ∀ i, A i i = 0) (hsym : ∀ i j, A j i = A i j)
    (hsq : ∀ i j, i ≠ j → A i j * A i j = 1)
    (hn : Fintype.card n = 3) (hm : Fintype.card m = 3) :
    (exchangeCompression (cutInvolution n m R) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E) U).charpoly
      = (X - C ((5 : R)⁻¹)) * (X - C (4 * (5 : R)⁻¹)) ^ 2 := by
  have hfive : (5 : R) ≠ 0 := by norm_num
  rw [charpoly_exchangeCompression_cut hAt hEt hCC hs hs0 hU hUU hW hWW (by rw [hn, hm])]
  exact charpoly_one_sub_smul_mul_self_of_card_three A hdiag hsym hsq
    (mul_inv_cancel₀ hfive) hn

end OrderSix

section CutDependence

open Finset

variable {R : Type*} [CommRing R] [CharZero R] [NoZeroDivisors R] [DecidableEq R]
  {n : Type*} [Fintype n] [DecidableEq n]

/-- The number of aligned four-sets of a balanced half of a symmetric conference
matrix of order `2d` is not the same for every half, once `4 ≤ d`.  Since the
second exchange moment of the cut at a half is
`(d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c) / q²` for `c` that
count, the second moment, and with it the spectrum of the exchange operator,
depends on the half. -/
theorem not_forall_alignedFourSetCount_eq (C : Matrix n n R) (hdiag : ∀ i, C i i = 0)
    (hsym : ∀ i j, C j i = C i j) (hsq : ∀ i j, i ≠ j → C i j * C i j = 1)
    {q : R} (hCC : C * C = q • 1) {d : ℕ} (hd : 4 ≤ d) (hn : Fintype.card n = 2 * d)
    (c : ℕ) :
    ¬ ∀ Y ⊆ (univ : Finset n), Y.card = d → alignedFourSetCount C Y = c := by
  intro hconst
  have hone : ∀ i j : n, i ≠ j → C i j * C j i = 1 := by
    intro i j hij
    rw [hsym i j]
    exact hsq i j hij
  refine BalancedExchangeRigidity.not_forall_sum_walkTerm_eq C hdiag hsym hsq hCC hd hn
    ((d : R) * ((d : R) - 1) + 12 * (d.choose 3 : R)
      + (32 * (c : R) - 8 * (d.choose 4 : R))) ?_
  intro Y hY hYc
  rw [ConferenceCutBlocks.sum_walkTerm_eq_add_sum_powersetCard C hdiag hone Y,
    sum_closedFourWalkSum_eq_alignedFourSetCount C hsym hsq Y, hconst Y hY hYc, hYc]

end CutDependence

end RelativeConicArcs.BalancedExchangeSpectrum
