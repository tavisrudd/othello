import RelativeConicArcs.NinePointHeisenbergStabilizer

/-!
# Stabilizer transporters with first target-list index two

The first image is the third listed point of the relevant target orbit.  Each private theorem
fixes the second target-list index and kernel-checks the remaining ordered target frames: 42 for
each distinct second image and none for the repeated image.  The nine blocks cover 336 frames
without an imported transporter certificate.
-/

namespace RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex2
open NinePointHeisenbergStabilizer
set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

private theorem s0 : stabilizerPrefixProfile 2 0 = true := by decide
private theorem s1 : stabilizerPrefixProfile 2 1 = true := by decide
private theorem s2 : stabilizerPrefixProfile 2 2 = true := by decide
private theorem s3 : stabilizerPrefixProfile 2 3 = true := by decide
private theorem s4 : stabilizerPrefixProfile 2 4 = true := by decide
private theorem s5 : stabilizerPrefixProfile 2 5 = true := by decide
private theorem s6 : stabilizerPrefixProfile 2 6 = true := by decide
private theorem s7 : stabilizerPrefixProfile 2 7 = true := by decide
private theorem s8 : stabilizerPrefixProfile 2 8 = true := by decide

/-- All nine second-index transporter blocks over first target-list index two satisfy the exact
stabilizer and inequivalence profile. -/
theorem transporter_profile :
    stabilizerPrefixProfile 2 0 = true ∧ stabilizerPrefixProfile 2 1 = true ∧
    stabilizerPrefixProfile 2 2 = true ∧ stabilizerPrefixProfile 2 3 = true ∧
    stabilizerPrefixProfile 2 4 = true ∧ stabilizerPrefixProfile 2 5 = true ∧
    stabilizerPrefixProfile 2 6 = true ∧ stabilizerPrefixProfile 2 7 = true ∧
    stabilizerPrefixProfile 2 8 = true := ⟨s0, s1, s2, s3, s4, s5, s6, s7, s8⟩

end RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex2
