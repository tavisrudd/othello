import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.MatrixOfIdeals
import Mathlib.Data.ENat.Lattice
import Mathlib.RingTheory.DiscreteValuationRing.Basic
import Mathlib.Tactic

/-!
# Rank-one generation with a normalized discrete valuation

This module supplies the valuation-theoretic necessity missing from the
division-free construction.  The structure below records exactly the
normalized discrete-valuation facts used by the manuscript proof: valuation
of zero, multiplicativity, the ultrametric inequality, value one for the
chosen uniformizer, and equivalence between valuation depth and divisibility
by uniformizer powers.  Completeness and unramifiedness play no role in this
algebraic lemma.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

variable {Index R : Type*} [CommRing R]

/-- The normalized discrete-valuation interface used in the rank-one
generation criterion. -/
structure NormalizedDVRValuation (uniformizer : R) where
  /-- The additive valuation, with infinity assigned to zero. -/
  valuation : R → WithTop ℕ
  /-- Zero has infinite valuation. -/
  valuation_zero : valuation 0 = ⊤
  /-- One has valuation zero. -/
  valuation_one : valuation 1 = 0
  /-- Valuation is additive on products. -/
  valuation_mul : ∀ left right, valuation (left * right) =
    valuation left + valuation right
  /-- The ultrametric lower bound for sums. -/
  valuation_add : ∀ left right, min (valuation left) (valuation right) ≤
    valuation (left + right)
  /-- The chosen uniformizer has normalized value one. -/
  valuation_uniformizer : valuation uniformizer = 1
  /-- Divisibility by a uniformizer power is exactly the corresponding
  valuation lower bound. -/
  power_dvd_iff : ∀ (exponent : ℕ) (value : R),
    uniformizer ^ exponent ∣ value ↔
      (exponent : WithTop ℕ) ≤ valuation value

namespace NormalizedDVRValuation

variable {uniformizer : R}

/-- Mathlib's additive valuation on a discrete valuation ring, normalized at
an irreducible uniformizer, supplies the abstract interface used below. -/
noncomputable def ofIsDiscreteValuationRing
    [IsDomain R] [IsDiscreteValuationRing R]
    (uniformizerIrreducible : Irreducible uniformizer) :
    NormalizedDVRValuation uniformizer where
  valuation := IsDiscreteValuationRing.addVal R
  valuation_zero := (IsDiscreteValuationRing.addVal R).map_zero
  valuation_one := (IsDiscreteValuationRing.addVal R).map_one
  valuation_mul := fun _ _ ↦ IsDiscreteValuationRing.addVal_mul
  valuation_add := fun _ _ ↦ IsDiscreteValuationRing.addVal_add
  valuation_uniformizer :=
    IsDiscreteValuationRing.addVal_uniformizer uniformizerIrreducible
  power_dvd_iff := by
    intro exponent value
    rw [← IsDiscreteValuationRing.addVal_le_iff_dvd,
      uniformizerIrreducible.addVal_pow]
    rfl

/-- The normalized valuation of a power of the uniformizer is its exponent. -/
theorem valuation_uniformizer_pow
    (data : NormalizedDVRValuation uniformizer) (exponent : ℕ) :
    data.valuation (uniformizer ^ exponent) = (exponent : WithTop ℕ) := by
  induction exponent with
  | zero =>
      simpa using data.valuation_one
  | succ exponent inductionHypothesis =>
      rw [pow_succ, data.valuation_mul, inductionHypothesis,
        data.valuation_uniformizer]
      simp

end NormalizedDVRValuation

/-- The sum of the two diagonal depths is at most twice the valuation of the
mixed entry of any internal rank-one generator. -/
theorem rankOne_mixedDepthBound
    [DecidableEq Index]
    {uniformizer : R} (data : NormalizedDVRValuation uniformizer)
    (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (coefficient : R) (vector : Index → R)
    (member : MemWeightedMatrix uniformizer diagonal cross
      (matrixRankOne coefficient vector))
    (first second : Index) :
    ((diagonal first + diagonal second : ℕ) : WithTop ℕ) ≤
      2 * data.valuation
        (matrixRankOne coefficient vector first second) := by
  have firstDivisibility := member.2.1 first
  have secondDivisibility := member.2.1 second
  have firstBound := (data.power_dvd_iff
    (diagonal first) (matrixRankOne coefficient vector first first)).mp
      firstDivisibility
  have secondBound := (data.power_dvd_iff
    (diagonal second) (matrixRankOne coefficient vector second second)).mp
      secondDivisibility
  simp only [matrixRankOne, data.valuation_mul] at firstBound secondBound ⊢
  calc
    ((diagonal first + diagonal second : ℕ) : WithTop ℕ) =
        (diagonal first : WithTop ℕ) + (diagonal second : WithTop ℕ) := by simp
    _ ≤ (data.valuation coefficient + data.valuation (vector first) +
          data.valuation (vector first)) +
        (data.valuation coefficient + data.valuation (vector second) +
          data.valuation (vector second)) :=
      add_le_add firstBound secondBound
    _ = 2 * (data.valuation coefficient + data.valuation (vector first) +
          data.valuation (vector second)) := by
      rw [two_mul]
      ac_rfl

/-- The same mixed-depth bound holds for every element of the internal
rank-one span. -/
theorem weightedRankOneSpan_mixedDepthBound
    [DecidableEq Index]
    {uniformizer : R} (data : NormalizedDVRValuation uniformizer)
    (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (first second : Index) (form : Matrix Index Index R)
    (spanMember : form ∈ weightedRankOneSpan uniformizer diagonal cross) :
    ((diagonal first + diagonal second : ℕ) : WithTop ℕ) ≤
      2 * data.valuation (form first second) := by
  change form ∈ Submodule.span R
    (weightedRankOneSet uniformizer diagonal cross) at spanMember
  refine Submodule.span_induction (p := fun candidate _ ↦
      ((diagonal first + diagonal second : ℕ) : WithTop ℕ) ≤
        2 * data.valuation (candidate first second)) ?_ ?_ ?_ ?_ spanMember
  · intro candidate generator
    rcases generator with ⟨coefficient, vector, rfl, member⟩
    exact rankOne_mixedDepthBound data diagonal cross coefficient vector
      member first second
  · simp [data.valuation_zero]
  · intro left right _ _ leftBound rightBound
    rw [Matrix.add_apply]
    have minimumBound :
        ((diagonal first + diagonal second : ℕ) : WithTop ℕ) ≤
          2 * min (data.valuation (left first second))
            (data.valuation (right first second)) := by
      rcases le_total (data.valuation (left first second))
          (data.valuation (right first second)) with ordered | ordered
      · simpa [min_eq_left ordered] using leftBound
      · simpa [min_eq_right ordered] using rightBound
    have doubled := mul_le_mul_right (data.valuation_add
      (left first second) (right first second)) 2
    exact minimumBound.trans (by simpa [mul_comm] using doubled)
  · intro scalar candidate _ candidateBound
    rw [Matrix.smul_apply, smul_eq_mul, data.valuation_mul]
    have increased : data.valuation (candidate first second) ≤
        data.valuation scalar + data.valuation (candidate first second) :=
      le_add_of_nonneg_left bot_le
    have doubled := mul_le_mul_right increased 2
    exact candidateBound.trans (by simpa [mul_comm] using doubled)

/-- Exact rank-one generation forces every pairwise midpoint inequality. -/
theorem pairwise_midpoint_of_weightedMatrixRankOneGenerated
    [Fintype Index] [DecidableEq Index] [LinearOrder Index]
    {uniformizer : R} (data : NormalizedDVRValuation uniformizer)
    (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (crossSymmetric : ∀ row column, cross row column = cross column row)
    (generated : WeightedMatrixRankOneGenerated uniformizer diagonal cross) :
    ∀ first second, first ≠ second →
      diagonal first + diagonal second ≤ 2 * cross first second := by
  intro first second distinct
  let atom := crossAtom first second (uniformizer ^ cross first second)
  have latticeMember : atom ∈
      weightedMatrixSubmodule uniformizer diagonal cross :=
    crossAtom_uniformizerPower_mem_weightedMatrix
      uniformizer diagonal cross crossSymmetric distinct
  have spanMember : atom ∈ weightedRankOneSpan uniformizer diagonal cross := by
    rw [← generated]
    exact latticeMember
  have valuationBound := weightedRankOneSpan_mixedDepthBound
    data diagonal cross first second atom spanMember
  have atomEntry : atom first second = uniformizer ^ cross first second := by
    simp [atom, crossAtom]
  rw [atomEntry, data.valuation_uniformizer_pow] at valuationBound
  exact_mod_cast valuationBound

/-- Over the normalized discrete-valuation interface, a finite symmetric
matrix-of-ideals lattice is generated by its internal rank-one forms exactly
when every pair of depths satisfies the midpoint inequality. -/
theorem weightedMatrixRankOneGenerated_iff_pairwise_midpoint
    [Fintype Index] [DecidableEq Index] [LinearOrder Index]
    {uniformizer : R} (data : NormalizedDVRValuation uniformizer)
    (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (crossSymmetric : ∀ row column, cross row column = cross column row) :
    WeightedMatrixRankOneGenerated uniformizer diagonal cross ↔
      ∀ first second, first ≠ second →
        diagonal first + diagonal second ≤ 2 * cross first second := by
  constructor
  · exact pairwise_midpoint_of_weightedMatrixRankOneGenerated
      data diagonal cross crossSymmetric
  · exact weightedMatrixRankOneGenerated_of_pairwise_midpoint
      uniformizer diagonal cross crossSymmetric

/-- The rank-one generation criterion stated directly for Mathlib's discrete
valuation rings and an irreducible uniformizer.  Completeness and
unramifiedness are not required for this algebraic equivalence. -/
theorem weightedMatrixRankOneGenerated_iff_pairwise_midpoint_of_dvr
    [Fintype Index] [DecidableEq Index] [LinearOrder Index]
    [IsDomain R] [IsDiscreteValuationRing R]
    {uniformizer : R} (uniformizerIrreducible : Irreducible uniformizer)
    (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (crossSymmetric : ∀ row column, cross row column = cross column row) :
    WeightedMatrixRankOneGenerated uniformizer diagonal cross ↔
      ∀ first second, first ≠ second →
        diagonal first + diagonal second ≤ 2 * cross first second :=
  weightedMatrixRankOneGenerated_iff_pairwise_midpoint
    (NormalizedDVRValuation.ofIsDiscreteValuationRing uniformizerIrreducible)
    diagonal cross crossSymmetric

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
