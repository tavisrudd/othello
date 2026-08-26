import RelativeConicArcs.ClebschWeightedJacobianFull

/-!
# Identification of the full weighted Jacobian

This module connects the primitive integer table to the actual cubic equality
coefficients.  A symmetric zero-diagonal matrix is parametrized by its fifteen
lexicographically ordered edge coordinates.  The twenty triangle and Hodge
third-compound coefficients are written directly, and their algebraic
directional derivative at the positive golden representative is proved to be
twice the primitive table.
-/

namespace RelativeConicArcs.ClebschWeightedJacobianActual

open Matrix
open ClebschWeightedJacobianFull

/-- A symmetric zero-diagonal order-six matrix from lexicographic edge
coordinates. -/
def edgeMatrix (x : Fin 15 → ℚ) : Matrix (Fin 6) (Fin 6) ℚ :=
  !![0, x 0, x 1, x 2, x 3, x 4;
     x 0, 0, x 5, x 6, x 7, x 8;
     x 1, x 5, 0, x 9, x 10, x 11;
     x 2, x 6, x 9, 0, x 12, x 13;
     x 3, x 7, x 10, x 12, 0, x 14;
     x 4, x 8, x 11, x 13, x 14, 0]

/-- The positive golden representative. -/
def goldenMatrix : Matrix (Fin 6) (Fin 6) ℚ := edgeMatrix scalingDirection

/-- A displayed three-by-three determinant. -/
def det3 (C : Matrix (Fin 6) (Fin 6) ℚ)
    (a b c i j k : Fin 6) : ℚ :=
  C a i * C b j * C c k + C a j * C b k * C c i + C a k * C b i * C c j -
    C a k * C b j * C c i - C a j * C b i * C c k - C a i * C b k * C c j

/-- The Hodge third-compound coefficients, in lexicographic triple order. -/
def compoundCoefficients (C : Matrix (Fin 6) (Fin 6) ℚ) : Fin 20 → ℚ :=
  ![ det3 C 3 4 5 0 1 2,
    -det3 C 2 4 5 0 1 3,
     det3 C 2 3 5 0 1 4,
    -det3 C 2 3 4 0 1 5,
     det3 C 1 4 5 0 2 3,
    -det3 C 1 3 5 0 2 4,
     det3 C 1 3 4 0 2 5,
     det3 C 1 2 5 0 3 4,
    -det3 C 1 2 4 0 3 5,
     det3 C 1 2 3 0 4 5,
    -det3 C 0 4 5 1 2 3,
     det3 C 0 3 5 1 2 4,
    -det3 C 0 3 4 1 2 5,
    -det3 C 0 2 5 1 3 4,
     det3 C 0 2 4 1 3 5,
    -det3 C 0 2 3 1 4 5,
     det3 C 0 1 5 2 3 4,
    -det3 C 0 1 4 2 3 5,
     det3 C 0 1 3 2 4 5,
    -det3 C 0 1 2 3 4 5]

/-- The twenty triangle products, in the same triple order. -/
def triangleCoefficients (C : Matrix (Fin 6) (Fin 6) ℚ) : Fin 20 → ℚ :=
  ![C 0 1 * C 1 2 * C 2 0, C 0 1 * C 1 3 * C 3 0,
    C 0 1 * C 1 4 * C 4 0, C 0 1 * C 1 5 * C 5 0,
    C 0 2 * C 2 3 * C 3 0, C 0 2 * C 2 4 * C 4 0,
    C 0 2 * C 2 5 * C 5 0, C 0 3 * C 3 4 * C 4 0,
    C 0 3 * C 3 5 * C 5 0, C 0 4 * C 4 5 * C 5 0,
    C 1 2 * C 2 3 * C 3 1, C 1 2 * C 2 4 * C 4 1,
    C 1 2 * C 2 5 * C 5 1, C 1 3 * C 3 4 * C 4 1,
    C 1 3 * C 3 5 * C 5 1, C 1 4 * C 4 5 * C 5 1,
    C 2 3 * C 3 4 * C 4 2, C 2 3 * C 3 5 * C 5 2,
    C 2 4 * C 4 5 * C 5 2, C 3 4 * C 4 5 * C 5 3]

/-- The positive oriented cubic equality coefficients `h - 4 tau`. -/
def equalityCoefficients (C : Matrix (Fin 6) (Fin 6) ℚ) : Fin 20 → ℚ :=
  compoundCoefficients C - 4 • triangleCoefficients C

/-- Algebraic directional derivative of the cubic equality at the positive
golden representative.  For a homogeneous cubic `f`, the polarization formula
`(f(A+X)-f(A-X))/2-f(X)` is its derivative at `A` along `X`. -/
def actualDirectionalDerivative (x : Fin 15 → ℚ) : Fin 20 → ℚ := fun r =>
    (equalityCoefficients (goldenMatrix + edgeMatrix x) r -
      equalityCoefficients (goldenMatrix - edgeMatrix x) r) / 2 -
      equalityCoefficients (edgeMatrix x) r

/-- The actual cubic equality Jacobian, normalized as twice the primitive
integer table. -/
def actualJacobian : (Fin 15 → ℚ) →ₗ[ℚ] (Fin 20 → ℚ) :=
  2 • ClebschWeightedJacobianFull.jacobian

local macro "prove_jacobian_row" : tactic =>
  `(tactic|
    simp [actualDirectionalDerivative, actualJacobian, equalityCoefficients,
      compoundCoefficients, triangleCoefficients, goldenMatrix, edgeMatrix,
      scalingDirection, det3, ClebschWeightedJacobianFull.jacobian,
      ClebschWeightedJacobianFull.jacobianMatrix, Matrix.toLin'_apply,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> ring)

private theorem actualDirectionalDerivative_eq_row0 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 0 = actualJacobian x 0 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row1 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 1 = actualJacobian x 1 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row2 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 2 = actualJacobian x 2 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row3 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 3 = actualJacobian x 3 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row4 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 4 = actualJacobian x 4 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row5 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 5 = actualJacobian x 5 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row6 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 6 = actualJacobian x 6 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row7 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 7 = actualJacobian x 7 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row8 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 8 = actualJacobian x 8 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row9 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 9 = actualJacobian x 9 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row10 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 10 = actualJacobian x 10 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row11 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 11 = actualJacobian x 11 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row12 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 12 = actualJacobian x 12 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row13 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 13 = actualJacobian x 13 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row14 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 14 = actualJacobian x 14 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row15 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 15 = actualJacobian x 15 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row16 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 16 = actualJacobian x 16 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row17 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 17 = actualJacobian x 17 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row18 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 18 = actualJacobian x 18 := by prove_jacobian_row
private theorem actualDirectionalDerivative_eq_row19 (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x 19 = actualJacobian x 19 := by prove_jacobian_row

/-- The polarization derivative of the displayed cubic coefficients agrees
with the actual Jacobian linear map. -/
theorem actualDirectionalDerivative_eq (x : Fin 15 → ℚ) :
    actualDirectionalDerivative x = actualJacobian x := by
  ext r
  fin_cases r
  all_goals first
    | exact actualDirectionalDerivative_eq_row0 x
    | exact actualDirectionalDerivative_eq_row1 x
    | exact actualDirectionalDerivative_eq_row2 x
    | exact actualDirectionalDerivative_eq_row3 x
    | exact actualDirectionalDerivative_eq_row4 x
    | exact actualDirectionalDerivative_eq_row5 x
    | exact actualDirectionalDerivative_eq_row6 x
    | exact actualDirectionalDerivative_eq_row7 x
    | exact actualDirectionalDerivative_eq_row8 x
    | exact actualDirectionalDerivative_eq_row9 x
    | exact actualDirectionalDerivative_eq_row10 x
    | exact actualDirectionalDerivative_eq_row11 x
    | exact actualDirectionalDerivative_eq_row12 x
    | exact actualDirectionalDerivative_eq_row13 x
    | exact actualDirectionalDerivative_eq_row14 x
    | exact actualDirectionalDerivative_eq_row15 x
    | exact actualDirectionalDerivative_eq_row16 x
    | exact actualDirectionalDerivative_eq_row17 x
    | exact actualDirectionalDerivative_eq_row18 x
    | exact actualDirectionalDerivative_eq_row19 x

/-- Consequently the actual cubic equality Jacobian has exactly the scaling
line as kernel. -/
theorem actualJacobian_ker :
    LinearMap.ker actualJacobian = ℚ ∙ scalingDirection := by
  ext x
  rw [← ClebschWeightedJacobianFull.jacobian_ker]
  rw [LinearMap.mem_ker, LinearMap.mem_ker]
  change ((2 : ℚ) • ClebschWeightedJacobianFull.jacobian x = 0 ↔
    ClebschWeightedJacobianFull.jacobian x = 0)
  constructor
  · intro hx
    exact (smul_eq_zero.mp hx).resolve_left (by norm_num)
  · intro hx
    simp [hx]

/-- Negate the ten inner-edge coordinates while fixing the five root edges. -/
def flipInnerEdges : (Fin 15 → ℚ) ≃ₗ[ℚ] (Fin 15 → ℚ) where
  toFun x :=
    ![x 0, x 1, x 2, x 3, x 4, -x 5, -x 6, -x 7, -x 8, -x 9,
      -x 10, -x 11, -x 12, -x 13, -x 14]
  invFun x :=
    ![x 0, x 1, x 2, x 3, x 4, -x 5, -x 6, -x 7, -x 8, -x 9,
      -x 10, -x 11, -x 12, -x 13, -x 14]
  left_inv x := by ext i; fin_cases i <;> simp
  right_inv x := by ext i; fin_cases i <;> simp
  map_add' x y := by ext i; fin_cases i <;> simp <;> ring
  map_smul' c x := by ext i; fin_cases i <;> simp

/-- The opposite oriented golden representative in edge coordinates. -/
def negativeScalingDirection : Fin 15 → ℚ :=
  flipInnerEdges.symm scalingDirection

/-- The primitive Jacobian at the opposite representative is obtained by the
inner-edge coordinate involution. -/
def negativeJacobian : (Fin 15 → ℚ) →ₗ[ℚ] (Fin 20 → ℚ) :=
  ClebschWeightedJacobianFull.jacobian.comp flipInnerEdges.toLinearMap

/-- The opposite primitive Jacobian again has exactly its scaling line as
kernel. -/
theorem negativeJacobian_ker :
    LinearMap.ker negativeJacobian = ℚ ∙ negativeScalingDirection := by
  ext x
  rw [LinearMap.mem_ker, Submodule.mem_span_singleton]
  change ClebschWeightedJacobianFull.jacobian (flipInnerEdges x) = 0 ↔ _
  constructor
  · intro hx
    have hf : flipInnerEdges x ∈
        LinearMap.ker ClebschWeightedJacobianFull.jacobian := hx
    rw [ClebschWeightedJacobianFull.jacobian_ker,
      Submodule.mem_span_singleton] at hf
    rcases hf with ⟨c, hc⟩
    refine ⟨c, ?_⟩
    have := congrArg flipInnerEdges.symm hc
    simpa [negativeScalingDirection] using this
  · rintro ⟨c, rfl⟩
    simp [negativeScalingDirection,
      ClebschWeightedJacobianFull.jacobian_scalingDirection]

/-- The opposite golden matrix. -/
def negativeGoldenMatrix : Matrix (Fin 6) (Fin 6) ℚ :=
  edgeMatrix negativeScalingDirection

/-- The negative oriented equality coefficients `h + 4 tau`. -/
def negativeEqualityCoefficients (C : Matrix (Fin 6) (Fin 6) ℚ) : Fin 20 → ℚ :=
  compoundCoefficients C + 4 • triangleCoefficients C

/-- Algebraic directional derivative at the opposite oriented golden
representative. -/
def negativeDirectionalDerivative (x : Fin 15 → ℚ) : Fin 20 → ℚ := fun r =>
  (negativeEqualityCoefficients (negativeGoldenMatrix + edgeMatrix x) r -
    negativeEqualityCoefficients (negativeGoldenMatrix - edgeMatrix x) r) / 2 -
    negativeEqualityCoefficients (edgeMatrix x) r

/-- The actual opposite-oriented Jacobian. -/
def actualNegativeJacobian : (Fin 15 → ℚ) →ₗ[ℚ] (Fin 20 → ℚ) :=
  2 • negativeJacobian

local macro "prove_negative_jacobian_row" : tactic =>
  `(tactic|
    simp [negativeDirectionalDerivative, actualNegativeJacobian,
      negativeEqualityCoefficients, negativeGoldenMatrix,
      negativeScalingDirection, negativeJacobian, flipInnerEdges,
      equalityCoefficients, compoundCoefficients, triangleCoefficients,
      goldenMatrix, edgeMatrix, scalingDirection, det3,
      ClebschWeightedJacobianFull.jacobian,
      ClebschWeightedJacobianFull.jacobianMatrix, Matrix.toLin'_apply,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> ring)

private theorem negativeDirectionalDerivative_eq_row0 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 0 = actualNegativeJacobian x 0 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row1 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 1 = actualNegativeJacobian x 1 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row2 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 2 = actualNegativeJacobian x 2 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row3 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 3 = actualNegativeJacobian x 3 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row4 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 4 = actualNegativeJacobian x 4 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row5 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 5 = actualNegativeJacobian x 5 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row6 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 6 = actualNegativeJacobian x 6 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row7 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 7 = actualNegativeJacobian x 7 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row8 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 8 = actualNegativeJacobian x 8 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row9 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 9 = actualNegativeJacobian x 9 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row10 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 10 = actualNegativeJacobian x 10 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row11 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 11 = actualNegativeJacobian x 11 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row12 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 12 = actualNegativeJacobian x 12 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row13 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 13 = actualNegativeJacobian x 13 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row14 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 14 = actualNegativeJacobian x 14 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row15 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 15 = actualNegativeJacobian x 15 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row16 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 16 = actualNegativeJacobian x 16 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row17 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 17 = actualNegativeJacobian x 17 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row18 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 18 = actualNegativeJacobian x 18 := by prove_negative_jacobian_row
private theorem negativeDirectionalDerivative_eq_row19 (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x 19 = actualNegativeJacobian x 19 := by prove_negative_jacobian_row

/-- The displayed negative cubic derivative agrees with the opposite-oriented
Jacobian linear map. -/
theorem negativeDirectionalDerivative_eq (x : Fin 15 → ℚ) :
    negativeDirectionalDerivative x = actualNegativeJacobian x := by
  ext r
  fin_cases r
  all_goals first
    | exact negativeDirectionalDerivative_eq_row0 x
    | exact negativeDirectionalDerivative_eq_row1 x
    | exact negativeDirectionalDerivative_eq_row2 x
    | exact negativeDirectionalDerivative_eq_row3 x
    | exact negativeDirectionalDerivative_eq_row4 x
    | exact negativeDirectionalDerivative_eq_row5 x
    | exact negativeDirectionalDerivative_eq_row6 x
    | exact negativeDirectionalDerivative_eq_row7 x
    | exact negativeDirectionalDerivative_eq_row8 x
    | exact negativeDirectionalDerivative_eq_row9 x
    | exact negativeDirectionalDerivative_eq_row10 x
    | exact negativeDirectionalDerivative_eq_row11 x
    | exact negativeDirectionalDerivative_eq_row12 x
    | exact negativeDirectionalDerivative_eq_row13 x
    | exact negativeDirectionalDerivative_eq_row14 x
    | exact negativeDirectionalDerivative_eq_row15 x
    | exact negativeDirectionalDerivative_eq_row16 x
    | exact negativeDirectionalDerivative_eq_row17 x
    | exact negativeDirectionalDerivative_eq_row18 x
    | exact negativeDirectionalDerivative_eq_row19 x

/-- The actual opposite-oriented cubic equality Jacobian has exactly the
opposite scaling line as kernel. -/
theorem actualNegativeJacobian_ker :
    LinearMap.ker actualNegativeJacobian = ℚ ∙ negativeScalingDirection := by
  ext x
  rw [← negativeJacobian_ker, LinearMap.mem_ker, LinearMap.mem_ker]
  change ((2 : ℚ) • negativeJacobian x = 0 ↔ negativeJacobian x = 0)
  constructor
  · intro hx
    exact (smul_eq_zero.mp hx).resolve_left (by norm_num)
  · intro hx
    simp [hx]

end RelativeConicArcs.ClebschWeightedJacobianActual
