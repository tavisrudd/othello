import PassantCodeQ13.MinimumWords.Base
import RelativeConicArcs.PassantCodeQ13.AssociationAlgebra

/-!
# Executable presentation of the binary elliptic association algebra over `ZMod 13`

The six elliptic relations are computed from the normalized polar invariant on the 78 internal
coordinates.  Their binary adjacency rows are encoded as natural-number bit sets: row `i` of a
relation is the natural number whose set bits are the coordinates standing in that relation to
coordinate `i`.  Matrix multiplication over the binary field is the parity of the coincidences of a
left row with a column, and matrix addition is exclusive-or of rows.

This module fixes those definitions.  The identities they satisfy — the exact ranks of the four
relation matrices, the square of the relation of polar invariant zero, and the squaring cycle on the
three rank-36 relations — are proved in `PassantCodeQ13.AssociationAlgebraIdentities`, which reaches
them through the displayed row masks of `PassantCodeQ13.AssociationTransport` and therefore imports
this module.
-/

namespace PassantCodeQ13.AssociationAlgebra

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.WeightTen
open PassantCodeQ13.MinimumWords

/-- Polar invariant of two indexed internal coordinates. -/
def rhoAt (first second : Nat) : Field13 :=
  let u := internalAt first
  let v := internalAt second
  polarValue u v ^ 2 * (pointDiscriminant u * pointDiscriminant v)⁻¹

/-- One binary row of an off-diagonal elliptic relation. -/
def relationRow (value : Field13) (first : Nat) : Nat :=
  (List.range 78).foldl (fun row second =>
    if first != second && rhoAt first second == value then row ||| (1 <<< second) else row) 0

/-- The 78 rows of one elliptic relation matrix. -/
def relationMatrix (value : Field13) : List Nat :=
  (List.range 78).map (relationRow value)

/-- Product of two binary matrices represented by row bit sets. -/
def matrixProduct (left right : List Nat) : List Nat :=
  (List.range 78).map fun row =>
    (List.range 78).foldl (fun answer column =>
      let parity := (List.range 78).foldl (fun bit middle =>
        if (left.getD row 0).testBit middle && (right.getD middle 0).testBit column
          then !bit else bit) false
      if parity then answer ||| (1 <<< column) else answer) 0

/-- The binary identity matrix as row bit sets. -/
def identityMatrix : List Nat :=
  (List.range 78).map fun index => 1 <<< index

/-- Pointwise XOR of four binary row matrices. -/
def xorFour (first second third fourth : List Nat) : List Nat :=
  List.zipWith (fun a rest => a ^^^ rest)
    first (List.zipWith (fun b rest => b ^^^ rest)
      second (List.zipWith (fun c d => c ^^^ d) third fourth))

end PassantCodeQ13.AssociationAlgebra
