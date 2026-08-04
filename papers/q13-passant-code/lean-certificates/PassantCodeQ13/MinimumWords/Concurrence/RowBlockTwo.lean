import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-! # Triple concurrence on the passant rows of indices 26 through 51

Each passant row in this block is checked by kernel reduction to carry seven internal points, all of
whose triples have concurrence zero in the displayed minimum-word supports.  The rows themselves are
read from the packed incidence table.
-/

namespace PassantCodeQ13.MinimumWords

/-- The passant rows of indices 26 through 51 are seven-sets with zero triple concurrence. -/
theorem rowSignature_blockTwo :
    rowTripleCheckOn minimumSupportCodes (passantRowCodesOn indexBlockTwo) = true := by
  rw [← tabulatedPassantRowCodesOn_eq _ indexBlockTwo_bounded, minimumSupportCodes_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
