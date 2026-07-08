import CapGame.BuildGame

/-!
# Transport across live subboards

This file contains a small variant of `FiniteBuildGame.isP_equiv` for an
embedding into a larger board, under the hypothesis that every legal move from
an embedded position still lands in the embedded subboard.  It is useful for
games where the larger board has permanently illegal dummy points.
-/

namespace FiniteBuildGame

variable {α β : Type*} [Fintype α] [DecidableEq α] [Fintype β] [DecidableEq β]

omit [DecidableEq α] in
private theorem card_lt_univ_of_notMem {S : Finset α} {x : α} (hx : x ∉ S) :
    S.card < Fintype.card α := by
  have hsubset : S ⊆ (Finset.univ : Finset α) := by
    intro y _; exact Finset.mem_univ y
  have hproper : S ⊂ (Finset.univ : Finset α) :=
    (Finset.ssubset_iff_of_subset hsubset).mpr ⟨x, Finset.mem_univ x, hx⟩
  simpa using Finset.card_lt_card hproper

omit [Fintype α] [Fintype β] in
/-- Legal moves are transported by an embedding when validity matches on the
embedded subboard. -/
theorem move_embedding {Validα : Finset α -> Prop} {Validβ : Finset β -> Prop}
    (e : α ↪ β)
    (hValid : ∀ S : Finset α, Validβ (S.map e) ↔ Validα S)
    {S : Finset α} {x : α} :
    Move Validβ (S.map e) (e x) ↔ Move Validα S x := by
  have hmem : e x ∈ S.map e ↔ x ∈ S := by
    simp
  have hins : insert (e x) (S.map e) = (insert x S).map e := by
    simp [Finset.map_insert]
  unfold Move
  rw [hins, hValid, hmem]

/--
Normal-play game values are transported by an embedding when every legal move
from an embedded position lies in the embedded subboard.
-/
theorem win_embedding {Validα : Finset α -> Prop} {Validβ : Finset β -> Prop}
    (e : α ↪ β)
    (hValid : ∀ S : Finset α, Validβ (S.map e) ↔ Validα S)
    (hLive : ∀ S : Finset α, ∀ y : β, Move Validβ (S.map e) y ->
      ∃ x : α, e x = y)
    (S : Finset α) : Win Validβ (S.map e) ↔ Win Validα S := by
  rw [win_iff_exists_move, win_iff_exists_move]
  constructor
  · rintro ⟨y, hymove, hylose⟩
    rcases hLive S y hymove with ⟨x, rfl⟩
    have hxmove : Move Validα S x := (move_embedding e hValid).mp hymove
    refine ⟨x, hxmove, fun hwin => hylose ?_⟩
    have hins : insert (e x) (S.map e) = (insert x S).map e := by
      simp [Finset.map_insert]
    rw [hins]
    exact (win_embedding e hValid hLive (insert x S)).mpr hwin
  · rintro ⟨x, hxmove, hxlose⟩
    refine ⟨e x, (move_embedding e hValid).mpr hxmove, fun hwin => hxlose ?_⟩
    have hins : insert (e x) (S.map e) = (insert x S).map e := by
      simp [Finset.map_insert]
    rw [hins] at hwin
    exact (win_embedding e hValid hLive (insert x S)).mp hwin
termination_by Fintype.card α - S.card
decreasing_by
  · classical
    have hx : x ∉ S := hxmove.1
    have hcard : (insert x S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hx
    have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
    rw [hcard]
    omega
  · classical
    have hx : x ∉ S := hxmove.1
    have hcard : (insert x S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hx
    have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
    rw [hcard]
    omega

theorem isP_embedding {Validα : Finset α -> Prop} {Validβ : Finset β -> Prop}
    (e : α ↪ β)
    (hValid : ∀ S : Finset α, Validβ (S.map e) ↔ Validα S)
    (hLive : ∀ S : Finset α, ∀ y : β, Move Validβ (S.map e) y ->
      ∃ x : α, e x = y)
    (S : Finset α) : IsP Validβ (S.map e) ↔ IsP Validα S :=
  not_congr (win_embedding e hValid hLive S)

end FiniteBuildGame
