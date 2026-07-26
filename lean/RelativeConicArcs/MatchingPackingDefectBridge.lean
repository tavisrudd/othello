import RelativeConicArcs.MatchingDesignRigidity

/-!
# Matching-packing deficiency and prescribed-hole defect

This module transfers a missing-block count in the maximum-concurrence matching packing of a
finite projective-plane arc to the integer-normalized prescribed-hole defect.  Its hypotheses state
the exact clique-partition count explicitly; the geometric inequality is supplied by
`two_mul_badConcurrenceEdgeCount_le`.
-/

namespace RelativeConicArcs

open Finset

section FinitePlane

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P]
  [Configuration.ProjectivePlane P L]

private theorem sum_choose_two_partition_at_maximum
    {α : Type*} [DecidableEq α] (s : Finset α) (r : α → ℕ) (m : ℕ)
    (hupper : ∀ x ∈ s, r x ≤ m) :
    (∑ x ∈ s, Nat.choose (r x) 2) =
      (∑ x ∈ s.filter fun x => 2 ≤ r x ∧ r x < m, Nat.choose (r x) 2) +
        (s.filter fun x => r x = m).card * Nat.choose m 2 := by
  have hmaxsum :
      (∑ _x ∈ s.filter fun x => r x = m, Nat.choose m 2) =
        (s.filter fun x => r x = m).card * Nat.choose m 2 := by
    simp [Nat.mul_comm]
  rw [← hmaxsum, Finset.sum_filter, Finset.sum_filter, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro x hx
  by_cases hrm : r x = m
  · simp [hrm]
  by_cases hrtwo : 2 ≤ r x
  · have hrlt : r x < m := by
      have := hupper x hx
      omega
    simp [hrm, hrtwo, hrlt]
  · have hrlt : r x < 2 := Nat.lt_of_not_ge hrtwo
    have hchoose : Nat.choose (r x) 2 = 0 := Nat.choose_eq_zero_of_lt hrlt
    simp [hrm, hrtwo, hchoose]

private theorem sum_choose_two_filter_positive_eq_filter_two
    {α : Type*} [DecidableEq α] (s : Finset α) (r : α → ℕ) (m : ℕ) :
    (∑ x ∈ s.filter fun x => 0 < r x ∧ r x < m, Nat.choose (r x) 2) =
      ∑ x ∈ s.filter fun x => 2 ≤ r x ∧ r x < m, Nat.choose (r x) 2 := by
  rw [Finset.sum_filter, Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro x _hx
  by_cases htwo : 2 ≤ r x
  · simp [htwo, Nat.zero_lt_of_lt htwo]
  · have hlt : r x < 2 := Nat.lt_of_not_ge htwo
    have hchoose : Nat.choose (r x) 2 = 0 := Nat.choose_eq_zero_of_lt hlt
    simp [htwo, hchoose]

/-- Required-locus concurrence centres whose secant index is the maximum matching size
`floor (|A| / 2)`. -/
noncomputable def maximumRequiredConcurrenceCenters
    (A H : Finset P) : Finset P := by
  classical
  exact (coveredRequired (L := L) A H).filter fun x =>
    pointIndex (L := L) A x = A.card / 2

/-- Prescribed-hole concurrence centres whose secant index is the maximum matching size
`floor (|A| / 2)`. -/
noncomputable def maximumHoleConcurrenceCenters
    (A H : Finset P) : Finset P := by
  classical
  exact H.filter fun x => pointIndex (L := L) A x = A.card / 2

/-- Number of maximum-matching blocks in the concurrence decomposition, split between required
points and prescribed holes. -/
noncomputable def maximumConcurrenceBlockCount
    (A H : Finset P) : ℕ :=
  (maximumRequiredConcurrenceCenters (L := L) A H).card +
    (maximumHoleConcurrenceCenters (L := L) A H).card

/-- Exact block-deficiency identity: bad concurrence edges plus the edges in all maximum
concurrence cliques account for every edge of the Kneser graph on the arc pairs. -/
theorem badConcurrenceEdgeCount_add_maximumBlocks
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H) :
    badConcurrenceEdgeCount (L := L) A H +
        (maximumConcurrenceBlockCount (L := L) A H : ℤ) *
          Nat.choose (A.card / 2) 2 =
      3 * Nat.choose A.card 4 := by
  classical
  have hrequiredUpper :
      ∀ x ∈ coveredRequired (L := L) A H,
        pointIndex (L := L) A x ≤ A.card / 2 := by
    intro x hx
    have hxA : x ∉ A := by
      have hx' := Finset.mem_filter.mp hx
      exact fun hxA => (Finset.mem_sdiff.mp hx'.1).2 (Finset.mem_union_left H hxA)
    exact pointIndex_le_half_card (L := L) hA hxA
  have hholeUpper :
      ∀ x ∈ H, pointIndex (L := L) A x ≤ A.card / 2 := by
    intro x hx
    have hxA : x ∉ A := fun hxA => Finset.disjoint_left.mp hdisj hxA hx
    exact pointIndex_le_half_card (L := L) hA hxA
  have hrequired :=
    sum_choose_two_partition_at_maximum
      (coveredRequired (L := L) A H) (pointIndex (L := L) A) (A.card / 2)
      hrequiredUpper
  have hholes :=
    sum_choose_two_partition_at_maximum
      H (pointIndex (L := L) A) (A.card / 2) hholeUpper
  have hholeFilters :=
    sum_choose_two_filter_positive_eq_filter_two
      H (pointIndex (L := L) A) (A.card / 2)
  have hmoment := second_secant_moment_split (L := L) hA hdisj
  rw [hrequired, hholes, ← hholeFilters] at hmoment
  have hmoment' :
      ((∑ x ∈ intermediateRequired (L := L) A H,
          Nat.choose (pointIndex (L := L) A x) 2) +
        (∑ y ∈ intermediateHoles (L := L) A H,
          Nat.choose (pointIndex (L := L) A y) 2) +
        maximumConcurrenceBlockCount (L := L) A H *
          Nat.choose (A.card / 2) 2 : ℕ) =
        3 * Nat.choose A.card 4 := by
    simpa [intermediateRequired, intermediateHoles,
      maximumConcurrenceBlockCount, maximumRequiredConcurrenceCenters,
      maximumHoleConcurrenceCenters, add_mul, add_assoc, add_left_comm, add_comm] using hmoment
  rw [badConcurrenceEdgeCount, maximumConcurrenceBlockCount]
  exact_mod_cast hmoment'

/-- If `v - b` maximum-matching blocks are missing from the concurrence decomposition, then their
number times `floor (|A| / 2)` is at most the integer-normalized prescribed-hole defect. -/
theorem matchingPackingDeficiency_le_scaledDefect
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (v b : ℕ)
    (hblocks :
      badConcurrenceEdgeCount (L := L) A H =
        (((v - b) * Nat.choose (A.card / 2) 2 : ℕ) : ℤ))
    (hhalf : 2 ≤ A.card / 2) :
    ((A.card / 2 : ℕ) : ℤ) * ((v - b : ℕ) : ℤ) ≤
      scaledDefect (L := L) A H := by
  have hbad :=
    two_mul_badConcurrenceEdgeCount_le (L := L) hA hdisj
  rw [hblocks] at hbad
  have hchoose :
      2 * (Nat.choose (A.card / 2) 2 : ℤ) =
        ((A.card / 2 : ℕ) : ℤ) * (((A.card / 2 : ℕ) : ℤ) - 1) := by
    rw [show (2 * (Nat.choose (A.card / 2) 2 : ℤ)) =
      ((2 * Nat.choose (A.card / 2) 2 : ℕ) : ℤ) by norm_num]
    rw [two_mul_choose_two]
    rw [Nat.cast_mul, Nat.cast_sub (by omega : 1 ≤ A.card / 2)]
    norm_num
  rw [Nat.cast_mul] at hbad
  have hbad' :
      ((v - b : ℕ) : ℤ) *
          (((A.card / 2 : ℕ) : ℤ) * (((A.card / 2 : ℕ) : ℤ) - 1)) ≤
        (((A.card / 2 : ℕ) : ℤ) - 1) * scaledDefect (L := L) A H := by
    calc
      ((v - b : ℕ) : ℤ) *
          (((A.card / 2 : ℕ) : ℤ) * (((A.card / 2 : ℕ) : ℤ) - 1)) =
          2 * (((v - b : ℕ) : ℤ) * (Nat.choose (A.card / 2) 2 : ℤ)) := by
            rw [← hchoose]
            ring
      _ ≤ (((A.card / 2 : ℕ) : ℤ) - 1) * scaledDefect (L := L) A H := hbad
  have hmone : 0 < ((A.card / 2 : ℕ) : ℤ) - 1 := by omega
  apply le_of_mul_le_mul_left ?_ hmone
  calc
    (((A.card / 2 : ℕ) : ℤ) - 1) *
        (((A.card / 2 : ℕ) : ℤ) * ((v - b : ℕ) : ℤ)) =
        ((v - b : ℕ) : ℤ) *
          (((A.card / 2 : ℕ) : ℤ) * (((A.card / 2 : ℕ) : ℤ) - 1)) := by ring
    _ ≤ (((A.card / 2 : ℕ) : ℤ) - 1) * scaledDefect (L := L) A H := hbad'

/-- If at least two maximum-matching blocks are missing, then the integer-normalized defect is at
least twice `floor (|A| / 2)`. -/
theorem two_mul_half_le_scaledDefect_of_two_le_matchingPackingDeficiency
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (v b : ℕ)
    (hblocks :
      badConcurrenceEdgeCount (L := L) A H =
        (((v - b) * Nat.choose (A.card / 2) 2 : ℕ) : ℤ))
    (hhalf : 2 ≤ A.card / 2) (htwo : 2 ≤ v - b) :
    2 * ((A.card / 2 : ℕ) : ℤ) ≤ scaledDefect (L := L) A H := by
  have htransfer :=
    matchingPackingDeficiency_le_scaledDefect (L := L) hA hdisj v b hblocks hhalf
  have hmnonneg : 0 ≤ ((A.card / 2 : ℕ) : ℤ) := by positivity
  have hdeficiency : (2 : ℤ) ≤ ((v - b : ℕ) : ℤ) := by exact_mod_cast htwo
  calc
    2 * ((A.card / 2 : ℕ) : ℤ) =
        ((A.card / 2 : ℕ) : ℤ) * 2 := by ring
    _ ≤ ((A.card / 2 : ℕ) : ℤ) * ((v - b : ℕ) : ℤ) :=
      mul_le_mul_of_nonneg_left hdeficiency hmnonneg
    _ ≤ scaledDefect (L := L) A H := htransfer

/-- Geometric form of the packing-deficiency transfer.  If `v` is the number of blocks in a full
maximum-matching decomposition, the difference between `v` and the actual number of maximum
concurrence blocks, multiplied by `floor (|A| / 2)`, is bounded by the integer-normalized defect. -/
theorem maximumConcurrenceBlockDeficiency_le_scaledDefect
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (v : ℕ)
    (htotal :
      v * Nat.choose (A.card / 2) 2 = 3 * Nat.choose A.card 4)
    (hhalf : 2 ≤ A.card / 2) :
    ((A.card / 2 : ℕ) : ℤ) *
        ((v - maximumConcurrenceBlockCount (L := L) A H : ℕ) : ℤ) ≤
      scaledDefect (L := L) A H := by
  have hexact :=
    badConcurrenceEdgeCount_add_maximumBlocks (L := L) hA hdisj
  have htotal' :
      (v : ℤ) * Nat.choose (A.card / 2) 2 =
        3 * Nat.choose A.card 4 := by
    exact_mod_cast htotal
  have hbadNonnegative :
      0 ≤ badConcurrenceEdgeCount (L := L) A H := by
    unfold badConcurrenceEdgeCount
    apply add_nonneg
    · apply Finset.sum_nonneg
      intro x _hx
      positivity
    · apply Finset.sum_nonneg
      intro x _hx
      positivity
  have hchoosePositive :
      0 < (Nat.choose (A.card / 2) 2 : ℤ) := by
    exact_mod_cast Nat.choose_pos hhalf
  have hcount : maximumConcurrenceBlockCount (L := L) A H ≤ v := by
    rw [← htotal'] at hexact
    have hcount' :
        (maximumConcurrenceBlockCount (L := L) A H : ℤ) ≤ v := by
      nlinarith
    exact_mod_cast hcount'
  have hblocks :
      badConcurrenceEdgeCount (L := L) A H =
        (((v - maximumConcurrenceBlockCount (L := L) A H) *
          Nat.choose (A.card / 2) 2 : ℕ) : ℤ) := by
    rw [← htotal'] at hexact
    rw [Nat.cast_mul, Nat.cast_sub hcount]
    nlinarith
  exact matchingPackingDeficiency_le_scaledDefect
    (L := L) hA hdisj v (maximumConcurrenceBlockCount (L := L) A H) hblocks hhalf

/-- If at least two blocks are absent from the maximum-concurrence packing, the
integer-normalized defect is at least twice the maximum matching size. -/
theorem two_mul_half_le_scaledDefect_of_two_le_maximumConcurrenceBlockDeficiency
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (v : ℕ)
    (htotal :
      v * Nat.choose (A.card / 2) 2 = 3 * Nat.choose A.card 4)
    (hhalf : 2 ≤ A.card / 2)
    (htwo : 2 ≤ v - maximumConcurrenceBlockCount (L := L) A H) :
    2 * ((A.card / 2 : ℕ) : ℤ) ≤ scaledDefect (L := L) A H := by
  have htransfer :=
    maximumConcurrenceBlockDeficiency_le_scaledDefect
      (L := L) hA hdisj v htotal hhalf
  have hdeficiency :
      (2 : ℤ) ≤
        ((v - maximumConcurrenceBlockCount (L := L) A H : ℕ) : ℤ) := by
    exact_mod_cast htwo
  have hmnonneg : 0 ≤ ((A.card / 2 : ℕ) : ℤ) := by positivity
  calc
    2 * ((A.card / 2 : ℕ) : ℤ) =
        ((A.card / 2 : ℕ) : ℤ) * 2 := by ring
    _ ≤ ((A.card / 2 : ℕ) : ℤ) *
        ((v - maximumConcurrenceBlockCount (L := L) A H : ℕ) : ℤ) :=
      mul_le_mul_of_nonneg_left hdeficiency hmnonneg
    _ ≤ scaledDefect (L := L) A H := htransfer

end FinitePlane

end RelativeConicArcs
