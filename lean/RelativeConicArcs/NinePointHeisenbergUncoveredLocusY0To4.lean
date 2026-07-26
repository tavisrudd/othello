import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Uncovered-locus check on affine rows zero through four

Kernel reduction compares ordinary uncoveredness with membership in the displayed uncovered orbit
on the 95 canonical affine points `[1:y:z]` with `0 ≤ y ≤ 4`.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredLocusY0To4

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- Ordinary uncoveredness agrees with the displayed orbit on affine rows zero through four. -/
theorem uncovered_locus_agreement :
    uncoveredLocusAgreementOn canonicalPointsY0To4 = true := by
  decide

end NinePointHeisenbergUncoveredLocusY0To4
end RelativeConicArcs
