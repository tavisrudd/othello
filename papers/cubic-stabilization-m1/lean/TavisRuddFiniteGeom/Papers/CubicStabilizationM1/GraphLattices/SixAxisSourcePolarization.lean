import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisTwoPrimaryDiscriminant
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisDiscriminantSupport
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointIntegralQuotient
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointThreePrimary
import Mathlib.LinearAlgebra.Matrix.Kronecker
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# The polarized six-axis source lattice and its primary discriminants

The six-axis source of the manuscript is the tensor product of an elliptic
curve with the integral quotient of six labelled coordinates by the constant
line.  On integral first homology that source is the tensor product of the
rank-two homology of the elliptic factor with the rank-five coefficient
lattice, and its polarization form is the corresponding Kronecker product.
This module builds that polarized lattice explicitly, over an arbitrary
commutative coefficient ring for the general identities and over the integers
for the numerical ones.

Objects and conventions.  `ellipticWeilPairing` is the alternating unimodular
pairing carried by the rank-two integral first homology of an elliptic curve
written in a symplectic basis, and `sixAxisSourcePolarization` is its
Kronecker product with the five-axis coefficient matrix `6I₅-J₅` of
`sixAxisGram`, indexed by an axis together with a homology coordinate of the
elliptic factor.  Rows and columns are ordered `(axis, homology coordinate)`
throughout.  The polarization is alternating in the sense that its transpose
is its negative and its diagonal vanishes.

Results.  The polarization has determinant `6⁸`.  Consequently a comparison
matrix which pulls back a unimodular alternating form to this polarization has
determinant of absolute value `6⁴` and is injective on the source lattice;
this is the lattice-level form of the degree and finiteness statements for a
relative isogeny onto a principally polarized target, in which the geometric
input is exactly the assertion that the supplied integral matrices are the
ones induced on first homology.  Modulo two the polarization degenerates to
the coordinate-sum map on the elliptic homology coordinates, so the kernel of
its two-torsion reduction is linearly equivalent to four copies of that
rank-two coordinate module; this is the coefficient-side identification of the
two-primary discriminant with `H₂ ⊗ E[2]`, with `H₂` presented in its
four-coordinate normalization.  Finally, on augmentation lifts the
six-coordinate coefficient form is six times the dot product, which is what
makes its quotients by two and by three the dot product and its negative
modulo the respective prime, and makes the normalization independent of the
chosen lift.

Trust boundary.  No abelian scheme, elliptic scheme, torsion local system,
Weil pairing of an actual elliptic curve, relative isogeny, or geometric group
action is constructed here.  Every statement is about explicit integral or
finite-field matrices and modules; the identification of those matrices with
geometric homology is supplied elsewhere and is not proved by this module.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped BigOperators
open scoped Kronecker
open scoped Matrix

/-- The alternating unimodular pairing on the rank-two integral first homology
of an elliptic curve, written in a symplectic basis. -/
def ellipticWeilPairing (R : Type*) [CommRing R] : Matrix (Fin 2) (Fin 2) R :=
  !![0, 1; -1, 0]

/-- The elliptic homology pairing is alternating: exchanging its arguments
reverses the sign. -/
theorem ellipticWeilPairing_swap
    (R : Type*) [CommRing R] (left right : Fin 2) :
    ellipticWeilPairing R right left = - ellipticWeilPairing R left right := by
  fin_cases left <;> fin_cases right <;> simp [ellipticWeilPairing]

/-- The elliptic homology pairing is unimodular. -/
theorem ellipticWeilPairing_det (R : Type*) [CommRing R] :
    (ellipticWeilPairing R).det = 1 := by
  simp [ellipticWeilPairing, Matrix.det_fin_two_of]

/-- The polarization form of the six-axis source on integral first homology,
in the chart omitting one axis: the Kronecker product of the five-axis
coefficient matrix `6I₅-J₅` with the elliptic homology pairing.  Rows and
columns are indexed by an axis together with a homology coordinate of the
elliptic factor. -/
def sixAxisSourcePolarization (R : Type*) [CommRing R] :
    Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) R :=
  sixAxisGram R ⊗ₖ ellipticWeilPairing R

/-- The five-axis coefficient matrix is symmetric. -/
theorem sixAxisGram_symm
    (R : Type*) [CommRing R] (row column : Fin 5) :
    sixAxisGram R column row = sixAxisGram R row column := by
  by_cases equalIndices : row = column
  · rw [equalIndices]
  · simp [sixAxisGram, equalIndices, Ne.symm equalIndices]

/-- Entry formula for the source polarization. -/
theorem sixAxisSourcePolarization_apply
    (R : Type*) [CommRing R] (row column : Fin 5) (rowSpin columnSpin : Fin 2) :
    sixAxisSourcePolarization R (row, rowSpin) (column, columnSpin) =
      sixAxisGram R row column * ellipticWeilPairing R rowSpin columnSpin :=
  rfl

/-- The source polarization is alternating: its transpose is its negative. -/
theorem sixAxisSourcePolarization_transpose
    (R : Type*) [CommRing R] :
    (sixAxisSourcePolarization R)ᵀ = - sixAxisSourcePolarization R := by
  ext rowIndex columnIndex
  obtain ⟨row, rowSpin⟩ := rowIndex
  obtain ⟨column, columnSpin⟩ := columnIndex
  rw [Matrix.transpose_apply, sixAxisSourcePolarization_apply,
    Matrix.neg_apply, sixAxisSourcePolarization_apply, sixAxisGram_symm,
    ellipticWeilPairing_swap]
  ring

/-- The source polarization has vanishing diagonal. -/
theorem sixAxisSourcePolarization_diagonal_eq_zero
    (R : Type*) [CommRing R] (index : Fin 5 × Fin 2) :
    sixAxisSourcePolarization R index index = 0 := by
  obtain ⟨axis, spin⟩ := index
  rw [sixAxisSourcePolarization_apply]
  fin_cases spin <;> simp [ellipticWeilPairing]

/-- The Smith diagonal has determinant `6⁴`. -/
theorem sixAxisSmithDiagonal_det : sixAxisSmithDiagonal.det = 1296 := by
  rw [sixAxisSmithDiagonal_eq_diagonal, Matrix.det_diagonal]
  norm_num [Fin.prod_univ_succ]

/-- The row operation of the Smith reduction has determinant a square root of
one, being an integral matrix with an integral inverse. -/
theorem sixAxisSmithLeft_det_sq : sixAxisSmithLeft.det ^ 2 = 1 := by
  have product : sixAxisSmithLeft.det * sixAxisSmithLeftInverse.det = 1 := by
    rw [← Matrix.det_mul, sixAxisSmithLeft_mul_inverse, Matrix.det_one]
  rcases Int.eq_one_or_neg_one_of_mul_eq_one product with value | value <;>
    rw [value] <;> norm_num

/-- The column operation of the Smith reduction likewise has determinant a
square root of one. -/
theorem sixAxisSmithRight_det_sq : sixAxisSmithRight.det ^ 2 = 1 := by
  have product : sixAxisSmithRight.det * sixAxisSmithRightInverse.det = 1 := by
    rw [← Matrix.det_mul, sixAxisSmithRight_mul_inverse, Matrix.det_one]
  rcases Int.eq_one_or_neg_one_of_mul_eq_one product with value | value <;>
    rw [value] <;> norm_num

/-- The five-axis coefficient matrix has determinant of absolute value `6⁴`,
read off from its integral Smith reduction. -/
theorem sixAxisGram_det_sq : (sixAxisGram ℤ).det ^ 2 = 6 ^ 8 := by
  have reduction := congrArg Matrix.det sixAxisGram_smith_reduction
  rw [Matrix.det_mul, Matrix.det_mul, sixAxisSmithDiagonal_det] at reduction
  have squared : sixAxisSmithLeft.det ^ 2 * (sixAxisGram ℤ).det ^ 2 *
      sixAxisSmithRight.det ^ 2 = 1296 ^ 2 := by
    rw [← mul_pow, ← mul_pow, reduction]
  rw [sixAxisSmithLeft_det_sq, sixAxisSmithRight_det_sq, one_mul, mul_one] at squared
  rw [squared]
  norm_num

/-- The integral source polarization has determinant `6⁸`. -/
theorem sixAxisSourcePolarization_det :
    (sixAxisSourcePolarization ℤ).det = 6 ^ 8 := by
  rw [sixAxisSourcePolarization, Matrix.det_kronecker, ellipticWeilPairing_det,
    one_pow, mul_one, Fintype.card_fin, sixAxisGram_det_sq]

/-- A comparison matrix pulling a unimodular form back to the source
polarization has determinant with square `6⁸`.  This is the lattice-level
degree calculation for a relative isogeny onto a principally polarized
target. -/
theorem sixAxisPolarizationPullback_det_sq
    {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}
    (principal : target.det = 1)
    (pullback :
      comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    comparison.det ^ 2 = 6 ^ 8 := by
  have determinants := congrArg Matrix.det pullback
  rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose, principal,
    sixAxisSourcePolarization_det] at determinants
  rw [← determinants]
  ring

/-- The same comparison matrix has determinant of absolute value `6⁴`. -/
theorem sixAxisPolarizationPullback_natAbs_det
    {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}
    (principal : target.det = 1)
    (pullback :
      comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    comparison.det.natAbs = 6 ^ 4 := by
  have squared := sixAxisPolarizationPullback_det_sq principal pullback
  have naturalSquare : comparison.det.natAbs ^ 2 = (6 ^ 4) ^ 2 := by
    have := congrArg Int.natAbs squared
    simpa [Int.natAbs_pow] using this
  exact Nat.pow_left_injective (by norm_num) naturalSquare

/-- The comparison matrix has nonzero determinant. -/
theorem sixAxisPolarizationPullback_det_ne_zero
    {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}
    (principal : target.det = 1)
    (pullback :
      comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    comparison.det ≠ 0 := by
  intro vanishing
  have squared := sixAxisPolarizationPullback_det_sq principal pullback
  rw [vanishing] at squared
  norm_num at squared

/-- The comparison matrix is injective on the integral source lattice, which
is the lattice-level finiteness of the corresponding relative isogeny. -/
theorem sixAxisPolarizationPullback_mulVec_injective
    {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}
    (principal : target.det = 1)
    (pullback :
      comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Function.Injective comparison.mulVec := by
  have determinantNonzero :=
    sixAxisPolarizationPullback_det_ne_zero principal pullback
  intro left right equalImages
  have differenceVanishes : comparison.mulVec (left - right) = 0 := by
    rw [Matrix.mulVec_sub, equalImages, sub_self]
  have scaled : comparison.det • (left - right) = 0 := by
    have adjugateApplied :=
      congrArg (fun vector ↦ comparison.adjugate.mulVec vector) differenceVanishes
    simpa [Matrix.mulVec_mulVec, Matrix.adjugate_mul, Matrix.smul_mulVec,
      Matrix.one_mulVec] using adjugateApplied
  rcases smul_eq_zero.mp scaled with determinantZero | differenceZero
  · exact absurd determinantZero determinantNonzero
  · exact sub_eq_zero.mp differenceZero

/-- Modulo two the five-axis coefficient matrix has every entry one. -/
theorem sixAxisGram_two_eq_one (row column : Fin 5) :
    sixAxisGram F2 row column = 1 := by
  have expanded : sixAxisGram F2 row column =
      6 * (if row = column then 1 else 0) - 1 := rfl
  rw [expanded]
  by_cases equalIndices : row = column
  · rw [if_pos equalIndices]; decide
  · rw [if_neg equalIndices]; decide

/-- Modulo two the source polarization acts through the elliptic homology
pairing on the axis-wise coordinate sums. -/
theorem sixAxisSourcePolarization_two_mulVec_apply
    (vector : Fin 5 × Fin 2 → F2) (axis : Fin 5) (spin : Fin 2) :
    (sixAxisSourcePolarization F2).mulVec vector (axis, spin) =
      ∑ otherSpin : Fin 2, ellipticWeilPairing F2 spin otherSpin *
        ∑ otherAxis : Fin 5, vector (otherAxis, otherSpin) := by
  rw [Matrix.mulVec, dotProduct, Fintype.sum_prod_type]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl ?_
  intro otherSpin _
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl ?_
  intro otherAxis _
  rw [sixAxisSourcePolarization_apply, sixAxisGram_two_eq_one, one_mul]

/-- Modulo two the source polarization is degenerate exactly on the vectors
whose coordinate sum vanishes along every elliptic homology coordinate. -/
theorem sixAxisSourcePolarization_two_mulVec_eq_zero_iff
    (vector : Fin 5 × Fin 2 → F2) :
    (sixAxisSourcePolarization F2).mulVec vector = 0 ↔
      ∀ spin : Fin 2, ∑ axis : Fin 5, vector (axis, spin) = 0 := by
  constructor
  · intro vanishing spin
    have firstRow := congrFun vanishing (0, 0)
    have secondRow := congrFun vanishing (0, 1)
    rw [sixAxisSourcePolarization_two_mulVec_apply] at firstRow secondRow
    simp [Fin.sum_univ_two, ellipticWeilPairing] at firstRow secondRow
    fin_cases spin
    · simpa using secondRow
    · simpa using firstRow
  · intro sumsVanish
    funext index
    obtain ⟨axis, spin⟩ := index
    rw [sixAxisSourcePolarization_two_mulVec_apply]
    simp [sumsVanish]

/-- The two-primary discriminant of the six-axis source polarization: the
kernel of its two-torsion reduction. -/
def sixAxisSourceTwoPrimaryDiscriminant : Submodule F2 (Fin 5 × Fin 2 → F2) :=
  LinearMap.ker (Matrix.mulVecLin (sixAxisSourcePolarization F2))

/-- Currying the source coordinates presents a two-torsion source vector as an
axis-indexed family of elliptic homology vectors. -/
def sixAxisSourceCurry :
    (Fin 5 × Fin 2 → F2) ≃ₗ[F2] (Fin 5 → Fin 2 → F2) :=
  LinearEquiv.curry F2 F2 (Fin 5) (Fin 2)

/-- Under currying, the two-primary discriminant of the source polarization is
the tensor-extended coefficient discriminant with the rank-two elliptic
homology module as tensor factor. -/
theorem sixAxisSourceTwoPrimaryDiscriminant_map_curry :
    Submodule.map (sixAxisSourceCurry : (Fin 5 × Fin 2 → F2) →ₗ[F2] _)
        sixAxisSourceTwoPrimaryDiscriminant =
      SixAxisTwoPrimaryDiscriminant (Fin 2 → F2) := by
  ext curried
  rw [Submodule.mem_map_equiv]
  simp only [sixAxisSourceTwoPrimaryDiscriminant, SixAxisTwoPrimaryDiscriminant,
    LinearMap.mem_ker, Matrix.mulVecLin_apply, sixAxisGramTensorLinearMap,
    LinearMap.coe_mk, AddHom.coe_mk]
  rw [sixAxisSourcePolarization_two_mulVec_eq_zero_iff,
    sixAxisGramTensorMap_eq_zero_iff_sum_zero]
  constructor
  · intro sums
    funext spin
    simpa [sixAxisSourceCurry] using sums spin
  · intro sumZero spin
    simpa [sixAxisSourceCurry] using congrFun sumZero spin

/-- The two-primary discriminant of the source polarization is linearly
equivalent to four copies of the rank-two elliptic homology module.  This is
the coefficient-side identification of the two-primary discriminant with
`H₂ ⊗ E[2]`, with the coefficient heart in its four-coordinate
normalization. -/
noncomputable def sixAxisSourceTwoPrimaryDiscriminantCoordinates :
    sixAxisSourceTwoPrimaryDiscriminant ≃ₗ[F2] (Fin 4 → Fin 2 → F2) :=
  (sixAxisSourceCurry.submoduleMap sixAxisSourceTwoPrimaryDiscriminant).trans
    ((LinearEquiv.ofEq _ _ sixAxisSourceTwoPrimaryDiscriminant_map_curry).trans
      (sixAxisTwoPrimaryDiscriminantLinearEquiv (Fin 2 → F2)).symm)

/-- The coordinate-sum map on five copies of a module. -/
def fiveCoordinateSum (R T : Type*) [CommRing R] [AddCommGroup T] [Module R T] :
    (Fin 5 → T) →ₗ[R] T :=
  ∑ index : Fin 5, LinearMap.proj index

/-- The coordinate-sum map is the sum of the five coordinates. -/
theorem fiveCoordinateSum_apply
    {R T : Type*} [CommRing R] [AddCommGroup T] [Module R T]
    (vector : Fin 5 → T) :
    fiveCoordinateSum R T vector = ∑ index, vector index := by
  simp [fiveCoordinateSum, LinearMap.sum_apply]

/-- The submodule of five-coordinate vectors whose coordinate sum vanishes. -/
def fiveCoordinateSumZero (R T : Type*) [CommRing R] [AddCommGroup T]
    [Module R T] : Submodule R (Fin 5 → T) :=
  LinearMap.ker (fiveCoordinateSum R T)

/-- Four free coordinates determine a vector of vanishing coordinate sum; the
fifth coordinate is the negative of their sum. -/
def fiveCoordinateSumZeroRepresentative
    {T : Type*} [AddCommGroup T] (coordinates : Fin 4 → T) : Fin 5 → T :=
  ![coordinates 0, coordinates 1, coordinates 2, coordinates 3,
    -(∑ index, coordinates index)]

/-- The displayed representative has vanishing coordinate sum. -/
theorem fiveCoordinateSumZeroRepresentative_sum
    {T : Type*} [AddCommGroup T] (coordinates : Fin 4 → T) :
    ∑ index, fiveCoordinateSumZeroRepresentative coordinates index = 0 := by
  simp [fiveCoordinateSumZeroRepresentative, Fin.sum_univ_succ]
  abel

/-- Vanishing coordinate sum is exactly four free coordinates. -/
def fiveCoordinateSumZeroEquiv (R T : Type*) [CommRing R] [AddCommGroup T]
    [Module R T] : (Fin 4 → T) ≃ₗ[R] fiveCoordinateSumZero R T where
  toFun coordinates :=
    ⟨fiveCoordinateSumZeroRepresentative coordinates, by
      simp [fiveCoordinateSumZero, LinearMap.mem_ker, fiveCoordinateSum_apply,
        fiveCoordinateSumZeroRepresentative_sum]⟩
  invFun vector := fun index ↦ vector.1 index.castSucc
  left_inv coordinates := by
    funext index
    fin_cases index <;> rfl
  right_inv vector := by
    apply Subtype.ext
    funext index
    have sumZero : ∑ coordinate : Fin 5, vector.1 coordinate = 0 := by
      have membership : fiveCoordinateSum R T vector.1 = 0 :=
        LinearMap.mem_ker.mp vector.2
      rwa [fiveCoordinateSum_apply] at membership
    fin_cases index
    · rfl
    · rfl
    · rfl
    · rfl
    · show -(∑ coordinate : Fin 4, vector.1 coordinate.castSucc) = vector.1 4
      have expanded :
          (∑ coordinate : Fin 4, vector.1 coordinate.castSucc) + vector.1 4 = 0 := by
        calc
          (∑ coordinate : Fin 4, vector.1 coordinate.castSucc) + vector.1 4 =
              ∑ coordinate : Fin 5, vector.1 coordinate := by
            simp [Fin.sum_univ_succ]
            abel
          _ = 0 := sumZero
      linear_combination (norm := abel) -expanded
  map_add' left right := by
    apply Subtype.ext
    funext index
    fin_cases index <;>
      (simp [fiveCoordinateSumZeroRepresentative, Finset.sum_add_distrib]; try abel)
  map_smul' scalar vector := by
    apply Subtype.ext
    funext index
    fin_cases index <;>
      simp [fiveCoordinateSumZeroRepresentative, Finset.smul_sum]

/-- Modulo three the five-axis coefficient matrix has every entry minus one. -/
theorem sixAxisGram_three_eq_neg_one (row column : Fin 5) :
    sixAxisGram F3 row column = -1 := by
  have expanded : sixAxisGram F3 row column =
      6 * (if row = column then 1 else 0) - 1 := rfl
  rw [expanded]
  by_cases equalIndices : row = column
  · rw [if_pos equalIndices]; decide
  · rw [if_neg equalIndices]; decide

/-- Modulo three the source polarization acts through the elliptic homology
pairing on the negated axis-wise coordinate sums. -/
theorem sixAxisSourcePolarization_three_mulVec_apply
    (vector : Fin 5 × Fin 2 → F3) (axis : Fin 5) (spin : Fin 2) :
    (sixAxisSourcePolarization F3).mulVec vector (axis, spin) =
      ∑ otherSpin : Fin 2, (-1 : F3) * ellipticWeilPairing F3 spin otherSpin *
        ∑ otherAxis : Fin 5, vector (otherAxis, otherSpin) := by
  rw [Matrix.mulVec, dotProduct, Fintype.sum_prod_type]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl ?_
  intro otherSpin _
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl ?_
  intro otherAxis _
  rw [sixAxisSourcePolarization_apply, sixAxisGram_three_eq_neg_one]

/-- Modulo three the source polarization is degenerate exactly on the vectors
whose coordinate sum vanishes along every elliptic homology coordinate. -/
theorem sixAxisSourcePolarization_three_mulVec_eq_zero_iff
    (vector : Fin 5 × Fin 2 → F3) :
    (sixAxisSourcePolarization F3).mulVec vector = 0 ↔
      ∀ spin : Fin 2, ∑ axis : Fin 5, vector (axis, spin) = 0 := by
  constructor
  · intro vanishing spin
    have firstRow := congrFun vanishing (0, 0)
    have secondRow := congrFun vanishing (0, 1)
    rw [sixAxisSourcePolarization_three_mulVec_apply] at firstRow secondRow
    simp [Fin.sum_univ_two, ellipticWeilPairing] at firstRow secondRow
    fin_cases spin
    · simpa using secondRow
    · simpa using firstRow
  · intro sumsVanish
    funext index
    obtain ⟨axis, spin⟩ := index
    rw [sixAxisSourcePolarization_three_mulVec_apply]
    simp [sumsVanish]

/-- The three-primary discriminant of the six-axis source polarization: the
kernel of its three-torsion reduction. -/
def sixAxisSourceThreePrimaryDiscriminant : Submodule F3 (Fin 5 × Fin 2 → F3) :=
  LinearMap.ker (Matrix.mulVecLin (sixAxisSourcePolarization F3))

/-- Currying the three-torsion source coordinates. -/
def sixAxisSourceThreeCurry :
    (Fin 5 × Fin 2 → F3) ≃ₗ[F3] (Fin 5 → Fin 2 → F3) :=
  LinearEquiv.curry F3 F3 (Fin 5) (Fin 2)

/-- Under currying, the three-primary discriminant of the source polarization
is the coordinate-sum-zero submodule of five copies of the rank-two
three-torsion module. -/
theorem sixAxisSourceThreePrimaryDiscriminant_map_curry :
    Submodule.map (sixAxisSourceThreeCurry : (Fin 5 × Fin 2 → F3) →ₗ[F3] _)
        sixAxisSourceThreePrimaryDiscriminant =
      fiveCoordinateSumZero F3 (Fin 2 → F3) := by
  ext curried
  rw [Submodule.mem_map_equiv]
  simp only [sixAxisSourceThreePrimaryDiscriminant, fiveCoordinateSumZero,
    LinearMap.mem_ker, Matrix.mulVecLin_apply, fiveCoordinateSum_apply]
  rw [sixAxisSourcePolarization_three_mulVec_eq_zero_iff]
  constructor
  · intro sums
    funext spin
    simpa [sixAxisSourceThreeCurry] using sums spin
  · intro sumZero spin
    simpa [sixAxisSourceThreeCurry] using congrFun sumZero spin

/-- The three-primary discriminant of the source polarization is linearly
equivalent to four copies of the rank-two three-torsion module.  This is the
coefficient-side identification of the three-primary discriminant with
`H₃ ⊗ E[3]`, with the coefficient heart in its four-coordinate
normalization. -/
noncomputable def sixAxisSourceThreePrimaryDiscriminantCoordinates :
    sixAxisSourceThreePrimaryDiscriminant ≃ₗ[F3] (Fin 4 → Fin 2 → F3) :=
  (sixAxisSourceThreeCurry.submoduleMap sixAxisSourceThreePrimaryDiscriminant).trans
    ((LinearEquiv.ofEq _ _ sixAxisSourceThreePrimaryDiscriminant_map_curry).trans
      (fiveCoordinateSumZeroEquiv F3 (Fin 2 → F3)).symm)

/-- On augmentation lifts the six-coordinate coefficient form is six times the
dot product. -/
theorem sixPointIntegralQuotientPairing_of_sum_zero
    (left right : Fin 6 → ℤ) (augmentation : ∑ index, left index = 0) :
    sixPointIntegralQuotientPairing left right =
      6 * ∑ index, left index * right index := by
  simp only [sixPointIntegralQuotientPairing, augmentation, zero_mul, sub_zero]

/-- Halving the six-coordinate coefficient form on augmentation lifts gives
the dot product modulo two. -/
theorem sixPointIntegralQuotientPairing_two_normalization
    (left right : Fin 6 → ℤ) (augmentation : ∑ index, left index = 0) :
    sixPointIntegralQuotientPairing left right =
        2 * (3 * ∑ index, left index * right index) ∧
      ((3 * ∑ index, left index * right index : ℤ) : ZMod 2) =
        ((∑ index, left index * right index : ℤ) : ZMod 2) := by
  refine ⟨by rw [sixPointIntegralQuotientPairing_of_sum_zero left right augmentation]; ring, ?_⟩
  push_cast
  rw [show (3 : ZMod 2) = 1 by decide, one_mul]

/-- Dividing the six-coordinate coefficient form by three on augmentation
lifts gives the negative of the dot product modulo three. -/
theorem sixPointIntegralQuotientPairing_three_normalization
    (left right : Fin 6 → ℤ) (augmentation : ∑ index, left index = 0) :
    sixPointIntegralQuotientPairing left right =
        3 * (2 * ∑ index, left index * right index) ∧
      ((2 * ∑ index, left index * right index : ℤ) : ZMod 3) =
        - ((∑ index, left index * right index : ℤ) : ZMod 3) := by
  refine ⟨by rw [sixPointIntegralQuotientPairing_of_sum_zero left right augmentation]; ring, ?_⟩
  push_cast
  rw [show (2 : ZMod 3) = -1 by decide]
  ring

/-- Against an augmentation lift the six-coordinate coefficient form is
divisible by six.  Changing a lift by a multiple of two or of three therefore
leaves the corresponding normalized form unchanged. -/
theorem sixPointIntegralQuotientPairing_dvd_six_of_sum_zero
    (left right : Fin 6 → ℤ) (augmentation : ∑ index, right index = 0) :
    (6 : ℤ) ∣ sixPointIntegralQuotientPairing left right := by
  rw [sixPointIntegralQuotientPairing_comm,
    sixPointIntegralQuotientPairing_of_sum_zero right left augmentation]
  exact Dvd.intro _ rfl

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
