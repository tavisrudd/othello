import Mathlib.Data.Nat.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-!
# Grading multiplicities exclude a cyclic family at an extreme grading value

For a smooth projective variety `Z` of dimension `n`, the grading operator on
even cohomology is `(deg - n) / 2`, so its spectrum is the multiset of values
`(2 * k - n) / 2` with multiplicity the Betti number `h^{2k}`.  Under the
formal decomposition of the quantum connection at `z = 0` each block carries a
residue whose diagonal, in a block-adapted gauge, is a sub-multiset of that
spectrum, and distinct blocks occupy disjoint sub-multisets.

A boundary monodromy that permutes several blocks cyclically conjugates their
residues into one another.  The grading values are rational and are fixed by
the semilinear field automorphism, so all blocks of one cyclic family share a
single grading pair.  A family of length `cycleLength` therefore consumes
`cycleLength` copies of each of the two values, or `2 * cycleLength` copies of
the single value when the two coincide.

For a connected threefold the extreme grading values `-3/2` and `3/2` have
multiplicity `h^0 = 1` and `h^6 = 1`, so no cyclic family of length at least
two can use them.  This module records that counting argument.  Grading values
are carried as doubled integers, so `-3/2` is `-3` and `-1/2` is `-1`, which
keeps the ledger free of division.

The geometry is external: that block residues partition the grading spectrum,
and that blocks of one cyclic family share a grading pair, are hypotheses
here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.GradingMultiplicityExclusion

/-- The multiplicity ledger of the grading spectrum of a connected smooth
projective threefold, with grading values doubled: the value `-3` (that is,
`-3/2`, from `H^0`) and the value `3` (from `H^6`) each occur once, while `-1`
and `1` each occur `secondBetti` times.  Any other value does not occur. -/
def threefoldMultiplicity (secondBetti : ℕ) (value : ℤ) : ℕ :=
  if value = -3 then 1
  else if value = -1 then secondBetti
  else if value = 1 then secondBetti
  else if value = 3 then 1
  else 0

@[simp] theorem threefoldMultiplicity_neg_three (secondBetti : ℕ) :
    threefoldMultiplicity secondBetti (-3) = 1 := by
  norm_num [threefoldMultiplicity]

@[simp] theorem threefoldMultiplicity_neg_one (secondBetti : ℕ) :
    threefoldMultiplicity secondBetti (-1) = secondBetti := by
  norm_num [threefoldMultiplicity]

@[simp] theorem threefoldMultiplicity_one (secondBetti : ℕ) :
    threefoldMultiplicity secondBetti 1 = secondBetti := by
  norm_num [threefoldMultiplicity]

@[simp] theorem threefoldMultiplicity_three (secondBetti : ℕ) :
    threefoldMultiplicity secondBetti 3 = 1 := by
  norm_num [threefoldMultiplicity]

/-- Number of copies of a grading value consumed by a cyclic family of
rank-two blocks all sharing the grading pair `{first, second}`. -/
def consumed (first second value : ℤ) (cycleLength : ℕ) : ℕ :=
  (if first = value then cycleLength else 0) +
  (if second = value then cycleLength else 0)

/-- A cyclic family cannot consume more copies of a grading value than the
spectrum provides.  This is the hypothesis supplied by the geometry: distinct
blocks occupy disjoint sub-multisets of the grading spectrum. -/
def Admissible (secondBetti : ℕ) (first second : ℤ) (cycleLength : ℕ) : Prop :=
  ∀ value : ℤ,
    consumed first second value cycleLength ≤ threefoldMultiplicity secondBetti value

/-- A family whose first grading value is `value` consumes at least
`cycleLength` copies of it. -/
theorem le_consumed_left {first second value : ℤ} {cycleLength : ℕ}
    (h : first = value) :
    cycleLength ≤ consumed first second value cycleLength := by
  unfold consumed
  rw [if_pos h]
  split <;> omega

/-- A family whose second grading value is `value` consumes at least
`cycleLength` copies of it. -/
theorem le_consumed_right {first second value : ℤ} {cycleLength : ℕ}
    (h : second = value) :
    cycleLength ≤ consumed first second value cycleLength := by
  unfold consumed
  rw [if_pos h]
  split <;> omega

/-- A grading value of multiplicity one cannot be used by a cyclic family of
length at least two. -/
theorem not_extreme_of_admissible
    {secondBetti : ℕ} {first second : ℤ} {cycleLength : ℕ}
    (long : 2 ≤ cycleLength)
    (adm : Admissible secondBetti first second cycleLength) :
    first ≠ -3 ∧ first ≠ 3 ∧ second ≠ -3 ∧ second ≠ 3 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro h
    have bound := adm (-3)
    have lower := le_consumed_left (second := second) (cycleLength := cycleLength) h
    simp only [threefoldMultiplicity_neg_three] at bound
    omega
  · intro h
    have bound := adm 3
    have lower := le_consumed_left (second := second) (cycleLength := cycleLength) h
    simp only [threefoldMultiplicity_three] at bound
    omega
  · intro h
    have bound := adm (-3)
    have lower := le_consumed_right (first := first) (cycleLength := cycleLength) h
    simp only [threefoldMultiplicity_neg_three] at bound
    omega
  · intro h
    have bound := adm 3
    have lower := le_consumed_right (first := first) (cycleLength := cycleLength) h
    simp only [threefoldMultiplicity_three] at bound
    omega

/-- A cyclic family of length at least two whose grading values are among the
four occurring on a connected threefold must use the two middle values, so its
doubled grading difference is `0` or `2`; undoubled, the grading difference is
zero or one, never two or three. -/
theorem middle_of_admissible
    {secondBetti : ℕ} {first second : ℤ} {cycleLength : ℕ}
    (long : 2 ≤ cycleLength)
    (occurring : first ∈ ({-3, -1, 1, 3} : Set ℤ) ∧ second ∈ ({-3, -1, 1, 3} : Set ℤ))
    (adm : Admissible secondBetti first second cycleLength) :
    (first = -1 ∨ first = 1) ∧ (second = -1 ∨ second = 1) := by
  obtain ⟨hf, hs⟩ := occurring
  obtain ⟨f3, f3', s3, s3'⟩ := not_extreme_of_admissible long adm
  constructor
  · rcases hf with h | h | h | h <;> simp_all
  · rcases hs with h | h | h | h <;> simp_all

/-- Equal grading values force twice the cycle length into one multiplicity,
so a cyclic family with grading difference zero needs second Betti number at
least twice its length. -/
theorem secondBetti_ge_two_mul_of_equal
    {secondBetti : ℕ} {value : ℤ} {cycleLength : ℕ}
    (middle : value = -1 ∨ value = 1)
    (adm : Admissible secondBetti value value cycleLength) :
    2 * cycleLength ≤ secondBetti := by
  have bound := adm value
  have exact_count : consumed value value value cycleLength = 2 * cycleLength := by
    unfold consumed
    rw [if_pos rfl]
    omega
  rcases middle with h | h <;> subst h
  · rw [exact_count, threefoldMultiplicity_neg_one] at bound
    omega
  · rw [exact_count, threefoldMultiplicity_one] at bound
    omega

/-- Distinct middle grading values force the cycle length into each
multiplicity, so a cyclic family with grading difference one needs second
Betti number at least its length. -/
theorem secondBetti_ge_of_distinct
    {secondBetti : ℕ} {cycleLength : ℕ}
    (adm : Admissible secondBetti (-1) 1 cycleLength) :
    cycleLength ≤ secondBetti := by
  have bound := adm (-1)
  have lower := le_consumed_left (second := (1 : ℤ)) (cycleLength := cycleLength)
    (rfl : (-1 : ℤ) = -1)
  simp only [threefoldMultiplicity_neg_one] at bound
  omega

/-- The exclusion used at `m = 2`.  A cyclic triple of rank-two blocks on a
connected threefold cannot have the doubled grading difference `2` carried by
the cubic threefold's marked block, whose grading pair is `(-3, 1)`. -/
theorem no_cubic_gradingPair_cycle
    {secondBetti : ℕ} {cycleLength : ℕ}
    (long : 2 ≤ cycleLength)
    (adm : Admissible secondBetti (-3) 1 cycleLength) :
    False := by
  obtain ⟨f3, _, _, _⟩ := not_extreme_of_admissible long adm
  exact f3 rfl

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.GradingMultiplicityExclusion
