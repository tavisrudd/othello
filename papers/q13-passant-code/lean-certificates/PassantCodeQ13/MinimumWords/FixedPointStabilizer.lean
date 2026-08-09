import PassantCodeQ13.MinimumWords.Reconstruction

/-!
# Structural fixed-point stabilizer orbits

The generated `28 × 78` table records the image index of every internal point under every
normalized projective matrix fixing internal point zero.  Lean checks every entry against the
symmetric-square action.  A symbolic fold argument then identifies table action with semantic
action on every encoded support.  Only the four compact table-orbit comparisons are reduced.
-/

namespace PassantCodeQ13.MinimumWords

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.WeightTen

/-- The 28 projective transformations fixing the normalized internal point of index zero. -/
def fixedPointStabilizer : List Matrix2 :=
  projectiveMatrices.filter fun matrix =>
    internalIndex (act matrix (internalAt 0)) == 0

/-- Image of an encoded support under the symmetric-square projective action. -/
def actOnSupportCode (matrix : Matrix2) (support : Nat) : Nat :=
  (List.range 78).foldl (fun image point =>
    if support.testBit point then
      image ||| (1 <<< internalIndex (act matrix (internalAt point)))
    else image) 0

/-- Orbit of one encoded support under the fixed-point stabilizer. -/
def fixedPointStabilizerOrbit (support : Nat) : List Nat :=
  (fixedPointStabilizer.map fun matrix => actOnSupportCode matrix support).eraseDups

/-- Action of one generated point-index row on an encoded support. -/
def fixedPointTableActOnSupportCode (row : List Nat) (support : Nat) : Nat :=
  (List.range 78).foldl (fun image point =>
    if support.testBit point then image ||| (1 <<< row.getD point 0) else image) 0

/-- Table orbit of an encoded support under the 28 generated action-index rows. -/
def fixedPointStabilizerTableOrbit (support : Nat) : List Nat :=
  (fixedPointStabilizerActionIndices.map fun row =>
    fixedPointTableActOnSupportCode row support).eraseDups

/-- A zero matrix used only as the out-of-range fallback of total list lookup. -/
private def zeroMatrix : Matrix2 := ⟨0, 0, 0, 0⟩

/-- Compact exhaustive check of the generated `28 × 78` action-index table. -/
def fixedPointStabilizerActionTableCheck : Bool :=
  (List.range 28).all fun matrixIndex =>
    (List.range 78).all fun pointIndex =>
      (fixedPointStabilizerActionIndices.getD matrixIndex []).getD pointIndex 0 ==
        internalIndex (act (fixedPointStabilizer.getD matrixIndex zeroMatrix)
          (internalAt pointIndex))

/-- The fixed-point stabilizer has the expected order. -/
theorem fixedPointStabilizer_length : fixedPointStabilizer.length = 28 := by
  decide +kernel

/-- The generated table has one row per stabilizer element. -/
theorem fixedPointStabilizerActionIndices_length :
    fixedPointStabilizerActionIndices.length = 28 := by
  decide +kernel

/-- Every generated action-index entry agrees with the semantic symmetric-square action. -/
theorem fixedPointStabilizerActionTable_checked :
    fixedPointStabilizerActionTableCheck = true := by
  decide +kernel

/-- A checked generated entry is the semantic image index. -/
theorem fixedPointStabilizerActionTable_entry {matrixIndex pointIndex : Nat}
    (matrix_lt : matrixIndex < 28) (point_lt : pointIndex < 78) :
    (fixedPointStabilizerActionIndices.getD matrixIndex []).getD pointIndex 0 =
      internalIndex (act (fixedPointStabilizer.getD matrixIndex zeroMatrix)
        (internalAt pointIndex)) := by
  have matrix_checked := List.all_eq_true.mp fixedPointStabilizerActionTable_checked matrixIndex
    (List.mem_range.mpr matrix_lt)
  have point_checked := List.all_eq_true.mp matrix_checked pointIndex
    (List.mem_range.mpr point_lt)
  exact eq_of_beq point_checked

/-- Folding a checked table row gives the semantic action on every encoded support. -/
theorem actOnSupportCode_eq_tableRow (support : Nat) {matrixIndex : Nat}
    (matrix_lt : matrixIndex < 28) :
    actOnSupportCode (fixedPointStabilizer.getD matrixIndex zeroMatrix) support =
      fixedPointTableActOnSupportCode
        (fixedPointStabilizerActionIndices.getD matrixIndex []) support := by
  unfold actOnSupportCode fixedPointTableActOnSupportCode
  have fold_eq : ∀ (points : List Nat), (∀ point ∈ points, point < 78) → ∀ image : Nat,
      points.foldl (fun image point =>
        if support.testBit point then
          image ||| (1 <<< internalIndex
            (act (fixedPointStabilizer.getD matrixIndex zeroMatrix) (internalAt point)))
        else image) image =
      points.foldl (fun image point =>
        if support.testBit point then
          image ||| (1 <<<
            (fixedPointStabilizerActionIndices.getD matrixIndex []).getD point 0)
        else image) image := by
    intro points bounds image
    induction points generalizing image with
    | nil => rfl
    | cons point rest inductionHypothesis =>
        simp only [List.foldl_cons]
        rw [fixedPointStabilizerActionTable_entry matrix_lt (bounds point (by simp))]
        apply inductionHypothesis
        intro restPoint restPoint_mem
        exact bounds restPoint (by simp [restPoint_mem])
  exact fold_eq (List.range 78) (fun point point_mem => List.mem_range.mp point_mem) 0

/-- Reading a list inside its range is reading the entry at that index. -/
private theorem getD_of_lt {α : Type*} {rows : List α} {index : Nat} (default : α)
    (inRange : index < rows.length) : rows.getD index default = rows[index] :=
  (List.getElem_eq_getD default).symm

/-- Reading a mapped list inside its range applies the map to the entry read. -/
private theorem getD_map_of_lt {α β : Type*} (function : α → β) (rows : List α)
    (inputDefault : α) (outputDefault : β) {index : Nat} (inRange : index < rows.length) :
    (rows.map function).getD index outputDefault = function (rows.getD index inputDefault) := by
  have mapped : index < (rows.map function).length := by simpa using inRange
  rw [getD_of_lt outputDefault mapped, getD_of_lt inputDefault inRange, List.getElem_map]

/-- The semantic stabilizer images equal the images computed from the checked index rows. -/
theorem fixedPointStabilizerImages_eq_tableImages (support : Nat) :
    fixedPointStabilizer.map (fun matrix => actOnSupportCode matrix support) =
      fixedPointStabilizerActionIndices.map fun row =>
        fixedPointTableActOnSupportCode row support := by
  apply List.ext_getElem
  · simp [fixedPointStabilizer_length, fixedPointStabilizerActionIndices_length]
  · intro index leftBound rightBound
    rw [← getD_of_lt 0 leftBound, ← getD_of_lt 0 rightBound,
      getD_map_of_lt _ fixedPointStabilizer zeroMatrix 0
        (by simpa [fixedPointStabilizer_length] using leftBound),
      getD_map_of_lt _ fixedPointStabilizerActionIndices [] 0
        (by simpa [fixedPointStabilizerActionIndices_length] using rightBound)]
    exact actOnSupportCode_eq_tableRow support
      (by simpa [fixedPointStabilizer_length] using leftBound)

/-- Semantic and table stabilizer orbits agree on every encoded support. -/
theorem fixedPointStabilizerOrbit_eq_tableOrbit (support : Nat) :
    fixedPointStabilizerOrbit support = fixedPointStabilizerTableOrbit support := by
  unfold fixedPointStabilizerOrbit fixedPointStabilizerTableOrbit
  rw [fixedPointStabilizerImages_eq_tableImages]

/-- The checked table orbit of the symmetric representative is its displayed fixed-point slice. -/
theorem fixedPointTableOrbit_symmetric :
    (fixedPointStabilizerTableOrbit (encodeSupport representativeS4)).toFinset =
      (orbitSymmetricSupports.filter fun support => support.testBit 0).toFinset := by
  decide +kernel

/-- The checked table orbit of the first dihedral representative is its fixed-point slice. -/
theorem fixedPointTableOrbit_dihedralA :
    (fixedPointStabilizerTableOrbit (encodeSupport representativeDihedralA)).toFinset =
      (orbitDihedralASupports.filter fun support => support.testBit 0).toFinset := by
  decide +kernel

/-- The checked table orbit of the second dihedral representative is its fixed-point slice. -/
theorem fixedPointTableOrbit_dihedralB :
    (fixedPointStabilizerTableOrbit (encodeSupport representativeDihedralB)).toFinset =
      (orbitDihedralBSupports.filter fun support => support.testBit 0).toFinset := by
  decide +kernel

/-- The checked table orbit of the third dihedral representative is its fixed-point slice. -/
theorem fixedPointTableOrbit_dihedralC :
    (fixedPointStabilizerTableOrbit (encodeSupport representativeDihedralC)).toFinset =
      (orbitDihedralCSupports.filter fun support => support.testBit 0).toFinset := by
  decide +kernel

/-- The order-28 fixed-point stabilizer acts transitively on each 14-support orbit slice. -/
theorem fixedPoint_slices_are_stabilizer_orbits :
    fixedPointStabilizer.length = 28 ∧
      (fixedPointStabilizerOrbit (encodeSupport representativeS4)).toFinset =
        ((supportOrbit representativeS4).filter fun support => support.testBit 0).toFinset ∧
      (fixedPointStabilizerOrbit (encodeSupport representativeDihedralA)).toFinset =
        ((supportOrbit representativeDihedralA).filter fun support => support.testBit 0).toFinset ∧
      (fixedPointStabilizerOrbit (encodeSupport representativeDihedralB)).toFinset =
        ((supportOrbit representativeDihedralB).filter fun support => support.testBit 0).toFinset ∧
      (fixedPointStabilizerOrbit (encodeSupport representativeDihedralC)).toFinset =
        ((supportOrbit representativeDihedralC).filter fun support => support.testBit 0).toFinset := by
  rw [fixedPointStabilizerOrbit_eq_tableOrbit,
    fixedPointStabilizerOrbit_eq_tableOrbit,
    fixedPointStabilizerOrbit_eq_tableOrbit,
    fixedPointStabilizerOrbit_eq_tableOrbit,
    supportOrbit_representativeS4_eq,
    supportOrbit_representativeDihedralA_eq,
    supportOrbit_representativeDihedralB_eq,
    supportOrbit_representativeDihedralC_eq]
  exact ⟨fixedPointStabilizer_length, fixedPointTableOrbit_symmetric,
    fixedPointTableOrbit_dihedralA, fixedPointTableOrbit_dihedralB,
    fixedPointTableOrbit_dihedralC⟩

end PassantCodeQ13.MinimumWords
