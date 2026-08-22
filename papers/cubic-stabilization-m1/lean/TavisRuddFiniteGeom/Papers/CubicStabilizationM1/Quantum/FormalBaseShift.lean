import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MonodromyBaseChange

/-!
# Algebraic tail of the formal base-shift argument

The string/divisor equations and finite-level bulk differential equations are
responsible for producing the comparison datum below.  Once that datum is
available, characteristic-polynomial invariance is a finite-matrix
consequence proved here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

/-- Exact matrix data produced by a formal base shift: the bulk monodromy is
an invertible conjugate of the small monodromy after the fixed-divisor
coefficient substitution. -/
structure FormalBaseShiftMatrixInput
    (Index Coefficient : Type*) [Fintype Index] [DecidableEq Index]
    [CommRing Coefficient] where
  smallMonodromy : Matrix Index Index Coefficient
  bulkMonodromy : Matrix Index Index Coefficient
  divisorSubstitution : Coefficient →+* Coefficient
  integralFrameGauge : (Matrix Index Index Coefficient)ˣ
  comparison :
    bulkMonodromy = integralFrameGauge.val *
      smallMonodromy.map divisorSubstitution * integralFrameGauge.val⁻¹

/-- The formal-base-shift matrix input implies the manuscript's
characteristic-polynomial conclusion after divisor substitution. -/
theorem FormalBaseShiftMatrixInput.characteristicPolynomial_eq
    {Index Coefficient : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing Coefficient]
    (input : FormalBaseShiftMatrixInput Index Coefficient) :
    input.bulkMonodromy.charpoly =
      input.smallMonodromy.charpoly.map input.divisorSubstitution := by
  rw [input.comparison]
  exact framedCharacteristicPolynomial_map_and_conjugate
    input.smallMonodromy input.divisorSubstitution input.integralFrameGauge

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
