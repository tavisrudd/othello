import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-! # Pair concurrence at the internal points of indices 52 through 77

The comparison of pair concurrence with the passant-join relation is checked by kernel reduction
for every first index in this block and every second index below 78, on the displayed minimum-word
supports and through the packed incidence table.

The block is checked in the two halves of indices 52 through 64 and indices 65 through 77, because
the kernel releases the memory of one declaration's reduction before beginning the next, and the
whole block in one declaration exceeds the memory available to the checked reduction.  The two halves
concatenate to the block, and the comparison over a concatenation of first indices is the conjunction
of the comparisons over its parts.
-/

namespace PassantCodeQ13.MinimumWords

/-- The indices 52 through 77 are the indices 52 through 64 followed by the indices 65 through 77. -/
private theorem indexBlockThree_halves :
    indexBlockThree = (List.range 13).map (· + 52) ++ (List.range 13).map (· + 65) := by
  decide

/-- Pair concurrence recovers the passant join at every first index of indices 52 through 64. -/
private theorem pairRecovery_blockThree_lowerHalf :
    pairRecoveryCheckOn minimumSupportCodes ((List.range 13).map (· + 52)) = true := by
  rw [← tabulatedPairRecoveryCheckOn_eq _ _ (by decide), minimumSupportCodes_eq]
  decide +kernel

/-- Pair concurrence recovers the passant join at every first index of indices 65 through 77. -/
private theorem pairRecovery_blockThree_upperHalf :
    pairRecoveryCheckOn minimumSupportCodes ((List.range 13).map (· + 65)) = true := by
  rw [← tabulatedPairRecoveryCheckOn_eq _ _ (by decide), minimumSupportCodes_eq]
  decide +kernel

/-- Pair concurrence recovers the passant join at every first index of indices 52 through 77. -/
theorem pairRecovery_blockThree :
    pairRecoveryCheckOn minimumSupportCodes indexBlockThree = true := by
  rw [indexBlockThree_halves, pairRecoveryCheckOn_append, pairRecovery_blockThree_lowerHalf,
    pairRecovery_blockThree_upperHalf]
  rfl

end PassantCodeQ13.MinimumWords
