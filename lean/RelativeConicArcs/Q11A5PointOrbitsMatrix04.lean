import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 20--24 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_20 : matrixDet 20 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_20 :
    ∀ p : PointIndex, matrixVec 20 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_21 : matrixDet 21 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_21 :
    ∀ p : PointIndex, matrixVec 21 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_22 : matrixDet 22 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_22 :
    ∀ p : PointIndex, matrixVec 22 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_23 : matrixDet 23 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_23 :
    ∀ p : PointIndex, matrixVec 23 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_24 : matrixDet 24 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_24 :
    ∀ p : PointIndex, matrixVec 24 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
