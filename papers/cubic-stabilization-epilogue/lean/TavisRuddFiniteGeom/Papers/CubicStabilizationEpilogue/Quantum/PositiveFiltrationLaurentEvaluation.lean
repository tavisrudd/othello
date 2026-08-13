import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.PositiveFiltrationBulkTruncation
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FilteredMultivariableLaurentFlatGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ProLaurent
import Mathlib.RingTheory.MvPowerSeries.Substitution

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
series or parameters with the manuscript's gauge and bulk coordinates.  The
finite evaluation is a ring homomorphism, so it preserves invertibility, and
the compatible evaluated gauges and chosen inverses form a pro-Laurent gauge
system.  If the filtration is coefficientwise complete and separated and
uniform Laurent lower bounds are supplied for both systems, Lean assembles a
two-sided-invertible Laurent matrix over the base ring that reduces to every
finite evaluation.  The uniform bounds, geometric identification of the
filtration, and analytic specialization are not proved.  The proofs are
symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

/-- The constant power series representing one filtration-positive parameter
inside the Laurent-series quotient coefficient ring. -/
noncomputable def MultiplicativeIdealFiltration.positiveLaurentSubstitutionParameterAtLevel
    {Coordinate B : Type*} [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B) (cutoff : ℕ)
    (coordinate : Coordinate) : MvPowerSeries (Fin 0)
      (LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)) :=
  MvPowerSeries.C (HahnSeries.C
    (Ideal.Quotient.mk (filtration.ideal cutoff) (parameter coordinate)))

/-- Level-one parameters are nilpotent in every filtration quotient, so their
constant Laurent power series satisfy Mathlib's finite substitution
criterion. -/
theorem MultiplicativeIdealFiltration.positiveLaurentSubstitutionParameterAtLevel_hasSubst
    {Coordinate B : Type*} [Fintype Coordinate] [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ) :
    MvPowerSeries.HasSubst
      (filtration.positiveLaurentSubstitutionParameterAtLevel
        parameter cutoff) := by
  apply MvPowerSeries.hasSubst_of_constantCoeff_nilpotent
  intro coordinate
  simp only [MultiplicativeIdealFiltration.positiveLaurentSubstitutionParameterAtLevel,
    MvPowerSeries.constantCoeff_C]
  have quotientNilpotent : IsNilpotent
      (Ideal.Quotient.mk (filtration.ideal cutoff) (parameter coordinate)) := by
    refine ⟨cutoff, ?_⟩
    rw [← map_pow, Ideal.Quotient.eq_zero_iff_mem]
    exact filtration.pow_mem_level (positive coordinate) cutoff
  exact quotientNilpotent.map HahnSeries.C

/-- The genuine ring homomorphism obtained by substituting the nilpotent
quotient classes of filtration-positive parameters.  The temporary
`PEmpty`-variable power-series ring is canonically collapsed by its constant
coefficient map. -/
noncomputable def MultiplicativeIdealFiltration.positiveLaurentEvaluationRingHomAtLevel
    {Coordinate B : Type*} [Fintype Coordinate] [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ) :
    MvPowerSeries Coordinate (LaurentSeries B) →+*
      LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff) := by
  let coefficientMap : LaurentSeries B →+*
      LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff) :=
    laurentSeriesMap (Ideal.Quotient.mk (filtration.ideal cutoff))
  letI : Algebra (LaurentSeries B)
      (LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)) :=
    coefficientMap.toAlgebra
  exact (MvPowerSeries.constantCoeff :
      MvPowerSeries (Fin 0)
          (LaurentSeries
            (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)) →+*
        LaurentSeries
          (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)).comp
    (MvPowerSeries.substAlgHom
      (filtration.positiveLaurentSubstitutionParameterAtLevel_hasSubst
        parameter positive cutoff)).toRingHom

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

/-- The explicit finite sum agrees with the nilpotent-substitution ring
homomorphism. -/
theorem MultiplicativeIdealFiltration.positiveLaurentEvaluationRingHomAtLevel_apply
    {Coordinate B : Type*} [Fintype Coordinate] [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ) (series : MvPowerSeries Coordinate (LaurentSeries B)) :
    filtration.positiveLaurentEvaluationRingHomAtLevel
        parameter positive cutoff series =
      filtration.positiveLaurentEvaluationAtLevel
        parameter cutoff series := by
  classical
  let coefficientMap : LaurentSeries B →+*
      LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff) :=
    laurentSeriesMap (Ideal.Quotient.mk (filtration.ideal cutoff))
  letI : Algebra (LaurentSeries B)
      (LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)) :=
    coefficientMap.toAlgebra
  rw [MultiplicativeIdealFiltration.positiveLaurentEvaluationRingHomAtLevel]
  rw [RingHom.comp_apply]
  change MvPowerSeries.constantCoeff
      (MvPowerSeries.substAlgHom
        (filtration.positiveLaurentSubstitutionParameterAtLevel_hasSubst
          parameter positive cutoff) series) = _
  rw [show MvPowerSeries.substAlgHom
      (filtration.positiveLaurentSubstitutionParameterAtLevel_hasSubst
        parameter positive cutoff) series =
      MvPowerSeries.subst
        (filtration.positiveLaurentSubstitutionParameterAtLevel
          parameter cutoff) series by
    exact congrFun (MvPowerSeries.coe_substAlgHom _) series]
  rw [MvPowerSeries.constantCoeff_subst
    (filtration.positiveLaurentSubstitutionParameterAtLevel_hasSubst
      parameter positive cutoff)]
  rw [MultiplicativeIdealFiltration.positiveLaurentEvaluationAtLevel]
  have summand_eq : ∀ degree : Coordinate →₀ ℕ,
      MvPowerSeries.coeff degree series •
          MvPowerSeries.constantCoeff
            (degree.prod fun coordinate exponent ↦
              filtration.positiveLaurentSubstitutionParameterAtLevel
                parameter cutoff coordinate ^ exponent) =
        filtration.positiveLaurentEvaluationTermAtLevel
          parameter cutoff series degree := by
    intro degree
    rw [Algebra.smul_def]
    rw [show algebraMap (LaurentSeries B)
        (LaurentSeries
          (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)) =
        coefficientMap from rfl]
    simp [MultiplicativeIdealFiltration.positiveLaurentSubstitutionParameterAtLevel,
      MultiplicativeIdealFiltration.positiveLaurentEvaluationTermAtLevel,
      bulkMonomialValue, coefficientMap]
  simp_rw [summand_eq]
  apply finsum_eq_sum_of_support_subset
  intro degree degree_mem
  by_contra outside
  have cutoff_le : cutoff ≤ multivariableTotalDegree degree := by
    by_contra not_le
    exact outside (mem_bulkMonomialBoxBelow_of_totalDegree_lt cutoff degree
      (Nat.lt_of_not_ge not_le))
  have term_zero := filtration.positiveLaurentEvaluationTermAtLevel_eq_zero
    parameter positive cutoff series degree cutoff_le
  exact degree_mem (by
    exact term_zero)

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

/-- Entrywise finite evaluation is exactly matrix mapping by the
nilpotent-substitution ring homomorphism. -/
theorem MultiplicativeIdealFiltration.positiveLaurentMatrixEvaluationAtLevel_eq_mapMatrix
    {Coordinate Index B : Type*} [Fintype Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ)
    (series : Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    filtration.positiveLaurentMatrixEvaluationAtLevel
        parameter cutoff series =
      (filtration.positiveLaurentEvaluationRingHomAtLevel
        parameter positive cutoff).mapMatrix series := by
  apply Matrix.ext
  intro row column
  exact (filtration.positiveLaurentEvaluationRingHomAtLevel_apply
    parameter positive cutoff (series row column)).symm

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

/-- Nilpotent positive-parameter evaluation preserves invertibility of the
normalized formal flat gauge. -/
theorem MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel_isUnit
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    IsUnit (filtration.positiveEvaluatedFlatGaugeAtLevel
      parameter cutoff connection) := by
  have sourceUnit := multivariableFlatGaugeSeries_isUnit connection
  have mappedUnit := sourceUnit.map
    (filtration.positiveLaurentEvaluationRingHomAtLevel
      parameter positive cutoff).mapMatrix
  rw [MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel,
    filtration.positiveLaurentMatrixEvaluationAtLevel_eq_mapMatrix
      parameter positive cutoff]
  exact mappedUnit

/-- A chosen two-sided inverse of the finite evaluated flat gauge. -/
noncomputable def MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeInverseAtLevel
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    Matrix Index Index
      (LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff)) :=
  ↑(filtration.positiveEvaluatedFlatGaugeAtLevel_isUnit
    parameter positive cutoff connection).unit⁻¹

/-- The chosen finite-level inverse is a two-sided matrix inverse. -/
theorem MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel_inverse
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    filtration.positiveEvaluatedFlatGaugeAtLevel
        parameter cutoff connection *
        filtration.positiveEvaluatedFlatGaugeInverseAtLevel
          parameter positive cutoff connection = 1 ∧
      filtration.positiveEvaluatedFlatGaugeInverseAtLevel
          parameter positive cutoff connection *
        filtration.positiveEvaluatedFlatGaugeAtLevel
          parameter cutoff connection = 1 := by
  let unit := (filtration.positiveEvaluatedFlatGaugeAtLevel_isUnit
    parameter positive cutoff connection).unit
  have unit_spec : (↑unit : Matrix Index Index
      (LaurentSeries
        (filtration.toDecreasingIdealFiltration.QuotientRing cutoff))) =
      filtration.positiveEvaluatedFlatGaugeAtLevel
        parameter cutoff connection :=
    IsUnit.unit_spec _
  constructor
  · rw [← unit_spec]
    change
      (↑unit : Matrix Index Index
          (LaurentSeries
            (filtration.toDecreasingIdealFiltration.QuotientRing cutoff))) *
        (↑(unit⁻¹) : Matrix Index Index
          (LaurentSeries
            (filtration.toDecreasingIdealFiltration.QuotientRing cutoff))) = 1
    simp
  · rw [← unit_spec]
    change
      (↑(unit⁻¹) : Matrix Index Index
          (LaurentSeries
            (filtration.toDecreasingIdealFiltration.QuotientRing cutoff))) *
        (↑unit : Matrix Index Index
          (LaurentSeries
            (filtration.toDecreasingIdealFiltration.QuotientRing cutoff))) = 1
    simp

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

/-- The chosen inverses of the finite evaluated gauges commute with canonical
adjacent quotient reductions. -/
theorem MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeInverseAtLevel_compatible
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    (filtration.positiveEvaluatedFlatGaugeInverseAtLevel
        parameter positive (cutoff + 1) connection).map
        (filtration.positiveLaurentReduction cutoff) =
      filtration.positiveEvaluatedFlatGaugeInverseAtLevel
        parameter positive cutoff connection := by
  let reduction := filtration.positiveLaurentReduction cutoff
  let highInverse := filtration.positiveEvaluatedFlatGaugeInverseAtLevel
    parameter positive (cutoff + 1) connection
  let lowInverse := filtration.positiveEvaluatedFlatGaugeInverseAtLevel
    parameter positive cutoff connection
  let lowGauge := filtration.positiveEvaluatedFlatGaugeAtLevel
    parameter cutoff connection
  have highIdentities :=
    filtration.positiveEvaluatedFlatGaugeAtLevel_inverse
      parameter positive (cutoff + 1) connection
  have lowIdentities :=
    filtration.positiveEvaluatedFlatGaugeAtLevel_inverse
      parameter positive cutoff connection
  have gaugeCompatibility :=
    filtration.positiveEvaluatedFlatGaugeAtLevel_compatible
      parameter positive cutoff connection
  have mappedRight : highInverse.map reduction * lowGauge = 1 := by
    have mapped := congrArg (fun matrix ↦ matrix.map reduction) highIdentities.2
    simpa [highInverse, lowGauge, reduction, Matrix.map_mul,
      gaugeCompatibility] using mapped
  calc
    highInverse.map reduction = highInverse.map reduction * 1 := by simp
    _ = highInverse.map reduction * (lowGauge * lowInverse) := by
      rw [lowIdentities.1]
    _ = (highInverse.map reduction * lowGauge) * lowInverse := by
      rw [mul_assoc]
    _ = lowInverse := by rw [mappedRight, one_mul]

/-- The finite evaluations of the normalized formal gauge, together with
their chosen compatible inverses, form a pro-Laurent gauge system over the
actual filtration quotients. -/
noncomputable def MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeSystem
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B))) :
    ProLaurentGaugeSystem Index where
  Coefficient level := filtration.toDecreasingIdealFiltration.QuotientRing level
  coefficientRing level := inferInstance
  gauge level := filtration.positiveEvaluatedFlatGaugeAtLevel
    parameter level connection
  inverse level := filtration.positiveEvaluatedFlatGaugeInverseAtLevel
    parameter positive level connection
  reduction level := filtration.positiveLaurentReduction level
  leftInverse level :=
    (filtration.positiveEvaluatedFlatGaugeAtLevel_inverse
      parameter positive level connection).1
  rightInverse level :=
    (filtration.positiveEvaluatedFlatGaugeAtLevel_inverse
      parameter positive level connection).2
  gauge_compatible level row column := by
    have compatibility :=
      filtration.positiveEvaluatedFlatGaugeAtLevel_compatible
        parameter positive level connection
    exact congrArg (fun matrix ↦ matrix row column) compatibility
  inverse_compatible level row column := by
    have compatibility :=
      filtration.positiveEvaluatedFlatGaugeInverseAtLevel_compatible
        parameter positive level connection
    exact congrArg (fun matrix ↦ matrix row column) compatibility

/-- For one matrix entry and loop exponent, the coefficients of the finite
evaluated gauges form an explicit compatible quotient family. -/
noncomputable def MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeCoefficientFamily
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (row column : Index) (exponent : ℤ) :
    DecreasingIdealFiltration.CompatibleQuotientFamily
      filtration.toDecreasingIdealFiltration where
  value level :=
    (filtration.positiveEvaluatedFlatGaugeAtLevel
      parameter level connection row column).coeff exponent
  compatible level := by
    have matrixCompatibility :=
      filtration.positiveEvaluatedFlatGaugeAtLevel_compatible
        parameter positive level connection
    have coefficientCompatibility := congrArg
      (fun matrix ↦ (matrix row column).coeff exponent)
      matrixCompatibility
    simpa [MultiplicativeIdealFiltration.positiveLaurentReduction,
      laurentSeriesMap] using coefficientCompatibility

/-- For one matrix entry and loop exponent, the coefficients of the chosen
finite-level inverses form an explicit compatible quotient family. -/
noncomputable def MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeInverseCoefficientFamily
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (row column : Index) (exponent : ℤ) :
    DecreasingIdealFiltration.CompatibleQuotientFamily
      filtration.toDecreasingIdealFiltration where
  value level :=
    (filtration.positiveEvaluatedFlatGaugeInverseAtLevel
      parameter positive level connection row column).coeff exponent
  compatible level := by
    have matrixCompatibility :=
      filtration.positiveEvaluatedFlatGaugeInverseAtLevel_compatible
        parameter positive level connection
    have coefficientCompatibility := congrArg
      (fun matrix ↦ (matrix row column).coeff exponent)
      matrixCompatibility
    simpa [MultiplicativeIdealFiltration.positiveLaurentReduction,
      laurentSeriesMap] using coefficientCompatibility

/-- A compatible quotient family has a chosen representative in a coefficientwise
complete filtered ring. -/
noncomputable def CompleteSeparatedMultiplicativeIdealFiltration.liftCompatibleFamily
    {B : Type*} [CommRing B]
    (filtration : CompleteSeparatedMultiplicativeIdealFiltration B)
    (family : filtration.toMultiplicativeIdealFiltration.toDecreasingIdealFiltration
      |>.CompatibleQuotientFamily) : B :=
  Classical.choose (filtration.complete family)

/-- The chosen representative maps back to its original compatible quotient
family. -/
theorem CompleteSeparatedMultiplicativeIdealFiltration.ofRingElement_liftCompatibleFamily
    {B : Type*} [CommRing B]
    (filtration : CompleteSeparatedMultiplicativeIdealFiltration B)
    (family : filtration.toMultiplicativeIdealFiltration.toDecreasingIdealFiltration
      |>.CompatibleQuotientFamily) :
    filtration.toMultiplicativeIdealFiltration.toDecreasingIdealFiltration.ofRingElement
        (filtration.liftCompatibleFamily family) = family :=
  Classical.choose_spec (filtration.complete family)

/-- Elements of a separated filtered ring are equal when their images agree
in every filtration quotient. -/
theorem CompleteSeparatedMultiplicativeIdealFiltration.eq_of_quotient_mk_eq
    {B : Type*} [CommRing B]
    (filtration : CompleteSeparatedMultiplicativeIdealFiltration B)
    {left right : B}
    (equal : ∀ level,
      Ideal.Quotient.mk
          (filtration.toMultiplicativeIdealFiltration.ideal level) left =
        Ideal.Quotient.mk
          (filtration.toMultiplicativeIdealFiltration.ideal level) right) :
    left = right := by
  apply (filtration.toMultiplicativeIdealFiltration.toDecreasingIdealFiltration
    |>.ofRingElement_injective_iff_iInf_eq_bot.mpr filtration.separated)
  ext level
  exact equal level

/-- Under a Laurent lower bound uniform across quotient levels, lift the
coefficient families of the evaluated gauges to a Laurent-series matrix over
the complete separated base ring. -/
noncomputable def CompleteSeparatedMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeLimit
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : CompleteSeparatedMultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate,
      parameter coordinate ∈ filtration.toMultiplicativeIdealFiltration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (lowerBound : ℤ)
    (bounded : ∀ level row column exponent, exponent < lowerBound →
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeAtLevel
          parameter level connection row column).coeff exponent = 0) :
    Matrix Index Index (LaurentSeries B) :=
  fun row column ↦ HahnSeries.ofSuppBddBelow
    (fun exponent ↦ filtration.liftCompatibleFamily
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeCoefficientFamily
          parameter positive connection row column exponent)) (by
      refine ⟨lowerBound, ?_⟩
      intro exponent hsupport
      by_contra hbound
      have hexponent : exponent < lowerBound := lt_of_not_ge hbound
      have familyZero :
          (filtration.toMultiplicativeIdealFiltration
            |>.positiveEvaluatedFlatGaugeCoefficientFamily
              parameter positive connection row column exponent) = 0 := by
        ext level
        exact bounded level row column exponent hexponent
      apply hsupport
      apply (filtration.toMultiplicativeIdealFiltration.toDecreasingIdealFiltration
        |>.ofRingElement_injective_iff_iInf_eq_bot.mpr filtration.separated)
      rw [filtration.ofRingElement_liftCompatibleFamily, familyZero]
      rfl)

/-- Every coefficient of the lifted Laurent matrix reduces to the corresponding
coefficient of the finite evaluated gauge. -/
theorem CompleteSeparatedMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeLimit_coeff
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : CompleteSeparatedMultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate,
      parameter coordinate ∈ filtration.toMultiplicativeIdealFiltration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (lowerBound : ℤ)
    (bounded : ∀ level row column exponent, exponent < lowerBound →
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeAtLevel
          parameter level connection row column).coeff exponent = 0)
    (level : ℕ) (row column : Index) (exponent : ℤ) :
    Ideal.Quotient.mk
        (filtration.toMultiplicativeIdealFiltration.ideal level)
        ((filtration.positiveEvaluatedFlatGaugeLimit
          parameter positive connection lowerBound bounded row column).coeff exponent) =
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeAtLevel
          parameter level connection row column).coeff exponent := by
  have representation := congrArg
    (fun family ↦ family.value level)
    (filtration.ofRingElement_liftCompatibleFamily
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeCoefficientFamily
          parameter positive connection row column exponent))
  simpa [CompleteSeparatedMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeLimit,
    DecreasingIdealFiltration.ofRingElement_value,
    MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeCoefficientFamily]
    using representation

/-- The lifted Laurent matrix reduces entrywise to the finite evaluated gauge
at every quotient level. -/
theorem CompleteSeparatedMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeLimit_map
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : CompleteSeparatedMultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate,
      parameter coordinate ∈ filtration.toMultiplicativeIdealFiltration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (lowerBound : ℤ)
    (bounded : ∀ level row column exponent, exponent < lowerBound →
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeAtLevel
          parameter level connection row column).coeff exponent = 0)
    (level : ℕ) :
    (filtration.positiveEvaluatedFlatGaugeLimit
        parameter positive connection lowerBound bounded).map
        (laurentSeriesMap (Ideal.Quotient.mk
          (filtration.toMultiplicativeIdealFiltration.ideal level))) =
      filtration.toMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel
        parameter level connection := by
  ext row column exponent
  exact filtration.positiveEvaluatedFlatGaugeLimit_coeff
    parameter positive connection lowerBound bounded level row column exponent

/-- Under a Laurent lower bound uniform across quotient levels, lift the
coefficient families of the chosen finite-level inverses to a Laurent-series
matrix over the complete separated base ring. -/
noncomputable def CompleteSeparatedMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeInverseLimit
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : CompleteSeparatedMultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate,
      parameter coordinate ∈ filtration.toMultiplicativeIdealFiltration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (lowerBound : ℤ)
    (bounded : ∀ level row column exponent, exponent < lowerBound →
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeInverseAtLevel
          parameter positive level connection row column).coeff exponent = 0) :
    Matrix Index Index (LaurentSeries B) :=
  fun row column ↦ HahnSeries.ofSuppBddBelow
    (fun exponent ↦ filtration.liftCompatibleFamily
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeInverseCoefficientFamily
          parameter positive connection row column exponent)) (by
      refine ⟨lowerBound, ?_⟩
      intro exponent hsupport
      by_contra hbound
      have hexponent : exponent < lowerBound := lt_of_not_ge hbound
      have familyZero :
          (filtration.toMultiplicativeIdealFiltration
            |>.positiveEvaluatedFlatGaugeInverseCoefficientFamily
              parameter positive connection row column exponent) = 0 := by
        ext level
        exact bounded level row column exponent hexponent
      apply hsupport
      apply (filtration.toMultiplicativeIdealFiltration.toDecreasingIdealFiltration
        |>.ofRingElement_injective_iff_iInf_eq_bot.mpr filtration.separated)
      rw [filtration.ofRingElement_liftCompatibleFamily, familyZero]
      rfl)

/-- The lifted inverse Laurent matrix reduces to the chosen inverse at every
quotient level. -/
theorem CompleteSeparatedMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeInverseLimit_map
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : CompleteSeparatedMultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate,
      parameter coordinate ∈ filtration.toMultiplicativeIdealFiltration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (lowerBound : ℤ)
    (bounded : ∀ level row column exponent, exponent < lowerBound →
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeInverseAtLevel
          parameter positive level connection row column).coeff exponent = 0)
    (level : ℕ) :
    (filtration.positiveEvaluatedFlatGaugeInverseLimit
        parameter positive connection lowerBound bounded).map
        (laurentSeriesMap (Ideal.Quotient.mk
          (filtration.toMultiplicativeIdealFiltration.ideal level))) =
      filtration.toMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeInverseAtLevel
        parameter positive level connection := by
  ext row column exponent
  have representation := congrArg
    (fun family ↦ family.value level)
    (filtration.ofRingElement_liftCompatibleFamily
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeInverseCoefficientFamily
          parameter positive connection row column exponent))
  simpa [CompleteSeparatedMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeInverseLimit,
    DecreasingIdealFiltration.ofRingElement_value,
    MultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeInverseCoefficientFamily]
    using representation

/-- Uniform Laurent lower bounds for both the evaluated gauges and their
finite-level inverses assemble them into a two-sided-invertible Laurent matrix
over the complete separated base ring. -/
theorem CompleteSeparatedMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeLimit_inverse
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : CompleteSeparatedMultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate,
      parameter coordinate ∈ filtration.toMultiplicativeIdealFiltration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (gaugeLowerBound inverseLowerBound : ℤ)
    (gaugeBounded : ∀ level row column exponent, exponent < gaugeLowerBound →
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeAtLevel
          parameter level connection row column).coeff exponent = 0)
    (inverseBounded : ∀ level row column exponent, exponent < inverseLowerBound →
      (filtration.toMultiplicativeIdealFiltration
        |>.positiveEvaluatedFlatGaugeInverseAtLevel
          parameter positive level connection row column).coeff exponent = 0) :
    filtration.positiveEvaluatedFlatGaugeLimit
        parameter positive connection gaugeLowerBound gaugeBounded *
          filtration.positiveEvaluatedFlatGaugeInverseLimit
            parameter positive connection inverseLowerBound inverseBounded = 1 ∧
      filtration.positiveEvaluatedFlatGaugeInverseLimit
          parameter positive connection inverseLowerBound inverseBounded *
        filtration.positiveEvaluatedFlatGaugeLimit
          parameter positive connection gaugeLowerBound gaugeBounded = 1 := by
  let gauge := filtration.positiveEvaluatedFlatGaugeLimit
    parameter positive connection gaugeLowerBound gaugeBounded
  let inverse := filtration.positiveEvaluatedFlatGaugeInverseLimit
    parameter positive connection inverseLowerBound inverseBounded
  have proveIdentity (left right : Matrix Index Index (LaurentSeries B))
      (finiteIdentity : ∀ level,
        left.map (laurentSeriesMap (Ideal.Quotient.mk
          (filtration.toMultiplicativeIdealFiltration.ideal level))) *
          right.map (laurentSeriesMap (Ideal.Quotient.mk
            (filtration.toMultiplicativeIdealFiltration.ideal level))) = 1) :
      left * right = 1 := by
    ext row column exponent
    apply filtration.eq_of_quotient_mk_eq
    intro level
    have mappedMatrix :
        (left * right).map (laurentSeriesMap (Ideal.Quotient.mk
            (filtration.toMultiplicativeIdealFiltration.ideal level))) =
          (1 : Matrix Index Index (LaurentSeries B)).map
            (laurentSeriesMap (Ideal.Quotient.mk
              (filtration.toMultiplicativeIdealFiltration.ideal level))) := by
      rw [Matrix.map_mul, Matrix.map_one]
      exact finiteIdentity level
      exact (laurentSeriesMap (Ideal.Quotient.mk
        (filtration.toMultiplicativeIdealFiltration.ideal level))).map_zero
      exact (laurentSeriesMap (Ideal.Quotient.mk
        (filtration.toMultiplicativeIdealFiltration.ideal level))).map_one
    have mapped := congrArg
      (fun matrix ↦ (matrix row column).coeff exponent)
      mappedMatrix
    simpa [Matrix.map_mul, laurentSeriesMap_coeff] using mapped
  constructor
  · apply proveIdentity
    intro level
    rw [filtration.positiveEvaluatedFlatGaugeLimit_map,
      filtration.positiveEvaluatedFlatGaugeInverseLimit_map]
    exact (filtration.toMultiplicativeIdealFiltration
      |>.positiveEvaluatedFlatGaugeAtLevel_inverse
        parameter positive level connection).1
  · apply proveIdentity
    intro level
    rw [filtration.positiveEvaluatedFlatGaugeInverseLimit_map,
      filtration.positiveEvaluatedFlatGaugeLimit_map]
    exact (filtration.toMultiplicativeIdealFiltration
      |>.positiveEvaluatedFlatGaugeAtLevel_inverse
        parameter positive level connection).2

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
