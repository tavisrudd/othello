import Sumfree.Game

/-!
# Grundy aliases for the finite SumFree game

The generic `FiniteBuildGame.Grundy` recurrence is specialized here to
sum-free positions, giving stable names for future nimber statements.
-/

namespace Sumfree
namespace Game

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- Grundy value of a finite sum-free position. -/
noncomputable abbrev Grundy (S : Finset G) : ℕ :=
  FiniteBuildGame.Grundy Valid S

/-- SumFree wins are exactly nonzero-Grundy positions. -/
theorem win_iff_grundy_ne_zero {S : Finset G} :
    Win S ↔ Grundy S ≠ 0 :=
  FiniteBuildGame.win_iff_grundy_ne_zero

/-- SumFree P-positions are exactly zero-Grundy positions. -/
theorem isP_iff_grundy_eq_zero {S : Finset G} :
    IsP S ↔ Grundy S = 0 :=
  FiniteBuildGame.isP_iff_grundy_eq_zero

/-- Nontrivial exponent-three sum-free games have root Grundy value `1`. -/
theorem f3_grundy_empty_eq_one [Nontrivial G]
    (hchar3 : ∀ z : G, z + z + z = 0) :
    Grundy (∅ : Finset G) = 1 := by
  rw [Grundy, FiniteBuildGame.Grundy.eq_def]
  have himage :
      (FiniteBuildGame.LegalExtensions Valid (∅ : Finset G)).attach.image
          (fun x : {x // x ∈ FiniteBuildGame.LegalExtensions Valid (∅ : Finset G)} =>
            FiniteBuildGame.Grundy Valid (insert (x : G) (∅ : Finset G))) = {0} := by
    ext n
    constructor
    · intro hn
      rw [Finset.mem_image] at hn
      rcases hn with ⟨x, _hxmem, hxn⟩
      have hxmove : Move (∅ : Finset G) (x : G) :=
        FiniteBuildGame.mem_legalExtensions.mp x.2
      have hx0 : (x : G) ≠ 0 := empty_move_iff_ne_zero.1 hxmove
      have hP : IsP ({(x : G)} : Finset G) := f3_postOpening_isP hchar3 hx0
      have hg : Grundy ({(x : G)} : Finset G) = 0 :=
        isP_iff_grundy_eq_zero.1 hP
      rw [← hxn]
      simpa [Grundy] using hg
    · intro hn
      have hn0 : n = 0 := by simpa using hn
      subst n
      obtain ⟨x, hx0⟩ := exists_ne (0 : G)
      have hxmove : Move (∅ : Finset G) x := empty_move_iff_ne_zero.2 hx0
      let xleg : {x : G // x ∈ FiniteBuildGame.LegalExtensions Valid (∅ : Finset G)} :=
        ⟨x, FiniteBuildGame.mem_legalExtensions.mpr hxmove⟩
      refine Finset.mem_image.mpr ⟨xleg, by simp, ?_⟩
      have hP : IsP ({x} : Finset G) := f3_postOpening_isP hchar3 hx0
      have hg : Grundy ({x} : Finset G) = 0 :=
        isP_iff_grundy_eq_zero.1 hP
      simpa [xleg, Grundy] using hg
  rw [himage, FiniteBuildGame.mex_singleton_zero]

end Game
end Sumfree
