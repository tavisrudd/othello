import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SemilinearVariation

/-!
# Projected variation from a scalar normal form

A direct source-facing input is a covector identity on the ambient trait
module:

`r (1 - T_j) (1 - T_i) = a lambda`.

If the scalar `a` specializes to zero, then the projected row vanishes on
`im (1 - T_i)`.  A one-sided can/variation factorization can prove this
identity from `v c = 1 - T_i` and `r (1 - T_j) v = a rho_P`.  No factorization
of `c v`, coverage of the full variation image, packet monodromy, or
vector-valued crossed coordinates are used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.VariationNormalFactor

open MonodromyImage ProjectedVariation

universe uR uk uV uP

variable
    {R : Type uR} [CommRing R]
    {k : Type uk} [CommRing k]
    {V : Type uV} {P : Type uP}
    [AddCommGroup V] [Module R V]
    [AddCommGroup P] [Module R P]

/-- A scalar normal form for the composite of the two ambient
identity-minus-monodromy operators as read by the marked covector. -/
structure AmbientCertificate
    (incoming target : V →ₗ[R] V) (row : V →ₗ[R] R) (normal : R) where
  referenceRow : V →ₗ[R] R
  directedRowNormalForm :
    (row.comp (defectOperator target)).comp (defectOperator incoming) =
      normal • referenceRow

/-- A one-sided can/variation factorization and a scalar normal form on
variation values. -/
structure CanVariationCertificate
    (incoming target : V →ₗ[R] V) (row : V →ₗ[R] R) (normal : R) where
  can : V →ₗ[R] P
  variation : P →ₗ[R] V
  incomingFactorization : variation.comp can = defectOperator incoming
  packetRow : P →ₗ[R] R
  directedRowNormalForm :
    (row.comp (defectOperator target)).comp variation = normal • packetRow

namespace CanVariationCertificate

variable
    {incoming target : V →ₗ[R] V} {row : V →ₗ[R] R} {normal : R}

/-- The one-sided can/variation data imply the ambient scalar normal form. -/
def toAmbientCertificate
    (certificate : CanVariationCertificate (P := P) incoming target row normal) :
    AmbientCertificate incoming target row normal where
  referenceRow := certificate.packetRow.comp certificate.can
  directedRowNormalForm := by
    apply LinearMap.ext
    intro source
    have incomingAt := LinearMap.congr_fun certificate.incomingFactorization source
    have directedAt := LinearMap.congr_fun certificate.directedRowNormalForm
      (certificate.can source)
    simp only [LinearMap.coe_comp, Function.comp_apply, LinearMap.smul_apply,
      smul_eq_mul] at directedAt ⊢
    rw [← incomingAt]
    change row (defectOperator target
      (certificate.variation (certificate.can source))) =
        normal * certificate.packetRow (certificate.can source)
    exact directedAt

end CanVariationCertificate

namespace AmbientCertificate

variable
    {incoming target : V →ₗ[R] V} {row : V →ₗ[R] R} {normal : R}

/-- Every trait-level projected-variation value specializes to zero when the
normal scalar does. -/
theorem specialize_projectedVariation_apply_eq_zero
    (certificate : AmbientCertificate incoming target row normal)
    (specialize : R →+* k)
    (normalVanishes : specialize normal = 0)
    (x : LinearMap.range (defectOperator incoming)) :
    specialize (projectedVariation incoming target row x) = 0 := by
  obtain ⟨source, sourceEquation⟩ := x.property
  have directedAt := LinearMap.congr_fun certificate.directedRowNormalForm
    source
  simp only [LinearMap.coe_comp, Function.comp_apply, LinearMap.smul_apply,
    smul_eq_mul] at directedAt
  change specialize (row (defectOperator target x.1)) = 0
  rw [← sourceEquation]
  rw [directedAt]
  simp [normalVanishes]

/-- A semilinear two-monodromy comparison transports the scalar-normal-form
vanishing to the specialized receiver once its incoming image spans. -/
theorem specialized_projectedVariation_eq_zero
    {W : Type*} [AddCommGroup W] [Module k W]
    {incomingK targetK : W →ₗ[k] W} {rowK : W →ₗ[k] k}
    (certificate : AmbientCertificate incoming target row normal)
    (specialize : R →+* k)
    (comparison : SemilinearVariation.Specialization specialize
      incoming target incomingK targetK row rowK)
    (incomingImageSpans :
      Submodule.span k (Set.range comparison.incomingImageMap) = ⊤)
    (normalVanishes : specialize normal = 0) :
    projectedVariation incomingK targetK rowK = 0 := by
  apply comparison.projectedVariation_eq_zero_of_incomingImageSpan_eq_top
    incomingImageSpans
  exact certificate.specialize_projectedVariation_apply_eq_zero
    specialize normalVanishes

end AmbientCertificate

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.VariationNormalFactor
