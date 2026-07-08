import CapGame.Embedding
import Sumfree.RankCounts

/-!
# Sum-free play on the nonzero part of a vector space

For a `ZMod 2` vector space of rank at least two, the existing sum-free rank
theorem proves that the empty ambient game is P.  This file transports that
result to the nonzero subboard, using the fact that `0` is never a legal move
in a sum-free game.
-/

namespace Sumfree
namespace Game

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- The inclusion of nonzero elements into the ambient additive group. -/
def nonzeroEmbedding : {x : G // x ≠ 0} ↪ G where
  toFun := Subtype.val
  inj' := by
    intro x y h
    exact Subtype.ext h

/-- Sum-free validity restricted to the nonzero subboard. -/
def NonzeroValid (S : Finset {x : G // x ≠ 0}) : Prop :=
  Valid (S.map (nonzeroEmbedding (G := G)))

theorem initial_isP_zmod2_of_finrank_ge_two [Module (ZMod 2) G]
    (hfinrank : 2 ≤ Module.finrank (ZMod 2) G) :
    IsP (∅ : Finset G) := by
  exact initial_isP_of_rank_count_P_cases
    (G := G)
    (hasTwoRank_finrank_zmod2 (G := G))
    (hasThreeRank_zero_of_zmod2_module (G := G))
    (Or.inl hfinrank)

/--
The nonzero part of a finite `ZMod 2` vector space of rank at least two is a
P-position for the restricted sum-free game.
-/
theorem nonzero_initial_isP_zmod2_of_finrank_ge_two [Module (ZMod 2) G]
    (hfinrank : 2 ≤ Module.finrank (ZMod 2) G) :
    FiniteBuildGame.IsP (NonzeroValid (G := G)) (∅ : Finset {x : G // x ≠ 0}) := by
  let e := nonzeroEmbedding (G := G)
  have hLive :
      ∀ S : Finset {x : G // x ≠ 0}, ∀ y : G,
        FiniteBuildGame.Move Valid (S.map e) y -> ∃ x : {x : G // x ≠ 0}, e x = y := by
    intro S y hymove
    have hy0 : y ≠ 0 :=
      legal_ne_zero (G := G) ((move_iff_legal (G := G) (S := S.map e) (x := y)).1 hymove)
    exact ⟨⟨y, hy0⟩, rfl⟩
  have hfull : FiniteBuildGame.IsP Valid ((∅ : Finset {x : G // x ≠ 0}).map e) := by
    simpa using initial_isP_zmod2_of_finrank_ge_two (G := G) hfinrank
  exact (FiniteBuildGame.isP_embedding
    (α := {x : G // x ≠ 0}) (β := G)
    (Validα := NonzeroValid (G := G)) (Validβ := Valid)
    e (by intro S; rfl) hLive
    (∅ : Finset {x : G // x ≠ 0})).mp hfull

end Game
end Sumfree
