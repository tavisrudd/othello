import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CompatibleMonodromySystem

/-!
# Compatible finite-level formal base shifts

At every coefficient level, a formal base shift supplies a small
monodromy matrix, a divisor-substitution endomorphism, an invertible gauge, and
the conjugate bulk matrix.  This module records compatibility of the small
matrices, substitutions, gauges, and inverse gauges under reduction.  Lean
then derives compatibility of the bulk matrices and the substituted
characteristic-polynomial identity at every level, together with compatibility
of the bulk characteristic polynomials under reduction.  These polynomials are
packaged as a `CompatibleCharacteristicPolynomialSystem`; at each level its
polynomial is both the bulk characteristic polynomial and the divisor-substituted
small characteristic polynomial.

The filtered coefficient quotients, string and divisor equations, bulk flat
equations, and construction of the finite-level gauges are not represented.
All proofs are symbolic and kernel checked, with no external computation or
oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u v

/-- Compatible finite-level matrix data for a formal base shift. -/
structure FormalBaseShiftSystem
    (Index : Type v) [Fintype Index] [DecidableEq Index] where
  Coefficient : ℕ → Type u
  coefficientRing : ∀ level, CommRing (Coefficient level)
  reduction : ∀ level, Coefficient (level + 1) →+* Coefficient level
  divisorSubstitution : ∀ level, Coefficient level →+* Coefficient level
  substitution_compatible : ∀ level coefficient,
    reduction level (divisorSubstitution (level + 1) coefficient) =
      divisorSubstitution level (reduction level coefficient)
  smallMonodromy : ∀ level, Matrix Index Index (Coefficient level)
  small_compatible : ∀ level row column,
    reduction level (smallMonodromy (level + 1) row column) =
      smallMonodromy level row column
  gauge : ∀ level, Matrix Index Index (Coefficient level)
  inverse : ∀ level, Matrix Index Index (Coefficient level)
  leftInverse : ∀ level,
    letI := coefficientRing level
    gauge level * inverse level = 1
  rightInverse : ∀ level,
    letI := coefficientRing level
    inverse level * gauge level = 1
  gauge_compatible : ∀ level row column,
    reduction level (gauge (level + 1) row column) = gauge level row column
  inverse_compatible : ∀ level row column,
    reduction level (inverse (level + 1) row column) = inverse level row column

namespace FormalBaseShiftSystem

/-- The bulk matrix obtained by coefficient substitution and conjugacy at one
finite level. -/
noncomputable def bulkMonodromy
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : FormalBaseShiftSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    Matrix Index Index (system.Coefficient level) := by
  letI := system.coefficientRing level
  exact system.gauge level *
    (system.smallMonodromy level).map (system.divisorSubstitution level) *
      system.inverse level

/-- Reduction commutes with the entrywise divisor substitution on the small
matrix. -/
theorem map_substitutedSmallMonodromy
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : FormalBaseShiftSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    ((system.smallMonodromy (level + 1)).map
      (system.divisorSubstitution (level + 1))).map (system.reduction level) =
      (system.smallMonodromy level).map (system.divisorSubstitution level) := by
  letI := system.coefficientRing level
  letI := system.coefficientRing (level + 1)
  apply Matrix.ext
  intro row column
  simp only [Matrix.map_apply]
  rw [system.substitution_compatible,
    system.small_compatible]

/-- The finite-level bulk matrices are compatible under coefficient
reduction. -/
theorem bulkMonodromy_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : FormalBaseShiftSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    (system.bulkMonodromy (level + 1)).map (system.reduction level) =
      system.bulkMonodromy level := by
  letI := system.coefficientRing level
  letI := system.coefficientRing (level + 1)
  simp only [bulkMonodromy, Matrix.map_mul]
  have gauge_map : (system.gauge (level + 1)).map
      (system.reduction level) = system.gauge level := by
    apply Matrix.ext
    intro row column
    exact system.gauge_compatible level row column
  have inverse_map : (system.inverse (level + 1)).map
      (system.reduction level) = system.inverse level := by
    apply Matrix.ext
    intro row column
    exact system.inverse_compatible level row column
  rw [gauge_map, system.map_substitutedSmallMonodromy level, inverse_map]

/-- At every finite level, the bulk characteristic polynomial is the divisor
substitution in the small characteristic polynomial. -/
theorem bulkMonodromy_charpoly
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : FormalBaseShiftSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    (system.bulkMonodromy level).charpoly =
      (system.smallMonodromy level).charpoly.map
        (system.divisorSubstitution level) := by
  letI := system.coefficientRing level
  rw [bulkMonodromy]
  calc
    (system.gauge level *
        (system.smallMonodromy level).map (system.divisorSubstitution level) *
          system.inverse level).charpoly =
      (system.inverse level *
        (system.gauge level *
          (system.smallMonodromy level).map
            (system.divisorSubstitution level))).charpoly :=
      Matrix.charpoly_mul_comm _ _
    _ = ((system.smallMonodromy level).map
          (system.divisorSubstitution level)).charpoly := by
      rw [← Matrix.mul_assoc, system.rightInverse, one_mul]
    _ = (system.smallMonodromy level).charpoly.map
          (system.divisorSubstitution level) :=
      framedCharacteristicPolynomial_map _ _

/-- The derived bulk matrices, with the supplied coefficient reductions, form
a compatible matrix system. -/
noncomputable def bulkMatrixSystem
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : FormalBaseShiftSystem Index) :
    CompatibleMonodromyMatrixSystem Index where
  Coefficient := system.Coefficient
  coefficientRing := system.coefficientRing
  reduction := system.reduction
  monodromy := system.bulkMonodromy
  compatible level row column := by
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    exact congrFun (congrFun
      (system.bulkMonodromy_compatible level) row) column

/-- The derived bulk characteristic polynomials are compatible under every
adjacent coefficient reduction. -/
theorem bulkCharacteristicPolynomial_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : FormalBaseShiftSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    ((system.bulkMonodromy (level + 1)).charpoly).map
        (system.reduction level) =
      (system.bulkMonodromy level).charpoly := by
  letI := system.coefficientRing level
  letI := system.coefficientRing (level + 1)
  rw [← framedCharacteristicPolynomial_map,
    system.bulkMonodromy_compatible level]

/-- The derived bulk characteristic polynomials form the explicit compatible
polynomial system associated to the bulk matrices. -/
noncomputable def bulkCharacteristicPolynomialSystem
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : FormalBaseShiftSystem Index) :
    CompatibleCharacteristicPolynomialSystem :=
  system.bulkMatrixSystem.characteristicPolynomialSystem

/-- Every level of the derived polynomial system is both the bulk matrix
characteristic polynomial and the divisor substitution in the small matrix
characteristic polynomial. -/
theorem bulkCharacteristicPolynomialSystem_level
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : FormalBaseShiftSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
        (system.bulkMonodromy level).charpoly ∧
      system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
        (system.smallMonodromy level).charpoly.map
          (system.divisorSubstitution level) := by
  exact ⟨rfl, system.bulkMonodromy_charpoly level⟩

end FormalBaseShiftSystem

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
