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

/-- Gaussian moments of separated coordinate monomials factor into the three
one-variable double-factorial weights.  This is the small evaluator used below
after normalizing in the squared coordinates. -/
private lemma gaussianMoment_coordinatePowers (a b c : ℕ) :
    gaussianMoment (X 0 ^ a * X 1 ^ b * X 2 ^ c) =
      momentFactor a * momentFactor b * momentFactor c := by
  simp only [MvPolynomial.X_pow_eq_monomial, monomial_mul, gaussianMoment_monomial]
  simp [momentWeight, Fin.prod_univ_three]

private lemma gaussianMoment_coordinatePowers_mul_C (a b c : ℕ) (q : ℝ) :
    gaussianMoment (X 0 ^ a * X 1 ^ b * X 2 ^ c * C q) =
      q * (momentFactor a * momentFactor b * momentFactor c) := by
  calc
    gaussianMoment (X 0 ^ a * X 1 ^ b * X 2 ^ c * C q) =
        gaussianMoment (C q * (X 0 ^ a * X 1 ^ b * X 2 ^ c)) := by
          congr 1
          ring
    _ = q * (momentFactor a * momentFactor b * momentFactor c) := by
      rw [gaussianMoment_C_mul, gaussianMoment_coordinatePowers]

private lemma gaussianMoment_mul_C (p : MvPolynomial (Fin 3) ℝ) (q : ℝ) :
    gaussianMoment (p * C q) = q * gaussianMoment p := by
  rw [mul_comm, gaussianMoment_C_mul]

private lemma gaussianMoment_mul_natCast (p : MvPolynomial (Fin 3) ℝ) (n : ℕ) :
    gaussianMoment (p * (n : MvPolynomial (Fin 3) ℝ)) =
      (n : ℝ) * gaussianMoment p := by
  rw [show (n : MvPolynomial (Fin 3) ℝ) = C (n : ℝ) by simp,
    gaussianMoment_mul_C]

private lemma gaussianMoment_mul_two (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (p * 2) = 2 * gaussianMoment p := by
  simpa using gaussianMoment_mul_natCast p 2

private lemma gaussianMoment_mul_three (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (p * 3) = 3 * gaussianMoment p := by
  simpa using gaussianMoment_mul_natCast p 3

private lemma gaussianMoment_mul_four (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (p * 4) = 4 * gaussianMoment p := by
  simpa using gaussianMoment_mul_natCast p 4

private lemma gaussianMoment_mul_five (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (p * 5) = 5 * gaussianMoment p := by
  simpa using gaussianMoment_mul_natCast p 5

private lemma gaussianMoment_mul_six (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (p * 6) = 6 * gaussianMoment p := by
  simpa using gaussianMoment_mul_natCast p 6

private lemma gaussianMoment_mul_nine (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (p * 9) = 9 * gaussianMoment p := by
  simpa using gaussianMoment_mul_natCast p 9

private lemma gaussianMoment_mul_twelve (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (p * 12) = 12 * gaussianMoment p := by
  simpa using gaussianMoment_mul_natCast p 12

private lemma gaussianMoment_mul_fifteen (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (p * 15) = 15 * gaussianMoment p := by
  simpa using gaussianMoment_mul_natCast p 15

private lemma gaussianMoment_mul_eighteen (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (p * 18) = 18 * gaussianMoment p := by
  simpa using gaussianMoment_mul_natCast p 18

private lemma gaussianMoment_mul_C_pow
    (p : MvPolynomial (Fin 3) ℝ) (q : ℝ) (n : ℕ) :
    gaussianMoment (p * C q ^ n) = q ^ n * gaussianMoment p := by
  rw [← map_pow, gaussianMoment_mul_C]

private lemma gaussianMoment_X0_pow (a : ℕ) :
    gaussianMoment (X 0 ^ a) = momentFactor a := by
  simpa using gaussianMoment_coordinatePowers a 0 0

private lemma gaussianMoment_X1_pow (b : ℕ) :
    gaussianMoment (X 1 ^ b) = momentFactor b := by
  simpa using gaussianMoment_coordinatePowers 0 b 0

private lemma gaussianMoment_X2_pow (c : ℕ) :
    gaussianMoment (X 2 ^ c) = momentFactor c := by
  simpa using gaussianMoment_coordinatePowers 0 0 c

private lemma gaussianMoment_X0_pow_mul_X1_pow (a b : ℕ) :
    gaussianMoment (X 0 ^ a * X 1 ^ b) = momentFactor a * momentFactor b := by
  simpa using gaussianMoment_coordinatePowers a b 0

private lemma gaussianMoment_X0_pow_mul_X2_pow (a c : ℕ) :
    gaussianMoment (X 0 ^ a * X 2 ^ c) = momentFactor a * momentFactor c := by
  simpa using gaussianMoment_coordinatePowers a 0 c

private lemma gaussianMoment_X1_pow_mul_X2_pow (b c : ℕ) :
    gaussianMoment (X 1 ^ b * X 2 ^ c) = momentFactor b * momentFactor c := by
  simpa using gaussianMoment_coordinatePowers 0 b c

set_option maxRecDepth 100000 in
/-- The normalized degree-eighteen moment of the cube of the even tetrahedral
harmonic is `-1280/46189`.  The proof expands its fifty-five monomials and
applies the defining Gaussian monomial moment formula. -/
theorem normalizedMean_tetrahedralEvenHarmonic_cube :
    normalizedMean 18 (tetrahedralEvenHarmonic ^ 3) = -1280 / 46189 := by
  rw [normalizedMean]
  generalize hpoly : tetrahedralEvenHarmonic ^ 3 = p
  simp only [tetrahedralEvenHarmonic, squaredCoordinate] at hpoly
  ring_nf at hpoly
  rw [← hpoly]
  simp only [map_add, map_sub]
  norm_num [tetrahedralEvenHarmonic, squaredCoordinate, momentWeight, momentFactor,
    gaussianMoment_coordinatePowers, gaussianMoment_coordinatePowers_mul_C,
    gaussianMoment_mul_C, gaussianMoment_mul_natCast, gaussianMoment_mul_two,
    gaussianMoment_mul_three, gaussianMoment_mul_four, gaussianMoment_mul_five,
    gaussianMoment_mul_six, gaussianMoment_mul_nine, gaussianMoment_mul_twelve,
    gaussianMoment_mul_fifteen, gaussianMoment_mul_eighteen,
    gaussianMoment_mul_C_pow, gaussianMoment_X0_pow,
    gaussianMoment_X1_pow,
    gaussianMoment_X2_pow, gaussianMoment_X0_pow_mul_X1_pow,
    gaussianMoment_X0_pow_mul_X2_pow, gaussianMoment_X1_pow_mul_X2_pow]

set_option maxRecDepth 100000 in
/-- The second nonzero degree-eighteen moment needed for the marked cubic is
the moment of two odd factors and one even factor. -/
theorem normalizedMean_tetrahedralOddHarmonic_sq_mul_tetrahedralEvenHarmonic :
    normalizedMean 18
      (tetrahedralOddHarmonic ^ 2 * tetrahedralEvenHarmonic) = -1024 / 969969 := by
  rw [normalizedMean]
  generalize hpoly :
    tetrahedralOddHarmonic ^ 2 * tetrahedralEvenHarmonic = p
  simp only [tetrahedralOddHarmonic, tetrahedralEvenHarmonic, squaredCoordinate] at hpoly
  ring_nf at hpoly
  rw [← hpoly]
  simp only [map_add, map_sub]
  norm_num [tetrahedralOddHarmonic, tetrahedralEvenHarmonic, squaredCoordinate,
    momentWeight, momentFactor, gaussianMoment_coordinatePowers,
    gaussianMoment_coordinatePowers_mul_C, gaussianMoment_mul_C, gaussianMoment_mul_natCast,
    gaussianMoment_mul_two, gaussianMoment_mul_three, gaussianMoment_mul_four,
    gaussianMoment_mul_five,
    gaussianMoment_mul_six, gaussianMoment_mul_nine, gaussianMoment_mul_twelve,
    gaussianMoment_mul_fifteen, gaussianMoment_mul_eighteen, gaussianMoment_mul_C_pow,
    gaussianMoment_X0_pow, gaussianMoment_X1_pow, gaussianMoment_X2_pow,
    gaussianMoment_X0_pow_mul_X1_pow, gaussianMoment_X0_pow_mul_X2_pow,
    gaussianMoment_X1_pow_mul_X2_pow]

/-- The orthogonal coordinate substitution exchanging the first two variables
and fixing the third. -/
def firstCoordinateSwap : Fin 3 → Fin 3 → ℝ :=
  ![![0, 1, 0], ![1, 0, 0], ![0, 0, 1]]

/-- The rows of the first-coordinate swap form an orthonormal basis. -/
theorem firstCoordinateSwap_rows_orthogonal (i j : Fin 3) :
    ∑ k, firstCoordinateSwap i k * firstCoordinateSwap j k = if i = j then 1 else 0 := by
  fin_cases i <;> fin_cases j <;>
    norm_num [firstCoordinateSwap, Fin.sum_univ_three, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]

/-- Exchanging the first two coordinates negates the odd tetrahedral harmonic. -/
theorem linearSubstitution_firstCoordinateSwap_tetrahedralOddHarmonic :
    linearSubstitution firstCoordinateSwap tetrahedralOddHarmonic =
      -tetrahedralOddHarmonic := by
  simp [tetrahedralOddHarmonic, squaredCoordinate, linearSubstitution_X, linearForm,
    firstCoordinateSwap, Fin.sum_univ_three]
  ring_nf

/-- Exchanging the first two coordinates fixes the even tetrahedral harmonic. -/
theorem linearSubstitution_firstCoordinateSwap_tetrahedralEvenHarmonic :
    linearSubstitution firstCoordinateSwap tetrahedralEvenHarmonic =
      tetrahedralEvenHarmonic := by
  simp [tetrahedralEvenHarmonic, squaredCoordinate, linearSubstitution_X, linearForm,
    firstCoordinateSwap, Fin.sum_univ_three]
  ring_nf

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
  · simp
  · rw [map_pow, linearSubstitution_firstCoordinateSwap_tetrahedralOddHarmonic]
    ring_nf

/-- Every cubic term with one odd and two even factors has vanishing normalized
mean by the first-coordinate transposition. -/
theorem normalizedMean_tetrahedralOddHarmonic_mul_tetrahedralEvenHarmonic_sq :
    normalizedMean 18
      (tetrahedralOddHarmonic * tetrahedralEvenHarmonic ^ 2) = 0 := by
  rw [normalizedMean, gaussianMoment_eq_zero_of_swap_neg]
  · simp
  · rw [map_mul, map_pow, linearSubstitution_firstCoordinateSwap_tetrahedralOddHarmonic,
      linearSubstitution_firstCoordinateSwap_tetrahedralEvenHarmonic]
    ring_nf

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
    ring_nf
  have hpoly : tetrahedralHarmonicCombination a b ^ 3 =
      C (a ^ 3) * tetrahedralOddHarmonic ^ 3 +
      C (3 * a ^ 2 * b) *
        (tetrahedralOddHarmonic ^ 2 * tetrahedralEvenHarmonic) +
      C (3 * a * b ^ 2) *
        (tetrahedralOddHarmonic * tetrahedralEvenHarmonic ^ 2) +
      C (b ^ 3) * tetrahedralEvenHarmonic ^ 3 := by
    rw [tetrahedralHarmonicCombination]
    simp only [map_pow, map_mul, map_ofNat]
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

/-- The ten pairs, named once so geometric calculations do not repeatedly
unfold the powerset-subtype representation of `Pair 5`. -/
private def p01 : Pair 5 := ⟨{0, 1}, by decide⟩
private def p02 : Pair 5 := ⟨{0, 2}, by decide⟩
private def p03 : Pair 5 := ⟨{0, 3}, by decide⟩
private def p04 : Pair 5 := ⟨{0, 4}, by decide⟩
private def p12 : Pair 5 := ⟨{1, 2}, by decide⟩
private def p13 : Pair 5 := ⟨{1, 3}, by decide⟩
private def p14 : Pair 5 := ⟨{1, 4}, by decide⟩
private def p23 : Pair 5 := ⟨{2, 3}, by decide⟩
private def p24 : Pair 5 := ⟨{2, 4}, by decide⟩
private def p34 : Pair 5 := ⟨{3, 4}, by decide⟩

private theorem pair_univ_five : (Finset.univ : Finset (Pair 5)) =
    {p01, p02, p03, p04, p12, p13, p14, p23, p24, p34} := by
  decide

private theorem sum_pair_five {A : Type*} [AddCommMonoid A] (f : Pair 5 → A) :
    ∑ p, f p =
      f p01 + f p02 + f p03 + f p04 + f p12 + f p13 + f p14 + f p23 +
        f p24 + f p34 := by
  classical
  rw [pair_univ_five]
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_singleton]
  abel

/-- Clearing the common unit-axis denominator rewrites a zonal form entirely
in doubled face-axis coordinates.  In particular, no square root of three
remains in subsequent finite sums. -/
private theorem faceAxisZonalForm_doubled (p : Pair 5) :
    faceAxisZonalForm p = C (1 / 27648) *
      (231 * (linearForm (doubledFaceAxisReal p) ^ 2) ^ 3 -
        3780 * (linearForm (doubledFaceAxisReal p) ^ 2) ^ 2 * quadric +
        15120 * (linearForm (doubledFaceAxisReal p) ^ 2) * quadric ^ 2 -
        8640 * quadric ^ 3) := by
  have hs3 : Real.sqrt 3 ^ 2 = 3 := Real.sq_sqrt (by norm_num)
  have hc2 : (1 / (2 * Real.sqrt 3) : ℝ) ^ 2 = 1 / 12 := by
    rw [div_pow, mul_pow, hs3]
    norm_num
  have hc4 : (1 / (2 * Real.sqrt 3) : ℝ) ^ 4 = 1 / 144 := by
    calc
      (1 / (2 * Real.sqrt 3) : ℝ) ^ 4 =
          ((1 / (2 * Real.sqrt 3) : ℝ) ^ 2) ^ 2 := by ring
      _ = 1 / 144 := by rw [hc2]; norm_num
  have hc6 : (1 / (2 * Real.sqrt 3) : ℝ) ^ 6 = 1 / 1728 := by
    calc
      (1 / (2 * Real.sqrt 3) : ℝ) ^ 6 =
          ((1 / (2 * Real.sqrt 3) : ℝ) ^ 2) ^ 3 := by ring
      _ = 1 / 1728 := by rw [hc2]; norm_num
  have hl : linearForm (unitFaceAxis p) =
      C (1 / (2 * Real.sqrt 3)) * linearForm (doubledFaceAxisReal p) := by
    rw [linearForm, linearForm, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    rw [unitFaceAxis]
    calc
      C (doubledFaceAxisReal p i / (2 * Real.sqrt 3)) * X i =
          C ((1 / (2 * Real.sqrt 3)) * doubledFaceAxisReal p i) * X i := by
            congr 2
            ring
      _ = C (1 / (2 * Real.sqrt 3)) *
          (C (doubledFaceAxisReal p i) * X i) := by
            rw [map_mul]
            ring
  have hC2 : C (1 / (2 * Real.sqrt 3)) ^ 2 =
      (C (1 / 12) : MvPolynomial (Fin 3) ℝ) := by rw [← map_pow, hc2]
  have hC4 : C (1 / (2 * Real.sqrt 3)) ^ 4 =
      (C (1 / 144) : MvPolynomial (Fin 3) ℝ) := by rw [← map_pow, hc4]
  have hC6 : C (1 / (2 * Real.sqrt 3)) ^ 6 =
      (C (1 / 1728) : MvPolynomial (Fin 3) ℝ) := by rw [← map_pow, hc6]
  rw [faceAxisZonalForm, zonalHarmonic, hl]
  simp only [mul_pow]
  rw [hC2, hC4, hC6]
  have c6 : C (1 / 16) * C (1 / 1728) * 231 =
      (C (1 / 27648) : MvPolynomial (Fin 3) ℝ) * 231 := by
    rw [show (231 : MvPolynomial (Fin 3) ℝ) = C 231 by
        exact (map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 231).symm,
      ← map_mul, ← map_mul, ← map_mul]
    norm_num
  have c4 : C (1 / 16) * C (1 / 144) * 315 =
      (C (1 / 27648) : MvPolynomial (Fin 3) ℝ) * 3780 := by
    rw [show (315 : MvPolynomial (Fin 3) ℝ) = C 315 by
        exact (map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 315).symm,
      show (3780 : MvPolynomial (Fin 3) ℝ) = C 3780 by
        exact (map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 3780).symm,
      ← map_mul, ← map_mul, ← map_mul]
    norm_num
  have c2 : C (1 / 16) * C (1 / 12) * 105 =
      (C (1 / 27648) : MvPolynomial (Fin 3) ℝ) * 15120 := by
    rw [show (105 : MvPolynomial (Fin 3) ℝ) = C 105 by
        exact (map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 105).symm,
      show (15120 : MvPolynomial (Fin 3) ℝ) = C 15120 by
        exact (map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 15120).symm,
      ← map_mul, ← map_mul, ← map_mul]
    norm_num
  have c0 : C (1 / 16) * 5 =
      (C (1 / 27648) : MvPolynomial (Fin 3) ℝ) * 8640 := by
    rw [show (5 : MvPolynomial (Fin 3) ℝ) = C 5 by
        exact (map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 5).symm,
      show (8640 : MvPolynomial (Fin 3) ℝ) = C 8640 by
        exact (map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 8640).symm,
      ← map_mul, ← map_mul]
    norm_num
  linear_combination
    c6 * linearForm (doubledFaceAxisReal p) ^ 6 -
    c4 * (linearForm (doubledFaceAxisReal p) ^ 4 * quadric) +
    c2 * (linearForm (doubledFaceAxisReal p) ^ 2 * quadric ^ 2) -
    c0 * quadric ^ 3

/-- Weighted even powers of the ten doubled axis linear forms at the marked
five-label weight. -/
private noncomputable def markedAxisPowerSum (n : ℕ) : MvPolynomial (Fin 3) ℝ :=
  ∑ p, C (pairSum stabilizerFixedVertexWeight p) *
    (linearForm (doubledFaceAxisReal p) ^ 2) ^ n

private theorem marked_pair_weights :
    pairSum stabilizerFixedVertexWeight p01 = 3 ∧
    pairSum stabilizerFixedVertexWeight p02 = 3 ∧
    pairSum stabilizerFixedVertexWeight p03 = 3 ∧
    pairSum stabilizerFixedVertexWeight p04 = 3 ∧
    pairSum stabilizerFixedVertexWeight p12 = -2 ∧
    pairSum stabilizerFixedVertexWeight p13 = -2 ∧
    pairSum stabilizerFixedVertexWeight p14 = -2 ∧
    pairSum stabilizerFixedVertexWeight p23 = -2 ∧
    pairSum stabilizerFixedVertexWeight p24 = -2 ∧
    pairSum stabilizerFixedVertexWeight p34 = -2 := by
  constructor
  · change ∑ i ∈ ({0, 1} : Finset (Fin 5)), stabilizerFixedVertexWeight i = 3
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]

  constructor
  · change ∑ i ∈ ({0, 2} : Finset (Fin 5)), stabilizerFixedVertexWeight i = 3
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]
  constructor
  · change ∑ i ∈ ({0, 3} : Finset (Fin 5)), stabilizerFixedVertexWeight i = 3
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]
  constructor
  · change ∑ i ∈ ({0, 4} : Finset (Fin 5)), stabilizerFixedVertexWeight i = 3
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]
  constructor
  · change ∑ i ∈ ({1, 2} : Finset (Fin 5)), stabilizerFixedVertexWeight i = -2
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]
  constructor
  · change ∑ i ∈ ({1, 3} : Finset (Fin 5)), stabilizerFixedVertexWeight i = -2
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]
  constructor
  · change ∑ i ∈ ({1, 4} : Finset (Fin 5)), stabilizerFixedVertexWeight i = -2
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]
  constructor
  · change ∑ i ∈ ({2, 3} : Finset (Fin 5)), stabilizerFixedVertexWeight i = -2
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]
  constructor
  · change ∑ i ∈ ({2, 4} : Finset (Fin 5)), stabilizerFixedVertexWeight i = -2
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]
  · change ∑ i ∈ ({3, 4} : Finset (Fin 5)), stabilizerFixedVertexWeight i = -2
    rw [Finset.sum_pair (by decide)]
    norm_num [stabilizerFixedVertexWeight, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four,
      Matrix.head_cons, Matrix.tail_cons]

private theorem doubledFaceAxisReal_p01 : doubledFaceAxisReal p01 = ![-2, -2, -2] := by
  have h : doubledFaceAxis p01 = ![-2, -2, -2] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p01 i)) = _
  rw [h]
  funext i; fin_cases i <;> norm_num [goldenCast]

private theorem doubledFaceAxisReal_p02 : doubledFaceAxisReal p02 = ![-2, -2, 2] := by
  have h : doubledFaceAxis p02 = ![-2, -2, 2] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p02 i)) = _
  rw [h]
  funext i; fin_cases i <;> norm_num [goldenCast]

private theorem doubledFaceAxisReal_p03 : doubledFaceAxisReal p03 = ![-2, 2, -2] := by
  have h : doubledFaceAxis p03 = ![-2, 2, -2] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p03 i)) = _
  rw [h]
  funext i; fin_cases i <;> norm_num [goldenCast]

private theorem doubledFaceAxisReal_p04 : doubledFaceAxisReal p04 = ![-2, 2, 2] := by
  have h : doubledFaceAxis p04 = ![-2, 2, 2] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p04 i)) = _
  rw [h]
  funext i; fin_cases i <;> norm_num [goldenCast]

private theorem doubledFaceAxisReal_p12 :
    doubledFaceAxisReal p12 = ![1 - Real.sqrt 5, 1 + Real.sqrt 5, 0] := by
  have h : doubledFaceAxis p12 = ![⟨1, -1⟩, ⟨1, 1⟩, 0] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p12 i)) = _
  rw [h]
  funext i
  fin_cases i <;> norm_num [goldenCast]
  all_goals ring

private theorem doubledFaceAxisReal_p13 :
    doubledFaceAxisReal p13 = ![1 + Real.sqrt 5, 0, 1 - Real.sqrt 5] := by
  have h : doubledFaceAxis p13 = ![⟨1, 1⟩, 0, ⟨1, -1⟩] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p13 i)) = _
  rw [h]
  funext i
  fin_cases i <;> norm_num [goldenCast]
  all_goals ring

private theorem doubledFaceAxisReal_p14 :
    doubledFaceAxisReal p14 = ![0, 1 - Real.sqrt 5, 1 + Real.sqrt 5] := by
  have h : doubledFaceAxis p14 = ![0, ⟨1, -1⟩, ⟨1, 1⟩] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p14 i)) = _
  rw [h]
  funext i
  fin_cases i <;> norm_num [goldenCast]
  all_goals ring

private theorem doubledFaceAxisReal_p23 :
    doubledFaceAxisReal p23 = ![0, 1 - Real.sqrt 5, -1 - Real.sqrt 5] := by
  have h : doubledFaceAxis p23 = ![0, ⟨1, -1⟩, ⟨-1, -1⟩] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p23 i)) = _
  rw [h]
  funext i; fin_cases i <;> norm_num [goldenCast] <;> ring

private theorem doubledFaceAxisReal_p24 :
    doubledFaceAxisReal p24 = ![-1 - Real.sqrt 5, 0, 1 - Real.sqrt 5] := by
  have h : doubledFaceAxis p24 = ![⟨-1, -1⟩, 0, ⟨1, -1⟩] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p24 i)) = _
  rw [h]
  funext i; fin_cases i <;> norm_num [goldenCast] <;> ring

private theorem doubledFaceAxisReal_p34 :
    doubledFaceAxisReal p34 = ![1 - Real.sqrt 5, -1 - Real.sqrt 5, 0] := by
  have h : doubledFaceAxis p34 = ![⟨1, -1⟩, ⟨-1, -1⟩, 0] := by decide
  change (fun i ↦ goldenCast (Real.sqrt 5) sqrt_five_mul_self (doubledFaceAxis p34 i)) = _
  rw [h]
  funext i; fin_cases i <;> norm_num [goldenCast] <;> ring

private theorem C_sqrt_five_powers :
    (C (Real.sqrt 5) : MvPolynomial (Fin 3) ℝ) ^ 2 = 5 ∧
    (C (Real.sqrt 5) : MvPolynomial (Fin 3) ℝ) ^ 3 = 5 * C (Real.sqrt 5) ∧
    (C (Real.sqrt 5) : MvPolynomial (Fin 3) ℝ) ^ 4 = 25 ∧
    (C (Real.sqrt 5) : MvPolynomial (Fin 3) ℝ) ^ 5 = 25 * C (Real.sqrt 5) ∧
    (C (Real.sqrt 5) : MvPolynomial (Fin 3) ℝ) ^ 6 = 125 := by
  have h2 : (C (Real.sqrt 5) : MvPolynomial (Fin 3) ℝ) ^ 2 = 5 := by
    rw [pow_two, ← map_mul, sqrt_five_mul_self]
    exact map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 5
  refine ⟨h2, ?_, ?_, ?_, ?_⟩
  · calc
      C (Real.sqrt 5) ^ 3 = C (Real.sqrt 5) ^ 2 * C (Real.sqrt 5) := by ring
      _ = 5 * C (Real.sqrt 5) := by rw [h2]
  · calc
      C (Real.sqrt 5) ^ 4 = C (Real.sqrt 5) ^ 2 * C (Real.sqrt 5) ^ 2 := by ring
      _ = 25 := by rw [h2]; norm_num
  · calc
      C (Real.sqrt 5) ^ 5 = C (Real.sqrt 5) ^ 4 * C (Real.sqrt 5) := by ring
      _ = 25 * C (Real.sqrt 5) := by
        rw [show C (Real.sqrt 5) ^ 4 = (25 : MvPolynomial (Fin 3) ℝ) by
          calc
            C (Real.sqrt 5) ^ 4 = C (Real.sqrt 5) ^ 2 * C (Real.sqrt 5) ^ 2 := by ring
            _ = 25 := by rw [h2]; norm_num]
  · calc
      C (Real.sqrt 5) ^ 6 = C (Real.sqrt 5) ^ 2 * C (Real.sqrt 5) ^ 4 := by ring
      _ = 125 := by
        have hh4 : C (Real.sqrt 5) ^ 4 = (25 : MvPolynomial (Fin 3) ℝ) := by
          calc
            C (Real.sqrt 5) ^ 4 = C (Real.sqrt 5) ^ 2 * C (Real.sqrt 5) ^ 2 := by ring
            _ = 25 := by rw [h2]; norm_num
        rw [h2, hh4]
        norm_num

private theorem markedAxisPowerSum_zero : markedAxisPowerSum 0 = 0 := by
  obtain ⟨h01, h02, h03, h04, h12, h13, h14, h23, h24, h34⟩ := marked_pair_weights
  rw [markedAxisPowerSum, sum_pair_five]
  rw [h01, h02, h03, h04, h12, h13, h14, h23, h24, h34]
  have hC3 : (C 3 : MvPolynomial (Fin 3) ℝ) = 3 :=
    map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 3
  have hC2 : (C 2 : MvPolynomial (Fin 3) ℝ) = 2 :=
    map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) 2
  rw [hC3, map_neg, hC2]
  norm_num

set_option maxHeartbeats 2000000 in
set_option maxRecDepth 100000 in
private theorem markedAxisPowerSum_one : markedAxisPowerSum 1 = 0 := by
  obtain ⟨h01, h02, h03, h04, h12, h13, h14, h23, h24, h34⟩ := marked_pair_weights
  rw [markedAxisPowerSum, sum_pair_five]
  rw [h01, h02, h03, h04, h12, h13, h14, h23, h24, h34]
  rw [doubledFaceAxisReal_p01, doubledFaceAxisReal_p02, doubledFaceAxisReal_p03,
    doubledFaceAxisReal_p04, doubledFaceAxisReal_p12, doubledFaceAxisReal_p13,
    doubledFaceAxisReal_p14, doubledFaceAxisReal_p23, doubledFaceAxisReal_p24,
    doubledFaceAxisReal_p34]
  norm_num [linearForm, Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
  simp only [map_ofNat]
  obtain ⟨h2, h3, h4, h5, h6⟩ := C_sqrt_five_powers
  ring_nf
  rw [h2]
  ring

set_option maxHeartbeats 2000000 in
set_option maxRecDepth 100000 in
private theorem markedAxisPowerSum_two : markedAxisPowerSum 2 =
    C (-256) * (X 0 ^ 4 + X 1 ^ 4 + X 2 ^ 4 -
      3 * (X 0 ^ 2 * X 1 ^ 2 + X 0 ^ 2 * X 2 ^ 2 + X 1 ^ 2 * X 2 ^ 2)) := by
  obtain ⟨h01, h02, h03, h04, h12, h13, h14, h23, h24, h34⟩ := marked_pair_weights
  rw [markedAxisPowerSum, sum_pair_five]
  rw [h01, h02, h03, h04, h12, h13, h14, h23, h24, h34]
  rw [doubledFaceAxisReal_p01, doubledFaceAxisReal_p02, doubledFaceAxisReal_p03,
    doubledFaceAxisReal_p04, doubledFaceAxisReal_p12, doubledFaceAxisReal_p13,
    doubledFaceAxisReal_p14, doubledFaceAxisReal_p23, doubledFaceAxisReal_p24,
    doubledFaceAxisReal_p34]
  norm_num [linearForm, Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
  simp only [map_ofNat]
  obtain ⟨h2, h3, h4, h5, h6⟩ := C_sqrt_five_powers
  ring_nf
  rw [h4, h2]
  ring

set_option maxHeartbeats 2000000 in
set_option maxRecDepth 100000 in
private theorem markedAxisPowerSum_three : markedAxisPowerSum 3 = C (-1920) *
    (2 * X 0 ^ 6 + 2 * X 1 ^ 6 + 2 * X 2 ^ 6 -
      C (3 + Real.sqrt 5) * (X 0 ^ 4 * X 1 ^ 2) -
      C (3 - Real.sqrt 5) * (X 0 ^ 4 * X 2 ^ 2) -
      C (3 - Real.sqrt 5) * (X 0 ^ 2 * X 1 ^ 4) -
      36 * (X 0 ^ 2 * X 1 ^ 2 * X 2 ^ 2) -
      C (3 + Real.sqrt 5) * (X 0 ^ 2 * X 2 ^ 4) -
      C (3 + Real.sqrt 5) * (X 1 ^ 4 * X 2 ^ 2) -
      C (3 - Real.sqrt 5) * (X 1 ^ 2 * X 2 ^ 4)) := by
  obtain ⟨h01, h02, h03, h04, h12, h13, h14, h23, h24, h34⟩ := marked_pair_weights
  rw [markedAxisPowerSum, sum_pair_five]
  rw [h01, h02, h03, h04, h12, h13, h14, h23, h24, h34]
  rw [doubledFaceAxisReal_p01, doubledFaceAxisReal_p02, doubledFaceAxisReal_p03,
    doubledFaceAxisReal_p04, doubledFaceAxisReal_p12, doubledFaceAxisReal_p13,
    doubledFaceAxisReal_p14, doubledFaceAxisReal_p23, doubledFaceAxisReal_p24,
    doubledFaceAxisReal_p34]
  norm_num [linearForm, Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
  simp only [map_ofNat]
  obtain ⟨h2, h3, h4, h5, h6⟩ := C_sqrt_five_powers
  ring_nf
  rw [h6, h5, h4, h3, h2]
  ring

set_option maxHeartbeats 4000000 in
set_option maxRecDepth 100000 in
/-- The face-axis zonal combination at the marked five-label weight is the
odd/even tetrahedral field with the nonnegative real square root of five. -/
theorem zonalCombination_pairSum_stabilizerFixedVertexWeight :
    zonalCombination (pairSum stabilizerFixedVertexWeight) =
      markedTetrahedralField (Real.sqrt 5) := by
  have hfield : zonalCombination (pairSum stabilizerFixedVertexWeight) =
      C (1 / 27648) *
        (231 * markedAxisPowerSum 3 - 3780 * markedAxisPowerSum 2 * quadric +
          15120 * markedAxisPowerSum 1 * quadric ^ 2 -
          8640 * markedAxisPowerSum 0 * quadric ^ 3) := by
    rw [zonalCombination]
    simp_rw [faceAxisZonalForm_doubled]
    simp only [markedAxisPowerSum]
    simp_rw [sum_pair_five]
    ring
  rw [hfield, markedAxisPowerSum_zero, markedAxisPowerSum_one,
    markedAxisPowerSum_two, markedAxisPowerSum_three]
  simp only [markedTetrahedralField, tetrahedralHarmonicCombination,
    tetrahedralOddHarmonic, tetrahedralEvenHarmonic, squaredCoordinate, quadric,
    Fin.sum_univ_three]
  simp only [map_add, map_sub, map_neg, map_ofNat]
  have cpure : C (1 / 27648) * 80640 =
      (C (35 / 12) : MvPolynomial (Fin 3) ℝ) := by
    calc
      C (1 / 27648) * 80640 = C (1 / 27648) * C (80640 : ℝ) := by
        congr 1
      _ = C (35 / 12) := by rw [← map_mul]; norm_num
  have ctriple : C (1 / 27648) * 7257600 =
      (C (35 / 12) : MvPolynomial (Fin 3) ℝ) * 90 := by
    calc
      C (1 / 27648) * 7257600 = C (1 / 27648) * C (7257600 : ℝ) := by
        congr 1
      _ = C ((35 / 12) * 90) := by rw [← map_mul]; norm_num
      _ = C (35 / 12) * 90 := by
        rw [map_mul]
        congr 1
  have cmixed : C (1 / 27648) * 604800 =
      (C (35 / 12) : MvPolynomial (Fin 3) ℝ) * C (15 / 2) := by
    calc
      C (1 / 27648) * 604800 = C (1 / 27648) * C (604800 : ℝ) := by
        congr 1
      _ = C ((35 / 12) * (15 / 2)) := by rw [← map_mul]; norm_num
      _ = C (35 / 12) * C (15 / 2) := by rw [map_mul]
  have cgold : -(C (1 / 27648) * C (Real.sqrt 5) * 443520) =
      (C (-385 * Real.sqrt 5 / 24) : MvPolynomial (Fin 3) ℝ) := by
    calc
      -(C (1 / 27648) * C (Real.sqrt 5) * 443520) =
          -(C (1 / 27648) * C (Real.sqrt 5) * C (443520 : ℝ)) := by
            congr 2
      _ = C (-385 * Real.sqrt 5 / 24) := by
        rw [← map_mul, ← map_mul, ← map_neg]
        congr 1
        ring
  linear_combination
    ctriple * (X 0 ^ 2 * X 1 ^ 2 * X 2 ^ 2) +
    cpure * (X 0 ^ 6 + X 1 ^ 6 + X 2 ^ 6) -
    cmixed * (X 0 ^ 2 * X 1 ^ 4 + X 0 ^ 2 * X 2 ^ 4 + X 0 ^ 4 * X 1 ^ 2 +
      X 0 ^ 4 * X 2 ^ 2 + X 1 ^ 2 * X 2 ^ 4 + X 1 ^ 4 * X 2 ^ 2) +
    cgold * (X 0 ^ 2 * X 1 ^ 4 + X 1 ^ 2 * X 2 ^ 4 + X 0 ^ 4 * X 2 ^ 2 -
      X 0 ^ 2 * X 2 ^ 4 - X 0 ^ 4 * X 1 ^ 2 - X 1 ^ 4 * X 2 ^ 2)

/-- The marked face-axis zonal field has normalized cubic mean
`-15680000/1247103`. -/
theorem normalizedMean_zonalCombination_stabilizerFixedVertexWeight_cube :
    normalizedMean 18
      (zonalCombination (pairSum stabilizerFixedVertexWeight) ^ 3) =
        -15680000 / 1247103 := by
  rw [zonalCombination_pairSum_stabilizerFixedVertexWeight]
  exact normalizedMean_markedTetrahedralField_cube
    (by rw [pow_two]; exact sqrt_five_mul_self)

/-- The real orthogonal matrix obtained by dividing the integral scaled
icosahedral rotation by four and sending the golden generator to `√5`. -/
noncomputable def faceAxisRotation (r : Fin 3) (i j : Fin 3) : ℝ :=
  goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r j i) / 4

/-- The real face-axis rotations have orthonormal rows. -/
theorem faceAxisRotation_rows_orthogonal (r i j : Fin 3) :
    ∑ k, faceAxisRotation r i k * faceAxisRotation r j k =
      if i = j then 1 else 0 := by
  fin_cases r <;> fin_cases i <;> fin_cases j <;>
    norm_num [faceAxisRotation, scaledRotation, goldenCast, Fin.sum_univ_three,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] <;>
    nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 5)]

/-- Transposition in `faceAxisRotation` turns the certified row orthogonality
of the integral matrices into column orthogonality over the reals. -/
private theorem faceAxisRotation_columns_orthogonal (r i j : Fin 3) :
    ∑ k, faceAxisRotation r k i * faceAxisRotation r k j =
      if i = j then 1 else 0 := by
  have h := congrArg (goldenCast (Real.sqrt 5) sqrt_five_mul_self)
    (scaledRotation_rows_orthogonal r i j)
  simp only [map_sum, map_mul] at h
  simp only [faceAxisRotation]
  calc
    ∑ k, goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r i k) / 4 *
        (goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r j k) / 4) =
        (∑ k, goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r i k) *
          goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r j k)) / 16 := by
            rw [Finset.sum_div]
            apply Finset.sum_congr rfl
            intro k _
            ring
    _ = if i = j then 1 else 0 := by
      rw [h]
      by_cases hij : i = j <;> simp [hij, goldenCast]

/-- The inverse tables of the three displayed label permutations. -/
def inverseLabelPermutation : Fin 3 → Fin 5 → Fin 5
  | 0 => ![0, 4, 3, 2, 1]
  | 1 => ![0, 1, 3, 4, 2]
  | 2 => ![1, 0, 4, 3, 2]

/-- The displayed label action of the `r`-th rotation, regarded as a
permutation. -/
def faceAxisLabelPermutation (r : Fin 3) : Equiv.Perm (Fin 5) :=
  { toFun := labelPermutation r
    invFun := inverseLabelPermutation r
    left_inv := by revert r; decide
    right_inv := by revert r; decide }

/-- The permutation wrapper acts by the displayed label function. -/
@[simp] theorem faceAxisLabelPermutation_apply (r : Fin 3) (i : Fin 5) :
    faceAxisLabelPermutation r i = labelPermutation r i := rfl

/-- Relabel a pair by one of the three displayed label permutations. -/
private def relabelPair (e : Equiv.Perm (Fin 5)) (p : Pair 5) : Pair 5 :=
  ⟨p.vertices.image e, by
    change p.vertices.image e ∈ Finset.univ.powersetCard 2
    rw [Finset.mem_powersetCard]
    refine ⟨Finset.subset_univ _, ?_⟩
    rw [Finset.card_image_of_injective _ e.injective, p.card_vertices]⟩

/-- Relabelling two-subsets by a label permutation is itself a permutation. -/
private def relabelPairEquiv (e : Equiv.Perm (Fin 5)) : Equiv.Perm (Pair 5) :=
  { toFun := relabelPair e
    invFun := relabelPair e.symm
    left_inv := by
      intro p
      apply Subtype.ext
      change Finset.image e.symm (Finset.image e p.vertices) = p.vertices
      ext i
      simp
    right_inv := by
      intro p
      apply Subtype.ext
      change Finset.image e (Finset.image e.symm p.vertices) = p.vertices
      ext i
      simp }

private theorem pairSum_relabelPair (e : Equiv.Perm (Fin 5))
    (y : Fin 5 → ℝ) (p : Pair 5) :
    pairSum y (relabelPair e p) = pairSum (fun i ↦ y (e i)) p := by
  rw [pairSum, pairSum]
  change ∑ i ∈ p.vertices.image e, y i = ∑ i ∈ p.vertices, y (e i)
  rw [Finset.sum_image (fun i _ j _ h ↦ e.injective h)]

private def rotatedPair (r : Fin 3) (p : Pair 5) : Pair 5 :=
  relabelPair (faceAxisLabelPermutation r) p

/-- Each displayed rotation preserves the coordinate quadric under linear
substitution. -/
private theorem linearSubstitution_faceAxisRotation_quadric (r : Fin 3) :
    linearSubstitution (faceAxisRotation r) quadric = quadric := by
  have h00 := congrArg (C : ℝ → MvPolynomial (Fin 3) ℝ)
    (faceAxisRotation_columns_orthogonal r 0 0)
  have h01 := congrArg (C : ℝ → MvPolynomial (Fin 3) ℝ)
    (faceAxisRotation_columns_orthogonal r 0 1)
  have h02 := congrArg (C : ℝ → MvPolynomial (Fin 3) ℝ)
    (faceAxisRotation_columns_orthogonal r 0 2)
  have h11 := congrArg (C : ℝ → MvPolynomial (Fin 3) ℝ)
    (faceAxisRotation_columns_orthogonal r 1 1)
  have h12 := congrArg (C : ℝ → MvPolynomial (Fin 3) ℝ)
    (faceAxisRotation_columns_orthogonal r 1 2)
  have h22 := congrArg (C : ℝ → MvPolynomial (Fin 3) ℝ)
    (faceAxisRotation_columns_orthogonal r 2 2)
  norm_num [Fin.sum_univ_three] at h00 h01 h02 h11 h12 h22
  simp only [if_neg (by decide : (0 : Fin 3) ≠ 2)] at h02
  simp only [if_neg (by decide : (1 : Fin 3) ≠ 2)] at h12
  rw [quadric, map_sum]
  simp only [map_pow, linearSubstitution_X, linearForm, Fin.sum_univ_three]
  linear_combination
    (X 0 ^ 2) * h00 + 2 * X 0 * X 1 * h01 + 2 * X 0 * X 2 * h02 +
    (X 1 ^ 2) * h11 + 2 * X 1 * X 2 * h12 + (X 2 ^ 2) * h22

/-- Linear substitution of a linear form is multiplication of its coefficient
vector by the transpose of the substitution matrix. -/
private theorem linearSubstitution_linearForm (M : Fin 3 → Fin 3 → ℝ)
    (u : Fin 3 → ℝ) :
    linearSubstitution M (linearForm u) =
      linearForm (fun k ↦ ∑ j, u j * M j k) := by
  have hc (a : ℝ) : linearSubstitution M (C a) = C a := by
    simp [linearSubstitution]
  rw [linearForm, map_sum, linearForm]
  simp only [map_mul, hc, linearSubstitution_X]
  simp_rw [linearForm, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro k _
  calc
    ∑ j, C (u j) * (C (M j k) * X k) =
        (∑ j, C (u j) * C (M j k)) * X k := by
          rw [Finset.sum_mul]
          apply Finset.sum_congr rfl
          intro j _
          ring
    _ = C (∑ j, u j * M j k) * X k := by
      simp only [map_sum, map_mul]

/-- The certified integral axis transport, cast to normalized real face axes. -/
private theorem faceAxisRotation_unitFaceAxis_coefficients (r : Fin 3) (p : Pair 5) :
    (fun k ↦ ∑ j, unitFaceAxis p j * faceAxisRotation r j k) =
        unitFaceAxis (rotatedPair r p) ∨
      (fun k ↦ ∑ j, unitFaceAxis p j * faceAxisRotation r j k) =
        -unitFaceAxis (rotatedPair r p) := by
  obtain ⟨q, hq, hp | hp⟩ := scaledRotationApply_doubledFaceAxis r p
  all_goals
    have hqr : q = rotatedPair r p := Subtype.ext hq
    subst q
  · left
    funext k
    have hk := congrArg (goldenCast (Real.sqrt 5) sqrt_five_mul_self)
      (congrFun hp k)
    simp only [scaledRotationApply, map_sum, map_mul, map_ofNat] at hk
    change (∑ x, goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k x) *
      doubledFaceAxisReal p x) = 4 * doubledFaceAxisReal (rotatedPair r p) k at hk
    have hk' : (∑ x, doubledFaceAxisReal p x *
        goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k x)) =
        4 * doubledFaceAxisReal (rotatedPair r p) k := by
      rw [Finset.sum_congr rfl (fun x _ ↦ mul_comm _ _), hk]
    change (∑ j, doubledFaceAxisReal p j / (2 * Real.sqrt 3) *
      (goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k j) / 4)) =
        doubledFaceAxisReal (rotatedPair r p) k / (2 * Real.sqrt 3)
    rw [show (∑ j, doubledFaceAxisReal p j / (2 * Real.sqrt 3) *
        (goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k j) / 4)) =
        (∑ j, doubledFaceAxisReal p j *
          goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k j)) /
            (8 * Real.sqrt 3) by
      rw [Finset.sum_div]
      apply Finset.sum_congr rfl
      intro j _
      ring]
    field_simp
    nlinarith [hk']
  · right
    funext k
    have hk := congrArg (goldenCast (Real.sqrt 5) sqrt_five_mul_self)
      (congrFun hp k)
    simp only [scaledRotationApply, map_sum, map_mul, map_neg, map_ofNat] at hk
    change (∑ x, goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k x) *
      doubledFaceAxisReal p x) = -(4 * doubledFaceAxisReal (rotatedPair r p) k) at hk
    have hk' : (∑ x, doubledFaceAxisReal p x *
        goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k x)) =
        -(4 * doubledFaceAxisReal (rotatedPair r p) k) := by
      rw [Finset.sum_congr rfl (fun x _ ↦ mul_comm _ _), hk]
    change (∑ j, doubledFaceAxisReal p j / (2 * Real.sqrt 3) *
      (goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k j) / 4)) =
        -(doubledFaceAxisReal (rotatedPair r p) k / (2 * Real.sqrt 3))
    rw [show (∑ j, doubledFaceAxisReal p j / (2 * Real.sqrt 3) *
        (goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k j) / 4)) =
        (∑ j, doubledFaceAxisReal p j *
          goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r k j)) /
            (8 * Real.sqrt 3) by
      rw [Finset.sum_div]
      apply Finset.sum_congr rfl
      intro j _
      ring]
    field_simp
    nlinarith [hk']

/-- A real face-axis rotation transports each normalized axis up to sign. -/
private theorem linearSubstitution_faceAxisRotation_unitFaceAxis (r : Fin 3) (p : Pair 5) :
    linearSubstitution (faceAxisRotation r) (linearForm (unitFaceAxis p)) =
        linearForm (unitFaceAxis (rotatedPair r p)) ∨
      linearSubstitution (faceAxisRotation r) (linearForm (unitFaceAxis p)) =
        -linearForm (unitFaceAxis (rotatedPair r p)) := by
  rw [linearSubstitution_linearForm]
  rcases faceAxisRotation_unitFaceAxis_coefficients r p with h | h
  · left
    rw [h]
  · right
    rw [h]
    simp [linearForm]

/-- A zonal form is transported once its axis linear form is transported up to
sign and the coordinate quadric is fixed. -/
private theorem linearSubstitution_zonalHarmonic_of_linearForm_eq_or_neg
    (M : Fin 3 → Fin 3 → ℝ) (u v : Fin 3 → ℝ)
    (hq : linearSubstitution M quadric = quadric)
    (hl : linearSubstitution M (linearForm u) = linearForm v ∨
      linearSubstitution M (linearForm u) = -linearForm v) :
    linearSubstitution M (zonalHarmonic u) = zonalHarmonic v := by
  have hc : linearSubstitution M (C (1 / 16)) = C (1 / 16) := by
    simp [linearSubstitution]
  rcases hl with hl | hl <;>
    simp only [zonalHarmonic, map_mul, map_sub, map_add, map_pow, map_ofNat] <;>
    rw [hl, hq, hc]
  all_goals ring

/-- A displayed rotation carries each individual face-axis zonal form to the
zonal form of the relabelled pair.  Only the degree-one axis form and the
degree-two quadric are computed. -/
private theorem linearSubstitution_faceAxisRotation_faceAxisZonalForm
    (r : Fin 3) (p : Pair 5) :
    linearSubstitution (faceAxisRotation r) (faceAxisZonalForm p) =
      faceAxisZonalForm (rotatedPair r p) := by
  rw [faceAxisZonalForm, faceAxisZonalForm]
  apply linearSubstitution_zonalHarmonic_of_linearForm_eq_or_neg
    (M := faceAxisRotation r) (u := unitFaceAxis p)
    (v := unitFaceAxis (rotatedPair r p))
    (linearSubstitution_faceAxisRotation_quadric r)
  exact linearSubstitution_faceAxisRotation_unitFaceAxis r p

/-- Substitution by a face-axis rotation pulls the coefficient labels back by
the inverse permutation. -/
theorem linearSubstitution_faceAxisRotation_zonalCombination_pairSum
    (r : Fin 3) (y : Fin 5 → ℝ) :
    linearSubstitution (faceAxisRotation r) (zonalCombination (pairSum y)) =
      zonalCombination (pairSum (fun i ↦ y (inverseLabelPermutation r i))) := by
  have hc (a : ℝ) : linearSubstitution (faceAxisRotation r) (C a) = C a := by
    simp [linearSubstitution]
  rw [zonalCombination, zonalCombination, map_sum]
  simp_rw [map_mul, hc,
    linearSubstitution_faceAxisRotation_faceAxisZonalForm]
  rw [← (relabelPairEquiv (faceAxisLabelPermutation r)).symm.sum_comp]
  apply Finset.sum_congr rfl
  intro p _
  change C (pairSum y (relabelPair (faceAxisLabelPermutation r).symm p)) *
      faceAxisZonalForm
        (relabelPair (faceAxisLabelPermutation r)
          (relabelPair (faceAxisLabelPermutation r).symm p)) =
    C (pairSum (fun i ↦ y ((faceAxisLabelPermutation r).symm i)) p) *
      faceAxisZonalForm p
  rw [pairSum_relabelPair]
  have h := (relabelPairEquiv (faceAxisLabelPermutation r)).apply_symm_apply p
  change relabelPair (faceAxisLabelPermutation r)
      (relabelPair (faceAxisLabelPermutation r).symm p) = p at h
  rw [h]

/-- The cubic moment of the face-axis zonal field attached to a five-label
weight vector. -/
noncomputable def faceAxisCubic (y : Fin 5 → ℝ) : ℝ :=
  normalizedMean 18 (zonalCombination (pairSum y) ^ 3)

private theorem normalizedMean_linearSubstitution_faceAxisRotation
    (r : Fin 3) (d : ℕ) (p : MvPolynomial (Fin 3) ℝ) :
    normalizedMean d (linearSubstitution (faceAxisRotation r) p) = normalizedMean d p := by
  rw [normalizedMean, normalizedMean]
  have h := congrArg (fun L : MvPolynomial (Fin 3) ℝ →ₗ[ℝ] ℝ ↦ L p)
    (gaussianMoment_comp_linearSubstitution (faceAxisRotation r)
      (faceAxisRotation_rows_orthogonal r))
  exact congrArg (fun z : ℝ ↦ z / momentFactor (d + 2)) h

/-- The face-axis cubic is invariant under pullback by each inverse displayed
label permutation. -/
private theorem faceAxisCubic_comp_inverseLabelPermutation (r : Fin 3) (y : Fin 5 → ℝ) :
    faceAxisCubic (fun i ↦ y (inverseLabelPermutation r i)) = faceAxisCubic y := by
  rw [faceAxisCubic, faceAxisCubic,
    ← linearSubstitution_faceAxisRotation_zonalCombination_pairSum, ← map_pow]
  exact normalizedMean_linearSubstitution_faceAxisRotation r 18 _

/-- The face-axis cubic is invariant under each of the three displayed label
permutations induced by icosahedral rotations. -/
theorem faceAxisCubic_comp_faceAxisLabelPermutation (r : Fin 3) (y : Fin 5 → ℝ) :
    faceAxisCubic (fun i ↦ y (faceAxisLabelPermutation r i)) = faceAxisCubic y := by
  have h := faceAxisCubic_comp_inverseLabelPermutation r
    (fun i ↦ y (faceAxisLabelPermutation r i))
  have hfun : (fun i ↦ y (faceAxisLabelPermutation r (inverseLabelPermutation r i))) = y := by
    funext i
    fin_cases r <;> fin_cases i <;> rfl
  rw [hfun] at h
  exact h.symm

/-- Apply a word in the three displayed rotation generators from left to right
to a label. -/
def applyRotationWord : List (Fin 3) → Fin 5 → Fin 5
  | [], i => i
  | r :: word, i => faceAxisLabelPermutation r (applyRotationWord word i)

/-- The cubic moment is invariant under every word in the three displayed
rotation generators. -/
theorem faceAxisCubic_comp_applyRotationWord (word : List (Fin 3)) (y : Fin 5 → ℝ) :
    faceAxisCubic (fun i ↦ y (applyRotationWord word i)) = faceAxisCubic y := by
  induction word generalizing y with
  | nil => rfl
  | cons r word ih =>
      have hfun : (fun i ↦ y (applyRotationWord (r :: word) i)) =
          (fun i ↦ (fun j ↦ y (faceAxisLabelPermutation r j))
            (applyRotationWord word i)) := by
        funext i
        rfl
      rw [hfun]
      exact (ih (fun j ↦ y (faceAxisLabelPermutation r j))).trans
        (faceAxisCubic_comp_faceAxisLabelPermutation r y)

/-- Explicit words carrying label zero to each of the five labels. -/
def rootMoverWord : Fin 5 → List (Fin 3)
  | 0 => []
  | 1 => [2]
  | 2 => [2, 0, 2]
  | 3 => [1, 0, 2]
  | 4 => [0, 2]

set_option maxHeartbeats 800000 in
/-- The displayed root-moving words have their asserted endpoints. -/
theorem applyRotationWord_rootMoverWord (i : Fin 5) :
    applyRotationWord (rootMoverWord i) 0 = i := by
  revert i
  decide

/-- Explicit words in the stabilizer of label zero.  For distinct nonzero
labels `i,j`, the selected word carries the ordered pair `(1,2)` to `(i,j)`;
entries outside that domain are irrelevant and set to the empty word. -/
def stabilizerPairWord : Fin 5 → Fin 5 → List (Fin 3) :=
  ![![[], [], [], [], []],
    ![[], [], [], [1, 1], [1]],
    ![[], [1, 1, 0, 1], [], [0, 1, 0], [1, 1, 0]],
    ![[], [1, 0, 1], [1, 0], [], [1, 0, 1, 1]],
    ![[], [0, 1], [0, 1, 1], [0], []]]

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
    applyRotationWord (u ++ v) i = applyRotationWord u (applyRotationWord v i) := by
  induction u generalizing i with
  | nil => rfl
  | cons r u ih => simp [applyRotationWord, ih]

/-- The constructed inverse word undoes a rotation word on every label. -/
theorem applyRotationWord_inverseRotationWord (word : List (Fin 3)) (i : Fin 5) :
    applyRotationWord (inverseRotationWord word) (applyRotationWord word i) = i := by
  have hinverseGenerator (r : Fin 3) (j : Fin 5) :
      applyRotationWord (inverseGeneratorWord r) (faceAxisLabelPermutation r j) = j := by
    revert j
    fin_cases r <;> decide
  induction word generalizing i with
  | nil => rfl
  | cons r word ih =>
      rw [applyRotationWord, inverseRotationWord, applyRotationWord_append,
        hinverseGenerator, ih]

/-- A word carrying a distinct ordered label triple to the standard triple
`(0,1,2)`: first move its first label to zero, then use the sharply transitive
zero stabilizer on the other two labels. -/
def canonicalTripleWord (a b c : Fin 5) : List (Fin 3) :=
  let move := inverseRotationWord (rootMoverWord a)
  let b' := applyRotationWord move b
  let c' := applyRotationWord move c
  inverseRotationWord (stabilizerPairWord b' c') ++ move

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
  inverseRotationWord (canonicalTripleWord i j k) ++ canonicalTripleWord a b c

/-- The displayed rotation words act three-transitively on the five labels. -/
theorem applyRotationWord_tripleTransportWord {a b c i j k : Fin 5}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hij : i ≠ j) (hik : i ≠ k) (hjk : j ≠ k) :
    applyRotationWord (tripleTransportWord a b c i j k) a = i ∧
      applyRotationWord (tripleTransportWord a b c i j k) b = j ∧
      applyRotationWord (tripleTransportWord a b c i j k) c = k := by
  have hs := applyRotationWord_canonicalTripleWord hab hac hbc
  have ht := applyRotationWord_canonicalTripleWord hij hik hjk
  constructor
  · rw [tripleTransportWord, applyRotationWord_append, hs.1]
    have h := applyRotationWord_inverseRotationWord (canonicalTripleWord i j k) i
    rwa [ht.1] at h
  · constructor
    · rw [tripleTransportWord, applyRotationWord_append, hs.2.1]
      have h := applyRotationWord_inverseRotationWord (canonicalTripleWord i j k) j
      rwa [ht.2.1] at h
    · rw [tripleTransportWord, applyRotationWord_append, hs.2.2]
      have h := applyRotationWord_inverseRotationWord (canonicalTripleWord i j k) k
      rwa [ht.2.2] at h

/-- The coordinate weight supported at one of the five labels. -/
def coordinateWeight (i : Fin 5) : Fin 5 → ℝ := fun j ↦ if j = i then 1 else 0

/-- The face-axis field is the linear combination of the five fields attached
to the coordinate weights. -/
theorem zonalCombination_pairSum_eq_sum_coordinateWeight (y : Fin 5 → ℝ) :
    zonalCombination (pairSum y) =
      ∑ i, C (y i) * zonalCombination (pairSum (coordinateWeight i)) := by
  have hcoeff (p : Pair 5) :
      pairSum y p = ∑ i, y i * pairSum (coordinateWeight i) p := by
    simp [pairSum, coordinateWeight]
  rw [zonalCombination]
  simp_rw [hcoeff, map_sum, map_mul, Finset.sum_mul, zonalCombination,
    Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro p _
  ring

/-- The polarized cubic moment of three five-label weight vectors. -/
noncomputable def faceAxisMixedCubic (y z w : Fin 5 → ℝ) : ℝ :=
  normalizedMean 18
    (zonalCombination (pairSum y) * zonalCombination (pairSum z) *
      zonalCombination (pairSum w))

/-- The polarized cubic is invariant when all three weights are pulled back by
one displayed label permutation. -/
theorem faceAxisMixedCubic_comp_faceAxisLabelPermutation
    (r : Fin 3) (y z w : Fin 5 → ℝ) :
    faceAxisMixedCubic (fun i ↦ y (faceAxisLabelPermutation r i))
        (fun i ↦ z (faceAxisLabelPermutation r i))
        (fun i ↦ w (faceAxisLabelPermutation r i)) =
      faceAxisMixedCubic y z w := by
  have hy := linearSubstitution_faceAxisRotation_zonalCombination_pairSum r
    (fun i ↦ y (faceAxisLabelPermutation r i))
  have hz := linearSubstitution_faceAxisRotation_zonalCombination_pairSum r
    (fun i ↦ z (faceAxisLabelPermutation r i))
  have hw := linearSubstitution_faceAxisRotation_zonalCombination_pairSum r
    (fun i ↦ w (faceAxisLabelPermutation r i))
  have hcancel (v : Fin 5 → ℝ) :
      (fun i ↦ v (faceAxisLabelPermutation r (inverseLabelPermutation r i))) = v := by
    funext i
    fin_cases r <;> fin_cases i <;> rfl
  rw [hcancel] at hy hz hw
  rw [faceAxisMixedCubic, faceAxisMixedCubic, ← hy, ← hz, ← hw,
    ← map_mul, ← map_mul,
    normalizedMean_linearSubstitution_faceAxisRotation]

/-- The polarized cubic is invariant under simultaneous pullback by every word
in the displayed rotation generators. -/
theorem faceAxisMixedCubic_comp_applyRotationWord
    (word : List (Fin 3)) (y z w : Fin 5 → ℝ) :
    faceAxisMixedCubic (fun i ↦ y (applyRotationWord word i))
        (fun i ↦ z (applyRotationWord word i))
        (fun i ↦ w (applyRotationWord word i)) =
      faceAxisMixedCubic y z w := by
  induction word generalizing y z w with
  | nil => rfl
  | cons r word ih =>
      change faceAxisMixedCubic
          (fun i ↦ (fun j ↦ y (faceAxisLabelPermutation r j))
            (applyRotationWord word i))
          (fun i ↦ (fun j ↦ z (faceAxisLabelPermutation r j))
            (applyRotationWord word i))
          (fun i ↦ (fun j ↦ w (faceAxisLabelPermutation r j))
            (applyRotationWord word i)) = _
      exact (ih (fun j ↦ y (faceAxisLabelPermutation r j))
        (fun j ↦ z (faceAxisLabelPermutation r j))
        (fun j ↦ w (faceAxisLabelPermutation r j))).trans
          (faceAxisMixedCubic_comp_faceAxisLabelPermutation r y z w)

/-- The structure coefficient of the polarized cubic at three labels. -/
noncomputable def faceAxisCubicCoefficient (i j k : Fin 5) : ℝ :=
  faceAxisMixedCubic (coordinateWeight i) (coordinateWeight j) (coordinateWeight k)

/-- Simultaneous transport of all three indices by a rotation word preserves a
polarized structure coefficient. -/
theorem faceAxisCubicCoefficient_applyRotationWord
    (word : List (Fin 3)) (i j k : Fin 5) :
    faceAxisCubicCoefficient (applyRotationWord word i)
        (applyRotationWord word j) (applyRotationWord word k) =
      faceAxisCubicCoefficient i j k := by
  have hinj : Function.Injective (applyRotationWord word) := by
    intro a b hab
    have h := congrArg (applyRotationWord (inverseRotationWord word)) hab
    simpa only [applyRotationWord_inverseRotationWord] using h
  have hcoordinate (a : Fin 5) :
      (fun x ↦ coordinateWeight (applyRotationWord word a)
        (applyRotationWord word x)) = coordinateWeight a := by
    funext x
    simp only [coordinateWeight]
    rw [if_congr (hinj.eq_iff)]
    all_goals rfl
  have h := faceAxisMixedCubic_comp_applyRotationWord word
    (coordinateWeight (applyRotationWord word i))
    (coordinateWeight (applyRotationWord word j))
    (coordinateWeight (applyRotationWord word k))
  rw [hcoordinate i, hcoordinate j, hcoordinate k] at h
  exact h.symm

/-- Expanding the face-axis field in the coordinate weights expands its cubic
moment into the corresponding three-index structure coefficients. -/
theorem faceAxisCubic_eq_sum_coefficients (y : Fin 5 → ℝ) :
    faceAxisCubic y =
      ∑ k, ∑ j, ∑ i, y i * y j * y k * faceAxisCubicCoefficient i j k := by
  rw [faceAxisCubic, zonalCombination_pairSum_eq_sum_coordinateWeight]
  rw [pow_three]
  simp only [Finset.sum_mul, Finset.mul_sum, normalizedMean_sum]
  apply Finset.sum_congr rfl
  intro k _
  apply Finset.sum_congr rfl
  intro j _
  apply Finset.sum_congr rfl
  intro i _
  rw [show
      C (y i) * zonalCombination (pairSum (coordinateWeight i)) *
          (C (y j) * zonalCombination (pairSum (coordinateWeight j)) *
            (C (y k) * zonalCombination (pairSum (coordinateWeight k)))) =
      C (y i * y j * y k) *
          (zonalCombination (pairSum (coordinateWeight i)) *
            zonalCombination (pairSum (coordinateWeight j)) *
              zonalCombination (pairSum (coordinateWeight k))) by
        simp only [map_mul]
        ring,
      normalizedMean_C_mul]
  rfl

end RelativeConicArcs.SphericalCubicRestriction
