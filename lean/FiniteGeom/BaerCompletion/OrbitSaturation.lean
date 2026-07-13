import FiniteGeom.BaerCompletion.PairExtension

/-!
# Arithmetic of equivariant orbit saturation

This file isolates the characteristic-free arithmetic behind the square-root lower bound.
-/

namespace FiniteGeom.BaerCompletion

/-- The product `e(t-e)` is at most `t²/4`, in denominator-free form. -/
theorem four_mul_splitProduct_le_square {e t M : ℕ} (he : e ≤ t)
    (hM : M = e * (t - e)) : 4 * M ≤ t * t := by
  let u := t - e
  have ht : e + u = t := by
    dsimp [u]
    omega
  have hM' : M = e * u := by simpa [u] using hM
  rw [hM', ← ht]
  nlinarith [two_mul_le_add_sq e u]

/-- Combining the pair-extension obstruction with the universal split-product bound gives the
quadratic orbit-saturation inequality. -/
theorem orbitSaturation_quadratic_bound {s k M : ℕ}
    (hpair : s * (s - 1) ≤ 2 * M)
    (hupper : 4 * M ≤ (k - 1) * (k - 1)) :
    2 * s * (s - 1) ≤ (k - 1) * (k - 1) := by
  nlinarith

/-- Direct specialization when `M=e((k-1)-e)`. -/
theorem orbitSaturation_quadratic_bound_of_split {s k e M : ℕ}
    (he : e ≤ k - 1) (hM : M = e * ((k - 1) - e))
    (hpair : s * (s - 1) ≤ 2 * M) :
    2 * s * (s - 1) ≤ (k - 1) * (k - 1) := by
  apply orbitSaturation_quadratic_bound hpair
  exact four_mul_splitProduct_le_square he hM

/-- Contrapositive form used by the extension theorem: below the quadratic threshold, the
noninvariant-secant obstruction cannot exhaust all candidate conjugate pairs. -/
theorem pair_obstruction_lt_of_square_lt {s k M : ℕ}
    (hupper : 4 * M ≤ (k - 1) * (k - 1))
    (hsmall : (k - 1) * (k - 1) < 2 * s * (s - 1)) :
    2 * M < s * (s - 1) := by
  nlinarith

end FiniteGeom.BaerCompletion
