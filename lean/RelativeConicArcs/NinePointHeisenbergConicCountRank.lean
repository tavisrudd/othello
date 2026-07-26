import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Evaluation rank for five-subset conics

Kernel reduction checks a nonzero maximal minor for the quadratic evaluation matrix of every
five-subset of the explicit uncovered nine-arc.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicCountRank

open NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- Every five-point evaluation matrix has a nonzero maximal minor, so its quadratic kernel is
one-dimensional. -/
theorem each_five_subset_has_full_evaluation_rank :
    fiveSubsetIndexLists.all (fun indices =>
      (List.ofFn fun omitted : Fin 6 => omitted).any fun omitted =>
        decide (Matrix.det (fivePointEvaluationMinor indices omitted) ≠ 0)) = true := by
  have checked :
      fiveSubsetIndexLists.all (fun indices =>
        (List.ofFn fun omitted : Fin 6 => omitted).any fun omitted =>
          decide (determinantFive (fivePointEvaluationMinor indices omitted) ≠ 0)) = true := by
    decide +kernel
  simpa only [determinantFive_eq_det] using checked

end NinePointHeisenbergConicCountRank
end RelativeConicArcs
