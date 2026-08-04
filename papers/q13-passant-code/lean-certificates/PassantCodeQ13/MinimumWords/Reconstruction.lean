import PassantCodeQ13.MinimumWords.Concurrence.PairBlockOne
import PassantCodeQ13.MinimumWords.Concurrence.PairBlockTwo
import PassantCodeQ13.MinimumWords.Concurrence.PairBlockThree
import PassantCodeQ13.MinimumWords.Concurrence.RowBlockOne
import PassantCodeQ13.MinimumWords.Concurrence.RowBlockTwo
import PassantCodeQ13.MinimumWords.Concurrence.RowBlockThree

/-!
# Concurrence checks for the four minimum-word orbits

The four 91-element projective orbits are joined into a 364-support hypergraph, defined together
with its concurrence counts in `PassantCodeQ13.MinimumWords.ConcurrenceBase`.  Pair concurrence is
compared with the geometric passant-join relation, and every geometric passant row is checked to be
a seven-set all of whose triples have concurrence zero.  Both checks are discharged blockwise by
kernel reduction over the three blocks of indices, and assembled here.

This finite leaf proves the forward reconstruction signatures.  It does not by itself prove that no
additional seven-clique has the same zero-triple property; that uniqueness statement remains an
explicit field of the shared `MinimumLayerCertificate` interface.
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

/-- The 78 geometric passant rows have the required seven-point zero-triple signatures. -/
theorem geometric_rows_have_zero_triple_signatures :
    passantRowCodes.eraseDups.length = 78 ∧ passantRowTripleCheck = true := by
  refine ⟨?_, ?_⟩
  · unfold passantRowCodes
    rw [← tabulatedPassantRowCodesOn_eq _ (fun line mem => List.mem_range.mp mem)]
    decide +kernel
  · unfold passantRowTripleCheck passantRowCodes
    rw [indexBlocks_cover, passantRowCodesOn_append, passantRowCodesOn_append,
      rowTripleCheckOn_append, rowTripleCheckOn_append,
      rowSignature_blockOne, rowSignature_blockTwo, rowSignature_blockThree]
    rfl

end PassantCodeQ13.MinimumWords
