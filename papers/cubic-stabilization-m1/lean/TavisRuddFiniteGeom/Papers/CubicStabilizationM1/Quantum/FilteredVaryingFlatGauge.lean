import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompatibleVaryingFlatGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredCoefficientQuotients
import Mathlib.Algebra.Algebra.Hom.Rat

/-!
# Varying formal flat gauges over an ideal-quotient tower

Let `R` be a commutative `ℚ`-algebra with a decreasing natural-number-indexed
ideal filtration, and let `Aₙ` be the coefficients of a one-variable square
matrix connection over `R`.  This module maps every `Aₙ` into each quotient
`R/F^level`, uses the canonical adjacent quotient reductions, and obtains the
compatible normalized formal solutions of `dG/dt=-A(t)G(t)` from the general
varying-gauge construction.  Lean proves that the quotient connection and
gauge series reduce compatibly, and that the solution at every level is unique
and invertible.

The base ring, filtration, and connection coefficients are supplied.  Lean
does not identify them with the manuscript's geometric coefficient ring,
filtration, or quantum product.  No multivariable bulk coordinates, Laurent
loop parameter, bounded Laurent order, convergence, or analytic gauge is
represented.  The proofs are symbolic and kernel checked, with no external
computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

universe u v

/-- A one-variable matrix connection over a rational algebra equipped with a
decreasing ideal filtration. -/
structure FilteredVaryingFlatGaugeInput
    (Index : Type v) [Fintype Index] [DecidableEq Index]
    (R : Type u) [CommRing R] [Algebra ℚ R] where
  filtration : DecreasingIdealFiltration R
  connectionCoefficient : ℕ → Matrix Index Index R

namespace FilteredVaryingFlatGaugeInput

/-- The compatible varying-connection system obtained by mapping the supplied
connection coefficients into every ideal quotient. -/
noncomputable def compatibleSystem
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (input : FilteredVaryingFlatGaugeInput Index R) :
    CompatibleVaryingConnectionSystem Index where
  Coefficient level := input.filtration.QuotientRing level
  coefficientRing _ := inferInstance
  coefficientAlgebra _ := inferInstance
  reduction level := (input.filtration.reduction level).toRatAlgHom
  connectionCoefficient level degree :=
    (input.connectionCoefficient degree).map
      (Ideal.Quotient.mk (input.filtration.ideal level))
  connection_compatible level degree := by
    ext row column
    exact input.filtration.reduction_mk level
      (input.connectionCoefficient degree row column)

/-- The normalized varying flat-gauge series over the quotient at a specified
filtration level. -/
noncomputable def gaugeSeries
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (input : FilteredVaryingFlatGaugeInput Index R) (level : ℕ) :
    Matrix Index Index
      (PowerSeries (input.filtration.QuotientRing level)) :=
  input.compatibleSystem.gaugeSeries level

/-- The one-variable connection series over the quotient at a specified
filtration level. -/
noncomputable def connectionSeries
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (input : FilteredVaryingFlatGaugeInput Index R) (level : ℕ) :
    Matrix Index Index
      (PowerSeries (input.filtration.QuotientRing level)) :=
  input.compatibleSystem.connectionSeries level

/-- The quotient-tower connection and normalized gauge series commute with
canonical adjacent reductions. -/
theorem series_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (input : FilteredVaryingFlatGaugeInput Index R) (level : ℕ) :
    (input.connectionSeries (level + 1)).map
        (PowerSeries.map (input.filtration.reduction level)) =
      input.connectionSeries level ∧
    (input.gaugeSeries (level + 1)).map
        (PowerSeries.map (input.filtration.reduction level)) =
      input.gaugeSeries level := by
  have connectionCompatibility :=
    input.compatibleSystem.connectionSeries_compatible level
  have gaugeCompatibility := input.compatibleSystem.gaugeSeries_compatible level
  exact ⟨connectionCompatibility, gaugeCompatibility⟩

/-- At every quotient level, the constructed gauge is the unique normalized
formal solution of the quotient connection and is an invertible matrix over
the quotient power-series ring. -/
theorem gaugeSeries_unique_and_isUnit
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (input : FilteredVaryingFlatGaugeInput Index R) (level : ℕ) :
    (input.gaugeSeries level).map (PowerSeries.coeff 0) = 1 ∧
      (input.gaugeSeries level).map PowerSeries.derivativeFun =
        -(input.connectionSeries level) * input.gaugeSeries level ∧
      (∀ candidate : Matrix Index Index
          (PowerSeries (input.filtration.QuotientRing level)),
        candidate.map (PowerSeries.coeff 0) = 1 →
        candidate.map PowerSeries.derivativeFun =
          -(input.connectionSeries level) * candidate →
        candidate = input.gaugeSeries level) ∧
      IsUnit (input.gaugeSeries level) := by
  have normalization :
      (input.gaugeSeries level).map (PowerSeries.coeff 0) = 1 := by
    letI := input.compatibleSystem.coefficientRing level
    letI := input.compatibleSystem.coefficientAlgebra level
    change (varyingFlatGaugeSeries
      (input.compatibleSystem.connectionCoefficient level)).map
        (PowerSeries.coeff 0) = 1
    rw [varyingFlatGaugeSeries_coefficient,
      varyingFlatGaugeCoefficient_zero]
  exact ⟨normalization,
    input.compatibleSystem.gaugeSeries_derivative level,
    fun candidate normalized flatEquation ↦
      input.compatibleSystem.gaugeSeries_unique level candidate
        normalized flatEquation,
    input.compatibleSystem.gaugeSeries_isUnit level⟩

end FilteredVaryingFlatGaugeInput

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
