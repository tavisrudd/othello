import RelativeConicArcs.PassantCodeQ13.PencilIncidence

/-!
# Passant and secant joins of internal points, on the subtype model

The finite pencil facts of `RelativeConicArcs.PassantCodeQ13.PencilIncidence` are stated on the
displayed coordinate lists of the normalized `q = 13` model.  This module transports them to the
subtypes `InternalPoint`, `PassantLine`, and `WeightEight.SecantLine` used by the geometric
arguments: the passant pencil of an internal point has exactly seven members, two distinct internal
points are joined by at most one passant line, and two distinct internal points with no common
passant line have a common conic secant.

Nothing here performs a finite computation; every step is either a membership transport between a
displayed list and its coordinate finset, or a rearrangement of the corresponding list statement.
-/

namespace RelativeConicArcs.PassantCodeQ13

open Finset

/-- Every internal point occurs in the displayed internal-point list. -/
theorem mem_internalCoordinateList (point : InternalPoint) :
    point.1 ∈ internalCoordinateList := by
  rw [← List.mem_toFinset, internalCoordinateList_toFinset]
  exact point.2

/-- Every passant line occurs in the displayed passant-line list. -/
theorem mem_passantCoordinateList (line : PassantLine) :
    line.1 ∈ passantCoordinateList := by
  rw [← List.mem_toFinset, passantCoordinateList_toFinset]
  exact line.2

/-- Every secant line occurs in the displayed secant-line list. -/
theorem mem_secantCoordinateList (line : WeightEight.SecantLine) :
    line.1 ∈ secantCoordinateList := by
  rw [← List.mem_toFinset, secantCoordinateList_toFinset]
  exact line.2

/-- The displayed passant-line list repeats no coordinate triple. -/
theorem passantCoordinateList_nodup : passantCoordinateList.Nodup := by
  decide +kernel

/-- A displayed passant pencil repeats no coordinate triple. -/
theorem passantPencilList_nodup (point : Triple) : (passantPencilList point).Nodup :=
  passantCoordinateList_nodup.filter _

/-- Membership in a displayed passant pencil. -/
theorem mem_passantPencilList {line point : Triple} :
    line ∈ passantPencilList point ↔
      line ∈ passantCoordinateList ∧ WeightEight.lineValue line point = 0 := by
  simp [passantPencilList, List.mem_filter]

/-- Membership in a displayed secant pencil. -/
theorem mem_secantPencilList {line point : Triple} :
    line ∈ secantPencilList point ↔
      line ∈ secantCoordinateList ∧ WeightEight.lineValue line point = 0 := by
  simp [secantPencilList, List.mem_filter]

/-- Membership in the intersection of two displayed pencils. -/
theorem mem_commonPencilLines {line : Triple} {first second : List Triple} :
    line ∈ commonPencilLines first second ↔ line ∈ first ∧ line ∈ second := by
  simp [commonPencilLines, List.mem_filter]

/-- A list with at most one member has all its members equal. -/
private theorem eq_of_mem_of_length_le_one {α : Type*} {members : List α}
    (bound : members.length ≤ 1) {first second : α}
    (first_mem : first ∈ members) (second_mem : second ∈ members) : first = second := by
  match members with
  | [] => exact absurd first_mem (List.not_mem_nil)
  | [single] =>
    rw [List.mem_singleton] at first_mem second_mem
    rw [first_mem, second_mem]
  | _ :: _ :: _ => simp at bound

/-- Distinct internal points have distinct normalized coordinate triples. -/
private theorem distinct_coordinates {base point : InternalPoint} (distinct : point ≠ base) :
    ¬ (base.1 == point.1) = true := by
  simp only [beq_iff_eq]
  exact fun equal => distinct (Subtype.ext equal.symm)

/-- The passant pencil of an internal point has exactly seven members. -/
theorem passantPencilList_length (base : InternalPoint) :
    (passantPencilList base.1).length = 7 := by
  have table := List.all_eq_true.mp pencilTable_passant_length
  have entry := table _ (mem_pencilTable (mem_internalCoordinateList base))
  simpa using entry

/-- The set of passant lines through an internal point has cardinality seven. -/
theorem card_passantLines_through (base : InternalPoint) :
    (Finset.univ.filter fun line : PassantLine => Incident line base).card = 7 := by
  classical
  have card_eq : (Finset.univ.filter fun line : PassantLine => Incident line base).card
      = (passantPencilList base.1).toFinset.card := by
    refine Finset.card_bij (fun line _ => line.1) ?_ ?_ ?_
    · intro line mem
      exact List.mem_toFinset.mpr (mem_passantPencilList.mpr
        ⟨mem_passantCoordinateList line, (Finset.mem_filter.mp mem).2⟩)
    · intro first _ second _ equal
      exact Subtype.ext equal
    · intro target mem
      obtain ⟨list_mem, value⟩ := mem_passantPencilList.mp (List.mem_toFinset.mp mem)
      have coordinate : target ∈ passantCoordinates := by
        rw [← passantCoordinateList_toFinset]
        exact List.mem_toFinset.mpr list_mem
      exact ⟨⟨target, coordinate⟩, Finset.mem_filter.mpr ⟨Finset.mem_univ _, value⟩, rfl⟩
  rw [card_eq, List.toFinset_card_of_nodup (passantPencilList_nodup base.1)]
  exact passantPencilList_length base

/-- A passant line joins two internal points exactly when the displayed pencils of the two points
share a member. -/
theorem exists_common_passantLine_iff (base point : InternalPoint) :
    (∃ line : PassantLine, Incident line base ∧ Incident line point) ↔
      commonPencilLines (passantPencilList base.1) (passantPencilList point.1) ≠ [] := by
  constructor
  · rintro ⟨line, base_incident, point_incident⟩
    refine List.ne_nil_of_mem (a := line.1) (mem_commonPencilLines.mpr ⟨?_, ?_⟩)
    · exact mem_passantPencilList.mpr ⟨mem_passantCoordinateList line, base_incident⟩
    · exact mem_passantPencilList.mpr ⟨mem_passantCoordinateList line, point_incident⟩
  · intro nonempty
    obtain ⟨line, mem⟩ := List.exists_mem_of_ne_nil _ nonempty
    obtain ⟨base_mem, point_mem⟩ := mem_commonPencilLines.mp mem
    obtain ⟨list_mem, base_incident⟩ := mem_passantPencilList.mp base_mem
    obtain ⟨-, point_incident⟩ := mem_passantPencilList.mp point_mem
    have coordinate : line ∈ passantCoordinates := by
      rw [← passantCoordinateList_toFinset]
      exact List.mem_toFinset.mpr list_mem
    exact ⟨⟨line, coordinate⟩, base_incident, point_incident⟩

/-- A conic secant joins two internal points exactly when the displayed secant pencils of the two
points share a member. -/
theorem exists_common_secantLine_iff (base point : InternalPoint) :
    (∃ line : WeightEight.SecantLine,
        WeightEight.lineValue line.1 base.1 = 0 ∧ WeightEight.lineValue line.1 point.1 = 0) ↔
      commonPencilLines (secantPencilList base.1) (secantPencilList point.1) ≠ [] := by
  constructor
  · rintro ⟨line, base_value, point_value⟩
    refine List.ne_nil_of_mem (a := line.1) (mem_commonPencilLines.mpr ⟨?_, ?_⟩)
    · exact mem_secantPencilList.mpr ⟨mem_secantCoordinateList line, base_value⟩
    · exact mem_secantPencilList.mpr ⟨mem_secantCoordinateList line, point_value⟩
  · intro nonempty
    obtain ⟨line, mem⟩ := List.exists_mem_of_ne_nil _ nonempty
    obtain ⟨base_mem, point_mem⟩ := mem_commonPencilLines.mp mem
    obtain ⟨list_mem, base_value⟩ := mem_secantPencilList.mp base_mem
    obtain ⟨-, point_value⟩ := mem_secantPencilList.mp point_mem
    have coordinate : line ∈ WeightEight.secantCoordinates := by
      rw [← secantCoordinateList_toFinset]
      exact List.mem_toFinset.mpr list_mem
    exact ⟨⟨line, coordinate⟩, base_value, point_value⟩

/-- Two distinct internal points lie on at most one common passant line. -/
theorem passantLine_join_unique {base point : InternalPoint} (distinct : point ≠ base)
    {first second : PassantLine}
    (first_base : Incident first base) (first_point : Incident first point)
    (second_base : Incident second base) (second_point : Incident second point) :
    first = second := by
  have table := List.all_eq_true.mp pencilTable_common_passant_length_le_one
  have entry := List.all_eq_true.mp
    (table _ (mem_pencilTable (mem_internalCoordinateList base)))
    _ (mem_pencilTable (mem_internalCoordinateList point))
  have bound : (commonPencilLines (passantPencilList base.1) (passantPencilList point.1)).length
      ≤ 1 := by
    rcases Bool.or_eq_true_iff.mp entry with equal | small
    · exact absurd equal (distinct_coordinates distinct)
    · exact of_decide_eq_true small
  have first_mem : first.1 ∈
      commonPencilLines (passantPencilList base.1) (passantPencilList point.1) :=
    mem_commonPencilLines.mpr
      ⟨mem_passantPencilList.mpr ⟨mem_passantCoordinateList first, first_base⟩,
        mem_passantPencilList.mpr ⟨mem_passantCoordinateList first, first_point⟩⟩
  have second_mem : second.1 ∈
      commonPencilLines (passantPencilList base.1) (passantPencilList point.1) :=
    mem_commonPencilLines.mpr
      ⟨mem_passantPencilList.mpr ⟨mem_passantCoordinateList second, second_base⟩,
        mem_passantPencilList.mpr ⟨mem_passantCoordinateList second, second_point⟩⟩
  exact Subtype.ext (eq_of_mem_of_length_le_one bound first_mem second_mem)

/-- Two distinct internal points lie on no common passant line exactly when some conic secant
contains both. -/
theorem no_common_passantLine_iff_common_secantLine {base point : InternalPoint}
    (distinct : point ≠ base) :
    (¬ ∃ line : PassantLine, Incident line base ∧ Incident line point) ↔
      ∃ line : WeightEight.SecantLine,
        WeightEight.lineValue line.1 base.1 = 0 ∧ WeightEight.lineValue line.1 point.1 = 0 := by
  have table := List.all_eq_true.mp pencilTable_passant_secant_dichotomy
  have entry := List.all_eq_true.mp
    (table _ (mem_pencilTable (mem_internalCoordinateList base)))
    _ (mem_pencilTable (mem_internalCoordinateList point))
  have dichotomy :
      (commonPencilLines (passantPencilList base.1) (passantPencilList point.1)).isEmpty
        = !(commonPencilLines (secantPencilList base.1) (secantPencilList point.1)).isEmpty := by
    rcases Bool.or_eq_true_iff.mp entry with equal | dichotomy
    · exact absurd equal (distinct_coordinates distinct)
    · exact of_decide_eq_true (by simpa using dichotomy)
  rw [exists_common_passantLine_iff, exists_common_secantLine_iff, not_ne_iff]
  constructor
  · intro passant_empty secant_empty
    rw [passant_empty, secant_empty] at dichotomy
    simp at dichotomy
  · intro secant_nonempty
    by_contra passant_nonempty
    have passant_flag :
        (commonPencilLines (passantPencilList base.1) (passantPencilList point.1)).isEmpty
          = false := by
      simpa [List.isEmpty_iff] using passant_nonempty
    have secant_flag :
        (commonPencilLines (secantPencilList base.1) (secantPencilList point.1)).isEmpty
          = false := by
      simpa [List.isEmpty_iff] using secant_nonempty
    rw [passant_flag, secant_flag] at dichotomy
    simp at dichotomy

end RelativeConicArcs.PassantCodeQ13
