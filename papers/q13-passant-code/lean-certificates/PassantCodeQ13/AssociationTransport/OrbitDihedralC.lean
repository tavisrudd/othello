import PassantCodeQ13.AssociationTransport.OrbitMasks.DihedralC
import PassantCodeQ13.AssociationTransport.RelationMasks

/-!
# Association certificate for the third dihedral-stabilizer minimum-word orbit

The Gram matrix of the orbit and the vanishing of its product with the relation of polar invariant
zero are evaluated on the displayed row and column masks, where one row of a product is the
exclusive-or of the selected rows of the right-hand factor.  Both identities are exhaustive over the
full index range and are discharged by kernel reduction; the transport to matrix identities over the
binary field uses only the symbolic bridges of `PassantCodeQ13.AssociationTransport.PackedRows` and
`booleanParityProduct_linearize`.
-/

namespace PassantCodeQ13.AssociationTransport

open PassantCodeQ13.MinimumWords

/-- Word-parallel evaluation identifies the orbit Gram masks with the relation of polar invariant
ten, and annihilates the orbit by the relation of polar invariant zero. -/
theorem orbitDihedralC_entry_certificate :
    maskProduct orbitDihedralCColumns orbitDihedralCSupports = relationRowsRhoTen ∧
      maskProduct relationRowsRhoZero orbitDihedralCColumns = List.replicate 78 0 := by
  decide +kernel

/-- The third dihedral orbit has Gram matrix `A10` and all its rows lie in `ker A0`. -/
theorem orbitDihedralC_Gram_and_kernel :
    let N := orbitSupportMatrix (supportOrbit representativeDihedralC)
    N.transpose * N = relationLinearMatrix 10 ∧ relationLinearMatrix 0 * N.transpose = 0 := by
  have supports : orbitSupportBooleanMatrix (supportOrbit representativeDihedralC)
      = (maskMatrix orbitDihedralCSupports : Matrix OrbitCoordinate Coordinate Bool) := by
    rw [supportOrbit_representativeDihedralC_eq]
    exact orbitSupportBooleanMatrix_eq_maskMatrix _
  simp only [orbitSupportMatrix, relationLinearMatrix, supports]
  rw [← booleanMatrix_transpose, ← maskMatrix_orbitDihedralCColumns]
  refine ⟨?_, ?_⟩
  · rw [← booleanParityProduct_linearize,
      ← maskMatrix_maskProduct orbitDihedralCColumns orbitDihedralCSupports
        orbitDihedralCSupports_length,
      orbitDihedralC_entry_certificate.1, maskMatrix_relationRowsRhoTen]
  · rw [← maskMatrix_relationRowsRhoZero, ← booleanParityProduct_linearize,
      ← maskMatrix_maskProduct relationRowsRhoZero orbitDihedralCColumns
        orbitDihedralCColumns_length,
      orbitDihedralC_entry_certificate.2, maskMatrix_replicate_zero, booleanMatrix_zero]

end PassantCodeQ13.AssociationTransport
