import DihedralSchreier.Density
import DihedralSchreier.DensityAxioms

/-!
# Theorem 12.1: relative density 1/2, conditional on prime equidistribution

This file closes the density-½ gap of the manuscript's Theorem 12.1
(`notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`, §12) **conditionally**: the
single classical analytic input — the prime number theorem for arithmetic progressions — is
quarantined as the one axiom `DensityAxioms.primes_equidistribute`, and the density value is
kernel-derived from that axiom together with the finite classification already formalized in
`DihedralSchreier/Density.lean` (`candidate_coprime`, `candidate_distinct`, `card_P_*`).

## The torus family and the P-classes

Fix `n ≥ 1`, a sign `s = ±1` (encoded `s^2 = 1`; split `s = +1`, nonsplit `s = -1`), and a
legal triple type with P-selection `Pset ⊆ ZMod 4` (`|Pset| = 2`, Corollary 9.1).  The prime
candidate is `q = 2·n·h + s`, and its P/N verdict depends only on `q mod 8n`, i.e. on
`h mod 4`.  The four values `h mod 4` give four **distinct** (`candidate_distinct`) **reduced**
(`candidate_coprime`) residue classes modulo `8n`; these four classes are the *torus family*
`familyR`, and the P-classes `PR` are exactly two of them (`card_P_*`).

## Relative density

`RelativeDensity num den d` says the counting ratio `num(x)/den(x)` tends to `d`.  With
`num = primeCountIn (8n) PR` (primes below `x` in a P-class) and
`den = primeCountIn (8n) familyR` (primes below `x` in the family), this is the natural density
of the P-primes **relative to the torus-family primes** — precisely the manuscript's relative
density.

## Headline

`relative_density_P_eq_half`, and its three triple-type corollaries
`relative_density_{dodd_nodd, dodd_neven, deven}`, prove this relative density equals `1/2`
(hence the N-classes' also equals `1/2`), for either sign `s = ±1`.  Each equidistribution
input contributes `1/φ(8n)` per reduced class; the shared `φ(8n)` cancels in the ratio
`2 classes / 4 classes = 1/2`, so the density value never requires computing `φ(8n)`.

The unconditional results in `Density.lean` are untouched and remain axiom-clean; only this
conditional layer carries `primes_equidistribute`.
-/

namespace DihedralSchreier
namespace DensityConditional

open Filter Density DensityAxioms

/-- Relative natural density `d` of the primes counted by `num` within the primes counted by
`den`: the ratio `num(x)/den(x)` converges to `d` as `x → ∞`.  Used with `num`/`den` counting
primes below `x` in a residue set, giving the density of the `num`-primes relative to the
`den`-primes. -/
def RelativeDensity (num den : ℕ → ℕ) (d : ℝ) : Prop :=
  Tendsto (fun x => (num x : ℝ) / (den x : ℝ)) atTop (nhds d)

open Classical in
/-- `π(x; m, R)` — the number of primes `p < x` whose residue `p mod m` lies in `R`. -/
noncomputable def primeCountIn (m : ℕ) (R : Finset (ZMod m)) (x : ℕ) : ℕ :=
  ((Finset.range x).filter (fun p : ℕ => p.Prime ∧ ((p : ZMod m) ∈ R))).card

/-- Counting over a residue set splits as the sum of the single-class counts: the classes are
disjoint (a prime has one residue) and cover the set. -/
lemma primeCountIn_eq_sum (m : ℕ) (R : Finset (ZMod m)) (x : ℕ) :
    primeCountIn m R x = ∑ a ∈ R, primeCountMod m a x := by
  classical
  simp only [primeCountIn, primeCountMod]
  rw [← Finset.card_biUnion]
  · congr 1
    ext p
    simp only [Finset.mem_biUnion, Finset.mem_filter, Finset.mem_range]
    constructor
    · rintro ⟨hlt, hp, hmem⟩
      exact ⟨(p : ZMod m), hmem, hlt, hp, rfl⟩
    · rintro ⟨a, ha, hlt, hp, rfl⟩
      exact ⟨hlt, hp, ha⟩
  · intro a _ b _ hab
    refine Finset.disjoint_left.mpr ?_
    intro p hpa hpb
    simp only [Finset.mem_filter] at hpa hpb
    exact hab (hpa.2.2.symm.trans hpb.2.2)

/-- `π(x) ≠ 0` for `x ≥ 3` (the prime `2` is counted). -/
lemma primeCount_ne_zero (x : ℕ) (hx : 3 ≤ x) : primeCount x ≠ 0 := by
  classical
  rw [primeCount, Finset.card_ne_zero]
  exact ⟨2, by rw [Finset.mem_filter, Finset.mem_range]; exact ⟨by omega, Nat.prime_two⟩⟩

section Family

variable (n : ℕ) (s : ℤ)

/-- The residue class mod `8n` of the candidate `q = 2·n·h + s`, as a function of `h mod 4`
(well defined because increasing `h` by `4` changes `q` by `8n ≡ 0`). -/
def cls (h : ZMod 4) : ZMod (8 * n) := ((2 * (n : ℤ) * (h.val : ℤ) + s : ℤ) : ZMod (8 * n))

/-- The torus family: the four reduced residue classes mod `8n` of `q = 2·n·h + s`. -/
def familyR : Finset (ZMod (8 * n)) := Finset.univ.image (cls n s)

/-- The P-classes of a triple type: the image of its P-selection `Pset ⊆ ZMod 4`. -/
def PR (Pset : Finset (ZMod 4)) : Finset (ZMod (8 * n)) := Pset.image (cls n s)

/-- `cls` is injective (the four classes are distinct) — consumes `candidate_distinct`. -/
lemma cls_injective (hn : 1 ≤ n) : Function.Injective (cls n s) := by
  intro h₁ h₂ heq
  by_contra hne
  haveI : NeZero (4 : ℕ) := ⟨by norm_num⟩
  have hv₁ : h₁.val < 4 := ZMod.val_lt h₁
  have hv₂ : h₂.val < 4 := ZMod.val_lt h₂
  haveI : NeZero (8 * n) := ⟨by omega⟩
  have hcast : (((2 * (n : ℤ) * (h₂.val : ℤ) + s) - (2 * (n : ℤ) * (h₁.val : ℤ) + s) : ℤ)
      : ZMod (8 * n)) = cls n s h₂ - cls n s h₁ := by
    unfold cls; push_cast; ring
  have hzero : (((2 * (n : ℤ) * (h₂.val : ℤ) + s) - (2 * (n : ℤ) * (h₁.val : ℤ) + s) : ℤ)
      : ZMod (8 * n)) = 0 := by rw [hcast, heq, sub_self]
  rw [ZMod.intCast_zmod_eq_zero_iff_dvd] at hzero
  have hcast2 : ((8 * n : ℕ) : ℤ) = 8 * (n : ℤ) := by push_cast; ring
  rw [hcast2] at hzero
  exact candidate_distinct n hn s h₁.val h₂.val hv₁ hv₂
    (fun hv => hne (ZMod.val_injective 4 hv)) hzero

/-- Each family class is a unit in `ZMod 8n` (reduced) — consumes `candidate_coprime`. -/
lemma cls_isUnit (_hn : 1 ≤ n) (hs : s ^ 2 = 1) (h : ZMod 4) : IsUnit (cls n s h) := by
  have hcop : IsCoprime (2 * (n : ℤ) * (h.val : ℤ) + s) (8 * (n : ℤ)) :=
    candidate_coprime n (h.val : ℤ) s hs
  have hmap := hcop.map (Int.castRingHom (ZMod (8 * n)))
  simp only [Int.coe_castRingHom] at hmap
  have hzero : ((8 * (n : ℤ) : ℤ) : ZMod (8 * n)) = 0 := by
    have hc : (8 * (n : ℤ)) = ((8 * n : ℕ) : ℤ) := by push_cast; ring
    rw [hc, Int.cast_natCast, ZMod.natCast_self]
  rw [hzero, isCoprime_zero_right] at hmap
  exact hmap

lemma familyR_isUnit (hn : 1 ≤ n) (hs : s ^ 2 = 1) :
    ∀ a ∈ familyR n s, IsUnit a := by
  intro a ha
  rw [familyR, Finset.mem_image] at ha
  obtain ⟨h, _, rfl⟩ := ha
  exact cls_isUnit n s hn hs h

lemma card_familyR (hn : 1 ≤ n) : (familyR n s).card = 4 := by
  rw [familyR, Finset.card_image_of_injective _ (cls_injective n s hn), Finset.card_univ]
  exact card_classes

lemma card_PR (hn : 1 ≤ n) (Pset : Finset (ZMod 4)) (hP : Pset.card = 2) :
    (PR n s Pset).card = 2 := by
  rw [PR, Finset.card_image_of_injective _ (cls_injective n s hn), hP]

lemma PR_subset_familyR (Pset : Finset (ZMod 4)) : PR n s Pset ⊆ familyR n s := by
  rw [PR, familyR]; exact Finset.image_subset_image (Finset.subset_univ _)

end Family

private lemma ratio_of_ratios (a b c : ℝ) (hc : c ≠ 0) :
    (a / c) / (b / c) = a / b := by
  rcases eq_or_ne b 0 with hb | hb
  · simp [hb]
  · field_simp

/-- Counting in any set `R` of reduced classes has relative density `|R|/φ(8n)` among all
primes: sum the per-class equidistribution axiom over `R`. -/
lemma tendsto_ratio (n : ℕ) (hn : 1 ≤ n) (R : Finset (ZMod (8 * n)))
    (hR : ∀ a ∈ R, IsUnit a) :
    Tendsto (fun x => (primeCountIn (8 * n) R x : ℝ) / (primeCount x : ℝ))
      atTop (nhds ((R.card : ℝ) * ((Nat.totient (8 * n) : ℝ))⁻¹)) := by
  have hsum : ∀ x, (primeCountIn (8 * n) R x : ℝ) / (primeCount x : ℝ)
      = ∑ a ∈ R, (primeCountMod (8 * n) a x : ℝ) / (primeCount x : ℝ) := by
    intro x
    rw [primeCountIn_eq_sum, Nat.cast_sum, Finset.sum_div]
  simp_rw [hsum]
  have key : Tendsto (fun x => ∑ a ∈ R, (primeCountMod (8 * n) a x : ℝ) / (primeCount x : ℝ))
      atTop (nhds (∑ _a ∈ R, ((Nat.totient (8 * n) : ℝ))⁻¹)) :=
    tendsto_finsetSum R (fun a ha => primes_equidistribute (8 * n) (by omega) a (hR a ha))
  rwa [Finset.sum_const, nsmul_eq_mul] at key

/-- **Theorem 12.1, conditional half-density.** For `n ≥ 1`, either sign `s = ±1`, and any
triple type with a 2-element P-selection `Pset ⊆ ZMod 4`, the P-candidate primes have density
`1/2` relative to the torus-family primes.  Conditional on `primes_equidistribute`; genuinely
consumes `candidate_coprime`, `candidate_distinct`, and `Pset.card = 2`. -/
theorem relative_density_P_eq_half (n : ℕ) (s : ℤ) (hn : 1 ≤ n) (hs : s ^ 2 = 1)
    (Pset : Finset (ZMod 4)) (hP : Pset.card = 2) :
    RelativeDensity (primeCountIn (8 * n) (PR n s Pset))
      (primeCountIn (8 * n) (familyR n s)) (1 / 2) := by
  unfold RelativeDensity
  have hφpos : (0 : ℝ) < (Nat.totient (8 * n) : ℝ) := by
    exact_mod_cast Nat.totient_pos.mpr (by omega : 0 < 8 * n)
  have hφ : ((Nat.totient (8 * n) : ℝ))⁻¹ ≠ 0 := inv_ne_zero (ne_of_gt hφpos)
  have hnum := tendsto_ratio n hn (PR n s Pset)
    (fun a ha => familyR_isUnit n s hn hs a (PR_subset_familyR n s Pset ha))
  have hden := tendsto_ratio n hn (familyR n s) (familyR_isUnit n s hn hs)
  have hden_ne : ((familyR n s).card : ℝ) * ((Nat.totient (8 * n) : ℝ))⁻¹ ≠ 0 := by
    rw [card_familyR n s hn]; exact mul_ne_zero (by norm_num) hφ
  have hcomb := hnum.div hden hden_ne
  have hval : ((PR n s Pset).card : ℝ) * ((Nat.totient (8 * n) : ℝ))⁻¹
      / (((familyR n s).card : ℝ) * ((Nat.totient (8 * n) : ℝ))⁻¹) = 1 / 2 := by
    rw [card_PR n s hn Pset hP, card_familyR n s hn,
      div_eq_iff (mul_ne_zero (by norm_num) hφ)]
    push_cast; ring
  rw [hval] at hcomb
  refine hcomb.congr' ?_
  filter_upwards [eventually_ge_atTop 3] with x hx
  have hpc : (primeCount x : ℝ) ≠ 0 := by exact_mod_cast primeCount_ne_zero x hx
  exact ratio_of_ratios _ _ _ hpc

/-! ### The three legal triple types, either sign -/

/-- `d` odd, `n` odd (`P = {1,2}`). -/
theorem relative_density_dodd_nodd (n : ℕ) (s : ℤ) (hn : 1 ≤ n) (hs : s ^ 2 = 1) :
    RelativeDensity (primeCountIn (8 * n) (PR n s P_dodd_nodd))
      (primeCountIn (8 * n) (familyR n s)) (1 / 2) :=
  relative_density_P_eq_half n s hn hs P_dodd_nodd card_P_dodd_nodd

/-- `d` odd, `n` even (`P = {2,3}`). -/
theorem relative_density_dodd_neven (n : ℕ) (s : ℤ) (hn : 1 ≤ n) (hs : s ^ 2 = 1) :
    RelativeDensity (primeCountIn (8 * n) (PR n s P_dodd_neven))
      (primeCountIn (8 * n) (familyR n s)) (1 / 2) :=
  relative_density_P_eq_half n s hn hs P_dodd_neven card_P_dodd_neven

/-- `d` even (`n` odd, `P = {0,2}`). -/
theorem relative_density_deven (n : ℕ) (s : ℤ) (hn : 1 ≤ n) (hs : s ^ 2 = 1) :
    RelativeDensity (primeCountIn (8 * n) (PR n s P_deven))
      (primeCountIn (8 * n) (familyR n s)) (1 / 2) :=
  relative_density_P_eq_half n s hn hs P_deven card_P_deven

#print axioms relative_density_dodd_nodd
#print axioms relative_density_dodd_neven
#print axioms relative_density_deven

end DensityConditional
end DihedralSchreier
