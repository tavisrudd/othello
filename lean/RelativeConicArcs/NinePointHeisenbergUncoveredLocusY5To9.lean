import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Uncovered-locus check on affine rows five through nine

Kernel reduction compares ordinary uncoveredness with membership in the displayed uncovered orbit
on the 95 canonical affine points `[1:y:z]` with `5 ≤ y ≤ 9`.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredLocusY5To9

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- Ordinary uncoveredness agrees with the displayed orbit on affine rows five through nine. -/
theorem uncovered_locus_agreement :
    uncoveredLocusAgreementOn canonicalPointsY5To9 = true := by
  decide

end NinePointHeisenbergUncoveredLocusY5To9
end RelativeConicArcs
