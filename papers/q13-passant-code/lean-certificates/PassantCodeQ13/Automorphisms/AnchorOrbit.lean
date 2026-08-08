import PassantCodeQ13.Automorphisms.RelationRows
import PassantCodeQ13.Automorphisms.Base
import PassantCodeQ13.MinimumWords.NormalizedIndexTable
import PassantCodeQ13.SymmetricSquareInvariance

/-!
# The anchor triple orbit as a table of encoded pairs

An ordered triple `(a, b, c)` of internal-point indices below 78 is recorded as bit `b * 78 + c` of
entry `a` of a list of 78 natural numbers.  Two such tables are built and compared by kernel
reduction.

The first table is accumulated by one pass over the 2184 normalized projective matrices, recording
the triple of images of the first three anchors under each.  The same pass records whether every
entry it sets was previously clear, which is exactly injectivity of the map sending a matrix to its
anchor image triple.

The second table holds the ordered triples carrying the anchor relation pattern `(10, 3, 9)`.  Entry
`a` is the union, over the points `b` in the relation of polar invariant ten with `a`, of the mask of
points standing in the relation of polar invariant three with `a` and of polar invariant nine with
`b`, shifted into the block of `b`.  It is read off the displayed row masks of those three relations,
whose agreement with the polar invariant is proved in `PassantCodeQ13.Automorphisms.RelationRows`.

Both checks are discharged by kernel reduction and neither uses compiled evaluation.  The transport
below turns them into statements about `matrixAction` and `rhoAt`: every patterned triple is an
anchor image, and distinct matrices have distinct anchor images.
-/

namespace PassantCodeQ13.Automorphisms

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.AssociationAlgebra
open PassantCodeQ13.AssociationTransport
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.WeightTen

/-! ## Setting one bit of one row of a table -/

/-- Set bit `position` of entry `index` of a list of row masks; a list too short to have that entry
is returned unchanged. -/
def setRowBit : Nat → Nat → List Nat → List Nat
  | _, _, [] => []
  | 0, position, row :: rest => (row ||| 1 <<< position) :: rest
  | index + 1, position, row :: rest => row :: setRowBit index position rest

theorem length_setRowBit :
    ∀ (rows : List Nat) (index position : Nat), (setRowBit index position rows).length = rows.length := by
  intro rows
  induction rows with
  | nil => intro index position; cases index <;> rfl
  | cons row rest inductionHypothesis =>
      intro index position
      cases index with
      | zero => rfl
      | succ index => simpa [setRowBit] using inductionHypothesis index position

theorem testBit_setRowBit_mono :
    ∀ (rows : List Nat) (index position other bit : Nat),
      (rows.getD other 0).testBit bit = true →
        ((setRowBit index position rows).getD other 0).testBit bit = true := by
  intro rows
  induction rows with
  | nil => intro index position other bit set; cases index <;> exact set
  | cons row rest inductionHypothesis =>
      intro index position other bit set
      cases index with
      | zero =>
          cases other with
          | zero => simpa [setRowBit, Nat.testBit_or] using Or.inl set
          | succ other => simpa [setRowBit] using set
      | succ index =>
          cases other with
          | zero => simpa [setRowBit] using set
          | succ other =>
              simpa [setRowBit] using inductionHypothesis index position other bit (by simpa using set)

theorem testBit_setRowBit :
    ∀ (rows : List Nat) (index position other bit : Nat),
      ((setRowBit index position rows).getD other 0).testBit bit = true →
        (rows.getD other 0).testBit bit = true ∨ (other = index ∧ bit = position) := by
  intro rows
  induction rows with
  | nil => intro index position other bit set; cases index <;> exact Or.inl set
  | cons row rest inductionHypothesis =>
      intro index position other bit set
      cases index with
      | zero =>
          cases other with
          | zero =>
              simp only [setRowBit, List.getD_cons_zero, Nat.testBit_or, Bool.or_eq_true] at set
              rcases set with set | inserted
              · exact Or.inl (by simpa using set)
              · rw [Nat.shiftLeft_eq, Nat.one_mul, Nat.testBit_two_pow] at inserted
                exact Or.inr ⟨rfl, by simpa [eq_comm] using inserted⟩
          | succ other => exact Or.inl (by simpa [setRowBit] using set)
      | succ index =>
          cases other with
          | zero => exact Or.inl (by simpa [setRowBit] using set)
          | succ other =>
              rcases inductionHypothesis index position other bit (by simpa [setRowBit] using set) with
                earlier | ⟨row_eq, bit_eq⟩
              · exact Or.inl (by simpa using earlier)
              · exact Or.inr ⟨by simp [row_eq], bit_eq⟩

theorem testBit_setRowBit_self :
    ∀ (rows : List Nat) (index position : Nat), index < rows.length →
      ((setRowBit index position rows).getD index 0).testBit position = true := by
  intro rows
  induction rows with
  | nil => intro index position bound; simp at bound
  | cons row rest inductionHypothesis =>
      intro index position bound
      cases index with
      | zero => simp [setRowBit, Nat.testBit_or, Nat.shiftLeft_eq]
      | succ index =>
          have bound' : index < rest.length := by simpa using bound
          simpa [setRowBit] using inductionHypothesis index position bound'

/-! ## One pass over a list of items, each contributing one table entry

The scan is stated for arbitrary row and bit functions so that its structural lemmas are proved
once: a set bit of the accumulated table names an item of the list, set bits survive later steps,
and a successful freshness flag makes the recorded pairs pairwise distinct. -/

section Scan

variable {α : Type*} (rowOf bitOf : α → Nat)

/-- One step of the scan: record the item's entry, and note whether that entry was clear. -/
def scanStep (state : List Nat × Bool) (item : α) : List Nat × Bool :=
  (setRowBit (rowOf item) (bitOf item) state.1,
    state.2 && !((state.1.getD (rowOf item) 0).testBit (bitOf item)))

private theorem length_scan :
    ∀ (items : List α) (state : List Nat × Bool),
      ((items.foldl (scanStep rowOf bitOf) state).1).length = state.1.length := by
  intro items
  induction items with
  | nil => intro state; rfl
  | cons item rest inductionHypothesis =>
      intro state
      simpa [scanStep, length_setRowBit] using inductionHypothesis (scanStep rowOf bitOf state item)

private theorem testBit_scan_mono :
    ∀ (items : List α) (state : List Nat × Bool) (other bit : Nat),
      (state.1.getD other 0).testBit bit = true →
        (((items.foldl (scanStep rowOf bitOf) state).1).getD other 0).testBit bit = true := by
  intro items
  induction items with
  | nil => intro state other bit set; exact set
  | cons item rest inductionHypothesis =>
      intro state other bit set
      exact inductionHypothesis _ other bit (testBit_setRowBit_mono _ _ _ _ _ set)

private theorem testBit_scan :
    ∀ (items : List α) (state : List Nat × Bool) (other bit : Nat),
      (((items.foldl (scanStep rowOf bitOf) state).1).getD other 0).testBit bit = true →
        (state.1.getD other 0).testBit bit = true ∨
          ∃ item ∈ items, rowOf item = other ∧ bitOf item = bit := by
  intro items
  induction items with
  | nil => intro state other bit set; exact Or.inl set
  | cons item rest inductionHypothesis =>
      intro state other bit set
      rcases inductionHypothesis _ other bit set with earlier | ⟨found, found_mem, found_row, found_bit⟩
      · rcases testBit_setRowBit _ _ _ _ _ earlier with original | ⟨row_eq, bit_eq⟩
        · exact Or.inl original
        · exact Or.inr ⟨item, by simp, row_eq.symm, bit_eq.symm⟩
      · exact Or.inr ⟨found, List.mem_cons_of_mem item found_mem, found_row, found_bit⟩

private theorem scan_snd_of_true :
    ∀ (items : List α) (state : List Nat × Bool),
      (items.foldl (scanStep rowOf bitOf) state).2 = true → state.2 = true := by
  intro items
  induction items with
  | nil => intro state flag; exact flag
  | cons item rest inductionHypothesis =>
      intro state flag
      have step := inductionHypothesis _ flag
      simp only [scanStep, Bool.and_eq_true] at step
      exact step.1

private theorem pairwise_of_scan :
    ∀ (items : List α) (state : List Nat × Bool),
      (∀ item ∈ items, rowOf item < state.1.length) →
      (items.foldl (scanStep rowOf bitOf) state).2 = true →
        items.Pairwise fun first second =>
          rowOf first ≠ rowOf second ∨ bitOf first ≠ bitOf second := by
  intro items
  induction items with
  | nil => intro _ _ _; exact List.Pairwise.nil
  | cons item rest inductionHypothesis =>
      intro state bounds flag
      simp only [List.foldl_cons] at flag
      have step_bounds : ∀ other ∈ rest, rowOf other < (scanStep rowOf bitOf state item).1.length := by
        intro other other_mem
        simpa [scanStep, length_setRowBit] using bounds other (List.mem_cons_of_mem item other_mem)
      refine List.Pairwise.cons ?_ (inductionHypothesis _ step_bounds flag)
      intro other other_mem
      by_contra clash
      rw [not_or, not_not, not_not] at clash
      obtain ⟨row_clash, bit_clash⟩ := clash
      obtain ⟨before, after, split⟩ := List.append_of_mem other_mem
      have inserted : ((scanStep rowOf bitOf state item).1.getD (rowOf other) 0).testBit (bitOf other)
          = true := by
        rw [← row_clash, ← bit_clash]
        exact testBit_setRowBit_self _ _ _ (bounds item (by simp))
      have carried :
          (((before.foldl (scanStep rowOf bitOf) (scanStep rowOf bitOf state item)).1).getD
            (rowOf other) 0).testBit (bitOf other) = true :=
        testBit_scan_mono rowOf bitOf before _ _ _ inserted
      have blocked :
          (scanStep rowOf bitOf
            (before.foldl (scanStep rowOf bitOf) (scanStep rowOf bitOf state item)) other).2
            = false := by
        simp only [scanStep] at carried ⊢
        rw [carried]
        simp
      have propagated := scan_snd_of_true rowOf bitOf after _ (by
        rw [split] at flag
        simpa [List.foldl_append, List.foldl_cons] using flag)
      rw [blocked] at propagated
      exact Bool.noConfusion propagated

end Scan

/-! ## The anchor image table -/

/-- Index of the image of the first anchor under one normalized matrix.  The index is read from the
packed lookup table rather than by scanning the coordinate list, so one pass over the matrices costs
a fixed amount of reduction per matrix. -/
def anchorImageRow (matrix : Matrix2) : Nat :=
  tabulatedInternalIndex (act matrix (internalAt (anchors 0)))

/-- The images of the second and third anchors, encoded as one entry of a row. -/
def anchorImageBit (matrix : Matrix2) : Nat :=
  tabulatedInternalIndex (act matrix (internalAt (anchors 1))) * 78
    + tabulatedInternalIndex (act matrix (internalAt (anchors 2)))

/-- The tabulated first-anchor image index is the scanning index. -/
theorem anchorImageRow_eq (matrix : Matrix2) :
    anchorImageRow matrix = internalIndex (act matrix (internalAt (anchors 0))) :=
  tabulatedInternalIndex_eq_internalIndex (act_mem_projectiveTripleList _ _)

/-- The tabulated entry is built from the scanning indices of the second and third images. -/
theorem anchorImageBit_eq (matrix : Matrix2) :
    anchorImageBit matrix = internalIndex (act matrix (internalAt (anchors 1))) * 78
      + internalIndex (act matrix (internalAt (anchors 2))) := by
  rw [anchorImageBit, tabulatedInternalIndex_eq_internalIndex (act_mem_projectiveTripleList _ _),
    tabulatedInternalIndex_eq_internalIndex (act_mem_projectiveTripleList _ _)]

/-- One pass over the normalized matrix list, accumulating the table of anchor image triples and
recording whether every entry it set was previously clear. -/
def anchorImageScan : List Nat × Bool :=
  projectiveMatrices.foldl (scanStep anchorImageRow anchorImageBit) (List.replicate 78 0, true)

/-- Distinct normalized matrices set distinct entries of the anchor image table. -/
theorem anchorImages_are_distinct : anchorImageScan.2 = true := by
  decide +kernel

/-! ## The patterned triple table -/

/-- For two internal-point indices in the relation of polar invariant ten, the mask of third points
completing the anchor relation pattern; the zero mask when they are not in that relation. -/
def patternedPairMask (first second : Nat) : Nat :=
  if (relationRowsRhoTen.getD first 0).testBit second then
    relationRowsRhoThree.getD first 0 &&& relationRowsRhoNine.getD second 0
  else 0

/-- Entry `first` of the patterned triple table. -/
def patternedRow (first : Nat) : Nat :=
  (List.range 78).foldl (fun mask second =>
    mask ||| (patternedPairMask first second <<< (second * 78))) 0

/-- The table of ordered triples carrying the anchor relation pattern `(10, 3, 9)`. -/
def patternedRows : List Nat :=
  (List.range 78).map patternedRow

/-- The anchor images are exactly the triples carrying the anchor relation pattern. -/
theorem anchorImageScan_fst_eq_patternedRows : anchorImageScan.1 = patternedRows := by
  decide +kernel

/-- The polar invariant of an internal point with itself is four, so a pair standing in any other
relation is a pair of distinct points. -/
theorem rhoAt_self : ∀ point : Coordinate, rhoAt point.1 point.1 = 4 := by
  decide +kernel

/-! ## Transport to the indexed model -/

private theorem getD_replicate_zero :
    ∀ (count index : Nat), (List.replicate count (0 : Nat)).getD index 0 = 0
  | 0, _ => rfl
  | _ + 1, 0 => rfl
  | count + 1, index + 1 => by
      simpa [List.replicate] using getD_replicate_zero count index

private theorem ofNat_val {value : Nat} (bound : value < 78) : (Fin.ofNat 78 value).val = value := by
  simpa [Fin.ofNat] using Nat.mod_eq_of_lt bound

private theorem testBit_relation_row {rows : List Nat} {value : Field13}
    (certificate : relationRowsCertificate rows value = true)
    {first second : Coordinate} (distinct : first ≠ second)
    (relation : rhoAt first.1 second.1 = value) :
    (rows.getD first.1 0).testBit second.1 = true := by
  rw [testBit_of_relationRowsCertificate certificate first.isLt second.isLt]
  have indices : first.1 ≠ second.1 := fun equal => distinct (Fin.ext equal)
  simp [indices, relation]

private theorem testBit_foldl_or {g : Nat → Nat} :
    ∀ (items : List Nat) (initial bit : Nat) (item : Nat), item ∈ items →
      (g item).testBit bit = true →
        (items.foldl (fun mask value => mask ||| g value) initial).testBit bit = true := by
  intro items
  induction items with
  | nil => intro _ _ _ absurd_mem; simp at absurd_mem
  | cons head rest inductionHypothesis =>
      intro initial bit item item_mem set
      have mono : ∀ (tail : List Nat) (start : Nat), start.testBit bit = true →
          (tail.foldl (fun mask value => mask ||| g value) start).testBit bit = true := by
        intro tail
        induction tail with
        | nil => intro start start_set; exact start_set
        | cons other others tailHypothesis =>
            intro start start_set
            exact tailHypothesis _ (by simp [Nat.testBit_or, start_set])
      rcases List.mem_cons.mp item_mem with head_eq | rest_mem
      · subst head_eq
        exact mono rest _ (by simp [Nat.testBit_or, set])
      · exact inductionHypothesis _ bit item rest_mem set

/-- A patterned triple is recorded in the patterned triple table. -/
theorem testBit_patternedRows {first second third : Coordinate}
    (ten : rhoAt first.1 second.1 = 10) (three : rhoAt first.1 third.1 = 3)
    (nine : rhoAt second.1 third.1 = 9) :
    ((patternedRows.getD first.1 0)).testBit (second.1 * 78 + third.1) = true := by
  have first_ne_second : first ≠ second := by
    intro equal; rw [equal, rhoAt_self] at ten; exact absurd ten (by decide)
  have first_ne_third : first ≠ third := by
    intro equal; rw [equal, rhoAt_self] at three; exact absurd three (by decide)
  have second_ne_third : second ≠ third := by
    intro equal; rw [equal, rhoAt_self] at nine; exact absurd nine (by decide)
  have ten_bit := testBit_relation_row relationRowsRhoTen_certificate first_ne_second ten
  have three_bit := testBit_relation_row relationRowsRhoThree_certificate first_ne_third three
  have nine_bit := testBit_relation_row relationRowsRhoNine_certificate second_ne_third nine
  have entry : patternedRows.getD first.1 0 = patternedRow first.1 := by
    simp [patternedRows, List.getD, first.isLt]
  rw [entry]
  refine testBit_foldl_or (List.range 78) 0 _ second.1 (List.mem_range.mpr second.isLt) ?_
  have mask_bit : (patternedPairMask first.1 second.1).testBit third.1 = true := by
    rw [patternedPairMask, if_pos ten_bit, Nat.testBit_and, three_bit, nine_bit]
    rfl
  simp [Nat.testBit_shiftLeft, mask_bit]

/-- Every ordered triple carrying the anchor relation pattern is the image of the first three
anchors under one normalized projective matrix. -/
theorem exists_matrixAction_of_pattern {first second third : Coordinate}
    (ten : rhoAt first.1 second.1 = 10) (three : rhoAt first.1 third.1 = 3)
    (nine : rhoAt second.1 third.1 = 9) :
    ∃ matrix : Fin projectiveMatrices.length,
      (matrixAction matrix (anchors 0), matrixAction matrix (anchors 1),
        matrixAction matrix (anchors 2)) = (first, second, third) := by
  have recorded : ((anchorImageScan.1.getD first.1 0)).testBit (second.1 * 78 + third.1) = true := by
    rw [anchorImageScan_fst_eq_patternedRows]
    exact testBit_patternedRows ten three nine
  rcases testBit_scan anchorImageRow anchorImageBit projectiveMatrices
      (List.replicate 78 0, true) _ _ recorded with clear | witness
  · rw [getD_replicate_zero] at clear
    simp at clear
  obtain ⟨matrix, matrix_mem, row_eq, bit_eq⟩ := witness
  rw [anchorImageRow_eq] at row_eq
  rw [anchorImageBit_eq] at bit_eq
  obtain ⟨index, index_eq⟩ := List.get_of_mem matrix_mem
  have bounds (point : Coordinate) : internalIndex (act matrix (internalAt point.1)) < 78 :=
    SymmetricSquare.internalIndex_lt
      (SymmetricSquare.act_mem_internalCoordinateList matrix_mem
        (SymmetricSquare.internalAt_mem_internalCoordinateList point))
  have images (point : Coordinate) :
      (matrixAction index point).val = internalIndex (act matrix (internalAt point.1)) := by
    show (Fin.ofNat 78
        (internalIndex (act (projectiveMatrices.get index) (internalAt point.1)))).val
      = internalIndex (act matrix (internalAt point.1))
    rw [index_eq]
    exact ofNat_val (bounds point)
  have second_eq : internalIndex (act matrix (internalAt (anchors 1).1)) = second.1 ∧
      internalIndex (act matrix (internalAt (anchors 2).1)) = third.1 := by
    have expanded : internalIndex (act matrix (internalAt (anchors 1).1)) * 78
        + internalIndex (act matrix (internalAt (anchors 2).1)) = second.1 * 78 + third.1 := bit_eq
    have left := bounds (anchors 2)
    have right := third.isLt
    omega
  refine ⟨index, ?_⟩
  have first_image : matrixAction index (anchors 0) = first :=
    Fin.ext ((images (anchors 0)).trans row_eq)
  have second_image : matrixAction index (anchors 1) = second :=
    Fin.ext ((images (anchors 1)).trans second_eq.1)
  have third_image : matrixAction index (anchors 2) = third :=
    Fin.ext ((images (anchors 2)).trans second_eq.2)
  rw [first_image, second_image, third_image]

/-- Distinct normalized projective matrices carry the first three anchors to distinct triples. -/
theorem anchorImageTriple_injective :
    Function.Injective fun matrix : Fin projectiveMatrices.length =>
      (matrixAction matrix (anchors 0), matrixAction matrix (anchors 1),
        matrixAction matrix (anchors 2)) := by
  have bounds : ∀ matrix ∈ projectiveMatrices,
      anchorImageRow matrix < (List.replicate 78 (0 : Nat)).length := by
    intro matrix matrix_mem
    rw [anchorImageRow_eq]
    simpa using SymmetricSquare.internalIndex_lt
      (SymmetricSquare.act_mem_internalCoordinateList matrix_mem
        (SymmetricSquare.internalAt_mem_internalCoordinateList (anchors 0)))
  have pairwise := pairwise_of_scan anchorImageRow anchorImageBit projectiveMatrices
    (List.replicate 78 0, true) bounds anchorImages_are_distinct
  have entries (index : Fin projectiveMatrices.length) :
      anchorImageRow projectiveMatrices[index.val] = (matrixAction index (anchors 0)).val ∧
        anchorImageBit projectiveMatrices[index.val] =
          (matrixAction index (anchors 1)).val * 78 + (matrixAction index (anchors 2)).val := by
    have matrix_mem := List.getElem_mem index.isLt
    have value (point : Coordinate) :
        (matrixAction index point).val
          = internalIndex (act projectiveMatrices[index.val] (internalAt point.1)) := by
      show (Fin.ofNat 78
          (internalIndex (act (projectiveMatrices.get index) (internalAt point.1)))).val
        = internalIndex (act projectiveMatrices[index.val] (internalAt point.1))
      exact ofNat_val (SymmetricSquare.internalIndex_lt
        (SymmetricSquare.act_mem_internalCoordinateList matrix_mem
          (SymmetricSquare.internalAt_mem_internalCoordinateList point)))
    exact ⟨by rw [anchorImageRow_eq, value (anchors 0)],
      by rw [anchorImageBit_eq, value (anchors 1), value (anchors 2)]⟩
  intro i j equal
  by_contra different
  simp only [Prod.mk.injEq] at equal
  have same_row : anchorImageRow projectiveMatrices[i.val] = anchorImageRow projectiveMatrices[j.val] := by
    rw [(entries i).1, (entries j).1, equal.1]
  have same_bit : anchorImageBit projectiveMatrices[i.val] = anchorImageBit projectiveMatrices[j.val] := by
    rw [(entries i).2, (entries j).2, equal.2.1, equal.2.2]
  have separated : ∀ m n : Fin projectiveMatrices.length, m.val < n.val →
      anchorImageRow projectiveMatrices[m.val] ≠ anchorImageRow projectiveMatrices[n.val] ∨
        anchorImageBit projectiveMatrices[m.val] ≠ anchorImageBit projectiveMatrices[n.val] :=
    fun m n lt => (List.pairwise_iff_getElem.mp pairwise) m.val n.val m.isLt n.isLt lt
  rcases Nat.lt_trichotomy i.val j.val with lt | eq | gt
  · rcases separated i j lt with row | bit
    · exact row same_row
    · exact bit same_bit
  · exact different (Fin.ext eq)
  · rcases separated j i gt with row | bit
    · exact row same_row.symm
    · exact bit same_bit.symm

end PassantCodeQ13.Automorphisms
