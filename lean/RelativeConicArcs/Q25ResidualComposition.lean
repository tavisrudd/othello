import RelativeConicArcs.Q25ResidualFast

/-!
# The composition law for the residual action

`Q25ResidualAction.residualApply y z` acts on the affine coordinate by
`u ↦ shift y + scale y * u`, which is the unique `AGL(1,5)`-map sending `y` to `omega`
(`Q25Normalization.normalize_coordinate`).  A parameter is therefore recovered from a map by
where it sends `omega` backwards, and composition of two parameters is *not* a product in `K25`
but the recovered-parameter formula `mulCoord`.

Writing `y = a + b * omega` with `b ≠ 0`, the map is `φ y (u) = (u - a) / b` and its inverse is
`w ↦ b * w + a`.  Since `φ k = φ g ∘ φ h` holds exactly when `k = (φ h)⁻¹ g`, the recovered
parameter is `mulCoord g h = b_h * g + a_h`.

Everything decided here is phrased through the kernel-reducible `Q25ResidualFast` evaluator; the
slow `residualApply` never appears inside a `decide`.  The exported result is
`residualApplyFast_mul`.
-/

namespace RelativeConicArcs
namespace Q25ResidualComposition

open Q25Coordinates Q25Normalization Q25ResidualAction Q25ResidualFast

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- Recovered parameter: the coordinate `k` with `φ k = φ g ∘ φ h`. -/
def mulCoord (g h : K25) : K25 :=
  algebraMap F5 K25 (imagPart h) * g + algebraMap F5 K25 (realPart h)

theorem imagPart_mulCoord (g h : K25) :
    imagPart (mulCoord g h) = imagPart h * imagPart g := by
  revert g h
  decide

theorem realPart_mulCoord (g h : K25) :
    realPart (mulCoord g h) = imagPart h * realPart g + realPart h := by
  revert g h
  decide

/-- The scale factor is multiplicative on recovered parameters, with no admissibility
hypothesis: inversion sends `0` to `0` on both sides. -/
theorem scaleFast_mulCoord (g h : K25) :
    scaleFast (mulCoord g h) = scaleFast g * scaleFast h := by
  revert g h
  decide

/-- The shift satisfies the affine cocycle identity.  This one genuinely needs `h` admissible:
the derivation cancels `scale h * imagPart h = 1`. -/
theorem shiftFast_mulCoord (g h : K25) (hh : imagPart h ≠ 0) :
    shiftFast (mulCoord g h) = shiftFast g + scaleFast g * shiftFast h := by
  revert g h
  decide

instance : Mul AdmissibleCoordinate :=
  ⟨fun g h => ⟨mulCoord g.1 h.1, by
    rw [imagPart_mulCoord]
    exact mul_ne_zero h.2 g.2⟩⟩

@[simp] theorem val_mul (g h : AdmissibleCoordinate) :
    (g * h).1 = mulCoord g.1 h.1 := rfl

/-- `omega` is the parameter of the identity map: `realPart omega = 0`, `imagPart omega = 1`. -/
def one : AdmissibleCoordinate := ⟨omega, by decide⟩

theorem mulCoord_omega (g : K25) : mulCoord g omega = g := by
  revert g
  decide

theorem omega_mulCoord (h : K25) : mulCoord omega h = h := by
  revert h
  decide

theorem mulCoord_assoc (g h k : K25) :
    mulCoord (mulCoord g h) k = mulCoord g (mulCoord h k) := by
  revert g h k
  decide

/-- The composition law on the parameter pair.  Both coordinates compose independently, and the
`.infinity` branch composes because it is built from the multiplicative scale factors alone. -/
theorem residualApplyFast_mul (g h : ResidualParameter) (i : Idx25) :
    residualApplyFast (g * h).1.1 (g * h).2.1 i =
      residualApplyFast g.1.1 g.2.1 (residualApplyFast h.1.1 h.2.1 i) := by
  obtain ⟨⟨y₁, hy₁⟩, ⟨z₁, hz₁⟩⟩ := g
  obtain ⟨⟨y₂, hy₂⟩, ⟨z₂, hz₂⟩⟩ := h
  cases i with
  | affine u v =>
      simp only [residualApplyFast, val_mul, Prod.fst_mul, Prod.snd_mul, Idx25.affine.injEq]
      constructor
      · rw [shiftFast_mulCoord y₁ y₂ hy₂, scaleFast_mulCoord]
        ring
      · rw [shiftFast_mulCoord z₁ z₂ hz₂, scaleFast_mulCoord]
        ring
  | infinity v =>
      simp only [residualApplyFast, val_mul, Prod.fst_mul, Prod.snd_mul, Idx25.infinity.injEq]
      rw [scaleFast_mulCoord, scaleFast_mulCoord, mul_inv]
      ring
  | vertical => rfl

/-- The same law for the semantic evaluator, obtained through the fast bridge. -/
theorem residualApply_mul (g h : ResidualParameter) (i : Idx25) :
    residualApply (g * h).1.1 (g * h).2.1 i =
      residualApply g.1.1 g.2.1 (residualApply h.1.1 h.2.1 i) := by
  rw [residualApply_eq_fast, residualApply_eq_fast, residualApply_eq_fast]
  exact residualApplyFast_mul g h i

end Q25ResidualComposition
end RelativeConicArcs
