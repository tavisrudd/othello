import PassantCodeQ13.AssociationTransport.RelationMasks

/-!
# The rho-twelve square in the binary elliptic association algebra

The square is evaluated on the displayed row masks of the two relations, where one row of a product
is the exclusive-or of the selected rows of the right-hand factor.  The identity is exhaustive over
all rows and is discharged by kernel reduction; the transport to a matrix identity over the binary
field uses only symbolic bridges.
-/

namespace PassantCodeQ13.AssociationTransport

/-- Word-parallel evaluation identifies the square of the masks of `A12` with the masks of `A9`. -/
theorem rhoTwelve_square_entry_certificate :
    maskProduct relationRowsRhoTwelve relationRowsRhoTwelve = relationRowsRhoNine := by
  decide +kernel

/-- The relation matrices satisfy `A12² = A9`. -/
theorem rhoTwelve_square_parity_certificate :
    relationLinearMatrix 12 * relationLinearMatrix 12 = relationLinearMatrix 9 := by
  simp only [relationLinearMatrix]
  rw [← maskMatrix_relationRowsRhoTwelve, ← booleanParityProduct_linearize,
    ← maskMatrix_maskProduct relationRowsRhoTwelve relationRowsRhoTwelve relationRowsRhoTwelve_length,
    rhoTwelve_square_entry_certificate, maskMatrix_relationRowsRhoNine]

end PassantCodeQ13.AssociationTransport
