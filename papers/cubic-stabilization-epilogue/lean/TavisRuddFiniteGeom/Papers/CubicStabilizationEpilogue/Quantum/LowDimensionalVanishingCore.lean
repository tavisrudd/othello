import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FramedMultiplicity
import Mathlib.LinearAlgebra.Eigenspace.Charpoly

/-!
# Involutive monodromy excludes primitive sixth roots

This module formalizes the terminal linear-algebra step in the manuscript's
low-dimensional vanishing argument.  If every characteristic root of a
supplied framed monodromy matrix has square one, whereas the two chosen
primitive sixth roots do not, their characteristic-polynomial multiplicities
vanish.  Involutivity of the matrix is recorded separately as one sufficient
condition for that root restriction; it is not asserted by the manuscript's
regular-singular argument.

The proof is symbolic and kernel checked.  It does not construct a quantum
connection, prove regular singularity or nilpotence of its residue, derive the
involutivity of geometric monodromy, classify low-dimensional varieties, or
compare intrinsic and specialized Novikov coefficients.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Polynomial

/-- The positive primitive sixth root has real part one half. -/
theorem primitiveSixthRootPositive_re :
    primitiveSixthRootPositive.re = 1 / 2 := by
  unfold primitiveSixthRootPositive
  rw [show (Real.pi : ℂ) * Complex.I / 3 =
      ((Real.pi / 3 : ℝ) : ℂ) * Complex.I by push_cast; ring]
  rw [Complex.exp_ofReal_mul_I_re, Real.cos_pi_div_three]

/-- The negative primitive sixth root has real part one half. -/
theorem primitiveSixthRootNegative_re :
    primitiveSixthRootNegative.re = 1 / 2 := by
  unfold primitiveSixthRootNegative
  rw [show -(Real.pi * Complex.I) / 3 =
      ((-(Real.pi / 3) : ℝ) : ℂ) * Complex.I by push_cast; ring]
  rw [Complex.exp_ofReal_mul_I_re, Real.cos_neg,
    Real.cos_pi_div_three]

/-- A complex number of real part one half cannot have square one. -/
theorem sq_ne_one_of_re_eq_half {value : ℂ}
    (realPart : value.re = 1 / 2) : value ^ 2 ≠ 1 := by
  intro square
  have product : (value - 1) * (value + 1) = 0 := by
    calc
      (value - 1) * (value + 1) = value ^ 2 - 1 := by ring
      _ = 0 := by rw [square, sub_self]
  rcases mul_eq_zero.mp product with valueOne | valueNegOne
  · have equality : value = 1 := sub_eq_zero.mp valueOne
    have realEquality := congrArg Complex.re equality
    norm_num [realPart] at realEquality
  · have equality : value = -1 := eq_neg_of_add_eq_zero_left valueNegOne
    have realEquality := congrArg Complex.re equality
    norm_num [realPart] at realEquality

/-- Neither chosen primitive sixth root has square one. -/
theorem primitiveSixthRoots_sq_ne_one :
    primitiveSixthRootPositive ^ 2 ≠ 1 ∧
      primitiveSixthRootNegative ^ 2 ≠ 1 :=
  ⟨sq_ne_one_of_re_eq_half primitiveSixthRootPositive_re,
    sq_ne_one_of_re_eq_half primitiveSixthRootNegative_re⟩

/-- Every characteristic-polynomial root of an involutive complex matrix has
square one. -/
theorem charpoly_isRoot_sq_eq_one_of_matrix_sq_eq_one
    {rank : ℕ} (operator : Matrix (Fin rank) (Fin rank) ℂ)
    (involutive : operator * operator = 1) {value : ℂ}
    (root : operator.charpoly.IsRoot value) : value ^ 2 = 1 := by
  let endomorphism : Module.End ℂ (Fin rank → ℂ) := Matrix.toLin' operator
  have eigenvalue : Module.End.HasEigenvalue endomorphism value := by
    rw [Module.End.hasEigenvalue_iff_isRoot_charpoly]
    simpa [endomorphism, Matrix.charpoly_toLin'] using root
  obtain ⟨vector, eigenvector⟩ := eigenvalue.exists_hasEigenvector
  have powerAction := eigenvector.pow_apply 2
  have endomorphismSquare : endomorphism ^ 2 = 1 := by
    rw [Module.End.one_eq_id, ← Matrix.toLin'_pow, pow_two, involutive]
    exact Matrix.toLin'_one
  rw [endomorphismSquare, Module.End.one_apply] at powerAction
  have nonzeroCoordinate : ∃ index, vector index ≠ 0 := by
    by_contra noCoordinate
    have allZero : ∀ index, vector index = 0 := by
      simpa only [not_exists, not_ne_iff] using noCoordinate
    exact eigenvector.2 (funext allZero)
  obtain ⟨index, coordinateNonzero⟩ := nonzeroCoordinate
  have coordinateEquality := congrArg (fun v : Fin rank → ℂ ↦ v index) powerAction
  have multiplied : (1 : ℂ) * vector index = value ^ 2 * vector index := by
    simpa [Pi.smul_apply] using coordinateEquality
  exact (mul_right_cancel₀ coordinateNonzero multiplied).symm

/-- If every characteristic root of a framed monodromy has square one, then
its primitive-sixth multiplicity is zero.  This is the exact spectral endpoint
used in the manuscript's low-dimensional argument. -/
theorem FramedMonodromyMatrix.sixthMultiplicity_eq_zero_of_roots_sq_eq_one
    (monodromy : FramedMonodromyMatrix)
    (rootSquare : ∀ value : ℂ, monodromy.operator.charpoly.IsRoot value →
      value ^ 2 = 1) :
    monodromy.sixthMultiplicity = 0 := by
  have positiveNotRoot :
      ¬monodromy.operator.charpoly.IsRoot primitiveSixthRootPositive := by
    intro root
    exact primitiveSixthRoots_sq_ne_one.1
      (rootSquare primitiveSixthRootPositive root)
  have negativeNotRoot :
      ¬monodromy.operator.charpoly.IsRoot primitiveSixthRootNegative := by
    intro root
    exact primitiveSixthRoots_sq_ne_one.2
      (rootSquare primitiveSixthRootNegative root)
  simp [FramedMonodromyMatrix.sixthMultiplicity,
    Polynomial.rootMultiplicity_eq_zero positiveNotRoot,
    Polynomial.rootMultiplicity_eq_zero negativeNotRoot]

/-- Involutivity is one sufficient finite-matrix condition for the exact
characteristic-root restriction used in low-dimensional vanishing.  The human
proof supplies the root restriction directly and does not assert that the
monodromy matrix is involutive. -/
theorem FramedMonodromyMatrix.sixthMultiplicity_eq_zero_of_sq_eq_one
    (monodromy : FramedMonodromyMatrix)
    (involutive : monodromy.operator * monodromy.operator = 1) :
    monodromy.sixthMultiplicity = 0 := by
  apply monodromy.sixthMultiplicity_eq_zero_of_roots_sq_eq_one
  intro value root
  exact charpoly_isRoot_sq_eq_one_of_matrix_sq_eq_one
    monodromy.operator involutive root

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
