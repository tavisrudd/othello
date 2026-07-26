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
projective arc or a dual Chow product.
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

/-- The normal of a parametrized line restricts to the zero binary coefficient vector. -/
theorem planeLineRestrictedCoefficients_parametrizedPlaneLineNormal_eq_zero
    (lineCoordinates : Fin 3 → Fin 2 → K) :
    planeLineRestrictedCoefficients lineCoordinates
        (parametrizedPlaneLineNormal lineCoordinates) = 0 := by
  funext j
  fin_cases j <;>
    simp [planeLineRestrictedCoefficients, parametrizedPlaneLineNormal,
      Fin.sum_univ_succ] <;>
    ring

/-- If the normal of a parametrized line is a nonzero scalar multiple of `center`, the plane-linear
equation represented by `center` restricts identically to zero on that line. -/
theorem planeLineRestriction_center_eq_zero_of_normal_eq_scale
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (center : Fin 3 → K) (scale : K)
    (hnormal :
      parametrizedPlaneLineNormal lineCoordinates =
        fun i => scale * center i)
    (hscale : scale ≠ 0) :
    planeLineRestriction lineCoordinates
        (homogeneousLinearPolynomial center) = 0 := by
  rw [planeLineRestriction_homogeneousLinearPolynomial]
  have hcoeff :
      planeLineRestrictedCoefficients lineCoordinates center = 0 := by
    funext j
    apply mul_left_cancel₀ hscale
    calc
      scale * planeLineRestrictedCoefficients lineCoordinates center j =
          planeLineRestrictedCoefficients lineCoordinates
            (fun i => scale * center i) j := by
        simp [planeLineRestrictedCoefficients, Finset.mul_sum, mul_assoc]
      _ = planeLineRestrictedCoefficients lineCoordinates
            (parametrizedPlaneLineNormal lineCoordinates) j := by
        rw [← hnormal]
      _ = 0 := by
        rw [
          planeLineRestrictedCoefficients_parametrizedPlaneLineNormal_eq_zero]
        rfl
      _ = scale * 0 := by simp
  rw [hcoeff]
  simp [homogeneousLinearPolynomial]

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

/-- The homogeneous component in the degree of a homogeneous polynomial is the polynomial itself. -/
theorem MvPolynomial.IsHomogeneous.homogeneousComponent_eq_self
    {F : MvPolynomial (Fin 2) K} {degree : ℕ}
    (hF : F.IsHomogeneous degree) :
    MvPolynomial.homogeneousComponent degree F = F := by
  ext monomial
  rw [MvPolynomial.coeff_homogeneousComponent]
  by_cases hdegree : monomial.degree = degree
  · simp [hdegree]
  · simp [hdegree, hF.coeff_eq_zero hdegree]

/-- A homogeneous component in a different degree of a homogeneous polynomial vanishes. -/
theorem MvPolynomial.IsHomogeneous.homogeneousComponent_eq_zero_of_ne
    {F : MvPolynomial (Fin 2) K} {firstDegree secondDegree : ℕ}
    (hF : F.IsHomogeneous firstDegree) (hne : firstDegree ≠ secondDegree) :
    MvPolynomial.homogeneousComponent secondDegree F = 0 := by
  ext monomial
  rw [MvPolynomial.coeff_homogeneousComponent]
  by_cases hdegree : monomial.degree = secondDegree
  · have hnotFirst : monomial.degree ≠ firstDegree := by
      intro heq
      exact hne (heq.symm.trans hdegree)
    simp [hdegree, hF.coeff_eq_zero hnotFirst]
  · simp [hdegree]

/-- Homogeneous substitution commutes with extraction of every homogeneous component. -/
theorem planeLineRestriction_homogeneousComponent
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (degree : ℕ) (F : MvPolynomial (Fin 3) K) :
    planeLineRestriction lineCoordinates
        (MvPolynomial.homogeneousComponent degree F) =
      MvPolynomial.homogeneousComponent degree
        (planeLineRestriction lineCoordinates F) := by
  classical
  conv_rhs =>
    rw [← MvPolynomial.sum_homogeneousComponent F]
  rw [map_sum, map_sum]
  by_cases hdegree :
      degree ∈ Finset.range (F.totalDegree + 1)
  · rw [Finset.sum_eq_single degree]
    · exact
        (MvPolynomial.IsHomogeneous.homogeneousComponent_eq_self
          (MvPolynomial.IsHomogeneous.planeLineRestriction
            (MvPolynomial.homogeneousComponent_isHomogeneous degree F)
            lineCoordinates)).symm
    · intro other hother hne
      exact
        MvPolynomial.IsHomogeneous.homogeneousComponent_eq_zero_of_ne
          (MvPolynomial.IsHomogeneous.planeLineRestriction
            (MvPolynomial.homogeneousComponent_isHomogeneous other F)
            lineCoordinates)
          hne
    · exact fun hnotMem => (hnotMem hdegree).elim
  · have htotal : F.totalDegree < degree := by
      simpa [Finset.mem_range, Nat.lt_add_one_iff] using hdegree
    rw [MvPolynomial.homogeneousComponent_eq_zero degree F htotal, map_zero]
    symm
    apply Finset.sum_eq_zero
    intro other hother
    apply
      MvPolynomial.IsHomogeneous.homogeneousComponent_eq_zero_of_ne
        (MvPolynomial.IsHomogeneous.planeLineRestriction
          (MvPolynomial.homogeneousComponent_isHomogeneous other F)
          lineCoordinates)
    intro heq
    apply hdegree
    simpa [heq] using hother

end HomogeneousRestrictions

section CoordinateCharts

variable (K : Type*) [Field K]

/-- A homogeneous coordinate chart for one projective plane line.  The two parametrization
columns span the kernel of `center`; `coordinateFunctional` recovers binary coordinates on that
kernel and is a left inverse to the parametrization.  The normal equation records the chosen
projective representative of the line equation, and the final field records that restriction has
the expected principal kernel. -/
structure PlaneLineCoordinateChart where
  center : Fin 3 → K
  center_ne_zero : center ≠ 0
  lineCoordinates : Fin 3 → Fin 2 → K
  scale : K
  normal_eq :
    parametrizedPlaneLineNormal lineCoordinates =
      fun i => scale * center i
  scale_ne_zero : scale ≠ 0
  coordinateFunctional : Fin 2 → Fin 3 → K
  leftInverse :
    ∀ j k,
      (∑ i, coordinateFunctional j i * lineCoordinates i k) =
        if j = k then 1 else 0
  reconstruct_incident :
    ∀ point : Fin 3 → K,
      planeVectorPairing center point = 0 →
        pointOnParametrizedPlaneLine lineCoordinates
          (fun j => ∑ i, coordinateFunctional j i * point i) =
            point
  restriction_eq_zero_iff_dvd :
    ∀ F : MvPolynomial (Fin 3) K,
      planeLineRestriction lineCoordinates F = 0 ↔
        homogeneousLinearPolynomial center ∣ F

variable {K}

/-- Substituting the coordinate functionals lifts a binary polynomial to the plane. -/
noncomputable def planeLinePolynomialLift
    (chart : PlaneLineCoordinateChart K) :
    MvPolynomial (Fin 2) K →+* MvPolynomial (Fin 3) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    (fun j => homogeneousLinearPolynomial (chart.coordinateFunctional j))

/-- The polynomial lift associated with a line chart is a right inverse to line restriction. -/
theorem planeLineRestriction_planeLinePolynomialLift
    (chart : PlaneLineCoordinateChart K)
    (F : MvPolynomial (Fin 2) K) :
    planeLineRestriction chart.lineCoordinates
        (planeLinePolynomialLift chart F) = F := by
  let composition : MvPolynomial (Fin 2) K →+* MvPolynomial (Fin 2) K :=
    (planeLineRestriction chart.lineCoordinates).comp
      (planeLinePolynomialLift chart)
  have hcomposition : composition = RingHom.id _ := by
    apply MvPolynomial.ringHom_ext
    · intro c
      simp [composition, planeLinePolynomialLift, planeLineRestriction]
    · intro j
      rw [RingHom.id_apply]
      simp only [composition, RingHom.coe_comp, Function.comp_apply,
        planeLinePolynomialLift, MvPolynomial.eval₂Hom_X']
      rw [planeLineRestriction_homogeneousLinearPolynomial]
      have hcoeff :
          planeLineRestrictedCoefficients chart.lineCoordinates
              (chart.coordinateFunctional j) =
            fun k => if j = k then 1 else 0 := by
        funext k
        exact chart.leftInverse j k
      rw [hcoeff]
      fin_cases j <;> simp [homogeneousLinearPolynomial]
  exact RingHom.congr_fun hcomposition F

/-- Every binary polynomial is the restriction of a plane polynomial through a coordinate chart. -/
theorem PlaneLineCoordinateChart.planeLineRestriction_surjective
    (chart : PlaneLineCoordinateChart K) :
    Function.Surjective
      (planeLineRestriction chart.lineCoordinates :
        MvPolynomial (Fin 3) K → MvPolynomial (Fin 2) K) := by
  intro F
  exact
    ⟨planeLinePolynomialLift chart F,
      planeLineRestriction_planeLinePolynomialLift chart F⟩

/-- Every incident plane vector has an exact binary preimage in a line coordinate chart. -/
theorem PlaneLineCoordinateChart.exists_binaryPreimage
    (chart : PlaneLineCoordinateChart K)
    (point : Fin 3 → K)
    (hpoint : planeVectorPairing chart.center point = 0) :
    ∃ binaryPoint : Fin 2 → K,
      pointOnParametrizedPlaneLine chart.lineCoordinates binaryPoint =
        point :=
  ⟨fun j => ∑ i, chart.coordinateFunctional j i * point i,
    chart.reconstruct_incident point hpoint⟩

/-- A nonzero plane coefficient vector defines a nonzero homogeneous linear polynomial. -/
theorem homogeneousLinearPolynomial_ne_zero_of_planeCoefficients_ne_zero
    {a : Fin 3 → K} (ha : a ≠ 0) :
    homogeneousLinearPolynomial a ≠ 0 := by
  intro hzero
  apply ha
  funext i
  fin_cases i
  · have heval := congrArg (MvPolynomial.eval ![1, 0, 0]) hzero
    simpa [homogeneousLinearPolynomial, Fin.sum_univ_succ] using heval
  · have heval := congrArg (MvPolynomial.eval ![0, 1, 0]) hzero
    simpa [homogeneousLinearPolynomial, Fin.sum_univ_succ] using heval
  · have heval := congrArg (MvPolynomial.eval ![0, 0, 1]) hzero
    simpa [homogeneousLinearPolynomial, Fin.sum_univ_succ] using heval

/-- A nonzero homogeneous plane-linear polynomial has total degree one. -/
theorem homogeneousLinearPolynomial_plane_totalDegree_eq_one
    {a : Fin 3 → K} (ha : a ≠ 0) :
    (homogeneousLinearPolynomial a).totalDegree = 1 := by
  apply MvPolynomial.IsHomogeneous.totalDegree
  · apply MvPolynomial.IsHomogeneous.sum
    intro i _
    exact MvPolynomial.isHomogeneous_C_mul_X (a i) i
  · exact homogeneousLinearPolynomial_ne_zero_of_planeCoefficients_ne_zero ha

/-- A chart line equation and any plane-linear equation nonzero on that line are relatively
prime. -/
theorem PlaneLineCoordinateChart.lineEquation_isRelPrime_of_restricted_ne_zero
    (chart : PlaneLineCoordinateChart K)
    (other : Fin 3 → K)
    (hother :
      planeLineRestrictedCoefficients chart.lineCoordinates other ≠ 0) :
    IsRelPrime
      (homogeneousLinearPolynomial chart.center)
      (homogeneousLinearPolynomial other) := by
  apply
    (mvPolynomial_irreducible_of_totalDegree_eq_one
      (homogeneousLinearPolynomial chart.center)
      (homogeneousLinearPolynomial_plane_totalDegree_eq_one
        chart.center_ne_zero)).isRelPrime_iff_not_dvd.mpr
  rintro ⟨Q, hQ⟩
  have hrestrictedOther :
      planeLineRestriction chart.lineCoordinates
          (homogeneousLinearPolynomial other) ≠ 0 := by
    rw [planeLineRestriction_homogeneousLinearPolynomial]
    exact
      homogeneousLinearPolynomial_ne_zero_of_binaryCoefficients_ne_zero
        hother
  apply hrestrictedOther
  rw [hQ, map_mul,
    planeLineRestriction_center_eq_zero_of_normal_eq_scale
      chart.lineCoordinates chart.center chart.scale
      chart.normal_eq chart.scale_ne_zero, zero_mul]

end CoordinateCharts

section CarrierResidualDivisibility

variable {K P : Type*} [Field K] [ExpChar K 2]

/-- On a new carrier line, exact shared representatives convert the preceding root agreements
into square agreement at every canonical restricted zero.  Nonincidence and no-three-collinear
determinants then make the product of the preceding line equations divide the homogeneous
residual. -/
theorem planeLineRestriction_finsetLineProduct_dvd_root_sub_restriction
    (lineCoordinates : P → Fin 3 → Fin 2 → K)
    (center : P → Fin 3 → K)
    (ambient : MvPolynomial (Fin 3) K)
    (root : P → MvPolynomial (Fin 2) K)
    (degree : ℕ)
    (hrootHomogeneous : ∀ x, (root x).IsHomogeneous degree)
    (hsquare :
      ∀ x, planeLineRestriction (lineCoordinates x) ambient = (root x) ^ 2)
    (hlineSurjective :
      ∀ x (point : Fin 3 → K),
        planeVectorPairing (center x) point = 0 →
          ∃ binaryPoint : Fin 2 → K,
            pointOnParametrizedPlaneLine (lineCoordinates x) binaryPoint =
              point)
    (s : Finset P) (x : P) (G : MvPolynomial (Fin 3) K)
    (hGhomogeneous : G.IsHomogeneous degree)
    (hG : ∀ y ∈ s, planeLineRestriction (lineCoordinates y) G = root y)
    (hne :
      ∀ y : {y // y ∈ s},
        planeLineRestrictedCoefficients
          (lineCoordinates x) (center y.1) ≠ 0)
    (scale : K)
    (hnormal :
      parametrizedPlaneLineNormal (lineCoordinates x) =
        fun i => scale * center x i)
    (hscale : scale ≠ 0)
    (hnoncollinear :
      Pairwise fun y z : {y // y ∈ s} =>
        planeVectorDeterminant (center x) (center y.1) (center z.1) ≠ 0) :
    planeLineRestriction (lineCoordinates x)
        (∏ y ∈ s, homogeneousLinearPolynomial (center y)) ∣
      root x - planeLineRestriction (lineCoordinates x) G := by
  let restrictedCovector : {y // y ∈ s} → Fin 3 → K :=
    fun y => center y.1
  have hdet :
      Pairwise fun y z : {y // y ∈ s} =>
        binaryLinearCoefficientDeterminant
          (planeLineRestrictedCoefficients
            (lineCoordinates x) (restrictedCovector y))
          (planeLineRestrictedCoefficients
            (lineCoordinates x) (restrictedCovector z)) ≠ 0 :=
    pairwise_restrictedDeterminant_ne_zero_of_normal_eq_scale
      (lineCoordinates x) (center x) restrictedCovector scale
      hnormal hscale hnoncollinear
  have hsquareAgree :
      ∀ y : {y // y ∈ s},
        let restricted :=
          planeLineRestrictedCoefficients
            (lineCoordinates x) (restrictedCovector y)
        MvPolynomial.eval ![restricted 1, -restricted 0] ((root x) ^ 2) =
          MvPolynomial.eval ![restricted 1, -restricted 0]
            ((planeLineRestriction (lineCoordinates x) G) ^ 2) := by
    intro y
    let firstPoint : Fin 2 → K :=
      restrictedCovectorProjectiveZero (lineCoordinates x) (center y.1)
    obtain ⟨secondPoint, hpoint⟩ :=
      exists_binaryPreimage_of_restrictedCovectorProjectiveZero
        (lineCoordinates x) (lineCoordinates y.1) (center y.1)
        (hlineSurjective y.1)
    change
      MvPolynomial.eval firstPoint ((root x) ^ 2) =
        MvPolynomial.eval firstPoint
          ((planeLineRestriction (lineCoordinates x) G) ^ 2)
    calc
      MvPolynomial.eval firstPoint ((root x) ^ 2) =
          MvPolynomial.eval firstPoint
            (planeLineRestriction (lineCoordinates x) ambient) := by
        rw [hsquare x]
      _ = MvPolynomial.eval secondPoint
            (planeLineRestriction (lineCoordinates y.1) ambient) :=
        eval_planeLineRestrictions_eq_of_pointOnParametrizedLine_eq
          (lineCoordinates x) (lineCoordinates y.1)
          firstPoint secondPoint ambient hpoint.symm
      _ = MvPolynomial.eval secondPoint ((root y.1) ^ 2) := by
        rw [hsquare y.1]
      _ = MvPolynomial.eval secondPoint
            ((planeLineRestriction (lineCoordinates y.1) G) ^ 2) := by
        rw [hG y.1 y.2]
      _ = MvPolynomial.eval secondPoint
            (planeLineRestriction (lineCoordinates y.1) (G ^ 2)) := by
        simp only [map_pow]
      _ = MvPolynomial.eval firstPoint
            (planeLineRestriction (lineCoordinates x) (G ^ 2)) :=
        (eval_planeLineRestrictions_eq_of_pointOnParametrizedLine_eq
          (lineCoordinates x) (lineCoordinates y.1)
          firstPoint secondPoint (G ^ 2) hpoint.symm).symm
      _ = MvPolynomial.eval firstPoint
            ((planeLineRestriction (lineCoordinates x) G) ^ 2) := by
        rw [map_pow]
  have hdiv :=
    fintypeProd_planeLineRestrictedLinearFactors_dvd_sub_of_projectiveZero_sq_eq
      (lineCoordinates x) restrictedCovector hne hdet
      (root x) (planeLineRestriction (lineCoordinates x) G) degree
      (hrootHomogeneous x)
      (MvPolynomial.IsHomogeneous.planeLineRestriction
        hGhomogeneous (lineCoordinates x))
      hsquareAgree
  change
    (∏ y : {y // y ∈ s},
      planeLineRestriction (lineCoordinates x)
        (homogeneousLinearPolynomial (center y.1))) ∣
      root x - planeLineRestriction (lineCoordinates x) G at hdiv
  have hproduct :
      (∏ y : {y // y ∈ s},
        planeLineRestriction (lineCoordinates x)
          (homogeneousLinearPolynomial (center y.1))) =
        ∏ y ∈ s,
          planeLineRestriction (lineCoordinates x)
            (homogeneousLinearPolynomial (center y)) := by
    change
      (∏ y ∈ s.attach,
        planeLineRestriction (lineCoordinates x)
          (homogeneousLinearPolynomial (center y.1))) =
        ∏ y ∈ s,
          planeLineRestriction (lineCoordinates x)
            (homogeneousLinearPolynomial (center y))
    exact
      Finset.prod_attach s
        (fun y =>
          planeLineRestriction (lineCoordinates x)
            (homogeneousLinearPolynomial (center y)))
  rw [hproduct] at hdiv
  simpa only [map_prod] using hdiv

/-- A finite family of carrier roots has a homogeneous ambient extension when every line
restriction is surjective.  The incidence hypotheses discharge the divisibility premise: distinct
centers give nonzero restricted equations, and triples of distinct centers give nonzero plane
determinants.  Taking the required homogeneous component of each ordinary quotient-lift correction
preserves all line restrictions and the prescribed degree. -/
theorem exists_finset_homogeneous_carrierRoot_extension
    [DecidableEq P]
    (lineCoordinates : P → Fin 3 → Fin 2 → K)
    (center : P → Fin 3 → K)
    (ambient : MvPolynomial (Fin 3) K)
    (root : P → MvPolynomial (Fin 2) K)
    (degree : ℕ)
    (hrootHomogeneous : ∀ x, (root x).IsHomogeneous degree)
    (hsquare :
      ∀ x, planeLineRestriction (lineCoordinates x) ambient = (root x) ^ 2)
    (hlineSurjective :
      ∀ x (point : Fin 3 → K),
        planeVectorPairing (center x) point = 0 →
          ∃ binaryPoint : Fin 2 → K,
            pointOnParametrizedPlaneLine (lineCoordinates x) binaryPoint =
              point)
    (scale : P → K)
    (hnormal :
      ∀ x,
        parametrizedPlaneLineNormal (lineCoordinates x) =
          fun i => scale x * center x i)
    (hscale : ∀ x, scale x ≠ 0)
    (hrestrictedNonzero :
      ∀ ⦃x y⦄, x ≠ y →
        planeLineRestrictedCoefficients
          (lineCoordinates x) (center y) ≠ 0)
    (hnoncollinear :
      ∀ ⦃x y z⦄, x ≠ y → x ≠ z → y ≠ z →
        planeVectorDeterminant (center x) (center y) (center z) ≠ 0)
    (hrestrictionSurjective :
      ∀ x,
        Function.Surjective
          (planeLineRestriction (lineCoordinates x) :
            MvPolynomial (Fin 3) K → MvPolynomial (Fin 2) K)) :
    ∀ s : Finset P,
      ∃ G : MvPolynomial (Fin 3) K,
        G.IsHomogeneous degree ∧
        ∀ x ∈ s, planeLineRestriction (lineCoordinates x) G = root x := by
  intro s
  induction s using Finset.induction_on with
  | empty =>
      exact
        ⟨0, MvPolynomial.isHomogeneous_zero (Fin 3) K degree, by simp⟩
  | @insert x s hx ih =>
      obtain ⟨G, hGhomogeneous, hG⟩ := ih
      have hne :
          ∀ y : {y // y ∈ s},
            planeLineRestrictedCoefficients
              (lineCoordinates x) (center y.1) ≠ 0 := by
        intro y
        apply hrestrictedNonzero
        intro hxy
        apply hx
        exact hxy ▸ y.2
      have htriple :
          Pairwise fun y z : {y // y ∈ s} =>
            planeVectorDeterminant
              (center x) (center y.1) (center z.1) ≠ 0 := by
        intro y z hyz
        apply hnoncollinear
        · intro hxy
          apply hx
          exact hxy ▸ y.2
        · intro hxz
          apply hx
          exact hxz ▸ z.2
        · exact fun hyz' => hyz (Subtype.ext hyz')
      have hdiv :
          planeLineRestriction (lineCoordinates x)
              (∏ y ∈ s, homogeneousLinearPolynomial (center y)) ∣
            root x - planeLineRestriction (lineCoordinates x) G :=
        planeLineRestriction_finsetLineProduct_dvd_root_sub_restriction
          lineCoordinates center ambient root degree hrootHomogeneous
          hsquare hlineSurjective s x G hGhomogeneous hG hne
          (scale x) (hnormal x) (hscale x) htriple
      obtain ⟨D, hDzero, hxD⟩ :=
        exists_single_correction_of_surjective_of_residual_dvd
          (fun y => planeLineRestriction (lineCoordinates y))
          root s x G
          (∏ y ∈ s, homogeneousLinearPolynomial (center y))
          (hrestrictionSurjective x)
          (by
            intro y hy
            rw [map_prod]
            exact
              Finset.prod_eq_zero hy
                (planeLineRestriction_center_eq_zero_of_normal_eq_scale
                  (lineCoordinates y) (center y) (scale y)
                  (hnormal y) (hscale y)))
          hdiv
      let homogeneousCorrection : MvPolynomial (Fin 3) K :=
        MvPolynomial.homogeneousComponent degree D
      have hDhomogeneous :
          homogeneousCorrection.IsHomogeneous degree :=
        MvPolynomial.homogeneousComponent_isHomogeneous degree D
      have hDzero' :
          ∀ y ∈ s,
            planeLineRestriction (lineCoordinates y)
              homogeneousCorrection = 0 := by
        intro y hy
        dsimp [homogeneousCorrection]
        rw [planeLineRestriction_homogeneousComponent, hDzero y hy]
        simp
      have hresidualHomogeneous :
          (planeLineRestriction (lineCoordinates x) D).IsHomogeneous
            degree := by
        have hDrestriction :
            planeLineRestriction (lineCoordinates x) D =
              root x - planeLineRestriction (lineCoordinates x) G := by
          have hxD' := hxD
          rw [map_add] at hxD'
          rw [eq_sub_iff_add_eq]
          simpa [add_comm] using hxD'
        rw [hDrestriction]
        exact
          (hrootHomogeneous x).sub
            (MvPolynomial.IsHomogeneous.planeLineRestriction
              hGhomogeneous (lineCoordinates x))
      have hxD' :
          planeLineRestriction (lineCoordinates x)
              (G + homogeneousCorrection) = root x := by
        dsimp [homogeneousCorrection]
        rw [map_add,
          planeLineRestriction_homogeneousComponent,
          MvPolynomial.IsHomogeneous.homogeneousComponent_eq_self
            hresidualHomogeneous]
        simpa only [map_add] using hxD
      refine
        ⟨G + homogeneousCorrection,
          hGhomogeneous.add hDhomogeneous, ?_⟩
      intro y hy
      rw [Finset.mem_insert] at hy
      rcases hy with rfl | hy
      · exact hxD'
      · rw [map_add, hDzero' y hy, add_zero]
        exact hG y hy

/-- Coordinate charts discharge both exact-preimage choice and polynomial-surjectivity
hypotheses in the homogeneous carrier-root extension theorem. -/
theorem exists_finset_homogeneous_carrierRoot_extension_of_coordinateCharts
    [DecidableEq P]
    (chart : P → PlaneLineCoordinateChart K)
    (ambient : MvPolynomial (Fin 3) K)
    (root : P → MvPolynomial (Fin 2) K)
    (degree : ℕ)
    (hrootHomogeneous : ∀ x, (root x).IsHomogeneous degree)
    (hsquare :
      ∀ x,
        planeLineRestriction (chart x).lineCoordinates ambient =
          (root x) ^ 2)
    (hrestrictedNonzero :
      ∀ ⦃x y⦄, x ≠ y →
        planeLineRestrictedCoefficients
          (chart x).lineCoordinates (chart y).center ≠ 0)
    (hnoncollinear :
      ∀ ⦃x y z⦄, x ≠ y → x ≠ z → y ≠ z →
        planeVectorDeterminant
          (chart x).center (chart y).center (chart z).center ≠ 0) :
    ∀ s : Finset P,
      ∃ G : MvPolynomial (Fin 3) K,
        G.IsHomogeneous degree ∧
        ∀ x ∈ s,
          planeLineRestriction (chart x).lineCoordinates G = root x := by
  apply exists_finset_homogeneous_carrierRoot_extension
    (fun x => (chart x).lineCoordinates)
    (fun x => (chart x).center)
    ambient root degree hrootHomogeneous hsquare
    (fun x point hpoint =>
      (chart x).exists_binaryPreimage point hpoint)
    (fun x => (chart x).scale)
    (fun x => (chart x).normal_eq)
    (fun x => (chart x).scale_ne_zero)
    hrestrictedNonzero hnoncollinear
    (fun x => (chart x).planeLineRestriction_surjective)

/-- A nonsquare homogeneous plane form whose square roots are carried by a noncollinear family of
charted dual lines has at most twice the root degree many carriers. -/
theorem card_le_two_mul_degree_of_coordinateCharts_carrierRoots
    [DecidableEq P]
    (chart : P → PlaneLineCoordinateChart K)
    (ambient : MvPolynomial (Fin 3) K)
    (root : P → MvPolynomial (Fin 2) K)
    (degree : ℕ) (carrier : Finset P)
    (hambientHomogeneous : ambient.IsHomogeneous (2 * degree))
    (hrootHomogeneous : ∀ x, (root x).IsHomogeneous degree)
    (hsquare :
      ∀ x,
        planeLineRestriction (chart x).lineCoordinates ambient =
          (root x) ^ 2)
    (hrestrictedNonzero :
      ∀ ⦃x y⦄, x ≠ y →
        planeLineRestrictedCoefficients
          (chart x).lineCoordinates (chart y).center ≠ 0)
    (hnoncollinear :
      ∀ ⦃x y z⦄, x ≠ y → x ≠ z → y ≠ z →
        planeVectorDeterminant
          (chart x).center (chart y).center (chart z).center ≠ 0)
    (hnonsquare :
      ¬∃ G : MvPolynomial (Fin 3) K, ambient = G ^ 2) :
    carrier.card ≤ 2 * degree := by
  by_contra hcard
  have hlarge : 2 * degree < carrier.card := by omega
  obtain ⟨G, hGhomogeneous, hG⟩ :=
    exists_finset_homogeneous_carrierRoot_extension_of_coordinateCharts
      chart ambient root degree hrootHomogeneous hsquare
      hrestrictedNonzero hnoncollinear carrier
  have hcoprime :
      Pairwise
        (IsRelPrime on fun x : {x // x ∈ carrier} =>
          homogeneousLinearPolynomial (chart x.1).center) := by
    intro x y hxy
    apply
      (chart x.1).lineEquation_isRelPrime_of_restricted_ne_zero
        (chart y.1).center
    apply hrestrictedNonzero
    intro hxy'
    exact hxy (Subtype.ext hxy')
  have hlineNe :
      ∀ x : {x // x ∈ carrier},
        homogeneousLinearPolynomial (chart x.1).center ≠ 0 := by
    intro x
    exact
      homogeneousLinearPolynomial_ne_zero_of_planeCoefficients_ne_zero
        (chart x.1).center_ne_zero
  have hlineDegree :
      ∀ x : {x // x ∈ carrier},
        (homogeneousLinearPolynomial (chart x.1).center).totalDegree = 1 := by
    intro x
    exact
      homogeneousLinearPolynomial_plane_totalDegree_eq_one
        (chart x.1).center_ne_zero
  have hdiv :
      ∀ x : {x // x ∈ carrier},
        homogeneousLinearPolynomial (chart x.1).center ∣
          ambient - G ^ 2 := by
    intro x
    rw [← (chart x.1).restriction_eq_zero_iff_dvd]
    rw [map_sub, map_pow, hsquare x.1, hG x.1 x.2, sub_self]
  have hGsquareHomogeneous :
      (G ^ 2).IsHomogeneous (2 * degree) := by
    simpa [mul_comm] using hGhomogeneous.pow 2
  have hresidualHomogeneous :
      (ambient - G ^ 2).IsHomogeneous (2 * degree) :=
    hambientHomogeneous.sub hGsquareHomogeneous
  have hlarge' :
      2 * degree < Fintype.card {x // x ∈ carrier} := by
    simpa using hlarge
  have hzero : ambient - G ^ 2 = 0 := by
    apply eq_zero_of_pairwise_isRelPrime_dvd_of_totalDegree_lt_card
      (fun x : {x // x ∈ carrier} =>
        homogeneousLinearPolynomial (chart x.1).center)
      hcoprime hlineNe hlineDegree (ambient - G ^ 2) hdiv
    exact lt_of_le_of_lt hresidualHomogeneous.totalDegree_le hlarge'
  apply hnonsquare
  exact ⟨G, sub_eq_zero.mp hzero⟩

/-- Finite-family form of the charted carrier bound, with no hypotheses outside the indexed
carrier family. -/
theorem fintype_card_le_two_mul_degree_of_coordinateCharts_carrierRoots
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (chart : ι → PlaneLineCoordinateChart K)
    (ambient : MvPolynomial (Fin 3) K)
    (root : ι → MvPolynomial (Fin 2) K)
    (degree : ℕ)
    (hambientHomogeneous : ambient.IsHomogeneous (2 * degree))
    (hrootHomogeneous : ∀ x, (root x).IsHomogeneous degree)
    (hsquare :
      ∀ x,
        planeLineRestriction (chart x).lineCoordinates ambient =
          (root x) ^ 2)
    (hrestrictedNonzero :
      ∀ ⦃x y⦄, x ≠ y →
        planeLineRestrictedCoefficients
          (chart x).lineCoordinates (chart y).center ≠ 0)
    (hnoncollinear :
      ∀ ⦃x y z⦄, x ≠ y → x ≠ z → y ≠ z →
        planeVectorDeterminant
          (chart x).center (chart y).center (chart z).center ≠ 0)
    (hnonsquare :
      ¬∃ G : MvPolynomial (Fin 3) K, ambient = G ^ 2) :
    Fintype.card ι ≤ 2 * degree := by
  simpa using
    card_le_two_mul_degree_of_coordinateCharts_carrierRoots
      chart ambient root degree Finset.univ hambientHomogeneous
      hrootHomogeneous hsquare hrestrictedNonzero hnoncollinear hnonsquare

end CarrierResidualDivisibility

end RelativeConicArcs
