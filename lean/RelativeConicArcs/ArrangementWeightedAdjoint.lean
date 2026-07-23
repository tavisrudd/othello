import RelativeConicArcs.ClebschConicMatchingQuotient
import RelativeConicArcs.ClebschGatewayCoxeterPhase
import RelativeConicArcs.ReflectionArrangements
import Mathlib.RingTheory.Polynomial.Basic

/-!
# Weighted two-adjoint depth and rank-three arrangement codes

Let an arrangement of `N` distinct projective lines be given in a finite projective plane of order
`q`.  A non-arrangement test line meets the arrangement in a finite set of points.  If `m(P)` is
the number of arrangement lines through an intersection point, its weighted two-adjoint depth is

`δ = ∑ₚ (m(P) - 1)`.

Counting the arrangement lines by their unique intersections with the test line gives

`|B ∩ L| + N = q + 1 + δ`,

where `B` is the arrangement complement.  The first layer proves the underlying finite-cardinality
identity from an explicit section profile; it does not construct projective incidence from those
hypotheses.  A second, numeric profile layer derives the punctured depth polynomial and the formal
projective-direction regrading, conditional on its recorded section and spanning inequalities.

The actual code layer is separate.  It evaluates vectors in `K^3`, for an explicit field `K`, on a
finite set of displayed projective representatives and uses ordinary Hamming weight.  Positivity
of every nonzero coefficient word is proved to make this evaluation injective.  The finite
`A3/F_5`, `B3/F_11`, and `H3/F_11` terminals count these actual coefficient vectors by weight and
prove attained minimum weights; their counts therefore give Hamming enumerators of distinct
codewords.

The final section checks the `A3` model over `F_5` and the `H3` model over `F_11` from the public
coordinate tables in `RelativeConicArcs.ReflectionArrangements`.  Those labels describe the
displayed finite models; identifying them with abstract reflection arrangements is a separate
classical input.  All finite checks in this file use kernel reduction by `decide`.
-/

open scoped BigOperators

namespace RelativeConicArcs
namespace ArrangementWeightedAdjoint

/-- Incidence data on one non-arrangement projective test line.

`points` is the set of distinct intersections with arrangement lines, and `multiplicity p` is the
number of arrangement lines meeting the test line at `p`.  Positivity excludes spurious points,
while `totalMultiplicity` is the incidence count obtained because every arrangement line has one
intersection with the test line. -/
structure SectionProfile (P : Type*) [DecidableEq P] where
  points : Finset P
  multiplicity : P → ℕ
  mirrorCount : ℕ
  positive : ∀ p ∈ points, 0 < multiplicity p
  totalMultiplicity : ∑ p ∈ points, multiplicity p = mirrorCount

/-- Weighted two-adjoint depth on a test line: each singular point of multiplicity `m` contributes
`m - 1`; ordinary intersections contribute zero. -/
def SectionProfile.weightedDepth {P : Type*} [DecidableEq P]
    (S : SectionProfile P) : ℕ :=
  ∑ p ∈ S.points, (S.multiplicity p - 1)

/-- The weighted depth plus the number of distinct intersection points equals the number of
arrangement lines.  This is the rank-three weighted two-adjoint depth identity. -/
theorem SectionProfile.weightedDepth_add_card {P : Type*} [DecidableEq P]
    (S : SectionProfile P) :
    S.weightedDepth + S.points.card = S.mirrorCount := by
  rw [SectionProfile.weightedDepth, ← S.totalMultiplicity]
  calc
    (∑ p ∈ S.points, (S.multiplicity p - 1)) + S.points.card =
        ∑ p ∈ S.points, ((S.multiplicity p - 1) + 1) := by
          have hcard : S.points.card = ∑ _p ∈ S.points, 1 := by simp
          rw [hcard, ← Finset.sum_add_distrib]
    _ = ∑ p ∈ S.points, S.multiplicity p := by
      apply Finset.sum_congr rfl
      intro p hp
      exact Nat.sub_add_cancel (S.positive p hp)

/-- Ambient line-section formula.  If a projective line has `q+1` points and its points forbidden
by the arrangement are exactly the distinct intersections in `S.points`, then the complement
section has cardinality `q+1-N+δ`, written without truncated subtraction as
`section + N = q+1+δ`. -/
theorem lineSection_card_add_mirrorCount {P : Type*} [DecidableEq P]
    (S : SectionProfile P) (linePoints : Finset P) (q : ℕ)
    (hpoints : S.points ⊆ linePoints) (hline : linePoints.card = q + 1) :
    (linePoints \ S.points).card + S.mirrorCount =
      q + 1 + S.weightedDepth := by
  have hcard : S.points.card ≤ linePoints.card := Finset.card_le_card hpoints
  have hdepth := S.weightedDepth_add_card
  rw [Finset.card_sdiff, Finset.inter_eq_left.mpr hpoints,
    hline]
  omega

/-- Numeric profile expected from a rank-three projective arrangement code after coefficient
directions have been chosen.  This structure records arithmetic data and identities only; it does
not contain a field, projective space, evaluation map, or proof that `Line` parametrizes coefficient
directions.  The actual finite-field evaluation layer below supplies those objects separately. -/
structure CodeProfile (Line : Type*) [Fintype Line] [DecidableEq Line] where
  q : ℕ
  length : ℕ
  mirrorCount : ℕ
  mirrors : Finset Line
  depth : Line → ℕ
  sectionCard : Line → ℕ
  mirrors_card : mirrors.card = mirrorCount
  mirror_depth : ∀ L ∈ mirrors, depth L = mirrorCount - 1
  mirror_section : ∀ L ∈ mirrors, sectionCard L = 0
  nonmirror_section :
    ∀ L ∉ mirrors, sectionCard L + mirrorCount = q + 1 + depth L
  spans : ∀ L, sectionCard L < length

/-- The complete weighted-depth polynomial over all projective test lines. -/
noncomputable def CodeProfile.depthPolynomial {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) : Polynomial ℕ :=
  ∑ L : Line, Polynomial.X ^ C.depth L

/-- The punctured weighted-depth polynomial, with the original arrangement mirrors removed. -/
noncomputable def CodeProfile.puncturedDepthPolynomial
    {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) : Polynomial ℕ :=
  ∑ L ∈ (Finset.univ \ C.mirrors), Polynomial.X ^ C.depth L

/-- The full depth polynomial is the punctured polynomial plus `N` copies of `x^(N-1)`.  The
puncture is therefore intrinsic once every original mirror has weighted depth `N-1`. -/
theorem CodeProfile.depthPolynomial_eq_mirror_add_punctured
    {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) :
    C.depthPolynomial =
      C.mirrorCount • (Polynomial.X ^ (C.mirrorCount - 1) : Polynomial ℕ) +
        C.puncturedDepthPolynomial := by
  rw [CodeProfile.depthPolynomial, CodeProfile.puncturedDepthPolynomial]
  rw [← Finset.sum_sdiff C.mirrors.subset_univ]
  rw [add_comm (∑ L ∈ Finset.univ \ C.mirrors,
    (Polynomial.X : Polynomial ℕ) ^ C.depth L)]
  congr 1
  calc
    ∑ L ∈ C.mirrors, (Polynomial.X : Polynomial ℕ) ^ C.depth L =
        ∑ _L ∈ C.mirrors,
          (Polynomial.X : Polynomial ℕ) ^ (C.mirrorCount - 1) := by
            apply Finset.sum_congr rfl
            intro L hL
            rw [C.mirror_depth L hL]
    _ = C.mirrorCount •
        (Polynomial.X ^ (C.mirrorCount - 1) : Polynomial ℕ) := by
          simp [C.mirrors_card]

/-- The coefficient of `x^d` in the punctured polynomial is exactly the number of nonmirror test
lines of weighted depth `d`. -/
theorem CodeProfile.puncturedDepthPolynomial_coeff
    {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) (d : ℕ) :
    C.puncturedDepthPolynomial.coeff d =
      ((Finset.univ \ C.mirrors).filter fun L => C.depth L = d).card := by
  simpa only [eq_comm] using
    (show C.puncturedDepthPolynomial.coeff d =
      ((Finset.univ \ C.mirrors).filter fun L => d = C.depth L).card by
        simp [CodeProfile.puncturedDepthPolynomial, Polynomial.coeff_X_pow])

/-- Hamming weight attached to a projective coefficient direction: the code length minus the
number of evaluation points on its kernel line. -/
def CodeProfile.wordWeight {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) (L : Line) : ℕ :=
  C.length - C.sectionCard L

/-- Formal one-variable weight polynomial attached to a numeric profile.  Interpreting it as a
Hamming enumerator additionally requires a finite-field coefficient-direction parametrization and
an injective evaluation map; the concrete terminals below verify actual codeword distributions
instead of deriving that interpretation from this definition. -/
noncomputable def CodeProfile.hammingEnumerator
    {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) : Polynomial ℕ :=
  1 + (C.q - 1) • ∑ L : Line, Polynomial.X ^ C.wordWeight L

/-- The exponent determined by a weighted depth through the line-section formula. -/
def CodeProfile.weightAtDepth {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) (d : ℕ) : ℕ :=
  C.length + C.mirrorCount - (C.q + 1 + d)

/-- On a nonmirror direction the Hamming weight is the depth-regraded exponent
`n+N-(q+1+δ)`. -/
theorem CodeProfile.wordWeight_eq_weightAtDepth
    {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) (L : Line) (hL : L ∉ C.mirrors) :
    C.wordWeight L = C.weightAtDepth (C.depth L) := by
  rw [CodeProfile.wordWeight, CodeProfile.weightAtDepth]
  have hs := C.nonmirror_section L hL
  have hlt := C.spans L
  omega

/-- The formal profile polynomial splits into the mirror contribution at exponent `n` and the
punctured weighted-depth sum regraded by `δ ↦ n+N-(q+1+δ)`. -/
theorem CodeProfile.hammingEnumerator_eq_weightedDepthSum
    {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) :
    C.hammingEnumerator =
      1 +
      (C.q - 1) •
        (C.mirrorCount • (Polynomial.X ^ C.length : Polynomial ℕ)) +
      (C.q - 1) •
        ∑ L ∈ (Finset.univ \ C.mirrors),
          Polynomial.X ^ C.weightAtDepth (C.depth L) := by
  rw [CodeProfile.hammingEnumerator]
  rw [← Finset.sum_sdiff C.mirrors.subset_univ]
  rw [add_comm (∑ L ∈ Finset.univ \ C.mirrors,
    (Polynomial.X : Polynomial ℕ) ^ C.wordWeight L)]
  have hmirror :
      ∑ L ∈ C.mirrors, (Polynomial.X : Polynomial ℕ) ^ C.wordWeight L =
        C.mirrorCount • (Polynomial.X ^ C.length : Polynomial ℕ) := by
    calc
      ∑ L ∈ C.mirrors, (Polynomial.X : Polynomial ℕ) ^ C.wordWeight L =
          ∑ _L ∈ C.mirrors, (Polynomial.X : Polynomial ℕ) ^ C.length := by
            apply Finset.sum_congr rfl
            intro L hL
            simp [CodeProfile.wordWeight, C.mirror_section L hL]
      _ = C.mirrorCount • (Polynomial.X ^ C.length : Polynomial ℕ) := by
        simp [C.mirrors_card]
  rw [hmirror]
  have hnonmirror :
      ∑ L ∈ Finset.univ \ C.mirrors,
          (Polynomial.X : Polynomial ℕ) ^ C.wordWeight L =
        ∑ L ∈ Finset.univ \ C.mirrors,
          Polynomial.X ^ C.weightAtDepth (C.depth L) := by
    apply Finset.sum_congr rfl
    intro L hL
    rw [C.wordWeight_eq_weightAtDepth L (Finset.mem_sdiff.mp hL).2]
  rw [hnonmirror]
  simp [add_assoc]

/-- Extremal consequence inside a numeric profile.  If `dmax` is attained and bounds every
nonmirror depth, then `weightAtDepth dmax` is attained among profile directions and bounds every
profile direction weight.  A code minimum-distance interpretation requires the separate
finite-field evaluation and injectivity bridge. -/
theorem CodeProfile.minimumDistance_of_maxDepth
    {Line : Type*} [Fintype Line] [DecidableEq Line]
    (C : CodeProfile Line) (dmax : ℕ)
    (hbound : ∀ L ∉ C.mirrors, C.depth L ≤ dmax)
    (hattain : ∃ L, L ∉ C.mirrors ∧ C.depth L = dmax) :
    (∀ L, C.weightAtDepth dmax ≤ C.wordWeight L) ∧
      ∃ L, C.wordWeight L = C.weightAtDepth dmax := by
  obtain ⟨Lmax, hLmax, hdepth⟩ := hattain
  constructor
  · intro L
    by_cases hL : L ∈ C.mirrors
    · rw [CodeProfile.wordWeight, C.mirror_section L hL]
      simp
      have hlt := C.spans Lmax
      have hs := C.nonmirror_section Lmax hLmax
      rw [CodeProfile.weightAtDepth]
      omega
    · rw [C.wordWeight_eq_weightAtDepth L hL, CodeProfile.weightAtDepth,
        CodeProfile.weightAtDepth]
      have hsL := C.nonmirror_section L hL
      have hsMax := C.nonmirror_section Lmax hLmax
      have hb := hbound L hL
      have hltL := C.spans L
      have hltMax := C.spans Lmax
      omega
  · exact ⟨Lmax, by rw [C.wordWeight_eq_weightAtDepth Lmax hLmax, hdepth]⟩

/-- Evaluation of a linear form on a finite set of displayed projective representatives.  The
coordinate type is `Fin 3 → K`; the output coordinates are indexed only by points in `evaluationSet`.
-/
def projectiveEvaluationWord {K P : Type*} [Field K] [DecidableEq K] [DecidableEq P]
    (pointVector : P → Fin 3 → K) (evaluationSet : Finset P) (a : Fin 3 → K) :
    {p : P // p ∈ evaluationSet} → K :=
  fun p => Examples.ReflectionArrangements.dot a (pointVector p.1)

/-- Hamming weight of an actual coefficient vector in the displayed projective evaluation code. -/
def projectiveEvaluationWeight {K P : Type*} [Field K] [DecidableEq K] [DecidableEq P]
    (pointVector : P → Fin 3 → K) (evaluationSet : Finset P) (a : Fin 3 → K) : ℕ :=
  CodingBridge.hammingWeight (projectiveEvaluationWord pointVector evaluationSet a)

/-- Coefficient vectors of a specified Hamming weight in a displayed projective evaluation code. -/
def coefficientVectorsOfWeight {K P : Type*} [Field K] [Fintype K] [DecidableEq K]
    [DecidableEq P] (pointVector : P → Fin 3 → K) (evaluationSet : Finset P)
    (w : ℕ) : Finset (Fin 3 → K) :=
  Finset.univ.filter fun a => projectiveEvaluationWeight pointVector evaluationSet a = w

/-- If every nonzero coefficient vector gives a positive-weight evaluation word, the coefficient
evaluation map is injective.  This is the exact spanning/nondegeneracy bridge needed to interpret
the coefficient-vector weight distribution as a distribution of distinct codewords. -/
theorem projectiveEvaluationWord_injective_of_positive
    {K P : Type*} [Field K] [DecidableEq K] [DecidableEq P]
    (pointVector : P → Fin 3 → K) (evaluationSet : Finset P)
    (hpositive : ∀ a : Fin 3 → K, a ≠ 0 →
      0 < projectiveEvaluationWeight pointVector evaluationSet a) :
    Function.Injective (projectiveEvaluationWord pointVector evaluationSet) := by
  intro a b hab
  apply sub_eq_zero.mp
  by_contra hne
  have hword :
      projectiveEvaluationWord pointVector evaluationSet (a - b) = 0 := by
    funext p
    have hp := congrFun hab p
    simp only [projectiveEvaluationWord] at hp ⊢
    rw [show Examples.ReflectionArrangements.dot (a - b) (pointVector p.1) =
        Examples.ReflectionArrangements.dot a (pointVector p.1) -
          Examples.ReflectionArrangements.dot b (pointVector p.1) by
      simp [Examples.ReflectionArrangements.dot, sub_mul]
      ring]
    exact sub_eq_zero.mpr hp
  have hz : projectiveEvaluationWeight pointVector evaluationSet (a - b) = 0 := by
    simp [projectiveEvaluationWeight, CodingBridge.hammingWeight,
      CodingBridge.hammingSupport, hword]
  have := hpositive (a - b) hne
  omega

namespace CoxeterModels

open Examples.ReflectionArrangements
open Examples.Q11Coding

set_option maxRecDepth 100000
set_option maxHeartbeats 30000000

/-- Nonzero scalars over `F_5` used to normalize the displayed 31 projective representatives. -/
abbrev NonzeroScalar5 := {a : ZMod 5 // a ≠ 0}

/-- A nonzero vector obtained from a displayed normalized `PG(2,5)` representative and a nonzero
scalar. -/
def affineRayVec5 (p : Fin 31 × NonzeroScalar5) : Point5 :=
  p.2.1 • projectiveVec5 p.1

/-- Every displayed `PG(2,5)` representative is nonzero. -/
theorem projectiveVec5_ne_zero (i : Fin 31) : projectiveVec5 i ≠ 0 := by
  revert i
  decide

/-- The displayed 31 normalized vectors, with four nonzero scalars each, enumerate every nonzero
vector of `F_5^3` exactly once.  This is the completeness and nonduplication bridge from the fixed
coordinate table to `PG(2,5)`. -/
theorem affineRayVec5_bijective :
    Function.Bijective (fun p : Fin 31 × NonzeroScalar5 =>
      (⟨affineRayVec5 p, smul_ne_zero p.2.2 (projectiveVec5_ne_zero p.1)⟩ :
        {v : Point5 // v ≠ 0})) := by
  decide

/-- Weighted two-adjoint depth of an `A3` test line in the displayed `F_5` model. -/
def a3WeightedDepth (L : Fin 31) : ℕ :=
  ∑ p ∈ (Finset.univ.filter fun p : Fin 31 =>
      dot (projectiveVec5 L) (projectiveVec5 p) = 0),
    (a3Multiplicity p - 1)

/-- The displayed `A3` projective directions. -/
def a3Mirrors : Finset (Fin 31) :=
  Finset.univ.filter fun L =>
    ∃ i : Fin 6, SameDirection (projectiveVec5 L) (a3Join i)

/-- Complement points on an `A3` test line. -/
def a3SectionCard (L : Fin 31) : ℕ :=
  (Finset.univ.filter fun p : Fin 31 =>
    a3Multiplicity p = 0 ∧ dot (projectiveVec5 L) (projectiveVec5 p) = 0).card

/-- The actual `F_5` evaluation-word weight on the six displayed arrangement-complement points. -/
def a3EvaluationWeight (a : Point5) : ℕ :=
  projectiveEvaluationWeight projectiveVec5 (a3PointsOfMultiplicity 0) a

/-- Coefficient vectors of weight `w` in the displayed `A3/F_5` evaluation code. -/
def a3CoefficientVectorsOfWeight (w : ℕ) : Finset Point5 :=
  coefficientVectorsOfWeight projectiveVec5 (a3PointsOfMultiplicity 0) w

/-- The `A3/F_5` public incidence theorem together with its checked weighted-depth puncture,
line-section formula, and maximum depth.  The punctured depth counts are `4,6,15` at depths
`0,1,2`; the six mirrors have depth five. -/
theorem a3_weightedAdjoint_specialization :
    (a3PointsOfMultiplicity 0).card = 6 ∧
    (a3PointsOfMultiplicity 1).card = 18 ∧
    (a3PointsOfMultiplicity 2).card = 3 ∧
    (a3PointsOfMultiplicity 3).card = 4 ∧
    a3Mirrors.card = 6 ∧
    (∀ L ∈ a3Mirrors, a3WeightedDepth L = 5) ∧
    ((Finset.univ \ a3Mirrors).filter fun L => a3WeightedDepth L = 0).card = 4 ∧
    ((Finset.univ \ a3Mirrors).filter fun L => a3WeightedDepth L = 1).card = 6 ∧
    ((Finset.univ \ a3Mirrors).filter fun L => a3WeightedDepth L = 2).card = 15 ∧
    (∀ L ∉ a3Mirrors, a3SectionCard L + 6 = 6 + a3WeightedDepth L) := by
  refine ⟨a3_intersection_spectrum.1, a3_intersection_spectrum.2.1,
    a3_intersection_spectrum.2.2.1, a3_intersection_spectrum.2.2.2, ?_⟩
  constructor
  · decide
  constructor
  · decide
  constructor
  · decide
  constructor
  · decide
  constructor
  · decide
  · decide

/-- Actual coefficient-vector distribution and exact minimum distance of the displayed
`A3/F_5` arrangement-complement evaluation code.  Its Hamming enumerator is
`1 + 60 z^4 + 24 z^5 + 40 z^6`; every nonzero coefficient has weight at least four and weight four
is attained. -/
theorem a3_evaluationCode_weightDistribution :
    (a3PointsOfMultiplicity 0).card = 6 ∧
    (a3CoefficientVectorsOfWeight 0).card = 1 ∧
    (a3CoefficientVectorsOfWeight 4).card = 60 ∧
    (a3CoefficientVectorsOfWeight 5).card = 24 ∧
    (a3CoefficientVectorsOfWeight 6).card = 40 ∧
    (∀ a : Point5, a3EvaluationWeight a = 0 ∨ a3EvaluationWeight a = 4 ∨
      a3EvaluationWeight a = 5 ∨ a3EvaluationWeight a = 6) ∧
    (∀ a : Point5, a ≠ 0 → 4 ≤ a3EvaluationWeight a) ∧
    (∃ a : Point5, a ≠ 0 ∧ a3EvaluationWeight a = 4) := by
  decide

/-- On every nonmirror projective coefficient direction, the actual `A3/F_5` evaluation weight is
the depth-regraded value `6-δ`; nonzero scalar representatives have the same weight. -/
theorem a3_evaluationWeight_eq_six_sub_weightedDepth :
    ∀ L ∉ a3Mirrors, ∀ s : NonzeroScalar5,
      a3EvaluationWeight (s.1 • projectiveVec5 L) = 6 - a3WeightedDepth L := by
  decide

/-- The displayed `A3/F_5` coefficient evaluation is injective, so its coefficient distribution
is a distribution of distinct codewords. -/
theorem a3_evaluationWord_injective :
    Function.Injective
      (projectiveEvaluationWord projectiveVec5 (a3PointsOfMultiplicity 0)) := by
  apply projectiveEvaluationWord_injective_of_positive
  intro a ha
  rcases a3_evaluationCode_weightDistribution with ⟨_, _, _, _, _, _, hbound, _⟩
  exact lt_of_lt_of_le (by omega) (hbound a ha)

/-- Weighted two-adjoint depth of an `H3` test line in the displayed `F_11` model. -/
def h3WeightedDepth (L : Fin 133) : ℕ :=
  ∑ p ∈ (Finset.univ.filter fun p : Fin 133 =>
      dot (projectiveVec L) (projectiveVec p) = 0),
    (h3Multiplicity p - 1)

/-- The displayed `H3` projective directions. -/
def h3Mirrors : Finset (Fin 133) :=
  Finset.univ.filter fun L =>
    ∃ i : Fin 15, SameDirection (projectiveVec L) (h3Join i)

/-- Complement points on an `H3` test line. -/
def h3SectionCard (L : Fin 133) : ℕ :=
  (Finset.univ.filter fun p : Fin 133 =>
    h3Multiplicity p = 0 ∧ dot (projectiveVec L) (projectiveVec p) = 0).card

/-- The actual `F_11` evaluation-word weight on the twelve displayed `H3` complement points. -/
def h3EvaluationWeight (a : Point11) : ℕ :=
  projectiveEvaluationWeight projectiveVec (h3PointsOfMultiplicity 0) a

/-- Coefficient vectors of weight `w` in the displayed `H3/F_11` evaluation code. -/
def h3CoefficientVectorsOfWeight (w : ℕ) : Finset Point11 :=
  coefficientVectorsOfWeight projectiveVec (h3PointsOfMultiplicity 0) w

/-- The `H3/F_11` public incidence theorem together with its checked weighted-depth puncture,
line-section formula, and maximum depth.  The punctured depth counts are `40,12,66` at depths
`3,4,5`; the fifteen mirrors have depth fourteen. -/
theorem h3_weightedAdjoint_specialization :
    (h3PointsOfMultiplicity 0).card = 12 ∧
    (h3PointsOfMultiplicity 1).card = 90 ∧
    (h3PointsOfMultiplicity 2).card = 15 ∧
    (h3PointsOfMultiplicity 3).card = 10 ∧
    (h3PointsOfMultiplicity 5).card = 6 ∧
    h3Mirrors.card = 15 ∧
    (∀ L ∈ h3Mirrors, h3WeightedDepth L = 14) ∧
    ((Finset.univ \ h3Mirrors).filter fun L => h3WeightedDepth L = 3).card = 40 ∧
    ((Finset.univ \ h3Mirrors).filter fun L => h3WeightedDepth L = 4).card = 12 ∧
    ((Finset.univ \ h3Mirrors).filter fun L => h3WeightedDepth L = 5).card = 66 ∧
    (∀ L ∉ h3Mirrors, h3SectionCard L + 15 = 12 + h3WeightedDepth L) := by
  refine ⟨h3_intersection_spectrum.1, h3_intersection_spectrum.2.1,
    h3_intersection_spectrum.2.2.1, h3_intersection_spectrum.2.2.2.1,
    h3_intersection_spectrum.2.2.2.2, ?_⟩
  decide

/-- Actual coefficient-vector distribution and exact minimum distance of the displayed
`H3/F_11` arrangement-complement evaluation code.  Its Hamming enumerator is
`1 + 660 z^10 + 120 z^11 + 550 z^12`; every nonzero coefficient has weight at least ten and
weight ten is attained. -/
theorem h3_evaluationCode_weightDistribution :
    (h3PointsOfMultiplicity 0).card = 12 ∧
    (h3CoefficientVectorsOfWeight 0).card = 1 ∧
    (h3CoefficientVectorsOfWeight 10).card = 660 ∧
    (h3CoefficientVectorsOfWeight 11).card = 120 ∧
    (h3CoefficientVectorsOfWeight 12).card = 550 ∧
    (∀ a : Point11, h3EvaluationWeight a = 0 ∨ h3EvaluationWeight a = 10 ∨
      h3EvaluationWeight a = 11 ∨ h3EvaluationWeight a = 12) ∧
    (∀ a : Point11, a ≠ 0 → 10 ≤ h3EvaluationWeight a) ∧
    (∃ a : Point11, a ≠ 0 ∧ h3EvaluationWeight a = 10) := by
  decide

/-- On every nonmirror projective coefficient direction, the actual `H3/F_11` evaluation weight is
the depth-regraded value `15-δ`; nonzero scalar representatives have the same weight. -/
theorem h3_evaluationWeight_eq_fifteen_sub_weightedDepth :
    ∀ L ∉ h3Mirrors, ∀ s : NonzeroScalar,
      h3EvaluationWeight (s.1 • projectiveVec L) = 15 - h3WeightedDepth L := by
  decide

/-- The displayed `H3/F_11` coefficient evaluation is injective, so its coefficient distribution
is a distribution of distinct codewords. -/
theorem h3_evaluationWord_injective :
    Function.Injective
      (projectiveEvaluationWord projectiveVec (h3PointsOfMultiplicity 0)) := by
  apply projectiveEvaluationWord_injective_of_positive
  intro a ha
  rcases h3_evaluationCode_weightDistribution with ⟨_, _, _, _, _, _, hbound, _⟩
  exact lt_of_lt_of_le (by omega) (hbound a ha)

end CoxeterModels

end ArrangementWeightedAdjoint
end RelativeConicArcs
