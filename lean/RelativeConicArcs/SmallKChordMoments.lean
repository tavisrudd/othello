import RelativeConicArcs.ClebschChordDefect
import RelativeConicArcs.Moments

/-!
# Small-arc consequences of the first two chord moments

This file isolates the exact integer algebra behind the `k = 4, 5, 7` extensions of the
Clebsch chord-defect argument.  The geometric seam is explicit: `nᵢ` counts off-arc points on
exactly `i` chords, and the theorems consume the first moment, second moment, and off-arc
partition as hypotheses.  `Moments.first_secant_moment`, `Moments.second_secant_moment`, and the
maximum-index theorem supply the corresponding geometric ingredients; a later integration leaf
can package the index fibers into the `nᵢ` hypotheses without changing any arithmetic below.

All equations use `ℤ`, so small field orders never encounter truncated natural subtraction.
No classification or finite-field computation is hidden in the moment identities.  The only
finite arithmetic in the seven-arc candidate theorem excludes the four composite non-prime-powers
in the interval `10 ≤ q ≤ 15`.
-/

namespace RelativeConicArcs

namespace SmallKChordMoments

/-- Algebraic form of the first two chord moments when every off-arc point lies on at most three
chords.

Here `m` is the number of chords and `s` is the number of unordered pairs of endpoint-disjoint
chords.  In the projective application, `m = choose k 2` and `s = 3 * choose k 4`. -/
theorem uncovered_of_three_index_moments
    (q k m s n1 n2 n3 u : ℕ)
    (hfirst :
      (n1 : ℤ) + 2 * (n2 : ℤ) + 3 * (n3 : ℤ) =
        (m : ℤ) * ((q : ℤ) - 1))
    (hsecond : (n2 : ℤ) + 3 * (n3 : ℤ) = (s : ℤ))
    (hpartition :
      (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) + (n3 : ℤ) =
        (q : ℤ) ^ 2 + (q : ℤ) + 1 - (k : ℤ)) :
    (u : ℤ) =
      (q : ℤ) ^ 2 + (q : ℤ) + 1 - (k : ℤ) -
        (m : ℤ) * ((q : ℤ) - 1) + (s : ℤ) - (n3 : ℤ) := by
  linarith

/-- For a four-arc, the six chords have three endpoint-disjoint chord pairs and no triple
concurrence.  The uncovered cardinality is `(q - 2)(q - 3)`. -/
theorem fourArc_uncovered_of_moments
    (q n1 n2 u : ℕ)
    (hfirst : (n1 : ℤ) + 2 * (n2 : ℤ) = 6 * ((q : ℤ) - 1))
    (hsecond : (n2 : ℤ) = 3)
    (hpartition :
      (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) = (q : ℤ) ^ 2 + (q : ℤ) - 3) :
    (u : ℤ) = ((q : ℤ) - 2) * ((q : ℤ) - 3) := by
  nlinarith

/-- A prime-power plane in which the four-arc uncovered set has conic cardinality must have
order five.  (The other integer root is `q = 1`.) -/
theorem fourArc_conic_order_of_moments
    (q n1 n2 u : ℕ) (hq : IsPrimePow q)
    (hfirst : (n1 : ℤ) + 2 * (n2 : ℤ) = 6 * ((q : ℤ) - 1))
    (hsecond : (n2 : ℤ) = 3)
    (hpartition :
      (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) = (q : ℤ) ^ 2 + (q : ℤ) - 3)
    (hu : u = q + 1) :
    q = 5 := by
  have huncovered := fourArc_uncovered_of_moments q n1 n2 u hfirst hsecond hpartition
  subst u
  push_cast at huncovered
  have hproduct : ((q : ℤ) - 1) * ((q : ℤ) - 5) = 0 := by
    nlinarith
  rcases mul_eq_zero.mp hproduct with hq1 | hq5
  · have : q = 1 := by omega
    subst q
    exact False.elim ((by decide : ¬ IsPrimePow 1) hq)
  · omega

/-- For a five-arc, the ten chords have fifteen endpoint-disjoint chord pairs and no triple
concurrence. -/
theorem fiveArc_uncovered_of_moments
    (q n1 n2 u : ℕ)
    (hfirst : (n1 : ℤ) + 2 * (n2 : ℤ) = 10 * ((q : ℤ) - 1))
    (hsecond : (n2 : ℤ) = 15)
    (hpartition :
      (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) = (q : ℤ) ^ 2 + (q : ℤ) - 4) :
    (u : ℤ) = (q : ℤ) ^ 2 - 9 * (q : ℤ) + 21 := by
  linarith

/-- No integer plane order can make the five-arc uncovered cardinality equal `q + 1`.
Equivalently, the impossible equation is `q^2 - 10q + 20 = 0`. -/
theorem fiveArc_ne_conic_card_of_moments
    (q n1 n2 u : ℕ)
    (hfirst : (n1 : ℤ) + 2 * (n2 : ℤ) = 10 * ((q : ℤ) - 1))
    (hsecond : (n2 : ℤ) = 15)
    (hpartition :
      (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) = (q : ℤ) ^ 2 + (q : ℤ) - 4) :
    u ≠ q + 1 := by
  intro hu
  have huncovered := fiveArc_uncovered_of_moments q n1 n2 u hfirst hsecond hpartition
  subst u
  push_cast at huncovered
  have hq_le : q ≤ 10 := by
    by_contra hnot
    have hq11 : 11 ≤ q := by omega
    have hnonneg : 0 ≤ ((q : ℤ) - 10) * (q : ℤ) :=
      mul_nonneg (by omega) (by positivity)
    nlinarith
  interval_cases q <;> norm_num at huncovered

/-- Seven-arc chord moments.  There are `21` chords and `3 * choose 7 4 = 105`
endpoint-disjoint chord pairs. -/
theorem sevenArc_uncovered_of_moments
    (q n1 n2 n3 u : ℕ)
    (hfirst :
      (n1 : ℤ) + 2 * (n2 : ℤ) + 3 * (n3 : ℤ) = 21 * ((q : ℤ) - 1))
    (hsecond : (n2 : ℤ) + 3 * (n3 : ℤ) = 105)
    (hpartition :
      (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) + (n3 : ℤ) =
        (q : ℤ) ^ 2 + (q : ℤ) - 6) :
    (u : ℤ) = (q : ℤ) ^ 2 - 20 * (q : ℤ) + 120 - (n3 : ℤ) := by
  linarith

/-- If a seven-arc's uncovered set has conic cardinality, both chord moments force the complete
index spectrum. -/
theorem sevenArc_conic_spectrum_formulas_of_moments
    (q n1 n2 n3 u : ℕ)
    (hfirst :
      (n1 : ℤ) + 2 * (n2 : ℤ) + 3 * (n3 : ℤ) = 21 * ((q : ℤ) - 1))
    (hsecond : (n2 : ℤ) + 3 * (n3 : ℤ) = 105)
    (hpartition :
      (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) + (n3 : ℤ) =
        (q : ℤ) ^ 2 + (q : ℤ) - 6)
    (hu : u = q + 1) :
    (n3 : ℤ) = (q : ℤ) ^ 2 - 21 * (q : ℤ) + 119 ∧
      (n2 : ℤ) = 3 * (-(q : ℤ) ^ 2 + 21 * (q : ℤ) - 84) ∧
      (n1 : ℤ) = 3 * ((q : ℤ) ^ 2 - 14 * (q : ℤ) + 42) := by
  have huncovered := sevenArc_uncovered_of_moments q n1 n2 n3 u
    hfirst hsecond hpartition
  subst u
  push_cast at huncovered
  constructor
  · linarith
  constructor <;> nlinarith

/-- Nonnegativity of the forced seven-arc spectrum confines a prime-power order to `11` or `13`.

The argument first obtains `6 ≤ q ≤ 15` from `n2 ≥ 0`, then `q ≥ 10` from `n1 ≥ 0`, and finally
excludes the composite integers `10, 12, 14, 15`. -/
theorem sevenArc_primePower_candidates_of_spectrum
    (q n1 n2 n3 : ℕ) (hq : IsPrimePow q)
    (hn3 : (n3 : ℤ) = (q : ℤ) ^ 2 - 21 * (q : ℤ) + 119)
    (hn2 : (n2 : ℤ) = 3 * (-(q : ℤ) ^ 2 + 21 * (q : ℤ) - 84))
    (hn1 : (n1 : ℤ) = 3 * ((q : ℤ) ^ 2 - 14 * (q : ℤ) + 42)) :
    q = 11 ∨ q = 13 := by
  have hn2_nonneg : (0 : ℤ) ≤ (n2 : ℤ) := by positivity
  have hn1_nonneg : (0 : ℤ) ≤ (n1 : ℤ) := by positivity
  have hq6 : 6 ≤ q := by
    by_contra hnot
    have hq5 : q ≤ 5 := by omega
    interval_cases q <;> norm_num at hn2 <;> omega
  have hq15 : q ≤ 15 := by
    by_contra hnot
    have hq16 : 16 ≤ q := by omega
    have hproduct : 0 ≤ ((q : ℤ) - 16) * ((q : ℤ) - 5) :=
      mul_nonneg (by omega) (by omega)
    nlinarith
  have hq10 : 10 ≤ q := by
    by_contra hnot
    have hq9 : q ≤ 9 := by omega
    interval_cases q <;> norm_num at hn1 <;> omega
  have hne10 : q ≠ 10 := by
    rintro rfl
    exact (by decide : ¬ IsPrimePow 10) hq
  have hne12 : q ≠ 12 := by
    rintro rfl
    exact (by decide : ¬ IsPrimePow 12) hq
  have hne14 : q ≠ 14 := by
    rintro rfl
    exact (by decide : ¬ IsPrimePow 14) hq
  have hne15 : q ≠ 15 := by
    rintro rfl
    have h15 : ¬ IsPrimePow 15 := by
      apply (Nat.not_isPrimePow_iff_nontrivial_of_two_le (by norm_num)).2
      refine ⟨3, ?_, 5, ?_, by norm_num⟩
      · norm_num [Nat.mem_primeFactors]
      · norm_num [Nat.mem_primeFactors]
    exact h15 hq
  omega

/-- Complete seven-arc candidate spectra under the conic-cardinality hypothesis. -/
theorem sevenArc_primePower_spectra_of_moments
    (q n1 n2 n3 u : ℕ) (hq : IsPrimePow q)
    (hfirst :
      (n1 : ℤ) + 2 * (n2 : ℤ) + 3 * (n3 : ℤ) = 21 * ((q : ℤ) - 1))
    (hsecond : (n2 : ℤ) + 3 * (n3 : ℤ) = 105)
    (hpartition :
      (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) + (n3 : ℤ) =
        (q : ℤ) ^ 2 + (q : ℤ) - 6)
    (hu : u = q + 1) :
    (q = 11 ∧ n1 = 27 ∧ n2 = 78 ∧ n3 = 9) ∨
      (q = 13 ∧ n1 = 87 ∧ n2 = 60 ∧ n3 = 15) := by
  obtain ⟨hn3, hn2, hn1⟩ := sevenArc_conic_spectrum_formulas_of_moments
    q n1 n2 n3 u hfirst hsecond hpartition hu
  rcases sevenArc_primePower_candidates_of_spectrum q n1 n2 n3 hq hn3 hn2 hn1 with
    hq11 | hq13
  · left
    subst q
    norm_num at hn1 hn2 hn3
    omega
  · right
    subst q
    norm_num at hn1 hn2 hn3
    omega

#print axioms uncovered_of_three_index_moments
#print axioms fourArc_conic_order_of_moments
#print axioms fiveArc_ne_conic_card_of_moments
#print axioms sevenArc_conic_spectrum_formulas_of_moments
#print axioms sevenArc_primePower_candidates_of_spectrum
#print axioms sevenArc_primePower_spectra_of_moments

end SmallKChordMoments

end RelativeConicArcs
