import PassantCodeQ13.MinimumWords.Concurrence.PairBlockOne
import PassantCodeQ13.MinimumWords.Concurrence.PairBlockTwo
import PassantCodeQ13.MinimumWords.Concurrence.PairBlockThree

/-!
# Concurrence checks for the four minimum-word orbits

The four 91-element projective orbits are joined into a 364-support hypergraph, defined together
with its concurrence counts in `PassantCodeQ13.MinimumWords.ConcurrenceBase`.  Pair concurrence is
compared with the geometric passant-join relation, discharged blockwise by kernel reduction over the
three blocks of internal-point indices and assembled here.

The companion zero-triple signature of the geometric passant rows is not a finite check: it is proved
from the arc property of the minimum-word family in
`PassantCodeQ13.MinimumWords.SupportArc`.

This finite leaf proves the forward pair signatures.  It does not by itself prove that no additional
seven-clique has the same zero-triple property; that uniqueness statement remains an explicit field of
the shared `MinimumLayerCertificate` interface.
-/

namespace PassantCodeQ13.MinimumWords

/-- The four projective orbits contain 364 distinct supports. -/
theorem minimumSupportCodes_length : minimumSupportCodes.length = 364 := by
  rw [minimumSupportCodes_eq]
  decide +kernel

/-- Pair concurrence recovers whether the join of two distinct internal points is passant. -/
theorem pair_concurrence_recovers_passant_join :
    pairRecoveryCheck = true := by
  unfold pairRecoveryCheck
  rw [indexBlocks_cover, pairRecoveryCheckOn_append, pairRecoveryCheckOn_append,
    pairRecovery_blockOne, pairRecovery_blockTwo, pairRecovery_blockThree]
  rfl

end PassantCodeQ13.MinimumWords
