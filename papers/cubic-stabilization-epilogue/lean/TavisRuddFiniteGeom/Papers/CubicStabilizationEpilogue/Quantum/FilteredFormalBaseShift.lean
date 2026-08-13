import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FilteredCoefficientQuotients
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FormalBaseShiftSystem

/-!
# Formal base shifts over filtered quotient rings

This module connects a decreasing ideal filtration to the finite-level formal
base-shift matrix packet.  The coefficient ring at level `n` is the actual
ideal quotient `R / I_n`, its reduction is the canonical quotient map, and the
divisor substitution is induced by one filtration-preserving endomorphism of
`R`.  Compatible small matrices and two-sided-invertible gauges over these
quotients then produce the compatible bulk matrix and characteristic-polynomial
systems.

The filtered base ring, its endomorphism, the matrix and gauge families, and
all their compatibility and inverse identities are supplied.  No string or
divisor equation, bulk flat solution, analytic gauge, or geometric
specialization is constructed.  All proofs are symbolic and kernel checked,
with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u v

/-- Matrix and gauge data over the actual quotient tower of a decreasing ideal
filtration. -/
structure FilteredFormalBaseShiftInput
    (Index : Type v) [Fintype Index] [DecidableEq Index]
    (R : Type u) [CommRing R]
    (filtration : DecreasingIdealFiltration R)
    (endomorphism : filtration.PreservingEndomorphism) where
  smallMonodromy : ∀ level,
    Matrix Index Index (filtration.QuotientRing level)
  small_compatible : ∀ level row column,
    filtration.reduction level (smallMonodromy (level + 1) row column) =
      smallMonodromy level row column
  gauge : ∀ level, Matrix Index Index (filtration.QuotientRing level)
  inverse : ∀ level, Matrix Index Index (filtration.QuotientRing level)
  leftInverse : ∀ level, gauge level * inverse level = 1
  rightInverse : ∀ level, inverse level * gauge level = 1
  gauge_compatible : ∀ level row column,
    filtration.reduction level (gauge (level + 1) row column) =
      gauge level row column
  inverse_compatible : ∀ level row column,
    filtration.reduction level (inverse (level + 1) row column) =
      inverse level row column

namespace FilteredFormalBaseShiftInput

/-- The formal base-shift system whose coefficient data are constructed from
the filtered quotient tower. -/
noncomputable def formalBaseShiftSystem
    {Index : Type v} [Fintype Index] [DecidableEq Index]
    {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R}
    {endomorphism : filtration.PreservingEndomorphism}
    (input : FilteredFormalBaseShiftInput Index R filtration endomorphism) :
    FormalBaseShiftSystem Index where
  Coefficient := filtration.QuotientRing
  coefficientRing := fun _ => inferInstance
  reduction := filtration.reduction
  divisorSubstitution := endomorphism.quotientEndomorphism
  substitution_compatible :=
    endomorphism.reduction_quotientEndomorphism
  smallMonodromy := input.smallMonodromy
  small_compatible := input.small_compatible
  gauge := input.gauge
  inverse := input.inverse
  leftInverse := input.leftInverse
  rightInverse := input.rightInverse
  gauge_compatible := input.gauge_compatible
  inverse_compatible := input.inverse_compatible

/-- Filtered quotient data plus compatible matrix and gauge families determine
compatible bulk matrices and an explicit compatible characteristic-polynomial
system.  Each level is both the bulk characteristic polynomial and the image of
the small characteristic polynomial under the induced quotient endomorphism. -/
theorem bulkSystem_compatible_and_characteristicPolynomial
    {Index : Type v} [Fintype Index] [DecidableEq Index]
    {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R}
    {endomorphism : filtration.PreservingEndomorphism}
    (input : FilteredFormalBaseShiftInput Index R filtration endomorphism) :
    (∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      letI := input.formalBaseShiftSystem.coefficientRing (level + 1)
      ((input.formalBaseShiftSystem.bulkMonodromy (level + 1)).map
        (filtration.reduction level)) =
          input.formalBaseShiftSystem.bulkMonodromy level) ∧
      (∀ level,
        letI := input.formalBaseShiftSystem.coefficientRing level
        (input.formalBaseShiftSystem.bulkMonodromy level).charpoly =
          (input.smallMonodromy level).charpoly.map
            (endomorphism.quotientEndomorphism level)) ∧
      (∀ level,
        letI := input.formalBaseShiftSystem.coefficientRing level
        letI := input.formalBaseShiftSystem.coefficientRing (level + 1)
        ((input.formalBaseShiftSystem.bulkMonodromy (level + 1)).charpoly).map
            (filtration.reduction level) =
          (input.formalBaseShiftSystem.bulkMonodromy level).charpoly) ∧
      (∀ level,
        letI := input.formalBaseShiftSystem.coefficientRing level
        (input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem).characteristicPolynomial
              level =
            (input.formalBaseShiftSystem.bulkMonodromy level).charpoly ∧
          (input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem).characteristicPolynomial
              level =
            (input.smallMonodromy level).charpoly.map
              (endomorphism.quotientEndomorphism level)) :=
  ⟨input.formalBaseShiftSystem.bulkMonodromy_compatible,
    input.formalBaseShiftSystem.bulkMonodromy_charpoly,
    input.formalBaseShiftSystem.bulkCharacteristicPolynomial_compatible,
    input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem_level⟩

end FilteredFormalBaseShiftInput

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
