import RelativeConicArcs.GoldenMatchingJacobianBase

/-!
# The `4+2` matching-Jacobian collision identity

The sum of two explicit four-by-four Jacobian minors factors as a unit-bearing
multiple of `c(a-b)` on the chosen `4+2` chart.  The proof is symbolic
normalization in Lean's kernel and imports no external polynomial certificate.
-/

namespace RelativeConicArcs.GoldenMatchingJacobian

/-- On the `4+2` chart, two Jacobian minors give a unit-bearing multiple of
the collision generator `c(a-b)`. -/
theorem fourTwo_minor_identity (a b c d : ℚ) :
    minorTwenty (chartFourTwo a b c d) +
      minorTwentyFive (chartFourTwo a b c d) =
    (1 + c) * (d - a - 1) * (d - b - 1) *
      (a + b + c + d + 1) * c * (a - b) := by
  simp [minorTwenty, minorTwentyFive, selectedMinor, detFour, detThree,
    matchingJacobian, chartFourTwo, withoutZero, withoutOne]
  ring

end RelativeConicArcs.GoldenMatchingJacobian
