import RelativeConicArcs.ClebschSignedGaleDuality

/-!
# Import-only gate for signed Gale-kernel duality

This gate exposes the kernel-checked linear-algebra mechanism that identifies
weighted rows with the complete relation space once weighted orthogonality and
the matching dimension equality are supplied.  It also checks that full row
rank and full-support column weights imply the required signed-row
independence. It adds no theorem and does not formalize the geometric,
coordinate-ring, Gorenstein, or inverse-system inputs.
-/

#print axioms RelativeConicArcs.SignedGaleDuality.signedRow_mem_ker
#print axioms RelativeConicArcs.SignedGaleDuality.weightedRowOrthogonal_iff_mul_transpose_eq_zero
#print axioms RelativeConicArcs.SignedGaleDuality.columnScale_injective
#print axioms RelativeConicArcs.SignedGaleDuality.signedRow_linearIndependent
#print axioms RelativeConicArcs.SignedGaleDuality.signedRowSpace_le_ker
#print axioms RelativeConicArcs.SignedGaleDuality.signedRowSpace_eq_ker_of_finrank_eq
#print axioms RelativeConicArcs.SignedGaleDuality.signedRowSpace_eq_ker_of_card_eq_twice
#print axioms RelativeConicArcs.SignedGaleDuality.signedRowSpace_eq_ker_of_mul_transpose_eq_zero
#print axioms RelativeConicArcs.SignedGaleDuality.rows_linearIndependent_of_toLin_surjective
#print axioms RelativeConicArcs.SignedGaleDuality.signedRowSpace_eq_ker_of_fullSupport
