import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisLocalChart
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.DepthOneSelfAdjointLift
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.AllDegreeAssembly

/-!
# The six-axis local chart as a split graph presentation

The coefficient lattice of the six-axis graph divisor calculation is the
five-dimensional symmetric lattice with Gram matrix `6I₅-J₅`.  Over a
coefficient ring in which five is invertible, the local chart writes it as the
orthogonal sum of a line of value five and a four-dimensional block equal to
`(6/5)(5I₄-J₄)`.  Whenever `6/5` is a uniformizer times a unit, the second
summand is that uniformizer times a unimodular block, so the chart exhibits the
depth decomposition with depths zero and one.

This module makes that decomposition usable as split-block data for the
weighted matrix lattice.  It records the unimodular block `5I₄-J₄` with its
explicit inverse `(1/5)(I₄+J₄)`, the depth-one entries of the chart Gram
matrix, the lifting statement for endomorphisms of the reduction of the
depth-one block, the split coordinate types carrying one unimodular line and an
arbitrary decomposition of the depth-one block, the explicit coordinate
equivalence they define with the chart, and the resulting instantiation of
split-graph divided-power saturation.  The eigenblock decomposition of the
depth-one slope, its scalars, and its error terms are inputs: the residue slope
of an actual geometric principal kernel is not constructed here, and neither is
any elliptic scheme, isogeny, or cohomological realization.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open Matrix

variable {R : Type*} [CommRing R]

/-- The four-by-four matrix all of whose entries are one. -/
def allOnesBlock (R : Type*) [CommRing R] : Matrix (Fin 4) (Fin 4) R :=
  fun _ _ ↦ 1

/-- The all-ones four-by-four matrix is idempotent up to the factor four. -/
theorem allOnesBlock_mul_self :
    allOnesBlock R * allOnesBlock R = (4 : R) • allOnesBlock R := by
  ext row column
  simp [allOnesBlock, Matrix.mul_apply]

/-- The all-ones four-by-four matrix is symmetric. -/
theorem allOnesBlock_transpose : (allOnesBlock R)ᵀ = allOnesBlock R := by
  ext row column
  simp [allOnesBlock]

/-- The four-dimensional block `5I₄-J₄` appearing in the local chart, whose
multiple `(6/5)(5I₄-J₄)` is the Gram matrix of the complement of the unit
line. -/
def sixAxisComplementBlock (R : Type*) [CommRing R] : Matrix (Fin 4) (Fin 4) R :=
  (5 : R) • (1 : Matrix (Fin 4) (Fin 4) R) - allOnesBlock R

/-- Entries of the complement block: four on the diagonal, minus one off it. -/
theorem sixAxisComplementBlock_apply (row column : Fin 4) :
    sixAxisComplementBlock R row column = if row = column then 4 else -1 := by
  by_cases equality : row = column <;>
    simp [sixAxisComplementBlock, allOnesBlock, equality]
  norm_num

/-- The complement block is symmetric. -/
theorem sixAxisComplementBlock_transpose :
    (sixAxisComplementBlock R)ᵀ = sixAxisComplementBlock R := by
  simp [sixAxisComplementBlock, Matrix.transpose_sub, Matrix.transpose_smul,
    allOnesBlock_transpose]

/-- The inverse `(1/5)(I₄+J₄)` of the complement block, written with an
explicitly supplied inverse of five. -/
def sixAxisComplementBlockInverse (inverseFive : R) : Matrix (Fin 4) (Fin 4) R :=
  inverseFive • ((1 : Matrix (Fin 4) (Fin 4) R) + allOnesBlock R)

/-- The inverse of the complement block is symmetric. -/
theorem sixAxisComplementBlockInverse_transpose (inverseFive : R) :
    (sixAxisComplementBlockInverse inverseFive)ᵀ =
      sixAxisComplementBlockInverse inverseFive := by
  simp [sixAxisComplementBlockInverse, Matrix.transpose_add, Matrix.transpose_smul,
    allOnesBlock_transpose]

/-- The complement block `5I₄-J₄` is invertible over any coefficient ring in
which five is invertible, with two-sided inverse `(1/5)(I₄+J₄)`.  The
determinant of the block is `125`, so this is the exact sense in which the
complement of the unit line is unimodular at every prime other than five. -/
theorem sixAxisComplementBlock_mul_inverse (inverseFive : R)
    (inverse : 5 * inverseFive = 1) :
    sixAxisComplementBlock R * sixAxisComplementBlockInverse inverseFive = 1 ∧
      sixAxisComplementBlockInverse inverseFive * sixAxisComplementBlock R = 1 := by
  have expansion :
      sixAxisComplementBlock R * sixAxisComplementBlockInverse inverseFive =
        (5 * inverseFive) • (1 : Matrix (Fin 4) (Fin 4) R) := by
    simp only [sixAxisComplementBlock, sixAxisComplementBlockInverse,
      Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_add,
      Matrix.mul_one, Matrix.one_mul, allOnesBlock_mul_self]
    module
  have commuting :
      sixAxisComplementBlockInverse inverseFive * sixAxisComplementBlock R =
        (5 * inverseFive) • (1 : Matrix (Fin 4) (Fin 4) R) := by
    simp only [sixAxisComplementBlock, sixAxisComplementBlockInverse,
      Matrix.mul_sub, Matrix.smul_mul, Matrix.mul_smul, Matrix.add_mul,
      Matrix.mul_one, Matrix.one_mul, allOnesBlock_mul_self]
    module
  rw [expansion, commuting, inverse, one_smul]
  exact ⟨rfl, rfl⟩

/-- Scaling a Gram matrix and its inverse by mutually inverse scalars preserves
the two-sided inverse relation. -/
theorem smul_mul_smul_inverse {Index : Type*} [Fintype Index] [DecidableEq Index]
    {gram inverseGram : Matrix Index Index R} (scale inverseScale : R)
    (scaleInverse : scale * inverseScale = 1)
    (rightInverse : gram * inverseGram = 1) (leftInverse : inverseGram * gram = 1) :
    (scale • gram) * (inverseScale • inverseGram) = 1 ∧
      (inverseScale • inverseGram) * (scale • gram) = 1 := by
  constructor
  · rw [Matrix.smul_mul, Matrix.mul_smul, rightInverse, smul_smul, scaleInverse,
      one_smul]
  · rw [Matrix.smul_mul, Matrix.mul_smul, leftInverse, smul_smul, mul_comm,
      scaleInverse, one_smul]

/-- The chart Gram matrix as a depth decomposition.  The first coordinate line
has value five and is orthogonal to the other four coordinates, and the
complementary block is the uniformizer times the unit multiple `unitPart` of the
unimodular block `5I₄-J₄`.  The scale hypothesis `6/5 = p * unitPart` holds at
the two primes dividing six: at `p = 2` with `unitPart = 3/5` and at `p = 3`
with `unitPart = 2/5`. -/
theorem sixAxisChartGram_depthDecomposition (inverseFive uniformizer unitPart : R)
    (scale : 6 * inverseFive = uniformizer * unitPart) :
    sixAxisChartGram inverseFive 0 0 = 5 ∧
      (∀ column : Fin 4, sixAxisChartGram inverseFive 0 column.succ = 0) ∧
      (∀ row : Fin 4, sixAxisChartGram inverseFive row.succ 0 = 0) ∧
      ∀ row column : Fin 4,
        sixAxisChartGram inverseFive row.succ column.succ =
          uniformizer * (unitPart * sixAxisComplementBlock R row column) := by
  refine ⟨by simp [sixAxisChartGram], fun column ↦ ?_, fun row ↦ ?_,
    fun row column ↦ ?_⟩
  · simp [sixAxisChartGram, Fin.succ_ne_zero]
  · simp [sixAxisChartGram, Fin.succ_ne_zero]
  · rw [sixAxisComplementBlock_apply]
    simp only [sixAxisChartGram, Fin.succ_ne_zero, if_false, Fin.succ_inj]
    split_ifs <;> rw [← mul_assoc, ← scale]

/-- The unimodular Gram matrix of the depth-one summand of the local chart:
the unit multiple `unitPart • (5I₄-J₄)` obtained after dividing the chart block
by the uniformizer.  It is symmetric and, whenever five and the unit multiple
are invertible, it has a two-sided inverse over the coefficient ring, which is
exactly the hypothesis the depth-one lifting construction needs. -/
theorem sixAxisDepthOneBlock_symmetric_and_invertible
    (inverseFive unitPart inverseUnitPart : R)
    (inverse : 5 * inverseFive = 1) (unitInverse : unitPart * inverseUnitPart = 1) :
    (unitPart • sixAxisComplementBlock R)ᵀ = unitPart • sixAxisComplementBlock R ∧
      (unitPart • sixAxisComplementBlock R) *
          (inverseUnitPart • sixAxisComplementBlockInverse inverseFive) = 1 ∧
        (inverseUnitPart • sixAxisComplementBlockInverse inverseFive) *
            (unitPart • sixAxisComplementBlock R) = 1 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [Matrix.transpose_smul, sixAxisComplementBlock_transpose]
  · exact (smul_mul_smul_inverse unitPart inverseUnitPart unitInverse
      (sixAxisComplementBlock_mul_inverse inverseFive inverse).1
      (sixAxisComplementBlock_mul_inverse inverseFive inverse).2).1
  · exact (smul_mul_smul_inverse unitPart inverseUnitPart unitInverse
      (sixAxisComplementBlock_mul_inverse inverseFive inverse).1
      (sixAxisComplementBlock_mul_inverse inverseFive inverse).2).2

/-- The depth-one lifting construction at the actual six-axis block.  Over a
domain in which the uniformizer and two are nonzero and five and the unit
multiple are invertible, every endomorphism of the reduction of the depth-one
summand modulo the uniformizer which is self-adjoint for the reduced dual form
of that summand is the reduction of an endomorphism self-adjoint for the dual
form itself.  Nothing is divided: the correcting term is the uniformizer times
the Gram matrix times the strictly lower triangular part of the divided
adjointness defect.  The statement is about matrices; the residue endomorphism
is not identified with the slope of a geometric principal kernel. -/
theorem exists_selfAdjoint_lift_sixAxisDepthOneBlock [IsDomain R]
    {uniformizer : R} (uniformizerNonzero : uniformizer ≠ 0)
    (twoNonzero : (2 : R) ≠ 0)
    (inverseFive unitPart inverseUnitPart : R)
    (inverse : 5 * inverseFive = 1) (unitInverse : unitPart * inverseUnitPart = 1)
    (residue : Matrix (Fin 4) (Fin 4)
      (R ⧸ Ideal.span ({uniformizer} : Set R)))
    (residueSelfAdjoint :
      residueᵀ *
          (inverseUnitPart • sixAxisComplementBlockInverse inverseFive).map
            (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set R))) =
        (inverseUnitPart • sixAxisComplementBlockInverse inverseFive).map
            (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set R))) * residue) :
    ∃ lift : Matrix (Fin 4) (Fin 4) R,
      lift.map (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set R))) = residue ∧
        liftᵀ * (inverseUnitPart • sixAxisComplementBlockInverse inverseFive) =
          (inverseUnitPart • sixAxisComplementBlockInverse inverseFive) * lift := by
  obtain ⟨symmetric, rightInverse, leftInverse⟩ :=
    sixAxisDepthOneBlock_symmetric_and_invertible (R := R) inverseFive unitPart
      inverseUnitPart inverse unitInverse
  exact exists_selfAdjoint_lift_of_residue_selfAdjoint uniformizerNonzero twoNonzero
    symmetric rightInverse leftInverse residue residueSelfAdjoint

/-- The five-by-five matrix acting by a scalar on the first coordinate and by a
supplied four-by-four matrix on the remaining four, the shape of every matrix
respecting the chart decomposition into the unit line and the depth-one
summand. -/
def sixAxisBlockDiagonal (corner : R) (block : Matrix (Fin 4) (Fin 4) R) :
    Matrix (Fin 5) (Fin 5) R :=
  Matrix.of fun row column ↦
    Fin.cases (Fin.cases corner (fun _ ↦ 0) column)
      (fun rowIndex ↦ Fin.cases 0 (fun columnIndex ↦ block rowIndex columnIndex) column)
      row

@[simp] theorem sixAxisBlockDiagonal_zero_zero (corner : R)
    (block : Matrix (Fin 4) (Fin 4) R) :
    sixAxisBlockDiagonal corner block 0 0 = corner := rfl

@[simp] theorem sixAxisBlockDiagonal_zero_succ (corner : R)
    (block : Matrix (Fin 4) (Fin 4) R) (column : Fin 4) :
    sixAxisBlockDiagonal corner block 0 column.succ = 0 := rfl

@[simp] theorem sixAxisBlockDiagonal_succ_zero (corner : R)
    (block : Matrix (Fin 4) (Fin 4) R) (row : Fin 4) :
    sixAxisBlockDiagonal corner block row.succ 0 = 0 := rfl

@[simp] theorem sixAxisBlockDiagonal_succ_succ (corner : R)
    (block : Matrix (Fin 4) (Fin 4) R) (row column : Fin 4) :
    sixAxisBlockDiagonal corner block row.succ column.succ = block row column := rfl

/-- Two matrices respecting the chart decomposition multiply cornerwise and
blockwise. -/
theorem sixAxisBlockDiagonal_mul (firstCorner secondCorner : R)
    (firstBlock secondBlock : Matrix (Fin 4) (Fin 4) R) :
    sixAxisBlockDiagonal firstCorner firstBlock *
        sixAxisBlockDiagonal secondCorner secondBlock =
      sixAxisBlockDiagonal (firstCorner * secondCorner) (firstBlock * secondBlock) := by
  ext row column
  induction row using Fin.cases with
  | zero =>
    induction column using Fin.cases with
    | zero => simp [Matrix.mul_apply, Fin.sum_univ_succ]
    | succ column => simp [Matrix.mul_apply, Fin.sum_univ_succ]
  | succ row =>
    induction column using Fin.cases with
    | zero => simp [Matrix.mul_apply, Fin.sum_univ_succ]
    | succ column =>
      simp [Matrix.mul_apply, Fin.sum_univ_succ]

/-- Transposition of a matrix respecting the chart decomposition transposes its
block. -/
theorem sixAxisBlockDiagonal_transpose (corner : R)
    (block : Matrix (Fin 4) (Fin 4) R) :
    (sixAxisBlockDiagonal corner block)ᵀ = sixAxisBlockDiagonal corner blockᵀ := by
  ext row column
  induction row using Fin.cases with
  | zero => induction column using Fin.cases with
    | zero => simp
    | succ column => simp
  | succ row => induction column using Fin.cases with
    | zero => simp
    | succ column => simp

/-- The identity matrix respects the chart decomposition. -/
theorem sixAxisBlockDiagonal_one :
    sixAxisBlockDiagonal (1 : R) (1 : Matrix (Fin 4) (Fin 4) R) = 1 := by
  ext row column
  induction row using Fin.cases with
  | zero => induction column using Fin.cases with
    | zero => simp
    | succ column => simp [eq_comm, Fin.succ_ne_zero]
  | succ row => induction column using Fin.cases with
    | zero => simp [Fin.succ_ne_zero]
    | succ column => simp [Matrix.one_apply, Fin.succ_inj]

/-- The chart Gram matrix in the shape of the chart decomposition: the unit line
of value five together with the multiple `6/5` of the unimodular block
`5I₄-J₄`. -/
theorem sixAxisChartGram_eq_blockDiagonal (inverseFive : R) :
    sixAxisChartGram inverseFive =
      sixAxisBlockDiagonal 5 ((6 * inverseFive) • sixAxisComplementBlock R) := by
  ext row column
  induction row using Fin.cases with
  | zero => induction column using Fin.cases with
    | zero => simp [sixAxisChartGram]
    | succ column => simp [sixAxisChartGram, Fin.succ_ne_zero]
  | succ row => induction column using Fin.cases with
    | zero => simp [sixAxisChartGram, Fin.succ_ne_zero]
    | succ column =>
      rw [sixAxisBlockDiagonal_succ_succ]
      simp only [sixAxisChartGram, Fin.succ_ne_zero, if_false, Fin.succ_inj,
        Matrix.smul_apply, smul_eq_mul, sixAxisComplementBlock_apply]

/-- A change of basis respecting the chart decomposition transports the chart
Gram matrix blockwise: the unit line keeps its value five and the depth-one
block is transported by congruence. -/
theorem sixAxisChartGram_congruence_blockDiagonal (inverseFive : R)
    (block : Matrix (Fin 4) (Fin 4) R) :
    (sixAxisBlockDiagonal 1 block)ᵀ * sixAxisChartGram inverseFive *
        sixAxisBlockDiagonal 1 block =
      sixAxisBlockDiagonal 5
        ((6 * inverseFive) • (blockᵀ * sixAxisComplementBlock R * block)) := by
  rw [sixAxisChartGram_eq_blockDiagonal, sixAxisBlockDiagonal_transpose,
    sixAxisBlockDiagonal_mul, sixAxisBlockDiagonal_mul, Matrix.mul_smul,
    Matrix.smul_mul]
  norm_num

/-- Orthogonality of eigenvectors of a self-adjoint slope.  If the slope is
self-adjoint for a coefficient form, in the sense that the transpose of the
slope composed with the form is the form composed with the slope, and two
vectors are eigenvectors of the slope whose eigenvalues differ by a cancellable
scalar, then the two vectors are orthogonal for that form.  This is the step
that makes the eigenblocks of a split depth-one slope orthogonal summands of
the coefficient lattice. -/
theorem pairing_eq_zero_of_selfAdjoint_eigenvectors {Index : Type*} [Fintype Index]
    (form slope : Matrix Index Index R)
    (selfAdjoint : slopeᵀ * form = form * slope)
    (first second : Index → R) (firstValue secondValue : R)
    (firstEigen : slope *ᵥ first = firstValue • first)
    (secondEigen : slope *ᵥ second = secondValue • second)
    (cancellable : ∀ scalar : R, (firstValue - secondValue) * scalar = 0 → scalar = 0) :
    first ⬝ᵥ (form *ᵥ second) = 0 := by
  have adjointStep :
      (slope *ᵥ first) ⬝ᵥ (form *ᵥ second) =
        first ⬝ᵥ (form *ᵥ (slope *ᵥ second)) :=
    calc (slope *ᵥ first) ⬝ᵥ (form *ᵥ second)
        = (first ᵥ* slopeᵀ) ⬝ᵥ (form *ᵥ second) := by
          rw [Matrix.vecMul_transpose]
      _ = first ⬝ᵥ (slopeᵀ *ᵥ (form *ᵥ second)) :=
          (Matrix.dotProduct_mulVec first slopeᵀ (form *ᵥ second)).symm
      _ = first ⬝ᵥ ((slopeᵀ * form) *ᵥ second) := by
          rw [Matrix.mulVec_mulVec]
      _ = first ⬝ᵥ ((form * slope) *ᵥ second) := by rw [selfAdjoint]
      _ = first ⬝ᵥ (form *ᵥ (slope *ᵥ second)) := by rw [Matrix.mulVec_mulVec]
  rw [firstEigen, secondEigen, smul_dotProduct, Matrix.mulVec_smul,
    dotProduct_smul, smul_eq_mul, smul_eq_mul] at adjointStep
  apply cancellable
  rw [sub_mul, adjointStep]
  ring

section SplitCoordinates

variable {S : Type*} [CommRing S]

/-- Coordinate blocks of the split presentation carried by the local chart:
`none` names the unimodular line spanned by the first chart vector, and
`some index` names the corresponding block of a supplied decomposition of the
depth-one summand into eigenblocks of its slope. -/
def sixAxisSplitBlock {DepthIndex : Type} (DepthBlock : DepthIndex → Type) :
    Option DepthIndex → Type
  | none => Fin 1
  | some index => DepthBlock index

instance sixAxisSplitBlockFintype {DepthIndex : Type} {DepthBlock : DepthIndex → Type}
    [∀ index, Fintype (DepthBlock index)] :
    ∀ index, Fintype (sixAxisSplitBlock DepthBlock index)
  | none => inferInstanceAs (Fintype (Fin 1))
  | some index => inferInstanceAs (Fintype (DepthBlock index))

instance sixAxisSplitBlockDecidableEq {DepthIndex : Type} {DepthBlock : DepthIndex → Type}
    [∀ index, DecidableEq (DepthBlock index)] :
    ∀ index, DecidableEq (sixAxisSplitBlock DepthBlock index)
  | none => inferInstanceAs (DecidableEq (Fin 1))
  | some index => inferInstanceAs (DecidableEq (DepthBlock index))

/-- The chart coordinates read on the split blocks: the unimodular line is the
first chart coordinate, and a supplied identification of the depth-one blocks
with the remaining four coordinates places every other block. -/
def sixAxisSplitAxisEquiv {DepthIndex : Type} {DepthBlock : DepthIndex → Type}
    (depthEquiv : (Σ index, DepthBlock index) ≃ Fin 4) :
    SplitGraphAxis (sixAxisSplitBlock DepthBlock) ≃ Fin 5 where
  toFun axis :=
    match axis with
    | ⟨none, _⟩ => 0
    | ⟨some index, coordinate⟩ => (depthEquiv ⟨index, coordinate⟩).succ
  invFun coordinate :=
    Fin.cases (⟨none, (0 : Fin 1)⟩ : SplitGraphAxis (sixAxisSplitBlock DepthBlock))
      (fun position ↦
        ⟨some (depthEquiv.symm position).1, (depthEquiv.symm position).2⟩)
      coordinate
  left_inv := by
    rintro ⟨index, coordinate⟩
    match index with
    | none =>
      have coordinateZero : coordinate = (0 : Fin 1) := Fin.fin_one_eq_zero coordinate
      simp [coordinateZero]
    | some index =>
      simp only [Fin.cases_succ]
      rw [depthEquiv.symm_apply_apply]
  right_inv := by
    intro coordinate
    induction coordinate using Fin.cases with
    | zero => simp
    | succ position => simp

/-- The composite change of basis: the chart change of basis followed by a
supplied change of basis of the depth-one summand, which in the split
presentation is the eigenbasis of the depth-one slope. -/
def sixAxisSplitBasisMatrix (inverseFive : S) (block : Matrix (Fin 4) (Fin 4) S) :
    Matrix (Fin 5) (Fin 5) S :=
  sixAxisChartBasis inverseFive * sixAxisBlockDiagonal 1 block

/-- The inverse of the composite change of basis. -/
def sixAxisSplitBasisMatrixInverse (inverseFive : S)
    (blockInverse : Matrix (Fin 4) (Fin 4) S) : Matrix (Fin 5) (Fin 5) S :=
  sixAxisBlockDiagonal 1 blockInverse * sixAxisChartBasisInverse inverseFive

/-- The composite change of basis is invertible as soon as the supplied change
of basis of the depth-one summand is. -/
theorem sixAxisSplitBasisMatrix_mul_inverse (inverseFive : S)
    (block blockInverse : Matrix (Fin 4) (Fin 4) S)
    (blockRightInverse : block * blockInverse = 1)
    (blockLeftInverse : blockInverse * block = 1) :
    sixAxisSplitBasisMatrix inverseFive block *
        sixAxisSplitBasisMatrixInverse inverseFive blockInverse = 1 ∧
      sixAxisSplitBasisMatrixInverse inverseFive blockInverse *
          sixAxisSplitBasisMatrix inverseFive block = 1 := by
  constructor
  · rw [sixAxisSplitBasisMatrix, sixAxisSplitBasisMatrixInverse, Matrix.mul_assoc,
      ← Matrix.mul_assoc (sixAxisBlockDiagonal 1 block), sixAxisBlockDiagonal_mul,
      blockRightInverse, one_mul, sixAxisBlockDiagonal_one, Matrix.one_mul]
    exact (sixAxisChartBasis_mul_inverse inverseFive).1
  · rw [sixAxisSplitBasisMatrix, sixAxisSplitBasisMatrixInverse, Matrix.mul_assoc,
      ← Matrix.mul_assoc (sixAxisChartBasisInverse inverseFive),
      (sixAxisChartBasis_mul_inverse inverseFive).2, Matrix.one_mul,
      sixAxisBlockDiagonal_mul, blockLeftInverse, one_mul, sixAxisBlockDiagonal_one]

/-- The coordinate equivalence between the five chart coordinates and the split
coordinates of the presentation, given by the chart change of basis followed by
the supplied change of basis of the depth-one summand. -/
def sixAxisSplitBasis {DepthIndex : Type} {DepthBlock : DepthIndex → Type}
    [∀ index, Fintype (DepthBlock index)] [∀ index, DecidableEq (DepthBlock index)]
    [Fintype (SplitGraphAxis (sixAxisSplitBlock DepthBlock))]
    [DecidableEq (SplitGraphAxis (sixAxisSplitBlock DepthBlock))]
    (depthEquiv : (Σ index, DepthBlock index) ≃ Fin 4)
    (inverseFive : S) (block blockInverse : Matrix (Fin 4) (Fin 4) S)
    (blockRightInverse : block * blockInverse = 1)
    (blockLeftInverse : blockInverse * block = 1) :
    SplitCoordinateBasisEquivalence S (Fin 5)
      (SplitGraphAxis (sixAxisSplitBlock DepthBlock)) where
  toSplit := (sixAxisSplitBasisMatrix inverseFive block).submatrix id
    (sixAxisSplitAxisEquiv depthEquiv)
  toBase := (sixAxisSplitBasisMatrixInverse inverseFive blockInverse).submatrix
    (sixAxisSplitAxisEquiv depthEquiv) id
  toSplit_mul_toBase := by
    rw [Matrix.submatrix_mul_equiv, (sixAxisSplitBasisMatrix_mul_inverse inverseFive
      block blockInverse blockRightInverse blockLeftInverse).1, Matrix.submatrix_id_id]
  toBase_mul_toSplit := by
    rw [show (id : Fin 5 → Fin 5) = ⇑(Equiv.refl (Fin 5)) from rfl,
      Matrix.submatrix_mul_equiv, (sixAxisSplitBasisMatrix_mul_inverse inverseFive
        block blockInverse blockRightInverse blockLeftInverse).2,
      Matrix.submatrix_one_equiv]

/-- The depth prescription of the chart: the unimodular line has depth zero and
every block of the depth-one summand has depth one. -/
def sixAxisSplitDepth {DepthIndex : Type} : Option DepthIndex → ℕ
  | none => 0
  | some _ => 1

/-- The slope scalars of the split presentation: the unimodular line carries no
condition and is given the scalar zero, and every block of the depth-one
summand carries its own supplied scalar. -/
def sixAxisSplitScalar {DepthIndex : Type} (scalar : DepthIndex → S) :
    Option DepthIndex → S
  | none => 0
  | some index => scalar index

/-- The slope errors of the split presentation: the unimodular line carries the
zero error, and every block of the depth-one summand carries its own supplied
integral error term. -/
def sixAxisSplitSlopeError {DepthIndex : Type} {DepthBlock : DepthIndex → Type}
    (slopeError : ∀ index, Matrix (DepthBlock index) (DepthBlock index) S) :
    ∀ index, Matrix (sixAxisSplitBlock DepthBlock index)
      (sixAxisSplitBlock DepthBlock index) S
  | none => 0
  | some index => slopeError index

/-- Every entry of a congruence is the pairing of the corresponding two columns
of the change of basis. -/
theorem congruenceEntry_eq_dotProduct {Index : Type*} [Fintype Index]
    (basis form : Matrix Index Index S) (row column : Index) :
    (basisᵀ * form * basis) row column =
      (fun index ↦ basis index row) ⬝ᵥ (form *ᵥ fun index ↦ basis index column) := by
  simp only [Matrix.mul_apply, Matrix.transpose_apply, dotProduct, Matrix.mulVec,
    Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun first _ ↦ Finset.sum_congr rfl fun second _ ↦ ?_
  ring

/-- The six-axis coefficient lattice in the split coordinates of the chart: the
first coordinate is the unimodular line of value five, it is orthogonal to the
other four coordinates, and the depth-one block is transported by congruence
under the supplied change of basis of the depth-one summand. -/
theorem sixAxisSplitBasisMatrix_congruence (inverseFive : S)
    (inverse : 5 * inverseFive = 1) (block : Matrix (Fin 4) (Fin 4) S) :
    (sixAxisSplitBasisMatrix inverseFive block)ᵀ * sixAxisGram S *
        sixAxisSplitBasisMatrix inverseFive block =
      sixAxisBlockDiagonal 5
        ((6 * inverseFive) • (blockᵀ * sixAxisComplementBlock S * block)) := by
  calc (sixAxisSplitBasisMatrix inverseFive block)ᵀ * sixAxisGram S *
        sixAxisSplitBasisMatrix inverseFive block
      = (sixAxisBlockDiagonal 1 block)ᵀ *
          ((sixAxisChartBasis inverseFive)ᵀ * sixAxisGram S *
            sixAxisChartBasis inverseFive) * sixAxisBlockDiagonal 1 block := by
        simp only [sixAxisSplitBasisMatrix, Matrix.transpose_mul, Matrix.mul_assoc]
    _ = (sixAxisBlockDiagonal 1 block)ᵀ * sixAxisChartGram inverseFive *
          sixAxisBlockDiagonal 1 block := by
        rw [sixAxisChartBasis_congruence inverseFive inverse]
    _ = _ := sixAxisChartGram_congruence_blockDiagonal inverseFive block

/-- Two depth-one split coordinates are orthogonal for the six-axis coefficient
form when they are eigenvectors of a slope self-adjoint for the unimodular block
whose eigenvalues differ by a cancellable scalar.  This is the step that makes
the eigenblocks of the depth-one slope orthogonal summands, so that the split
coordinates really carry an orthogonal decomposition of the coefficient
lattice. -/
theorem sixAxisSplitBasisMatrix_congruence_eq_zero (inverseFive : S)
    (inverse : 5 * inverseFive = 1) (slope block : Matrix (Fin 4) (Fin 4) S)
    (selfAdjoint :
      slopeᵀ * sixAxisComplementBlock S = sixAxisComplementBlock S * slope)
    (first second : Fin 4) (firstValue secondValue : S)
    (firstEigen : slope *ᵥ (fun index ↦ block index first) =
      firstValue • fun index ↦ block index first)
    (secondEigen : slope *ᵥ (fun index ↦ block index second) =
      secondValue • fun index ↦ block index second)
    (cancellable : ∀ scalar : S, (firstValue - secondValue) * scalar = 0 → scalar = 0) :
    ((sixAxisSplitBasisMatrix inverseFive block)ᵀ * sixAxisGram S *
        sixAxisSplitBasisMatrix inverseFive block) first.succ second.succ = 0 := by
  rw [sixAxisSplitBasisMatrix_congruence inverseFive inverse block,
    sixAxisBlockDiagonal_succ_succ]
  have vanishing : (blockᵀ * sixAxisComplementBlock S * block) first second = 0 := by
    rw [congruenceEntry_eq_dotProduct]
    exact pairing_eq_zero_of_selfAdjoint_eigenvectors (sixAxisComplementBlock S) slope
      selfAdjoint _ _ firstValue secondValue firstEigen secondEigen cancellable
  simp [vanishing]

/-- Divided-power saturation of the six-axis graph divisor lattice in the local
chart.  The coefficient lattice is the five-dimensional lattice with Gram matrix
`6I₅-J₅`, the coordinates are those of the chart followed by a supplied change
of basis of the depth-one summand, the depth is zero on the unimodular line and
one on every block of the depth-one summand, and the slope scalars and error
terms are those of the split slope.  Under the three graph-coordinate descent
conditions for those data, every divided power of a class in the lattice is an
ordinary integral divisor product.

What remains supplied is geometric: the cohomological realization of coefficient
matrices, the injective pullback to the elliptic-power source, the divisor
submodule, and the compatibility of the class and its divided power with that
realization.  No elliptic scheme, isogeny, principal kernel, or slope of an
actual geometric kernel is constructed. -/
theorem sixAxisChart_allDegree_dividedPowerMember
    {R Target DepthIndex : Type} {DepthBlock : DepthIndex → Type}
    [CommRing R] [Algebra R S] [Module.FaithfullyFlat R S]
    [IsDomain S] [IsDiscreteValuationRing S] [CommRing Target] [Algebra R Target]
    [∀ index, Fintype (DepthBlock index)] [∀ index, DecidableEq (DepthBlock index)]
    [Fintype (SplitGraphAxis (sixAxisSplitBlock DepthBlock))]
    [DecidableEq (SplitGraphAxis (sixAxisSplitBlock DepthBlock))]
    [LinearOrder (SplitGraphAxis (sixAxisSplitBlock DepthBlock))]
    (depthEquiv : (Σ index, DepthBlock index) ≃ Fin 4)
    (inverseFive : S) (block blockInverse : Matrix (Fin 4) (Fin 4) S)
    (blockRightInverse : block * blockInverse = 1)
    (blockLeftInverse : blockInverse * block = 1)
    (uniformizer : R)
    (extendedUniformizerIrreducible : Irreducible (algebraMap R S uniformizer))
    (scalar : DepthIndex → S)
    (slopeError : ∀ index, Matrix (DepthBlock index) (DepthBlock index) S)
    (extendedRealization : Matrix (SplitGraphAxis (sixAxisSplitBlock DepthBlock))
        (SplitGraphAxis (sixAxisSplitBlock DepthBlock)) S →+ TensorProduct R S Target)
    (pullback : TensorProduct R S Target →+*
      ExteriorAlgebra S
        (EllipticSourceHOne S (SplitGraphAxis (sixAxisSplitBlock DepthBlock))))
    (pullbackInjective : Function.Injective pullback)
    (sourceCompatible : ∀ candidate,
      pullback (extendedRealization candidate) =
        ellipticSourceCoefficientRealization candidate)
    (divisors : Submodule R Target)
    (extendedRealizationMember : ∀ candidate,
      candidate ∈ weightedMatrixSubmodule (algebraMap R S uniformizer)
          (fun axis ↦ sixAxisSplitDepth axis.1)
          (splitGraphCrossDepth (sixAxisSplitBlock DepthBlock)
            (IsDiscreteValuationRing.addVal S) sixAxisSplitDepth
            (sixAxisSplitScalar scalar)) →
        extendedRealization candidate ∈
          scalarExtendedSubmodule S
            (Algebra.TensorProduct.includeRight (R := R) (A := S) (B := Target))
            divisors)
    (form : Matrix (Fin 5) (Fin 5) R) (formSymmetric : form.IsSymm)
    (graphDescent : GraphBlockDescentCondition (sixAxisSplitBlock DepthBlock)
      (algebraMap R S uniformizer) sixAxisSplitDepth (sixAxisSplitScalar scalar)
      (sixAxisSplitSlopeError slopeError)
      (blockCoefficientOfMatrix (sixAxisSplitBlock DepthBlock)
        (splitCoordinateCoefficientExtension
          (sixAxisSplitBasis depthEquiv inverseFive block blockInverse
            blockRightInverse blockLeftInverse).toSplit form)))
    (baseClass dividedPower : Target)
    (baseClassCompatible :
      extendedRealization
          (splitCoordinateCoefficientExtension
            (sixAxisSplitBasis depthEquiv inverseFive block blockInverse
              blockRightInverse blockLeftInverse).toSplit form) =
        Algebra.TensorProduct.includeRight baseClass)
    (degree : ℕ)
    (dividedPowerCompatible :
      ∀ forms : List (Matrix (SplitGraphAxis (sixAxisSplitBlock DepthBlock))
          (SplitGraphAxis (sixAxisSplitBlock DepthBlock)) S),
      (∀ candidate ∈ forms,
        candidate ∈ weightedRankOneSet (algebraMap R S uniformizer)
          (fun axis ↦ sixAxisSplitDepth axis.1)
          (splitGraphCrossDepth (sixAxisSplitBlock DepthBlock)
            (IsDiscreteValuationRing.addVal S) sixAxisSplitDepth
            (sixAxisSplitScalar scalar))) →
      forms.sum = splitCoordinateCoefficientExtension
          (sixAxisSplitBasis depthEquiv inverseFive block blockInverse
            blockRightInverse blockLeftInverse).toSplit form →
      Algebra.TensorProduct.includeRight dividedPower =
        squarefreeProductSum (forms.map extendedRealization) degree) :
    dividedPower ∈ ordinaryProductSubmodule divisors degree ∧
      baseClass ^ degree = (degree.factorial : Target) * dividedPower :=
  allDegree_dividedPowerMember_of_markedGraphDescent_afterBasisChange
    (sixAxisSplitBlock DepthBlock)
    (sixAxisSplitBasis depthEquiv inverseFive block blockInverse blockRightInverse
      blockLeftInverse)
    uniformizer extendedUniformizerIrreducible sixAxisSplitDepth
    (sixAxisSplitScalar scalar) (sixAxisSplitSlopeError slopeError)
    extendedRealization pullback pullbackInjective sourceCompatible divisors
    extendedRealizationMember form formSymmetric graphDescent baseClass dividedPower
    baseClassCompatible degree dividedPowerCompatible

/-- A slope whose reduction modulo the uniformizer is scalar splits integrally as
that scalar plus the uniformizer times an integral error term, which is the split
form the graph-coordinate descent conditions consume.  Nothing is divided: the
error term is assembled from the divisibility witnesses of the entries. -/
theorem exists_slopeError_of_residue_scalar {Index : Type*} [Fintype Index]
    [DecidableEq Index] (uniformizer scalar : S) (slope : Matrix Index Index S)
    (residue : slope.map (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set S))) =
      (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set S)) scalar) •
        (1 : Matrix Index Index (S ⧸ Ideal.span ({uniformizer} : Set S)))) :
    ∃ error : Matrix Index Index S,
      slope = scalar • (1 : Matrix Index Index S) + uniformizer • error := by
  have divisible : ∀ row column : Index, ∃ coefficient : S,
      slope row column - (scalar • (1 : Matrix Index Index S)) row column =
        uniformizer * coefficient := by
    intro row column
    have entry := congrFun (congrFun residue row) column
    have vanishing :
        Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set S))
          (slope row column - (scalar • (1 : Matrix Index Index S)) row column) = 0 := by
      rw [map_sub, sub_eq_zero]
      simpa [Matrix.map_apply, Matrix.smul_apply, Matrix.one_apply, smul_eq_mul,
        apply_ite (Ideal.Quotient.mk (Ideal.span ({uniformizer} : Set S)))] using entry
    exact Ideal.mem_span_singleton.mp (Ideal.Quotient.eq_zero_iff_mem.mp vanishing)
  choose coefficient property using divisible
  refine ⟨Matrix.of coefficient, ?_⟩
  ext row column
  have entry := property row column
  simp only [Matrix.add_apply, Matrix.smul_apply, Matrix.of_apply, smul_eq_mul]
  simp only [Matrix.smul_apply, smul_eq_mul] at entry
  linear_combination entry

/-- For a slope in split form, the split-slope commutator of the graph-coordinate
descent conditions is the commutator `A Tᵗ - T A` of the manuscript's descent
matrix.  The depth-one blocks therefore impose exactly the manuscript's condition
on the actual slope, not on its scalar and error parts separately. -/
theorem rectangularSplitSlopeCommutator_eq_slopeCommutator {Index : Type*}
    [Fintype Index] [DecidableEq Index] (uniformizer scalar : S)
    (slope error coefficient : Matrix Index Index S)
    (splitForm : slope = scalar • (1 : Matrix Index Index S) + uniformizer • error) :
    rectangularSplitSlopeCommutator uniformizer 1 1 coefficient scalar scalar error
        error =
      coefficient * slopeᵀ - slope * coefficient := by
  subst splitForm
  rw [rectangularSplitSlopeCommutator_expansion, sub_self, zero_smul, zero_add,
    pow_one]
  simp only [Matrix.transpose_add, Matrix.transpose_smul, Matrix.transpose_one,
    Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul,
    Matrix.mul_one, Matrix.one_mul]
  abel

/-- Multiplication by the all-ones block replaces every coordinate by the
coordinate sum. -/
theorem allOnesBlock_mulVec (vector : Fin 4 → S) :
    allOnesBlock S *ᵥ vector = fun _ ↦ ∑ index, vector index := by
  funext row
  simp [allOnesBlock, Matrix.mulVec, dotProduct]

/-- Multiplication by the depth-one block `5I₄-J₄` sends a vector to five times
itself minus its coordinate sum. -/
theorem sixAxisComplementBlock_mulVec (vector : Fin 4 → S) :
    sixAxisComplementBlock S *ᵥ vector =
      fun row ↦ 5 * vector row - ∑ index, vector index := by
  rw [sixAxisComplementBlock, Matrix.sub_mulVec, Matrix.smul_mulVec,
    Matrix.one_mulVec, allOnesBlock_mulVec]
  funext row
  simp [smul_eq_mul]

/-- Multiplication by the dual form `(1/5)(I₄+J₄)` sends a vector to the supplied
inverse of five times the vector plus its coordinate sum. -/
theorem sixAxisComplementBlockInverse_mulVec (inverseFive : S) (vector : Fin 4 → S) :
    sixAxisComplementBlockInverse inverseFive *ᵥ vector =
      fun row ↦ inverseFive * (vector row + ∑ index, vector index) := by
  rw [sixAxisComplementBlockInverse, Matrix.smul_mulVec, Matrix.add_mulVec,
    Matrix.one_mulVec, allOnesBlock_mulVec]
  funext row
  simp [smul_eq_mul]

/-- The pairing of the depth-one block `5I₄-J₄` is the sum of the squares of the
coordinates and of their pairwise differences. -/
theorem sixAxisComplementBlock_dotProduct (vector : Fin 4 → S) :
    vector ⬝ᵥ (sixAxisComplementBlock S *ᵥ vector) =
      vector 0 ^ 2 + vector 1 ^ 2 + vector 2 ^ 2 + vector 3 ^ 2 +
        ((vector 0 - vector 1) ^ 2 + (vector 0 - vector 2) ^ 2 +
          (vector 0 - vector 3) ^ 2 + (vector 1 - vector 2) ^ 2 +
          (vector 1 - vector 3) ^ 2 + (vector 2 - vector 3) ^ 2) := by
  rw [sixAxisComplementBlock_mulVec]
  simp only [dotProduct, Fin.sum_univ_four]
  ring

/-- The pairing of the dual form `(1/5)(I₄+J₄)` is the supplied inverse of five
times the sum of the squares of the coordinates and the square of their sum. -/
theorem sixAxisComplementBlockInverse_dotProduct (inverseFive : S)
    (vector : Fin 4 → S) :
    vector ⬝ᵥ (sixAxisComplementBlockInverse inverseFive *ᵥ vector) =
      inverseFive *
        (vector 0 ^ 2 + vector 1 ^ 2 + vector 2 ^ 2 + vector 3 ^ 2 +
          (vector 0 + vector 1 + vector 2 + vector 3) ^ 2) := by
  rw [sixAxisComplementBlockInverse_mulVec]
  simp only [dotProduct, Fin.sum_univ_four]
  ring

end SplitCoordinates

section OrderedCoefficients

variable {R : Type*} [CommRing R] [LinearOrder R] [IsStrictOrderedRing R]

/-- No slope satisfying the relation of a primitive cube root of unity is
self-adjoint for a coefficient form that is positive semidefinite and positive on
one vector.  Writing `base`, `mixed`, and `top` for the pairings of that vector
with itself, with its image, and of the image with itself, self-adjointness and
the relation give `top = -mixed - base`, while semidefiniteness applied to
`base • image - mixed • vector` gives `mixed² ≤ base * top`; together these force
`base² + base * mixed + mixed² ≤ 0`, impossible for `base > 0`.  A slope of this
type over the depth-one summand therefore exists only over a coefficient ring
carrying no compatible order. -/
theorem not_selfAdjoint_of_cubeRootRelation {Index : Type*} [Fintype Index]
    [DecidableEq Index] (form slope : Matrix Index Index R)
    (selfAdjoint : slopeᵀ * form = form * slope)
    (semidefinite : ∀ vector : Index → R, 0 ≤ vector ⬝ᵥ (form *ᵥ vector))
    (vector : Index → R) (positive : 0 < vector ⬝ᵥ (form *ᵥ vector))
    (cubeRootRelation : slope * slope + slope + 1 = 0) : False := by
  have adjointStep : ∀ first second : Index → R,
      (slope *ᵥ first) ⬝ᵥ (form *ᵥ second) =
        first ⬝ᵥ (form *ᵥ (slope *ᵥ second)) := by
    intro first second
    calc (slope *ᵥ first) ⬝ᵥ (form *ᵥ second)
        = (first ᵥ* slopeᵀ) ⬝ᵥ (form *ᵥ second) := by rw [Matrix.vecMul_transpose]
      _ = first ⬝ᵥ (slopeᵀ *ᵥ (form *ᵥ second)) :=
          (Matrix.dotProduct_mulVec first slopeᵀ (form *ᵥ second)).symm
      _ = first ⬝ᵥ ((slopeᵀ * form) *ᵥ second) := by rw [Matrix.mulVec_mulVec]
      _ = first ⬝ᵥ ((form * slope) *ᵥ second) := by rw [selfAdjoint]
      _ = first ⬝ᵥ (form *ᵥ (slope *ᵥ second)) := by rw [Matrix.mulVec_mulVec]
  have relation : slope * slope = -slope - 1 := by
    have step : slope * slope + (slope + 1) = 0 := by
      rw [← add_assoc]; exact cubeRootRelation
    have negation := eq_neg_of_add_eq_zero_left step
    rw [negation]
    abel
  have squareImage : slope *ᵥ (slope *ᵥ vector) = -(slope *ᵥ vector) - vector := by
    rw [Matrix.mulVec_mulVec, relation, Matrix.sub_mulVec, Matrix.neg_mulVec,
      Matrix.one_mulVec]
  have topValue : (slope *ᵥ vector) ⬝ᵥ (form *ᵥ (slope *ᵥ vector)) =
      -(vector ⬝ᵥ (form *ᵥ (slope *ᵥ vector))) - vector ⬝ᵥ (form *ᵥ vector) := by
    rw [adjointStep vector (slope *ᵥ vector), squareImage, Matrix.mulVec_sub,
      Matrix.mulVec_neg, dotProduct_sub, dotProduct_neg]
  have crossValue : (slope *ᵥ vector) ⬝ᵥ (form *ᵥ vector) =
      vector ⬝ᵥ (form *ᵥ (slope *ᵥ vector)) := adjointStep vector vector
  have expansion :
      ((vector ⬝ᵥ (form *ᵥ vector)) • (slope *ᵥ vector) -
            (vector ⬝ᵥ (form *ᵥ (slope *ᵥ vector))) • vector) ⬝ᵥ
          (form *ᵥ ((vector ⬝ᵥ (form *ᵥ vector)) • (slope *ᵥ vector) -
            (vector ⬝ᵥ (form *ᵥ (slope *ᵥ vector))) • vector)) =
        (vector ⬝ᵥ (form *ᵥ vector)) *
          ((vector ⬝ᵥ (form *ᵥ vector)) *
              ((slope *ᵥ vector) ⬝ᵥ (form *ᵥ (slope *ᵥ vector))) -
            (vector ⬝ᵥ (form *ᵥ (slope *ᵥ vector))) *
              (vector ⬝ᵥ (form *ᵥ (slope *ᵥ vector)))) := by
    simp only [Matrix.mulVec_sub, Matrix.mulVec_smul, sub_dotProduct, dotProduct_sub,
      smul_dotProduct, dotProduct_smul, smul_eq_mul]
    rw [crossValue]
    ring
  have nonneg := semidefinite
    ((vector ⬝ᵥ (form *ᵥ vector)) • (slope *ᵥ vector) -
      (vector ⬝ᵥ (form *ᵥ (slope *ᵥ vector))) • vector)
  rw [expansion, topValue] at nonneg
  set base := vector ⬝ᵥ (form *ᵥ vector) with baseDefinition
  set mixed := vector ⬝ᵥ (form *ᵥ (slope *ᵥ vector)) with mixedDefinition
  have baseSquare : 0 < base ^ 2 := pow_pos positive 2
  have squarePositive : 0 < (2 * mixed + base) ^ 2 + 3 * base ^ 2 := by
    nlinarith [sq_nonneg (2 * mixed + base), baseSquare]
  nlinarith [nonneg, mul_pos positive squarePositive]

/-- The depth-one block `5I₄-J₄` is positive semidefinite over an ordered
coefficient ring. -/
theorem sixAxisComplementBlock_semidefinite (vector : Fin 4 → R) :
    0 ≤ vector ⬝ᵥ (sixAxisComplementBlock R *ᵥ vector) := by
  rw [sixAxisComplementBlock_dotProduct]
  positivity

/-- The depth-one block is positive on the first coordinate vector, where its
value is four. -/
theorem sixAxisComplementBlock_positive_on_firstCoordinate :
    0 < (Pi.single 0 1 : Fin 4 → R) ⬝ᵥ
      (sixAxisComplementBlock R *ᵥ (Pi.single 0 1 : Fin 4 → R)) := by
  rw [sixAxisComplementBlock_dotProduct]
  norm_num [Pi.single_apply, Fin.ext_iff]

/-- The dual form `(1/5)(I₄+J₄)` is positive semidefinite whenever the supplied
inverse of five is nonnegative. -/
theorem sixAxisComplementBlockInverse_semidefinite {inverseFive : R}
    (nonnegative : 0 ≤ inverseFive) (vector : Fin 4 → R) :
    0 ≤ vector ⬝ᵥ (sixAxisComplementBlockInverse inverseFive *ᵥ vector) := by
  rw [sixAxisComplementBlockInverse_dotProduct]
  have squares : 0 ≤ vector 0 ^ 2 + vector 1 ^ 2 + vector 2 ^ 2 + vector 3 ^ 2 +
      (vector 0 + vector 1 + vector 2 + vector 3) ^ 2 := by positivity
  exact mul_nonneg nonnegative squares

/-- The dual form is positive on the first coordinate vector whenever the
supplied inverse of five is positive. -/
theorem sixAxisComplementBlockInverse_positive_on_firstCoordinate {inverseFive : R}
    (positive : 0 < inverseFive) :
    0 < (Pi.single 0 1 : Fin 4 → R) ⬝ᵥ
      (sixAxisComplementBlockInverse inverseFive *ᵥ (Pi.single 0 1 : Fin 4 → R)) := by
  rw [sixAxisComplementBlockInverse_dotProduct]
  have value : ((Pi.single 0 1 : Fin 4 → R) 0 ^ 2 + (Pi.single 0 1 : Fin 4 → R) 1 ^ 2 +
      (Pi.single 0 1 : Fin 4 → R) 2 ^ 2 + (Pi.single 0 1 : Fin 4 → R) 3 ^ 2 +
      ((Pi.single 0 1 : Fin 4 → R) 0 + (Pi.single 0 1 : Fin 4 → R) 1 +
        (Pi.single 0 1 : Fin 4 → R) 2 + (Pi.single 0 1 : Fin 4 → R) 3) ^ 2) = 2 := by
    norm_num [Pi.single_apply, Fin.ext_iff]
  rw [value]
  linarith

/-- Over an ordered coefficient ring no endomorphism of the depth-one summand of
the local chart satisfies the relation of a primitive cube root of unity while
being self-adjoint for that summand, and none does for the dual form either when
five is positive.  The exotic two-primary slope of the chart therefore has no
model over an ordered coefficient ring; it exists only after passing to a ring
carrying no compatible order, such as a two-adic one. -/
theorem no_cubeRootRelation_selfAdjoint_slope (slope : Matrix (Fin 4) (Fin 4) R)
    (cubeRootRelation : slope * slope + slope + 1 = 0) :
    (slopeᵀ * sixAxisComplementBlock R ≠ sixAxisComplementBlock R * slope) ∧
      ∀ inverseFive : R, 0 < inverseFive →
        slopeᵀ * sixAxisComplementBlockInverse inverseFive ≠
          sixAxisComplementBlockInverse inverseFive * slope := by
  constructor
  · intro selfAdjoint
    exact not_selfAdjoint_of_cubeRootRelation (sixAxisComplementBlock R) slope
      selfAdjoint sixAxisComplementBlock_semidefinite (Pi.single 0 1)
      sixAxisComplementBlock_positive_on_firstCoordinate cubeRootRelation
  · intro inverseFive positive selfAdjoint
    exact not_selfAdjoint_of_cubeRootRelation
      (sixAxisComplementBlockInverse inverseFive) slope selfAdjoint
      (sixAxisComplementBlockInverse_semidefinite positive.le) (Pi.single 0 1)
      (sixAxisComplementBlockInverse_positive_on_firstCoordinate positive)
      cubeRootRelation

end OrderedCoefficients

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
