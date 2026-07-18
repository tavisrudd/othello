import RelativeConicArcs.Q25ResidualAction

/-!
# A kernel-reducible evaluator for the residual action

`Q25ResidualAction.residualApply` is computable but does not *reduce* in the kernel: `scale`
is `algebraMap F5 K25 (imagPart x)⁻¹`, and `(·)⁻¹` on `F5 = ZMod 5` is `ZMod.inv`, which routes
through `Nat.gcdA`/`xgcdAux` and its well-founded recursion.  Every `decide` that unfolds a
residual image therefore gets stuck on that one atom, independently of how small the finite
problem is.

This module removes the atom in the way the generated transport leaves already do by hand, but
once and symbolically: on `F5` inversion agrees with cubing, because `a ^ 4 = 1` for `a ≠ 0`
and both sides vanish at `0`.  Cubing is ordinary `ZMod` multiplication and reduces.

The exported bridge is `residualApply_eq_fast`.  Downstream `decide`s should be phrased in
`residualApplyFast` and rewritten with it; nothing here changes the semantics of the action.
-/

namespace RelativeConicArcs
namespace Q25ResidualFast

open Q25Coordinates Q25Normalization Q25ResidualAction

/-- On `F5`, inversion is cubing: `a ^ 4 = 1` away from zero, and `0⁻¹ = 0 = 0 ^ 3`. -/
theorem f5_inv_eq_pow (a : F5) : a⁻¹ = a ^ 3 := by
  rcases eq_or_ne a 0 with rfl | ha
  · simp
  · have hpow : a ^ 4 = 1 := by
      simpa using ZMod.pow_card_sub_one_eq_one ha
    have hmul : a * a ^ 3 = 1 := by
      calc a * a ^ 3 = a ^ 4 := by ring
        _ = 1 := hpow
    exact inv_eq_of_mul_eq_one_right hmul

/-- `scale` with the opaque inversion replaced by cubing. -/
def scaleFast (x : K25) : K25 := algebraMap F5 K25 (imagPart x ^ 3)

/-- `shift` expressed through `scaleFast`. -/
def shiftFast (x : K25) : K25 := -scaleFast x * algebraMap F5 K25 (realPart x)

theorem scale_eq_scaleFast (x : K25) : scale x = scaleFast x := by
  rw [scale, scaleFast, f5_inv_eq_pow]

theorem shift_eq_shiftFast (x : K25) : shift x = shiftFast x := by
  rw [shift, shiftFast, scale_eq_scaleFast]

/-- The reducible form of the residual action.  The `.infinity` branch keeps `GF25.inv`, which
is already a literal 25-entry table and reduces. -/
def residualApplyFast (y z : K25) : Idx25 → Idx25
  | .affine u v => .affine (shiftFast y + scaleFast y * u) (shiftFast z + scaleFast z * v)
  | .infinity v => .infinity ((scaleFast y)⁻¹ * scaleFast z * v)
  | .vertical => .vertical

theorem residualApply_eq_fast (y z : K25) (i : Idx25) :
    residualApply y z i = residualApplyFast y z i := by
  cases i <;>
    simp [residualApply, residualApplyFast, scale_eq_scaleFast, shift_eq_shiftFast]

theorem residualApply_eq_fast' (y z : K25) :
    residualApply y z = residualApplyFast y z :=
  funext (residualApply_eq_fast y z)

end Q25ResidualFast
end RelativeConicArcs
