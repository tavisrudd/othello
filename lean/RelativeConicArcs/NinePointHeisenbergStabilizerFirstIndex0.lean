import RelativeConicArcs.NinePointHeisenbergStabilizer

/-!
# Stabilizer transporters with first target-list index zero

The first image is the first listed point of the relevant target orbit.  Each terminal fixes the
second target-list index and kernel-checks the remaining ordered target frames: 42 for each of the
eight distinct second images and none for the repeated image.  The nine blocks cover 336 frames
without an imported transporter certificate.
-/

namespace RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex0
open NinePointHeisenbergStabilizer
set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

private theorem s0 : stabilizerPrefixProfile 0 0 = true := by decide
private theorem s1 : stabilizerPrefixProfile 0 1 = true := by decide
private theorem s2 : stabilizerPrefixProfile 0 2 = true := by decide
private theorem s3 : stabilizerPrefixProfile 0 3 = true := by decide
private theorem s4 : stabilizerPrefixProfile 0 4 = true := by decide
private theorem s5 : stabilizerPrefixProfile 0 5 = true := by decide
private theorem s6 : stabilizerPrefixProfile 0 6 = true := by decide
private theorem s7 : stabilizerPrefixProfile 0 7 = true := by decide
private theorem s8 : stabilizerPrefixProfile 0 8 = true := by decide

/-- All nine second-index transporter blocks over first target-list index zero satisfy the exact
stabilizer and inequivalence profile. -/
theorem transporter_profile :
    stabilizerPrefixProfile 0 0 = true ∧ stabilizerPrefixProfile 0 1 = true ∧
    stabilizerPrefixProfile 0 2 = true ∧ stabilizerPrefixProfile 0 3 = true ∧
    stabilizerPrefixProfile 0 4 = true ∧ stabilizerPrefixProfile 0 5 = true ∧
    stabilizerPrefixProfile 0 6 = true ∧ stabilizerPrefixProfile 0 7 = true ∧
    stabilizerPrefixProfile 0 8 = true := ⟨s0, s1, s2, s3, s4, s5, s6, s7, s8⟩

end RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex0
