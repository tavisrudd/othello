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

When the supplied filtration is normalized and multiplicative, the same
finite-level construction retains the premises `F⁰R = R` and
`FᵐR · FⁿR ⊆ Fᵐ⁺ⁿR` in its stated conclusion.  Lean does not prove that a
particular geometric coefficient filtration has this structure.

For the adic filtration of one ideal, it is enough to supply a ring
endomorphism preserving that ideal.  Lean proves preservation of every ideal
power, constructs the induced quotient substitutions, and combines these with
the supplied matrix and gauge families.  The same construction also retains
the multiplicative lower-bound law for the adic filtration.
This separate adic model is not identified with the manuscript's
coefficient filtration or divisor substitution.

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

namespace MultiplicativeIdealFiltration

/-- The algebraic conclusion obtained from a normalized multiplicative ideal
filtration and compatible finite-level matrix and gauge data. -/
def FormalBaseShiftConclusion
    {Index : Type v} [Fintype Index] [DecidableEq Index]
    {R : Type u} [CommRing R]
    (filtration : MultiplicativeIdealFiltration R)
    {endomorphism : filtration.toDecreasingIdealFiltration.PreservingEndomorphism}
    (input : FilteredFormalBaseShiftInput Index R
      filtration.toDecreasingIdealFiltration endomorphism) : Prop :=
    filtration.toDecreasingIdealFiltration.ideal 0 = ⊤ ∧
      (∀ left right leftOrder rightOrder,
        left ∈ filtration.toDecreasingIdealFiltration.ideal leftOrder →
        right ∈ filtration.toDecreasingIdealFiltration.ideal rightOrder →
        left * right ∈
          filtration.toDecreasingIdealFiltration.ideal
            (leftOrder + rightOrder)) ∧
      (∀ level,
        letI := input.formalBaseShiftSystem.coefficientRing level
        letI := input.formalBaseShiftSystem.coefficientRing (level + 1)
        ((input.formalBaseShiftSystem.bulkMonodromy (level + 1)).map
          (filtration.toDecreasingIdealFiltration.reduction level)) =
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
            (filtration.toDecreasingIdealFiltration.reduction level) =
          (input.formalBaseShiftSystem.bulkMonodromy level).charpoly) ∧
      (∀ level,
        letI := input.formalBaseShiftSystem.coefficientRing level
        (input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem).characteristicPolynomial
              level =
            (input.formalBaseShiftSystem.bulkMonodromy level).charpoly ∧
          (input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem).characteristicPolynomial
              level =
            (input.smallMonodromy level).charpoly.map
              (endomorphism.quotientEndomorphism level))

/-- A supplied normalized multiplicative ideal filtration retains its unit and
product laws while its quotient tower and compatible matrix/gauge data produce
the stated bulk matrix and characteristic-polynomial system. -/
theorem formalBaseShiftConclusion
    {Index : Type v} [Fintype Index] [DecidableEq Index]
    {R : Type u} [CommRing R]
    (filtration : MultiplicativeIdealFiltration R)
    {endomorphism : filtration.toDecreasingIdealFiltration.PreservingEndomorphism}
    (input : FilteredFormalBaseShiftInput Index R
      filtration.toDecreasingIdealFiltration endomorphism) :
    FormalBaseShiftConclusion filtration input :=
  ⟨filtration.ideal_zero,
    fun _ _ _ _ hleft hright => filtration.mul_mem hleft hright,
    input.bulkSystem_compatible_and_characteristicPolynomial⟩

end MultiplicativeIdealFiltration

/-- Matrix and gauge data over the adic quotient tower of one ideal.  The
endomorphism is required to preserve only the generating ideal; preservation
of every power is derived. -/
structure AdicFormalBaseShiftInput
    (Index : Type v) [Fintype Index] [DecidableEq Index]
    (R : Type u) [CommRing R]
    (ideal : Ideal R) (endomorphism : R →+* R) where
  preserves : ∀ value, value ∈ ideal → endomorphism value ∈ ideal
  smallMonodromy : ∀ level,
    Matrix Index Index ((adicFiltration ideal).QuotientRing level)
  small_compatible : ∀ level row column,
    (adicFiltration ideal).reduction level
        (smallMonodromy (level + 1) row column) =
      smallMonodromy level row column
  gauge : ∀ level, Matrix Index Index ((adicFiltration ideal).QuotientRing level)
  inverse : ∀ level, Matrix Index Index ((adicFiltration ideal).QuotientRing level)
  leftInverse : ∀ level, gauge level * inverse level = 1
  rightInverse : ∀ level, inverse level * gauge level = 1
  gauge_compatible : ∀ level row column,
    (adicFiltration ideal).reduction level (gauge (level + 1) row column) =
      gauge level row column
  inverse_compatible : ∀ level row column,
    (adicFiltration ideal).reduction level (inverse (level + 1) row column) =
      inverse level row column

namespace AdicFormalBaseShiftInput

/-- Regard adic matrix and gauge data as filtered formal-base-shift data.  The
quotient substitution is constructed from preservation of the generating
ideal. -/
noncomputable def filteredInput
    {Index : Type v} [Fintype Index] [DecidableEq Index]
    {R : Type u} [CommRing R]
    {ideal : Ideal R} {endomorphism : R →+* R}
    (input : AdicFormalBaseShiftInput Index R ideal endomorphism) :
    FilteredFormalBaseShiftInput Index R (adicFiltration ideal)
      (DecreasingIdealFiltration.adicPreservingEndomorphism
        ideal endomorphism input.preserves) where
  smallMonodromy := input.smallMonodromy
  small_compatible := input.small_compatible
  gauge := input.gauge
  inverse := input.inverse
  leftInverse := input.leftInverse
  rightInverse := input.rightInverse
  gauge_compatible := input.gauge_compatible
  inverse_compatible := input.inverse_compatible

/-- The packaged algebraic conclusion attached to adic formal-base-shift
input: multiplicative filtration, preservation of every power, compatible bulk
matrices, and the two descriptions of the compatible characteristic-polynomial
system. -/
def BulkSystemConclusion
    {Index : Type v} [Fintype Index] [DecidableEq Index]
    {R : Type u} [CommRing R]
    {ideal : Ideal R} {endomorphism : R →+* R}
    (input : AdicFormalBaseShiftInput Index R ideal endomorphism) : Prop :=
    (∀ left right leftOrder rightOrder,
      left ∈ ideal ^ leftOrder → right ∈ ideal ^ rightOrder →
        left * right ∈ ideal ^ (leftOrder + rightOrder)) ∧
      (∀ order value, value ∈ ideal ^ order →
        endomorphism value ∈ ideal ^ order) ∧
      (∀ level,
        let system := input.filteredInput.formalBaseShiftSystem
        letI := system.coefficientRing level
        letI := system.coefficientRing (level + 1)
        (system.bulkMonodromy (level + 1)).map
            ((adicFiltration ideal).reduction level) =
          system.bulkMonodromy level) ∧
      (∀ level,
        let system := input.filteredInput.formalBaseShiftSystem
        letI := system.coefficientRing level
        (system.bulkMonodromy level).charpoly =
          (input.smallMonodromy level).charpoly.map
            ((DecreasingIdealFiltration.adicPreservingEndomorphism
              ideal endomorphism input.preserves).quotientEndomorphism level)) ∧
      (∀ level,
        let system := input.filteredInput.formalBaseShiftSystem
        letI := system.coefficientRing level
        letI := system.coefficientRing (level + 1)
        ((system.bulkMonodromy (level + 1)).charpoly).map
            ((adicFiltration ideal).reduction level) =
          (system.bulkMonodromy level).charpoly) ∧
      (∀ level,
        let system := input.filteredInput.formalBaseShiftSystem
        letI := system.coefficientRing level
        system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
            (system.bulkMonodromy level).charpoly ∧
          system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
            (input.smallMonodromy level).charpoly.map
              ((DecreasingIdealFiltration.adicPreservingEndomorphism
                ideal endomorphism input.preserves).quotientEndomorphism level))

/-- Adic matrix and gauge data produce the listed compatible finite-level bulk
matrix and characteristic-polynomial packet.  Lean derives the quotient
substitutions from preservation of the generating ideal and separately proves
the multiplicative lower-bound law for the adic filtration. -/
theorem bulkSystem_compatible_and_characteristicPolynomial
    {Index : Type v} [Fintype Index] [DecidableEq Index]
    {R : Type u} [CommRing R]
    {ideal : Ideal R} {endomorphism : R →+* R}
    (input : AdicFormalBaseShiftInput Index R ideal endomorphism) :
    BulkSystemConclusion input := by
  refine ⟨?_, ?_, input.filteredInput.bulkSystem_compatible_and_characteristicPolynomial⟩
  · intro left right leftOrder rightOrder hleft hright
    exact adicFiltration_mul_mem_add ideal hleft hright
  · exact (DecreasingIdealFiltration.adicPreservingEndomorphism
      ideal endomorphism input.preserves).maps_mem

end AdicFormalBaseShiftInput

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
