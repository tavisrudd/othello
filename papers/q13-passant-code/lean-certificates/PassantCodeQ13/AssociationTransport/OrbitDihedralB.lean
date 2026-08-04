import PassantCodeQ13.AssociationTransport.OrbitMasks.DihedralB
import PassantCodeQ13.AssociationTransport.RelationMasks

/-!
# Association certificate for the second dihedral-stabilizer minimum-word orbit

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
twelve, and annihilates the orbit by the relation of polar invariant zero. -/
theorem orbitDihedralB_entry_certificate :
    maskProduct orbitDihedralBColumns orbitDihedralBSupports = relationRowsRhoTwelve ∧
      maskProduct relationRowsRhoZero orbitDihedralBColumns = List.replicate 78 0 := by
  decide +kernel

/-- The second dihedral orbit has Gram matrix `A12` and all its rows lie in `ker A0`. -/
theorem orbitDihedralB_Gram_and_kernel :
    let N := orbitSupportMatrix (supportOrbit representativeDihedralB)
    N.transpose * N = relationLinearMatrix 12 ∧ relationLinearMatrix 0 * N.transpose = 0 := by
  have supports : orbitSupportBooleanMatrix (supportOrbit representativeDihedralB)
      = (maskMatrix orbitDihedralBSupports : Matrix OrbitCoordinate Coordinate Bool) := by
    rw [supportOrbit_representativeDihedralB_eq]
    exact orbitSupportBooleanMatrix_eq_maskMatrix _
  simp only [orbitSupportMatrix, relationLinearMatrix, supports]
  rw [← booleanMatrix_transpose, ← maskMatrix_orbitDihedralBColumns]
  refine ⟨?_, ?_⟩
  · rw [← booleanParityProduct_linearize,
      ← maskMatrix_maskProduct orbitDihedralBColumns orbitDihedralBSupports
        orbitDihedralBSupports_length,
      orbitDihedralB_entry_certificate.1, maskMatrix_relationRowsRhoTwelve]
  · rw [← maskMatrix_relationRowsRhoZero, ← booleanParityProduct_linearize,
      ← maskMatrix_maskProduct relationRowsRhoZero orbitDihedralBColumns
        orbitDihedralBColumns_length,
      orbitDihedralB_entry_certificate.2, maskMatrix_replicate_zero, booleanMatrix_zero]

end PassantCodeQ13.AssociationTransport
