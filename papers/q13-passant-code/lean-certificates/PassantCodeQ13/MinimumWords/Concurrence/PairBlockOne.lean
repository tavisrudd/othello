import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-! # Pair concurrence at the internal points of indices 0 through 25

The comparison of pair concurrence with the passant-join relation is checked by kernel reduction
for every first index in this block and every second index below 78, on the displayed minimum-word
supports and through the packed incidence table.

The block is checked in the two halves of indices 0 through 12 and indices 13 through 25, because
the kernel releases the memory of one declaration's reduction before beginning the next, and the
whole block in one declaration exceeds the memory available to the checked reduction.  The two halves
concatenate to the block, and the comparison over a concatenation of first indices is the conjunction
of the comparisons over its parts.
-/

namespace PassantCodeQ13.MinimumWords

/-- The indices 0 through 25 are the indices 0 through 12 followed by the indices 13 through 25. -/
private theorem indexBlockOne_halves :
    indexBlockOne = List.range 13 ++ (List.range 13).map (· + 13) := by
  decide

/-- Pair concurrence recovers the passant join at every first index of indices 0 through 12. -/
private theorem pairRecovery_blockOne_lowerHalf :
    pairRecoveryCheckOn minimumSupportCodes (List.range 13) = true := by
  rw [← tabulatedPairRecoveryCheckOn_eq _ _ (by decide), minimumSupportCodes_eq]
  decide +kernel

/-- Pair concurrence recovers the passant join at every first index of indices 13 through 25. -/
private theorem pairRecovery_blockOne_upperHalf :
    pairRecoveryCheckOn minimumSupportCodes ((List.range 13).map (· + 13)) = true := by
  rw [← tabulatedPairRecoveryCheckOn_eq _ _ (by decide), minimumSupportCodes_eq]
  decide +kernel

/-- Pair concurrence recovers the passant join at every first index of indices 0 through 25. -/
theorem pairRecovery_blockOne :
    pairRecoveryCheckOn minimumSupportCodes indexBlockOne = true := by
  rw [indexBlockOne_halves, pairRecoveryCheckOn_append, pairRecovery_blockOne_lowerHalf,
    pairRecovery_blockOne_upperHalf]
  rfl

end PassantCodeQ13.MinimumWords
