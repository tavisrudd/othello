import Mathlib

/-!
# Threefold grading and cubic Kummer compatibility

This file records two finite linear models relevant to a proposed dimension
bound for cyclic packets of rank-two blocks.

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
