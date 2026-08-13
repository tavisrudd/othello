import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FramedMultiplicity
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Tactic

/-!
# Arithmetic core of the cubic rank-two packet

This module verifies the factorization of Cai's displayed indicial polynomial
and converts its two exponents into the two primitive-sixth framed-monodromy
eigenvalues.  It does not formalize Cai's integral-`z` block diagonalization
of the cubic quantum connection or the other two rank-one blocks.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Polynomial

/-- Cai's rank-two indicial polynomial `ρ²+ρ+5/36`. -/
noncomputable def cubicIndicialPolynomial : Polynomial ℚ :=
  X ^ 2 + X + C (5 / 36)

/-- Exact factorization of the cubic rank-two indicial polynomial. -/
theorem cubicIndicialPolynomial_factorization :
    cubicIndicialPolynomial =
      (X - C (-1 / 6)) * (X - C (-5 / 6)) := by
  norm_num [cubicIndicialPolynomial]
  have coefficientSum :
      C (1 / 6 : ℚ) + C (5 / 6 : ℚ) = (1 : Polynomial ℚ) := by
    rw [← C_add]
    norm_num
  have constantProduct :
      C (1 / 6 : ℚ) * C (5 / 6 : ℚ) = C (5 / 36 : ℚ) := by
    rw [← C_mul]
    norm_num
  rw [show (X + C (1 / 6 : ℚ)) * (X + C (5 / 6 : ℚ)) =
      X ^ 2 + (C (1 / 6 : ℚ) + C (5 / 6 : ℚ)) * X +
        C (1 / 6 : ℚ) * C (5 / 6 : ℚ) by ring]
  rw [coefficientSum, constantProduct]
  ring

/-- The exponent `-1/6` gives the negative primitive-sixth eigenvalue for one
turn of the original loop coordinate. -/
theorem cubicExponent_neg_one_sixth :
    Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (-1 / 6)) =
      primitiveSixthRootNegative := by
  unfold primitiveSixthRootNegative
  congr 1
  ring

/-- The exponent `-5/6` gives the positive primitive-sixth eigenvalue for one
turn of the original loop coordinate. -/
theorem cubicExponent_neg_five_sixths :
    Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (-5 / 6)) =
      primitiveSixthRootPositive := by
  unfold primitiveSixthRootPositive
  have exponentIdentity :
      2 * (Real.pi : ℂ) * Complex.I * (-5 / 6) =
        (Real.pi * Complex.I / 3) - 2 * Real.pi * Complex.I := by
    ring
  rw [exponentIdentity, sub_eq_add_neg, Complex.exp_add, Complex.exp_neg,
    Complex.exp_two_pi_mul_I]
  simp

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
