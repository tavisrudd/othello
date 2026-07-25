import Mathlib.LinearAlgebra.Matrix.Kronecker
import RelativeConicArcs.AMELU.UnitaryConjugation

/-!
# Partial trace covariance under product unitaries

This module proves the finite-dimensional matrix identity used to pass a
global product-unitary equivalence to reduced operators.  The proof
expands an arbitrary bipartite matrix into matrix units tensored with
its environment blocks.  Unitary conjugation on the environment
disappears under the block trace.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped Kronecker ComplexConjugate
open Finset Matrix

variable {α β : Type*} [Fintype α] [DecidableEq α]
  [Fintype β] [DecidableEq β]

/-- The `(a,b)` matrix unit. -/
def coordinateMatrix (a b : α) : Matrix α α ℂ :=
  fun i j => if i = a ∧ j = b then 1 else 0

/-- The environment block of a bipartite matrix. -/
def matrixBlock (M : Matrix (α × β) (α × β) ℂ)
    (a b : α) : Matrix β β ℂ :=
  fun i j => M (a, i) (b, j)

/-- Partial trace over the second tensor factor. -/
def partialTraceSecond (M : Matrix (α × β) (α × β) ℂ) :
    Matrix α α ℂ :=
  fun a b => Matrix.trace (matrixBlock M a b)

omit [Fintype β] [DecidableEq β] in
/-- A bipartite matrix is the sum of its matrix-unit block
decomposition. -/
theorem sum_coordinateMatrix_kronecker_block
    (M : Matrix (α × β) (α × β) ℂ) :
    (∑ a, ∑ b, coordinateMatrix a b ⊗ₖ matrixBlock M a b) = M := by
  classical
  ext ⟨i, r⟩ ⟨j, s⟩
  simp only [Matrix.sum_apply, Matrix.kronecker_apply,
    coordinateMatrix, matrixBlock]
  rw [Fintype.sum_eq_single i]
  · rw [Fintype.sum_eq_single j]
    · simp
    · intro b hbj
      simp [Ne.symm hbj]
  · intro a hai
    simp [Ne.symm hai]

omit [Fintype α] [DecidableEq α] [DecidableEq β] in
/-- Partial trace of a Kronecker product. -/
theorem partialTraceSecond_kronecker
    (A : Matrix α α ℂ) (B : Matrix β β ℂ) :
    partialTraceSecond (A ⊗ₖ B) = Matrix.trace B • A := by
  ext a b
  simp [partialTraceSecond, matrixBlock, Matrix.trace,
    Matrix.diag, mul_comm]
  rw [Finset.mul_sum]

omit [Fintype α] [DecidableEq α] [DecidableEq β] in
/-- Partial trace is additive. -/
theorem partialTraceSecond_sum
    {ι : Type*} [Fintype ι]
    (M : ι → Matrix (α × β) (α × β) ℂ) :
    partialTraceSecond (∑ i, M i) =
      ∑ i, partialTraceSecond (M i) := by
  ext a b
  have hleft (x : β) :
      (∑ i : ι, M i) (a, x) (b, x) =
        ∑ i : ι, M i (a, x) (b, x) := by
    simpa using Matrix.sum_apply (a, x) (b, x) Finset.univ M
  have hright :
      (∑ i : ι, partialTraceSecond (M i)) a b =
        ∑ i : ι, partialTraceSecond (M i) a b := by
    simpa using Matrix.sum_apply a b Finset.univ
      (fun i => partialTraceSecond (M i))
  rw [show partialTraceSecond (∑ i, M i) a b =
      ∑ x : β, (∑ i, M i) (a, x) (b, x) by rfl,
    hright]
  simp_rw [hleft]
  simp_rw [show ∀ i : ι,
      partialTraceSecond (M i) a b =
        ∑ x : β, M i (a, x) (b, x) by
          intro i
          rfl]
  rw [Finset.sum_comm]

/-- Conjugation preserves trace. -/
theorem trace_unitary_conjugation
    (B M : Matrix β β ℂ) (hB : Bᴴ * B = 1) :
    Matrix.trace (B * M * Bᴴ) = Matrix.trace M := by
  calc
    Matrix.trace (B * M * Bᴴ) =
        Matrix.trace (M * Bᴴ * B) := by
      rw [show B * M * Bᴴ = B * (M * Bᴴ) by noncomm_ring,
        Matrix.trace_mul_comm]
    _ = Matrix.trace M := by
      rw [show M * Bᴴ * B = M * (Bᴴ * B) by noncomm_ring, hB]
      simp

/-- Partial trace is covariant under the retained unitary and invariant
under the traced-out unitary. -/
theorem partialTraceSecond_product_conjugation
    (A : Matrix α α ℂ) (B : Matrix β β ℂ)
    (M : Matrix (α × β) (α × β) ℂ)
    (hB : Bᴴ * B = 1) :
    partialTraceSecond
        ((A ⊗ₖ B) * M * (A ⊗ₖ B)ᴴ) =
      A * partialTraceSecond M * Aᴴ := by
  classical
  rw [← sum_coordinateMatrix_kronecker_block M]
  simp only [Matrix.mul_sum, Matrix.sum_mul,
    Matrix.conjTranspose_kronecker]
  rw [partialTraceSecond_sum]
  simp_rw [partialTraceSecond_sum]
  rw [Matrix.mul_sum, Matrix.sum_mul]
  apply Finset.sum_congr rfl
  intro a _
  rw [Matrix.mul_sum, Matrix.sum_mul]
  apply Finset.sum_congr rfl
  intro b _
  rw [← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul]
  rw [partialTraceSecond_kronecker,
    trace_unitary_conjugation B (matrixBlock M a b) hB,
    partialTraceSecond_kronecker]
  ext i j
  simp only [Matrix.smul_apply, Matrix.mul_apply,
    Matrix.conjTranspose_apply, coordinateMatrix, smul_eq_mul]
  let s : ℂ := Matrix.trace (matrixBlock M a b)
  have hbase :
      (∑ x, (∑ y, A i y * if y = a ∧ x = b then 1 else 0) *
        conj (A j x)) =
        A i a * conj (A j b) := by
    rw [Fintype.sum_eq_single b]
    · rw [Fintype.sum_eq_single a]
      · simp
      · intro y hya
        rw [if_neg]
        · simp
        · intro h
          exact hya h.1
    · intro x hxb
      have hsum :
          (∑ y, A i y * if y = a ∧ x = b then 1 else 0) = 0 := by
        apply Finset.sum_eq_zero
        intro y _
        rw [if_neg]
        · simp
        · intro h
          exact hxb h.2
      rw [hsum]
      simp
  have hscaled :
      (∑ x, (∑ y,
        A i y * (s * if y = a ∧ x = b then 1 else 0)) *
          conj (A j x)) =
        s * A i a * conj (A j b) := by
    rw [Fintype.sum_eq_single b]
    · rw [Fintype.sum_eq_single a]
      · rw [if_pos ⟨rfl, rfl⟩]
        ring
      · intro y hya
        rw [if_neg]
        · simp
        · intro h
          exact hya h.1
    · intro x hxb
      have hsum :
          (∑ y,
            A i y * (s * if y = a ∧ x = b then 1 else 0)) = 0 := by
        apply Finset.sum_eq_zero
        intro y _
        rw [if_neg]
        · simp
        · intro h
          exact hxb h.2
      rw [hsum]
      simp
  change
    s * (∑ x, (∑ y,
      A i y * if y = a ∧ x = b then 1 else 0) * conj (A j x)) =
      ∑ x, (∑ y,
        A i y * (s * if y = a ∧ x = b then 1 else 0)) *
          conj (A j x)
  rw [hbase, hscaled]
  ring

end RelativeConicArcs.AMELU
