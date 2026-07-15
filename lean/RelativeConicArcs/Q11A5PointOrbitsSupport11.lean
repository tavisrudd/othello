import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 55--59 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_55 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 55)).card = 6 := by decide

theorem supportPerm_injective_row_55 :
    ∀ h : GroupIndex, supportPerm 55 = supportPerm h → (55 : GroupIndex) = h := by decide

theorem support_family_closed_row_55 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 55 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_56 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 56)).card = 6 := by decide

theorem supportPerm_injective_row_56 :
    ∀ h : GroupIndex, supportPerm 56 = supportPerm h → (56 : GroupIndex) = h := by decide

theorem support_family_closed_row_56 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 56 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_57 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 57)).card = 6 := by decide

theorem supportPerm_injective_row_57 :
    ∀ h : GroupIndex, supportPerm 57 = supportPerm h → (57 : GroupIndex) = h := by decide

theorem support_family_closed_row_57 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 57 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_58 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 58)).card = 6 := by decide

theorem supportPerm_injective_row_58 :
    ∀ h : GroupIndex, supportPerm 58 = supportPerm h → (58 : GroupIndex) = h := by decide

theorem support_family_closed_row_58 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 58 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_59 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 59)).card = 6 := by decide

theorem supportPerm_injective_row_59 :
    ∀ h : GroupIndex, supportPerm 59 = supportPerm h → (59 : GroupIndex) = h := by decide

theorem support_family_closed_row_59 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 59 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
