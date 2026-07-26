import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Uncovered-locus check on affine rows ten through fourteen

Kernel reduction compares ordinary uncoveredness with membership in the displayed uncovered orbit
on the 95 canonical affine points `[1:y:z]` with `10 ≤ y ≤ 14`.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredLocusY10To14

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- Ordinary uncoveredness agrees with the displayed orbit on affine rows ten through fourteen. -/
theorem uncovered_locus_agreement :
    uncoveredLocusAgreementOn canonicalPointsY10To14 = true := by
  decide

end NinePointHeisenbergUncoveredLocusY10To14
end RelativeConicArcs
