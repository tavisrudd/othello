import Mathlib

/-!
# Coordinate check for the conic projection involution

The manuscript uses the conic `XZ = Y²` with parameterization
`c(t) = [t² : t : 1]`. For a centre `[a:b:c]`, projection along a chord sends

`t ↦ (b*t - a) / (c*t - b)`.

Keeping this elementary identity in the checked spine prevents accidentally combining
that Möbius formula with the reversed parameterization `[1:t:t²]`, which would transpose
the off-diagonal entries of the representing matrix.
-/

namespace DihedralSchreier

namespace ConicCoordinates

variable {K : Type*} [Field K]

/-- An affine representative of the conic point `[t²:t:1]`. -/
def conicPoint (t : K) : Fin 3 → K :=
  ![t ^ 2, t, 1]

/-- The chord through parameters `t,u` has equation
`X - (t+u)Y + tu Z = 0`. -/
def chordForm (t u : K) (w : Fin 3 → K) : K :=
  w 0 - (t + u) * w 1 + t * u * w 2

@[simp] theorem chordForm_left (t u : K) : chordForm t u (conicPoint t) = 0 := by
  simp [chordForm, conicPoint]
  ring

@[simp] theorem chordForm_right (t u : K) : chordForm t u (conicPoint u) = 0 := by
  simp [chordForm, conicPoint]
  ring

/-- The finite-parameter part of the projection involution centred at `[a:b:c]`. -/
def projectionParam (a b c t : K) : K :=
  (b * t - a) / (c * t - b)

/-- Away from its pole, the point with parameter `projectionParam a b c t` lies on the
chord through `conicPoint t` and the centre `[a:b:c]`. -/
theorem centre_on_projection_chord (a b c t : K) (hpole : c * t - b ≠ 0) :
    chordForm t (projectionParam a b c t) ![a, b, c] = 0 := by
  let u := projectionParam a b c t
  change a - (t + u) * b + t * u * c = 0
  calc
    a - (t + u) * b + t * u * c = (a - t * b) + u * (c * t - b) := by ring
    _ = (a - t * b) + (b * t - a) := by
      rw [show u = (b * t - a) / (c * t - b) from rfl, div_mul_cancel₀ _ hpole]
    _ = 0 := by ring

end ConicCoordinates

end DihedralSchreier
