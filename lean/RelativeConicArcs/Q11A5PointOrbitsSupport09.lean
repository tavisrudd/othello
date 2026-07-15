import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 45--49 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_45 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 45)).card = 6 := by decide

theorem supportPerm_injective_row_45 :
    ∀ h : GroupIndex, supportPerm 45 = supportPerm h → (45 : GroupIndex) = h := by decide

theorem support_family_closed_row_45 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 45 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_46 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 46)).card = 6 := by decide

theorem supportPerm_injective_row_46 :
    ∀ h : GroupIndex, supportPerm 46 = supportPerm h → (46 : GroupIndex) = h := by decide

theorem support_family_closed_row_46 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 46 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_47 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 47)).card = 6 := by decide

theorem supportPerm_injective_row_47 :
    ∀ h : GroupIndex, supportPerm 47 = supportPerm h → (47 : GroupIndex) = h := by decide

theorem support_family_closed_row_47 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 47 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_48 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 48)).card = 6 := by decide

theorem supportPerm_injective_row_48 :
    ∀ h : GroupIndex, supportPerm 48 = supportPerm h → (48 : GroupIndex) = h := by decide

theorem support_family_closed_row_48 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 48 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_49 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 49)).card = 6 := by decide

theorem supportPerm_injective_row_49 :
    ∀ h : GroupIndex, supportPerm 49 = supportPerm h → (49 : GroupIndex) = h := by decide

theorem support_family_closed_row_49 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 49 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
