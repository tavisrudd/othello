import RelativeConicArcs.Moments
import FiniteGeom.BaerCompletion.PairExtension

/-!
# Arithmetic identities for quadratic Baer extension

These are the point/orbit normalization identities used after the geometric incidence counts.
-/

namespace RelativeConicArcs

open FiniteGeom.BaerCompletion

/-- Under `k=f+2e`, the definition by noninvariant secant orbits agrees with the explicit profile
formula `fe+e(e-1)`. -/
theorem baerNonInvariantSecantOrbits_eq {k f e : ℕ} (hk : k = f + 2 * e) :
    baerNonInvariantSecantOrbits k f e = f * e + e * (e - 1) := by
  have hkchoose := two_mul_choose_two k
  have hfchoose := two_mul_choose_two f
  cases e with
  | zero =>
      subst k
      simp [baerNonInvariantSecantOrbits]
  | succ e =>
      have hkminus : k - 1 = f + 2 * e + 1 := by omega
      have hfull :
          k.choose 2 = f.choose 2 + (e + 1) +
            2 * (f * (e + 1) + (e + 1) * e) := by
        cases f with
        | zero =>
            simp at hfchoose ⊢
            nlinarith
        | succ f =>
            simp only [Nat.succ_sub_one] at hfchoose
            nlinarith
      have hnum :
          k.choose 2 - (f.choose 2 + (e + 1)) =
            2 * (f * (e + 1) + (e + 1) * e) := by omega
      rw [baerNonInvariantSecantOrbits, hnum]
      simp

/-- For an invariant eight-arc, the number of noninvariant old-secant orbits is at most twelve. -/
theorem baerNonInvariantSecantOrbits_le_twelve_of_eight
    {f e : ℕ} (hk : 8 = f + 2 * e) :
    baerNonInvariantSecantOrbits 8 f e ≤ 12 := by
  rw [baerNonInvariantSecantOrbits_eq hk]
  have he : e ≤ 4 := by omega
  interval_cases e <;> omega

/-- At quadratic subfield order at least seven, every empty subfield line has more than twelve
conjugate candidate pairs. -/
theorem twelve_lt_quadraticCandidateCount {s : ℕ} (hs : 7 ≤ s) :
    12 < (s * s - s) / 2 := by
  have h21 : 21 ≤ (s * s - s) / 2 := by
    rw [Nat.le_div_iff_mul_le (by omega : 0 < 2)]
    have h42 : s + 42 ≤ s * s := by nlinarith
    omega
  omega

/-- Integer-valued occupied-subfield-line count, avoiding truncated subtraction while proving the
completed-square identity. -/
def occupiedLineCountZ (s f e : ℕ) : ℤ :=
  (f : ℤ) * ((s : ℤ) + 1) - (f.choose 2 : ℤ) + (e : ℤ)

/-- The exact completed-square identity
`2O=(s+1)²+k-(f-s-1)²`. -/
theorem two_mul_occupiedLineCountZ {s k f e : ℕ} (hk : k = f + 2 * e) :
    2 * occupiedLineCountZ s f e =
      ((s : ℤ) + 1) ^ 2 + (k : ℤ) - ((f : ℤ) - (s : ℤ) - 1) ^ 2 := by
  have hfchoose : 2 * (f.choose 2 : ℤ) = (f : ℤ) * ((f : ℤ) - 1) := by
    cases f with
    | zero => norm_num
    | succ f =>
        have h := two_mul_choose_two (f + 1)
        have hz := congrArg (fun n : ℕ => (n : ℤ)) h
        norm_num only [Nat.cast_mul, Nat.cast_ofNat] at hz
        rw [Nat.cast_sub (by omega : 1 ≤ f + 1)] at hz
        norm_num only [Nat.cast_add, Nat.cast_one]
        simpa using hz
  have hkz : (k : ℤ) = (f : ℤ) + 2 * (e : ℤ) := by
    exact_mod_cast hk
  unfold occupiedLineCountZ
  nlinarith

/-- If every subfield line is occupied, the arc size satisfies the stronger exact equation
`k=s²+1+(f-s-1)²`. -/
theorem eq_of_occupiedLineCountZ_eq_all {s k f e : ℕ} (hk : k = f + 2 * e)
    (hall : occupiedLineCountZ s f e = (s : ℤ) ^ 2 + (s : ℤ) + 1) :
    (k : ℤ) = (s : ℤ) ^ 2 + 1 + ((f : ℤ) - (s : ℤ) - 1) ^ 2 := by
  have hid := two_mul_occupiedLineCountZ (s := s) hk
  rw [hall] at hid
  nlinarith

/-- Therefore an arc with `k<s²+1` cannot occupy every subfield line. -/
theorem occupiedLineCountZ_ne_all_of_lt {s k f e : ℕ} (hk : k = f + 2 * e)
    (hlt : k < s * s + 1) :
    occupiedLineCountZ s f e ≠ (s : ℤ) ^ 2 + (s : ℤ) + 1 := by
  intro hall
  have heq := eq_of_occupiedLineCountZ_eq_all hk hall
  have hsquare : 0 ≤ ((f : ℤ) - (s : ℤ) - 1) ^ 2 := sq_nonneg _
  have hltz : (k : ℤ) < (s : ℤ) ^ 2 + 1 := by
    have hltz' : (k : ℤ) < (s * s + 1 : ℕ) := by exact_mod_cast hlt
    simpa [pow_two] using hltz'
  nlinarith

end RelativeConicArcs
