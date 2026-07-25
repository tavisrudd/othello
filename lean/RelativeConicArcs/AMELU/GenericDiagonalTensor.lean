import RelativeConicArcs.AMELU.DiagonalTensor
import Mathlib.Algebra.Module.Equiv.Basic

/-!
# Axis recovery for diagonal tensors of arbitrary arity

After contracting one factor of a full diagonal tensor with at least
three factors, flatten any two remaining factors against each other.
The resulting matrix is diagonal with entries `coeff k * x k`.  It is a
nonzero pure matrix exactly when the contracting covector `x` lies on a
nonzero coordinate axis.  This two-factor flattening is independent of
the number of additional tensor factors and is the length-generic
axis-recovery interface.

The terminal statement says that any invertible factor map preserving
this pure-contraction locus carries coordinate axes to coordinate axes;
equivalently, it is monomial in the displayed full basis.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

variable {κ κ₂ : Type*} [Fintype κ] [DecidableEq κ]
  [Fintype κ₂] [DecidableEq κ₂]

/-- A two-factor complex array. -/
abbrev TwoArray (κ : Type*) := κ → κ → ℂ

/-- A nonzero pure matrix is an outer product of two nonzero coordinate
functions. -/
def IsNonzeroPureTwoArray (T : TwoArray κ) : Prop :=
  ∃ a b : κ → ℂ,
    a ≠ 0 ∧ b ≠ 0 ∧ ∀ i j, T i j = a i * b j

/-- The two-factor flattening of a one-factor contraction of a full
diagonal tensor. -/
def diagonalTensorFlattening (coeff x : κ → ℂ) : TwoArray κ :=
  fun i j => if i = j then coeff i * x i else 0

omit [DecidableEq κ] in
private theorem generic_exists_apply_ne_zero {x : κ → ℂ} (hx : x ≠ 0) :
    ∃ i, x i ≠ 0 := by
  by_contra h
  apply hx
  funext i
  exact not_ne_iff.mp (not_exists.mp h i)

omit [Fintype κ] in
private theorem generic_coordinateVector_ne_zero
    {i : κ} {z : ℂ} (hz : z ≠ 0) :
    coordinateVector i z ≠ 0 := by
  intro h
  have hi := congrFun h i
  simp [coordinateVector, hz] at hi

omit [Fintype κ] in
/-- A nonzero coordinate covector gives a nonzero pure flattening. -/
theorem diagonalTensorFlattening_pure_of_coordinateAxis
    {coeff x : κ → ℂ} (hcoeff : ∀ i, coeff i ≠ 0)
    (hx : IsNonzeroCoordinateAxis x) :
    IsNonzeroPureTwoArray (diagonalTensorFlattening coeff x) := by
  classical
  obtain ⟨t, z, hz, rfl⟩ := hx
  refine
    ⟨coordinateVector t (coeff t * z), coordinateVector t 1,
      generic_coordinateVector_ne_zero (mul_ne_zero (hcoeff t) hz),
      generic_coordinateVector_ne_zero one_ne_zero, ?_⟩
  intro i j
  by_cases hit : i = t
  · subst i
    by_cases hjt : j = t
    · subst j
      simp [diagonalTensorFlattening, coordinateVector]
    · have htj : t ≠ j := Ne.symm hjt
      simp [diagonalTensorFlattening, coordinateVector, hjt, htj]
  · simp [diagonalTensorFlattening, coordinateVector, hit]

/-- A nonzero pure flattening forces the contracting covector onto one
coordinate axis. -/
theorem coordinateAxis_of_diagonalTensorFlattening_pure
    [Nontrivial κ] {coeff x : κ → ℂ} (hcoeff : ∀ i, coeff i ≠ 0)
    (hpure : IsNonzeroPureTwoArray (diagonalTensorFlattening coeff x)) :
    IsNonzeroCoordinateAxis x := by
  classical
  obtain ⟨a, b, ha, hb, hfactor⟩ := hpure
  obtain ⟨p, hp⟩ := generic_exists_apply_ne_zero ha
  obtain ⟨q, hq⟩ := generic_exists_apply_ne_zero hb
  have hpq : p = q := by
    by_contra hpq
    have hzero : diagonalTensorFlattening coeff x p q = 0 := by
      simp [diagonalTensorFlattening, hpq]
    rw [hfactor] at hzero
    exact (mul_ne_zero hp hq) hzero
  subst q
  have hxp : x p ≠ 0 := by
    intro hxp
    have hzero : diagonalTensorFlattening coeff x p p = 0 := by
      simp [diagonalTensorFlattening, hxp]
    rw [hfactor] at hzero
    exact (mul_ne_zero hp hq) hzero
  refine ⟨p, x p, hxp, ?_⟩
  funext s
  by_cases hsp : s = p
  · subst s
    simp [coordinateVector]
  · have hxs : x s = 0 := by
      by_contra hxs
      have hdiag : diagonalTensorFlattening coeff x s s ≠ 0 := by
        simp [diagonalTensorFlattening, mul_ne_zero (hcoeff s) hxs]
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
      have hoff : diagonalTensorFlattening coeff x s p = 0 := by
        simp [diagonalTensorFlattening, hsp]
      rw [hfactor] at hoff
      exact (mul_ne_zero has hq) hoff
    simp [coordinateVector, hsp, hxs]

/-- The nonzero pure-contraction locus of a full diagonal tensor of any
arity at least three is its union of nonzero coordinate axes. -/
theorem diagonalTensorFlattening_pure_iff_coordinateAxis
    [Nontrivial κ] {coeff x : κ → ℂ} (hcoeff : ∀ i, coeff i ≠ 0) :
    IsNonzeroPureTwoArray (diagonalTensorFlattening coeff x) ↔
      IsNonzeroCoordinateAxis x :=
  ⟨coordinateAxis_of_diagonalTensorFlattening_pure hcoeff,
    diagonalTensorFlattening_pure_of_coordinateAxis hcoeff⟩

/-- An invertible factor map preserving the pure-contraction locus of two
full diagonal tensors carries every displayed coordinate axis to a
displayed coordinate axis. -/
theorem coordinateAxes_preserved_of_diagonalTensor_equivalent
    [Nontrivial κ] [Nontrivial κ₂]
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ₂ → ℂ))
    {coeff : κ → ℂ} {coeff' : κ₂ → ℂ}
    (hcoeff : ∀ i, coeff i ≠ 0)
    (hcoeff' : ∀ i, coeff' i ≠ 0)
    (hpure : ∀ x,
      IsNonzeroPureTwoArray (diagonalTensorFlattening coeff x) ↔
        IsNonzeroPureTwoArray
          (diagonalTensorFlattening coeff' (A x))) :
    ∀ x, IsNonzeroCoordinateAxis x →
      IsNonzeroCoordinateAxis (A x) := by
  intro x hx
  apply (diagonalTensorFlattening_pure_iff_coordinateAxis hcoeff').mp
  exact (hpure x).mp
    ((diagonalTensorFlattening_pure_iff_coordinateAxis hcoeff).mpr hx)

end RelativeConicArcs.AMELU
