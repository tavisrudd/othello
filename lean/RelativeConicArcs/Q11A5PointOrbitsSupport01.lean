import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 5--9 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_5 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 5)).card = 6 := by decide

theorem supportPerm_injective_row_5 :
    ∀ h : GroupIndex, supportPerm 5 = supportPerm h → (5 : GroupIndex) = h := by decide

theorem support_family_closed_row_5 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 5 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_6 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 6)).card = 6 := by decide

theorem supportPerm_injective_row_6 :
    ∀ h : GroupIndex, supportPerm 6 = supportPerm h → (6 : GroupIndex) = h := by decide

theorem support_family_closed_row_6 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 6 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_7 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 7)).card = 6 := by decide

theorem supportPerm_injective_row_7 :
    ∀ h : GroupIndex, supportPerm 7 = supportPerm h → (7 : GroupIndex) = h := by decide

theorem support_family_closed_row_7 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 7 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_8 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 8)).card = 6 := by decide

theorem supportPerm_injective_row_8 :
    ∀ h : GroupIndex, supportPerm 8 = supportPerm h → (8 : GroupIndex) = h := by decide

theorem support_family_closed_row_8 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 8 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_9 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 9)).card = 6 := by decide

theorem supportPerm_injective_row_9 :
    ∀ h : GroupIndex, supportPerm 9 = supportPerm h → (9 : GroupIndex) = h := by decide

theorem support_family_closed_row_9 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 9 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
