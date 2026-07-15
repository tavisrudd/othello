import RelativeConicArcs.BaerArithmetic

/-!
# Exact profile envelope for alternate-orbit repair

This dependency-light arithmetic module records the five first-order lower bounds for invariant
eight-arcs.  The geometric transport to semantic legal pairs and alternate repairs is added only
after the closed forms and crossover inequalities are kernel-checked.
-/

namespace RelativeConicArcs
namespace AlternateOrbitRepairProfileEnvelope

open FiniteGeom.BaerCompletion

/-- Number of conjugate candidate pairs on one empty fixed carrier. -/
def quadraticCandidateCount (s : ℕ) : ℕ := (s * s - s) / 2

theorem two_mul_quadraticCandidateCount {s : ℕ} (hs : 1 ≤ s) :
    2 * quadraticCandidateCount s = s * s - s := by
  have hprod : s * s - s = (s - 1) * ((s - 1) + 1) := by
    calc
      s * s - s = s * (s - 1) := by
        rw [Nat.mul_sub_left_distrib]
        simp
      _ = (s - 1) * ((s - 1) + 1) := by
        rw [Nat.sub_add_cancel hs, Nat.mul_comm]
  rw [quadraticCandidateCount]
  apply Nat.two_mul_div_two_of_even
  rw [hprod]
  exact Nat.even_mul_succ_self (s - 1)

theorem two_mul_quadraticCandidateCountZ {s : ℕ} (hs : 1 ≤ s) :
    2 * (quadraticCandidateCount s : ℤ) = (s : ℤ) * (s : ℤ) - (s : ℤ) := by
  have hss : s ≤ s * s := by nlinarith
  have hcast := congrArg (fun n : ℕ => (n : ℤ)) (two_mul_quadraticCandidateCount hs)
  push_cast [Nat.cast_sub hss] at hcast
  exact hcast

/-- The existing first-order total legal-pair lower bound for one eight-arc profile. -/
def profileLowerBound (s f e : ℕ) : ℕ :=
  baerEmptyLineCount s f e *
    (quadraticCandidateCount s - baerNonInvariantSecantOrbits 8 f e)

def profileZero (s : ℕ) : ℕ := profileLowerBound s 0 4
def profileTwo (s : ℕ) : ℕ := profileLowerBound s 2 3
def profileFour (s : ℕ) : ℕ := profileLowerBound s 4 2
def profileSix (s : ℕ) : ℕ := profileLowerBound s 6 1
def profileEight (s : ℕ) : ℕ := profileLowerBound s 8 0

/-! Doubled integer quartics avoid division while certifying the infinite crossover branch. -/

def twiceProfileZeroZ (s : ℤ) : ℤ := s ^ 4 - 28 * s ^ 2 - 21 * s + 72
def twiceProfileTwoZ (s : ℤ) : ℤ := s ^ 4 - 2 * s ^ 3 - 26 * s ^ 2 + 27 * s + 72
def twiceProfileFourZ (s : ℤ) : ℤ := s ^ 4 - 4 * s ^ 3 - 16 * s ^ 2 + 59 * s - 20
def twiceProfileSixZ (s : ℤ) : ℤ := s ^ 4 - 6 * s ^ 3 + 2 * s ^ 2 + 51 * s - 108
def twiceProfileEightZ (s : ℤ) : ℤ := s ^ 4 - 8 * s ^ 3 + 28 * s ^ 2 - 21 * s

theorem twiceProfileEightZ_le_twiceProfileZeroZ {s : ℤ} (hs : 10 ≤ s) :
    twiceProfileEightZ s ≤ twiceProfileZeroZ s := by
  let t := s - 10
  have ht : 0 ≤ t := by omega
  have ht2 : 0 ≤ t ^ 2 := pow_nonneg ht _
  have ht3 : 0 ≤ t ^ 3 := pow_nonneg ht _
  have hid : twiceProfileZeroZ s - twiceProfileEightZ s =
      2472 + 1280 * t + 184 * t ^ 2 + 8 * t ^ 3 := by
    simp [twiceProfileZeroZ, twiceProfileEightZ, t]
    ring
  nlinarith

theorem twiceProfileEightZ_le_twiceProfileTwoZ {s : ℤ} (hs : 10 ≤ s) :
    twiceProfileEightZ s ≤ twiceProfileTwoZ s := by
  let t := s - 10
  have ht : 0 ≤ t := by omega
  have ht2 : 0 ≤ t ^ 2 := pow_nonneg ht _
  have ht3 : 0 ≤ t ^ 3 := pow_nonneg ht _
  have hid : twiceProfileTwoZ s - twiceProfileEightZ s =
      1152 + 768 * t + 126 * t ^ 2 + 6 * t ^ 3 := by
    simp [twiceProfileTwoZ, twiceProfileEightZ, t]
    ring
  nlinarith

theorem twiceProfileEightZ_le_twiceProfileFourZ {s : ℤ} (hs : 10 ≤ s) :
    twiceProfileEightZ s ≤ twiceProfileFourZ s := by
  let t := s - 10
  have ht : 0 ≤ t := by omega
  have ht2 : 0 ≤ t ^ 2 := pow_nonneg ht _
  have ht3 : 0 ≤ t ^ 3 := pow_nonneg ht _
  have hid : twiceProfileFourZ s - twiceProfileEightZ s =
      380 + 400 * t + 76 * t ^ 2 + 4 * t ^ 3 := by
    simp [twiceProfileFourZ, twiceProfileEightZ, t]
    ring
  nlinarith

theorem twiceProfileEightZ_le_twiceProfileSixZ {s : ℤ} (hs : 10 ≤ s) :
    twiceProfileEightZ s ≤ twiceProfileSixZ s := by
  let t := s - 10
  have ht : 0 ≤ t := by omega
  have ht2 : 0 ≤ t ^ 2 := pow_nonneg ht _
  have ht3 : 0 ≤ t ^ 3 := pow_nonneg ht _
  have hid : twiceProfileSixZ s - twiceProfileEightZ s =
      12 + 152 * t + 34 * t ^ 2 + 2 * t ^ 3 := by
    simp [twiceProfileSixZ, twiceProfileEightZ, t]
    ring
  nlinarith

theorem twenty_one_le_quadraticCandidateCount {s : ℕ} (hs : 7 ≤ s) :
    21 ≤ quadraticCandidateCount s := by
  rw [quadraticCandidateCount, Nat.le_div_iff_mul_le (by omega : 0 < 2)]
  have h42 : s + 42 ≤ s * s := by nlinarith
  omega

theorem profileZero_closed {s : ℕ} (_hs : 7 ≤ s) :
    profileZero s = (s * s + s - 3) * (quadraticCandidateCount s - 12) := by
  have hcarrier : baerEmptyLineCount s 0 4 = s * s + s - 3 := by
    simp [baerEmptyLineCount, Nat.choose]
  rw [profileZero, profileLowerBound, hcarrier]
  norm_num [baerNonInvariantSecantOrbits, Nat.choose]

theorem profileTwo_closed {s : ℕ} (hs : 7 ≤ s) :
    profileTwo s = (s * s - s - 3) * (quadraticCandidateCount s - 12) := by
  have hcarrier : baerEmptyLineCount s 2 3 = s * s - s - 3 := by
    simp [baerEmptyLineCount, Nat.choose]
    omega
  rw [profileTwo, profileLowerBound, hcarrier]
  norm_num [baerNonInvariantSecantOrbits, Nat.choose]

theorem profileFour_closed {s : ℕ} (hs : 7 ≤ s) :
    profileFour s = (s * s - 3 * s + 1) * (quadraticCandidateCount s - 10) := by
  have hcarrier : baerEmptyLineCount s 4 2 = s * s - 3 * s + 1 := by
    have hchoose : (4 : ℕ).choose 2 = 6 := by decide
    rw [baerEmptyLineCount, hchoose]
    have hoccupied : 4 * (s + 1) - 6 + 2 = 4 * s := by omega
    rw [hoccupied]
    have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
    omega
  rw [profileFour, profileLowerBound, hcarrier]
  norm_num [baerNonInvariantSecantOrbits, Nat.choose]

theorem profileSix_closed {s : ℕ} (hs : 7 ≤ s) :
    profileSix s = (s * s - 5 * s + 9) * (quadraticCandidateCount s - 6) := by
  have hcarrier : baerEmptyLineCount s 6 1 = s * s - 5 * s + 9 := by
    have hchoose : (6 : ℕ).choose 2 = 15 := by decide
    rw [baerEmptyLineCount, hchoose]
    have hoccupied : 6 * (s + 1) - 15 + 1 = 6 * s - 8 := by omega
    rw [hoccupied]
    have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
    omega
  rw [profileSix, profileLowerBound, hcarrier]
  norm_num [baerNonInvariantSecantOrbits, Nat.choose]

theorem profileEight_closed {s : ℕ} (hs : 7 ≤ s) :
    profileEight s = (s * s - 7 * s + 21) * quadraticCandidateCount s := by
  have hcarrier : baerEmptyLineCount s 8 0 = s * s - 7 * s + 21 := by
    have hchoose : (8 : ℕ).choose 2 = 28 := by decide
    rw [baerEmptyLineCount, hchoose]
    have hoccupied : 8 * (s + 1) - 28 + 0 = 8 * s - 20 := by omega
    rw [hoccupied]
    have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
    omega
  rw [profileEight, profileLowerBound, hcarrier]
  norm_num [baerNonInvariantSecantOrbits, Nat.choose]

theorem twice_profileZero_cast {s : ℕ} (hs : 7 ≤ s) :
    2 * (profileZero s : ℤ) = twiceProfileZeroZ (s : ℤ) := by
  rw [profileZero_closed hs]
  have hcarrier : 3 ≤ s * s + s := by nlinarith
  have hcandidates : 12 ≤ quadraticCandidateCount s :=
    (by omega : 12 ≤ 21).trans (twenty_one_le_quadraticCandidateCount hs)
  have hq := two_mul_quadraticCandidateCountZ (by omega : 1 ≤ s)
  push_cast [Nat.cast_sub hcarrier, Nat.cast_sub hcandidates]
  calc
    2 * (((s : ℤ) * s + s - 3) * ((quadraticCandidateCount s : ℤ) - 12)) =
        ((s : ℤ) * s + s - 3) * (2 * (quadraticCandidateCount s : ℤ) - 24) := by
      ring
    _ = twiceProfileZeroZ (s : ℤ) := by
      rw [hq]
      simp [twiceProfileZeroZ]
      ring

theorem twice_profileTwo_cast {s : ℕ} (hs : 7 ≤ s) :
    2 * (profileTwo s : ℤ) = twiceProfileTwoZ (s : ℤ) := by
  rw [profileTwo_closed hs]
  have hss : s ≤ s * s := by nlinarith
  have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
  have hcarrier : 3 ≤ s * s - s := by omega
  have hcandidates : 12 ≤ quadraticCandidateCount s :=
    (by omega : 12 ≤ 21).trans (twenty_one_le_quadraticCandidateCount hs)
  have hq := two_mul_quadraticCandidateCountZ (by omega : 1 ≤ s)
  push_cast [Nat.cast_sub hss, Nat.cast_sub hcarrier, Nat.cast_sub hcandidates]
  calc
    2 * ((((s : ℤ) * s - s) - 3) * ((quadraticCandidateCount s : ℤ) - 12)) =
        (((s : ℤ) * s - s) - 3) * (2 * (quadraticCandidateCount s : ℤ) - 24) := by
      ring
    _ = twiceProfileTwoZ (s : ℤ) := by
      rw [hq]
      simp [twiceProfileTwoZ]
      ring

theorem twice_profileFour_cast {s : ℕ} (hs : 7 ≤ s) :
    2 * (profileFour s : ℤ) = twiceProfileFourZ (s : ℤ) := by
  rw [profileFour_closed hs]
  have hcarrier : 3 * s ≤ s * s := by
    have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
    omega
  have hcandidates : 10 ≤ quadraticCandidateCount s :=
    (by omega : 10 ≤ 21).trans (twenty_one_le_quadraticCandidateCount hs)
  have hq := two_mul_quadraticCandidateCountZ (by omega : 1 ≤ s)
  push_cast [Nat.cast_sub hcarrier, Nat.cast_sub hcandidates]
  calc
    2 * ((((s : ℤ) * s - 3 * s) + 1) *
        ((quadraticCandidateCount s : ℤ) - 10)) =
        (((s : ℤ) * s - 3 * s) + 1) *
          (2 * (quadraticCandidateCount s : ℤ) - 20) := by
      ring
    _ = twiceProfileFourZ (s : ℤ) := by
      rw [hq]
      simp [twiceProfileFourZ]
      ring

theorem twice_profileSix_cast {s : ℕ} (hs : 7 ≤ s) :
    2 * (profileSix s : ℤ) = twiceProfileSixZ (s : ℤ) := by
  rw [profileSix_closed hs]
  have hcarrier : 5 * s ≤ s * s := by
    have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
    omega
  have hcandidates : 6 ≤ quadraticCandidateCount s :=
    (by omega : 6 ≤ 21).trans (twenty_one_le_quadraticCandidateCount hs)
  have hq := two_mul_quadraticCandidateCountZ (by omega : 1 ≤ s)
  push_cast [Nat.cast_sub hcarrier, Nat.cast_sub hcandidates]
  calc
    2 * ((((s : ℤ) * s - 5 * s) + 9) *
        ((quadraticCandidateCount s : ℤ) - 6)) =
        (((s : ℤ) * s - 5 * s) + 9) *
          (2 * (quadraticCandidateCount s : ℤ) - 12) := by
      ring
    _ = twiceProfileSixZ (s : ℤ) := by
      rw [hq]
      simp [twiceProfileSixZ]
      ring

theorem twice_profileEight_cast {s : ℕ} (hs : 7 ≤ s) :
    2 * (profileEight s : ℤ) = twiceProfileEightZ (s : ℤ) := by
  rw [profileEight_closed hs]
  have hcarrier : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
  have hq := two_mul_quadraticCandidateCountZ (by omega : 1 ≤ s)
  push_cast [Nat.cast_sub hcarrier]
  calc
    2 * ((((s : ℤ) * s - 7 * s) + 21) * (quadraticCandidateCount s : ℤ)) =
        (((s : ℤ) * s - 7 * s) + 21) *
          (2 * (quadraticCandidateCount s : ℤ)) := by
      ring
    _ = twiceProfileEightZ (s : ℤ) := by
      rw [hq]
      simp [twiceProfileEightZ]
      ring

/-- Pointwise minimum of the five parity-allowed invariant eight-arc profile bounds. -/
def profileEnvelope (s : ℕ) : ℕ :=
  min (profileZero s)
    (min (profileTwo s) (min (profileFour s) (min (profileSix s) (profileEight s))))

theorem profileValues_seven :
    profileZero 7 = 477 ∧ profileTwo 7 = 351 ∧ profileFour 7 = 319 ∧
      profileSix 7 = 345 ∧ profileEight 7 = 441 := by
  decide

theorem profileEnvelope_seven : profileEnvelope 7 = 319 := by
  decide

theorem profileEnvelope_eq_profileFour_seven : profileEnvelope 7 = profileFour 7 := by
  decide

theorem alternateEnvelope_seven : profileEnvelope 7 - 1 = 318 := by
  decide

theorem profileValues_eight :
    profileZero 8 = 1104 ∧ profileTwo 8 = 848 ∧ profileFour 8 = 738 ∧
      profileSix 8 = 726 ∧ profileEight 8 = 812 := by
  decide

theorem profileEnvelope_eight : profileEnvelope 8 = 726 := by
  decide

theorem profileEnvelope_eq_profileSix_eight : profileEnvelope 8 = profileSix 8 := by
  decide

theorem profileValues_nine :
    profileZero 9 = 2088 ∧ profileTwo 9 = 1656 ∧ profileFour 9 = 1430 ∧
      profileSix 9 = 1350 ∧ profileEight 9 = 1404 := by
  decide

theorem profileEnvelope_nine : profileEnvelope 9 = 1350 := by
  decide

theorem profileEnvelope_eq_profileSix_nine : profileEnvelope 9 = profileSix 9 := by
  decide

theorem profileEight_le_profileZero_of_ten_le {s : ℕ} (hs : 10 ≤ s) :
    profileEight s ≤ profileZero s := by
  have hsZ : (10 : ℤ) ≤ (s : ℤ) := by exact_mod_cast hs
  have hpoly := twiceProfileEightZ_le_twiceProfileZeroZ hsZ
  rw [← twice_profileEight_cast (by omega : 7 ≤ s),
    ← twice_profileZero_cast (by omega : 7 ≤ s)] at hpoly
  have hcast : (profileEight s : ℤ) ≤ (profileZero s : ℤ) := by nlinarith
  exact_mod_cast hcast

theorem profileEight_le_profileTwo_of_ten_le {s : ℕ} (hs : 10 ≤ s) :
    profileEight s ≤ profileTwo s := by
  have hsZ : (10 : ℤ) ≤ (s : ℤ) := by exact_mod_cast hs
  have hpoly := twiceProfileEightZ_le_twiceProfileTwoZ hsZ
  rw [← twice_profileEight_cast (by omega : 7 ≤ s),
    ← twice_profileTwo_cast (by omega : 7 ≤ s)] at hpoly
  have hcast : (profileEight s : ℤ) ≤ (profileTwo s : ℤ) := by nlinarith
  exact_mod_cast hcast

theorem profileEight_le_profileFour_of_ten_le {s : ℕ} (hs : 10 ≤ s) :
    profileEight s ≤ profileFour s := by
  have hsZ : (10 : ℤ) ≤ (s : ℤ) := by exact_mod_cast hs
  have hpoly := twiceProfileEightZ_le_twiceProfileFourZ hsZ
  rw [← twice_profileEight_cast (by omega : 7 ≤ s),
    ← twice_profileFour_cast (by omega : 7 ≤ s)] at hpoly
  have hcast : (profileEight s : ℤ) ≤ (profileFour s : ℤ) := by nlinarith
  exact_mod_cast hcast

theorem profileEight_le_profileSix_of_ten_le {s : ℕ} (hs : 10 ≤ s) :
    profileEight s ≤ profileSix s := by
  have hsZ : (10 : ℤ) ≤ (s : ℤ) := by exact_mod_cast hs
  have hpoly := twiceProfileEightZ_le_twiceProfileSixZ hsZ
  rw [← twice_profileEight_cast (by omega : 7 ≤ s),
    ← twice_profileSix_cast (by omega : 7 ≤ s)] at hpoly
  have hcast : (profileEight s : ℤ) ≤ (profileSix s : ℤ) := by nlinarith
  exact_mod_cast hcast

theorem profileEnvelope_eq_profileEight_of_ten_le {s : ℕ} (hs : 10 ≤ s) :
    profileEnvelope s = profileEight s := by
  apply Nat.le_antisymm
  · exact (min_le_right _ _).trans
      ((min_le_right _ _).trans ((min_le_right _ _).trans (min_le_right _ _)))
  · exact le_min (profileEight_le_profileZero_of_ten_le hs)
      (le_min (profileEight_le_profileTwo_of_ten_le hs)
        (le_min (profileEight_le_profileFour_of_ten_le hs)
          (le_min (profileEight_le_profileSix_of_ten_le hs) le_rfl)))

theorem three_hundred_nineteen_le_profileZero {s : ℕ} (hs : 7 ≤ s) :
    319 ≤ profileZero s := by
  rw [profileZero_closed hs]
  have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
  have hcarrier : 53 ≤ s * s + s - 3 := by omega
  have hcandidates : 9 ≤ quadraticCandidateCount s - 12 := by
    have := twenty_one_le_quadraticCandidateCount hs
    omega
  exact (by norm_num : 319 ≤ 53 * 9).trans (Nat.mul_le_mul hcarrier hcandidates)

theorem three_hundred_nineteen_le_profileTwo {s : ℕ} (hs : 7 ≤ s) :
    319 ≤ profileTwo s := by
  rw [profileTwo_closed hs]
  have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
  have hcarrier : 39 ≤ s * s - s - 3 := by omega
  have hcandidates : 9 ≤ quadraticCandidateCount s - 12 := by
    have := twenty_one_le_quadraticCandidateCount hs
    omega
  exact (by norm_num : 319 ≤ 39 * 9).trans (Nat.mul_le_mul hcarrier hcandidates)

theorem three_hundred_nineteen_le_profileFour {s : ℕ} (hs : 7 ≤ s) :
    319 ≤ profileFour s := by
  rw [profileFour_closed hs]
  have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
  have hcarrier : 29 ≤ s * s - 3 * s + 1 := by omega
  have hcandidates : 11 ≤ quadraticCandidateCount s - 10 := by
    have := twenty_one_le_quadraticCandidateCount hs
    omega
  exact (by norm_num : 319 ≤ 29 * 11).trans (Nat.mul_le_mul hcarrier hcandidates)

theorem three_hundred_nineteen_le_profileSix {s : ℕ} (hs : 7 ≤ s) :
    319 ≤ profileSix s := by
  rw [profileSix_closed hs]
  have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
  have hcarrier : 23 ≤ s * s - 5 * s + 9 := by omega
  have hcandidates : 15 ≤ quadraticCandidateCount s - 6 := by
    have := twenty_one_le_quadraticCandidateCount hs
    omega
  exact (by norm_num : 319 ≤ 23 * 15).trans (Nat.mul_le_mul hcarrier hcandidates)

theorem three_hundred_nineteen_le_profileEight {s : ℕ} (hs : 7 ≤ s) :
    319 ≤ profileEight s := by
  rw [profileEight_closed hs]
  have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
  have hcarrier : 21 ≤ s * s - 7 * s + 21 := by omega
  have hcandidates := twenty_one_le_quadraticCandidateCount hs
  exact (by norm_num : 319 ≤ 21 * 21).trans (Nat.mul_le_mul hcarrier hcandidates)

theorem three_hundred_nineteen_le_profileEnvelope {s : ℕ} (hs : 7 ≤ s) :
    319 ≤ profileEnvelope s := by
  unfold profileEnvelope
  exact le_min (three_hundred_nineteen_le_profileZero hs)
    (le_min (three_hundred_nineteen_le_profileTwo hs)
      (le_min (three_hundred_nineteen_le_profileFour hs)
        (le_min (three_hundred_nineteen_le_profileSix hs)
          (three_hundred_nineteen_le_profileEight hs))))

theorem three_hundred_eighteen_le_alternateEnvelope {s : ℕ} (hs : 7 ≤ s) :
    318 ≤ profileEnvelope s - 1 := by
  have := three_hundred_nineteen_le_profileEnvelope hs
  omega

theorem profileEnvelope_le_profileLowerBound_of_eight {s f e : ℕ}
    (hprofile : 8 = f + 2 * e) :
    profileEnvelope s ≤ profileLowerBound s f e := by
  have hcases :
      (f = 0 ∧ e = 4) ∨ (f = 2 ∧ e = 3) ∨ (f = 4 ∧ e = 2) ∨
        (f = 6 ∧ e = 1) ∨ (f = 8 ∧ e = 0) := by
    omega
  rcases hcases with h | h | h | h | h
  · rcases h with ⟨rfl, rfl⟩
    exact min_le_left _ _
  · rcases h with ⟨rfl, rfl⟩
    exact (min_le_right _ _).trans (min_le_left _ _)
  · rcases h with ⟨rfl, rfl⟩
    exact (min_le_right _ _).trans ((min_le_right _ _).trans (min_le_left _ _))
  · rcases h with ⟨rfl, rfl⟩
    exact (min_le_right _ _).trans
      ((min_le_right _ _).trans ((min_le_right _ _).trans (min_le_left _ _)))
  · rcases h with ⟨rfl, rfl⟩
    exact (min_le_right _ _).trans
      ((min_le_right _ _).trans ((min_le_right _ _).trans (min_le_right _ _)))

end AlternateOrbitRepairProfileEnvelope
end RelativeConicArcs
