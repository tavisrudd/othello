import ProjectiveCap.HyperbolicQuadricMirror
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv

/-!
# Formal boundary reductions for projective mirror arguments

This file proves the linear-algebra reductions that do not depend on the classification of finite
quadratic or Hermitian forms. It deliberately does **not** assert the paper-only parabolic,
Hermitian, or elliptic-quadric exclusions. Those require explicit isotropy and semilinear
classification inputs, recorded in the accompanying trust note.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- A sub-board contains a fixed point of a projective symmetry. -/
def HasFixedPointOn (Q : Point K V → Prop) (σ : Point K V ≃ Point K V) : Prop :=
  ∃ x, Q x ∧ σ x = x

/-- A projective symmetry is fixed-point-free on a sub-board. -/
def FixedPointFreeOn (Q : Point K V → Prop) (σ : Point K V ≃ Point K V) : Prop :=
  ∀ x, Q x → σ x ≠ x

theorem not_fixedPointFreeOn_of_hasFixedPointOn {Q : Point K V → Prop}
    {σ : Point K V ≃ Point K V} (h : HasFixedPointOn Q σ) : ¬ FixedPointFreeOn Q σ := by
  rintro hfpf
  obtain ⟨x, hxQ, hx⟩ := h
  exact hfpf x hxQ hx

/-- An isotropic eigenvector is exactly the local obstruction needed to refute a mirror on a
quadric/Hermitian sub-board. The hard family-specific task is to produce such an eigenvector. -/
theorem hasFixedPointOn_of_eigenvector (g : V ≃ₗ[K] V) (Q : Point K V → Prop)
    {v : V} (hv : v ≠ 0) {a : K} (hgv : g v = a • v)
    (hQ : Q (Projectivization.mk K v hv)) :
    HasFixedPointOn Q (mapEquiv g) := by
  exact ⟨Projectivization.mk K v hv, hQ, mapEquiv_fixed_of_eq_smul g hv hgv⟩

/-- A mirror that is fixed-point-free on a quadratic/Hermitian board has no eigenline on that
board. Equivalently, each eigenspace is anisotropic for the board predicate. -/
theorem no_board_eigenvector_of_fixedPointFreeOn (g : V ≃ₗ[K] V)
    (Q : Point K V → Prop) (hfpf : FixedPointFreeOn Q (mapEquiv g))
    {v : V} (hv : v ≠ 0) {a : K} (hgv : g v = a • v) :
    ¬ Q (Projectivization.mk K v hv) := by
  intro hQ
  exact hfpf _ hQ (mapEquiv_fixed_of_eq_smul g hv hgv)

/-- Determinant parity obstruction. If an invertible `(2m+1)×(2m+1)` matrix squares to
`δ I`, then `δ` is a square. Thus a nonsplit square-scalar projective involution cannot act on an
odd-dimensional vector space. -/
theorem isSquare_scalar_of_matrix_sq_odd {m : ℕ}
    (A : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) (δ : K)
    (hδ : δ ≠ 0) (hA : A * A = δ • (1 : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K)) :
    IsSquare δ := by
  have hdet : A.det * A.det = δ ^ (2 * m + 1) := by
    calc
      A.det * A.det = (A * A).det := (Matrix.det_mul A A).symm
      _ = (δ • (1 : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K)).det := by rw [hA]
      _ = δ ^ (2 * m + 1) := by simp
  have hpow : δ ^ (2 * m + 1) = δ * (δ ^ m) ^ 2 := by ring
  refine ⟨A.det / δ ^ m, ?_⟩
  field_simp
  rw [hpow] at hdet
  simpa [pow_two] using hdet.symm

theorem no_matrix_sq_nonsquare_in_odd_dimension {m : ℕ}
    (A : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) (δ : K)
    (hδ : δ ≠ 0) (hnonsquare : ¬ IsSquare δ) :
    A * A ≠ δ • (1 : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) := by
  intro hA
  exact hnonsquare (isSquare_scalar_of_matrix_sq_odd A δ hδ hA)

/-- Formalized nonsplit half of the parabolic obstruction: the vector space underlying
`Q(2m,q)` has odd dimension `2m+1`, so it cannot carry a linear projective involution represented
by `A² = δ I` with `δ` nonsquare. The remaining split and semilinear exclusions require isotropy
and Baer-fixed-subgeometry theorems not currently present in mathlib. -/
theorem parabolic_nonsplit_linear_route_impossible {m : ℕ}
    (A : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) (δ : K)
    (hδ : δ ≠ 0) (hnonsquare : ¬ IsSquare δ) :
    A * A ≠ δ • (1 : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) :=
  no_matrix_sq_nonsquare_in_odd_dimension A δ hδ hnonsquare

end Projective
end ProjectiveCap
