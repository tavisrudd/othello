import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.GradedBulkSubring

/-!
# Faithful ring maps on the full graded bulk source

The raw formal coefficient-family model and the graded completed polynomial
subring are equivalent, coefficient by coefficient. Polynomiality is derived
from grading bounds, so this equivalence imposes no additional finite-support
restriction. The center map is a unital ring homomorphism on the subring,
using its actual completed convolution. It agrees with the original formal
coefficient-family map and is injective. Geometric QDM-base identifications
and coordinate comparison theorems remain external.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The formal-family model is equivalent to the actual graded completed
subring; both directions preserve every curve and bulk coefficient. -/
noncomputable def gradedCompletedBulkSource_equivSubring
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {rank : ℕ}
    (grading : FiniteDegreeAddCommMonoid Curve) (curveGrade : Curve →+ ℤ)
    (bulkDegree : Fin rank → ℕ) :
    GradedCompletedBulkSource (K := K) curveGrade bulkDegree ≃
      gradedCompletedBulkSubring (K := K) grading curveGrade bulkDegree where
  toFun source := ⟨gradedCompletedBulkSource_embedding grading source, source.property⟩
  invFun series := ⟨fun curve => (series.val.coefficient curve : MvPowerSeries (Option (Fin rank)) K),by
    obtain ⟨lower,upper,unit,bounded⟩ := series.property
    refine ⟨lower,upper,unit,?_⟩
    intro curve monomial h
    exact bounded curve monomial (by simpa only [MvPolynomial.coeff_coe] using h)⟩
  left_inv source := by
    apply Subtype.ext
    funext curve
    apply MvPowerSeries.ext
    intro monomial
    rfl
  right_inv series := by
    apply Subtype.ext
    apply CompletedNovikovSeries.ext
    funext curve
    apply MvPolynomial.ext
    intro monomial
    rfl

/-- The graded center map as an actual unital homomorphism on the completed
source subring, with its inherited completed convolution product. -/
noncomputable def gradedCompletedBulkCenterRingHom
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {bulkRank divisorRank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin bulkRank → ℕ)
    (pairing : Curve →+ (Fin divisorRank → ℤ)) (exceptionalDegree : Curve →+ ℤ)
    (parameter : FractionRing (MvPolynomial (Option (Fin bulkRank)) K)) (nonzero : parameter ≠ 0) :
    gradedCompletedBulkSubring (K := K) data.homologicalGrading curveGrade bulkDegree →+*
      data.numericalGrading.CompletedNovikovRing
        (MvPowerSeries (Fin divisorRank) (FractionRing (MvPolynomial (Option (Fin bulkRank)) K))) :=
  (completedExponentialRingHom data pairing (exceptionalMonomialCharacter exceptionalDegree parameter nonzero)).comp
    ((completedCoefficientExtensionRingHom data.homologicalGrading
      (algebraMap (MvPolynomial (Option (Fin bulkRank)) K) (FractionRing (MvPolynomial (Option (Fin bulkRank)) K)))).comp
        (gradedCompletedBulkSubring (K := K) data.homologicalGrading curveGrade bulkDegree).subtype)

/-- The ring map agrees coefficientwise with the original map on actual
formal graded families through the proved source equivalence. -/
theorem gradedCompletedBulkCenterRingHom_agrees
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {bulkRank divisorRank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin bulkRank → ℕ)
    (pairing : Curve →+ (Fin divisorRank → ℤ)) (exceptionalDegree : Curve →+ ℤ)
    (parameter : FractionRing (MvPolynomial (Option (Fin bulkRank)) K)) (nonzero : parameter ≠ 0)
    (source : GradedCompletedBulkSource (K := K) curveGrade bulkDegree) :
    gradedCompletedBulkCenterRingHom data curveGrade bulkDegree pairing exceptionalDegree parameter nonzero
      (gradedCompletedBulkSource_equivSubring data.homologicalGrading curveGrade bulkDegree source)=
        gradedCompletedBulkCenterMap data curveGrade bulkDegree pairing exceptionalDegree parameter nonzero source := rfl

/-- The center homomorphism on the full graded completed source ring is
injective, with polynomial coefficient finiteness and ring closure proved. -/
theorem gradedCompletedBulkCenterRingHom_injective
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {bulkRank divisorRank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin bulkRank → ℕ)
    (pairing : Curve →+ (Fin divisorRank → ℤ)) (injective : Function.Injective pairing)
    (exceptionalDegree : Curve →+ ℤ)
    (parameter : FractionRing (MvPolynomial (Option (Fin bulkRank)) K)) (nonzero : parameter ≠ 0) :
    Function.Injective (gradedCompletedBulkCenterRingHom data curveGrade bulkDegree pairing exceptionalDegree parameter nonzero) :=
  (completedExponentialRingHom_injective data pairing injective _
    (exceptionalMonomialCharacter_ne_zero exceptionalDegree parameter nonzero)).comp
      ((completedCoefficientExtensionRingHom_injective data.homologicalGrading _
        (IsFractionRing.injective _ _)).comp Subtype.val_injective)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
