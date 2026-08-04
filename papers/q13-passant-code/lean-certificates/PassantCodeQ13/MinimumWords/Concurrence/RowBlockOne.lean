import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-! # Triple concurrence on the passant rows of indices 0 through 25

Each passant row in this block is checked by kernel reduction to carry seven internal points, all of
whose triples have concurrence zero in the displayed minimum-word supports.  The rows themselves are
read from the packed incidence table.
-/

namespace PassantCodeQ13.MinimumWords

/-- The passant rows of indices 0 through 25 are seven-sets with zero triple concurrence. -/
theorem rowSignature_blockOne :
    rowTripleCheckOn minimumSupportCodes (passantRowCodesOn indexBlockOne) = true := by
  rw [← tabulatedPassantRowCodesOn_eq _ indexBlockOne_bounded, minimumSupportCodes_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
