import PassantCodeQ13.AssociationTransport.RelationMasks

/-!
# The rho-nine square in the binary elliptic association algebra

The square is evaluated on the displayed row masks of the two relations, where one row of a product
is the exclusive-or of the selected rows of the right-hand factor.  The identity is exhaustive over
all rows and is discharged by kernel reduction; the transport to a matrix identity over the binary
field uses only symbolic bridges.
-/

namespace PassantCodeQ13.AssociationTransport

/-- Word-parallel evaluation identifies the square of the masks of `A9` with the masks of `A10`. -/
theorem rhoNine_square_entry_certificate :
    maskProduct relationRowsRhoNine relationRowsRhoNine = relationRowsRhoTen := by
  decide +kernel

/-- The relation matrices satisfy `A9² = A10`. -/
theorem rhoNine_square_parity_certificate :
    relationLinearMatrix 9 * relationLinearMatrix 9 = relationLinearMatrix 10 := by
  simp only [relationLinearMatrix]
  rw [← maskMatrix_relationRowsRhoNine, ← booleanParityProduct_linearize,
    ← maskMatrix_maskProduct relationRowsRhoNine relationRowsRhoNine relationRowsRhoNine_length,
    rhoNine_square_entry_certificate, maskMatrix_relationRowsRhoTen]

end PassantCodeQ13.AssociationTransport
