import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.CubicPacketFromBlockReduction

/-!
# Primitive-sixth multiplicity of products with projective space

The manuscript's product formula states that for a smooth projective variety
`T` and a projective space of dimension `m`, the primitive-sixth multiplicity
of `T x P^m` is `m + 1` times that of `T`.  Its proof combines the
Gromov--Witten product formula, the numerical Novikov base change, and
compatibility of the formal decomposition with tensor products of differential
modules; none of that is constructed here, so the formula enters as an explicit
premise of every theorem below.

Two consequences are then exact deductions.  A projective space is the product
of a point with itself, and the framed monodromy of a point is involutive, so
every projective space has vanishing primitive-sixth multiplicity; the case of
dimension three is the value used for the universal triviality comparison, and
the case of dimension four is the value used by the framed-monodromy proof of
one-step irrationality.  A smooth cubic threefold has multiplicity two, so its
product with a projective line has multiplicity four.

The multiplicity two for a cubic threefold is not assumed in the second
deduction below: it is taken from the block-reduction theorem of
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.cubicPacket_sixthMultiplicity_eq_two_of_block_exponents`,
whose only premise is the passage from the exponents of the reduced small even
system to framed formal monodromy.

Lean does not construct varieties, products, projective spaces, quantum
connections, or framed monodromy, and does not prove the product formula.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

/-- Geometric signature for the product-formula corollaries: a supplied type of
varieties with the cubic-threefold predicate and framed monodromy of the
underlying packet signature, a distinguished point, the projective spaces, and
the product of a variety with a projective space. -/
structure ProjectiveProductGeometry (Variety : Type*) extends
    CubicPacketGeometry Variety where
  /-- The distinguished point object. -/
  point : Variety
  /-- The projective space of the supplied dimension. -/
  projectiveSpace : ℕ → Variety
  /-- The product of a variety with the projective space of the supplied
  dimension. -/
  productWithProjectiveSpace : Variety → ℕ → Variety

/-- External mathematical input for the product-formula corollaries.  Each
premise is stated only at the strength the deductions consume. -/
structure ProjectiveProductInput {Variety : Type*}
    (geometry : ProjectiveProductGeometry Variety) where
  /-- The product formula: multiplying a variety by a projective space of
  dimension `m` multiplies its primitive-sixth multiplicity by `m + 1`. -/
  productFormula : ∀ (base : Variety) (dimension : ℕ),
    (geometry.framedMonodromy
        (geometry.productWithProjectiveSpace base dimension)).sixthMultiplicity =
      (dimension + 1) * (geometry.framedMonodromy base).sixthMultiplicity
  /-- A projective space is the product of the point with that projective
  space. -/
  projectiveSpace_eq_pointProduct : ∀ dimension : ℕ,
    geometry.projectiveSpace dimension =
      geometry.productWithProjectiveSpace geometry.point dimension
  /-- The framed monodromy of the point is involutive.  In the manuscript it is
  the identity of the rank-one quantum connection of a point. -/
  pointMonodromyInvolutive :
    (geometry.framedMonodromy geometry.point).operator *
        (geometry.framedMonodromy geometry.point).operator = 1

variable {Variety : Type*}

/-- The point has vanishing primitive-sixth multiplicity. -/
theorem point_sixthMultiplicity_eq_zero
    (geometry : ProjectiveProductGeometry Variety)
    (input : ProjectiveProductInput geometry) :
    (geometry.framedMonodromy geometry.point).sixthMultiplicity = 0 :=
  Quantum.FramedMonodromyMatrix.sixthMultiplicity_eq_zero_of_sq_eq_one _
    input.pointMonodromyInvolutive

/-- Every projective space has vanishing primitive-sixth multiplicity.  The
value for dimension three is the one used in the universal triviality
comparison, and the value for dimension four is the one used by the
framed-monodromy proof of one-step irrationality. -/
theorem projectiveSpace_sixthMultiplicity_eq_zero
    (geometry : ProjectiveProductGeometry Variety)
    (input : ProjectiveProductInput geometry) (dimension : ℕ) :
    (geometry.framedMonodromy (geometry.projectiveSpace dimension)).sixthMultiplicity =
      0 := by
  rw [input.projectiveSpace_eq_pointProduct, input.productFormula,
    point_sixthMultiplicity_eq_zero geometry input, Nat.mul_zero]

/-- A variety of primitive-sixth multiplicity two has multiplicity four after
one product stabilization by a projective line. -/
theorem productProjectiveLine_sixthMultiplicity_eq_four
    (geometry : ProjectiveProductGeometry Variety)
    (input : ProjectiveProductInput geometry) {base : Variety}
    (packet : (geometry.framedMonodromy base).sixthMultiplicity = 2) :
    (geometry.framedMonodromy
        (geometry.productWithProjectiveSpace base 1)).sixthMultiplicity = 4 := by
  rw [input.productFormula, packet]

/-- Every smooth cubic threefold has primitive-sixth multiplicity four after one
product stabilization by a projective line.  The value two for the cubic
threefold itself is derived from the small even block reduction, so the only
premises are the product formula, the point comparison, and the passage from
the exponents of the reduced system to framed formal monodromy. -/
theorem cubicProductProjectiveLine_sixthMultiplicity_eq_four
    (geometry : ProjectiveProductGeometry Variety)
    (input : ProjectiveProductInput geometry)
    (exponentMonodromy : ∀ cubic, geometry.isSmoothCubicThreefold cubic →
      ∀ firstExponent secondExponent : ℚ,
        Quantum.cubicIndicialPolynomial =
            (Polynomial.X - Polynomial.C firstExponent) *
              (Polynomial.X - Polynomial.C secondExponent) →
          (geometry.framedMonodromy cubic).operator.charpoly =
            (Polynomial.X -
                Polynomial.C
                  (Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (firstExponent : ℂ)))) *
              (Polynomial.X -
                Polynomial.C
                  (Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (secondExponent : ℂ)))) *
                (Polynomial.X - Polynomial.C 1) ^ 2) :
    ∀ cubic, geometry.isSmoothCubicThreefold cubic →
      (geometry.framedMonodromy
          (geometry.productWithProjectiveSpace cubic 1)).sixthMultiplicity = 4 := by
  intro cubic smooth
  exact productProjectiveLine_sixthMultiplicity_eq_four geometry input
    (cubicPacket_sixthMultiplicity_eq_two_of_block_exponents
      geometry.toCubicPacketGeometry exponentMonodromy cubic smooth)

/-- The product formula for the primitive-sixth count, from the framed tensor
decomposition.  The premise is the conclusion of the manuscript's
Levelt--Turrittin computation for the product: after adjoining the root of the
projective-space Novikov variable, quantum multiplication by the first Chern
class of the projective space of dimension `m` has `m + 1` distinct eigenvalues,
each rank-one block has trivial framed regular monodromy, and tensoring a formal
factor of the base with one of them leaves the framed regular operator of the
base factor unchanged.  The framed characteristic polynomial of the product is
therefore the `(m + 1)`-st power of that of the base, and Lean concludes that the
primitive-sixth multiplicity is multiplied by `m + 1`.  The Gromov--Witten product
formula, the numerical Novikov base change, and the tensor compatibility of the
formal decomposition are not proved here. -/
theorem projectiveProduct_sixthMultiplicity_of_charpoly_power
    (base product : Quantum.FramedMonodromyMatrix) (dimension : ℕ)
    (tensorDecomposition :
      product.operator.charpoly = base.operator.charpoly ^ (dimension + 1)) :
    product.sixthMultiplicity = (dimension + 1) * base.sixthMultiplicity := by
  have nonzero : base.operator.charpoly ≠ 0 := base.operator.charpoly_monic.ne_zero
  change Quantum.sixthMultiplicityPolynomial product.operator.charpoly = _
  rw [tensorDecomposition, Quantum.sixthMultiplicityPolynomial_pow _ nonzero]
  rfl

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
