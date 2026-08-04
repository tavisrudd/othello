import PassantCodeQ13.AssociationTransport.RelationMasks

/-!
# The rho-ten square in the binary elliptic association algebra

The square is evaluated on the displayed row masks of the two relations, where one row of a product
is the exclusive-or of the selected rows of the right-hand factor.  The identity is exhaustive over
all rows and is discharged by kernel reduction; the transport to a matrix identity over the binary
field uses only symbolic bridges.
-/

namespace PassantCodeQ13.AssociationTransport

/-- Word-parallel evaluation identifies the square of the masks of `A10` with the masks of `A12`. -/
theorem rhoTen_square_entry_certificate :
    maskProduct relationRowsRhoTen relationRowsRhoTen = relationRowsRhoTwelve := by
  decide +kernel

/-- The relation matrices satisfy `A10² = A12`. -/
theorem rhoTen_square_parity_certificate :
    relationLinearMatrix 10 * relationLinearMatrix 10 = relationLinearMatrix 12 := by
  simp only [relationLinearMatrix]
  rw [← maskMatrix_relationRowsRhoTen, ← booleanParityProduct_linearize,
    ← maskMatrix_maskProduct relationRowsRhoTen relationRowsRhoTen relationRowsRhoTen_length,
    rhoTen_square_entry_certificate, maskMatrix_relationRowsRhoTwelve]

end PassantCodeQ13.AssociationTransport
