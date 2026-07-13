import RelativeConicArcs.Moments

/-!
# The prescribed-hole defect identity

This file splits the classical secant moments between prescribed holes and the required locus.
The defect is normalized as an integer, so its exact identity involves no truncated subtraction.
-/

namespace RelativeConicArcs

open Configuration Finset

variable {P L : Type*} [Membership P L]

section FinitePlane

variable [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- The total secant incidence at the prescribed holes. -/
noncomputable def holeIncidence (A H : Finset P) : ℕ :=
  ∑ y ∈ H, pointIndex (L := L) A y

/-- The integer-normalized defect `m·Δ`, where `m = floor (|A|/2)`. -/
noncomputable def scaledDefect (A H : Finset P) : ℤ :=
  ((A.card / 2 : ℕ) : ℤ) * (Nat.choose A.card 2 * (PlaneOrder P L - 1) : ℕ)
    - 6 * (Nat.choose A.card 4 : ℤ)
    - (holeIncidence (L := L) A H : ℤ)
    - ((A.card / 2 : ℕ) : ℤ) * (coveredRequired (L := L) A H).card

/-- The required-locus side of the exact defect identity. -/
noncomputable def requiredRemainder (A H : Finset P) : ℤ :=
  ∑ x ∈ coveredRequired (L := L) A H,
    ((pointIndex (L := L) A x : ℤ) - 1) *
      (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A x)

/-- The prescribed-hole side of the exact defect identity. -/
noncomputable def holeRemainder (A H : Finset P) : ℤ :=
  ∑ y ∈ H, (pointIndex (L := L) A y : ℤ) *
    (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A y)

/-- The required points whose indices are strictly between the equality-case extremes. -/
noncomputable def intermediateRequired (A H : Finset P) : Finset P := by
  classical
  exact (coveredRequired (L := L) A H).filter fun x =>
    2 ≤ pointIndex (L := L) A x ∧ pointIndex (L := L) A x < A.card / 2

/-- The holes whose indices are strictly between the equality-case extremes. -/
noncomputable def intermediateHoles (A H : Finset P) : Finset P := by
  classical
  exact H.filter fun y =>
    0 < pointIndex (L := L) A y ∧ pointIndex (L := L) A y < A.card / 2

theorem external_eq_holes_union_required {A H : Finset P} (hdisj : Disjoint A H) :
    Finset.univ \ A = H ∪ requiredLocus A H := by
  classical
  ext x
  rw [Finset.mem_sdiff, Finset.mem_union]
  simp only [Finset.mem_univ, true_and]
  change x ∉ A ↔ x ∈ H ∨ x ∈ Finset.univ \ (A ∪ H)
  simp only [Finset.mem_sdiff, Finset.mem_univ, Finset.mem_union, true_and]
  constructor
  · intro hxA
    by_cases hxH : x ∈ H
    · exact Or.inl hxH
    · exact Or.inr (by rintro (hxA' | hxH'); exact hxA hxA'; exact hxH hxH')
  · rintro (hxH | hxnotUnion)
    · exact fun hxA => (Finset.disjoint_left.mp hdisj) hxA hxH
    · exact fun hxA => hxnotUnion (Or.inl hxA)

theorem holes_disjoint_required (A H : Finset P) :
    Disjoint H (requiredLocus A H) := by
  classical
  rw [Finset.disjoint_left]
  intro x hxH hxrequired
  exact (Finset.mem_sdiff.mp hxrequired).2 (Finset.mem_union_right A hxH)

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
theorem sum_required_eq_sum_coveredRequired (A H : Finset P) :
    (∑ x ∈ requiredLocus A H, pointIndex (L := L) A x) =
      ∑ x ∈ coveredRequired (L := L) A H, pointIndex (L := L) A x := by
  classical
  symm
  change (∑ x ∈ (requiredLocus A H).filter (Covered (L := L) A),
      pointIndex (L := L) A x) = _
  apply Finset.sum_subset (Finset.filter_subset _ _)
  intro x hxrequired hxnot
  have hxnotCovered : ¬ Covered (L := L) A x := by
    intro hxcovered
    exact hxnot (Finset.mem_filter.mpr ⟨hxrequired, hxcovered⟩)
  simp only [Covered] at hxnotCovered
  omega

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
theorem sum_choose_required_eq_sum_choose_coveredRequired (A H : Finset P) :
    (∑ x ∈ requiredLocus A H,
        Nat.choose (pointIndex (L := L) A x) 2) =
      ∑ x ∈ coveredRequired (L := L) A H,
        Nat.choose (pointIndex (L := L) A x) 2 := by
  classical
  symm
  change (∑ x ∈ (requiredLocus A H).filter (Covered (L := L) A),
      Nat.choose (pointIndex (L := L) A x) 2) = _
  apply Finset.sum_subset (Finset.filter_subset _ _)
  intro x hxrequired hxnot
  have hxnotCovered : ¬ Covered (L := L) A x := by
    intro hxcovered
    exact hxnot (Finset.mem_filter.mpr ⟨hxrequired, hxcovered⟩)
  have hxzero : pointIndex (L := L) A x = 0 := by
    simp only [Covered] at hxnotCovered
    omega
  simp [hxzero]

/-- The first moment split between covered required points and prescribed holes. -/
theorem first_secant_moment_split {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) :
    (∑ x ∈ coveredRequired (L := L) A H, pointIndex (L := L) A x)
        + holeIncidence (L := L) A H =
      Nat.choose A.card 2 * (PlaneOrder P L - 1) := by
  classical
  have hmoment := first_secant_moment (L := L) hA
  rw [external_eq_holes_union_required hdisj,
    Finset.sum_union (holes_disjoint_required A H)] at hmoment
  rw [sum_required_eq_sum_coveredRequired (L := L) A H] at hmoment
  simpa [holeIncidence, Nat.add_comm] using hmoment

/-- The second moment split between covered required points and prescribed holes. -/
theorem second_secant_moment_split {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) :
    (∑ x ∈ coveredRequired (L := L) A H,
        Nat.choose (pointIndex (L := L) A x) 2)
        + (∑ y ∈ H, Nat.choose (pointIndex (L := L) A y) 2) =
      3 * Nat.choose A.card 4 := by
  classical
  have hmoment := second_secant_moment (L := L) hA
  rw [external_eq_holes_union_required hdisj,
    Finset.sum_union (holes_disjoint_required A H)] at hmoment
  rw [sum_choose_required_eq_sum_choose_coveredRequired (L := L) A H] at hmoment
  simpa [Nat.add_comm] using hmoment

private theorem required_remainder_term (m r : ℕ) (hr : 0 < r) :
    ((r : ℤ) - 1) * ((m : ℤ) - r) =
      (m : ℤ) * r - m - 2 * (Nat.choose r 2 : ℤ) := by
  have hchoose : (2 : ℤ) * (Nat.choose r 2 : ℤ) = (r : ℤ) * ((r : ℤ) - 1) := by
    have hsub : (r : ℤ) - 1 = ((r - 1 : ℕ) : ℤ) := by omega
    rw [hsub]
    norm_cast
    exact two_mul_choose_two r
  rw [hchoose]
  ring

private theorem hole_remainder_term (m r : ℕ) (hr : 0 < r) :
    (r : ℤ) * ((m : ℤ) - r) =
      ((m : ℤ) - 1) * r - 2 * (Nat.choose r 2 : ℤ) := by
  have hchoose : (2 : ℤ) * (Nat.choose r 2 : ℤ) = (r : ℤ) * ((r : ℤ) - 1) := by
    have hsub : (r : ℤ) - 1 = ((r - 1 : ℕ) : ℤ) := by omega
    rw [hsub]
    norm_cast
    exact two_mul_choose_two r
  rw [hchoose]
  ring

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
private theorem requiredRemainder_eq (A H : Finset P) :
    requiredRemainder (L := L) A H =
      ((A.card / 2 : ℕ) : ℤ) *
          (∑ x ∈ coveredRequired (L := L) A H, pointIndex (L := L) A x)
        - ((A.card / 2 : ℕ) : ℤ) * (coveredRequired (L := L) A H).card
        - 2 * (∑ x ∈ coveredRequired (L := L) A H,
          Nat.choose (pointIndex (L := L) A x) 2) := by
  classical
  rw [requiredRemainder]
  calc
    (∑ x ∈ coveredRequired (L := L) A H,
        ((pointIndex (L := L) A x : ℤ) - 1) *
          (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A x)) =
      ∑ x ∈ coveredRequired (L := L) A H,
        (((A.card / 2 : ℕ) : ℤ) * pointIndex (L := L) A x - ((A.card / 2 : ℕ) : ℤ)
          - 2 * (Nat.choose (pointIndex (L := L) A x) 2 : ℤ)) := by
        apply Finset.sum_congr rfl
        intro x hx
        have hxcovered := (Finset.mem_filter.mp hx).2
        exact required_remainder_term (A.card / 2) (pointIndex (L := L) A x) hxcovered
    _ = _ := by
      push_cast
      simp only [Finset.sum_sub_distrib, Finset.mul_sum,
        Finset.sum_const, nsmul_eq_mul]
      ring

omit [Fintype P] [DecidableEq P] [DecidableEq L] [Configuration.ProjectivePlane P L] in
private theorem holeRemainder_eq (A H : Finset P) :
    holeRemainder (L := L) A H =
      (((A.card / 2 : ℕ) : ℤ) - 1) * holeIncidence (L := L) A H
        - 2 * (∑ y ∈ H, Nat.choose (pointIndex (L := L) A y) 2) := by
  classical
  rw [holeRemainder, holeIncidence]
  calc
    (∑ y ∈ H, (pointIndex (L := L) A y : ℤ) *
        (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A y)) =
      ∑ y ∈ H, ((((A.card / 2 : ℕ) : ℤ) - 1) * pointIndex (L := L) A y
        - 2 * (Nat.choose (pointIndex (L := L) A y) 2 : ℤ)) := by
        apply Finset.sum_congr rfl
        intro y _hy
        by_cases hr : pointIndex (L := L) A y = 0
        · simp [hr]
        · exact hole_remainder_term (A.card / 2) (pointIndex (L := L) A y)
            (Nat.pos_of_ne_zero hr)
    _ = _ := by
      push_cast
      simp only [Finset.sum_sub_distrib, Finset.mul_sum]

/-- Exact prescribed-hole defect identity, in the subtraction-safe normalization `m·Δ`. -/
theorem scaledDefect_eq_remainders {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) :
    scaledDefect (L := L) A H =
      requiredRemainder (L := L) A H + holeRemainder (L := L) A H := by
  rw [requiredRemainder_eq, holeRemainder_eq, scaledDefect]
  have hfirst :
      (∑ x ∈ coveredRequired (L := L) A H, (pointIndex (L := L) A x : ℤ))
          + (holeIncidence (L := L) A H : ℤ) =
        (Nat.choose A.card 2 : ℤ) * (PlaneOrder P L - 1 : ℕ) := by
    exact_mod_cast first_secant_moment_split (L := L) hA hdisj
  have hsecond :
      (∑ x ∈ coveredRequired (L := L) A H,
          (Nat.choose (pointIndex (L := L) A x) 2 : ℤ))
          + (∑ y ∈ H, (Nat.choose (pointIndex (L := L) A y) 2 : ℤ)) =
        3 * (Nat.choose A.card 4 : ℤ) := by
    exact_mod_cast second_secant_moment_split (L := L) hA hdisj
  push_cast at ⊢
  rw [← hfirst]
  ring_nf at hsecond ⊢
  omega

private theorem required_remainder_nonneg_at {A H : Finset P} (hA : Arc (L := L) A)
    {x : P} (hx : x ∈ coveredRequired (L := L) A H) :
    0 ≤ ((pointIndex (L := L) A x : ℤ) - 1) *
      (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A x) := by
  classical
  have hxparts := Finset.mem_filter.mp hx
  have hxA : x ∉ A := fun hxA =>
    (Finset.mem_sdiff.mp hxparts.1).2 (Finset.mem_union_left H hxA)
  have hle := pointIndex_le_half_card (L := L) hA hxA
  have hpos : 0 < pointIndex (L := L) A x := hxparts.2
  exact mul_nonneg (by omega) (by omega)

omit [Fintype P] in
private theorem hole_remainder_nonneg_at {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) {y : P} (hy : y ∈ H) :
    0 ≤ (pointIndex (L := L) A y : ℤ) *
      (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A y) := by
  have hyA : y ∉ A := fun hyA => (Finset.disjoint_left.mp hdisj) hyA hy
  have hle := pointIndex_le_half_card (L := L) hA hyA
  exact mul_nonneg (by positivity) (by omega)

theorem requiredRemainder_nonneg {A H : Finset P} (hA : Arc (L := L) A) :
    0 ≤ requiredRemainder (L := L) A H := by
  classical
  rw [requiredRemainder]
  exact Finset.sum_nonneg fun x hx => required_remainder_nonneg_at (L := L) hA hx

omit [Fintype P] in
theorem holeRemainder_nonneg {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) : 0 ≤ holeRemainder (L := L) A H := by
  classical
  rw [holeRemainder]
  exact Finset.sum_nonneg fun y hy => hole_remainder_nonneg_at (L := L) hA hdisj hy

/-- The prescribed-hole defect is nonnegative. -/
theorem scaledDefect_nonneg {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) : 0 ≤ scaledDefect (L := L) A H := by
  rw [scaledDefect_eq_remainders hA hdisj]
  exact add_nonneg (requiredRemainder_nonneg hA) (holeRemainder_nonneg hA hdisj)

private theorem required_remainder_eq_zero_iff {A H : Finset P} (hA : Arc (L := L) A)
    {x : P} (hx : x ∈ coveredRequired (L := L) A H) :
    ((pointIndex (L := L) A x : ℤ) - 1) *
          (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A x) = 0 ↔
      pointIndex (L := L) A x = 1 ∨ pointIndex (L := L) A x = A.card / 2 := by
  classical
  have hxparts := Finset.mem_filter.mp hx
  have hxA : x ∉ A := fun hxA =>
    (Finset.mem_sdiff.mp hxparts.1).2 (Finset.mem_union_left H hxA)
  have hle := pointIndex_le_half_card (L := L) hA hxA
  have hpos : 0 < pointIndex (L := L) A x := hxparts.2
  constructor
  · intro hzero
    rcases mul_eq_zero.mp hzero with hzero | hzero
    · left; omega
    · right; omega
  · rintro (hr | hr) <;> simp [hr]

omit [Fintype P] in
private theorem hole_remainder_eq_zero_iff {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) {y : P} (hy : y ∈ H) :
    (pointIndex (L := L) A y : ℤ) *
          (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A y) = 0 ↔
      pointIndex (L := L) A y = 0 ∨ pointIndex (L := L) A y = A.card / 2 := by
  have hyA : y ∉ A := fun hyA => (Finset.disjoint_left.mp hdisj) hyA hy
  have hle := pointIndex_le_half_card (L := L) hA hyA
  constructor
  · intro hzero
    rcases mul_eq_zero.mp hzero with hzero | hzero
    · left; exact_mod_cast hzero
    · right; omega
  · rintro (hr | hr) <;> simp [hr]

/-- Equality occurs exactly at the two allowed point-index extremes on each side. -/
theorem scaledDefect_eq_zero_iff {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) :
    scaledDefect (L := L) A H = 0 ↔
      (∀ x ∈ coveredRequired (L := L) A H,
        pointIndex (L := L) A x = 1 ∨ pointIndex (L := L) A x = A.card / 2) ∧
      (∀ y ∈ H,
        pointIndex (L := L) A y = 0 ∨ pointIndex (L := L) A y = A.card / 2) := by
  classical
  rw [scaledDefect_eq_remainders hA hdisj]
  constructor
  · intro hzero
    have hreqnonneg := requiredRemainder_nonneg (L := L) hA (H := H)
    have hholenonneg := holeRemainder_nonneg (L := L) hA hdisj
    have hreqzero : requiredRemainder (L := L) A H = 0 := by omega
    have hholezero : holeRemainder (L := L) A H = 0 := by omega
    rw [requiredRemainder] at hreqzero
    rw [holeRemainder] at hholezero
    have hreqall := (Finset.sum_eq_zero_iff_of_nonneg
      (fun x hx => required_remainder_nonneg_at (L := L) hA hx)).mp hreqzero
    have hholeall := (Finset.sum_eq_zero_iff_of_nonneg
      (fun y hy => hole_remainder_nonneg_at (L := L) hA hdisj hy)).mp hholezero
    exact ⟨fun x hx => (required_remainder_eq_zero_iff (L := L) hA hx).mp (hreqall x hx),
      fun y hy => (hole_remainder_eq_zero_iff (L := L) hA hdisj hy).mp (hholeall y hy)⟩
  · rintro ⟨hreq, hhole⟩
    have hreqzero : requiredRemainder (L := L) A H = 0 := by
      rw [requiredRemainder]
      exact (Finset.sum_eq_zero_iff_of_nonneg
        (fun x hx => required_remainder_nonneg_at (L := L) hA hx)).mpr
          (fun x hx => (required_remainder_eq_zero_iff (L := L) hA hx).mpr (hreq x hx))
    have hholezero : holeRemainder (L := L) A H = 0 := by
      rw [holeRemainder]
      exact (Finset.sum_eq_zero_iff_of_nonneg
        (fun y hy => hole_remainder_nonneg_at (L := L) hA hdisj hy)).mpr
          (fun y hy => (hole_remainder_eq_zero_iff (L := L) hA hdisj hy).mpr (hhole y hy))
    rw [hreqzero, hholezero, add_zero]

/-- The integral form of the manuscript's coverage bound. -/
theorem coverage_bound {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) :
    (A.card / 2) * (coveredRequired (L := L) A H).card
        + holeIncidence (L := L) A H + 6 * Nat.choose A.card 4 ≤
      (A.card / 2) * (Nat.choose A.card 2 * (PlaneOrder P L - 1)) := by
  have hnonneg := scaledDefect_nonneg (L := L) hA hdisj
  rw [scaledDefect] at hnonneg
  omega

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
theorem covered_union_uncovered (A H : Finset P) :
    coveredRequired (L := L) A H ∪ uncovered (L := L) A H = requiredLocus A H := by
  classical
  ext x
  simp only [coveredRequired, uncovered, Finset.mem_union, Finset.mem_filter]
  tauto

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
theorem covered_disjoint_uncovered (A H : Finset P) :
    Disjoint (coveredRequired (L := L) A H) (uncovered (L := L) A H) := by
  classical
  rw [Finset.disjoint_left]
  intro x hxc hxu
  exact (Finset.mem_filter.mp hxu).2 (Finset.mem_filter.mp hxc).2

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
theorem card_requiredLocus (A H : Finset P) :
    (requiredLocus A H).card =
      (coveredRequired (L := L) A H).card + (uncovered (L := L) A H).card := by
  rw [← covered_union_uncovered (L := L) A H,
    Finset.card_union_of_disjoint (covered_disjoint_uncovered (L := L) A H)]

/-- A subtraction-free form of the uncovered-locus lower bound. -/
theorem uncovered_bound {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) :
    (A.card / 2) * (requiredLocus A H).card
        + holeIncidence (L := L) A H + 6 * Nat.choose A.card 4 ≤
      (A.card / 2) * (Nat.choose A.card 2 * (PlaneOrder P L - 1))
        + (A.card / 2) * (uncovered (L := L) A H).card := by
  rw [card_requiredLocus (L := L), Nat.mul_add]
  have h := coverage_bound (L := L) hA hdisj
  omega

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
private theorem intermediate_required_lower {A H : Finset P}
    {x : P} (hx : x ∈ intermediateRequired (L := L) A H) :
    (((A.card / 2 : ℕ) - 2 : ℕ) : ℤ) ≤
      ((pointIndex (L := L) A x : ℤ) - 1) *
        (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A x) := by
  classical
  have hrange := (Finset.mem_filter.mp hx).2
  have hleft : 0 ≤ (pointIndex (L := L) A x : ℤ) - 2 := by omega
  have hright : 0 ≤ ((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A x - 1 := by
    omega
  have hprod := mul_nonneg hleft hright
  have hcast : (((A.card / 2 : ℕ) - 2 : ℕ) : ℤ) =
      ((A.card / 2 : ℕ) : ℤ) - 2 := by omega
  rw [hcast]
  nlinarith

omit [Fintype P] [DecidableEq P] [DecidableEq L] [Configuration.ProjectivePlane P L] in
private theorem intermediate_hole_lower {A H : Finset P}
    {y : P} (hy : y ∈ intermediateHoles (L := L) A H) :
    (((A.card / 2 : ℕ) - 1 : ℕ) : ℤ) ≤
      (pointIndex (L := L) A y : ℤ) *
        (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A y) := by
  classical
  have hrange := (Finset.mem_filter.mp hy).2
  have hleft : 0 ≤ (pointIndex (L := L) A y : ℤ) - 1 := by omega
  have hright : 0 ≤ ((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A y - 1 := by
    omega
  have hprod := mul_nonneg hleft hright
  have hcast : (((A.card / 2 : ℕ) - 1 : ℕ) : ℤ) =
      ((A.card / 2 : ℕ) : ℤ) - 1 := by omega
  rw [hcast]
  nlinarith

private theorem intermediateRequired_bound {A H : Finset P} (hA : Arc (L := L) A) :
    (((A.card / 2 : ℕ) - 2 : ℕ) : ℤ) *
        (intermediateRequired (L := L) A H).card ≤
      requiredRemainder (L := L) A H := by
  classical
  let f : P → ℤ := fun x =>
    ((pointIndex (L := L) A x : ℤ) - 1) *
      (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A x)
  have hlower := Finset.card_nsmul_le_sum (intermediateRequired (L := L) A H) f
    ((((A.card / 2 : ℕ) - 2 : ℕ) : ℤ))
    (fun x hx => intermediate_required_lower (L := L) hx)
  have hsubset : intermediateRequired (L := L) A H ⊆ coveredRequired (L := L) A H :=
    Finset.filter_subset _ _
  have hsum : (∑ x ∈ intermediateRequired (L := L) A H, f x) ≤
      ∑ x ∈ coveredRequired (L := L) A H, f x := by
    exact Finset.sum_le_sum_of_subset_of_nonneg hsubset
      (fun x hx _hxnot => required_remainder_nonneg_at (L := L) hA hx)
  rw [requiredRemainder]
  change _ ≤ ∑ x ∈ coveredRequired (L := L) A H, f x
  simpa [nsmul_eq_mul, mul_comm] using hlower.trans hsum

omit [Fintype P] in
private theorem intermediateHoles_bound {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) :
    (((A.card / 2 : ℕ) - 1 : ℕ) : ℤ) *
        (intermediateHoles (L := L) A H).card ≤
      holeRemainder (L := L) A H := by
  classical
  let f : P → ℤ := fun y => (pointIndex (L := L) A y : ℤ) *
    (((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A y)
  have hlower := Finset.card_nsmul_le_sum (intermediateHoles (L := L) A H) f
    ((((A.card / 2 : ℕ) - 1 : ℕ) : ℤ))
    (fun y hy => intermediate_hole_lower (L := L) hy)
  have hsubset : intermediateHoles (L := L) A H ⊆ H := Finset.filter_subset _ _
  have hsum : (∑ y ∈ intermediateHoles (L := L) A H, f y) ≤ ∑ y ∈ H, f y := by
    exact Finset.sum_le_sum_of_subset_of_nonneg hsubset
      (fun y hy _hynot => hole_remainder_nonneg_at (L := L) hA hdisj hy)
  rw [holeRemainder]
  change _ ≤ ∑ y ∈ H, f y
  simpa [nsmul_eq_mul, mul_comm] using hlower.trans hsum

/-- Quantitative stability: every non-extremal index consumes a uniform amount of defect. -/
theorem stability_bound {A H : Finset P} (hA : Arc (L := L) A)
    (hdisj : Disjoint A H) :
    (((A.card / 2 : ℕ) - 2 : ℕ) : ℤ) *
          (intermediateRequired (L := L) A H).card
        + (((A.card / 2 : ℕ) - 1 : ℕ) : ℤ) *
          (intermediateHoles (L := L) A H).card ≤
      scaledDefect (L := L) A H := by
  rw [scaledDefect_eq_remainders hA hdisj]
  exact add_le_add (intermediateRequired_bound (L := L) hA)
    (intermediateHoles_bound (L := L) hA hdisj)

end FinitePlane

end RelativeConicArcs
