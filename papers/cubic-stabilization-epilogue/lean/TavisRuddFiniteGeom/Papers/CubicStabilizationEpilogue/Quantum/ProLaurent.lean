import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.RingTheory.LaurentSeries

/-!
# Pro-Laurent gauges and compatible characteristic polynomials

Each finite level below uses ordinary Laurent series indexed by integers.  A
compatible inverse system therefore permits the Laurent lower bound to vary
with the level, while excluding fractional powers of the loop coordinate by
construction.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u

/-- A compatible inverse system of invertible finite-level Laurent-series
matrices.  The coefficient rings model the quotients `B/F^N B`; the supplied
Laurent-series ring homomorphisms model reduction. -/
structure ProLaurentGaugeSystem (Index : Type*) [Fintype Index]
    [DecidableEq Index] where
  Coefficient : ℕ → Type u
  coefficientRing : ∀ level, CommRing (Coefficient level)
  gauge : ∀ level, Matrix Index Index (LaurentSeries (Coefficient level))
  inverse : ∀ level, Matrix Index Index (LaurentSeries (Coefficient level))
  reduction : ∀ level,
    LaurentSeries (Coefficient (level + 1)) →+*
      LaurentSeries (Coefficient level)
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

/-- For a fixed Laurent coefficient tower, the compatible levelwise general
linear groups form an actual group under pointwise multiplication.  This is
the group object underlying the manuscript's pro-Laurent gauge-group
notation. -/
def proLaurentGaugeGroup
    (Index : Type*) [Fintype Index] [DecidableEq Index]
    (Coefficient : ℕ → Type u) [∀ level, CommRing (Coefficient level)]
    (reduction : ∀ level,
      LaurentSeries (Coefficient (level + 1)) →+*
        LaurentSeries (Coefficient level)) :
    Subgroup (∀ level, Matrix.GeneralLinearGroup Index
      (LaurentSeries (Coefficient level))) where
  carrier gauge := ∀ level,
    Matrix.GeneralLinearGroup.map (reduction level) (gauge (level + 1)) =
      gauge level
  one_mem' := by
    intro level
    simp
  mul_mem' := by
    intro left right leftCompatible rightCompatible level
    change Matrix.GeneralLinearGroup.map (reduction level)
        (left (level + 1) * right (level + 1)) =
      left level * right level
    rw [map_mul, leftCompatible level, rightCompatible level]
  inv_mem' := by
    intro gauge compatible level
    change Matrix.GeneralLinearGroup.map (reduction level)
        (gauge (level + 1))⁻¹ = (gauge level)⁻¹
    rw [map_inv, compatible level]

/-- Compatibility in the pro-Laurent gauge group is literally the adjacent
reduction equation. -/
theorem mem_proLaurentGaugeGroup_iff
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    {Coefficient : ℕ → Type u} [∀ level, CommRing (Coefficient level)]
    {reduction : ∀ level,
      LaurentSeries (Coefficient (level + 1)) →+*
        LaurentSeries (Coefficient level)}
    (gauge : ∀ level, Matrix.GeneralLinearGroup Index
      (LaurentSeries (Coefficient level))) :
    gauge ∈ proLaurentGaugeGroup Index Coefficient reduction ↔
      ∀ level,
        Matrix.GeneralLinearGroup.map (reduction level) (gauge (level + 1)) =
          gauge level :=
  Iff.rfl

/-- A finite-level Laurent lower-bound function has a uniform lower bound
exactly when one integer bounds it at every level.  Pro-Laurent systems do not
assume this predicate. -/
def HasUniformLaurentLowerBound (lowerBound : ℕ → ℤ) : Prop :=
  ∃ bound : ℤ, ∀ level, bound ≤ lowerBound level

/-- Compatible finite-level characteristic polynomials over quotient
coefficient rings.  This is the inverse-system form of the manuscript's
"common finite-level polynomial" condition. -/
structure CompatibleCharacteristicPolynomialSystem where
  Coefficient : ℕ → Type u
  coefficientRing : ∀ level, CommRing (Coefficient level)
  reduction : ∀ level, Coefficient (level + 1) →+* Coefficient level
  characteristicPolynomial : ∀ level, Polynomial (Coefficient level)
  compatible : ∀ level,
    letI := coefficientRing level
    letI := coefficientRing (level + 1)
    (characteristicPolynomial (level + 1)).map (reduction level) =
      characteristicPolynomial level

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
