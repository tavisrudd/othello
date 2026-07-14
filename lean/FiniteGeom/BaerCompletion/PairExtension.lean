import FiniteGeom.BaerCompletion.BaerPlane

/-!
# Counting conjugate-pair extensions

The geometric theorem partitions candidate conjugate pairs by their unique fixed mate line. On
each empty fixed line there are `N` candidates and a finset of distinct forbidden candidates whose
cardinality is at most `M`. This file proves the finite counting engine
`E * (N-M) ≤ N_pair`. The finset cardinality is forbidden support, not a secant-orbit charge count
with multiplicity.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {L Q : Type*} [DecidableEq L] [DecidableEq Q]

/-- Candidate pairs and the actual distinct forbidden-candidate support, indexed by empty fixed
lines. -/
structure PairExtensionData (L Q : Type*) [DecidableEq L] [DecidableEq Q] where
  emptyLines : Finset L
  candidates : L → Finset Q
  forbidden : L → Finset Q

/-- Count candidates line-by-line. In the Baer-plane instance, uniqueness of the mate line makes
this equal to the cardinality of the global set of legal conjugate pairs. -/
def PairExtensionData.legalCount (D : PairExtensionData L Q) : ℕ :=
  ∑ l ∈ D.emptyLines, (D.candidates l \ D.forbidden l).card

omit [DecidableEq L] in
theorem card_sdiff_ge_of_card_forbidden_le {A B : Finset Q} {N M : ℕ}
    (hA : A.card = N) (hB : B.card ≤ M) : N - M ≤ (A \ B).card := by
  rw [Finset.card_sdiff]
  rw [← hA]
  apply Nat.sub_le_sub_left
  exact le_trans (Finset.card_le_card Finset.inter_subset_left) hB

/-- **Quantitative pair-extension counting engine.** If every one of `E` empty lines contains
`N` candidates and at most `M` forbidden candidates, there are at least `E*(N-M)` legal pairs. -/
theorem PairExtensionData.mul_sub_le_legalCount (D : PairExtensionData L Q) (N M : ℕ)
    (hcand : ∀ l ∈ D.emptyLines, (D.candidates l).card = N)
    (hbad : ∀ l ∈ D.emptyLines, (D.forbidden l).card ≤ M) :
    D.emptyLines.card * (N - M) ≤ D.legalCount := by
  unfold PairExtensionData.legalCount
  calc
    D.emptyLines.card * (N - M) = ∑ l ∈ D.emptyLines, (N - M) := by simp
    _ ≤ ∑ l ∈ D.emptyLines, (D.candidates l \ D.forbidden l).card := by
      apply Finset.sum_le_sum
      intro l hl
      exact card_sdiff_ge_of_card_forbidden_le (hcand l hl) (hbad l hl)

/-- Heterogeneous refinement: each empty line contributes its candidate count minus the cardinality
of its distinct forbidden support. The uniform `E*(N-M)` theorem follows from a common upper bound
on those support cardinalities. -/
theorem PairExtensionData.sum_card_sub_le_legalCount (D : PairExtensionData L Q) :
    (∑ l ∈ D.emptyLines,
        ((D.candidates l).card - (D.forbidden l).card)) ≤ D.legalCount := by
  unfold PairExtensionData.legalCount
  apply Finset.sum_le_sum
  intro l hl
  exact card_sdiff_ge_of_card_forbidden_le rfl le_rfl

/-- If every locally forbidden set is already a subset of its candidate set, the heterogeneous
bound is exact. -/
theorem PairExtensionData.legalCount_eq_sum_card_sub (D : PairExtensionData L Q)
    (hsub : ∀ l ∈ D.emptyLines, D.forbidden l ⊆ D.candidates l) :
    D.legalCount = ∑ l ∈ D.emptyLines,
      ((D.candidates l).card - (D.forbidden l).card) := by
  unfold PairExtensionData.legalCount
  apply Finset.sum_congr rfl
  intro l hl
  exact Finset.card_sdiff_of_subset (hsub l hl)

/-- A positive per-line surplus on at least one empty line guarantees a legal pair. -/
theorem PairExtensionData.exists_legal_of_nonempty_of_lt (D : PairExtensionData L Q) (N M : ℕ)
    (hE : D.emptyLines.Nonempty)
    (hcand : ∀ l ∈ D.emptyLines, (D.candidates l).card = N)
    (hbad : ∀ l ∈ D.emptyLines, (D.forbidden l).card ≤ M)
    (hMN : M < N) :
    ∃ l ∈ D.emptyLines, (D.candidates l \ D.forbidden l).Nonempty := by
  obtain ⟨l, hl⟩ := hE
  refine ⟨l, hl, ?_⟩
  rw [Finset.nonempty_iff_ne_empty]
  intro hempty
  have hbound := card_sdiff_ge_of_card_forbidden_le (hcand l hl) (hbad l hl)
  rw [hempty, Finset.card_empty] at hbound
  omega

/-- The arithmetic specialization used in the quadratic Baer-plane theorem: each empty fixed line
has `(s²-s)/2` conjugate candidate pairs. -/
theorem baer_pairExtension_lowerBound (D : PairExtensionData L Q) (s M : ℕ)
    (hcand : ∀ l ∈ D.emptyLines, (D.candidates l).card = (s * s - s) / 2)
    (hbad : ∀ l ∈ D.emptyLines, (D.forbidden l).card ≤ M) :
    D.emptyLines.card * (((s * s - s) / 2) - M) ≤ D.legalCount :=
  D.mul_sub_le_legalCount ((s * s - s) / 2) M hcand hbad

/-- Number of empty subfield lines in the quadratic Baer-plane theorem. -/
def baerEmptyLineCount (s f e : ℕ) : ℕ :=
  s * s + s + 1 - (f * (s + 1) - f.choose 2 + e)

/-- Number of conjugate orbits of noninvariant old secants. -/
def baerNonInvariantSecantOrbits (k f e : ℕ) : ℕ :=
  (k.choose 2 - (f.choose 2 + e)) / 2

/-- The exact finite counting inputs supplied by a `PG(2,s²)` incidence instance. -/
structure QuadraticBaerPairExtensionData (L Q : Type*) [DecidableEq L] [DecidableEq Q]
    (s k f e : ℕ) extends PairExtensionData L Q where
  emptyLine_count : emptyLines.card = baerEmptyLineCount s f e
  candidate_count : ∀ l ∈ emptyLines, (candidates l).card = (s * s - s) / 2
  forbidden_bound : ∀ l ∈ emptyLines,
    (forbidden l).card ≤ baerNonInvariantSecantOrbits k f e

/-- **Quadratic pair-extension theorem, exact counting form.** Once the three geometric counts in
`QuadraticBaerPairExtensionData` are established, the paper's lower bound follows without further
geometric assumptions. -/
theorem quadraticBaer_pairExtension_lowerBound
    (D : QuadraticBaerPairExtensionData L Q s k f e) :
    baerEmptyLineCount s f e *
        (((s * s - s) / 2) - baerNonInvariantSecantOrbits k f e) ≤
      D.toPairExtensionData.legalCount := by
  rw [← D.emptyLine_count]
  exact baer_pairExtension_lowerBound D.toPairExtensionData s
    (baerNonInvariantSecantOrbits k f e) D.candidate_count D.forbidden_bound

/-- The paper's two strict inequalities imply existence of a legal conjugate pair. -/
theorem quadraticBaer_exists_pair
    (D : QuadraticBaerPairExtensionData L Q s k f e)
    (hE : 0 < baerEmptyLineCount s f e)
    (hM : baerNonInvariantSecantOrbits k f e < (s * s - s) / 2) :
    ∃ l ∈ D.emptyLines, (D.candidates l \ D.forbidden l).Nonempty := by
  apply D.toPairExtensionData.exists_legal_of_nonempty_of_lt
      ((s * s - s) / 2) (baerNonInvariantSecantOrbits k f e)
  · rw [Finset.nonempty_iff_ne_empty]
    intro hzero
    have := D.emptyLine_count
    rw [hzero, Finset.card_empty] at this
    omega
  · exact D.candidate_count
  · exact D.forbidden_bound
  · exact hM

end FiniteGeom.BaerCompletion
