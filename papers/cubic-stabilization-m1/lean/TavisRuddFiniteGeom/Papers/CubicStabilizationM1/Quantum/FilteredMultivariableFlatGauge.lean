import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredCoefficientQuotients
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MultivariableFlatGaugeUniqueness
import Mathlib.Algebra.Algebra.Hom.Rat

/-!
# Multivariable formal flat gauges over an ideal-quotient tower

Let `R` be a commutative `ℚ`-algebra with a decreasing ideal filtration, and
let a matrix-valued multivariate formal connection over `R` satisfy the exact
zero-curvature equations for the coefficientwise formal partial derivatives.
This module maps the connection into every quotient `R/F^n`, constructs the
unique normalized invertible formal gauge there, and proves that both the
connection and gauge commute with every canonical adjacent reduction.

The base ring, filtration, connection, and its zero-curvature proof are
supplied.  Lean constructs the quotient rings, reductions, level connections,
and compatible level gauges.  It does not identify these data with the
manuscript's geometric coefficient tower or quantum connection, prove a
Laurent lower bound uniform in all bulk monomials and levels, form an
inverse-limit Laurent gauge, or construct an analytic specialization.  The
proofs are symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

universe u v w

/-- A zero-curvature multivariate formal connection over a rational algebra
equipped with a decreasing ideal filtration. -/
structure FilteredMultivariableFlatGaugeInput
    (Coordinate : Type u) [DecidableEq Coordinate]
    (Index : Type v) [Fintype Index] [DecidableEq Index]
    (R : Type w) [CommRing R] [Algebra ℚ R] where
  filtration : DecreasingIdealFiltration R
  connection : Coordinate →
    Matrix Index Index (MvPowerSeries Coordinate R)
  curvature : ∀ first second,
    (connection second).map (multivariablePartialDerivative first) -
        (connection first).map (multivariablePartialDerivative second) +
        connection first * connection second -
        connection second * connection first = 0

namespace FilteredMultivariableFlatGaugeInput

/-- The canonical rational-algebra quotient map at one filtration level. -/
noncomputable def quotientMap
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (input : FilteredMultivariableFlatGaugeInput Coordinate Index R)
    (level : ℕ) :
    R →ₐ[ℚ] input.filtration.QuotientRing level :=
  (Ideal.Quotient.mk (input.filtration.ideal level)).toRatAlgHom

/-- The connection obtained by mapping coefficients into one quotient. -/
noncomputable def connectionAt
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (input : FilteredMultivariableFlatGaugeInput Coordinate Index R)
    (level : ℕ) : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (input.filtration.QuotientRing level)) :=
  fun coordinate ↦ (input.connection coordinate).map
    (MvPowerSeries.map (input.quotientMap level).toRingHom)

/-- Zero curvature descends to every quotient connection. -/
theorem curvatureAt
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (input : FilteredMultivariableFlatGaugeInput Coordinate Index R)
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
  have mappedEntry := congrArg (input.quotientMap level).toRingHom sourceEntry
  simpa [connectionAt, Matrix.mul_apply, MvPowerSeries.coeff_mul,
    multivariablePartialDerivative_coefficient] using mappedEntry

/-- The recursively constructed normalized formal gauge at one quotient
level. -/
noncomputable def gaugeAt
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (input : FilteredMultivariableFlatGaugeInput Coordinate Index R)
    (level : ℕ) : Matrix Index Index
      (MvPowerSeries Coordinate (input.filtration.QuotientRing level)) :=
  multivariableFlatGaugeSeries (input.connectionAt level)

/-- The quotient connection and its recursively constructed normalized gauge
commute with canonical adjacent reductions. -/
theorem connectionAt_gaugeAt_compatible
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (input : FilteredMultivariableFlatGaugeInput Coordinate Index R)
    (level : ℕ) :
    (∀ coordinate,
      (input.connectionAt (level + 1) coordinate).map
          (MvPowerSeries.map (input.filtration.reduction level)) =
        input.connectionAt level coordinate) ∧
      (input.gaugeAt (level + 1)).map
          (MvPowerSeries.map (input.filtration.reduction level)) =
        input.gaugeAt level := by
  constructor
  · intro coordinate
    ext row column degree
    simp [connectionAt, quotientMap]
  · have highNaturality := multivariableFlatGaugeSeries_map
      (input.quotientMap (level + 1)) input.connection input.curvature
    have lowNaturality := multivariableFlatGaugeSeries_map
      (input.quotientMap level) input.connection input.curvature
    have highEquality :
        (multivariableFlatGaugeSeries input.connection).map
            (MvPowerSeries.map (input.quotientMap (level + 1)).toRingHom) =
          multivariableFlatGaugeSeries (input.connectionAt (level + 1)) := by
      change _ = multivariableFlatGaugeSeries (fun coordinate ↦
        (input.connection coordinate).map
          (MvPowerSeries.map (input.quotientMap (level + 1)).toRingHom))
      exact highNaturality
    have lowEquality :
        (multivariableFlatGaugeSeries input.connection).map
            (MvPowerSeries.map (input.quotientMap level).toRingHom) =
          multivariableFlatGaugeSeries (input.connectionAt level) := by
      change _ = multivariableFlatGaugeSeries (fun coordinate ↦
        (input.connection coordinate).map
          (MvPowerSeries.map (input.quotientMap level).toRingHom))
      exact lowNaturality
    change (multivariableFlatGaugeSeries (input.connectionAt (level + 1))).map
        (MvPowerSeries.map (input.filtration.reduction level)) =
      multivariableFlatGaugeSeries (input.connectionAt level)
    rw [← highEquality, ← lowEquality]
    ext row column degree
    simp [quotientMap]

/-- At every quotient level the constructed gauge is normalized, invertible,
satisfies every coordinate equation, and is the unique normalized solution. -/
theorem gaugeAt_existsUnique
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (input : FilteredMultivariableFlatGaugeInput Coordinate Index R)
    (level : ℕ) :
    ∃! solution : Matrix Index Index
        (MvPowerSeries Coordinate (input.filtration.QuotientRing level)),
      solution.map (MvPowerSeries.coeff 0) = 1 ∧
      IsUnit solution ∧
      ∀ coordinate,
        solution.map (multivariablePartialDerivative coordinate) =
          -(input.connectionAt level coordinate) * solution :=
  multivariableFlatGaugeSeries_existsUnique_of_curvature
    (input.connectionAt level) (input.curvatureAt level)

/-- The coefficient of one matrix entry and one bulk monomial across all
quotient gauges, packaged as an adjacent-compatible quotient family. -/
noncomputable def gaugeCoefficientFamily
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (input : FilteredMultivariableFlatGaugeInput Coordinate Index R)
    (row column : Index) (degree : Coordinate →₀ ℕ) :
    input.filtration.CompatibleQuotientFamily where
  value level := MvPowerSeries.coeff degree (input.gaugeAt level row column)
  compatible level := by
    have compatibility := congrArg
      (fun matrix ↦ MvPowerSeries.coeff degree (matrix row column))
      (input.connectionAt_gaugeAt_compatible level).2
    simpa using compatibility

/-- Every packaged quotient-gauge coefficient is exactly the compatible family
represented by the corresponding coefficient of the base-ring gauge. -/
theorem gaugeCoefficientFamily_eq_ofRingElement
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (input : FilteredMultivariableFlatGaugeInput Coordinate Index R)
    (row column : Index) (degree : Coordinate →₀ ℕ) :
    input.gaugeCoefficientFamily row column degree =
      input.filtration.ofRingElement
        (MvPowerSeries.coeff degree
          (multivariableFlatGaugeSeries input.connection row column)) := by
  ext level
  have naturality := multivariableFlatGaugeSeries_map
    (input.quotientMap level) input.connection input.curvature
  have levelEquality :
      (multivariableFlatGaugeSeries input.connection).map
          (MvPowerSeries.map (input.quotientMap level).toRingHom) =
        input.gaugeAt level := by
    change _ = multivariableFlatGaugeSeries (fun coordinate ↦
      (input.connection coordinate).map
        (MvPowerSeries.map (input.quotientMap level).toRingHom))
    exact naturality
  have coefficientEquality := congrArg
    (fun matrix ↦ MvPowerSeries.coeff degree (matrix row column)) levelEquality
  simpa [gaugeCoefficientFamily, quotientMap] using coefficientEquality.symm

end FilteredMultivariableFlatGaugeInput

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
