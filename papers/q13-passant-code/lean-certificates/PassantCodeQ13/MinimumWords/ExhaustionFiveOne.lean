import PassantCodeQ13.MinimumWords.ExhaustionFiveOneData

/-! # Kernel checks for the five-one fixed-point profile -/

namespace PassantCodeQ13.MinimumWords

set_option maxRecDepth 100000
set_option maxHeartbeats 0 in
theorem fiveOneShardCheck_zero : fiveOneShardCheck 0 fiveOneClassifier0 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
