import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 0--4 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_0 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 0)).card = 6 := by decide

theorem supportPerm_injective_row_0 :
    ∀ h : GroupIndex, supportPerm 0 = supportPerm h → (0 : GroupIndex) = h := by decide

theorem support_family_closed_row_0 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 0 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_1 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 1)).card = 6 := by decide

theorem supportPerm_injective_row_1 :
    ∀ h : GroupIndex, supportPerm 1 = supportPerm h → (1 : GroupIndex) = h := by decide

theorem support_family_closed_row_1 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 1 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_2 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 2)).card = 6 := by decide

theorem supportPerm_injective_row_2 :
    ∀ h : GroupIndex, supportPerm 2 = supportPerm h → (2 : GroupIndex) = h := by decide

theorem support_family_closed_row_2 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 2 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_3 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 3)).card = 6 := by decide

theorem supportPerm_injective_row_3 :
    ∀ h : GroupIndex, supportPerm 3 = supportPerm h → (3 : GroupIndex) = h := by decide

theorem support_family_closed_row_3 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 3 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_4 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 4)).card = 6 := by decide

theorem supportPerm_injective_row_4 :
    ∀ h : GroupIndex, supportPerm 4 = supportPerm h → (4 : GroupIndex) = h := by decide

theorem support_family_closed_row_4 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 4 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
