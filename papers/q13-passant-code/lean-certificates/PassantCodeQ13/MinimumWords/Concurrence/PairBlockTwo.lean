import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-! # Pair concurrence at the internal points of indices 26 through 51

The comparison of pair concurrence with the passant-join relation is checked by kernel reduction
for every first index in this block and every second index below 78, on the displayed minimum-word
supports and through the packed incidence table.
-/

namespace PassantCodeQ13.MinimumWords

/-- Pair concurrence recovers the passant join at every first index of indices 26 through 51. -/
theorem pairRecovery_blockTwo :
    pairRecoveryCheckOn minimumSupportCodes indexBlockTwo = true := by
  rw [← tabulatedPairRecoveryCheckOn_eq _ _ indexBlockTwo_bounded, minimumSupportCodes_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
