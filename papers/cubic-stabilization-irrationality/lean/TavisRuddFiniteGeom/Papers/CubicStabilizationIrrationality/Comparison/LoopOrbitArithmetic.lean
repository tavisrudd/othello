import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoLayerDescentPacket
import Mathlib.Algebra.Group.Action.Prod
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-!
# Loop-orbit arithmetic for two-index correction ledgers

A blow-up along a smooth centre of codimension \(r\) contributes \(r-1\)
centre factors to the quantum differential module of the blow-up
(Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3,
Theorem 5.18).  A marked point of such a correction ledger therefore carries
two indices: an internal index, on which a loop acts through the centre's own
spectral monodromy, and a Kummer index, on which the same loop acts through
the roots of unity of the exceptional direction.  This module records the
elementary arithmetic of one loop acting diagonally on such a pair.

The results are set-level statements about one group element acting on a
product of two sets:

* the power-fixedness period of a pair is the least common multiple of the
  periods of its coordinates;
* a period is determined by its fixedness fingerprint, so periods of
  equivariantly identified points agree;
* when the pair period is a prime \(\ell\) and the Kummer period is not
  \(\ell\), the internal period is exactly \(\ell\);
* the only solutions in natural numbers of \((k+1)(m-k-1)=m+1\) are
  \(m=5\) with \(k\in\{1,2\}\).

A final section records the arithmetic of a ramification computed in stages.
The cycle length of a branch of a spectral cover over a punctured disc is the
product of the rotation orders of the successive Newton--Puiseux stages.  If
every stage order is a product of twos and threes, then so is the cycle
length, and no prime at least five divides it.  The section also records the
dimension count for a block that factors as a marked part and a rotating part.

The count statement below is the comparison between the \(m+1\) marked sheets
of a product with \(\mathbf P^m\) and the \((k+1)(r-1)\) marked sheets
contributed by a centre of the form (marked threefold) \(\times\mathbf P^k\)
of codimension \(r=m-k\) in an \((m+3)\)-fold.  It shows that sheet counts
alone cannot separate the two ledgers when \(m=5\).

Nothing here constructs a loop action on a quantum differential module,
identifies the internal and Kummer actions, or shows that a blow-up
comparison is equivariant.  Those remain hypotheses of any consumer.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LoopOrbitArithmetic

open TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoLayerDescentPacket

section Periods

variable {G : Type*} [Group G] {A B : Type*} [MulAction G A] [MulAction G B]

/-- Under the diagonal action of one group element on a pair, the powers fixing
the pair are exactly the common multiples of the coordinate periods, so the
pair has period `Nat.lcm p s`. -/
theorem hasPowerFixednessPeriod_prod
    (generator : G) {p s : ℕ} {x : A} {y : B}
    (hx : HasPowerFixednessPeriod G generator p x)
    (hy : HasPowerFixednessPeriod G generator s y) :
    HasPowerFixednessPeriod G generator (Nat.lcm p s) (x, y) := by
  intro k
  rw [Prod.smul_mk, Prod.mk.injEq, hx k, hy k, Nat.lcm_dvd_iff]

/-- A point has at most one power-fixedness period. -/
theorem period_eq_of_hasPowerFixednessPeriod
    (generator : G) {p p' : ℕ} {x : A}
    (hp : HasPowerFixednessPeriod G generator p x)
    (hp' : HasPowerFixednessPeriod G generator p' x) :
    p = p' := by
  have forward : p' ∣ p := (hp' p).mp ((hp p).mpr dvd_rfl)
  have backward : p ∣ p' := (hp p').mp ((hp' p').mpr dvd_rfl)
  exact Nat.dvd_antisymm backward forward

/-- If a least common multiple equals a prime `ℓ` and the second argument is
not `ℓ`, then the first argument is `ℓ`. -/
theorem left_eq_prime_of_lcm_eq_prime
    {p s ℓ : ℕ} (prime : ℓ.Prime) (lcm_eq : Nat.lcm p s = ℓ) (s_ne : s ≠ ℓ) :
    p = ℓ := by
  have p_dvd : p ∣ ℓ := lcm_eq ▸ Nat.dvd_lcm_left p s
  have s_dvd : s ∣ ℓ := lcm_eq ▸ Nat.dvd_lcm_right p s
  rcases (Nat.dvd_prime prime).mp s_dvd with s_one | s_eq
  · rcases (Nat.dvd_prime prime).mp p_dvd with p_one | p_eq
    · subst s_one; subst p_one
      exact absurd lcm_eq.symm prime.one_lt.ne'
    · exact p_eq
  · exact absurd s_eq s_ne

/-- Prime-period exclusion for a two-index ledger point.  If the pair has
prime period `ℓ` under a loop and its Kummer coordinate has a period other
than `ℓ`, then its internal coordinate has period exactly `ℓ`. -/
theorem internal_period_eq_prime_of_pair_period_prime
    (generator : G) {p s ℓ : ℕ} {x : A} {y : B}
    (prime : ℓ.Prime)
    (hx : HasPowerFixednessPeriod G generator p x)
    (hy : HasPowerFixednessPeriod G generator s y)
    (hxy : HasPowerFixednessPeriod G generator ℓ (x, y))
    (s_ne : s ≠ ℓ) :
    p = ℓ :=
  left_eq_prime_of_lcm_eq_prime prime
    (period_eq_of_hasPowerFixednessPeriod generator
      (hasPowerFixednessPeriod_prod generator hx hy) hxy) s_ne

end Periods

section SheetCounts

/-- The natural-number solutions of `a * b = a + b + 1` are `(2, 3)` and
`(3, 2)`: the equation is `(a - 1) * (b - 1) = 2`. -/
theorem mul_eq_add_add_one_iff (a b : ℕ) :
    a * b = a + b + 1 ↔ (a = 2 ∧ b = 3) ∨ (a = 3 ∧ b = 2) := by
  constructor
  · intro h
    have a_ge : 2 ≤ a := by
      by_contra lt
      interval_cases a <;> omega
    have b_ge : 2 ≤ b := by
      by_contra lt
      interval_cases b <;> omega
    obtain ⟨a', rfl⟩ : ∃ a', a = a' + 2 := ⟨a - 2, by omega⟩
    obtain ⟨b', rfl⟩ : ∃ b', b = b' + 2 := ⟨b - 2, by omega⟩
    have reduced : a' * b' + a' + b' = 1 := by nlinarith
    have a'_le : a' ≤ 1 := by nlinarith
    have b'_le : b' ≤ 1 := by nlinarith
    interval_cases a' <;> interval_cases b' <;> omega
  · rintro (⟨rfl, rfl⟩ | ⟨rfl, rfl⟩) <;> norm_num

/-- Sheet-count coincidence.  For a centre of the form (marked threefold)
\(\times\mathbf P^k\) inside an \((m+3)\)-fold, the centre contributes
\((k+1)(m-k-1)\) marked sheets, while the product with \(\mathbf P^m\) has
\(m+1\).  Under the dimension bound `k + 2 ≤ m` the counts agree exactly when
`m = 5` and `k ∈ {1, 2}`. -/
theorem centre_sheet_count_eq_source_iff {m k : ℕ} (bound : k + 2 ≤ m) :
    (k + 1) * (m - k - 1) = m + 1 ↔ m = 5 ∧ (k = 1 ∨ k = 2) := by
  obtain ⟨b, rfl⟩ : ∃ b, m = k + 1 + b := ⟨m - k - 1, by omega⟩
  have sub_eq : k + 1 + b - k - 1 = b := by omega
  rw [sub_eq, mul_eq_add_add_one_iff]
  omega

end SheetCounts

section StageOrders

/-- A natural number is *three-smooth* when every prime dividing it is at most
three, equivalently when it is a product of twos and threes. -/
def ThreeSmooth (n : ℕ) : Prop :=
  ∀ p : ℕ, p.Prime → p ∣ n → p ≤ 3

theorem threeSmooth_one : ThreeSmooth 1 := by
  intro p prime dvd
  exact absurd (Nat.eq_one_of_dvd_one dvd) prime.ne_one

theorem threeSmooth_mul {a b : ℕ} (ha : ThreeSmooth a) (hb : ThreeSmooth b) :
    ThreeSmooth (a * b) := by
  intro p prime dvd
  rcases (Nat.Prime.dvd_mul prime).mp dvd with h | h
  · exact ha p prime h
  · exact hb p prime h

/-- A product of three-smooth stage orders is three-smooth. -/
theorem threeSmooth_prod {ι : Type*} (s : List ι) (order : ι → ℕ)
    (smooth : ∀ i ∈ s, ThreeSmooth (order i)) :
    ThreeSmooth ((s.map order).prod) := by
  induction s with
  | nil => simpa using threeSmooth_one
  | cons i t ih =>
      simp only [List.map_cons, List.prod_cons]
      exact threeSmooth_mul (smooth i (by simp))
        (ih fun j hj => smooth j (by simp [hj]))

/-- No prime at least five divides a three-smooth number. -/
theorem not_dvd_of_threeSmooth {n ℓ : ℕ} (smooth : ThreeSmooth n)
    (prime : ℓ.Prime) (large : 5 ≤ ℓ) : ¬ ℓ ∣ n := by
  intro dvd
  exact absurd (smooth ℓ prime dvd) (by omega)

/-- Stage exclusion.  A cycle length assembled as the product of stage
rotation orders, each of them three-smooth, is not divisible by any prime at
least five.  This is the arithmetic skeleton of a ramification argument that
bounds each Newton--Puiseux stage separately. -/
theorem prime_not_dvd_cycleLength_of_stages_threeSmooth
    {ι : Type*} (stages : List ι) (order : ι → ℕ) {ℓ : ℕ}
    (smooth : ∀ i ∈ stages, ThreeSmooth (order i))
    (prime : ℓ.Prime) (large : 5 ≤ ℓ) :
    ¬ ℓ ∣ (stages.map order).prod :=
  not_dvd_of_threeSmooth (threeSmooth_prod stages order smooth) prime large

/-- Dimension count for a block that factors as a marked part and a rotating
part.  If the marked factor has dimension at least three and the rotating
factor has index `ℓ`, hence by the Kobayashi--Ochiai bound dimension at least
`ℓ - 1`, the ambient dimension is at least `ℓ + 2`.  Both hypotheses are
supplied by geometry; only the count is checked here. -/
theorem dimension_ge_of_marked_times_rotating
    {markedDim rotatingDim ℓ : ℕ}
    (marked : 3 ≤ markedDim) (rotating : ℓ - 1 ≤ rotatingDim)
    (nontrivial : 1 ≤ ℓ) :
    ℓ + 2 ≤ markedDim + rotatingDim := by
  omega

end StageOrders

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LoopOrbitArithmetic
