import RelativeConicArcs.FaceAxisHarmonicGram

/-!
# Cubic restriction of the icosahedral degree-six field

The normalized mean in this module is the explicitly defined polynomial
functional of `RelativeConicArcs.SphericalMomentFunctional`; no statement here
is a statement about a surface integral.  The symmetric tetrahedral harmonic
below is written in the squared coordinate variables.  Its cubic moment is one
of the two explicit degree-eighteen evaluations needed for the restriction of
the icosahedral cubic to the sum-zero five-label module.
-/

namespace RelativeConicArcs.SphericalCubicRestriction

open MvPolynomial
open RelativeConicArcs.SphericalMomentFunctional
open RelativeConicArcs.KneserPairEigenspace
open RelativeConicArcs.IcosahedralFaceAxes
open RelativeConicArcs.ZonalHarmonicDegreeSix
open RelativeConicArcs.FaceAxisHarmonicGram

/-- The square of the `i`-th coordinate variable. -/
noncomputable def squaredCoordinate (i : Fin 3) : MvPolynomial (Fin 3) ℝ := X i ^ 2

/-- The coordinate-transposition-even tetrahedral harmonic in the squared
variables `u = x₀²`, `v = x₁²`, and `w = x₂²`:
`u³ + v³ + w³ - (15/2)Σ_sym u²v + 90uvw`. -/
noncomputable def tetrahedralEvenHarmonic : MvPolynomial (Fin 3) ℝ :=
  let u := squaredCoordinate 0
  let v := squaredCoordinate 1
  let w := squaredCoordinate 2
  u ^ 3 + v ^ 3 + w ^ 3 - C (15 / 2) *
    (u ^ 2 * v + v ^ 2 * w + w ^ 2 * u + u * v ^ 2 + v * w ^ 2 + w * u ^ 2) +
    C 90 * (u * v * w)

/-- The coordinate-transposition-odd tetrahedral harmonic in the squared
variables: the cyclic sum `uv² + vw² + wu²` minus its reverse cyclic sum. -/
noncomputable def tetrahedralOddHarmonic : MvPolynomial (Fin 3) ℝ :=
  let u := squaredCoordinate 0
  let v := squaredCoordinate 1
  let w := squaredCoordinate 2
  (u * v ^ 2 + v * w ^ 2 + w * u ^ 2) -
    (u ^ 2 * v + v ^ 2 * w + w ^ 2 * u)

/-- The normalized degree-eighteen moment of the cube of the even tetrahedral
harmonic is `-1280/46189`.  The proof expands its fifty-five monomials and
applies the defining Gaussian monomial moment formula. -/
theorem normalizedMean_tetrahedralEvenHarmonic_cube :
    normalizedMean 18 (tetrahedralEvenHarmonic ^ 3) = -1280 / 46189 := by
  rw [normalizedMean]
  norm_num [tetrahedralEvenHarmonic, squaredCoordinate, gaussianMoment, momentWeight,
    momentFactor]

/-- The second nonzero degree-eighteen moment needed for the marked cubic is
the moment of two odd factors and one even factor. -/
theorem normalizedMean_tetrahedralOddHarmonic_sq_mul_tetrahedralEvenHarmonic :
    normalizedMean 18
      (tetrahedralOddHarmonic ^ 2 * tetrahedralEvenHarmonic) = -1024 / 969969 := by
  rw [normalizedMean]
  norm_num [tetrahedralOddHarmonic, tetrahedralEvenHarmonic, squaredCoordinate,
    gaussianMoment, momentWeight, momentFactor]

/-- The orthogonal coordinate substitution exchanging the first two variables
and fixing the third. -/
def firstCoordinateSwap : Fin 3 → Fin 3 → ℝ :=
  ![![0, 1, 0], ![1, 0, 0], ![0, 0, 1]]

/-- The rows of the first-coordinate swap form an orthonormal basis. -/
theorem firstCoordinateSwap_rows_orthogonal (i j : Fin 3) :
    ∑ k, firstCoordinateSwap i k * firstCoordinateSwap j k = if i = j then 1 else 0 := by
  decide +revert

/-- Exchanging the first two coordinates negates the odd tetrahedral harmonic. -/
theorem linearSubstitution_firstCoordinateSwap_tetrahedralOddHarmonic :
    linearSubstitution firstCoordinateSwap tetrahedralOddHarmonic =
      -tetrahedralOddHarmonic := by
  simp [tetrahedralOddHarmonic, squaredCoordinate, linearSubstitution_X, linearForm,
    firstCoordinateSwap]
  ring

/-- Exchanging the first two coordinates fixes the even tetrahedral harmonic. -/
theorem linearSubstitution_firstCoordinateSwap_tetrahedralEvenHarmonic :
    linearSubstitution firstCoordinateSwap tetrahedralEvenHarmonic =
      tetrahedralEvenHarmonic := by
  simp [tetrahedralEvenHarmonic, squaredCoordinate, linearSubstitution_X, linearForm,
    firstCoordinateSwap]
  ring

private theorem gaussianMoment_eq_zero_of_swap_neg
    (p : MvPolynomial (Fin 3) ℝ)
    (hp : linearSubstitution firstCoordinateSwap p = -p) : gaussianMoment p = 0 := by
  have hinv := congrArg (fun L : MvPolynomial (Fin 3) ℝ →ₗ[ℝ] ℝ => L p)
    (gaussianMoment_comp_linearSubstitution firstCoordinateSwap
      firstCoordinateSwap_rows_orthogonal)
  change gaussianMoment (linearSubstitution firstCoordinateSwap p) = gaussianMoment p at hinv
  rw [hp, map_neg] at hinv
  linarith

/-- Every cubic term with three odd factors has vanishing normalized mean by
the first-coordinate transposition. -/
theorem normalizedMean_tetrahedralOddHarmonic_cube :
    normalizedMean 18 (tetrahedralOddHarmonic ^ 3) = 0 := by
  rw [normalizedMean, gaussianMoment_eq_zero_of_swap_neg]
  rw [map_pow, linearSubstitution_firstCoordinateSwap_tetrahedralOddHarmonic]
  ring

/-- Every cubic term with one odd and two even factors has vanishing normalized
mean by the first-coordinate transposition. -/
theorem normalizedMean_tetrahedralOddHarmonic_mul_tetrahedralEvenHarmonic_sq :
    normalizedMean 18
      (tetrahedralOddHarmonic * tetrahedralEvenHarmonic ^ 2) = 0 := by
  rw [normalizedMean, gaussianMoment_eq_zero_of_swap_neg]
  rw [map_mul, map_pow, linearSubstitution_firstCoordinateSwap_tetrahedralOddHarmonic,
    linearSubstitution_firstCoordinateSwap_tetrahedralEvenHarmonic]
  ring

/-- A linear combination of the odd and even tetrahedral harmonics. -/
noncomputable def tetrahedralHarmonicCombination (a b : ℝ) :
    MvPolynomial (Fin 3) ℝ :=
  C a * tetrahedralOddHarmonic + C b * tetrahedralEvenHarmonic

/-- The cubic normalized mean of an odd/even tetrahedral combination has only
the two even-parity contributions. -/
theorem normalizedMean_tetrahedralHarmonicCombination_cube (a b : ℝ) :
    normalizedMean 18 (tetrahedralHarmonicCombination a b ^ 3) =
      3 * a ^ 2 * b * (-1024 / 969969) + b ^ 3 * (-1280 / 46189) := by
  have hadd (p q : MvPolynomial (Fin 3) ℝ) :
      normalizedMean 18 (p + q) = normalizedMean 18 p + normalizedMean 18 q := by
    simp [normalizedMean]
  have hpoly : tetrahedralHarmonicCombination a b ^ 3 =
      C (a ^ 3) * tetrahedralOddHarmonic ^ 3 +
      C (3 * a ^ 2 * b) *
        (tetrahedralOddHarmonic ^ 2 * tetrahedralEvenHarmonic) +
      C (3 * a * b ^ 2) *
        (tetrahedralOddHarmonic * tetrahedralEvenHarmonic ^ 2) +
      C (b ^ 3) * tetrahedralEvenHarmonic ^ 3 := by
    rw [tetrahedralHarmonicCombination]
    push_cast
    ring
  rw [hpoly, hadd, hadd, hadd,
    normalizedMean_C_mul, normalizedMean_C_mul, normalizedMean_C_mul,
    normalizedMean_C_mul,
    normalizedMean_tetrahedralOddHarmonic_cube,
    normalizedMean_tetrahedralOddHarmonic_sq_mul_tetrahedralEvenHarmonic,
    normalizedMean_tetrahedralOddHarmonic_mul_tetrahedralEvenHarmonic_sq,
    normalizedMean_tetrahedralEvenHarmonic_cube]
  ring

/-- The marked tetrahedral field in terms of a chosen square root `s` of five.
Its odd coefficient is `-385s/24` and its even coefficient is `35/12`. -/
noncomputable def markedTetrahedralField (s : ℝ) : MvPolynomial (Fin 3) ℝ :=
  tetrahedralHarmonicCombination (-385 * s / 24) (35 / 12)

/-- For either real square root of five, the marked tetrahedral field has the
rational normalized cubic moment `-15680000/1247103`. -/
theorem normalizedMean_markedTetrahedralField_cube {s : ℝ} (hs : s ^ 2 = 5) :
    normalizedMean 18 (markedTetrahedralField s ^ 3) = -15680000 / 1247103 := by
  rw [markedTetrahedralField, normalizedMean_tetrahedralHarmonicCombination_cube]
  have ha : (-385 * s / 24 : ℝ) ^ 2 = 741125 / 576 := by
    nlinarith
  rw [ha]
  norm_num

/-- The face-axis zonal combination at the marked five-label weight is the
odd/even tetrahedral field with the nonnegative real square root of five. -/
theorem zonalCombination_pairSum_stabilizerFixedVertexWeight :
    zonalCombination (pairSum stabilizerFixedVertexWeight) =
      markedTetrahedralField (Real.sqrt 5) := by
  norm_num [zonalCombination, pairSum, stabilizerFixedVertexWeight,
    faceAxisZonalForm, zonalHarmonic, unitFaceAxis, doubledFaceAxisReal,
    doubledFaceAxisOver, goldenCast, doubledFaceAxis, doubledAxisCoordinates,
    markedTetrahedralField, tetrahedralHarmonicCombination,
    tetrahedralOddHarmonic, tetrahedralEvenHarmonic, squaredCoordinate,
    linearForm, quadric]
  ring_nf
  nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 5),
    Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)]

/-- The marked face-axis zonal field has normalized cubic mean
`-15680000/1247103`. -/
theorem normalizedMean_zonalCombination_stabilizerFixedVertexWeight_cube :
    normalizedMean 18
      (zonalCombination (pairSum stabilizerFixedVertexWeight) ^ 3) =
        -15680000 / 1247103 := by
  rw [zonalCombination_pairSum_stabilizerFixedVertexWeight]
  exact normalizedMean_markedTetrahedralField_cube
    (by simpa [pow_two] using sqrt_five_mul_self)

end RelativeConicArcs.SphericalCubicRestriction
