import Mathlib.Data.Nat.Prime.Basic
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.QuotientGroup.Basic

/-!
# Prime-denominator local-to-global membership

This module isolates the elementary abelian-group argument used when local
membership in an integral product lattice has already been converted into
denominator witnesses.  It deliberately does not construct those witnesses
from geometry or identify them with a particular localization API.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

variable {A : Type*} [AddCommGroup A]

/-- An element is a prime-denominator member of an additive subgroup at `p`
if some natural-number multiple with multiplier prime to `p` belongs to the
subgroup. -/
def PrimeDenominatorMember (P : AddSubgroup A) (x : A) (p : ℕ) : Prop :=
  ∃ n : ℕ, ¬p ∣ n ∧ n • x ∈ P

/-- Membership in an additive subgroup can be checked using denominator
witnesses prime to every prime.  This elementwise statement needs no finite
generation assumption. -/
theorem mem_of_primeDenominatorMember_all
    (P : AddSubgroup A) (x : A)
    (localMember : ∀ p : ℕ, p.Prime → PrimeDenominatorMember P x p) :
    x ∈ P := by
  let q : A ⧸ P := QuotientAddGroup.mk' P x
  obtain ⟨twoDenominator, twoPrimeTo, twoKills⟩ :=
    localMember 2 Nat.prime_two
  have twoDenominatorNeZero : twoDenominator ≠ 0 := by
    intro equality
    apply twoPrimeTo
    simp [equality]
  have qFinite : IsOfFinAddOrder q := by
    rw [isOfFinAddOrder_iff_nsmul_eq_zero]
    refine ⟨twoDenominator, Nat.pos_of_ne_zero twoDenominatorNeZero, ?_⟩
    change twoDenominator • QuotientAddGroup.mk' P x = 0
    rw [← map_nsmul]
    exact (QuotientAddGroup.eq_zero_iff (twoDenominator • x)).mpr twoKills
  have qOrderPositive : 0 < addOrderOf q := addOrderOf_pos_iff.mpr qFinite
  by_contra notMember
  have qNeZero : q ≠ 0 := by
    intro qZero
    apply notMember
    rw [← QuotientAddGroup.eq_zero_iff]
    exact qZero
  have qOrderNeOne : addOrderOf q ≠ 1 := by
    intro orderOne
    exact qNeZero (AddMonoid.addOrderOf_eq_one_iff.mp orderOne)
  obtain ⟨p, pPrime, pDividesOrder⟩ :=
    Nat.exists_prime_and_dvd qOrderNeOne
  obtain ⟨denominator, pPrimeTo, denominatorMember⟩ :=
    localMember p pPrime
  have denominatorKills : denominator • q = 0 := by
    change denominator • QuotientAddGroup.mk' P x = 0
    rw [← map_nsmul]
    exact (QuotientAddGroup.eq_zero_iff (denominator • x)).mpr denominatorMember
  have orderDividesDenominator : addOrderOf q ∣ denominator :=
    addOrderOf_dvd_iff_nsmul_eq_zero.mpr denominatorKills
  exact pPrimeTo (dvd_trans pDividesOrder orderDividesDenominator)

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
