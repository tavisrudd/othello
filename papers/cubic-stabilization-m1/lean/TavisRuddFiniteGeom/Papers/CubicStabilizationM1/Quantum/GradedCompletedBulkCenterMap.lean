import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.GradedBulkCoefficientFiniteness
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FaithfulCompletedExponentialRingMap
import Mathlib.RingTheory.Localization.FractionRing

/-!
# Faithful center maps on the graded bulk completion

The source consists of actual formal bulk coefficient families with a finite
range of total cohomological grades and a uniform polynomial unit bound.
Negative bulk powers may grow without a global bound as curve degree grows.
Polynomiality is derived separately at each curve class from those grading
bounds. This embeds the source into the completed Novikov ring with polynomial
coefficients, then into its fraction-field coefficient extension.

The center map uses the constructed divisor exponential, an exceptional
monomial weight, and the actual finite-fiber numerical pushforward. It is
injective, including after an actual target coordinate equivalence. Geometric
identification of these graded families and coordinate equivalences with QDM
bases remains external. The graded source is represented as a subtype of
coefficient families; its inherited ring closure is not asserted here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Finite total grading range and a bounded unit exponent for an entire
formal bulk coefficient family. Ample completion degree is separate from
this possibly signed cohomological curve grading. -/
def HasBoundedBulkGrading
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {bulkRank : ℕ}
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin bulkRank → ℕ)
    (family : Curve → MvPowerSeries (Option (Fin bulkRank)) K) : Prop :=
  ∃ lower upper : ℤ, ∃ unitBound : ℕ, ∀ curve monomial,
    MvPowerSeries.coeff monomial (family curve) ≠ 0 →
      lower ≤ curveGrade curve + (monomial none : ℤ) - weightedNegativeBulkDegree bulkDegree monomial ∧
      curveGrade curve + (monomial none : ℤ) - weightedNegativeBulkDegree bulkDegree monomial ≤ upper ∧
      monomial none ≤ unitBound

/-- The actual graded completed source, with formal negative bulk variables
and a uniformly polynomial unit variable. Bounds are properties, not extra
coordinates of the represented family. -/
abbrev GradedCompletedBulkSource
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {bulkRank : ℕ}
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin bulkRank → ℕ) :=
  {family : Curve → MvPowerSeries (Option (Fin bulkRank)) K //
    HasBoundedBulkGrading curveGrade bulkDegree family}

/-- Each curve layer of the graded source has finite monomial support,
without imposing a global bound on negative bulk exponents. -/
theorem gradedCompletedBulkSource_layer_finite
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {bulkRank : ℕ}
    {curveGrade : Curve →+ ℤ} {bulkDegree : Fin bulkRank → ℕ}
    (source : GradedCompletedBulkSource (K := K) curveGrade bulkDegree) (curve : Curve) :
    Set.Finite {monomial | MvPowerSeries.coeff monomial (source.val curve) ≠ 0} := by
  obtain ⟨lower,upper,unitBound,bounded⟩ := source.property
  exact gradedBulkPowerSeries_finite_support bulkDegree (curveGrade curve) lower unitBound
    (source.val curve) (fun monomial h => ⟨(bounded curve monomial h).2.2,(bounded curve monomial h).1⟩)

/-- The coefficient polynomial constructed from the actual graded formal layer. -/
noncomputable def gradedCompletedBulkSource_polynomial
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {bulkRank : ℕ}
    {curveGrade : Curve →+ ℤ} {bulkDegree : Fin bulkRank → ℕ}
    (source : GradedCompletedBulkSource (K := K) curveGrade bulkDegree) (curve : Curve) :
    MvPolynomial (Option (Fin bulkRank)) K :=
  Finsupp.ofSupportFinite (fun monomial => MvPowerSeries.coeff monomial (source.val curve))
    (gradedCompletedBulkSource_layer_finite source curve)

/-- Embed the entire graded bulk source into completed polynomial coefficient
families. Bounded ample degree gives finite curve support at every cutoff. -/
noncomputable def gradedCompletedBulkSource_embedding
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {bulkRank : ℕ}
    (grading : FiniteDegreeAddCommMonoid Curve)
    {curveGrade : Curve →+ ℤ} {bulkDegree : Fin bulkRank → ℕ}
    (source : GradedCompletedBulkSource (K := K) curveGrade bulkDegree) :
    grading.CompletedNovikovRing (MvPolynomial (Option (Fin bulkRank)) K) where
  coefficient := gradedCompletedBulkSource_polynomial source
  finite_below cutoff := (grading.finite_bounded cutoff).subset (fun _ h => h.2)

/-- The polynomial-layer embedding preserves every original formal
coefficient and is injective on the whole graded completed source. -/
theorem gradedCompletedBulkSource_embedding_injective
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {bulkRank : ℕ}
    (grading : FiniteDegreeAddCommMonoid Curve)
    {curveGrade : Curve →+ ℤ} {bulkDegree : Fin bulkRank → ℕ} :
    Function.Injective (gradedCompletedBulkSource_embedding (K := K) grading
      (curveGrade := curveGrade) (bulkDegree := bulkDegree)) := by
  intro left right equal
  apply Subtype.ext
  funext curve
  apply MvPowerSeries.ext
  intro monomial
  exact congrArg (fun s : grading.CompletedNovikovRing (MvPolynomial (Option (Fin bulkRank)) K) =>
    MvPolynomial.coeff monomial (s.coefficient curve)) equal

/-- Exceptional scalar monomials from a nonzero parameter and an additive
integral degree; negative exponents are allowed. -/
noncomputable def exceptionalMonomialCharacter
    {Curve F : Type*} [AddCommMonoid Curve] [Field F]
    (degree : Curve →+ ℤ) (parameter : F) (nonzero : parameter ≠ 0) : Multiplicative Curve →* F where
  toFun curve := parameter ^ degree curve.toAdd
  map_one' := by simp
  map_mul' left right := by simp [map_add, zpow_add₀ nonzero]

/-- The exceptional monomial weight is nonzero at every effective class. -/
theorem exceptionalMonomialCharacter_ne_zero
    {Curve F : Type*} [AddCommMonoid Curve] [Field F]
    (degree : Curve →+ ℤ) (parameter : F) (nonzero : parameter ≠ 0) (curve : Curve) :
    exceptionalMonomialCharacter degree parameter nonzero (.ofAdd curve) ≠ 0 :=
  zpow_ne_zero _ nonzero

/-- The concrete graded center map: polynomial-layer embedding, faithful
fraction-field extension, exceptional monomials and divisor exponentials,
then finite-fiber pushforward on actual completed series. -/
noncomputable def gradedCompletedBulkCenterMap
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {bulkRank divisorRank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin bulkRank → ℕ)
    (pairing : Curve →+ (Fin divisorRank → ℤ)) (exceptionalDegree : Curve →+ ℤ)
    (parameter : FractionRing (MvPolynomial (Option (Fin bulkRank)) K)) (nonzero : parameter ≠ 0)
    (source : GradedCompletedBulkSource (K := K) curveGrade bulkDegree) :
    data.numericalGrading.CompletedNovikovRing
      (MvPowerSeries (Fin divisorRank) (FractionRing (MvPolynomial (Option (Fin bulkRank)) K))) :=
  completedExponentialRingHom data pairing (exceptionalMonomialCharacter exceptionalDegree parameter nonzero)
    (completedCoefficientExtensionRingHom data.homologicalGrading
      (algebraMap (MvPolynomial (Option (Fin bulkRank)) K) (FractionRing (MvPolynomial (Option (Fin bulkRank)) K)))
      (gradedCompletedBulkSource_embedding data.homologicalGrading source))

/-- The actual map on the graded bulk completion is injective. The proof
derives polynomial coefficient finiteness from grading bounds and constructs
every intermediate coefficient map; source-map injectivity is not a premise. -/
theorem gradedCompletedBulkCenterMap_injective
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {bulkRank divisorRank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin bulkRank → ℕ)
    (pairing : Curve →+ (Fin divisorRank → ℤ)) (injective : Function.Injective pairing)
    (exceptionalDegree : Curve →+ ℤ)
    (parameter : FractionRing (MvPolynomial (Option (Fin bulkRank)) K)) (nonzero : parameter ≠ 0) :
    Function.Injective (gradedCompletedBulkCenterMap data curveGrade bulkDegree pairing exceptionalDegree parameter nonzero) :=
  (completedExponentialRingHom_injective data pairing injective _
    (exceptionalMonomialCharacter_ne_zero exceptionalDegree parameter nonzero)).comp
      ((completedCoefficientExtensionRingHom_injective data.homologicalGrading _
        (IsFractionRing.injective _ _)).comp
          (gradedCompletedBulkSource_embedding_injective data.homologicalGrading))

/-- An actual target coordinate equivalence, including one with nonconstant
formal translations, preserves the proved faithfulness of the graded center
map. Its inverse is part of the equivalence rather than a noncancellation
assumption for the center map. -/
theorem gradedCompletedBulkCenterMap_after_coordinateEquiv_injective
    {Curve TargetCurve K Target : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] [CommRing Target] {bulkRank divisorRank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin bulkRank → ℕ)
    (pairing : Curve →+ (Fin divisorRank → ℤ)) (injective : Function.Injective pairing)
    (exceptionalDegree : Curve →+ ℤ)
    (parameter : FractionRing (MvPolynomial (Option (Fin bulkRank)) K)) (nonzero : parameter ≠ 0)
    (coordinate : data.numericalGrading.CompletedNovikovRing
      (MvPowerSeries (Fin divisorRank) (FractionRing (MvPolynomial (Option (Fin bulkRank)) K))) ≃+* Target) :
    Function.Injective (fun source => coordinate
      (gradedCompletedBulkCenterMap data curveGrade bulkDegree pairing exceptionalDegree parameter nonzero source)) :=
  coordinate.injective.comp
    (gradedCompletedBulkCenterMap_injective data curveGrade bulkDegree pairing injective exceptionalDegree parameter nonzero)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
