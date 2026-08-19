import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FormalBaseShift
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FramedMultiplicity
import Mathlib.Algebra.Polynomial.Roots

/-!
# Framed invariance under the two low-degree bulk shifts

Two shifts of the bulk point of an even quantum connection leave the framed
formal monodromy of the original loop coordinate unchanged, for two different
reasons, and this module isolates the algebra of each.

The first is the shift by a multiple of the identity class.  By the string
equation it changes a solution of the horizontal equation only by a scalar
factor, the irregular twist `exp(-c/z)`, which is single-valued under one turn
of the original loop coordinate.  The algebraic content is that multiplying a
solution frame by a scalar that the turn fixes leaves the monodromy matrix of
that frame unchanged.  This is proved here for a commutative solution algebra
carrying a ring automorphism in the role of the turn, an invertible frame, and
an invertible scalar: the frame relation for the twisted frame forces the same
constant matrix.  No exponential, no irregular type, and no solution of a
differential equation is constructed; single-valuedness is the hypothesis that
the turn fixes the scalar.

The second is the shift by a divisor class.  By the divisor equation it acts on
the connection by the coefficient substitution sending the Novikov monomial of
a curve class to its multiple by the character value at that class.  The
resulting characteristic polynomial is the image of the original one under the
substitution, which is the content of
`TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FormalBaseShiftMatrixInput.characteristicPolynomial_eq`.
What is added here is the last step: an injective coefficient substitution
preserves the algebraic multiplicity of any root it fixes, so a substitution
fixing the complex numbers preserves the multiplicity of every root of unity,
and in particular the primitive-sixth multiplicity.

All proofs are symbolic and kernel checked, with no external computation or
oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

section StringShift

variable {SolutionAlgebra Constant Index : Type*}
  [CommRing SolutionAlgebra] [CommRing Constant] [Algebra Constant SolutionAlgebra]
  [Fintype Index] [DecidableEq Index]

omit [DecidableEq Index] in
/-- A scalar twist that the turn fixes carries a solution frame to a frame with
the same monodromy matrix.  Here `turn` plays the role of one turn of the
original loop coordinate, `frame` of a fundamental solution matrix, and the
frame relation `frame.map turn = frame * monodromy` of the definition of the
framed monodromy of that frame. -/
theorem turn_frame_of_invariant_scalarTwist
    (turn : SolutionAlgebra ≃+* SolutionAlgebra)
    (frame : Matrix Index Index SolutionAlgebra)
    (twist : SolutionAlgebra) (invariant : turn twist = twist)
    (monodromy : Matrix Index Index Constant)
    (frameTurn : frame.map turn = frame * monodromy.map (algebraMap Constant SolutionAlgebra)) :
    (twist • frame).map turn =
      (twist • frame) * monodromy.map (algebraMap Constant SolutionAlgebra) := by
  have twisted : (twist • frame).map turn = twist • frame.map turn := by
    ext row column
    simp [Matrix.map_apply, invariant, map_mul]
  rw [twisted, frameTurn, Matrix.smul_mul]

/-- The framed monodromy matrix is unchanged by a scalar twist that the turn
fixes.  The frame and the twist are invertible, and the constants embed
injectively in the solution algebra, so the monodromy matrix of the twisted
frame is the monodromy matrix of the original frame. -/
theorem framedMonodromy_eq_of_invariant_scalarTwist
    (turn : SolutionAlgebra ≃+* SolutionAlgebra)
    (frame : (Matrix Index Index SolutionAlgebra)ˣ)
    (twist : SolutionAlgebraˣ) (invariant : turn twist.val = twist.val)
    (monodromy twistedMonodromy : Matrix Index Index Constant)
    (constantsInjective : Function.Injective (algebraMap Constant SolutionAlgebra))
    (frameTurn : frame.val.map turn =
      frame.val * monodromy.map (algebraMap Constant SolutionAlgebra))
    (twistedTurn : (twist.val • frame.val).map turn =
      (twist.val • frame.val) * twistedMonodromy.map (algebraMap Constant SolutionAlgebra)) :
    twistedMonodromy = monodromy := by
  have equalProducts :
      (twist.val • frame.val) * twistedMonodromy.map (algebraMap Constant SolutionAlgebra) =
        (twist.val • frame.val) * monodromy.map (algebraMap Constant SolutionAlgebra) := by
    rw [← twistedTurn]
    exact turn_frame_of_invariant_scalarTwist turn frame.val twist.val invariant monodromy frameTurn
  have cancelFrame :
      twist.val • twistedMonodromy.map (algebraMap Constant SolutionAlgebra) =
        twist.val • monodromy.map (algebraMap Constant SolutionAlgebra) := by
    have := congrArg (fun product => frame.inv * product) equalProducts
    simpa [Matrix.smul_mul, Matrix.mul_smul, ← Matrix.mul_assoc, frame.inv_mul] using this
  have cancelTwist :
      twistedMonodromy.map (algebraMap Constant SolutionAlgebra) =
        monodromy.map (algebraMap Constant SolutionAlgebra) := by
    have := congrArg (fun matrix => twist.inv • matrix) cancelFrame
    simpa [smul_smul, twist.inv_val] using this
  ext row column
  exact constantsInjective (congrFun (congrFun (congrArg Matrix.of cancelTwist) row) column)

end StringShift

section DivisorShift

/-- An injective coefficient substitution preserves the algebraic multiplicity
of a root it fixes. -/
theorem rootMultiplicity_map_of_fixed_root
    {Coefficient Target : Type*} [CommRing Coefficient] [CommRing Target]
    (substitution : Coefficient →+* Target)
    (injective : Function.Injective substitution)
    (polynomial : Polynomial Coefficient) {root : Coefficient} {image : Target}
    (fixed : substitution root = image) :
    (polynomial.map substitution).rootMultiplicity image =
      polynomial.rootMultiplicity root := by
  subst fixed
  exact (Polynomial.eq_rootMultiplicity_map injective root).symm

/-- The primitive-sixth multiplicity of the framed characteristic polynomial is
unchanged by a divisor shift.  The bulk monodromy is the substituted small
monodromy up to an invertible frame gauge, and the substitution is injective
and fixes both primitive sixth roots of unity, as a substitution fixing the
complex numbers does. -/
theorem sixthMultiplicity_eq_of_divisorShift
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (input : FormalBaseShiftMatrixInput Index ℂ)
    (injective : Function.Injective input.divisorSubstitution)
    (fixesPositive : input.divisorSubstitution primitiveSixthRootPositive =
      primitiveSixthRootPositive)
    (fixesNegative : input.divisorSubstitution primitiveSixthRootNegative =
      primitiveSixthRootNegative) :
    sixthMultiplicityPolynomial input.bulkMonodromy.charpoly =
      sixthMultiplicityPolynomial input.smallMonodromy.charpoly := by
  rw [sixthMultiplicityPolynomial, sixthMultiplicityPolynomial,
    input.characteristicPolynomial_eq,
    rootMultiplicity_map_of_fixed_root input.divisorSubstitution injective _ fixesPositive,
    rootMultiplicity_map_of_fixed_root input.divisorSubstitution injective _ fixesNegative]

end DivisorShift

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
