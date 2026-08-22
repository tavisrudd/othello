import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PairingHorizontality
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.OrthogonalRestrictionNondegeneracy

/-!
# Block diagonality of a horizontal pairing for a labelled spectral splitting

A local splitting of an `F`-bundle into spectral factors is recorded here by a
label on a finite type of coordinates: the coordinates carrying a fixed label
span one factor.  A block-diagonalizing frame for the connection is the
hypothesis that the residue and every regular coefficient of the connection
vanish on entries whose row and column carry different labels.  The pairing is
given, as in the coefficientwise horizontality identity, by a family of
matrices on all coordinates.

For two labels the block of that identity is the two-factor horizontality
identity of the corresponding blocks: multiplying on the left by a
block-diagonal matrix restricts to multiplication by its diagonal block on the
row label, multiplying on the right by a block-diagonal matrix restricts to
multiplication by its diagonal block on the column label, and transposition,
addition, subtraction, scalar multiplication, and finite sums are computed
entrywise.  Feeding those blocks into the Sylvester induction for two factors
with distinct leading eigenvalues gives block diagonality of the whole pairing:
every coefficient of the pairing vanishes on every entry whose row and column
carry different labels.

Combining this with restriction of a nondegenerate pairing to a set of
coordinates orthogonal to its complement gives the nondegeneracy statements the
atomic argument uses.  The leading pairing coefficient restricts nondegenerately
to each factor, and, when the pairing also vanishes between coordinates of
different parity, to the even coordinates of each factor; transporting the
latter along a frame `Fin rank ≃ (even coordinates of a factor)` produces the
invertible matrix required by the rank-two residue rigidity argument.

The eigenvalues are supplied as an injective family, the residue restricted to
each factor being that eigenvalue plus a nilpotent matrix.  Lean constructs no
`F`-bundle, spectral cover, connection, cohomological grading, or Poincare
pairing; horizontality is vanishing of the coefficients of a formal identity
between matrix families, and the parity of a coordinate is an arbitrary function
to `ZMod 2` with `0` naming the even coordinates.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open Matrix

variable {K : Type*} [Field K] {coordinate : Type*} [Fintype coordinate] [DecidableEq coordinate]
  {factorIndex : Type*} [DecidableEq factorIndex] {label : coordinate → factorIndex}

/-- The block of a matrix on the coordinates labelled `rowValue` and those
labelled `columnValue`. -/
def labelBlock (matrix : Matrix coordinate coordinate K) (label : coordinate → factorIndex)
    (rowValue columnValue : factorIndex) :
    Matrix {index // label index = rowValue} {index // label index = columnValue} K :=
  matrix.submatrix Subtype.val Subtype.val

omit [Field K] [Fintype coordinate] [DecidableEq coordinate] [DecidableEq factorIndex] in
/-- The blocks of a transpose are the transposed blocks with the two labels
exchanged. -/
theorem labelBlock_transpose (matrix : Matrix coordinate coordinate K)
    (rowValue columnValue : factorIndex) :
    labelBlock matrixᵀ label rowValue columnValue
      = (labelBlock matrix label columnValue rowValue)ᵀ := rfl

omit [DecidableEq coordinate] in
/-- Blocks of a product with a block-diagonal left factor: the row label is
preserved by the block-diagonal factor, so the intermediate summation runs over
the coordinates carrying that label. -/
theorem labelBlock_mul_of_blockDiagonal_left {left right : Matrix coordinate coordinate K}
    (blockDiagonal : ∀ row column, label row ≠ label column → left row column = 0)
    (rowValue columnValue : factorIndex) :
    labelBlock (left * right) label rowValue columnValue
      = labelBlock left label rowValue rowValue * labelBlock right label rowValue columnValue := by
  ext row column
  have expansion : (left * right) row.val column.val
      = ∑ middle : {index // label index = rowValue},
          left row.val middle.val * right middle.val column.val := by
    rw [Matrix.mul_apply]
    exact sum_eq_sum_subtype_of_vanishing _ fun middle notMember => by
      rw [blockDiagonal row.val middle fun equal => notMember (equal.symm.trans row.2), zero_mul]
  simpa [labelBlock, Matrix.mul_apply] using expansion

omit [DecidableEq coordinate] in
/-- Blocks of a product with a block-diagonal right factor: the column label is
preserved by the block-diagonal factor, so the intermediate summation runs over
the coordinates carrying that label. -/
theorem labelBlock_mul_of_blockDiagonal_right {left right : Matrix coordinate coordinate K}
    (blockDiagonal : ∀ row column, label row ≠ label column → right row column = 0)
    (rowValue columnValue : factorIndex) :
    labelBlock (left * right) label rowValue columnValue
      = labelBlock left label rowValue columnValue
          * labelBlock right label columnValue columnValue := by
  ext row column
  have expansion : (left * right) row.val column.val
      = ∑ middle : {index // label index = columnValue},
          left row.val middle.val * right middle.val column.val := by
    rw [Matrix.mul_apply]
    exact sum_eq_sum_subtype_of_vanishing _ fun middle notMember => by
      rw [blockDiagonal middle column.val fun equal => notMember (equal.trans column.2), mul_zero]
  simpa [labelBlock, Matrix.mul_apply] using expansion

omit [Fintype coordinate] [DecidableEq coordinate] [DecidableEq factorIndex] in
/-- Blocks are computed entrywise, so they respect sums of matrices. -/
theorem labelBlock_add (left right : Matrix coordinate coordinate K)
    (rowValue columnValue : factorIndex) :
    labelBlock (left + right) label rowValue columnValue
      = labelBlock left label rowValue columnValue
          + labelBlock right label rowValue columnValue := rfl

omit [Fintype coordinate] [DecidableEq coordinate] [DecidableEq factorIndex] in
/-- Blocks are computed entrywise, so they respect differences of matrices. -/
theorem labelBlock_sub (left right : Matrix coordinate coordinate K)
    (rowValue columnValue : factorIndex) :
    labelBlock (left - right) label rowValue columnValue
      = labelBlock left label rowValue columnValue
          - labelBlock right label rowValue columnValue := rfl

omit [Fintype coordinate] [DecidableEq coordinate] [DecidableEq factorIndex] in
/-- Blocks are computed entrywise, so they respect scalar multiples. -/
theorem labelBlock_smul (scalar : K) (matrix : Matrix coordinate coordinate K)
    (rowValue columnValue : factorIndex) :
    labelBlock (scalar • matrix) label rowValue columnValue
      = scalar • labelBlock matrix label rowValue columnValue := rfl

omit [Fintype coordinate] [DecidableEq coordinate] [DecidableEq factorIndex] in
/-- Blocks are computed entrywise, so they respect finite sums of matrices. -/
theorem labelBlock_sum {ι : Type*} (summands : Finset ι) (family : ι → Matrix coordinate coordinate K)
    (rowValue columnValue : factorIndex) :
    labelBlock (∑ item ∈ summands, family item) label rowValue columnValue
      = ∑ item ∈ summands, labelBlock (family item) label rowValue columnValue := by
  ext row column
  simp [labelBlock, Matrix.sum_apply]

omit [DecidableEq coordinate] in
/-- The block of a horizontality coefficient for a connection that is block
diagonal in the chosen frame is the horizontality coefficient of the
corresponding blocks: the connection data of the row factor on the left, of the
column factor on the right, and the block of the pairing and of its derivative
between the two factors. -/
theorem labelBlock_pairingHorizontalityCoefficient
    {residue : Matrix coordinate coordinate K}
    {regular pairing derivative : ℕ → Matrix coordinate coordinate K}
    (residueBlockDiagonal : ∀ row column, label row ≠ label column → residue row column = 0)
    (regularBlockDiagonal : ∀ order row column,
      label row ≠ label column → regular order row column = 0)
    (rowValue columnValue : factorIndex) (order : ℕ) :
    labelBlock (pairingHorizontalityCoefficient residue regular residue regular
        pairing derivative order) label rowValue columnValue
      = pairingHorizontalityCoefficient (labelBlock residue label rowValue rowValue)
          (fun step => labelBlock (regular step) label rowValue rowValue)
          (labelBlock residue label columnValue columnValue)
          (fun step => labelBlock (regular step) label columnValue columnValue)
          (fun step => labelBlock (pairing step) label rowValue columnValue)
          (fun step => labelBlock (derivative step) label rowValue columnValue) order := by
  have transposeBlockDiagonal : ∀ (matrix : Matrix coordinate coordinate K),
      (∀ row column, label row ≠ label column → matrix row column = 0) →
        ∀ row column, label row ≠ label column → matrixᵀ row column = 0 := by
    intro matrix vanishing row column different
    exact vanishing column row (Ne.symm different)
  cases order with
  | zero =>
      show labelBlock (residueᵀ * pairing 0 - pairing 0 * residue) label rowValue columnValue = _
      rw [labelBlock_sub,
        labelBlock_mul_of_blockDiagonal_left (transposeBlockDiagonal residue residueBlockDiagonal),
        labelBlock_mul_of_blockDiagonal_right residueBlockDiagonal, labelBlock_transpose]
      rfl
  | succ order =>
      show labelBlock (derivative order
          + (residueᵀ * pairing (order + 1) - pairing (order + 1) * residue)
          + ∑ index ∈ Finset.range (order + 1),
              ((regular index)ᵀ * pairing (order - index)
                + (-1 : K) ^ (order - index) • (pairing index * regular (order - index))))
        label rowValue columnValue = _
      rw [labelBlock_add, labelBlock_add, labelBlock_sub,
        labelBlock_mul_of_blockDiagonal_left (transposeBlockDiagonal residue residueBlockDiagonal),
        labelBlock_mul_of_blockDiagonal_right residueBlockDiagonal, labelBlock_transpose,
        labelBlock_sum]
      refine congrArg _ (Finset.sum_congr rfl fun index _ => ?_)
      rw [labelBlock_add, labelBlock_smul,
        labelBlock_mul_of_blockDiagonal_left
          (transposeBlockDiagonal (regular index) (regularBlockDiagonal index)),
        labelBlock_mul_of_blockDiagonal_right (regularBlockDiagonal (order - index)),
        labelBlock_transpose]

/-- Block diagonality of a horizontal pairing for a labelled splitting with
pairwise distinct leading eigenvalues: every coefficient of the pairing vanishes
on every entry whose row and column carry different labels.  The connection is
block diagonal in the chosen frame, the residue restricted to the coordinates of
one label is that label's eigenvalue plus a nilpotent matrix, the eigenvalues are
pairwise distinct, and every coefficient of the sesquilinear horizontality
identity vanishes.  The direction's derivation is assumed to annihilate an entry
at which the pairing vanishes, which holds for the loop direction and for a
derivation in a base direction of a pairing constant in the frame. -/
theorem labelledPairing_eq_zero_of_horizontality
    {residue : Matrix coordinate coordinate K}
    {regular pairing derivative : ℕ → Matrix coordinate coordinate K}
    {eigenvalue : factorIndex → K}
    (separated : Function.Injective eigenvalue)
    (residueBlockDiagonal : ∀ row column, label row ≠ label column → residue row column = 0)
    (regularBlockDiagonal : ∀ order row column,
      label row ≠ label column → regular order row column = 0)
    (nilpotent : ∀ value : factorIndex,
      IsNilpotent (labelBlock residue label value value - eigenvalue value • 1))
    (derivativeVanishing : ∀ order row column,
      pairing order row column = 0 → derivative order row column = 0)
    (horizontal : ∀ order, pairingHorizontalityCoefficient residue regular residue regular
      pairing derivative order = 0)
    (order : ℕ) (row column : coordinate) (different : label row ≠ label column) :
    pairing order row column = 0 := by
  have blockVanishing : ∀ step,
      labelBlock (pairing step) label (label row) (label column) = 0 := by
    refine offDiagonalPairing_eq_zero_of_horizontality
      (leftRegular := fun step => labelBlock (regular step) label (label row) (label row))
      (rightRegular := fun step => labelBlock (regular step) label (label column) (label column))
      (derivative := fun step => labelBlock (derivative step) label (label row) (label column))
      (separated.ne different) (nilpotent (label row)) (nilpotent (label column)) ?_ ?_
    · intro step blockZero
      ext blockRow blockColumn
      exact derivativeVanishing step blockRow.val blockColumn.val
        (by simpa [labelBlock] using congrFun (congrFun blockZero blockRow) blockColumn)
    · intro step
      rw [← labelBlock_pairingHorizontalityCoefficient residueBlockDiagonal regularBlockDiagonal,
        horizontal step]
      rfl
  have entry := congrFun (congrFun (blockVanishing order) ⟨row, rfl⟩) ⟨column, rfl⟩
  simpa [labelBlock] using entry

/-- Nondegeneracy of a horizontal pairing on the even coordinates of one
spectral factor.  The leading pairing coefficient is nondegenerate on all
coordinates and pairs only coordinates of equal parity; the connection is block
diagonal for a labelled splitting whose leading eigenvalues are pairwise
distinct and whose residue is that eigenvalue plus a nilpotent matrix on each
factor; and every coefficient of the horizontality identity vanishes.  Then the
leading coefficient restricts to a nondegenerate pairing on the coordinates of
one label and even parity. -/
theorem evenPartOfFactor_leadingPairing_det_ne_zero
    {residue : Matrix coordinate coordinate K}
    {regular pairing derivative : ℕ → Matrix coordinate coordinate K}
    {eigenvalue : factorIndex → K} {parity : coordinate → ZMod 2}
    (separated : Function.Injective eigenvalue)
    (residueBlockDiagonal : ∀ row column, label row ≠ label column → residue row column = 0)
    (regularBlockDiagonal : ∀ order row column,
      label row ≠ label column → regular order row column = 0)
    (nilpotent : ∀ value : factorIndex,
      IsNilpotent (labelBlock residue label value value - eigenvalue value • 1))
    (derivativeVanishing : ∀ order row column,
      pairing order row column = 0 → derivative order row column = 0)
    (horizontal : ∀ order, pairingHorizontalityCoefficient residue regular residue regular
      pairing derivative order = 0)
    (parityOrthogonal : ∀ row column, parity row ≠ parity column → pairing 0 row column = 0)
    (leadingNondegenerate : (pairing 0).det ≠ 0) (value : factorIndex) :
    (restrictToCoordinates (pairing 0)
      fun index => label index = value ∧ parity index = 0).det ≠ 0 :=
  det_restrictToEvenPartOfFactor_ne_zero
    (fun row column different => labelledPairing_eq_zero_of_horizontality separated
      residueBlockDiagonal regularBlockDiagonal nilpotent derivativeVanishing horizontal
      0 row column different)
    parityOrthogonal leadingNondegenerate value

/-- Two factors whose leading eigenvalues agree can carry a nonzero horizontal
pairing, so distinctness of the leading eigenvalues cannot be dropped from the
block-diagonality statement.  The witness is a pair of one-dimensional factors
whose connections are the same scalar residue with vanishing regular part,
paired by a constant pairing with invertible leading coefficient: every
coefficient of the sesquilinear horizontality identity vanishes because the two
residue terms cancel and every other term contains a vanishing factor, while the
leading pairing coefficient is the identity. -/
theorem equalEigenvalues_admit_nonzero_horizontalPairing (eigenvalue : K) :
    ∃ (residue : Matrix (Fin 1) (Fin 1) K)
      (regular pairing derivative : ℕ → Matrix (Fin 1) (Fin 1) K),
      IsNilpotent (residue - eigenvalue • 1) ∧
        (∀ order, pairing order = 0 → derivative order = 0) ∧
        (∀ order, pairingHorizontalityCoefficient residue regular residue regular
          pairing derivative order = 0) ∧
        pairing 0 ≠ 0 := by
  refine ⟨eigenvalue • 1, fun _ => 0, fun order => if order = 0 then 1 else 0, fun _ => 0,
    ⟨1, by simp⟩, fun _ _ => rfl, ?_, ?_⟩
  · intro order
    cases order with
    | zero =>
        show (eigenvalue • (1 : Matrix (Fin 1) (Fin 1) K))ᵀ * (if (0 : ℕ) = 0 then 1 else 0)
          - (if (0 : ℕ) = 0 then 1 else 0) * (eigenvalue • (1 : Matrix (Fin 1) (Fin 1) K)) = 0
        simp
    | succ order =>
        rw [pairingHorizontalityCoefficient_succ]
        simp
  · intro leadingZero
    have entry : (1 : Matrix (Fin 1) (Fin 1) K) 0 0 = (0 : Matrix (Fin 1) (Fin 1) K) 0 0 := by
      simpa using congrFun (congrFun leadingZero 0) 0
    simp at entry

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
