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
the multivariate formal power-series ring, Lean proves the coefficientwise
partial derivatives satisfy the Leibniz rule, packages them as commuting
derivations, and specializes the zero-curvature identity to those actual
partials.  The same necessary identity is also proved for an arbitrary
commutative coefficient algebra with commuting derivations.

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

/-- Coefficientwise partial differentiation satisfies the product rule on
multivariate formal power series. -/
theorem multivariablePartialDerivative_mul
    {Coordinate R : Type*} [CommRing R] [DecidableEq Coordinate]
    (coordinate : Coordinate) (left right : MvPowerSeries Coordinate R) :
    multivariablePartialDerivative coordinate (left * right) =
      multivariablePartialDerivative coordinate left * right +
        left * multivariablePartialDerivative coordinate right := by
  classical
  apply MvPowerSeries.ext
  intro degree
  let basisMonomial : Coordinate →₀ ℕ := Finsupp.single coordinate 1
  let firstTerm : (Coordinate →₀ ℕ) × (Coordinate →₀ ℕ) → R := fun pair ↦
    (pair.1 coordinate : R) * MvPowerSeries.coeff pair.1 left *
      MvPowerSeries.coeff pair.2 right
  let secondTerm : (Coordinate →₀ ℕ) × (Coordinate →₀ ℕ) → R := fun pair ↦
    (pair.2 coordinate : R) * MvPowerSeries.coeff pair.1 left *
      MvPowerSeries.coeff pair.2 right
  let firstLowerTerm : (Coordinate →₀ ℕ) × (Coordinate →₀ ℕ) → R := fun pair ↦
    (pair.1 coordinate + 1 : R) *
      MvPowerSeries.coeff (pair.1 + basisMonomial) left *
      MvPowerSeries.coeff pair.2 right
  let secondLowerTerm : (Coordinate →₀ ℕ) × (Coordinate →₀ ℕ) → R := fun pair ↦
    (pair.2 coordinate + 1 : R) *
      MvPowerSeries.coeff pair.1 left *
      MvPowerSeries.coeff (pair.2 + basisMonomial) right
  have firstReindex :
      (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal
          (degree + basisMonomial), firstTerm pair) =
        ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal degree,
          firstLowerTerm pair := by
    refine Finset.sum_bij_ne_zero
      (fun pair _ _ ↦ (pair.1 - basisMonomial, pair.2)) ?_ ?_ ?_ ?_
    · intro pair pairMem termNonzero
      have pairSum : pair.1 + pair.2 = degree + basisMonomial := by
        simpa using pairMem
      have firstPresent : pair.1 coordinate ≠ 0 := by
        intro firstZero
        apply termNonzero
        simp [firstTerm, firstZero]
      have recover : pair.1 - basisMonomial + basisMonomial = pair.1 := by
        exact Finsupp.sub_add_single_one_cancel firstPresent
      have targetSum : pair.1 - basisMonomial + pair.2 = degree := by
        exact add_right_cancel (by
          calc
            (pair.1 - basisMonomial + pair.2) + basisMonomial =
                (pair.1 - basisMonomial + basisMonomial) + pair.2 := by ac_rfl
            _ = pair.1 + pair.2 := by rw [recover]
            _ = degree + basisMonomial := pairSum)
      simpa using targetSum
    · intro leftPair leftMem leftNonzero rightPair rightMem rightNonzero equality
      have firstPresent : leftPair.1 coordinate ≠ 0 := by
        intro firstZero
        apply leftNonzero
        simp [firstTerm, firstZero]
      have secondPresent : rightPair.1 coordinate ≠ 0 := by
        intro secondZero
        apply rightNonzero
        simp [firstTerm, secondZero]
      apply Prod.ext
      · have reducedEquality :
            leftPair.1 - basisMonomial = rightPair.1 - basisMonomial := by
          simpa only using congrArg Prod.fst equality
        calc
          leftPair.1 = (leftPair.1 - basisMonomial) + basisMonomial :=
            (Finsupp.sub_add_single_one_cancel firstPresent).symm
          _ = (rightPair.1 - basisMonomial) + basisMonomial := by
            rw [reducedEquality]
          _ = rightPair.1 := Finsupp.sub_add_single_one_cancel secondPresent
      · simpa only using congrArg Prod.snd equality
    · intro pair pairMem termNonzero
      refine ⟨(pair.1 + basisMonomial, pair.2), ?_, ?_, ?_⟩
      · have pairSum : pair.1 + pair.2 = degree := by simpa using pairMem
        have targetSum : pair.1 + basisMonomial + pair.2 = degree + basisMonomial := by
          calc
            pair.1 + basisMonomial + pair.2 =
                (pair.1 + pair.2) + basisMonomial := by ac_rfl
            _ = degree + basisMonomial := by rw [pairSum]
        simpa using targetSum
      · simpa [firstTerm, firstLowerTerm, basisMonomial] using termNonzero
      · apply Prod.ext
        · exact add_tsub_cancel_right pair.1 basisMonomial
        · rfl
    · intro pair pairMem termNonzero
      have firstPresent : pair.1 coordinate ≠ 0 := by
        intro firstZero
        apply termNonzero
        simp [firstTerm, firstZero]
      have recover : pair.1 - basisMonomial + basisMonomial = pair.1 :=
        Finsupp.sub_add_single_one_cancel firstPresent
      have coordinateRecover :
          (pair.1 - basisMonomial) coordinate + 1 = pair.1 coordinate := by
        simpa [basisMonomial] using
          congrArg (fun monomial ↦ monomial coordinate) recover
      have coordinateRecoverCast :
          ((pair.1 - basisMonomial) coordinate : R) + 1 =
            (pair.1 coordinate : R) := by
        simpa using congrArg (fun exponent : ℕ ↦ (exponent : R)) coordinateRecover
      simp only [firstTerm, firstLowerTerm]
      rw [recover, coordinateRecoverCast]
  have secondReindex :
      (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal
          (degree + basisMonomial), secondTerm pair) =
        ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal degree,
          secondLowerTerm pair := by
    refine Finset.sum_bij_ne_zero
      (fun pair _ _ ↦ (pair.1, pair.2 - basisMonomial)) ?_ ?_ ?_ ?_
    · intro pair pairMem termNonzero
      have pairSum : pair.1 + pair.2 = degree + basisMonomial := by
        simpa using pairMem
      have secondPresent : pair.2 coordinate ≠ 0 := by
        intro secondZero
        apply termNonzero
        simp [secondTerm, secondZero]
      have recover : pair.2 - basisMonomial + basisMonomial = pair.2 := by
        exact Finsupp.sub_add_single_one_cancel secondPresent
      have targetSum : pair.1 + (pair.2 - basisMonomial) = degree := by
        exact add_right_cancel (by
          calc
            (pair.1 + (pair.2 - basisMonomial)) + basisMonomial =
                pair.1 + ((pair.2 - basisMonomial) + basisMonomial) := by ac_rfl
            _ = pair.1 + pair.2 := by rw [recover]
            _ = degree + basisMonomial := pairSum)
      simpa using targetSum
    · intro leftPair leftMem leftNonzero rightPair rightMem rightNonzero equality
      have firstPresent : leftPair.2 coordinate ≠ 0 := by
        intro firstZero
        apply leftNonzero
        simp [secondTerm, firstZero]
      have secondPresent : rightPair.2 coordinate ≠ 0 := by
        intro secondZero
        apply rightNonzero
        simp [secondTerm, secondZero]
      apply Prod.ext
      · simpa only using congrArg Prod.fst equality
      · have reducedEquality :
            leftPair.2 - basisMonomial = rightPair.2 - basisMonomial := by
          simpa only using congrArg Prod.snd equality
        calc
          leftPair.2 = (leftPair.2 - basisMonomial) + basisMonomial :=
            (Finsupp.sub_add_single_one_cancel firstPresent).symm
          _ = (rightPair.2 - basisMonomial) + basisMonomial := by
            rw [reducedEquality]
          _ = rightPair.2 := Finsupp.sub_add_single_one_cancel secondPresent
    · intro pair pairMem termNonzero
      refine ⟨(pair.1, pair.2 + basisMonomial), ?_, ?_, ?_⟩
      · have pairSum : pair.1 + pair.2 = degree := by simpa using pairMem
        have targetSum : pair.1 + (pair.2 + basisMonomial) =
            degree + basisMonomial := by
          calc
            pair.1 + (pair.2 + basisMonomial) =
                (pair.1 + pair.2) + basisMonomial := by ac_rfl
            _ = degree + basisMonomial := by rw [pairSum]
        simpa using targetSum
      · simpa [secondTerm, secondLowerTerm, basisMonomial] using termNonzero
      · apply Prod.ext
        · rfl
        · exact add_tsub_cancel_right pair.2 basisMonomial
    · intro pair pairMem termNonzero
      have secondPresent : pair.2 coordinate ≠ 0 := by
        intro secondZero
        apply termNonzero
        simp [secondTerm, secondZero]
      have recover : pair.2 - basisMonomial + basisMonomial = pair.2 :=
        Finsupp.sub_add_single_one_cancel secondPresent
      have coordinateRecover :
          (pair.2 - basisMonomial) coordinate + 1 = pair.2 coordinate := by
        simpa [basisMonomial] using
          congrArg (fun monomial ↦ monomial coordinate) recover
      have coordinateRecoverCast :
          ((pair.2 - basisMonomial) coordinate : R) + 1 =
            (pair.2 coordinate : R) := by
        simpa using congrArg (fun exponent : ℕ ↦ (exponent : R)) coordinateRecover
      simp only [secondTerm, secondLowerTerm]
      rw [recover, coordinateRecoverCast]
  rw [multivariablePartialDerivative_coefficient, MvPowerSeries.coeff_mul]
  rw [Finset.mul_sum]
  calc
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal (degree + basisMonomial),
        (degree coordinate + 1 : R) *
          (MvPowerSeries.coeff pair.1 left *
            MvPowerSeries.coeff pair.2 right)) =
        ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal (degree + basisMonomial),
          (firstTerm pair + secondTerm pair) := by
      apply Finset.sum_congr rfl
      intro pair pairMem
      have pairSum : pair.1 + pair.2 = degree + basisMonomial := by
        simpa using pairMem
      have coordinateSum :
          pair.1 coordinate + pair.2 coordinate = degree coordinate + 1 := by
        simpa [basisMonomial] using
          congrArg (fun monomial ↦ monomial coordinate) pairSum
      have coordinateSumCast :
          (pair.1 coordinate : R) + (pair.2 coordinate : R) =
            (degree coordinate : R) + 1 := by
        simpa using congrArg (fun exponent : ℕ ↦ (exponent : R)) coordinateSum
      simp only [firstTerm, secondTerm]
      rw [← coordinateSumCast]
      ring
    _ = (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal
          (degree + basisMonomial), firstTerm pair) +
        ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal
          (degree + basisMonomial), secondTerm pair := by
      rw [Finset.sum_add_distrib]
    _ = (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal degree,
          firstLowerTerm pair) +
        ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal degree,
          secondLowerTerm pair := by
      rw [firstReindex, secondReindex]
    _ = MvPowerSeries.coeff degree
        (multivariablePartialDerivative coordinate left * right +
          left * multivariablePartialDerivative coordinate right) := by
      change _ = MvPowerSeries.coeff degree
        (multivariablePartialDerivative coordinate left * right) +
          MvPowerSeries.coeff degree
            (left * multivariablePartialDerivative coordinate right)
      rw [MvPowerSeries.coeff_mul, MvPowerSeries.coeff_mul]
      simp only [multivariablePartialDerivative_coefficient, firstLowerTerm,
        secondLowerTerm, basisMonomial]
      congr 1
      apply Finset.sum_congr rfl
      intro pair _
      ring

/-- Partial differentiation as a linear map over the coefficient ring. -/
noncomputable def multivariablePartialDerivativeLinearMap
    {Coordinate R : Type*} [CommRing R] [DecidableEq Coordinate]
    (coordinate : Coordinate) :
    MvPowerSeries Coordinate R →ₗ[R] MvPowerSeries Coordinate R where
  toFun := multivariablePartialDerivative coordinate
  map_add' := by
    intro left right
    apply MvPowerSeries.ext
    intro degree
    simp [multivariablePartialDerivative_coefficient, mul_add]
  map_smul' := by
    intro scalar series
    apply MvPowerSeries.ext
    intro degree
    simp [multivariablePartialDerivative_coefficient]
    ring

/-- Partial differentiation as a derivation of the multivariate formal power
series ring over its coefficient ring. -/
noncomputable def multivariablePartialDerivation
    {Coordinate R : Type*} [CommRing R] [DecidableEq Coordinate]
    (coordinate : Coordinate) :
    Derivation R (MvPowerSeries Coordinate R) (MvPowerSeries Coordinate R) where
  toLinearMap := multivariablePartialDerivativeLinearMap coordinate
  map_one_eq_zero' := by
    apply MvPowerSeries.ext
    intro degree
    have shiftedNonzero :
        degree + Finsupp.single coordinate 1 ≠ (0 : Coordinate →₀ ℕ) := by
      intro equality
      have coordinateEquality :=
        congrArg (fun monomial ↦ monomial coordinate) equality
      simp at coordinateEquality
    simp [multivariablePartialDerivativeLinearMap,
      multivariablePartialDerivative_coefficient, MvPowerSeries.coeff_one,
      shiftedNonzero]
  leibniz' := by
    intro left right
    simpa [multivariablePartialDerivativeLinearMap, smul_eq_mul, add_comm,
      mul_comm] using multivariablePartialDerivative_mul coordinate left right

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

/-- The coefficientwise partial derivatives form a commuting coordinate
system of derivations. -/
noncomputable def multivariablePartialDerivationSystem
    {Coordinate R : Type*} [CommRing R] [DecidableEq Coordinate] :
    CommutingCoordinateDerivations Coordinate R
      (MvPowerSeries Coordinate R) where
  derivation := multivariablePartialDerivation
  commute := multivariablePartialDerivative_comm

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

/-- For the coefficientwise partial derivatives on multivariate formal power
series, an invertible solution of every coordinate equation forces the
corresponding zero-curvature identity.  This specializes the abstract
commuting-derivation theorem; it still proves only necessity, not existence of
a solution from the curvature equations. -/
theorem multivariableFlatGaugeSeries_curvature_eq_zero
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (solution : Matrix Index Index (MvPowerSeries Coordinate R))
    (solutionUnit : IsUnit solution)
    (flatEquation : ∀ coordinate,
      solution.map (multivariablePartialDerivative coordinate) =
        -(connection coordinate) * solution)
    (first second : Coordinate) :
    (connection second).map (multivariablePartialDerivative first) -
        (connection first).map (multivariablePartialDerivative second) +
        connection first * connection second -
        connection second * connection first = 0 := by
  exact multivariableFlatGauge_curvature_eq_zero
    (multivariablePartialDerivationSystem (Coordinate := Coordinate) (R := R))
    connection solution solutionUnit flatEquation first second

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
