import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.RankOneGeneration
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.MatrixOfIdeals
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.DVRRankOne
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.AllDegreeAssembly
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.GraphCoefficientDepth
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.GraphCoefficientBlocks
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.LocalGlobalMembership
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.DividedPowers
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisGram
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisLocalChart
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisSlopeModels
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.PrincipalGluingPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.FrobeniusPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.TraceDeterminantPairing
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.ExoticStabilizerCore
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.AlternatingFiveIdentification
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.FrobeniusNormalizer
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FramedMultiplicity
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.WeakFactorization
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.NovikovAdmissibility
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ProLaurent
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.MonodromyBaseChange
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.NumericalNovikov
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FormalBaseShift
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CubicPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.GenusEightThreefold

/-!
# Reviewer interface for the cubic-stabilization companion

This is the public mathematical entry point for the Lean companion.  It
exports the division-free rank-one identity and the abstract telescope behind
birational invariance of packet multiplicities.  The manuscript-to-declaration
map distinguishes these kernel-checked deductions from geometric and quantum
comparison theorems that have not been formalized from foundations.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

open scoped MatrixGroups

/-- Public form of the division-free identity used in the rank-one generation
argument for symmetric matrix-of-ideals lattices. -/
theorem rankOne_mixed_coefficient_identity
    {R : Type*} [CommRing R] (c a b : R) :
    GraphLattices.SymmetricPair.sub
          (GraphLattices.SymmetricPair.sub
            (GraphLattices.SymmetricPair.scale c
              (GraphLattices.SymmetricPair.rankOne a b))
            (GraphLattices.SymmetricPair.scale (c * a * a)
              GraphLattices.SymmetricPair.firstSquare))
          (GraphLattices.SymmetricPair.scale (c * b * b)
            GraphLattices.SymmetricPair.secondSquare) =
      { diagonalFirst := 0, mixed := c * a * b, diagonalSecond := 0 } :=
  GraphLattices.SymmetricPair.scaled_rankOne_sub_diagonals c a b

/-- The midpoint inequality produces the parity-compatible exponents used in
the integral rank-one decomposition. -/
theorem rankOne_midpoint_exponents
    (diagonalFirst diagonalSecond cross : ℕ)
    (midpoint : diagonalFirst + diagonalSecond ≤ 2 * cross) :
    ∃ t r s : ℕ,
      diagonalFirst ≤ t + 2 * r ∧
      diagonalSecond ≤ t + 2 * s ∧
      cross = t + r + s :=
  GraphLattices.exists_midpoint_exponents
    diagonalFirst diagonalSecond cross midpoint

/-- Every multiple of a cross-ideal generator has the explicit division-free
three-rank-one decomposition supplied by the midpoint inequality. -/
theorem rankOne_cross_coefficient_decomposition
    {R : Type*} [CommRing R]
    (π z : R) (diagonalFirst diagonalSecond cross : ℕ)
    (midpoint : diagonalFirst + diagonalSecond ≤ 2 * cross) :
    ∃ t r s : ℕ,
      diagonalFirst ≤ t + 2 * r ∧
      diagonalSecond ≤ t + 2 * s ∧
      GraphLattices.SymmetricPair.sub
          (GraphLattices.SymmetricPair.sub
            (GraphLattices.SymmetricPair.scale (z * π ^ t)
              (GraphLattices.SymmetricPair.rankOne (π ^ r) (π ^ s)))
            (GraphLattices.SymmetricPair.scale
              ((z * π ^ t) * π ^ r * π ^ r)
              GraphLattices.SymmetricPair.firstSquare))
          (GraphLattices.SymmetricPair.scale
            ((z * π ^ t) * π ^ s * π ^ s)
            GraphLattices.SymmetricPair.secondSquare) =
        { diagonalFirst := 0, mixed := z * π ^ cross, diagonalSecond := 0 } :=
  GraphLattices.SymmetricPair.cross_coefficient_rankOne_decomposition
    π z diagonalFirst diagonalSecond cross midpoint

/-- Every member of a two-coordinate matrix-of-ideals lattice satisfying the
midpoint inequality is assembled from five explicitly displayed rank-one forms
that all remain in that same lattice. -/
theorem rankOne_weightedPair_decomposition_of_midpoint
    {R : Type*} [CommRing R]
    (π : R) (diagonalFirst diagonalSecond cross : ℕ)
    (midpoint : diagonalFirst + diagonalSecond ≤ 2 * cross)
    (form : GraphLattices.SymmetricPair R)
    (member : GraphLattices.SymmetricPair.MemWeightedPair
      π diagonalFirst diagonalSecond cross form) :
    ∃ firstCoefficient mixedCoefficient secondCoefficient : R,
      ∃ t r s : ℕ,
        diagonalFirst ≤ t + 2 * r ∧
        diagonalSecond ≤ t + 2 * s ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale
            (π ^ diagonalFirst * firstCoefficient)
            GraphLattices.SymmetricPair.firstSquare) ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale
            (π ^ diagonalSecond * secondCoefficient)
            GraphLattices.SymmetricPair.secondSquare) ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale (mixedCoefficient * π ^ t)
            (GraphLattices.SymmetricPair.rankOne (π ^ r) (π ^ s))) ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale
            ((mixedCoefficient * π ^ t) * π ^ r * π ^ r)
            GraphLattices.SymmetricPair.firstSquare) ∧
        GraphLattices.SymmetricPair.MemWeightedPair
          π diagonalFirst diagonalSecond cross
          (GraphLattices.SymmetricPair.scale
            ((mixedCoefficient * π ^ t) * π ^ s * π ^ s)
            GraphLattices.SymmetricPair.secondSquare) ∧
        form =
          GraphLattices.SymmetricPair.add
            (GraphLattices.SymmetricPair.scale
              (π ^ diagonalFirst * firstCoefficient)
              GraphLattices.SymmetricPair.firstSquare)
            (GraphLattices.SymmetricPair.add
              (GraphLattices.SymmetricPair.scale
                (π ^ diagonalSecond * secondCoefficient)
                GraphLattices.SymmetricPair.secondSquare)
              (GraphLattices.SymmetricPair.sub
                (GraphLattices.SymmetricPair.sub
                  (GraphLattices.SymmetricPair.scale (mixedCoefficient * π ^ t)
                    (GraphLattices.SymmetricPair.rankOne (π ^ r) (π ^ s)))
                  (GraphLattices.SymmetricPair.scale
                    ((mixedCoefficient * π ^ t) * π ^ r * π ^ r)
                    GraphLattices.SymmetricPair.firstSquare))
                (GraphLattices.SymmetricPair.scale
                  ((mixedCoefficient * π ^ t) * π ^ s * π ^ s)
                  GraphLattices.SymmetricPair.secondSquare))) :=
  GraphLattices.SymmetricPair.weightedPair_decomposition_of_midpoint
    π diagonalFirst diagonalSecond cross midpoint form member

/-- Constructive sufficiency for an arbitrary finite symmetric
matrix-of-ideals lattice: pairwise midpoint inequalities imply that every
lattice member lies in the span of rank-one forms internal to the lattice.
This statement is ring-theoretic and does not assert the valuation-theoretic
necessity direction of the manuscript's DVR equivalence. -/
theorem rankOne_finiteMatrix_generation_of_pairwise_midpoint
    {Index R : Type*} [Fintype Index] [DecidableEq Index] [LinearOrder Index]
    [CommRing R]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (crossSymmetric : ∀ row column, cross row column = cross column row)
    (midpoint : ∀ first second, first ≠ second →
      diagonal first + diagonal second ≤ 2 * cross first second)
    (form : Matrix Index Index R)
    (member : GraphLattices.MemWeightedMatrix π diagonal cross form) :
    form ∈ GraphLattices.weightedRankOneSpan π diagonal cross :=
  GraphLattices.mem_weightedRankOneSpan_of_pairwise_midpoint
    π diagonal cross crossSymmetric midpoint form member

/-- Exact finite-matrix form of the manuscript's DVR rank-one criterion.
For a discrete valuation ring and an irreducible uniformizer, the weighted
symmetric lattice equals the span of its internal rank-one matrices if and
only if every distinct pair satisfies the midpoint inequality.  Completeness
and unramifiedness are unnecessary for this algebraic equivalence. -/
theorem rankOne_finiteMatrix_generated_iff_pairwise_midpoint_of_dvr
    {Index R : Type*} [Fintype Index] [DecidableEq Index] [LinearOrder Index]
    [CommRing R] [IsDomain R] [IsDiscreteValuationRing R]
    {π : R} (πIrreducible : Irreducible π)
    (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (crossSymmetric : ∀ row column, cross row column = cross column row) :
    GraphLattices.WeightedMatrixRankOneGenerated π diagonal cross ↔
      ∀ first second, first ≠ second →
        diagonal first + diagonal second ≤ 2 * cross first second :=
  GraphLattices.weightedMatrixRankOneGenerated_iff_pairwise_midpoint_of_dvr
    πIrreducible diagonal cross crossSymmetric

/-- Direct block-ring verification of the graph-coordinate multiplication
identity used to read off the three descent integrality conditions.  The
coefficient ring may be noncommutative, as it is for matrix blocks. -/
theorem graphCoefficient_graphCoordinate_block_identity
    {S : Type*} [Ring S]
    (inverseDepth slope adjointSlope coefficient : S) :
    GraphLattices.graphChangeMatrix inverseDepth slope *
        GraphLattices.graphAlternatingMatrix coefficient *
        GraphLattices.graphTransposePartner inverseDepth adjointSlope =
      GraphLattices.graphDescentBlockMatrix
        inverseDepth slope adjointSlope coefficient ∧
      ∀ (integral : S → Prop), integral 0 →
        ((∀ row column,
          integral ((GraphLattices.graphChangeMatrix inverseDepth slope *
              GraphLattices.graphAlternatingMatrix coefficient *
              GraphLattices.graphTransposePartner inverseDepth adjointSlope)
            row column)) ↔
          integral (inverseDepth *
              (coefficient * adjointSlope - slope * coefficient) *
            inverseDepth) ∧
            integral (inverseDepth * coefficient) ∧
            integral (-coefficient * inverseDepth)) := by
  exact ⟨GraphLattices.graphChange_mul_alternating_mul_transposePartner
      inverseDepth slope adjointSlope coefficient,
    GraphLattices.graphChange_product_entrywise_iff_three_blocks
      inverseDepth slope adjointSlope coefficient⟩

/-- Exact equivalence between the dual-form and coefficient-form adjoint
conventions used in the marked graph theorem. -/
theorem graphCoefficient_dualForm_adjoint_iff
    {S : Type*} [Ring S]
    (coefficientForm inverseCoefficientForm slope adjointSlope : S)
    (leftInverse : inverseCoefficientForm * coefficientForm = 1)
    (rightInverse : coefficientForm * inverseCoefficientForm = 1) :
    adjointSlope * inverseCoefficientForm = inverseCoefficientForm * slope ↔
      coefficientForm * adjointSlope = slope * coefficientForm :=
  GraphLattices.dualForm_adjoint_iff_coefficient_adjoint
    coefficientForm inverseCoefficientForm slope adjointSlope
    leftInverse rightInverse

/-- Expansion isolating the scalar slope-difference term from the two
depth-divisible error terms in a pair of positive-depth slope blocks. -/
theorem graphCoefficient_slopeCommutator_expansion
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
        firstPower * (firstError * coefficient) :=
  GraphLattices.slopeCommutator_expansion
    coefficient firstScalar secondScalar firstPower secondPower
    firstError secondError firstScalarCentral secondScalarCentral secondPowerCentral

/-- DVR arithmetic bridge from the scalar-difference commutator term to its
truncated residual coefficient depth. -/
theorem graphCoefficient_scalarDifference_divisibility
    {R : Type*} [CommRing R] [IsDomain R] [IsDiscreteValuationRing R]
    {π : R} (πIrreducible : Irreducible π)
    (totalDepth : ℕ) (scalarDifference coefficient : R) :
    π ^ GraphLattices.truncatedDepthDifference totalDepth
          (IsDiscreteValuationRing.addVal R scalarDifference) ∣ coefficient ↔
      π ^ totalDepth ∣ scalarDifference * coefficient :=
  GraphLattices.pow_truncatedDepthDifference_dvd_iff_pow_dvd_mul
    (GraphLattices.NormalizedDVRValuation.ofIsDiscreteValuationRing
      πIrreducible)
    totalDepth scalarDifference coefficient

/-- Exact local arithmetic reduction of the full split-slope commutator to
the truncated scalar-difference depth, assuming the two diagonal coefficient
conditions. -/
theorem graphCoefficient_commutatorDepth_iff_truncated
    {R : Type*} [CommRing R] [IsDomain R] [IsDiscreteValuationRing R]
    {π : R} (πIrreducible : Irreducible π)
    (firstDepth secondDepth : ℕ)
    (coefficient firstScalar secondScalar firstError secondError : R)
    (firstCoefficientDivides : π ^ firstDepth ∣ coefficient)
    (secondCoefficientDivides : π ^ secondDepth ∣ coefficient) :
    π ^ (firstDepth + secondDepth) ∣
        coefficient * (secondScalar + π ^ secondDepth * secondError) -
          (firstScalar + π ^ firstDepth * firstError) * coefficient ↔
      π ^ GraphLattices.truncatedDepthDifference (firstDepth + secondDepth)
          (IsDiscreteValuationRing.addVal R (secondScalar - firstScalar)) ∣
        coefficient :=
  (GraphLattices.slopeCommutator_totalDepth_dvd_iff_scalarDifference
    π firstDepth secondDepth coefficient firstScalar secondScalar
    firstError secondError firstCoefficientDivides secondCoefficientDivides).trans
      (GraphLattices.pow_truncatedDepthDifference_dvd_iff_pow_dvd_mul
        (GraphLattices.NormalizedDVRValuation.ofIsDiscreteValuationRing
          πIrreducible)
        (firstDepth + secondDepth) (secondScalar - firstScalar)
        coefficient).symm

/-- Complete local DVR form of the coefficient-depth calculation: one
cross-depth condition is equivalent to the two diagonal coefficient
conditions together with the full split-slope commutator condition. -/
theorem graphCoefficient_crossDepth_iff_splitSlopeCommutator
    {R : Type*} [CommRing R] [IsDomain R] [IsDiscreteValuationRing R]
    {π : R} (πIrreducible : Irreducible π)
    (firstDepth secondDepth : ℕ)
    (coefficient firstScalar secondScalar firstError secondError : R) :
    π ^ GraphLattices.graphCrossDepth firstDepth secondDepth
          (IsDiscreteValuationRing.addVal R (secondScalar - firstScalar)) ∣
        coefficient ↔
      π ^ firstDepth ∣ coefficient ∧
      π ^ secondDepth ∣ coefficient ∧
      π ^ (firstDepth + secondDepth) ∣
        coefficient * (secondScalar + π ^ secondDepth * secondError) -
          (firstScalar + π ^ firstDepth * firstError) * coefficient :=
  GraphLattices.pow_graphCrossDepth_dvd_iff_splitSlopeCommutator
    (GraphLattices.NormalizedDVRValuation.ofIsDiscreteValuationRing
      πIrreducible)
    firstDepth secondDepth coefficient firstScalar secondScalar
    firstError secondError

/-- The positive-positive graph coefficient formula for actual rectangular
matrix blocks of arbitrary finite ranks. -/
theorem graphCoefficient_rectangular_crossDepth_iff_splitSlopeCommutator
    {R I J : Type*} [CommRing R] [IsDomain R] [IsDiscreteValuationRing R]
    [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]
    {π : R} (πIrreducible : Irreducible π)
    (firstDepth secondDepth : ℕ)
    (coefficient : Matrix I J R) (firstScalar secondScalar : R)
    (firstError : Matrix I I R) (secondError : Matrix J J R) :
    GraphLattices.MatrixEntriesDivisibleBy
        (π ^ GraphLattices.graphCrossDepth firstDepth secondDepth
          (IsDiscreteValuationRing.addVal R
            (secondScalar - firstScalar))) coefficient ↔
      GraphLattices.MatrixEntriesDivisibleBy
          (π ^ firstDepth) coefficient ∧
      GraphLattices.MatrixEntriesDivisibleBy
          (π ^ secondDepth) coefficient ∧
      GraphLattices.MatrixEntriesDivisibleBy
          (π ^ (firstDepth + secondDepth))
        (GraphLattices.rectangularSplitSlopeCommutator π
          firstDepth secondDepth coefficient firstScalar secondScalar
          firstError secondError) :=
  GraphLattices.matrixEntries_graphCrossDepth_iff_splitSlopeCommutator
    (GraphLattices.NormalizedDVRValuation.ofIsDiscreteValuationRing
      πIrreducible)
    firstDepth secondDepth coefficient firstScalar secondScalar
    firstError secondError

/-- The unit-to-positive rectangular block introduces no condition beyond
the positive diagonal coefficient depth, for arbitrary integral slopes. -/
theorem graphCoefficient_rectangular_unitPositive_commutator
    {R I J : Type*} [CommRing R] [Fintype I] [Fintype J]
    (π : R) (positiveDepth : ℕ) (coefficient : Matrix I J R)
    (unitSlope : Matrix I I R) (positiveSlope : Matrix J J R)
    (coefficientDivides : GraphLattices.MatrixEntriesDivisibleBy
      (π ^ positiveDepth) coefficient) :
    GraphLattices.MatrixEntriesDivisibleBy (π ^ positiveDepth)
      (coefficient * positiveSlope - unitSlope * coefficient) :=
  GraphLattices.unitPositive_commutator_divisible π positiveDepth coefficient
    unitSlope positiveSlope coefficientDivides

/-- Global finite-family assembly of the split graph coefficient formula,
including unrestricted depth-zero blocks. -/
theorem graphCoefficient_symmetricFiniteBlockFamily_depth_iff_descent
    {R Index : Type*} [CommRing R] [IsDomain R]
    [IsDiscreteValuationRing R] [Fintype Index]
    (Block : Index → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    {π : R} (πIrreducible : Irreducible π)
    (depth : Index → ℕ) (scalar : Index → R)
    (slopeError : ∀ index, Matrix (Block index) (Block index) R)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) :
    (GraphLattices.GraphBlockSymmetric Block coefficient ∧
      GraphLattices.GraphBlockDepthCondition Block π
        (IsDiscreteValuationRing.addVal R) depth scalar coefficient) ↔
      (GraphLattices.GraphBlockSymmetric Block coefficient ∧
        GraphLattices.GraphBlockDescentCondition Block π depth scalar slopeError
          coefficient) :=
  GraphLattices.symmetricGraphBlockDepthCondition_iff_descentCondition Block
    (GraphLattices.NormalizedDVRValuation.ofIsDiscreteValuationRing
      πIrreducible)
    depth scalar slopeError coefficient

/-- Arithmetic core of the graph coefficient depth formula: the maximum
depth is exactly the intersection of the three power-divisibility conditions,
and it always satisfies the midpoint inequality. -/
theorem graphCoefficient_crossDepth_intersection_and_midpoint
    {R : Type*} [CommRing R] (π value : R)
    (firstDepth secondDepth : ℕ) (slopeDifferenceValuation : WithTop ℕ) :
    (π ^ GraphLattices.graphCrossDepth
          firstDepth secondDepth slopeDifferenceValuation ∣ value ↔
        π ^ firstDepth ∣ value ∧
        π ^ secondDepth ∣ value ∧
        π ^ GraphLattices.truncatedDepthDifference
          (firstDepth + secondDepth) slopeDifferenceValuation ∣ value) ∧
      firstDepth + secondDepth ≤
        2 * GraphLattices.graphCrossDepth
          firstDepth secondDepth slopeDifferenceValuation :=
  ⟨GraphLattices.pow_graphCrossDepth_dvd_iff
      π value firstDepth secondDepth slopeDifferenceValuation,
    GraphLattices.graphCrossDepth_midpoint
      firstDepth secondDepth slopeDifferenceValuation⟩

/-- Arithmetic lift-independence statement: the cross depth depends only on
the slope-difference valuation truncated at the smaller diagonal depth. -/
theorem graphCoefficient_crossDepth_eq_of_effectiveSlopeDifference_eq
    (firstDepth secondDepth : ℕ)
    {firstValuation secondValuation : WithTop ℕ}
    (effectiveEqual :
      GraphLattices.effectiveSlopeDifferenceValuation
          firstDepth secondDepth firstValuation =
        GraphLattices.effectiveSlopeDifferenceValuation
          firstDepth secondDepth secondValuation) :
    GraphLattices.graphCrossDepth firstDepth secondDepth firstValuation =
      GraphLattices.graphCrossDepth firstDepth secondDepth secondValuation :=
  GraphLattices.graphCrossDepth_eq_of_effectiveSlopeDifference_eq
    firstDepth secondDepth effectiveEqual

/-- DVR scalar-lift invariance in the form used by the manuscript: changing
each lift by its prescribed diagonal-depth ideal leaves the graph cross depth
unchanged. -/
theorem graphCoefficient_crossDepth_eq_of_dvr_scalar_lifts
    {R : Type*} [CommRing R] [IsDomain R] [IsDiscreteValuationRing R]
    {π : R} (πIrreducible : Irreducible π)
    (firstDepth secondDepth : ℕ)
    (firstSlope secondSlope firstLift secondLift : R)
    (firstCongruent : π ^ firstDepth ∣ firstLift - firstSlope)
    (secondCongruent : π ^ secondDepth ∣ secondLift - secondSlope) :
    GraphLattices.graphCrossDepth firstDepth secondDepth
        (IsDiscreteValuationRing.addVal R (secondSlope - firstSlope)) =
      GraphLattices.graphCrossDepth firstDepth secondDepth
        (IsDiscreteValuationRing.addVal R (secondLift - firstLift)) :=
  GraphLattices.graphCrossDepth_eq_of_dvr_scalar_lifts
    πIrreducible firstDepth secondDepth
    firstSlope secondSlope firstLift secondLift firstCongruent secondCongruent

/-- Arithmetic unit-block clause: depth zero paired with a positive-depth
block has exactly that positive cross depth, for every slope valuation. -/
theorem graphCoefficient_unitCrossDepth
    (positiveDepth : ℕ) (slopeDifferenceValuation : ℕ∞) :
    GraphLattices.graphCrossDepth 0 positiveDepth slopeDifferenceValuation =
      positiveDepth :=
  GraphLattices.graphCrossDepth_unit_positive
    positiveDepth slopeDifferenceValuation

/-- Literal matrix-level form of the graph coefficient lemma on the disjoint
union of all split block bases: weighted matrix-lattice membership is exactly
block symmetry plus the three graph-coordinate descent conditions. -/
theorem graphCoefficient_flattenedSplitPresentation_iff_descent
    {R BlockIndex : Type*} [CommRing R]
    (Block : BlockIndex → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    {π : R} (data : GraphLattices.NormalizedDVRValuation π)
    (depth : BlockIndex → ℕ) (scalar : BlockIndex → R)
    (slopeError : ∀ index, Matrix (Block index) (Block index) R)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) :
    GraphLattices.MemWeightedMatrix π (fun axis ↦ depth axis.1)
        (GraphLattices.splitGraphCrossDepth Block data.valuation depth scalar)
        (GraphLattices.flattenBlockCoefficient Block coefficient) ↔
      GraphLattices.GraphBlockSymmetric Block coefficient ∧
        GraphLattices.GraphBlockDescentCondition Block π depth scalar
          slopeError coefficient :=
  GraphLattices.memWeightedMatrix_flattenBlockCoefficient_iff_graphDescent
    Block data depth scalar slopeError coefficient

/-- For an actual DVR, the split graph cross-depth lattice on the disjoint
union of block bases is rank-one generated. -/
theorem graphCoefficient_splitPresentation_rankOneGenerated
    {R BlockIndex : Type*} [CommRing R] [IsDomain R]
    [IsDiscreteValuationRing R]
    (Block : BlockIndex → Type*)
    [Fintype (GraphLattices.SplitGraphAxis Block)]
    [DecidableEq (GraphLattices.SplitGraphAxis Block)]
    [LinearOrder (GraphLattices.SplitGraphAxis Block)]
    (π : R) (πIrreducible : Irreducible π)
    (depth : BlockIndex → ℕ) (scalar : BlockIndex → R) :
    GraphLattices.WeightedMatrixRankOneGenerated π
      (fun axis ↦ depth axis.1)
      (GraphLattices.splitGraphCrossDepth Block
        (IsDiscreteValuationRing.addVal R) depth scalar) :=
  GraphLattices.splitGraph_weightedMatrix_rankOneGenerated_of_dvr
    Block π πIrreducible depth scalar

/-- Public division-free form of the square-zero divided-power expansion.  It
models a labelled list of square-zero ring elements and does not assert that
any particular geometric divisor classes satisfy these hypotheses. -/
theorem squareZero_sum_pow_eq_factorial_mul_squarefreeProductSum
    {R : Type*} [CommRing R]
    (terms : List R) (squareZero : ∀ term ∈ terms, term * term = 0) (k : ℕ) :
    terms.sum ^ k =
      (k.factorial : R) * GraphLattices.squarefreeProductSum terms k :=
  GraphLattices.sum_pow_eq_factorial_mul_squarefreeProductSum
    terms squareZero k

/-- The literal degree-`k` ordinary product submodule generated by a
prescribed divisor submodule. -/
def ordinaryDivisorProductSubmodule
    {R A : Type*} [CommRing R] [CommRing A] [Algebra R A]
    (divisors : Submodule R A) (k : ℕ) : Submodule R A :=
  GraphLattices.ordinaryProductSubmodule divisors k

/-- Every labelled squarefree degree-`k` product sum of divisor classes lies
in the literal ordinary degree-`k` product submodule. -/
theorem squarefreeProductSum_mem_ordinaryDivisorProductSubmodule
    {R A : Type*} [CommRing R] [CommRing A] [Algebra R A]
    (divisors : Submodule R A) (terms : List A)
    (termsMember : ∀ term ∈ terms, term ∈ divisors) (k : ℕ) :
    GraphLattices.squarefreeProductSum terms k ∈
      ordinaryDivisorProductSubmodule divisors k :=
  GraphLattices.squarefreeProductSum_mem_ordinaryProductSubmodule
    divisors terms termsMember k

/-- Exterior-algebra source of the square-zero identity: every decomposable
alternating two-form squares to zero. -/
theorem decomposableTwoForm_squareZero
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (first second : M) :
    (ExteriorAlgebra.ι R first * ExteriorAlgebra.ι R second) ^ 2 = 0 :=
  GraphLattices.exterior_decomposableTwoForm_sq_zero first second

/-- In the canonical exterior-algebra model for the first cohomology of an
elliptic power, a rank-one coefficient matrix is literally a decomposable
two-form and therefore has square zero. -/
theorem ellipticSource_rankOne_decomposable_and_squareZero
    {Index R : Type*} [CommRing R] [Fintype Index] [DecidableEq Index]
    (coefficient : R) (vector : Index → R) :
    (GraphLattices.ellipticSourceCoefficientRealization
        (GraphLattices.matrixRankOne coefficient vector) =
      ExteriorAlgebra.ι R
          (GraphLattices.ellipticSourceX (coefficient • vector)) *
        ExteriorAlgebra.ι R (GraphLattices.ellipticSourceY vector)) ∧
    GraphLattices.ellipticSourceCoefficientRealization
          (GraphLattices.matrixRankOne coefficient vector) *
        GraphLattices.ellipticSourceCoefficientRealization
          (GraphLattices.matrixRankOne coefficient vector) = 0 :=
  ⟨GraphLattices.ellipticSourceCoefficientRealization_matrixRankOne
      coefficient vector,
    GraphLattices.ellipticSourceCoefficientRealization_rankOne_sq_zero
      coefficient vector⟩

/-- Injective cohomological pullback transports the source square-zero
identity for internal rank-one classes back to the target realization. -/
theorem rankOne_squareZero_of_injectivePullback
    {Index R Target Source : Type*} [CommRing R]
    [CommRing Target] [Ring Source]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (targetRealization : Matrix Index Index R →+ Target)
    (sourceRealization : Matrix Index Index R →+ Source)
    (pullback : Target →+* Source) (pullbackInjective : Function.Injective pullback)
    (realizationCompatible : ∀ candidate,
      pullback (targetRealization candidate) = sourceRealization candidate)
    (sourceRankOneSquareZero : ∀ candidate,
      candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross →
        sourceRealization candidate * sourceRealization candidate = 0) :
    ∀ candidate,
      candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross →
        targetRealization candidate * targetRealization candidate = 0 :=
  GraphLattices.rankOneSquareZero_of_injectivePullback π diagonal cross
    targetRealization sourceRealization pullback pullbackInjective
    realizationCompatible sourceRankOneSquareZero

/-- Algebraic all-degree consequence of exact rank-one generation.  Given an
additive realization whose internal rank-one images square to zero, each
realized lattice member admits a finite internal rank-one list and the
division-free factorial expansion in every degree.  No geometric realization
or descent assertion is built into this theorem. -/
theorem rankOne_allDegree_squareZeroAssembly
    {Index R Target : Type*} [CommRing R] [CommRing Target]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (generated : GraphLattices.WeightedMatrixRankOneGenerated π diagonal cross)
    (realization : Matrix Index Index R →+ Target)
    (rankOneSquareZero : ∀ candidate,
      candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross →
        realization candidate * realization candidate = 0)
    (form : Matrix Index Index R)
    (member : form ∈ GraphLattices.weightedMatrixSubmodule π diagonal cross)
    (degree : ℕ) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) ∧
      forms.sum = form ∧
      realization form ^ degree =
        (degree.factorial : Target) *
          GraphLattices.squarefreeProductSum (forms.map realization) degree :=
  GraphLattices.allDegree_squareZeroAssembly_of_rankOneGenerated
    π diagonal cross generated realization rankOneSquareZero form member degree

/-- Faithfully flat reflection of submodule membership in the quotient form
used by the manuscript's splitting-ring descent. -/
theorem faithfullyFlat_tensorQuotient_zero_implies_mem
    {R S M : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [AddCommGroup M] [Module R M] [Module.FaithfullyFlat R S]
    (submodule : Submodule R M) (element : M)
    (extendedQuotientZero :
      TensorProduct.mk R S (M ⧸ submodule) 1
          (Submodule.Quotient.mk element) = 0) :
    element ∈ submodule :=
  GraphLattices.mem_submodule_of_faithfullyFlat_tensor_quotient_zero
    submodule element extendedQuotientZero

/-- All-degree square-zero assembly followed by exact faithfully flat descent
of the resulting squarefree product through the quotient by the prescribed
integral product submodule. -/
theorem rankOne_allDegree_integralProductMember_of_faithfullyFlatQuotient
    {Index R S Target : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [CommRing Target] [Module R Target] [Module.FaithfullyFlat R S]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (generated : GraphLattices.WeightedMatrixRankOneGenerated π diagonal cross)
    (realization : Matrix Index Index R →+ Target)
    (rankOneSquareZero : ∀ candidate,
      candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross →
        realization candidate * realization candidate = 0)
    (integralProducts : Submodule R Target)
    (form : Matrix Index Index R)
    (member : form ∈ GraphLattices.weightedMatrixSubmodule π diagonal cross)
    (degree : ℕ)
    (extendedProducts : ∀ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) →
      forms.sum = form →
      TensorProduct.mk R S (Target ⧸ integralProducts) 1
        (Submodule.Quotient.mk
          (GraphLattices.squarefreeProductSum
            (forms.map realization) degree)) = 0) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) ∧
      forms.sum = form ∧
      GraphLattices.squarefreeProductSum
          (forms.map realization) degree ∈ integralProducts ∧
      realization form ^ degree =
        (degree.factorial : Target) *
          GraphLattices.squarefreeProductSum
            (forms.map realization) degree :=
  GraphLattices.allDegree_integralProductMember_of_faithfullyFlatQuotient
    π diagonal cross generated realization rankOneSquareZero integralProducts
    form member degree extendedProducts

/-- A same-coefficient algebraic all-degree chain: rank-one generation,
source square-zero, injective pullback, squarefree expansion, and faithfully
flat quotient descent.  This theorem does not move the rank-one decomposition
itself to a splitting coefficient ring. -/
theorem rankOne_allDegree_of_injectivePullback_and_faithfullyFlatDescent
    {Index R S Target Source : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [CommRing Target] [Module R Target] [Ring Source]
    [Module.FaithfullyFlat R S]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (generated : GraphLattices.WeightedMatrixRankOneGenerated π diagonal cross)
    (targetRealization : Matrix Index Index R →+ Target)
    (sourceRealization : Matrix Index Index R →+ Source)
    (pullback : Target →+* Source) (pullbackInjective : Function.Injective pullback)
    (realizationCompatible : ∀ candidate,
      pullback (targetRealization candidate) = sourceRealization candidate)
    (sourceRankOneSquareZero : ∀ candidate,
      candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross →
        sourceRealization candidate * sourceRealization candidate = 0)
    (integralProducts : Submodule R Target)
    (form : Matrix Index Index R)
    (member : form ∈ GraphLattices.weightedMatrixSubmodule π diagonal cross)
    (degree : ℕ)
    (extendedProducts : ∀ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) →
      forms.sum = form →
      TensorProduct.mk R S (Target ⧸ integralProducts) 1
        (Submodule.Quotient.mk
          (GraphLattices.squarefreeProductSum
            (forms.map targetRealization) degree)) = 0) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) ∧
      forms.sum = form ∧
      GraphLattices.squarefreeProductSum
          (forms.map targetRealization) degree ∈ integralProducts ∧
      targetRealization form ^ degree =
        (degree.factorial : Target) *
          GraphLattices.squarefreeProductSum
            (forms.map targetRealization) degree :=
  GraphLattices.allDegree_integralProductMember_of_injectivePullback_and_faithfullyFlat
    π diagonal cross generated targetRealization sourceRealization pullback
    pullbackInjective realizationCompatible sourceRankOneSquareZero
    integralProducts form member degree extendedProducts

/-- The all-degree chain with its source realization fixed to the canonical
elliptic-power exterior algebra.  Thus rank-one source square-zero is proved,
not supplied as a hypothesis; the geometric target realization, compatible
injective pullback, and extended product identity remain explicit inputs. -/
theorem rankOne_allDegree_of_canonicalEllipticSourcePullback_and_faithfullyFlatDescent
    {Index R S Target : Type*} [CommRing R] [Fintype Index]
    [DecidableEq Index] [CommRing S] [Algebra R S]
    [CommRing Target] [Module R Target] [Module.FaithfullyFlat R S]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (generated : GraphLattices.WeightedMatrixRankOneGenerated π diagonal cross)
    (targetRealization : Matrix Index Index R →+ Target)
    (pullback : Target →+*
      ExteriorAlgebra R (GraphLattices.EllipticSourceHOne R Index))
    (pullbackInjective : Function.Injective pullback)
    (realizationCompatible : ∀ candidate,
      pullback (targetRealization candidate) =
        GraphLattices.ellipticSourceCoefficientRealization candidate)
    (integralProducts : Submodule R Target)
    (form : Matrix Index Index R)
    (member : form ∈ GraphLattices.weightedMatrixSubmodule π diagonal cross)
    (degree : ℕ)
    (extendedProducts : ∀ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) →
      forms.sum = form →
      TensorProduct.mk R S (Target ⧸ integralProducts) 1
        (Submodule.Quotient.mk
          (GraphLattices.squarefreeProductSum
            (forms.map targetRealization) degree)) = 0) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) ∧
      forms.sum = form ∧
      GraphLattices.squarefreeProductSum
          (forms.map targetRealization) degree ∈ integralProducts ∧
      targetRealization form ^ degree =
        (degree.factorial : Target) *
          GraphLattices.squarefreeProductSum
            (forms.map targetRealization) degree :=
  GraphLattices.allDegree_integralProductMember_of_ellipticSourcePullback
    π diagonal cross generated targetRealization pullback pullbackInjective
    realizationCompatible integralProducts form member degree extendedProducts

/-- Rank-one generation plus the canonical elliptic-source pullback places
the squarefree representative in the literal ordinary product submodule,
with no abstract product-membership hypothesis. -/
theorem rankOne_allDegree_ordinaryProduct_of_canonicalEllipticSourcePullback
    {Index R Target : Type*} [CommRing R] [Fintype Index]
    [DecidableEq Index] [CommRing Target] [Algebra R Target]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (generated : GraphLattices.WeightedMatrixRankOneGenerated π diagonal cross)
    (targetRealization : Matrix Index Index R →+ Target)
    (pullback : Target →+*
      ExteriorAlgebra R (GraphLattices.EllipticSourceHOne R Index))
    (pullbackInjective : Function.Injective pullback)
    (realizationCompatible : ∀ candidate,
      pullback (targetRealization candidate) =
        GraphLattices.ellipticSourceCoefficientRealization candidate)
    (divisors : Submodule R Target)
    (realizationMember : ∀ candidate,
      candidate ∈ GraphLattices.weightedMatrixSubmodule π diagonal cross →
        targetRealization candidate ∈ divisors)
    (form : Matrix Index Index R)
    (member : form ∈ GraphLattices.weightedMatrixSubmodule π diagonal cross)
    (degree : ℕ) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) ∧
      forms.sum = form ∧
      GraphLattices.squarefreeProductSum
          (forms.map targetRealization) degree ∈
        ordinaryDivisorProductSubmodule divisors degree ∧
      targetRealization form ^ degree =
        (degree.factorial : Target) *
          GraphLattices.squarefreeProductSum
            (forms.map targetRealization) degree :=
  GraphLattices.allDegree_ordinaryProductMember_of_ellipticSourcePullback
    π diagonal cross generated targetRealization pullback pullbackInjective
    realizationCompatible divisors realizationMember form member degree

/-- Entrywise coefficient extension preserves the weighted graph lattice and
maps rank-one coefficient matrices to the corresponding rank-one matrices. -/
theorem graphLattice_coefficientExtension_preserves_member_and_rankOne
    {Index R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (form : Matrix Index Index R)
    (latticeMember : form ∈
      GraphLattices.weightedMatrixSubmodule π diagonal cross)
    (rankOneMember : form ∈
      GraphLattices.weightedRankOneSet π diagonal cross) :
    GraphLattices.matrixCoefficientExtension form ∈
        GraphLattices.weightedMatrixSubmodule
          (algebraMap R S π) diagonal cross ∧
      GraphLattices.matrixCoefficientExtension form ∈
        GraphLattices.weightedRankOneSet
          (algebraMap R S π) diagonal cross :=
  ⟨GraphLattices.matrixCoefficientExtension_mem_weightedMatrixSubmodule
      π diagonal cross form latticeMember,
    GraphLattices.matrixCoefficientExtension_mem_weightedRankOneSet
      π diagonal cross form rankOneMember⟩

/-- Ordinary product images commute with coefficient extension in the needed
direction, and faithfully flatness reflects membership from the resulting
scalar-extended submodule. -/
theorem ordinaryDivisorProducts_baseChange_and_faithfullyFlatReflection
    {R S T : Type*} [CommRing R] [CommRing S] [CommRing T]
    [Algebra R S] [Algebra R T] [Module.FaithfullyFlat R S]
    (divisors : Submodule R T) (degree : ℕ) (element : T)
    (extendedMember :
      Algebra.TensorProduct.includeRight element ∈
        GraphLattices.ordinaryProductSubmodule
          (GraphLattices.scalarExtendedSubmodule S
            (Algebra.TensorProduct.includeRight
              (R := R) (A := S) (B := T)) divisors) degree) :
    element ∈ ordinaryDivisorProductSubmodule divisors degree := by
  apply GraphLattices.mem_submodule_of_mem_scalarExtendedSubmodule
    (S := S)
  exact GraphLattices.ordinaryProductSubmodule_scalarExtension_le
    (S := S)
    (Algebra.TensorProduct.includeRight
      (R := R) (A := S) (B := T)) divisors degree extendedMember

/-- Exact algebraic skeleton of the manuscript's splitting-ring proof.
Rank-one generation occurs after faithfully flat coefficient extension;
ordinary product membership and the factorial identity descend to the base.
The geometric realization compatibilities, including identification of the
chosen divided-power class after extension, remain explicit hypotheses. -/
theorem rankOne_allDegree_dividedPower_of_faithfullyFlatCoefficientExtension
    {Index R S Target : Type*} [CommRing R] [Fintype Index]
    [DecidableEq Index] [CommRing S] [Algebra R S]
    [Module.FaithfullyFlat R S] [CommRing Target] [Algebra R Target]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (extendedGenerated : GraphLattices.WeightedMatrixRankOneGenerated
      (algebraMap R S π) diagonal cross)
    (extendedRealization : Matrix Index Index S →+
      TensorProduct R S Target)
    (pullback : TensorProduct R S Target →+*
      ExteriorAlgebra S (GraphLattices.EllipticSourceHOne S Index))
    (pullbackInjective : Function.Injective pullback)
    (sourceCompatible : ∀ candidate,
      pullback (extendedRealization candidate) =
        GraphLattices.ellipticSourceCoefficientRealization candidate)
    (divisors : Submodule R Target)
    (extendedRealizationMember : ∀ candidate,
      candidate ∈ GraphLattices.weightedMatrixSubmodule
          (algebraMap R S π) diagonal cross →
        extendedRealization candidate ∈
          GraphLattices.scalarExtendedSubmodule S
            (Algebra.TensorProduct.includeRight
              (R := R) (A := S) (B := Target)) divisors)
    (form : Matrix Index Index R)
    (member : form ∈ GraphLattices.weightedMatrixSubmodule π diagonal cross)
    (baseClass dividedPower : Target)
    (baseClassCompatible :
      extendedRealization (GraphLattices.matrixCoefficientExtension form) =
        Algebra.TensorProduct.includeRight baseClass)
    (degree : ℕ)
    (dividedPowerCompatible : ∀ forms : List (Matrix Index Index S),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet
          (algebraMap R S π) diagonal cross) →
      forms.sum = GraphLattices.matrixCoefficientExtension form →
      Algebra.TensorProduct.includeRight dividedPower =
        GraphLattices.squarefreeProductSum
          (forms.map extendedRealization) degree) :
    dividedPower ∈ ordinaryDivisorProductSubmodule divisors degree ∧
      baseClass ^ degree = (degree.factorial : Target) * dividedPower :=
  GraphLattices.allDegree_dividedPowerMember_of_faithfullyFlatCoefficientExtension
    π diagonal cross extendedGenerated extendedRealization pullback
    pullbackInjective sourceCompatible divisors extendedRealizationMember
    form member baseClass dividedPower baseClassCompatible degree
    dividedPowerCompatible

/-- The preceding coefficient-extension/descent packet with rank-one
generation discharged internally by the split graph depth formula over the
splitting DVR. -/
theorem rankOne_allDegree_dividedPower_of_splitGraphDVR
    {R S Target BlockIndex : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Module.FaithfullyFlat R S]
    [IsDomain S] [IsDiscreteValuationRing S]
    [CommRing Target] [Algebra R Target]
    (Block : BlockIndex → Type*)
    [Fintype (GraphLattices.SplitGraphAxis Block)]
    [DecidableEq (GraphLattices.SplitGraphAxis Block)]
    [LinearOrder (GraphLattices.SplitGraphAxis Block)]
    (π : R) (extendedπIrreducible : Irreducible (algebraMap R S π))
    (depth : BlockIndex → ℕ) (scalar : BlockIndex → S)
    (extendedRealization : Matrix (GraphLattices.SplitGraphAxis Block)
        (GraphLattices.SplitGraphAxis Block) S →+ TensorProduct R S Target)
    (pullback : TensorProduct R S Target →+*
      ExteriorAlgebra S
        (GraphLattices.EllipticSourceHOne S
          (GraphLattices.SplitGraphAxis Block)))
    (pullbackInjective : Function.Injective pullback)
    (sourceCompatible : ∀ candidate,
      pullback (extendedRealization candidate) =
        GraphLattices.ellipticSourceCoefficientRealization candidate)
    (divisors : Submodule R Target)
    (extendedRealizationMember : ∀ candidate,
      candidate ∈ GraphLattices.weightedMatrixSubmodule (algebraMap R S π)
          (fun axis ↦ depth axis.1)
          (GraphLattices.splitGraphCrossDepth Block
            (IsDiscreteValuationRing.addVal S) depth scalar) →
        extendedRealization candidate ∈
          GraphLattices.scalarExtendedSubmodule S
            (Algebra.TensorProduct.includeRight
              (R := R) (A := S) (B := Target)) divisors)
    (form : Matrix (GraphLattices.SplitGraphAxis Block)
      (GraphLattices.SplitGraphAxis Block) R)
    (member : form ∈ GraphLattices.weightedMatrixSubmodule π
      (fun axis ↦ depth axis.1)
      (GraphLattices.splitGraphCrossDepth Block
        (IsDiscreteValuationRing.addVal S) depth scalar))
    (baseClass dividedPower : Target)
    (baseClassCompatible :
      extendedRealization (GraphLattices.matrixCoefficientExtension form) =
        Algebra.TensorProduct.includeRight baseClass)
    (degree : ℕ)
    (dividedPowerCompatible :
      ∀ forms : List (Matrix (GraphLattices.SplitGraphAxis Block)
        (GraphLattices.SplitGraphAxis Block) S),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet (algebraMap R S π)
          (fun axis ↦ depth axis.1)
          (GraphLattices.splitGraphCrossDepth Block
            (IsDiscreteValuationRing.addVal S) depth scalar)) →
      forms.sum = GraphLattices.matrixCoefficientExtension form →
      Algebra.TensorProduct.includeRight dividedPower =
        GraphLattices.squarefreeProductSum
          (forms.map extendedRealization) degree) :
    dividedPower ∈ ordinaryDivisorProductSubmodule divisors degree ∧
      baseClass ^ degree = (degree.factorial : Target) * dividedPower :=
  GraphLattices.allDegree_dividedPowerMember_of_splitGraphDVR
    Block π extendedπIrreducible depth scalar extendedRealization pullback
    pullbackInjective sourceCompatible divisors extendedRealizationMember
    form member baseClass dividedPower baseClassCompatible degree
    dividedPowerCompatible

/-- Elementwise local-to-global membership in denominator-witness form.  If,
at every prime, a natural-number multiple prime to that prime carries `x`
into the subgroup, then `x` already belongs to the subgroup.  Unlike the
paper's sufficient finite-generation argument, this sharper algebraic lemma
needs no finiteness assumption. -/
theorem primeDenominatorMember_all_implies_mem
    {A : Type*} [AddCommGroup A]
    (P : AddSubgroup A) (x : A)
    (localMember : ∀ p : ℕ, p.Prime →
      GraphLattices.PrimeDenominatorMember P x p) :
    x ∈ P :=
  GraphLattices.mem_of_primeDenominatorMember_all P x localMember

/-- Abstract all-degree saturation conclusion after local inputs are supplied.
Exact rank-one generation and square-zero realization produce a finite
squarefree representative; prime-to-prime denominator witnesses place that
representative in the chosen integral product subgroup globally. -/
theorem rankOne_allDegree_integralProductMember_of_primeDenominators
    {Index R Target : Type*} [CommRing R] [CommRing Target]
    (π : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (generated : GraphLattices.WeightedMatrixRankOneGenerated π diagonal cross)
    (realization : Matrix Index Index R →+ Target)
    (rankOneSquareZero : ∀ candidate,
      candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross →
        realization candidate * realization candidate = 0)
    (integralProducts : AddSubgroup Target)
    (form : Matrix Index Index R)
    (member : form ∈ GraphLattices.weightedMatrixSubmodule π diagonal cross)
    (degree : ℕ)
    (localProducts : ∀ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) →
      forms.sum = form →
      ∀ p : ℕ, p.Prime →
        GraphLattices.PrimeDenominatorMember integralProducts
          (GraphLattices.squarefreeProductSum (forms.map realization) degree) p) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet π diagonal cross) ∧
      forms.sum = form ∧
      GraphLattices.squarefreeProductSum
          (forms.map realization) degree ∈ integralProducts ∧
      realization form ^ degree =
        (degree.factorial : Target) *
          GraphLattices.squarefreeProductSum (forms.map realization) degree :=
  GraphLattices.allDegree_integralProductMember_of_primeDenominators
    π diagonal cross generated realization rankOneSquareZero integralProducts
    form member degree localProducts

/-- The abstract `6I-J` calculation: the constant line has eigenvalue one and
the coordinate-sum-zero hyperplane has eigenvalue six.  No geometric Rosati
identification is asserted. -/
theorem sixAxisGram_unit_and_augmentation_eigenvalues
    {R : Type*} [CommRing R] :
    Matrix.mulVec (GraphLattices.sixAxisGram R)
        (fun _ : Fin 5 ↦ (1 : R)) = (fun _ ↦ 1) ∧
      ∀ vector : Fin 5 → R, (∑ column, vector column) = 0 →
        Matrix.mulVec (GraphLattices.sixAxisGram R) vector =
          (fun row ↦ 6 * vector row) := by
  constructor
  · exact GraphLattices.sixAxisGram_mulVec_one
  · exact GraphLattices.sixAxisGram_mulVec_of_sum_zero

/-- An explicit integral Smith witness: the displayed integral row and column
matrices are invertible over the integers and reduce `6I-J` to
`diag(1,6,6,6,6)`. -/
theorem sixAxisGram_integralSmithReduction :
    GraphLattices.sixAxisSmithLeft * GraphLattices.sixAxisGram ℤ *
        GraphLattices.sixAxisSmithRight = GraphLattices.sixAxisSmithDiagonal ∧
      GraphLattices.sixAxisSmithLeft *
          GraphLattices.sixAxisSmithLeftInverse = 1 ∧
      GraphLattices.sixAxisSmithLeftInverse *
          GraphLattices.sixAxisSmithLeft = 1 ∧
      GraphLattices.sixAxisSmithRight *
          GraphLattices.sixAxisSmithRightInverse = 1 ∧
      GraphLattices.sixAxisSmithRightInverse *
          GraphLattices.sixAxisSmithRight = 1 := by
  exact ⟨GraphLattices.sixAxisGram_smith_reduction,
    GraphLattices.sixAxisSmithLeft_mul_inverse,
    GraphLattices.sixAxisSmithLeft_inverse_mul,
    GraphLattices.sixAxisSmithRight_mul_inverse,
    GraphLattices.sixAxisSmithRight_inverse_mul⟩

/-- Arithmetic part of the local chart: after the integral Smith reduction,
there is one unit entry and four entries of exact depth one at both two and
three. -/
theorem sixAxisSmith_unit_line_and_depth_one_at_two_three :
    (GraphLattices.sixAxisSmithDiagonal 0 0 = 1 ∧
      ∀ index : Fin 5, index ≠ 0 →
        GraphLattices.sixAxisSmithDiagonal index index = 6) ∧
      (((2 : ℤ) ∣ 6 ∧ ¬ (4 : ℤ) ∣ 6) ∧
        ((3 : ℤ) ∣ 6 ∧ ¬ (9 : ℤ) ∣ 6)) :=
  ⟨GraphLattices.sixAxisSmithDiagonal_entries,
    GraphLattices.sixAxisSmith_depth_one_at_two_and_three⟩

/-- Exact arithmetic completion of the numerical step in the six-axis
polarization proof: positivity, the vanishing invariant sum, and the
intersection equation force diagonal entry five and off-diagonal entry
minus one. -/
theorem sixAxisPolarization_parameters_unique
    (diagonal offDiagonal : ℤ)
    (diagonalPositive : 0 < diagonal)
    (invariantSum : diagonal + 5 * offDiagonal = 0)
    (intersection : diagonal ^ 2 - offDiagonal ^ 2 = 24) :
    diagonal = 5 ∧ offDiagonal = -1 :=
  GraphLattices.sixAxisGram_parameters_unique diagonal offDiagonal
    diagonalPositive invariantSum intersection

/-- Exact algebraic local chart at every coefficient ring in which five has
the displayed inverse.  The first line has norm five, the four complement
vectors are orthogonal to it, and their Gram matrix is `(6/5)(5I-J)`; the
integral unit block has determinant `125`, prime to two and three. -/
theorem sixAxisLocalChart_orthogonal_block
    {R : Type*} [CommRing R]
    (inverseFive : R) (inverse : 5 * inverseFive = 1) :
    GraphLattices.sixAxisGramPairing (R := R)
        GraphLattices.sixAxisFirstVector GraphLattices.sixAxisFirstVector = 5 ∧
      (∀ column : Fin 4,
        GraphLattices.sixAxisGramPairing (R := R)
          GraphLattices.sixAxisFirstVector
          (GraphLattices.sixAxisComplementVector inverseFive column) = 0) ∧
      (∀ row column : Fin 4,
        GraphLattices.sixAxisGramPairing (R := R)
          (GraphLattices.sixAxisComplementVector inverseFive row)
          (GraphLattices.sixAxisComplementVector inverseFive column) =
            6 * inverseFive * (if row = column then 4 else -1)) ∧
      Matrix.det GraphLattices.sixAxisComplementUnitMatrix = 125 ∧
      ¬(2 : ℤ) ∣ Matrix.det GraphLattices.sixAxisComplementUnitMatrix ∧
      ¬(3 : ℤ) ∣ Matrix.det GraphLattices.sixAxisComplementUnitMatrix := by
  exact ⟨GraphLattices.sixAxisFirstVector_pairing,
    GraphLattices.sixAxisFirstVector_pairing_complement inverseFive inverse,
    GraphLattices.sixAxisComplementVector_pairing inverseFive inverse,
    GraphLattices.sixAxisComplementUnitMatrix_det,
    GraphLattices.sixAxisComplementUnitMatrix_det_prime_to_two_three⟩

/-- Explicit model of the characteristic-two residue-field slope type
appearing in the manuscript: two quadratic companion blocks on a
set of four coordinates, modeling the four-dimensional depth-one block.  The
matrix is annihilated by `t²+t+1`, is not scalar, and that polynomial has no
root in `F₂`.  This is a
residue-field model, not an identification with the geometric kernel. -/
theorem sixAxisLocalChart_twoPrimary_quadraticSlopeModel :
    (GraphLattices.sixAxisTwoQuadraticSlope *
          GraphLattices.sixAxisTwoQuadraticSlope +
        GraphLattices.sixAxisTwoQuadraticSlope + 1 = 0) ∧
      (∀ value : ZMod 2,
        GraphLattices.sixAxisTwoQuadraticSlope ≠
          Matrix.scalar (Fin 4) value) ∧
      (∀ value : ZMod 2, value ^ 2 + value + 1 ≠ 0) := by
  exact ⟨GraphLattices.sixAxisTwoQuadraticSlope_polynomial,
    GraphLattices.sixAxisTwoQuadraticSlope_not_scalar,
    GraphLattices.zmodTwo_quadraticSlopePolynomial_no_root⟩

/-- Explicit model of the characteristic-three residue-field slope type
appearing in the manuscript, represented on four coordinates modeling the
four-dimensional depth-one block.  It is literally a scalar-algebra image and
therefore commutes with every coefficient block.  This is a
residue-field model, not an identification with the geometric kernel. -/
theorem sixAxisLocalChart_threePrimary_scalarSlopeModel (value : ZMod 3) :
    GraphLattices.sixAxisThreeScalarSlope value =
        algebraMap (ZMod 3) (Matrix (Fin 4) (Fin 4) (ZMod 3)) value ∧
      ∀ coefficient : Matrix (Fin 4) (Fin 4) (ZMod 3),
        coefficient * GraphLattices.sixAxisThreeScalarSlope value =
          GraphLattices.sixAxisThreeScalarSlope value * coefficient := by
  exact ⟨GraphLattices.sixAxisThreeScalarSlope_eq_algebraMap value,
    GraphLattices.sixAxisThreeScalarSlope_commutes value⟩

/-- Exact projective-line classification and counts behind the finite-field
gluing packets.  Every point is uniquely the vertical line or a scalar graph;
there are five points over `F4` and four over `F3`. -/
theorem principalGluing_projectiveLine_packets :
    Nonempty (Option GraphLattices.F4 ≃
      Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4)) ∧
      Nat.card (Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4)) = 5 ∧
      Nonempty (Option (ZMod 3) ≃
        Projectivization (ZMod 3) (ZMod 3 × ZMod 3)) ∧
      Nat.card (Projectivization (ZMod 3) (ZMod 3 × ZMod 3)) = 4 :=
  ⟨⟨GraphLattices.optionEquivProjectiveLine GraphLattices.F4⟩,
    GraphLattices.f4_projectiveLine_card,
    ⟨GraphLattices.optionEquivProjectiveLine (ZMod 3)⟩,
    GraphLattices.f3_projectiveLine_card⟩

/-- Polarization core for the gluing packet: a self-adjoint linear slope has
isotropic graph for the alternating two-copy pairing; its graph range has
the dimension of one coefficient copy while the ambient pair has twice that
dimension. -/
theorem principalGluing_selfAdjointGraph_isotropic_halfDimension
    {K H : Type*} [Field K] [AddCommGroup H] [Module K H] [Module.Finite K H]
    (coefficientPairing : H →ₗ[K] H →ₗ[K] K)
    (slope : H →ₗ[K] H)
    (selfAdjoint : ∀ left right,
      coefficientPairing left (slope right) =
        coefficientPairing (slope left) right) :
    (∀ left right : H,
      GraphLattices.multiplicityAlternatingPairing coefficientPairing
        (GraphLattices.graphEmbedding (K := K) slope left)
        (GraphLattices.graphEmbedding (K := K) slope right) = 0) ∧
      Module.finrank K
          (LinearMap.range (GraphLattices.graphEmbedding (K := K) slope)) =
        Module.finrank K H ∧
      Module.finrank K (H × H) = 2 * Module.finrank K H := by
  exact ⟨GraphLattices.graphEmbedding_isotropic_of_selfAdjoint
      coefficientPairing slope selfAdjoint,
    GraphLattices.finrank_graphEmbedding_range slope,
    GraphLattices.finrank_multiplicity_pair⟩

/-- Finite-field Frobenius core for the exotic pair: squaring on the chosen
`F4` fixes exactly `0` and `1`, is involutive, and exchanges every other
element with a distinct conjugate.  This statement does not identify a
normalizer action with Frobenius. -/
theorem principalGluing_f4Frobenius_fixed_and_exchanged :
    (∀ a : GraphLattices.F4,
      GraphLattices.f4FrobeniusRingEquiv a =
        GraphLattices.f4Frobenius a) ∧
    (∀ point : Option GraphLattices.F4,
      GraphLattices.f4ProjectiveFrobenius point =
        point.map GraphLattices.f4FrobeniusRingEquiv) ∧
    (∀ a : GraphLattices.F4,
      GraphLattices.f4Frobenius a = a ↔ a = 0 ∨ a = 1) ∧
    Function.Involutive GraphLattices.f4Frobenius ∧
    (∀ a : GraphLattices.F4, a ≠ 0 → a ≠ 1 →
      GraphLattices.f4Frobenius a ≠ a ∧
        GraphLattices.f4Frobenius (GraphLattices.f4Frobenius a) = a) ∧
    (∀ point : Option GraphLattices.F4,
      GraphLattices.f4ProjectiveFrobenius point = point ↔
        point = none ∨ point = some 0 ∨ point = some 1) := by
  exact ⟨GraphLattices.f4FrobeniusRingEquiv_apply,
    GraphLattices.f4ProjectiveFrobenius_eq_option_map,
    GraphLattices.f4Frobenius_fixed_iff,
    GraphLattices.f4Frobenius_involutive,
    GraphLattices.f4Frobenius_exchanges_nonPrimeElement,
    GraphLattices.f4ProjectiveFrobenius_fixed_iff⟩

/-- Concrete polarization calculation from the principal-gluing proof.  The
trace of the determinant on `F4²` is nondegenerate over `F2`; the induced
form on two multiplicity copies is nondegenerate; and every scalar graph is
self-orthogonal, hence maximal isotropic. -/
theorem principalGluing_f4TraceDeterminant_maximalIsotropic :
    GraphLattices.f4TraceDeterminantPairing.Nondegenerate ∧
    GraphLattices.f4MultiplicityAlternatingForm.Nondegenerate ∧
    ∀ a : GraphLattices.F4,
      LinearMap.BilinForm.orthogonal
          GraphLattices.f4MultiplicityAlternatingForm
          (LinearMap.range
            (GraphLattices.graphEmbedding
              (GraphLattices.f4ScalarSlope a))) =
        LinearMap.range
          (GraphLattices.graphEmbedding
            (GraphLattices.f4ScalarSlope a)) := by
  exact ⟨GraphLattices.f4TraceDeterminantPairing_nondegenerate,
    GraphLattices.f4MultiplicityAlternatingForm_nondegenerate,
    GraphLattices.f4ScalarGraph_orthogonal_eq⟩

/-- Algebraic core of the manuscript's exotic-stabilizer order calculation.
Nondegeneracy of the field trace makes any trace-preserving determinant scalar
equal to one, and the resulting concrete special linear group has order `60`.
This statement does not identify a permutation stabilizer with that group or
with `A5`. -/
theorem principalGluing_exoticStabilizer_algebraicCore :
    (∀ d : GraphLattices.F4ˣ,
      (∀ z : GraphLattices.F4,
        Algebra.trace (ZMod 2) GraphLattices.F4 ((d : GraphLattices.F4) * z) =
          Algebra.trace (ZMod 2) GraphLattices.F4 z) →
      d = 1) ∧
    Nat.card
      (Matrix.SpecialLinearGroup (Fin 2) GraphLattices.F4) = 60 := by
  constructor
  · intro d tracePreserved
    apply Units.ext
    exact GraphLattices.f4_eq_one_of_trace_mul_eq_trace d tracePreserved
  · exact GraphLattices.f4_specialLinearGroup_two_card

/-- Abstract exceptional-group identification supporting the stabilizer
paragraph: the ordinary alternating group on five letters has order `60`,
and the concrete `SL₂(F4)` is isomorphic to it.  This does not identify the
manuscript's geometric permutation action or its named `A5` subgroup with
either side of this equivalence. -/
theorem principalGluing_abstractExceptionalGroup :
    Nat.card (alternatingGroup (Fin 5)) = 60 ∧
      Nonempty
        (Matrix.SpecialLinearGroup (Fin 2) GraphLattices.F4 ≃*
          alternatingGroup (Fin 5)) := by
  exact ⟨GraphLattices.alternatingGroup_fin_five_card,
    ⟨GraphLattices.specialLinearGroupF4EquivAlternatingFive⟩⟩

/-- Abstract outer-normalizer calculation on the five-point packet.
Arithmetic Frobenius is a transposition, hence odd, and its conjugation
preserves the transported alternating subgroup.  This does not identify the
permutation with a geometric normalizer element of the six-axis family. -/
theorem principalGluing_f4Frobenius_oddNormalizer :
    Nat.card (Equiv.Perm (Fin 5)) = 120 ∧
      (alternatingGroup (Fin 5)).index = 2 ∧
      Subgroup.normalizer
          (alternatingGroup (Fin 5) : Set (Equiv.Perm (Fin 5))) = ⊤ ∧
      GraphLattices.f4FrobeniusPermutation ∈
        Subgroup.normalizer
          (alternatingGroup (Fin 5) : Set (Equiv.Perm (Fin 5))) ∧
      GraphLattices.f4FrobeniusPermutation ∉ alternatingGroup (Fin 5) ∧
      GraphLattices.f4FrobeniusPermutation.IsSwap ∧
      Equiv.Perm.sign GraphLattices.f4FrobeniusPermutation = -1 ∧
      (∀ permutation : alternatingGroup (Fin 5),
        GraphLattices.f4FrobeniusPermutation * permutation *
            GraphLattices.f4FrobeniusPermutation⁻¹ ∈
          alternatingGroup (Fin 5)) ∧
      ∀ matrix : PSL(2, GraphLattices.F4),
        ∃ conjugate : PSL(2, GraphLattices.F4),
          GraphLattices.psl2F4ProjectiveAction conjugate =
            GraphLattices.f4FrobeniusPermutation *
                GraphLattices.psl2F4ProjectiveAction matrix *
              GraphLattices.f4FrobeniusPermutation⁻¹ := by
  exact ⟨GraphLattices.symmetricGroup_fin_five_card,
    GraphLattices.alternatingGroup_fin_five_index,
    GraphLattices.alternatingGroup_fin_five_normalizer_eq_top,
    GraphLattices.f4FrobeniusPermutation_mem_normalizer,
    GraphLattices.f4FrobeniusPermutation_not_mem_alternating,
    GraphLattices.f4FrobeniusPermutation_isSwap,
    GraphLattices.f4FrobeniusPermutation_sign,
    GraphLattices.f4FrobeniusPermutation_conjugate_mem_alternating,
    GraphLattices.exists_psl2F4_projectiveAction_eq_frobenius_conjugate⟩

/-- The manuscript's primitive-sixth algebraic-multiplicity formula, applied
to a supplied finite framed-monodromy matrix.  Construction of that operator
from the small even quantum connection remains outside this definition. -/
noncomputable def framedSixthMultiplicity
    (monodromy : Quantum.FramedMonodromyMatrix) : ℕ :=
  monodromy.sixthMultiplicity

/-- Algebraic projective-bundle pattern: an `r`-fold power of a nonzero block
characteristic polynomial has `r` times its primitive-sixth multiplicity. -/
theorem framedSixthMultiplicity_polynomial_pow
    (polynomial : Polynomial ℂ) (nonzero : polynomial ≠ 0) (rank : ℕ) :
    Quantum.sixthMultiplicityPolynomial (polynomial ^ rank) =
      rank * Quantum.sixthMultiplicityPolynomial polynomial :=
  Quantum.sixthMultiplicityPolynomial_pow polynomial nonzero rank

/-- Algebraic blowup/direct-sum pattern: the primitive-sixth multiplicity of
a product of nonzero block characteristic polynomials is the sum of their
multiplicities. -/
theorem framedSixthMultiplicity_polynomial_list_prod
    (polynomials : List (Polynomial ℂ))
    (nonzero : ∀ polynomial ∈ polynomials, polynomial ≠ 0) :
    Quantum.sixthMultiplicityPolynomial polynomials.prod =
      (polynomials.map Quantum.sixthMultiplicityPolynomial).sum :=
  Quantum.sixthMultiplicityPolynomial_list_prod polynomials nonzero

/-- Arithmetic core of Cai's cubic rank-two block: the displayed indicial
polynomial factors with exponents `-1/6` and `-5/6`, whose one-turn framed
monodromies are the two primitive sixth roots. -/
theorem cubicPacket_indicial_factorization_and_framed_eigenvalues :
    Quantum.cubicIndicialPolynomial =
        (Polynomial.X - Polynomial.C (-1 / 6)) *
          (Polynomial.X - Polynomial.C (-5 / 6)) ∧
      Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (-1 / 6)) =
        Quantum.primitiveSixthRootNegative ∧
      Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (-5 / 6)) =
        Quantum.primitiveSixthRootPositive :=
  ⟨Quantum.cubicIndicialPolynomial_factorization,
    Quantum.cubicExponent_neg_one_sixth,
    Quantum.cubicExponent_neg_five_sixths⟩

/-- Reviewer-facing type of strict Novikov-admissibility certificates for an
effective numerical monoid and a complete separated topological domain. -/
def strictNovikovAdmissibleData
    (Curve Target : Type*)
    [AddCommMonoid Curve] [CommRing Target] [IsDomain Target]
    [UniformSpace Target] [CompleteSpace Target] [T2Space Target]
    [IsTopologicalRing Target] : Type _ :=
  Quantum.StrictNovikovAdmissible (Curve := Curve) (Target := Target)

/-- Reviewer-facing type of compatible invertible finite-level Laurent gauge
systems.  Every loop exponent is integral by the `LaurentSeries` coefficient
type, while no uniform lower bound across levels is imposed. -/
def proLaurentGaugeSystem
    (Index : Type*) [Fintype Index] [DecidableEq Index] : Type _ :=
  Quantum.ProLaurentGaugeSystem Index

/-- Reviewer-facing type of finite-level characteristic polynomials compatible
under all coefficient reductions. -/
def proLaurentCharacteristicPolynomialSystem : Type _ :=
  Quantum.CompatibleCharacteristicPolynomialSystem

/-- Finite-matrix coefficientwise base change followed by conjugacy: the
resulting characteristic polynomial is exactly the coefficientwise image of
the original one. -/
theorem framedMonodromy_characteristicPolynomial_baseChange_and_gauge
    {Index R S : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [CommRing S]
    (monodromy : Matrix Index Index R) (extension : R →+* S)
    (gauge : (Matrix Index Index S)ˣ) :
    (gauge.val * monodromy.map extension * gauge.val⁻¹).charpoly =
      monodromy.charpoly.map extension :=
  Quantum.framedCharacteristicPolynomial_map_and_conjugate
    monodromy extension gauge

/-- Bounded-degree finiteness makes the homological fiber over each numerical
class a finite set, with no extra cutoff condition in its membership theorem.
-/
theorem numericalNovikov_finiteFiber_exact
    {Homology Numerical : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical]
    (data : Quantum.NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    (homological : Homology) (numerical : Numerical) :
    homological ∈ data.fiber numerical ↔
      data.quotient homological = numerical :=
  data.mem_fiber_iff homological numerical

/-- The coefficient of the numerical pushforward is the finite sum of the
homological coefficients in the exact numerical fiber. -/
theorem numericalNovikov_coefficientPushforward_apply
    {Homology Numerical R : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical] [AddCommMonoid R]
    (data : Quantum.NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    (series : Homology → R) (numerical : Numerical) :
    data.coefficientPushforward series numerical =
      ∑ degree ∈ data.fiber numerical, series degree :=
  data.coefficientPushforward_apply series numerical

/-- Once the finite-level string/divisor/bulk analysis supplies an explicit
integral-frame conjugacy, the bulk monodromy characteristic polynomial is the
small characteristic polynomial after the fixed divisor substitution. -/
theorem formalBaseShift_characteristicPolynomial_of_matrixInput
    {Index Coefficient : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing Coefficient]
    (input : Quantum.FormalBaseShiftMatrixInput Index Coefficient) :
    input.bulkMonodromy.charpoly =
      input.smallMonodromy.charpoly.map input.divisorSubstitution :=
  input.characteristicPolynomial_eq

/-- The divisor-tag separation fragment: an injective integral tag makes the
pair of specialized monomial and tag injective even if the specialized
monomial map alone is not injective. -/
theorem strictNovikov_injective_taggedMonomial
    {Curve Target : Type*}
    [AddCommMonoid Curve] [CommRing Target] [IsDomain Target]
    [UniformSpace Target] [CompleteSpace Target] [T2Space Target]
    [IsTopologicalRing Target]
    (specialization : Quantum.StrictNovikovAdmissible
      (Curve := Curve) (Target := Target))
    {Tag : Type*} (divisorTag : Curve → Tag)
    (separates : Function.Injective divisorTag) :
    Function.Injective (fun degree ↦
      (specialization.monomialImage degree, divisorTag degree)) :=
  specialization.injective_taggedMonomial divisorTag separates

/-- Public form of the weak-factorization telescope: composable steps that
preserve a packet multiplicity preserve it between their endpoints. -/
theorem packet_multiplicity_eq_of_preserving_chain
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    {source target : Variety}
    (chain : Quantum.PreservingChain packet source target) :
    packet.multiplicity source = packet.multiplicity target :=
  chain.multiplicity_eq packet

/-- Reviewer-facing weak-factorization telescope with the blowup bookkeeping
exposed: smooth endpoints and centers, codimension, dimensions, specialized
center contributions, and the operation formula all occur in the typed input.
The smoothness assumptions are stated explicitly even though the arithmetic
telescope itself consumes them through each blowup step. -/
theorem packet_multiplicity_eq_of_typed_weak_factorization
    {Variety Center : Type*} (packet : Quantum.PacketData Variety)
    (geometry : Quantum.BlowupGeometry packet Center)
    {source target : Variety}
    (sourceSmooth : geometry.smoothProjectiveComplex source)
    (targetSmooth : geometry.smoothProjectiveComplex target)
    (sourceDimension : packet.dimension source ≤ 4)
    (chain : Quantum.WeakFactorizationChain packet geometry source target)
    (vanishing :
      Quantum.CenterContributionsVanishThroughDimensionTwo geometry) :
    packet.multiplicity source = packet.multiplicity target := by
  have _ := sourceSmooth
  have _ := targetSmooth
  exact chain.multiplicity_eq_of_center_vanishing sourceDimension vanishing

/-- Reviewer-facing birational-invariance deduction.  Its typed input records
the geometric weak-factorization and operation-formula premise explicitly. -/
theorem packet_multiplicity_birational_in_dimension_four
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (input : Quantum.DimensionFourBirationalInput packet)
    {source target : Variety} (sourceDimension : packet.dimension source ≤ 4)
    (birational : input.birational source target) :
    packet.multiplicity source = packet.multiplicity target :=
  input.multiplicity_eq packet sourceDimension birational

/-- Reviewer-facing transport across two birational rank-two projective
bundles, the formal deduction used for the genus-eight Fano application. -/
theorem rankTwoProjectiveBundle_packet_transport
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (input : Quantum.DimensionFourBirationalInput packet)
    {leftBase rightBase leftBundle rightBundle : Variety}
    (leftFormula : packet.multiplicity leftBundle =
      2 * packet.multiplicity leftBase)
    (rightFormula : packet.multiplicity rightBundle =
      2 * packet.multiplicity rightBase)
    (bundleDimension : packet.dimension leftBundle ≤ 4)
    (bundlesBirational : input.birational leftBundle rightBundle) :
    packet.multiplicity leftBase = packet.multiplicity rightBase :=
  Quantum.rankTwoProjectiveBundle_transport packet input leftFormula rightFormula
    bundleDimension bundlesBirational

/-- Reviewer-facing irrationality deduction from a nonzero packet invariant. -/
theorem irrational_of_nonzero_packet
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (input : Quantum.DimensionFourBirationalInput packet)
    (Rational : Variety → Prop)
    {object comparison : Variety}
    (objectDimension : packet.dimension object ≤ 4)
    (objectNonzero : packet.multiplicity object ≠ 0)
    (comparisonZero : packet.multiplicity comparison = 0)
    (rationalComparison : Rational object → input.birational object comparison) :
    ¬ Rational object :=
  Quantum.not_rational_of_nonzero_multiplicity packet input Rational objectDimension
    objectNonzero comparisonZero rationalComparison

/-- Reviewer-facing form of the cubic-threefold one-step irrationality
deduction.  The input structure exposes every external quantum and geometric
premise used by the proof. -/
theorem cubicThreefold_oneStep_irrational_of_packet_inputs
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : Applications.CubicThreefoldGeometry Variety)
    {cubic : Variety}
    (input : Applications.CubicThreefoldOneStepInput
      packet birationalInput geometry cubic) :
    ¬ geometry.Rational (geometry.productWithProjectiveLine cubic) :=
  Applications.cubicThreefold_oneStepStabilization_not_rational
    packet birationalInput geometry input

/-- Reviewer-facing packet transport from an associated cubic threefold to a
genus-eight Fano threefold, conditional on the typed projective-bundle and flop
premises. -/
theorem genusEight_packet_eq_two_of_flop_inputs
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : Applications.GenusEightGeometry Variety)
    {fano : Variety}
    (input : Applications.GenusEightOneStepInput
      packet birationalInput geometry fano) :
    packet.multiplicity fano = 2 :=
  Applications.genusEight_packet_eq_two_of_projectiveBundle_flop
    packet birationalInput geometry input

/-- Reviewer-facing one-step irrationality deduction for a genus-eight Fano
threefold.  Its typed input keeps the cubic packet, projective-bundle flop, and
rational comparison visible. -/
theorem genusEight_oneStep_irrational_of_flop_inputs
    {Variety : Type*} (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : Applications.GenusEightGeometry Variety)
    {fano : Variety}
    (input : Applications.GenusEightOneStepInput
      packet birationalInput geometry fano) :
    ¬ geometry.Rational (geometry.productWithProjectiveLine fano) :=
  Applications.genusEight_oneStepStabilization_not_rational
    packet birationalInput geometry input

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
