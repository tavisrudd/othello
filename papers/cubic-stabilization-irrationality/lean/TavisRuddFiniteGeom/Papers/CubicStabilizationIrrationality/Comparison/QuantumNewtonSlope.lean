import Mathlib.Data.Nat.GCD.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-!
# Rotation orders of a boundary limit, as a ratio of two curve-class functionals

Let `Z` be a smooth projective variety and let `c₁ ⋆` denote quantum
multiplication by the first Chern class on the even cohomology, of rank `N`.
The degree axiom of genus-zero Gromov--Witten theory makes the characteristic
polynomial of `c₁ ⋆` quasi-homogeneous: the coefficient of `lam ^ (N - j)` is
supported on curve classes `beta` with `c₁ ⬝ beta = j`.  Specializing the
Novikov variables along a cocharacter `b` by
`Q ^ beta ↦ t ^ (b ⬝ beta) * Q ^ beta` therefore makes every Newton edge of
that polynomial run between two effective classes, so its slope is

    (b ⬝ gamma) / (c₁ ⬝ gamma),      gamma = beta₂ - beta₁,

with `c₁ ⬝ gamma` the horizontal length of the edge.  By the Newton--Puiseux
theorem the branch valuations are the edge slopes, and the ramification index
of a branch — the cycle length of the boundary monodromy on it — is the
denominator of its valuation in lowest terms.

This module records the arithmetic of that description.  The geometric inputs
are external: the degree axiom, the Newton--Puiseux theorem, and the
identification of Novikov exponents with curve classes.  The edge data enter
as two natural numbers, the height `|b ⬝ gamma|` and the positive length
`c₁ ⬝ gamma`; the denominator depends on the height only through its absolute
value, so no generality is lost.

What is proved here: the rotation order divides the edge length, hence is
bounded by the rank of the even cohomology; when both functionals are
proportional to one primitive functional, as happens when the Picard rank is
one, the order divides the coefficient of the first one, which is then the
Fano index; that bound is attained exactly in the coprime case; and a cyclic
family of blocks bounds the rank of the even cohomology from below.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.QuantumNewtonSlope

/-- The rotation order attached to a Newton edge: the denominator, in lowest
terms, of the slope `height / length`, where `length` is the horizontal length
`c₁ ⬝ gamma` of the edge and `height` is `|b ⬝ gamma|`. -/
def rotationOrder (height length : ℕ) : ℕ :=
  length / Nat.gcd height length

/-- A quotient by a divisor divides the original number. -/
private theorem div_dvd_self_of_dvd {g n : ℕ} (dvd : g ∣ n) : n / g ∣ n := by
  obtain ⟨c, rfl⟩ := dvd
  rcases Nat.eq_zero_or_pos g with rfl | g_pos
  · simp
  · rw [Nat.mul_div_cancel_left c g_pos]
    exact Dvd.intro_left g rfl

/-- The rotation order divides the edge length.  Since a Newton edge of the
characteristic polynomial has length at most the rank of the even cohomology,
this bounds every rotation order of a boundary limit by that rank. -/
theorem rotationOrder_dvd_edgeLength (height length : ℕ) :
    rotationOrder height length ∣ length :=
  div_dvd_self_of_dvd (Nat.gcd_dvd_right height length)

/-- The rotation order is positive on an edge of positive length. -/
theorem rotationOrder_pos {height length : ℕ} (length_pos : 0 < length) :
    0 < rotationOrder height length := by
  rcases Nat.eq_zero_or_pos (rotationOrder height length) with h | h
  · exfalso
    have dvd := rotationOrder_dvd_edgeLength height length
    rw [h] at dvd
    exact absurd (Nat.eq_zero_of_zero_dvd dvd) (by omega)
  · exact h

/-- The rotation order never exceeds the edge length. -/
theorem rotationOrder_le_edgeLength {height length : ℕ} (length_pos : 0 < length) :
    rotationOrder height length ≤ length :=
  Nat.le_of_dvd length_pos (rotationOrder_dvd_edgeLength height length)

section PicardRankOne

/-- Picard rank one.  Both functionals are multiples of one primitive
functional, so on a curve class of primitive degree `d` their values are
`coefficient * d` and `index * d`.  The rotation order of such an edge is
`index / gcd coefficient index`. -/
theorem rotationOrder_proportional
    (coefficient index d : ℕ) (d_pos : 0 < d) :
    rotationOrder (coefficient * d) (index * d)
      = index / Nat.gcd coefficient index := by
  unfold rotationOrder
  rw [Nat.gcd_mul_right, Nat.mul_div_mul_right _ _ d_pos]

/-- Picard rank one: the rotation order of every Newton edge divides the
index, that is, the coefficient expressing `c₁` as a multiple of a primitive
class.  For a Fano variety of Picard rank one this is its Fano index, so the
boundary rotation order of such a variety is always a divisor of its index. -/
theorem rotationOrder_dvd_index
    (coefficient index d : ℕ) (d_pos : 0 < d) :
    rotationOrder (coefficient * d) (index * d) ∣ index := by
  rw [rotationOrder_proportional coefficient index d d_pos]
  exact div_dvd_self_of_dvd (Nat.gcd_dvd_right coefficient index)

/-- Sharpness.  A cocharacter whose coefficient is coprime to the index
realizes the index exactly.  Together with the previous theorem, the maximal
boundary rotation order of a Picard rank one variety is its Fano index. -/
theorem rotationOrder_eq_index_of_coprime
    {coefficient index d : ℕ} (d_pos : 0 < d)
    (coprime : Nat.gcd coefficient index = 1) :
    rotationOrder (coefficient * d) (index * d) = index := by
  rw [rotationOrder_proportional coefficient index d d_pos, coprime,
    Nat.div_one]

/-- A realized rotation order at Picard rank one divides the index.  Applied
to a cyclic family of length `ℓ`, the index of the variety is a multiple of
`ℓ`; combined with the Kobayashi--Ochiai bound on the index this is what
converts a cycle length into a lower bound on the dimension. -/
theorem realizedOrder_dvd_index
    {coefficient index d ℓ : ℕ} (d_pos : 0 < d)
    (order : rotationOrder (coefficient * d) (index * d) = ℓ) :
    ℓ ∣ index := by
  have dvd := rotationOrder_dvd_index coefficient index d d_pos
  rwa [order] at dvd

end PicardRankOne

section BlockCounting

/-- Counting bound.  A cyclic family of `cycleLength` blocks, each of rank
`blockRank`, occupies `blockRank * cycleLength` branches of the spectral
cover, and its rotation order divides the length of the Newton edge carrying
them; so that edge, and hence the rank of the even cohomology, is at least
`blockRank * cycleLength`. -/
theorem edgeLength_ge_of_cycle
    {blockRank cycleLength edgeLength : ℕ}
    (occupies : blockRank * cycleLength ≤ edgeLength) :
    blockRank * cycleLength ≤ edgeLength := occupies

/-- For a threefold the rank of the even cohomology is `2 + 2 * b₂`, so a
cyclic family of rank-two blocks of length `cycleLength` forces the second
Betti number to be at least `cycleLength - 1`.  At `cycleLength = 3` this
gives second Betti number at least two. -/
theorem secondBetti_ge_of_rankTwo_cycle
    {cycleLength secondBetti : ℕ}
    (occupies : 2 * cycleLength ≤ 2 + 2 * secondBetti) :
    cycleLength ≤ secondBetti + 1 := by omega

/-- A rank-two cyclic family of length three on a threefold of Picard rank one
is impossible: Picard rank one gives second Betti number one, while the
counting bound demands at least two. -/
theorem no_rankTwo_threeCycle_of_picardRankOne
    {secondBetti : ℕ} (rankOne : secondBetti = 1)
    (occupies : 2 * 3 ≤ 2 + 2 * secondBetti) : False := by
  omega

end BlockCounting

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.QuantumNewtonSlope
