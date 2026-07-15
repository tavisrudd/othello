import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 15--19 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_15 : matrixDet 15 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_15 :
    ∀ p : PointIndex, matrixVec 15 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_16 : matrixDet 16 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_16 :
    ∀ p : PointIndex, matrixVec 16 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_17 : matrixDet 17 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_17 :
    ∀ p : PointIndex, matrixVec 17 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_18 : matrixDet 18 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_18 :
    ∀ p : PointIndex, matrixVec 18 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_19 : matrixDet 19 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_19 :
    ∀ p : PointIndex, matrixVec 19 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
