import RelativeConicArcs.PassantCodeQ13.Geometry

/-!
# Pencils of passant and secant lines through the internal points of the standard conic

Fix the normalized coordinate model of `RelativeConicArcs.PassantCodeQ13.Geometry` for the conic
`XZ - Y^2 = 0` over `ZMod 13`: internal points are the normalized projective triples on which
`Y^2 - XZ` is a nonsquare, passant lines are the normalized dual triples on which `Y^2 - 4XZ` is a
nonsquare, secant lines are the normalized dual triples on which `Y^2 - 4XZ` is a nonzero square,
and a line contains a point exactly when the standard dot product of their coordinate triples
vanishes.

This module computes, for every internal point, the list of passant lines and the list of secant
lines through it, and dually the list of internal points on each passant line, and records four
finite incidence facts:

* each passant pencil has exactly seven members;
* two distinct internal points lie on at most one common passant line;
* two distinct internal points lie on no common passant line exactly when they lie on a common
  secant line;
* each passant line contains exactly seven internal points.

The facts are stated on the displayed coordinate lists and are decided by kernel reduction of a
pencil table over the 78 internal points and a row table over the 78 passant lines; the pairwise
statements then range over the ordered pairs of pencil-table entries.  No step uses native evaluation, an external certificate, or a
search over the ambient projective plane.  The transport of these statements to the subtypes
`InternalPoint` and `PassantLine` is carried out in
`RelativeConicArcs.PassantCodeQ13.PencilJoins`.
-/

namespace RelativeConicArcs.PassantCodeQ13

set_option maxRecDepth 20000

/-- The normalized secant lines of the standard conic, in the inherited dual-projective order. -/
def secantCoordinateList : List Triple :=
  projectiveTripleList.filter fun line =>
    lineDiscriminant line != 0 && isNonzeroSquare (lineDiscriminant line)

/-- The displayed secant-line list enumerates exactly the semantic secant coordinate finset. -/
theorem secantCoordinateList_toFinset :
    secantCoordinateList.toFinset = secantCoordinates := by
  decide +kernel

/-- The displayed passant lines containing a given normalized point. -/
def passantPencilList (point : Triple) : List Triple :=
  passantCoordinateList.filter fun line => lineValue line point == 0

/-- The displayed secant lines containing a given normalized point. -/
def secantPencilList (point : Triple) : List Triple :=
  secantCoordinateList.filter fun line => lineValue line point == 0

/-- The lines common to two displayed pencils. -/
def commonPencilLines (first second : List Triple) : List Triple :=
  first.filter fun line => second.contains line

/-- Each internal point together with its passant pencil and its secant pencil, in the displayed
order of the internal points. -/
def pencilTable : List (Triple × List Triple × List Triple) :=
  internalCoordinateList.map fun point => (point, passantPencilList point, secantPencilList point)

/-- The pencil table lists the two pencils of every displayed internal point. -/
theorem mem_pencilTable {point : Triple} (mem : point ∈ internalCoordinateList) :
    (point, passantPencilList point, secantPencilList point) ∈ pencilTable :=
  List.mem_map_of_mem mem

/-- Every internal point lies on exactly seven passant lines. -/
theorem pencilTable_passant_length :
    pencilTable.all (fun entry => entry.2.1.length == 7) = true := by
  decide +kernel

/-- Two distinct internal points lie on at most one common passant line. -/
theorem pencilTable_common_passant_length_le_one :
    pencilTable.all (fun first => pencilTable.all fun second =>
      first.1 == second.1 ||
        decide ((commonPencilLines first.2.1 second.2.1).length ≤ 1)) = true := by
  decide +kernel

/-- The displayed internal points lying on a given normalized dual line. -/
def passantRowList (line : Triple) : List Triple :=
  internalCoordinateList.filter fun point => lineValue line point == 0

/-- Each passant line together with the internal points on it, in the displayed order of the
passant lines. -/
def passantRowTable : List (Triple × List Triple) :=
  passantCoordinateList.map fun line => (line, passantRowList line)

/-- The row table lists the internal points of every displayed passant line. -/
theorem mem_passantRowTable {line : Triple} (mem : line ∈ passantCoordinateList) :
    (line, passantRowList line) ∈ passantRowTable :=
  List.mem_map_of_mem mem

/-- Every passant line contains exactly seven internal points. -/
theorem passantRowTable_length :
    passantRowTable.all (fun entry => entry.2.length == 7) = true := by
  decide +kernel

/-- Two distinct internal points lie on no common passant line exactly when they lie on a common
secant line. -/
theorem pencilTable_passant_secant_dichotomy :
    pencilTable.all (fun first => pencilTable.all fun second =>
      first.1 == second.1 ||
        ((commonPencilLines first.2.1 second.2.1).isEmpty ==
          !(commonPencilLines first.2.2 second.2.2).isEmpty)) = true := by
  decide +kernel

end RelativeConicArcs.PassantCodeQ13
