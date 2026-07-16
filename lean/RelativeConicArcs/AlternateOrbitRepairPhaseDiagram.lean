import RelativeConicArcs.AlternateOrbitRepairProfileEnvelope

/-!
# Parameterized alternate-orbit repair phase diagram

This arithmetic layer isolates the uniform obstruction envelope for an invariant remainder of
size `k`.  It also proves that the useful multiplicity region automatically has an empty fixed
carrier, so the semantic theorem needs no separate carrier hypothesis.
-/

namespace RelativeConicArcs
namespace AlternateOrbitRepairPhaseDiagram

open FiniteGeom.BaerCompletion
open AlternateOrbitRepairProfileEnvelope

/-- Exact worst-case number of noninvariant old-secant orbits among profiles of size `k`. -/
def worstObstruction (k : ℕ) : ℕ := (k - 1) ^ 2 / 4

/-- The clean parameter region guaranteeing `r` alternatives after deleting the selected orbit. -/
def PhaseAdmissible (s k r : ℕ) : Prop :=
  worstObstruction k + r + 1 ≤ quadraticCandidateCount s

/-- The profile obstruction `fe+e(e-1)` is the concave quadratic `e(k-e-1)`. -/
theorem profileObstruction_eq {k f e : ℕ} (hk : k = f + 2 * e) :
    f * e + e * (e - 1) = e * (k - e - 1) := by
  cases e with
  | zero => simp
  | succ e =>
      have hsub : k - (e + 1) - 1 = f + e := by omega
      rw [hsub]
      simp only [Nat.succ_sub_one]
      ring

/-- The concave profile obstruction is bounded by `floor((k-1)^2/4)`. -/
theorem baerNonInvariantSecantOrbits_le_worstObstruction
    {k f e : ℕ} (hk : k = f + 2 * e) :
    baerNonInvariantSecantOrbits k f e ≤ worstObstruction k := by
  rw [baerNonInvariantSecantOrbits_eq hk, profileObstruction_eq hk,
    worstObstruction, Nat.le_div_iff_mul_le (by norm_num : 0 < 4)]
  subst k
  cases f with
  | zero =>
      cases e with
      | zero => norm_num
      | succ e =>
          have hleft : 2 * (e + 1) - (e + 1) - 1 = e := by omega
          have hright : 2 * (e + 1) - 1 = 2 * e + 1 := by omega
          simp only [zero_add]
          rw [hleft, hright]
          nlinarith
  | succ f =>
      have hleft : (f + 1 + 2 * e) - e - 1 = f + e := by omega
      have hright : (f + 1 + 2 * e) - 1 = f + 2 * e := by omega
      rw [hleft, hright]
      nlinarith

/-- The upper envelope is sharp: a parity-minimal fixed-point profile attains it for every `k`. -/
theorem exists_profile_attaining_worstObstruction (k : ℕ) :
    ∃ f e : ℕ, k = f + 2 * e ∧
      baerNonInvariantSecantOrbits k f e = worstObstruction k := by
  rcases Nat.even_or_odd k with heven | hodd
  · obtain ⟨t, ht⟩ := heven
    refine ⟨0, t, by omega, ?_⟩
    have hprofile : k = 0 + 2 * t := by omega
    rw [baerNonInvariantSecantOrbits_eq hprofile, profileObstruction_eq hprofile]
    unfold worstObstruction
    subst k
    cases t with
    | zero => norm_num
    | succ t =>
        have hobstruction : t + 1 + (t + 1) - (t + 1) - 1 = t := by omega
        have hpred : t + 1 + (t + 1) - 1 = 2 * t + 1 := by omega
        rw [hobstruction, hpred]
        symm
        apply Nat.div_eq_of_lt_le
        · nlinarith
        · nlinarith
  · obtain ⟨t, ht⟩ := hodd
    refine ⟨1, t, by omega, ?_⟩
    have hprofile : k = 1 + 2 * t := by omega
    rw [baerNonInvariantSecantOrbits_eq hprofile, profileObstruction_eq hprofile]
    unfold worstObstruction
    subst k
    have hleft : 2 * t + 1 - t - 1 = t := by omega
    have hright : 2 * t + 1 - 1 = 2 * t := by omega
    rw [hleft, hright]
    symm
    apply Nat.div_eq_of_lt_le
    · nlinarith
    · nlinarith

/-- The multiplicity inequality itself forces the remainder into the carrier-friendly range. -/
theorem k_le_two_mul_s_add_one_of_phase {s k : ℕ} (hs : 1 ≤ s)
    (hphase : worstObstruction k + 1 ≤ quadraticCandidateCount s) :
    k ≤ 2 * s + 1 := by
  by_contra hnot
  have hk : 2 * s + 2 ≤ k := by omega
  have hkpred : 2 * s + 1 ≤ k - 1 := by omega
  have hsq : (2 * s + 1) ^ 2 ≤ (k - 1) ^ 2 :=
    Nat.pow_le_pow_left hkpred 2
  have hss : s ≤ s * s := by nlinarith
  have hdiff : s * s - s + s = s * s := Nat.sub_add_cancel hss
  have htwo := two_mul_quadraticCandidateCount hs
  have hfour : 4 * quadraticCandidateCount s ≤ (k - 1) ^ 2 := by
    nlinarith
  have hcand_le : quadraticCandidateCount s ≤ worstObstruction k := by
    rw [worstObstruction, Nat.le_div_iff_mul_le (by norm_num : 0 < 4)]
    simpa [Nat.mul_comm] using hfour
  omega

theorem k_lt_square_add_one_of_phase {s k : ℕ} (hs : 3 ≤ s)
    (hphase : worstObstruction k + 1 ≤ quadraticCandidateCount s) :
    k < s * s + 1 := by
  have hk := k_le_two_mul_s_add_one_of_phase (by omega : 1 ≤ s) hphase
  nlinarith

/-- In the useful phase region every compatible profile has an empty fixed carrier. -/
theorem one_le_baerEmptyLineCount_of_phase {s k f e : ℕ} (hs : 3 ≤ s)
    (hk : k = f + 2 * e)
    (hphase : worstObstruction k + 1 ≤ quadraticCandidateCount s) :
    1 ≤ baerEmptyLineCount s f e := by
  have hkrange := k_le_two_mul_s_add_one_of_phase (by omega : 1 ≤ s) hphase
  have hf_le_k : f ≤ k := by omega
  have hf_range : f ≤ 2 * s + 1 := hf_le_k.trans hkrange
  have hfminus : f - 1 ≤ 2 * s := by omega
  have hchoose_twice := two_mul_choose_two f
  have hmul : f * (f - 1) ≤ f * (2 * s) := Nat.mul_le_mul_left f hfminus
  have hchoose : f.choose 2 ≤ f * (s + 1) := by
    have hchoose_s : f.choose 2 ≤ f * s := by nlinarith
    exact hchoose_s.trans (Nat.mul_le_mul_left f (Nat.le_succ s))
  let occupied : ℕ := f * (s + 1) - f.choose 2 + e
  have hoccupied_cast : (occupied : ℤ) = occupiedLineCountZ s f e := by
    simp only [occupied, Nat.cast_add, Nat.cast_sub hchoose, Nat.cast_mul]
    rfl
  have hid := two_mul_occupiedLineCountZ (s := s) hk
  have hklt := k_lt_square_add_one_of_phase hs hphase
  have hkltZ : (k : ℤ) < (s : ℤ) ^ 2 + 1 := by
    have : (k : ℤ) < ((s * s + 1 : ℕ) : ℤ) := by exact_mod_cast hklt
    simpa [pow_two] using this
  have hsquare : 0 ≤ ((f : ℤ) - (s : ℤ) - 1) ^ 2 := sq_nonneg _
  have hoccupied_ltZ :
      occupiedLineCountZ s f e < (s : ℤ) ^ 2 + (s : ℤ) + 1 := by
    nlinarith
  have hoccupied_lt : occupied < s * s + s + 1 := by
    rw [← hoccupied_cast] at hoccupied_ltZ
    have : occupied < s ^ 2 + s + 1 := by exact_mod_cast hoccupied_ltZ
    simpa [pow_two] using this
  unfold baerEmptyLineCount
  change 1 ≤ s * s + s + 1 - occupied
  omega

/-- The exact phase condition supplies both an empty carrier and `r+1` unobstructed candidates on
that carrier. -/
theorem phase_profile_product_lowerBound {s k f e r : ℕ} (hs : 3 ≤ s)
    (hk : k = f + 2 * e) (hphase : PhaseAdmissible s k r) :
    r + 1 ≤ baerEmptyLineCount s f e *
      (quadraticCandidateCount s - baerNonInvariantSecantOrbits k f e) := by
  have hbase : worstObstruction k + 1 ≤ quadraticCandidateCount s := by
    unfold PhaseAdmissible at hphase
    omega
  have hempty := one_le_baerEmptyLineCount_of_phase hs hk hbase
  have hobstruction := baerNonInvariantSecantOrbits_le_worstObstruction hk
  have hsurplus :
      r + 1 ≤ quadraticCandidateCount s - baerNonInvariantSecantOrbits k f e := by
    unfold PhaseAdmissible at hphase
    omega
  calc
    r + 1 = 1 * (r + 1) := by simp
    _ ≤ baerEmptyLineCount s f e *
        (quadraticCandidateCount s - baerNonInvariantSecantOrbits k f e) :=
      Nat.mul_le_mul hempty hsurplus

/-- A convenient rectangular subregion: over base order at least four, every remainder of size at
most `s+1` has at least one alternate repair available.  The lower bound `s≥4` is sharp for this
rectangle: `(s,k)=(3,4)` lies just outside the exact phase. -/
theorem phaseAdmissible_one_of_k_le_s_add_one {s k : ℕ} (hs : 4 ≤ s)
    (hk : k ≤ s + 1) : PhaseAdmissible s k 1 := by
  have hkpred : k - 1 ≤ s := by omega
  have hsq : (k - 1) ^ 2 ≤ s ^ 2 := Nat.pow_le_pow_left hkpred 2
  have hworst_four : 4 * worstObstruction k ≤ (k - 1) ^ 2 := by
    unfold worstObstruction
    simpa [Nat.mul_comm] using Nat.div_mul_le_self ((k - 1) ^ 2) 4
  have hss : s ≤ s * s := by nlinarith
  have hdiff : s * s - s + s = s * s := Nat.sub_add_cancel hss
  have htwo := two_mul_quadraticCandidateCount (by omega : 1 ≤ s)
  have hquad : s * s + 8 ≤ 2 * (s * s - s) := by nlinarith
  have hfour :
      4 * (worstObstruction k + 2) ≤ 4 * quadraticCandidateCount s := by
    nlinarith
  unfold PhaseAdmissible
  omega

end AlternateOrbitRepairPhaseDiagram
end RelativeConicArcs
