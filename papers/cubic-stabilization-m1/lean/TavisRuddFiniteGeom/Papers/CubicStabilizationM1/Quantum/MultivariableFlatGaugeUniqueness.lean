import Mathlib.RingTheory.MvPowerSeries.Basic
import Mathlib.RingTheory.MvPowerSeries.Inverse
import Mathlib.Data.Finsupp.Order
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.RingTheory.LaurentSeries
import Mathlib.RingTheory.Derivation.Basic
import Mathlib.Tactic

/-!
# Existence and uniqueness for multivariable formal flat-gauge equations

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
commutative coefficient algebra with commuting derivations.  Conversely, the
two Frobenius-type identities consisting of symmetric mixed derivatives and
pairwise commuting connection matrices imply zero curvature directly.

For a zero-curvature connection over a commutative `\mathbb{Q}`-algebra, Lean
also constructs the coefficients recursively in one chosen support coordinate,
proves that curvature propagates the selected equation to every coordinate,
and obtains the unique normalized invertible formal gauge, naturally under
rational-algebra coefficient homomorphisms.  The module does not
identify the coefficient ring with a filtered quantum coefficient ring or
construct or package the manuscript's quotient tower and its level connections,
a Laurent-order bound uniform in all bulk
monomials and levels, convergence, or analytic gauge data.  The proofs are
symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

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

/-- Coefficient extension along a rational-algebra homomorphism commutes with
coefficientwise multivariable partial differentiation. -/
theorem multivariablePartialDerivative_map
    {Coordinate R S : Type*} [DecidableEq Coordinate]
    [CommRing R] [CommRing S] [Algebra ℚ R] [Algebra ℚ S]
    (homomorphism : R →ₐ[ℚ] S) (coordinate : Coordinate)
    (series : MvPowerSeries Coordinate R) :
    multivariablePartialDerivative coordinate
        (MvPowerSeries.map homomorphism.toRingHom series) =
      MvPowerSeries.map homomorphism.toRingHom
        (multivariablePartialDerivative coordinate series) := by
  apply MvPowerSeries.ext
  intro degree
  simp [multivariablePartialDerivative_coefficient]

/-- Entrywise coefficient extension commutes with entrywise multivariable
partial differentiation of a matrix. -/
theorem matrix_multivariablePartialDerivative_map
    {Coordinate Index R S : Type*} [DecidableEq Coordinate]
    [CommRing R] [CommRing S] [Algebra ℚ R] [Algebra ℚ S]
    (homomorphism : R →ₐ[ℚ] S) (coordinate : Coordinate)
    (matrix : Matrix Index Index (MvPowerSeries Coordinate R)) :
    (matrix.map (MvPowerSeries.map homomorphism.toRingHom)).map
        (multivariablePartialDerivative coordinate) =
      (matrix.map (multivariablePartialDerivative coordinate)).map
        (MvPowerSeries.map homomorphism.toRingHom) := by
  apply Matrix.ext
  intro row column
  exact multivariablePartialDerivative_map homomorphism coordinate
    (matrix row column)

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

/-- Symmetry of the mixed connection derivatives and pairwise commutativity
of the connection matrices imply the zero-curvature identity.  These are the
two algebraic inputs supplied by potentiality and the commutative-associative
product law for a Frobenius-type quantum product; no solution matrix is
assumed. -/
theorem connection_curvature_eq_zero_of_mixedDerivative_eq_and_mul_comm
    {Coordinate Index Base Coefficient : Type*}
    [Fintype Index] [DecidableEq Index]
    [CommRing Base] [CommRing Coefficient] [Algebra Base Coefficient]
    (directions : CommutingCoordinateDerivations
      Coordinate Base Coefficient)
    (connection : Coordinate → Matrix Index Index Coefficient)
    (mixedDerivative : ∀ first second,
      (connection second).map (directions.derivation first) =
        (connection first).map (directions.derivation second))
    (connectionCommutes : ∀ first second,
      connection first * connection second =
        connection second * connection first)
    (first second : Coordinate) :
    (connection second).map (directions.derivation first) -
        (connection first).map (directions.derivation second) +
        connection first * connection second -
        connection second * connection first = 0 := by
  rw [mixedDerivative first second, connectionCommutes first second]
  abel

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

/-- The defect of a matrix series in one coordinate equation
`partial_i G=-A_iG`. -/
noncomputable def multivariableFlatGaugeDefect
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (solution : Matrix Index Index (MvPowerSeries Coordinate R))
    (coordinate : Coordinate) :
    Matrix Index Index (MvPowerSeries Coordinate R) :=
  solution.map (multivariablePartialDerivative coordinate) +
    connection coordinate * solution

/-- For a zero-curvature connection, the coordinate defects of any matrix
series satisfy the induced compatibility equation.  This is the algebraic
identity used to propagate a recursively imposed coordinate equation to all
coordinates. -/
theorem multivariableFlatGaugeDefect_compatibility
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (solution : Matrix Index Index (MvPowerSeries Coordinate R))
    (curvature : ∀ first second,
      (connection second).map (multivariablePartialDerivative first) -
          (connection first).map (multivariablePartialDerivative second) +
          connection first * connection second -
          connection second * connection first = 0)
    (first second : Coordinate) :
    (multivariableFlatGaugeDefect connection solution second).map
          (multivariablePartialDerivative first) -
        (multivariableFlatGaugeDefect connection solution first).map
          (multivariablePartialDerivative second) =
      connection second *
          multivariableFlatGaugeDefect connection solution first -
        connection first *
          multivariableFlatGaugeDefect connection solution second := by
  have mixedSolution :
      (solution.map (multivariablePartialDerivative second)).map
          (multivariablePartialDerivative first) =
        (solution.map (multivariablePartialDerivative first)).map
          (multivariablePartialDerivative second) := by
    apply Matrix.ext
    intro row column
    exact multivariablePartialDerivative_comm first second (solution row column)
  have firstProduct :
      (connection second * solution).map
          (multivariablePartialDerivative first) =
        (connection second).map (multivariablePartialDerivative first) * solution +
          connection second * solution.map (multivariablePartialDerivative first) := by
    simpa [multivariablePartialDerivation,
      multivariablePartialDerivativeLinearMap] using
      matrixDerivation_mul (multivariablePartialDerivation first)
        (connection second) solution
  have secondProduct :
      (connection first * solution).map
          (multivariablePartialDerivative second) =
        (connection first).map (multivariablePartialDerivative second) * solution +
          connection first * solution.map (multivariablePartialDerivative second) := by
    simpa [multivariablePartialDerivation,
      multivariablePartialDerivativeLinearMap] using
      matrixDerivation_mul (multivariablePartialDerivation second)
        (connection first) solution
  have curvatureRearranged :
      (connection second).map (multivariablePartialDerivative first) -
          (connection first).map (multivariablePartialDerivative second) =
        -(connection first * connection second -
          connection second * connection first) := by
    calc
      _ = ((connection second).map (multivariablePartialDerivative first) -
            (connection first).map (multivariablePartialDerivative second) +
            (connection first * connection second -
              connection second * connection first)) -
            (connection first * connection second -
              connection second * connection first) := by abel
      _ = 0 - (connection first * connection second -
              connection second * connection first) := by
            rw [show (connection second).map
                    (multivariablePartialDerivative first) -
                  (connection first).map
                    (multivariablePartialDerivative second) +
                  (connection first * connection second -
                    connection second * connection first) = 0 by
              simpa [sub_eq_add_neg, add_assoc] using curvature first second]
      _ = _ := zero_sub _
  have firstDefectMap :
      (multivariableFlatGaugeDefect connection solution second).map
          (multivariablePartialDerivative first) =
        (solution.map (multivariablePartialDerivative second)).map
            (multivariablePartialDerivative first) +
          (connection second * solution).map
            (multivariablePartialDerivative first) := by
    apply Matrix.ext
    intro row column
    apply MvPowerSeries.ext
    intro degree
    simp [multivariableFlatGaugeDefect,
      multivariablePartialDerivative_coefficient, mul_add]
  have secondDefectMap :
      (multivariableFlatGaugeDefect connection solution first).map
          (multivariablePartialDerivative second) =
        (solution.map (multivariablePartialDerivative first)).map
            (multivariablePartialDerivative second) +
          (connection first * solution).map
            (multivariablePartialDerivative second) := by
    apply Matrix.ext
    intro row column
    apply MvPowerSeries.ext
    intro degree
    simp [multivariableFlatGaugeDefect,
      multivariablePartialDerivative_coefficient, mul_add]
  calc
    _ = ((solution.map (multivariablePartialDerivative second)).map
            (multivariablePartialDerivative first) +
          ((connection second).map (multivariablePartialDerivative first) * solution +
            connection second * solution.map
              (multivariablePartialDerivative first))) -
        ((solution.map (multivariablePartialDerivative first)).map
            (multivariablePartialDerivative second) +
          ((connection first).map (multivariablePartialDerivative second) * solution +
            connection first * solution.map
              (multivariablePartialDerivative second))) := by
          rw [firstDefectMap, secondDefectMap, firstProduct, secondProduct]
    _ = (((connection second).map (multivariablePartialDerivative first) -
            (connection first).map (multivariablePartialDerivative second)) *
              solution +
          connection second * solution.map
            (multivariablePartialDerivative first) -
          connection first * solution.map
            (multivariablePartialDerivative second)) := by
          rw [mixedSolution]
          noncomm_ring
    _ = (-(connection first * connection second -
            connection second * connection first) * solution +
          connection second * solution.map
            (multivariablePartialDerivative first) -
          connection first * solution.map
            (multivariablePartialDerivative second)) := by
          rw [curvatureRearranged]
    _ = _ := by
          simp only [multivariableFlatGaugeDefect]
          noncomm_ring

/-- A chosen coordinate in the support of a nonconstant monomial. -/
noncomputable def multivariablePivot
    {Coordinate : Type*} (degree : Coordinate →₀ ℕ) (nonzero : degree ≠ 0) :
    Coordinate :=
  Classical.choose (Finsupp.support_nonempty_iff.mpr nonzero)

/-- The chosen pivot coordinate belongs to the monomial support. -/
theorem multivariablePivot_mem_support
    {Coordinate : Type*} (degree : Coordinate →₀ ℕ) (nonzero : degree ≠ 0) :
    multivariablePivot degree nonzero ∈ degree.support :=
  Classical.choose_spec (Finsupp.support_nonempty_iff.mpr nonzero)

/-- The exponent at the chosen pivot coordinate is nonzero. -/
theorem multivariablePivot_present
    {Coordinate : Type*} (degree : Coordinate →₀ ℕ) (nonzero : degree ≠ 0) :
    degree (multivariablePivot degree nonzero) ≠ 0 := by
  simpa [Finsupp.mem_support_iff] using
    multivariablePivot_mem_support degree nonzero

/-- A nonzero natural exponent, viewed as a unit in a commutative
`\mathbb{Q}`-algebra. -/
noncomputable def multivariableExponentUnit
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (exponent : ℕ) (nonzero : exponent ≠ 0) : Rˣ :=
  Units.map (algebraMap ℚ R)
    (Units.mk0 (exponent : ℚ) (by exact_mod_cast nonzero))

/-- The value of the exponent unit in the coefficient algebra is the natural
exponent itself. -/
theorem multivariableExponentUnit_coe
    {R : Type*} [CommRing R] [Algebra ℚ R]
    (exponent : ℕ) (nonzero : exponent ≠ 0) :
    (↑(multivariableExponentUnit (R := R) exponent nonzero) : R) = exponent := by
  simp [multivariableExponentUnit]

/-- Coefficients of the normalized multivariable gauge selected recursively in
one support coordinate.  Zero curvature later propagates that selected
coordinate equation to every coordinate. -/
noncomputable def multivariableFlatGaugeCoefficient
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (degree : Coordinate →₀ ℕ) : Matrix Index Index R := by
  classical
  exact (measure multivariableTotalDegree).wf.fix
    (C := fun _ ↦ Matrix Index Index R)
    (fun current recurse ↦
      if currentZero : current = 0 then
        1
      else
        let pivot := multivariablePivot current currentZero;
        let predecessor := current - Finsupp.single pivot 1;
        let exponentUnit := multivariableExponentUnit (R := R)
          (current pivot) (multivariablePivot_present current currentZero);
        -(↑(exponentUnit⁻¹) : R) •
          ∑ pair : {pair // pair ∈
              Finset.HasAntidiagonal.antidiagonal predecessor},
            (connection pivot).map (MvPowerSeries.coeff pair.1.1) *
              recurse pair.1.2 (by
                have pairSum : pair.1.1 + pair.1.2 = predecessor := by
                  exact Finset.HasAntidiagonal.mem_antidiagonal.mp pair.2
                have secondLe : pair.1.2 ≤ predecessor := by
                  calc
                    pair.1.2 ≤ pair.1.1 + pair.1.2 := le_add_left le_rfl
                    _ = predecessor := pairSum
                have secondTotalLe :
                    multivariableTotalDegree pair.1.2 ≤
                      multivariableTotalDegree predecessor :=
                  multivariableTotalDegree_mono secondLe
                have predecessorTotal :
                    multivariableTotalDegree predecessor + 1 =
                      multivariableTotalDegree current := by
                  exact multivariableTotalDegree_sub_single_add_one
                    (multivariablePivot_present current currentZero)
                show multivariableTotalDegree pair.1.2 <
                  multivariableTotalDegree current
                calc
                  multivariableTotalDegree pair.1.2 ≤
                      multivariableTotalDegree predecessor := secondTotalLe
                  _ < multivariableTotalDegree current := by omega))
    degree

/-- The recursively selected gauge has identity constant coefficient. -/
@[simp]
theorem multivariableFlatGaugeCoefficient_zero
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R)) :
    multivariableFlatGaugeCoefficient connection 0 = 1 := by
  classical
  rw [multivariableFlatGaugeCoefficient, WellFounded.fix_eq]
  simp

/-- Unfolding the recursive coefficient at a nonconstant monomial. -/
theorem multivariableFlatGaugeCoefficient_of_ne_zero
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (degree : Coordinate →₀ ℕ) (nonzero : degree ≠ 0) :
    multivariableFlatGaugeCoefficient connection degree =
      let pivot := multivariablePivot degree nonzero;
      let predecessor := degree - Finsupp.single pivot 1;
      let exponentUnit := multivariableExponentUnit (R := R)
        (degree pivot) (multivariablePivot_present degree nonzero);
      -(↑(exponentUnit⁻¹) : R) •
        ∑ pair : {pair // pair ∈
            Finset.HasAntidiagonal.antidiagonal predecessor},
          (connection pivot).map (MvPowerSeries.coeff pair.1.1) *
            multivariableFlatGaugeCoefficient connection pair.1.2 := by
  classical
  rw [multivariableFlatGaugeCoefficient, WellFounded.fix_eq]
  simp only [nonzero]
  rfl

/-- The chosen support-coordinate coefficient satisfies the exact recursive
flat equation. -/
theorem multivariableFlatGaugeCoefficient_pivot_recursion
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (degree : Coordinate →₀ ℕ) (nonzero : degree ≠ 0) :
    (degree (multivariablePivot degree nonzero) : R) •
        multivariableFlatGaugeCoefficient connection degree =
      -∑ pair : {pair // pair ∈
          Finset.HasAntidiagonal.antidiagonal
            (degree - Finsupp.single (multivariablePivot degree nonzero) 1)},
        (connection (multivariablePivot degree nonzero)).map
            (MvPowerSeries.coeff pair.1.1) *
          multivariableFlatGaugeCoefficient connection pair.1.2 := by
  classical
  rw [multivariableFlatGaugeCoefficient_of_ne_zero connection degree nonzero]
  dsimp only
  rw [← multivariableExponentUnit_coe (R := R)
    (degree (multivariablePivot degree nonzero))
    (multivariablePivot_present degree nonzero)]
  let exponentUnit := multivariableExponentUnit (R := R)
    (degree (multivariablePivot degree nonzero))
    (multivariablePivot_present degree nonzero)
  let coefficientSum : Matrix Index Index R :=
    ∑ pair : {pair // pair ∈
        Finset.HasAntidiagonal.antidiagonal
          (degree - Finsupp.single (multivariablePivot degree nonzero) 1)},
      (connection (multivariablePivot degree nonzero)).map
          (MvPowerSeries.coeff pair.1.1) *
        multivariableFlatGaugeCoefficient connection pair.1.2
  change (↑exponentUnit : R) •
      ((-(↑(exponentUnit⁻¹) : R)) • coefficientSum) = -coefficientSum
  rw [smul_smul, mul_neg]
  have inverseIdentity :
      (↑exponentUnit : R) * (↑(exponentUnit⁻¹) : R) = 1 := by
    exact Units.mul_inv exponentUnit
  rw [inverseIdentity, neg_one_smul]

/-- The matrix-valued multivariate formal series assembled from the recursively
selected coefficients. -/
noncomputable def multivariableFlatGaugeSeries
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R)) :
    Matrix Index Index (MvPowerSeries Coordinate R) :=
  fun row column degree ↦
    multivariableFlatGaugeCoefficient connection degree row column

/-- Coefficient extraction from the recursively assembled multivariable
gauge. -/
theorem multivariableFlatGaugeSeries_coefficient
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (degree : Coordinate →₀ ℕ) :
    (multivariableFlatGaugeSeries connection).map
        (MvPowerSeries.coeff degree) =
      multivariableFlatGaugeCoefficient connection degree := by
  rfl

/-- The recursively assembled multivariable gauge is normalized at the origin. -/
theorem multivariableFlatGaugeSeries_normalized
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R)) :
    (multivariableFlatGaugeSeries connection).map (MvPowerSeries.coeff 0) = 1 := by
  rw [multivariableFlatGaugeSeries_coefficient]
  exact multivariableFlatGaugeCoefficient_zero connection

/-- The normalized recursively assembled gauge is an invertible square matrix
over the multivariate formal power-series ring. -/
theorem multivariableFlatGaugeSeries_isUnit
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R)) :
    IsUnit (multivariableFlatGaugeSeries connection) := by
  rw [Matrix.isUnit_iff_isUnit_det]
  rw [MvPowerSeries.isUnit_iff_constantCoeff]
  rw [RingHom.map_det]
  have constantMatrix :
      MvPowerSeries.constantCoeff.mapMatrix
          (multivariableFlatGaugeSeries connection) = 1 := by
    exact multivariableFlatGaugeSeries_normalized connection
  rw [constantMatrix, Matrix.det_one]
  exact isUnit_one

/-- The recursively assembled gauge satisfies the selected pivot-coordinate
equation at every nonconstant monomial. -/
theorem multivariableFlatGaugeSeries_pivot_defect
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (degree : Coordinate →₀ ℕ) (nonzero : degree ≠ 0) :
    (multivariableFlatGaugeDefect connection
        (multivariableFlatGaugeSeries connection)
        (multivariablePivot degree nonzero)).map
      (MvPowerSeries.coeff
        (degree - Finsupp.single (multivariablePivot degree nonzero) 1)) = 0 := by
  classical
  let pivot := multivariablePivot degree nonzero
  let predecessor := degree - Finsupp.single pivot 1
  have pivotPresent : degree pivot ≠ 0 := by
    exact multivariablePivot_present degree nonzero
  have recoverDegree :
      predecessor + Finsupp.single pivot 1 = degree :=
    Finsupp.sub_add_single_one_cancel pivotPresent
  have derivativeCoefficient :
      ((multivariableFlatGaugeSeries connection).map
          (multivariablePartialDerivative pivot)).map
          (MvPowerSeries.coeff predecessor) =
        (predecessor pivot + 1 : R) •
          multivariableFlatGaugeCoefficient connection degree := by
    apply Matrix.ext
    intro row column
    simp only [Matrix.map_apply,
      multivariablePartialDerivative_coefficient, Matrix.smul_apply,
      smul_eq_mul]
    change (predecessor pivot + 1 : R) *
        multivariableFlatGaugeCoefficient connection
          (predecessor + Finsupp.single pivot 1) row column =
      (predecessor pivot + 1 : R) *
        multivariableFlatGaugeCoefficient connection degree row column
    rw [recoverDegree]
  have productCoefficient :
      (connection pivot * multivariableFlatGaugeSeries connection).map
          (MvPowerSeries.coeff predecessor) =
        ∑ pair : {pair // pair ∈
            Finset.HasAntidiagonal.antidiagonal predecessor},
          (connection pivot).map (MvPowerSeries.coeff pair.1.1) *
            multivariableFlatGaugeCoefficient connection pair.1.2 := by
    apply Matrix.ext
    intro row column
    simp only [Matrix.map_apply, Matrix.mul_apply, Matrix.sum_apply]
    rw [map_sum]
    simp_rw [MvPowerSeries.coeff_mul]
    rw [Finset.sum_comm]
    let coefficientTerm :
        ((Coordinate →₀ ℕ) × (Coordinate →₀ ℕ)) → R := fun pair ↦
      ∑ index,
        MvPowerSeries.coeff pair.1 (connection pivot row index) *
          multivariableFlatGaugeCoefficient connection pair.2 index column
    change (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal predecessor,
        coefficientTerm pair) =
      ∑ pair : {pair // pair ∈
          Finset.HasAntidiagonal.antidiagonal predecessor}, coefficientTerm pair.1
    exact Finset.sum_subtype _ (fun _ ↦ Iff.rfl) coefficientTerm
  have pivotExponent : predecessor pivot + 1 = degree pivot := by
    simpa using congrArg (fun monomial ↦ monomial pivot) recoverDegree
  have recursion := multivariableFlatGaugeCoefficient_pivot_recursion
    connection degree nonzero
  change
    ((multivariableFlatGaugeSeries connection).map
        (multivariablePartialDerivative pivot) +
      connection pivot * multivariableFlatGaugeSeries connection).map
        (MvPowerSeries.coeff predecessor) = 0
  rw [show ((multivariableFlatGaugeSeries connection).map
          (multivariablePartialDerivative pivot) +
        connection pivot * multivariableFlatGaugeSeries connection).map
          (MvPowerSeries.coeff predecessor) =
      ((multivariableFlatGaugeSeries connection).map
          (multivariablePartialDerivative pivot)).map
          (MvPowerSeries.coeff predecessor) +
        (connection pivot * multivariableFlatGaugeSeries connection).map
          (MvPowerSeries.coeff predecessor) by rfl]
  rw [derivativeCoefficient, productCoefficient,
    show (predecessor pivot + 1 : R) = degree pivot by
      simpa only [Nat.cast_add, Nat.cast_one] using
        congrArg (fun exponent : ℕ ↦ (exponent : R)) pivotExponent]
  exact eq_neg_iff_add_eq_zero.mp (by simpa [pivot] using recursion)

/-- If a zero-curvature connection equation is imposed recursively in one
chosen support coordinate for every nonconstant monomial, the equation holds
in every coordinate.  The proof propagates the chosen equations by total
degree using the defect compatibility identity. -/
theorem multivariableFlatGaugeDefect_eq_zero_of_pivot
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (solution : Matrix Index Index (MvPowerSeries Coordinate R))
    (curvature : ∀ first second,
      (connection second).map (multivariablePartialDerivative first) -
          (connection first).map (multivariablePartialDerivative second) +
          connection first * connection second -
          connection second * connection first = 0)
    (pivotEquation : ∀ (degree : Coordinate →₀ ℕ) (nonzero : degree ≠ 0),
      (multivariableFlatGaugeDefect connection solution
          (multivariablePivot degree nonzero)).map
        (MvPowerSeries.coeff
          (degree - Finsupp.single (multivariablePivot degree nonzero) 1)) = 0) :
    ∀ coordinate, multivariableFlatGaugeDefect connection solution coordinate = 0 := by
  have coefficientZero : ∀ total : ℕ, ∀ (degree : Coordinate →₀ ℕ),
      multivariableTotalDegree degree = total → ∀ coordinate,
        (multivariableFlatGaugeDefect connection solution coordinate).map
          (MvPowerSeries.coeff degree) = 0 := by
    intro total
    induction total using Nat.strongRecOn with
    | ind total previous =>
        intro degree degreeTotal coordinate
        let augmented := degree + Finsupp.single coordinate 1
        have augmentedNonzero : augmented ≠ 0 := by
          intro equality
          have coordinateEquality :=
            congrArg (fun monomial ↦ monomial coordinate) equality
          simp [augmented] at coordinateEquality
        let pivot := multivariablePivot augmented augmentedNonzero
        have pivotPresent : augmented pivot ≠ 0 :=
          multivariablePivot_present augmented augmentedNonzero
        by_cases pivotIsCoordinate : pivot = coordinate
        · have actualPivot :
              multivariablePivot augmented augmentedNonzero = coordinate := by
            simpa [pivot] using pivotIsCoordinate
          have selected := pivotEquation augmented augmentedNonzero
          rw [actualPivot] at selected
          have predecessor :
              augmented - Finsupp.single coordinate 1 = degree := by
            exact add_tsub_cancel_right degree (Finsupp.single coordinate 1)
          simpa [predecessor] using selected
        · have degreePivotPresent : degree pivot ≠ 0 := by
            have coordinateNePivot : coordinate ≠ pivot := Ne.symm pivotIsCoordinate
            simpa [augmented, coordinateNePivot] using pivotPresent
          let predecessor := degree - Finsupp.single pivot 1
          have recoverDegree :
              predecessor + Finsupp.single pivot 1 = degree :=
            Finsupp.sub_add_single_one_cancel degreePivotPresent
          have predecessorTotal :
              multivariableTotalDegree predecessor + 1 = total := by
            rw [← degreeTotal]
            exact multivariableTotalDegree_sub_single_add_one degreePivotPresent
          have predecessorTotalLt :
              multivariableTotalDegree predecessor < total := by omega
          have selected := pivotEquation augmented augmentedNonzero
          have selectedIndex :
              augmented - Finsupp.single pivot 1 =
                predecessor + Finsupp.single coordinate 1 := by
            exact add_right_cancel (by
              calc
                (augmented - Finsupp.single pivot 1) +
                      Finsupp.single pivot 1 = augmented :=
                  Finsupp.sub_add_single_one_cancel pivotPresent
                _ = degree + Finsupp.single coordinate 1 := rfl
                _ = (predecessor + Finsupp.single coordinate 1) +
                      Finsupp.single pivot 1 := by
                  rw [← recoverDegree]
                  ac_rfl)
          have selectedCoefficient :
              (multivariableFlatGaugeDefect connection solution pivot).map
                (MvPowerSeries.coeff
                  (predecessor + Finsupp.single coordinate 1)) = 0 := by
            simpa [pivot, selectedIndex] using selected
          have compatibility := multivariableFlatGaugeDefect_compatibility
            connection solution curvature pivot coordinate
          have coefficientCompatibility := congrArg
            (fun matrix ↦ matrix.map (MvPowerSeries.coeff predecessor))
            compatibility
          have rightSideZero :
              (connection coordinate *
                    multivariableFlatGaugeDefect connection solution pivot -
                  connection pivot *
                    multivariableFlatGaugeDefect connection solution coordinate).map
                (MvPowerSeries.coeff predecessor) = 0 := by
            have productZero (connectionDirection defectDirection : Coordinate) :
                (connection connectionDirection *
                    multivariableFlatGaugeDefect connection solution
                      defectDirection).map
                  (MvPowerSeries.coeff predecessor) = 0 := by
              apply Matrix.ext
              intro row column
              change MvPowerSeries.coeff predecessor
                ((connection connectionDirection *
                  multivariableFlatGaugeDefect connection solution
                    defectDirection) row column) = 0
              simp only [Matrix.mul_apply, map_sum, MvPowerSeries.coeff_mul]
              apply Finset.sum_eq_zero
              intro index indexMem
              apply Finset.sum_eq_zero
              intro pair pairMem
              have pairSum : pair.1 + pair.2 = predecessor := by
                simpa using pairMem
              have secondLe : pair.2 ≤ predecessor := by
                rw [← pairSum]
                exact le_add_left le_rfl
              have secondTotalLe :
                  multivariableTotalDegree pair.2 ≤
                    multivariableTotalDegree predecessor :=
                multivariableTotalDegree_mono secondLe
              have secondTotalLt : multivariableTotalDegree pair.2 < total :=
                lt_of_le_of_lt secondTotalLe predecessorTotalLt
              have defectCoefficient := previous
                (multivariableTotalDegree pair.2) secondTotalLt pair.2 rfl
                  defectDirection
              rw [show MvPowerSeries.coeff pair.2
                    (multivariableFlatGaugeDefect connection solution
                      defectDirection
                      index column) = 0 by
                exact congrArg (fun matrix ↦ matrix index column) defectCoefficient]
              simp
            calc
              _ = (connection coordinate *
                    multivariableFlatGaugeDefect connection solution pivot).map
                      (MvPowerSeries.coeff predecessor) -
                  (connection pivot *
                    multivariableFlatGaugeDefect connection solution coordinate).map
                      (MvPowerSeries.coeff predecessor) := by
                    apply Matrix.ext
                    intro row column
                    change MvPowerSeries.coeff predecessor
                        ((connection coordinate *
                            multivariableFlatGaugeDefect connection solution pivot -
                          connection pivot *
                            multivariableFlatGaugeDefect connection solution coordinate)
                          row column) = _
                    exact map_sub (MvPowerSeries.coeff predecessor) _ _
              _ = 0 := by
                    rw [productZero coordinate pivot,
                      productZero pivot coordinate, sub_zero]
          rw [rightSideZero] at coefficientCompatibility
          have firstPartialCoefficient :
              ((multivariableFlatGaugeDefect connection solution coordinate).map
                    (multivariablePartialDerivative pivot)).map
                  (MvPowerSeries.coeff predecessor) =
                (predecessor pivot + 1 : R) •
                  (multivariableFlatGaugeDefect connection solution coordinate).map
                    (MvPowerSeries.coeff degree) := by
            apply Matrix.ext
            intro row column
            simp only [Matrix.map_apply,
              multivariablePartialDerivative_coefficient, Matrix.smul_apply,
              smul_eq_mul]
            rw [recoverDegree]
          have secondPartialCoefficient :
              ((multivariableFlatGaugeDefect connection solution pivot).map
                    (multivariablePartialDerivative coordinate)).map
                  (MvPowerSeries.coeff predecessor) = 0 := by
            apply Matrix.ext
            intro row column
            change (predecessor coordinate + 1 : R) *
                MvPowerSeries.coeff
                  (predecessor + Finsupp.single coordinate 1)
                  (multivariableFlatGaugeDefect connection solution pivot
                    row column) = 0
            exact (show (predecessor coordinate + 1 : R) *
                  MvPowerSeries.coeff
                    (predecessor + Finsupp.single coordinate 1)
                    (multivariableFlatGaugeDefect connection solution pivot
                      row column) = 0 by
              rw [show MvPowerSeries.coeff
                    (predecessor + Finsupp.single coordinate 1)
                    (multivariableFlatGaugeDefect connection solution pivot
                      row column) = 0 by
                exact congrArg (fun matrix ↦ matrix row column)
                  selectedCoefficient]
              simp)
          have coefficientCompatibility' :
              ((multivariableFlatGaugeDefect connection solution coordinate).map
                    (multivariablePartialDerivative pivot)).map
                  (MvPowerSeries.coeff predecessor) -
                ((multivariableFlatGaugeDefect connection solution pivot).map
                    (multivariablePartialDerivative coordinate)).map
                  (MvPowerSeries.coeff predecessor) = 0 := by
            calc
              _ = (((multivariableFlatGaugeDefect connection solution coordinate).map
                      (multivariablePartialDerivative pivot) -
                    (multivariableFlatGaugeDefect connection solution pivot).map
                      (multivariablePartialDerivative coordinate)).map
                    (MvPowerSeries.coeff predecessor)) := by
                  apply Matrix.ext
                  intro row column
                  rfl
              _ = 0 := coefficientCompatibility
          have partialPivotCoefficient :
              (predecessor pivot + 1 : R) •
                  (multivariableFlatGaugeDefect connection solution coordinate).map
                    (MvPowerSeries.coeff degree) = 0 := by
            rw [firstPartialCoefficient, secondPartialCoefficient, sub_zero]
              at coefficientCompatibility'
            exact coefficientCompatibility'
          have pivotExponent : predecessor pivot + 1 = degree pivot := by
            simpa using congrArg (fun monomial ↦ monomial pivot) recoverDegree
          have scalarUnit : IsUnit ((predecessor pivot + 1 : R)) := by
            rw [show (predecessor pivot + 1 : R) =
              algebraMap ℚ R ((predecessor pivot : ℚ) + 1) by norm_num]
            exact (isUnit_iff_ne_zero.mpr
              (by positivity : (predecessor pivot : ℚ) + 1 ≠ 0)).map _
          rcases scalarUnit with ⟨unit, unit_eq⟩
          apply Matrix.ext
          intro row column
          have entryZero := congrArg (fun matrix ↦ matrix row column)
            partialPivotCoefficient
          change (predecessor pivot + 1 : R) * _ = 0 at entryZero
          rw [← unit_eq] at entryZero
          have cancelled := congrArg (fun value : R ↦ (↑(unit⁻¹) : R) * value)
            entryZero
          simpa [← mul_assoc] using cancelled
  intro coordinate
  apply Matrix.ext
  intro row column
  apply MvPowerSeries.ext
  intro degree
  exact congrArg (fun matrix ↦ matrix row column)
    (coefficientZero (multivariableTotalDegree degree) degree rfl coordinate)

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

/-- Under zero curvature, the recursively assembled gauge satisfies every
coordinate flat equation. -/
theorem multivariableFlatGaugeSeries_equation_of_curvature
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (curvature : ∀ first second,
      (connection second).map (multivariablePartialDerivative first) -
          (connection first).map (multivariablePartialDerivative second) +
          connection first * connection second -
          connection second * connection first = 0) :
    ∀ coordinate,
      (multivariableFlatGaugeSeries connection).map
          (multivariablePartialDerivative coordinate) =
        -(connection coordinate) * multivariableFlatGaugeSeries connection := by
  have allDefects : ∀ coordinate,
      multivariableFlatGaugeDefect connection
        (multivariableFlatGaugeSeries connection) coordinate = 0 := by
    apply multivariableFlatGaugeDefect_eq_zero_of_pivot
      connection (multivariableFlatGaugeSeries connection) curvature
    exact multivariableFlatGaugeSeries_pivot_defect connection
  intro coordinate
  rw [neg_mul]
  exact eq_neg_iff_add_eq_zero.mpr (by
    simpa only [multivariableFlatGaugeDefect] using allDefects coordinate)

/-- A zero-curvature multivariate formal connection over a commutative
`\mathbb{Q}`-algebra has a unique normalized flat-gauge series.  The constructed
solution is an invertible square matrix over the multivariate power-series
ring. -/
theorem multivariableFlatGaugeSeries_existsUnique_of_curvature
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (curvature : ∀ first second,
      (connection second).map (multivariablePartialDerivative first) -
          (connection first).map (multivariablePartialDerivative second) +
          connection first * connection second -
          connection second * connection first = 0) :
    ∃! solution : Matrix Index Index (MvPowerSeries Coordinate R),
      solution.map (MvPowerSeries.coeff 0) = 1 ∧
      IsUnit solution ∧
      ∀ coordinate,
        solution.map (multivariablePartialDerivative coordinate) =
          -(connection coordinate) * solution := by
  let solution := multivariableFlatGaugeSeries connection
  have equations : ∀ coordinate,
      solution.map (multivariablePartialDerivative coordinate) =
        -(connection coordinate) * solution :=
    multivariableFlatGaugeSeries_equation_of_curvature connection curvature
  refine ⟨solution, ?_, ?_⟩
  · exact ⟨multivariableFlatGaugeSeries_normalized connection,
      multivariableFlatGaugeSeries_isUnit connection, equations⟩
  · intro candidate candidateProperties
    exact multivariableFlatGaugeSeries_unique connection candidate solution
      candidateProperties.1
      (multivariableFlatGaugeSeries_normalized connection)
      candidateProperties.2.2 equations

/-- The normalized flat gauge constructed from zero curvature is natural under
coefficient extension along rational-algebra homomorphisms. -/
theorem multivariableFlatGaugeSeries_map
    {Coordinate Index R S : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index]
    [CommRing R] [CommRing S] [Algebra ℚ R] [Algebra ℚ S]
    (homomorphism : R →ₐ[ℚ] S)
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (curvature : ∀ first second,
      (connection second).map (multivariablePartialDerivative first) -
          (connection first).map (multivariablePartialDerivative second) +
          connection first * connection second -
          connection second * connection first = 0) :
    (multivariableFlatGaugeSeries connection).map
        (MvPowerSeries.map homomorphism.toRingHom) =
      multivariableFlatGaugeSeries
        (fun coordinate ↦ (connection coordinate).map
          (MvPowerSeries.map homomorphism.toRingHom)) := by
  let mappedConnection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate S) := fun coordinate ↦
    (connection coordinate).map (MvPowerSeries.map homomorphism.toRingHom)
  let mappedGauge : Matrix Index Index (MvPowerSeries Coordinate S) :=
    (multivariableFlatGaugeSeries connection).map
      (MvPowerSeries.map homomorphism.toRingHom)
  have mappedCurvature : ∀ first second,
      (mappedConnection second).map (multivariablePartialDerivative first) -
          (mappedConnection first).map (multivariablePartialDerivative second) +
          mappedConnection first * mappedConnection second -
          mappedConnection second * mappedConnection first = 0 := by
    intro first second
    apply Matrix.ext
    intro row column
    apply MvPowerSeries.ext
    intro degree
    have sourceEntry := congrArg
      (fun matrix ↦ MvPowerSeries.coeff degree (matrix row column))
      (curvature first second)
    have mappedEntry := congrArg homomorphism.toRingHom sourceEntry
    simpa [mappedConnection, Matrix.mul_apply, MvPowerSeries.coeff_mul,
      multivariablePartialDerivative_coefficient] using mappedEntry
  have mappedNormalized : mappedGauge.map (MvPowerSeries.coeff 0) = 1 := by
    apply Matrix.ext
    intro row column
    have sourceEntry := congrArg (fun matrix ↦ matrix row column)
      (multivariableFlatGaugeSeries_normalized connection)
    have mappedEntry := congrArg homomorphism.toRingHom sourceEntry
    simpa [mappedGauge, Matrix.one_apply] using mappedEntry
  have mappedEquation : ∀ coordinate,
      mappedGauge.map (multivariablePartialDerivative coordinate) =
        -(mappedConnection coordinate) * mappedGauge := by
    intro coordinate
    apply Matrix.ext
    intro row column
    apply MvPowerSeries.ext
    intro degree
    have sourceEquation :=
      multivariableFlatGaugeSeries_equation_of_curvature
        connection curvature coordinate
    have sourceEntry := congrArg
      (fun matrix ↦ MvPowerSeries.coeff degree (matrix row column))
      sourceEquation
    have mappedEntry := congrArg homomorphism.toRingHom sourceEntry
    simpa [mappedGauge, mappedConnection, Matrix.mul_apply,
      MvPowerSeries.coeff_mul, multivariablePartialDerivative_coefficient]
      using mappedEntry
  exact multivariableFlatGaugeSeries_unique mappedConnection mappedGauge
    (multivariableFlatGaugeSeries mappedConnection) mappedNormalized
    (multivariableFlatGaugeSeries_normalized mappedConnection) mappedEquation
    (multivariableFlatGaugeSeries_equation_of_curvature
      mappedConnection mappedCurvature)

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

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
