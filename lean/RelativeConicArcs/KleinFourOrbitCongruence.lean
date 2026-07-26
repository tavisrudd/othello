import Mathlib.Data.Nat.ModEq
import Mathlib.GroupTheory.GroupAction.Quotient

/-!
# A unique-fixed-point orbit congruence

Let a nontrivial finite group act on a finite set.  Suppose one point is fixed
by the whole group and every nonidentity element fixes no other point.
Burnside's lemma then forces the set cardinality to be congruent to one
modulo the order of the group.

The order-four specialization gives congruence modulo four, and the terminal
specialization rules out a ninety-one-element set with this fixed-point
pattern.  The module formalizes only the finite group-action argument;
constructing such an action from conic involutions is a separate geometric
input.
-/

namespace RelativeConicArcs

/-- If a nontrivial finite group acts on a finite set and every nonidentity
element fixes exactly the same singleton, then the set has cardinality one
modulo the order of the group. -/
theorem card_mod_group_order_eq_one_of_unique_fixed_point_action
    {G X : Type*} [Group G] [Fintype G] [Nontrivial G] [Fintype X] [MulAction G X]
    (t : X) (hfixed : ∀ g : G, g ≠ 1 → MulAction.fixedBy X g = {t}) :
    Fintype.card X % Fintype.card G = 1 := by
  classical
  have hG : 1 < Fintype.card G := Fintype.one_lt_card
  have hterm (g : G) :
      Fintype.card (MulAction.fixedBy X g) =
        if g = 1 then Fintype.card X else 1 := by
    by_cases hg : g = 1
    · subst g
      simp only [if_pos]
      have hone : MulAction.fixedBy X (1 : G) = Set.univ := by
        ext x
        simp [MulAction.fixedBy]
      exact Fintype.card_congr
        ((Equiv.setCongr hone).trans (Equiv.Set.univ X))
    · rw [if_neg hg]
      calc
        Fintype.card (MulAction.fixedBy X g) =
            Fintype.card ({t} : Set X) :=
          Fintype.card_congr (Equiv.setCongr (hfixed g hg))
        _ = 1 := by simp
  have hsum :
      (∑ g : G, Fintype.card (MulAction.fixedBy X g)) =
        Fintype.card X + (Fintype.card G - 1) := by
    have hrest :
        (∑ g : {g : G // g ≠ 1},
          if (g : G) = 1 then Fintype.card X else 1) =
            Fintype.card G - 1 := by
      calc
        (∑ g : {g : G // g ≠ 1},
            if (g : G) = 1 then Fintype.card X else 1) =
            ∑ _g : {g : G // g ≠ 1}, 1 := by
              apply Fintype.sum_congr
              intro g
              simp [g.property]
        _ = Fintype.card {g : G // g ≠ 1} := by simp
        _ = Fintype.card G - 1 := by
          simp [Fintype.card_subtype_compl]
    simp_rw [hterm]
    rw [Fintype.sum_eq_add_sum_subtype_ne _ (1 : G)]
    rw [if_pos rfl, hrest]
  have hburnside :=
    MulAction.sum_card_fixedBy_eq_card_orbits_mul_card_group G X
  rw [hsum] at hburnside
  have hzero :
      Nat.ModEq (Fintype.card G)
        (Fintype.card X + (Fintype.card G - 1)) 0 := by
    rw [Nat.ModEq, hburnside]
    simp
  have htotal :
      Nat.ModEq (Fintype.card G)
        (Fintype.card X + (Fintype.card G - 1))
        (1 + (Fintype.card G - 1)) := by
    apply hzero.trans
    have hone_sub : 1 + (Fintype.card G - 1) = Fintype.card G := by
      omega
    rw [hone_sub, Nat.ModEq]
    simp
  have hcongr :
      Nat.ModEq (Fintype.card G) (Fintype.card X) 1 :=
    Nat.ModEq.add_right_cancel' (Fintype.card G - 1) htotal
  simpa [Nat.ModEq, Nat.mod_eq_of_lt hG] using hcongr

/-- If a group of order four acts on a finite set and every nonidentity
element fixes exactly the same singleton, then the set has cardinality one
modulo four. -/
theorem card_mod_four_eq_one_of_unique_fixed_point_action
    {V X : Type*} [Group V] [Fintype V] [Fintype X] [MulAction V X]
    (hV : Fintype.card V = 4) (t : X)
    (hfixed : ∀ g : V, g ≠ 1 → MulAction.fixedBy X g = {t}) :
    Fintype.card X % 4 = 1 := by
  haveI : Nontrivial V := Fintype.one_lt_card_iff_nontrivial.mp (by omega)
  simpa [hV] using
    card_mod_group_order_eq_one_of_unique_fixed_point_action t hfixed

/-- No action of a group of order four on a ninety-one-element set can have
one common fixed point and no further fixed point for any nonidentity
element. -/
theorem no_unique_fixed_point_four_group_action_on_card_ninety_one
    {V X : Type*} [Group V] [Fintype V] [Fintype X] [MulAction V X]
    (hV : Fintype.card V = 4) (hX : Fintype.card X = 91) (t : X)
    (hfixed : ∀ g : V, g ≠ 1 → MulAction.fixedBy X g = {t}) :
    False := by
  have hmod :=
    card_mod_four_eq_one_of_unique_fixed_point_action hV t hfixed
  omega

end RelativeConicArcs
