import Mathlib.Tactic

/-!
# Klein's dehomogenized icosahedral syzygy modulo 11

The integer polynomials below are obtained from Klein's degree-12, degree-20, and degree-30
binary forms by setting `z₂ = 1`.  We prove the classical integer identity, reduce its
coefficients through the canonical ring homomorphism to `ZMod 11`, and identify the resulting
polynomials with their displayed canonical reductions.  Every theorem is checked by Lean's
kernel; no native decision procedure or external certificate is used.

This module does not certify the transcription from the cited classical source, the homogeneous
interpretation, group invariance, root loci, or the diagonal/resolvent/pole correspondence.
-/

namespace RelativeConicArcs.Examples.Q11KleinSyzygy

open Polynomial

noncomputable section

abbrev PZ := Polynomial ℤ
abbrev P11 := Polynomial (ZMod 11)

/-- Dehomogenized degree-12 vertex form over the integers. -/
def fZ : PZ := X * (X ^ 10 + 11 * X ^ 5 - 1)

/-- Dehomogenized degree-20 face form over the integers. -/
def hZ : PZ := -(X ^ 20 + 1) + 228 * (X ^ 15 - X ^ 5) - 494 * X ^ 10

/-- Dehomogenized degree-30 edge form over the integers. -/
def tZ : PZ := X ^ 30 + 1 + 522 * (X ^ 25 - X ^ 5) - 10005 * (X ^ 20 + X ^ 10)

/-- Klein's dehomogenized integer syzygy in the normalization used by the paper. -/
theorem syzygyZ : hZ ^ 3 + tZ ^ 2 = 1728 * fZ ^ 5 := by
  unfold hZ tZ fZ
  ring

/-- Coefficientwise reduction from integer polynomials to `ZMod 11` polynomials. -/
def reduce (p : PZ) : P11 := p.map (Int.castRingHom (ZMod 11))

def f11 : P11 := reduce fZ
def h11 : P11 := reduce hZ
def t11 : P11 := reduce tZ

/-- Structured mod-11 reduction of the vertex form. -/
def f11Reduced : P11 := X ^ 11 - X

/-- Structured mod-11 reduction of the face form. -/
def h11Reduced : P11 := -(X ^ 20 + 1) + 8 * (X ^ 15 - X ^ 5) + X ^ 10

/-- Structured mod-11 reduction of the edge form. -/
def t11Reduced : P11 :=
  X ^ 30 + 1 + 5 * (X ^ 25 - X ^ 5) + 5 * (X ^ 20 + X ^ 10)

/-- Canonical coefficient display of the mod-11 face form. -/
def h11Canonical : P11 :=
  10 * X ^ 20 + 8 * X ^ 15 + X ^ 10 + 3 * X ^ 5 + 10

/-- Canonical coefficient display of the mod-11 edge form. -/
def t11Canonical : P11 :=
  X ^ 30 + 5 * X ^ 25 + 5 * X ^ 20 + 5 * X ^ 10 + 6 * X ^ 5 + 1

private theorem scalar11 : (11 : P11) = 0 := by
  calc
    (11 : P11) = C (11 : ZMod 11) := (C_eq_natCast 11).symm
    _ = C 0 := congrArg C (by decide)
    _ = 0 := C_0

private theorem scalar228 : (228 : P11) = 8 := by
  calc
    (228 : P11) = C (228 : ZMod 11) := (C_eq_natCast 228).symm
    _ = C 8 := congrArg C (by decide)
    _ = 8 := C_eq_natCast 8

private theorem scalar494 : (494 : P11) = -1 := by
  calc
    (494 : P11) = C (494 : ZMod 11) := (C_eq_natCast 494).symm
    _ = C (-1) := congrArg C (by decide)
    _ = -1 := by simp only [map_neg, C_1]

private theorem scalar522 : (522 : P11) = 5 := by
  calc
    (522 : P11) = C (522 : ZMod 11) := (C_eq_natCast 522).symm
    _ = C 5 := congrArg C (by decide)
    _ = 5 := C_eq_natCast 5

private theorem scalar10005 : (10005 : P11) = -5 := by
  calc
    (10005 : P11) = C (10005 : ZMod 11) := (C_eq_natCast 10005).symm
    _ = C (-5) := congrArg C (by decide)
    _ = -5 := by
      rw [map_neg]
      exact congrArg Neg.neg (C_eq_natCast 5)

private theorem negOne : (-1 : P11) = 10 := by
  calc
    (-1 : P11) = C (-1 : ZMod 11) := by simp only [map_neg, C_1]
    _ = C 10 := congrArg C (by decide)
    _ = 10 := C_eq_natCast 10

private theorem negEight : (-8 : P11) = 3 := by
  calc
    (-8 : P11) = C (-8 : ZMod 11) := by
      rw [map_neg]
      exact congrArg Neg.neg (C_eq_natCast 8).symm
    _ = C 3 := congrArg C (by decide)
    _ = 3 := C_eq_natCast 3

private theorem negFive : (-5 : P11) = 6 := by
  calc
    (-5 : P11) = C (-5 : ZMod 11) := by
      rw [map_neg]
      exact congrArg Neg.neg (C_eq_natCast 5).symm
    _ = C 6 := congrArg C (by decide)
    _ = 6 := C_eq_natCast 6

theorem f11_eq_reduced : f11 = f11Reduced := by
  unfold f11 f11Reduced reduce fZ
  simp
  rw [scalar11]
  ring

theorem h11_eq_reduced : h11 = h11Reduced := by
  unfold h11 h11Reduced reduce hZ
  simp
  rw [scalar228, scalar494]
  ring

theorem t11_eq_reduced : t11 = t11Reduced := by
  unfold t11 t11Reduced reduce tZ
  simp
  rw [scalar522, scalar10005]
  ring

theorem h11_eq_canonical : h11 = h11Canonical := by
  rw [h11_eq_reduced]
  unfold h11Reduced h11Canonical
  rw [← negOne, ← negEight]
  ring

theorem t11_eq_canonical : t11 = t11Canonical := by
  rw [t11_eq_reduced]
  unfold t11Reduced t11Canonical
  rw [← negFive]
  ring

private theorem scalar1728 : (1728 : P11) = 1 := by
  rw [← C_ofNat]
  simpa only [C_1] using congrArg (C : ZMod 11 → P11)
    (show (1728 : ZMod 11) = 1 by decide)

/-- The exact reduced syzygy `h11³ + t11² = f11⁵`. -/
theorem syzygy11 : h11 ^ 3 + t11 ^ 2 = f11 ^ 5 := by
  have h := congrArg reduce syzygyZ
  simpa [reduce, h11, t11, f11, scalar1728] using h

#print axioms syzygy11

end

end RelativeConicArcs.Examples.Q11KleinSyzygy
