import RelativeConicArcs.PRSContraction

/-!
# Residual quadratics after consecutive contraction

For a binary quartic syndrome and a quintic coefficient vector, four consecutive Hankel
contractions determine a homogeneous residual quadratic.  Lean checks the two Hankel equations,
the discriminant identity, and the conversion of a rational point on the branch double cover into
the two residual roots.  The last conversion explicitly assumes that `2D` is nonzero; it is
therefore a statement for the separable odd-characteristic chart, not a characteristic-two
replacement.
-/

namespace RelativeConicArcs.PRSResidualQuadratic

section ResidualQuadratic

variable {R : Type*} [CommRing R]

/-- Affine coefficients of a binary quartic in increasing divided-power order. -/
@[ext] structure BinaryQuarticCoefficients (R : Type*) where
  a0 : R
  a1 : R
  a2 : R
  a3 : R
  a4 : R

/-- Affine coefficients of a quintic in increasing monomial order. -/
@[ext] structure QuinticCoefficients (R : Type*) where
  p0 : R
  p1 : R
  p2 : R
  p3 : R
  p4 : R
  p5 : R

/-- The consecutive Hankel contraction with shift `-1`. -/
def hankelNegOne (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) : R :=
  h.a1 * p.p0 + h.a2 * p.p1 + h.a3 * p.p2 + h.a4 * p.p3

/-- The consecutive Hankel contraction with shift `0`. -/
def hankelZero (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) : R :=
  h.a0 * p.p0 + h.a1 * p.p1 + h.a2 * p.p2 + h.a3 * p.p3 + h.a4 * p.p4

/-- The consecutive Hankel contraction with shift `1`. -/
def hankelOne (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) : R :=
  h.a0 * p.p1 + h.a1 * p.p2 + h.a2 * p.p3 + h.a3 * p.p4 + h.a4 * p.p5

/-- The consecutive Hankel contraction with shift `2`. -/
def hankelTwo (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) : R :=
  h.a0 * p.p2 + h.a1 * p.p3 + h.a2 * p.p4 + h.a3 * p.p5

/-- Determinant of the residual two-by-two Hankel system. -/
def determinant (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) : R :=
  hankelZero h p * hankelTwo h p - hankelOne h p ^ 2

/-- Homogeneous numerator of the sum of the two residual roots. -/
def sumNumerator (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) : R :=
  hankelNegOne h p * hankelTwo h p - hankelZero h p * hankelOne h p

/-- Homogeneous numerator of the product of the two residual roots. -/
def productNumerator (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) : R :=
  hankelNegOne h p * hankelOne h p - hankelZero h p ^ 2

/-- The homogeneous residual quadratic `D t² - Nₛ t + Nᵤ`. -/
def residualQuadratic (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) (t : R) : R :=
  determinant h p * t ^ 2 - sumNumerator h p * t + productNumerator h p

/-- Branch polynomial of the residual quadratic. -/
def branchPolynomial (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) : R :=
  sumNumerator h p ^ 2 - 4 * productNumerator h p * determinant h p

/-- The first homogeneous Hankel equation is an identity for the residual numerators. -/
theorem first_hankel_identity (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) :
    hankelZero h p * determinant h p -
        sumNumerator h p * hankelOne h p +
        productNumerator h p * hankelTwo h p = 0 := by
  simp only [determinant, sumNumerator, productNumerator]
  ring

/-- The second homogeneous Hankel equation is an identity for the residual numerators. -/
theorem second_hankel_identity (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) :
    hankelNegOne h p * determinant h p -
        sumNumerator h p * hankelZero h p +
        productNumerator h p * hankelOne h p = 0 := by
  simp only [determinant, sumNumerator, productNumerator]
  ring

/-- The displayed branch polynomial is exactly the discriminant of the homogeneous residual
quadratic. -/
theorem residual_discriminant (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R) :
    (-sumNumerator h p) ^ 2 -
        4 * determinant h p * productNumerator h p = branchPolynomial h p := by
  simp only [branchPolynomial]
  ring

end ResidualQuadratic

section ResidualQuadraticField

variable {R : Type*} [Field R]


/-- Off the determinant divisor, the residual sum and product solve both inhomogeneous Hankel
equations. -/
theorem residual_sum_product_solve_hankel (h : BinaryQuarticCoefficients R)
    (p : QuinticCoefficients R) (hD : determinant h p ≠ 0) :
    hankelZero h p -
          (sumNumerator h p / determinant h p) * hankelOne h p +
          (productNumerator h p / determinant h p) * hankelTwo h p = 0 ∧
      hankelNegOne h p -
          (sumNumerator h p / determinant h p) * hankelZero h p +
          (productNumerator h p / determinant h p) * hankelOne h p = 0 := by
  constructor
  · field_simp
    simpa using first_hankel_identity h p
  · field_simp
    simpa using second_hankel_identity h p

/-- A rational point `y² = K` on the separable branch cover yields the plus residual root. -/
theorem residual_root_add (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R)
    (y : R) (hy : y ^ 2 = branchPolynomial h p)
    (h2D : 2 * determinant h p ≠ 0) :
    residualQuadratic h p
        ((sumNumerator h p + y) / (2 * determinant h p)) = 0 := by
  have hD : determinant h p ≠ 0 := by
    intro hzero
    apply h2D
    simp [hzero]
  have htwo : (2 : R) ≠ 0 := by
    intro hzero
    apply h2D
    rw [hzero]
    simp
  rw [residualQuadratic]
  field_simp [hD, htwo]
  ring_nf
  rw [hy]
  simp only [branchPolynomial]
  ring

/-- A rational point `y² = K` on the separable branch cover yields the minus residual root. -/
theorem residual_root_sub (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R)
    (y : R) (hy : y ^ 2 = branchPolynomial h p)
    (h2D : 2 * determinant h p ≠ 0) :
    residualQuadratic h p
        ((sumNumerator h p - y) / (2 * determinant h p)) = 0 := by
  have hD : determinant h p ≠ 0 := by
    intro hzero
    apply h2D
    simp [hzero]
  have htwo : (2 : R) ≠ 0 := by
    intro hzero
    apply h2D
    rw [hzero]
    simp
  rw [residualQuadratic]
  field_simp [hD, htwo]
  ring_nf
  rw [hy]
  simp only [branchPolynomial]
  ring

/-- The two branch-cover roots have the prescribed residual sum. -/
theorem residual_roots_sum (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R)
    (y : R) (h2D : 2 * determinant h p ≠ 0) :
    (sumNumerator h p + y) / (2 * determinant h p) +
        (sumNumerator h p - y) / (2 * determinant h p) =
      sumNumerator h p / determinant h p := by
  have hD : determinant h p ≠ 0 := by
    intro hzero
    apply h2D
    simp [hzero]
  have htwo : (2 : R) ≠ 0 := by
    intro hzero
    apply h2D
    rw [hzero]
    simp
  field_simp [hD, htwo]
  ring

/-- On the branch cover, the two roots have the prescribed residual product. -/
theorem residual_roots_product (h : BinaryQuarticCoefficients R) (p : QuinticCoefficients R)
    (y : R) (hy : y ^ 2 = branchPolynomial h p)
    (h2D : 2 * determinant h p ≠ 0) :
    ((sumNumerator h p + y) / (2 * determinant h p)) *
        ((sumNumerator h p - y) / (2 * determinant h p)) =
      productNumerator h p / determinant h p := by
  have hD : determinant h p ≠ 0 := by
    intro hzero
    apply h2D
    simp [hzero]
  have htwo : (2 : R) ≠ 0 := by
    intro hzero
    apply h2D
    rw [hzero]
    simp
  field_simp [hD, htwo]
  ring_nf
  rw [hy]
  simp only [branchPolynomial]
  ring

end ResidualQuadraticField

end RelativeConicArcs.PRSResidualQuadratic
