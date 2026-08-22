import Mathlib

/-!
# Threefold grading and cubic Kummer compatibility

This file records finite linear models and a dimension lemma relevant to a
proposed dimension bound for cyclic packets of rank-two blocks.

The first model has the six grading eigenvalues of the even cohomology of a
Picard-rank-two threefold, a perfect Poincare-type pairing, and branchwise
modified-residue discriminant `4/9`.  It therefore shows that those three
linear conditions do not by themselves exclude three cyclic copies of the
marked rank-two block.  The same model fails the displayed logarithmic
homogeneity equation for the cubic Kummer coordinate.

The second model is the classical-limit algebra
`Q[x, e] / (x^3, e^2)`.  Multiplication by `x + e` has Jordan type
`J_4 direct-sum J_2`, as witnessed by an explicit invertible chain basis, and
is self-adjoint for the coefficient-of-`x^2 e` pairing.  These calculations
do not assert that the first model is a quantum cohomology ring.  A geometric
application still requires the divisor, homogeneity, WDVV, and classical-limit
identifications of an actual quantum connection.

A strict cubic dual-number model verifies the first two normalized
Sylvester recurrences and gives modified-residue discriminant zero.  A
separate noncommutative matrix lemma proves the compression identities used
by this calculation, including the gauge-derivative term.

The abstract lemma says that `n` cyclically equivalent pieces of total
dimension `2n` all have dimension two.  A distinguished piece contained in a
two-dimensional residue class therefore exhausts that class.  This statement
does not construct the residue splitting, the cyclic transports, or an
effective coefficient lattice.

A final scalar lemma checks the contradiction among the three weight
equations obtained after reducing a proposed degree-one-unit gauge.  The
derivation of those equations from flat quantum-connection data is not part
of this file.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ThreefoldKummerCompatibility

abbrev BlockIndex := Fin 2
abbrev ThreefoldIndex := Fin 6

/-- The square-zero operator on one rank-two block. -/
def blockNilpotent : Matrix BlockIndex BlockIndex ℚ :=
  !![0, 1; 0, 0]

/-- A split pairing on one rank-two block. -/
def blockPairing : Matrix BlockIndex BlockIndex ℚ :=
  !![0, 1; 1, 0]

/-- A representative of the modified-residue conjugacy class with
eigenvalues `-1/6` and `-5/6`. -/
def blockResidue : Matrix BlockIndex BlockIndex ℚ :=
  !![-1 / 6, 0; 0, -5 / 6]

/-- The rank-two local data satisfy square-zero nilpotence, self-adjointness
of the nilpotent part, and the weight-minus-one residue pairing law. -/
theorem block_pairing_compatibility :
    blockNilpotent * blockNilpotent = 0 ∧
      blockNilpotent.transpose * blockPairing = blockPairing * blockNilpotent ∧
      blockResidue.transpose * blockPairing + blockPairing * blockResidue =
        -blockPairing := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [blockNilpotent, Matrix.mul_apply]
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [blockNilpotent, blockPairing, Matrix.mul_apply]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [blockResidue, blockPairing, Matrix.mul_apply]

/-- The representative modified residue has discriminant `4/9`. -/
theorem blockResidue_discriminant :
    blockResidue.trace ^ 2 - 4 * blockResidue.det = 4 / 9 := by
  norm_num [blockResidue, Matrix.trace, Matrix.det_fin_two]

/-- The Poincare-type pairing in the ordered basis
`1, e, x, x e, x^2, x^2 e`. -/
def threefoldPairing : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0]

/-- The ordinary dimension-three grading in the ordered basis
`1, e, x, x e, x^2, x^2 e`. -/
def productGrading : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![-3 / 2, 0, 0, 0, 0, 0;
     0, -1 / 2, 0, 0, 0, 0;
     0, 0, -1 / 2, 0, 0, 0;
     0, 0, 0, 1 / 2, 0, 0;
     0, 0, 0, 0, 1 / 2, 0;
     0, 0, 0, 0, 0, 3 / 2]

/-- A second grading with the same multiset of eigenvalues.  Its three
successive two-dimensional compressions average to exponents `-1/6, 1/6`. -/
def residueVisibleGrading : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![-3 / 2, 0, 0, 0, 0, 0;
     0, -1 / 2, 0, 0, 0, 0;
     0, 0, 1 / 2, 0, 0, 0;
     0, 0, 0, -1 / 2, 0, 0;
     0, 0, 0, 0, 1 / 2, 0;
     0, 0, 0, 0, 0, 3 / 2]

/-- Both displayed gradings are skew-adjoint for the same perfect pairing. -/
theorem grading_pairing_compatibility :
    productGrading.transpose * threefoldPairing +
        threefoldPairing * productGrading = 0 ∧
      residueVisibleGrading.transpose * threefoldPairing +
        threefoldPairing * residueVisibleGrading = 0 := by
  constructor <;>
    ext i j <;>
    fin_cases i <;> fin_cases j <;>
      norm_num [productGrading, residueVisibleGrading, threefoldPairing,
        Matrix.mul_apply, Fin.sum_univ_succ]

/-- The branchwise diagonal compression of the residue-visible grading. -/
def residueVisibleBranchCompression : Matrix BlockIndex BlockIndex ℚ :=
  !![-1 / 6, 0; 0, 1 / 6]

/-- Averaging the three displayed character blocks gives the
residue-visible branch compression. -/
theorem residueVisible_branch_compression_value :
    residueVisibleBranchCompression =
      !![((-3 / 2 : ℚ) + (1 / 2) + (1 / 2)) / 3, 0;
         0, ((-1 / 2 : ℚ) + (-1 / 2) + (3 / 2)) / 3] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [residueVisibleBranchCompression]

/-- Elementary modification keeps the first compressed exponent and lowers
the second by one. -/
def modifiedResidueOfCompression
    (compression : Matrix BlockIndex BlockIndex ℚ) :
    Matrix BlockIndex BlockIndex ℚ :=
  !![compression 0 0, 1; 0, compression 1 1 - 1]

/-- The elementary modification of the residue-visible compression has
discriminant `4/9`. -/
theorem residueVisible_compressed_residue_discriminant :
    let residue := modifiedResidueOfCompression residueVisibleBranchCompression
    residue.trace ^ 2 - 4 * residue.det = 4 / 9 := by
  norm_num [modifiedResidueOfCompression, residueVisibleBranchCompression,
    Matrix.trace, Matrix.det_fin_two]

/-- Multiplication by `x` on the cubic Kummer algebra at `x^3 = 1`, in the
ordered basis `1, e, x, x e, x^2, x^2 e`. -/
def cubicMultiplication : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1;
     1, 0, 0, 0, 0, 0;
     0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 1, 0, 0]

/-- The derivative of multiplication by `x` with respect to the logarithmic
Kummer parameter, before the factor three in the Euler field. -/
def cubicWrap : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0]

/-- The ordinary grading satisfies the logarithmic homogeneity equation for
the cubic Kummer coordinate. -/
theorem productGrading_logarithmic_homogeneity :
    cubicMultiplication + cubicMultiplication * productGrading -
        productGrading * cubicMultiplication = 3 • cubicWrap := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [cubicMultiplication, cubicWrap, productGrading,
      Matrix.mul_apply, Fin.sum_univ_succ]

/-- The left side of the logarithmic homogeneity equation for the
residue-visible grading. -/
def residueVisibleHomogeneityLeft : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, 0, 0, 3, 0;
     0, 0, 0, 0, 0, 3;
     -1, 0, 0, 0, 0, 0;
     0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, -1, 0, 0]

theorem residueVisibleHomogeneityLeft_value :
    cubicMultiplication + cubicMultiplication * residueVisibleGrading -
        residueVisibleGrading * cubicMultiplication =
      residueVisibleHomogeneityLeft := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [cubicMultiplication, residueVisibleGrading,
      residueVisibleHomogeneityLeft, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The residue-visible grading violates that logarithmic homogeneity
equation. -/
theorem residueVisibleGrading_logarithmic_homogeneity_fails :
    cubicMultiplication + cubicMultiplication * residueVisibleGrading -
        residueVisibleGrading * cubicMultiplication ≠ 3 • cubicWrap := by
  intro equality
  rw [residueVisibleHomogeneityLeft_value] at equality
  have entryEquality := Matrix.ext_iff.mpr equality
    (Fin.succ (Fin.succ (0 : Fin 4))) (0 : ThreefoldIndex)
  simp [residueVisibleHomogeneityLeft, cubicWrap, Matrix.of_apply] at entryEquality

/-- Multiplication by the square-zero generator `e` in
`Q[x,e]/(x^3-1,e^2)`, in the ordered basis
`1, e, x, x e, x^2, x^2 e`. -/
def dualNumberMultiplication : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 1, 0]

/-- Multiplication by `3x+2e` on the cubic dual-number algebra.  Its three
eigenvalues are the cube-root translates of `3`, each with one rank-two
Jordan block. -/
def strictCubicEuler : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  3 • cubicMultiplication + 2 • dualNumberMultiplication

/-- A rational basis separating the rank-two block of `strictCubicEuler` at
the eigenvalue `3` from the complementary quadratic factor. -/
def strictCubicJordanBasis : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 1, 0, 0, 1, 0;
     1, 0, 1, 0, 0, 0;
     0, 1, 0, 0, -1, 1;
     1, 0, -1, 1, 0, 0;
     0, 1, 0, 0, 0, -1;
     1, 0, 0, -1, 0, 0]

/-- The inverse of `strictCubicJordanBasis`. -/
def strictCubicJordanBasisInverse : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 1 / 3, 0, 1 / 3, 0, 1 / 3;
     1 / 3, 0, 1 / 3, 0, 1 / 3, 0;
     0, 2 / 3, 0, -1 / 3, 0, -1 / 3;
     0, 1 / 3, 0, 1 / 3, 0, -2 / 3;
     2 / 3, 0, -1 / 3, 0, -1 / 3, 0;
     1 / 3, 0, 1 / 3, 0, -2 / 3, 0]

/-- The Jordan form of `strictCubicEuler` in the separating basis.  The
upper-left block is `3 I + 2 E_{12}`. -/
def strictCubicJordanForm : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![3, 2, 0, 0, 0, 0;
     0, 3, 0, 0, 0, 0;
     0, 0, 0, -3, 2, 0;
     0, 0, 3, -3, 0, 2;
     0, 0, 0, 0, 0, -3;
     0, 0, 0, 0, 3, -3]

/-- The sign convention for the grading term in the `z`-connection. -/
def strictConnectionGrading : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  -productGrading

/-- The connection grading in the separating Jordan basis. -/
def strictCubicGradingInJordanBasis : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![-1 / 2, 0, 1 / 3, 1 / 3, 0, 0;
     0, 1 / 2, 0, 0, 1 / 3, 1 / 3;
     1, 0, 1 / 6, -1 / 3, 0, 0;
     1, 0, 1 / 3, -7 / 6, 0, 0;
     0, 1, 0, 0, 7 / 6, -1 / 3;
     0, 1, 0, 0, 1 / 3, -1 / 6]

/-- The first normalized off-block gauge coefficient.  Its diagonal blocks
for the partition `2+4` are zero. -/
def strictCubicFirstGauge : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, -1 / 9, 0, 0, 0;
     0, 0, 0, 0, -1 / 9, 0;
     1 / 9, 0, 0, 0, 0, 0;
     2 / 9, 0, 0, 0, 0, 0;
     0, 1 / 9, 0, 0, 0, 0;
     0, 2 / 9, 0, 0, 0, 0]

/-- The grading after the first off-block Sylvester step. -/
def strictCubicBlockGrading : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  strictCubicGradingInJordanBasis +
    strictCubicJordanForm * strictCubicFirstGauge -
      strictCubicFirstGauge * strictCubicJordanForm

/-- The second recurrence expression for the normalized gauge. -/
def strictCubicSecondCoefficient : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  let commutator := strictCubicJordanForm * strictCubicFirstGauge -
    strictCubicFirstGauge * strictCubicJordanForm
  strictCubicGradingInJordanBasis * strictCubicFirstGauge -
    strictCubicFirstGauge * strictCubicGradingInJordanBasis -
    strictCubicFirstGauge * commutator - strictCubicFirstGauge

/-- The displayed separating basis has the stated right inverse. -/
theorem strictCubicJordanBasis_mul_inverse :
    strictCubicJordanBasis * strictCubicJordanBasisInverse = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [strictCubicJordanBasis, strictCubicJordanBasisInverse,
      Matrix.mul_apply, Fin.sum_univ_succ]

/-- The displayed separating basis has the stated left inverse. -/
theorem strictCubicJordanBasis_inverse_mul :
    strictCubicJordanBasisInverse * strictCubicJordanBasis = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [strictCubicJordanBasis, strictCubicJordanBasisInverse,
      Matrix.mul_apply, Fin.sum_univ_succ]

/-- The separating basis intertwines Euler multiplication with the displayed
Jordan matrix. -/
theorem strictCubicEuler_intertwining :
    strictCubicEuler * strictCubicJordanBasis =
      strictCubicJordanBasis * strictCubicJordanForm := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [strictCubicJordanBasis, strictCubicEuler, cubicMultiplication,
      dualNumberMultiplication, strictCubicJordanForm, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- The separating basis intertwines the connection grading with its
displayed matrix in the Jordan frame. -/
theorem strictConnectionGrading_intertwining :
    strictConnectionGrading * strictCubicJordanBasis =
      strictCubicJordanBasis * strictCubicGradingInJordanBasis := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [strictCubicJordanBasis, strictConnectionGrading, productGrading,
      strictCubicGradingInJordanBasis, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The displayed change of basis is invertible and gives the stated Jordan
and grading matrices. -/
theorem strictCubic_change_of_basis :
    strictCubicJordanBasis * strictCubicJordanBasisInverse = 1 ∧
      strictCubicJordanBasisInverse * strictCubicJordanBasis = 1 ∧
      strictCubicEuler * strictCubicJordanBasis =
        strictCubicJordanBasis * strictCubicJordanForm ∧
      strictConnectionGrading * strictCubicJordanBasis =
        strictCubicJordanBasis * strictCubicGradingInJordanBasis :=
  ⟨strictCubicJordanBasis_mul_inverse,
    strictCubicJordanBasis_inverse_mul,
    strictCubicEuler_intertwining,
    strictConnectionGrading_intertwining⟩

/-- The first Sylvester step removes every entry between the selected
rank-two block and its four-dimensional complement. -/
theorem strictCubic_firstGauge_block_separation :
    ∀ i j,
      (i.1 < 2 ∧ 2 ≤ j.1) ∨ (2 ≤ i.1 ∧ j.1 < 2) →
        strictCubicBlockGrading i j = 0 := by
  intro i j hij
  fin_cases i <;> fin_cases j <;>
    norm_num at hij <;>
    norm_num [strictCubicBlockGrading, strictCubicGradingInJordanBasis,
      strictCubicJordanForm, strictCubicFirstGauge, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- On the selected rank-two block the normalized grading has diagonal
entries `-1/2,1/2`, and the return entry of the second recurrence coefficient
is zero. -/
theorem strictCubic_selectedBlock_values :
    strictCubicBlockGrading 0 0 = -1 / 2 ∧
      strictCubicBlockGrading 1 1 = 1 / 2 ∧
      strictCubicSecondCoefficient 1 0 = 0 := by
  norm_num [strictCubicBlockGrading, strictCubicSecondCoefficient,
    strictCubicGradingInJordanBasis, strictCubicJordanForm,
    strictCubicFirstGauge, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The elementary-modified residue of the selected block in the strict
cubic dual-number model. -/
def strictCubicModifiedResidue : Matrix BlockIndex BlockIndex ℚ :=
  !![strictCubicBlockGrading 0 0, 2;
     strictCubicSecondCoefficient 1 0, strictCubicBlockGrading 1 1 - 1]

/-- The selected strict block has zero modified-residue discriminant. -/
theorem strictCubicModifiedResidue_discriminant :
    strictCubicModifiedResidue.trace ^ 2 -
        4 * strictCubicModifiedResidue.det = 0 := by
  norm_num [strictCubicModifiedResidue, strictCubicBlockGrading,
    strictCubicSecondCoefficient, strictCubicGradingInJordanBasis,
    strictCubicJordanForm, strictCubicFirstGauge, Matrix.trace,
    Matrix.det_fin_two, Matrix.mul_apply, Fin.sum_univ_succ]

namespace RankOneReturn

/-- A trace-zero rank-one square-zero endomorphism of a two-dimensional
space, written in terms of a spanning vector `(r,s)`. -/
def nilpotent (r s : ℚ) : Matrix BlockIndex BlockIndex ℚ :=
  !![-r * s, r ^ 2; -s ^ 2, r * s]

/-- The displayed rank-one family is square-zero for every pair `(r,s)`. -/
theorem nilpotent_sq (r s : ℚ) :
    nilpotent r s * nilpotent r s = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nilpotent, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

/-- The lower-left return polynomial from the strict cubic Sylvester
recurrence. -/
def returnCoefficient (r s : ℚ) : ℚ :=
  -2 * r ^ 2 * s ^ 2 / 27

/-- Self-adjointness for the hyperbolic unit--point pairing forces the two
parameters not to be simultaneously nonzero. -/
theorem mul_eq_zero_of_selfAdjoint (r s : ℚ)
    (selfAdjoint :
      (nilpotent r s).transpose * blockPairing =
        blockPairing * nilpotent r s) :
    r * s = 0 := by
  have entry := congrFun (congrFun selfAdjoint (0 : BlockIndex)) (1 : BlockIndex)
  simp [nilpotent, blockPairing, Matrix.mul_apply, Fin.sum_univ_succ] at entry
  linarith

/-- Under the Poincare self-adjointness equation, the strict cubic return
polynomial vanishes. -/
theorem returnCoefficient_eq_zero_of_selfAdjoint (r s : ℚ)
    (selfAdjoint :
      (nilpotent r s).transpose * blockPairing =
        blockPairing * nilpotent r s) :
    returnCoefficient r s = 0 := by
  have hrs := mul_eq_zero_of_selfAdjoint r s selfAdjoint
  obtain hr | hs := mul_eq_zero.mp hrs
  · simp [returnCoefficient, hr]
  · simp [returnCoefficient, hs]

end RankOneReturn

namespace CyclicResidueRegression

/-- The scalar selected second coefficient predicted by the strict
`n`-cycle Sylvester recurrence.  This definition records the closed formula;
the finite evaluations below do not derive the recurrence. -/
def secondCoefficient (n L : ℚ) : ℚ :=
  (n ^ 2 - 1) / (24 * L)

/-- Exact evaluations of the closed second-coefficient formula at the five
named packet lengths, normalized by `L = 1`. -/
theorem secondCoefficient_named_values :
    secondCoefficient 2 1 = 1 / 8 ∧
      secondCoefficient 3 1 = 1 / 3 ∧
      secondCoefficient 4 1 = 5 / 8 ∧
      secondCoefficient 5 1 = 1 ∧
      secondCoefficient 14 1 = 65 / 8 := by
  norm_num [secondCoefficient]

/-- The lower-orientation elementary-modified residue with arbitrary nonzero
or zero Jordan coefficient. -/
def lowerResidue (eta : ℚ) : Matrix BlockIndex BlockIndex ℚ :=
  !![-1 / 2, eta; 0, -1 / 2]

/-- The upper-orientation elementary-modified residue with arbitrary Jordan
coefficient. -/
def upperResidue (eta : ℚ) : Matrix BlockIndex BlockIndex ℚ :=
  !![1 / 2, eta; 0, -3 / 2]

/-- The lower and upper orientations have discriminants zero and four,
independently of the Jordan coefficient. -/
theorem orientation_discriminants (eta : ℚ) :
    (lowerResidue eta).trace ^ 2 - 4 * (lowerResidue eta).det = 0 ∧
      (upperResidue eta).trace ^ 2 - 4 * (upperResidue eta).det = 4 := by
  constructor <;>
    simp [lowerResidue, upperResidue, Matrix.trace, Matrix.det_fin_two] <;>
    ring

end CyclicResidueRegression

namespace FlatCoordinateObstruction

/-- Three scalar equations forced by the proposed degree-one-unit gauge are
inconsistent over a characteristic-zero field.  In the intended application
`epsilon` is the Euler derivative of `alpha`: the first two equations come
from weights `-1` and `+1`, while the last comes from the wrapped Novikov
entry.  This theorem does not derive those equations from a quantum
connection. -/
theorem three_weight_equations_inconsistent
    {K : Type*} [Field K] [CharZero K]
    (alpha epsilon t : K) (ht : t ≠ 0)
    (hminus : epsilon = alpha) (hplus : epsilon = -alpha)
    (hwrap : (epsilon + 3 * alpha) * t = 3 * t) : False := by
  have halpha : alpha = 0 := by
    have hneg : alpha = -alpha := hminus.symm.trans hplus
    have hsum : alpha + alpha = 0 := by
      calc
        alpha + alpha = -alpha + alpha := congrArg (fun x ↦ x + alpha) hneg
        _ = 0 := by ring
    have htwo : (2 : K) * alpha = 0 := by
      simpa [two_mul] using hsum
    exact (mul_eq_zero.mp htwo).resolve_left (by norm_num)
  have hepsilon : epsilon = 0 := hminus.trans halpha
  rw [halpha, hepsilon] at hwrap
  exact (mul_ne_zero (by norm_num : (3 : K) ≠ 0) ht) (by simpa using hwrap.symm)

end FlatCoordinateObstruction

namespace GaugeRecurrenceCompression

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- Compressing the first two normalized gauge recurrences to an idempotent
block removes the off-block commutator.  The second identity includes the
gauge-derivative term `-X`; it is therefore a connection recurrence, not only
a conjugation identity for a matrix pencil. -/
theorem first_and_second_compressions
    (U mu P X : Matrix I I ℚ)
    (projector : P * P = P)
    (offDiagonal :
      U * X - X * U =
        P * mu * (1 - P) + (1 - P) * mu * P)
    (selectedOffBlock : P * X * P = 0) :
    P * (-mu + (U * X - X * U)) * P = -P * mu * P ∧
      P * ((-mu) * X - X * (-mu) - X * (U * X - X * U) - X) * P =
        -P * mu * X * P := by
  constructor
  · rw [offDiagonal]
    noncomm_ring
    simp only [← mul_assoc, projector]
    noncomm_ring
  · rw [offDiagonal]
    noncomm_ring
    simp only [← mul_assoc, projector, selectedOffBlock, zero_mul]
    noncomm_ring

end GaugeRecurrenceCompression

namespace CyclicCarrierDimension

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- If `n` cyclic pieces have equal dimension and total dimension `2n`, then
each piece has dimension two.  This is the dimension count used for a regular
`n`-cycle of rank-two blocks; it does not construct the cyclic equivalences. -/
theorem part_finrank_eq_two_of_cyclicFamily
    {n : ℕ} (hn : 0 < n) (part : Fin n → Submodule K V)
    (zeroIndex : Fin n) (cycleToZero : ∀ i, part i ≃ₗ[K] part zeroIndex)
    (carrier_finrank : ∑ i, Module.finrank K (part i) = 2 * n)
    (i : Fin n) :
    Module.finrank K (part i) = 2 := by
  have hpart : ∀ j, Module.finrank K (part j) =
      Module.finrank K (part zeroIndex) :=
    fun j => LinearEquiv.finrank_eq (cycleToZero j)
  have hsum : n * Module.finrank K (part zeroIndex) = 2 * n := by
    calc
      n * Module.finrank K (part zeroIndex) =
          ∑ _ : Fin n, Module.finrank K (part zeroIndex) := by simp
      _ = ∑ j, Module.finrank K (part j) := by
        apply Finset.sum_congr rfl
        intro j _
        exact (hpart j).symm
      _ = 2 * n := carrier_finrank
  have hzero : Module.finrank K (part zeroIndex) = 2 := by nlinarith
  exact (hpart i).trans hzero

variable [FiniteDimensional K V]

/-- In the preceding cyclic situation, a distinguished piece contained in a
two-dimensional residue class exhausts that class. -/
theorem zeroPart_eq_zeroClass_of_cyclicFamily
    {n : ℕ} (hn : 0 < n) (part : Fin n → Submodule K V)
    (zeroIndex : Fin n) (zeroClass : Submodule K V)
    (zeroPart_le : part zeroIndex ≤ zeroClass)
    (zeroClass_finrank : Module.finrank K zeroClass = 2)
    (cycleToZero : ∀ i, part i ≃ₗ[K] part zeroIndex)
    (carrier_finrank : ∑ i, Module.finrank K (part i) = 2 * n) :
    part zeroIndex = zeroClass := by
  apply Submodule.eq_of_le_of_finrank_eq zeroPart_le
  rw [part_finrank_eq_two_of_cyclicFamily hn part zeroIndex cycleToZero
    carrier_finrank zeroIndex]
  exact zeroClass_finrank.symm

/-- Suppose the distinguished residue class has dimension one below the
packet length and dimension two at the packet length.  A cyclic family of
`n` rank-two pieces contained in a variety of dimension at most `n` then
forces equality of the two dimensions and exhausts the distinguished residue
class.  The two residue-rank laws are explicit inputs. -/
theorem dimension_eq_and_zeroPart_eq_zeroClass
    {n d : ℕ} (hn : 0 < n) (hdn : d ≤ n)
    (part : Fin n → Submodule K V) (zeroIndex : Fin n)
    (zeroClass : Submodule K V)
    (zeroPart_le : part zeroIndex ≤ zeroClass)
    (zeroRank_of_lt : d < n → Module.finrank K zeroClass = 1)
    (zeroRank_of_eq : d = n → Module.finrank K zeroClass = 2)
    (cycleToZero : ∀ i, part i ≃ₗ[K] part zeroIndex)
    (carrier_finrank : ∑ i, Module.finrank K (part i) = 2 * n) :
    d = n ∧ part zeroIndex = zeroClass := by
  have partRank : Module.finrank K (part zeroIndex) = 2 :=
    part_finrank_eq_two_of_cyclicFamily hn part zeroIndex cycleToZero
      carrier_finrank zeroIndex
  have dimensionEq : d = n := by
    rcases lt_or_eq_of_le hdn with hlt | heq
    · have rankLe : Module.finrank K (part zeroIndex) ≤
          Module.finrank K zeroClass :=
        Submodule.finrank_mono zeroPart_le
      rw [partRank, zeroRank_of_lt hlt] at rankLe
      omega
    · exact heq
  refine ⟨dimensionEq, ?_⟩
  apply Submodule.eq_of_le_of_finrank_eq zeroPart_le
  exact partRank.trans (zeroRank_of_eq dimensionEq).symm

/-- Three cyclically equivalent pieces of total dimension six have dimension
two.  If the first lies in a two-dimensional residue class, it equals that
class. -/
theorem zeroPart_eq_zeroClass
    (zeroClass zeroPart onePart twoPart : Submodule K V)
    (zeroPart_le : zeroPart ≤ zeroClass)
    (zeroClass_finrank : Module.finrank K zeroClass = 2)
    (carrier_finrank :
      Module.finrank K zeroPart + Module.finrank K onePart +
        Module.finrank K twoPart = 6)
    (cycleZeroOne : zeroPart ≃ₗ[K] onePart)
    (cycleOneTwo : onePart ≃ₗ[K] twoPart) :
    zeroPart = zeroClass := by
  have zeroOneFinrank :
      Module.finrank K zeroPart = Module.finrank K onePart :=
    LinearEquiv.finrank_eq cycleZeroOne
  have oneTwoFinrank :
      Module.finrank K onePart = Module.finrank K twoPart :=
    LinearEquiv.finrank_eq cycleOneTwo
  have zeroPartFinrank : Module.finrank K zeroPart = 2 := by
    omega
  apply Submodule.eq_of_le_of_finrank_eq zeroPart_le
  omega

/-- If the cyclic zero piece lies in a carrier, the preceding dimension
calculation puts the whole residue-zero class in that carrier. -/
theorem zeroClass_le_carrier
    (carrier zeroClass zeroPart onePart twoPart : Submodule K V)
    (zeroPart_le_carrier : zeroPart ≤ carrier)
    (zeroPart_le_zeroClass : zeroPart ≤ zeroClass)
    (zeroClass_finrank : Module.finrank K zeroClass = 2)
    (carrier_finrank :
      Module.finrank K zeroPart + Module.finrank K onePart +
        Module.finrank K twoPart = 6)
    (cycleZeroOne : zeroPart ≃ₗ[K] onePart)
    (cycleOneTwo : onePart ≃ₗ[K] twoPart) :
    zeroClass ≤ carrier := by
  have zeroPartEq := zeroPart_eq_zeroClass zeroClass zeroPart onePart twoPart
    zeroPart_le_zeroClass zeroClass_finrank carrier_finrank cycleZeroOne cycleOneTwo
  rw [← zeroPartEq]
  exact zeroPart_le_carrier

end CyclicCarrierDimension

/-- Multiplication by `x + e` in `Q[x,e]/(x^3,e^2)`. -/
def lefschetzAtClassicalLimit : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 1, 1, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 1, 1, 0]

/-- The standard `J_4 direct-sum J_2` nilpotent matrix. -/
def jordanFourPlusTwo : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 0, 0]

/-- Columns are the two Jordan chains
`3 x^2 e, x^2+2xe, x+e, 1` and `x^2-xe, x-2e`. -/
def jordanChainBasis : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, 0, 1, 0, 0;
     0, 0, 1, 0, 0, -2;
     0, 0, 1, 0, 0, 1;
     0, 2, 0, 0, -1, 0;
     0, 1, 0, 0, 1, 0;
     3, 0, 0, 0, 0, 0]

/-- An explicit inverse of `jordanChainBasis`. -/
def jordanChainBasisInverse : Matrix ThreefoldIndex ThreefoldIndex ℚ :=
  !![0, 0, 0, 0, 0, 1 / 3;
     0, 0, 0, 1 / 3, 1 / 3, 0;
     0, 1 / 3, 2 / 3, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, -1 / 3, 2 / 3, 0;
     0, -1 / 3, 1 / 3, 0, 0, 0]

/-- The two displayed Jordan chains form a basis. -/
theorem jordanChainBasis_inverse :
    jordanChainBasis * jordanChainBasisInverse = 1 ∧
      jordanChainBasisInverse * jordanChainBasis = 1 := by
  constructor <;>
    ext i j <;>
    fin_cases i <;> fin_cases j <;>
      norm_num [jordanChainBasis, jordanChainBasisInverse, Matrix.mul_apply,
        Fin.sum_univ_succ]

/-- Multiplication by `x + e` has Jordan form `J_4 direct-sum J_2`. -/
theorem lefschetzAtClassicalLimit_jordanFourPlusTwo :
    lefschetzAtClassicalLimit * jordanChainBasis =
      jordanChainBasis * jordanFourPlusTwo := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [lefschetzAtClassicalLimit, jordanChainBasis,
      jordanFourPlusTwo, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Multiplication by `x + e` is self-adjoint for the coefficient-of-`x^2 e`
pairing. -/
theorem lefschetzAtClassicalLimit_selfAdjoint :
    lefschetzAtClassicalLimit.transpose * threefoldPairing =
      threefoldPairing * lefschetzAtClassicalLimit := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [lefschetzAtClassicalLimit, threefoldPairing, Matrix.mul_apply,
      Fin.sum_univ_succ]

namespace ResidueCarrier

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- A finite-linear interface for the possible mod-three reduction.  The
`zeroClassInside` field is the geometric dimension step: the carried packet
must exhaust the residue-zero cohomology class.  The other two residue
classes are grading eigenspaces, while the grading need only preserve the
zero class. -/
structure Data where
  carrier : Submodule K V
  projectionZero : V →ₗ[K] V
  projectionOne : V →ₗ[K] V
  projectionTwo : V →ₗ[K] V
  projections_sum :
    projectionZero + projectionOne + projectionTwo = LinearMap.id
  carrier_projectionOne :
    ∀ {x : V}, x ∈ carrier → projectionOne x ∈ carrier
  carrier_projectionTwo :
    ∀ {x : V}, x ∈ carrier → projectionTwo x ∈ carrier
  zeroClassInside : LinearMap.range projectionZero ≤ carrier
  grading : V →ₗ[K] V
  zeroClass_grading_stable :
    ∀ {x : V}, x ∈ LinearMap.range projectionZero →
      grading x ∈ LinearMap.range projectionZero
  grading_projectionOne :
    ∃ scalar : K, ∀ x : V, grading (projectionOne x) = scalar • projectionOne x
  grading_projectionTwo :
    ∃ scalar : K, ∀ x : V, grading (projectionTwo x) = scalar • projectionTwo x

/-- Once a residue-graded carrier contains the whole residue-zero class, a
threefold grading that is scalar on the other two classes preserves the
carrier.  This is the finite consumer behind the proposed rank-six
reduction; constructing the residue projections and the containment from an
actual QDM remains external. -/
theorem Data.grading_mem (data : Data (K := K) (V := V))
    {x : V} (hx : x ∈ data.carrier) : data.grading x ∈ data.carrier := by
  have decompose :
      data.projectionZero x + data.projectionOne x + data.projectionTwo x = x := by
    have := LinearMap.congr_fun data.projections_sum x
    simpa using this
  have zeroMem : data.grading (data.projectionZero x) ∈ data.carrier := by
    apply data.zeroClassInside
    apply data.zeroClass_grading_stable
    exact ⟨x, rfl⟩
  have oneMem : data.grading (data.projectionOne x) ∈ data.carrier := by
    obtain ⟨scalar, value⟩ := data.grading_projectionOne
    specialize value x
    rw [value]
    exact data.carrier.smul_mem _ (data.carrier_projectionOne hx)
  have twoMem : data.grading (data.projectionTwo x) ∈ data.carrier := by
    obtain ⟨scalar, value⟩ := data.grading_projectionTwo
    specialize value x
    rw [value]
    exact data.carrier.smul_mem _ (data.carrier_projectionTwo hx)
  rw [← decompose, map_add, map_add]
  exact data.carrier.add_mem (data.carrier.add_mem zeroMem oneMem) twoMem

/-- Equal finite dimension of the carrier's residue-zero part and the whole
residue-zero class supplies the containment consumed by `grading_mem`. -/
theorem zeroClassInside_of_finrank
    (carrier : Submodule K V) (projectionZero : V →ₗ[K] V)
    (carrierZeroPart : Submodule K V)
    [FiniteDimensional K (LinearMap.range projectionZero)]
    (zeroPart_le_carrier : carrierZeroPart ≤ carrier)
    (zeroPart_le_zeroClass : carrierZeroPart ≤ LinearMap.range projectionZero)
    (sameFinrank :
      Module.finrank K carrierZeroPart =
        Module.finrank K (LinearMap.range projectionZero)) :
    LinearMap.range projectionZero ≤ carrier := by
  have zeroPartEq :
      carrierZeroPart =
        LinearMap.range projectionZero :=
    Submodule.eq_of_le_of_finrank_eq zeroPart_le_zeroClass sameFinrank
  intro x hx
  apply zeroPart_le_carrier
  have hxZeroPart : x ∈ carrierZeroPart := by
    rw [zeroPartEq]
    exact hx
  exact hxZeroPart

end ResidueCarrier

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ThreefoldKummerCompatibility
