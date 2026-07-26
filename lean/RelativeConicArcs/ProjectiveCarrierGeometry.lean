import RelativeConicArcs.CarrierArcBound

/-!
# Coordinate geometry for projective square-root carriers

A plane vector `center : Fin 3 → K` represents the equation of its dual projective line.  A
homogeneous parametrization of that line is a `3 × 2` coefficient array.  Its two columns have a
cross product, called the parametrized-line normal below.  The determinant of two plane covectors
after restriction to the line is their plane determinant with this normal.

Consequently, if the normal is a nonzero scalar multiple of `center`, noncollinearity of
`center, a, b` makes the restricted equations of `a` and `b` relatively prime.  The canonical
binary zero of the restriction of a second center maps to an exact plane representative of the
intersection of the two dual lines.  Surjectivity of the second parametrization onto its line then
chooses a binary preimage of that same representative, with no transition scalar.

The final theorem applies these facts to a partial square-root interpolation.  On a new carrier
line, the product of all preceding line equations divides the residual whenever the preceding
roots already agree with one homogeneous ambient form.  The theorem assumes the stated
nonincidence and noncollinearity conditions on the plane representatives; it does not construct a
projective arc, a dual Chow product, or a degree-preserving quotient lift.
-/

namespace RelativeConicArcs

open scoped BigOperators Function

section PlaneDeterminants

variable {K : Type*} [Field K]

/-- The scalar pairing of a plane covector and a plane vector. -/
def planeVectorPairing (covector point : Fin 3 → K) : K :=
  ∑ i, covector i * point i

/-- The cross product of the two columns of a homogeneous projective-line parametrization. -/
def parametrizedPlaneLineNormal
    (lineCoordinates : Fin 3 → Fin 2 → K) : Fin 3 → K :=
  ![
    lineCoordinates 1 0 * lineCoordinates 2 1 -
      lineCoordinates 1 1 * lineCoordinates 2 0,
    -(lineCoordinates 0 0 * lineCoordinates 2 1 -
      lineCoordinates 0 1 * lineCoordinates 2 0),
    lineCoordinates 0 0 * lineCoordinates 1 1 -
      lineCoordinates 0 1 * lineCoordinates 1 0]

/-- The determinant whose rows are three plane vectors. -/
def planeVectorDeterminant
    (first second third : Fin 3 → K) : K :=
  first 0 * (second 1 * third 2 - second 2 * third 1) -
    first 1 * (second 0 * third 2 - second 2 * third 0) +
    first 2 * (second 0 * third 1 - second 1 * third 0)

/-- The restricted binary determinant is the plane determinant with the cross product of the
parametrization columns. -/
theorem binaryLinearCoefficientDeterminant_restrictions_eq_planeVectorDeterminant_normal
    (lineCoordinates : Fin 3 → Fin 2 → K) (a b : Fin 3 → K) :
    binaryLinearCoefficientDeterminant
        (planeLineRestrictedCoefficients lineCoordinates a)
        (planeLineRestrictedCoefficients lineCoordinates b) =
      planeVectorDeterminant
        (parametrizedPlaneLineNormal lineCoordinates) a b := by
  rw [binaryLinearCoefficientDeterminant_planeLineRestrictedCoefficients]
  simp [parametrizedPlaneLineNormal, planeVectorDeterminant]
  ring

/-- Scaling the first row scales a plane determinant by the same scalar. -/
theorem planeVectorDeterminant_scale_first
    (scale : K) (first second third : Fin 3 → K) :
    planeVectorDeterminant (fun i => scale * first i) second third =
      scale * planeVectorDeterminant first second third := by
  simp [planeVectorDeterminant]
  ring

/-- If a parametrized line has normal `scale * center`, noncollinearity of
`center, a, b` makes the two restricted coefficient vectors independent. -/
theorem binaryLinearCoefficientDeterminant_restrictions_ne_zero_of_normal_eq_scale
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (center a b : Fin 3 → K) (scale : K)
    (hnormal :
      parametrizedPlaneLineNormal lineCoordinates =
        fun i => scale * center i)
    (hscale : scale ≠ 0)
    (hnoncollinear : planeVectorDeterminant center a b ≠ 0) :
    binaryLinearCoefficientDeterminant
        (planeLineRestrictedCoefficients lineCoordinates a)
        (planeLineRestrictedCoefficients lineCoordinates b) ≠ 0 := by
  rw [
    binaryLinearCoefficientDeterminant_restrictions_eq_planeVectorDeterminant_normal,
    hnormal, planeVectorDeterminant_scale_first]
  exact mul_ne_zero hscale hnoncollinear

/-- Pairwise noncollinearity with one carrier center supplies the determinant hypotheses for all
restricted factors on its dual line. -/
theorem pairwise_restrictedDeterminant_ne_zero_of_normal_eq_scale
    {ι : Type*}
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (center : Fin 3 → K) (covector : ι → Fin 3 → K) (scale : K)
    (hnormal :
      parametrizedPlaneLineNormal lineCoordinates =
        fun i => scale * center i)
    (hscale : scale ≠ 0)
    (hnoncollinear :
      Pairwise fun i j =>
        planeVectorDeterminant center (covector i) (covector j) ≠ 0) :
    Pairwise fun i j =>
      binaryLinearCoefficientDeterminant
        (planeLineRestrictedCoefficients lineCoordinates (covector i))
        (planeLineRestrictedCoefficients lineCoordinates (covector j)) ≠ 0 := by
  intro i j hij
  exact
    binaryLinearCoefficientDeterminant_restrictions_ne_zero_of_normal_eq_scale
      lineCoordinates center (covector i) (covector j) scale
      hnormal hscale (hnoncollinear hij)

end PlaneDeterminants

section ExactIntersectionRepresentatives

variable {K : Type*} [Field K]

/-- The canonical binary zero of the restriction of `covector` to a parametrized line. -/
noncomputable def restrictedCovectorProjectiveZero
    (lineCoordinates : Fin 3 → Fin 2 → K) (covector : Fin 3 → K) :
    Fin 2 → K :=
  ![
    planeLineRestrictedCoefficients lineCoordinates covector 1,
    -planeLineRestrictedCoefficients lineCoordinates covector 0]

/-- The canonical restricted zero maps to a plane vector incident with the original covector. -/
theorem planeVectorPairing_pointOn_restrictedCovectorProjectiveZero
    (lineCoordinates : Fin 3 → Fin 2 → K) (covector : Fin 3 → K) :
    planeVectorPairing covector
        (pointOnParametrizedPlaneLine lineCoordinates
          (restrictedCovectorProjectiveZero lineCoordinates covector)) = 0 := by
  have hincidence :=
    eval_planeCovector_pointOnParametrizedLine_canonicalRestrictedZero
      lineCoordinates covector
  simpa [planeVectorPairing, restrictedCovectorProjectiveZero,
    homogeneousLinearPolynomial] using hincidence

/-- If a line parametrization reaches every plane vector incident with its center, the canonical
intersection representative produced on another line has an exact binary preimage. -/
theorem exists_binaryPreimage_of_restrictedCovectorProjectiveZero
    (firstLine secondLine : Fin 3 → Fin 2 → K)
    (secondCenter : Fin 3 → K)
    (hsecondSurjective :
      ∀ point : Fin 3 → K,
        planeVectorPairing secondCenter point = 0 →
          ∃ secondPoint : Fin 2 → K,
            pointOnParametrizedPlaneLine secondLine secondPoint = point) :
    ∃ secondPoint : Fin 2 → K,
      pointOnParametrizedPlaneLine secondLine secondPoint =
        pointOnParametrizedPlaneLine firstLine
          (restrictedCovectorProjectiveZero firstLine secondCenter) := by
  apply hsecondSurjective
  exact
    planeVectorPairing_pointOn_restrictedCovectorProjectiveZero
      firstLine secondCenter

end ExactIntersectionRepresentatives

section HomogeneousRestrictions

variable {K : Type*} [Field K]

/-- Homogeneous linear substitution along a projective-line parametrization preserves degree. -/
theorem MvPolynomial.IsHomogeneous.planeLineRestriction
    {F : MvPolynomial (Fin 3) K} {degree : ℕ}
    (hF : F.IsHomogeneous degree)
    (lineCoordinates : Fin 3 → Fin 2 → K) :
    (planeLineRestriction lineCoordinates F).IsHomogeneous degree := by
  change
    (MvPolynomial.eval₂ MvPolynomial.C
      (fun i => homogeneousLinearPolynomial (lineCoordinates i)) F).IsHomogeneous degree
  have hrestriction :=
    hF.eval₂ MvPolynomial.C
      (fun i => homogeneousLinearPolynomial (lineCoordinates i))
      (fun c => MvPolynomial.isHomogeneous_C (Fin 2) c)
      (fun i => by
        apply MvPolynomial.IsHomogeneous.sum
        intro j _
        exact MvPolynomial.isHomogeneous_C_mul_X (lineCoordinates i j) j)
  rw [Nat.one_mul] at hrestriction
  exact hrestriction

end HomogeneousRestrictions

end RelativeConicArcs
