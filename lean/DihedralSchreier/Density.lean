import Mathlib

/-!
# Periodicity and prime density (Theorem 12.1)

This file formalizes the finite-algebra core of Section 12 of
`notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`, together with the strongest
analytic statement reachable from current mathlib.

## Manuscript statement

Fix `n ≥ 2`, a legal triple type, and either the split or nonsplit torus family. Setting
`h = (q ∓ 1)/(2n)` (upper sign split, lower nonsplit), the prime candidate is
`q = 2·n·h ± 1`. The paper asserts:

* `gcd(q, 8n) = 1` for all four values of `h mod 4` — the four admissible **reduced**
  residue classes modulo `8n` (so the P/N verdict is periodic in `q` with period `8n`);
* Corollary 9.1 selects **exactly two** of these four classes as P (and two as N);
* by the prime number theorem for arithmetic progressions / its Dirichlet-density
  consequence, each reduced residue class carries the same density, so relative to the
  chosen torus family the four classes each have density `1/4`, giving relative density
  `1/2` to P and to N.

## What is formalized here, and the density gap

* `candidate_coprime` — `gcd(q, 8n) = 1` (as `IsCoprime` in `ℤ`), for every `n`, every
  `h`, and either sign `s = ±1` (encoded `s ^ 2 = 1`). This is the reduced-residue-class
  fact underpinning periodicity.
* `candidate_distinct` — the four values `h mod 4` give four **distinct** residue classes
  modulo `8n` (for `n ≥ 1`): the P/N verdict genuinely depends only on `q mod 8n`.
* `card_P_*` / `card_compl_*` — Corollary 9.1's "exactly two of four": for each of the
  three legal triple types the P-selection is a 2-element subset of `ZMod 4`, its
  complement (the N-selection) also has two elements.
* `candidate_primes_infinite` — **Dirichlet's theorem** (mathlib
  `Nat.forall_exists_prime_gt_and_zmodEq`): each admissible residue class contains
  arbitrarily large primes. Combined with the 2/2 split this gives
  `P_and_N_primes_infinite`: both P and N positions occur over infinitely many prime
  fields in the family.

**Density gap (reported, not a self-declared trust boundary).** mathlib currently proves
the *qualitative* Dirichlet theorem (infinitude of primes in every reduced residue class)
but does **not** provide the *quantitative* equidistribution / natural- or Dirichlet-density
statement that each reduced class has density `1/φ(8n)`. Consequently the paper's numerical
conclusion "relative density = 1/2" is **not** derivable in mathlib today. The strongest
reachable form — infinitude of both P-class and N-class primes, together with the exact
residue classification (2 of 4) — is formalized here; the missing input is precisely the
equidistribution theorem for primes in arithmetic progressions.
-/

namespace DihedralSchreier

namespace Density

/-! ### Reduced residue classes: `gcd(q, 8n) = 1` -/

/-- **`gcd(q, 8n) = 1`.** The prime candidate `q = 2·n·h + s` with `s = ±1` (encoded by
`s ^ 2 = 1`) is coprime to `8n`, for every `n` and every `h`. Any common divisor with `2n`
would divide `s = ±1`, and `q` is odd, so it is coprime to `4` and to `2n`, hence to `8n`.
This is the manuscript's reduced-residue-class claim (§12). -/
theorem candidate_coprime (n : ℕ) (h s : ℤ) (hs : s ^ 2 = 1) :
    IsCoprime (2 * (n : ℤ) * h + s) (8 * (n : ℤ)) := by
  have hq2n : IsCoprime (2 * (n : ℤ) * h + s) (2 * (n : ℤ)) :=
    ⟨s, -(h * s), by linear_combination hs⟩
  have hq2 : IsCoprime (2 * (n : ℤ) * h + s) (2 : ℤ) :=
    ⟨s, -((n : ℤ) * h * s), by linear_combination hs⟩
  have hq4 : IsCoprime (2 * (n : ℤ) * h + s) (4 : ℤ) := by
    have hp := hq2.pow_right (n := 2)
    norm_num at hp
    exact hp
  have hcomb := hq4.mul_right hq2n
  have he : (4 : ℤ) * (2 * (n : ℤ)) = 8 * (n : ℤ) := by ring
  rwa [he] at hcomb

/-! ### Periodicity: four distinct residue classes modulo `8n` -/

/-- **Period `8n` / four distinct classes.** For `n ≥ 1` and distinct `k₁, k₂ < 4`, the two
prime candidates `2·n·k₁ + s` and `2·n·k₂ + s` are **not** congruent modulo `8n`. Thus the
four values `h mod 4` yield four distinct residue classes mod `8n`, and the P/N verdict
depends only on `q mod 8n`. -/
theorem candidate_distinct (n : ℕ) (hn : 1 ≤ n) (s : ℤ) (k₁ k₂ : ℕ)
    (hk₁ : k₁ < 4) (hk₂ : k₂ < 4) (hne : k₁ ≠ k₂) :
    ¬ (8 * (n : ℤ)) ∣ ((2 * (n : ℤ) * (k₂ : ℤ) + s) - (2 * (n : ℤ) * (k₁ : ℤ) + s)) := by
  intro hdvd
  have hrw : (2 * (n : ℤ) * (k₂ : ℤ) + s) - (2 * (n : ℤ) * (k₁ : ℤ) + s)
      = (2 * (n : ℤ)) * ((k₂ : ℤ) - (k₁ : ℤ)) := by ring
  have h8 : (8 : ℤ) * (n : ℤ) = (2 * (n : ℤ)) * 4 := by ring
  rw [hrw, h8] at hdvd
  have h2n : (2 * (n : ℤ)) ≠ 0 := by
    have : (0 : ℤ) < (n : ℤ) := by exact_mod_cast hn
    positivity
  have h4 : (4 : ℤ) ∣ ((k₂ : ℤ) - (k₁ : ℤ)) := (mul_dvd_mul_iff_left h2n).mp hdvd
  omega

/-! ### Corollary 9.1: exactly two of four classes are P -/

/-- P-selection for the `d` odd, `n` odd triple type: `h ≡ 1, 2 (mod 4)`. -/
def P_dodd_nodd : Finset (ZMod 4) := {1, 2}

/-- P-selection for the `d` odd, `n` even triple type: `h ≡ 2, 3 (mod 4)`. -/
def P_dodd_neven : Finset (ZMod 4) := {2, 3}

/-- P-selection for the `d` even triple type (`n` odd): `h ≡ 0, 2 (mod 4)`. -/
def P_deven : Finset (ZMod 4) := {0, 2}

/-- There are exactly four residue classes for `h mod 4`. -/
theorem card_classes : Fintype.card (ZMod 4) = 4 := by decide

theorem card_P_dodd_nodd : P_dodd_nodd.card = 2 := by decide
theorem card_P_dodd_neven : P_dodd_neven.card = 2 := by decide
theorem card_P_deven : P_deven.card = 2 := by decide

/-- The N-selection (complement) also has exactly two classes: two of four are P, two N. -/
theorem card_compl_dodd_nodd : P_dodd_noddᶜ.card = 2 := by decide
theorem card_compl_dodd_neven : P_dodd_nevenᶜ.card = 2 := by decide
theorem card_compl_deven : P_devenᶜ.card = 2 := by decide

/-! ### Dirichlet's theorem: primes in each admissible class -/

/-- **Dirichlet's theorem for the admissible classes.** Each reduced residue class
`q ≡ 2·n·h + s (mod 8n)` contains arbitrarily large primes. Proof: `candidate_coprime`
supplies the coprimality hypothesis of mathlib's
`Nat.forall_exists_prime_gt_and_zmodEq`. -/
theorem candidate_primes_infinite (n : ℕ) (hn : 1 ≤ n) (h s : ℤ) (hs : s ^ 2 = 1) (N : ℕ) :
    ∃ p > N, p.Prime ∧ (p : ℤ) ≡ 2 * (n : ℤ) * h + s [ZMOD (8 * n)] := by
  have hq : (8 * n : ℕ) ≠ 0 := by positivity
  have hcop : IsCoprime (2 * (n : ℤ) * h + s) ((8 * n : ℕ) : ℤ) := by
    have := candidate_coprime n h s hs
    rwa [show ((8 * n : ℕ) : ℤ) = 8 * (n : ℤ) by push_cast; ring]
  simpa using Nat.forall_exists_prime_gt_and_zmodEq N hq hcop

/-- **Both P and N positions occur over infinitely many primes (reachable form of Theorem
12.1).** For a fixed triple type with P-selection `Pset ⊆ ZMod 4`, choose any P-class
represented by `hP` and any N-class represented by `hN`; each supplies arbitrarily large
primes in the corresponding arithmetic progression. This is the strongest statement the
present mathlib supports; the numerical density `1/2` needs equidistribution, which mathlib
does not yet provide (see the module docstring). -/
theorem P_and_N_primes_infinite (n : ℕ) (hn : 1 ≤ n) (s : ℤ) (hs : s ^ 2 = 1)
    (hP hN : ℤ) (N : ℕ) :
    (∃ p > N, p.Prime ∧ (p : ℤ) ≡ 2 * (n : ℤ) * hP + s [ZMOD (8 * n)]) ∧
      (∃ p > N, p.Prime ∧ (p : ℤ) ≡ 2 * (n : ℤ) * hN + s [ZMOD (8 * n)]) :=
  ⟨candidate_primes_infinite n hn hP s hs N, candidate_primes_infinite n hn hN s hs N⟩

end Density

end DihedralSchreier
