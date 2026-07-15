import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 55--59 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_55 : matrixDet 55 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_55 :
    ∀ p : PointIndex, matrixVec 55 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_56 : matrixDet 56 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_56 :
    ∀ p : PointIndex, matrixVec 56 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_57 : matrixDet 57 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_57 :
    ∀ p : PointIndex, matrixVec 57 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_58 : matrixDet 58 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_58 :
    ∀ p : PointIndex, matrixVec 58 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_59 : matrixDet 59 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_59 :
    ∀ p : PointIndex, matrixVec 59 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
