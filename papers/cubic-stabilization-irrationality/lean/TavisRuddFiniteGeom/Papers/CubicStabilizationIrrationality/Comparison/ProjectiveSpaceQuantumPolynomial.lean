import Mathlib.FieldTheory.Separable

/-!
# Separability of the projective-space quantum polynomial

For the small quantum cohomology presentation of projective space, the
quantum relation for `P^(m+3)` is `H^(m+4) = q`.  Over a characteristic-zero
field and away from `q = 0`, the polynomial `X^(m+4) - q` is separable.  Thus
its splitting algebra has no repeated spectral root.  The theorem below checks
this algebraic input; identifying the presentation with a geometric quantum
module is not part of the statement.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectiveSpaceQuantumPolynomial

open Polynomial

universe u

/-- The polynomial relation for the small quantum cohomology of
`P^(m+3)`. -/
noncomputable def relationPolynomial
    (K : Type u) [Field K] (m : ℕ) (q : K) : K[X] :=
  X ^ (m + 4) - C q

/-- In characteristic zero, the projective-space quantum relation is
separable at every nonzero value of the quantum parameter. -/
theorem relationPolynomial_separable
    (K : Type u) [Field K] [CharZero K]
    (m : ℕ) {q : K} (q_ne_zero : q ≠ 0) :
    (relationPolynomial K m q).Separable := by
  apply separable_X_pow_sub_C q
  · exact_mod_cast (show m + 4 ≠ 0 by omega)
  · exact q_ne_zero

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectiveSpaceQuantumPolynomial
