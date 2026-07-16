import RelativeConicArcs.Q25ResidualAction

/-!
# Shared line-incidence checker for C151 masks

Generated data will index projective lines by the same `651` canonical coordinate triples as
points.  A small witness says that the cross product of two point representatives is a nonzero
multiple of the stored dual-line representative.  The generic theorem below then replaces every
determinant condition against that pair by one reusable point-line incidence bit.
-/

namespace RelativeConicArcs
namespace Q25LineMaskChecker

open Q25Coordinates Q25PairCertificate Q25MinimumMask FiniteFields

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

def crossVec (a b : Idx25) : Fin 3 → K25 := ![
  vec a 1 * vec b 2 - vec a 2 * vec b 1,
  vec a 2 * vec b 0 - vec a 0 * vec b 2,
  vec a 0 * vec b 1 - vec a 1 * vec b 0]

def lineDot (u v : Fin 3 → K25) : K25 :=
  u 0 * v 0 + u 1 * v 1 + u 2 * v 2

theorem det_eq_lineDot_crossVec (a b p : Idx25) :
    Matrix.det ![vec a, vec b, vec p] = lineDot (crossVec a b) (vec p) := by
  simp [Matrix.det_fin_three, crossVec, lineDot]
  ring

theorem lineDot_smul_left (r : K25) (u v : Fin 3 → K25) :
    lineDot (r • u) v = r * lineDot u v := by
  simp [lineDot]
  ring

/-- `l` is a canonical dual-line representative for the join of `a,b`, with explicit nonzero
projective scale `r`. -/
def LineWitnessValid (a b l : Idx25) (r : K25) : Prop :=
  r ≠ 0 ∧ crossVec a b = r • vec l

instance (a b l : Idx25) (r : K25) : Decidable (LineWitnessValid a b l r) := by
  unfold LineWitnessValid
  infer_instance

theorem det_zero_iff_lineDot_zero {a b l : Idx25} {r : K25}
    (h : LineWitnessValid a b l r) (p : Idx25) :
    Matrix.det ![vec a, vec b, vec p] = 0 ↔ lineDot (vec l) (vec p) = 0 := by
  rw [det_eq_lineDot_crossVec, h.2, lineDot_smul_left]
  exact mul_eq_zero.trans (or_iff_right h.1)

theorem det_ne_zero_iff_lineDot_ne_zero {a b l : Idx25} {r : K25}
    (h : LineWitnessValid a b l r) (p : Idx25) :
    Matrix.det ![vec a, vec b, vec p] ≠ 0 ↔ lineDot (vec l) (vec p) ≠ 0 := by
  exact not_congr (det_zero_iff_lineDot_zero h p)

/-- Conjugation carries point-line incidence to incidence of both conjugates. -/
theorem conj_lineDot (l p : Idx25) :
    Q25Coordinates.conj (lineDot (vec l) (vec p)) =
      lineDot (vec (conjIdx l)) (vec (conjIdx p)) := by
  simp only [lineDot, Q25Coordinates.conj_add, Q25Coordinates.conj_mul]
  rw [vec_conjIdx, vec_conjIdx]
  rfl

theorem lineDot_conj_ne_zero {l p : Idx25} (hl : conjIdx l = l)
    (h : lineDot (vec l) (vec p) ≠ 0) :
    lineDot (vec l) (vec (conjIdx p)) ≠ 0 := by
  intro hz
  have hc := congrArg Q25Coordinates.conj hz
  rw [conj_zero, conj_lineDot, hl, conjIdx_involutive] at hc
  exact h hc

/-- A literal five-word table row is exactly the selected-representative incidence mask of `l`. -/
structure LineMaskCertificate (l : Idx25) (mask : OrbitMask) : Prop where
  exact : ∀ n : Fin 310,
    maskBit mask n = true ↔
      lineDot (vec l) (vec (orbitIdx (orbitCodeOfNumber n))) = 0

/-- One candidate's conjugate pair has the stated fixed carrier line. -/
structure CarrierLineCertificate (o : OrbitCode) (l : Idx25) (r : K25) : Prop where
  witness : LineWitnessValid (orbitIdx o) (conjIdx (orbitIdx o)) l r
  fixed : conjIdx l = l

end Q25LineMaskChecker
end RelativeConicArcs
