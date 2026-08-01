import Mathlib.Tactic

/-!
# Parity of the residual dihedral reflection equation

In the regular dihedral matching case, an outer element fixes a reflection matching precisely when
the congruence `2a + 1 = 0 (mod n)` has a solution.  This module proves the arithmetic content of
that statement: for positive `n`, such a solution exists exactly when `n` is odd.

The surrounding identification of invariant matchings with right multiplication by involutions is
group-theoretic and is not asserted here.
-/

namespace RelativeConicArcs.ClebschDihedralReflectionParity

/-- A positive modulus divides an odd number of the form `2a+1` for some `a` exactly when the
modulus is odd.  Equivalently, `2a+1=0` has a solution modulo `n` exactly for odd `n`. -/
theorem exists_two_mul_add_one_dvd_iff_odd {n : ℕ} (_hn : 0 < n) :
    (∃ a : ℕ, n ∣ 2 * a + 1) ↔ Odd n := by
  constructor
  · rintro ⟨a, c, hc⟩
    have hproduct : Odd (n * c) := by
      rw [← hc]
      exact odd_two_mul_add_one a
    exact Nat.Odd.of_mul_left hproduct
  · intro hodd
    refine ⟨n / 2, ?_⟩
    use 1
    simpa using Nat.two_mul_div_two_add_one_of_odd hodd

/-- For even positive `n`, the reflection equation `2a+1=0 (mod n)` has no solution. -/
theorem no_reflection_solution_of_even {n : ℕ} (hn : 0 < n) (hnEven : Even n) :
    ¬ ∃ a : ℕ, n ∣ 2 * a + 1 := by
  rw [exists_two_mul_add_one_dvd_iff_odd hn]
  exact Nat.not_odd_iff_even.mpr hnEven

/-- For odd positive `n`, the reflection equation `2a+1=0 (mod n)` has a solution. -/
theorem reflection_solution_of_odd {n : ℕ} (hn : 0 < n) (hnOdd : Odd n) :
    ∃ a : ℕ, n ∣ 2 * a + 1 :=
  (exists_two_mul_add_one_dvd_iff_odd hn).2 hnOdd

end RelativeConicArcs.ClebschDihedralReflectionParity
