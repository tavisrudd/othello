import Mathlib.Data.ENat.Lattice
import Mathlib.Data.Matrix.Auto
import Mathlib.RingTheory.DiscreteValuationRing.Basic
import Mathlib.Tactic

/-!
# Graph-coordinate block calculation and coefficient depths

This module verifies the algebraic calculation and ideal-intersection
arithmetic used in the graph coefficient lattice lemma.  The geometric
existence of a marked graph presentation and the reduction of its descent
condition to these displayed blocks remain separate inputs.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- The two-by-two block graph-coordinate change matrix, over an arbitrary
possibly noncommutative coefficient ring. -/
def graphChangeMatrix {S : Type*} [Ring S] (inverseDepth slope : S) :
    Matrix (Fin 2) (Fin 2) S :=
  !![inverseDepth, inverseDepth * slope; 0, 1]

/-- The alternating block matrix attached to a symmetric coefficient block. -/
def graphAlternatingMatrix {S : Type*} [Ring S] (coefficient : S) :
    Matrix (Fin 2) (Fin 2) S :=
  !![0, coefficient; -coefficient, 0]

/-- The block matrix obtained from the transpose of the graph-coordinate
change after naming the adjoint slope separately. -/
def graphTransposePartner {S : Type*} [Ring S]
    (inverseDepth adjointSlope : S) : Matrix (Fin 2) (Fin 2) S :=
  !![inverseDepth, 0; adjointSlope * inverseDepth, 1]

/-- The three nonzero blocks appearing in the graph descent calculation. -/
def graphDescentBlockMatrix {S : Type*} [Ring S]
    (inverseDepth slope adjointSlope coefficient : S) :
    Matrix (Fin 2) (Fin 2) S :=
  !![inverseDepth * (coefficient * adjointSlope - slope * coefficient) * inverseDepth,
      inverseDepth * coefficient;
      -coefficient * inverseDepth,
      0]

/-- Direct noncommutative verification of the manuscript's graph-coordinate
matrix identity. -/
theorem graphChange_mul_alternating_mul_transposePartner
    {S : Type*} [Ring S]
    (inverseDepth slope adjointSlope coefficient : S) :
    graphChangeMatrix inverseDepth slope *
        graphAlternatingMatrix coefficient *
        graphTransposePartner inverseDepth adjointSlope =
      graphDescentBlockMatrix inverseDepth slope adjointSlope coefficient := by
  ext row column
  fin_cases row <;> fin_cases column
  all_goals
    simp [graphChangeMatrix, graphAlternatingMatrix, graphTransposePartner,
      graphDescentBlockMatrix, Matrix.mul_apply, Fin.sum_univ_two]
    try noncomm_ring

/-- Entrywise integrality of the graph-coordinate product is equivalent to
integrality of its three displayed nonzero blocks.  The predicate is kept
abstract so the statement applies equally to a subring, an order, or a
lattice-valued block model; only integrality of zero is used. -/
theorem graphChange_product_entrywise_iff_three_blocks
    {S : Type*} [Ring S]
    (inverseDepth slope adjointSlope coefficient : S)
    (integral : S → Prop) (integralZero : integral 0) :
    (∀ row column,
      integral ((graphChangeMatrix inverseDepth slope *
          graphAlternatingMatrix coefficient *
          graphTransposePartner inverseDepth adjointSlope) row column)) ↔
      integral
          (inverseDepth * (coefficient * adjointSlope - slope * coefficient) *
            inverseDepth) ∧
        integral (inverseDepth * coefficient) ∧
        integral (-coefficient * inverseDepth) := by
  rw [graphChange_mul_alternating_mul_transposePartner]
  constructor
  · intro allEntries
    exact ⟨allEntries 0 0, allEntries 0 1, allEntries 1 0⟩
  · rintro ⟨upperLeft, upperRight, lowerLeft⟩ row column
    fin_cases row <;> fin_cases column
    · exact upperLeft
    · exact upperRight
    · exact lowerLeft
    · simpa [graphDescentBlockMatrix] using integralZero

/-- Adjointness for an invertible coefficient form may be written either in
the dual-form convention `Tᵃ B⁻¹ = B⁻¹ T` or, equivalently, as
`B Tᵃ = T B`.  The statement is noncommutative and therefore applies
directly to matrix blocks. -/
theorem dualForm_adjoint_iff_coefficient_adjoint
    {S : Type*} [Ring S]
    (coefficientForm inverseCoefficientForm slope adjointSlope : S)
    (leftInverse : inverseCoefficientForm * coefficientForm = 1)
    (rightInverse : coefficientForm * inverseCoefficientForm = 1) :
    adjointSlope * inverseCoefficientForm = inverseCoefficientForm * slope ↔
      coefficientForm * adjointSlope = slope * coefficientForm := by
  constructor <;> intro adjoint
  · calc
      coefficientForm * adjointSlope =
          (coefficientForm * adjointSlope) *
            (inverseCoefficientForm * coefficientForm) := by
              rw [leftInverse, mul_one]
      _ = coefficientForm *
          (adjointSlope * inverseCoefficientForm) * coefficientForm := by
            simp only [mul_assoc]
      _ = coefficientForm *
          (inverseCoefficientForm * slope) * coefficientForm := by rw [adjoint]
      _ = (coefficientForm * inverseCoefficientForm) * slope *
          coefficientForm := by simp only [mul_assoc]
      _ = slope * coefficientForm := by rw [rightInverse, one_mul]
  · calc
      adjointSlope * inverseCoefficientForm =
          (inverseCoefficientForm * coefficientForm) *
            (adjointSlope * inverseCoefficientForm) := by
              rw [leftInverse, one_mul]
      _ = inverseCoefficientForm * (coefficientForm * adjointSlope) *
          inverseCoefficientForm := by simp only [mul_assoc]
      _ = inverseCoefficientForm * (slope * coefficientForm) *
          inverseCoefficientForm := by rw [adjoint]
      _ = inverseCoefficientForm * slope *
          (coefficientForm * inverseCoefficientForm) := by simp only [mul_assoc]
      _ = inverseCoefficientForm * slope := by rw [rightInverse, mul_one]

/-- Expansion of the slope commutator after writing each slope as a scalar
part plus a depth-divisible error.  Centrality hypotheses express that the
displayed scalar parts are scalar matrices on their blocks. -/
theorem slopeCommutator_expansion
    {S : Type*} [Ring S]
    (coefficient firstScalar secondScalar firstPower secondPower
      firstError secondError : S)
    (firstScalarCentral : firstScalar * coefficient = coefficient * firstScalar)
    (secondScalarCentral : coefficient * secondScalar = secondScalar * coefficient)
    (secondPowerCentral : coefficient * secondPower = secondPower * coefficient) :
    coefficient * (secondScalar + secondPower * secondError) -
        (firstScalar + firstPower * firstError) * coefficient =
      (secondScalar - firstScalar) * coefficient +
        secondPower * (coefficient * secondError) -
        firstPower * (firstError * coefficient) := by
  rw [mul_add, add_mul]
  rw [← mul_assoc coefficient secondPower secondError, secondPowerCentral,
    mul_assoc secondPower coefficient secondError]
  noncomm_ring [firstScalarCentral, secondScalarCentral]

/-- Truncated subtraction by an extended valuation, with infinite valuation
contributing no additional depth. -/
def truncatedDepthDifference (total : ℕ) (valuation : ℕ∞) : ℕ :=
  valuation.recTopCoe 0 (fun finiteValue ↦ total - finiteValue)

/-- The cross depth obtained by intersecting the two off-diagonal
integrality conditions with the slope-difference condition. -/
def graphCrossDepth
    (firstDepth secondDepth : ℕ) (slopeDifferenceValuation : ℕ∞) : ℕ :=
  max firstDepth
    (max secondDepth
      (truncatedDepthDifference (firstDepth + secondDepth)
        slopeDifferenceValuation))

/-- The part of the slope-difference valuation visible to the cross-depth
formula: values at or above the smaller diagonal depth are indistinguishable. -/
def effectiveSlopeDifferenceValuation
    (firstDepth secondDepth : ℕ) (slopeDifferenceValuation : ℕ∞) : ℕ :=
  slopeDifferenceValuation.recTopCoe (min firstDepth secondDepth)
    (fun finiteValue ↦ min finiteValue (min firstDepth secondDepth))

/-- Infinite slope-difference valuation truncates to the smaller depth. -/
theorem effectiveSlopeDifferenceValuation_top
    (firstDepth secondDepth : ℕ) :
    effectiveSlopeDifferenceValuation firstDepth secondDepth ⊤ =
      min firstDepth secondDepth :=
  rfl

/-- A finite slope-difference valuation truncates by taking the minimum with
the smaller depth. -/
theorem effectiveSlopeDifferenceValuation_coe
    (firstDepth secondDepth finiteValue : ℕ) :
    effectiveSlopeDifferenceValuation firstDepth secondDepth
        (finiteValue : ℕ∞) =
      min finiteValue (min firstDepth secondDepth) :=
  rfl

/-- A valuation at least the smaller diagonal depth has maximal effective
value. -/
theorem effectiveSlopeDifferenceValuation_eq_minDepth_of_le
    (firstDepth secondDepth : ℕ) (valuation : ℕ∞)
    (deep : (min firstDepth secondDepth : ℕ∞) ≤ valuation) :
    effectiveSlopeDifferenceValuation firstDepth secondDepth valuation =
      min firstDepth secondDepth := by
  induction valuation using ENat.recTopCoe with
  | top => rfl
  | coe finiteValue =>
      rw [effectiveSlopeDifferenceValuation_coe, min_eq_right]
      exact ENat.coe_le_coe.mp (by simpa using deep)

/-- Adding an error of valuation at least the smaller diagonal depth does not
change the effective slope-difference valuation. -/
theorem effectiveSlopeDifferenceValuation_add_high
    {R : Type*} [Ring R] (valuation : AddValuation R ℕ∞)
    (firstDepth secondDepth : ℕ) (original error : R)
    (errorDeep : (min firstDepth secondDepth : ℕ∞) ≤ valuation error) :
    effectiveSlopeDifferenceValuation firstDepth secondDepth
        (valuation (original + error)) =
      effectiveSlopeDifferenceValuation firstDepth secondDepth
        (valuation original) := by
  by_cases originalDeep :
      (min firstDepth secondDepth : ℕ∞) ≤ valuation original
  · have sumDeep :
        (min firstDepth secondDepth : ℕ∞) ≤
          valuation (original + error) :=
      valuation.map_le_add originalDeep errorDeep
    rw [effectiveSlopeDifferenceValuation_eq_minDepth_of_le
        firstDepth secondDepth _ sumDeep,
      effectiveSlopeDifferenceValuation_eq_minDepth_of_le
        firstDepth secondDepth _ originalDeep]
  · have originalShallow :
        valuation original < (min firstDepth secondDepth : ℕ∞) :=
      lt_of_not_ge originalDeep
    have unequal : valuation original < valuation error :=
      originalShallow.trans_le errorDeep
    rw [valuation.map_add_eq_of_lt_left unequal]

/-- Divisibility by the maximum of two powers is equivalent to simultaneous
divisibility by both powers. -/
theorem pow_max_dvd_iff
    {R : Type*} [CommRing R] (uniformizer value : R) (first second : ℕ) :
    uniformizer ^ max first second ∣ value ↔
      uniformizer ^ first ∣ value ∧ uniformizer ^ second ∣ value := by
  constructor
  · intro maximumDivides
    exact ⟨(pow_dvd_pow uniformizer (le_max_left first second)).trans maximumDivides,
      (pow_dvd_pow uniformizer (le_max_right first second)).trans maximumDivides⟩
  · rintro ⟨firstDivides, secondDivides⟩
    rcases le_total first second with ordered | ordered
    · simpa [max_eq_right ordered] using secondDivides
    · simpa [max_eq_left ordered] using firstDivides

/-- The graph cross-depth power is exactly the intersection of the three
displayed power-divisibility conditions. -/
theorem pow_graphCrossDepth_dvd_iff
    {R : Type*} [CommRing R] (uniformizer value : R)
    (firstDepth secondDepth : ℕ) (slopeDifferenceValuation : ℕ∞) :
    uniformizer ^ graphCrossDepth firstDepth secondDepth slopeDifferenceValuation ∣ value ↔
      uniformizer ^ firstDepth ∣ value ∧
      uniformizer ^ secondDepth ∣ value ∧
      uniformizer ^ truncatedDepthDifference (firstDepth + secondDepth)
        slopeDifferenceValuation ∣ value := by
  rw [graphCrossDepth, pow_max_dvd_iff, pow_max_dvd_iff]

/-- Infinite slope-difference valuation removes the additional commutator
depth condition. -/
theorem graphCrossDepth_top
    (firstDepth secondDepth : ℕ) :
    graphCrossDepth firstDepth secondDepth ⊤ = max firstDepth secondDepth := by
  simp [graphCrossDepth, truncatedDepthDifference]

/-- At a finite slope-difference valuation, the cross depth is the maximum
of the two diagonal depths and the truncated valuation deficit. -/
theorem graphCrossDepth_coe
    (firstDepth secondDepth finiteValue : ℕ) :
    graphCrossDepth firstDepth secondDepth (finiteValue : ℕ∞) =
      max firstDepth (max secondDepth (firstDepth + secondDepth - finiteValue)) := by
  rfl

/-- The depth formula depends only on the slope-difference valuation truncated
at the smaller diagonal depth.  This is the arithmetic content behind
independence from the choice of scalar lifts. -/
theorem graphCrossDepth_eq_effectiveSlopeDifference
    (firstDepth secondDepth : ℕ) (slopeDifferenceValuation : ℕ∞) :
    graphCrossDepth firstDepth secondDepth slopeDifferenceValuation =
      max firstDepth
        (max secondDepth
          (firstDepth + secondDepth -
            effectiveSlopeDifferenceValuation
              firstDepth secondDepth slopeDifferenceValuation)) := by
  induction slopeDifferenceValuation using ENat.recTopCoe with
  | top =>
      calc
        graphCrossDepth firstDepth secondDepth ⊤ =
            max firstDepth secondDepth := graphCrossDepth_top _ _
        _ = max firstDepth
            (max secondDepth
              (firstDepth + secondDepth - min firstDepth secondDepth)) := by omega
        _ = max firstDepth
            (max secondDepth
              (firstDepth + secondDepth -
                effectiveSlopeDifferenceValuation firstDepth secondDepth ⊤)) := by
          rw [effectiveSlopeDifferenceValuation_top]
  | coe finiteValue =>
      calc
        graphCrossDepth firstDepth secondDepth (finiteValue : ℕ∞) =
            max firstDepth
              (max secondDepth
                (firstDepth + secondDepth - finiteValue)) :=
          graphCrossDepth_coe _ _ _
        _ = max firstDepth
            (max secondDepth
              (firstDepth + secondDepth -
                min finiteValue (min firstDepth secondDepth))) := by omega
        _ = max firstDepth
            (max secondDepth
              (firstDepth + secondDepth -
                effectiveSlopeDifferenceValuation firstDepth secondDepth
                  (finiteValue : ℕ∞))) := by
          rw [effectiveSlopeDifferenceValuation_coe]

/-- Equal effective slope valuations give equal cross depths, even when the
chosen scalar lifts have different untruncated valuations. -/
theorem graphCrossDepth_eq_of_effectiveSlopeDifference_eq
    (firstDepth secondDepth : ℕ)
    {firstValuation secondValuation : ℕ∞}
    (effectiveEqual :
      effectiveSlopeDifferenceValuation firstDepth secondDepth firstValuation =
        effectiveSlopeDifferenceValuation firstDepth secondDepth secondValuation) :
    graphCrossDepth firstDepth secondDepth firstValuation =
      graphCrossDepth firstDepth secondDepth secondValuation := by
  rw [graphCrossDepth_eq_effectiveSlopeDifference,
    graphCrossDepth_eq_effectiveSlopeDifference, effectiveEqual]

/-- Changing scalar slope lifts by the prescribed diagonal-depth ideals does
not change the graph cross depth in a discrete valuation ring. -/
theorem graphCrossDepth_eq_of_dvr_scalar_lifts
    {R : Type*} [CommRing R] [IsDomain R] [IsDiscreteValuationRing R]
    {uniformizer : R} (uniformizerIrreducible : Irreducible uniformizer)
    (firstDepth secondDepth : ℕ)
    (firstSlope secondSlope firstLift secondLift : R)
    (firstCongruent : uniformizer ^ firstDepth ∣ firstLift - firstSlope)
    (secondCongruent : uniformizer ^ secondDepth ∣ secondLift - secondSlope) :
    graphCrossDepth firstDepth secondDepth
        (IsDiscreteValuationRing.addVal R (secondSlope - firstSlope)) =
      graphCrossDepth firstDepth secondDepth
        (IsDiscreteValuationRing.addVal R (secondLift - firstLift)) := by
  let valuation := IsDiscreteValuationRing.addVal R
  have firstErrorDeep : (firstDepth : ℕ∞) ≤
      valuation (firstLift - firstSlope) := by
    rw [← uniformizerIrreducible.addVal_pow,
      IsDiscreteValuationRing.addVal_le_iff_dvd]
    exact firstCongruent
  have secondErrorDeep : (secondDepth : ℕ∞) ≤
      valuation (secondLift - secondSlope) := by
    rw [← uniformizerIrreducible.addVal_pow,
      IsDiscreteValuationRing.addVal_le_iff_dvd]
    exact secondCongruent
  have firstAtMinimum : (min firstDepth secondDepth : ℕ∞) ≤
      valuation (firstLift - firstSlope) :=
    (ENat.coe_le_coe.mpr (min_le_left firstDepth secondDepth)).trans firstErrorDeep
  have secondAtMinimum : (min firstDepth secondDepth : ℕ∞) ≤
      valuation (secondLift - secondSlope) :=
    (ENat.coe_le_coe.mpr (min_le_right firstDepth secondDepth)).trans secondErrorDeep
  have errorDeep : (min firstDepth secondDepth : ℕ∞) ≤
      valuation ((secondLift - secondSlope) - (firstLift - firstSlope)) :=
    valuation.map_le_sub secondAtMinimum firstAtMinimum
  have effectiveEqual := effectiveSlopeDifferenceValuation_add_high
    valuation firstDepth secondDepth (secondSlope - firstSlope)
      ((secondLift - secondSlope) - (firstLift - firstSlope)) errorDeep
  have differenceIdentity :
      (secondSlope - firstSlope) +
          ((secondLift - secondSlope) - (firstLift - firstSlope)) =
        secondLift - firstLift := by
    ring
  rw [differenceIdentity] at effectiveEqual
  exact graphCrossDepth_eq_of_effectiveSlopeDifference_eq
    firstDepth secondDepth effectiveEqual.symm

/-- Every graph cross depth dominates both diagonal depths and therefore
satisfies the midpoint inequality. -/
theorem graphCrossDepth_midpoint
    (firstDepth secondDepth : ℕ) (slopeDifferenceValuation : ℕ∞) :
    firstDepth + secondDepth ≤
      2 * graphCrossDepth firstDepth secondDepth slopeDifferenceValuation := by
  have firstBound : firstDepth ≤
      graphCrossDepth firstDepth secondDepth slopeDifferenceValuation :=
    le_max_left _ _
  have secondBound : secondDepth ≤
      graphCrossDepth firstDepth secondDepth slopeDifferenceValuation :=
    (le_max_left secondDepth _).trans (le_max_right firstDepth _)
  omega

/-- The unit-to-positive-depth cross block has the asserted depth and obeys
the same midpoint inequality with unit depth zero. -/
theorem unitCrossDepth_midpoint (positiveDepth : ℕ) :
    0 + positiveDepth ≤ 2 * positiveDepth := by
  omega

/-- Pairing a depth-zero unit block with a positive-depth block gives exactly
the positive depth, independently of the slope-difference valuation. -/
theorem graphCrossDepth_unit_positive
    (positiveDepth : ℕ) (slopeDifferenceValuation : ℕ∞) :
    graphCrossDepth 0 positiveDepth slopeDifferenceValuation = positiveDepth := by
  induction slopeDifferenceValuation using ENat.recTopCoe with
  | top => simp [graphCrossDepth_top]
  | coe finiteValue =>
      rw [graphCrossDepth_coe]
      omega

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
