import RelativeConicArcs.Q11A5PointOrbitsArithmetic

/-! Arithmetic row 2 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem action_on_witness_row_2 :
    ∀ i : Fin 6, pointAction 2 (witnessIndex i) = witnessIndex (supportPerm 2 i) := by
  intro i
  rw [pointAction_eq_fast]
  revert i
  decide

/-- Canonical point-action values for group row 2. -/
def pointActionCode_2 (p : PointIndex) : PointIndex :=
  ![
    103, 52, 68, 87, 17, 95, 25, 33, 60, 9, 129, 32,
    49, 35, 66, 63, 80, 4, 18, 124, 94, 108, 64, 48,
    90, 6, 69, 27, 126, 85, 43, 106, 11, 7, 53, 13,
    36, 127, 76, 88, 59, 105, 82, 30, 78, 45, 121, 56,
    23, 12, 67, 100, 1, 34, 89, 128, 47, 79, 97, 40,
    8, 104, 72, 15, 22, 65, 14, 50, 2, 26, 86, 99,
    62, 98, 74, 122, 38, 96, 44, 57, 16, 109, 42, 83,
    123, 29, 70, 3, 39, 54, 24, 107, 92, 125, 20, 5,
    77, 58, 73, 71, 51, 101, 131, 0, 61, 41, 31, 91,
    21, 81, 110, 132, 112, 117, 115, 114, 120, 113, 119, 118,
    116, 46, 75, 84, 19, 93, 28, 37, 55, 10, 130, 102,
    111
  ] p

/-- Numeric matrix normalization for group row 2, independent of orbit lookup. -/
theorem pointAction_eq_code_2 : ∀ p : PointIndex, pointAction 2 p = pointActionCode_2 p := by
  intro p
  rw [pointAction_eq_fast]
  revert p
  decide

/-- Pure table lookup: group row 2 preserves the orbit label. -/
theorem orbitIndex_code_2 : ∀ p : PointIndex, orbitIndex (pointActionCode_2 p) = orbitIndex p := by
  decide

theorem orbitIndex_pointAction_row_2 :
    ∀ p : PointIndex, orbitIndex (pointAction 2 p) = orbitIndex p := by
  intro p
  rw [pointAction_eq_code_2 p]
  exact orbitIndex_code_2 p

end RelativeConicArcs.Examples.Q11A5PointOrbits
