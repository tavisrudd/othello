import Mathlib.Tactic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# The residue discriminant of a rank-two atomic connection

Let `R` be the residue of the canonical elementary modification of an even
rank-two atomic connection whose centered leading operator is a nonzero
square-zero endomorphism.  Its residue discriminant is

  `residueDiscriminant R = (trace R) ^ 2 - 4 * det R`.

Over a field in which the residue splits, with residue eigenvalues `r₁` and
`r₂` counted with algebraic multiplicity, this equals `(r₁ - r₂) ^ 2`: the
squared separation of the two residue representatives selected by the
modification.  The quantity is unchanged when a scalar multiple of the identity
is added to `R`, so it does not depend on a scalar normalization of the
residue.

This module proves those two algebraic facts and evaluates the invariant on the
two explicit residues used in the manuscript: the residue of the small even
zero packet of a smooth cubic threefold, whose value is `4 / 9`, and the
residue of the even connection of a smooth projective curve of genus at least
two, whose value is `0`.  The two values differ, which is the separation used
to exclude a curve representative.

Lean proves only the stated matrix algebra.  It does not construct the
`A`-model `F`-bundle, the spectral cover, the elementary modification, or the
identification of either displayed matrix with a geometric residue.  The cubic
residue matrix is the one obtained in the manuscript from the small even
connection of J. Cai, *The cubic threefold is symplectically irrational*,
arXiv:2608.01577 (2026), Section 3; the curve residue matrix comes from the
even connection displayed in Section 4 of the same source.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

variable {K : Type*} [CommRing K]

/-- The residue discriminant of a two-by-two residue matrix: the discriminant
of its characteristic polynomial, `(trace R) ^ 2 - 4 * det R`. -/
def residueDiscriminant (R : Matrix (Fin 2) (Fin 2) K) : K :=
  (Matrix.trace R) ^ 2 - 4 * R.det

/-- The residue discriminant is unchanged by adding a scalar multiple of the
identity, so it is insensitive to a scalar normalization of the residue. -/
theorem residueDiscriminant_add_scalar (R : Matrix (Fin 2) (Fin 2) K) (c : K) :
    residueDiscriminant (R + c • (1 : Matrix (Fin 2) (Fin 2) K)) =
      residueDiscriminant R := by
  simp [residueDiscriminant, Matrix.trace_fin_two, Matrix.det_fin_two, Matrix.one_apply]
  ring

/-- If the residue has eigenvalues `r₁` and `r₂`, counted with algebraic
multiplicity, then its residue discriminant is the squared separation
`(r₁ - r₂) ^ 2` of those two representatives. -/
theorem residueDiscriminant_eq_sq_sub_of_trace_det
    (R : Matrix (Fin 2) (Fin 2) K) (r₁ r₂ : K)
    (htrace : Matrix.trace R = r₁ + r₂) (hdet : R.det = r₁ * r₂) :
    residueDiscriminant R = (r₁ - r₂) ^ 2 := by
  rw [residueDiscriminant, htrace, hdet]
  ring

/-- The residue of the canonical elementary modification of the small even zero
packet of a smooth cubic threefold.  The frame is adapted to the square-zero
leading operator, which carries the second basis vector to a unit multiple of
the first, and the modification is the lattice change of basis
`diag (1, u)`; the entries below are those of the resulting regular term. -/
def cubicZeroPacketResidue : Matrix (Fin 2) (Fin 2) ℚ :=
  !![-19 / 18, 2; -8 / 81, 1 / 18]

/-- The residue of the canonical elementary modification of the even connection
of a smooth projective curve of genus at least two.  Here the square-zero
leading operator carries the first basis vector to a multiple of the second, so
the modification is `diag (u, 1)`.  The parameter is the curve's Euler
characteristic `2 - 2 * g`, which is nonzero in that genus range and enters
only off the diagonal. -/
def curveResidue (a : ℚ) : Matrix (Fin 2) (Fin 2) ℚ :=
  !![-1 / 2, 0; a, -1 / 2]

/-- The two residue representatives of the cubic zero packet are `-1 / 6` and
`-5 / 6`: the residue has trace `-1` and determinant `5 / 36`. -/
theorem cubicZeroPacketResidue_trace_det :
    Matrix.trace cubicZeroPacketResidue = (-1 / 6) + (-5 / 6) ∧
      cubicZeroPacketResidue.det = (-1 / 6) * (-5 / 6) := by
  constructor <;>
    simp [cubicZeroPacketResidue, Matrix.trace_fin_two, Matrix.det_fin_two] <;> norm_num

/-- The residue discriminant of the cubic zero packet equals `4 / 9`. -/
theorem residueDiscriminant_cubicZeroPacketResidue :
    residueDiscriminant cubicZeroPacketResidue = 4 / 9 := by
  rw [residueDiscriminant_eq_sq_sub_of_trace_det cubicZeroPacketResidue (-1 / 6) (-5 / 6)
    cubicZeroPacketResidue_trace_det.1 cubicZeroPacketResidue_trace_det.2]
  norm_num

/-- The curve residue has the repeated eigenvalue `-1 / 2`, so its residue
discriminant vanishes for every value of the parameter. -/
theorem residueDiscriminant_curveResidue (a : ℚ) :
    residueDiscriminant (curveResidue a) = 0 := by
  rw [residueDiscriminant_eq_sq_sub_of_trace_det (curveResidue a) (-1 / 2) (-1 / 2)
    (by norm_num [curveResidue, Matrix.trace_fin_two])
    (by norm_num [curveResidue, Matrix.det_fin_two])]
  norm_num

/-- The cubic zero packet and every curve residue have different residue
discriminants.  This inequality is the separation used to exclude a curve
representative of the cubic atom. -/
theorem residueDiscriminant_cubicZeroPacketResidue_ne_curveResidue (a : ℚ) :
    residueDiscriminant cubicZeroPacketResidue ≠ residueDiscriminant (curveResidue a) := by
  rw [residueDiscriminant_cubicZeroPacketResidue, residueDiscriminant_curveResidue]
  norm_num

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
