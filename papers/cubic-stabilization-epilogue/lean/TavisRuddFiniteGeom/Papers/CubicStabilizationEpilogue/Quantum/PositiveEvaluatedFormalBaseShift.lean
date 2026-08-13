import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.PositiveFiltrationLaurentEvaluation
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FormalBaseShiftSystem

/-!
# Formal base shift from a filtration-positive evaluated flat gauge

Let a commutative rational algebra carry a normalized multiplicative ideal
filtration, finitely many level-one bulk parameters, and an ordinary-Laurent-
valued multivariable connection satisfying the exact coefficientwise
zero-curvature equations.  The normalized formal flat solution can be
evaluated at every quotient level by the finite substitution ring homomorphism.
The resulting matrices and their chosen inverses are compatible under
reduction.

This module inserts those constructed gauges into the finite-level formal
base-shift matrix packet.  The compatible small monodromy matrices and divisor
substitutions remain supplied data.  Lean derives the compatible bulk matrices,
their characteristic-polynomial substitution identity, and the compatible
bulk characteristic-polynomial system.  No geometric quantum connection,
string or divisor equation, analytic monodromy, or geometric comparison theorem is
constructed.  The proofs are symbolic and kernel checked, with no external
computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u v w

/-- Filtered connection data together with the remaining supplied small-
monodromy and divisor-substitution inputs for a formal base shift. -/
structure PositiveEvaluatedFormalBaseShiftInput
    (Coordinate : Type u) (Index : Type v) (B : Type w)
    [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B] where
  filtration : MultiplicativeIdealFiltration B
  parameter : Coordinate → B
  positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1
  connection : Coordinate → Matrix Index Index
    (MvPowerSeries Coordinate (LaurentSeries B))
  curvature : ∀ first second,
    (connection second).map (multivariablePartialDerivative first) -
        (connection first).map (multivariablePartialDerivative second) +
        connection first * connection second -
        connection second * connection first = 0
  divisorSubstitution : ∀ level,
    LaurentSeries (filtration.toDecreasingIdealFiltration.QuotientRing level) →+*
      LaurentSeries (filtration.toDecreasingIdealFiltration.QuotientRing level)
  substitution_compatible : ∀ level coefficient,
    filtration.positiveLaurentReduction level
        (divisorSubstitution (level + 1) coefficient) =
      divisorSubstitution level
        (filtration.positiveLaurentReduction level coefficient)
  smallMonodromy : ∀ level, Matrix Index Index
    (LaurentSeries (filtration.toDecreasingIdealFiltration.QuotientRing level))
  small_compatible : ∀ level row column,
    filtration.positiveLaurentReduction level
        (smallMonodromy (level + 1) row column) =
      smallMonodromy level row column

namespace PositiveEvaluatedFormalBaseShiftInput

/-- The formal-base-shift system whose gauge and inverse are constructed from
the evaluated normalized flat solution. -/
noncomputable def formalBaseShiftSystem
    {Coordinate Index B : Type*}
    [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : PositiveEvaluatedFormalBaseShiftInput Coordinate Index B) :
    FormalBaseShiftSystem Index where
  Coefficient level := LaurentSeries
    (input.filtration.toDecreasingIdealFiltration.QuotientRing level)
  coefficientRing level := inferInstance
  reduction level := input.filtration.positiveLaurentReduction level
  divisorSubstitution level := input.divisorSubstitution level
  substitution_compatible := input.substitution_compatible
  smallMonodromy level := input.smallMonodromy level
  small_compatible := input.small_compatible
  gauge level := input.filtration.positiveEvaluatedFlatGaugeAtLevel
    input.parameter level input.connection
  inverse level := input.filtration.positiveEvaluatedFlatGaugeInverseAtLevel
    input.parameter input.positive level input.connection
  leftInverse level :=
    (input.filtration.positiveEvaluatedFlatGaugeAtLevel_inverse
      input.parameter input.positive level input.connection).1
  rightInverse level :=
    (input.filtration.positiveEvaluatedFlatGaugeAtLevel_inverse
      input.parameter input.positive level input.connection).2
  gauge_compatible level row column := by
    have compatibility :=
      input.filtration.positiveEvaluatedFlatGaugeAtLevel_compatible
        input.parameter input.positive level input.connection
    exact congrArg (fun matrix ↦ matrix row column) compatibility
  inverse_compatible level row column := by
    have compatibility :=
      input.filtration.positiveEvaluatedFlatGaugeInverseAtLevel_compatible
        input.parameter input.positive level input.connection
    exact congrArg (fun matrix ↦ matrix row column) compatibility

/-- The constructed formal-base-shift system uses exactly the finite evaluated
gauges and their chosen inverses. -/
theorem formalBaseShiftSystem_gauge_inverse
    {Coordinate Index B : Type*}
    [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : PositiveEvaluatedFormalBaseShiftInput Coordinate Index B)
    (level : ℕ) :
    input.formalBaseShiftSystem.gauge level =
        input.filtration.positiveEvaluatedFlatGaugeAtLevel
          input.parameter level input.connection ∧
      input.formalBaseShiftSystem.inverse level =
        input.filtration.positiveEvaluatedFlatGaugeInverseAtLevel
          input.parameter input.positive level input.connection :=
  ⟨rfl, rfl⟩

/-- The constructed evaluated gauges give the full finite-level bulk matrix
and characteristic-polynomial packet. -/
theorem bulkSystemConclusion
    {Coordinate Index B : Type*}
    [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : PositiveEvaluatedFormalBaseShiftInput Coordinate Index B) :
    (∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      letI := input.formalBaseShiftSystem.coefficientRing (level + 1)
      (input.formalBaseShiftSystem.bulkMonodromy (level + 1)).map
          (input.filtration.positiveLaurentReduction level) =
        input.formalBaseShiftSystem.bulkMonodromy level) ∧
    (∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      (input.formalBaseShiftSystem.bulkMonodromy level).charpoly =
        (input.smallMonodromy level).charpoly.map
          (input.divisorSubstitution level)) ∧
    (∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      letI := input.formalBaseShiftSystem.coefficientRing (level + 1)
      (input.formalBaseShiftSystem.bulkMonodromy (level + 1)).charpoly.map
          (input.filtration.positiveLaurentReduction level) =
        (input.formalBaseShiftSystem.bulkMonodromy level).charpoly) ∧
    ∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
          (input.formalBaseShiftSystem.bulkMonodromy level).charpoly ∧
        input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
          (input.smallMonodromy level).charpoly.map
            (input.divisorSubstitution level) := by
  exact ⟨input.formalBaseShiftSystem.bulkMonodromy_compatible,
    input.formalBaseShiftSystem.bulkMonodromy_charpoly,
    input.formalBaseShiftSystem.bulkCharacteristicPolynomial_compatible,
    input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem_level⟩

end PositiveEvaluatedFormalBaseShiftInput

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
