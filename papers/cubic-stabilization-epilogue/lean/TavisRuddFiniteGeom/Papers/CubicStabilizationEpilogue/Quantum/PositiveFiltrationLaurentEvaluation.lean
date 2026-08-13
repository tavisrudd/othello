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
    HahnSeries.C
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

/-- Canonical Laurent-series reduction between adjacent quotients of a
normalized multiplicative filtration. -/
noncomputable def MultiplicativeIdealFiltration.positiveLaurentReduction
    {B : Type*} [CommRing B]
    (filtration : MultiplicativeIdealFiltration B) (cutoff : ℕ) :
    LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing (cutoff + 1)) →+*
      LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff) :=
  laurentSeriesMap
    (filtration.toDecreasingIdealFiltration.reduction cutoff)

/-- The exponent box for `cutoff` is contained in the box for the next
cutoff. -/
theorem bulkMonomialBoxBelow_mono_succ
    (Coordinate : Type*) [Fintype Coordinate] (cutoff : ℕ) :
    bulkMonomialBoxBelow Coordinate cutoff ⊆
      bulkMonomialBoxBelow Coordinate (cutoff + 1) := by
  classical
  intro degree degree_mem
  rw [bulkMonomialBoxBelow] at degree_mem ⊢
  obtain ⟨exponent, _, rfl⟩ := Finset.mem_image.mp degree_mem
  let nextExponent : Coordinate → Fin (cutoff + 1) := fun coordinate ↦
    ⟨exponent coordinate, Nat.lt_succ_of_lt (exponent coordinate).isLt⟩
  refine Finset.mem_image.mpr ⟨nextExponent, Finset.mem_univ _, ?_⟩
  apply Finsupp.ext
  intro coordinate
  simp [nextExponent]

/-- One evaluated Laurent term commutes with canonical adjacent reduction. -/
theorem MultiplicativeIdealFiltration.positiveLaurentEvaluationTermAtLevel_compatible
    {Coordinate B : Type*} [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B) (cutoff : ℕ)
    (series : MvPowerSeries Coordinate (LaurentSeries B))
    (degree : Coordinate →₀ ℕ) :
    filtration.positiveLaurentReduction cutoff
        (filtration.positiveLaurentEvaluationTermAtLevel
          parameter (cutoff + 1) series degree) =
      filtration.positiveLaurentEvaluationTermAtLevel
        parameter cutoff series degree := by
  rw [MultiplicativeIdealFiltration.positiveLaurentEvaluationTermAtLevel,
    map_mul]
  apply congrArg₂ (fun left right ↦ left * right)
  · ext exponent
    by_cases exponent = 0
    · subst exponent
      simp [MultiplicativeIdealFiltration.positiveLaurentReduction,
        laurentSeriesMap]
    · simp [MultiplicativeIdealFiltration.positiveLaurentReduction,
        laurentSeriesMap, *]
  · ext exponent
    by_cases exponent = 0
    · subst exponent
      simp [MultiplicativeIdealFiltration.positiveLaurentReduction,
        laurentSeriesMap]
    · simp [MultiplicativeIdealFiltration.positiveLaurentReduction,
        laurentSeriesMap, *]

/-- Finite quotient-level evaluation at filtration-positive parameters
commutes with canonical adjacent reductions. -/
theorem MultiplicativeIdealFiltration.positiveLaurentEvaluationAtLevel_compatible
    {Coordinate B : Type*} [Fintype Coordinate] [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ) (series : MvPowerSeries Coordinate (LaurentSeries B)) :
    filtration.positiveLaurentReduction cutoff
        (filtration.positiveLaurentEvaluationAtLevel
          parameter (cutoff + 1) series) =
      filtration.positiveLaurentEvaluationAtLevel
        parameter cutoff series := by
  classical
  let lowBox := bulkMonomialBoxBelow Coordinate cutoff
  let highBox := bulkMonomialBoxBelow Coordinate (cutoff + 1)
  have subset : lowBox ⊆ highBox :=
    bulkMonomialBoxBelow_mono_succ Coordinate cutoff
  have extra_zero : ∀ degree ∈ highBox, degree ∉ lowBox →
      filtration.positiveLaurentReduction cutoff
          (filtration.positiveLaurentEvaluationTermAtLevel
            parameter (cutoff + 1) series degree) = 0 := by
    intro degree _ outside
    rw [filtration.positiveLaurentEvaluationTermAtLevel_compatible
      parameter cutoff series degree]
    apply filtration.positiveLaurentEvaluationTermAtLevel_eq_zero
      parameter positive cutoff series degree
    by_contra not_le
    exact outside (mem_bulkMonomialBoxBelow_of_totalDegree_lt cutoff degree
      (Nat.lt_of_not_ge not_le))
  rw [MultiplicativeIdealFiltration.positiveLaurentEvaluationAtLevel,
    map_sum]
  calc
    ∑ degree ∈ highBox,
        filtration.positiveLaurentReduction cutoff
          (filtration.positiveLaurentEvaluationTermAtLevel
            parameter (cutoff + 1) series degree) =
        ∑ degree ∈ lowBox,
          filtration.positiveLaurentReduction cutoff
            (filtration.positiveLaurentEvaluationTermAtLevel
              parameter (cutoff + 1) series degree) := by
          symm
          exact Finset.sum_subset subset extra_zero
    _ = ∑ degree ∈ lowBox,
          filtration.positiveLaurentEvaluationTermAtLevel
            parameter cutoff series degree := by
          apply Finset.sum_congr rfl
          intro degree _
          exact filtration.positiveLaurentEvaluationTermAtLevel_compatible
            parameter cutoff series degree

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

/-- The finite evaluated flat-gauge matrices commute with canonical adjacent
quotient reductions. -/
theorem MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel_compatible
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    (filtration.positiveEvaluatedFlatGaugeAtLevel
        parameter (cutoff + 1) connection).map
        (filtration.positiveLaurentReduction cutoff) =
      filtration.positiveEvaluatedFlatGaugeAtLevel
        parameter cutoff connection := by
  apply Matrix.ext
  intro row column
  exact filtration.positiveLaurentEvaluationAtLevel_compatible
    parameter positive cutoff
    ((multivariableFlatGaugeSeries connection) row column)

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
