import RelativeConicArcs.QuadraticPinching
import RelativeConicArcs.SplitQuadraticPinching
import RelativeConicArcs.InvolutiveOddUnit
import RelativeConicArcs.GoldenQuadraticCharacters
import RelativeConicArcs.TightFrameConference
import RelativeConicArcs.SignedEquiangularGram
import RelativeConicArcs.ClebschGoldenConference
import RelativeConicArcs.MarkedClebschBridge
import RelativeConicArcs.PetersenHarmonicKernel
import RelativeConicArcs.ClebschInvariantCubic

/-!
# Structural correspondence for the Clebsch passages

This file collects the exact algebraic joints used by the paper.  It does
not identify Hitchin's geometric objects with these abstract models: those
geometric identifications remain explicit hypotheses in the prose.  The
purpose of the declarations here is narrower and sharper: once the chart,
golden, marked, or Petersen datum has been identified, every scalar and
conductor appearing downstream is forced by a structural theorem.
-/

namespace RelativeConicArcs.ClebschPassagesCorrespondence

open RelativeConicArcs.SplitQuadraticPinching
open RelativeConicArcs.GoldenQuadraticCharacters
open RelativeConicArcs.PetersenHarmonicKernel
open RelativeConicArcs.ClebschInvariantCubic

/-- The chart branch parameter `4*r*σ` has square `80*σ²` as soon as
`r²=5`.  Thus the coefficient eighty is the product `4²*5`, not an
independent coordinate constant. -/
theorem chartBranch_square {S : Type*} [CommRing S] {r sigma : S}
    (hr : r ^ 2 = 5) :
    (4 * r * sigma) ^ 2 = 80 * sigma ^ 2 := by
  calc
    (4 * r * sigma) ^ 2 = 16 * r ^ 2 * sigma ^ 2 := by ring
    _ = 80 * sigma ^ 2 := by rw [hr]; ring

/-- In the split chart model, the conductor is supported exactly on both
branches of the intrinsic parameter `4*r*σ`. -/
theorem chartConductor_eq_branchIdeal {S : Type*} [CommRing S]
    (r sigma : S) :
    subringConductor (splitPinching (4 * r * sigma)) =
      branchIdeal (4 * r * sigma) :=
  conductor_eq_branchIdeal (4 * r * sigma)

/-- A golden root simultaneously supplies its conjugate root, their norm
`-1`, and the discriminant square root. -/
theorem goldenRoot_structural_package {S : Type*} [CommRing S] {t : S}
    (ht : t ^ 2 = t + 1) :
    goldenConjugate t ^ 2 = goldenConjugate t + 1 ∧
      t * goldenConjugate t = -1 ∧
      (2 * t - 1) ^ 2 = 5 := by
  exact ⟨goldenConjugate_relation ht, golden_mul_conjugate ht,
    golden_discriminant_square ht⟩

/-- Pulling the normalized Petersen Gram scalar back through the pair-sum
map contributes the forced factor three. -/
theorem petersenPullback_scalar :
    3 * (140 / 1053 : ℚ) = 140 / 351 := by
  norm_num

/-- The normalized marked chart point forces the displayed branch square;
there is no free denominator or independent magic number. -/
theorem normalizedMarked_chart_value :
    (16 : ℚ) * sigmaThree normalizedMarkedVector ^ 2 = (16 / 25) ^ 2 :=
  chartFactor_at_normalizedMarkedVector

/-- Once invariant theory places the harmonic cubic on the Clebsch line,
one marked value fixes its coefficient everywhere on the sum-zero space. -/
theorem markedValue_determines_gauntCoefficient
    {F : (Fin 5 → ℚ) → ℚ}
    (hline : LiesOnSigmaThreeLine F)
    (hmarked : F markedFixedVector = -15680000 / 1247103) :
    ∀ y, (∑ i, y i = 0) →
      F y = (-784000 / 1247103 : ℚ) * sigmaThree y :=
  eq_gauntCoefficient_mul_sigmaThree hline hmarked

/-- The final Gaunt coefficient splits into the universal Wigner factor and
the marked Petersen restriction factor. -/
theorem gauntCoefficient_has_two_structural_factors :
    (-784000 / 1247103 : ℚ) =
      -wignerSixFactor * petersenRestrictionFactor :=
  gauntCoefficient_factorization

end RelativeConicArcs.ClebschPassagesCorrespondence
