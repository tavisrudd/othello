import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.NumericalNovikovCompletion

/-!
# Numerical descent of coefficient operations

For a surjective finite-degree quotient of effective additive monoids, this
module formalizes two algebraic operations used in numerical Novikov base
change.

First, a finite homological coefficient packet constant on numerical fibers
descends to one numerical coefficient per class; fiberwise summation of the
original packet is the descended coefficient multiplied by the finite fiber
cardinality.  A weighted finite packet also descends when both its coefficient
and its weight depend only on the numerical class.

Second, a logarithmic Novikov operator multiplies each coefficient by an
additive scalar weight.  Lean packages it as an additive homomorphism and
proves its Leibniz rule for completed convolution.  When the weight factors
through the numerical quotient, completed numerical pushforward commutes with
the operator.

These results isolate the finite-sum and derivation algebra in the manuscript.
They do not construct Gromov--Witten invariants, prove their deformation or
numerical invariance, define a quantum product or connection, construct curve
pushforward or normal-bundle pairings, or formalize the comparison isomorphisms.
All proofs are symbolic and kernel checked, with no external computation or
oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open scoped BigOperators

variable {Homology Numerical Coefficient : Type*}

namespace CompletedNumericalQuotient

variable [AddCommMonoid Homology] [AddCommMonoid Numerical]

/-- A homological coefficient function is numerically invariant when equal
numerical classes have equal coefficients. -/
def NumericallyInvariant
    (data : CompletedNumericalQuotient Homology Numerical)
    (coefficient : Homology → Coefficient) : Prop :=
  ∀ left right, data.quotient left = data.quotient right →
    coefficient left = coefficient right

/-- A numerically invariant coefficient function descends uniquely along the
surjective numerical quotient. -/
noncomputable def descendedCoefficient
    (data : CompletedNumericalQuotient Homology Numerical)
    (coefficient : Homology → Coefficient) : Numerical → Coefficient :=
  fun numerical ↦ coefficient (Classical.choose (data.quotient_surjective numerical))

/-- Evaluation of the descended coefficient on a quotient class recovers the
original coefficient. -/
theorem descendedCoefficient_quotient
    (data : CompletedNumericalQuotient Homology Numerical)
    (coefficient : Homology → Coefficient)
    (invariant : data.NumericallyInvariant coefficient)
    (homological : Homology) :
    data.descendedCoefficient coefficient (data.quotient homological) =
      coefficient homological := by
  apply invariant
  exact Classical.choose_spec
    (data.quotient_surjective (data.quotient homological))

/-- A finite packet of numerically invariant coefficients factors through the
numerical quotient term by term. -/
theorem finite_sum_descends
    (data : CompletedNumericalQuotient Homology Numerical)
    [AddCommMonoid Coefficient]
    (packet : Finset Homology) (coefficient : Homology → Coefficient)
    (invariant : data.NumericallyInvariant coefficient) :
    ∑ homological ∈ packet, coefficient homological =
      ∑ homological ∈ packet,
        data.descendedCoefficient coefficient (data.quotient homological) := by
  apply Finset.sum_congr rfl
  intro homological _
  rw [data.descendedCoefficient_quotient coefficient invariant homological]

/-- Summation over one exact numerical fiber is multiplication of the
descended coefficient by the fiber cardinality. -/
theorem fiber_sum_eq_card_nsmul_descendedCoefficient
    (data : CompletedNumericalQuotient Homology Numerical)
    [AddCommMonoid Coefficient]
    (coefficient : Homology → Coefficient)
    (invariant : data.NumericallyInvariant coefficient)
    (numerical : Numerical) :
    ∑ homological ∈ data.coefficientData.fiber numerical,
        coefficient homological =
      (data.coefficientData.fiber numerical).card •
        data.descendedCoefficient coefficient numerical := by
  obtain ⟨representative, representative_image⟩ :=
    data.quotient_surjective numerical
  subst numerical
  rw [Finset.sum_eq_card_nsmul]
  intro homological homological_mem
  rw [data.descendedCoefficient_quotient coefficient invariant representative]
  apply invariant
  exact (data.coefficientData.mem_fiber_iff homological
    (data.quotient representative)).mp homological_mem

/-- Weighted finite coefficient sums descend when both the coefficient and the
weight are numerically invariant. -/
theorem finite_weighted_sum_descends
    (data : CompletedNumericalQuotient Homology Numerical)
    [CommSemiring Coefficient]
    (packet : Finset Homology)
    (coefficient weight : Homology → Coefficient)
    (coefficient_invariant : data.NumericallyInvariant coefficient)
    (weight_invariant : data.NumericallyInvariant weight) :
    ∑ homological ∈ packet, weight homological * coefficient homological =
      ∑ homological ∈ packet,
        data.descendedCoefficient weight (data.quotient homological) *
          data.descendedCoefficient coefficient (data.quotient homological) := by
  apply Finset.sum_congr rfl
  intro homological _
  rw [data.descendedCoefficient_quotient weight weight_invariant homological,
    data.descendedCoefficient_quotient coefficient coefficient_invariant homological]

/-- Coefficientwise logarithmic Novikov operator associated to a scalar weight
on effective classes. -/
noncomputable def logarithmicOperator
    (grading : FiniteDegreeAddCommMonoid Homology) [CommRing Coefficient]
    (weight : Homology →+ Coefficient)
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing grading Coefficient) :
    FiniteDegreeAddCommMonoid.CompletedNovikovRing grading Coefficient where
  coefficient homological := weight homological * series.coefficient homological
  finite_below cutoff := (series.finite_below cutoff).subset <| by
    intro homological membership
    exact ⟨by
      intro coefficient_zero
      exact membership.1 (by simp [coefficient_zero]), membership.2⟩

/-- The coefficient of the logarithmic operator is weight times coefficient. -/
theorem logarithmicOperator_coefficient
    (grading : FiniteDegreeAddCommMonoid Homology) [CommRing Coefficient]
    (weight : Homology →+ Coefficient)
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing grading Coefficient)
    (homological : Homology) :
    (logarithmicOperator grading weight series).coefficient homological =
      weight homological * series.coefficient homological :=
  rfl

/-- For a fixed additive weight, the coefficientwise logarithmic operator is
an additive homomorphism on the completed coefficient ring. -/
noncomputable def logarithmicOperatorAddHom
    (grading : FiniteDegreeAddCommMonoid Homology) [CommRing Coefficient]
    (weight : Homology →+ Coefficient) :
    FiniteDegreeAddCommMonoid.CompletedNovikovRing grading Coefficient →+
      FiniteDegreeAddCommMonoid.CompletedNovikovRing grading Coefficient where
  toFun := logarithmicOperator grading weight
  map_zero' := by
    apply CompletedNovikovSeries.ext
    funext homological
    simp [logarithmicOperator_coefficient]
  map_add' left right := by
    apply CompletedNovikovSeries.ext
    funext homological
    simp [logarithmicOperator_coefficient, mul_add]

/-- Evaluation of the additive logarithmic operator is multiplication of the
coefficient by the supplied additive weight. -/
theorem logarithmicOperatorAddHom_apply
    (grading : FiniteDegreeAddCommMonoid Homology) [CommRing Coefficient]
    (weight : Homology →+ Coefficient)
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing grading Coefficient) :
    logarithmicOperatorAddHom grading weight series =
      logarithmicOperator grading weight series :=
  rfl

/-- The coefficientwise operator associated to an additive logarithmic weight
satisfies the Leibniz rule for completed convolution. -/
theorem logarithmicOperator_convolution
    (grading : FiniteDegreeAddCommMonoid Homology) [CommRing Coefficient]
    (weight : Homology →+ Coefficient)
    (left right : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      grading Coefficient) :
    logarithmicOperator grading weight (grading.convolution left right) =
      grading.convolution (logarithmicOperator grading weight left) right +
        grading.convolution left (logarithmicOperator grading weight right) := by
  apply CompletedNovikovSeries.ext
  funext total
  rw [logarithmicOperator_coefficient,
    FiniteDegreeAddCommMonoid.convolution_coefficient,
    Finset.mul_sum]
  change _ =
    (grading.convolution (logarithmicOperator grading weight left) right).coefficient total +
      (grading.convolution left
        (logarithmicOperator grading weight right)).coefficient total
  rw [FiniteDegreeAddCommMonoid.convolution_coefficient,
    FiniteDegreeAddCommMonoid.convolution_coefficient,
    ← Finset.sum_add_distrib]
  simp only [logarithmicOperator_coefficient]
  apply Finset.sum_congr rfl
  intro pair pair_mem
  have decomposition := (grading.mem_decompositions_iff pair total).mp pair_mem
  rw [← decomposition, map_add]
  ring

/-- Numerical completed pushforward commutes with a logarithmic Novikov
operator whenever the scalar weight factors through the numerical quotient. -/
theorem completedPushforward_logarithmicOperator
    (data : CompletedNumericalQuotient Homology Numerical)
    [CommRing Coefficient]
    (numericalWeight : Numerical →+ Coefficient)
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading Coefficient) :
    data.completedPushforward
        (logarithmicOperator data.homologicalGrading
          (numericalWeight.comp data.quotient) series) =
      logarithmicOperator data.numericalGrading numericalWeight
        (data.completedPushforward series) := by
  apply CompletedNovikovSeries.ext
  funext numerical
  rw [logarithmicOperator_coefficient, completedPushforward,
    NumericallyFiniteEffectiveQuotient.completedCoefficientPushforward_apply,
    completedPushforward,
    NumericallyFiniteEffectiveQuotient.completedCoefficientPushforward_apply]
  simp only [logarithmicOperator_coefficient]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro homological homological_mem
  have quotient_eq := (data.coefficientData.mem_fiber_iff homological numerical).mp
    homological_mem
  change data.quotient homological = numerical at quotient_eq
  change numericalWeight (data.quotient homological) * series.coefficient homological = _
  rw [quotient_eq]

end CompletedNumericalQuotient

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
