import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Complex.Basic

/-!
# Coordinate axes intrinsic to a full diagonal tensor

For a finite index type `κ`, contract the first factor of the diagonal
four-tensor

`∑ₖ λₖ eₖ ⊗ eₖ ⊗ eₖ ⊗ eₖ`

against a covector `x`.  The resulting three-array has entries
`λₖ xₖ` on the diagonal and zero elsewhere.  When every `λₖ` is nonzero
and `κ` has at least two elements, this array is a nonzero pure tensor
exactly when `x` is a nonzero coordinate vector.  Thus the rank-one
contraction locus recovers the displayed coordinate axes without an
inner product or a matrix-rank API.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

variable {κ : Type*} [Fintype κ] [DecidableEq κ]

/-- A three-factor array over a finite coordinate type. -/
abbrev ThreeArray (κ : Type*) := κ → κ → κ → ℂ

/-- A nonzero pure three-array is an outer product of three nonzero
coordinate functions. -/
def IsNonzeroPureThreeArray (T : ThreeArray κ) : Prop :=
  ∃ a b c : κ → ℂ,
    a ≠ 0 ∧ b ≠ 0 ∧ c ≠ 0 ∧
      ∀ i j k, T i j k = a i * b j * c k

/-- The coordinate vector supported at `i` with value `z`. -/
def coordinateVector (i : κ) (z : ℂ) : κ → ℂ :=
  fun j => if j = i then z else 0

/-- A function lies on a nonzero coordinate axis. -/
def IsNonzeroCoordinateAxis (x : κ → ℂ) : Prop :=
  ∃ i z, z ≠ 0 ∧ x = coordinateVector i z

/-- Contraction of a full diagonal four-tensor in its first factor. -/
def diagonalTensorContraction (coeff x : κ → ℂ) : ThreeArray κ :=
  fun i j k => if i = j ∧ j = k then coeff i * x i else 0

omit [DecidableEq κ] in
private theorem exists_apply_ne_zero {x : κ → ℂ} (hx : x ≠ 0) :
    ∃ i, x i ≠ 0 := by
  by_contra h
  apply hx
  funext i
  exact not_ne_iff.mp (not_exists.mp h i)

omit [Fintype κ] in
private theorem coordinateVector_ne_zero {i : κ} {z : ℂ} (hz : z ≠ 0) :
    coordinateVector i z ≠ 0 := by
  intro h
  have hi := congrFun h i
  simp [coordinateVector, hz] at hi

omit [Fintype κ] in
/-- A nonzero coordinate covector contracts a full diagonal tensor to a
nonzero pure three-array. -/
theorem diagonalTensorContraction_pure_of_coordinateAxis
    {coeff x : κ → ℂ} (hcoeff : ∀ i, coeff i ≠ 0)
    (hx : IsNonzeroCoordinateAxis x) :
    IsNonzeroPureThreeArray (diagonalTensorContraction coeff x) := by
  classical
  obtain ⟨t, z, hz, rfl⟩ := hx
  refine
    ⟨coordinateVector t (coeff t * z), coordinateVector t 1,
      coordinateVector t 1, ?_, coordinateVector_ne_zero one_ne_zero,
      coordinateVector_ne_zero one_ne_zero, ?_⟩
  · exact coordinateVector_ne_zero (mul_ne_zero (hcoeff t) hz)
  · intro i j k
    by_cases hit : i = t
    · subst i
      by_cases hjt : j = t
      · subst j
        by_cases hkt : k = t
        · subst k
          simp [diagonalTensorContraction, coordinateVector]
        · have htk : t ≠ k := Ne.symm hkt
          simp [diagonalTensorContraction, coordinateVector, hkt, htk]
      · have htj : t ≠ j := Ne.symm hjt
        simp [diagonalTensorContraction, coordinateVector, hjt, htj]
    · simp [diagonalTensorContraction, coordinateVector, hit]

/-- If contraction of a full diagonal tensor is a nonzero pure
three-array, then the contracting covector lies on one coordinate axis. -/
theorem coordinateAxis_of_diagonalTensorContraction_pure
    [Nontrivial κ] {coeff x : κ → ℂ} (hcoeff : ∀ i, coeff i ≠ 0)
    (hpure :
      IsNonzeroPureThreeArray (diagonalTensorContraction coeff x)) :
    IsNonzeroCoordinateAxis x := by
  classical
  obtain ⟨a, b, c, ha, hb, hc, hfactor⟩ := hpure
  obtain ⟨p, hp⟩ := exists_apply_ne_zero ha
  obtain ⟨q, hq⟩ := exists_apply_ne_zero hb
  obtain ⟨r, hr⟩ := exists_apply_ne_zero hc
  have hpqr : a p * b q * c r ≠ 0 := mul_ne_zero (mul_ne_zero hp hq) hr
  have hpq : p = q := by
    by_contra hpq
    have hzero :
        diagonalTensorContraction coeff x p q r = 0 := by
      simp [diagonalTensorContraction, hpq]
    rw [hfactor] at hzero
    exact hpqr hzero
  have hqr : q = r := by
    by_contra hqr
    have hzero :
        diagonalTensorContraction coeff x p q r = 0 := by
      simp [diagonalTensorContraction, hqr]
    rw [hfactor] at hzero
    exact hpqr hzero
  subst q
  subst r
  have hxp : x p ≠ 0 := by
    intro hxp
    have hzero :
        diagonalTensorContraction coeff x p p p = 0 := by
      simp [diagonalTensorContraction, hxp]
    rw [hfactor] at hzero
    exact hpqr hzero
  refine ⟨p, x p, hxp, ?_⟩
  funext s
  by_cases hsp : s = p
  · subst s
    simp [coordinateVector]
  · have hxs : x s = 0 := by
      by_contra hxs
      have hdiag :
          diagonalTensorContraction coeff x s s s ≠ 0 := by
        simp [diagonalTensorContraction, mul_ne_zero (hcoeff s) hxs]
      have has : a s ≠ 0 := by
        intro has
        apply hdiag
        rw [hfactor]
        simp [has]
      have hbs : b s ≠ 0 := by
        intro hbs
        apply hdiag
        rw [hfactor]
        simp [hbs]
      have hcs : c s ≠ 0 := by
        intro hcs
        apply hdiag
        rw [hfactor]
        simp [hcs]
      have hoff :
          diagonalTensorContraction coeff x s p p = 0 := by
        simp [diagonalTensorContraction, hsp]
      rw [hfactor] at hoff
      exact (mul_ne_zero (mul_ne_zero has hq) hr) hoff
    simp [coordinateVector, hsp, hxs]

/-- The nonzero pure-contraction locus of a full diagonal four-tensor is
exactly the union of its nonzero coordinate axes. -/
theorem diagonalTensorContraction_pure_iff_coordinateAxis
    [Nontrivial κ] {coeff x : κ → ℂ} (hcoeff : ∀ i, coeff i ≠ 0) :
    IsNonzeroPureThreeArray (diagonalTensorContraction coeff x) ↔
      IsNonzeroCoordinateAxis x :=
  ⟨coordinateAxis_of_diagonalTensorContraction_pure hcoeff,
    diagonalTensorContraction_pure_of_coordinateAxis hcoeff⟩

end RelativeConicArcs.AMELU
