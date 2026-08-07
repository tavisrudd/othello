import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-!
# The internal points of a passant row, as a bit set and as an increasing list

The `78` passant lines and the `78` internal points of the standard conic over `ZMod 13` are indexed
by their positions in the displayed coordinate lists, and their incidence is read from the packed
table of `PassantCodeQ13.IndexedIncidenceTable`.  This module carries the row of one passant in the
two presentations that the semantic transports consume: `passantRowMask line` is the bit set of the
internal-point indices incident to the passant of index `line`, accumulated by
`rowMaskBelow` over the indices below a bound, and `passantRowPoints line` is the same row as the
increasing list of those indices.

The characterization `testBit_passantRowMask` is proved by induction on the bound and identifies a
set bit with incidence at an index below `78`.  No finite search occurs here.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open PassantCodeQ13.WeightTen

/-- A bit of a union accumulated over a list of bit sets is set exactly where one selected member
has it. -/
private theorem testBit_foldl_lor (select : Nat → Bool) (bit : Nat) :
    ∀ (elements : List Nat) (initial : Nat),
      (elements.foldl (fun mask element =>
          if select element then mask ||| element else mask) initial).testBit bit =
        (initial.testBit bit ||
          elements.any fun element => select element && element.testBit bit)
  | [], initial => by simp
  | element :: rest, initial => by
      rw [List.foldl_cons, testBit_foldl_lor select bit rest, List.any_cons]
      by_cases selected : select element = true
      · rw [if_pos selected, Nat.testBit_or, selected]
        simp [Bool.or_assoc]
      · have not_selected : select element = false := by simpa using selected
        rw [if_neg selected, not_selected]
        simp

/-- The internal points on the passant of one index whose own index is below a bound, as a bit
set. -/
def rowMaskBelow (bound line : Nat) : Nat :=
  (List.range bound).foldl (fun mask point =>
    if tabulatedIncidentAt line point then mask ||| (1 <<< point) else mask) 0

/-- Raising the bound by one adds the point of that index when it lies on the row. -/
private theorem rowMaskBelow_succ (bound line : Nat) :
    rowMaskBelow (bound + 1) line =
      if tabulatedIncidentAt line bound then rowMaskBelow bound line ||| (1 <<< bound)
      else rowMaskBelow bound line := by
  rw [rowMaskBelow, List.range_succ, List.foldl_append]
  rfl

/-- A row bit is set exactly at the incident points below the bound. -/
private theorem testBit_rowMaskBelow (bound line point : Nat) :
    (rowMaskBelow bound line).testBit point =
      (decide (point < bound) && tabulatedIncidentAt line point) := by
  induction bound with
  | zero => simp [rowMaskBelow]
  | succ bound induction_hypothesis =>
      rw [rowMaskBelow_succ]
      by_cases incident : tabulatedIncidentAt line bound = true
      · rw [if_pos incident, Nat.testBit_or, induction_hypothesis,
          show (1 <<< bound) = 2 ^ bound by simp [Nat.shiftLeft_eq],
          Nat.testBit_two_pow]
        rcases Nat.lt_trichotomy point bound with below | equal | above
        · have : point < bound + 1 := by omega
          simp [below, this, Nat.ne_of_gt below]
        · subst equal
          simp [incident]
        · have : ¬point < bound + 1 := by omega
          simp [Nat.not_lt_of_gt above, this, Nat.ne_of_lt above]
      · have not_incident : tabulatedIncidentAt line bound = false := by simpa using incident
        rw [if_neg incident, induction_hypothesis]
        rcases Nat.lt_trichotomy point bound with below | equal | above
        · have : point < bound + 1 := by omega
          simp [below, this]
        · subst equal
          simp [not_incident]
        · have : ¬point < bound + 1 := by omega
          simp [Nat.not_lt_of_gt above, this]

/-- The internal points on the passant of one index, as a bit set of internal-point indices. -/
def passantRowMask (line : Nat) : Nat := rowMaskBelow 78 line

/-- A row bit is set exactly at the incident internal-point indices. -/
theorem testBit_passantRowMask (line point : Nat) :
    (passantRowMask line).testBit point =
      (decide (point < 78) && tabulatedIncidentAt line point) :=
  testBit_rowMaskBelow 78 line point

/-- The internal points of one displayed passant row, in increasing order of index. -/
def passantRowPoints (line : Nat) : List Nat :=
  (List.range 78).filter (tabulatedIncidentAt line)

end PassantCodeQ13.MinimumWords.RowUniqueness
