import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Algebra.CharP.Lemmas
import Mathlib.Data.Fintype.BigOperators

/-!
# Polynomial restriction and Frobenius descent for paired linear factors

A homogeneous linear parametrization substitutes three linear forms in two variables into a
polynomial in three variables.  This module allows degenerate coefficient arrays, defines the
substitution as a ring homomorphism, and applies it to a finite product of homogeneous linear
factors.  A rank-two array gives the usual parametrization of a projective line.

If the restricted factors admit a pairing with equal members, their product is the square of the
product over either half of the pairing.  This is the algebraic restriction mechanism used by
square-root carriers.  A separate descent theorem states the exact remaining extension condition:
linewise roots must be restrictions of one ambient polynomial, and the family of restriction maps
must jointly detect ambient polynomials.

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

end PairedChowRestriction

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
