import Mathlib.Analysis.Complex.Exponential
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.Algebra.Polynomial.Div

/-!
# Primitive-sixth multiplicity of a framed monodromy matrix

This module formalizes the algebraic-multiplicity definition once the framed
formal-monodromy operator has been supplied as a finite complex matrix.  It
does not construct that matrix from a quantum connection or a
Levelt--Turrittin solution algebra.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

/-- The primitive sixth root `exp(π i / 3)` used in the manuscript. -/
noncomputable def primitiveSixthRootPositive : ℂ :=
  Complex.exp (Real.pi * Complex.I / 3)

/-- The conjugate primitive sixth root `exp(-π i / 3)` used in the manuscript. -/
noncomputable def primitiveSixthRootNegative : ℂ :=
  Complex.exp (-(Real.pi * Complex.I) / 3)

/-- A framed formal-monodromy operator on a labelled finite-dimensional
complex vector space.  The word "framed" records that this is the operator
for one turn of the original, unramified loop coordinate; the structure does
not construct that operator from a differential module. -/
structure FramedMonodromyMatrix where
  rank : ℕ
  operator : Matrix (Fin rank) (Fin rank) ℂ

/-- The sum of the algebraic multiplicities of the two primitive sixth roots
in the characteristic polynomial of a supplied framed-monodromy matrix. -/
noncomputable def FramedMonodromyMatrix.sixthMultiplicity
    (monodromy : FramedMonodromyMatrix) : ℕ :=
  monodromy.operator.charpoly.rootMultiplicity primitiveSixthRootPositive +
    monodromy.operator.charpoly.rootMultiplicity primitiveSixthRootNegative

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
