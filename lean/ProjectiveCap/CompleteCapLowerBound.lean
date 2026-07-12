import ProjectiveCap.Projective
import Mathlib.Algebra.Field.ZMod
import Mathlib.Data.Finset.Powerset
import Mathlib.LinearAlgebra.Projectivization.Cardinality

/-!
# Secant-cover lower bound for complete caps

This file isolates the counting kernel behind the elementary lower bound for a
complete cap.  `blocked P` is the set of outside points covered by the secant
through the two-point subset `P`.  The geometric application supplies two
facts: every outside point belongs to one of these sets, and each set has at
most `q - 1` points.
-/

namespace ProjectiveCap

open Finset

section PairCover

variable {α : Type*} [Fintype α] [DecidableEq α]

/-- A finite set covered by itself and by at most `r` points attached to each
of its two-element subsets satisfies the secant-cover counting bound. -/
theorem card_le_card_add_mul_choose_two
    (S : Finset α) (blocked : Finset α → Finset α) (r : ℕ)
    (hcover : ∀ x ∉ S, ∃ P ∈ S.powersetCard 2, x ∈ blocked P)
    (hblocked : ∀ P ∈ S.powersetCard 2, (blocked P).card ≤ r) :
    Fintype.card α ≤ S.card + r * Nat.choose S.card 2 := by
  classical
  have huniv : (Finset.univ : Finset α) ⊆
      S ∪ (S.powersetCard 2).biUnion blocked := by
    intro x hx
    by_cases hS : x ∈ S
    · exact Finset.mem_union_left _ hS
    · obtain ⟨P, hP, hxP⟩ := hcover x hS
      exact Finset.mem_union_right _ (Finset.mem_biUnion.mpr ⟨P, hP, hxP⟩)
  calc
    Fintype.card α = (Finset.univ : Finset α).card := Finset.card_univ.symm
    _ ≤ (S ∪ (S.powersetCard 2).biUnion blocked).card := Finset.card_le_card huniv
    _ ≤ S.card + ((S.powersetCard 2).biUnion blocked).card := Finset.card_union_le _ _
    _ ≤ S.card + ∑ P ∈ S.powersetCard 2, (blocked P).card := by
      gcongr
      exact Finset.card_biUnion_le
    _ ≤ S.card + ∑ _P ∈ S.powersetCard 2, r := by
      gcongr with P hP
      exact hblocked P hP
    _ = S.card + r * Nat.choose S.card 2 := by
      rw [Finset.sum_const, Finset.card_powersetCard]
      simp [Nat.mul_comm]

/-- Numerical `PG(4,5)` instance of the secant-cover kernel: 781 points,
four off-cap points per secant, hence every complete cap has at least 21
points. -/
theorem card_ge_21_of_pg45_pair_cover
    (S : Finset α) (blocked : Finset α → Finset α)
    (hcard : Fintype.card α = 781)
    (hcover : ∀ x ∉ S, ∃ P ∈ S.powersetCard 2, x ∈ blocked P)
    (hblocked : ∀ P ∈ S.powersetCard 2, (blocked P).card ≤ 4) :
    21 ≤ S.card := by
  have h := card_le_card_add_mul_choose_two S blocked 4 hcover hblocked
  rw [hcard] at h
  by_contra hn
  have hk : S.card ≤ 20 := by omega
  have hchoose : Nat.choose S.card 2 ≤ Nat.choose 20 2 :=
    Nat.choose_le_choose 2 hk
  norm_num [Nat.choose] at hchoose
  omega

end PairCover

section PG45

open scoped LinearAlgebra.Projectivization

local instance : Fact (Nat.Prime 5) := Fact.mk (by decide)

/-- `PG(4,5)` has 781 projective points. -/
theorem pg45_point_card :
    Nat.card (Projectivization (ZMod 5) (Fin 5 → ZMod 5)) = 781 := by
  rw [Projectivization.card_of_finrank (ZMod 5) (Fin 5 → ZMod 5) (n := 5) (by simp)]
  norm_num

end PG45

end ProjectiveCap
