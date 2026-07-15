import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 50--54 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_50 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 50)).card = 6 := by decide

theorem supportPerm_injective_row_50 :
    ∀ h : GroupIndex, supportPerm 50 = supportPerm h → (50 : GroupIndex) = h := by decide

theorem support_family_closed_row_50 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 50 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_51 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 51)).card = 6 := by decide

theorem supportPerm_injective_row_51 :
    ∀ h : GroupIndex, supportPerm 51 = supportPerm h → (51 : GroupIndex) = h := by decide

theorem support_family_closed_row_51 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 51 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_52 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 52)).card = 6 := by decide

theorem supportPerm_injective_row_52 :
    ∀ h : GroupIndex, supportPerm 52 = supportPerm h → (52 : GroupIndex) = h := by decide

theorem support_family_closed_row_52 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 52 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_53 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 53)).card = 6 := by decide

theorem supportPerm_injective_row_53 :
    ∀ h : GroupIndex, supportPerm 53 = supportPerm h → (53 : GroupIndex) = h := by decide

theorem support_family_closed_row_53 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 53 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_54 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 54)).card = 6 := by decide

theorem supportPerm_injective_row_54 :
    ∀ h : GroupIndex, supportPerm 54 = supportPerm h → (54 : GroupIndex) = h := by decide

theorem support_family_closed_row_54 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 54 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
