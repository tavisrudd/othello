import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-! # Pair concurrence at the internal points of indices 26 through 51

The comparison of pair concurrence with the passant-join relation is checked by kernel reduction
for every first index in this block and every second index below 78, on the displayed minimum-word
supports and through the packed incidence table.

The block is checked in the two halves of indices 26 through 38 and indices 39 through 51, because
the kernel releases the memory of one declaration's reduction before beginning the next, and the
whole block in one declaration exceeds the memory available to the checked reduction.  The two halves
concatenate to the block, and the comparison over a concatenation of first indices is the conjunction
of the comparisons over its parts.
-/

namespace PassantCodeQ13.MinimumWords

/-- The indices 26 through 51 are the indices 26 through 38 followed by the indices 39 through 51. -/
private theorem indexBlockTwo_halves :
    indexBlockTwo = (List.range 13).map (· + 26) ++ (List.range 13).map (· + 39) := by
  decide

/-- Pair concurrence recovers the passant join at every first index of indices 26 through 38. -/
private theorem pairRecovery_blockTwo_lowerHalf :
    pairRecoveryCheckOn minimumSupportCodes ((List.range 13).map (· + 26)) = true := by
  rw [← tabulatedPairRecoveryCheckOn_eq _ _ (by decide), minimumSupportCodes_eq]
  decide +kernel

/-- Pair concurrence recovers the passant join at every first index of indices 39 through 51. -/
private theorem pairRecovery_blockTwo_upperHalf :
    pairRecoveryCheckOn minimumSupportCodes ((List.range 13).map (· + 39)) = true := by
  rw [← tabulatedPairRecoveryCheckOn_eq _ _ (by decide), minimumSupportCodes_eq]
  decide +kernel

/-- Pair concurrence recovers the passant join at every first index of indices 26 through 51. -/
theorem pairRecovery_blockTwo :
    pairRecoveryCheckOn minimumSupportCodes indexBlockTwo = true := by
  rw [indexBlockTwo_halves, pairRecoveryCheckOn_append, pairRecovery_blockTwo_lowerHalf,
    pairRecovery_blockTwo_upperHalf]
  rfl

end PassantCodeQ13.MinimumWords
