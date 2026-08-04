import PassantCodeQ13.AssociationTransport.PackedRows
import PassantCodeQ13.AssociationTransport.RelationData

/-!
# Column masks of the orbit with a dihedral stabilizer of order 24 whose Gram matrix is the
elliptic relation of polar invariant nine

The displayed column masks of `PassantCodeQ13.AssociationTransport.RelationData` are compared
entrywise with the transpose of the support matrix of the displayed orbit.  The comparison is
exhaustive over all pairs of an internal point and an orbit member and is discharged by kernel
reduction, so the column masks carry no trust; they exist so that the Gram product of the orbit can
be evaluated one natural-number operation at a time.
-/

namespace PassantCodeQ13.AssociationTransport

open PassantCodeQ13.MinimumWords

/-- Compact entry check comparing the displayed column masks with the transposed support matrix. -/
theorem orbitDihedralAColumns_entry_certificate :
    booleanMatrixEqualityCheck
      (maskMatrix orbitDihedralAColumns : Matrix Coordinate OrbitCoordinate Bool)
      (maskMatrix orbitDihedralASupports : Matrix OrbitCoordinate Coordinate Bool).transpose
      = true := by
  decide +kernel

/-- The displayed column masks present the transposed support matrix of the orbit. -/
theorem maskMatrix_orbitDihedralAColumns :
    (maskMatrix orbitDihedralAColumns : Matrix Coordinate OrbitCoordinate Bool)
      = (maskMatrix orbitDihedralASupports : Matrix OrbitCoordinate Coordinate Bool).transpose :=
  booleanMatrixEqualityCheck_sound orbitDihedralAColumns_entry_certificate

/-- The orbit has one support per member. -/
theorem orbitDihedralASupports_length : orbitDihedralASupports.length = 91 := by
  rfl

/-- The column masks give one entry per internal point. -/
theorem orbitDihedralAColumns_length : orbitDihedralAColumns.length = 78 := by
  rfl

end PassantCodeQ13.AssociationTransport
