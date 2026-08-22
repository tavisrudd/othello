import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ThreefoldKummerCompatibility

/-!
# Cubic Kummer derivatives and separating multiplication operators

This file isolates algebraic steps used when a logarithmic divisor
direction acts on three conjugate primary factors.

First, let `sigma` be an order-three linear action and let `D` be a commuting
derivation operator.  If every vector killed by `D` is fixed by `sigma`, then
`D x` is fixed by `sigma` exactly when `x` is fixed.  For the Euler derivation
on a Laurent or Puiseux field, the kernel consists of constants, so
differentiation does not erase a nontrivial cubic Kummer character.

Second, three pairwise distinct scalar values generate the split cubic
algebra: the vectors `1`, `d`, and `d^2` form a basis of functions on the
three points.  This is the Vandermonde step behind the statement that a
divisor separating three geometric factors generates their cubic etale
quotient.

Finally, an exact rational example records the calibration freedom.
A parabolic Poincare isometry fixes the unit and both divisor vectors and
preserves the cubic dual-number Jordan form, but changes the selected modified
residue discriminant from zero to `4/9`.  Thus the preceding divisor-generator
lemmas do not determine the large-radius grading calibration.

The results are finite linear algebra.  They do not construct a divisor
direction, a marked spectral carrier, a trait model, or a quantum-connection
comparison.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.KummerDivisorGenerator

section ExactMarker

/-- Numerical data used to select primitive factors.  The geometric adapter
chooses these functions; the exact cubic carrier below keeps the value `4/9`
in its type. -/
structure MarkerData (Point : Type*) where
  rank : Point → ℕ
  nilpotentNonzero : Point → Prop
  discriminant : Point → ℚ

/-- The subtype of points carrying the exact cubic marker.  A point with
nonzero discriminant `4`, for example, cannot inhabit this subtype without an
equality proof identifying `4` with `4/9`. -/
def ExactCubicPoint {Point : Type*} (data : MarkerData Point) :=
  {point : Point // data.rank point = 2 ∧ data.nilpotentNonzero point ∧
    data.discriminant point = 4 / 9}

end ExactMarker

section CubicDerivative

variable {K V : Type*} [Field K] [CharZero K] [AddCommGroup V] [Module K V]

/--
A commuting linear derivative whose kernel is fixed by an order-three action
preserves the fixed-point fingerprint of every vector.
-/
theorem cubicAction_fixed_derivative_iff
    (sigma D : V →ₗ[K] V)
    (hcomm : sigma.comp D = D.comp sigma)
    (hcube : sigma.comp (sigma.comp sigma) = LinearMap.id)
    (hker : ∀ y : V, D y = 0 → sigma y = y)
    (x : V) :
    sigma (D x) = D x ↔ sigma x = x := by
  constructor
  · intro hfixed
    let y : V := sigma x - x
    have hDy : D y = 0 := by
      change D (sigma x - x) = 0
      rw [map_sub, ← LinearMap.comp_apply, ← hcomm, LinearMap.comp_apply, hfixed]
      exact sub_self (D x)
    have hsigmay : sigma y = y := hker y hDy
    have hsigma2 : sigma (sigma x) = x + (2 : K) • y := by
      calc
        sigma (sigma x) = sigma (x + y) := by simp [y]
        _ = sigma x + sigma y := map_add sigma x y
        _ = (x + y) + y := by rw [hsigmay]; simp [y]
        _ = x + (2 : K) • y := by module
    have hsigma3 : sigma (sigma (sigma x)) = x + (3 : K) • y := by
      calc
        sigma (sigma (sigma x)) = sigma (x + (2 : K) • y) := by rw [hsigma2]
        _ = sigma x + (2 : K) • sigma y := by
          rw [map_add, map_smul]
        _ = (x + y) + (2 : K) • y := by rw [hsigmay]; simp [y]
        _ = x + (3 : K) • y := by module
    have hcubex : sigma (sigma (sigma x)) = x := by
      simpa only [LinearMap.comp_apply, LinearMap.id_apply] using congrArg (fun f : V →ₗ[K] V ↦ f x) hcube
    have hthree : (3 : K) • y = 0 := by
      rw [hsigma3] at hcubex
      exact add_left_cancel (hcubex.trans (add_zero x).symm)
    have hy : y = 0 := by
      exact (smul_eq_zero.mp hthree).resolve_left (by norm_num)
    exact sub_eq_zero.mp hy
  · intro hx
    rw [← LinearMap.comp_apply, hcomm, LinearMap.comp_apply, hx]

end CubicDerivative

section ProjectedTrace

variable {K ι : Type*} [Field K] [Fintype ι]

/--
The trace of a commutator remains zero after compression by a projector that
commutes with the first factor.  This is the finite trace step used to pass
from a flatness equation for an Euler block to its scalar eigenvalue.
-/
theorem trace_projected_commutator_eq_zero
    (P C mu : Matrix ι ι K)
    (hP : P * P = P) (hcomm : P * C = C * P) :
    Matrix.trace (P * (C * mu - mu * C) * P) = 0 := by
  have houter (A : Matrix ι ι K) :
      Matrix.trace (P * A * P) = Matrix.trace (P * A) := by
    calc
      Matrix.trace (P * A * P) = Matrix.trace (P * (P * A)) :=
        Matrix.trace_mul_comm (P * A) P
      _ = Matrix.trace ((P * P) * A) := by rw [Matrix.mul_assoc]
      _ = Matrix.trace (P * A) := by rw [hP]
  have hsecondTrace :
      Matrix.trace (P * (mu * C)) = Matrix.trace (P * (C * mu)) := by
    calc
      Matrix.trace (P * (mu * C)) = Matrix.trace ((P * mu) * C) := by
        rw [Matrix.mul_assoc]
      _ = Matrix.trace (C * (P * mu)) := Matrix.trace_mul_comm (P * mu) C
      _ = Matrix.trace ((C * P) * mu) := by rw [Matrix.mul_assoc]
      _ = Matrix.trace ((P * C) * mu) := by rw [← hcomm]
      _ = Matrix.trace (P * (C * mu)) := by rw [Matrix.mul_assoc]
  rw [Matrix.mul_sub, Matrix.sub_mul, Matrix.trace_sub, houter, houter,
    hsecondTrace]
  exact sub_self _

end ProjectedTrace

section CubicGenerator

variable {K : Type*} [Field K]

/-- The three consecutive values of a point under a chosen permutation. -/
def cubicOrbitValues {Point : Type*} (sigma : Equiv.Perm Point) (point : Point) :
    Fin 3 → Point :=
  ![point, sigma point, sigma (sigma point)]

/-- A point moved by a permutation whose third iterate returns that point has
three pairwise distinct consecutive values. -/
theorem cubicOrbitValues_injective
    {Point : Type*} (sigma : Equiv.Perm Point) (point : Point)
    (hcube : sigma (sigma (sigma point)) = point)
    (hmoved : sigma point ≠ point) :
    Function.Injective (cubicOrbitValues sigma point) := by
  have h02 : point ≠ sigma (sigma point) := by
    intro h
    apply hmoved
    calc
      sigma point = sigma (sigma (sigma point)) := congrArg sigma h
      _ = point := hcube
  have h12 : sigma point ≠ sigma (sigma point) := by
    intro h
    exact hmoved (sigma.injective h).symm
  intro i j hij
  fin_cases i <;> fin_cases j
  · rfl
  · exact (hmoved hij.symm).elim
  · exact (h02 hij).elim
  · exact (hmoved hij).elim
  · rfl
  · exact (h12 hij).elim
  · exact (h02 hij.symm).elim
  · exact (h12 hij.symm).elim
  · rfl

/--
If three scalar values are pairwise distinct, evaluation on `1`, `d`, and
`d^2` is surjective onto all functions on the three points.
-/
theorem vandermonde_surjective_of_three_distinct
    (d : Fin 3 → K) (hd : Function.Injective d) :
    Function.Surjective (Matrix.vandermonde d).mulVec := by
  rw [Matrix.mulVec_surjective_iff_isUnit, Matrix.isUnit_iff_isUnit_det]
  rw [isUnit_iff_ne_zero, Matrix.det_vandermonde_ne_zero_iff]
  exact hd

/--
Every function on three points is a quadratic polynomial in any function
whose three values are pairwise distinct.
-/
theorem exists_quadratic_evaluation_of_three_distinct
    (d : Fin 3 → K) (hd : Function.Injective d) (value : Fin 3 → K) :
    ∃ coefficient : Fin 3 → K,
      (Matrix.vandermonde d).mulVec coefficient = value :=
  vandermonde_surjective_of_three_distinct d hd value

/-- Every function on a nontrivial cubic orbit is a quadratic polynomial in
the orbit-value function. -/
theorem exists_quadratic_evaluation_of_cubic_orbit
    (sigma : Equiv.Perm K) (point : K)
    (hcube : sigma (sigma (sigma point)) = point)
    (hmoved : sigma point ≠ point) (value : Fin 3 → K) :
    ∃ coefficient : Fin 3 → K,
      (Matrix.vandermonde (cubicOrbitValues sigma point)).mulVec coefficient = value :=
  exists_quadratic_evaluation_of_three_distinct _
    (cubicOrbitValues_injective sigma point hcube hmoved) value

end CubicGenerator

namespace ParabolicShear

open ThreefoldKummerCompatibility

/-- A Poincare isometry which fixes the first three basis vectors
`1`, `e`, and `x`, but mixes the degree-two and degree-four complements. -/
def shear : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![1, 0, 0, 0, 0, 0;
     0, 1, 0, 1, 0, 0;
     0, 0, 1, 0, -1, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1]

/-- The inverse of `shear`. -/
def shearInverse : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![1, 0, 0, 0, 0, 0;
     0, 1, 0, -1, 0, 0;
     0, 0, 1, 0, 1, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1]

/-- The displayed parabolic matrix and its displayed inverse multiply to the
identity in both orders. -/
theorem shear_inverse_values :
    shear * shearInverse = 1 ∧ shearInverse * shear = 1 := by
  constructor <;>
    ext i j <;>
    fin_cases i <;> fin_cases j <;>
      norm_num [shear, shearInverse, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The parabolic shear preserves the Poincare pairing. -/
theorem shear_pairing_isometry :
    shear.transpose * threefoldPairing * shear = threefoldPairing := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [shear, threefoldPairing, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The first three columns of the shear are those of the identity, so it
fixes the unit and the two displayed divisor vectors. -/
theorem shear_fixes_unit_and_divisors
    (i : ThreefoldIndex) (j : Fin 3) :
    shear i ⟨j, by omega⟩ = (1 : Matrix ThreefoldIndex ThreefoldIndex ℚ) i ⟨j, by omega⟩ := by
  fin_cases i <;> fin_cases j <;> norm_num [shear, Matrix.one_apply]

/-- Euler multiplication after conjugating the dual-cubic multiplication
algebra by the parabolic shear. -/
def shearedEuler : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  shear * strictCubicEuler * shearInverse

/-- The corresponding separating Jordan basis. -/
def shearedJordanBasis : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  shear * strictCubicJordanBasis

/-- The sheared Euler operator has the same selected rank-two Jordan block and
the same complementary cubic factor as the un-sheared operator. -/
theorem shearedEuler_change_of_basis :
    shearedEuler * shearedJordanBasis =
      shearedJordanBasis * strictCubicJordanForm := by
  have hinverse := shear_inverse_values.2
  simp only [shearedEuler, shearedJordanBasis, Matrix.mul_assoc]
  rw [← Matrix.mul_assoc shearInverse shear strictCubicJordanBasis,
    hinverse, one_mul, strictCubicEuler_intertwining]

/-- The connection grading in the sheared separating basis. -/
def gradingInJordanBasis : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![-1 / 6, 0, 0, 2 / 3, 0, 0;
     0, 1 / 6, 0, 0, 1 / 3, 2 / 3;
     5 / 3, 0, -1 / 2, 1 / 3, 0, 0;
     4 / 3, 0, 0, -5 / 6, 0, 0;
     0, 4 / 3, 0, 0, 7 / 6, -2 / 3;
     0, 2 / 3, 0, 0, 1 / 3, 1 / 6]

/-- The sheared Jordan basis intertwines the standard connection grading with
the displayed sheared grading. -/
theorem gradingInJordanBasis_intertwining :
    strictConnectionGrading * shearedJordanBasis =
      shearedJordanBasis * gradingInJordanBasis := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [gradingInJordanBasis, shearedJordanBasis,
      strictConnectionGrading, productGrading, shear, strictCubicJordanBasis,
      Matrix.mul_apply, Fin.sum_univ_succ]

/-- The normalized first off-block gauge for the selected `2+4` splitting. -/
def firstGauge : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, -2 / 27, -2 / 27, 2 / 81, -2 / 81;
     0, 0, 0, 0, -4 / 27, -1 / 27;
     2 / 9, 2 / 81, 0, 0, 0, 0;
     1 / 3, -2 / 81, 0, 0, 0, 0;
     0, 2 / 9, 0, 0, 0, 0;
     0, 2 / 9, 0, 0, 0, 0]

/-- The grading after the first off-block recurrence. -/
def blockGrading : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  gradingInJordanBasis + strictCubicJordanForm * firstGauge -
    firstGauge * strictCubicJordanForm

/-- The second normalized recurrence expression for the sheared operator. -/
def secondCoefficient : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  let commutator := strictCubicJordanForm * firstGauge -
    firstGauge * strictCubicJordanForm
  gradingInJordanBasis * firstGauge - firstGauge * gradingInJordanBasis -
    firstGauge * commutator - firstGauge

/-- The first gauge removes all entries between the selected rank-two block
and its four-dimensional complement. -/
theorem firstGauge_block_separation :
    ∀ i j,
      (i.1 < 2 ∧ 2 ≤ j.1) ∨ (2 ≤ i.1 ∧ j.1 < 2) →
        blockGrading i j = 0 := by
  intro i j hij
  fin_cases i <;> fin_cases j <;>
    norm_num at hij <;>
    norm_num [blockGrading, gradingInJordanBasis, strictCubicJordanForm,
      firstGauge, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The selected diagonal exponents are `-1/6, 1/6`, and the normalized
second return entry is zero. -/
theorem selected_recurrence_values :
    blockGrading 0 0 = -1 / 6 ∧
      blockGrading 1 1 = 1 / 6 ∧
      secondCoefficient 1 0 = 0 := by
  norm_num [blockGrading, secondCoefficient, gradingInJordanBasis, firstGauge,
    strictCubicJordanForm, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The elementary-modified selected residue determined by the displayed
recurrence values and the nilpotent scale `2`. -/
def selectedModifiedResidue : Matrix (Fin 2) (Fin 2) ℚ :=
  !![blockGrading 0 0, 2;
     secondCoefficient 1 0, blockGrading 1 1 - 1]

/-- The parabolic calibration has exactly the cubic modified-residue
discriminant `4/9`. -/
theorem selectedModifiedResidue_discriminant :
    selectedModifiedResidue.trace ^ 2 -
      4 * selectedModifiedResidue.det = 4 / 9 := by
  norm_num [selectedModifiedResidue, blockGrading, secondCoefficient,
    gradingInJordanBasis, firstGauge, strictCubicJordanForm,
    Matrix.mul_apply, Fin.sum_univ_succ, Matrix.trace, Matrix.det_fin_two]

end ParabolicShear

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.KummerDivisorGenerator
