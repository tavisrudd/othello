import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.SylvesterOperator

/-!
# Unique solvability of the block Sylvester equation

A splitting of a finite coordinate type into blocks is recorded by a label: the
coordinates carrying a fixed label span one block.  A matrix is *block diagonal*
when it vanishes on every entry whose row and column carry different labels, and
*block off-diagonal* when it vanishes on every entry whose row and column carry
the same label.  Every matrix is the sum of its block-diagonal and its block
off-diagonal part, and a matrix that is both is zero.

Let `U` be a block-diagonal matrix whose blocks have separated spectra: writing
`D` for the diagonal matrix whose entry at a coordinate is the scalar attached
to that coordinate's label, the difference of the scalars attached to two
distinct labels is a unit, and `U - D` is nilpotent.  This module proves that
for every block off-diagonal matrix `Y` there is exactly one block off-diagonal
matrix `X` with

  `U * X - X * U = Y`.

That is the step which makes an order-by-order gauge recursion well posed: at
each order the unknown block off-diagonal coefficient is the unique solution of
such an equation.

The proof does not restrict the adjoint operator to the submodule of block
off-diagonal matrices.  Instead it extends it to the endomorphism

  `Ψ = ad U ∘ P + Q`

of all matrices, where `P` and `Q` are the projections onto the block
off-diagonal and the block-diagonal parts.  Because `ad U` preserves both parts,
`Ψ` is invertible exactly when the adjoint operator is invertible on the block
off-diagonal part.  In turn `Ψ` is the sum of `ad D ∘ P + Q`, whose explicit
inverse multiplies each off-diagonal entry by the inverse of the difference of
the two scalars, with the nilpotent endomorphism `ad (U - D) ∘ P`; the two
commute, because `D` commutes with every block-diagonal matrix and both adjoint
operators preserve the two parts.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

variable {R : Type*} [CommRing R] {coordinate : Type*} {factorIndex : Type*}
  [DecidableEq factorIndex]

/-- A matrix is block diagonal for a labelling of the coordinates when it
vanishes on every entry whose row and column carry different labels. -/
def IsBlockDiagonal (label : coordinate → factorIndex) (matrix : Matrix coordinate coordinate R) :
    Prop :=
  ∀ row column, label row ≠ label column → matrix row column = 0

/-- A matrix is block off-diagonal for a labelling of the coordinates when it
vanishes on every entry whose row and column carry the same label. -/
def IsBlockOffDiagonal (label : coordinate → factorIndex)
    (matrix : Matrix coordinate coordinate R) : Prop :=
  ∀ row column, label row = label column → matrix row column = 0

/-- A matrix that is both block diagonal and block off-diagonal vanishes. -/
theorem eq_zero_of_isBlockDiagonal_of_isBlockOffDiagonal {label : coordinate → factorIndex}
    {matrix : Matrix coordinate coordinate R} (diagonal : IsBlockDiagonal label matrix)
    (offDiagonal : IsBlockOffDiagonal label matrix) : matrix = 0 := by
  ext row column
  by_cases sameLabel : label row = label column
  · exact offDiagonal row column sameLabel
  · exact diagonal row column sameLabel

omit [DecidableEq factorIndex] in
/-- A difference of block-diagonal matrices is block diagonal. -/
theorem isBlockDiagonal_sub {label : coordinate → factorIndex}
    {first second : Matrix coordinate coordinate R} (firstDiagonal : IsBlockDiagonal label first)
    (secondDiagonal : IsBlockDiagonal label second) :
    IsBlockDiagonal label (first - second) := by
  intro row column differentLabel
  rw [Matrix.sub_apply, firstDiagonal row column differentLabel,
    secondDiagonal row column differentLabel, sub_zero]

omit [DecidableEq factorIndex] in
/-- The diagonal matrix whose entry at a coordinate is the scalar attached to
that coordinate's label is block diagonal. -/
theorem isBlockDiagonal_diagonal_of_label [DecidableEq coordinate]
    (label : coordinate → factorIndex) (scalar : factorIndex → R) :
    IsBlockDiagonal label (Matrix.diagonal fun index => scalar (label index)) := by
  intro row column differentLabel
  have different : row ≠ column := fun equal => differentLabel (by rw [equal])
  exact Matrix.diagonal_apply_ne _ different

/-- The diagonal matrix of label scalars commutes with every block-diagonal
matrix: on a nonzero entry the two labels agree, so the two scalars agree. -/
theorem diagonal_of_label_commute {label : coordinate → factorIndex} {scalar : factorIndex → R}
    [DecidableEq coordinate] [Fintype coordinate] {matrix : Matrix coordinate coordinate R}
    (blockDiagonal : IsBlockDiagonal label matrix) :
    (Matrix.diagonal fun index => scalar (label index)) * matrix
      = matrix * Matrix.diagonal fun index => scalar (label index) := by
  ext row column
  rw [Matrix.diagonal_mul, Matrix.mul_diagonal]
  by_cases sameLabel : label row = label column
  · rw [sameLabel]
    ring
  · rw [blockDiagonal row column sameLabel]
    ring

/-- The projection onto the block-diagonal part: the entries whose row and
column carry different labels are replaced by zero. -/
def blockDiagonalProjection (label : coordinate → factorIndex) :
    Module.End R (Matrix coordinate coordinate R) where
  toFun matrix := Matrix.of fun row column =>
    if label row = label column then matrix row column else 0
  map_add' matrix other := by
    ext row column
    by_cases sameLabel : label row = label column <;> simp [sameLabel]
  map_smul' scalar matrix := by
    ext row column
    by_cases sameLabel : label row = label column <;> simp [sameLabel]

/-- The projection onto the block off-diagonal part: the entries whose row and
column carry the same label are replaced by zero. -/
def blockOffDiagonalProjection (label : coordinate → factorIndex) :
    Module.End R (Matrix coordinate coordinate R) where
  toFun matrix := Matrix.of fun row column =>
    if label row = label column then 0 else matrix row column
  map_add' matrix other := by
    ext row column
    by_cases sameLabel : label row = label column <;> simp [sameLabel]
  map_smul' scalar matrix := by
    ext row column
    by_cases sameLabel : label row = label column <;> simp [sameLabel]

/-- The block-diagonal projection keeps the entries whose row and column carry
the same label and sets the others to zero. -/
@[simp]
theorem blockDiagonalProjection_apply (label : coordinate → factorIndex)
    (matrix : Matrix coordinate coordinate R) (row column : coordinate) :
    blockDiagonalProjection label matrix row column
      = if label row = label column then matrix row column else 0 := rfl

/-- The block off-diagonal projection keeps the entries whose row and column
carry different labels and sets the others to zero. -/
@[simp]
theorem blockOffDiagonalProjection_apply (label : coordinate → factorIndex)
    (matrix : Matrix coordinate coordinate R) (row column : coordinate) :
    blockOffDiagonalProjection label matrix row column
      = if label row = label column then 0 else matrix row column := rfl

/-- The two projections add up to the identity. -/
theorem blockDiagonalProjection_add_blockOffDiagonalProjection
    (label : coordinate → factorIndex) :
    (blockDiagonalProjection label : Module.End R (Matrix coordinate coordinate R))
        + blockOffDiagonalProjection label = 1 := by
  ext matrix row column
  by_cases sameLabel : label row = label column <;> simp [sameLabel]

/-- Every matrix is the sum of its block-diagonal and its block off-diagonal
part. -/
theorem blockDiagonalProjection_add_blockOffDiagonalProjection_apply
    (label : coordinate → factorIndex) (matrix : Matrix coordinate coordinate R) :
    blockDiagonalProjection (R := R) label matrix + blockOffDiagonalProjection label matrix
      = matrix := by
  ext row column
  by_cases sameLabel : label row = label column <;> simp [sameLabel]

/-- The block off-diagonal part of a block off-diagonal matrix is itself. -/
theorem blockOffDiagonalProjection_eq_self {label : coordinate → factorIndex}
    {matrix : Matrix coordinate coordinate R} (offDiagonal : IsBlockOffDiagonal label matrix) :
    blockOffDiagonalProjection label matrix = matrix := by
  ext row column
  by_cases sameLabel : label row = label column
  · simp [sameLabel, offDiagonal row column sameLabel]
  · simp [sameLabel]

/-- The block-diagonal part of a block off-diagonal matrix vanishes. -/
theorem blockDiagonalProjection_eq_zero {label : coordinate → factorIndex}
    {matrix : Matrix coordinate coordinate R} (offDiagonal : IsBlockOffDiagonal label matrix) :
    blockDiagonalProjection label matrix = 0 := by
  ext row column
  by_cases sameLabel : label row = label column
  · simp [sameLabel, offDiagonal row column sameLabel]
  · simp [sameLabel]

/-- The block off-diagonal part of a block-diagonal matrix vanishes. -/
theorem blockOffDiagonalProjection_eq_zero {label : coordinate → factorIndex}
    {matrix : Matrix coordinate coordinate R} (diagonal : IsBlockDiagonal label matrix) :
    blockOffDiagonalProjection label matrix = 0 := by
  ext row column
  by_cases sameLabel : label row = label column
  · simp [sameLabel]
  · simp [sameLabel, diagonal row column sameLabel]

/-- A matrix whose block-diagonal part vanishes is block off-diagonal. -/
theorem isBlockOffDiagonal_of_blockDiagonalProjection_eq_zero {label : coordinate → factorIndex}
    {matrix : Matrix coordinate coordinate R}
    (vanishing : blockDiagonalProjection (R := R) label matrix = 0) :
    IsBlockOffDiagonal label matrix := by
  intro row column sameLabel
  have entry := congrFun (congrFun vanishing row) column
  rw [blockDiagonalProjection_apply, if_pos sameLabel] at entry
  exact entry

/-- The image of the block off-diagonal projection is block off-diagonal. -/
theorem isBlockOffDiagonal_blockOffDiagonalProjection (label : coordinate → factorIndex)
    (matrix : Matrix coordinate coordinate R) :
    IsBlockOffDiagonal label (blockOffDiagonalProjection label matrix) := by
  intro row column sameLabel
  simp [sameLabel]

/-- The image of the block-diagonal projection is block diagonal. -/
theorem isBlockDiagonal_blockDiagonalProjection (label : coordinate → factorIndex)
    (matrix : Matrix coordinate coordinate R) :
    IsBlockDiagonal label (blockDiagonalProjection label matrix) := by
  intro row column differentLabel
  simp [differentLabel]

/-- The block-diagonal projection is idempotent. -/
theorem blockDiagonalProjection_idempotent (label : coordinate → factorIndex) :
    (blockDiagonalProjection label : Module.End R (Matrix coordinate coordinate R))
        * blockDiagonalProjection label = blockDiagonalProjection label := by
  ext matrix row column
  by_cases sameLabel : label row = label column <;> simp [Module.End.mul_apply, sameLabel]

/-- The block off-diagonal projection is idempotent. -/
theorem blockOffDiagonalProjection_idempotent (label : coordinate → factorIndex) :
    (blockOffDiagonalProjection label : Module.End R (Matrix coordinate coordinate R))
        * blockOffDiagonalProjection label = blockOffDiagonalProjection label := by
  ext matrix row column
  by_cases sameLabel : label row = label column <;> simp [Module.End.mul_apply, sameLabel]

section Adjoint

variable [Fintype coordinate] [DecidableEq coordinate]

omit [DecidableEq coordinate] in
/-- The adjoint operator of a block-diagonal matrix carries block off-diagonal
matrices to block off-diagonal matrices: a nonzero entry of the block-diagonal
factor forces the summation index to carry the row's or the column's label. -/
theorem isBlockOffDiagonal_sylvesterOperator {label : coordinate → factorIndex}
    {leadingOperator matrix : Matrix coordinate coordinate R}
    (blockDiagonal : IsBlockDiagonal label leadingOperator)
    (offDiagonal : IsBlockOffDiagonal label matrix) :
    IsBlockOffDiagonal label (sylvesterOperator leadingOperator leadingOperator matrix) := by
  intro row column sameLabel
  have leftVanishing : (leadingOperator * matrix) row column = 0 := by
    rw [Matrix.mul_apply]
    refine Finset.sum_eq_zero fun middle _ => ?_
    by_cases rowLabel : label row = label middle
    · rw [offDiagonal middle column (rowLabel ▸ sameLabel), mul_zero]
    · rw [blockDiagonal row middle rowLabel, zero_mul]
  have rightVanishing : (matrix * leadingOperator) row column = 0 := by
    rw [Matrix.mul_apply]
    refine Finset.sum_eq_zero fun middle _ => ?_
    by_cases columnLabel : label middle = label column
    · rw [offDiagonal row middle (sameLabel.trans columnLabel.symm), zero_mul]
    · rw [blockDiagonal middle column columnLabel, mul_zero]
  rw [sylvesterOperator_apply, Matrix.sub_apply, leftVanishing, rightVanishing, sub_zero]

omit [DecidableEq coordinate] in
/-- The adjoint operator of a block-diagonal matrix carries block-diagonal
matrices to block-diagonal matrices. -/
theorem isBlockDiagonal_sylvesterOperator {label : coordinate → factorIndex}
    {leadingOperator matrix : Matrix coordinate coordinate R}
    (blockDiagonal : IsBlockDiagonal label leadingOperator)
    (matrixDiagonal : IsBlockDiagonal label matrix) :
    IsBlockDiagonal label (sylvesterOperator leadingOperator leadingOperator matrix) := by
  intro row column differentLabel
  have leftVanishing : (leadingOperator * matrix) row column = 0 := by
    rw [Matrix.mul_apply]
    refine Finset.sum_eq_zero fun middle _ => ?_
    by_cases rowLabel : label row = label middle
    · rw [matrixDiagonal middle column (fun equal => differentLabel (rowLabel.trans equal)),
        mul_zero]
    · rw [blockDiagonal row middle rowLabel, zero_mul]
  have rightVanishing : (matrix * leadingOperator) row column = 0 := by
    rw [Matrix.mul_apply]
    refine Finset.sum_eq_zero fun middle _ => ?_
    by_cases columnLabel : label middle = label column
    · rw [matrixDiagonal row middle (fun equal => differentLabel (equal.trans columnLabel)),
        zero_mul]
    · rw [blockDiagonal middle column columnLabel, mul_zero]
  rw [sylvesterOperator_apply, Matrix.sub_apply, leftVanishing, rightVanishing, sub_zero]

omit [DecidableEq coordinate] in
/-- The adjoint operator of a block-diagonal matrix commutes with the block
off-diagonal projection: it preserves both the block-diagonal and the block
off-diagonal part of a matrix. -/
theorem commute_sylvesterOperator_blockOffDiagonalProjection {label : coordinate → factorIndex}
    {leadingOperator : Matrix coordinate coordinate R}
    (blockDiagonal : IsBlockDiagonal label leadingOperator) :
    Commute (sylvesterOperator leadingOperator leadingOperator :
        Module.End R (Matrix coordinate coordinate R))
      (blockOffDiagonalProjection label) := by
  unfold Commute SemiconjBy
  refine LinearMap.ext fun matrix => ?_
  have offDiagonalPart := isBlockOffDiagonal_sylvesterOperator (leadingOperator := leadingOperator)
    blockDiagonal (isBlockOffDiagonal_blockOffDiagonalProjection label matrix)
  have diagonalPart := isBlockDiagonal_sylvesterOperator (leadingOperator := leadingOperator)
    blockDiagonal (isBlockDiagonal_blockDiagonalProjection label matrix)
  rw [Module.End.mul_apply, Module.End.mul_apply]
  conv_rhs =>
    rw [← blockDiagonalProjection_add_blockOffDiagonalProjection_apply label matrix]
  rw [map_add, map_add, blockOffDiagonalProjection_eq_zero diagonalPart,
    blockOffDiagonalProjection_eq_self offDiagonalPart, zero_add]

omit [DecidableEq coordinate] in
/-- The adjoint operator of a block-diagonal matrix commutes with the
block-diagonal projection. -/
theorem commute_sylvesterOperator_blockDiagonalProjection {label : coordinate → factorIndex}
    {leadingOperator : Matrix coordinate coordinate R}
    (blockDiagonal : IsBlockDiagonal label leadingOperator) :
    Commute (sylvesterOperator leadingOperator leadingOperator :
        Module.End R (Matrix coordinate coordinate R))
      (blockDiagonalProjection label) := by
  have identity : (blockDiagonalProjection label :
      Module.End R (Matrix coordinate coordinate R))
      = 1 - blockOffDiagonalProjection label := by
    rw [← blockDiagonalProjection_add_blockOffDiagonalProjection (R := R) label]
    abel
  rw [identity]
  exact (Commute.one_right _).sub_right
    (commute_sylvesterOperator_blockOffDiagonalProjection blockDiagonal)

omit [DecidableEq factorIndex] in
/-- The adjoint operator of the diagonal matrix of label scalars multiplies each
entry by the difference of the two scalars. -/
theorem sylvesterOperator_diagonal_of_label_apply (label : coordinate → factorIndex)
    (scalar : factorIndex → R) (matrix : Matrix coordinate coordinate R)
    (row column : coordinate) :
    sylvesterOperator (Matrix.diagonal fun index => scalar (label index))
        (Matrix.diagonal fun index => scalar (label index)) matrix row column
      = (scalar (label row) - scalar (label column)) * matrix row column := by
  rw [sylvesterOperator_apply, Matrix.sub_apply, Matrix.diagonal_mul, Matrix.mul_diagonal]
  ring

end Adjoint

/-- The entrywise inverse of the adjoint operator of the diagonal matrix of
label scalars, on the block off-diagonal part: the entry at a pair of
coordinates with different labels is multiplied by a supplied inverse of the
difference of the two scalars, and the remaining entries are set to zero. -/
def blockSeparationInverse (label : coordinate → factorIndex)
    (witness : factorIndex → factorIndex → R) :
    Module.End R (Matrix coordinate coordinate R) where
  toFun matrix := Matrix.of fun row column =>
    if label row = label column then 0
      else witness (label row) (label column) * matrix row column
  map_add' matrix other := by
    ext row column
    by_cases sameLabel : label row = label column <;> simp [sameLabel, mul_add]
  map_smul' scalar matrix := by
    ext row column
    by_cases sameLabel : label row = label column <;> simp [sameLabel, mul_left_comm]

/-- The entrywise inverse of the separation multiplies each entry with
different labels by the supplied inverse of the difference of the two scalars,
and sets the entries with equal labels to zero. -/
@[simp]
theorem blockSeparationInverse_apply (label : coordinate → factorIndex)
    (witness : factorIndex → factorIndex → R) (matrix : Matrix coordinate coordinate R)
    (row column : coordinate) :
    blockSeparationInverse label witness matrix row column
      = if label row = label column then 0
        else witness (label row) (label column) * matrix row column := rfl

section Solvability

variable [Fintype coordinate] [DecidableEq coordinate]

/-- The extension of the adjoint operator of a leading operator by the identity
on the block-diagonal part.  It agrees with the adjoint operator on block
off-diagonal matrices and is the identity on block-diagonal ones, so its
invertibility is exactly unique solvability of the block Sylvester equation. -/
def extendedBlockAdjoint (label : coordinate → factorIndex)
    (leadingOperator : Matrix coordinate coordinate R) :
    Module.End R (Matrix coordinate coordinate R) :=
  sylvesterOperator leadingOperator leadingOperator * blockOffDiagonalProjection label
    + blockDiagonalProjection label

/-- On the diagonal matrix of label scalars the extended adjoint operator is
invertible, with the entrywise inverse of the separation as its inverse on the
block off-diagonal part. -/
theorem isUnit_extendedBlockAdjoint_diagonal {label : coordinate → factorIndex}
    {scalar : factorIndex → R} {witness : factorIndex → factorIndex → R}
    (witnessProperty : ∀ first second, first ≠ second →
      (scalar first - scalar second) * witness first second = 1) :
    IsUnit (extendedBlockAdjoint label
      (Matrix.diagonal fun index => scalar (label index)) :
        Module.End R (Matrix coordinate coordinate R)) := by
  refine ⟨⟨extendedBlockAdjoint label (Matrix.diagonal fun index => scalar (label index)),
    blockSeparationInverse label witness + blockDiagonalProjection label, ?_, ?_⟩, rfl⟩
  · ext matrix row column
    by_cases sameLabel : label row = label column
    · simp [extendedBlockAdjoint, Module.End.mul_apply, sameLabel]
    · have separation := witnessProperty (label row) (label column) sameLabel
      simp only [Module.End.mul_apply, extendedBlockAdjoint, LinearMap.add_apply,
        Module.End.one_apply, map_add, blockSeparationInverse_apply,
        blockDiagonalProjection_apply, blockOffDiagonalProjection_apply, Matrix.add_apply,
        sylvesterOperator_diagonal_of_label_apply, if_neg sameLabel]
      linear_combination matrix row column * separation
  · ext matrix row column
    by_cases sameLabel : label row = label column
    · simp [extendedBlockAdjoint, Module.End.mul_apply, sameLabel]
    · have separation := witnessProperty (label row) (label column) sameLabel
      simp only [Module.End.mul_apply, extendedBlockAdjoint, LinearMap.add_apply,
        Module.End.one_apply, map_add, blockSeparationInverse_apply,
        blockDiagonalProjection_apply, blockOffDiagonalProjection_apply, Matrix.add_apply,
        sylvesterOperator_diagonal_of_label_apply, if_neg sameLabel]
      linear_combination matrix row column * separation

/-- The extended adjoint operator of a block-diagonal leading operator with
separated blocks is invertible.  It is the sum of the extended adjoint operator
of the diagonal matrix of label scalars, which is invertible, with the adjoint
operator of the nilpotent part composed with the block off-diagonal projection,
which is nilpotent; the two commute. -/
theorem isUnit_extendedBlockAdjoint {label : coordinate → factorIndex}
    {scalar : factorIndex → R} {leadingOperator : Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second → IsUnit (scalar first - scalar second))
    (blockDiagonal : IsBlockDiagonal label leadingOperator)
    (nilpotent : IsNilpotent
      (leadingOperator - Matrix.diagonal fun index => scalar (label index))) :
    IsUnit (extendedBlockAdjoint label leadingOperator :
      Module.End R (Matrix coordinate coordinate R)) := by
  have existsWitness : ∀ first second : factorIndex, ∃ value : R,
      first ≠ second → (scalar first - scalar second) * value = 1 := by
    intro first second
    by_cases equal : first = second
    · exact ⟨0, fun different => absurd equal different⟩
    · obtain ⟨value, property⟩ := (separated first second equal).exists_right_inv
      exact ⟨value, fun _ => property⟩
  choose witness witnessProperty using existsWitness
  set diagonalPart : Matrix coordinate coordinate R :=
    Matrix.diagonal fun index => scalar (label index) with diagonalPartDefinition
  set nilpotentPart : Matrix coordinate coordinate R := leadingOperator - diagonalPart
    with nilpotentPartDefinition
  have nilpotentBlockDiagonal : IsBlockDiagonal label nilpotentPart :=
    isBlockDiagonal_sub blockDiagonal
      (isBlockDiagonal_diagonal_of_label (R := R) label scalar)
  have splitting : leadingOperator = diagonalPart + nilpotentPart := by
    rw [nilpotentPartDefinition]
    abel
  have adjointSplitting :
      (sylvesterOperator leadingOperator leadingOperator :
          Module.End R (Matrix coordinate coordinate R))
        = sylvesterOperator diagonalPart diagonalPart
          + sylvesterOperator nilpotentPart nilpotentPart := by
    conv_lhs => rw [splitting]
    exact sylvesterOperator_add _ _ _ _
  have decomposition : (extendedBlockAdjoint label leadingOperator :
        Module.End R (Matrix coordinate coordinate R))
      = extendedBlockAdjoint label diagonalPart
        + sylvesterOperator nilpotentPart nilpotentPart * blockOffDiagonalProjection label := by
    rw [extendedBlockAdjoint, extendedBlockAdjoint, adjointSplitting, add_mul]
    abel
  have nilpotentAdjoint :
      IsNilpotent (sylvesterOperator nilpotentPart nilpotentPart *
        blockOffDiagonalProjection label :
          Module.End R (Matrix coordinate coordinate R)) := by
    obtain ⟨exponent, vanishing⟩ :=
      isNilpotent_sylvesterOperator (R := R) nilpotent nilpotent
    refine ⟨exponent + 1, ?_⟩
    have commuting := commute_sylvesterOperator_blockOffDiagonalProjection
      (R := R) nilpotentBlockDiagonal
    have projectionPower : ∀ power : ℕ,
        (blockOffDiagonalProjection label : Module.End R (Matrix coordinate coordinate R))
            ^ (power + 1) = blockOffDiagonalProjection label := by
      intro power
      induction power with
      | zero => rw [pow_one]
      | succ power inductionHypothesis =>
          rw [pow_succ, inductionHypothesis, blockOffDiagonalProjection_idempotent]
    rw [commuting.mul_pow, projectionPower exponent,
      show exponent + 1 = exponent + 1 from rfl, pow_succ, vanishing, zero_mul, zero_mul]
  have commuting : Commute (sylvesterOperator nilpotentPart nilpotentPart *
      blockOffDiagonalProjection label : Module.End R (Matrix coordinate coordinate R))
      (extendedBlockAdjoint label diagonalPart) := by
    have nilpotentDiagonalCommute : Commute (sylvesterOperator nilpotentPart nilpotentPart :
        Module.End R (Matrix coordinate coordinate R))
        (sylvesterOperator diagonalPart diagonalPart) :=
      commute_sylvesterOperator_of_commute
        (diagonal_of_label_commute (scalar := scalar) nilpotentBlockDiagonal).symm
    have nilpotentOffProjection : Commute (sylvesterOperator nilpotentPart nilpotentPart :
        Module.End R (Matrix coordinate coordinate R)) (blockOffDiagonalProjection label) :=
      commute_sylvesterOperator_blockOffDiagonalProjection (R := R) nilpotentBlockDiagonal
    have nilpotentDiagonalProjection : Commute (sylvesterOperator nilpotentPart nilpotentPart :
        Module.End R (Matrix coordinate coordinate R)) (blockDiagonalProjection label) :=
      commute_sylvesterOperator_blockDiagonalProjection (R := R) nilpotentBlockDiagonal
    have diagonalOffProjection : Commute (blockOffDiagonalProjection label :
        Module.End R (Matrix coordinate coordinate R))
        (sylvesterOperator diagonalPart diagonalPart) :=
      (commute_sylvesterOperator_blockOffDiagonalProjection (R := R)
        (isBlockDiagonal_diagonal_of_label (R := R) label scalar)).symm
    have projectionCommute : Commute (blockOffDiagonalProjection label :
        Module.End R (Matrix coordinate coordinate R)) (blockDiagonalProjection label) := by
      have identity : (blockDiagonalProjection label :
          Module.End R (Matrix coordinate coordinate R))
          = 1 - blockOffDiagonalProjection label := by
        rw [← blockDiagonalProjection_add_blockOffDiagonalProjection (R := R) label]
        abel
      rw [identity]
      exact (Commute.one_right _).sub_right (Commute.refl _)
    have leftFactor : Commute (sylvesterOperator nilpotentPart nilpotentPart *
        blockOffDiagonalProjection label : Module.End R (Matrix coordinate coordinate R))
        (sylvesterOperator diagonalPart diagonalPart * blockOffDiagonalProjection label) :=
      Commute.mul_left (nilpotentDiagonalCommute.mul_right nilpotentOffProjection)
        (diagonalOffProjection.mul_right (Commute.refl _))
    have rightFactor : Commute (sylvesterOperator nilpotentPart nilpotentPart *
        blockOffDiagonalProjection label : Module.End R (Matrix coordinate coordinate R))
        (blockDiagonalProjection label) :=
      Commute.mul_left nilpotentDiagonalProjection projectionCommute
    rw [extendedBlockAdjoint]
    exact leftFactor.add_right rightFactor
  rw [decomposition]
  exact nilpotentAdjoint.isUnit_add_left_of_commute
    (isUnit_extendedBlockAdjoint_diagonal witnessProperty) commuting

/-- Unique solvability of the block Sylvester equation.  For a block-diagonal
leading operator whose blocks have separated spectra — the difference of the
scalars attached to two distinct labels is a unit and the operator differs from
the diagonal matrix of those scalars by a nilpotent matrix — every block
off-diagonal right-hand side is the commutator of the leading operator with
exactly one block off-diagonal matrix. -/
theorem existsUnique_blockOffDiagonal_sylvester_solution {label : coordinate → factorIndex}
    {scalar : factorIndex → R} {leadingOperator : Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second → IsUnit (scalar first - scalar second))
    (blockDiagonal : IsBlockDiagonal label leadingOperator)
    (nilpotent : IsNilpotent
      (leadingOperator - Matrix.diagonal fun index => scalar (label index)))
    {target : Matrix coordinate coordinate R}
    (targetOffDiagonal : IsBlockOffDiagonal label target) :
    ∃! solution : Matrix coordinate coordinate R,
      IsBlockOffDiagonal label solution ∧
        leadingOperator * solution - solution * leadingOperator = target := by
  obtain ⟨operator, operatorEquality⟩ :=
    isUnit_extendedBlockAdjoint separated blockDiagonal nilpotent
  have extendedApply : ∀ matrix : Matrix coordinate coordinate R,
      extendedBlockAdjoint label leadingOperator matrix
        = sylvesterOperator leadingOperator leadingOperator
            (blockOffDiagonalProjection label matrix)
          + blockDiagonalProjection label matrix := fun matrix => rfl
  have extendedOffDiagonal : ∀ matrix : Matrix coordinate coordinate R,
      IsBlockOffDiagonal label matrix →
        extendedBlockAdjoint label leadingOperator matrix
          = leadingOperator * matrix - matrix * leadingOperator := by
    intro matrix offDiagonal
    rw [extendedApply, blockOffDiagonalProjection_eq_self offDiagonal,
      blockDiagonalProjection_eq_zero offDiagonal, add_zero, sylvesterOperator_apply]
  have injective : ∀ first second : Matrix coordinate coordinate R,
      extendedBlockAdjoint label leadingOperator first
        = extendedBlockAdjoint label leadingOperator second → first = second := by
    intro first second equality
    have cancel : ∀ matrix : Matrix coordinate coordinate R,
        (↑operator⁻¹ : Module.End R (Matrix coordinate coordinate R))
          (extendedBlockAdjoint label leadingOperator matrix) = matrix := by
      intro matrix
      have applied := congrArg
        (fun endomorphism : Module.End R (Matrix coordinate coordinate R) => endomorphism matrix)
        operator.inv_mul
      simp only [Module.End.mul_apply, Module.End.one_apply] at applied
      rwa [operatorEquality] at applied
    rw [← cancel first, equality, cancel second]
  refine ⟨(↑operator⁻¹ : Module.End R (Matrix coordinate coordinate R)) target, ?_, ?_⟩
  · have applied := congrArg
      (fun endomorphism : Module.End R (Matrix coordinate coordinate R) => endomorphism target)
      operator.mul_inv
    simp only [Module.End.mul_apply, Module.End.one_apply] at applied
    rw [operatorEquality] at applied
    set solution : Matrix coordinate coordinate R :=
      (↑operator⁻¹ : Module.End R (Matrix coordinate coordinate R)) target with solutionDefinition
    have diagonalVanishing : blockDiagonalProjection label solution = 0 := by
      have projected := congrArg (fun matrix => blockDiagonalProjection (R := R) label matrix)
        (applied.trans rfl)
      rw [extendedApply] at projected
      simp only [map_add] at projected
      have adjointOffDiagonal := isBlockOffDiagonal_sylvesterOperator
        (leadingOperator := leadingOperator) blockDiagonal
        (isBlockOffDiagonal_blockOffDiagonalProjection label solution)
      rw [blockDiagonalProjection_eq_zero adjointOffDiagonal, zero_add] at projected
      have idempotent : blockDiagonalProjection (R := R) label
          (blockDiagonalProjection label solution)
          = blockDiagonalProjection label solution := by
        have identity := blockDiagonalProjection_idempotent (R := R) label
        have applied := congrArg
          (fun endomorphism : Module.End R (Matrix coordinate coordinate R) => endomorphism solution)
          identity
        simpa [Module.End.mul_apply] using applied
      rw [idempotent] at projected
      rw [projected, blockDiagonalProjection_eq_zero targetOffDiagonal]
    have solutionOffDiagonal : IsBlockOffDiagonal label solution :=
      isBlockOffDiagonal_of_blockDiagonalProjection_eq_zero diagonalVanishing
    refine ⟨solutionOffDiagonal, ?_⟩
    rw [← extendedOffDiagonal solution solutionOffDiagonal]
    exact applied
  · rintro candidate ⟨candidateOffDiagonal, candidateEquation⟩
    refine injective candidate _ ?_
    rw [extendedOffDiagonal candidate candidateOffDiagonal, candidateEquation]
    have applied := congrArg
      (fun endomorphism : Module.End R (Matrix coordinate coordinate R) => endomorphism target)
      operator.mul_inv
    simp only [Module.End.mul_apply, Module.End.one_apply] at applied
    rw [operatorEquality] at applied
    exact applied.symm

end Solvability

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
