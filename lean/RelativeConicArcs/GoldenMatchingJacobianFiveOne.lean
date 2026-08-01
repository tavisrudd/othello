import RelativeConicArcs.GoldenMatchingJacobianBase

/-!
# The `5+1` matching-Jacobian collision identity

The displayed rational linear combination of six explicit four-by-four
Jacobian minors factors as a unit-bearing multiple of
`c*d*(a-b)*(c-d)` on the chosen `5+1` chart.  The proof is symbolic
normalization in Lean's kernel and imports no external polynomial certificate.
-/

namespace RelativeConicArcs.GoldenMatchingJacobian

/-- On the `5+1` chart, a linear combination of six Jacobian minors is a
unit-bearing multiple of the collision generator `c*d*(a-b)*(c-d)`. -/
theorem fiveOne_minor_identity (a b c d : ℚ) :
    (1 / 2) * minorFive (chartFiveOne a b c d) +
      (1 / 6) * (minorSixteen (chartFiveOne a b c d) +
        minorSeventeen (chartFiveOne a b c d) +
        minorTwentyOne (chartFiveOne a b c d)) +
      ((2 * c - 2 * d) / 3) * minorTwenty (chartFiveOne a b c d) +
      ((-2 * d - 2) / 3) * minorTwentyFive (chartFiveOne a b c d) =
    (1 + c) * (1 + d) * (1 + c + d) * c * d * (a - b) * (c - d) := by
  simp [minorFive, minorSixteen, minorSeventeen, minorTwenty,
    minorTwentyOne, minorTwentyFive, selectedMinor, detFour, detThree,
    matchingJacobian, chartFiveOne, withoutZero, withoutOne,
    withoutThree, withoutFour]
  ring

end RelativeConicArcs.GoldenMatchingJacobian
