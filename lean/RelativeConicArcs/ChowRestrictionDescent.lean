import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Algebra.CharP.Lemmas
import Mathlib.Data.Fintype.BigOperators
import Mathlib.FieldTheory.Perfect

/-!
# Polynomial restriction and Frobenius descent for paired linear factors

A homogeneous linear parametrization substitutes three linear forms in two variables into a
polynomial in three variables.  This module allows degenerate coefficient arrays, defines the
substitution as a ring homomorphism, and applies it to a finite product of homogeneous linear
factors.  A rank-two array gives the usual parametrization of a projective line.

If the restricted factors admit a pairing with proportional members, their product is the product
of the proportionality scalars times a square.  Equal paired factors are the unit-scalar case; a
square aggregate scalar gives an explicitly corrected square root.  This is the algebraic
restriction mechanism used by square-root carriers.  Over a perfect coefficient ring of exponent
characteristic two, Frobenius surjectivity makes the aggregate scalar automatically a square.  A
separate descent theorem states the exact remaining extension condition: linewise roots must be
restrictions of one ambient polynomial, and the family of restriction maps must jointly detect
ambient polynomials.

No projective incidence theorem is asserted here.  In particular, the module does not construct a
pairing from secants, prove that a chosen family of line parametrizations jointly detects forms of
a bounded degree, or interpolate compatible linewise roots.
-/

namespace RelativeConicArcs

open scoped BigOperators

section HomogeneousRestriction

variable {K σ : Type*} [CommSemiring K] [Fintype σ] [DecidableEq σ]

/-- The homogeneous linear polynomial with coefficient vector `a`. -/
noncomputable def homogeneousLinearPolynomial (a : σ → K) : MvPolynomial σ K :=
  ∑ i, MvPolynomial.C (a i) * MvPolynomial.X i

/-- Substitution from three homogeneous coordinates to two homogeneous line coordinates.
The array `lineCoordinates i j` is the coefficient of line variable `j` in plane coordinate
`i`; no rank condition is imposed. -/
noncomputable def planeLineRestriction (lineCoordinates : Fin 3 → Fin 2 → K) :
    MvPolynomial (Fin 3) K →+* MvPolynomial (Fin 2) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    (fun i => homogeneousLinearPolynomial (lineCoordinates i))

/-- Restriction sends each plane coordinate to its prescribed homogeneous linear form. -/
@[simp]
theorem planeLineRestriction_X
    (lineCoordinates : Fin 3 → Fin 2 → K) (i : Fin 3) :
    planeLineRestriction lineCoordinates (MvPolynomial.X i) =
      homogeneousLinearPolynomial (lineCoordinates i) := by
  simp [planeLineRestriction]

omit [DecidableEq σ] in
/-- Scaling a coefficient vector scales its homogeneous linear polynomial by the corresponding
constant polynomial. -/
theorem homogeneousLinearPolynomial_scale
    (s : K) (a : σ → K) :
    homogeneousLinearPolynomial (fun i => s * a i) =
      MvPolynomial.C s * homogeneousLinearPolynomial a := by
  simp only [homogeneousLinearPolynomial, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  simp [mul_assoc]

/-- Homogeneous line substitution preserves the scalar change caused by rescaling a linear-factor
representative. -/
theorem planeLineRestriction_homogeneousLinearPolynomial_scale
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (s : K) (a : Fin 3 → K) :
    planeLineRestriction lineCoordinates
        (homogeneousLinearPolynomial (fun i => s * a i)) =
      MvPolynomial.C s *
        planeLineRestriction lineCoordinates (homogeneousLinearPolynomial a) := by
  rw [homogeneousLinearPolynomial_scale, map_mul]
  simp [planeLineRestriction]

/-- The finite product of homogeneous plane-linear factors represented by their coefficient
vectors. -/
noncomputable def dualLinearFactorProduct
    {ι : Type*} [Fintype ι] (covector : ι → Fin 3 → K) :
    MvPolynomial (Fin 3) K :=
  ∏ i, homogeneousLinearPolynomial (covector i)

/-- Restriction of a finite linear-factor product is the product of the restricted factors. -/
theorem planeLineRestriction_dualLinearFactorProduct
    {ι : Type*} [Fintype ι]
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K) :
    planeLineRestriction lineCoordinates (dualLinearFactorProduct covector) =
      ∏ i, planeLineRestriction lineCoordinates
        (homogeneousLinearPolynomial (covector i)) := by
  simp [dualLinearFactorProduct]

end HomogeneousRestriction

section BinaryLinearFactors

variable {K : Type*} [Field K]

/-- The determinant of two coefficient vectors for homogeneous binary linear forms. -/
def binaryLinearCoefficientDeterminant (a b : Fin 2 → K) : K :=
  a 0 * b 1 - a 1 * b 0

/-- Two nonzero homogeneous binary linear forms with zero coefficient determinant are related by
a nonzero scalar at the level of coefficient vectors. -/
theorem exists_ne_zero_scale_binaryCoefficients_of_determinant_eq_zero
    {a b : Fin 2 → K} (ha : a ≠ 0) (hb : b ≠ 0)
    (hdet : binaryLinearCoefficientDeterminant a b = 0) :
    ∃ c : K, c ≠ 0 ∧ b = fun i => c * a i := by
  have hcross : a 0 * b 1 = a 1 * b 0 := by
    simpa [binaryLinearCoefficientDeterminant, sub_eq_zero] using hdet
  by_cases ha0 : a 0 = 0
  · have ha1 : a 1 ≠ 0 := by
      intro ha1
      apply ha
      funext i
      fin_cases i
      · exact ha0
      · exact ha1
    have hb0 : b 0 = 0 := by
      apply (mul_left_cancel₀ ha1)
      simpa [ha0] using hcross.symm
    have heq : b = fun i => (b 1 / a 1) * a i := by
      funext i
      fin_cases i
      · simp [ha0, hb0]
      · exact (div_mul_cancel₀ (b 1) ha1).symm
    refine ⟨b 1 / a 1, ?_, heq⟩
    intro hc
    apply hb
    rw [heq, hc]
    funext i
    simp
  · have heq : b = fun i => (b 0 / a 0) * a i := by
      funext i
      fin_cases i
      · exact (div_mul_cancel₀ (b 0) ha0).symm
      · apply (mul_left_cancel₀ ha0)
        calc
          a 0 * b 1 = a 1 * b 0 := hcross
          _ = a 0 * ((b 0 / a 0) * a 1) := by
            field_simp [ha0]
    refine ⟨b 0 / a 0, ?_, heq⟩
    · intro hc
      apply hb
      rw [heq, hc]
      funext i
      simp

/-- Zero determinant for two nonzero binary coefficient vectors makes their homogeneous linear
polynomials proportional by a nonzero constant. -/
theorem exists_ne_zero_scale_homogeneousLinearPolynomial_of_binary_determinant_eq_zero
    {a b : Fin 2 → K} (ha : a ≠ 0) (hb : b ≠ 0)
    (hdet : binaryLinearCoefficientDeterminant a b = 0) :
    ∃ c : K, c ≠ 0 ∧
      homogeneousLinearPolynomial b =
        MvPolynomial.C c * homogeneousLinearPolynomial a := by
  obtain ⟨c, hc, rfl⟩ :=
    exists_ne_zero_scale_binaryCoefficients_of_determinant_eq_zero ha hb hdet
  exact ⟨c, hc, homogeneousLinearPolynomial_scale c a⟩

end BinaryLinearFactors

section PairedProducts

variable {R ι J : Type*} [CommMonoid R] [Fintype ι] [Fintype J]

/-- If a finite product is indexed by two copies of the same type and corresponding factors agree,
then the product is the square of the product over either copy. -/
theorem prod_eq_sq_of_equiv_sum
    (pairing : ι ≃ J ⊕ J) (factor : ι → R)
    (hpair :
      ∀ j, factor (pairing.symm (Sum.inl j)) =
        factor (pairing.symm (Sum.inr j))) :
    ∏ i, factor i =
      (∏ j, factor (pairing.symm (Sum.inl j))) ^ 2 := by
  calc
    ∏ i, factor i =
        ∏ s : J ⊕ J, factor (pairing.symm s) := by
      apply Fintype.prod_equiv pairing
      intro i
      simp
    _ = (∏ j, factor (pairing.symm (Sum.inl j))) *
        ∏ j, factor (pairing.symm (Sum.inr j)) :=
      Fintype.prod_sum_type _
    _ = (∏ j, factor (pairing.symm (Sum.inl j))) *
        ∏ j, factor (pairing.symm (Sum.inl j)) := by
      congr 1
      apply Fintype.prod_congr
      intro j
      exact (hpair j).symm
    _ = (∏ j, factor (pairing.symm (Sum.inl j))) ^ 2 := by
      rw [pow_two]

/-- If corresponding factors differ by prescribed scalars, their product is the scalar product
times the square of the product over the left half. -/
theorem prod_eq_scaleProduct_mul_sq_of_equiv_sum
    (pairing : ι ≃ J ⊕ J) (factor : ι → R) (scale : J → R)
    (hpair :
      ∀ j, factor (pairing.symm (Sum.inr j)) =
        scale j * factor (pairing.symm (Sum.inl j))) :
    ∏ i, factor i =
      (∏ j, scale j) *
        (∏ j, factor (pairing.symm (Sum.inl j))) ^ 2 := by
  calc
    ∏ i, factor i =
        ∏ s : J ⊕ J, factor (pairing.symm s) := by
      apply Fintype.prod_equiv pairing
      intro i
      simp
    _ = (∏ j, factor (pairing.symm (Sum.inl j))) *
        ∏ j, factor (pairing.symm (Sum.inr j)) :=
      Fintype.prod_sum_type _
    _ = (∏ j, factor (pairing.symm (Sum.inl j))) *
        ∏ j, scale j * factor (pairing.symm (Sum.inl j)) := by
      congr 1
      apply Fintype.prod_congr
      exact hpair
    _ = (∏ j, factor (pairing.symm (Sum.inl j))) *
        ((∏ j, scale j) * ∏ j, factor (pairing.symm (Sum.inl j))) := by
      rw [Finset.prod_mul_distrib]
    _ = (∏ j, scale j) *
        (∏ j, factor (pairing.symm (Sum.inl j))) ^ 2 := by
      rw [pow_two]
      ac_rfl

/-- If the product of the proportionality scalars is itself a square, the paired product has an
explicit square root corrected by that scalar root. -/
theorem prod_eq_sq_of_equiv_sum_of_scaleProduct_sq
    (pairing : ι ≃ J ⊕ J) (factor : ι → R) (scale : J → R)
    (hpair :
      ∀ j, factor (pairing.symm (Sum.inr j)) =
        scale j * factor (pairing.symm (Sum.inl j)))
    (scaleRoot : R) (hscale : ∏ j, scale j = scaleRoot ^ 2) :
    ∏ i, factor i =
      (scaleRoot * ∏ j, factor (pairing.symm (Sum.inl j))) ^ 2 := by
  rw [prod_eq_scaleProduct_mul_sq_of_equiv_sum pairing factor scale hpair,
    hscale, mul_pow]

end PairedProducts

section PairedChowRestriction

variable {K ι J : Type*} [CommSemiring K] [Fintype ι] [Fintype J]

/-- A pairing of equal restricted linear factors makes the restricted factor product a square,
with the product over the left half as an explicit root. -/
theorem planeLineRestriction_dualLinearFactorProduct_eq_sq_of_pairing
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K)
    (pairing : ι ≃ J ⊕ J)
    (hpair :
      ∀ j,
        planeLineRestriction lineCoordinates
            (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inl j)))) =
          planeLineRestriction lineCoordinates
            (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inr j))))) :
    planeLineRestriction lineCoordinates (dualLinearFactorProduct covector) =
      (∏ j, planeLineRestriction lineCoordinates
        (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inl j))))) ^ 2 := by
  rw [planeLineRestriction_dualLinearFactorProduct]
  exact prod_eq_sq_of_equiv_sum pairing _ hpair

/-- Proportional restricted factor pairs give a scalar multiple of a square.  The scalar is the
product of the pairwise proportionality constants. -/
theorem planeLineRestriction_dualLinearFactorProduct_eq_scaleProduct_mul_sq_of_pairing
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K)
    (pairing : ι ≃ J ⊕ J) (scale : J → K)
    (hpair :
      ∀ j,
        planeLineRestriction lineCoordinates
            (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inr j)))) =
          MvPolynomial.C (scale j) *
            planeLineRestriction lineCoordinates
              (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inl j))))) :
    planeLineRestriction lineCoordinates (dualLinearFactorProduct covector) =
      MvPolynomial.C (∏ j, scale j) *
        (∏ j, planeLineRestriction lineCoordinates
          (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inl j))))) ^ 2 := by
  rw [planeLineRestriction_dualLinearFactorProduct]
  calc
    ∏ i, planeLineRestriction lineCoordinates
        (homogeneousLinearPolynomial (covector i)) =
        (∏ j, MvPolynomial.C (scale j)) *
          (∏ j, planeLineRestriction lineCoordinates
            (homogeneousLinearPolynomial
              (covector (pairing.symm (Sum.inl j))))) ^ 2 :=
      prod_eq_scaleProduct_mul_sq_of_equiv_sum
        pairing _ (fun j => MvPolynomial.C (scale j)) hpair
    _ = MvPolynomial.C (∏ j, scale j) *
          (∏ j, planeLineRestriction lineCoordinates
            (homogeneousLinearPolynomial
              (covector (pairing.symm (Sum.inl j))))) ^ 2 := by
      rw [map_prod]

/-- If the aggregate proportionality scalar is a square, proportional restricted factor pairs
still give an explicit square root of the restricted factor product. -/
theorem planeLineRestriction_dualLinearFactorProduct_eq_sq_of_proportionalPairing
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K)
    (pairing : ι ≃ J ⊕ J) (scale : J → K)
    (hpair :
      ∀ j,
        planeLineRestriction lineCoordinates
            (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inr j)))) =
          MvPolynomial.C (scale j) *
            planeLineRestriction lineCoordinates
              (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inl j)))))
    (scaleRoot : K)
    (hscale : ∏ j, scale j = scaleRoot ^ 2) :
    planeLineRestriction lineCoordinates (dualLinearFactorProduct covector) =
      (MvPolynomial.C scaleRoot * ∏ j, planeLineRestriction lineCoordinates
        (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inl j))))) ^ 2 := by
  rw [planeLineRestriction_dualLinearFactorProduct]
  apply prod_eq_sq_of_equiv_sum_of_scaleProduct_sq
    pairing _ (fun j => MvPolynomial.C (scale j)) hpair
      (MvPolynomial.C scaleRoot)
  rw [← map_prod, hscale, map_pow]

end PairedChowRestriction

section PerfectCoefficientFrobenius

variable {K ι J : Type*} [CommRing K] [ExpChar K 2] [PerfectRing K 2]
  [Fintype ι] [Fintype J]

/-- Over a perfect coefficient ring of exponent characteristic two, the aggregate scalar in a
proportional factor pairing is automatically a square.  Hence the restricted factor product has
an explicit square root after choosing the Frobenius preimage of that scalar. -/
theorem exists_planeLineRestriction_dualLinearFactorProduct_eq_sq_of_proportionalPairing
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K)
    (pairing : ι ≃ J ⊕ J) (scale : J → K)
    (hpair :
      ∀ j,
        planeLineRestriction lineCoordinates
            (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inr j)))) =
          MvPolynomial.C (scale j) *
            planeLineRestriction lineCoordinates
              (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inl j))))) :
    ∃ root : MvPolynomial (Fin 2) K,
      planeLineRestriction lineCoordinates (dualLinearFactorProduct covector) =
        root ^ 2 := by
  obtain ⟨scaleRoot, hscaleRoot⟩ :=
    surjective_frobenius K 2 (∏ j, scale j)
  refine ⟨MvPolynomial.C scaleRoot *
    ∏ j, planeLineRestriction lineCoordinates
      (homogeneousLinearPolynomial (covector (pairing.symm (Sum.inl j)))), ?_⟩
  apply planeLineRestriction_dualLinearFactorProduct_eq_sq_of_proportionalPairing
    lineCoordinates covector pairing scale hpair scaleRoot
  change ∏ j, scale j = scaleRoot ^ 2
  exact hscaleRoot.symm

end PerfectCoefficientFrobenius

section SquareRootDescent

variable {A B Λ : Type*} [CommSemiring A] [CommSemiring B]

/-- A family of restriction maps jointly detects ambient polynomials when equality of all
restrictions implies ambient equality. -/
def RestrictionFamily.JointlyDetects
    (restriction : Λ → A →+* B) : Prop :=
  Function.Injective fun F lineIndex => restriction lineIndex F

/-- A global square root restricts to a square root along every member of a restriction family. -/
theorem globalSquareRoot_restricts
    (restriction : Λ → A →+* B) {F G : A} (hFG : F = G ^ 2)
    (lineIndex : Λ) :
    restriction lineIndex F = (restriction lineIndex G) ^ 2 := by
  rw [hFG, map_pow]

/-- Compatible linewise roots descend to an ambient square when they extend to one ambient
polynomial and the restriction family jointly detects ambient polynomials. -/
theorem exists_globalSquareRoot_of_jointlyDetected_extendedRoots
    (restriction : Λ → A →+* B)
    (hdetect : RestrictionFamily.JointlyDetects restriction)
    (F : A) (root : Λ → B)
    (hsquare : ∀ lineIndex, restriction lineIndex F = (root lineIndex) ^ 2)
    (hextend : ∃ G : A, ∀ lineIndex, restriction lineIndex G = root lineIndex) :
    ∃ G : A, F = G ^ 2 := by
  obtain ⟨G, hG⟩ := hextend
  refine ⟨G, hdetect ?_⟩
  funext lineIndex
  change restriction lineIndex F = restriction lineIndex (G ^ 2)
  rw [map_pow, hG lineIndex]
  exact hsquare lineIndex

end SquareRootDescent

section CharacteristicTwoFrobeniusDescent

variable {A B Λ : Type*} [CommSemiring A] [CommSemiring B] [ExpChar A 2]

/-- Membership in the image of the characteristic-two Frobenius endomorphism `G ↦ G²`. -/
def IsInSquareFrobeniusImage (F : A) : Prop :=
  ∃ G : A, F = frobenius A 2 G

/-- The square-root descent criterion places the ambient polynomial in the image of Frobenius
when the ambient semiring has exponent characteristic two. -/
theorem isInSquareFrobeniusImage_of_jointlyDetected_extendedRoots
    (restriction : Λ → A →+* B)
    (hdetect : RestrictionFamily.JointlyDetects restriction)
    (F : A) (root : Λ → B)
    (hsquare : ∀ lineIndex, restriction lineIndex F = (root lineIndex) ^ 2)
    (hextend : ∃ G : A, ∀ lineIndex, restriction lineIndex G = root lineIndex) :
    IsInSquareFrobeniusImage F := by
  obtain ⟨G, hG⟩ :=
    exists_globalSquareRoot_of_jointlyDetected_extendedRoots
      restriction hdetect F root hsquare hextend
  refine ⟨G, ?_⟩
  change F = G ^ 2
  exact hG

end CharacteristicTwoFrobeniusDescent

end RelativeConicArcs
