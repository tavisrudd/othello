import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.NumericalNovikov
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CompletedNovikovSupport
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CompletedNovikovConvolution

/-!
# Numerical pushforward on completed Novikov coefficient families

Let a homomorphism from an effective homology monoid to an effective numerical
monoid preserve a natural-number degree, and suppose every bounded homological
degree set is finite.  This module proves that coefficientwise summation over
the exact finite fibers sends completed homological coefficient families to
completed numerical coefficient families.

This is the completed-ring extension appearing in the numerical Novikov
base-change lemma.  The formal quotient is surjective onto the numerical monoid;
the completed pushforward is proved to commute with every finite truncation and
to be a unital ring homomorphism.  No topology or inverse-limit object is
represented, so continuity as a topological statement is not asserted.  The
module also does not construct quantum products, Gromov--Witten invariants,
Novikov derivations, or the Iritani comparison maps and their inverses.  All
proofs are symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open scoped BigOperators

variable {Homology Numerical R : Type*}

/-- A surjective quotient between finite-degree effective additive monoids,
with exact compatibility of the two additive degree functions.  Surjectivity
encodes that the numerical monoid is the image of the homological monoid. -/
structure CompletedNumericalQuotient
    (Homology Numerical : Type*) [AddCommMonoid Homology]
    [AddCommMonoid Numerical] where
  homologicalGrading : FiniteDegreeAddCommMonoid Homology
  numericalGrading : FiniteDegreeAddCommMonoid Numerical
  quotient : Homology →+ Numerical
  quotient_surjective : Function.Surjective quotient
  degree_compatible : numericalGrading.degree.comp quotient =
    homologicalGrading.degree

namespace CompletedNumericalQuotient

variable [AddCommMonoid Homology] [AddCommMonoid Numerical]

/-- The underlying finite-fiber coefficient-pushforward data. -/
def coefficientData
    (data : CompletedNumericalQuotient Homology Numerical) :
    NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical) where
  quotient := data.quotient
  homologicalDegree := data.homologicalGrading.degree
  numericalDegree := data.numericalGrading.degree
  degree_compatible homological := DFunLike.congr_fun data.degree_compatible homological
  bounded_homological := data.homologicalGrading.finite_bounded

/-- Degree compatibility evaluated on one homological class. -/
theorem degree_compatible_apply
    (data : CompletedNumericalQuotient Homology Numerical)
    (homological : Homology) :
    data.numericalGrading.degree (data.quotient homological) =
      data.homologicalGrading.degree homological :=
  DFunLike.congr_fun data.degree_compatible homological

end CompletedNumericalQuotient

namespace NumericallyFiniteEffectiveQuotient

variable [AddCommMonoid Homology] [AddCommMonoid Numerical]

/-- Numerical coefficient pushforward preserves the completion support
condition: below a numerical degree cutoff, a nonzero output coefficient can
occur only in the finite image of the bounded homological set. -/
noncomputable def completedCoefficientPushforward
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    [AddCommGroup R]
    (series : CompletedNovikovSeries Homology R data.homologicalDegree) :
    CompletedNovikovSeries Numerical R data.numericalDegree where
  coefficient := data.coefficientPushforward series.coefficient
  finite_below cutoff := by
    classical
    refine ((data.bounded_homological cutoff).toFinset.image
      data.quotient).finite_toSet.subset ?_
    intro numerical membership
    rcases membership with ⟨coefficient_nonzero, degree_le⟩
    by_contra numerical_not_image
    apply coefficient_nonzero
    rw [data.coefficientPushforward_apply]
    apply Finset.sum_eq_zero
    intro homological homological_mem
    by_contra homological_nonzero
    apply numerical_not_image
    apply Finset.mem_image.mpr
    refine ⟨homological, ?_, ?_⟩
    · simpa only [Set.Finite.mem_toFinset, Set.mem_setOf_eq] using (show
        data.homologicalDegree homological ≤ cutoff by
        rw [← data.degree_compatible homological,
          (data.mem_fiber_iff homological numerical).mp homological_mem]
        exact degree_le)
    · exact (data.mem_fiber_iff homological numerical).mp homological_mem

/-- The completed numerical coefficient has the exact finite-fiber formula. -/
theorem completedCoefficientPushforward_apply
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    [AddCommGroup R]
    (series : CompletedNovikovSeries Homology R data.homologicalDegree)
    (numerical : Numerical) :
    (data.completedCoefficientPushforward series).coefficient numerical =
      ∑ homological ∈ data.fiber numerical, series.coefficient homological :=
  rfl

/-- Additivity of completed numerical coefficient pushforward. -/
theorem completedCoefficientPushforward_add
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    [AddCommGroup R]
    (left right : CompletedNovikovSeries Homology R data.homologicalDegree) :
    data.completedCoefficientPushforward (left + right) =
      data.completedCoefficientPushforward left +
        data.completedCoefficientPushforward right := by
  apply CompletedNovikovSeries.ext
  exact data.coefficientPushforward.map_add left.coefficient right.coefficient

/-- Coefficient-filtration compatibility: agreement of two homological
families through a degree cutoff implies agreement of their numerical
pushforwards through the same cutoff.  This is the exact finite-level property
used by the inverse-limit argument, without introducing a topology or an
inverse-limit object. -/
theorem completedCoefficientPushforward_eq_below_of_eq_below
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    [AddCommGroup R]
    (left right : CompletedNovikovSeries Homology R data.homologicalDegree)
    (cutoff : ℕ)
    (equal_below : ∀ homological,
      data.homologicalDegree homological ≤ cutoff →
        left.coefficient homological = right.coefficient homological) :
    ∀ numerical, data.numericalDegree numerical ≤ cutoff →
      (data.completedCoefficientPushforward left).coefficient numerical =
        (data.completedCoefficientPushforward right).coefficient numerical := by
  intro numerical numerical_below
  rw [data.completedCoefficientPushforward_apply,
    data.completedCoefficientPushforward_apply]
  apply Finset.sum_congr rfl
  intro homological homological_mem
  apply equal_below homological
  rw [← data.degree_compatible homological,
    (data.mem_fiber_iff homological numerical).mp homological_mem]
  exact numerical_below

end NumericallyFiniteEffectiveQuotient

namespace CompletedNumericalQuotient

variable [AddCommMonoid Homology] [AddCommMonoid Numerical]

/-- Completed numerical coefficient pushforward attached to a surjective
finite-degree quotient. -/
noncomputable def completedPushforward
    (data : CompletedNumericalQuotient Homology Numerical) [CommRing R]
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading R) :
    FiniteDegreeAddCommMonoid.CompletedNovikovRing data.numericalGrading R :=
  data.coefficientData.completedCoefficientPushforward series

/-- The coefficient of ordinary additive-monoid-algebra pushforward is the sum
over the exact finite numerical fiber. -/
theorem mapDomain_apply_eq_fiber_sum
    (data : CompletedNumericalQuotient Homology Numerical) [CommRing R]
    (series : AddMonoidAlgebra R Homology) (numerical : Numerical) :
    AddMonoidAlgebra.mapDomain data.quotient series numerical =
      ∑ homological ∈ data.coefficientData.fiber numerical, series homological := by
  classical
  obtain ⟨representative, representative_image⟩ :=
    data.quotient_surjective numerical
  subst numerical
  change (Finsupp.mapDomain data.quotient series.coeff)
      (data.quotient representative) = _
  rw [Finsupp.mapDomain_apply_eq_sum]
  apply Finset.sum_subset
  · intro homological homological_mem
    exact (data.coefficientData.mem_fiber_iff homological
      (data.quotient representative)).mpr (Finset.mem_filter.mp homological_mem).2
  · intro homological homological_mem homological_not_mem
    by_contra coefficient_nonzero
    apply homological_not_mem
    exact Finset.mem_filter.mpr ⟨Finsupp.mem_support_iff.mpr coefficient_nonzero,
      (data.coefficientData.mem_fiber_iff homological
        (data.quotient representative)).mp homological_mem⟩

/-- Finite truncation commutes exactly with numerical pushforward: the
truncation of the completed fiber sum is the ordinary additive-monoid-algebra
map induced by the quotient on the homological truncation. -/
theorem truncation_completedPushforward
    (data : CompletedNumericalQuotient Homology Numerical) [CommRing R]
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading R)
    (cutoff : ℕ) :
    data.numericalGrading.truncation
        (data.completedPushforward series) cutoff =
      AddMonoidAlgebra.mapDomain data.quotient
        (data.homologicalGrading.truncation series cutoff) := by
  classical
  ext numerical
  obtain ⟨homological, homological_image⟩ := data.quotient_surjective numerical
  subst numerical
  change
    (data.numericalGrading.truncation
      (data.completedPushforward series) cutoff) (data.quotient homological) =
      (Finsupp.mapDomain data.quotient
        (AddMonoidAlgebra.coeff
          (data.homologicalGrading.truncation series cutoff)))
        (data.quotient homological)
  rw [Finsupp.mapDomain_apply_eq_sum]
  by_cases target_below :
      data.numericalGrading.degree (data.quotient homological) ≤ cutoff
  · rw [data.numericalGrading.truncation_apply_of_degree_le _ _ _ target_below,
      completedPushforward,
      NumericallyFiniteEffectiveQuotient.completedCoefficientPushforward_apply]
    let sourceTruncation :=
      AddMonoidAlgebra.coeff
        (data.homologicalGrading.truncation series cutoff)
    let sourceFiber := data.coefficientData.fiber (data.quotient homological)
    have source_degree_below : ∀ source ∈ sourceFiber,
        data.homologicalGrading.degree source ≤ cutoff := by
      intro source source_mem
      rw [← data.degree_compatible_apply source]
      have source_image := (data.coefficientData.mem_fiber_iff source
        (data.quotient homological)).mp source_mem
      change data.quotient source = data.quotient homological at source_image
      rw [source_image]
      exact target_below
    symm
    calc
      ∑ source ∈ sourceTruncation.support with
          data.quotient source = data.quotient homological,
          sourceTruncation source =
        ∑ source ∈ sourceTruncation.support with
          data.quotient source = data.quotient homological,
          series.coefficient source := by
            apply Finset.sum_congr rfl
            intro source source_mem
            exact data.homologicalGrading.truncation_apply_of_degree_le
              series cutoff source <| source_degree_below source <|
                (data.coefficientData.mem_fiber_iff source
                  (data.quotient homological)).mpr
                  (Finset.mem_filter.mp source_mem).2
      _ = ∑ source ∈ sourceFiber, series.coefficient source := by
        apply Finset.sum_subset
        · intro source source_mem
          exact (data.coefficientData.mem_fiber_iff source
            (data.quotient homological)).mpr
            (Finset.mem_filter.mp source_mem).2
        · intro source source_mem source_not_mem
          by_contra source_nonzero
          apply source_not_mem
          apply Finset.mem_filter.mpr
          refine ⟨Finsupp.mem_support_iff.mpr ?_,
            (data.coefficientData.mem_fiber_iff source
              (data.quotient homological)).mp source_mem⟩
          change (data.homologicalGrading.truncation series cutoff) source ≠ 0
          rw [data.homologicalGrading.truncation_apply_of_degree_le
            series cutoff source (source_degree_below source source_mem)]
          exact source_nonzero
  · have source_above : ∀ source,
        data.quotient source = data.quotient homological →
        ¬ data.homologicalGrading.degree source ≤ cutoff := by
      intro source source_image source_below
      apply target_below
      rw [← source_image, data.degree_compatible_apply]
      exact source_below
    rw [data.numericalGrading.truncation_apply_of_degree_not_le
      _ cutoff _ target_below]
    symm
    apply Finset.sum_eq_zero
    intro source source_mem
    change (data.homologicalGrading.truncation series cutoff) source = 0
    rw [data.homologicalGrading.truncation_apply_of_degree_not_le
      series cutoff source (source_above source (Finset.mem_filter.mp source_mem).2)]

/-- Completed numerical pushforward preserves convolution. -/
theorem completedPushforward_convolution
    (data : CompletedNumericalQuotient Homology Numerical) [CommRing R]
    (left right : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading R) :
    data.completedPushforward (data.homologicalGrading.convolution left right) =
      data.numericalGrading.convolution
        (data.completedPushforward left) (data.completedPushforward right) := by
  apply CompletedNovikovSeries.ext
  funext numerical
  let cutoff := data.numericalGrading.degree numerical
  have numerical_below : data.numericalGrading.degree numerical ≤ cutoff := le_rfl
  calc
    (data.completedPushforward
        (data.homologicalGrading.convolution left right)).coefficient numerical =
        data.numericalGrading.truncation
          (data.completedPushforward
            (data.homologicalGrading.convolution left right)) cutoff numerical :=
      (data.numericalGrading.truncation_apply_of_degree_le _ _ _ numerical_below).symm
    _ = AddMonoidAlgebra.mapDomain data.quotient
          (data.homologicalGrading.truncation
            (data.homologicalGrading.convolution left right) cutoff) numerical := by
      rw [data.truncation_completedPushforward]
    _ = AddMonoidAlgebra.mapDomain data.quotient
          (data.homologicalGrading.truncation left cutoff *
            data.homologicalGrading.truncation right cutoff) numerical := by
      rw [data.mapDomain_apply_eq_fiber_sum,
        data.mapDomain_apply_eq_fiber_sum]
      apply Finset.sum_congr rfl
      intro homological homological_mem
      apply data.homologicalGrading.truncation_convolution_apply_of_degree_le
      rw [← data.degree_compatible_apply homological]
      have homological_image := (data.coefficientData.mem_fiber_iff homological numerical).mp
        homological_mem
      change data.quotient homological = numerical at homological_image
      rw [homological_image]
    _ = (AddMonoidAlgebra.mapDomain data.quotient
            (data.homologicalGrading.truncation left cutoff) *
          AddMonoidAlgebra.mapDomain data.quotient
            (data.homologicalGrading.truncation right cutoff)) numerical := by
      rw [AddMonoidAlgebra.mapDomain_mul]
    _ = (data.numericalGrading.truncation
            (data.completedPushforward left) cutoff *
          data.numericalGrading.truncation
            (data.completedPushforward right) cutoff) numerical := by
      rw [data.truncation_completedPushforward,
        data.truncation_completedPushforward]
    _ = (data.numericalGrading.convolution
          (data.completedPushforward left)
          (data.completedPushforward right)).coefficient numerical := by
      rw [← data.numericalGrading.truncation_convolution_apply_of_degree_le
        _ _ cutoff numerical numerical_below,
        data.numericalGrading.truncation_apply_of_degree_le _ _ _ numerical_below]

/-- Completed numerical pushforward is a unital ring homomorphism. -/
noncomputable def completedPushforwardRingHom
    (data : CompletedNumericalQuotient Homology Numerical) [CommRing R] :
    FiniteDegreeAddCommMonoid.CompletedNovikovRing data.homologicalGrading R →+*
      FiniteDegreeAddCommMonoid.CompletedNovikovRing data.numericalGrading R where
  toFun := data.completedPushforward
  map_zero' := by
    apply CompletedNovikovSeries.ext
    exact data.coefficientData.coefficientPushforward.map_zero
  map_add' := data.coefficientData.completedCoefficientPushforward_add
  map_one' := by
    apply CompletedNovikovSeries.ext
    funext numerical
    let cutoff := data.numericalGrading.degree numerical
    have numerical_below : data.numericalGrading.degree numerical ≤ cutoff := le_rfl
    calc
      (data.completedPushforward
          (1 : FiniteDegreeAddCommMonoid.CompletedNovikovRing
            data.homologicalGrading R)).coefficient numerical =
          data.numericalGrading.truncation
            (data.completedPushforward
              (1 : FiniteDegreeAddCommMonoid.CompletedNovikovRing
                data.homologicalGrading R)) cutoff numerical :=
        (data.numericalGrading.truncation_apply_of_degree_le _ _ _ numerical_below).symm
      _ = AddMonoidAlgebra.mapDomain data.quotient
            (data.homologicalGrading.truncation
              (1 : FiniteDegreeAddCommMonoid.CompletedNovikovRing
                data.homologicalGrading R) cutoff) numerical := by
        rw [data.truncation_completedPushforward]
      _ = (1 : AddMonoidAlgebra R Numerical) numerical := by
        rw [FiniteDegreeAddCommMonoid.CompletedNovikovRing.one_def,
          data.homologicalGrading.truncation_convolutionUnit,
          AddMonoidAlgebra.mapDomain_one]
      _ = data.numericalGrading.truncation
            (data.numericalGrading.convolutionUnit (Coefficient := R))
            cutoff numerical := by
        rw [data.numericalGrading.truncation_convolutionUnit]
      _ = (data.numericalGrading.convolutionUnit (Coefficient := R)).coefficient numerical :=
        data.numericalGrading.truncation_apply_of_degree_le _ _ _ numerical_below
      _ = (1 : FiniteDegreeAddCommMonoid.CompletedNovikovRing
            data.numericalGrading R).coefficient numerical := rfl
  map_mul' := by
    intro left right
    rw [FiniteDegreeAddCommMonoid.CompletedNovikovRing.mul_def,
      FiniteDegreeAddCommMonoid.CompletedNovikovRing.mul_def]
    exact data.completedPushforward_convolution left right

end CompletedNumericalQuotient

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
