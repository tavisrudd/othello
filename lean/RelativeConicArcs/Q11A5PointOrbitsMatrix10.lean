import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 50--54 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_50 : matrixDet 50 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_50 :
    ∀ p : PointIndex, matrixVec 50 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_51 : matrixDet 51 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_51 :
    ∀ p : PointIndex, matrixVec 51 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_52 : matrixDet 52 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_52 :
    ∀ p : PointIndex, matrixVec 52 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_53 : matrixDet 53 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_53 :
    ∀ p : PointIndex, matrixVec 53 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_54 : matrixDet 54 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_54 :
    ∀ p : PointIndex, matrixVec 54 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
