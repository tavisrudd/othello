import Mathlib.GroupTheory.Coset.Card
import Mathlib.GroupTheory.Perm.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Data.Fintype.Perm

/-!
# Excluding a faithful symmetric action on a classified automorphism group

The gluing argument for the six-axis packet rules out a rational two-primary
discriminant kernel by showing that such a kernel would make the symmetric group
on six letters act faithfully on a smooth complex cubic threefold.  That is
impossible because of the classification of faithful automorphism groups of
smooth complex cubic threefolds in M. Hartlieb, *Special subvarieties in the
locus of intermediate Jacobians of cubic threefolds*, Math. Z. 310 (2025),
article 52, arXiv:2304.03214v2, Theorem 2.1: five of the six groups listed there
have order smaller than the order of the symmetric group on six letters, and the
remaining one has order `9720`, which that order does not divide.

This module supplies the arithmetic of that exclusion.  Lean computes the order
of the symmetric group on six letters, and proves that a group admitting an
injective homomorphism from it has order divisible by `720`, so its order is
neither smaller than `720` nor equal to `9720`.  The classification itself
enters as an explicit hypothesis listing the possible orders; Lean neither
constructs cubic threefolds and their automorphism groups nor proves the
classification.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- The symmetric group on six letters has order `720`. -/
theorem symmetricSix_card : Nat.card (Equiv.Perm (Fin 6)) = 720 := by
  rw [Nat.card_eq_fintype_card, Fintype.card_perm, Fintype.card_fin]
  decide

/-- A group receiving an injective homomorphism from the symmetric group on six
letters has order divisible by `720`. -/
theorem card_dvd_of_faithful_symmetricSix {G : Type*} [Group G]
    (action : Equiv.Perm (Fin 6) →* G) (faithful : Function.Injective action) :
    720 ∣ Nat.card G := by
  have divides := Subgroup.card_dvd_of_injective action faithful
  rwa [symmetricSix_card] at divides

/-- No finite group whose order is smaller than `720`, and no group of order
`9720`, admits a faithful action of the symmetric group on six letters.  These
are exactly the two cases the classification of faithful automorphism groups of
smooth complex cubic threefolds leaves open. -/
theorem no_faithful_symmetricSix_of_classified_order {G : Type*} [Group G] [Finite G]
    (action : Equiv.Perm (Fin 6) →* G) (faithful : Function.Injective action)
    (classified : Nat.card G < 720 ∨ Nat.card G = 9720) : False := by
  have divides := card_dvd_of_faithful_symmetricSix action faithful
  rcases classified with small | large
  · have positive : 0 < Nat.card G := Nat.card_pos
    have bound : 720 ≤ Nat.card G := Nat.le_of_dvd positive divides
    omega
  · rw [large] at divides
    revert divides
    decide

/-- The exclusion in the form the gluing argument uses.  The classification
input is the list of orders of the groups it permits, together with the
statement that each listed order is either smaller than `720` or equal to
`9720`; the conclusion is that no group on that list admits a faithful action of
the symmetric group on six letters. -/
theorem no_faithful_symmetricSix_of_classified_list {G : Type*} [Group G] [Finite G]
    (classifiedOrders : List ℕ) (listed : Nat.card G ∈ classifiedOrders)
    (classification : ∀ order ∈ classifiedOrders, order < 720 ∨ order = 9720)
    (action : Equiv.Perm (Fin 6) →* G) (faithful : Function.Injective action) :
    False :=
  no_faithful_symmetricSix_of_classified_order action faithful
    (classification (Nat.card G) listed)

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
