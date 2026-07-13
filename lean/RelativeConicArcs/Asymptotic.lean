import RelativeConicArcs.Conic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.Asymptotics.Defs
import Mathlib.Order.LiminfLimsup

/-!
# Asymptotic lower bounds

The analytic layer starts from a parity-free cubic necessary inequality.  Quantified finite
estimates are proved before any asymptotic notation or liminf packaging.
-/

namespace RelativeConicArcs
namespace Conic

/-- The parity-free necessary inequality behind the additive `3/2` term. -/
theorem parityFreeNecessary {q k : ℕ} (h : L2Admissible q k) :
    ((q ^ 2 - k : ℕ) : ℚ) ≤
      (((k - 1 : ℕ) : ℚ) / 2) *
        ((k : ℚ) * (q - 1 : ℕ) -
          ((k - 2 : ℕ) : ℚ) * (k - 3 : ℕ)) := by
  rcases h with ⟨hk, hcap⟩
  let m := k / 2
  have hmpos : 0 < m := Nat.div_pos (by omega : 2 ≤ k) (by omega)
  have hmle : 2 * m ≤ k := by
    dsimp [m]
    simpa [mul_comm] using Nat.div_mul_le_self k 2
  have hcapQ :
      (m : ℚ) * (q ^ 2 - k : ℕ) + 6 * (Nat.choose k 4 : ℚ) ≤
        (m : ℚ) * ((Nat.choose k 2 : ℚ) * (q - 1 : ℕ)) := by
    exact_mod_cast hcap
  have hchooseTwo :
      2 * (Nat.choose k 2 : ℚ) = (k : ℚ) * (k - 1 : ℕ) := by
    exact_mod_cast two_mul_choose_two k
  have hchooseFour :
      24 * (Nat.choose k 4 : ℚ) =
        (k : ℚ) * (k - 1 : ℕ) * (k - 2 : ℕ) * (k - 3 : ℕ) := by
    exact_mod_cast twentyFour_mul_choose_four k
  let T : ℚ := ((k - 1 : ℕ) : ℚ) * (k - 2 : ℕ) * (k - 3 : ℕ)
  have hTnonneg : 0 ≤ T := by positivity
  have hmleQ : (2 : ℚ) * m ≤ k := by exact_mod_cast hmle
  have hprod := mul_le_mul_of_nonneg_right hmleQ hTnonneg
  have hfour : (2 : ℚ) * m * T ≤ 24 * (Nat.choose k 4 : ℚ) := by
    calc
      (2 : ℚ) * m * T ≤ (k : ℚ) * T := by simpa [mul_assoc] using hprod
      _ = 24 * (Nat.choose k 4 : ℚ) := by
        rw [hchooseFour]
        simp [T, mul_assoc]
  have hcorrection : T / 2 ≤ 6 / (m : ℚ) * (Nat.choose k 4 : ℚ) := by
    have hmQ : (0 : ℚ) < m := by exact_mod_cast hmpos
    rw [show 6 / (m : ℚ) * (Nat.choose k 4 : ℚ) =
      (6 * (Nat.choose k 4 : ℚ)) / m by ring]
    apply (le_div_iff₀ hmQ).2
    nlinarith
  have hdiv :
      ((q ^ 2 - k : ℕ) : ℚ) + 6 / (m : ℚ) * (Nat.choose k 4 : ℚ) ≤
        (Nat.choose k 2 : ℚ) * (q - 1 : ℕ) := by
    have hmQ : (0 : ℚ) < m := by exact_mod_cast hmpos
    apply (le_of_mul_le_mul_left _ hmQ)
    field_simp
    nlinarith
  calc
    ((q ^ 2 - k : ℕ) : ℚ) ≤
        (Nat.choose k 2 : ℚ) * (q - 1 : ℕ) - T / 2 := by linarith
    _ = (((k - 1 : ℕ) : ℚ) / 2) *
        ((k : ℚ) * (q - 1 : ℕ) -
          ((k - 2 : ℕ) : ℚ) * (k - 3 : ℕ)) := by
      rw [show (Nat.choose k 2 : ℚ) =
        (k : ℚ) * (k - 1 : ℕ) / 2 by nlinarith [hchooseTwo]]
      simp [T]
      ring

/-- Real-valued form of the parity-free inequality when the natural subtractions are genuine. -/
theorem parityFreeNecessary_real {q k : ℕ} (hq : 1 ≤ q) (hkq : k ≤ q ^ 2)
    (h : L2Admissible q k) :
    (q : ℝ) ^ 2 - k ≤
      (((k : ℝ) - 1) / 2) *
        ((k : ℝ) * ((q : ℝ) - 1) - ((k : ℝ) - 2) * ((k : ℝ) - 3)) := by
  rcases h with ⟨hk, hcap⟩
  let m := k / 2
  have hmpos : 0 < m := Nat.div_pos (by omega : 2 ≤ k) (by omega)
  have hmle : 2 * m ≤ k := by
    dsimp [m]
    simpa [mul_comm] using Nat.div_mul_le_self k 2
  have hcapR :
      (m : ℝ) * (q ^ 2 - k : ℕ) + 6 * (Nat.choose k 4 : ℝ) ≤
        (m : ℝ) * ((Nat.choose k 2 : ℝ) * (q - 1 : ℕ)) := by
    exact_mod_cast hcap
  have hchooseTwo :
      2 * (Nat.choose k 2 : ℝ) = (k : ℝ) * (k - 1 : ℕ) := by
    exact_mod_cast two_mul_choose_two k
  have hchooseFour :
      24 * (Nat.choose k 4 : ℝ) =
        (k : ℝ) * (k - 1 : ℕ) * (k - 2 : ℕ) * (k - 3 : ℕ) := by
    exact_mod_cast twentyFour_mul_choose_four k
  let T : ℝ := ((k - 1 : ℕ) : ℝ) * (k - 2 : ℕ) * (k - 3 : ℕ)
  have hTnonneg : 0 ≤ T := by positivity
  have hmleR : (2 : ℝ) * m ≤ k := by exact_mod_cast hmle
  have hprod := mul_le_mul_of_nonneg_right hmleR hTnonneg
  have hfour : (2 : ℝ) * m * T ≤ 24 * (Nat.choose k 4 : ℝ) := by
    calc
      (2 : ℝ) * m * T ≤ (k : ℝ) * T := by simpa [mul_assoc] using hprod
      _ = 24 * (Nat.choose k 4 : ℝ) := by rw [hchooseFour]; simp [T, mul_assoc]
  have hcorrection : T / 2 ≤ 6 / (m : ℝ) * (Nat.choose k 4 : ℝ) := by
    have hmR : (0 : ℝ) < m := by exact_mod_cast hmpos
    rw [show 6 / (m : ℝ) * (Nat.choose k 4 : ℝ) =
      (6 * (Nat.choose k 4 : ℝ)) / m by ring]
    apply (le_div_iff₀ hmR).2
    nlinarith
  have hdiv :
      ((q ^ 2 - k : ℕ) : ℝ) + 6 / (m : ℝ) * (Nat.choose k 4 : ℝ) ≤
        (Nat.choose k 2 : ℝ) * (q - 1 : ℕ) := by
    have hmR : (0 : ℝ) < m := by exact_mod_cast hmpos
    apply (le_of_mul_le_mul_left _ hmR)
    field_simp
    nlinarith
  have hraw : ((q ^ 2 - k : ℕ) : ℝ) ≤
      (Nat.choose k 2 : ℝ) * (q - 1 : ℕ) - T / 2 := by linarith
  push_cast [Nat.cast_sub hkq, Nat.cast_sub hq,
    Nat.cast_sub (by omega : 1 ≤ k), Nat.cast_sub (by omega : 2 ≤ k),
    Nat.cast_sub (by omega : 3 ≤ k)] at hraw hchooseTwo ⊢
  rw [show (Nat.choose k 2 : ℝ) = (k : ℝ) * ((k : ℝ) - 1) / 2 by
    nlinarith [hchooseTwo]] at hraw
  dsimp [T] at hraw
  push_cast [Nat.cast_sub (by omega : 1 ≤ k), Nat.cast_sub (by omega : 2 ≤ k),
    Nat.cast_sub (by omega : 3 ≤ k)] at hraw
  calc
    (q : ℝ) ^ 2 - k ≤
        (k : ℝ) * ((k : ℝ) - 1) / 2 * ((q : ℝ) - 1) -
          (((k : ℝ) - 1) * ((k : ℝ) - 2) * ((k : ℝ) - 3)) / 2 := hraw
    _ = (((k : ℝ) - 1) / 2) *
        ((k : ℝ) * ((q : ℝ) - 1) - ((k : ℝ) - 2) * ((k : ℝ) - 3)) := by
      ring

/-- The elementary first-moment estimate already forces `k ≥ sqrt(2q)`. -/
theorem sqrt_two_mul_le_of_l1Admissible {q k : ℕ} (hq : 2 ≤ q) (hkq : k ≤ q ^ 2)
    (h : L1Admissible q k) :
    Real.sqrt (2 * q) ≤ k := by
  rcases h with ⟨hk, hboundNat⟩
  have hq0 : (0 : ℝ) ≤ 2 * q := by positivity
  have hsquare : Real.sqrt (2 * q) ^ 2 = (2 : ℝ) * q := Real.sq_sqrt hq0
  have hsnonneg : 0 ≤ Real.sqrt (2 * q) := Real.sqrt_nonneg _
  have hqreal : (2 : ℝ) ≤ q := by exact_mod_cast hq
  have hsleq : Real.sqrt (2 * q) ≤ (q : ℝ) := by nlinarith
  have hchoose : (2 : ℝ) * (Nat.choose k 2 : ℝ) = k * ((k : ℝ) - 1) := by
    have hcast : (2 : ℝ) * (Nat.choose k 2 : ℝ) =
        (k : ℝ) * ((k - 1 : ℕ) : ℝ) := by
      exact_mod_cast two_mul_choose_two k
    rw [Nat.cast_sub (by omega : 1 ≤ k)] at hcast
    simpa using hcast
  have hbound : (q : ℝ) ^ 2 - k ≤
      (Nat.choose k 2 : ℝ) * ((q : ℝ) - 1) := by
    have hnat : ((q ^ 2 - k : ℕ) : ℝ) ≤
        (Nat.choose k 2 : ℝ) * (q - 1 : ℕ) := by exact_mod_cast hboundNat
    push_cast [Nat.cast_sub hkq, Nat.cast_sub (by omega : 1 ≤ q)] at hnat
    exact hnat
  by_contra hks
  have hklt : (k : ℝ) < Real.sqrt (2 * q) := lt_of_not_ge hks
  have hkqreal : (k : ℝ) ≤ q := hklt.le.trans hsleq
  have hk2 : (k : ℝ) ^ 2 < 2 * q := by nlinarith
  have hqminus : 0 < (q : ℝ) - 1 := by linarith
  have hchoose_nonneg : 0 ≤ (Nat.choose k 2 : ℝ) := by positivity
  have hchoose_lt : (Nat.choose k 2 : ℝ) < q := by nlinarith
  have hright_lt : (Nat.choose k 2 : ℝ) * ((q : ℝ) - 1) <
      (q : ℝ) * ((q : ℝ) - 1) :=
    mul_lt_mul_of_pos_right hchoose_lt hqminus
  nlinarith

/-- Explicit finite form of the additive-`3/2` estimate. -/
theorem explicit_additive_lower_bound {q k : ℕ} (hq : 2 ≤ q) (hkq : k ≤ q ^ 2)
    (h : L2Admissible q k) :
    Real.sqrt (2 * q) + 3 / 2 - 8 / Real.sqrt (2 * q) ≤ (k : ℝ) := by
  let s : ℝ := Real.sqrt (2 * q)
  let a : ℝ := k - s
  have hsnonneg : 0 ≤ s := Real.sqrt_nonneg _
  have hsquare : s ^ 2 = (2 : ℝ) * q := by
    dsimp [s]
    exact Real.sq_sqrt (by positivity)
  have hsge : 2 ≤ s := by
    have : (2 : ℝ) ≤ q := by exact_mod_cast hq
    nlinarith
  have hks : s ≤ k := sqrt_two_mul_le_of_l1Admissible hq hkq
    (l2Admissible_l1Admissible h)
  have ha0 : 0 ≤ a := by dsimp [a]; linarith
  by_cases hlarge : s + 2 ≤ (k : ℝ)
  · have hspos : 0 < s := lt_of_lt_of_le (by norm_num) hsge
    have : 8 / s ≥ 0 := div_nonneg (by norm_num) hsnonneg
    change s + 3 / 2 - 8 / s ≤ (k : ℝ)
    linarith
  · have ha2 : a ≤ 2 := by
      dsimp [a]
      linarith
    have hparity := parityFreeNecessary_real (by omega) hkq h
    have hD : 0 ≤
        (((k : ℝ) - 1) / 2) *
          ((k : ℝ) * ((q : ℝ) - 1) - ((k : ℝ) - 2) * ((k : ℝ) - 3))
          - ((q : ℝ) ^ 2 - k) := by linarith
    have hB2 : (a ^ 2 - 7 * a + 10) / 4 ≤ 5 / 2 := by nlinarith
    have hB1 : (-3 * a ^ 2 + 10 * a - 8) / 2 ≤ 1 := by nlinarith
    have hB0 : (-a ^ 3 + 5 * a ^ 2 - 8 * a + 6) / 2 ≤ 3 := by
      have hprod : 0 ≤ a * (2 - a) * (a - 3) ^ 2 := by positivity
      nlinarith
    have hR :
        (a ^ 2 - 7 * a + 10) / 4 * s ^ 2
            + (-3 * a ^ 2 + 10 * a - 8) / 2 * s
            + (-a ^ 3 + 5 * a ^ 2 - 8 * a + 6) / 2 ≤ 4 * s ^ 2 := by
      have hs2 : 0 ≤ s ^ 2 := sq_nonneg s
      have hs_le_half_sq : s ≤ s ^ 2 / 2 := by nlinarith
      have hthree : (3 : ℝ) ≤ 3 / 4 * s ^ 2 := by nlinarith
      nlinarith
    have hExpansion :
        (((k : ℝ) - 1) / 2) *
            ((k : ℝ) * ((q : ℝ) - 1) - ((k : ℝ) - 2) * ((k : ℝ) - 3))
            - ((q : ℝ) ^ 2 - k) =
          (2 * a - 3) / 4 * s ^ 3
            + (a ^ 2 - 7 * a + 10) / 4 * s ^ 2
            + (-3 * a ^ 2 + 10 * a - 8) / 2 * s
            + (-a ^ 3 + 5 * a ^ 2 - 8 * a + 6) / 2 := by
      have hqeq : (q : ℝ) = s ^ 2 / 2 := by nlinarith [hsquare]
      rw [hqeq]
      dsimp [a]
      ring
    rw [hExpansion] at hD
    have hspos : 0 < s := lt_of_lt_of_le (by norm_num) hsge
    have haLower : 3 / 2 - 8 / s ≤ a := by
      have hs3pos : 0 < s ^ 3 := pow_pos hspos 3
      apply (le_of_mul_le_mul_right _ hs3pos)
      field_simp
      nlinarith
    dsimp [a, s] at haLower ⊢
    linarith

section FiniteField

open scoped LinearAlgebra.Projectivization

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance instFintypePoint : Fintype (Point K) :=
  Fintype.ofFinite (Point K)

noncomputable local instance instDecidableEqPoint : DecidableEq (Point K) :=
  Classical.decEq (Point K)

private theorem rhoC_data :
    L2Admissible (Fintype.card K) (rhoC (K := K)) ∧
      rhoC (K := K) ≤ Fintype.card K ^ 2 := by
  obtain ⟨A, hcomplete, hcard⟩ :=
    exists_completeOutside_card_eq_rho (L := Point K) (standardConic (K := K))
  have hcard' : A.card = rhoC (K := K) := by
    rw [rhoC]
    exact hcard
  have horder : PlaneOrder (Point K) (Point K) = Fintype.card K :=
    ProjectiveBridge.planeOrder_eq_card
  have hC : (standardConic (K := K)).card = PlaneOrder (Point K) (Point K) + 1 := by
    rw [horder, standardConic_card]
  have hge := completeOutside_card_ge_three_of_card_holes
    (P := Point K) (L := Point K) hcomplete hC
  have hcap := corrected_capacity_bound_of_card_holes
    (P := Point K) (L := Point K) hcomplete hC
  rw [horder] at hcap
  have hadm : L2Admissible (Fintype.card K) A.card := ⟨hge, hcap⟩
  have hunion : A.card + (standardConic (K := K)).card =
      (A ∪ standardConic (K := K)).card :=
    (Finset.card_union_of_disjoint hcomplete.2.1).symm
  have hle := Finset.card_le_univ (A ∪ standardConic (K := K))
  rw [← hunion, standardConic_card] at hle
  have hplane := RelativeConicArcs.card_points (P := Point K) (L := Point K)
  rw [horder] at hplane
  rw [hplane] at hle
  rw [hcard'] at hadm hle
  exact ⟨hadm, by omega⟩

/-- Quantified additive lower bound for every realized finite-field order. -/
theorem rhoC_explicit_additive_lower_bound :
    Real.sqrt (2 * Fintype.card K) + 3 / 2 -
        8 / Real.sqrt (2 * Fintype.card K) ≤ (rhoC (K := K) : ℝ) := by
  have hq : 2 ≤ Fintype.card K := by
    rw [← Nat.card_eq_fintype_card]
    have := Finite.one_lt_card (α := K)
    omega
  exact explicit_additive_lower_bound hq rhoC_data.2 rhoC_data.1

end FiniteField

section Packaging

open Filter Asymptotics

variable {I : Type*}

/-- The positive shortfall below the claimed main term. -/
noncomputable def additiveShortfall (q : I → ℕ) (r : I → ℝ) (i : I) : ℝ :=
  max 0 (Real.sqrt (2 * q i) + 3 / 2 - r i)

/-- The exact inverse-square-root scale used by the explicit estimate. -/
noncomputable def inverseSqrtScale (q : I → ℕ) (i : I) : ℝ :=
  1 / Real.sqrt (2 * q i)

/-- Big-O packaging of the quantified estimate. -/
theorem additiveShortfall_isBigO (q : I → ℕ) (r : I → ℝ)
    (hq : ∀ i, 2 ≤ q i)
    (hbound : ∀ i, Real.sqrt (2 * q i) + 3 / 2 -
      8 / Real.sqrt (2 * q i) ≤ r i) (l : Filter I) :
    (additiveShortfall q r) =O[l] (inverseSqrtScale q) := by
  apply (IsBigOWith.of_bound (c := 8) (Filter.Eventually.of_forall ?_)).isBigO
  intro i
  have hsnonneg : 0 ≤ Real.sqrt (2 * q i) := Real.sqrt_nonneg _
  have hqi := hq i
  have hqreal : (0 : ℝ) < q i := by exact_mod_cast (by omega : 0 < q i)
  have hspos : 0 < Real.sqrt (2 * q i) := Real.sqrt_pos.2 (by positivity)
  have hscale : 0 ≤ inverseSqrtScale q i := by
    dsimp [inverseSqrtScale]
    positivity
  have hshort : additiveShortfall q r i ≤ 8 * inverseSqrtScale q i := by
    have hdiff : Real.sqrt (2 * q i) + 3 / 2 - r i ≤
        8 / Real.sqrt (2 * q i) := by linarith [hbound i]
    rw [additiveShortfall]
    apply max_le (mul_nonneg (by norm_num) hscale)
    simpa [inverseSqrtScale, div_eq_mul_inv] using hdiff
  rw [Real.norm_eq_abs, Real.norm_eq_abs,
    abs_of_nonneg (le_max_left 0 _), abs_of_nonneg hscale]
  exact hshort

/-- Unconditional operational form of the liminf bound: every value below `3/2` is eventually a
lower bound for the centered parameter.  This also covers families whose centered values diverge
to `+∞`, which a real-valued `Filter.liminf` cannot directly represent. -/
theorem eventually_lt_centered (q : I → ℕ) (r : I → ℝ) (l : Filter I)
    (hq_top : Tendsto q l atTop)
    (hbound : ∀ i, Real.sqrt (2 * q i) + 3 / 2 -
      8 / Real.sqrt (2 * q i) ≤ r i) {b : ℝ} (hb : b < 3 / 2) :
    ∀ᶠ i in l, b < r i - Real.sqrt (2 * q i) := by
  have hcast : Tendsto (fun i => (q i : ℝ)) l atTop :=
    tendsto_natCast_atTop_atTop.comp hq_top
  have htwo : Tendsto (fun i => (2 : ℝ) * q i) l atTop :=
    hcast.const_mul_atTop (by norm_num)
  have hsqrt : Tendsto (fun i => Real.sqrt (2 * q i)) l atTop :=
    Real.tendsto_sqrt_atTop.comp htwo
  have herr : Tendsto (fun i => 8 / Real.sqrt (2 * q i)) l (nhds 0) := by
    simpa using tendsto_const_nhds.div_atTop hsqrt
  have heps : 0 < (3 : ℝ) / 2 - b := by linarith
  have hev : ∀ᶠ i in l, 8 / Real.sqrt (2 * q i) < (3 : ℝ) / 2 - b :=
    (tendsto_order.1 herr).2 _ heps
  filter_upwards [hev] with i hi
  have := hbound i
  linarith

/-- Liminf consequence along any unbounded family of realized orders. -/
theorem three_halves_le_liminf (q : I → ℕ) (r : I → ℝ) (l : Filter I) [NeBot l]
    (hq : ∀ i, 2 ≤ q i)
    (hq_top : Tendsto q l atTop)
    (hbound : ∀ i, Real.sqrt (2 * q i) + 3 / 2 -
      8 / Real.sqrt (2 * q i) ≤ r i)
    (hcob : l.IsCoboundedUnder (fun x y : ℝ => x ≥ y)
      (fun i => r i - Real.sqrt (2 * q i))) :
    (3 : ℝ) / 2 ≤ liminf (fun i => r i - Real.sqrt (2 * q i)) l := by
  have hbelow : l.IsBoundedUnder (fun x y : ℝ => x ≥ y)
      (fun i => r i - Real.sqrt (2 * q i)) := by
    apply isBoundedUnder_of_eventually_ge
    show ∀ᶠ i in l, (-3 : ℝ) ≤ r i - Real.sqrt (2 * q i)
    apply Filter.Eventually.of_forall
    intro i
    have hqreal : (2 : ℝ) ≤ q i := by exact_mod_cast hq i
    have hsnonneg : 0 ≤ Real.sqrt (2 * q i) := Real.sqrt_nonneg _
    have hsq : Real.sqrt (2 * q i) ^ 2 = (2 : ℝ) * q i :=
      Real.sq_sqrt (by positivity)
    have hsge : 2 ≤ Real.sqrt (2 * q i) := by nlinarith
    have hspos : 0 < Real.sqrt (2 * q i) := lt_of_lt_of_le (by norm_num) hsge
    have herrle : 8 / Real.sqrt (2 * q i) ≤ 4 := by
      apply (div_le_iff₀ hspos).2
      nlinarith
    have := hbound i
    linarith
  apply (le_liminf_iff hcob hbelow).2
  intro b hb
  exact eventually_lt_centered q r l hq_top hbound hb

end Packaging

section RealizedFamilies

open Filter Asymptotics

variable {I : Type*} (K : I → Type*)
  [∀ i, Field (K i)] [∀ i, Fintype (K i)] [∀ i, DecidableEq (K i)]

/-- Orders in an indexed family of actual finite fields. -/
def realizedOrder (i : I) : ℕ := Fintype.card (K i)

/-- Relative conic parameters in an indexed family of actual finite fields. -/
noncomputable def realizedRhoC (i : I) : ℝ := rhoC (K := K i)

omit [(i : I) → DecidableEq (K i)] in
theorem realizedOrder_two_le (i : I) : 2 ≤ realizedOrder K i := by
  rw [realizedOrder, ← Nat.card_eq_fintype_card]
  have := Finite.one_lt_card (α := K i)
  omega

theorem realizedRhoC_explicit (i : I) :
    Real.sqrt (2 * realizedOrder K i) + 3 / 2 -
        8 / Real.sqrt (2 * realizedOrder K i) ≤ realizedRhoC K i := by
  exact rhoC_explicit_additive_lower_bound (K := K i)

theorem realizedShortfall_isBigO (l : Filter I) :
    additiveShortfall (realizedOrder K) (realizedRhoC K) =O[l]
      inverseSqrtScale (realizedOrder K) :=
  additiveShortfall_isBigO _ _ (realizedOrder_two_le K) (realizedRhoC_explicit K) l

/-- Liminf statement along any unbounded indexed family of realized finite-field orders. -/
theorem realized_three_halves_le_liminf (l : Filter I) [NeBot l]
    (horder : Tendsto (realizedOrder K) l atTop)
    (hcob : l.IsCoboundedUnder (fun x y : ℝ => x ≥ y)
      (fun i => realizedRhoC K i - Real.sqrt (2 * realizedOrder K i))) :
    (3 : ℝ) / 2 ≤
      liminf (fun i => realizedRhoC K i - Real.sqrt (2 * realizedOrder K i)) l :=
  three_halves_le_liminf _ _ l (realizedOrder_two_le K) horder
    (realizedRhoC_explicit K) hcob

end RealizedFamilies

end Conic
end RelativeConicArcs
