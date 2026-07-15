import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 15--19 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_15 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 15)).card = 6 := by decide

theorem supportPerm_injective_row_15 :
    ∀ h : GroupIndex, supportPerm 15 = supportPerm h → (15 : GroupIndex) = h := by decide

theorem support_family_closed_row_15 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 15 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_16 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 16)).card = 6 := by decide

theorem supportPerm_injective_row_16 :
    ∀ h : GroupIndex, supportPerm 16 = supportPerm h → (16 : GroupIndex) = h := by decide

theorem support_family_closed_row_16 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 16 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_17 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 17)).card = 6 := by decide

theorem supportPerm_injective_row_17 :
    ∀ h : GroupIndex, supportPerm 17 = supportPerm h → (17 : GroupIndex) = h := by decide

theorem support_family_closed_row_17 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 17 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_18 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 18)).card = 6 := by decide

theorem supportPerm_injective_row_18 :
    ∀ h : GroupIndex, supportPerm 18 = supportPerm h → (18 : GroupIndex) = h := by decide

theorem support_family_closed_row_18 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 18 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_19 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 19)).card = 6 := by decide

theorem supportPerm_injective_row_19 :
    ∀ h : GroupIndex, supportPerm 19 = supportPerm h → (19 : GroupIndex) = h := by decide

theorem support_family_closed_row_19 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 19 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
