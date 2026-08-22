import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.GraphCoefficientBlocks

/-!
# Marked split graph presentations

This module turns the dependent family of split slope blocks into one literal
matrix-of-ideals lattice on the disjoint union of the block bases.  It proves
that the block descent equations are exactly membership in that weighted
matrix lattice, including entries within a nontrivial diagonal block.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

/-- The disjoint union of the coordinate bases of a split graph family. -/
abbrev SplitGraphAxis (Block : Index → Type*) := Σ index, Block index

/-- Assemble dependent rectangular coefficient blocks into one square
coefficient matrix on the disjoint union of their coordinate bases. -/
def flattenBlockCoefficient
    {R Index : Type*} [CommRing R] (Block : Index → Type*)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) :
    Matrix (SplitGraphAxis Block) (SplitGraphAxis Block) R :=
  fun row column ↦ coefficient row.1 column.1 row.2 column.2

/-- Blockwise transpose symmetry is exactly symmetry of the flattened
coefficient matrix. -/
theorem flattenBlockCoefficient_isSymm_iff
    {R Index : Type*} [CommRing R] (Block : Index → Type*)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) :
    (flattenBlockCoefficient Block coefficient).IsSymm ↔
      GraphBlockSymmetric Block coefficient := by
  constructor
  · intro symmetric first second
    ext row column
    have entry := congrFun
      (congrFun symmetric ⟨first, row⟩) ⟨second, column⟩
    simpa [Matrix.IsSymm, Matrix.transpose_apply,
      flattenBlockCoefficient] using entry
  · intro blockSymmetric
    ext row column
    have entry := congrFun
      (congrFun (blockSymmetric column.1 row.1) column.2) row.2
    simpa [Matrix.IsSymm, Matrix.transpose_apply,
      flattenBlockCoefficient] using entry.symm

/-- The cross-depth prescription on the flattened disjoint union. -/
def splitGraphCrossDepth
    {R Index : Type*} [CommRing R] (Block : Index → Type*)
    (valuation : R → ℕ∞) (depth : Index → ℕ) (scalar : Index → R) :
    SplitGraphAxis Block → SplitGraphAxis Block → ℕ :=
  fun first second ↦
    graphCrossDepth (depth first.1) (depth second.1)
      (valuation (scalar second.1 - scalar first.1))

/-- The flattened cross-depth function is symmetric for a valuation. -/
theorem splitGraphCrossDepth_symmetric
    {R Index : Type*} [CommRing R] (Block : Index → Type*)
    (valuation : AddValuation R ℕ∞) (depth : Index → ℕ) (scalar : Index → R) :
    ∀ first second,
      splitGraphCrossDepth Block valuation depth scalar first second =
        splitGraphCrossDepth Block valuation depth scalar second first := by
  intro first second
  unfold splitGraphCrossDepth
  have valuationEqual :
      valuation (scalar first.1 - scalar second.1) =
        valuation (scalar second.1 - scalar first.1) := by
    rw [show scalar first.1 - scalar second.1 =
        -(scalar second.1 - scalar first.1) by ring]
    exact valuation.map_neg _
  rw [valuationEqual]
  simp only [graphCrossDepth, add_comm]
  omega

/-- The block depth condition is exactly the entrywise depth condition in the
flattened weighted matrix lattice.  Diagonal entries and off-diagonal entries
inside one block are both included. -/
theorem memWeightedMatrix_flattenBlockCoefficient_iff
    {R Index : Type*} [CommRing R]
    (Block : Index → Type*)
    {uniformizer : R} (data : NormalizedDVRValuation uniformizer)
    (depth : Index → ℕ) (scalar : Index → R)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) :
    MemWeightedMatrix uniformizer (fun axis ↦ depth axis.1)
        (splitGraphCrossDepth Block data.valuation depth scalar)
        (flattenBlockCoefficient Block coefficient) ↔
      GraphBlockSymmetric Block coefficient ∧
        GraphBlockDepthCondition Block uniformizer data.valuation depth scalar
          coefficient := by
  constructor
  · rintro ⟨symmetric, diagonalMember, crossMember⟩
    refine ⟨(flattenBlockCoefficient_isSymm_iff Block coefficient).mp symmetric,
      ?_⟩
    intro first second row column
    by_cases sameAxis : (⟨first, row⟩ : SplitGraphAxis Block) = ⟨second, column⟩
    · cases sameAxis
      have diagonalDepth : graphCrossDepth (depth first) (depth first)
          (data.valuation (scalar first - scalar first)) = depth first := by
        rw [sub_self, data.valuation_zero]
        change graphCrossDepth (depth first) (depth first) (⊤ : ENat) = depth first
        rw [graphCrossDepth_top, max_self]
      rw [diagonalDepth]
      exact diagonalMember ⟨first, row⟩
    · exact crossMember ⟨first, row⟩ ⟨second, column⟩ sameAxis
  · rintro ⟨symmetric, depthCondition⟩
    refine ⟨(flattenBlockCoefficient_isSymm_iff Block coefficient).mpr symmetric,
      ?_, ?_⟩
    · intro axis
      have entry := depthCondition axis.1 axis.1 axis.2 axis.2
      have diagonalDepth : graphCrossDepth (depth axis.1) (depth axis.1)
          (data.valuation (scalar axis.1 - scalar axis.1)) = depth axis.1 := by
        rw [sub_self, data.valuation_zero]
        change graphCrossDepth (depth axis.1) (depth axis.1) (⊤ : ENat) = depth axis.1
        rw [graphCrossDepth_top, max_self]
      rw [diagonalDepth] at entry
      exact entry
    · intro row column distinct
      exact depthCondition row.1 column.1 row.2 column.2

/-- Complete coefficient-lattice theorem for a dependent family of finite
split graph blocks:
the literal flattened weighted matrix lattice is exactly the locus satisfying
symmetry and the three graph-coordinate descent conditions. -/
theorem memWeightedMatrix_flattenBlockCoefficient_iff_graphDescent
    {R Index : Type*} [CommRing R]
    (Block : Index → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    {uniformizer : R} (data : NormalizedDVRValuation uniformizer)
    (depth : Index → ℕ) (scalar : Index → R)
    (slopeError : ∀ index, Matrix (Block index) (Block index) R)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) :
    MemWeightedMatrix uniformizer (fun axis ↦ depth axis.1)
        (splitGraphCrossDepth Block data.valuation depth scalar)
        (flattenBlockCoefficient Block coefficient) ↔
      GraphBlockSymmetric Block coefficient ∧
        GraphBlockDescentCondition Block uniformizer depth scalar slopeError
          coefficient := by
  rw [memWeightedMatrix_flattenBlockCoefficient_iff]
  exact symmetricGraphBlockDepthCondition_iff_descentCondition
    Block data depth scalar slopeError coefficient

/-- Every pair of flattened graph depths satisfies the midpoint inequality
needed for rank-one generation. -/
theorem splitGraphCrossDepth_pairwise_midpoint
    {R Index : Type*} [CommRing R] (Block : Index → Type*)
    (valuation : R → ℕ∞) (depth : Index → ℕ) (scalar : Index → R) :
    ∀ first second : SplitGraphAxis Block,
      depth first.1 + depth second.1 ≤
        2 * splitGraphCrossDepth Block valuation depth scalar first second := by
  intro first second
  exact graphCrossDepth_midpoint _ _ _

/-- Over a DVR, the flattened coefficient lattice attached to split block
data with a finite flattened axis is rank-one generated.  This is the direct composition of the
graph cross-depth midpoint bound with the exact DVR criterion. -/
theorem splitGraph_weightedMatrix_rankOneGenerated_of_dvr
    {R Index : Type*} [CommRing R] [IsDomain R]
    [IsDiscreteValuationRing R]
    (Block : Index → Type*) [Fintype (SplitGraphAxis Block)]
    [DecidableEq (SplitGraphAxis Block)] [LinearOrder (SplitGraphAxis Block)]
    (uniformizer : R) (uniformizerIrreducible : Irreducible uniformizer)
    (depth : Index → ℕ) (scalar : Index → R) :
    WeightedMatrixRankOneGenerated uniformizer (fun axis ↦ depth axis.1)
      (splitGraphCrossDepth Block (IsDiscreteValuationRing.addVal R)
        depth scalar) := by
  apply (weightedMatrixRankOneGenerated_iff_pairwise_midpoint_of_dvr
    uniformizerIrreducible (fun axis ↦ depth axis.1)
      (splitGraphCrossDepth Block (IsDiscreteValuationRing.addVal R)
        depth scalar)
      (splitGraphCrossDepth_symmetric Block
        (IsDiscreteValuationRing.addVal R) depth scalar)).mpr
  intro first second _
  exact splitGraphCrossDepth_pairwise_midpoint Block
    (IsDiscreteValuationRing.addVal R) depth scalar first second

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
