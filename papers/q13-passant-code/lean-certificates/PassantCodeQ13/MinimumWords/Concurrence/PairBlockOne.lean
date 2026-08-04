import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-! # Pair concurrence at the internal points of indices 0 through 25

The comparison of pair concurrence with the passant-join relation is checked by kernel reduction
for every first index in this block and every second index below 78, on the displayed minimum-word
supports and through the packed incidence table.
-/

namespace PassantCodeQ13.MinimumWords

/-- Pair concurrence recovers the passant join at every first index of indices 0 through 25. -/
theorem pairRecovery_blockOne :
    pairRecoveryCheckOn minimumSupportCodes indexBlockOne = true := by
  rw [← tabulatedPairRecoveryCheckOn_eq _ _ indexBlockOne_bounded, minimumSupportCodes_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
