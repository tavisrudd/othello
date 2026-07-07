import Sumfree.RankCounts
import Sumfree.Z2F3Bridge

/-!
# Rank counts for the concrete `ZMod 2 × F_3^b` model

`Sumfree.Z2F3Game` proves the game outcome for the product model used by the
labelled residual argument.  This file records the matching rank-count facts:
the product has 2-rank `1`, and its 3-rank is the `F_3`-dimension of `V`.
-/

namespace Sumfree
namespace Game

variable {V : Type*} [AddCommGroup V] [Fintype V] [DecidableEq V] [Module (ZMod 3) V]

private theorem zmod2_eq_zero_or_one (e : ZMod 2) : e = 0 ∨ e = 1 := by
  fin_cases e
  · exact Or.inl rfl
  · exact Or.inr rfl

omit [Fintype V] [DecidableEq V] in
private theorem zmod3_two_nsmul_eq_zero_iff {v : V} :
    (2 : ℕ) • v = 0 ↔ v = 0 := by
  constructor
  · intro hv
    have hvscalar : (2 : ZMod 3) • v = 0 :=
      (Nat.cast_smul_eq_nsmul (R := ZMod 3) 2 v).trans hv
    rcases smul_eq_zero.mp hvscalar with h2 | hvzero
    · exact ((by decide : (2 : ZMod 3) ≠ 0) h2).elim
    · exact hvzero
  · intro hv
    rw [hv]
    simp

private theorem zmod2_three_nsmul_eq_zero_iff {e : ZMod 2} :
    (3 : ℕ) • e = 0 ↔ e = 0 := by
  constructor
  · intro h
    have hscalar : (3 : ZMod 2) • e = 0 :=
      (Nat.cast_smul_eq_nsmul (R := ZMod 2) 3 e).trans h
    rcases smul_eq_zero.mp hscalar with h3 | hezero
    · exact ((by decide : (3 : ZMod 2) ≠ 0) h3).elim
    · exact hezero
  · intro h
    rw [h]
    simp

/-- The zero-label embedding of the `F_3` part into `ZMod 2 × V`. -/
def z2vZeroLabelEmbedding (V : Type*) : V ↪ Z2V V where
  toFun v := LabelledPoint v 0
  inj' := by
    intro a b h
    exact congrArg Prod.snd h

/-- The order-two kernel of `ZMod 2 × V` is the two labels over the zero slot. -/
theorem orderTwoKernelElements_z2v_zmod3_module :
    OrderTwoKernelElements (G := Z2V V) =
      ({LabelledPoint (0 : V) 0, LabelledPoint (0 : V) 1} : Finset (Z2V V)) := by
  ext x
  rw [mem_orderTwoKernelElements_iff_two_nsmul]
  constructor
  · intro hx
    have hv2 : (2 : ℕ) • x.2 = 0 :=
      congrArg Prod.snd hx
    have hv0 : x.2 = 0 := zmod3_two_nsmul_eq_zero_iff.mp hv2
    rcases zmod2_eq_zero_or_one x.1 with h0 | h1
    · have hxEq : x = LabelledPoint (0 : V) 0 := by
        ext <;> simp [LabelledPoint, h0, hv0]
      simp [hxEq]
    · have hxEq : x = LabelledPoint (0 : V) 1 := by
        ext <;> simp [LabelledPoint, h1, hv0]
      simp [hxEq]
  · intro hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with hx0 | hx1
    · rw [hx0]
      ext <;> simp [LabelledPoint]
    · rw [hx1]
      ext
      · change (2 : ℕ) • (1 : ZMod 2) = 0
        decide
      · simp [LabelledPoint]

/-- The order-three kernel of `ZMod 2 × V` is the zero-label copy of `V`. -/
theorem orderThreeKernelElements_z2v_zmod3_module :
    OrderThreeKernelElements (G := Z2V V) =
      Finset.univ.map (z2vZeroLabelEmbedding V) := by
  ext x
  rw [mem_orderThreeKernelElements_iff_three_nsmul]
  constructor
  · intro hx
    have hfst : (3 : ℕ) • x.1 = 0 :=
      congrArg Prod.fst hx
    have hx0 : x.1 = 0 := zmod2_three_nsmul_eq_zero_iff.mp hfst
    refine Finset.mem_map.mpr ?_
    refine ⟨x.2, Finset.mem_univ _, ?_⟩
    ext <;> simp [z2vZeroLabelEmbedding, LabelledPoint, hx0]
  · intro hx
    rcases Finset.mem_map.mp hx with ⟨v, _hv, rfl⟩
    ext
    · simp [z2vZeroLabelEmbedding, LabelledPoint]
    · simpa [z2vZeroLabelEmbedding, LabelledPoint, three_nsmul, add_assoc] using
        (ZModModule.char_nsmul_eq_zero (n := 3) v)

theorem hasTwoRank_z2v_zmod3_module :
    HasTwoRank (Z2V V) 1 := by
  unfold HasTwoRank
  rw [orderTwoKernelElements_z2v_zmod3_module]
  simp [LabelledPoint]

theorem hasThreeRank_z2v_zmod3_module :
    HasThreeRank (Z2V V) (Module.finrank (ZMod 3) V) := by
  unfold HasThreeRank
  rw [orderThreeKernelElements_z2v_zmod3_module]
  rw [Finset.card_map, Finset.card_univ]
  rw [@Module.card_eq_pow_finrank (K := ZMod 3) (V := V)]
  rw [show Fintype.card (ZMod 3) = 3 by exact ZMod.card 3]

theorem hasRanks_z2v_zmod3_module :
    HasTwoRank (Z2V V) 1 ∧
      HasThreeRank (Z2V V) (Module.finrank (ZMod 3) V) :=
  ⟨hasTwoRank_z2v_zmod3_module, hasThreeRank_z2v_zmod3_module⟩

end Game
end Sumfree
