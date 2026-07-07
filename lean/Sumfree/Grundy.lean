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

end Game
end Sumfree
