import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.PaperInterface.Imports

/-!
# Framed-monodromy reviewer terminals

Framed multiplicity, numerical Novikov, and specialized low-dimensional
terminals.  Geometric and literature inputs remain explicit in the declaration
types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

open TensorProduct

open scoped MatrixGroups

/-- Exact conditional assembly of low-dimensional primitive-sixth vanishing.
The classification into nef seeds, a point, projective bundles, and point
blowups is supplied, as are the regular-singular root restriction, operation
formulas, and divisor-tagging comparison.  Lean proves the induction through
the classification and the transfer to every strictly Novikov-admissible
specialization. -/
theorem lowDimensionalVanishing_of_classification_and_specialization_inputs
    {Object : Type*}
    (geometry : Applications.LowDimensionalVanishingGeometry Object)
    (input : Applications.LowDimensionalVanishingInput geometry) :
    ∀ object, geometry.isPointCurveOrSurface object →
      ∀ specialization : geometry.Specialization object,
        geometry.isStrictlyNovikovAdmissible object specialization →
          (geometry.specializedMonodromy object
            specialization).sixthMultiplicity = 0 :=
  Applications.lowDimensionalMultiplicity_eq_zero_of_classification_and_tagging
    geometry input
/-- Conditional rank-`r` framed projective-bundle formula.  The geometric
bundle relation and the characteristic-polynomial comparison are supplied;
Lean derives the primitive-sixth multiplicity formula. -/
theorem framedProjectiveBundle_sixthMultiplicity
    {Object : Type*} (geometry : Applications.FramedOperationGeometry Object)
    (input : Applications.FramedOperationComparisonInput geometry)
    (rank : ℕ) (rankAtLeastTwo : 2 ≤ rank) (base total : Object)
    (bundle : geometry.IsProjectiveBundle rank base total) :
    (geometry.intrinsicMonodromy total).sixthMultiplicity =
      rank * (geometry.intrinsicMonodromy base).sixthMultiplicity :=
  Applications.projectiveBundle_sixthMultiplicity geometry input rank
    rankAtLeastTwo base total bundle
/-- Conditional framed blowup formula in codimension `c ≥ 2`.  The geometric
blowup relation, its `c - 1` numerical center specializations, and the
characteristic-polynomial block comparison are supplied; Lean derives the
ambient-plus-center primitive-sixth multiplicity identity. -/
theorem framedBlowup_sixthMultiplicity
    {Object : Type*} (geometry : Applications.FramedOperationGeometry Object)
    (input : Applications.FramedOperationComparisonInput geometry)
    (codim : ℕ) (codimAtLeastTwo : 2 ≤ codim)
    (center ambient total : Object)
    (blowup : geometry.IsBlowup codim center ambient total) :
    (geometry.intrinsicMonodromy total).sixthMultiplicity =
      (geometry.intrinsicMonodromy ambient).sixthMultiplicity +
        ∑ index : Fin (codim - 1),
          (geometry.specializedMonodromy center
            (input.centerSpecialization codim codimAtLeastTwo center ambient
              total blowup index)).sixthMultiplicity :=
  Applications.blowup_sixthMultiplicity geometry input codim codimAtLeastTwo
    center ambient total blowup
/-- Conditional cubic packet theorem.  A supplied characteristic-polynomial
comparison identifies the framed monodromy of every smooth cubic threefold
with the two primitive-sixth factors and two unit factors of Cai's block
description; Lean proves that its primitive-sixth multiplicity is exactly two. -/
theorem cubicPacket_sixthMultiplicity_eq_two_of_charpoly
    {Cubic : Type*} (geometry : Applications.CubicPacketGeometry Cubic)
    (charpolyComparison : ∀ cubic,
      geometry.isSmoothCubicThreefold cubic →
        (geometry.framedMonodromy cubic).operator.charpoly =
          Applications.cubicPacketCharacteristicPolynomial) :
    ∀ cubic, geometry.isSmoothCubicThreefold cubic →
      (geometry.framedMonodromy cubic).sixthMultiplicity = 2 :=
  Applications.cubicThreefold_sixthMultiplicity_eq_two_of_charpoly
    geometry charpolyComparison
/-- Conditional common-field endpoint of divisor tagging.  The final
characteristic-polynomial equalities resulting from injective tagged scalar
extension and the formal divisor bulk gauge are supplied explicitly; neither
comparison construction is represented.  Lean transfers intrinsic
primitive-sixth vanishing to every strictly Novikov-admissible specialization. -/
theorem divisorTagging_vanishing_of_comparison_inputs
    {Object : Type*} (geometry : Applications.DivisorTaggingGeometry Object)
    (input : Applications.DivisorTaggingComparisonInput geometry) :
    ∀ object, (geometry.intrinsicMonodromy object).sixthMultiplicity = 0 →
      ∀ specialization : geometry.Specialization object,
        geometry.isStrictlyNovikovAdmissible object specialization →
          (geometry.specializedMonodromy object
            specialization).sixthMultiplicity = 0 :=
  Applications.divisorTagging_vanishing geometry input
/-- The manuscript's primitive-sixth algebraic-multiplicity formula, applied
to a supplied finite framed-monodromy matrix.  Construction of that operator
from the small even quantum connection remains outside this definition. -/
noncomputable def framedSixthMultiplicity
    (monodromy : Quantum.FramedMonodromyMatrix) : ℕ :=
  monodromy.sixthMultiplicity
/-- Algebraic projective-bundle pattern: an `r`-fold power of a nonzero block
characteristic polynomial has `r` times its primitive-sixth multiplicity. -/
theorem framedSixthMultiplicity_polynomial_pow
    (polynomial : Polynomial ℂ) (nonzero : polynomial ≠ 0) (rank : ℕ) :
    Quantum.sixthMultiplicityPolynomial (polynomial ^ rank) =
      rank * Quantum.sixthMultiplicityPolynomial polynomial :=
  Quantum.sixthMultiplicityPolynomial_pow polynomial nonzero rank
/-- Algebraic blowup/direct-sum pattern: the primitive-sixth multiplicity of
a product of nonzero block characteristic polynomials is the sum of their
multiplicities. -/
theorem framedSixthMultiplicity_polynomial_list_prod
    (polynomials : List (Polynomial ℂ))
    (nonzero : ∀ polynomial ∈ polynomials, polynomial ≠ 0) :
    Quantum.sixthMultiplicityPolynomial polynomials.prod =
      (polynomials.map Quantum.sixthMultiplicityPolynomial).sum :=
  Quantum.sixthMultiplicityPolynomial_list_prod polynomials nonzero
/-- Exact terminal spectral step of low-dimensional vanishing: if every
characteristic root of the supplied framed monodromy has square one, then its
primitive-sixth multiplicity vanishes.  This theorem does not derive the root
restriction from a quantum connection or from low-dimensional geometry. -/
theorem lowDimensionalVanishing_of_characteristicRoots_sq_eq_one
    (monodromy : Quantum.FramedMonodromyMatrix)
    (rootSquare : ∀ value : ℂ, monodromy.operator.charpoly.IsRoot value →
      value ^ 2 = 1) :
    monodromy.sixthMultiplicity = 0 :=
  monodromy.sixthMultiplicity_eq_zero_of_roots_sq_eq_one rootSquare
/-- A sufficient finite-matrix special case of low-dimensional vanishing:
involutivity implies the exact characteristic-root restriction and hence zero
primitive-sixth multiplicity.  The manuscript's regular-singular argument
asserts the root restriction, not involutivity of the full monodromy matrix. -/
theorem lowDimensionalVanishing_of_involutiveFramedMonodromy
    (monodromy : Quantum.FramedMonodromyMatrix)
    (involutive : monodromy.operator * monodromy.operator = 1) :
    monodromy.sixthMultiplicity = 0 :=
  monodromy.sixthMultiplicity_eq_zero_of_sq_eq_one involutive
/-- Arithmetic core of Cai's cubic rank-two block: the displayed indicial
polynomial factors with exponents `-1/6` and `-5/6`, whose one-turn framed
monodromies are the two primitive sixth roots. -/
theorem cubicPacket_indicial_factorization_and_framed_eigenvalues :
    Quantum.cubicIndicialPolynomial =
        (Polynomial.X - Polynomial.C (-1 / 6)) *
          (Polynomial.X - Polynomial.C (-5 / 6)) ∧
      Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (-1 / 6)) =
        Quantum.primitiveSixthRootNegative ∧
      Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (-5 / 6)) =
        Quantum.primitiveSixthRootPositive :=
  ⟨Quantum.cubicIndicialPolynomial_factorization,
    Quantum.cubicExponent_neg_one_sixth,
    Quantum.cubicExponent_neg_five_sixths⟩
/-- Reviewer-facing type of strict Novikov-admissibility certificates for an
effective numerical monoid and a complete separated topological domain. -/
def strictNovikovAdmissibleData
    (Curve Target : Type*)
    [AddCommMonoid Curve] [CommRing Target] [IsDomain Target]
    [UniformSpace Target] [CompleteSpace Target] [T2Space Target]
    [IsTopologicalRing Target] : Type _ :=
  Quantum.StrictNovikovAdmissible (Curve := Curve) (Target := Target)
/-- Bounded-degree finiteness makes the homological fiber over each numerical
class a finite set, with no extra cutoff condition in its membership theorem.
-/
theorem numericalNovikov_finiteFiber_exact
    {Homology Numerical : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical]
    (data : Quantum.NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    (homological : Homology) (numerical : Numerical) :
    homological ∈ data.fiber numerical ↔
      data.quotient homological = numerical :=
  data.mem_fiber_iff homological numerical
/-- The coefficient of the numerical pushforward is the finite sum of the
homological coefficients in the exact numerical fiber. -/
theorem numericalNovikov_coefficientPushforward_apply
    {Homology Numerical R : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical] [AddCommMonoid R]
    (data : Quantum.NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    (series : Homology → R) (numerical : Numerical) :
    data.coefficientPushforward series numerical =
      ∑ degree ∈ data.fiber numerical, series degree :=
  data.coefficientPushforward_apply series numerical
/-- Finite-fiber pushforward sends a completed homological coefficient family
to a completed numerical coefficient family.  Its coefficient is the exact
finite-fiber sum, and its nonzero coefficients below every numerical degree
cutoff form a finite set.  This is a coefficient-level support statement; no
topology, multiplication, or continuity structure is represented. -/
theorem numericalNovikov_completedCoefficientPushforward_apply_and_finiteBelow
    {Homology Numerical R : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical] [AddCommGroup R]
    (data : Quantum.NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    (series : Quantum.CompletedNovikovSeries
      Homology R data.homologicalDegree)
    (numerical : Numerical) (cutoff : ℕ) :
    (data.completedCoefficientPushforward series).coefficient numerical =
        ∑ homological ∈ data.fiber numerical,
          series.coefficient homological ∧
      Set.Finite {degree |
        (data.completedCoefficientPushforward series).coefficient degree ≠ 0 ∧
          data.numericalDegree degree ≤ cutoff} :=
  ⟨data.completedCoefficientPushforward_apply series numerical,
    (data.completedCoefficientPushforward series).finite_below cutoff⟩
/-- Completed numerical coefficient pushforward is additive.  The statement
uses only pointwise addition and the finite-below support condition; it does
not assert compatibility with a convolution product. -/
theorem numericalNovikov_completedCoefficientPushforward_add
    {Homology Numerical R : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical] [AddCommGroup R]
    (data : Quantum.NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    (left right : Quantum.CompletedNovikovSeries
      Homology R data.homologicalDegree) :
    data.completedCoefficientPushforward (left + right) =
      data.completedCoefficientPushforward left +
        data.completedCoefficientPushforward right :=
  data.completedCoefficientPushforward_add left right
/-- Agreement of completed homological coefficient families through a degree
cutoff implies agreement of their numerical pushforwards through that cutoff.
This exposes the finite-level compatibility used by a continuous inverse-limit
extension, but neither a topology nor an inverse limit is part of the formal
statement. -/
theorem numericalNovikov_completedCoefficientPushforward_eq_below_of_eq_below
    {Homology Numerical R : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical] [AddCommGroup R]
    (data : Quantum.NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    (left right : Quantum.CompletedNovikovSeries
      Homology R data.homologicalDegree)
    (cutoff : ℕ)
    (equal_below : ∀ homological,
      data.homologicalDegree homological ≤ cutoff →
        left.coefficient homological = right.coefficient homological) :
    ∀ numerical, data.numericalDegree numerical ≤ cutoff →
      (data.completedCoefficientPushforward left).coefficient numerical =
        (data.completedCoefficientPushforward right).coefficient numerical :=
  data.completedCoefficientPushforward_eq_below_of_eq_below
    left right cutoff equal_below
/-- In a finite-degree effective additive monoid, the finite decomposition set
contains exactly the ordered pairs whose sum is the prescribed class. -/
theorem completedNovikov_decompositions_exact
    {Curve : Type*} [AddCommMonoid Curve]
    (grading : Quantum.FiniteDegreeAddCommMonoid Curve)
    (pair : Curve × Curve) (total : Curve) :
    pair ∈ grading.decompositions total ↔ pair.1 + pair.2 = total :=
  grading.mem_decompositions_iff pair total
/-- Finite decomposition sums define a completed coefficient family: the
coefficient is the displayed convolution sum, and the nonzero convolution
coefficients below every cutoff form a finite set.  This terminal does not
assert convolution ring laws or compatibility with numerical pushforward. -/
theorem completedNovikov_convolution_coefficient_and_finiteBelow
    {Curve Coefficient : Type*} [AddCommMonoid Curve] [CommRing Coefficient]
    (grading : Quantum.FiniteDegreeAddCommMonoid Curve)
    (left right : Quantum.CompletedNovikovSeries
      Curve Coefficient grading.degree)
    (total : Curve) (cutoff : ℕ) :
    (grading.convolution left right).coefficient total =
        ∑ pair ∈ grading.decompositions total,
          left.coefficient pair.1 * right.coefficient pair.2 ∧
      Set.Finite {curve |
        (grading.convolution left right).coefficient curve ≠ 0 ∧
          grading.degree curve ≤ cutoff} :=
  ⟨grading.convolution_coefficient left right total,
    (grading.convolution left right).finite_below cutoff⟩
/-- Finite-below completed coefficient families form a commutative ring under
finite-decomposition convolution, and finite truncation agrees coefficientwise
with ordinary additive-monoid-algebra multiplication through its cutoff. -/
theorem completedNovikov_commRing_and_truncation_mul
    {Curve Coefficient : Type*} [AddCommMonoid Curve] [CommRing Coefficient]
    (grading : Quantum.FiniteDegreeAddCommMonoid Curve)
    (left right : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
      grading Coefficient)
    (third : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
      grading Coefficient)
    (cutoff : ℕ) (total : Curve) (degree_le : grading.degree total ≤ cutoff) :
    left * right = grading.convolution left right ∧
      (left * right) * third = left * (right * third) ∧
      (1 : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
        grading Coefficient) * left = left ∧
      left * (1 : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
        grading Coefficient) = left ∧
      left * right = right * left ∧
      left * (right + third) = left * right + left * third ∧
      (left + right) * third = left * third + right * third ∧
      grading.truncation (left * right) cutoff total =
        (grading.truncation left cutoff * grading.truncation right cutoff) total :=
  ⟨rfl, mul_assoc _ _ _, one_mul _, mul_one _, mul_comm _ _,
    mul_add _ _ _, add_mul _ _ _,
    grading.truncation_convolution_apply_of_degree_le
      left right cutoff total degree_le⟩
/-- Completed coefficient families are exactly compatible systems of finite
degree truncations: reconstructing from every finite level and truncating a
reconstruction are mutually inverse.  This is a coefficientwise inverse-limit
description, not a topological or categorical completion theorem. -/
theorem completedNovikov_truncationFamily_roundTrips
    {Curve Coefficient : Type*} [AddCommMonoid Curve] [CommRing Coefficient]
    (grading : Quantum.FiniteDegreeAddCommMonoid Curve) :
    (∀ series : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
        grading Coefficient,
      (Quantum.FiniteDegreeAddCommMonoid.DegreeTruncationFamily.ofCompleted
        grading series).toCompleted = series) ∧
    (∀ family : Quantum.FiniteDegreeAddCommMonoid.DegreeTruncationFamily
        grading Coefficient,
      Quantum.FiniteDegreeAddCommMonoid.DegreeTruncationFamily.ofCompleted
        grading family.toCompleted = family) :=
  ⟨Quantum.FiniteDegreeAddCommMonoid.DegreeTruncationFamily.toCompleted_ofCompleted
      grading,
    Quantum.FiniteDegreeAddCommMonoid.DegreeTruncationFamily.ofCompleted_toCompleted
      grading⟩
/-- Numerical pushforward acts on the compatible truncation model by the
ordinary finite-level `mapDomain` map at every cutoff, and this action commutes
exactly with passage from a completed family to its truncations.  No topology
or categorical limit universal property is asserted. -/
theorem numericalNovikov_truncationFamily_pushforward
    {Homology Numerical Coefficient : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical] [CommRing Coefficient]
    (data : Quantum.CompletedNumericalQuotient Homology Numerical)
    (family : Quantum.FiniteDegreeAddCommMonoid.DegreeTruncationFamily
      data.homologicalGrading Coefficient) (cutoff : ℕ)
    (series : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading Coefficient) :
    (data.pushforwardTruncationFamily family).level cutoff =
        AddMonoidAlgebra.mapDomain data.quotient (family.level cutoff) ∧
      data.pushforwardTruncationFamily
          (Quantum.FiniteDegreeAddCommMonoid.DegreeTruncationFamily.ofCompleted
            data.homologicalGrading series) =
        Quantum.FiniteDegreeAddCommMonoid.DegreeTruncationFamily.ofCompleted
          data.numericalGrading (data.completedPushforward series) :=
  ⟨data.pushforwardTruncationFamily_level family cutoff,
    data.pushforwardTruncationFamily_ofCompleted series⟩
/-- Addition, convolution, and numerical pushforward preserve agreement through
the same degree cutoff.  Consequently numerical pushforward satisfies the
explicit cutoff-continuity predicate with identity modulus.  This terminal does
not assert Mathlib topological continuity. -/
theorem numericalNovikov_cutoffContinuity
    {Homology Numerical Coefficient : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical] [CommRing Coefficient]
    (data : Quantum.CompletedNumericalQuotient Homology Numerical)
    {cutoff : ℕ}
    {left₁ left₂ right₁ right₂ :
      Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
        data.homologicalGrading Coefficient}
    (left_agree : data.homologicalGrading.AgreeThrough cutoff left₁ left₂)
    (right_agree : data.homologicalGrading.AgreeThrough cutoff right₁ right₂) :
    data.homologicalGrading.AgreeThrough cutoff
        (left₁ + right₁) (left₂ + right₂) ∧
      data.homologicalGrading.AgreeThrough cutoff
        (data.homologicalGrading.convolution left₁ right₁)
        (data.homologicalGrading.convolution left₂ right₂) ∧
      data.numericalGrading.AgreeThrough cutoff
        (data.completedPushforward left₁) (data.completedPushforward left₂) ∧
      Quantum.FiniteDegreeAddCommMonoid.CutoffContinuous
        data.homologicalGrading data.numericalGrading
          (data.completedPushforward (R := Coefficient)) :=
  ⟨data.homologicalGrading.agreeThrough_add left_agree right_agree,
    data.homologicalGrading.agreeThrough_convolution left_agree right_agree,
    data.completedPushforward_agreeThrough left_agree,
    data.completedPushforward_cutoffContinuous⟩
/-- For a surjective finite-degree numerical quotient, the completed
finite-fiber pushforward commutes with every finite truncation and is a unital
ring homomorphism.  This theorem constructs neither a topology nor quantum or
comparison-theorem data. -/
theorem numericalNovikov_completedPushforward_ringHom_and_truncation
    {Homology Numerical R : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical] [CommRing R]
    (data : Quantum.CompletedNumericalQuotient Homology Numerical)
    (series : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading R) (cutoff : ℕ) :
    data.completedPushforwardRingHom series = data.completedPushforward series ∧
      data.numericalGrading.truncation
          (data.completedPushforward series) cutoff =
        AddMonoidAlgebra.mapDomain data.quotient
          (data.homologicalGrading.truncation series cutoff) :=
  ⟨rfl, data.truncation_completedPushforward series cutoff⟩
/-- A finite homological coefficient packet that is constant on numerical
fibers factors termwise through the numerical quotient; summation over one
fiber is its descended coefficient multiplied by the fiber cardinality.  This
is an algebraic descent criterion, not a construction or invariance proof for
Gromov--Witten coefficients. -/
theorem numericalNovikov_finiteCoefficientPacket_descends
    {Homology Numerical Coefficient : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical]
    [AddCommMonoid Coefficient]
    (data : Quantum.CompletedNumericalQuotient Homology Numerical)
    (packet : Finset Homology) (coefficient : Homology → Coefficient)
    (invariant : data.NumericallyInvariant coefficient)
    (numerical : Numerical) :
    (∑ homological ∈ packet, coefficient homological =
      ∑ homological ∈ packet,
        data.descendedCoefficient coefficient (data.quotient homological)) ∧
    (∑ homological ∈ data.coefficientData.fiber numerical,
        coefficient homological =
      (data.coefficientData.fiber numerical).card •
        data.descendedCoefficient coefficient numerical) :=
  ⟨data.finite_sum_descends packet coefficient invariant,
    data.fiber_sum_eq_card_nsmul_descendedCoefficient
      coefficient invariant numerical⟩
/-- Completed numerical pushforward commutes with every logarithmic Novikov
operator whose additive scalar weight factors through the numerical quotient.
Lean does not construct the geometric curve-pairing weight or the quantum
connection in which the operator occurs. -/
theorem numericalNovikov_logarithmicOperator_commutes_with_pushforward
    {Homology Numerical Coefficient : Type*}
    [AddCommMonoid Homology] [AddCommMonoid Numerical]
    [CommRing Coefficient]
    (data : Quantum.CompletedNumericalQuotient Homology Numerical)
    (numericalWeight : Numerical →+ Coefficient)
    (series : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading Coefficient) :
    data.completedPushforward
        (Quantum.CompletedNumericalQuotient.logarithmicOperator data.homologicalGrading
          (numericalWeight.comp data.quotient) series) =
      Quantum.CompletedNumericalQuotient.logarithmicOperator
        data.numericalGrading numericalWeight
        (data.completedPushforward series) :=
  data.completedPushforward_logarithmicOperator numericalWeight series
/-- The coefficientwise logarithmic operator associated to an additive scalar
weight is additive and satisfies the Leibniz rule for completed Novikov
convolution.  The result does not package scalar linearity over a separately
modeled coefficient subring. -/
theorem numericalNovikov_logarithmicOperator_leibniz
    {Curve Coefficient : Type*}
    [AddCommMonoid Curve] [CommRing Coefficient]
    (grading : Quantum.FiniteDegreeAddCommMonoid Curve)
    (weight : Curve →+ Coefficient)
    (left right : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
      grading Coefficient) :
    Quantum.CompletedNumericalQuotient.logarithmicOperatorAddHom grading weight
        (left + right) =
      Quantum.CompletedNumericalQuotient.logarithmicOperatorAddHom grading weight left +
        Quantum.CompletedNumericalQuotient.logarithmicOperatorAddHom grading weight right ∧
    Quantum.CompletedNumericalQuotient.logarithmicOperator grading weight
          (grading.convolution left right) =
        grading.convolution
            (Quantum.CompletedNumericalQuotient.logarithmicOperator
              grading weight left) right +
          grading.convolution left
            (Quantum.CompletedNumericalQuotient.logarithmicOperator
              grading weight right) :=
  ⟨map_add _ _ _,
    Quantum.CompletedNumericalQuotient.logarithmicOperator_convolution
      grading weight left right⟩
/-- The divisor-tag separation fragment: an injective integral tag makes the
pair of specialized monomial and tag injective even if the specialized
monomial map alone is not injective. -/
theorem strictNovikov_injective_taggedMonomial
    {Curve Target : Type*}
    [AddCommMonoid Curve] [CommRing Target] [IsDomain Target]
    [UniformSpace Target] [CompleteSpace Target] [T2Space Target]
    [IsTopologicalRing Target]
    (specialization : Quantum.StrictNovikovAdmissible
      (Curve := Curve) (Target := Target))
    {Tag : Type*} (divisorTag : Curve → Tag)
    (separates : Function.Injective divisorTag) :
    Function.Injective (fun degree ↦
      (specialization.monomialImage degree, divisorTag degree)) :=
  specialization.injective_taggedMonomial divisorTag separates
/-- Finite-support exponential-character step in divisor tagging.  For an
injective finite family of divisor-pairing vectors over an infinite
characteristic-zero field, Lean chooses one abstract `K`-linear dual
functional with distinct
scalar pairings and proves by the first `m` coefficients and a Vandermonde
determinant that the resulting `m` formal exponential characters are linearly
independent.  The functional need not be induced by the manuscript's integral
one-parameter vector.  This does not construct the lowest-valuation support of
a completed Novikov series or prove that passage to initial terms is injective. -/
theorem finiteDivisorPairing_exponentialCharacters_independent
    {K V : Type*} [Field K] [CharZero K] [Infinite K]
    [AddCommGroup V] [Module K V] {m : ℕ}
    (vector : Fin m → V) (vector_injective : Function.Injective vector) :
    ∃ functional : Module.Dual K V,
      Function.Injective (fun index ↦ functional (vector index)) ∧
      ∀ coefficient : Fin m → K,
        (∑ index, coefficient index •
          Quantum.formalExponentialCharacter
            (functional (vector index)) = 0) →
        coefficient = 0 :=
  Quantum.exists_dual_separating_formalExponentialCharacters
    vector vector_injective
/-- Integral-direction form of the finite divisor-tagging step.  For an
injective finite family of integral pairing vectors, Lean constructs an
integral direction `(1,t,t²,...)` with pairwise distinct dot products by
avoiding the finitely many integral roots of the pairwise difference
polynomials.  After casting the exponents into any characteristic-zero field,
the associated formal exponential characters are then linearly independent
by the Vandermonde theorem.  This does not construct
the finite family as the lowest-valuation support of a completed Novikov
series or prove associated-graded noncancellation. -/
theorem integralDivisorPairing_exponentialCharacters_independent
    {K : Type*} [Field K] [CharZero K]
    {m rank : ℕ} (vector : Fin m → Fin rank → ℤ)
    (vector_injective : Function.Injective vector) :
    ∃ direction : Fin rank → ℤ,
      Function.Injective
        (fun index ↦ ∑ coordinate, direction coordinate * vector index coordinate) ∧
      ∀ coefficient : Fin m → K,
        (∑ index, coefficient index • Quantum.formalExponentialCharacter
          ((∑ coordinate, direction coordinate * vector index coordinate : ℤ) : K) = 0) →
        coefficient = 0 :=
  Quantum.exists_integralDirection_separating_formalExponentialCharacters
    vector vector_injective
/-- A nonzero coefficient family satisfying the completed Novikov support
condition has a nonempty finite lowest-length support.  Membership in that
support means exactly nonzero coefficient at the least occupied length. -/
theorem completedNovikov_lowestSupport_nonempty
    {Curve Coefficient : Type*} [Zero Coefficient] {length : Curve → ℕ}
    (series : Quantum.CompletedNovikovSeries Curve Coefficient length)
    (series_nonzero : series.coefficient ≠ 0) :
    series.lowestSupport.Nonempty ∧
      ∀ degree, degree ∈ series.lowestSupport ↔
        series.coefficient degree ≠ 0 ∧
          length degree = series.lowestLength :=
  ⟨series.lowestSupport_nonempty series_nonzero,
    series.mem_lowestSupport_iff⟩
/-- Completed-series finite-support noncancellation used in divisor tagging.
For a nonzero completed coefficient family with an injective integral
divisor-pairing vector, Lean constructs an integral direction separating the
finite lowest support.  Every assignment of nonzero leading coefficients then
gives a nonzero finite exponential-character combination over any
characteristic-zero field.  The theorem does not identify this combination
with the initial form of a geometric specialization. -/
theorem completedNovikov_lowestSupport_exponentialSum_ne_zero
    {Curve Coefficient K : Type*} [Zero Coefficient]
    [Field K] [CharZero K] {length : Curve → ℕ}
    (series : Quantum.CompletedNovikovSeries Curve Coefficient length)
    (series_nonzero : series.coefficient ≠ 0)
    {rank : ℕ} (pairingVector : Curve → Fin rank → ℤ)
    (pairingVector_injective : Function.Injective pairingVector) :
    ∃ direction : Fin rank → ℤ,
      Function.Injective (fun degree : series.lowestSupport ↦
        ∑ coordinate, direction coordinate * pairingVector degree coordinate) ∧
      ∀ leadingCoefficient : series.lowestSupport → K,
        (∀ degree, leadingCoefficient degree ≠ 0) →
        ∑ degree, leadingCoefficient degree •
          Quantum.formalExponentialCharacter
            ((∑ coordinate, direction coordinate *
              pairingVector degree coordinate : ℤ) : K) ≠ 0 :=
  series.exists_integralDirection_lowestSupport_exponentialSum_ne_zero
    series_nonzero pairingVector pairingVector_injective
/-- Conditional detector bridge for associated-graded tagging.  From a supplied
initial-form detector, nonzero monomial initial coefficients, and the equality
identifying the detected initial form with the finite lowest-support
exponential combination, Lean proves that every nonzero completed coefficient
family has nonzero tagged image.  Only the detector, its zero value, nonzero
monomial coefficients, and the compatibility equality are supplied.  The
target filtration, associated graded ring, valuation, geometric specialization,
and the proof that they induce these inputs are not represented. -/
theorem associatedGradedTagging_taggedImage_ne_zero
    {Curve K Target : Type*} [Field K] [CharZero K] [AddCommGroup Target]
    {length : Curve → ℕ} {rank : ℕ}
    (input : Quantum.AssociatedGradedTaggingInput
      Curve K Target length rank)
    (series : Quantum.CompletedNovikovSeries Curve K length)
    (series_nonzero : series ≠ 0) :
    input.taggedImage series ≠ 0 :=
  input.taggedImage_ne_zero series series_nonzero
/-- Zero-reflection conclusion of the associated-graded tagging bridge: the
tagged image is zero exactly for the zero completed coefficient family. -/
theorem associatedGradedTagging_taggedImage_eq_zero_iff
    {Curve K Target : Type*} [Field K] [CharZero K] [AddCommGroup Target]
    {length : Curve → ℕ} {rank : ℕ}
    (input : Quantum.AssociatedGradedTaggingInput
      Curve K Target length rank)
    (series : Quantum.CompletedNovikovSeries Curve K length) :
    input.taggedImage series = 0 ↔ series = 0 :=
  input.taggedImage_eq_zero_iff series
/-- Full completed-series injectivity of the associated-graded tagging
bridge.  Since the supplied tagged map is additive, nonvanishing on every
nonzero series applied to a difference proves pairwise injectivity. -/
theorem associatedGradedTagging_taggedImage_injective
    {Curve K Target : Type*} [Field K] [CharZero K] [AddCommGroup Target]
    {length : Curve → ℕ} {rank : ℕ}
    (input : Quantum.AssociatedGradedTaggingInput
      Curve K Target length rank) :
    Function.Injective input.taggedImage :=
  input.taggedImage_injective
/-- Reviewer-facing dimension-four birational invariance of the framed
primitive-sixth marker.  It invokes the same generic occurrence-indexed theorem
as the direct residue marker. -/
theorem framedSixthMarker_eq_of_birational
    {Variety Center Occurrence : Type*} {ambientDimension : ℕ}
    (context : Quantum.FramedSixthMarkerContext ambientDimension
      Variety Center Occurrence)
    {left right : Variety}
    (leftSmooth : context.data.smoothProjective left)
    (rightSmooth : context.data.smoothProjective right)
    (leftDimension : context.data.dimension left = ambientDimension)
    (rightDimension : context.data.dimension right = ambientDimension)
    (related : context.birational.r left right) :
    context.marker left = context.marker right :=
  context.marker_eq_of_birational leftSmooth rightSmooth leftDimension rightDimension related
/-- Reviewer-facing one-projective-line consequence of framed marker
invariance: if the stabilizations of two smooth projective threefolds are
birational and both satisfy the rank-two projective-bundle formula, their
primitive-sixth markers agree. -/
theorem framedSixthMarker_eq_of_oneProjectiveLine_birational
    {Variety Center Occurrence : Type*}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    {left right : Variety}
    (leftDimension : context.data.dimension left = 3)
    (rightDimension : context.data.dimension right = 3)
    (leftFormula : Quantum.ProjectiveBundleMarkerFormula
      context.data context.presentation.fold left
        (productWithProjectiveLine left) 2)
    (rightFormula : Quantum.ProjectiveBundleMarkerFormula
      context.data context.presentation.fold right
        (productWithProjectiveLine right) 2)
    (related : context.birational.r
      (productWithProjectiveLine left) (productWithProjectiveLine right)) :
    context.marker left = context.marker right :=
  Applications.framedSixthMarker_eq_of_oneProjectiveLine_birational
    context productWithProjectiveLine leftDimension rightDimension
      leftFormula rightFormula related
/-- Reviewer-facing unconditional genus-eight one-step irrationality through
the direct residue-marker categorical context. -/
theorem genusEight_oneProjectiveLine_not_rational_of_residueContext
    {K Variety Center Occurrence : Type*} [CommRing K]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (geometry : Applications.GenusEightCategoricalGeometry Variety)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (fano : Variety)
    (transport : Applications.GenusEightResidueTransportInput context geometry
      productWithProjectiveLine Rational fano)
    (cubicInput : Applications.CubicResidueMarkerOneStepInput context
      productWithProjectiveLine projectiveFourSpace Rational
      (geometry.associatedPfaffianCubic fano)) :
    ¬ Rational (productWithProjectiveLine fano) :=
  Applications.genusEight_oneProjectiveLine_not_rational_of_residueContext
    context geometry productWithProjectiveLine projectiveFourSpace Rational
    fano transport cubicInput
/-- Reviewer-facing conditional equality `ν₆(V) = 2`, obtained from the framed
occurrence-indexed descent theorem applied to Kuznetsov's two rank-two
projectivizations. -/
theorem genusEight_framedSixthMarker_eq_two_of_categoricalFlop
    {Variety Center Occurrence : Type*}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (geometry : Applications.GenusEightCategoricalGeometry Variety)
    (fano : Variety)
    (input : Applications.GenusEightFramedTransportInput context geometry fano) :
    context.marker fano = 2 :=
  Applications.genusEight_framedSixthMarker_eq_two_of_categoricalFlop
    context geometry fano input
/-- Reviewer-facing cubic packet theorem from the block reduction.  The premise
supplies only that framed formal monodromy exponentiates the exponents of the
reduced system, with two unit factors from the rank-one blocks; which exponents
occur is proved from the reduction rather than assumed. -/
theorem cubicPacket_sixthMultiplicity_eq_two_of_block_exponents
    {Cubic : Type*} (geometry : Applications.CubicPacketGeometry Cubic)
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
      (geometry.framedMonodromy cubic).sixthMultiplicity = 2 :=
  Applications.cubicPacket_sixthMultiplicity_eq_two_of_block_exponents geometry
    exponentMonodromy
/-- Reviewer-facing vanishing of the primitive-sixth multiplicity of every
projective space.  The premises are the manuscript's product formula for a
product with a projective space, the identification of a projective space with
the product of a point with it, and involutivity of the framed monodromy of a
point.  Lean deduces that the point and every projective space have vanishing
multiplicity; dimension three is the value used in the universal triviality
comparison, and dimension four is the value used by the framed-monodromy proof
of one-step irrationality. -/
theorem projectiveSpace_sixthMultiplicity_eq_zero_of_product_inputs
    {Variety : Type*}
    (geometry : Applications.ProjectiveProductGeometry Variety)
    (input : Applications.ProjectiveProductInput geometry) :
    (geometry.framedMonodromy geometry.point).sixthMultiplicity = 0 ∧
      ∀ dimension : ℕ,
        (geometry.framedMonodromy
          (geometry.projectiveSpace dimension)).sixthMultiplicity = 0 :=
  ⟨Applications.point_sixthMultiplicity_eq_zero geometry input,
    Applications.projectiveSpace_sixthMultiplicity_eq_zero geometry input⟩
/-- Reviewer-facing framed count after one product stabilization, from the
packet value.  Under the manuscript's product formula, a variety of
primitive-sixth multiplicity two has multiplicity four after multiplication by
a projective line. -/
theorem productProjectiveLine_sixthMultiplicity_eq_four
    {Variety : Type*}
    (geometry : Applications.ProjectiveProductGeometry Variety)
    (input : Applications.ProjectiveProductInput geometry) {base : Variety}
    (packet : (geometry.framedMonodromy base).sixthMultiplicity = 2) :
    (geometry.framedMonodromy
        (geometry.productWithProjectiveSpace base 1)).sixthMultiplicity = 4 :=
  Applications.productProjectiveLine_sixthMultiplicity_eq_four geometry input packet
/-- Reviewer-facing framed count after one product stabilization for a smooth
cubic threefold.  The packet value two is not assumed: it is derived from the
small even block reduction, so the premises are the manuscript's product
formula, involutivity of the framed monodromy of a point, and the passage from
the exponents of the reduced rank-two block to framed formal monodromy. -/
theorem cubicProductProjectiveLine_sixthMultiplicity_eq_four_of_block_exponents
    {Variety : Type*}
    (geometry : Applications.ProjectiveProductGeometry Variety)
    (input : Applications.ProjectiveProductInput geometry)
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
          (geometry.productWithProjectiveSpace cubic 1)).sixthMultiplicity = 4 :=
  Applications.cubicProductProjectiveLine_sixthMultiplicity_eq_four geometry input
    exponentMonodromy
/-- Formal-germ rigidity of an isolated rank-two Euler cluster, in the matrix
model of a formal bulk germ.  The leading operator of the cluster is
`eigenvalue • 1 + nilpotent` with traceless nilpotent part; `compressed` is the
compression to the cluster of quantum multiplication by a bulk tangent vector,
`connection` records the covariant derivative in a chosen frame, and `grading`
is the grading operator.  From the two compressed flatness identities, an
invertible off-diagonal entry of the nilpotent part, and its vanishing
determinant at the closed point, Lean proves that the nilpotent part stays
square-zero and nonzero over the whole germ, which is the matrix form of
remaining a single nonzero Jordan block.  No quantum connection, Euler operator,
or spectral projector is constructed. -/
theorem rankTwoCluster_nilpotent_persists_on_formal_germ
    {coordinate : Type*} [DecidableEq coordinate] {field : Type*} [Field field] [CharZero field]
    {eigenvalue : MvPowerSeries coordinate field}
    {nilpotent grading : Matrix (Fin 2) (Fin 2) (MvPowerSeries coordinate field)}
    {connection compressed :
      coordinate → Matrix (Fin 2) (Fin 2) (MvPowerSeries coordinate field)}
    (traceless : Matrix.trace nilpotent = 0)
    (unitEntry : IsUnit (nilpotent 0 1))
    (nilpotentAtClosedPoint : MvPowerSeries.coeff 0 nilpotent.det = 0)
    (commutes : ∀ direction,
      compressed direction * nilpotent = nilpotent * compressed direction)
    (flatness : ∀ direction,
      (eigenvalue • (1 : Matrix (Fin 2) (Fin 2) (MvPowerSeries coordinate field))
            + nilpotent).map (Quantum.formalPartialDerivative direction)
          + connection direction * (eigenvalue • 1 + nilpotent)
          - (eigenvalue • 1 + nilpotent) * connection direction
        = compressed direction
          + (compressed direction * grading - grading * compressed direction)) :
    nilpotent * nilpotent = 0 ∧ nilpotent ≠ 0 :=
  Quantum.rankTwoCluster_nilpotent_persists_on_germ traceless unitEntry
    nilpotentAtClosedPoint commutes flatness
/-- The residue of the canonical elementary modification has constant
characteristic polynomial over a formal bulk germ.  The premise is modified
flatness in every base direction, which makes each formal partial derivative of
the residue a commutator with a matrix regular in the germ; the conclusion
exhibits the characteristic polynomial as the one attached to two scalars of the
coefficient field, so neither the trace nor the determinant varies.  The
elementary modification itself is not constructed. -/
theorem rankTwoCluster_residue_charpoly_constant_on_formal_germ
    {coordinate : Type*} [DecidableEq coordinate] {field : Type*} [Field field] [CharZero field]
    {residue : Matrix (Fin 2) (Fin 2) (MvPowerSeries coordinate field)}
    {regular : coordinate → Matrix (Fin 2) (Fin 2) (MvPowerSeries coordinate field)}
    (modifiedFlatness : ∀ direction,
      residue.map (Quantum.formalPartialDerivative direction)
        = regular direction * residue - residue * regular direction) :
    ∃ traceValue determinantValue : field,
      residue.charpoly = Polynomial.X ^ 2
          - Polynomial.C (MvPowerSeries.C traceValue) * Polynomial.X
        + Polynomial.C (MvPowerSeries.C determinantValue) :=
  Quantum.residue_charpoly_constant_of_lax modifiedFlatness
/-- Constancy of the primitive-sixth count contributed by a block with constant
exponents.  Two multisets of formal exponents with the same monic split
polynomial contribute the same framed primitive-sixth multiplicity, because the
multiset is recovered from that polynomial as its multiset of roots and framed
monodromy attaches to each exponent the eigenvalue of one turn of the unramified
loop coordinate.  Over a formal germ the hypothesis is supplied by constancy of
the residue characteristic polynomial. -/
theorem rankTwoCluster_sixthMultiplicity_constant_of_equal_exponents
    {first second : Multiset ℂ}
    (equalExponentPolynomials :
      Quantum.splitMonicPolynomial first = Quantum.splitMonicPolynomial second) :
    Quantum.sixthMultiplicityPolynomial
        (Quantum.splitMonicPolynomial (first.map Quantum.framedEigenvalue))
      = Quantum.sixthMultiplicityPolynomial
        (Quantum.splitMonicPolynomial (second.map Quantum.framedEigenvalue)) :=
  Quantum.sixthMultiplicity_eq_of_exponent_polynomial_eq equalExponentPolynomials
/-- The grading operator vanishes on a rank-one Euler block.  On the block the
Poincare pairing is a single nonzero scalar, because generalized eigenspaces of
distinct eigenvalues of an operator self-adjoint for a nondegenerate pairing are
orthogonal; anti-self-adjointness of the grading operator on that line then
forces its value to vanish. -/
theorem simpleEulerBlock_grading_eq_zero
    {field : Type*} [Field field] (twoNeZero : (2 : field) ≠ 0)
    {pairing grading : Matrix (Fin 1) (Fin 1) field}
    (nondegenerate : pairing 0 0 ≠ 0)
    (antiSelfAdjoint : Matrix.transpose grading * pairing + pairing * grading = 0) :
    grading = 0 :=
  Quantum.rankOne_grading_eq_zero twoNeZero nondegenerate antiSelfAdjoint
/-- The order-`z` coefficient of the scalar equation on a rank-one Euler block
vanishes.  It is the compression of the grading operator, with a minus sign, plus
the compression of the commutator of Euler multiplication with the first
coefficient of the normalized gauge splitting the block off; the first vanishes
on a rank-one block and the second vanishes because the projector commutes with
Euler multiplication and annihilates a block-off-diagonal gauge coefficient on
both sides. -/
theorem simpleEulerBlock_linearCoefficient_eq_zero
    {index : Type*} [Fintype index] {ring : Type*} [CommRing ring]
    (projector euler gauge grading : Matrix index index ring)
    (commutes : projector * euler = euler * projector)
    (offDiagonal : projector * gauge * projector = 0)
    (gradingCompression : projector * grading * projector = 0) :
    -(projector * grading * projector)
        + projector * (euler * gauge - gauge * euler) * projector = 0 :=
  Quantum.rankOne_linearCoefficient_eq_zero projector euler gauge grading commutes
    offDiagonal gradingCompression
/-- The regular factor of a rank-one Euler block is an ordinary power series in
the loop coordinate.  Once the order-`z` coefficient vanishes, removing the
irregular exponential factor from the scalar equation leaves
`solution' = logarithmic * solution`, which over a field of characteristic zero
has exactly one formal solution with constant coefficient one.  No logarithm and
no fractional power occurs, so the framed regular monodromy of the block is the
identity. -/
theorem simpleEulerBlock_regularFactor_exists_unique
    {field : Type*} [Field field] [CharZero field] (logarithmic : PowerSeries field) :
    ∃! solution : PowerSeries field,
      PowerSeries.coeff 0 solution = 1 ∧
        PowerSeries.derivativeFun solution = logarithmic * solution :=
  ⟨Quantum.normalizedExponential logarithmic,
    ⟨Quantum.normalizedExponential_constantCoeff logarithmic,
      Quantum.normalizedExponential_derivative logarithmic⟩,
    fun _ condition =>
      Quantum.eq_normalizedExponential_of_derivative condition.1 condition.2⟩
/-- A block whose framed regular monodromy is the identity contributes nothing to
the primitive-sixth count: its characteristic polynomial is a power of `X - 1`,
and neither primitive sixth root is a root of it. -/
theorem simpleEulerBlock_sixthMultiplicity_eq_zero (rank : ℕ) :
    Quantum.sixthMultiplicityPolynomial
        ((Polynomial.X - Polynomial.C (1 : ℂ)) ^ rank) = 0 :=
  Quantum.sixthMultiplicityPolynomial_unitPower_eq_zero rank
/-- Persistence of the cubic packet over the formal even bulk germ.  The framed
characteristic polynomial at every point of the germ splits as the exponential
polynomial of the rank-two zero cluster times the unit power contributed by the
rank-one clusters at the nonzero Euler eigenvalues; the exponent polynomial of
the zero cluster does not vary over the germ; and at the closed point the framed
characteristic polynomial is the displayed four-factor polynomial of the cubic
packet.  Lean then proves that the primitive-sixth multiplicity equals two at
every point.  The germ, the connection, and the identification of these data with
them are not constructed. -/
theorem cubicPacket_sixthMultiplicity_eq_two_on_formal_germ
    {Point : Type*} (germ : Applications.CubicFormalGermPacket Point)
    (blockFactorization : ∀ point,
      (germ.framedMonodromy point).operator.charpoly
        = Quantum.splitMonicPolynomial
            ((germ.zeroClusterExponents point).map Quantum.framedEigenvalue)
          * (Polynomial.X - Polynomial.C (1 : ℂ)) ^ germ.simpleClusterRank)
    (exponentRigidity : ∀ point,
      Quantum.splitMonicPolynomial (germ.zeroClusterExponents point)
        = Quantum.splitMonicPolynomial (germ.zeroClusterExponents germ.closedPoint))
    (closedPointPacket :
      (germ.framedMonodromy germ.closedPoint).operator.charpoly
        = Applications.cubicPacketCharacteristicPolynomial) :
    ∀ point, (germ.framedMonodromy point).sixthMultiplicity = 2 :=
  Applications.cubicFormalGerm_sixthMultiplicity_eq_two germ blockFactorization
    exponentRigidity closedPointPacket
/-- The product formula for the primitive-sixth count of a product with a
projective space, from the framed tensor decomposition.  The premise is that the
framed characteristic polynomial of the product is the `(m + 1)`-st power of that
of the base, which is what the manuscript's Levelt--Turrittin computation
produces once the rank-one blocks at the `m + 1` eigenvalues of quantum
multiplication by the first Chern class of the projective space are seen to have
trivial framed regular monodromy.  Lean concludes that the multiplicity is
multiplied by `m + 1`.  The Gromov--Witten product formula, the numerical Novikov
base change, and the tensor compatibility of the formal decomposition are not
proved. -/
theorem projectiveProduct_sixthMultiplicity_of_framed_tensor_decomposition
    (base product : Quantum.FramedMonodromyMatrix) (dimension : ℕ)
    (tensorDecomposition :
      product.operator.charpoly = base.operator.charpoly ^ (dimension + 1)) :
    product.sixthMultiplicity = (dimension + 1) * base.sixthMultiplicity :=
  Applications.projectiveProduct_sixthMultiplicity_of_charpoly_power base product
    dimension tensorDecomposition
/-- Nilpotence of the residue of the gauged connection of a target with nef
canonical class.  The residue is recorded as a complex matrix whose nonzero
entries raise by at least one the integral weight function given by the
eigenvalues of the grading operator; on a finite index type such a matrix is
nilpotent, because the weights of finitely many basis vectors have bounded
spread.  The grading operator, Euler multiplication, and the gauge are not
constructed. -/
theorem specializedLowDimensional_weightRaising_residue_isNilpotent {rank : ℕ}
    (weight : Fin rank → ℤ) (residue : Matrix (Fin rank) (Fin rank) ℂ)
    (raises : Quantum.RaisesWeight weight residue) : IsNilpotent residue :=
  raises.isNilpotent
/-- The residue of the gauged connection of a target with nef canonical class is
a finite sum of weight-raising matrices, one for each effective class of
vanishing first Chern number, and such a sum raises the weight.  A specialization
that groups several numerical classes into one coefficient contributes a grouped
summand, which is again a sum of weight-raising matrices, so the conclusion is
unaffected. -/
theorem specializedLowDimensional_weightRaising_sum {rank : ℕ} {index : Type*}
    (weight : Fin rank → ℤ) (support : Finset index)
    (family : index → Matrix (Fin rank) (Fin rank) ℂ)
    (raises : ∀ i ∈ support, Quantum.RaisesWeight weight (family i)) :
    Quantum.RaisesWeight weight (∑ i ∈ support, family i) :=
  Quantum.RaisesWeight.sum raises
/-- Unipotence of the regular monodromy of a nilpotent residue: the exponential
of a nilpotent complex matrix differs from the identity by a nilpotent matrix.
This is the passage from nilpotence of the residue of a regular-singular
connection to unipotence of its regular monodromy, at the level of the
exponential of a matrix. -/
theorem specializedLowDimensional_exp_nilpotentResidue_unipotent {rank : ℕ}
    {residue : Matrix (Fin rank) (Fin rank) ℂ} (nilpotent : IsNilpotent residue) :
    IsNilpotent (NormedSpace.exp residue - 1) :=
  Quantum.isNilpotent_exp_sub_one nilpotent
/-- Direct vanishing of the specialized primitive-sixth count for a target whose
canonical class is nef.  The framed monodromy is supplied as the product of a
parity correction of square one with the exponential of `2πi` times a residue
raising the integral weight filtration of the grading operator, and the parity
correction commutes with the residue.  Lean proves that the residue is nilpotent,
hence that the second factor is unipotent, hence that every characteristic root
of the product has square one, so neither primitive sixth root occurs.  The
quantum connection, the grading operator, the gauge making the connection regular
singular, and the identification of the parity factor with the monodromy of the
half-parity correction are not formalized. -/
theorem specializedLowDimensional_nefCanonical_sixthMultiplicity_eq_zero
    (monodromy : Quantum.FramedMonodromyMatrix) (weight : Fin monodromy.rank → ℤ)
    (parity residue : Matrix (Fin monodromy.rank) (Fin monodromy.rank) ℂ)
    (residueRaisesWeight : Quantum.RaisesWeight weight residue)
    (parityInvolution : parity * parity = 1)
    (parityCommutes : Commute parity residue)
    (factorization : monodromy.operator
      = parity * NormedSpace.exp ((2 * Real.pi * Complex.I) • residue)) :
    monodromy.sixthMultiplicity = 0 :=
  Quantum.sixthMultiplicity_eq_zero_of_weightRaising_residue monodromy weight parity residue
    residueRaisesWeight parityInvolution parityCommutes factorization
/-- Simplicity of the Euler spectrum of a specialized projective space.  If the
characteristic polynomial of Euler multiplication is `X ^ (m + 1) - a` with `a`
nonzero, that polynomial is separable, so every maximal generalized eigenspace
has dimension at most one: every spectral block has rank one. -/
theorem specializedLowDimensional_projectiveSpace_eulerBlocks_simple {dimension : ℕ}
    (euler : Matrix (Fin (dimension + 1)) (Fin (dimension + 1)) ℂ)
    (lineCoefficient : ℂ) (lineCoefficientNonzero : lineCoefficient ≠ 0)
    (quantumRelation : euler.charpoly
      = Polynomial.X ^ (dimension + 1) - Polynomial.C lineCoefficient)
    (value : ℂ) :
    Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1 :=
  Quantum.projectiveSpaceEuler_finrank_maxGenEigenspace_le_one euler lineCoefficient
    lineCoefficientNonzero quantumRelation value
/-- The specialized quantum relation of projective `m`-space has exactly `m + 1`
distinct roots, which are the eigenvalues of Euler multiplication up to the
scaling by `m + 1` used in the manuscript. -/
theorem specializedLowDimensional_projectiveSpace_distinctEigenvalues (dimension : ℕ)
    (lineCoefficient : ℂ) (lineCoefficientNonzero : lineCoefficient ≠ 0) :
    (Polynomial.X ^ (dimension + 1)
        - Polynomial.C lineCoefficient).roots.toFinset.card = dimension + 1 :=
  Quantum.projectiveSpaceRelation_card_distinct_roots dimension lineCoefficient
    lineCoefficientNonzero
/-- Direct vanishing of the specialized primitive-sixth count for the projective
line and the projective plane.  From the specialized quantum relation with
nonzero line coefficient, Lean proves that every spectral block of Euler
multiplication has rank one, and the supplied conclusion of the multiplicity-one
Euler block lemma then makes the framed monodromy the identity, which contributes
nothing to the count. -/
theorem specializedLowDimensional_projectiveSpace_sixthMultiplicity_eq_zero {dimension : ℕ}
    (euler : Matrix (Fin (dimension + 1)) (Fin (dimension + 1)) ℂ)
    (lineCoefficient : ℂ) (lineCoefficientNonzero : lineCoefficient ≠ 0)
    (quantumRelation : euler.charpoly
      = Polynomial.X ^ (dimension + 1) - Polynomial.C lineCoefficient)
    (monodromy : Quantum.FramedMonodromyMatrix)
    (simpleBlockMonodromy :
      (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1) →
        monodromy.operator.charpoly
          = (Polynomial.X - Polynomial.C (1 : ℂ)) ^ monodromy.rank) :
    monodromy.sixthMultiplicity = 0 :=
  Applications.projectiveSpace_specialized_sixthMultiplicity_eq_zero euler lineCoefficient
    lineCoefficientNonzero quantumRelation monodromy simpleBlockMonodromy
/-- Direct vanishing of the specialized primitive-sixth count for a geometrically
ruled surface over a curve of positive genus.  The base curve has nef canonical
class, so the spectral argument applies to it; the intrinsic projective-bundle
formula doubles its count; and the specialized and intrinsic framed
characteristic polynomials agree, which is the manuscript's identification of the
two one-variable modules after scalar extension to a common algebraically closed
overfield.  The projective-bundle formula and that identification are
hypotheses. -/
theorem specializedLowDimensional_ruledSurface_sixthMultiplicity_eq_zero
    (base total specialized : Quantum.FramedMonodromyMatrix)
    (weight : Fin base.rank → ℤ)
    (parity residue : Matrix (Fin base.rank) (Fin base.rank) ℂ)
    (residueRaisesWeight : Quantum.RaisesWeight weight residue)
    (parityInvolution : parity * parity = 1)
    (parityCommutes : Commute parity residue)
    (baseFactorization : base.operator
      = parity * NormedSpace.exp ((2 * Real.pi * Complex.I) • residue))
    (projectiveBundleFormula : total.sixthMultiplicity = 2 * base.sixthMultiplicity)
    (specializationComparison :
      specialized.operator.charpoly = total.operator.charpoly) :
    specialized.sixthMultiplicity = 0 :=
  Applications.ruledSurface_specialized_sixthMultiplicity_eq_zero_of_nefCanonical_base
    base total specialized weight parity residue residueRaisesWeight parityInvolution
    parityCommutes baseFactorization projectiveBundleFormula specializationComparison
/-- Discriminant of the quartic that the manuscript derives as the
characteristic polynomial of Euler multiplication on the rank-four even
cohomology of a Hirzebruch surface of even index, after a Novikov specialization
sending the fibre class to `u` and the section class shifted by half the index in
fibres to `w`: the discriminant is `2 ^ 24 u ^ 2 w ^ 2 (u - w) ^ 2`.  Lean
constructs no quantum cohomology; the quartic is the displayed polynomial. -/
theorem hirzebruchEven_eulerSpectrum_discriminant (fibreValue sectionValue : ℂ) :
    Quantum.quarticDiscriminant (16 * (fibreValue - sectionValue) ^ 2) 0
        (-(8 * (fibreValue + sectionValue))) 0
      = 16777216 * (fibreValue ^ 2 * sectionValue ^ 2 * (fibreValue - sectionValue) ^ 2) :=
  Quantum.hirzebruchEvenEuler_discriminant fibreValue sectionValue
/-- Discriminant of the corresponding quartic for a Hirzebruch surface of odd
index, with `u` the specialized value of the fibre class and `w` that of the
section class shifted by the integer part of half the index in fibres:
`- u ^ 2 w ^ 2 (256 u + 27 w ^ 2) ^ 3`.  Lean constructs no quantum cohomology;
the quartic is the displayed polynomial. -/
theorem hirzebruchOdd_eulerSpectrum_discriminant (fibreValue sectionValue : ℂ) :
    Quantum.quarticDiscriminant (16 * fibreValue ^ 2 - 27 * fibreValue * sectionValue ^ 2)
        (-(36 * fibreValue * sectionValue)) (-(8 * fibreValue)) sectionValue
      = -(fibreValue ^ 2 * sectionValue ^ 2 * (256 * fibreValue + 27 * sectionValue ^ 2) ^ 3) :=
  Quantum.hirzebruchOddEuler_discriminant fibreValue sectionValue
/-- At `u = fibreRoot ^ 2` and `w = sectionRoot ^ 2` the even quartic is the
product of the four linear factors with roots `2 (± fibreRoot ± sectionRoot)`;
these are the eigenvalues of Euler multiplication in the even case, and they need
not be distinct.  The letter `a` is reserved for the index of the surface. -/
theorem hirzebruchEven_eulerSpectrum_splitting (fibreRoot sectionRoot : ℂ) :
    Quantum.hirzebruchEvenEulerCharpoly (fibreRoot ^ 2) (sectionRoot ^ 2)
      = (Polynomial.X - Polynomial.C (2 * (fibreRoot + sectionRoot)))
        * (Polynomial.X - Polynomial.C (2 * (fibreRoot - sectionRoot)))
        * (Polynomial.X - Polynomial.C (-(2 * (fibreRoot - sectionRoot))))
        * (Polynomial.X - Polynomial.C (-(2 * (fibreRoot + sectionRoot)))) :=
  Quantum.hirzebruchEvenEuler_splitting fibreRoot sectionRoot
/-- Degeneracy criterion in the even case: for a specialization with both values
nonzero the Euler quartic has a repeated root exactly when the two values
agree. -/
theorem hirzebruchEven_degenerate_iff (fibreValue sectionValue : ℂ)
    (fibreNonzero : fibreValue ≠ 0) (sectionNonzero : sectionValue ≠ 0) :
    Quantum.quarticDiscriminant (16 * (fibreValue - sectionValue) ^ 2) 0
        (-(8 * (fibreValue + sectionValue))) 0 = 0 ↔ fibreValue = sectionValue :=
  Quantum.hirzebruchEvenEuler_discriminant_eq_zero_iff fibreValue sectionValue fibreNonzero
    sectionNonzero
/-- Degeneracy criterion in the odd case: for a specialization with both values
nonzero the Euler quartic has a repeated root exactly on the quadratic locus
`256 u + 27 w ^ 2 = 0`. -/
theorem hirzebruchOdd_degenerate_iff (fibreValue sectionValue : ℂ)
    (fibreNonzero : fibreValue ≠ 0) (sectionNonzero : sectionValue ≠ 0) :
    Quantum.quarticDiscriminant (16 * fibreValue ^ 2 - 27 * fibreValue * sectionValue ^ 2)
        (-(36 * fibreValue * sectionValue)) (-(8 * fibreValue)) sectionValue = 0
      ↔ 256 * fibreValue + 27 * sectionValue ^ 2 = 0 :=
  Quantum.hirzebruchOddEuler_discriminant_eq_zero_iff fibreValue sectionValue fibreNonzero
    sectionNonzero
/-- On the even degeneracy locus the quartic is a squared linear factor times a
quadratic: the repeated root is `0` and the two remaining roots are
`± 4 fibreRoot`, where `fibreRoot` is a square root of the common specialized
value. -/
theorem hirzebruchEven_degenerate_splitting (fibreRoot : ℂ) :
    Quantum.hirzebruchEvenEulerCharpoly (fibreRoot ^ 2) (fibreRoot ^ 2)
      = (Polynomial.X - Polynomial.C 0) ^ 2
        * ((Polynomial.X - Polynomial.C (4 * fibreRoot))
          * (Polynomial.X - Polynomial.C (-(4 * fibreRoot)))) :=
  Quantum.hirzebruchEvenEuler_degenerate_splitting fibreRoot
/-- On the odd degeneracy locus, parametrized by writing the section value as
`16 s` so that the fibre value is `-27 s ^ 2`, the quartic is a squared linear
factor times a quadratic: the repeated root is `-18 s` and the two remaining
roots are `10 s ± 16 e` for a square root `e` of `-2 s ^ 2`. -/
theorem hirzebruchOdd_degenerate_splitting (sectionScale squareRoot : ℂ)
    (root : squareRoot ^ 2 = -(2 * sectionScale ^ 2)) :
    Quantum.hirzebruchOddEulerCharpoly (-(27 * sectionScale ^ 2)) (16 * sectionScale)
      = (Polynomial.X - Polynomial.C (-(18 * sectionScale))) ^ 2
        * ((Polynomial.X - Polynomial.C (10 * sectionScale + 16 * squareRoot))
          * (Polynomial.X - Polynomial.C (10 * sectionScale - 16 * squareRoot))) :=
  Quantum.hirzebruchOddEuler_degenerate_splitting sectionScale squareRoot root
/-- The parametrization of the odd degeneracy locus is surjective: a pair of
specialized values on that locus is `(-(27 s ^ 2), 16 s)` for `s` a sixteenth of
the section value. -/
theorem hirzebruchOdd_degeneracyLocus_parametrized (fibreValue sectionValue : ℂ)
    (locus : 256 * fibreValue + 27 * sectionValue ^ 2 = 0) :
    fibreValue = -(27 * (sectionValue / 16) ^ 2) ∧ sectionValue = 16 * (sectionValue / 16) :=
  Quantum.hirzebruchOddEuler_degeneracyLocus_parametrized fibreValue sectionValue locus
/-- A quartic of the form `(X - r) ^ 2 (X - c) (X - d)` with `c ≠ r` and `d ≠ r`
has every root multiplicity at most two.  No relation between `c` and `d` is
assumed, and no matrix occurs: the statement is about the polynomial. -/
theorem hirzebruch_degenerate_rootMultiplicity_le_two {repeated first second : ℂ}
    (firstNe : first ≠ repeated) (secondNe : second ≠ repeated) (value : ℂ) :
    (((Polynomial.X - Polynomial.C repeated) ^ 2)
        * ((Polynomial.X - Polynomial.C first)
          * (Polynomial.X - Polynomial.C second))).rootMultiplicity value ≤ 2 :=
  Quantum.rootMultiplicity_le_two_of_squared_linear_mul_quadratic firstNe secondNe value
/-- The repeated factor of such a quartic contributes root multiplicity exactly
two.  Nothing about eigenspace dimensions is asserted here, and the two remaining
factors are not assumed distinct from each other. -/
theorem hirzebruch_degenerate_rootMultiplicity_eq_two {repeated first second : ℂ}
    (firstNe : first ≠ repeated) (secondNe : second ≠ repeated) :
    (((Polynomial.X - Polynomial.C repeated) ^ 2)
        * ((Polynomial.X - Polynomial.C first)
          * (Polynomial.X - Polynomial.C second))).rootMultiplicity repeated = 2 :=
  Quantum.rootMultiplicity_eq_two_of_squared_linear_mul_quadratic firstNe secondNe
/-- A root of `(X - r) ^ 2 (X - c) (X - d)` that differs from `r` and from the
other unrepeated root is simple: the multiplicity at `c` is one when `r ≠ c` and
`d ≠ c`.  No matrix occurs; the statement is about the polynomial.  Applying it
to both remaining roots of a degenerate Euler quartic is done in
`TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.HirzebruchEulerSpectrum`. -/
theorem hirzebruch_degenerate_rootMultiplicity_eq_one {repeated first second : ℂ}
    (repeatedNe : repeated ≠ first) (secondNe : second ≠ first) :
    (((Polynomial.X - Polynomial.C repeated) ^ 2)
        * ((Polynomial.X - Polynomial.C first)
          * (Polynomial.X - Polynomial.C second))).rootMultiplicity first = 1 :=
  Quantum.rootMultiplicity_eq_one_of_squared_linear_mul_quadratic repeatedNe secondNe
/-- Block shape of Euler multiplication on the even degeneracy locus, with the
distinctness hypotheses discharged: if the specialized value is nonzero, no
maximal generalized eigenspace has dimension more than two, the one at the
repeated root `0` has dimension exactly two, and the ones at the two remaining
roots have dimension exactly one.  The degenerate spectrum is one block of rank
two and two blocks of rank one: the three eigenvalues account for all four
dimensions, so these are all the blocks, by the completeness of the generalized
eigenspace decomposition of a complex endomorphism, which is standard and is not
restated here. -/
theorem hirzebruchEven_degenerate_blockShape (euler : Matrix (Fin 4) (Fin 4) ℂ)
    (fibreRoot : ℂ) (nonzero : fibreRoot ≠ 0)
    (quantumRelation : euler.charpoly
      = Quantum.hirzebruchEvenEulerCharpoly (fibreRoot ^ 2) (fibreRoot ^ 2)) :
    (∀ value : ℂ,
        Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 2) ∧
      Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) 0) = 2 ∧
      Module.finrank ℂ
        (Module.End.maxGenEigenspace (Matrix.toLin' euler) (4 * fibreRoot)) = 1 ∧
      Module.finrank ℂ
        (Module.End.maxGenEigenspace (Matrix.toLin' euler) (-(4 * fibreRoot))) = 1 :=
  Quantum.hirzebruchEvenEuler_degenerate_finrank_maxGenEigenspace euler fibreRoot nonzero
    quantumRelation
/-- Block shape of Euler multiplication on the odd degeneracy locus, with the
distinctness hypotheses discharged: if the scale parameter is nonzero, no maximal
generalized eigenspace has dimension more than two, the one at the repeated root
`-18 s` has dimension exactly two, and the ones at the two remaining roots have
dimension exactly one.  The degenerate spectrum is one block of rank two and two
blocks of rank one: the three eigenvalues account for all four dimensions, so
these are all the blocks, by the completeness of the generalized eigenspace
decomposition of a complex endomorphism, which is standard and is not restated
here. -/
theorem hirzebruchOdd_degenerate_blockShape (euler : Matrix (Fin 4) (Fin 4) ℂ)
    (sectionScale squareRoot : ℂ) (root : squareRoot ^ 2 = -(2 * sectionScale ^ 2))
    (nonzero : sectionScale ≠ 0)
    (quantumRelation : euler.charpoly
      = Quantum.hirzebruchOddEulerCharpoly (-(27 * sectionScale ^ 2)) (16 * sectionScale)) :
    (∀ value : ℂ,
        Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 2) ∧
      Module.finrank ℂ
        (Module.End.maxGenEigenspace (Matrix.toLin' euler) (-(18 * sectionScale))) = 2 ∧
      Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler)
        (10 * sectionScale + 16 * squareRoot)) = 1 ∧
      Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler)
        (10 * sectionScale - 16 * squareRoot)) = 1 :=
  Quantum.hirzebruchOddEuler_degenerate_finrank_maxGenEigenspace euler sectionScale squareRoot
    root nonzero quantumRelation
/-- The nilpotent part of a rank-two block is square-zero: Cayley--Hamilton in
rank two for a matrix whose trace is twice and whose determinant is the square of
its single eigenvalue.  Semisimplicity of such a block is not asserted. -/
theorem hirzebruch_rankTwoBlock_nilpotent_sq_eq_zero (block : Matrix (Fin 2) (Fin 2) ℂ)
    (eigenvalue : ℂ) (traceValue : Matrix.trace block = 2 * eigenvalue)
    (determinantValue : block.det = eigenvalue ^ 2) :
    (block - eigenvalue • (1 : Matrix (Fin 2) (Fin 2) ℂ))
        * (block - eigenvalue • (1 : Matrix (Fin 2) (Fin 2) ℂ)) = 0 :=
  Quantum.rankTwo_centered_sq_eq_zero block eigenvalue traceValue determinantValue
/-- Off the degeneracy locus every maximal generalized eigenspace of Euler
multiplication of a Hirzebruch surface of even index is at most one-dimensional:
every spectral block has rank one. -/
theorem hirzebruchEven_eulerBlocks_simple (euler : Matrix (Fin 4) (Fin 4) ℂ)
    (fibreValue sectionValue : ℂ)
    (quantumRelation : euler.charpoly
      = Quantum.hirzebruchEvenEulerCharpoly fibreValue sectionValue)
    (fibreNonzero : fibreValue ≠ 0) (sectionNonzero : sectionValue ≠ 0)
    (separated : fibreValue ≠ sectionValue) (value : ℂ) :
    Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1 :=
  Quantum.hirzebruchEvenEuler_finrank_maxGenEigenspace_le_one euler fibreValue sectionValue
    quantumRelation fibreNonzero sectionNonzero separated value
/-- Off the degeneracy locus every maximal generalized eigenspace of Euler
multiplication of a Hirzebruch surface of odd index is at most one-dimensional:
every spectral block has rank one. -/
theorem hirzebruchOdd_eulerBlocks_simple (euler : Matrix (Fin 4) (Fin 4) ℂ)
    (fibreValue sectionValue : ℂ)
    (quantumRelation : euler.charpoly
      = Quantum.hirzebruchOddEulerCharpoly fibreValue sectionValue)
    (fibreNonzero : fibreValue ≠ 0) (sectionNonzero : sectionValue ≠ 0)
    (separated : 256 * fibreValue + 27 * sectionValue ^ 2 ≠ 0) (value : ℂ) :
    Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1 :=
  Quantum.hirzebruchOddEuler_finrank_maxGenEigenspace_le_one euler fibreValue sectionValue
    quantumRelation fibreNonzero sectionNonzero separated value
/-- Direct vanishing of the specialized primitive-sixth count for the quadric
surface, the product of two projective lines.  Lean proves that both factors have
simple Euler spectrum; the conclusion drawn from the Gromov--Witten product
formula and the multiplicity-one Euler block lemma, that the framed monodromy of
the specialized product is then unipotent, with characteristic polynomial the
`rank`-th power of `X - 1`, is a hypothesis.  No relation between the two
specialized values is assumed. -/
theorem hirzebruch_quadricSurface_sixthMultiplicity_eq_zero
    (firstEuler secondEuler : Matrix (Fin 2) (Fin 2) ℂ) (firstValue secondValue : ℂ)
    (firstNonzero : firstValue ≠ 0) (secondNonzero : secondValue ≠ 0)
    (firstRelation : firstEuler.charpoly = Polynomial.X ^ 2 - Polynomial.C firstValue)
    (secondRelation : secondEuler.charpoly = Polynomial.X ^ 2 - Polynomial.C secondValue)
    (product : Quantum.FramedMonodromyMatrix)
    (tensorTriviality :
      (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' firstEuler) value) ≤ 1) →
        (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' secondEuler) value) ≤ 1) →
          product.operator.charpoly = (Polynomial.X - Polynomial.C (1 : ℂ)) ^ product.rank) :
    product.sixthMultiplicity = 0 :=
  Applications.quadricSurface_specialized_sixthMultiplicity_eq_zero firstEuler secondEuler
    firstValue secondValue firstNonzero secondNonzero firstRelation secondRelation product
    tensorTriviality
/-- Direct vanishing of the specialized primitive-sixth count for a Hirzebruch
surface of even index at a specialization off the degeneracy locus. -/
theorem hirzebruchEven_sixthMultiplicity_eq_zero (euler : Matrix (Fin 4) (Fin 4) ℂ)
    (fibreValue sectionValue : ℂ) (fibreNonzero : fibreValue ≠ 0)
    (sectionNonzero : sectionValue ≠ 0) (separated : fibreValue ≠ sectionValue)
    (quantumRelation : euler.charpoly
      = Quantum.hirzebruchEvenEulerCharpoly fibreValue sectionValue)
    (monodromy : Quantum.FramedMonodromyMatrix)
    (simpleBlockMonodromy :
      (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1) →
        monodromy.operator.charpoly
          = (Polynomial.X - Polynomial.C (1 : ℂ)) ^ monodromy.rank) :
    monodromy.sixthMultiplicity = 0 :=
  Applications.hirzebruchEven_specialized_sixthMultiplicity_eq_zero euler fibreValue
    sectionValue fibreNonzero sectionNonzero separated quantumRelation monodromy
    simpleBlockMonodromy
/-- Direct vanishing of the specialized primitive-sixth count for a Hirzebruch
surface of odd index at a specialization off the degeneracy locus. -/
theorem hirzebruchOdd_sixthMultiplicity_eq_zero (euler : Matrix (Fin 4) (Fin 4) ℂ)
    (fibreValue sectionValue : ℂ) (fibreNonzero : fibreValue ≠ 0)
    (sectionNonzero : sectionValue ≠ 0)
    (separated : 256 * fibreValue + 27 * sectionValue ^ 2 ≠ 0)
    (quantumRelation : euler.charpoly
      = Quantum.hirzebruchOddEulerCharpoly fibreValue sectionValue)
    (monodromy : Quantum.FramedMonodromyMatrix)
    (simpleBlockMonodromy :
      (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1) →
        monodromy.operator.charpoly
          = (Polynomial.X - Polynomial.C (1 : ℂ)) ^ monodromy.rank) :
    monodromy.sixthMultiplicity = 0 :=
  Applications.hirzebruchOdd_specialized_sixthMultiplicity_eq_zero euler fibreValue
    sectionValue fibreNonzero sectionNonzero separated quantumRelation monodromy
    simpleBlockMonodromy
/-- For a specialization attached to a blowup center, the even degeneracy locus
is not met once the section class is shifted by at least one fibre: the lengths
of the fibre class and of the shifted section class differ, so the two specialized
values have different valuations.  The statement holds for any strictly
Novikov-admissible specialization with that shift. -/
theorem centerSpecialization_fibre_ne_shiftedSection {Curve Target : Type*}
    [AddCommMonoid Curve] [CommRing Target] [IsDomain Target] [UniformSpace Target]
    [CompleteSpace Target] [T2Space Target] [IsTopologicalRing Target]
    (specialization : Quantum.StrictNovikovAdmissible (Curve := Curve) (Target := Target))
    {fibre sectionClass : Curve} (fibreNonzero : fibre ≠ 0) (sectionNonzero : sectionClass ≠ 0)
    {shift : ℕ} (positiveShift : 0 < shift) :
    specialization.monomialImage fibre
      ≠ specialization.monomialImage (sectionClass + shift • fibre) :=
  specialization.fibre_ne_shiftedSection fibreNonzero sectionNonzero positiveShift
/-- For a specialization attached to a blowup center, the odd degeneracy locus is
not met once the section class is shifted by at least one fibre: the fibre value
and the square of the shifted-section value have different valuations, so no
combination of them with unit coefficients vanishes.  The statement holds for any
strictly Novikov-admissible specialization with that shift. -/
theorem centerSpecialization_oddCombination_ne_zero {Curve Target : Type*}
    [AddCommMonoid Curve] [CommRing Target] [IsDomain Target] [UniformSpace Target]
    [CompleteSpace Target] [T2Space Target] [IsTopologicalRing Target]
    (specialization : Quantum.StrictNovikovAdmissible (Curve := Curve) (Target := Target))
    {fibre sectionClass : Curve} (fibreNonzero : fibre ≠ 0) (sectionNonzero : sectionClass ≠ 0)
    {shift : ℕ} (positiveShift : 0 < shift)
    {coefficientFibre coefficientSection : Target}
    (fibreUnit : IsUnit coefficientFibre) (sectionUnit : IsUnit coefficientSection) :
    coefficientFibre * specialization.monomialImage fibre
        + coefficientSection * specialization.monomialImage (sectionClass + shift • fibre) ^ 2
      ≠ 0 :=
  specialization.oddCombination_ne_zero fibreNonzero sectionNonzero positiveShift fibreUnit
    sectionUnit
/-- Reviewer-facing name for the bundle of leading-term data a graded-monomial
specialization must supply: a leading-term map, a linearly independent family of
monomials of the graded target, and a leading term in that family for every
effective class.  Nothing here is verified by Lean; the bundle is a
hypothesis. -/
def monomialSpecializationData {Curve Target Index Graded : Type*}
    [AddCommMonoid Curve] [CommRing Target] [AddCommGroup Graded] [Module ℂ Graded]
    (leadingTerm : Target → Graded) (monomialImage : Curve → Target)
    (monomial : Index → Graded) : Type _ :=
  Quantum.MonomialSpecializationData leadingTerm monomialImage monomial
/-- A supplied additive exponent map gives a coefficient-one monomial map from
center degrees to the additive-monoid algebra on the target exponents.  The
resulting data certify that the canonical target monomials are linearly
independent and that every center degree has its prescribed monomial as leading
term.  No geometric center specialization or associated-graded identification
is asserted. -/
noncomputable def centerMonomialSpecializationData_of_exponentMap
    {CenterDegree TargetExponent : Type*}
    [AddCommMonoid CenterDegree] [AddCommMonoid TargetExponent]
    (exponent : CenterDegree →+ TargetExponent) :
    Quantum.MonomialSpecializationData
      (leadingTerm := id)
      (monomialImage := Quantum.centerMonomialImage exponent)
      (monomial := fun target : TargetExponent =>
        AddMonoidAlgebra.single target (1 : ℂ)) :=
  Quantum.centerMonomialMap_monomialSpecializationData exponent
/-- Under the coefficient-one monomial map supplied by an additive exponent
map, addition of center degrees becomes multiplication of target monomials. -/
theorem centerMonomialImage_add_of_exponentMap
    {CenterDegree TargetExponent : Type*}
    [AddCommMonoid CenterDegree] [AddCommMonoid TargetExponent]
    (exponent : CenterDegree →+ TargetExponent)
    (left right : CenterDegree) :
    Quantum.centerMonomialImage exponent (left + right) =
      Quantum.centerMonomialImage exponent left *
        Quantum.centerMonomialImage exponent right :=
  Quantum.centerMonomialImage_add exponent left right
/-- The odd degeneracy locus is not met by a graded-monomial specialization.  The
premise is that the leading term of the combination is the corresponding
combination of two members of a linearly independent family of monomials of the
associated graded ring; the coefficients `256` and `27` are positive, so their
sum does not vanish and the combination cannot.  The argument is independent of
any shift, since no curve class enters the statement. -/
theorem monomialSpecialization_oddCombination_ne_zero {Index Graded Target : Type*}
    [AddCommGroup Graded] [Module ℂ Graded] [CommRing Target]
    (leadingTerm : Target → Graded) (leadingTerm_zero : leadingTerm 0 = 0)
    {monomial : Index → Graded} (independent : LinearIndependent ℂ monomial)
    {first second : Index} {fibreValue sectionValue : Target}
    (leading : leadingTerm (256 * fibreValue + 27 * sectionValue ^ 2)
      = (256 : ℂ) • monomial first + (27 : ℂ) • monomial second) :
    256 * fibreValue + 27 * sectionValue ^ 2 ≠ 0 :=
  Quantum.oddCombination_ne_zero_of_monomialLeadingTerms leadingTerm leadingTerm_zero
    independent leading
/-- Reviewer-facing invariance of a framed monodromy matrix under a scalar
twist of the solution frame that one turn of the loop coordinate fixes.  This
is the algebraic step behind the bulk shift by a multiple of the identity
class, where the string equation makes the shifted connection differ by the
scalar irregular twist and that twist is single-valued on the original loop
disc.  Lean constructs no quantum connection, no exponential, and no solution
of a differential equation: the solution algebra is an abstract commutative
ring, the turn is a ring automorphism of it, single-valuedness is the
hypothesis that the turn fixes the scalar, and the frame relation defining the
monodromy of a frame is a hypothesis. -/
theorem invariantScalarTwist_framedMonodromy_eq
    {SolutionAlgebra Constant Index : Type*}
    [CommRing SolutionAlgebra] [CommRing Constant] [Algebra Constant SolutionAlgebra]
    [Fintype Index] [DecidableEq Index]
    (turn : SolutionAlgebra ≃+* SolutionAlgebra)
    (frame : (Matrix Index Index SolutionAlgebra)ˣ)
    (twist : SolutionAlgebraˣ) (invariant : turn twist.val = twist.val)
    (monodromy twistedMonodromy : Matrix Index Index Constant)
    (constantsInjective : Function.Injective (algebraMap Constant SolutionAlgebra))
    (frameTurn : frame.val.map turn =
      frame.val * monodromy.map (algebraMap Constant SolutionAlgebra))
    (twistedTurn : (twist.val • frame.val).map turn =
      (twist.val • frame.val) * twistedMonodromy.map (algebraMap Constant SolutionAlgebra)) :
    twistedMonodromy = monodromy :=
  Quantum.framedMonodromy_eq_of_invariant_scalarTwist turn frame twist invariant monodromy
    twistedMonodromy constantsInjective frameTurn twistedTurn
/-- Reviewer-facing invariance of primitive-sixth multiplicity under the bulk
shift by a divisor class.  The divisor equation makes the shifted connection
the image of the original one under the coefficient substitution that
multiplies the Novikov monomial of a curve class by the character value there,
so the shifted framed characteristic polynomial is the image of the original.
An injective substitution preserves the algebraic multiplicity of every root it
fixes, and a substitution fixing the complex numbers fixes both primitive sixth
roots of unity, so the primitive-sixth multiplicity is unchanged.  The
comparison of the two monodromy matrices up to an invertible frame gauge is a
supplied datum; no quantum connection or divisor equation is constructed. -/
theorem divisorSubstitution_sixthMultiplicity_eq
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (input : Quantum.FormalBaseShiftMatrixInput Index ℂ)
    (injective : Function.Injective input.divisorSubstitution)
    (fixesPositive : input.divisorSubstitution Quantum.primitiveSixthRootPositive =
      Quantum.primitiveSixthRootPositive)
    (fixesNegative : input.divisorSubstitution Quantum.primitiveSixthRootNegative =
      Quantum.primitiveSixthRootNegative) :
    Quantum.sixthMultiplicityPolynomial input.bulkMonodromy.charpoly =
      Quantum.sixthMultiplicityPolynomial input.smallMonodromy.charpoly :=
  Quantum.sixthMultiplicity_eq_of_divisorShift input injective fixesPositive fixesNegative

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
