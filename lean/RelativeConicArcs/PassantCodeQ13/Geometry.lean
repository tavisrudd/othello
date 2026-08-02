import RelativeConicArcs.ConicPassantCode

/-!
# The passant incidence code of the standard conic over `ZMod 13`

This module fixes homogeneous representatives for the projective plane over `ZMod 13`.  A
representative is normalized by making its first nonzero coordinate equal to one.  Internal points
are the normalized triples on which `Y^2 - XZ` is a nonsquare, and passant lines are the normalized
dual triples on which `Y^2 - 4XZ` is a nonsquare.  Incidence is the vanishing of the standard dot
product.

The resulting binary code is the kernel of the passant-by-internal-point incidence matrix.  The
cardinality checks in this module use native evaluation on the explicitly bounded set of 183
normalized projective triples; they do not classify codewords or establish the rank or minimum
distance of the code.
-/

namespace RelativeConicArcs.PassantCodeQ13

open Finset

/-- The prime field used by the concrete conic model. -/
abbrev Field13 := ZMod 13

/-- A homogeneous coordinate triple, used for both points and dual lines. -/
structure Triple where
  x : Field13
  y : Field13
  z : Field13
deriving DecidableEq, Repr

/-- The normalized representative `(1,y,z)`. -/
def affineTriple (y z : Field13) : Triple := ⟨1, y, z⟩

/-- The normalized representative `(0,1,z)` on the line at infinity. -/
def infiniteTriple (z : Field13) : Triple := ⟨0, 1, z⟩

/-- The final normalized representative `(0,0,1)`. -/
def verticalTriple : Triple := ⟨0, 0, 1⟩

/-- The thirteen field elements in their standard integer order. -/
def fieldElements : List Field13 :=
  (List.range 13).map fun value => (value : Field13)

/-- The 183 normalized homogeneous representatives in affine-first order. -/
def projectiveTripleList : List Triple :=
  (fieldElements.flatMap fun y => fieldElements.map fun z => affineTriple y z) ++
    fieldElements.map infiniteTriple ++ [verticalTriple]

/-- All normalized homogeneous representatives of `PG(2,13)`. -/
def projectiveTriples : Finset Triple :=
  projectiveTripleList.toFinset

/-- The point-conic value `Y^2 - XZ` for the standard conic `XZ-Y^2=0`. -/
def pointDiscriminant (point : Triple) : Field13 :=
  point.y * point.y - point.x * point.z

/-- The dual-conic value `Y^2 - 4XZ`; its nonsquares represent passant lines. -/
def lineDiscriminant (line : Triple) : Field13 :=
  line.y * line.y - 4 * line.x * line.z

/-- The executable test for a nonzero square in `ZMod 13`. -/
def isNonzeroSquare (value : Field13) : Bool :=
  value == 1 || value == 3 || value == 4 || value == 9 || value == 10 || value == 12

/-- The normalized internal points of the standard nonsingular conic. -/
def internalCoordinates : Finset Triple :=
  projectiveTriples.filter fun point =>
    pointDiscriminant point ≠ 0 ∧ isNonzeroSquare (pointDiscriminant point) = false

/-- Internal points in the inherited normalized projective order. -/
def internalCoordinateList : List Triple :=
  projectiveTripleList.filter fun point =>
    pointDiscriminant point != 0 && !isNonzeroSquare (pointDiscriminant point)

/-- The normalized passant lines of the standard nonsingular conic. -/
def passantCoordinates : Finset Triple :=
  projectiveTriples.filter fun line =>
    lineDiscriminant line ≠ 0 ∧ isNonzeroSquare (lineDiscriminant line) = false

/-- Passant lines in the inherited normalized dual-projective order. -/
def passantCoordinateList : List Triple :=
  projectiveTripleList.filter fun line =>
    lineDiscriminant line != 0 && !isNonzeroSquare (lineDiscriminant line)

/-- An internal projective point in the fixed normalized coordinate model. -/
abbrev InternalPoint := {point : Triple // point ∈ internalCoordinates}

/-- A passant projective line in the fixed normalized dual coordinate model. -/
abbrev PassantLine := {line : Triple // line ∈ passantCoordinates}

/-- Incidence between a normalized dual line and a normalized point. -/
def Incident (line : PassantLine) (point : InternalPoint) : Prop :=
  line.1.x * point.1.x + line.1.y * point.1.y + line.1.z * point.1.z = 0

instance : DecidableRel Incident := fun line point =>
  decEq (line.1.x * point.1.x + line.1.y * point.1.y + line.1.z * point.1.z) 0

/-- The binary incidence code checked by all passant rows of the standard conic over `ZMod 13`. -/
def passantCode : Submodule (ZMod 2) (InternalPoint → ZMod 2) :=
  ConicPassantCode.code Incident

/-- The normalized coordinate model contains all 183 projective points of `PG(2,13)`. -/
theorem projectiveTriples_card : projectiveTriples.card = 183 := by
  native_decide

/-- The standard conic over `ZMod 13` has 78 internal points. -/
theorem internalCoordinates_card : internalCoordinates.card = 78 := by
  native_decide

/-- The standard conic over `ZMod 13` has 78 passant lines. -/
theorem passantCoordinates_card : passantCoordinates.card = 78 := by
  native_decide

/-- The executable internal-point list has length 78 and no duplicates. -/
theorem internalCoordinateList_length : internalCoordinateList.length = 78 := by
  native_decide

/-- The executable internal-point list enumerates exactly the semantic coordinate finset. -/
theorem internalCoordinateList_toFinset :
    internalCoordinateList.toFinset = internalCoordinates := by
  native_decide

/-- The executable passant-line list has length 78 and no duplicates. -/
theorem passantCoordinateList_length : passantCoordinateList.length = 78 := by
  native_decide

/-- The executable passant-line list enumerates exactly the semantic coordinate finset. -/
theorem passantCoordinateList_toFinset :
    passantCoordinateList.toFinset = passantCoordinates := by
  native_decide

/-- The coordinate set of the binary passant code has cardinality 78. -/
theorem internalPoint_card : Fintype.card InternalPoint = 78 := by
  simpa only [Fintype.card_coe] using internalCoordinates_card

/-- The parity-check row set has cardinality 78. -/
theorem passantLine_card : Fintype.card PassantLine = 78 := by
  simpa only [Fintype.card_coe] using passantCoordinates_card

/-- Membership in the concrete code is vanishing of every passant-row parity sum. -/
theorem mem_passantCode_iff_row_sums (word : InternalPoint → ZMod 2) :
    word ∈ passantCode ↔
      ∀ line : PassantLine,
        ∑ point : InternalPoint,
          word point * ConicPassantCode.incidenceBit Incident line point = 0 :=
  ConicPassantCode.mem_code_iff_row_sums Incident word

end RelativeConicArcs.PassantCodeQ13
