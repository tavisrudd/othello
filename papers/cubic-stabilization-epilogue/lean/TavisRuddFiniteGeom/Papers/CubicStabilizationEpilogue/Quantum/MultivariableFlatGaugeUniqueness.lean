import Mathlib.RingTheory.MvPowerSeries.Basic
import Mathlib.Data.Finsupp.Order
import Mathlib.Data.Matrix.Basic
import Mathlib.RingTheory.LaurentSeries

/-!
# Uniqueness for multivariable formal flat-gauge equations

Let `A_i(x)` be one matrix-valued multivariate formal power series for each
coordinate `i`.  This module defines coefficientwise partial derivatives and
proves that two normalized matrix series satisfying

`partial_i G = -A_i G`

for every coordinate are equal.  The argument is induction on total monomial
degree: a nonconstant coefficient is recovered from any coordinate in its
support, and positive integers are units over a commutative `ℚ`-algebra.

The theorem proves uniqueness only.  It does not construct a solution, prove
the integrability conditions on the connection, identify the coefficient ring
with a Laurent or filtered quantum coefficient ring, or supply convergence or
analytic gauge data.  The proof is symbolic and kernel checked, with no
external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

/-- The total degree of a multivariate monomial. -/
def multivariableTotalDegree {Coordinate : Type*}
    (degree : Coordinate →₀ ℕ) : ℕ :=
  degree.sum fun _ exponent ↦ exponent

/-- Total degree is additive on monomials. -/
theorem multivariableTotalDegree_add {Coordinate : Type*}
    (left right : Coordinate →₀ ℕ) :
    multivariableTotalDegree (left + right) =
      multivariableTotalDegree left + multivariableTotalDegree right := by
  classical
  simp [multivariableTotalDegree, Finsupp.sum_add_index']

/-- Pointwise comparison of monomials implies comparison of total degrees. -/
theorem multivariableTotalDegree_mono {Coordinate : Type*}
    {left right : Coordinate →₀ ℕ} (comparison : left ≤ right) :
    multivariableTotalDegree left ≤ multivariableTotalDegree right := by
  classical
  exact Finsupp.sum_le_sum_index comparison
    (fun _ _ ↦ monotone_id) (by simp)

/-- A single variable to the first power has total degree one. -/
@[simp]
theorem multivariableTotalDegree_single {Coordinate : Type*}
    (coordinate : Coordinate) :
    multivariableTotalDegree (Finsupp.single coordinate 1) = 1 := by
  classical
  simp [multivariableTotalDegree]

/-- Removing one occurrence of a variable lowers total degree by one. -/
theorem multivariableTotalDegree_sub_single_add_one
    {Coordinate : Type*} {degree : Coordinate →₀ ℕ}
    {coordinate : Coordinate} (present : degree coordinate ≠ 0) :
    multivariableTotalDegree (degree - Finsupp.single coordinate 1) + 1 =
      multivariableTotalDegree degree := by
  have equality := congrArg multivariableTotalDegree
    (Finsupp.sub_add_single_one_cancel present)
  simpa [multivariableTotalDegree_add] using equality

/-- Coefficientwise partial differentiation of a multivariate formal power
series. -/
noncomputable def multivariablePartialDerivative
    {Coordinate R : Type*} [CommRing R] [DecidableEq Coordinate]
    (coordinate : Coordinate) (series : MvPowerSeries Coordinate R) :
    MvPowerSeries Coordinate R :=
  fun degree ↦
    (degree coordinate + 1 : R) *
      MvPowerSeries.coeff (degree + Finsupp.single coordinate 1) series

/-- The coefficient formula defining multivariable partial differentiation. -/
theorem multivariablePartialDerivative_coefficient
    {Coordinate R : Type*} [CommRing R] [DecidableEq Coordinate]
    (coordinate : Coordinate) (series : MvPowerSeries Coordinate R)
    (degree : Coordinate →₀ ℕ) :
    MvPowerSeries.coeff degree
        (multivariablePartialDerivative coordinate series) =
      (degree coordinate + 1 : R) *
        MvPowerSeries.coeff (degree + Finsupp.single coordinate 1) series := by
  rfl

/-- Two normalized matrix-valued multivariate series satisfying the same
coordinatewise formal flat equation are equal.  Existence and integrability
of such a solution are not assumptions hidden by this statement: the two
candidate solutions and every displayed equation are explicit hypotheses. -/
theorem multivariableFlatGaugeSeries_unique
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate → Matrix Index Index (MvPowerSeries Coordinate R))
    (left right : Matrix Index Index (MvPowerSeries Coordinate R))
    (leftNormalized : left.map (MvPowerSeries.coeff 0) = 1)
    (rightNormalized : right.map (MvPowerSeries.coeff 0) = 1)
    (leftEquation : ∀ coordinate,
      left.map (multivariablePartialDerivative coordinate) =
        -(connection coordinate) * left)
    (rightEquation : ∀ coordinate,
      right.map (multivariablePartialDerivative coordinate) =
        -(connection coordinate) * right) :
    left = right := by
  have coefficientsEqual : ∀ degree : Coordinate →₀ ℕ,
      left.map (MvPowerSeries.coeff degree) =
        right.map (MvPowerSeries.coeff degree) := by
    intro degree
    let statement : ℕ → Prop := fun total ↦
      ∀ current : Coordinate →₀ ℕ,
        multivariableTotalDegree current = total →
          left.map (MvPowerSeries.coeff current) =
            right.map (MvPowerSeries.coeff current)
    have allTotals : ∀ total, statement total := by
      intro total
      induction total using Nat.strongRecOn with
      | ind total previous =>
          intro current currentTotal
          by_cases currentZero : current = 0
          · subst current
            calc
              left.map (MvPowerSeries.coeff 0) = 1 := leftNormalized
              _ = right.map (MvPowerSeries.coeff 0) := rightNormalized.symm
          · have supportNonempty : current.support.Nonempty :=
              Finsupp.support_nonempty_iff.mpr currentZero
            obtain ⟨coordinate, coordinateMem⟩ := supportNonempty
            have coordinatePresent : current coordinate ≠ 0 := by
              simpa [Finsupp.mem_support_iff] using coordinateMem
            let predecessor := current - Finsupp.single coordinate 1
            have recover : predecessor + Finsupp.single coordinate 1 = current := by
              exact Finsupp.sub_add_single_one_cancel coordinatePresent
            have predecessorDegree :
                multivariableTotalDegree predecessor + 1 = total := by
              rw [← currentTotal]
              exact multivariableTotalDegree_sub_single_add_one coordinatePresent
            have rightSidesEqual : ∀ row column,
                MvPowerSeries.coeff predecessor
                    ((-(connection coordinate) * left) row column) =
                  MvPowerSeries.coeff predecessor
                    ((-(connection coordinate) * right) row column) := by
              intro row column
              simp only [Matrix.mul_apply, Matrix.neg_apply, map_sum, map_neg,
                neg_mul, MvPowerSeries.coeff_mul]
              apply Finset.sum_congr rfl
              intro index _
              congr 1
              apply Finset.sum_congr rfl
              intro pair pairMem
              congr 1
              have pairSum : pair.1 + pair.2 = predecessor := by
                simpa using pairMem
              have secondLe : pair.2 ≤ predecessor := by
                rw [← pairSum]
                exact le_add_left le_rfl
              have secondDegreeLe :
                  multivariableTotalDegree pair.2 ≤
                    multivariableTotalDegree predecessor :=
                multivariableTotalDegree_mono secondLe
              have secondDegreeLt :
                  multivariableTotalDegree pair.2 < total := by omega
              exact congrArg (fun matrix ↦ matrix index column)
                (previous (multivariableTotalDegree pair.2) secondDegreeLt
                  pair.2 rfl)
            apply Matrix.ext
            intro row column
            have leftCoefficientEquation := congrArg
              (fun matrix ↦ MvPowerSeries.coeff predecessor (matrix row column))
              (leftEquation coordinate)
            have rightCoefficientEquation := congrArg
              (fun matrix ↦ MvPowerSeries.coeff predecessor (matrix row column))
              (rightEquation coordinate)
            have leftScalarEquation :
                (predecessor coordinate + 1 : R) *
                    MvPowerSeries.coeff current (left row column) =
                  MvPowerSeries.coeff predecessor
                    ((-(connection coordinate) * left) row column) := by
              simpa only [Matrix.map_apply,
                multivariablePartialDerivative_coefficient, recover] using
                leftCoefficientEquation
            have rightScalarEquation :
                (predecessor coordinate + 1 : R) *
                    MvPowerSeries.coeff current (right row column) =
                  MvPowerSeries.coeff predecessor
                    ((-(connection coordinate) * right) row column) := by
              simpa only [Matrix.map_apply,
                multivariablePartialDerivative_coefficient, recover] using
                rightCoefficientEquation
            have scalarEquation :
                (predecessor coordinate + 1 : R) *
                    MvPowerSeries.coeff current (left row column) =
                  (predecessor coordinate + 1 : R) *
                    MvPowerSeries.coeff current (right row column) := by
              calc
                _ = MvPowerSeries.coeff predecessor
                    ((-(connection coordinate) * left) row column) :=
                  leftScalarEquation
                _ = MvPowerSeries.coeff predecessor
                    ((-(connection coordinate) * right) row column) :=
                  rightSidesEqual row column
                _ = _ := rightScalarEquation.symm
            have scalarUnit : IsUnit ((predecessor coordinate + 1 : R)) := by
              rw [show (predecessor coordinate + 1 : R) =
                algebraMap ℚ R ((predecessor coordinate : ℚ) + 1) by norm_num]
              exact (isUnit_iff_ne_zero.mpr
                (by positivity : (predecessor coordinate : ℚ) + 1 ≠ 0)).map _
            exact scalarUnit.mul_left_cancel scalarEquation
    exact allTotals (multivariableTotalDegree degree) degree rfl
  apply Matrix.ext
  intro row column
  apply MvPowerSeries.ext
  intro degree
  exact congrArg (fun matrix ↦ matrix row column) (coefficientsEqual degree)

/-- Over Laurent-series coefficients, two normalized multivariable formal
gauges satisfying the same coordinate equations are equal.  Ordinary Laurent
series allow an integral lower bound for each coefficient; this theorem does
not establish a lower bound uniform in the bulk monomial or in a quotient
tower. -/
theorem laurentMultivariableFlatGaugeSeries_unique
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate (LaurentSeries R)))
    (left right :
      Matrix Index Index (MvPowerSeries Coordinate (LaurentSeries R)))
    (leftNormalized : left.map (MvPowerSeries.coeff 0) = 1)
    (rightNormalized : right.map (MvPowerSeries.coeff 0) = 1)
    (leftEquation : ∀ coordinate,
      left.map (multivariablePartialDerivative coordinate) =
        -(connection coordinate) * left)
    (rightEquation : ∀ coordinate,
      right.map (multivariablePartialDerivative coordinate) =
        -(connection coordinate) * right) :
    left = right :=
  multivariableFlatGaugeSeries_unique connection left right leftNormalized
    rightNormalized leftEquation rightEquation

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
