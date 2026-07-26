import Mathlib.GroupTheory.GroupAction.Quotient

/-!
# A four-group orbit congruence

Let a finite group of order four act on a finite set.  Suppose one point is
fixed by the whole group and every nonidentity element fixes no other point.
Burnside's lemma then forces the set cardinality to be congruent to one
modulo four.

The terminal specialization rules out a ninety-one-element set with this
fixed-point pattern.  The module formalizes only the finite group-action
argument; constructing such an action from conic involutions is a separate
geometric input.
-/

namespace RelativeConicArcs

/-- If a group of order four acts on a finite set and every nonidentity
element fixes exactly the same singleton, then the set has cardinality one
modulo four. -/
theorem card_mod_four_eq_one_of_unique_fixed_point_action
    {V X : Type*} [Group V] [Fintype V] [Fintype X] [MulAction V X]
    (hV : Fintype.card V = 4) (t : X)
    (hfixed : ∀ g : V, g ≠ 1 → MulAction.fixedBy X g = {t}) :
    Fintype.card X % 4 = 1 := by
  classical
  have hterm (g : V) :
      Fintype.card (MulAction.fixedBy X g) =
        if g = 1 then Fintype.card X else 1 := by
    by_cases hg : g = 1
    · subst g
      simp only [if_pos]
      have hone : MulAction.fixedBy X (1 : V) = Set.univ := by
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
      (∑ g : V, Fintype.card (MulAction.fixedBy X g)) =
        Fintype.card X + 3 := by
    have hnecard : Fintype.card {g : V // g ≠ 1} = 3 := by
      simp [Fintype.card_subtype_compl, hV]
    have hrest :
        (∑ g : {g : V // g ≠ 1},
          if (g : V) = 1 then Fintype.card X else 1) = 3 := by
      calc
        (∑ g : {g : V // g ≠ 1},
            if (g : V) = 1 then Fintype.card X else 1) =
            ∑ _g : {g : V // g ≠ 1}, 1 := by
              apply Fintype.sum_congr
              intro g
              simp [g.property]
        _ = Fintype.card {g : V // g ≠ 1} := by simp
        _ = 3 := hnecard
    simp_rw [hterm]
    rw [Fintype.sum_eq_add_sum_subtype_ne _ (1 : V)]
    rw [if_pos rfl, hrest]
  have hburnside :=
    MulAction.sum_card_fixedBy_eq_card_orbits_mul_card_group V X
  rw [hsum, hV] at hburnside
  omega

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
