import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 30--34 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_30 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 30)).card = 6 := by decide

theorem supportPerm_injective_row_30 :
    ∀ h : GroupIndex, supportPerm 30 = supportPerm h → (30 : GroupIndex) = h := by decide

theorem support_family_closed_row_30 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 30 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_31 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 31)).card = 6 := by decide

theorem supportPerm_injective_row_31 :
    ∀ h : GroupIndex, supportPerm 31 = supportPerm h → (31 : GroupIndex) = h := by decide

theorem support_family_closed_row_31 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 31 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_32 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 32)).card = 6 := by decide

theorem supportPerm_injective_row_32 :
    ∀ h : GroupIndex, supportPerm 32 = supportPerm h → (32 : GroupIndex) = h := by decide

theorem support_family_closed_row_32 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 32 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_33 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 33)).card = 6 := by decide

theorem supportPerm_injective_row_33 :
    ∀ h : GroupIndex, supportPerm 33 = supportPerm h → (33 : GroupIndex) = h := by decide

theorem support_family_closed_row_33 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 33 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_34 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 34)).card = 6 := by decide

theorem supportPerm_injective_row_34 :
    ∀ h : GroupIndex, supportPerm 34 = supportPerm h → (34 : GroupIndex) = h := by decide

theorem support_family_closed_row_34 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 34 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
