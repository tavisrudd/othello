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

/-- The real orthogonal matrix obtained by dividing the integral scaled
icosahedral rotation by four and sending the golden generator to `√5`. -/
noncomputable def faceAxisRotation (r : Fin 3) (i j : Fin 3) : ℝ :=
  goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r i j) / 4

/-- The real face-axis rotations have orthonormal rows. -/
theorem faceAxisRotation_rows_orthogonal (r i j : Fin 3) :
    ∑ k, faceAxisRotation r i k * faceAxisRotation r j k =
      if i = j then 1 else 0 := by
  have h := congrArg (goldenCast (Real.sqrt 5) sqrt_five_mul_self)
    (scaledRotation_rows_orthogonal r i j)
  simp only [map_sum, map_mul, map_ofNat, map_zero, map_ite] at h
  rw [← h]
  simp only [faceAxisRotation, div_mul_div_comm, Finset.sum_div]
  norm_num

/-- The displayed label action of the `r`-th rotation, regarded as a
permutation. -/
def faceAxisLabelPermutation (r : Fin 3) : Equiv.Perm (Fin 5) :=
  Equiv.ofInjective (labelPermutation r) (labelPermutation_injective r)

/-- The permutation wrapper acts by the displayed label function. -/
@[simp] theorem faceAxisLabelPermutation_apply (r : Fin 3) (i : Fin 5) :
    faceAxisLabelPermutation r i = labelPermutation r i := rfl

/-- Substitution by a face-axis rotation relabels the zonal field by the same
permutation of the five labels. -/
theorem linearSubstitution_faceAxisRotation_zonalCombination_pairSum
    (r : Fin 3) (y : Fin 5 → ℝ) :
    linearSubstitution (faceAxisRotation r) (zonalCombination (pairSum y)) =
      zonalCombination (pairSum (fun i ↦ y (faceAxisLabelPermutation r i))) := by
  fin_cases r <;>
    norm_num [zonalCombination, pairSum, faceAxisZonalForm, zonalHarmonic,
      unitFaceAxis, doubledFaceAxisReal, doubledFaceAxisOver, goldenCast,
      doubledFaceAxis, doubledAxisCoordinates, faceAxisRotation, scaledRotation,
      faceAxisLabelPermutation, labelPermutation, linearSubstitution_X,
      linearSubstitution, linearForm, quadric] <;>
    ring_nf <;>
    nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 5),
      Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)]

/-- The cubic moment of the face-axis zonal field attached to a five-label
weight vector. -/
noncomputable def faceAxisCubic (y : Fin 5 → ℝ) : ℝ :=
  normalizedMean 18 (zonalCombination (pairSum y) ^ 3)

/-- The face-axis cubic is invariant under each of the three displayed label
permutations induced by icosahedral rotations. -/
theorem faceAxisCubic_comp_faceAxisLabelPermutation (r : Fin 3) (y : Fin 5 → ℝ) :
    faceAxisCubic (fun i ↦ y (faceAxisLabelPermutation r i)) = faceAxisCubic y := by
  rw [faceAxisCubic, faceAxisCubic,
    ← linearSubstitution_faceAxisRotation_zonalCombination_pairSum, ← map_pow]
  rw [normalizedMean, normalizedMean]
  have h := congrArg (fun L : MvPolynomial (Fin 3) ℝ →ₗ[ℝ] ℝ ⇒
      L (zonalCombination (pairSum y) ^ 3))
    (gaussianMoment_comp_linearSubstitution (faceAxisRotation r)
      (faceAxisRotation_rows_orthogonal r))
  exact congrArg (fun z : ℝ ⇒ z / momentFactor 20) h

/-- Apply a word in the three displayed rotation generators from left to right
to a label. -/
def applyRotationWord : List (Fin 3) → Fin 5 → Fin 5
  | [], i => i
  | r :: word, i => applyRotationWord word (faceAxisLabelPermutation r i)

/-- The cubic moment is invariant under every word in the three displayed
rotation generators. -/
theorem faceAxisCubic_comp_applyRotationWord (word : List (Fin 3)) (y : Fin 5 → ℝ) :
    faceAxisCubic (fun i ↦ y (applyRotationWord word i)) = faceAxisCubic y := by
  induction word with
  | nil => rfl
  | cons r word ih =>
      rw [show (fun i ↦ y (applyRotationWord (r :: word) i)) =
          (fun i ↦ (fun j ↦ y (applyRotationWord word j))
            (faceAxisLabelPermutation r i)) by rfl,
        faceAxisCubic_comp_faceAxisLabelPermutation, ih]

/-- Explicit words carrying label zero to each of the five labels. -/
def rootMoverWord : Fin 5 → List (Fin 3)
  | 0 => []
  | 1 => [2]
  | 2 => [2, 0, 2]
  | 3 => [1, 0, 2]
  | 4 => [0, 2]

/-- The displayed root-moving words have their asserted endpoints. -/
theorem applyRotationWord_rootMoverWord (i : Fin 5) :
    applyRotationWord (rootMoverWord i) 0 = i := by
  revert i
  decide

/-- Explicit words in the stabilizer of label zero.  For distinct nonzero
labels `i,j`, the selected word carries the ordered pair `(1,2)` to `(i,j)`;
entries outside that domain are irrelevant and set to the empty word. -/
def stabilizerPairWord : Fin 5 → Fin 5 → List (Fin 3) :=
  ![!([], [], [], [], []),
    !([], [], [], [1, 1], [1]),
    !([], [1, 1, 0, 1], [], [0, 1, 0], [1, 1, 0]),
    !([], [1, 0, 1], [1, 0], [], [1, 0, 1, 1]),
    !([], [0, 1], [0, 1, 1], [0], [])]

/-- The twelve stabilizer words fix zero and act sharply transitively on the
ordered pairs of distinct nonzero labels. -/
theorem applyRotationWord_stabilizerPairWord {i j : Fin 5}
    (hi : i ≠ 0) (hj : j ≠ 0) (hij : i ≠ j) :
    applyRotationWord (stabilizerPairWord i j) 0 = 0 ∧
      applyRotationWord (stabilizerPairWord i j) 1 = i ∧
      applyRotationWord (stabilizerPairWord i j) 2 = j := by
  revert i j
  decide

/-- A word for the inverse of one displayed generator.  The first and third
generators are involutions; the inverse of the second is its square. -/
def inverseGeneratorWord : Fin 3 → List (Fin 3)
  | 0 => [0]
  | 1 => [1, 1]
  | 2 => [2]

/-- Reverse a rotation word and replace each generator by its displayed inverse
word. -/
def inverseRotationWord : List (Fin 3) → List (Fin 3)
  | [] => []
  | r :: word => inverseRotationWord word ++ inverseGeneratorWord r

/-- Applying concatenated words means applying the first word and then the
second. -/
theorem applyRotationWord_append (u v : List (Fin 3)) (i : Fin 5) :
    applyRotationWord (u ++ v) i = applyRotationWord v (applyRotationWord u i) := by
  induction u generalizing i with
  | nil => rfl
  | cons r u ih => simp [applyRotationWord, ih]

/-- The constructed inverse word undoes a rotation word on every label. -/
theorem applyRotationWord_inverseRotationWord (word : List (Fin 3)) (i : Fin 5) :
    applyRotationWord (inverseRotationWord word) (applyRotationWord word i) = i := by
  induction word generalizing i with
  | nil => rfl
  | cons r word ih =>
      rw [applyRotationWord, inverseRotationWord, applyRotationWord_append, ih]
      fin_cases r <;> decide

/-- A word carrying a distinct ordered label triple to the standard triple
`(0,1,2)`: first move its first label to zero, then use the sharply transitive
zero stabilizer on the other two labels. -/
def canonicalTripleWord (a b c : Fin 5) : List (Fin 3) :=
  let move := inverseRotationWord (rootMoverWord a)
  let b' := applyRotationWord move b
  let c' := applyRotationWord move c
  move ++ inverseRotationWord (stabilizerPairWord b' c')

/-- The canonicalizing word sends every ordered triple of distinct labels to
`(0,1,2)`. -/
theorem applyRotationWord_canonicalTripleWord {a b c : Fin 5}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    applyRotationWord (canonicalTripleWord a b c) a = 0 ∧
      applyRotationWord (canonicalTripleWord a b c) b = 1 ∧
      applyRotationWord (canonicalTripleWord a b c) c = 2 := by
  revert a b c
  decide

/-- An explicit rotation word carrying one ordered triple of distinct labels to
another. -/
def tripleTransportWord (a b c i j k : Fin 5) : List (Fin 3) :=
  canonicalTripleWord a b c ++ inverseRotationWord (canonicalTripleWord i j k)

/-- The displayed rotation words act three-transitively on the five labels. -/
theorem applyRotationWord_tripleTransportWord {a b c i j k : Fin 5}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hij : i ≠ j) (hik : i ≠ k) (hjk : j ≠ k) :
    applyRotationWord (tripleTransportWord a b c i j k) a = i ∧
      applyRotationWord (tripleTransportWord a b c i j k) b = j ∧
      applyRotationWord (tripleTransportWord a b c i j k) c = k := by
  revert a b c i j k
  decide

end RelativeConicArcs.SphericalCubicRestriction
