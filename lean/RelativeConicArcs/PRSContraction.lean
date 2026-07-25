import Mathlib

/-!
# Consecutive divided-power contraction

This module isolates the finite-coordinate contraction algebra shared by projective
Reed--Solomon syndrome arguments.  Contraction at a finite marker `r` sends consecutive
coordinates `aᵢ, aᵢ₊₁` to `aᵢ₊₁ - r aᵢ`; two contractions commute and give the displayed
quadratic coefficient formula.

The declarations retain their established `PRSResidualQuadratic` namespace so existing
mathematical APIs do not change.  No residual-quadratic coefficient structure, discriminant,
root calculation, or degree-specific synthesis result is imported here.
-/

namespace RelativeConicArcs.PRSResidualQuadratic

variable {R : Type*} [CommRing R]

/-- Divided-power contraction at a finite marker. -/
def dividedPowerContraction {n : ℕ} (r : R) (a : Fin (n + 2) → R) :
    Fin (n + 1) → R :=
  fun i => a i.succ - r * a i.castSucc

/-- Contraction at the zero marker drops the first divided-power coordinate. -/
@[simp] theorem dividedPowerContraction_zero {n : ℕ} (a : Fin (n + 2) → R) :
    dividedPowerContraction 0 a = fun i => a i.succ := by
  funext i
  simp [dividedPowerContraction]

/-- Divided-power contraction is additive in the syndrome coordinates. -/
theorem dividedPowerContraction_add {n : ℕ} (r : R) (a b : Fin (n + 2) → R) :
    dividedPowerContraction r (a + b) =
      dividedPowerContraction r a + dividedPowerContraction r b := by
  funext i
  simp [dividedPowerContraction]
  ring

/-- Scalar multiplication commutes with divided-power contraction. -/
theorem dividedPowerContraction_smul {n : ℕ} (r c : R) (a : Fin (n + 2) → R) :
    dividedPowerContraction r (c • a) = c • dividedPowerContraction r a := by
  funext i
  simp [dividedPowerContraction]
  ring

/-- Successive contractions are symmetric in their two marked roots. -/
theorem dividedPowerContraction_comm {n : ℕ} (r s : R) (a : Fin (n + 3) → R) :
    dividedPowerContraction s (dividedPowerContraction r a) =
      dividedPowerContraction r (dividedPowerContraction s a) := by
  funext i
  simp [dividedPowerContraction]
  ring

/-- Two marked contractions give the divided-power analogue of multiplication by
`(X-r)(X-s)`. -/
theorem dividedPowerContraction_twice_apply {n : ℕ} (r s : R)
    (a : Fin (n + 3) → R) (i : Fin (n + 1)) :
    dividedPowerContraction s (dividedPowerContraction r a) i =
      a i.succ.succ - (r + s) * a i.succ.castSucc +
        r * s * a i.castSucc.castSucc := by
  simp [dividedPowerContraction]
  ring

end RelativeConicArcs.PRSResidualQuadratic
