import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Algebra.Polynomial.Homogenize
import Mathlib.Algebra.CharP.Lemmas
import Mathlib.Algebra.CharP.Reduced
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

For a fixed line parametrization, the module computes restricted binary coefficients, identifies
their evaluation at `[t : 1]` with incidence at the corresponding plane point, derives injectivity
of assigned affine parameters from pairwise avoidance, and chooses the nonzero scalars relating an
incident family of restricted equations to its homogenized affine-node factors.  For a
nontrivially indexed family, pairwise avoidance also proves that the restricted equations are
nonzero.  Equality of squared polynomial-root values forces equality of their values over a
characteristic-two field.

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

/-- Evaluating a degree-`degree` homogeneous polynomial at a scalar multiple of a point multiplies
its value by the `degree`-th power of that scalar. -/
theorem MvPolynomial.IsHomogeneous.eval_smul_point
    {F : MvPolynomial σ K} {degree : ℕ}
    (hF : F.IsHomogeneous degree) (scale : K) (point : σ → K) :
    MvPolynomial.eval (fun i => scale * point i) F =
      scale ^ degree * MvPolynomial.eval point F := by
  rw [MvPolynomial.eval_eq', MvPolynomial.eval_eq']
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro monomial hmonomial
  have hdegree : ∑ i, monomial i = degree := by
    simpa [Finsupp.weight_apply, Finsupp.sum_fintype] using
      hF (MvPolynomial.mem_support_iff.mp hmonomial)
  simp only [mul_pow]
  rw [Finset.prod_mul_distrib,
    Finset.prod_pow_eq_pow_sum Finset.univ monomial scale, hdegree]
  ring

/-- Substitution from three homogeneous coordinates to two homogeneous line coordinates.
The array `lineCoordinates i j` is the coefficient of line variable `j` in plane coordinate
`i`; no rank condition is imposed. -/
noncomputable def planeLineRestriction (lineCoordinates : Fin 3 → Fin 2 → K) :
    MvPolynomial (Fin 3) K →+* MvPolynomial (Fin 2) K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    (fun i => homogeneousLinearPolynomial (lineCoordinates i))

/-- Coefficients of the binary linear form obtained by restricting a plane-linear covector along
a homogeneous parametrization of a projective line. -/
noncomputable def planeLineRestrictedCoefficients
    (lineCoordinates : Fin 3 → Fin 2 → K) (covector : Fin 3 → K) :
    Fin 2 → K :=
  fun j => ∑ i, covector i * lineCoordinates i j

/-- The plane vector obtained from homogeneous binary coordinates under a line parametrization. -/
def pointOnParametrizedPlaneLine
    (lineCoordinates : Fin 3 → Fin 2 → K) (point : Fin 2 → K) :
    Fin 3 → K :=
  fun i => ∑ j, lineCoordinates i j * point j

/-- The point of a parametrized projective line represented by the affine binary coordinates
`[t : 1]`.  No nondegeneracy condition is imposed on the parametrization. -/
def affinePointOnParametrizedPlaneLine
    (lineCoordinates : Fin 3 → Fin 2 → K) (t : K) :
    Fin 3 → K :=
  pointOnParametrizedPlaneLine lineCoordinates ![t, 1]

/-- Restriction sends each plane coordinate to its prescribed homogeneous linear form. -/
@[simp]
theorem planeLineRestriction_X
    (lineCoordinates : Fin 3 → Fin 2 → K) (i : Fin 3) :
    planeLineRestriction lineCoordinates (MvPolynomial.X i) =
      homogeneousLinearPolynomial (lineCoordinates i) := by
  simp [planeLineRestriction]

/-- Restricting a plane-linear covector gives the binary linear form whose coefficients are the
matrix product of the covector with the line parametrization. -/
theorem planeLineRestriction_homogeneousLinearPolynomial
    (lineCoordinates : Fin 3 → Fin 2 → K) (covector : Fin 3 → K) :
    planeLineRestriction lineCoordinates (homogeneousLinearPolynomial covector) =
      homogeneousLinearPolynomial
        (planeLineRestrictedCoefficients lineCoordinates covector) := by
  simp [planeLineRestriction, homogeneousLinearPolynomial,
    planeLineRestrictedCoefficients, Finset.sum_mul, Finset.sum_comm,
    mul_add, mul_assoc]

/-- Evaluation after restricting a plane polynomial to a parametrized line equals evaluation of
the original polynomial at the corresponding plane vector. -/
theorem eval_planeLineRestriction
    (lineCoordinates : Fin 3 → Fin 2 → K) (point : Fin 2 → K)
    (F : MvPolynomial (Fin 3) K) :
    MvPolynomial.eval point (planeLineRestriction lineCoordinates F) =
      MvPolynomial.eval (pointOnParametrizedPlaneLine lineCoordinates point) F := by
  let left : MvPolynomial (Fin 3) K →+* K :=
    (MvPolynomial.eval point).comp (planeLineRestriction lineCoordinates)
  let right : MvPolynomial (Fin 3) K →+* K :=
    MvPolynomial.eval (pointOnParametrizedPlaneLine lineCoordinates point)
  have heq : left = right := by
    apply MvPolynomial.ringHom_ext
    · intro c
      simp [left, right, planeLineRestriction]
    · intro i
      simp [left, right, planeLineRestriction, pointOnParametrizedPlaneLine,
        homogeneousLinearPolynomial]
  exact RingHom.congr_fun heq F

/-- Evaluating the restricted binary coefficient vector at `[t : 1]` equals evaluating the
original plane-linear covector at the corresponding parametrized point. -/
theorem planeLineRestrictedCoefficients_affinePoint
    (lineCoordinates : Fin 3 → Fin 2 → K) (covector : Fin 3 → K) (t : K) :
    planeLineRestrictedCoefficients lineCoordinates covector 0 * t +
        planeLineRestrictedCoefficients lineCoordinates covector 1 =
      ∑ i, covector i * affinePointOnParametrizedPlaneLine lineCoordinates t i := by
  simp [planeLineRestrictedCoefficients, affinePointOnParametrizedPlaneLine,
    pointOnParametrizedPlaneLine, Finset.sum_mul, mul_add, mul_assoc]
  rw [Finset.sum_add_distrib]

/-- A plane-linear equation whose value is nonzero at one affine point of a parametrized line has
a nonzero restricted binary coefficient vector. -/
theorem planeLineRestrictedCoefficients_ne_zero_of_affinePoint_ne_zero
    (lineCoordinates : Fin 3 → Fin 2 → K) (covector : Fin 3 → K) (t : K)
    (hne :
      ∑ i, covector i *
        affinePointOnParametrizedPlaneLine lineCoordinates t i ≠ 0) :
    planeLineRestrictedCoefficients lineCoordinates covector ≠ 0 := by
  intro hzero
  apply hne
  rw [← planeLineRestrictedCoefficients_affinePoint]
  simp [hzero]

/-- If each indexed plane line contains its assigned affine point on a parametrized carrier line,
and every differently indexed plane line avoids that point, then the affine parameters are
injective. -/
theorem injective_affineNode_of_pairwise_avoids_incidentPoint
    {ι : Type*} (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K) (node : ι → K)
    (hincident :
      ∀ i, ∑ k, covector i k *
        affinePointOnParametrizedPlaneLine lineCoordinates (node i) k = 0)
    (havoid :
      ∀ i j, i ≠ j → ∑ k, covector j k *
        affinePointOnParametrizedPlaneLine lineCoordinates (node i) k ≠ 0) :
    Function.Injective node := by
  intro i j hij
  by_contra hne
  apply havoid i j hne
  rw [hij]
  exact hincident j

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

/-- Rescaling every linear-factor representative multiplies their product by the product of the
scalars. -/
theorem dualLinearFactorProduct_rescale
    {ι : Type*} [Fintype ι]
    (scale : ι → K) (covector : ι → Fin 3 → K) :
    dualLinearFactorProduct (fun i j => scale i * covector i j) =
      MvPolynomial.C (∏ i, scale i) * dualLinearFactorProduct covector := by
  simp [dualLinearFactorProduct, homogeneousLinearPolynomial_scale,
    Finset.prod_mul_distrib]

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

/-- A nonzero binary coefficient vector defines a nonzero homogeneous linear polynomial. -/
theorem homogeneousLinearPolynomial_ne_zero_of_binaryCoefficients_ne_zero
    {a : Fin 2 → K} (ha : a ≠ 0) :
    homogeneousLinearPolynomial a ≠ 0 := by
  intro hzero
  apply ha
  funext i
  fin_cases i
  · have heval := congrArg (MvPolynomial.eval ![1, 0]) hzero
    simpa [homogeneousLinearPolynomial] using heval
  · have heval := congrArg (MvPolynomial.eval ![0, 1]) hzero
    simpa [homogeneousLinearPolynomial] using heval

/-- A homogeneous binary linear polynomial is homogeneous of total degree one when its
coefficient vector is nonzero. -/
theorem homogeneousLinearPolynomial_totalDegree_eq_one
    {a : Fin 2 → K} (ha : a ≠ 0) :
    (homogeneousLinearPolynomial a).totalDegree = 1 := by
  apply MvPolynomial.IsHomogeneous.totalDegree
  · apply MvPolynomial.IsHomogeneous.sum
    intro i _
    exact MvPolynomial.isHomogeneous_C_mul_X (a i) i
  · exact homogeneousLinearPolynomial_ne_zero_of_binaryCoefficients_ne_zero ha

/-- The determinant of two plane covectors after restriction to a parametrized line is the
three-term Cauchy--Binet pairing of their two-coordinate minors with the line minors. -/
theorem binaryLinearCoefficientDeterminant_planeLineRestrictedCoefficients
    (lineCoordinates : Fin 3 → Fin 2 → K) (a b : Fin 3 → K) :
    binaryLinearCoefficientDeterminant
        (planeLineRestrictedCoefficients lineCoordinates a)
        (planeLineRestrictedCoefficients lineCoordinates b) =
      (a 0 * b 1 - a 1 * b 0) *
          (lineCoordinates 0 0 * lineCoordinates 1 1 -
            lineCoordinates 0 1 * lineCoordinates 1 0) +
        (a 0 * b 2 - a 2 * b 0) *
          (lineCoordinates 0 0 * lineCoordinates 2 1 -
            lineCoordinates 0 1 * lineCoordinates 2 0) +
        (a 1 * b 2 - a 2 * b 1) *
          (lineCoordinates 1 0 * lineCoordinates 2 1 -
            lineCoordinates 1 1 * lineCoordinates 2 0) := by
  simp [binaryLinearCoefficientDeterminant, planeLineRestrictedCoefficients,
    Fin.sum_univ_succ]
  ring

/-- The canonical binary representative `[a₁ : -a₀]` is a zero of the homogeneous linear form
with coefficient vector `a`. -/
theorem eval_homogeneousLinearPolynomial_canonicalProjectiveZero
    (a : Fin 2 → K) :
    MvPolynomial.eval ![a 1, -a 0] (homogeneousLinearPolynomial a) = 0 := by
  simp [homogeneousLinearPolynomial]
  ring

/-- The canonical zero of a restricted plane covector maps to a plane representative incident
with that covector. -/
theorem eval_planeCovector_pointOnParametrizedLine_canonicalRestrictedZero
    (lineCoordinates : Fin 3 → Fin 2 → K) (covector : Fin 3 → K) :
    MvPolynomial.eval
        (pointOnParametrizedPlaneLine lineCoordinates
          ![planeLineRestrictedCoefficients lineCoordinates covector 1,
            -planeLineRestrictedCoefficients lineCoordinates covector 0])
        (homogeneousLinearPolynomial covector) = 0 := by
  rw [← eval_planeLineRestriction]
  rw [planeLineRestriction_homogeneousLinearPolynomial]
  exact
    eval_homogeneousLinearPolynomial_canonicalProjectiveZero
      (planeLineRestrictedCoefficients lineCoordinates covector)

/-- Restrictions along two parametrized lines have equal values at binary representatives of the
same plane vector. -/
theorem eval_planeLineRestrictions_eq_of_pointOnParametrizedLine_eq
    (firstLine secondLine : Fin 3 → Fin 2 → K)
    (firstPoint secondPoint : Fin 2 → K)
    (F : MvPolynomial (Fin 3) K)
    (hpoint :
      pointOnParametrizedPlaneLine firstLine firstPoint =
        pointOnParametrizedPlaneLine secondLine secondPoint) :
    MvPolynomial.eval firstPoint (planeLineRestriction firstLine F) =
      MvPolynomial.eval secondPoint (planeLineRestriction secondLine F) := by
  rw [eval_planeLineRestriction, eval_planeLineRestriction, hpoint]

/-- In exponent characteristic two, square roots of two restrictions have equal values at binary
representatives of one exact shared plane vector. -/
theorem eval_eq_of_planeLineRestriction_sq_eq_at_shared_plane_representative
    [ExpChar K 2]
    (firstLine secondLine : Fin 3 → Fin 2 → K)
    (firstPoint secondPoint : Fin 2 → K)
    (F : MvPolynomial (Fin 3) K)
    (firstRoot secondRoot : MvPolynomial (Fin 2) K)
    (hfirst : planeLineRestriction firstLine F = firstRoot ^ 2)
    (hsecond : planeLineRestriction secondLine F = secondRoot ^ 2)
    (hpoint :
      pointOnParametrizedPlaneLine firstLine firstPoint =
        pointOnParametrizedPlaneLine secondLine secondPoint) :
    MvPolynomial.eval firstPoint firstRoot =
      MvPolynomial.eval secondPoint secondRoot := by
  apply frobenius_inj K 2
  change
    MvPolynomial.eval firstPoint firstRoot ^ 2 =
      MvPolynomial.eval secondPoint secondRoot ^ 2
  rw [← map_pow, ← hfirst, ← map_pow, ← hsecond]
  exact
    eval_planeLineRestrictions_eq_of_pointOnParametrizedLine_eq
      firstLine secondLine firstPoint secondPoint F hpoint

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

/-- The degree-one homogenization of `X - t` is the homogeneous binary linear form with
coefficient vector `(1, -t)`. -/
theorem homogenize_X_sub_C_eq_homogeneousLinearPolynomial_affineNode
    (t : K) :
    Polynomial.homogenize (Polynomial.X - Polynomial.C t) 1 =
      homogeneousLinearPolynomial ![1, -t] := by
  simp [homogeneousLinearPolynomial, sub_eq_add_neg]

/-- A nonzero homogeneous binary linear form which vanishes at the affine point `[t : 1]` is a
nonzero scalar multiple of the homogenized node factor `X - t`. -/
theorem exists_ne_zero_scale_homogeneousLinearPolynomial_eq_C_mul_homogenize_X_sub_C
    (a : Fin 2 → K) (t : K) (ha : a ≠ 0)
    (hvanish : a 0 * t + a 1 = 0) :
    ∃ c : K, c ≠ 0 ∧
      homogeneousLinearPolynomial a =
        MvPolynomial.C c *
          Polynomial.homogenize (Polynomial.X - Polynomial.C t) 1 := by
  let nodeCoefficient : Fin 2 → K := ![1, -t]
  have hnode : nodeCoefficient ≠ 0 := by
    intro hzero
    have hzero' := congrFun hzero 0
    simp [nodeCoefficient] at hzero'
  have hdet :
      binaryLinearCoefficientDeterminant nodeCoefficient a = 0 := by
    simpa [binaryLinearCoefficientDeterminant, nodeCoefficient,
      sub_eq_add_neg, mul_comm, add_comm] using hvanish
  obtain ⟨c, hc, hproportional⟩ :=
    exists_ne_zero_scale_homogeneousLinearPolynomial_of_binary_determinant_eq_zero
      hnode ha hdet
  refine ⟨c, hc, ?_⟩
  rw [hproportional,
    homogenize_X_sub_C_eq_homogeneousLinearPolynomial_affineNode]

/-- A nonzero plane-linear equation restricted to a parametrized line is a nonzero scalar multiple
of the homogenized factor at any affine parameter where the restricted equation vanishes. -/
theorem exists_ne_zero_scale_planeLineRestriction_homogeneousLinearPolynomial_eq_C_mul_homogenize_X_sub_C
    (lineCoordinates : Fin 3 → Fin 2 → K) (covector : Fin 3 → K) (t : K)
    (hne : planeLineRestrictedCoefficients lineCoordinates covector ≠ 0)
    (hvanish :
      planeLineRestrictedCoefficients lineCoordinates covector 0 * t +
        planeLineRestrictedCoefficients lineCoordinates covector 1 = 0) :
    ∃ c : K, c ≠ 0 ∧
      planeLineRestriction lineCoordinates
          (homogeneousLinearPolynomial covector) =
        MvPolynomial.C c *
          Polynomial.homogenize (Polynomial.X - Polynomial.C t) 1 := by
  rw [planeLineRestriction_homogeneousLinearPolynomial]
  exact
    exists_ne_zero_scale_homogeneousLinearPolynomial_eq_C_mul_homogenize_X_sub_C
      (planeLineRestrictedCoefficients lineCoordinates covector) t hne hvanish

/-- Concrete incidence of a plane line with the affine point `[t : 1]` on a parametrized carrier
line supplies the vanishing hypothesis needed to identify its restricted linear factor. -/
theorem exists_ne_zero_scale_planeLineRestriction_eq_C_mul_homogenize_X_sub_C_of_affinePoint
    (lineCoordinates : Fin 3 → Fin 2 → K) (covector : Fin 3 → K) (t : K)
    (hne : planeLineRestrictedCoefficients lineCoordinates covector ≠ 0)
    (hincident :
      ∑ i, covector i *
        affinePointOnParametrizedPlaneLine lineCoordinates t i = 0) :
    ∃ c : K, c ≠ 0 ∧
      planeLineRestriction lineCoordinates
          (homogeneousLinearPolynomial covector) =
        MvPolynomial.C c *
          Polynomial.homogenize (Polynomial.X - Polynomial.C t) 1 := by
  apply
    exists_ne_zero_scale_planeLineRestriction_homogeneousLinearPolynomial_eq_C_mul_homogenize_X_sub_C
      lineCoordinates covector t hne
  rw [planeLineRestrictedCoefficients_affinePoint]
  exact hincident

/-- A family of incident, nonzero restricted plane-line equations admits simultaneous nonzero
scalars identifying every member with its affine node factor. -/
theorem exists_scale_planeLineRestriction_eq_C_mul_homogenize_X_sub_C_of_affinePoints
    {ι : Type*} (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K) (node : ι → K)
    (hne :
      ∀ i, planeLineRestrictedCoefficients lineCoordinates (covector i) ≠ 0)
    (hincident :
      ∀ i, ∑ k, covector i k *
        affinePointOnParametrizedPlaneLine lineCoordinates (node i) k = 0) :
    ∃ scale : ι → K,
      (∀ i, scale i ≠ 0) ∧
      ∀ i,
        planeLineRestriction lineCoordinates
            (homogeneousLinearPolynomial (covector i)) =
          MvPolynomial.C (scale i) *
            Polynomial.homogenize
              (Polynomial.X - Polynomial.C (node i)) 1 := by
  choose scale hscale hfactor using fun i =>
    exists_ne_zero_scale_planeLineRestriction_eq_C_mul_homogenize_X_sub_C_of_affinePoint
      lineCoordinates (covector i) (node i) (hne i) (hincident i)
  exact ⟨scale, hscale, hfactor⟩

/-- For a nontrivially indexed family, incidence at assigned affine points and pairwise
avoidance together make the node parameters injective and identify every restricted equation with
its node factor up to a simultaneously chosen nonzero scalar. -/
theorem injective_affineNode_and_exists_scale_planeLineRestriction_eq_C_mul_homogenize_X_sub_C_of_pairwise_avoids
    {ι : Type*} [Nontrivial ι] (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K) (node : ι → K)
    (hincident :
      ∀ i, ∑ k, covector i k *
        affinePointOnParametrizedPlaneLine lineCoordinates (node i) k = 0)
    (havoid :
      ∀ i j, i ≠ j → ∑ k, covector j k *
        affinePointOnParametrizedPlaneLine lineCoordinates (node i) k ≠ 0) :
    Function.Injective node ∧
      ∃ scale : ι → K,
        (∀ i, scale i ≠ 0) ∧
        ∀ i,
          planeLineRestriction lineCoordinates
              (homogeneousLinearPolynomial (covector i)) =
            MvPolynomial.C (scale i) *
              Polynomial.homogenize
                (Polynomial.X - Polynomial.C (node i)) 1 := by
  have hnode :=
    injective_affineNode_of_pairwise_avoids_incidentPoint
      lineCoordinates covector node hincident havoid
  have hrestrictedNe :
      ∀ i, planeLineRestrictedCoefficients lineCoordinates (covector i) ≠ 0 := by
    intro i
    obtain ⟨j, hji⟩ := exists_ne i
    apply planeLineRestrictedCoefficients_ne_zero_of_affinePoint_ne_zero
    exact havoid j i hji
  exact ⟨hnode,
    exists_scale_planeLineRestriction_eq_C_mul_homogenize_X_sub_C_of_affinePoints
      lineCoordinates covector node hrestrictedNe hincident⟩

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

/-- Over a perfect coefficient ring of exponent characteristic two, rescaling all representatives
of a finite linear-factor product preserves the existence of a square root. -/
theorem exists_dualLinearFactorProduct_rescale_eq_sq_of_exists_eq_sq
    (scale : ι → K) (covector : ι → Fin 3 → K)
    (hsquare :
      ∃ root : MvPolynomial (Fin 3) K,
        dualLinearFactorProduct covector = root ^ 2) :
    ∃ root : MvPolynomial (Fin 3) K,
      dualLinearFactorProduct (fun i j => scale i * covector i j) =
        root ^ 2 := by
  obtain ⟨root, hroot⟩ := hsquare
  obtain ⟨scaleRoot, hscaleRoot⟩ :=
    surjective_frobenius K 2 (∏ i, scale i)
  refine ⟨MvPolynomial.C scaleRoot * root, ?_⟩
  rw [dualLinearFactorProduct_rescale, hroot]
  change MvPolynomial.C (∏ i, scale i) * root ^ 2 =
    (MvPolynomial.C scaleRoot * root) ^ 2
  rw [show ∏ i, scale i = scaleRoot ^ 2 by exact hscaleRoot.symm,
    map_pow, mul_pow]

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

section ProjectiveRepresentativeSquareClass

variable {K ι : Type*} [Field K] [ExpChar K 2] [PerfectRing K 2] [Fintype ι]

/-- Over a perfect field of exponent characteristic two, changing every projective linear-factor
representative by a nonzero scalar preserves, in both directions, whether the full factor product
is a square. -/
theorem exists_dualLinearFactorProduct_rescale_eq_sq_iff
    (scale : ι → K) (covector : ι → Fin 3 → K)
    (hscale : ∀ i, scale i ≠ 0) :
    (∃ root : MvPolynomial (Fin 3) K,
      dualLinearFactorProduct (fun i j => scale i * covector i j) =
        root ^ 2) ↔
    ∃ root : MvPolynomial (Fin 3) K,
      dualLinearFactorProduct covector = root ^ 2 := by
  constructor
  · intro hsquare
    have hback :=
      exists_dualLinearFactorProduct_rescale_eq_sq_of_exists_eq_sq
        (fun i => (scale i)⁻¹)
        (fun i j => scale i * covector i j) hsquare
    simpa [hscale, mul_assoc] using hback
  · exact
      exists_dualLinearFactorProduct_rescale_eq_sq_of_exists_eq_sq
        scale covector

end ProjectiveRepresentativeSquareClass

section CharacteristicTwoRootAgreement

variable {K σ τ : Type*} [Field K] [ExpChar K 2]

/-- In a characteristic-two field, equality of squares forces equality. -/
theorem eq_of_sq_eq_sq_expCharTwo {x y : K} (h : x ^ 2 = y ^ 2) :
    x = y := by
  apply frobenius_inj K 2
  exact h

/-- If two polynomial roots have squares with the same value at possibly different coordinate
representatives of one geometric point, then their values agree in characteristic two. -/
theorem eval_eq_of_eval_sq_eq_expCharTwo
    (leftRoot : MvPolynomial σ K) (rightRoot : MvPolynomial τ K)
    (leftPoint : σ → K) (rightPoint : τ → K)
    (hsquare :
      MvPolynomial.eval leftPoint (leftRoot ^ 2) =
        MvPolynomial.eval rightPoint (rightRoot ^ 2)) :
    MvPolynomial.eval leftPoint leftRoot =
      MvPolynomial.eval rightPoint rightRoot := by
  apply eq_of_sq_eq_sq_expCharTwo
  simpa only [map_pow] using hsquare

end CharacteristicTwoRootAgreement

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
