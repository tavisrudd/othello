import PassantCodeQ13.WeightTen.Base

/-!
# Constant-time incidence between indexed passants and indexed internal points

`incidentAt` reads a passant coordinate and an internal coordinate out of their normalized lists
before evaluating the bilinear form, so each query costs a traversal of both lists.  A check that
ranges over all passant–point pairs, or that asks for each pair of internal points whether some
passant joins them, therefore spends most of its reduction on list traversal.

This module packs the whole incidence relation into one natural number: the bit at position
`78 * line + point` records whether the passant of index `line` contains the internal point of
index `point`.  A query is one shift and one mask.  Agreement with `incidentAt` is checked by
kernel reduction over all 6084 pairs of indices below 78, which is exhaustive for the indices the
relation is used at.
-/

namespace PassantCodeQ13

open PassantCodeQ13.WeightTen

/-- The incidence relation of the indexed passants and internal points, packed one bit per pair. -/
def indexedIncidenceTable : Nat :=
  (List.range 78).foldl (fun table line =>
    table ||| ((List.range 78).foldl (fun row point =>
      if incidentAt line point then row ||| (1 <<< point) else row) 0) <<< (78 * line)) 0

/-- Incidence of an indexed passant and an indexed internal point, read from the packed table. -/
def tabulatedIncidentAt (line point : Nat) : Bool :=
  (indexedIncidenceTable >>> (78 * line + point)) &&& 1 == 1

/-- The packed table reproduces the coordinate incidence test at every pair of indices below 78. -/
theorem tabulatedIncidentAt_agrees_below_78 :
    (List.range 78).all (fun line =>
      (List.range 78).all fun point => tabulatedIncidentAt line point == incidentAt line point) =
      true := by
  decide +kernel

/-- The packed table reproduces the coordinate incidence test at indices below 78. -/
theorem tabulatedIncidentAt_eq_incidentAt {line point : Nat} (hline : line < 78)
    (hpoint : point < 78) :
    tabulatedIncidentAt line point = incidentAt line point := by
  have row := List.all_eq_true.mp tabulatedIncidentAt_agrees_below_78 line
    (List.mem_range.mpr hline)
  have := List.all_eq_true.mp row point (List.mem_range.mpr hpoint)
  simpa using this

end PassantCodeQ13
