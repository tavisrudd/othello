import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.PaperInterface.Imports

/-!
# Integral minimal-class reviewer terminals

Integral divisor-product and minimal-class terminals.  Geometric and literature
inputs remain explicit in the declaration types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

open TensorProduct

open scoped MatrixGroups

/-- Exact conditional form of the manuscript's universal `CH₀` corollary.
The six-axis input supplies smoothness and algebraicity of the primitive
minimal class fibrewise; the cited Voisin equivalence is a separate explicit
premise.  Lean performs only the universal logical deduction and constructs
none of the geometric objects or premises. -/
theorem universalCH0_of_sixAxisMinimalClass_and_Voisin
    {Base CubicObject JacobianObject : Type*}
    (geometry : Applications.CubicCycleTrivialityGeometry
      CubicObject JacobianObject)
    (fibre : Base → CubicObject)
    (familyInput : Applications.SixAxisMinimalClassFamilyInput geometry fibre)
    (voisinCriterion :
      Applications.VoisinPrimitiveMinimalClassCriterion geometry) :
    ∀ parameter, geometry.universallyCH0Trivial (fibre parameter) :=
  Applications.universalCH0Triviality_of_primitiveMinimalClassFamily
    geometry fibre familyInput voisinCriterion
/-- Exact conditional form of both sentences of the separated-variable
proposition.  The independently established fibrewise universal `CH₀`
statement is composed with the Eckardt-locus exclusion, so the second sentence
is no longer omitted from the public terminal. -/
theorem separatedVariableLocus_and_universalCH0_outside
    {Base Variety Moduli : Type*}
    (fibre : Base → Variety) (moduliPoint : Base → Moduli)
    (hasEckardtPoint universallyCH0Trivial separatedVariableType : Variety → Prop)
    (projectivelyEquivalent : Variety → Variety → Prop)
    (distinguishedPoint : Moduli)
    (input : Applications.SeparatedVariableModuliInput fibre moduliPoint
      hasEckardtPoint separatedVariableType projectivelyEquivalent
      distinguishedPoint)
    (allFibresUniversallyCH0Trivial : ∀ parameter,
      universallyCH0Trivial (fibre parameter)) :
    Applications.SeparatedVariableUniversalCH0Conclusion fibre moduliPoint
      universallyCH0Trivial separatedVariableType projectivelyEquivalent
      distinguishedPoint :=
  Applications.separatedVariableLocus_and_universalCH0_outside fibre moduliPoint
    hasEckardtPoint universallyCH0Trivial separatedVariableType
    projectivelyEquivalent distinguishedPoint input allFibresUniversallyCH0Trivial
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
/-- Exact coefficient-lattice criterion after scalar extension and a supplied
invertible basis change over the extension ring.  The base and split axes may
differ: Lean restricts the transported form to its dependent slope blocks and
proves that weighted-lattice membership is equivalent to symmetry plus the
three formal graph-coordinate descent conditions.  The basis, slope-block
data, and interpretation of these algebraic conditions as geometric divisor
descent are supplied rather than constructed. -/
theorem graphCoefficient_afterSplitBasisChange_iff_descent
    {R S BaseAxis BlockIndex : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Fintype BaseAxis] [DecidableEq BaseAxis]
    (Block : BlockIndex → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    [Fintype (GraphLattices.SplitGraphAxis Block)]
    [DecidableEq (GraphLattices.SplitGraphAxis Block)]
    (basis : GraphLattices.SplitCoordinateBasisEquivalence S BaseAxis
      (GraphLattices.SplitGraphAxis Block))
    {π : S} (data : GraphLattices.NormalizedDVRValuation π)
    (depth : BlockIndex → ℕ) (scalar : BlockIndex → S)
    (slopeError : ∀ index, Matrix (Block index) (Block index) S)
    (form : Matrix BaseAxis BaseAxis R) :
    GraphLattices.MemWeightedMatrix π (fun axis ↦ depth axis.1)
        (GraphLattices.splitGraphCrossDepth Block data.valuation depth scalar)
        (GraphLattices.splitCoordinateCoefficientExtension
          basis.toSplit form) ↔
      GraphLattices.GraphBlockSymmetric Block
          (GraphLattices.blockCoefficientOfMatrix Block
            (GraphLattices.splitCoordinateCoefficientExtension
              basis.toSplit form)) ∧
        GraphLattices.GraphBlockDescentCondition Block π depth scalar
          slopeError
          (GraphLattices.blockCoefficientOfMatrix Block
            (GraphLattices.splitCoordinateCoefficientExtension
              basis.toSplit form)) :=
  GraphLattices.splitCoordinateCoefficientExtension_memWeightedMatrix_iff_graphDescent
    Block basis data depth scalar slopeError form
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
/-- Exact transport from base coordinates to a separately indexed basis over
the coefficient-extension ring.  Congruence preserves scalar rank-one forms,
and applying the supplied inverse basis change recovers every extended base
form.  The basis equivalence itself remains data: this theorem does not
construct a finite-etale splitting or eigenbasis. -/
theorem graphLattice_splitCoordinateBasisChange_rankOne_and_recovery
    {R S BaseAxis SplitAxis : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Fintype BaseAxis] [Fintype SplitAxis]
    [DecidableEq BaseAxis] [DecidableEq SplitAxis]
    (basis : GraphLattices.SplitCoordinateBasisEquivalence
      S BaseAxis SplitAxis)
    (coefficient : R) (vector : BaseAxis → R)
    (form : Matrix BaseAxis BaseAxis S) :
    GraphLattices.splitCoordinateCoefficientExtension basis.toSplit
        (GraphLattices.matrixRankOne coefficient vector) =
      GraphLattices.matrixRankOne (algebraMap R S coefficient)
        (GraphLattices.splitCoordinateVector basis.toSplit
          (fun index ↦ algebraMap R S (vector index))) ∧
      GraphLattices.matrixCongruence basis.toBase
          (GraphLattices.matrixCongruence basis.toSplit form) = form :=
  ⟨GraphLattices.splitCoordinateCoefficientExtension_matrixRankOne
      basis.toSplit coefficient vector,
    GraphLattices.matrixCongruence_toBase_toSplit basis form⟩
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
/-- The split-graph all-degree packet with the base and split coordinate types
kept distinct.  A supplied invertible `S`-basis change transports the
entrywise scalar extension of the base coefficient form into the split graph
lattice.  Lean discharges rank-one generation, square-zero expansion, and
faithfully-flat product descent; membership after basis change and all
cohomological identifications remain explicit hypotheses. -/
theorem rankOne_allDegree_dividedPower_of_splitGraphDVR_afterBasisChange
    {R S Target BaseAxis BlockIndex : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Module.FaithfullyFlat R S]
    [IsDomain S] [IsDiscreteValuationRing S]
    [CommRing Target] [Algebra R Target]
    [Fintype BaseAxis] [DecidableEq BaseAxis]
    (Block : BlockIndex → Type*)
    [Fintype (GraphLattices.SplitGraphAxis Block)]
    [DecidableEq (GraphLattices.SplitGraphAxis Block)]
    [LinearOrder (GraphLattices.SplitGraphAxis Block)]
    (basis : GraphLattices.SplitCoordinateBasisEquivalence S BaseAxis
      (GraphLattices.SplitGraphAxis Block))
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
    (form : Matrix BaseAxis BaseAxis R)
    (member : GraphLattices.splitCoordinateCoefficientExtension
        basis.toSplit form ∈
      GraphLattices.weightedMatrixSubmodule (algebraMap R S π)
        (fun axis ↦ depth axis.1)
        (GraphLattices.splitGraphCrossDepth Block
          (IsDiscreteValuationRing.addVal S) depth scalar))
    (baseClass dividedPower : Target)
    (baseClassCompatible :
      extendedRealization
          (GraphLattices.splitCoordinateCoefficientExtension
            basis.toSplit form) =
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
      forms.sum = GraphLattices.splitCoordinateCoefficientExtension
        basis.toSplit form →
      Algebra.TensorProduct.includeRight dividedPower =
        GraphLattices.squarefreeProductSum
          (forms.map extendedRealization) degree) :
    dividedPower ∈ ordinaryDivisorProductSubmodule divisors degree ∧
      baseClass ^ degree = (degree.factorial : Target) * dividedPower :=
  GraphLattices.allDegree_dividedPowerMember_of_splitGraphDVR_afterBasisChange
    Block basis π extendedπIrreducible depth scalar extendedRealization
    pullback pullbackInjective sourceCompatible divisors
    extendedRealizationMember form member baseClass dividedPower
    baseClassCompatible degree dividedPowerCompatible
/-- The split-graph all-degree packet stated with the actual blockwise descent
conditions in place of an opaque transported-lattice membership premise.
After a supplied invertible extension-ring basis change, symmetry and the
three graph-coordinate descent conditions—including the commutator with the
right slope transposed in `A Tᵗ - T A`—imply the exact split weighted lattice;
Lean then discharges rank-one generation, square-zero expansion, and
faithful-flat product descent.  The spectral basis and
geometric/cohomological compatibilities remain supplied. -/
theorem rankOne_allDegree_dividedPower_of_markedGraphDescent_afterBasisChange
    {R S Target BaseAxis BlockIndex : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Module.FaithfullyFlat R S]
    [IsDomain S] [IsDiscreteValuationRing S]
    [CommRing Target] [Algebra R Target]
    [Fintype BaseAxis] [DecidableEq BaseAxis]
    (Block : BlockIndex → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    [Fintype (GraphLattices.SplitGraphAxis Block)]
    [DecidableEq (GraphLattices.SplitGraphAxis Block)]
    [LinearOrder (GraphLattices.SplitGraphAxis Block)]
    (basis : GraphLattices.SplitCoordinateBasisEquivalence S BaseAxis
      (GraphLattices.SplitGraphAxis Block))
    (π : R) (extendedπIrreducible : Irreducible (algebraMap R S π))
    (depth : BlockIndex → ℕ) (scalar : BlockIndex → S)
    (slopeError : ∀ index, Matrix (Block index) (Block index) S)
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
    (form : Matrix BaseAxis BaseAxis R)
    (formSymmetric : form.IsSymm)
    (graphDescent : GraphLattices.GraphBlockDescentCondition Block
      (algebraMap R S π) depth scalar slopeError
      (GraphLattices.blockCoefficientOfMatrix Block
        (GraphLattices.splitCoordinateCoefficientExtension
          basis.toSplit form)))
    (baseClass dividedPower : Target)
    (baseClassCompatible :
      extendedRealization
          (GraphLattices.splitCoordinateCoefficientExtension
            basis.toSplit form) =
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
      forms.sum = GraphLattices.splitCoordinateCoefficientExtension
        basis.toSplit form →
      Algebra.TensorProduct.includeRight dividedPower =
        GraphLattices.squarefreeProductSum
          (forms.map extendedRealization) degree) :
    dividedPower ∈ ordinaryDivisorProductSubmodule divisors degree ∧
      baseClass ^ degree = (degree.factorial : Target) * dividedPower :=
  GraphLattices.allDegree_dividedPowerMember_of_markedGraphDescent_afterBasisChange
    Block basis π extendedπIrreducible depth scalar slopeError
    extendedRealization pullback pullbackInjective sourceCompatible divisors
    extendedRealizationMember form formSymmetric graphDescent baseClass
    dividedPower baseClassCompatible degree dividedPowerCompatible
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
/-- Exact minimal-polynomial statement for the characteristic-two
residue-field model.  The matrix has minimal polynomial `t²+t+1` over `F₂`.
This identifies the algebraic type of the displayed model only, not the slope
of the geometric principal kernel. -/
theorem sixAxisLocalChart_twoPrimary_minimalPolynomialModel :
    minpoly (ZMod 2) GraphLattices.sixAxisTwoQuadraticSlope =
      GraphLattices.sixAxisQuadraticSlopePolynomial :=
  GraphLattices.sixAxisTwoQuadraticSlope_minpoly
/-- Explicit spectral splitting of the characteristic-two model.  Over any
commutative characteristic-two ring containing a root `ω` of `t²+t+1`, the
displayed change of basis is invertible and diagonalizes the two companion
blocks with diagonal `(ω,ω+1,ω,ω+1)`.  This terminal does not construct such
a ring or identify it geometrically; the next terminal constructs the
specific quadratic finite-etale extension of `F₂` needed by this model. -/
theorem sixAxisLocalChart_twoPrimary_splitsOverQuadraticRoot
    {K : Type*} [CommRing K] [CharP K 2] (ω : K)
    (root : ω ^ 2 + ω + 1 = 0) :
    GraphLattices.sixAxisTwoQuadraticSlope.map
          (ZMod.castHom dvd_rfl K) =
        GraphLattices.sixAxisTwoQuadraticSlopeOver K ∧
      GraphLattices.sixAxisTwoQuadraticEigenbasis K ω *
          GraphLattices.sixAxisTwoQuadraticEigenbasisInverse K ω = 1 ∧
      GraphLattices.sixAxisTwoQuadraticEigenbasisInverse K ω *
          GraphLattices.sixAxisTwoQuadraticEigenbasis K ω = 1 ∧
      GraphLattices.sixAxisTwoQuadraticSlopeOver K *
          GraphLattices.sixAxisTwoQuadraticEigenbasis K ω =
        GraphLattices.sixAxisTwoQuadraticEigenbasis K ω *
          GraphLattices.sixAxisTwoQuadraticDiagonal K ω := by
  exact ⟨GraphLattices.sixAxisTwoQuadraticSlope_map_castHom K,
    GraphLattices.sixAxisTwoQuadraticEigenbasis_mul_inverse K ω,
    GraphLattices.sixAxisTwoQuadraticEigenbasis_inverse_mul K ω,
    GraphLattices.sixAxisTwoQuadraticSlopeOver_mul_eigenbasis K ω root⟩
/-- Concrete finite-etale spectral splitting of the characteristic-two model.
Lean adjoins a marked root of `t²+t+1` to `F₂`, proves that the resulting field
is a finite etale algebra of degree two, constructs an `F₂`-algebra equivalence
with the concrete four-element field used for the gluing packet.  For the
chosen equivalence, Lean proves that the transported marked root is neither
`0` nor `1`, and that it and `root+1` form a distinct two-cycle in the affine
chart of the five-point projective gluing packet.  It also
exhibits mutually inverse eigenbasis matrices that diagonalize the two
companion blocks both in the root-adjoining field and directly over the
concrete four-element field.  No prior naming distinguishes the two exotic gluing scalars, so this
identifies the transported root only as one member of their Frobenius pair.
This constructs the algebraic splitting
object for the displayed residue model, but does not identify it or the
displayed matrix with the manuscript's geometric principal kernel. -/
theorem sixAxisLocalChart_twoPrimary_concreteFiniteEtaleSplitting :
    Module.Finite (ZMod 2) GraphLattices.SixAxisQuadraticSplittingField ∧
      Algebra.Etale (ZMod 2) GraphLattices.SixAxisQuadraticSplittingField ∧
      Module.finrank (ZMod 2)
          GraphLattices.SixAxisQuadraticSplittingField = 2 ∧
      Nonempty (GraphLattices.SixAxisQuadraticSplittingField ≃ₐ[ZMod 2]
        GraphLattices.F4) ∧
      GraphLattices.sixAxisQuadraticSlopeRootInF4 =
        GraphLattices.sixAxisQuadraticSplittingFieldAlgEquivF4
          GraphLattices.sixAxisQuadraticSlopeRoot ∧
      (GraphLattices.sixAxisQuadraticSlopeRootInF4 ^ 2 +
            GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1 = 0 ∧
        GraphLattices.sixAxisQuadraticSlopeRootInF4 ≠ 0 ∧
        GraphLattices.sixAxisQuadraticSlopeRootInF4 ≠ 1) ∧
      (GraphLattices.f4Frobenius
            GraphLattices.sixAxisQuadraticSlopeRootInF4 ≠
          GraphLattices.sixAxisQuadraticSlopeRootInF4 ∧
        GraphLattices.f4Frobenius (GraphLattices.f4Frobenius
            GraphLattices.sixAxisQuadraticSlopeRootInF4) =
          GraphLattices.sixAxisQuadraticSlopeRootInF4) ∧
      GraphLattices.f4Frobenius
          GraphLattices.sixAxisQuadraticSlopeRootInF4 =
        GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1 ∧
      (GraphLattices.f4ProjectiveFrobenius
            (some GraphLattices.sixAxisQuadraticSlopeRootInF4) =
          some (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1) ∧
        GraphLattices.f4ProjectiveFrobenius
            (some (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1)) =
          some GraphLattices.sixAxisQuadraticSlopeRootInF4 ∧
        (some GraphLattices.sixAxisQuadraticSlopeRootInF4 :
            Option GraphLattices.F4) ≠
          some (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1)) ∧
      (GraphLattices.sixAxisTwoQuadraticEigenbasis GraphLattices.F4
            GraphLattices.sixAxisQuadraticSlopeRootInF4 *
          GraphLattices.sixAxisTwoQuadraticEigenbasisInverse GraphLattices.F4
            GraphLattices.sixAxisQuadraticSlopeRootInF4 = 1 ∧
        GraphLattices.sixAxisTwoQuadraticEigenbasisInverse GraphLattices.F4
            GraphLattices.sixAxisQuadraticSlopeRootInF4 *
          GraphLattices.sixAxisTwoQuadraticEigenbasis GraphLattices.F4
            GraphLattices.sixAxisQuadraticSlopeRootInF4 = 1 ∧
        GraphLattices.sixAxisTwoQuadraticSlopeOver GraphLattices.F4 *
            GraphLattices.sixAxisTwoQuadraticEigenbasis GraphLattices.F4
              GraphLattices.sixAxisQuadraticSlopeRootInF4 =
          GraphLattices.sixAxisTwoQuadraticEigenbasis GraphLattices.F4
              GraphLattices.sixAxisQuadraticSlopeRootInF4 *
            GraphLattices.sixAxisTwoQuadraticDiagonal GraphLattices.F4
              GraphLattices.sixAxisQuadraticSlopeRootInF4) ∧
      GraphLattices.sixAxisQuadraticSlopeRoot ^ 2 +
          GraphLattices.sixAxisQuadraticSlopeRoot + 1 = 0 ∧
      GraphLattices.sixAxisTwoQuadraticEigenbasis
            GraphLattices.SixAxisQuadraticSplittingField
            GraphLattices.sixAxisQuadraticSlopeRoot *
          GraphLattices.sixAxisTwoQuadraticEigenbasisInverse
            GraphLattices.SixAxisQuadraticSplittingField
            GraphLattices.sixAxisQuadraticSlopeRoot = 1 ∧
      GraphLattices.sixAxisTwoQuadraticEigenbasisInverse
            GraphLattices.SixAxisQuadraticSplittingField
            GraphLattices.sixAxisQuadraticSlopeRoot *
          GraphLattices.sixAxisTwoQuadraticEigenbasis
            GraphLattices.SixAxisQuadraticSplittingField
            GraphLattices.sixAxisQuadraticSlopeRoot = 1 ∧
      GraphLattices.sixAxisTwoQuadraticSlopeOver
            GraphLattices.SixAxisQuadraticSplittingField *
          GraphLattices.sixAxisTwoQuadraticEigenbasis
            GraphLattices.SixAxisQuadraticSplittingField
            GraphLattices.sixAxisQuadraticSlopeRoot =
        GraphLattices.sixAxisTwoQuadraticEigenbasis
            GraphLattices.SixAxisQuadraticSplittingField
            GraphLattices.sixAxisQuadraticSlopeRoot *
          GraphLattices.sixAxisTwoQuadraticDiagonal
            GraphLattices.SixAxisQuadraticSplittingField
            GraphLattices.sixAxisQuadraticSlopeRoot := by
  exact ⟨GraphLattices.sixAxisQuadraticSplittingField_moduleFinite,
    GraphLattices.sixAxisQuadraticSplittingField_etale,
    GraphLattices.sixAxisQuadraticSplittingField_finrank,
    ⟨GraphLattices.sixAxisQuadraticSplittingFieldAlgEquivF4⟩,
    rfl,
    GraphLattices.sixAxisQuadraticSlopeRootInF4_equation_and_exotic,
    GraphLattices.sixAxisQuadraticSlopeRootInF4_frobenius_conjugate,
    GraphLattices.sixAxisQuadraticSlopeRootInF4_frobenius_eq_add_one,
    GraphLattices.sixAxisQuadraticSlope_markedProjectivePair,
    GraphLattices.sixAxisTwoQuadraticSlope_f4Marked_split,
    GraphLattices.sixAxisQuadraticSlopeRoot_equation,
    GraphLattices.sixAxisTwoQuadraticSlope_concreteFiniteEtale_split⟩
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
/-- The depth-one lifting step of the local chart, in the generality in which the
manuscript states it.  Let the coefficient ring be a domain in which `p` and `2`
are nonzero, and let the Gram matrix be symmetric with a two-sided inverse over
that ring.  Every endomorphism of the reduction modulo `p` that is self-adjoint
for the reduced dual coefficient form is the reduction of an endomorphism
self-adjoint for the dual coefficient form itself.  The witness corrects a chosen
lift by `p` times the Gram matrix times the strictly lower triangular part of the
divided adjointness defect, so the construction divides by nothing.  The
statement is about matrices over a ring; it does not identify the residue
endomorphism with the slope of a geometric principal kernel. -/
theorem sixAxisLocalChart_depthOne_selfAdjointLift
    {R Index : Type*} [CommRing R] [IsDomain R] [Fintype Index] [DecidableEq Index]
    [LinearOrder Index] {p : R} (nonzero : p ≠ 0) (twoNonzero : (2 : R) ≠ 0)
    {gram inverseGram : Matrix Index Index R}
    (symmetric : Matrix.transpose gram = gram)
    (rightInverse : gram * inverseGram = 1)
    (leftInverse : inverseGram * gram = 1)
    (residue : Matrix Index Index (R ⧸ Ideal.span ({p} : Set R)))
    (residueSelfAdjoint :
      Matrix.transpose residue *
          inverseGram.map (Ideal.Quotient.mk (Ideal.span ({p} : Set R))) =
        inverseGram.map (Ideal.Quotient.mk (Ideal.span ({p} : Set R))) * residue) :
    ∃ lift : Matrix Index Index R,
      lift.map (Ideal.Quotient.mk (Ideal.span ({p} : Set R))) = residue ∧
        Matrix.transpose lift * inverseGram = inverseGram * lift :=
  GraphLattices.exists_selfAdjoint_lift_of_residue_selfAdjoint nonzero twoNonzero
    symmetric rightInverse leftInverse residue residueSelfAdjoint
/-- The two ways the depth-one lifting step meets an orthogonal decomposition of
the coefficient lattice.  A block-diagonal matrix is self-adjoint for a
block-diagonal inverse Gram matrix as soon as each block is self-adjoint for its
own block, so lifts built separately on orthogonal summands assemble into one
lift and the decomposition is preserved; and a scalar matrix is self-adjoint for
every inverse Gram matrix, so a lift on one summand extends by a scalar on its
orthogonal complement. -/
theorem sixAxisLocalChart_selfAdjointLift_orthogonalSummands
    {R First Second : Type*} [CommRing R] [Fintype First] [DecidableEq First]
    [Fintype Second] [DecidableEq Second]
    (firstInverseGram firstMatrix : Matrix First First R)
    (secondInverseGram secondMatrix : Matrix Second Second R) (scalar : R)
    (firstSelfAdjoint :
      Matrix.transpose firstMatrix * firstInverseGram = firstInverseGram * firstMatrix)
    (secondSelfAdjoint :
      Matrix.transpose secondMatrix * secondInverseGram =
        secondInverseGram * secondMatrix) :
    Matrix.transpose (Matrix.fromBlocks firstMatrix 0 0 secondMatrix) *
          Matrix.fromBlocks firstInverseGram 0 0 secondInverseGram =
        Matrix.fromBlocks firstInverseGram 0 0 secondInverseGram *
          Matrix.fromBlocks firstMatrix 0 0 secondMatrix ∧
      Matrix.transpose (scalar • (1 : Matrix First First R)) * firstInverseGram =
        firstInverseGram * (scalar • (1 : Matrix First First R)) :=
  ⟨GraphLattices.fromBlocks_selfAdjoint firstInverseGram firstMatrix secondInverseGram
      secondMatrix firstSelfAdjoint secondSelfAdjoint,
    GraphLattices.smul_one_selfAdjoint scalar firstInverseGram⟩
/-- The unimodular summand of the five-axis coefficient lattice carries no
discriminant.  Multiplication by `6I₅-J₅` is the map to the dual lattice in the
same coordinates, and the quotient by its image is the discriminant group.  Using
the integral reduction to `diag(1,6,6,6,6)`, Lean proves that the constant vector
is in that image; that the constant vector has value five under the form, the
value of the first coordinate line of the local chart, so it spans a unimodular
summand at two and at three; that every integral vector is congruent modulo the
image to a combination of the four remaining reduced basis vectors, whose Smith
entries have exact depth one at both primes; and that six annihilates the
quotient.  The primary part at either prime dividing six is therefore supported
on those four coordinates.  Lean constructs no abelian scheme, polarization, or
isogeny kernel, and does not identify this discriminant group with a geometric
kernel. -/
theorem sixAxisLocalChart_unitSummand_carries_no_discriminant :
    Matrix.mulVec (GraphLattices.sixAxisGram ℤ)
          (Matrix.mulVec GraphLattices.sixAxisSmithRight (Pi.single 0 1)) =
        (fun _ ↦ (1 : ℤ)) ∧
      GraphLattices.sixAxisGramPairing (R := ℤ) (fun _ ↦ 1) (fun _ ↦ 1) = 5 ∧
      (∀ value : Fin 5 → ℤ, ∃ source coordinates : Fin 5 → ℤ,
        coordinates 0 = 0 ∧
          value = Matrix.mulVec (GraphLattices.sixAxisGram ℤ) source +
            Matrix.mulVec GraphLattices.sixAxisSmithLeftInverse coordinates) ∧
      ∀ value : Fin 5 → ℤ, ∃ source : Fin 5 → ℤ,
        (6 : ℤ) • value = Matrix.mulVec (GraphLattices.sixAxisGram ℤ) source :=
  ⟨GraphLattices.sixAxisGram_unitLine_mem_image,
    GraphLattices.sixAxisGram_constantVector_pairing,
    GraphLattices.sixAxisGram_discriminant_supported_off_unitLine,
    GraphLattices.sixAxisGram_six_smul_mem_image⟩
/-- The orthogonal decomposition of the coefficient lattice in the local chart,
as a change of basis, together with the triviality of the principal quotient on
its unimodular summand.  Over any coefficient ring in which five has an inverse —
in particular over the two-adic and three-adic integers, the two cases the
manuscript needs — the chart change of basis is invertible, and it carries
`6I₅-J₅` to the block matrix `sixAxisChartGram` whose first row and column are
the unit line of value five and whose complementary four-by-four block is
`(6/5)(5I₄-J₄)`.  The first chart dual vector then lies in the image of
`6I₅-J₅`, and every vector is congruent modulo that image to a combination of the
four chart dual vectors orthogonal to it.  Lean constructs no abelian scheme,
polarization, or isogeny kernel, and does not identify this quotient with a
geometric kernel. -/
theorem sixAxisLocalChart_orthogonalDecomposition_and_unitLine
    {R : Type*} [CommRing R] (inverseFive : R) (inverse : 5 * inverseFive = 1) :
    GraphLattices.sixAxisChartBasis inverseFive *
          GraphLattices.sixAxisChartBasisInverse inverseFive = 1 ∧
      GraphLattices.sixAxisChartBasisInverse inverseFive *
          GraphLattices.sixAxisChartBasis inverseFive = 1 ∧
      Matrix.transpose (GraphLattices.sixAxisChartBasis inverseFive) *
            GraphLattices.sixAxisGram R *
            GraphLattices.sixAxisChartBasis inverseFive =
          GraphLattices.sixAxisChartGram inverseFive ∧
      Matrix.mulVec (GraphLattices.sixAxisGram R)
            (Matrix.mulVec (GraphLattices.sixAxisChartBasis inverseFive)
              (Pi.single 0 inverseFive)) =
          Matrix.mulVec
            (Matrix.transpose (GraphLattices.sixAxisChartBasisInverse inverseFive))
            (Pi.single 0 (1 : R)) ∧
      ∀ value : Fin 5 → R, ∃ source coordinates : Fin 5 → R,
        coordinates 0 = 0 ∧
          value = Matrix.mulVec (GraphLattices.sixAxisGram R) source +
            Matrix.mulVec
              (Matrix.transpose (GraphLattices.sixAxisChartBasisInverse inverseFive))
              coordinates :=
  ⟨(GraphLattices.sixAxisChartBasis_mul_inverse inverseFive).1,
    (GraphLattices.sixAxisChartBasis_mul_inverse inverseFive).2,
    GraphLattices.sixAxisChartBasis_congruence inverseFive inverse,
    GraphLattices.sixAxisChart_unitLine_mem_image inverseFive inverse,
    GraphLattices.sixAxisChart_discriminant_supported_off_unitLine inverseFive inverse⟩
/-- The depth decomposition carried by the local chart, and unimodularity of its
depth-one summand.  Over a coefficient ring in which five is invertible and in
which `6/5` is the uniformizer times an invertible scalar — at `p = 2` with unit
multiple `3/5`, at `p = 3` with unit multiple `2/5` — the chart Gram matrix has
value five on the first coordinate line, vanishes between that line and the
other four coordinates, and equals the uniformizer times the unit multiple of
the block `5I₄-J₄` on those four coordinates.  That block is symmetric and has
the two-sided inverse `(1/5)(I₄+J₄)`, so the depth-one summand is unimodular
after division by the uniformizer.  This is the depth prescription `(Z_p⁵,G) ≃
U₀ ⊥ pU₁` of the local chart, at the level of coefficient matrices; no lattice,
polarization, or isogeny kernel is constructed. -/
theorem sixAxisLocalChart_depthOneBlock_unimodular
    {R : Type*} [CommRing R] (inverseFive uniformizer unitPart inverseUnitPart : R)
    (inverse : 5 * inverseFive = 1) (unitInverse : unitPart * inverseUnitPart = 1)
    (scale : 6 * inverseFive = uniformizer * unitPart) :
    GraphLattices.sixAxisChartGram inverseFive 0 0 = 5 ∧
      (∀ column : Fin 4, GraphLattices.sixAxisChartGram inverseFive 0 column.succ = 0) ∧
      (∀ row : Fin 4, GraphLattices.sixAxisChartGram inverseFive row.succ 0 = 0) ∧
      (∀ row column : Fin 4,
        GraphLattices.sixAxisChartGram inverseFive row.succ column.succ =
          uniformizer * (unitPart * GraphLattices.sixAxisComplementBlock R row column)) ∧
      Matrix.transpose (unitPart • GraphLattices.sixAxisComplementBlock R) =
          unitPart • GraphLattices.sixAxisComplementBlock R ∧
        (unitPart • GraphLattices.sixAxisComplementBlock R) *
            (inverseUnitPart • GraphLattices.sixAxisComplementBlockInverse inverseFive) = 1 ∧
          (inverseUnitPart • GraphLattices.sixAxisComplementBlockInverse inverseFive) *
              (unitPart • GraphLattices.sixAxisComplementBlock R) = 1 :=
  ⟨(GraphLattices.sixAxisChartGram_depthDecomposition inverseFive uniformizer unitPart
      scale).1,
    (GraphLattices.sixAxisChartGram_depthDecomposition inverseFive uniformizer unitPart
      scale).2.1,
    (GraphLattices.sixAxisChartGram_depthDecomposition inverseFive uniformizer unitPart
      scale).2.2.1,
    (GraphLattices.sixAxisChartGram_depthDecomposition inverseFive uniformizer unitPart
      scale).2.2.2,
    (GraphLattices.sixAxisDepthOneBlock_symmetric_and_invertible inverseFive unitPart
      inverseUnitPart inverse unitInverse).1,
    (GraphLattices.sixAxisDepthOneBlock_symmetric_and_invertible inverseFive unitPart
      inverseUnitPart inverse unitInverse).2.1,
    (GraphLattices.sixAxisDepthOneBlock_symmetric_and_invertible inverseFive unitPart
      inverseUnitPart inverse unitInverse).2.2⟩
/-- The depth-one lifting construction at the actual depth-one summand of the
local chart.  Over a domain in which the uniformizer and two are nonzero and
five and the unit multiple of the block `5I₄-J₄` are invertible, every
endomorphism of the reduction of that summand modulo the uniformizer which is
self-adjoint for its reduced dual form is the reduction of an endomorphism
self-adjoint for the dual form itself.  Nothing is divided.  Unlike the general
lifting terminal, no invertible Gram matrix is supplied here: the one the
manuscript uses is exhibited.  The residue endomorphism is still an arbitrary
matrix and is not identified with the slope of a geometric principal kernel. -/
theorem sixAxisLocalChart_depthOneBlock_selfAdjointLift
    {R : Type*} [CommRing R] [IsDomain R] {uniformizer : R}
    (uniformizerNonzero : uniformizer ≠ 0) (twoNonzero : (2 : R) ≠ 0)
    (inverseFive unitPart inverseUnitPart : R)
    (inverse : 5 * inverseFive = 1) (unitInverse : unitPart * inverseUnitPart = 1)
    (residue : Matrix (Fin 4) (Fin 4) (R ⧸ Ideal.span ({uniformizer} : Set R)))
    (residueSelfAdjoint :
      Matrix.transpose residue *
          (inverseUnitPart • GraphLattices.sixAxisComplementBlockInverse inverseFive).map
            (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set R))) =
        (inverseUnitPart • GraphLattices.sixAxisComplementBlockInverse inverseFive).map
            (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set R))) * residue) :
    ∃ lift : Matrix (Fin 4) (Fin 4) R,
      lift.map (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set R))) = residue ∧
        Matrix.transpose lift *
            (inverseUnitPart • GraphLattices.sixAxisComplementBlockInverse inverseFive) =
          (inverseUnitPart • GraphLattices.sixAxisComplementBlockInverse inverseFive) * lift :=
  GraphLattices.exists_selfAdjoint_lift_sixAxisDepthOneBlock uniformizerNonzero
    twoNonzero inverseFive unitPart inverseUnitPart inverse unitInverse residue
    residueSelfAdjoint
/-- The six-axis coefficient form in the split coordinates of the local chart,
and orthogonality of the eigenblocks of the depth-one slope.  The split
coordinates are the chart coordinates followed by a supplied change of basis of
the depth-one summand.  In them the form is again the unit line of value five
orthogonal to the depth-one part, whose block is the multiple `6/5` of the
transported block `5I₄-J₄`.  Two depth-one coordinates that are eigenvectors of
a slope self-adjoint for `5I₄-J₄`, with eigenvalues whose difference is
cancellable, pair to zero, which is the step making the eigenblocks orthogonal
summands.  The slope, its eigenvectors, and the change of basis are supplied
matrices; no geometric principal kernel is constructed. -/
theorem sixAxisLocalChart_splitCoordinates_orthogonalBlocks
    {S : Type*} [CommRing S] (inverseFive : S) (inverse : 5 * inverseFive = 1)
    (slope block : Matrix (Fin 4) (Fin 4) S)
    (selfAdjoint : Matrix.transpose slope * GraphLattices.sixAxisComplementBlock S =
      GraphLattices.sixAxisComplementBlock S * slope)
    (first second : Fin 4) (firstValue secondValue : S)
    (firstEigen : Matrix.mulVec slope (fun index ↦ block index first) =
      firstValue • fun index ↦ block index first)
    (secondEigen : Matrix.mulVec slope (fun index ↦ block index second) =
      secondValue • fun index ↦ block index second)
    (cancellable : ∀ scalar : S, (firstValue - secondValue) * scalar = 0 → scalar = 0) :
    Matrix.transpose (GraphLattices.sixAxisSplitBasisMatrix inverseFive block) *
            GraphLattices.sixAxisGram S *
            GraphLattices.sixAxisSplitBasisMatrix inverseFive block =
          GraphLattices.sixAxisBlockDiagonal 5
            ((6 * inverseFive) •
              (Matrix.transpose block * GraphLattices.sixAxisComplementBlock S * block)) ∧
      (Matrix.transpose (GraphLattices.sixAxisSplitBasisMatrix inverseFive block) *
          GraphLattices.sixAxisGram S *
          GraphLattices.sixAxisSplitBasisMatrix inverseFive block)
        first.succ second.succ = 0 :=
  ⟨GraphLattices.sixAxisSplitBasisMatrix_congruence inverseFive inverse block,
    GraphLattices.sixAxisSplitBasisMatrix_congruence_eq_zero inverseFive inverse slope
      block selfAdjoint first second firstValue secondValue firstEigen secondEigen
      cancellable⟩
/-- The split form of a depth-one slope whose residue is scalar, which is the
case of the local chart at three.  Over any coefficient ring, a matrix whose
reduction modulo the uniformizer is the scalar matrix of a residue class is that
scalar plus the uniformizer times an integral error term; nothing is divided,
since the error term is assembled from the divisibility witnesses of the
entries.  For a slope in that form the split-slope commutator of the
graph-coordinate descent conditions is the commutator of the coefficient block
with the actual slope, so the depth-one blocks impose exactly the manuscript's
descent condition on the slope itself.  At three the depth-one summand is a
single block, so this determines the split presentation data from the slope; no
geometric principal kernel or its residue is constructed. -/
theorem sixAxisLocalChart_scalarResidueSlope_splitForm
    {S Index : Type*} [CommRing S] [Fintype Index] [DecidableEq Index]
    (uniformizer scalar : S) (slope : Matrix Index Index S)
    (residue : slope.map (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set S))) =
      (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set S)) scalar) •
        (1 : Matrix Index Index (S ⧸ Ideal.span ({uniformizer} : Set S))))
    (coefficient : Matrix Index Index S) :
    ∃ error : Matrix Index Index S,
      slope = scalar • (1 : Matrix Index Index S) + uniformizer • error ∧
        GraphLattices.rectangularSplitSlopeCommutator uniformizer 1 1 coefficient
            scalar scalar error error =
          coefficient * Matrix.transpose slope - slope * coefficient := by
  obtain ⟨error, splitForm⟩ :=
    GraphLattices.exists_slopeError_of_residue_scalar uniformizer scalar slope residue
  exact ⟨error, splitForm,
    GraphLattices.rectangularSplitSlopeCommutator_eq_slopeCommutator uniformizer
      scalar slope error coefficient splitForm⟩
/-- Divided-power saturation of the six-axis graph divisor lattice, with the
split presentation supplied by the local chart rather than as an abstract
premise.  The coordinates are the five chart coordinates followed by a supplied
change of basis of the depth-one summand, distributed over the unimodular line
and the blocks of the depth-one slope; the depth is zero on that line and one on
every depth-one block; and the slope scalars and error terms are those of the
split slope.  Under the three graph-coordinate descent conditions for exactly
these data, every divided power of a class in the lattice is an ordinary
integral divisor product.  What remains supplied is geometric: the cohomological
realization of coefficient matrices, the injective pullback to the
elliptic-power source, the divisor submodule, and the compatibility of the class
and its divided power with that realization. -/
theorem sixAxisChart_allDegree_dividedPower_of_markedGraphDescent
    {R S Target DepthIndex : Type} {DepthBlock : DepthIndex → Type}
    [CommRing R] [CommRing S] [Algebra R S] [Module.FaithfullyFlat R S]
    [IsDomain S] [IsDiscreteValuationRing S] [CommRing Target] [Algebra R Target]
    [∀ index, Fintype (DepthBlock index)] [∀ index, DecidableEq (DepthBlock index)]
    [Fintype (GraphLattices.SplitGraphAxis (GraphLattices.sixAxisSplitBlock DepthBlock))]
    [DecidableEq (GraphLattices.SplitGraphAxis (GraphLattices.sixAxisSplitBlock DepthBlock))]
    [LinearOrder (GraphLattices.SplitGraphAxis (GraphLattices.sixAxisSplitBlock DepthBlock))]
    (depthEquiv : (Σ index, DepthBlock index) ≃ Fin 4)
    (inverseFive : S) (block blockInverse : Matrix (Fin 4) (Fin 4) S)
    (blockRightInverse : block * blockInverse = 1)
    (blockLeftInverse : blockInverse * block = 1)
    (uniformizer : R)
    (extendedUniformizerIrreducible : Irreducible (algebraMap R S uniformizer))
    (scalar : DepthIndex → S)
    (slopeError : ∀ index, Matrix (DepthBlock index) (DepthBlock index) S)
    (extendedRealization :
      Matrix (GraphLattices.SplitGraphAxis (GraphLattices.sixAxisSplitBlock DepthBlock))
          (GraphLattices.SplitGraphAxis (GraphLattices.sixAxisSplitBlock DepthBlock)) S →+
        TensorProduct R S Target)
    (pullback : TensorProduct R S Target →+*
      ExteriorAlgebra S (GraphLattices.EllipticSourceHOne S
        (GraphLattices.SplitGraphAxis (GraphLattices.sixAxisSplitBlock DepthBlock))))
    (pullbackInjective : Function.Injective pullback)
    (sourceCompatible : ∀ candidate,
      pullback (extendedRealization candidate) =
        GraphLattices.ellipticSourceCoefficientRealization candidate)
    (divisors : Submodule R Target)
    (extendedRealizationMember : ∀ candidate,
      candidate ∈ GraphLattices.weightedMatrixSubmodule (algebraMap R S uniformizer)
          (fun axis ↦ GraphLattices.sixAxisSplitDepth axis.1)
          (GraphLattices.splitGraphCrossDepth (GraphLattices.sixAxisSplitBlock DepthBlock)
            (IsDiscreteValuationRing.addVal S) GraphLattices.sixAxisSplitDepth
            (GraphLattices.sixAxisSplitScalar scalar)) →
        extendedRealization candidate ∈
          GraphLattices.scalarExtendedSubmodule S
            (Algebra.TensorProduct.includeRight (R := R) (A := S) (B := Target))
            divisors)
    (form : Matrix (Fin 5) (Fin 5) R) (formSymmetric : form.IsSymm)
    (graphDescent : GraphLattices.GraphBlockDescentCondition
      (GraphLattices.sixAxisSplitBlock DepthBlock) (algebraMap R S uniformizer)
      GraphLattices.sixAxisSplitDepth (GraphLattices.sixAxisSplitScalar scalar)
      (GraphLattices.sixAxisSplitSlopeError slopeError)
      (GraphLattices.blockCoefficientOfMatrix (GraphLattices.sixAxisSplitBlock DepthBlock)
        (GraphLattices.splitCoordinateCoefficientExtension
          (GraphLattices.sixAxisSplitBasis depthEquiv inverseFive block blockInverse
            blockRightInverse blockLeftInverse).toSplit form)))
    (baseClass dividedPower : Target)
    (baseClassCompatible :
      extendedRealization
          (GraphLattices.splitCoordinateCoefficientExtension
            (GraphLattices.sixAxisSplitBasis depthEquiv inverseFive block blockInverse
              blockRightInverse blockLeftInverse).toSplit form) =
        Algebra.TensorProduct.includeRight baseClass)
    (degree : ℕ)
    (dividedPowerCompatible :
      ∀ forms : List (Matrix
          (GraphLattices.SplitGraphAxis (GraphLattices.sixAxisSplitBlock DepthBlock))
          (GraphLattices.SplitGraphAxis (GraphLattices.sixAxisSplitBlock DepthBlock)) S),
      (∀ candidate ∈ forms,
        candidate ∈ GraphLattices.weightedRankOneSet (algebraMap R S uniformizer)
          (fun axis ↦ GraphLattices.sixAxisSplitDepth axis.1)
          (GraphLattices.splitGraphCrossDepth (GraphLattices.sixAxisSplitBlock DepthBlock)
            (IsDiscreteValuationRing.addVal S) GraphLattices.sixAxisSplitDepth
            (GraphLattices.sixAxisSplitScalar scalar))) →
      forms.sum = GraphLattices.splitCoordinateCoefficientExtension
          (GraphLattices.sixAxisSplitBasis depthEquiv inverseFive block blockInverse
            blockRightInverse blockLeftInverse).toSplit form →
      Algebra.TensorProduct.includeRight dividedPower =
        GraphLattices.squarefreeProductSum (forms.map extendedRealization) degree) :
    dividedPower ∈ ordinaryDivisorProductSubmodule divisors degree ∧
      baseClass ^ degree = (degree.factorial : Target) * dividedPower :=
  GraphLattices.sixAxisChart_allDegree_dividedPowerMember depthEquiv inverseFive block
    blockInverse blockRightInverse blockLeftInverse uniformizer
    extendedUniformizerIrreducible scalar slopeError extendedRealization pullback
    pullbackInjective sourceCompatible divisors extendedRealizationMember form
    formSymmetric graphDescent baseClass dividedPower baseClassCompatible degree
    dividedPowerCompatible
/-- Reviewer-facing rank criterion behind the Eckardt condition.  In
coordinates adapted to a point of a cubic hypersurface, the defining form reads
`x₀²L + x₀Q + C` and the Hessian at that point is the bordered symmetric matrix
whose distinguished entry is zero, whose border is the coefficient vector of the
linear part `L`, and whose remaining block is the matrix of the quadratic part
`Q`.  Over a field in which two is invertible, and for a nonzero border and a
symmetric block, that matrix has rank at most two exactly when the block is the
symmetrized outer product of the border with a single vector, which is the
matrix form of `Q` being a multiple of `L`.  Lean constructs no cubic form,
hypersurface, tangent hyperplane section, cone, or Eckardt point, and does not
carry out the passage from a point of a smooth cubic threefold to this normal
form. -/
theorem borderedHessian_rank_le_two_iff_borderDivides
    {K Index : Type*} [Field K] [Fintype Index] [DecidableEq Index]
    {v : Index → K} {block : Matrix Index Index K} (nonzeroBorder : v ≠ 0)
    (symmetric : block.IsSymm) (twoNeZero : (2 : K) ≠ 0) :
    (Applications.borderedMatrix v block).rank ≤ 2 ↔
      ∃ w, block = Applications.symmetrizedOuterProduct v w :=
  Applications.borderedMatrix_rank_le_two_iff nonzeroBorder symmetric twoNeZero

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
