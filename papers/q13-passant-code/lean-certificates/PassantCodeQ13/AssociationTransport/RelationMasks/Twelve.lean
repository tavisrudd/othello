import PassantCodeQ13.AssociationTransport.PackedRows
import PassantCodeQ13.AssociationTransport.RelationData

/-!
# Row masks of the elliptic relation with normalized polar invariant twelve

The displayed masks of `PassantCodeQ13.AssociationTransport.RelationData` are compared entrywise
with the semantic adjacency matrix `relationBooleanMatrix 12`, which evaluates the normalized polar
invariant of two internal points.  The comparison is exhaustive over all 6084 ordered pairs of
internal points and is discharged by kernel reduction, so the displayed masks carry no trust.
-/

namespace PassantCodeQ13.AssociationTransport

/-- Compact entry check comparing the displayed masks with the relation of polar invariant twelve. -/
theorem relationRowsRhoTwelve_entry_certificate :
    booleanMatrixEqualityCheck
      (maskMatrix relationRowsRhoTwelve : Matrix Coordinate Coordinate Bool)
      (relationBooleanMatrix 12) = true := by
  decide +kernel

/-- The displayed masks present the elliptic relation of polar invariant twelve. -/
theorem maskMatrix_relationRowsRhoTwelve :
    (maskMatrix relationRowsRhoTwelve : Matrix Coordinate Coordinate Bool)
      = relationBooleanMatrix 12 :=
  booleanMatrixEqualityCheck_sound relationRowsRhoTwelve_entry_certificate

/-- The displayed masks give one row per internal point. -/
theorem relationRowsRhoTwelve_length : relationRowsRhoTwelve.length = 78 := by
  rfl

end PassantCodeQ13.AssociationTransport
