import PassantCodeQ13.MinimumWords.NormalizedIndexTable
import PassantCodeQ13.MinimumWords.OrbitData

/-!
# Bounded certificates for the four minimum-word orbits

For a displayed twelve-point representative, the semantic projective orbit expands its image under
all 2184 normalized matrices and removes repetitions.  Reducing that expansion in one declaration
exceeds the clean-build memory envelope.  The generated matrix-orbit index tables give the position,
in the corresponding displayed 91-support orbit, of the image under each normalized matrix.

`orbitImageBlockCheck` compares one consecutive block of matrices with one such table by kernel
reduction.  Fourteen separately elaborated matrix blocks cover the complete matrix list.  The symbolic
lemmas below assemble those block checks into equality of the full expansion; a final check that the
indexed expansion removes duplicates to the displayed orbit establishes the original semantic orbit
identity.  The generated tables carry no trust: every entry is checked against the projective action.
-/

namespace PassantCodeQ13.MinimumWords

open RelativeConicArcs.PassantCodeQ13

/-- A zero matrix used only as the out-of-range fallback of total list lookup. -/
private def zeroMatrix : Matrix2 := ⟨0, 0, 0, 0⟩

/-- The encoded image of a displayed support under the matrix at one position of the normalized
projective matrix list. -/
def orbitImageAt (support : List Triple) (index : Nat) : Nat :=
  tabulatedEncodeSupport (support.map (act (projectiveMatrices.getD index zeroMatrix)))

/-- Read a generated matrix-orbit index table through its displayed orbit. -/
def orbitIndexedImageAt (orbit indices : List Nat) (index : Nat) : Nat :=
  orbit.getD (indices.getD index 0) 0

/-- Exhaustive comparison of one consecutive matrix block with a generated orbit-index table. -/
def orbitImageBlockCheck (support : List Triple) (orbit indices : List Nat)
    (start count : Nat) : Bool :=
  (List.range count).all fun offset =>
    tabulatedEncodeSupport (support.map
      (act ((projectiveMatrices.drop start).getD offset zeroMatrix))) ==
      orbit.getD ((indices.drop start).getD offset 0) 0

/-- A successful block check gives the image identity at every offset in that block. -/
theorem orbitImageBlockCheck_sound {support : List Triple} {orbit indices : List Nat}
    {start count : Nat} (checked : orbitImageBlockCheck support orbit indices start count = true)
    {offset : Nat} (offset_lt : offset < count) :
    tabulatedEncodeSupport (support.map
      (act ((projectiveMatrices.drop start).getD offset zeroMatrix))) =
      orbit.getD ((indices.drop start).getD offset 0) 0 := by
  have at_offset := List.all_eq_true.mp checked offset (List.mem_range.mpr offset_lt)
  exact eq_of_beq at_offset

/-- The normalized projective matrix list has fourteen blocks of 156 matrices. -/
theorem projectiveMatrices_length_orbitCertificate : projectiveMatrices.length = 2184 := by
  decide +kernel

/-- Reading a list inside its range is reading the entry at that index. -/
private theorem getD_of_lt {α : Type*} {rows : List α} {index : Nat} (default : α)
    (inRange : index < rows.length) : rows.getD index default = rows[index] :=
  (List.getElem_eq_getD default).symm

/-- A local lookup in a dropped list is the corresponding absolute lookup. -/
private theorem getD_drop_of_add_lt {α : Type*} {rows : List α} {start offset : Nat}
    (default : α) (inRange : start + offset < rows.length) :
    (rows.drop start).getD offset default = rows.getD (start + offset) default := by
  have dropped : offset < (rows.drop start).length := by
    simp only [List.length_drop]
    omega
  rw [getD_of_lt default dropped, getD_of_lt default inRange]
  simp

/-- Reading a mapped list inside its range applies the map to the entry read. -/
private theorem getD_map_of_lt {α β : Type*} (function : α → β) (rows : List α)
    (inputDefault : α) (outputDefault : β) {index : Nat} (inRange : index < rows.length) :
    (rows.map function).getD index outputDefault = function (rows.getD index inputDefault) := by
  have mapped : index < (rows.map function).length := by simpa using inRange
  rw [getD_of_lt outputDefault mapped, getD_of_lt inputDefault inRange, List.getElem_map]

/-- The generated index table read through its displayed orbit. -/
def orbitIndexExpansion (orbit indices : List Nat) : List Nat :=
  indices.map fun index => orbit.getD index 0

/-- Fourteen checked blocks cover every position of the normalized matrix list. -/
theorem orbitImage_eq_of_blockFamily {support : List Triple} {orbit indices : List Nat}
    (indices_length : indices.length = 2184)
    (checked : ∀ block : Fin 14,
      orbitImageBlockCheck support orbit indices (block.1 * 156) 156 = true)
    {index : Nat} (index_lt : index < 2184) :
    orbitImageAt support index = orbitIndexedImageAt orbit indices index := by
  have block_lt : index / 156 < 14 := by omega
  let block : Fin 14 := ⟨index / 156, block_lt⟩
  have offset_lt : index % 156 < 156 := Nat.mod_lt _ (by omega)
  have at_offset := orbitImageBlockCheck_sound (checked block) offset_lt
  have recombine : block.1 * 156 + index % 156 = index := by
    dsimp [block]
    omega
  have matrixRange : block.1 * 156 + index % 156 < projectiveMatrices.length := by
    rw [recombine, projectiveMatrices_length_orbitCertificate]
    exact index_lt
  have indexRange : block.1 * 156 + index % 156 < indices.length := by
    rw [recombine, indices_length]
    exact index_lt
  rw [getD_drop_of_add_lt zeroMatrix matrixRange, getD_drop_of_add_lt 0 indexRange,
    recombine] at at_offset
  exact at_offset

/-- The checked blocks identify the full matrix expansion with the displayed orbit read through the
generated index table. -/
theorem tabulatedSupportImages_eq_indexExpansion {support : List Triple} {orbit indices : List Nat}
    (indices_length : indices.length = 2184)
    (checked : ∀ block : Fin 14,
      orbitImageBlockCheck support orbit indices (block.1 * 156) 156 = true) :
    projectiveMatrices.map (fun matrix => tabulatedEncodeSupport (support.map (act matrix))) =
      orbitIndexExpansion orbit indices := by
  apply List.ext_getElem
  · simp [orbitIndexExpansion, projectiveMatrices_length_orbitCertificate, indices_length]
  · intro index leftBound rightBound
    unfold orbitIndexExpansion at rightBound ⊢
    rw [← getD_of_lt 0 leftBound, ← getD_of_lt 0 rightBound,
      getD_map_of_lt _ projectiveMatrices zeroMatrix 0
        (by simpa [projectiveMatrices_length_orbitCertificate] using leftBound),
      getD_map_of_lt _ indices 0 0 (by simpa [indices_length] using rightBound)]
    exact orbitImage_eq_of_blockFamily indices_length checked
      (by simpa [projectiveMatrices_length_orbitCertificate] using leftBound)

/-- Bounded matrix checks plus duplicate removal of the indexed expansion establish equality with
the semantic projective orbit. -/
theorem tabulatedSupportOrbit_eq_of_blockFamily {support : List Triple} {orbit indices : List Nat}
    (indices_length : indices.length = 2184)
    (checked : ∀ block : Fin 14,
      orbitImageBlockCheck support orbit indices (block.1 * 156) 156 = true)
    (deduplicated : (orbitIndexExpansion orbit indices).eraseDups = orbit) :
    tabulatedSupportOrbit support = orbit := by
  change (projectiveMatrices.map
    (fun matrix => tabulatedEncodeSupport (support.map (act matrix)))).eraseDups = orbit
  rw [tabulatedSupportImages_eq_indexExpansion indices_length checked, deduplicated]

end PassantCodeQ13.MinimumWords
