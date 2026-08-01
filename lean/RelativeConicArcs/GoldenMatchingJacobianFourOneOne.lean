import RelativeConicArcs.GoldenMatchingJacobianBase

/-!
# The `4+1+1` matching-Jacobian collision identity

The displayed rational linear combination of six explicit four-by-four
Jacobian minors factors as a unit-bearing multiple of `c(a-b)` on the chosen
`4+1+1` chart.  The proof is symbolic normalization in Lean's kernel and
imports no external polynomial certificate.
-/

namespace RelativeConicArcs.GoldenMatchingJacobian

/-- On the `4+1+1` chart, a linear combination of six Jacobian minors is a
unit-bearing multiple of the collision generator `c(a-b)`. -/
theorem fourOneOne_minor_identity (a b c d : ℚ) :
    (1 / 2) * minorFive (chartFourOneOne a b c d) +
      (1 / 6) * (minorSixteen (chartFourOneOne a b c d) +
        minorSeventeen (chartFourOneOne a b c d) +
        minorTwentyOne (chartFourOneOne a b c d)) +
      ((2 * c - 2 * d + 4) / 3) * minorTwenty (chartFourOneOne a b c d) +
      ((-2 * d + 2) / 3) * minorTwentyFive (chartFourOneOne a b c d) =
    -(1 + c) * (d - 2) * (d - 1) * (d - c - 2) *
      (c + d - 1) * c * (a - b) := by
  simp [minorFive, minorSixteen, minorSeventeen, minorTwenty,
    minorTwentyOne, minorTwentyFive, selectedMinor, detFour, detThree,
    matchingJacobian, chartFourOneOne, withoutZero, withoutOne,
    withoutThree, withoutFour]
  ring

end RelativeConicArcs.GoldenMatchingJacobian
