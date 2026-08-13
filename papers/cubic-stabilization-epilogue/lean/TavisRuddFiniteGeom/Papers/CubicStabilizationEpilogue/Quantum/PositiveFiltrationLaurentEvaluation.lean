import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.PositiveFiltrationBulkTruncation
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FilteredMultivariableLaurentFlatGauge

/-!
# Finite Laurent evaluation at filtration-positive bulk parameters

For finitely many bulk coordinates, parameters in filtration level one become
jointly nilpotent in every quotient `B / F^N`.  This module turns that fact
into an actual finite Laurent-series value: it maps each Laurent coefficient
to the quotient, multiplies by the corresponding parameter monomial, and sums
over a finite exponent box containing every total degree below `N`.  Terms of
total degree at least `N` vanish, and a finite matrix of the resulting Laurent
series has one common lower bound on its loop exponents.

This is a finite quotient-level evaluation, not an infinite summation or a
topological evaluation theorem.  Lean does not identify the supplied formal
series or parameters with the manuscript's gauge and bulk coordinates, prove
that evaluation preserves products or inverses, construct an inverse-limit
Laurent gauge, or identify the coefficient filtration geometrically.  The
proofs are symbolic and kernel checked, with no external computation or
oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

/-- One Laurent-valued bulk term after mapping coefficients and a positive
parameter monomial to the quotient by filtration level `cutoff`. -/
noncomputable def MultiplicativeIdealFiltration.positiveLaurentEvaluationTermAtLevel
    {Coordinate B : Type*} [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B) (cutoff : ℕ)
    (series : MvPowerSeries Coordinate (LaurentSeries B))
    (degree : Coordinate →₀ ℕ) :
    LaurentSeries (filtration.toDecreasingIdealFiltration.QuotientRing cutoff) :=
  laurentSeriesMap (Ideal.Quotient.mk (filtration.ideal cutoff))
      (MvPowerSeries.coeff degree series) *
    algebraMap
      (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)
      (LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff))
      (Ideal.Quotient.mk (filtration.ideal cutoff)
        (bulkMonomialValue parameter degree))

/-- Every Laurent-valued bulk term whose total degree reaches the quotient
cutoff is zero. -/
theorem MultiplicativeIdealFiltration.positiveLaurentEvaluationTermAtLevel_eq_zero
    {Coordinate B : Type*} [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ) (series : MvPowerSeries Coordinate (LaurentSeries B))
    (degree : Coordinate →₀ ℕ)
    (cutoff_le : cutoff ≤ multivariableTotalDegree degree) :
    filtration.positiveLaurentEvaluationTermAtLevel parameter cutoff series degree = 0 := by
  rw [MultiplicativeIdealFiltration.positiveLaurentEvaluationTermAtLevel]
  rw [filtration.quotient_mk_bulkMonomialValue_eq_zero parameter positive
    cutoff degree cutoff_le]
  simp

/-- The finite quotient-level Laurent evaluation obtained by summing the
possibly nonzero terms in the canonical exponent box. -/
noncomputable def MultiplicativeIdealFiltration.positiveLaurentEvaluationAtLevel
    {Coordinate B : Type*} [Fintype Coordinate] [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B) (cutoff : ℕ)
    (series : MvPowerSeries Coordinate (LaurentSeries B)) :
    LaurentSeries (filtration.toDecreasingIdealFiltration.QuotientRing cutoff) :=
  ∑ degree ∈ bulkMonomialBoxBelow Coordinate cutoff,
    filtration.positiveLaurentEvaluationTermAtLevel parameter cutoff series degree

/-- Entrywise finite positive-parameter evaluation of a matrix-valued
multivariate Laurent series at one filtration quotient. -/
noncomputable def MultiplicativeIdealFiltration.positiveLaurentMatrixEvaluationAtLevel
    {Coordinate Index B : Type*} [Fintype Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B) (cutoff : ℕ)
    (series : Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    Matrix Index Index
      (LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)) :=
  fun row column ↦
    filtration.positiveLaurentEvaluationAtLevel parameter cutoff
      (series row column)

/-- A finite quotient-level positive-parameter evaluation has one Laurent
lower bound common to every entry of a finite matrix. -/
theorem MultiplicativeIdealFiltration.positiveLaurentMatrixEvaluationAtLevel_hasUniformLowerBound
    {Coordinate Index B : Type*} [Fintype Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B) (cutoff : ℕ)
    (series : Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    ∃ lowerBound : ℤ, ∀ row column exponent,
      exponent < lowerBound →
        (filtration.positiveLaurentMatrixEvaluationAtLevel
          parameter cutoff series row column).coeff exponent = 0 := by
  let evaluated : Index × Index →
      LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff) :=
    fun entry ↦ filtration.positiveLaurentMatrixEvaluationAtLevel
      parameter cutoff series entry.1 entry.2
  obtain ⟨lowerBound, bounded⟩ :=
    finiteFamily_hasUniformLaurentLowerBound evaluated
  exact ⟨lowerBound, fun row column exponent below ↦
    bounded (row, column) exponent below⟩

/-- Evaluate the recursively constructed normalized multivariable flat gauge
at filtration-positive parameters in one quotient. -/
noncomputable def MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B) (cutoff : ℕ)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    Matrix Index Index
      (LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)) :=
  filtration.positiveLaurentMatrixEvaluationAtLevel parameter cutoff
    (multivariableFlatGaugeSeries connection)

/-- At filtration-positive parameters, all high-total-degree terms of the
recursively constructed flat gauge vanish at the selected quotient level. -/
theorem MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel_term_eq_zero
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (row column : Index) (degree : Coordinate →₀ ℕ)
    (cutoff_le : cutoff ≤ multivariableTotalDegree degree) :
    filtration.positiveLaurentEvaluationTermAtLevel parameter cutoff
      ((multivariableFlatGaugeSeries connection) row column) degree = 0 := by
  exact filtration.positiveLaurentEvaluationTermAtLevel_eq_zero
    parameter positive cutoff
    ((multivariableFlatGaugeSeries connection) row column) degree cutoff_le

/-- The finite positive-parameter evaluation of the recursively constructed
flat gauge has one Laurent lower bound common to every matrix entry. -/
theorem MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel_hasUniformLowerBound
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B) (cutoff : ℕ)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    ∃ lowerBound : ℤ, ∀ row column exponent,
      exponent < lowerBound →
        (filtration.positiveEvaluatedFlatGaugeAtLevel
          parameter cutoff connection row column).coeff exponent = 0 := by
  simpa [MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel] using
    filtration.positiveLaurentMatrixEvaluationAtLevel_hasUniformLowerBound
      parameter cutoff (multivariableFlatGaugeSeries connection)

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
