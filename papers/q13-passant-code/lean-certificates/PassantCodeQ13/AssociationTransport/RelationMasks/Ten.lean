import PassantCodeQ13.AssociationTransport.PackedRows
import PassantCodeQ13.AssociationTransport.RelationData

/-!
# Row masks of the elliptic relation with normalized polar invariant ten

The displayed masks of `PassantCodeQ13.AssociationTransport.RelationData` are compared entrywise
with the semantic adjacency matrix `relationBooleanMatrix 10`, which evaluates the normalized polar
invariant of two internal points.  The comparison is exhaustive over all 6084 ordered pairs of
internal points and is discharged by kernel reduction, so the displayed masks carry no trust.
-/

namespace PassantCodeQ13.AssociationTransport

/-- Compact entry check comparing the displayed masks with the relation of polar invariant ten. -/
theorem relationRowsRhoTen_entry_certificate :
    booleanMatrixEqualityCheck
      (maskMatrix relationRowsRhoTen : Matrix Coordinate Coordinate Bool)
      (relationBooleanMatrix 10) = true := by
  decide +kernel

/-- The displayed masks present the elliptic relation of polar invariant ten. -/
theorem maskMatrix_relationRowsRhoTen :
    (maskMatrix relationRowsRhoTen : Matrix Coordinate Coordinate Bool)
      = relationBooleanMatrix 10 :=
  booleanMatrixEqualityCheck_sound relationRowsRhoTen_entry_certificate

/-- The displayed masks give one row per internal point. -/
theorem relationRowsRhoTen_length : relationRowsRhoTen.length = 78 := by
  rfl

end PassantCodeQ13.AssociationTransport
