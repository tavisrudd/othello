import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 35--39 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_35 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 35)).card = 6 := by decide

theorem supportPerm_injective_row_35 :
    ∀ h : GroupIndex, supportPerm 35 = supportPerm h → (35 : GroupIndex) = h := by decide

theorem support_family_closed_row_35 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 35 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_36 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 36)).card = 6 := by decide

theorem supportPerm_injective_row_36 :
    ∀ h : GroupIndex, supportPerm 36 = supportPerm h → (36 : GroupIndex) = h := by decide

theorem support_family_closed_row_36 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 36 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_37 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 37)).card = 6 := by decide

theorem supportPerm_injective_row_37 :
    ∀ h : GroupIndex, supportPerm 37 = supportPerm h → (37 : GroupIndex) = h := by decide

theorem support_family_closed_row_37 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 37 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_38 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 38)).card = 6 := by decide

theorem supportPerm_injective_row_38 :
    ∀ h : GroupIndex, supportPerm 38 = supportPerm h → (38 : GroupIndex) = h := by decide

theorem support_family_closed_row_38 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 38 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_39 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 39)).card = 6 := by decide

theorem supportPerm_injective_row_39 :
    ∀ h : GroupIndex, supportPerm 39 = supportPerm h → (39 : GroupIndex) = h := by decide

theorem support_family_closed_row_39 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 39 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
