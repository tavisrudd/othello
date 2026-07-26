import Mathlib

/-!
# Hilbert-symmetry forcing for socle degree three

This module isolates the numerical step used for a zero-dimensional
arithmetically Gorenstein scheme of length `2 * q`.  If its Artinian
reduction has first Hilbert values `1, q - 1, q - 1`, symmetry leaves room
for exactly one further value, equal to one.  The theorem is purely
arithmetic: the Gorenstein symmetry and the identification of the Hilbert
values are hypotheses rather than formalized algebraic-geometry results.
-/

namespace RelativeConicArcs.HilbertSymmetry

/-- A symmetric finite Hilbert function of total length `2 * q` whose first
three values are `1, q - 1, q - 1` has socle degree three. -/
theorem socleDegree_eq_three
    (q s : ℕ) (h : ℕ → ℕ)
    (hq : 2 ≤ q) (hs : 2 ≤ s)
    (hzero : h 0 = 1)
    (hone : h 1 = q - 1)
    (htwo : h 2 = q - 1)
    (hsymm : ∀ i ≤ s, h i = h (s - i))
    (htotal : ∑ i ∈ Finset.range (s + 1), h i = 2 * q) :
    s = 3 := by
  rcases eq_or_lt_of_le hs with rfl | hs_gt
  · simp [Finset.sum_range_succ, hzero, hone, htwo] at htotal
    omega
  by_contra hs_ne
  have hs_four : 4 ≤ s := by omega
  have hlast : h s = 1 := by
    simpa [hzero] using (hsymm 0 (by omega)).symm
  have hprev : h (s - 1) = q - 1 := by
    simpa [hone] using (hsymm 1 (by omega)).symm
  let indices : Finset ℕ := {0, 1, 2, s - 1, s}
  have hsubset : indices ⊆ Finset.range (s + 1) := by
    intro i hi
    simp only [indices, Finset.mem_insert, Finset.mem_singleton] at hi
    simp only [Finset.mem_range]
    rcases hi with rfl | rfl | rfl | rfl | rfl
    all_goals omega
  have hle :
      ∑ i ∈ indices, h i ≤ ∑ i ∈ Finset.range (s + 1), h i := by
    exact Finset.sum_le_sum_of_subset_of_nonneg hsubset (by
      intro _ _ _
      omega)
  have hindices :
      ∑ i ∈ indices, h i = 3 * q - 1 := by
    have hnot_zero : 0 ∉ ({1, 2, s - 1, s} : Finset ℕ) := by
      simp
      omega
    have hnot_one : 1 ∉ ({2, s - 1, s} : Finset ℕ) := by
      simp
      omega
    have hnot_two : 2 ∉ ({s - 1, s} : Finset ℕ) := by
      simp
      omega
    have hnot_prev : s - 1 ∉ ({s} : Finset ℕ) := by
      simp
      omega
    dsimp [indices]
    rw [Finset.sum_insert hnot_zero, Finset.sum_insert hnot_one,
      Finset.sum_insert hnot_two, Finset.sum_insert hnot_prev]
    simp [hzero, hone, htwo, hprev, hlast]
    omega
  rw [hindices, htotal] at hle
  omega

/-- Under the same hypotheses, the value in socle degree is one. -/
theorem value_three_eq_one
    (q s : ℕ) (h : ℕ → ℕ)
    (hq : 2 ≤ q) (hs : 2 ≤ s)
    (hzero : h 0 = 1)
    (hone : h 1 = q - 1)
    (htwo : h 2 = q - 1)
    (hsymm : ∀ i ≤ s, h i = h (s - i))
    (htotal : ∑ i ∈ Finset.range (s + 1), h i = 2 * q) :
    h 3 = 1 := by
  have hs_three :=
    socleDegree_eq_three q s h hq hs hzero hone htwo hsymm htotal
  subst s
  simpa [hzero] using (hsymm 0 (by omega)).symm

end RelativeConicArcs.HilbertSymmetry
