import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Uncovered-locus check on the last affine rows and the line at infinity

Kernel reduction compares ordinary uncoveredness with membership in the displayed uncovered orbit
on the 76 canonical affine points `[1:y:z]` with `15 ≤ y ≤ 18` and the 20 points at infinity.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredLocusY15To18AndInfinity

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- Ordinary uncoveredness agrees with the displayed orbit on the last 96 canonical points. -/
theorem uncovered_locus_agreement :
    uncoveredLocusAgreementOn canonicalPointsY15To18AndInfinity = true := by
  decide

end NinePointHeisenbergUncoveredLocusY15To18AndInfinity
end RelativeConicArcs
