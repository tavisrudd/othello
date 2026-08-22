import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredCoefficientQuotients
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MultivariableFlatGaugeUniqueness
import Mathlib.Algebra.Algebra.Hom.Rat
import Mathlib.RingTheory.LaurentSeries

/-!
# Multivariable Laurent flat gauges over filtered quotients

For a commutative rational algebra `B` with a decreasing ideal filtration,
this module starts with a matrix connection whose bulk coefficients are
ordinary Laurent series over `B`.  It maps Laurent coefficients into each
`B/F^n`, constructs the unique normalized invertible multivariable formal
gauge at every level, and proves compatibility under canonical adjacent
reductions.  Thus every bulk-monomial coefficient at every finite level is an
ordinary Laurent series with integral loop exponents and its own lower bound.

The supplied connection is assumed to satisfy the exact zero-curvature
equations.  Lean does not identify it or the filtration with the manuscript's
quantum data, derive the curvature equations from string or divisor equations,
give a Laurent lower bound uniform in bulk monomials or levels, package a
Laurent-valued inverse-limit gauge, or construct an analytic specialization.
The proofs are symbolic and kernel checked, with no external computation or
oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

universe u v w

/-- Coefficientwise application of a ring homomorphism to ordinary Laurent
series.  Its support can only shrink, so Laurent lower boundedness is
preserved. -/
noncomputable def laurentSeriesMap {R S : Type*} [CommRing R] [CommRing S]
    (homomorphism : R →+* S) : LaurentSeries R →+* LaurentSeries S where
  toFun series := series.map homomorphism
  map_one' := HahnSeries.map_one homomorphism.toMonoidWithZeroHom
  map_mul' _ _ := HahnSeries.map_mul homomorphism.toNonUnitalRingHom
  map_zero' := HahnSeries.map_zero homomorphism.toZeroHom
  map_add' _ _ := HahnSeries.map_add homomorphism.toAddMonoidHom

/-- The coefficient of the mapped Laurent series is the image of the original
coefficient. -/
@[simp]
theorem laurentSeriesMap_coeff {R S : Type*} [CommRing R] [CommRing S]
    (homomorphism : R →+* S) (series : LaurentSeries R) (exponent : ℤ) :
    (laurentSeriesMap homomorphism series).coeff exponent =
      homomorphism (series.coeff exponent) := by
  simp [laurentSeriesMap]

/-- A multivariable Laurent connection over the quotients of a decreasing
ideal filtration. -/
structure FilteredMultivariableLaurentFlatGaugeInput
    (Coordinate : Type u) [DecidableEq Coordinate]
    (Index : Type v) [Fintype Index] [DecidableEq Index]
    (B : Type w) [CommRing B] [Algebra ℚ B] where
  filtration : DecreasingIdealFiltration B
  connection : Coordinate →
    Matrix Index Index (MvPowerSeries Coordinate (LaurentSeries B))
  curvature : ∀ first second,
    (connection second).map (multivariablePartialDerivative first) -
        (connection first).map (multivariablePartialDerivative second) +
        connection first * connection second -
        connection second * connection first = 0

namespace FilteredMultivariableLaurentFlatGaugeInput

/-- The rational-algebra map on Laurent coefficients induced by quotienting
the base coefficient ring at one filtration level. -/
noncomputable def quotientLaurentMap
    {Coordinate Index B : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : FilteredMultivariableLaurentFlatGaugeInput Coordinate Index B)
    (level : ℕ) :
    LaurentSeries B →ₐ[ℚ]
      LaurentSeries (input.filtration.QuotientRing level) :=
  (laurentSeriesMap
    (Ideal.Quotient.mk (input.filtration.ideal level))).toRatAlgHom

/-- The Laurent connection at one actual quotient level. -/
noncomputable def connectionAt
    {Coordinate Index B : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : FilteredMultivariableLaurentFlatGaugeInput Coordinate Index B)
    (level : ℕ) : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate
        (LaurentSeries (input.filtration.QuotientRing level))) :=
  fun coordinate ↦ (input.connection coordinate).map
    (MvPowerSeries.map (input.quotientLaurentMap level).toRingHom)

/-- Zero curvature descends coefficientwise to each Laurent quotient
connection. -/
theorem curvatureAt
    {Coordinate Index B : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : FilteredMultivariableLaurentFlatGaugeInput Coordinate Index B)
    (level : ℕ) (first second : Coordinate) :
    (input.connectionAt level second).map
          (multivariablePartialDerivative first) -
        (input.connectionAt level first).map
          (multivariablePartialDerivative second) +
        input.connectionAt level first * input.connectionAt level second -
        input.connectionAt level second * input.connectionAt level first = 0 := by
  apply Matrix.ext
  intro row column
  apply MvPowerSeries.ext
  intro degree
  have sourceEntry := congrArg
    (fun matrix ↦ MvPowerSeries.coeff degree (matrix row column))
    (input.curvature first second)
  have mappedEntry := congrArg (input.quotientLaurentMap level).toRingHom
    sourceEntry
  simpa [connectionAt, Matrix.mul_apply, MvPowerSeries.coeff_mul,
    multivariablePartialDerivative_coefficient] using mappedEntry

/-- The normalized multivariable gauge at one quotient level. -/
noncomputable def gaugeAt
    {Coordinate Index B : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : FilteredMultivariableLaurentFlatGaugeInput Coordinate Index B)
    (level : ℕ) : Matrix Index Index
      (MvPowerSeries Coordinate
        (LaurentSeries (input.filtration.QuotientRing level))) :=
  multivariableFlatGaugeSeries (input.connectionAt level)

/-- The Laurent-series reduction induced by the canonical adjacent quotient
map. -/
noncomputable def laurentReduction
    {Coordinate Index B : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : FilteredMultivariableLaurentFlatGaugeInput Coordinate Index B)
    (level : ℕ) : LaurentSeries (input.filtration.QuotientRing (level + 1)) →ₐ[ℚ]
      LaurentSeries (input.filtration.QuotientRing level) :=
  (laurentSeriesMap (input.filtration.reduction level)).toRatAlgHom

/-- Quotient-level Laurent connections and their normalized gauges commute
with canonical adjacent reductions. -/
theorem connectionAt_gaugeAt_compatible
    {Coordinate Index B : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : FilteredMultivariableLaurentFlatGaugeInput Coordinate Index B)
    (level : ℕ) :
    (∀ coordinate,
      (input.connectionAt (level + 1) coordinate).map
          (MvPowerSeries.map (input.laurentReduction level).toRingHom) =
        input.connectionAt level coordinate) ∧
      (input.gaugeAt (level + 1)).map
          (MvPowerSeries.map (input.laurentReduction level).toRingHom) =
        input.gaugeAt level := by
  constructor
  · intro coordinate
    ext row column degree exponent
    simp [connectionAt, quotientLaurentMap, laurentReduction,
      laurentSeriesMap]
  · have highNaturality := multivariableFlatGaugeSeries_map
      (input.quotientLaurentMap (level + 1)) input.connection input.curvature
    have lowNaturality := multivariableFlatGaugeSeries_map
      (input.quotientLaurentMap level) input.connection input.curvature
    have highEquality :
        (multivariableFlatGaugeSeries input.connection).map
            (MvPowerSeries.map
              (input.quotientLaurentMap (level + 1)).toRingHom) =
          input.gaugeAt (level + 1) := by
      change _ = multivariableFlatGaugeSeries (fun coordinate ↦
        (input.connection coordinate).map
          (MvPowerSeries.map
            (input.quotientLaurentMap (level + 1)).toRingHom))
      exact highNaturality
    have lowEquality :
        (multivariableFlatGaugeSeries input.connection).map
            (MvPowerSeries.map (input.quotientLaurentMap level).toRingHom) =
          input.gaugeAt level := by
      change _ = multivariableFlatGaugeSeries (fun coordinate ↦
        (input.connection coordinate).map
          (MvPowerSeries.map (input.quotientLaurentMap level).toRingHom))
      exact lowNaturality
    rw [← highEquality, ← lowEquality]
    ext row column degree exponent
    simp [quotientLaurentMap, laurentReduction, laurentSeriesMap]

/-- At every quotient level, the Laurent-valued gauge is the unique normalized
invertible solution of all coordinate equations. -/
theorem gaugeAt_existsUnique
    {Coordinate Index B : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : FilteredMultivariableLaurentFlatGaugeInput Coordinate Index B)
    (level : ℕ) :
    ∃! solution : Matrix Index Index
        (MvPowerSeries Coordinate
          (LaurentSeries (input.filtration.QuotientRing level))),
      solution.map (MvPowerSeries.coeff 0) = 1 ∧
      IsUnit solution ∧
      ∀ coordinate,
        solution.map (multivariablePartialDerivative coordinate) =
          -(input.connectionAt level coordinate) * solution :=
  multivariableFlatGaugeSeries_existsUnique_of_curvature
    (input.connectionAt level) (input.curvatureAt level)

end FilteredMultivariableLaurentFlatGaugeInput

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
