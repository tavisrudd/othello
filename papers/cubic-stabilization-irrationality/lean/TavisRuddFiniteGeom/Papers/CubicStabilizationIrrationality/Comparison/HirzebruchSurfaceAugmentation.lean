import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

/-!
# Degree-zero visibility for the first Hirzebruch surface

Reichelt, Schulze, Sevenheck, and Walther, *Algebraic aspects of
hypergeometric differential equations* (2021),
DOI 10.1007/s13366-020-00560-1, Example 5.1, give the small quantum
multiplication table of the first Hirzebruch surface in the ordered basis
\((1,T_1,T_2,[\mathrm{pt}])\).  Multiplication by \(T_1\) is

\[
 (a,b,c,d)\longmapsto
 (q_1q_2d,\ a-q_1b,\ q_1b,\ c).
\]

The theorem below proves that, when both Novikov parameters are nonzero, every
nonzero eigenvector of this operator has nonzero degree-zero coordinate.  The
module also proves the operator polynomial relation and that its exceptional
root at zero second parameter is simple.  The proofs are symbolic and
kernel-checked.  The cited multiplication table, its identification with the
quantum cohomology of the geometric surface, and any Hensel or deck-action
interpretation remain external inputs.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.HirzebruchSurfaceAugmentation

open TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

/-- Coordinates in the ordered basis \((1,T_1,T_2,[\mathrm{pt}])\). -/
abbrev State (K : Type*) := Fin 4 → K

/-- Small quantum multiplication by \(T_1\) in the displayed basis. -/
def firstDivisorAction {K : Type*} [CommRing K] (q₁ q₂ : K) (x : State K) :
    State K :=
  ![q₁ * q₂ * x 3, x 0 - q₁ * x 1, q₁ * x 1, x 2]

/-- The degree-zero coordinate, equivalently the coefficient of the unit. -/
def degreeZeroRow {K : Type*} [CommRing K] (x : State K) : K :=
  x 0

/-- The degree-zero coordinate as a linear covector. -/
def degreeZeroLinearRow {K : Type*} [CommRing K] : State K →ₗ[K] K where
  toFun := degreeZeroRow
  map_add' := by simp [degreeZeroRow]
  map_smul' := by simp [degreeZeroRow]

@[simp]
theorem degreeZeroLinearRow_apply
    {K : Type*} [CommRing K] (x : State K) :
    degreeZeroLinearRow x = degreeZeroRow x := rfl

/-- The scalar polynomial satisfied by the first-divisor action. -/
def eigenvaluePolynomial {K : Type*} [CommRing K] (q₁ q₂ eigenvalue : K) : K :=
  eigenvalue ^ 4 + q₁ * eigenvalue ^ 3 - q₁ ^ 2 * q₂

/-- The formal derivative of `eigenvaluePolynomial` in its eigenvalue. -/
def eigenvaluePolynomialDerivative
    {K : Type*} [CommRing K] (q₁ eigenvalue : K) : K :=
  4 * eigenvalue ^ 3 + 3 * q₁ * eigenvalue ^ 2

/--
The published first-divisor action satisfies
`T⁴ + q₁ T³ - q₁² q₂ = 0` on every state.
-/
theorem firstDivisorAction_polynomial_relation
    {K : Type*} [CommRing K] (q₁ q₂ : K) (x : State K) :
    let T := firstDivisorAction q₁ q₂
    T (T (T (T x))) =
      fun i => -q₁ * T (T (T x)) i + q₁ ^ 2 * q₂ * x i := by
  dsimp
  funext i
  fin_cases i <;> simp [firstDivisorAction] <;> ring

/-- At zero second parameter, the eigenvalue polynomial has a triple zero
root and the additional root `-q₁`. -/
theorem eigenvaluePolynomial_zeroParameter_factor
    {K : Type*} [CommRing K] (q₁ eigenvalue : K) :
    eigenvaluePolynomial q₁ 0 eigenvalue =
      eigenvalue ^ 3 * (eigenvalue + q₁) := by
  simp [eigenvaluePolynomial]
  ring

/-- The derivative at the additional zero-parameter root is `-q₁³`. -/
theorem eigenvaluePolynomialDerivative_at_exceptionalRoot
    {K : Type*} [CommRing K] (q₁ : K) :
    eigenvaluePolynomialDerivative q₁ (-q₁) = -q₁ ^ 3 := by
  simp [eigenvaluePolynomialDerivative]
  ring

/-- The additional zero-parameter root is simple when `q₁` is nonzero. -/
theorem exceptionalRoot_isSimple
    {K : Type*} [Field K] {q₁ : K} (hq₁ : q₁ ≠ 0) :
    eigenvaluePolynomialDerivative q₁ (-q₁) ≠ 0 := by
  rw [eigenvaluePolynomialDerivative_at_exceptionalRoot]
  exact neg_ne_zero.mpr (pow_ne_zero 3 hq₁)

/--
Every nonzero eigenvector of multiplication by \(T_1\) is visible to the
degree-zero row when both Novikov parameters are nonzero.
-/
theorem degreeZeroRow_ne_zero_of_eigenvector
    {K : Type*} [Field K] {q₁ q₂ eigenvalue : K} {x : State K}
    (hq₁ : q₁ ≠ 0) (hq₂ : q₂ ≠ 0) (hx : x ≠ 0)
    (heigen : firstDivisorAction q₁ q₂ x = fun i => eigenvalue * x i) :
    degreeZeroRow x ≠ 0 := by
  intro hrow
  have hcoord0 := congrFun heigen (0 : Fin 4)
  have hcoord2 := congrFun heigen (2 : Fin 4)
  have hcoord3 := congrFun heigen (3 : Fin 4)
  have hx0 : x 0 = 0 := hrow
  have hx3 : x 3 = 0 := by
    simp [firstDivisorAction, hx0] at hcoord0
    exact hcoord0.resolve_left (not_or_intro hq₁ hq₂)
  have hx2 : x 2 = 0 := by
    simpa [firstDivisorAction, hx3] using hcoord3
  have hx1 : x 1 = 0 := by
    simp [firstDivisorAction, hx2] at hcoord2
    exact hcoord2.resolve_left hq₁
  apply hx
  funext i
  fin_cases i <;> assumption

/--
The kernel of the degree-zero row contains no nonzero eigenvector of
multiplication by \(T_1\) at nonzero Novikov parameters.
-/
theorem no_nonzero_eigenvector_in_degreeZeroKernel
    {K : Type*} [Field K] {q₁ q₂ : K}
    (hq₁ : q₁ ≠ 0) (hq₂ : q₂ ≠ 0) :
    ¬ ∃ (x : State K) (eigenvalue : K),
        x ≠ 0 ∧
          firstDivisorAction q₁ q₂ x = (fun i => eigenvalue * x i) ∧
          degreeZeroRow x = 0 := by
  rintro ⟨x, eigenvalue, hx, heigen, hrow⟩
  exact degreeZeroRow_ne_zero_of_eigenvector hq₁ hq₂ hx heigen hrow

/--
Tensoring a row-visible vector with a nonzero eigenvector of the first
divisor action gives a row-visible product vector at nonzero Novikov
parameters.
-/
theorem tensor_degreeZeroRow_ne_zero_of_eigenvector
    {K B : Type*} [Field K] [AddCommGroup B] [Module K B]
    (rowB : B →ₗ[K] K) {b : B} (rowBNonzero : rowB b ≠ 0)
    {q₁ q₂ eigenvalue : K} {x : State K}
    (hq₁ : q₁ ≠ 0) (hq₂ : q₂ ≠ 0) (hx : x ≠ 0)
    (heigen : firstDivisorAction q₁ q₂ x = fun i => eigenvalue * x i) :
    tensorRow K rowB degreeZeroLinearRow (b ⊗ₜ[K] x) ≠ 0 := by
  rw [tensorRow_tmul, degreeZeroLinearRow_apply]
  exact mul_ne_zero rowBNonzero
    (degreeZeroRow_ne_zero_of_eigenvector hq₁ hq₂ hx heigen)

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.HirzebruchSurfaceAugmentation
