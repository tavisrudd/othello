import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 25--29 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_25 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 25)).card = 6 := by decide

theorem supportPerm_injective_row_25 :
    ∀ h : GroupIndex, supportPerm 25 = supportPerm h → (25 : GroupIndex) = h := by decide

theorem support_family_closed_row_25 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 25 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_26 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 26)).card = 6 := by decide

theorem supportPerm_injective_row_26 :
    ∀ h : GroupIndex, supportPerm 26 = supportPerm h → (26 : GroupIndex) = h := by decide

theorem support_family_closed_row_26 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 26 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_27 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 27)).card = 6 := by decide

theorem supportPerm_injective_row_27 :
    ∀ h : GroupIndex, supportPerm 27 = supportPerm h → (27 : GroupIndex) = h := by decide

theorem support_family_closed_row_27 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 27 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_28 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 28)).card = 6 := by decide

theorem supportPerm_injective_row_28 :
    ∀ h : GroupIndex, supportPerm 28 = supportPerm h → (28 : GroupIndex) = h := by decide

theorem support_family_closed_row_28 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 28 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_29 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 29)).card = 6 := by decide

theorem supportPerm_injective_row_29 :
    ∀ h : GroupIndex, supportPerm 29 = supportPerm h → (29 : GroupIndex) = h := by decide

theorem support_family_closed_row_29 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 29 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
