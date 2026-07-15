import RelativeConicArcs.Q11A5PointOrbitsData

/-! Support-permutation rows 40--44 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

theorem supportPerm_permutation_row_40 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 40)).card = 6 := by decide

theorem supportPerm_injective_row_40 :
    ∀ h : GroupIndex, supportPerm 40 = supportPerm h → (40 : GroupIndex) = h := by decide

theorem support_family_closed_row_40 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 40 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_41 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 41)).card = 6 := by decide

theorem supportPerm_injective_row_41 :
    ∀ h : GroupIndex, supportPerm 41 = supportPerm h → (41 : GroupIndex) = h := by decide

theorem support_family_closed_row_41 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 41 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_42 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 42)).card = 6 := by decide

theorem supportPerm_injective_row_42 :
    ∀ h : GroupIndex, supportPerm 42 = supportPerm h → (42 : GroupIndex) = h := by decide

theorem support_family_closed_row_42 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 42 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_43 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 43)).card = 6 := by decide

theorem supportPerm_injective_row_43 :
    ∀ h : GroupIndex, supportPerm 43 = supportPerm h → (43 : GroupIndex) = h := by decide

theorem support_family_closed_row_43 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 43 (supportPerm h i) := by decide

theorem supportPerm_permutation_row_44 :
    ((Finset.univ : Finset (Fin 6)).image (supportPerm 44)).card = 6 := by decide

theorem supportPerm_injective_row_44 :
    ∀ h : GroupIndex, supportPerm 44 = supportPerm h → (44 : GroupIndex) = h := by decide

theorem support_family_closed_row_44 :
    ∀ h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm 44 (supportPerm h i) := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
