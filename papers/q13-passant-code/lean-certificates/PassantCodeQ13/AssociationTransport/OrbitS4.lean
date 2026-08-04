import PassantCodeQ13.AssociationTransport.OrbitMasks.Symmetric
import PassantCodeQ13.AssociationTransport.RelationMasks

/-!
# Association certificate for the symmetric-stabilizer minimum-word orbit

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
nine, and annihilates the orbit by the relation of polar invariant zero. -/
theorem orbitS4_entry_certificate :
    maskProduct orbitSymmetricColumns orbitSymmetricSupports = relationRowsRhoNine ∧
      maskProduct relationRowsRhoZero orbitSymmetricColumns = List.replicate 78 0 := by
  decide +kernel

/-- The symmetric-stabilizer orbit has Gram matrix `A9` and all its rows lie in `ker A0`. -/
theorem orbitS4_Gram_and_kernel :
    let N := orbitSupportMatrix (supportOrbit representativeS4)
    N.transpose * N = relationLinearMatrix 9 ∧ relationLinearMatrix 0 * N.transpose = 0 := by
  have supports : orbitSupportBooleanMatrix (supportOrbit representativeS4)
      = (maskMatrix orbitSymmetricSupports : Matrix OrbitCoordinate Coordinate Bool) := by
    rw [supportOrbit_representativeS4_eq]
    exact orbitSupportBooleanMatrix_eq_maskMatrix _
  simp only [orbitSupportMatrix, relationLinearMatrix, supports]
  rw [← booleanMatrix_transpose, ← maskMatrix_orbitSymmetricColumns]
  refine ⟨?_, ?_⟩
  · rw [← booleanParityProduct_linearize,
      ← maskMatrix_maskProduct orbitSymmetricColumns orbitSymmetricSupports
        orbitSymmetricSupports_length,
      orbitS4_entry_certificate.1, maskMatrix_relationRowsRhoNine]
  · rw [← maskMatrix_relationRowsRhoZero, ← booleanParityProduct_linearize,
      ← maskMatrix_maskProduct relationRowsRhoZero orbitSymmetricColumns
        orbitSymmetricColumns_length,
      orbitS4_entry_certificate.2, maskMatrix_replicate_zero, booleanMatrix_zero]

end PassantCodeQ13.AssociationTransport
