import PassantCodeQ13.AssociationTransport.Base

/-!
# Word-parallel evaluation of binary matrix products

A Boolean matrix on bounded index types is presented here by the list of its rows, each row the
natural number whose set bits are the columns carrying the entry `true`.  In that presentation one
row of a parity product is the exclusive-or of the right-hand rows selected by the set bits of the
corresponding left-hand row, so evaluating a product costs one natural-number operation per pair of
a left-hand row and a middle index, rather than one operation per triple of indices.

`maskMatrix_maskProduct` proves that this evaluation computes the Boolean parity product of
`PassantCodeQ13.AssociationTransport.Base`, which `booleanParityProduct_linearize` in turn identifies
with matrix multiplication over the binary field; `maskMatrix_maskXor` does the same for entrywise
addition.  The hypotheses are exactly the length conditions making the mask lists describe matrices
on the stated index types: a mask list shorter than its row count would silently read the zero row.
Every result in this module is symbolic, and no declaration here performs a finite search.
-/

namespace PassantCodeQ13.AssociationTransport

/-- The Boolean matrix whose entry at `(row, column)` is bit `column` of the `row`-th listed mask;
positions beyond the list read as the zero row. -/
def maskMatrix (rows : List Nat) {rowCard columnCard : Nat} :
    Matrix (Fin rowCard) (Fin columnCard) Bool :=
  fun row column => (rows.getD row.1 0).testBit column.1

/-- The support matrix of a displayed projective orbit is the matrix of its row masks. -/
theorem orbitSupportBooleanMatrix_eq_maskMatrix (orbit : List Nat) :
    orbitSupportBooleanMatrix orbit
      = (maskMatrix orbit : Matrix OrbitCoordinate Coordinate Bool) :=
  rfl

/-- Exclusive-or of the listed rows selected by the set bits of `selector`, counting list positions
from `start`. -/
def selectedRowXor (selector : Nat) : Nat → List Nat → Nat
  | _, [] => 0
  | start, row :: rest =>
      if selector.testBit start then row ^^^ selectedRowXor selector (start + 1) rest
      else selectedRowXor selector (start + 1) rest

/-- Parity of the bits in column `column` of the rows selected by the set bits of `selector`,
counting list positions from `start`. -/
def selectedBitParity (selector column : Nat) : Nat → List Nat → Bool
  | _, [] => false
  | start, row :: rest =>
      xor (selector.testBit start && row.testBit column)
        (selectedBitParity selector column (start + 1) rest)

/-- Row masks of the parity product of two matrices presented by row masks. -/
def maskProduct (left right : List Nat) : List Nat :=
  left.map fun row => selectedRowXor row 0 right

/-- Row masks of the entrywise exclusive-or of two matrices presented by row masks. -/
def maskXor (left right : List Nat) : List Nat :=
  List.zipWith (· ^^^ ·) left right

/-- Row masks of the identity matrix on `card` coordinates. -/
def identityMasks (card : Nat) : List Nat :=
  (List.range card).map fun index => 1 <<< index

/-- Entrywise exclusive-or keeps one row for each row common to both mask lists. -/
theorem maskXor_length (left right : List Nat) :
    (maskXor left right).length = min left.length right.length := by
  simp [maskXor]

/-- The identity masks give one row per coordinate. -/
theorem identityMasks_length (card : Nat) : (identityMasks card).length = card := by
  simp [identityMasks]

private theorem selectedRowXor_zero :
    ∀ (rows : List Nat) (start : Nat), selectedRowXor 0 start rows = 0 := by
  intro rows
  induction rows with
  | nil => intro start; rfl
  | cons row rest inductionHypothesis =>
      intro start
      simp [selectedRowXor, inductionHypothesis]

private theorem getD_maskProduct :
    ∀ (left right : List Nat) (index : Nat),
      (maskProduct left right).getD index 0 = selectedRowXor (left.getD index 0) 0 right := by
  intro left
  induction left with
  | nil =>
      intro right index
      simp [maskProduct, selectedRowXor_zero]
  | cons row rest inductionHypothesis =>
      intro right index
      cases index with
      | zero => simp [maskProduct]
      | succ index => simpa [maskProduct] using inductionHypothesis right index

private theorem getD_maskXor :
    ∀ (left right : List Nat), left.length = right.length →
      ∀ index : Nat,
        (maskXor left right).getD index 0 = (left.getD index 0) ^^^ (right.getD index 0) := by
  intro left
  induction left with
  | nil =>
      intro right lengths index
      have : right = [] := List.eq_nil_of_length_eq_zero lengths.symm
      subst this
      simp [maskXor]
  | cons row rest inductionHypothesis =>
      intro right lengths index
      cases right with
      | nil => simp at lengths
      | cons other others =>
          cases index with
          | zero => simp [maskXor]
          | succ index =>
              have tailLengths : rest.length = others.length := by
                simpa using lengths
              simpa [maskXor] using inductionHypothesis others tailLengths index

/-- Reading a column of the selected exclusive-or is the parity of the selected column bits. -/
private theorem testBit_selectedRowXor (selector column : Nat) :
    ∀ (rows : List Nat) (start : Nat),
      (selectedRowXor selector start rows).testBit column
        = selectedBitParity selector column start rows := by
  intro rows
  induction rows with
  | nil => intro start; simp [selectedRowXor, selectedBitParity]
  | cons row rest inductionHypothesis =>
      intro start
      by_cases selected : selector.testBit start
      · simp [selectedRowXor, selectedBitParity, selected, Nat.testBit_xor, inductionHypothesis]
      · simp [selectedRowXor, selectedBitParity, selected, inductionHypothesis]

private theorem foldl_parity_init :
    ∀ (terms : List Bool) (initial : Bool),
      terms.foldl (fun parity term => if term then !parity else parity) initial
        = xor initial (terms.foldl (fun parity term => if term then !parity else parity) false) := by
  intro terms
  induction terms with
  | nil => intro initial; simp
  | cons term terms inductionHypothesis =>
      intro initial
      simp only [List.foldl_cons]
      rw [inductionHypothesis (if term then !initial else initial),
        inductionHypothesis (if term then !false else false)]
      cases term <;> cases initial <;> simp

private theorem parity_ofFn_eq_selectedBitParity (selector column : Nat) :
    ∀ (rows : List Nat) (start : Nat),
      ((List.ofFn fun middle : Fin rows.length =>
            selector.testBit (start + middle.1) && (rows.getD middle.1 0).testBit column).foldl
          (fun parity term => if term then !parity else parity) false)
        = selectedBitParity selector column start rows := by
  intro rows
  induction rows with
  | nil => intro start; simp [selectedBitParity]
  | cons row rest inductionHypothesis =>
      intro start
      have shift : ∀ index : Nat, start + (index + 1) = start + 1 + index := by
        intro index
        omega
      simp only [List.length_cons, List.ofFn_succ, Fin.val_zero, Nat.add_zero,
        List.getD_cons_zero, Fin.val_succ, List.getD_cons_succ, List.foldl_cons,
        shift, selectedBitParity]
      rw [foldl_parity_init, inductionHypothesis (start + 1)]
      cases selector.testBit start <;> cases row.testBit column <;> simp

private theorem parity_ofFn_zero (selector column : Nat) (rows : List Nat) :
    ((List.ofFn fun middle : Fin rows.length =>
          selector.testBit middle.1 && (rows.getD middle.1 0).testBit column).foldl
        (fun parity term => if term then !parity else parity) false)
      = selectedBitParity selector column 0 rows := by
  simpa only [Nat.zero_add] using parity_ofFn_eq_selectedBitParity selector column rows 0

/-- The word-parallel product of row masks presents the Boolean parity product of the matrices they
encode, provided the right-hand mask list has one entry per middle index. -/
theorem maskMatrix_maskProduct {rowCard middleCard columnCard : Nat}
    (left right : List Nat) (rightLength : right.length = middleCard) :
    (maskMatrix (maskProduct left right) : Matrix (Fin rowCard) (Fin columnCard) Bool)
      = booleanParityProduct (maskMatrix left : Matrix (Fin rowCard) (Fin middleCard) Bool)
          (maskMatrix right : Matrix (Fin middleCard) (Fin columnCard) Bool) := by
  subst rightLength
  ext row column
  show ((maskProduct left right).getD row.1 0).testBit column.1
      = ((List.ofFn fun middle : Fin right.length =>
            (left.getD row.1 0).testBit middle.1 && (right.getD middle.1 0).testBit column.1).foldl
          (fun parity term => if term then !parity else parity) false)
  rw [getD_maskProduct, testBit_selectedRowXor, parity_ofFn_zero]

/-- The entrywise exclusive-or of row masks presents the entrywise exclusive-or of the matrices they
encode, provided the two mask lists have the same length. -/
theorem maskMatrix_maskXor {rowCard columnCard : Nat}
    (left right : List Nat) (lengths : left.length = right.length) :
    (maskMatrix (maskXor left right) : Matrix (Fin rowCard) (Fin columnCard) Bool)
      = booleanXorMatrix (maskMatrix left) (maskMatrix right) := by
  ext row column
  show ((maskXor left right).getD row.1 0).testBit column.1 = _
  rw [getD_maskXor left right lengths]
  simp [booleanXorMatrix, maskMatrix, Nat.testBit_xor]

/-- A mask list of zeros presents the zero Boolean matrix. -/
theorem maskMatrix_replicate_zero {rowCard columnCard count : Nat} :
    (maskMatrix (List.replicate count 0) : Matrix (Fin rowCard) (Fin columnCard) Bool)
      = booleanZeroMatrix := by
  have zeros : ∀ index : Nat, (List.replicate count (0 : Nat)).getD index 0 = 0 := by
    intro index
    induction count generalizing index with
    | zero => simp
    | succ count inductionHypothesis =>
        cases index with
        | zero => simp
        | succ index => simpa using inductionHypothesis index
  ext row column
  show ((List.replicate count 0).getD row.1 0).testBit column.1 = _
  rw [zeros]
  simp [booleanZeroMatrix]

end PassantCodeQ13.AssociationTransport
