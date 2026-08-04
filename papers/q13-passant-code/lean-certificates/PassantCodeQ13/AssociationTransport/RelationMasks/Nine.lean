import PassantCodeQ13.AssociationTransport.PackedRows
import PassantCodeQ13.AssociationTransport.RelationData

/-!
# Row masks of the elliptic relation with normalized polar invariant nine

The displayed masks of `PassantCodeQ13.AssociationTransport.RelationData` are compared entrywise
with the semantic adjacency matrix `relationBooleanMatrix 9`, which evaluates the normalized polar
invariant of two internal points.  The comparison is exhaustive over all 6084 ordered pairs of
internal points and is discharged by kernel reduction, so the displayed masks carry no trust.
-/

namespace PassantCodeQ13.AssociationTransport

/-- Compact entry check comparing the displayed masks with the relation of polar invariant nine. -/
theorem relationRowsRhoNine_entry_certificate :
    booleanMatrixEqualityCheck
      (maskMatrix relationRowsRhoNine : Matrix Coordinate Coordinate Bool)
      (relationBooleanMatrix 9) = true := by
  decide +kernel

/-- The displayed masks present the elliptic relation of polar invariant nine. -/
theorem maskMatrix_relationRowsRhoNine :
    (maskMatrix relationRowsRhoNine : Matrix Coordinate Coordinate Bool)
      = relationBooleanMatrix 9 :=
  booleanMatrixEqualityCheck_sound relationRowsRhoNine_entry_certificate

/-- The displayed masks give one row per internal point. -/
theorem relationRowsRhoNine_length : relationRowsRhoNine.length = 78 := by
  rfl

end PassantCodeQ13.AssociationTransport
