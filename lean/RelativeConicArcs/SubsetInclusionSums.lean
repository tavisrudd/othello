import Mathlib.Algebra.BigOperators.Group.Finset.Powerset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.CharZero.Defs
import Mathlib.Data.Finset.Powerset
import Mathlib.Data.Nat.Choose.Basic

/-!
# Sums of a set function over the subsets of a fixed size

Fix a finite label set `X`, a function `g` from finite label sets to a
commutative ring, and two sizes `r ≤ m`.  The *inclusion sums* of `g` are the
ring elements

```
Σ_{T ⊆ S, |T| = r} g T,      S ⊆ X,  |S| = m,
```

one for each `m`-subset `S` of `X`.  This module proves that in characteristic
zero, and with no zero divisors, those sums determine `g` on the `r`-subsets of
`X` as soon as `r ≤ m` and `r + m ≤ |X|`:

* `eq_zero_of_sum_powersetCard_eq_zero`: if every inclusion sum vanishes then
  `g` vanishes on every `r`-subset of `X`;
* `eq_of_sum_powersetCard_eq`: if the inclusion sums are all equal, and
  `1 ≤ r`, then `g` takes one value on all `r`-subsets of `X`.

Both are the statement that the inclusion matrix of `r`-subsets against
`m`-subsets of an `|X|`-set has full column rank over a field of
characteristic zero, restricted to the one consequence it is used for.  The
rank formula for inclusion matrices in that generality is due to Gottlieb
(D. H. Gottlieb, *A certain class of incidence matrices*, Proceedings of the
American Mathematical Society **17** (1966), 1233--1237, Theorem 1) with a
representation-theoretic proof by Jolliffe (W. Jolliffe, *A short proof of the
rank formula for inclusion matrices using the representation theory of the
symmetric group*, arXiv:2009.05202v1 (2020), Theorem 1); neither is used here.

The proof is a descent on one-element swaps.  Two `m`-subsets of `X` that
differ in a single label `a` versus `b` have inclusion sums differing by

```
Σ_{T ⊆ S, |T| = r-1} ( g (T ∪ {a}) - g (T ∪ {b}) ),
```

the inclusion sums of the difference function `T ↦ g (T ∪ {a}) - g (T ∪ {b})`
at one smaller subset size, on the smaller label set `X \ {a, b}`.  Induction
on `r` therefore makes that difference vanish, so exchanging one label of an
`r`-subset does not change `g`; since one-element exchanges connect all
`r`-subsets, `g` is constant on them, and a single inclusion sum then evaluates
that constant as a binomial multiple.

Nothing in this module refers to matrices; the two theorems are stated for an
arbitrary function on finite subsets of an arbitrary type with decidable
equality.
-/

namespace RelativeConicArcs.SubsetInclusionSums

open Finset

variable {α : Type*} [DecidableEq α]

/-- Splitting the `(r+1)`-subsets of `insert a S`, for `a ∉ S`, into those
contained in `S` and those obtained by adjoining `a` to an `r`-subset of `S`. -/
theorem sum_powersetCard_insert {M : Type*} [AddCommMonoid M] {a : α} {S : Finset α}
    (ha : a ∉ S) (r : ℕ) (g : Finset α → M) :
    ∑ T ∈ (insert a S).powersetCard (r + 1), g T =
      (∑ T ∈ S.powersetCard (r + 1), g T) + ∑ T ∈ S.powersetCard r, g (insert a T) := by
  have hdisj :
      Disjoint (S.powersetCard (r + 1)) ((S.powersetCard r).image (insert a)) := by
    refine Finset.disjoint_left.mpr ?_
    intro T hT hT'
    obtain ⟨U, hU, rfl⟩ := Finset.mem_image.mp hT'
    exact ha ((Finset.mem_powersetCard.mp hT).1 (Finset.mem_insert_self a U))
  have hinj : ∀ U ∈ S.powersetCard r, ∀ V ∈ S.powersetCard r,
      insert a U = insert a V → U = V := by
    intro U hU V hV hUV
    have haU : a ∉ U := fun h => ha ((Finset.mem_powersetCard.mp hU).1 h)
    have haV : a ∉ V := fun h => ha ((Finset.mem_powersetCard.mp hV).1 h)
    rw [← Finset.erase_insert haU, ← Finset.erase_insert haV, hUV]
  rw [Finset.powersetCard_succ_insert ha, Finset.sum_union hdisj, Finset.sum_image hinj]

/-- The one-element exchange step.  If all inclusion sums of `g` at subset size
`r + 1` over the `(m+1)`-subsets of `X` share the value `c`, then for any two
distinct labels `a, b` of `X` the difference function
`T ↦ g (T ∪ {a}) - g (T ∪ {b})` has vanishing inclusion sums at subset size `r`
over the `m`-subsets of `X \ {a, b}`. -/
theorem sum_sub_eq_zero_of_sum_powersetCard_eq {R : Type*} [CommRing R]
    {X : Finset α} {r m : ℕ} {g : Finset α → R} {c : R}
    (h : ∀ S ⊆ X, S.card = m + 1 → ∑ T ∈ S.powersetCard (r + 1), g T = c)
    {a b : α} (ha : a ∈ X) (hb : b ∈ X)
    {S : Finset α} (hS : S ⊆ X \ {a, b}) (hcard : S.card = m) :
    ∑ T ∈ S.powersetCard r, (g (insert a T) - g (insert b T)) = 0 := by
  have hSX : S ⊆ X := hS.trans (Finset.sdiff_subset)
  have haS : a ∉ S := fun hmem => by
    have := hS hmem
    simp [Finset.mem_sdiff] at this
  have hbS : b ∉ S := fun hmem => by
    have := hS hmem
    simp [Finset.mem_sdiff] at this
  have hA : (∑ T ∈ S.powersetCard (r + 1), g T)
      + ∑ T ∈ S.powersetCard r, g (insert a T) = c := by
    rw [← sum_powersetCard_insert haS r g]
    exact h _ (Finset.insert_subset ha hSX) (by rw [Finset.card_insert_of_notMem haS, hcard])
  have hB : (∑ T ∈ S.powersetCard (r + 1), g T)
      + ∑ T ∈ S.powersetCard r, g (insert b T) = c := by
    rw [← sum_powersetCard_insert hbS r g]
    exact h _ (Finset.insert_subset hb hSX) (by rw [Finset.card_insert_of_notMem hbS, hcard])
  rw [Finset.sum_sub_distrib, add_left_cancel (hA.trans hB.symm), sub_self]

/-- One-element exchanges connect the subsets of a fixed size: a function
unchanged by every exchange of one label for another takes a single value on
all `(r+1)`-subsets of `X`. -/
theorem eq_of_swap_invariant {R : Type*} [CommRing R] {X : Finset α} {r : ℕ}
    {g : Finset α → R}
    (hswap : ∀ a ∈ X, ∀ b ∈ X, ∀ T ⊆ X, a ∉ T → b ∉ T → T.card = r →
      g (insert a T) = g (insert b T)) :
    ∀ U ⊆ X, U.card = r + 1 → ∀ V ⊆ X, V.card = r + 1 → g U = g V := by
  have key : ∀ N : ℕ, ∀ U ⊆ X, U.card = r + 1 → ∀ V ⊆ X, V.card = r + 1 →
      (U \ V).card ≤ N → g U = g V := by
    intro N
    induction N with
    | zero =>
      intro U _ hUc V hV hVc hle
      have hsub : U ⊆ V :=
        Finset.sdiff_eq_empty_iff_subset.mp (Finset.card_eq_zero.mp (Nat.le_zero.mp hle))
      rw [Finset.eq_of_subset_of_card_le hsub (by rw [hUc, hVc])]
    | succ N ih =>
      intro U hU hUc V hV hVc hle
      rcases eq_or_ne U V with rfl | hUV
      · rfl
      · have hne : (U \ V).Nonempty := by
          rw [Finset.sdiff_nonempty]
          intro hsub
          exact hUV (Finset.eq_of_subset_of_card_le hsub (by rw [hUc, hVc]))
        obtain ⟨a, haUV⟩ := hne
        have haU : a ∈ U := (Finset.mem_sdiff.mp haUV).1
        have haV : a ∉ V := (Finset.mem_sdiff.mp haUV).2
        have hne' : (V \ U).Nonempty := by
          rw [Finset.sdiff_nonempty]
          intro hsub
          exact hUV (Finset.eq_of_subset_of_card_le hsub (by rw [hUc, hVc])).symm
        obtain ⟨b, hbVU⟩ := hne'
        have hbV : b ∈ V := (Finset.mem_sdiff.mp hbVU).1
        have hbU : b ∉ U := (Finset.mem_sdiff.mp hbVU).2
        set T := U.erase a with hT
        have hTsub : T ⊆ X := (Finset.erase_subset a U).trans hU
        have haT : a ∉ T := Finset.notMem_erase a U
        have hbT : b ∉ T := fun hmem => hbU (Finset.mem_of_mem_erase hmem)
        have hTc : T.card = r := by
          rw [hT, Finset.card_erase_of_mem haU, hUc]
          omega
        have hUins : U = insert a T := by rw [hT, Finset.insert_erase haU]
        have hstep : g U = g (insert b T) := by
          rw [hUins]
          exact hswap a (hU haU) b (hV hbV) T hTsub haT hbT hTc
        have hWsub : insert b T ⊆ X := Finset.insert_subset (hV hbV) hTsub
        have hWc : (insert b T).card = r + 1 := by
          rw [Finset.card_insert_of_notMem hbT, hTc]
        have hshrink : (insert b T \ V).card < (U \ V).card := by
          have hbig : insert b T \ V = (U \ V).erase a := by
            ext x
            simp only [Finset.mem_sdiff, Finset.mem_insert, Finset.mem_erase, hT,
              Finset.mem_erase]
            constructor
            · rintro ⟨hx | hx, hxV⟩
              · exact absurd hbV (hx ▸ hxV)
              · exact ⟨hx.1, hx.2, hxV⟩
            · rintro ⟨hxa, hxU, hxV⟩
              exact ⟨Or.inr ⟨hxa, hxU⟩, hxV⟩
          rw [hbig, Finset.card_erase_of_mem haUV]
          have : 0 < (U \ V).card := Finset.card_pos.mpr ⟨a, haUV⟩
          omega
        exact hstep.trans (ih (insert b T) hWsub hWc V hV hVc (by omega))
  intro U hU hUc V hV hVc
  exact key (U \ V).card U hU hUc V hV hVc le_rfl

/-- Full column rank of the inclusion matrix, in the form used here: if every
`m`-subset of `X` has vanishing sum of `g` over its `r`-subsets, and
`r ≤ m` with `r + m ≤ |X|`, then `g` vanishes on every `r`-subset of `X`. -/
theorem eq_zero_of_sum_powersetCard_eq_zero {R : Type*} [CommRing R] [CharZero R]
    [NoZeroDivisors R] :
    ∀ (r m : ℕ) {X : Finset α} {g : Finset α → R}, r ≤ m → r + m ≤ X.card →
      (∀ S ⊆ X, S.card = m → ∑ T ∈ S.powersetCard r, g T = 0) →
      ∀ T ⊆ X, T.card = r → g T = 0 := by
  intro r
  induction r with
  | zero =>
    intro m X g _ hcard h T _ hTc
    obtain ⟨S, hS, hSc⟩ := Finset.exists_subset_card_eq (show m ≤ X.card by omega)
    have hsum := h S hS hSc
    rw [Finset.powersetCard_zero, Finset.sum_singleton] at hsum
    rwa [Finset.card_eq_zero.mp hTc]
  | succ r ih =>
    intro m X g hrm hcard h T hT hTc
    obtain ⟨m, rfl⟩ : ∃ m', m = m' + 1 := ⟨m - 1, by omega⟩
    have hswap : ∀ a ∈ X, ∀ b ∈ X, ∀ U ⊆ X, a ∉ U → b ∉ U → U.card = r →
        g (insert a U) = g (insert b U) := by
      intro a ha b hb U hUX haU hbU hUc
      have hpair : ({a, b} : Finset α) ⊆ X := by
        intro x hx
        rcases Finset.mem_insert.mp hx with rfl | hx
        · exact ha
        · rwa [Finset.mem_singleton.mp hx]
      have hcard' : r + m ≤ (X \ ({a, b} : Finset α)).card := by
        have hle : (X \ ({a, b} : Finset α)).card = X.card - ({a, b} : Finset α).card :=
          Finset.card_sdiff_of_subset hpair
        have : ({a, b} : Finset α).card ≤ 2 := by simpa using Finset.card_insert_le a ({b} : Finset α)
        omega
      have hUsub : U ⊆ X \ ({a, b} : Finset α) := by
        refine Finset.subset_sdiff.mpr ⟨hUX, ?_⟩
        refine Finset.disjoint_right.mpr ?_
        intro x hx
        rcases Finset.mem_insert.mp hx with rfl | hx
        · exact haU
        · rw [Finset.mem_singleton.mp hx]; exact hbU
      have hzero := ih m (X := X \ ({a, b} : Finset α))
        (g := fun U => g (insert a U) - g (insert b U)) (by omega) hcard'
        (fun S hS hSc => sum_sub_eq_zero_of_sum_powersetCard_eq h ha hb hS hSc)
        U hUsub hUc
      exact sub_eq_zero.mp hzero
    have hconst := eq_of_swap_invariant hswap
    obtain ⟨S, hSX, hSc⟩ := Finset.exists_subset_card_eq (show m + 1 ≤ X.card by omega)
    have hsum := h S hSX hSc
    have hval : ∑ U ∈ S.powersetCard (r + 1), g U
        = ((S.powersetCard (r + 1)).card : R) * g T := by
      rw [Finset.sum_congr rfl (fun U hU => hconst U ((Finset.mem_powersetCard.mp hU).1.trans hSX)
        (Finset.mem_powersetCard.mp hU).2 T hT hTc), Finset.sum_const, nsmul_eq_mul]
    rw [hval, Finset.card_powersetCard, hSc] at hsum
    have hpos : (m + 1).choose (r + 1) ≠ 0 := (Nat.choose_pos (by omega)).ne'
    rcases mul_eq_zero.mp hsum with hc | hg
    · exact absurd (Nat.cast_eq_zero.mp hc) hpos
    · exact hg

/-- Equal inclusion sums force a set function to be constant on subsets of the
smaller size: if all `m`-subsets of `X` have the same sum of `g` over their
`r`-subsets, with `1 ≤ r ≤ m` and `r + m ≤ |X|`, then `g` takes one value on
all `r`-subsets of `X`. -/
theorem eq_of_sum_powersetCard_eq {R : Type*} [CommRing R] [CharZero R] [NoZeroDivisors R]
    {r m : ℕ} {X : Finset α} {g : Finset α → R} {c : R}
    (hr : 1 ≤ r) (hrm : r ≤ m) (hcard : r + m ≤ X.card)
    (h : ∀ S ⊆ X, S.card = m → ∑ T ∈ S.powersetCard r, g T = c) :
    ∀ U ⊆ X, U.card = r → ∀ V ⊆ X, V.card = r → g U = g V := by
  obtain ⟨r, rfl⟩ : ∃ r', r = r' + 1 := ⟨r - 1, by omega⟩
  obtain ⟨m, rfl⟩ : ∃ m', m = m' + 1 := ⟨m - 1, by omega⟩
  refine eq_of_swap_invariant ?_
  intro a ha b hb U hUX haU hbU hUc
  have hpair : ({a, b} : Finset α) ⊆ X := by
    intro x hx
    rcases Finset.mem_insert.mp hx with rfl | hx
    · exact ha
    · rwa [Finset.mem_singleton.mp hx]
  have hcard' : r + m ≤ (X \ ({a, b} : Finset α)).card := by
    have hle : (X \ ({a, b} : Finset α)).card = X.card - ({a, b} : Finset α).card :=
      Finset.card_sdiff_of_subset hpair
    have : ({a, b} : Finset α).card ≤ 2 := by simpa using Finset.card_insert_le a ({b} : Finset α)
    omega
  have hUsub : U ⊆ X \ ({a, b} : Finset α) := by
    refine Finset.subset_sdiff.mpr ⟨hUX, ?_⟩
    refine Finset.disjoint_right.mpr ?_
    intro x hx
    rcases Finset.mem_insert.mp hx with rfl | hx
    · exact haU
    · rw [Finset.mem_singleton.mp hx]; exact hbU
  have hzero := eq_zero_of_sum_powersetCard_eq_zero r m (X := X \ ({a, b} : Finset α))
    (g := fun U => g (insert a U) - g (insert b U)) (by omega) hcard'
    (fun S hS hSc => sum_sub_eq_zero_of_sum_powersetCard_eq h ha hb hS hSc)
    U hUsub hUc
  exact sub_eq_zero.mp hzero

end RelativeConicArcs.SubsetInclusionSums
