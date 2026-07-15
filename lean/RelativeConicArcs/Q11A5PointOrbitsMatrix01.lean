import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 5--9 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_5 : matrixDet 5 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_5 :
    ∀ p : PointIndex, matrixVec 5 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_6 : matrixDet 6 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_6 :
    ∀ p : PointIndex, matrixVec 6 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_7 : matrixDet 7 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_7 :
    ∀ p : PointIndex, matrixVec 7 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_8 : matrixDet 8 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_8 :
    ∀ p : PointIndex, matrixVec 8 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_9 : matrixDet 9 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_9 :
    ∀ p : PointIndex, matrixVec 9 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
