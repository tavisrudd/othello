import RelativeConicArcs.Q16LeafData

/-!
# Exact q=16 rejection profile

This downstream module counts only the already checked rejection tags.  It introduces no new
search data and does not re-elaborate any leaf's arithmetic certificate.
-/

namespace RelativeConicArcs.Q16Classification

open Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

def LeafReject.isFullRank : LeafReject → Bool
  | .fullRank _ => true
  | .forcedHit _ => false

def LeafReject.isForcedHit : LeafReject → Bool
  | .fullRank _ => false
  | .forcedHit _ => true

noncomputable def fullRankLeafCount : ℕ :=
  (rejectedLeaves.map (fun leaf => leaf.reject.isFullRank)).count true

noncomputable def forcedHitLeafCount : ℕ :=
  (rejectedLeaves.map (fun leaf => leaf.reject.isForcedHit)).count true

/-- The 2,633 checked leaves split into 2,630 full-rank and three forced-hit rejections. -/
theorem rejection_profile :
    rejectedLeaves.length = 2633 ∧ fullRankLeafCount = 2630 ∧ forcedHitLeafCount = 3 := by
  decide

#print axioms rejection_profile

end RelativeConicArcs.Q16Classification
