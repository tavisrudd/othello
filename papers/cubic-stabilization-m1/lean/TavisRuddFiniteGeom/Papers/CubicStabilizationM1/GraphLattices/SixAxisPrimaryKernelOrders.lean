import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisTwoPrimaryLatticeComparison
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisThreePrimaryLatticeComparison

/-!
# The orders of the primary parts of the isogeny-kernel lattice model

The discriminant group of the six-axis source polarization is annihilated by
six and splits as the direct sum of its two- and three-primary parts, of orders
`2⁸` and `3⁸`.  For an integral comparison matrix pulling a unimodular
alternating form back to that polarization, the lattice model of the kernel is a
subgroup of order `6⁴` which splits along the same decomposition.

Results.  The two primary parts of that kernel have orders `2⁴` and `3⁴`.  The
argument is elementary: an internal direct sum of two submodules has order the
product of their orders, each primary part of the kernel sits inside the
corresponding primary part of the discriminant group, and Lagrange's theorem
then forces the two prime-power factors of `6⁴` to be distributed one to each
part.  The maximal isotropy of each primary part, proved separately, is not used
here, and nothing here replaces it.

Trust boundary.  Every statement is about explicit integral matrices and finite
abelian groups.  No abelian scheme, elliptic scheme, isogeny, Weil pairing, or
geometric commutator pairing is constructed, so these are the orders of the
primary parts of a lattice model; their identification with the orders of the
primary parts of the kernel of a relative isogeny is supplied elsewhere.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped Matrix

section InternalSum

variable {R M : Type*} [Ring R] [AddCommGroup M] [Module R M]

/-- Two submodules meeting only in zero add without collision: the order of
their join is the product of their orders. -/
theorem natCard_sup_of_inf_eq_bot {first second : Submodule R M}
    (trivialIntersection : first ⊓ second = ⊥) :
    Nat.card (first ⊔ second : Submodule R M) =
      Nat.card first * Nat.card second := by
  classical
  have bijective : Function.Bijective
      (fun pair : first × second ↦
        (⟨(pair.1 : M) + (pair.2 : M),
            Submodule.add_mem_sup pair.1.property pair.2.property⟩ :
          (first ⊔ second : Submodule R M))) := by
    constructor
    · rintro ⟨⟨left, leftMember⟩, ⟨right, rightMember⟩⟩
        ⟨⟨otherLeft, otherLeftMember⟩, ⟨otherRight, otherRightMember⟩⟩ equality
      have sumEquality : left + right = otherLeft + otherRight :=
        congrArg Subtype.val equality
      have difference : left - otherLeft = otherRight - right := by
        rw [sub_eq_sub_iff_add_eq_add, sumEquality, add_comm]
      have inFirst : left - otherLeft ∈ first :=
        Submodule.sub_mem _ leftMember otherLeftMember
      have inSecond : left - otherLeft ∈ second := by
        rw [difference]
        exact Submodule.sub_mem _ otherRightMember rightMember
      have vanishes : left - otherLeft = 0 := by
        have membership : left - otherLeft ∈ first ⊓ second :=
          Submodule.mem_inf.mpr ⟨inFirst, inSecond⟩
        rw [trivialIntersection] at membership
        simpa using membership
      have leftEquality : left = otherLeft := sub_eq_zero.mp vanishes
      have rightEquality : right = otherRight := by
        rw [leftEquality] at sumEquality
        exact add_left_cancel sumEquality
      simp [leftEquality, rightEquality]
    · rintro ⟨element, member⟩
      obtain ⟨left, leftMember, right, rightMember, rfl⟩ :=
        Submodule.mem_sup.mp member
      exact ⟨(⟨left, leftMember⟩, ⟨right, rightMember⟩), rfl⟩
  rw [← Nat.card_congr (Equiv.ofBijective _ bijective), Nat.card_prod]

end InternalSum

section Comparison

variable {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}

/-- The order of the lattice model of the isogeny kernel is the product of the
orders of its two primary parts. -/
theorem natCard_sixAxisSourceKernelSubgroup_eq_mul
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Nat.card (comparisonKernelSubgroup pullback) =
      Nat.card (sixAxisSourcePrimaryKernelSubgroup pullback 2) *
        Nat.card (sixAxisSourcePrimaryKernelSubgroup pullback 3) := by
  obtain ⟨decomposition, trivialIntersection⟩ :=
    sixAxisSourceKernelSubgroup_primaryDecomposition pullback
  rw [decomposition, natCard_sup_of_inf_eq_bot trivialIntersection]

/-- Each primary part of the lattice model of the isogeny kernel has order
dividing the order of the corresponding primary part of the discriminant
group. -/
theorem natCard_sixAxisSourcePrimaryKernelSubgroup_dvd
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (prime : ℤ) :
    Nat.card (sixAxisSourcePrimaryKernelSubgroup pullback prime) ∣
      Nat.card (sixAxisSourceDiscriminantPrimaryPart prime) := by
  have inclusion :
      (sixAxisSourcePrimaryKernelSubgroup pullback prime).toAddSubgroup ≤
        (sixAxisSourceDiscriminantPrimaryPart prime).toAddSubgroup := by
    intro element member
    exact (Submodule.mem_inf.mp member).2
  exact AddSubgroup.card_dvd_of_le inclusion

/-- The two- and three-primary parts of the lattice model of the isogeny kernel
have orders `2⁴` and `3⁴`.  This is the lattice-level form of the per-prime
kernel orders: the whole kernel has order `6⁴`, and that order is distributed as
one square root of each primary discriminant order. -/
theorem natCard_sixAxisSourcePrimaryKernelSubgroup (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Nat.card (sixAxisSourcePrimaryKernelSubgroup pullback 2) = 2 ^ 4 ∧
      Nat.card (sixAxisSourcePrimaryKernelSubgroup pullback 3) = 3 ^ 4 := by
  have twoDivides :
      Nat.card (sixAxisSourcePrimaryKernelSubgroup pullback 2) ∣ 2 ^ 8 := by
    have divisibility := natCard_sixAxisSourcePrimaryKernelSubgroup_dvd pullback 2
    rwa [natCard_sixAxisSourceDiscriminantPrimaryPart_two] at divisibility
  have threeDivides :
      Nat.card (sixAxisSourcePrimaryKernelSubgroup pullback 3) ∣ 3 ^ 8 := by
    have divisibility := natCard_sixAxisSourcePrimaryKernelSubgroup_dvd pullback 3
    rwa [natCard_sixAxisSourceDiscriminantPrimaryPart_three] at divisibility
  obtain ⟨twoExponent, twoBound, twoValue⟩ :=
    (Nat.dvd_prime_pow Nat.prime_two).mp twoDivides
  obtain ⟨threeExponent, threeBound, threeValue⟩ :=
    (Nat.dvd_prime_pow Nat.prime_three).mp threeDivides
  have product : 2 ^ twoExponent * 3 ^ threeExponent = 6 ^ 4 := by
    rw [← twoValue, ← threeValue,
      ← natCard_sixAxisSourceKernelSubgroup_eq_mul pullback]
    exact natCard_sixAxisSourceKernelSubgroup principal pullback
  have exponents : twoExponent = 4 ∧ threeExponent = 4 := by
    interval_cases twoExponent <;> interval_cases threeExponent <;>
      revert product <;> decide
  rw [twoValue, threeValue, exponents.1, exponents.2]
  exact ⟨rfl, rfl⟩

end Comparison

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
