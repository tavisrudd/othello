import PassantCodeQ13.AssociationTransport.RelationSquares

/-!
# The cubic satisfied by the rho-nine relation operator on its image

Over the binary field the relation operator `A9` satisfies `B⁴ + B³ + B = 0`.  The only finite input
beyond the squaring identities is the mixed product `A10 A9`, evaluated on the displayed row masks
and discharged by kernel reduction; the powers of `B` are then rewritten by the squaring identities
and the identity is closed by the vanishing of `M + M` over the binary field.
-/

namespace PassantCodeQ13.AssociationTransport

/-- Word-parallel evaluation identifies the mixed product of the masks of `A10` and `A9` with the
masks of `A12 + A9`. -/
theorem rhoTen_rhoNine_product_entry_certificate :
    maskProduct relationRowsRhoTen relationRowsRhoNine
      = maskXor relationRowsRhoTwelve relationRowsRhoNine := by
  decide +kernel

/-- The relation matrices satisfy `A10 A9 = A12 + A9`. -/
theorem rhoTen_rhoNine_product_parity_certificate :
    relationLinearMatrix 10 * relationLinearMatrix 9
      = relationLinearMatrix 12 + relationLinearMatrix 9 := by
  simp only [relationLinearMatrix]
  rw [← maskMatrix_relationRowsRhoTen, ← maskMatrix_relationRowsRhoNine,
    ← maskMatrix_relationRowsRhoTwelve, ← booleanParityProduct_linearize,
    ← maskMatrix_maskProduct relationRowsRhoTen relationRowsRhoNine relationRowsRhoNine_length,
    rhoTen_rhoNine_product_entry_certificate,
    maskMatrix_maskXor relationRowsRhoTwelve relationRowsRhoNine
      (relationRowsRhoTwelve_length.trans relationRowsRhoNine_length.symm),
    booleanMatrix_xor]

private theorem addSelf_eq_zero (matrix : Matrix Coordinate Coordinate (ZMod 2)) :
    matrix + matrix = 0 := by
  have doubling : ∀ value : ZMod 2, value + value = 0 := by decide
  ext row column
  simpa using doubling (matrix row column)

/-- The relation operator `A9` satisfies the hidden irreducible cubic on its image: multiplying
`B³ + B² + I` by `B` gives the zero ambient matrix. -/
theorem rhoNine_quartic_vanishes :
    relationLinearMatrix 9 ^ 4 + relationLinearMatrix 9 ^ 3 + relationLinearMatrix 9 = 0 := by
  have square : relationLinearMatrix 9 ^ 2 = relationLinearMatrix 10 := by
    rw [pow_two]
    exact rhoNine_square_parity_certificate
  have cube : relationLinearMatrix 9 ^ 3 = relationLinearMatrix 12 + relationLinearMatrix 9 := by
    rw [show (3 : Nat) = 2 + 1 from rfl, pow_add, pow_one, square]
    exact rhoTen_rhoNine_product_parity_certificate
  have quartic : relationLinearMatrix 9 ^ 4 = relationLinearMatrix 12 := by
    rw [show (4 : Nat) = 2 + 2 from rfl, pow_add, square]
    exact rhoTen_square_parity_certificate
  rw [quartic, cube]
  calc relationLinearMatrix 12 + (relationLinearMatrix 12 + relationLinearMatrix 9)
        + relationLinearMatrix 9
      = relationLinearMatrix 12 + relationLinearMatrix 12
        + (relationLinearMatrix 9 + relationLinearMatrix 9) := by abel
    _ = 0 := by rw [addSelf_eq_zero, addSelf_eq_zero, add_zero]

end PassantCodeQ13.AssociationTransport
