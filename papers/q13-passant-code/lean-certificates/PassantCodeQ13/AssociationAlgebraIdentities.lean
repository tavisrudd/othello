import PassantCodeQ13.AssociationTransport.RelationSquares

/-!
# Rank and squaring identities of the binary elliptic association algebra

`PassantCodeQ13.AssociationAlgebra` presents each elliptic relation of the normalized polar
invariant by the list of its 78 row bit masks, computed from the invariant itself, and multiplies
two such presentations by the triple loop over row, column and middle index.  This module proves the
four identities that presentation is introduced for: the exact binary ranks 42, 36, 36, 36 of the
relations of invariants 0, 9, 10, 12, the square of the invariant-zero relation as the sum of the
identity with the other three, and the three-cycle formed by squaring the rank-36 relations.

The proofs run no search over the polar invariant.  Each computed relation list is identified with
the displayed row masks of `PassantCodeQ13.AssociationTransport`, which an exhaustive kernel-reduced
comparison over the ordered pairs of internal points has already identified with the semantic
adjacency matrix of the relation; the identification here is symbolic, because both lists have 78
entries whose set bits lie below 78 and both present the same Boolean matrix.  The triple-loop
product is then identified, again symbolically, with the word-parallel product of row masks, whose
squaring identities are the kernel-reduced certificates of
`PassantCodeQ13.AssociationTransport.RelationSquares`.  Only the ranks are computed here, by kernel
reduction on the displayed masks.

The declarations belong to the `PassantCodeQ13.AssociationAlgebra` namespace, whose definitions they
are about, and occupy a separate module because their proofs consume the mask presentation, which is
built on top of those definitions.
-/

namespace PassantCodeQ13.AssociationAlgebra

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.AssociationTransport
open PassantCodeQ13.MinimumWords

/-- Reading a list of masks inside its range is reading the entry at that index. -/
private theorem getD_of_lt {rows : List Nat} {index : Nat} (inRange : index < rows.length) :
    rows.getD index 0 = rows[index] :=
  (List.getElem_eq_getD 0).symm

/-- Reading a list of masks beyond its length gives the zero mask. -/
private theorem getD_of_le {rows : List Nat} {index : Nat} (beyond : rows.length ≤ index) :
    rows.getD index 0 = 0 := by
  simp [List.getD_eq_getElem?_getD, List.getElem?_eq_none beyond]

/-- Reading a mapped list inside its range applies the function to the entry read. -/
private theorem getD_map_of_lt (function : Nat → Nat) (rows : List Nat) {index : Nat}
    (inRange : index < rows.length) :
    (rows.map function).getD index 0 = function (rows.getD index 0) := by
  have mapped : index < (rows.map function).length := by simpa using inRange
  rw [getD_of_lt mapped, getD_of_lt inRange, List.getElem_map]

/-- Reading the list of the first `count` natural numbers inside its range gives the index. -/
private theorem getD_range {count index : Nat} (inRange : index < count) :
    (List.range count).getD index 0 = index := by
  have bound : index < (List.range count).length := by simpa using inRange
  rw [getD_of_lt bound]
  simp

/-- Tabulating a function of a bounded index is mapping it over the list of those indices. -/
private theorem ofFn_val_eq_map_range {count : Nat} (function : Nat → Bool) :
    (List.ofFn fun index : Fin count => function index.1) = (List.range count).map function := by
  apply List.ext_getElem (by simp)
  intro index bound otherBound
  simp

/-- Bits of the natural number obtained by setting bit `index` for every index below `count` at
which `predicate` holds. -/
private theorem testBit_setBitFold (predicate : Nat → Bool) :
    ∀ count column : Nat,
      ((List.range count).foldl
          (fun value index => if predicate index then value ||| (1 <<< index) else value)
          0).testBit column
        = (decide (column < count) && predicate column) := by
  intro count
  induction count with
  | zero => intro column; simp
  | succ count inductionHypothesis =>
      intro column
      rw [List.range_succ, List.foldl_append, List.foldl_cons, List.foldl_nil]
      by_cases atLast : predicate count
      · rw [if_pos atLast, Nat.testBit_or, inductionHypothesis column, Nat.one_shiftLeft,
          Nat.testBit_two_pow]
        rcases Nat.lt_trichotomy column count with less | equal | greater
        · simp [show column < count from less, show ¬ count = column by omega,
            show column < count + 1 by omega]
        · subst equal
          simp [atLast]
        · simp [show ¬ column < count by omega, show ¬ count = column by omega,
            show ¬ column < count + 1 by omega]
      · rw [if_neg atLast, inductionHypothesis column]
        rcases Nat.lt_trichotomy column count with less | equal | greater
        · simp [show column < count from less, show column < count + 1 by omega]
        · subst equal
          simp [atLast]
        · simp [show ¬ column < count by omega, show ¬ column < count + 1 by omega]

/-- Outside the first 78 bits every entry of a list of masks bounded by `2 ^ 78` vanishes. -/
private theorem getD_testBit_of_bounded {rows : List Nat}
    (bounded : ∀ value ∈ rows, value < 2 ^ 78) (index column : Nat) (high : 78 ≤ column) :
    (rows.getD index 0).testBit column = false := by
  by_cases inRange : index < rows.length
  · rw [getD_of_lt inRange]
    exact Nat.testBit_lt_two_pow
      (lt_of_lt_of_le (bounded _ (List.getElem_mem inRange))
        (Nat.pow_le_pow_right (by norm_num) high))
  · rw [getD_of_le (Nat.le_of_not_lt inRange)]
    simp

/-- Two mask lists of 78 entries whose set bits lie below 78 are equal as soon as they present the
same Boolean matrix on the internal points. -/
private theorem list_eq_of_maskMatrix_eq {left right : List Nat}
    (leftLength : left.length = 78) (rightLength : right.length = 78)
    (leftHigh : ∀ index column : Nat, 78 ≤ column → (left.getD index 0).testBit column = false)
    (rightHigh : ∀ index column : Nat, 78 ≤ column → (right.getD index 0).testBit column = false)
    (masks : (maskMatrix left : Matrix Coordinate Coordinate Bool) = maskMatrix right) :
    left = right := by
  apply List.ext_getElem (by rw [leftLength, rightLength])
  intro index bound otherBound
  rw [← getD_of_lt bound, ← getD_of_lt otherBound]
  apply Nat.eq_of_testBit_eq
  intro column
  by_cases high : 78 ≤ column
  · rw [leftHigh index column high, rightHigh index column high]
  · have indexLt : index < 78 := by omega
    have columnLt : column < 78 := by omega
    exact congrFun (congrFun masks ⟨index, indexLt⟩) ⟨column, columnLt⟩

/-- The computed rows of an elliptic relation, read inside their range. -/
private theorem getD_relationMatrix (value : Field13) {index : Nat} (inRange : index < 78) :
    (relationMatrix value).getD index 0
      = PassantCodeQ13.AssociationAlgebra.relationRow value index := by
  rw [relationMatrix, getD_map_of_lt _ _ (by simpa using inRange), getD_range inRange]

/-- The computed rows of an elliptic relation present its semantic adjacency matrix. -/
private theorem maskMatrix_relationMatrix (value : Field13) :
    (maskMatrix (relationMatrix value) : Matrix Coordinate Coordinate Bool)
      = relationBooleanMatrix value := by
  ext row column
  show ((relationMatrix value).getD row.1 0).testBit column.1 = _
  rw [getD_relationMatrix value row.2, PassantCodeQ13.AssociationAlgebra.relationRow,
    testBit_setBitFold (fun second => row.1 != second && rhoAt row.1 second == value)]
  have distinct : (row.1 != column.1) = (row != column) := by
    simp [bne, Fin.val_inj]
  simp [relationBooleanMatrix, column.2, distinct]

/-- Outside the first 78 bits every computed relation row vanishes. -/
private theorem relationMatrix_testBit_high (value : Field13) (index column : Nat)
    (high : 78 ≤ column) : ((relationMatrix value).getD index 0).testBit column = false := by
  by_cases inRange : index < 78
  · rw [getD_relationMatrix value inRange, PassantCodeQ13.AssociationAlgebra.relationRow,
      testBit_setBitFold (fun second => index != second && rhoAt index second == value)]
    simp [Nat.not_lt_of_ge high]
  · rw [relationMatrix, getD_of_le (by simpa using Nat.le_of_not_lt inRange)]
    simp

/-- The computed rows of an elliptic relation are its displayed row masks. -/
private theorem relationMatrix_eq_masks {value : Field13} {rows : List Nat}
    (length : rows.length = 78) (bounded : ∀ entry ∈ rows, entry < 2 ^ 78)
    (masks : (maskMatrix rows : Matrix Coordinate Coordinate Bool) = relationBooleanMatrix value) :
    relationMatrix value = rows :=
  list_eq_of_maskMatrix_eq (by simp [relationMatrix]) length
    (relationMatrix_testBit_high value) (getD_testBit_of_bounded bounded)
    ((maskMatrix_relationMatrix value).trans masks.symm)

/-- The computed rows of the relation of polar invariant zero are its displayed row masks. -/
theorem relationMatrix_rhoZero : relationMatrix 0 = relationRowsRhoZero :=
  relationMatrix_eq_masks relationRowsRhoZero_length (by decide +kernel)
    maskMatrix_relationRowsRhoZero

/-- The computed rows of the relation of polar invariant nine are its displayed row masks. -/
theorem relationMatrix_rhoNine : relationMatrix 9 = relationRowsRhoNine :=
  relationMatrix_eq_masks relationRowsRhoNine_length (by decide +kernel)
    maskMatrix_relationRowsRhoNine

/-- The computed rows of the relation of polar invariant ten are its displayed row masks. -/
theorem relationMatrix_rhoTen : relationMatrix 10 = relationRowsRhoTen :=
  relationMatrix_eq_masks relationRowsRhoTen_length (by decide +kernel)
    maskMatrix_relationRowsRhoTen

/-- The computed rows of the relation of polar invariant twelve are its displayed row masks. -/
theorem relationMatrix_rhoTwelve : relationMatrix 12 = relationRowsRhoTwelve :=
  relationMatrix_eq_masks relationRowsRhoTwelve_length (by decide +kernel)
    maskMatrix_relationRowsRhoTwelve

/-- The triple-loop product presents the Boolean parity product of the matrices its factors
encode. -/
private theorem maskMatrix_matrixProduct (left right : List Nat) :
    (maskMatrix (matrixProduct left right) : Matrix Coordinate Coordinate Bool)
      = booleanParityProduct (maskMatrix left : Matrix Coordinate Coordinate Bool)
          (maskMatrix right : Matrix Coordinate Coordinate Bool) := by
  ext row column
  show ((matrixProduct left right).getD row.1 0).testBit column.1
      = ((List.ofFn fun middle : Fin 78 =>
          (left.getD row.1 0).testBit middle.1 && (right.getD middle.1 0).testBit column.1).foldl
            (fun parity term => if term then !parity else parity) false)
  rw [ofFn_val_eq_map_range (fun middle =>
      (left.getD row.1 0).testBit middle && (right.getD middle 0).testBit column.1),
    List.foldl_map, matrixProduct,
    getD_map_of_lt _ _ (by simp [row.2]), getD_range row.2,
    testBit_setBitFold (fun columnIndex =>
      (List.range 78).foldl (fun bit middle =>
        if (left.getD row.1 0).testBit middle && (right.getD middle 0).testBit columnIndex
          then !bit else bit) false)]
  simp [column.2]

/-- Outside the first 78 bits every row of a triple-loop product vanishes. -/
private theorem matrixProduct_testBit_high (left right : List Nat) (index column : Nat)
    (high : 78 ≤ column) : ((matrixProduct left right).getD index 0).testBit column = false := by
  by_cases inRange : index < 78
  · rw [matrixProduct, getD_map_of_lt _ _ (by simpa using inRange), getD_range inRange,
      testBit_setBitFold (fun columnIndex =>
        (List.range 78).foldl (fun bit middle =>
          if (left.getD index 0).testBit middle && (right.getD middle 0).testBit columnIndex
            then !bit else bit) false)]
    simp [Nat.not_lt_of_ge high]
  · rw [matrixProduct, getD_of_le (by simpa using Nat.le_of_not_lt inRange)]
    simp

/-- Outside a bit position where every listed row vanishes, the exclusive-or of a selection of those
rows vanishes as well. -/
private theorem testBit_selectedRowXor_of_rows (selector column : Nat) :
    ∀ (rows : List Nat) (start : Nat), (∀ entry ∈ rows, entry.testBit column = false) →
      (selectedRowXor selector start rows).testBit column = false := by
  intro rows
  induction rows with
  | nil => intro start _; simp [selectedRowXor]
  | cons row rest inductionHypothesis =>
      intro start vanishing
      have headVanishes : row.testBit column = false := vanishing row (by simp)
      have tailVanishes : ∀ entry ∈ rest, entry.testBit column = false := fun entry member =>
        vanishing entry (by simp [member])
      by_cases selected : selector.testBit start
      · simp [selectedRowXor, selected, Nat.testBit_xor, headVanishes,
          inductionHypothesis (start + 1) tailVanishes]
      · simp [selectedRowXor, selected, inductionHypothesis (start + 1) tailVanishes]

/-- The triple-loop product agrees with the word-parallel product of row masks, for factors of 78
rows whose set bits lie below 78. -/
private theorem matrixProduct_eq_maskProduct {left right : List Nat}
    (leftLength : left.length = 78) (rightLength : right.length = 78)
    (rightBounded : ∀ entry ∈ right, entry < 2 ^ 78) :
    matrixProduct left right = maskProduct left right := by
  have rightVanishing :
      ∀ column : Nat, 78 ≤ column → ∀ entry ∈ right, entry.testBit column = false :=
    fun column high entry member =>
      Nat.testBit_lt_two_pow
        (lt_of_lt_of_le (rightBounded entry member) (Nat.pow_le_pow_right (by norm_num) high))
  refine list_eq_of_maskMatrix_eq (by simp [matrixProduct]) (by simp [maskProduct, leftLength])
    (matrixProduct_testBit_high left right) ?_ ?_
  · intro index column high
    by_cases inRange : index < 78
    · rw [maskProduct, getD_map_of_lt _ _ (by simpa [leftLength] using inRange)]
      exact testBit_selectedRowXor_of_rows _ _ right 0 (rightVanishing column high)
    · rw [maskProduct, getD_of_le (by simpa [leftLength] using Nat.le_of_not_lt inRange)]
      simp
  · rw [maskMatrix_matrixProduct, maskMatrix_maskProduct left right rightLength]

/-- The four relation matrices have ranks `42,36,36,36`. -/
theorem relation_matrix_ranks :
    binaryRank (relationMatrix 0) = 42 ∧
      binaryRank (relationMatrix 9) = 36 ∧
      binaryRank (relationMatrix 10) = 36 ∧
      binaryRank (relationMatrix 12) = 36 := by
  rw [relationMatrix_rhoZero, relationMatrix_rhoNine, relationMatrix_rhoTen,
    relationMatrix_rhoTwelve]
  decide +kernel

/-- The square of the rho-zero relation is `I + A9 + A10 + A12` over the binary field. -/
theorem rhoZero_square :
    matrixProduct (relationMatrix 0) (relationMatrix 0) =
      xorFour identityMatrix (relationMatrix 9) (relationMatrix 10) (relationMatrix 12) := by
  rw [relationMatrix_rhoZero, relationMatrix_rhoNine, relationMatrix_rhoTen,
    relationMatrix_rhoTwelve,
    matrixProduct_eq_maskProduct relationRowsRhoZero_length relationRowsRhoZero_length
      (by decide +kernel)]
  exact rhoZero_square_entry_certificate

/-- The three rank-36 relation matrices form a squaring cycle over the binary field. -/
theorem rankThirtySix_squaring_cycle :
    matrixProduct (relationMatrix 9) (relationMatrix 9) = relationMatrix 10 ∧
      matrixProduct (relationMatrix 10) (relationMatrix 10) = relationMatrix 12 ∧
      matrixProduct (relationMatrix 12) (relationMatrix 12) = relationMatrix 9 := by
  rw [relationMatrix_rhoNine, relationMatrix_rhoTen, relationMatrix_rhoTwelve,
    matrixProduct_eq_maskProduct relationRowsRhoNine_length relationRowsRhoNine_length
      (by decide +kernel),
    matrixProduct_eq_maskProduct relationRowsRhoTen_length relationRowsRhoTen_length
      (by decide +kernel),
    matrixProduct_eq_maskProduct relationRowsRhoTwelve_length relationRowsRhoTwelve_length
      (by decide +kernel)]
  exact ⟨rhoNine_square_entry_certificate, rhoTen_square_entry_certificate,
    rhoTwelve_square_entry_certificate⟩

end PassantCodeQ13.AssociationAlgebra
