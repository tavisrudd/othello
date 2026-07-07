import Sumfree.Game

/-!
# Rank-count interface for finite sum-free games

This file packages the finite-abelian rank information used by the proved
SumFree game branches as explicit cardinality hypotheses on the obstruction
sets.  The remaining algebraic step for a full finite-abelian theorem is to
prove these predicates from a chosen structure-theorem/rank API.
-/

namespace Sumfree
namespace Game

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/--
`HasTwoRank G s` is the obstruction-count interface for saying that the
2-torsion has `F_2`-rank `s`: the full order-two kernel has size `2^s`, so
the nonzero obstruction set has size `2^s - 1`.
-/
def HasTwoRank (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G] (s : ℕ) :
    Prop :=
  (NonzeroOrderTwoElements (G := G)).card + 1 = 2 ^ s

/--
`HasThreeRank G r` is the obstruction-count interface for saying that the
3-torsion has `F_3`-rank `r`: the full order-three obstruction kernel has
size `3^r`, so the nonzero obstruction set has size `3^r - 1`.
-/
def HasThreeRank (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G] (r : ℕ) :
    Prop :=
  (NonzeroOrderThreeElements (G := G)).card + 1 = 3 ^ r

theorem nonzeroOrderTwo_card_eq_zero_of_hasTwoRank_zero
    (h : HasTwoRank G 0) :
    (NonzeroOrderTwoElements (G := G)).card = 0 := by
  unfold HasTwoRank at h
  omega

theorem nonzeroOrderTwo_card_eq_one_of_hasTwoRank_one
    (h : HasTwoRank G 1) :
    (NonzeroOrderTwoElements (G := G)).card = 1 := by
  unfold HasTwoRank at h
  norm_num at h
  omega

theorem nonzeroOrderTwo_card_ge_two_of_hasTwoRank_ge_two {s : ℕ}
    (h : HasTwoRank G s) (hs : 2 ≤ s) :
    2 ≤ (NonzeroOrderTwoElements (G := G)).card := by
  unfold HasTwoRank at h
  have hpow : 4 ≤ 2 ^ s := by
    have hpow := Nat.pow_le_pow_right (by decide : 0 < 2) hs
    simpa using hpow
  omega

theorem nonzeroOrderThree_card_eq_zero_of_hasThreeRank_zero
    (h : HasThreeRank G 0) :
    (NonzeroOrderThreeElements (G := G)).card = 0 := by
  unfold HasThreeRank at h
  omega

theorem nonzeroOrderThree_card_eq_two_of_hasThreeRank_one
    (h : HasThreeRank G 1) :
    (NonzeroOrderThreeElements (G := G)).card = 2 := by
  unfold HasThreeRank at h
  norm_num at h
  omega

/--
Rank-count P-side theorem for the currently proved branches.

This is the rank-facing wrapper around
`initial_isP_of_obstruction_count_P_cases`.
-/
theorem initial_isP_of_rank_count_P_cases {s r : ℕ}
    (h2 : HasTwoRank G s) (h3 : HasThreeRank G r)
    (h :
      2 ≤ s ∨
        (s = 0 ∧ r = 0) ∨
        (s = 1 ∧ r = 1)) :
    IsP (∅ : Finset G) := by
  rcases h with hs2 | h00 | h11
  · exact initial_isP_of_obstruction_count_P_cases (G := G)
      (Or.inl (nonzeroOrderTwo_card_ge_two_of_hasTwoRank_ge_two h2 hs2))
  · rcases h00 with ⟨rfl, rfl⟩
    exact initial_isP_of_obstruction_count_P_cases (G := G)
      (Or.inr (Or.inl
        ⟨nonzeroOrderTwo_card_eq_zero_of_hasTwoRank_zero h2,
          nonzeroOrderThree_card_eq_zero_of_hasThreeRank_zero h3⟩))
  · rcases h11 with ⟨rfl, rfl⟩
    exact initial_isP_of_obstruction_count_P_cases (G := G)
      (Or.inr (Or.inr
        ⟨nonzeroOrderTwo_card_eq_one_of_hasTwoRank_one h2,
          nonzeroOrderThree_card_eq_two_of_hasThreeRank_one h3⟩))

/--
Rank-count N-side theorem for the currently proved `r₃ ≤ 1`, `s₂ ≤ 1`
branches.

This is the rank-facing wrapper around
`initial_win_of_obstruction_count_N_cases`.
-/
theorem initial_win_of_rank_count_N_cases {s r : ℕ}
    (h2 : HasTwoRank G s) (h3 : HasThreeRank G r)
    (h :
      (s = 1 ∧ r = 0) ∨
        (s = 0 ∧ r = 1)) :
    Win (∅ : Finset G) := by
  rcases h with h10 | h01
  · rcases h10 with ⟨rfl, rfl⟩
    exact initial_win_of_obstruction_count_N_cases (G := G)
      (Or.inl
        ⟨nonzeroOrderTwo_card_eq_one_of_hasTwoRank_one h2,
          nonzeroOrderThree_card_eq_zero_of_hasThreeRank_zero h3⟩)
  · rcases h01 with ⟨rfl, rfl⟩
    exact initial_win_of_obstruction_count_N_cases (G := G)
      (Or.inr
        ⟨nonzeroOrderTwo_card_eq_zero_of_hasTwoRank_zero h2,
          nonzeroOrderThree_card_eq_two_of_hasThreeRank_one h3⟩)

/--
Rank-count form of the proved `r₃ ≤ 1` P criterion.

The remaining finite-abelian algebra task is to construct `HasTwoRank` and
`HasThreeRank`; once those are available, this theorem gives the complete
P-side criterion for `r ≤ 1`.
-/
theorem initial_isP_iff_rank_count_P_cases_of_threeRank_le_one {s r : ℕ}
    (h2 : HasTwoRank G s) (h3 : HasThreeRank G r) (hr : r ≤ 1) :
    IsP (∅ : Finset G) ↔
      2 ≤ s ∨ (s = 0 ∧ r = 0) ∨ (s = 1 ∧ r = 1) := by
  constructor
  · intro hP
    by_cases hs2 : 2 ≤ s
    · exact Or.inl hs2
    · have hslt : s < 2 := Nat.lt_of_not_ge hs2
      interval_cases s
      · interval_cases r
        · exact Or.inr (Or.inl ⟨rfl, rfl⟩)
        · exfalso
          exact hP (initial_win_of_rank_count_N_cases (G := G) h2 h3
            (Or.inr ⟨rfl, rfl⟩))
      · interval_cases r
        · exfalso
          exact hP (initial_win_of_rank_count_N_cases (G := G) h2 h3
            (Or.inl ⟨rfl, rfl⟩))
        · exact Or.inr (Or.inr ⟨rfl, rfl⟩)
  · exact initial_isP_of_rank_count_P_cases (G := G) h2 h3

/--
Rank-count form of the proved `r₃ ≤ 1`, `s₂ ≤ 1` N criterion.
-/
theorem initial_win_iff_rank_count_N_cases_of_threeRank_le_one {s r : ℕ}
    (h2 : HasTwoRank G s) (h3 : HasThreeRank G r) (hr : r ≤ 1) :
    Win (∅ : Finset G) ↔
      (s = 1 ∧ r = 0) ∨ (s = 0 ∧ r = 1) := by
  constructor
  · intro hW
    by_cases hs2 : 2 ≤ s
    · exfalso
      exact (initial_isP_of_rank_count_P_cases (G := G) h2 h3 (Or.inl hs2)) hW
    · have hslt : s < 2 := Nat.lt_of_not_ge hs2
      interval_cases s
      · interval_cases r
        · exfalso
          exact (initial_isP_of_rank_count_P_cases (G := G) h2 h3
            (Or.inr (Or.inl ⟨rfl, rfl⟩))) hW
        · exact Or.inr ⟨rfl, rfl⟩
      · interval_cases r
        · exact Or.inl ⟨rfl, rfl⟩
        · exfalso
          exact (initial_isP_of_rank_count_P_cases (G := G) h2 h3
            (Or.inr (Or.inr ⟨rfl, rfl⟩))) hW
  · exact initial_win_of_rank_count_N_cases (G := G) h2 h3

end Game
end Sumfree
