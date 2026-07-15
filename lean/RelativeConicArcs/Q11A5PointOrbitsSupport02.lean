import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 10--14 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_10 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 10)).card = 6 := by decide

theorem supportPerm_injective_row_10 :
    ∀ h : GroupIndex, supportPerm 10 = supportPerm h → (10 : GroupIndex) = h := by decide

theorem support_family_closed_row_10 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 10 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_11 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 11)).card = 6 := by decide

theorem supportPerm_injective_row_11 :
    ∀ h : GroupIndex, supportPerm 11 = supportPerm h → (11 : GroupIndex) = h := by decide

theorem support_family_closed_row_11 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 11 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_12 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 12)).card = 6 := by decide

theorem supportPerm_injective_row_12 :
    ∀ h : GroupIndex, supportPerm 12 = supportPerm h → (12 : GroupIndex) = h := by decide

theorem support_family_closed_row_12 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 12 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_13 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 13)).card = 6 := by decide

theorem supportPerm_injective_row_13 :
    ∀ h : GroupIndex, supportPerm 13 = supportPerm h → (13 : GroupIndex) = h := by decide

theorem support_family_closed_row_13 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 13 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_14 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 14)).card = 6 := by decide

theorem supportPerm_injective_row_14 :
    ∀ h : GroupIndex, supportPerm 14 = supportPerm h → (14 : GroupIndex) = h := by decide

theorem support_family_closed_row_14 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 14 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
