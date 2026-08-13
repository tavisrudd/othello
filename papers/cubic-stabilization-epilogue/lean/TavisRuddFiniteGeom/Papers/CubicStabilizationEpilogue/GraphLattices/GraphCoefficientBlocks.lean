import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.GraphCoefficientDepth

/-!
# Rectangular block form of the graph coefficient calculation

This module lifts the scalar depth arithmetic to actual rectangular matrix
blocks.  It records entrywise power divisibility, verifies the split-slope
commutator expansion for arbitrary finite block ranks, and proves that the
error terms impose no condition beyond the two diagonal coefficient depths.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- Every entry of a rectangular matrix is divisible by `factor`. -/
def MatrixEntriesDivisibleBy
    {R I J : Type*} [CommRing R] (factor : R) (matrix : Matrix I J R) : Prop :=
  ∀ row column, factor ∣ matrix row column

namespace MatrixEntriesDivisibleBy

variable {R I J K : Type*} [CommRing R]

/-- Entrywise divisibility is preserved by subtraction. -/
theorem sub {factor : R} {left right : Matrix I J R}
    (leftDivides : MatrixEntriesDivisibleBy factor left)
    (rightDivides : MatrixEntriesDivisibleBy factor right) :
    MatrixEntriesDivisibleBy factor (left - right) := by
  intro row column
  exact (leftDivides row column).sub (rightDivides row column)

/-- Right matrix multiplication preserves entrywise divisibility. -/
theorem mul_right [Fintype J] {factor : R} {left : Matrix I J R}
    (leftDivides : MatrixEntriesDivisibleBy factor left)
    (right : Matrix J K R) :
    MatrixEntriesDivisibleBy factor (left * right) := by
  intro row column
  rw [Matrix.mul_apply]
  exact Finset.dvd_sum fun index _ ↦
    dvd_mul_of_dvd_left (leftDivides row index) _

/-- Left matrix multiplication preserves entrywise divisibility. -/
theorem mul_left [Fintype I] {factor : R} {right : Matrix I J R}
    (rightDivides : MatrixEntriesDivisibleBy factor right)
    (left : Matrix K I R) :
    MatrixEntriesDivisibleBy factor (left * right) := by
  intro row column
  rw [Matrix.mul_apply]
  exact Finset.dvd_sum fun index _ ↦
    dvd_mul_of_dvd_right (rightDivides index column) _

/-- Multiplying a matrix by one uniformizer power upgrades an entrywise
divisibility condition by the sum of the two exponents. -/
theorem pow_add_smul [Fintype I]
    (uniformizer : R) (firstDepth secondDepth : ℕ)
    {matrix : Matrix I J R}
    (matrixDivides : MatrixEntriesDivisibleBy
      (uniformizer ^ firstDepth) matrix) :
    MatrixEntriesDivisibleBy (uniformizer ^ (firstDepth + secondDepth))
      ((uniformizer ^ secondDepth) • matrix) := by
  intro row column
  rcases matrixDivides row column with ⟨quotient, identity⟩
  refine ⟨quotient, ?_⟩
  simp only [Matrix.smul_apply, smul_eq_mul]
  rw [identity, pow_add]
  ring

end MatrixEntriesDivisibleBy

/-- The actual rectangular commutator block obtained from two split slope
blocks of possibly different ranks. -/
def rectangularSplitSlopeCommutator
    {R I J : Type*} [CommRing R] [Fintype I] [Fintype J]
    [DecidableEq I] [DecidableEq J]
    (uniformizer : R) (firstDepth secondDepth : ℕ)
    (coefficient : Matrix I J R) (firstScalar secondScalar : R)
    (firstError : Matrix I I R) (secondError : Matrix J J R) :
    Matrix I J R :=
  coefficient *
      (Matrix.scalar J secondScalar +
        (uniformizer ^ secondDepth) • secondError.transpose) -
    (Matrix.scalar I firstScalar +
        (uniformizer ^ firstDepth) • firstError) * coefficient

/-- Rectangular-matrix version of the manuscript's split-slope commutator
expansion. -/
theorem rectangularSplitSlopeCommutator_expansion
    {R I J : Type*} [CommRing R] [Fintype I] [Fintype J]
    [DecidableEq I] [DecidableEq J]
    (uniformizer : R) (firstDepth secondDepth : ℕ)
    (coefficient : Matrix I J R) (firstScalar secondScalar : R)
    (firstError : Matrix I I R) (secondError : Matrix J J R) :
    rectangularSplitSlopeCommutator uniformizer firstDepth secondDepth
        coefficient firstScalar secondScalar firstError secondError =
      (secondScalar - firstScalar) • coefficient +
        (uniformizer ^ secondDepth) • (coefficient * secondError.transpose) -
        (uniformizer ^ firstDepth) • (firstError * coefficient) := by
  unfold rectangularSplitSlopeCommutator
  rw [Matrix.mul_add, Matrix.add_mul]
  simp only [Matrix.scalar_apply]
  rw [← Matrix.smul_eq_mul_diagonal coefficient secondScalar,
    ← Matrix.smul_eq_diagonal_mul coefficient firstScalar,
    Matrix.mul_smul, Matrix.smul_mul]
  module

/-- Under the two diagonal coefficient conditions, total-depth divisibility
of the rectangular split-slope commutator is equivalent entry by entry to
total-depth divisibility of the scalar-difference block. -/
theorem rectangularSplitSlopeCommutator_totalDepth_iff
    {R I J : Type*} [CommRing R] [Fintype I] [Fintype J]
    [DecidableEq I] [DecidableEq J]
    (uniformizer : R) (firstDepth secondDepth : ℕ)
    (coefficient : Matrix I J R) (firstScalar secondScalar : R)
    (firstError : Matrix I I R) (secondError : Matrix J J R)
    (firstCoefficientDivides : MatrixEntriesDivisibleBy
      (uniformizer ^ firstDepth) coefficient)
    (secondCoefficientDivides : MatrixEntriesDivisibleBy
      (uniformizer ^ secondDepth) coefficient) :
    MatrixEntriesDivisibleBy (uniformizer ^ (firstDepth + secondDepth))
        (rectangularSplitSlopeCommutator uniformizer firstDepth secondDepth
          coefficient firstScalar secondScalar firstError secondError) ↔
      MatrixEntriesDivisibleBy (uniformizer ^ (firstDepth + secondDepth))
        ((secondScalar - firstScalar) • coefficient) := by
  rw [rectangularSplitSlopeCommutator_expansion]
  have secondErrorDivides :
      MatrixEntriesDivisibleBy (uniformizer ^ (firstDepth + secondDepth))
        ((uniformizer ^ secondDepth) • (coefficient * secondError.transpose)) :=
    MatrixEntriesDivisibleBy.pow_add_smul uniformizer firstDepth secondDepth
      (MatrixEntriesDivisibleBy.mul_right firstCoefficientDivides
        secondError.transpose)
  have firstErrorDivides :
      MatrixEntriesDivisibleBy (uniformizer ^ (firstDepth + secondDepth))
        ((uniformizer ^ firstDepth) • (firstError * coefficient)) := by
    rw [add_comm firstDepth secondDepth]
    exact MatrixEntriesDivisibleBy.pow_add_smul uniformizer secondDepth firstDepth
      (MatrixEntriesDivisibleBy.mul_left secondCoefficientDivides firstError)
  constructor
  · intro fullDivides row column
    have restored := ((fullDivides row column).add
      (firstErrorDivides row column)).sub (secondErrorDivides row column)
    convert restored using 1
    simp only [Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply]
    ring
  · intro scalarDivides
    exact MatrixEntriesDivisibleBy.sub
      (fun row column ↦ (scalarDivides row column).add
        (secondErrorDivides row column))
      firstErrorDivides

/-- Entrywise rectangular-matrix form of the truncated valuation-deficit
equivalence. -/
theorem matrixEntries_truncatedDepth_iff_scalarDifference
    {R I J : Type*} [CommRing R] {uniformizer : R}
    (data : NormalizedDVRValuation uniformizer)
    (totalDepth : ℕ) (scalarDifference : R) (coefficient : Matrix I J R) :
    MatrixEntriesDivisibleBy
        (uniformizer ^ truncatedDepthDifference totalDepth
          (data.valuation scalarDifference)) coefficient ↔
      MatrixEntriesDivisibleBy (uniformizer ^ totalDepth)
        (scalarDifference • coefficient) := by
  constructor <;> intro divides row column
  · apply (pow_truncatedDepthDifference_dvd_iff_pow_dvd_mul data
      totalDepth scalarDifference (coefficient row column)).mp
    exact divides row column
  · apply (pow_truncatedDepthDifference_dvd_iff_pow_dvd_mul data
      totalDepth scalarDifference (coefficient row column)).mpr
    simpa only [Matrix.smul_apply, smul_eq_mul] using divides row column

/-- Full positive-positive rectangular block statement behind the manuscript's
depth formula.  The single graph cross-depth condition on every coefficient
entry is equivalent to the two off-diagonal conditions and total-depth
divisibility of the actual split-slope commutator matrix. -/
theorem matrixEntries_graphCrossDepth_iff_splitSlopeCommutator
    {R I J : Type*} [CommRing R] [Fintype I] [Fintype J]
    [DecidableEq I] [DecidableEq J] {uniformizer : R}
    (data : NormalizedDVRValuation uniformizer)
    (firstDepth secondDepth : ℕ)
    (coefficient : Matrix I J R) (firstScalar secondScalar : R)
    (firstError : Matrix I I R) (secondError : Matrix J J R) :
    MatrixEntriesDivisibleBy
        (uniformizer ^ graphCrossDepth firstDepth secondDepth
          (data.valuation (secondScalar - firstScalar))) coefficient ↔
      MatrixEntriesDivisibleBy (uniformizer ^ firstDepth) coefficient ∧
      MatrixEntriesDivisibleBy (uniformizer ^ secondDepth) coefficient ∧
      MatrixEntriesDivisibleBy (uniformizer ^ (firstDepth + secondDepth))
        (rectangularSplitSlopeCommutator uniformizer firstDepth secondDepth
          coefficient firstScalar secondScalar firstError secondError) := by
  constructor
  · intro crossDivides
    have threeConditions :
        MatrixEntriesDivisibleBy (uniformizer ^ firstDepth) coefficient ∧
        MatrixEntriesDivisibleBy (uniformizer ^ secondDepth) coefficient ∧
        MatrixEntriesDivisibleBy
          (uniformizer ^ truncatedDepthDifference (firstDepth + secondDepth)
            (data.valuation (secondScalar - firstScalar))) coefficient := by
      refine ⟨fun row column ↦ ?_, fun row column ↦ ?_, fun row column ↦ ?_⟩
      · exact (pow_graphCrossDepth_dvd_iff uniformizer (coefficient row column)
          firstDepth secondDepth
          (data.valuation (secondScalar - firstScalar))).mp
            (crossDivides row column) |>.1
      · exact (pow_graphCrossDepth_dvd_iff uniformizer (coefficient row column)
          firstDepth secondDepth
          (data.valuation (secondScalar - firstScalar))).mp
            (crossDivides row column) |>.2.1
      · exact (pow_graphCrossDepth_dvd_iff uniformizer (coefficient row column)
          firstDepth secondDepth
          (data.valuation (secondScalar - firstScalar))).mp
            (crossDivides row column) |>.2.2
    refine ⟨threeConditions.1, threeConditions.2.1, ?_⟩
    apply (rectangularSplitSlopeCommutator_totalDepth_iff uniformizer
      firstDepth secondDepth coefficient firstScalar secondScalar firstError
      secondError threeConditions.1 threeConditions.2.1).mpr
    exact (matrixEntries_truncatedDepth_iff_scalarDifference data
      (firstDepth + secondDepth) (secondScalar - firstScalar) coefficient).mp
        threeConditions.2.2
  · rintro ⟨firstDivides, secondDivides, commutatorDivides⟩
    have scalarDifferenceDivides :=
      (rectangularSplitSlopeCommutator_totalDepth_iff uniformizer
        firstDepth secondDepth coefficient firstScalar secondScalar firstError
        secondError firstDivides secondDivides).mp commutatorDivides
    have truncatedDivides :=
      (matrixEntries_truncatedDepth_iff_scalarDifference data
        (firstDepth + secondDepth) (secondScalar - firstScalar) coefficient).mpr
          scalarDifferenceDivides
    intro row column
    exact (pow_graphCrossDepth_dvd_iff uniformizer (coefficient row column)
      firstDepth secondDepth
      (data.valuation (secondScalar - firstScalar))).mpr
        ⟨firstDivides row column, secondDivides row column,
          truncatedDivides row column⟩

/-- Pairing an arbitrary integral unit-depth slope block with a positive-depth
block introduces no condition beyond the positive diagonal coefficient
depth. -/
theorem unitPositive_commutator_divisible
    {R I J : Type*} [CommRing R] [Fintype I] [Fintype J]
    (uniformizer : R) (positiveDepth : ℕ)
    (coefficient : Matrix I J R)
    (unitSlope : Matrix I I R) (positiveSlope : Matrix J J R)
    (coefficientDivides : MatrixEntriesDivisibleBy
      (uniformizer ^ positiveDepth) coefficient) :
    MatrixEntriesDivisibleBy (uniformizer ^ positiveDepth)
      (coefficient * positiveSlope - unitSlope * coefficient) :=
  MatrixEntriesDivisibleBy.sub
    (MatrixEntriesDivisibleBy.mul_right coefficientDivides positiveSlope)
    (MatrixEntriesDivisibleBy.mul_left coefficientDivides unitSlope)

/-- Blockwise coefficient-depth condition for a finite split graph family.
Depth-zero blocks are allowed: writing their slope as a scalar plus an
arbitrary error imposes no restriction because the error is multiplied by
the zeroth power of the uniformizer. -/
def GraphBlockDepthCondition
    {R Index : Type*} [CommRing R]
    (Block : Index → Type*) (uniformizer : R)
    (valuation : R → ℕ∞) (depth : Index → ℕ) (scalar : Index → R)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) : Prop :=
  ∀ first second,
    MatrixEntriesDivisibleBy
      (uniformizer ^ graphCrossDepth (depth first) (depth second)
        (valuation (scalar second - scalar first)))
      (coefficient first second)

/-- The three actual graph-descent block conditions for every ordered pair in
a finite split graph family.  The right slope error is transposed, matching
the `A Tᵗ - T A` block in the graph-coordinate identity. -/
def GraphBlockDescentCondition
    {R Index : Type*} [CommRing R]
    (Block : Index → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    (uniformizer : R) (depth : Index → ℕ) (scalar : Index → R)
    (slopeError : ∀ index, Matrix (Block index) (Block index) R)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) : Prop :=
  ∀ first second,
    MatrixEntriesDivisibleBy (uniformizer ^ depth first)
        (coefficient first second) ∧
      MatrixEntriesDivisibleBy (uniformizer ^ depth second)
        (coefficient first second) ∧
      MatrixEntriesDivisibleBy
        (uniformizer ^ (depth first + depth second))
        (rectangularSplitSlopeCommutator uniformizer
          (depth first) (depth second) (coefficient first second)
          (scalar first) (scalar second) (slopeError first) (slopeError second))

/-- Symmetry of a dependent family of rectangular coefficient blocks. -/
def GraphBlockSymmetric
    {R Index : Type*} [CommRing R] (Block : Index → Type*)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) : Prop :=
  ∀ first second,
    (coefficient second first).transpose = coefficient first second

/-- Dependent-family assembly of the graph coefficient calculation, with a
finite basis in every block.  The
matrix-of-ideals depth prescription for every rectangular block is exactly
equivalent to all three graph-descent block conditions for every ordered
pair, including depth-zero blocks. -/
theorem graphBlockDepthCondition_iff_descentCondition
    {R Index : Type*} [CommRing R]
    (Block : Index → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    {uniformizer : R} (data : NormalizedDVRValuation uniformizer)
    (depth : Index → ℕ) (scalar : Index → R)
    (slopeError : ∀ index, Matrix (Block index) (Block index) R)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) :
    GraphBlockDepthCondition Block uniformizer data.valuation depth scalar
        coefficient ↔
      GraphBlockDescentCondition Block uniformizer depth scalar slopeError
        coefficient := by
  constructor <;> intro condition first second
  · exact (matrixEntries_graphCrossDepth_iff_splitSlopeCommutator data
      (depth first) (depth second) (coefficient first second)
      (scalar first) (scalar second) (slopeError first) (slopeError second)).mp
        (condition first second)
  · exact (matrixEntries_graphCrossDepth_iff_splitSlopeCommutator data
      (depth first) (depth second) (coefficient first second)
      (scalar first) (scalar second) (slopeError first) (slopeError second)).mpr
        (condition first second)

/-- Symmetric matrix-of-ideals form of the dependent-family assembly theorem. -/
theorem symmetricGraphBlockDepthCondition_iff_descentCondition
    {R Index : Type*} [CommRing R]
    (Block : Index → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    {uniformizer : R} (data : NormalizedDVRValuation uniformizer)
    (depth : Index → ℕ) (scalar : Index → R)
    (slopeError : ∀ index, Matrix (Block index) (Block index) R)
    (coefficient : ∀ first second,
      Matrix (Block first) (Block second) R) :
    (GraphBlockSymmetric Block coefficient ∧
      GraphBlockDepthCondition Block uniformizer data.valuation depth scalar
        coefficient) ↔
      (GraphBlockSymmetric Block coefficient ∧
        GraphBlockDescentCondition Block uniformizer depth scalar slopeError
          coefficient) := by
  constructor
  · rintro ⟨symmetric, depthCondition⟩
    exact ⟨symmetric,
      (graphBlockDepthCondition_iff_descentCondition Block data depth scalar
        slopeError coefficient).mp depthCondition⟩
  · rintro ⟨symmetric, descentCondition⟩
    exact ⟨symmetric,
      (graphBlockDepthCondition_iff_descentCondition Block data depth scalar
        slopeError coefficient).mpr descentCondition⟩

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
