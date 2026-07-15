import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 20--24 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_20 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 20)).card = 6 := by decide

theorem supportPerm_injective_row_20 :
    ∀ h : GroupIndex, supportPerm 20 = supportPerm h → (20 : GroupIndex) = h := by decide

theorem support_family_closed_row_20 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 20 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_21 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 21)).card = 6 := by decide

theorem supportPerm_injective_row_21 :
    ∀ h : GroupIndex, supportPerm 21 = supportPerm h → (21 : GroupIndex) = h := by decide

theorem support_family_closed_row_21 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 21 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_22 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 22)).card = 6 := by decide

theorem supportPerm_injective_row_22 :
    ∀ h : GroupIndex, supportPerm 22 = supportPerm h → (22 : GroupIndex) = h := by decide

theorem support_family_closed_row_22 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 22 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_23 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 23)).card = 6 := by decide

theorem supportPerm_injective_row_23 :
    ∀ h : GroupIndex, supportPerm 23 = supportPerm h → (23 : GroupIndex) = h := by decide

theorem support_family_closed_row_23 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 23 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_24 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 24)).card = 6 := by decide

theorem supportPerm_injective_row_24 :
    ∀ h : GroupIndex, supportPerm 24 = supportPerm h → (24 : GroupIndex) = h := by decide

theorem support_family_closed_row_24 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 24 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
