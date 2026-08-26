import RelativeConicArcs.ClebschWeightedJacobian

/-!
# The full weighted Jacobian at the positive golden representative

The twenty cubic equality equations are differentiated in the fifteen edge
coordinates, ordered lexicographically.  After dividing every row by the
common factor two, their exact integer Jacobian is the matrix below.  Direct
rational elimination proves that its kernel is precisely the scaling line.

The table is the full calculation whose order-three fixed-space reduction is
recorded in `ClebschWeightedJacobian`.
-/

namespace RelativeConicArcs.ClebschWeightedJacobianFull

open Matrix

/-- The positive golden conference representative in lexicographic edge
coordinates `(01,02,03,04,05,12,13,14,15,23,24,25,34,35,45)`. -/
def scalingDirection : Fin 15 → ℚ :=
  ![1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 1, -1, -1, 1, 1]

/-- The primitive twenty-by-fifteen weighted Jacobian.  Rows are indexed by
the lexicographically ordered triples of six labels. -/
def jacobianMatrix : Matrix (Fin 20) (Fin 15) ℚ :=
  ![![-2, -2,  1,  1,  0, -2,  1,  0, -1,  0,  1, -1,  0,  0,  0],
    ![-2,  1, -2,  0,  1,  1, -2, -1,  0,  0,  0,  0, -1,  1,  0],
    ![ 2,  0, -1,  2, -1, -1,  0, -2,  1,  0, -1,  0,  1,  0,  0],
    ![ 2, -1,  0, -1,  2,  0, -1,  1, -2,  0,  0,  1,  0, -1,  0],
    ![ 0,  2,  2, -1, -1, -1, -1,  0,  0, -2,  0,  1,  1,  0,  0],
    ![ 1, -2,  0, -2,  1,  1,  0,  0,  0, -1, -2,  0, -1,  0,  1],
    ![-1,  2, -1,  0,  2,  0,  0,  0,  1,  1, -1, -2,  0,  0, -1],
    ![-1, -1,  2,  2,  0,  0,  0,  1,  0,  1,  0,  0, -2, -1, -1],
    ![ 1,  0, -2,  1, -2,  0,  1,  0,  0, -1,  0, -1,  0, -2,  1],
    ![ 0,  1,  1, -2, -2,  0,  0, -1, -1,  0,  1,  0,  0,  1, -2],
    ![ 0, -1, -1,  0,  0,  2,  2,  1,  1, -2, -1,  0,  0, -1,  0],
    ![-1,  0,  0, -1,  0,  2, -1, -2,  0,  1,  2,  1,  0,  0, -1],
    ![ 1,  1,  0,  0,  0, -2,  0, -1,  2, -1,  0,  2,  0,  1,  1],
    ![ 1,  0,  1,  0,  0,  0, -2,  2, -1, -1,  1,  0,  2,  0,  1],
    ![-1,  0,  0,  0, -1, -1,  2,  0, -2,  1,  0,  0,  1,  2, -1],
    ![ 0,  0,  0,  1,  1,  1,  1,  2,  2,  0,  0, -1, -1,  0, -2],
    ![ 0,  1,  0,  1,  0,  0,  1, -1,  0,  2, -2, -1,  2,  1,  0],
    ![ 0,  0,  1,  0,  1,  1,  0,  0, -1,  2,  1,  2, -1, -2,  0],
    ![ 0, -1,  0,  0, -1, -1,  0,  1,  0,  0,  2, -2,  1, -1,  2],
    ![ 0,  0, -1, -1,  0,  0, -1,  0,  1,  0, -1,  1, -2,  2,  2]]

/-- The full primitive Jacobian as a rational linear map. -/
def jacobian : (Fin 15 → ℚ) →ₗ[ℚ] (Fin 20 → ℚ) :=
  Matrix.toLin' jacobianMatrix

/-- Homogeneity places the golden representative in the full kernel. -/
theorem jacobian_scalingDirection : jacobian scalingDirection = 0 := by
  ext i
  fin_cases i <;>
    norm_num [jacobian, jacobianMatrix, scalingDirection, Matrix.toLin'_apply,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ]

/-- The full twenty-by-fifteen Jacobian has exactly the scaling line as its
kernel; equivalently, it has rational rank fourteen. -/
theorem jacobian_ker :
    LinearMap.ker jacobian = ℚ ∙ scalingDirection := by
  ext x
  rw [LinearMap.mem_ker, Submodule.mem_span_singleton]
  constructor
  · intro hx
    have h₀ := congrFun hx 0
    have h₁ := congrFun hx 1
    have h₂ := congrFun hx 2
    have h₃ := congrFun hx 3
    have h₄ := congrFun hx 4
    have h₅ := congrFun hx 5
    have h₆ := congrFun hx 6
    have h₇ := congrFun hx 7
    have h₈ := congrFun hx 8
    have h₉ := congrFun hx 9
    have h₁₀ := congrFun hx 10
    have h₁₁ := congrFun hx 11
    have h₁₂ := congrFun hx 12
    have h₁₃ := congrFun hx 13
    simp [jacobian, jacobianMatrix, Matrix.toLin'_apply, Matrix.mulVec,
      dotProduct, Fin.sum_univ_succ] at h₀ h₁ h₂ h₃ h₄ h₅ h₆
    simp [jacobian, jacobianMatrix, Matrix.toLin'_apply, Matrix.mulVec,
      dotProduct, Fin.sum_univ_succ] at h₇ h₈ h₉ h₁₀ h₁₁ h₁₂ h₁₃
    have hx₀ : x 0 = x 14 := by linarith
    have hx₁ : x 1 = x 14 := by linarith
    have hx₂ : x 2 = x 14 := by linarith
    have hx₃ : x 3 = x 14 := by linarith
    have hx₄ : x 4 = x 14 := by linarith
    have hx₅ : x 5 = x 14 := by linarith
    have hx₆ : x 6 = x 14 := by linarith
    have hx₇ : x 7 = -x 14 := by linarith
    have hx₈ : x 8 = -x 14 := by linarith
    have hx₉ : x 9 = -x 14 := by linarith
    have hx₁₀ : x 10 = x 14 := by linarith
    have hx₁₁ : x 11 = -x 14 := by linarith
    have hx₁₂ : x 12 = -x 14 := by linarith
    have hx₁₃ : x 13 = x 14 := by linarith
    refine ⟨x 14, ?_⟩
    ext i
    fin_cases i <;>
      simp [scalingDirection, hx₀, hx₁, hx₂, hx₃, hx₄, hx₅, hx₆, hx₇,
        hx₈, hx₉, hx₁₀, hx₁₁, hx₁₂, hx₁₃, Matrix.cons_val_two,
        Matrix.cons_val_three, Matrix.cons_val_four]
  · rintro ⟨c, rfl⟩
    simp [jacobian_scalingDirection]

end RelativeConicArcs.ClebschWeightedJacobianFull
