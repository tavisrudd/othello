import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 30--34 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_30 : matrixDet 30 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_30 :
    ∀ p : PointIndex, matrixVec 30 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_31 : matrixDet 31 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_31 :
    ∀ p : PointIndex, matrixVec 31 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_32 : matrixDet 32 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_32 :
    ∀ p : PointIndex, matrixVec 32 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_33 : matrixDet 33 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_33 :
    ∀ p : PointIndex, matrixVec 33 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_34 : matrixDet 34 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_34 :
    ∀ p : PointIndex, matrixVec 34 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
