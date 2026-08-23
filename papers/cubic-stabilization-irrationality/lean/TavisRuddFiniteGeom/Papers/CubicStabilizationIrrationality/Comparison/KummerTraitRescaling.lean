import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedReesShadowCertificate

/-!
# Kummer-trait rescaling and lattice drift

Consider the effective family

`x^3 = q * h^(3k)`

and restrict it to the diagonal trait `q = h = r`.  The resulting cubic
equation is `x^3 = r^(3k+1)`.  Its sheet action still has exact period three,
because the exponent is congruent to one modulo three.  After identifying the
generic fibre with `u^3 = r` by

`u ↦ r^(-k) x`,  `epsilon ↦ r^(2k) e`,

the ordered basis `(1,u,u^2,epsilon,u*epsilon,u^2*epsilon)` acquires the
valuation vector `(0,-k,-2k,2k,k,0)`.  This vector fixes the unit and top
class and is self-dual for the Frobenius pairing, but it is unbounded as `k`
varies.

The results below check the arithmetic content of this family.  They do not
construct a quantum connection or identify a geometric occurrence.  In
particular, they show that exact cubic period, effectiveness, and self-duality
alone cannot imply a bounded affine-coweight domain.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.KummerTraitRescaling

/-- Indices of the ordered basis
`(1,u,u^2,epsilon,u*epsilon,u^2*epsilon)`. -/
abbrev Index := Fin 6

/-- The involution pairing complementary basis vectors. -/
def pairingPartner : Index → Index :=
  ![5, 4, 3, 2, 1, 0]

/-- Valuations of the generic basis change
`u ↦ r^(-k)x`, `epsilon ↦ r^(2k)e`. -/
def rescalingCoweight (k : ℤ) : Index → ℤ :=
  ![0, -k, -2 * k, 2 * k, k, 0]

/-- The rescaling fixes the unit and the Frobenius top class. -/
theorem rescalingCoweight_unit_top (k : ℤ) :
    rescalingCoweight k 0 = 0 ∧ rescalingCoweight k 5 = 0 := by
  simp [rescalingCoweight]

/-- Paired basis vectors receive opposite valuations. -/
theorem rescalingCoweight_selfDual (k : ℤ) (i : Index) :
    rescalingCoweight k (pairingPartner i) = -rescalingCoweight k i := by
  fin_cases i <;> simp [rescalingCoweight, pairingPartner]

/-- Distinct rescaling exponents give distinct coweights. -/
theorem rescalingCoweight_injective : Function.Injective rescalingCoweight := by
  intro left right equal
  have coordinate := congrFun equal (4 : Index)
  simpa [rescalingCoweight] using coordinate

/-- One positive coordinate of the self-dual coweight exceeds any prescribed
natural bound. -/
theorem exists_rescalingCoweight_coordinate_above (bound : ℕ) :
    ∃ k : ℕ, (bound : ℤ) < rescalingCoweight (k : ℤ) 4 := by
  refine ⟨bound + 1, ?_⟩
  simp [rescalingCoweight]

/-- Exponent of the cubic equation on the diagonal effective trait. -/
def liftedCubicCharge (k : ℕ) : ℕ :=
  3 * k + 1

/-- Every lifted charge is coprime to three. -/
theorem three_coprime_liftedCubicCharge (k : ℕ) :
    Nat.Coprime 3 (liftedCubicCharge k) := by
  simp [liftedCubicCharge, add_comm]

/-- Translation by `3k+1` on three sheets has the same fixed powers as
translation by one. -/
theorem liftedCubicCharge_fixedness (k power : ℕ) :
    3 ∣ power * liftedCubicCharge k ↔ 3 ∣ power :=
  (three_coprime_liftedCubicCharge k).dvd_mul_right

/-- The cyclic-translation period attached to every lifted charge is exactly
three. -/
theorem liftedCubicCharge_reducedPeriod (k : ℕ) :
    3 / Nat.gcd 3 (liftedCubicCharge k) = 3 := by
  rw [three_coprime_liftedCubicCharge k]

/-- Exact cubic sheet action coexists with arbitrarily large self-dual lattice
drift.  This is the numerical obstruction to deriving a finite coweight bound
from the loop period and pairing alone. -/
theorem exists_exactCubicCharge_with_coweight_above (bound : ℕ) :
    ∃ k : ℕ,
      3 / Nat.gcd 3 (liftedCubicCharge k) = 3 ∧
        (bound : ℤ) < rescalingCoweight (k : ℤ) 4 ∧
        (∀ i : Index,
          rescalingCoweight (k : ℤ) (pairingPartner i) =
            -rescalingCoweight (k : ℤ) i) := by
  obtain ⟨k, above⟩ := exists_rescalingCoweight_coordinate_above bound
  exact ⟨k, liftedCubicCharge_reducedPeriod k, above,
    rescalingCoweight_selfDual (k : ℤ)⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.KummerTraitRescaling
