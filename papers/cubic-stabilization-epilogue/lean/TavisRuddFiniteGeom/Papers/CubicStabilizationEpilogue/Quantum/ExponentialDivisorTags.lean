import Mathlib.Algebra.Module.Submodule.Union
import Mathlib.LinearAlgebra.Vandermonde
import Mathlib.RingTheory.PowerSeries.Basic

/-!
# Linear independence of finite exponential divisor tags

Let `K` be a characteristic-zero field.  For `a : K`, this module represents
the formal character `exp(a t)` by the power series whose coefficient of
`t^n` is `a^n / n!`.  It proves that finitely many such characters with
pairwise distinct exponents are linearly independent.  The proof reads the
first `m` coefficients of a relation among `m` characters, clears the nonzero
factorials, and applies the Vandermonde determinant criterion.

This is the finite-character step used in divisor tagging.  It does not choose
an integral one-parameter direction separating a finite collection of divisor
pairing vectors, construct a completed Novikov ring, identify its
lowest-valuation support, or prove that an associated graded domain prevents
cancellation of initial terms.  The proof is symbolic and kernel checked; it
uses no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open scoped BigOperators

/-- The formal power series `exp(a t)`, defined coefficientwise over a
characteristic-zero field. -/
noncomputable def formalExponentialCharacter
    {K : Type*} [Field K] [CharZero K] (a : K) : PowerSeries K :=
  PowerSeries.mk fun degree ↦ a ^ degree / (Nat.factorial degree : K)

/-- The coefficient of degree `n` in the formal exponential character is
`a^n / n!`. -/
@[simp]
theorem formalExponentialCharacter_coeff
    {K : Type*} [Field K] [CharZero K] (a : K) (degree : ℕ) :
    PowerSeries.coeff degree (formalExponentialCharacter a) =
      a ^ degree / (Nat.factorial degree : K) := by
  simp [formalExponentialCharacter]

/-- A finite linear relation among formal exponential characters with
pairwise distinct exponents has every coefficient equal to zero.  The index
type `Fin m` is an enumeration of the finite support; no ordering of the
exponents is required. -/
theorem coefficients_eq_zero_of_sum_formalExponentialCharacter_eq_zero
    {K : Type*} [Field K] [CharZero K] {m : ℕ}
    (exponent coefficient : Fin m → K)
    (exponent_injective : Function.Injective exponent)
    (relation : ∑ index, coefficient index •
      formalExponentialCharacter (exponent index) = 0) :
    coefficient = 0 := by
  apply Matrix.eq_zero_of_forall_pow_sum_mul_pow_eq_zero exponent_injective
  intro degree
  have coefficient_relation :
      ∑ index, coefficient index *
          (exponent index ^ (degree : ℕ) /
            (Nat.factorial (degree : ℕ) : K)) = 0 := by
    simpa [formalExponentialCharacter] using congrArg
      (fun series : PowerSeries K ↦ PowerSeries.coeff degree series) relation
  have factorial_ne_zero : (Nat.factorial (degree : ℕ) : K) ≠ 0 := by
    exact_mod_cast Nat.factorial_ne_zero (degree : ℕ)
  calc
    ∑ index, coefficient index * exponent index ^ (degree : ℕ) =
        ∑ index, (coefficient index *
          (exponent index ^ (degree : ℕ) /
            (Nat.factorial (degree : ℕ) : K))) *
              (Nat.factorial (degree : ℕ) : K) := by
      apply Finset.sum_congr rfl
      intro index _
      field_simp [factorial_ne_zero]
    _ = (∑ index, coefficient index *
          (exponent index ^ (degree : ℕ) /
            (Nat.factorial (degree : ℕ) : K))) *
              (Nat.factorial (degree : ℕ) : K) := by
      rw [Finset.sum_mul]
    _ = 0 := by rw [coefficient_relation, zero_mul]

/-- For a finite injective family of vectors over an infinite
characteristic-zero field, there is one linear functional whose values on the
family are pairwise distinct.  Along this one-parameter direction, the
corresponding formal exponential characters have no nontrivial finite linear
relation.

For divisor tagging, the vectors are the divisor-pairing vectors of the finite
lowest-valuation support after scalar extension to a characteristic-zero
field.  This theorem chooses the separating direction and proves the
Vandermonde step; it does not construct that support or show that it is the
initial support of a nonzero completed Novikov series. -/
theorem exists_dual_separating_formalExponentialCharacters
    {K V : Type*} [Field K] [CharZero K] [Infinite K]
    [AddCommGroup V] [Module K V] {m : ℕ}
    (vector : Fin m → V) (vector_injective : Function.Injective vector) :
    ∃ functional : Module.Dual K V,
      Function.Injective (fun index ↦ functional (vector index)) ∧
      ∀ coefficient : Fin m → K,
        (∑ index, coefficient index •
          formalExponentialCharacter (functional (vector index)) = 0) →
        coefficient = 0 := by
  let Pair := {pair : Fin m × Fin m // pair.1 ≠ pair.2}
  let difference : Pair → V := fun pair ↦
    vector pair.1.1 - vector pair.1.2
  have difference_ne_zero : ∀ pair, difference pair ≠ 0 := by
    intro pair difference_zero
    exact pair.2 (vector_injective (sub_eq_zero.mp difference_zero))
  obtain ⟨functional, functional_nonzero⟩ :=
    Module.exists_dual_forall_apply_ne_zero (K := K) (M := V)
      difference difference_ne_zero
  have functional_injective :
      Function.Injective (fun index ↦ functional (vector index)) := by
    intro left right equal_values
    by_contra distinct_indices
    have nonzero_difference := functional_nonzero
      (⟨(left, right), distinct_indices⟩ : Pair)
    apply nonzero_difference
    simp [difference, equal_values]
  exact ⟨functional, functional_injective, fun coefficient relation ↦
    coefficients_eq_zero_of_sum_formalExponentialCharacter_eq_zero
      (fun index ↦ functional (vector index)) coefficient
      functional_injective relation⟩

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
