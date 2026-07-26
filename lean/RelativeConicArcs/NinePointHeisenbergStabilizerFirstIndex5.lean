import RelativeConicArcs.NinePointHeisenbergStabilizer

/-!
# Stabilizer transporters with first target-list index five

The first image is the sixth listed point of the relevant target orbit.  Each private theorem
fixes the second target-list index and kernel-checks the remaining ordered target frames: 42 for
each distinct second image and none for the repeated image.  The nine blocks cover 336 frames
without an imported transporter certificate.
-/
namespace RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex5
open NinePointHeisenbergStabilizer
set_option maxHeartbeats 800000000
set_option maxRecDepth 100000
private theorem s0 : stabilizerPrefixProfile 5 0 = true := by decide
private theorem s1 : stabilizerPrefixProfile 5 1 = true := by decide
private theorem s2 : stabilizerPrefixProfile 5 2 = true := by decide
private theorem s3 : stabilizerPrefixProfile 5 3 = true := by decide
private theorem s4 : stabilizerPrefixProfile 5 4 = true := by decide
private theorem s5 : stabilizerPrefixProfile 5 5 = true := by decide
private theorem s6 : stabilizerPrefixProfile 5 6 = true := by decide
private theorem s7 : stabilizerPrefixProfile 5 7 = true := by decide
private theorem s8 : stabilizerPrefixProfile 5 8 = true := by decide
/-- All second-index blocks over first target-list index five satisfy the exact profile. -/
theorem transporter_profile :
    stabilizerPrefixProfile 5 0 = true ∧ stabilizerPrefixProfile 5 1 = true ∧
    stabilizerPrefixProfile 5 2 = true ∧ stabilizerPrefixProfile 5 3 = true ∧
    stabilizerPrefixProfile 5 4 = true ∧ stabilizerPrefixProfile 5 5 = true ∧
    stabilizerPrefixProfile 5 6 = true ∧ stabilizerPrefixProfile 5 7 = true ∧
    stabilizerPrefixProfile 5 8 = true := ⟨s0, s1, s2, s3, s4, s5, s6, s7, s8⟩
end RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex5
