import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 25--29 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_25 : matrixDet 25 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_25 :
    ∀ p : PointIndex, matrixVec 25 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_26 : matrixDet 26 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_26 :
    ∀ p : PointIndex, matrixVec 26 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_27 : matrixDet 27 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_27 :
    ∀ p : PointIndex, matrixVec 27 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_28 : matrixDet 28 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_28 :
    ∀ p : PointIndex, matrixVec 28 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_29 : matrixDet 29 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_29 :
    ∀ p : PointIndex, matrixVec 29 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
