import Mathlib.RingTheory.MvPowerSeries.Basic
import Mathlib.Data.Finsupp.Order
import Mathlib.Data.Matrix.Basic
import Mathlib.RingTheory.LaurentSeries
import Mathlib.RingTheory.Derivation.Basic
import Mathlib.Tactic

/-!
# Uniqueness for multivariable formal flat-gauge equations

Let `A_i(x)` be one matrix-valued multivariate formal power series for each
coordinate `i`.  This module defines coefficientwise partial derivatives and
proves that two normalized matrix series satisfying

`partial_i G = -A_i G`

for every coordinate are equal.  The argument is induction on total monomial
degree: a nonconstant coefficient is recovered from any coordinate in its
support, and positive integers are units over a commutative `ℚ`-algebra.  For
an arbitrary commutative coefficient algebra with commuting derivations, Lean
also proves that an invertible supplied solution forces the zero-curvature
identity.

The module does not construct a multivariable solution or prove the converse
existence theorem from zero curvature.  It does not identify the coefficient
ring with a filtered quantum coefficient ring or supply uniform Laurent-order,
convergence, or analytic gauge data.  The proofs are symbolic and kernel
checked, with no external computation or oracle.
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

/-- Coefficientwise partial derivatives in two coordinates commute. -/
theorem multivariablePartialDerivative_comm
    {Coordinate R : Type*} [CommRing R] [DecidableEq Coordinate]
    (first second : Coordinate) (series : MvPowerSeries Coordinate R) :
    multivariablePartialDerivative first
        (multivariablePartialDerivative second series) =
      multivariablePartialDerivative second
        (multivariablePartialDerivative first series) := by
  apply MvPowerSeries.ext
  intro degree
  by_cases coordinatesEqual : first = second
  · subst second
    rfl
  · simp only [multivariablePartialDerivative_coefficient]
    rw [show (degree + Finsupp.single first 1 : Coordinate →₀ ℕ) second =
        degree second by simp [coordinatesEqual]]
    rw [show (degree + Finsupp.single second 1 : Coordinate →₀ ℕ) first =
        degree first by simp [Ne.symm coordinatesEqual]]
    have indexEquality :
        degree + Finsupp.single first 1 + Finsupp.single second 1 =
          degree + Finsupp.single second 1 + Finsupp.single first 1 := by
      ac_rfl
    rw [indexEquality]
    ring

/-- Any matrix series satisfying all coordinate flat equations satisfies the
corresponding mixed-derivative compatibility identity.  This identity does
not assert the expanded zero-curvature equation for the connection. -/
theorem multivariableFlatEquation_mixedDerivative_compatible
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R]
    (connection : Coordinate → Matrix Index Index (MvPowerSeries Coordinate R))
    (solution : Matrix Index Index (MvPowerSeries Coordinate R))
    (flatEquation : ∀ coordinate,
      solution.map (multivariablePartialDerivative coordinate) =
        -(connection coordinate) * solution)
    (first second : Coordinate) :
    (-(connection second) * solution).map
        (multivariablePartialDerivative first) =
      (-(connection first) * solution).map
        (multivariablePartialDerivative second) := by
  rw [← flatEquation second, ← flatEquation first]
  ext row column degree
  exact congrArg (MvPowerSeries.coeff degree)
    (multivariablePartialDerivative_comm first second (solution row column))

/-- Entrywise application of a derivation obeys the matrix-product Leibniz
rule. -/
theorem matrixDerivation_mul
    {Index Base Coefficient : Type*} [Fintype Index]
    [CommRing Base] [CommRing Coefficient] [Algebra Base Coefficient]
    (derivation : Derivation Base Coefficient Coefficient)
    (left right : Matrix Index Index Coefficient) :
    (left * right).map derivation =
      left.map derivation * right + left * right.map derivation := by
  ext row column
  simp only [Matrix.map_apply, Matrix.mul_apply, map_sum,
    derivation.leibniz, Matrix.add_apply, smul_eq_mul]
  rw [Finset.sum_add_distrib]
  rw [add_comm]
  have commuteSum :
      (∑ index, right index column * derivation (left row index)) =
        ∑ index, derivation (left row index) * right index column := by
    apply Finset.sum_congr rfl
    intro index _
    rw [mul_comm]
  rw [commuteSum]

/-- A coordinatewise system of commuting derivations. -/
structure CommutingCoordinateDerivations
    (Coordinate Base Coefficient : Type*)
    [CommRing Base] [CommRing Coefficient] [Algebra Base Coefficient] where
  /-- The derivation in each coordinate. -/
  derivation : Coordinate → Derivation Base Coefficient Coefficient
  /-- The coordinate derivations commute on every coefficient. -/
  commute : ∀ first second coefficient,
    derivation first (derivation second coefficient) =
      derivation second (derivation first coefficient)

/-- An invertible solution of all coordinate equations forces the standard
zero-curvature identity for the supplied connection.  This theorem proves a
necessary integrability condition; it does not construct a solution from a
flat connection. -/
theorem multivariableFlatGauge_curvature_eq_zero
    {Coordinate Index Base Coefficient : Type*}
    [Fintype Index] [DecidableEq Index]
    [CommRing Base] [CommRing Coefficient] [Algebra Base Coefficient]
    (directions : CommutingCoordinateDerivations
      Coordinate Base Coefficient)
    (connection : Coordinate → Matrix Index Index Coefficient)
    (solution : Matrix Index Index Coefficient)
    (solutionUnit : IsUnit solution)
    (flatEquation : ∀ coordinate,
      solution.map (directions.derivation coordinate) =
        -(connection coordinate) * solution)
    (first second : Coordinate) :
    (connection second).map (directions.derivation first) -
        (connection first).map (directions.derivation second) +
        connection first * connection second -
        connection second * connection first = 0 := by
  have mixedDerivatives :
      (solution.map (directions.derivation second)).map
          (directions.derivation first) =
        (solution.map (directions.derivation first)).map
          (directions.derivation second) := by
    ext row column
    exact directions.commute first second (solution row column)
  have firstDifferentiated := congrArg
    (fun matrix ↦ matrix.map (directions.derivation first))
    (flatEquation second)
  have secondDifferentiated := congrArg
    (fun matrix ↦ matrix.map (directions.derivation second))
    (flatEquation first)
  have mapNegativeSecond :
      (-(connection second)).map (directions.derivation first) =
        -(connection second).map (directions.derivation first) := by
    ext
    simp
  have mapNegativeFirst :
      (-(connection first)).map (directions.derivation second) =
        -(connection first).map (directions.derivation second) := by
    ext
    simp
  have differentiatedSecond :
      (solution.map (directions.derivation second)).map
          (directions.derivation first) =
        -(connection second).map (directions.derivation first) * solution +
          connection second * connection first * solution := by
    calc
      _ = (-(connection second) * solution).map
          (directions.derivation first) := firstDifferentiated
      _ = (-(connection second)).map (directions.derivation first) * solution +
          -(connection second) * solution.map (directions.derivation first) :=
        matrixDerivation_mul _ _ _
      _ = _ := by
        rw [flatEquation first]
        rw [mapNegativeSecond]
        noncomm_ring
  have differentiatedFirst :
      (solution.map (directions.derivation first)).map
          (directions.derivation second) =
        -(connection first).map (directions.derivation second) * solution +
          connection first * connection second * solution := by
    calc
      _ = (-(connection first) * solution).map
          (directions.derivation second) := secondDifferentiated
      _ = (-(connection first)).map (directions.derivation second) * solution +
          -(connection first) * solution.map (directions.derivation second) :=
        matrixDerivation_mul _ _ _
      _ = _ := by
        rw [flatEquation second]
        rw [mapNegativeFirst]
        noncomm_ring
  have productsEqual :
      (-(connection second).map (directions.derivation first) +
          connection second * connection first) * solution =
        (-(connection first).map (directions.derivation second) +
          connection first * connection second) * solution := by
    calc
      _ = -(connection second).map (directions.derivation first) * solution +
          connection second * connection first * solution := by noncomm_ring
      _ = (solution.map (directions.derivation second)).map
          (directions.derivation first) := differentiatedSecond.symm
      _ = (solution.map (directions.derivation first)).map
          (directions.derivation second) := mixedDerivatives
      _ = -(connection first).map (directions.derivation second) * solution +
          connection first * connection second * solution := differentiatedFirst
      _ = _ := by noncomm_ring
  have factorsEqual := solutionUnit.mul_right_cancel productsEqual
  calc
    _ = -(-(connection second).map (directions.derivation first) +
          connection second * connection first) +
        (-(connection first).map (directions.derivation second) +
          connection first * connection second) := by noncomm_ring
    _ = 0 := by rw [factorsEqual]; abel

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
