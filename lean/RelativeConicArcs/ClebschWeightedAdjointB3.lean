import RelativeConicArcs.ArrangementWeightedAdjoint

/-!
# Checked weighted two-adjoint data for the displayed `B3` arrangement

Over `F_11`, take the nine projective line directions with normals

`X, Y, Z, X±Y, X±Z, Y±Z`.

This file exhaustively checks, by Lean kernel reduction over all 133 normalized projective points,
their incidence multiplicities, weighted two-adjoint depths, complement line sections, and the
punctured depth spectrum.  No generated data, external certificate, `native_decide`, or opaque
oracle is used.  Calling this coordinate model the projectivized `B3` reflection arrangement uses
the semantic identification recorded by Paper I trust-manifest claim
`thm-headline-rigidity-phase-clause-2`; Lean checks the displayed finite model itself.
-/

namespace RelativeConicArcs
namespace ArrangementWeightedAdjoint
namespace CoxeterModels

open Examples.ReflectionArrangements
open Examples.Q11Coding

set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

/-- The nine normals `X, Y, Z, X±Y, X±Z, Y±Z` over `F_11`. -/
def b3RootDirection : Fin 9 → Point11
  | 0 => ![1, 0, 0]
  | 1 => ![0, 1, 0]
  | 2 => ![0, 0, 1]
  | 3 => ![1, 1, 0]
  | 4 => ![1, -1, 0]
  | 5 => ![1, 0, 1]
  | 6 => ![1, 0, -1]
  | 7 => ![0, 1, 1]
  | 8 => ![0, 1, -1]

/-- Incidence multiplicity of a normalized projective point with the nine displayed lines. -/
def b3Multiplicity (p : Fin 133) : ℕ :=
  (Finset.univ.filter fun i : Fin 9 =>
    dot (b3RootDirection i) (projectiveVec p) = 0).card

/-- Normalized projective points of a fixed incidence multiplicity. -/
def b3PointsOfMultiplicity (m : ℕ) : Finset (Fin 133) :=
  Finset.univ.filter fun p => b3Multiplicity p = m

/-- Weighted two-adjoint depth of a normalized projective test line. -/
def b3WeightedDepth (L : Fin 133) : ℕ :=
  ∑ p ∈ (Finset.univ.filter fun p : Fin 133 =>
      dot (projectiveVec L) (projectiveVec p) = 0),
    (b3Multiplicity p - 1)

/-- The nine displayed projective mirror directions. -/
def b3Mirrors : Finset (Fin 133) :=
  Finset.univ.filter fun L =>
    ∃ i : Fin 9, SameDirection (projectiveVec L) (b3RootDirection i)

/-- Complement points on a displayed `B3` test line. -/
def b3SectionCard (L : Fin 133) : ℕ :=
  (Finset.univ.filter fun p : Fin 133 =>
    b3Multiplicity p = 0 ∧ dot (projectiveVec L) (projectiveVec p) = 0).card

/-- The actual `F_11` evaluation-word weight on the 48 displayed complement points. -/
def b3EvaluationWeight (a : Point11) : ℕ :=
  projectiveEvaluationWeight projectiveVec (b3PointsOfMultiplicity 0) a

/-- Coefficient vectors of weight `w` in the displayed `B3/F_11` evaluation code. -/
def b3CoefficientVectorsOfWeight (w : ℕ) : Finset Point11 :=
  coefficientVectorsOfWeight projectiveVec (b3PointsOfMultiplicity 0) w

/-- Exhaustive `B3/F_11` multiplicity, weighted-depth, and line-section certificate.

The arrangement-point spectrum is `48,72,6,4,3` at multiplicities `0,1,2,3,4`.
After removing the nine mirrors, the weighted-depth spectrum is `24,36,24,40` at depths
`0,1,2,3`; each mirror has depth eight. -/
theorem b3_weightedAdjoint_certificate :
    (b3PointsOfMultiplicity 0).card = 48 ∧
    (b3PointsOfMultiplicity 1).card = 72 ∧
    (b3PointsOfMultiplicity 2).card = 6 ∧
    (b3PointsOfMultiplicity 3).card = 4 ∧
    (b3PointsOfMultiplicity 4).card = 3 ∧
    b3Mirrors.card = 9 ∧
    (∀ L ∈ b3Mirrors, b3WeightedDepth L = 8) ∧
    ((Finset.univ \ b3Mirrors).filter fun L => b3WeightedDepth L = 0).card = 24 ∧
    ((Finset.univ \ b3Mirrors).filter fun L => b3WeightedDepth L = 1).card = 36 ∧
    ((Finset.univ \ b3Mirrors).filter fun L => b3WeightedDepth L = 2).card = 24 ∧
    ((Finset.univ \ b3Mirrors).filter fun L => b3WeightedDepth L = 3).card = 40 ∧
    (∀ L ∉ b3Mirrors, b3SectionCard L + 9 = 12 + b3WeightedDepth L) := by
  decide

/-- Actual coefficient-vector distribution and exact minimum distance of the displayed
`B3/F_11` arrangement-complement evaluation code.  Its Hamming enumerator is
`1 + 400 z^42 + 240 z^43 + 360 z^44 + 240 z^45 + 90 z^48`; every nonzero coefficient has
weight at least 42 and weight 42 is attained. -/
theorem b3_evaluationCode_weightDistribution :
    (b3PointsOfMultiplicity 0).card = 48 ∧
    (b3CoefficientVectorsOfWeight 0).card = 1 ∧
    (b3CoefficientVectorsOfWeight 42).card = 400 ∧
    (b3CoefficientVectorsOfWeight 43).card = 240 ∧
    (b3CoefficientVectorsOfWeight 44).card = 360 ∧
    (b3CoefficientVectorsOfWeight 45).card = 240 ∧
    (b3CoefficientVectorsOfWeight 48).card = 90 ∧
    (∀ a : Point11, b3EvaluationWeight a = 0 ∨ b3EvaluationWeight a = 42 ∨
      b3EvaluationWeight a = 43 ∨ b3EvaluationWeight a = 44 ∨
      b3EvaluationWeight a = 45 ∨ b3EvaluationWeight a = 48) ∧
    (∀ a : Point11, a ≠ 0 → 42 ≤ b3EvaluationWeight a) ∧
    (∃ a : Point11, a ≠ 0 ∧ b3EvaluationWeight a = 42) := by
  decide

/-- On every nonmirror projective coefficient direction, the actual `B3/F_11` evaluation weight is
the depth-regraded value `45-δ`; nonzero scalar representatives have the same weight. -/
theorem b3_evaluationWeight_eq_fortyFive_sub_weightedDepth :
    ∀ L ∉ b3Mirrors, ∀ s : NonzeroScalar,
      b3EvaluationWeight (s.1 • projectiveVec L) = 45 - b3WeightedDepth L := by
  decide

/-- The displayed `B3/F_11` coefficient evaluation is injective, so its coefficient distribution
is a distribution of distinct codewords. -/
theorem b3_evaluationWord_injective :
    Function.Injective
      (projectiveEvaluationWord projectiveVec (b3PointsOfMultiplicity 0)) := by
  apply projectiveEvaluationWord_injective_of_positive
  intro a ha
  rcases b3_evaluationCode_weightDistribution with
    ⟨_, _, _, _, _, _, _, _, hbound, _⟩
  exact lt_of_lt_of_le (by omega) (hbound a ha)

end CoxeterModels
end ArrangementWeightedAdjoint
end RelativeConicArcs
