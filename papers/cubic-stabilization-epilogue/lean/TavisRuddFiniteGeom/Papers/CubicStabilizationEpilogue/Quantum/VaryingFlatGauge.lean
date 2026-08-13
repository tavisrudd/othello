import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ConstantFlatGauge
import Mathlib.RingTheory.PowerSeries.Inverse

/-!
# One-variable varying formal flat gauges

Let `A(t)=∑ Aₙtⁿ` be a matrix over a commutative `ℚ`-algebra.  This
module constructs the unique normalized matrix series `G(t)=∑ Gₙtⁿ`
whose coefficients satisfy

`G₀=1`,  `(n+1)Gₙ₊₁ = -∑_{k=0}^n AₖGₙ₋ₖ`.

Lean proves the exact formal differential equation `dG/dt=-A(t)G(t)` and
uniqueness among normalized formal matrix solutions.  This is a one-variable
algebraic construction over ordinary formal power series.  No multivariable
bulk coordinates, filtered coefficient quotients, Laurent loop coordinate,
quantum product, convergence, or analytic gauge is represented.  The proofs
are symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

/-- The normalized coefficient of the formal solution to the one-variable
matrix equation `G'=-AG`, defined by strong recursion on its degree. -/
noncomputable def varyingFlatGaugeCoefficient
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connectionCoefficient : ℕ → Matrix Index Index R) (degree : ℕ) :
    Matrix Index Index R :=
  Nat.strongRec (motive := fun _ ↦ Matrix Index Index R)
    (fun current previous ↦
      match current with
      | 0 => 1
      | n + 1 =>
          -(algebraMap ℚ R ((n + 1 : ℚ)⁻¹) •
            ∑ k ∈ Finset.range (n + 1),
              connectionCoefficient k * previous (n - k) (by omega))) degree

/-- The constant coefficient of the varying formal gauge is the identity
matrix. -/
@[simp]
theorem varyingFlatGaugeCoefficient_zero
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connectionCoefficient : ℕ → Matrix Index Index R) :
    varyingFlatGaugeCoefficient connectionCoefficient 0 = 1 := by
  rw [varyingFlatGaugeCoefficient, Nat.strongRec_eq]

/-- The recursively constructed coefficients satisfy the normalized
coefficient equation for `G'=-AG`. -/
theorem varyingFlatGaugeCoefficient_succ
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connectionCoefficient : ℕ → Matrix Index Index R) (degree : ℕ) :
    (degree + 1 : R) •
        varyingFlatGaugeCoefficient connectionCoefficient (degree + 1) =
      -∑ k ∈ Finset.range (degree + 1),
        connectionCoefficient k *
          varyingFlatGaugeCoefficient connectionCoefficient (degree - k) := by
  rw [varyingFlatGaugeCoefficient, Nat.strongRec_eq]
  simp only [smul_neg, smul_smul]
  have scalar_cancel :
      (degree + 1 : R) * algebraMap ℚ R ((degree + 1 : ℚ)⁻¹) = 1 := by
    rw [← Nat.cast_one, ← Nat.cast_add]
    rw [← map_natCast (algebraMap ℚ R) (degree + 1)]
    rw [show ((degree + 1 : ℕ) : ℚ) = (degree : ℚ) + 1 by norm_num]
    rw [← map_mul]
    rw [mul_inv_cancel₀ (by positivity : (degree + 1 : ℚ) ≠ 0), map_one]
    norm_num
  rw [scalar_cancel, one_smul]
  congr 1

/-- The entrywise formal power-series connection assembled from its matrix
coefficients. -/
noncomputable def varyingConnectionSeries
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R]
    (connectionCoefficient : ℕ → Matrix Index Index R) :
    Matrix Index Index (PowerSeries R) :=
  fun row column ↦ PowerSeries.mk fun degree ↦
    connectionCoefficient degree row column

/-- The entrywise formal power-series matrix assembled from the normalized
varying flat-gauge coefficients. -/
noncomputable def varyingFlatGaugeSeries
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connectionCoefficient : ℕ → Matrix Index Index R) :
    Matrix Index Index (PowerSeries R) :=
  fun row column ↦ PowerSeries.mk fun degree ↦
    varyingFlatGaugeCoefficient connectionCoefficient degree row column

/-- Coefficient extraction recovers the supplied varying connection matrix. -/
theorem varyingConnectionSeries_coefficient
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R]
    (connectionCoefficient : ℕ → Matrix Index Index R) (degree : ℕ) :
    (varyingConnectionSeries connectionCoefficient).map
        (PowerSeries.coeff degree) = connectionCoefficient degree := by
  ext
  simp [varyingConnectionSeries]

/-- Coefficient extraction recovers the normalized varying flat-gauge
coefficient matrix. -/
theorem varyingFlatGaugeSeries_coefficient
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connectionCoefficient : ℕ → Matrix Index Index R) (degree : ℕ) :
    (varyingFlatGaugeSeries connectionCoefficient).map
        (PowerSeries.coeff degree) =
      varyingFlatGaugeCoefficient connectionCoefficient degree := by
  ext
  simp [varyingFlatGaugeSeries]

/-- The recursively constructed series satisfies the exact one-variable
formal differential equation `G'=-AG`. -/
theorem varyingFlatGaugeSeries_derivative
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connectionCoefficient : ℕ → Matrix Index Index R) :
    (varyingFlatGaugeSeries connectionCoefficient).map
        PowerSeries.derivativeFun =
      -(varyingConnectionSeries connectionCoefficient) *
        varyingFlatGaugeSeries connectionCoefficient := by
  ext row column degree
  rw [Matrix.map_apply, PowerSeries.coeff_derivativeFun]
  rw [Matrix.mul_apply]
  simp only [Matrix.neg_apply, map_sum, map_neg, neg_mul,
    varyingFlatGaugeSeries, varyingConnectionSeries,
    PowerSeries.coeff_mk, PowerSeries.coeff_mul]
  have recurrence_entry := congrArg (fun matrix ↦ matrix row column)
    (varyingFlatGaugeCoefficient_succ connectionCoefficient degree)
  simp only [Matrix.smul_apply, Matrix.neg_apply, Matrix.sum_apply,
    Matrix.mul_apply, smul_eq_mul] at recurrence_entry
  rw [mul_comm] at recurrence_entry
  rw [recurrence_entry]
  have antidiagonal_as_range (index : Index) :
      (∑ pair ∈ Finset.antidiagonal degree,
          connectionCoefficient pair.1 row index *
            varyingFlatGaugeCoefficient connectionCoefficient pair.2 index column) =
        ∑ k ∈ Finset.range (degree + 1),
          connectionCoefficient k row index *
            varyingFlatGaugeCoefficient connectionCoefficient (degree - k) index column := by
    exact Finset.Nat.sum_antidiagonal_eq_sum_range_succ
      (fun first second ↦ connectionCoefficient first row index *
        varyingFlatGaugeCoefficient connectionCoefficient second index column) degree
  simp_rw [antidiagonal_as_range]
  simp only [← Finset.sum_neg_distrib]
  rw [Finset.sum_comm]

/-- A normalized formal matrix solution of the varying one-variable equation
is equal to the recursively constructed solution. -/
theorem varyingFlatGaugeSeries_unique
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connectionCoefficient : ℕ → Matrix Index Index R)
    (candidate : Matrix Index Index (PowerSeries R))
    (normalized : candidate.map (PowerSeries.coeff 0) = 1)
    (flatEquation : candidate.map PowerSeries.derivativeFun =
      -(varyingConnectionSeries connectionCoefficient) * candidate) :
    candidate = varyingFlatGaugeSeries connectionCoefficient := by
  have coefficients_equal : ∀ degree,
      candidate.map (PowerSeries.coeff degree) =
        (varyingFlatGaugeSeries connectionCoefficient).map
          (PowerSeries.coeff degree) := by
    intro degree
    induction degree using Nat.strongRecOn with
    | ind degree previous =>
        cases degree with
        | zero =>
            calc
              candidate.map (PowerSeries.coeff 0) = 1 := normalized
              _ = (varyingFlatGaugeSeries connectionCoefficient).map
                    (PowerSeries.coeff 0) := by
                rw [varyingFlatGaugeSeries_coefficient,
                  varyingFlatGaugeCoefficient_zero]
        | succ degree =>
            apply Matrix.ext
            intro row column
            have candidateEquation := congrArg
              (fun matrix ↦ PowerSeries.coeff degree (matrix row column)) flatEquation
            have constructedEquation := congrArg
              (fun matrix ↦ PowerSeries.coeff degree (matrix row column))
              (varyingFlatGaugeSeries_derivative connectionCoefficient)
            have derivative_coeff_equal :
                PowerSeries.coeff degree ((candidate row column).derivativeFun) =
                  PowerSeries.coeff degree
                    ((varyingFlatGaugeSeries connectionCoefficient row column).derivativeFun) := by
              calc
                PowerSeries.coeff degree ((candidate row column).derivativeFun) =
                    PowerSeries.coeff degree
                      ((-(varyingConnectionSeries connectionCoefficient) * candidate)
                        row column) := candidateEquation
                _ = PowerSeries.coeff degree
                      ((-(varyingConnectionSeries connectionCoefficient) *
                          varyingFlatGaugeSeries connectionCoefficient) row column) := by
                    simp only [Matrix.mul_apply, Matrix.neg_apply, map_sum, map_neg,
                      neg_mul, PowerSeries.coeff_mul, varyingConnectionSeries,
                      varyingFlatGaugeSeries, PowerSeries.coeff_mk]
                    apply Finset.sum_congr rfl
                    intro index _
                    congr 1
                    apply Finset.sum_congr rfl
                    intro pair pair_mem
                    congr 1
                    simpa [Matrix.map_apply, varyingFlatGaugeSeries] using
                      congrArg (fun matrix ↦ matrix index column)
                        (previous pair.2 (by
                          rw [Finset.mem_antidiagonal] at pair_mem
                          omega))
                _ = PowerSeries.coeff degree
                      ((varyingFlatGaugeSeries connectionCoefficient row column).derivativeFun) :=
                  constructedEquation.symm
            rw [PowerSeries.coeff_derivativeFun,
              PowerSeries.coeff_derivativeFun] at derivative_coeff_equal
            have scalar_unit : IsUnit ((degree : R) + 1) := by
              rw [show (degree : R) + 1 =
                algebraMap ℚ R ((degree : ℚ) + 1) by norm_num]
              exact (isUnit_iff_ne_zero.mpr
                (by positivity : (degree : ℚ) + 1 ≠ 0)).map _
            exact scalar_unit.mul_right_cancel derivative_coeff_equal
  apply Matrix.ext
  intro row column
  apply PowerSeries.ext
  intro degree
  exact congrArg (fun matrix ↦ matrix row column) (coefficients_equal degree)

/-- Rational-algebra homomorphisms carry every recursively constructed
varying flat-gauge coefficient to the coefficient constructed from the mapped
connection. -/
theorem varyingFlatGaugeCoefficient_map
    {Index R S : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R] [CommRing S] [Algebra ℚ S]
    (homomorphism : R →ₐ[ℚ] S)
    (connectionCoefficient : ℕ → Matrix Index Index R) (degree : ℕ) :
    (varyingFlatGaugeCoefficient connectionCoefficient degree).map
        homomorphism.toRingHom =
      varyingFlatGaugeCoefficient
        (fun n ↦ (connectionCoefficient n).map homomorphism.toRingHom) degree := by
  induction degree using Nat.strongRecOn with
  | ind degree previous =>
      cases degree with
      | zero =>
          simp
      | succ degree =>
          apply Matrix.ext
          intro row column
          have sourceRecurrence := congrArg
            (fun matrix ↦ matrix.map homomorphism.toRingHom)
            (varyingFlatGaugeCoefficient_succ connectionCoefficient degree)
          have sourceEntry := congrArg (fun matrix ↦ matrix row column)
            sourceRecurrence
          simp only [Matrix.map_apply, Matrix.smul_apply, smul_eq_mul,
            Matrix.neg_apply, Matrix.sum_apply, Matrix.mul_apply,
            map_mul, map_neg, map_sum] at sourceEntry
          have scalarMap :
              homomorphism.toRingHom (degree + 1 : R) = (degree + 1 : S) := by
            norm_num
          rw [scalarMap] at sourceEntry
          have mappedSum :
              (∑ k ∈ Finset.range (degree + 1), ∑ index,
                  homomorphism.toRingHom (connectionCoefficient k row index) *
                    homomorphism.toRingHom
                      (varyingFlatGaugeCoefficient connectionCoefficient
                        (degree - k) index column)) =
                ∑ k ∈ Finset.range (degree + 1), ∑ index,
                  homomorphism.toRingHom (connectionCoefficient k row index) *
                    varyingFlatGaugeCoefficient
                      (fun n ↦ (connectionCoefficient n).map
                        homomorphism.toRingHom) (degree - k) index column := by
            apply Finset.sum_congr rfl
            intro k k_mem
            apply Finset.sum_congr rfl
            intro index _
            congr 1
            exact congrArg (fun matrix ↦ matrix index column)
              (previous (degree - k) (by
                rw [Finset.mem_range] at k_mem
                omega))
          rw [mappedSum] at sourceEntry
          have targetEntry := congrArg (fun matrix ↦ matrix row column)
            (varyingFlatGaugeCoefficient_succ
              (fun n ↦ (connectionCoefficient n).map homomorphism.toRingHom)
              degree)
          simp only [Matrix.smul_apply, smul_eq_mul, Matrix.neg_apply,
            Matrix.sum_apply, Matrix.mul_apply, Matrix.map_apply] at targetEntry
          have scalarUnit : IsUnit (degree + 1 : S) := by
            rw [show (degree + 1 : S) =
              algebraMap ℚ S (degree + 1 : ℚ) by norm_num]
            exact (isUnit_iff_ne_zero.mpr
              (by positivity : (degree + 1 : ℚ) ≠ 0)).map _
          exact scalarUnit.mul_left_cancel (sourceEntry.trans targetEntry.symm)

/-- Mapping the coefficients of a varying connection entrywise commutes with
assembling its formal power-series matrix. -/
theorem varyingConnectionSeries_map
    {Index R S : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [CommRing S]
    (homomorphism : R →+* S)
    (connectionCoefficient : ℕ → Matrix Index Index R) :
    (varyingConnectionSeries connectionCoefficient).map
        (PowerSeries.map homomorphism) =
      varyingConnectionSeries
        (fun degree ↦ (connectionCoefficient degree).map homomorphism) := by
  ext row column degree
  simp [varyingConnectionSeries]

/-- Rational-algebra homomorphisms commute with assembly of the normalized
varying flat-gauge series. -/
theorem varyingFlatGaugeSeries_map
    {Index R S : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R] [CommRing S] [Algebra ℚ S]
    (homomorphism : R →ₐ[ℚ] S)
    (connectionCoefficient : ℕ → Matrix Index Index R) :
    (varyingFlatGaugeSeries connectionCoefficient).map
        (PowerSeries.map homomorphism.toRingHom) =
      varyingFlatGaugeSeries
        (fun degree ↦ (connectionCoefficient degree).map
          homomorphism.toRingHom) := by
  ext row column degree
  simpa [varyingFlatGaugeSeries] using
    congrArg (fun matrix ↦ matrix row column)
      (varyingFlatGaugeCoefficient_map homomorphism connectionCoefficient degree)

/-- The normalized varying formal flat-gauge series is an invertible square
matrix over the formal power-series ring. -/
theorem varyingFlatGaugeSeries_isUnit
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connectionCoefficient : ℕ → Matrix Index Index R) :
    IsUnit (varyingFlatGaugeSeries connectionCoefficient) := by
  rw [Matrix.isUnit_iff_isUnit_det]
  rw [PowerSeries.isUnit_iff_constantCoeff]
  rw [RingHom.map_det]
  have constantMatrix :
      PowerSeries.constantCoeff.mapMatrix
          (varyingFlatGaugeSeries connectionCoefficient) = 1 := by
    ext row column
    simp [varyingFlatGaugeSeries,
      ← PowerSeries.coeff_zero_eq_constantCoeff_apply,
      varyingFlatGaugeCoefficient_zero]
  rw [constantMatrix, Matrix.det_one]
  exact isUnit_one

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
