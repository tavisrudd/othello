import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-! # Pair concurrence at the internal points of indices 52 through 77

The comparison of pair concurrence with the passant-join relation is checked by kernel reduction
for every first index in this block and every second index below 78, on the displayed minimum-word
supports and through the packed incidence table.
-/

namespace PassantCodeQ13.MinimumWords

/-- Pair concurrence recovers the passant join at every first index of indices 52 through 77. -/
theorem pairRecovery_blockThree :
    pairRecoveryCheckOn minimumSupportCodes indexBlockThree = true := by
  rw [← tabulatedPairRecoveryCheckOn_eq _ _ indexBlockThree_bounded, minimumSupportCodes_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
