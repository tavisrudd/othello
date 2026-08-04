import PassantCodeQ13.AssociationTransport.RelationMasks

/-!
# The rho-zero square in the binary elliptic association algebra

The square is evaluated on the displayed row masks of the four relations, where one row of a product
is the exclusive-or of the selected rows of the right-hand factor and entrywise addition is
exclusive-or of masks.  Both finite checks are exhaustive over all rows, respectively over all
ordered pairs of internal points, and are discharged by kernel reduction; the transport to a matrix
identity over the binary field uses only symbolic bridges.
-/

namespace PassantCodeQ13.AssociationTransport

/-- Word-parallel evaluation identifies the square of the masks of `A0` with the masks of
`I + A9 + A10 + A12`. -/
theorem rhoZero_square_entry_certificate :
    maskProduct relationRowsRhoZero relationRowsRhoZero
      = maskXor (identityMasks 78)
          (maskXor relationRowsRhoNine (maskXor relationRowsRhoTen relationRowsRhoTwelve)) := by
  decide +kernel

/-- Compact entry check comparing the identity masks with the Boolean identity matrix. -/
theorem identityMasks_entry_certificate :
    booleanMatrixEqualityCheck
      (maskMatrix (identityMasks 78) : Matrix Coordinate Coordinate Bool)
      booleanIdentityMatrix = true := by
  decide +kernel

/-- The identity masks present the Boolean identity matrix on the internal points. -/
theorem maskMatrix_identityMasks :
    (maskMatrix (identityMasks 78) : Matrix Coordinate Coordinate Bool) = booleanIdentityMatrix :=
  booleanMatrixEqualityCheck_sound identityMasks_entry_certificate

/-- The rho-zero relation matrix satisfies its binary square identity. -/
theorem rhoZero_square_parity_certificate :
    relationLinearMatrix 0 * relationLinearMatrix 0 =
      1 + relationLinearMatrix 9 + relationLinearMatrix 10 + relationLinearMatrix 12 := by
  have innerLength : (maskXor relationRowsRhoTen relationRowsRhoTwelve).length = 78 := by
    simp [maskXor_length, relationRowsRhoTen_length, relationRowsRhoTwelve_length]
  have middleLength : (maskXor relationRowsRhoNine
      (maskXor relationRowsRhoTen relationRowsRhoTwelve)).length = 78 := by
    simp [maskXor_length, relationRowsRhoNine_length, innerLength]
  simp only [relationLinearMatrix]
  rw [← maskMatrix_relationRowsRhoZero, ← booleanParityProduct_linearize,
    ← maskMatrix_maskProduct relationRowsRhoZero relationRowsRhoZero relationRowsRhoZero_length,
    rhoZero_square_entry_certificate,
    maskMatrix_maskXor (identityMasks 78) _ ((identityMasks_length 78).trans middleLength.symm),
    maskMatrix_maskXor relationRowsRhoNine _ (relationRowsRhoNine_length.trans innerLength.symm),
    maskMatrix_maskXor relationRowsRhoTen relationRowsRhoTwelve
      (relationRowsRhoTen_length.trans relationRowsRhoTwelve_length.symm),
    booleanMatrix_xor, booleanMatrix_xor, booleanMatrix_xor, booleanMatrix_identity,
    maskMatrix_relationRowsRhoNine, maskMatrix_relationRowsRhoTen,
    maskMatrix_relationRowsRhoTwelve]
  simp only [add_assoc]

end PassantCodeQ13.AssociationTransport
