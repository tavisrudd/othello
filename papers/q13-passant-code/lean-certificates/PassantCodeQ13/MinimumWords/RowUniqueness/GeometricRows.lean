import PassantCodeQ13.MinimumWords.RowUniqueness.ConcurrenceTransport
import PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate
import PassantCodeQ13.WeightTen.PencilTransport

/-!
# Zero triple concurrence on the geometric passant rows

Every passant row carries seven internal points, and no minimum-word support contains three of them.
The finite content of that statement is the blockwise kernel check
`PassantCodeQ13.MinimumWords.geometric_rows_have_zero_triple_signatures`, which ranges over the
displayed row codes and the three-element sublists of their point lists.  This module transports it
to the subtype presentation: three distinct internal points on one passant line have concurrence
zero in the decoded minimum-word hypergraph.

The transport needs two elementary facts.  Three increasing indices lying on a row form a sublist of
that row's increasing point list, which is the general statement that an increasing list contained
in an increasing list is a sublist of it; and the concurrence count is unchanged by permuting its
three arguments, which reduces an arbitrary distinct triple to an increasing one.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.WeightTen

/-- An increasing list contained in an increasing list is a sublist of it. -/
private theorem sorted_sublist_of_subset : ∀ (larger smaller : List Nat),
    smaller.Pairwise (· < ·) → larger.Pairwise (· < ·) → (∀ index ∈ smaller, index ∈ larger) →
      smaller.Sublist larger
  | [], smaller, _, _, subset => by
      match smaller with
      | [] => exact List.Sublist.refl []
      | first :: _ => exact absurd (subset first (by simp)) (by simp)
  | head :: tail, smaller, sorted_smaller, sorted_larger, subset => by
      match smaller with
      | [] => exact List.nil_sublist _
      | first :: rest =>
        have head_lt : ∀ index ∈ tail, head < index := (List.pairwise_cons.mp sorted_larger).1
        have first_lt : ∀ index ∈ rest, first < index := (List.pairwise_cons.mp sorted_smaller).1
        by_cases first_eq : first = head
        · subst first_eq
          refine List.Sublist.cons_cons first ?_
          refine sorted_sublist_of_subset tail rest (List.pairwise_cons.mp sorted_smaller).2
            (List.pairwise_cons.mp sorted_larger).2 ?_
          intro index index_mem
          rcases List.mem_cons.mp (subset index (List.mem_cons_of_mem _ index_mem)) with
            equal | mem
          · exact absurd (first_lt index index_mem) (by omega)
          · exact mem
        · have first_mem_tail : first ∈ tail := by
            rcases List.mem_cons.mp (subset first (by simp)) with equal | mem
            · exact absurd equal first_eq
            · exact mem
          refine List.Sublist.cons head ?_
          refine sorted_sublist_of_subset tail (first :: rest) sorted_smaller
            (List.pairwise_cons.mp sorted_larger).2 ?_
          intro index index_mem
          rcases List.mem_cons.mp (subset index index_mem) with equal | mem
          · have head_lt_index : head < index := by
              rcases List.mem_cons.mp index_mem with equal_first | mem_rest
              · exact equal_first ▸ head_lt first first_mem_tail
              · exact lt_trans (head_lt first first_mem_tail) (first_lt index mem_rest)
            exact absurd equal (by omega)
          · exact mem

/-- Triple concurrence is unchanged when the last two indices are exchanged. -/
private theorem tripleConcurrenceIn_swap_last (supports : List Nat) (first second third : Nat) :
    tripleConcurrenceIn supports first second third =
      tripleConcurrenceIn supports first third second := by
  unfold tripleConcurrenceIn
  congr 1
  funext support
  simp [Bool.and_assoc, Bool.and_comm, Bool.and_left_comm]

/-- Triple concurrence is unchanged when the first two indices are exchanged. -/
private theorem tripleConcurrenceIn_swap_first (supports : List Nat) (first second third : Nat) :
    tripleConcurrenceIn supports first second third =
      tripleConcurrenceIn supports second first third := by
  unfold tripleConcurrenceIn
  congr 1
  funext support
  simp [Bool.and_assoc, Bool.and_comm]

/-- The displayed passant row codes are the row bit sets read from the packed incidence table. -/
theorem passantRowCodes_eq_masks : passantRowCodes = (List.range 78).map passantRowMask := by
  rw [passantRowCodes, ← tabulatedPassantRowCodesOn_eq _ fun line mem => List.mem_range.mp mem]
  rfl

/-- The point list of a displayed row is the list of indices its bit set selects. -/
theorem passantRowPoints_eq_filter (line : Nat) :
    (List.range 78).filter (passantRowMask line).testBit = passantRowPoints line := by
  refine List.filter_congr fun point point_mem => ?_
  simp [testBit_passantRowMask, List.mem_range.mp point_mem]

/-- Three increasing indices on one displayed row have zero concurrence in the minimum-word
supports. -/
private theorem tripleConcurrenceIn_eq_zero_of_increasing_on_row {line first second third : Nat}
    (line_lt : line < 78) (first_lt : first < 78) (second_lt : second < 78) (third_lt : third < 78)
    (first_lt_second : first < second) (second_lt_third : second < third)
    (first_incident : tabulatedIncidentAt line first = true)
    (second_incident : tabulatedIncidentAt line second = true)
    (third_incident : tabulatedIncidentAt line third = true) :
    tripleConcurrenceIn minimumSupportCodes first second third = 0 := by
  have row_check : rowTripleCheckOn minimumSupportCodes passantRowCodes = true :=
    geometric_rows_have_zero_triple_signatures.2
  have row_mem : passantRowMask line ∈ passantRowCodes := by
    rw [passantRowCodes_eq_masks]
    exact List.mem_map.mpr ⟨line, List.mem_range.mpr line_lt, rfl⟩
  have row_data := (List.all_eq_true.mp row_check) (passantRowMask line) row_mem
  have triple_check := (Bool.and_eq_true ..).mp row_data
  have selected : ∀ index, index < 78 → tabulatedIncidentAt line index = true →
      index ∈ (List.range 78).filter (passantRowMask line).testBit := by
    intro index index_lt incident
    refine List.mem_filter.mpr ⟨List.mem_range.mpr index_lt, ?_⟩
    simp [testBit_passantRowMask, index_lt, incident]
  have sublist : ([first, second, third] : List Nat).Sublist
      ((List.range 78).filter (passantRowMask line).testBit) := by
    refine sorted_sublist_of_subset _ _ (by simp [first_lt_second, second_lt_third,
      lt_trans first_lt_second second_lt_third])
      (List.pairwise_lt_range.filter _) ?_
    intro index index_mem
    rcases List.mem_cons.mp index_mem with equal | index_mem
    · exact equal ▸ selected first first_lt first_incident
    rcases List.mem_cons.mp index_mem with equal | index_mem
    · exact equal ▸ selected second second_lt second_incident
    · rw [List.mem_singleton.mp index_mem]
      exact selected third third_lt third_incident
  have triple_mem : ([first, second, third] : List Nat) ∈
      ((List.range 78).filter (passantRowMask line).testBit).sublistsLen 3 :=
    List.mem_sublistsLen.mpr ⟨sublist, rfl⟩
  have zero := (List.all_eq_true.mp triple_check.2) [first, second, third] triple_mem
  simpa using zero

/-- Three distinct indices on one displayed row have zero concurrence in the minimum-word
supports. -/
private theorem tripleConcurrenceIn_eq_zero_on_row {line first second third : Nat}
    (line_lt : line < 78) (first_lt : first < 78) (second_lt : second < 78) (third_lt : third < 78)
    (first_ne_second : first ≠ second) (first_ne_third : first ≠ third)
    (second_ne_third : second ≠ third)
    (first_incident : tabulatedIncidentAt line first = true)
    (second_incident : tabulatedIncidentAt line second = true)
    (third_incident : tabulatedIncidentAt line third = true) :
    tripleConcurrenceIn minimumSupportCodes first second third = 0 := by
  have increasing := fun {a b c : Nat} (a_lt : a < 78) (b_lt : b < 78) (c_lt : c < 78)
      (a_lt_b : a < b) (b_lt_c : b < c) (a_incident : tabulatedIncidentAt line a = true)
      (b_incident : tabulatedIncidentAt line b = true)
      (c_incident : tabulatedIncidentAt line c = true) =>
    tripleConcurrenceIn_eq_zero_of_increasing_on_row (line := line) line_lt a_lt b_lt c_lt a_lt_b
      b_lt_c a_incident b_incident c_incident
  rcases Nat.lt_or_ge first second with first_lt_second | second_le_first
  · rcases Nat.lt_or_ge second third with second_lt_third | third_le_second
    · exact increasing first_lt second_lt third_lt first_lt_second second_lt_third
        first_incident second_incident third_incident
    · have third_lt_second : third < second := Nat.lt_of_le_of_ne third_le_second
        (Ne.symm second_ne_third)
      rcases Nat.lt_or_ge first third with first_lt_third | third_le_first
      · rw [tripleConcurrenceIn_swap_last]
        exact increasing first_lt third_lt second_lt first_lt_third third_lt_second
          first_incident third_incident second_incident
      · have third_lt_first : third < first := Nat.lt_of_le_of_ne third_le_first (Ne.symm first_ne_third)
        rw [tripleConcurrenceIn_swap_last, tripleConcurrenceIn_swap_first]
        exact increasing third_lt first_lt second_lt third_lt_first first_lt_second
          third_incident first_incident second_incident
  · have second_lt_first : second < first := Nat.lt_of_le_of_ne second_le_first first_ne_second.symm
    rcases Nat.lt_or_ge first third with first_lt_third | third_le_first
    · rw [tripleConcurrenceIn_swap_first]
      exact increasing second_lt first_lt third_lt second_lt_first first_lt_third
        second_incident first_incident third_incident
    · have third_lt_first : third < first := Nat.lt_of_le_of_ne third_le_first (Ne.symm first_ne_third)
      rcases Nat.lt_or_ge second third with second_lt_third | third_le_second
      · rw [tripleConcurrenceIn_swap_first, tripleConcurrenceIn_swap_last]
        exact increasing second_lt third_lt first_lt second_lt_third third_lt_first
          second_incident third_incident first_incident
      · have third_lt_second : third < second :=
          Nat.lt_of_le_of_ne third_le_second (Ne.symm second_ne_third)
        rw [tripleConcurrenceIn_swap_last, tripleConcurrenceIn_swap_first,
          tripleConcurrenceIn_swap_last]
        exact increasing third_lt second_lt first_lt third_lt_second second_lt_first
          third_incident second_incident first_incident

/-- Every geometric passant row has zero triple concurrence in the decoded minimum layer. -/
theorem geometric_rows_have_zero_triple_concurrence :
    GeometricRowsHaveZeroTripleConcurrence := by
  intro line first second third first_incident second_incident third_incident
    first_ne_second first_ne_third second_ne_third
  obtain ⟨lineIndex, rfl⟩ := passantLineAt_bijective.surjective line
  obtain ⟨firstIndex, rfl⟩ := internalPointAt_bijective.surjective first
  obtain ⟨secondIndex, rfl⟩ := internalPointAt_bijective.surjective second
  obtain ⟨thirdIndex, rfl⟩ := internalPointAt_bijective.surjective third
  rw [← indexedTripleConcurrence_eq_semantic, indexedTripleConcurrence,
    internalPointIndex_internalPointAt, internalPointIndex_internalPointAt,
    internalPointIndex_internalPointAt]
  have indexed_incident : ∀ {index : Fin 78},
      Incident (passantLineAt lineIndex) (internalPointAt index) →
        tabulatedIncidentAt lineIndex.1 index.1 = true := by
    intro index incident
    rw [tabulatedIncidentAt_eq_incidentAt lineIndex.2 index.2]
    exact (PencilTransport.incidentAt_iff lineIndex index).mpr incident
  exact tripleConcurrenceIn_eq_zero_on_row lineIndex.2 firstIndex.2 secondIndex.2 thirdIndex.2
    (fun equality => first_ne_second (congrArg internalPointAt (Fin.ext equality)))
    (fun equality => first_ne_third (congrArg internalPointAt (Fin.ext equality)))
    (fun equality => second_ne_third (congrArg internalPointAt (Fin.ext equality)))
    (indexed_incident first_incident) (indexed_incident second_incident)
    (indexed_incident third_incident)

end PassantCodeQ13.MinimumWords.RowUniqueness
