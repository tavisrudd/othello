import Mathlib.Tactic

/-!
# An even-rank-one Frobenius superalgebra has no odd part

The even part is represented concretely by scalar multiples of the unit in an
associative algebra. The odd part is a submodule: its products are scalar and
anticommute, the whole algebra is spanned by scalars and odd elements, and an
even Frobenius trace has nondegenerate multiplication pairing. These explicit
identities imply that the odd submodule is zero.

The proof first derives square-zero odd elements from anticommutativity.
Every product of two odd elements is then both square-zero and scalar, so it
vanishes. The trace pairing finally forces each odd element to vanish. No
primary decomposition or geometric quantum algebra is constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

variable {K A : Type*} [Field K] [CharZero K] [Ring A] [Algebra K A]

/-- Anticommutativity forces the square of an odd element to vanish in
characteristic zero, without commutativity of the ambient algebra. -/
theorem odd_square_eq_zero {odd : Submodule K A}
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y = -(y*x))
    {x : A} (hx : x ∈ odd) : x*x = 0 := by
  have twice : (2 : K) • (x*x) = 0 := by
    rw [two_smul]
    exact add_eq_zero_iff_eq_neg.mpr (anticommute x hx x hx)
  exact (smul_eq_zero.mp twice).resolve_left (by norm_num)

/-- If odd products lie in the scalar even part, anticommutativity forces all
of them to vanish. Nontriviality makes the scalar algebra map injective. -/
theorem odd_mul_eq_zero_of_scalar_even [Nontrivial A] {odd : Submodule K A}
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y = -(y*x))
    (scalarProduct : ∀ x ∈ odd, ∀ y ∈ odd, ∃ c : K, x*y = algebraMap K A c)
    {x y : A} (hx : x ∈ odd) (hy : y ∈ odd) : x*y = 0 := by
  have nilpotent : (x*y)*(x*y) = 0 := by
    calc
      (x*y)*(x*y) = x*(y*x)*y := by simp only [mul_assoc]
      _ = x*(-(x*y))*y := by rw [anticommute y hy x hx]
      _ = -(x*x)*(y*y) := by noncomm_ring
      _ = 0 := by rw [odd_square_eq_zero anticommute hx]; simp
  obtain ⟨c, scalar⟩ := scalarProduct x hx y hy
  have square : c*c = 0 := by
    apply (algebraMap K A).injective
    simpa only [map_mul, map_zero, ← scalar] using nilpotent
  have zero : c = 0 := mul_self_eq_zero.mp square
  simpa [zero] using scalar

/-- A scalar-even Frobenius superalgebra has zero odd submodule. The trace is
even, its multiplication pairing is left-nondegenerate, and every algebra
element is a sum of a scalar and an odd element. No nondegeneracy or vanishing
of a separately restricted odd pairing is assumed. -/
theorem odd_eq_bot_of_scalar_even_frobenius [Nontrivial A] {odd : Submodule K A}
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y = -(y*x))
    (scalarProduct : ∀ x ∈ odd, ∀ y ∈ odd, ∃ c : K, x*y = algebraMap K A c)
    (spanning : ∀ y : A, ∃ (c : K) (v : A), v ∈ odd ∧ y = algebraMap K A c + v)
    (trace : A →ₗ[K] K) (traceOdd : ∀ x ∈ odd, trace x = 0)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y) = 0) → x = 0) :
    odd = ⊥ := by
  apply le_antisymm _ bot_le
  intro x hx
  change x = 0
  apply nondegenerate x
  intro y
  obtain ⟨c, v, hv, rfl⟩ := spanning y
  rw [mul_add, map_add, odd_mul_eq_zero_of_scalar_even anticommute scalarProduct hx hv,
    map_zero, add_zero]
  simp [Algebra.algebraMap_eq_smul_one, traceOdd x hx]

omit [CharZero K] in
/-- A polynomial identity for left multiplication that holds on a submodule
containing the unit holds on the entire algebra. For an even Euler element,
this transfers an identity from the even part to both parity parts. The proof
uses the actual regular representation and polynomial evaluation; it does not
assume an identity on the odd part. -/
theorem euler_polynomial_eq_zero_of_annihilates_unit_submodule
    (even : Submodule K A) (unitEven : (1 : A) ∈ even) (euler : A)
    (polynomial : Polynomial K)
    (annihilates : ∀ x ∈ even,
      (Polynomial.aeval (Algebra.lmul K A euler) polynomial) x = 0) :
    Polynomial.aeval (Algebra.lmul K A euler) polynomial = 0 := by
  rw [Polynomial.aeval_algHom_apply]
  have atUnit := annihilates 1 unitEven
  rw [Polynomial.aeval_algHom_apply] at atUnit
  have value : Polynomial.aeval euler polynomial = 0 := by
    simpa using atUnit
  rw [value, map_zero]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
