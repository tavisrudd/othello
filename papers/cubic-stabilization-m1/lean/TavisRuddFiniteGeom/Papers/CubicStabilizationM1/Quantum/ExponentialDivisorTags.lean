import Mathlib.Algebra.Module.Submodule.Union
import Mathlib.Algebra.Polynomial.OfFn
import Mathlib.Algebra.Polynomial.Roots
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

This is the finite-character step used in divisor tagging.  For an injective
finite family of integral pairing vectors, the module also constructs an
integral separating direction of the form `(1,t,t²,...)` by avoiding the
finitely many integral roots of the pairwise difference polynomials.  It does
not construct a completed Novikov ring, identify its lowest-valuation support,
or prove that an associated graded domain prevents cancellation of initial
terms.  The proofs are symbolic and kernel checked; they use no external
computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

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

/-- A finite injective family of integral divisor-pairing vectors admits the
integral one-parameter direction used in divisor tagging.  One may choose a
direction of the form `(1, t, t², ...)`: every pairwise collision excludes a
root of a nonzero integral polynomial, and finitely many such polynomials
exclude only finitely many integers.  After casting into any
characteristic-zero field `K`, the resulting scalar pairings give linearly
independent formal exponential characters over `K`.

This proves both the integral-direction and finite Vandermonde parts of the
manuscript's tagging argument.  It does not construct the finite family as the
lowest-valuation support of a completed Novikov series or justify passage to
that support through an associated graded domain. -/
theorem exists_integralDirection_separating_formalExponentialCharacters
    {K : Type*} [Field K] [CharZero K]
    {m rank : ℕ} (vector : Fin m → Fin rank → ℤ)
    (vector_injective : Function.Injective vector) :
    ∃ direction : Fin rank → ℤ,
      Function.Injective
        (fun index ↦ ∑ coordinate, direction coordinate * vector index coordinate) ∧
      ∀ coefficient : Fin m → K,
        (∑ index, coefficient index • formalExponentialCharacter
          ((∑ coordinate, direction coordinate * vector index coordinate : ℤ) : K) = 0) →
        coefficient = 0 := by
  classical
  let Pair := {pair : Fin m × Fin m // pair.1 ≠ pair.2}
  let differencePolynomial : Pair → Polynomial ℤ := fun pair ↦
    Polynomial.ofFn rank
      (fun coordinate ↦ vector pair.1.1 coordinate - vector pair.1.2 coordinate)
  have differencePolynomial_ne_zero : ∀ pair, differencePolynomial pair ≠ 0 := by
    intro pair polynomial_zero
    have difference_zero :
        (fun coordinate ↦ vector pair.1.1 coordinate -
          vector pair.1.2 coordinate) = 0 := by
      apply Polynomial.injective_ofFn rank
      simpa [differencePolynomial, Polynomial.ofFn_zero] using polynomial_zero
    apply pair.2
    apply vector_injective
    funext coordinate
    have := congrFun difference_zero coordinate
    simpa using sub_eq_zero.mp this
  let forbidden : Finset ℤ := Finset.univ.biUnion fun pair : Pair ↦
    (differencePolynomial pair).roots.toFinset
  obtain ⟨parameter, parameter_not_forbidden⟩ := forbidden.exists_notMem
  let direction : Fin rank → ℤ := fun coordinate ↦ parameter ^ (coordinate : ℕ)
  have scalarPairing_injective : Function.Injective
      (fun index ↦ ∑ coordinate, direction coordinate * vector index coordinate) := by
    intro left right equal_pairings
    by_contra distinct_indices
    let pair : Pair := ⟨(left, right), distinct_indices⟩
    have root_membership : parameter ∈ (differencePolynomial pair).roots := by
      rw [Polynomial.mem_roots (differencePolynomial_ne_zero pair)]
      change (differencePolynomial pair).eval parameter = 0
      rw [show differencePolynomial pair = Polynomial.ofFn rank
        (fun coordinate ↦ vector left coordinate - vector right coordinate) by rfl]
      simp only [Polynomial.ofFn_eq_sum_monomial, Polynomial.eval_finsetSum,
        Polynomial.eval_monomial]
      simp only [sub_mul, Finset.sum_sub_distrib]
      apply sub_eq_zero.mpr
      simpa [direction, mul_comm] using equal_pairings
    apply parameter_not_forbidden
    exact Finset.mem_biUnion.mpr ⟨pair, Finset.mem_univ pair,
      Multiset.mem_toFinset.mpr root_membership⟩
  refine ⟨direction, scalarPairing_injective, ?_⟩
  intro coefficient relation
  exact coefficients_eq_zero_of_sum_formalExponentialCharacter_eq_zero
    (fun index ↦
      ((∑ coordinate, direction coordinate * vector index coordinate : ℤ) : K))
    coefficient (fun left right equality ↦ scalarPairing_injective <|
      Int.cast_injective equality)
    relation

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
