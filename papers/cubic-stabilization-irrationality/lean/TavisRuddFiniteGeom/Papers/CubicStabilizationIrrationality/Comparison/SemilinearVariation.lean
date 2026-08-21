import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectedVariation

/-!
# Semilinear specialization of directed projected variation

A semilinear map intertwining two pairs of monodromy operators induces a
semilinear map on the incoming monodromy images. If it also specializes the
marked row, then directed projected variation specializes pointwise. This is
a trait-level transport law sufficient for vanishing; it does not claim that
tensor product commutes with image formation.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SemilinearVariation

open MonodromyImage
open ProjectedVariation

universe uR uk uV uW

variable
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module k W]

/-- A marked semilinear specialization of two monodromy operators. -/
structure Specialization
    (specialize : R →+* k)
    (incomingR targetR : V →ₗ[R] V)
    (incomingK targetK : W →ₗ[k] W)
    (rowR : V →ₗ[R] R) (rowK : W →ₗ[k] k) where
  map : V →ₛₗ[specialize] W
  incomingCommutes : ∀ x, map (incomingR x) = incomingK (map x)
  targetCommutes : ∀ x, map (targetR x) = targetK (map x)
  rowSpecializes : ∀ x, rowK (map x) = specialize (rowR x)

namespace Specialization

variable
    {incomingR targetR : V →ₗ[R] V}
    {incomingK targetK : W →ₗ[k] W}
    {rowR : V →ₗ[R] R} {rowK : W →ₗ[k] k}

/-- Identity-minus-monodromy commutes with a semilinear specialization. -/
theorem defectOperator_commutes
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK)
    (operatorR : V →ₗ[R] V) (operatorK : W →ₗ[k] W)
    (commutes : ∀ x, reader.map (operatorR x) = operatorK (reader.map x))
    (x : V) :
    reader.map (defectOperator operatorR x) =
      defectOperator operatorK (reader.map x) := by
  simp [defectOperator, commutes]

/-- The induced semilinear map on an incoming monodromy image. -/
def incomingImageMap
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK) :
    LinearMap.range (defectOperator incomingR) →ₛₗ[specialize]
      LinearMap.range (defectOperator incomingK) where
  toFun x := by
    refine ⟨reader.map x.1, ?_⟩
    obtain ⟨source, sourceEquation⟩ := x.2
    refine ⟨reader.map source, ?_⟩
    rw [← reader.defectOperator_commutes incomingR incomingK
      reader.incomingCommutes source, sourceEquation]
  map_add' left right := by
    apply Subtype.ext
    exact map_add reader.map left.1 right.1
  map_smul' scalar x := by
    apply Subtype.ext
    exact reader.map.map_smulₛₗ scalar x.1

@[simp]
theorem incomingImageMap_value
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK)
    (x : LinearMap.range (defectOperator incomingR)) :
    (reader.incomingImageMap x).1 = reader.map x.1 :=
  rfl

/-- A surjective ambient specialization is sufficient for surjectivity on
the incoming monodromy image. -/
theorem incomingImageMap_surjective_of_surjective
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK)
    (mapSurjective : Function.Surjective reader.map) :
    Function.Surjective reader.incomingImageMap := by
  intro y
  obtain ⟨targetSource, targetEquation⟩ := y.2
  obtain ⟨source, sourceEquation⟩ := mapSurjective targetSource
  refine ⟨⟨defectOperator incomingR source, ⟨source, rfl⟩⟩, ?_⟩
  apply Subtype.ext
  change reader.map (defectOperator incomingR source) = y.1
  rw [reader.defectOperator_commutes incomingR incomingK
    reader.incomingCommutes source, sourceEquation, targetEquation]

/-- A surjective ambient specialization makes the induced incoming image span
the entire specialized packet. -/
theorem incomingImageSpan_eq_top_of_surjective
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK)
    (mapSurjective : Function.Surjective reader.map) :
    Submodule.span k (Set.range reader.incomingImageMap) = ⊤ := by
  rw [Set.range_eq_univ.mpr
    (reader.incomingImageMap_surjective_of_surjective mapSurjective)]
  exact Submodule.span_univ

/-- Directed projected variation specializes along the induced incoming-image
map. -/
theorem projectedVariation_specializes
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK)
    (x : LinearMap.range (defectOperator incomingR)) :
    projectedVariation incomingK targetK rowK (reader.incomingImageMap x) =
      specialize (projectedVariation incomingR targetR rowR x) := by
  change rowK (defectOperator targetK (reader.map x.1)) =
    specialize (rowR (defectOperator targetR x.1))
  rw [← reader.defectOperator_commutes targetR targetK
    reader.targetCommutes x.1]
  exact reader.rowSpecializes (defectOperator targetR x.1)

/-- Pointwise vanishing after scalar specialization, rather than vanishing
over the trait, suffices to kill the specialized projected variation. -/
theorem projectedVariation_eq_zero_of_incomingImageSpan_eq_top
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK)
    (imageSpans :
      Submodule.span k (Set.range reader.incomingImageMap) = ⊤)
    (specializedValuesVanish : ∀ x,
      specialize (projectedVariation incomingR targetR rowR x) = 0) :
    projectedVariation incomingK targetK rowK = 0 := by
  let specializedVariation := projectedVariation incomingK targetK rowK
  have range_le_kernel :
      Set.range reader.incomingImageMap ⊆ specializedVariation.ker := by
    rintro _ ⟨x, rfl⟩
    change projectedVariation incomingK targetK rowK
      (reader.incomingImageMap x) = 0
    rw [reader.projectedVariation_specializes]
    exact specializedValuesVanish x
  have top_le_kernel : (⊤ : Submodule k _) ≤ specializedVariation.ker := by
    rw [← imageSpans]
    exact Submodule.span_le.2 range_le_kernel
  apply LinearMap.ext
  intro y
  exact top_le_kernel Submodule.mem_top

/-- Set-surjectivity is a convenient sufficient form of incoming-image
coverage. -/
theorem projectedVariation_eq_zero_of_specializedValues
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK)
    (imageSurjective : Function.Surjective reader.incomingImageMap)
    (specializedValuesVanish : ∀ x,
      specialize (projectedVariation incomingR targetR rowR x) = 0) :
    projectedVariation incomingK targetK rowK = 0 := by
  apply LinearMap.ext
  intro y
  obtain ⟨x, rfl⟩ := imageSurjective y
  rw [reader.projectedVariation_specializes]
  exact specializedValuesVanish x

/-- A trait-level variation divisible by a scalar in the specialization
kernel has zero specialized projected variation. -/
theorem projectedVariation_eq_zero_of_normalFactor
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK)
    (imageSpans :
      Submodule.span k (Set.range reader.incomingImageMap) = ⊤)
    (normal : R)
    (referenceRow : LinearMap.range (defectOperator incomingR) →ₗ[R] R)
    (variationReading :
      projectedVariation incomingR targetR rowR = normal • referenceRow)
    (normalVanishes : specialize normal = 0) :
    projectedVariation incomingK targetK rowK = 0 := by
  apply reader.projectedVariation_eq_zero_of_incomingImageSpan_eq_top imageSpans
  intro x
  rw [variationReading]
  simp [normalVanishes]

/-- Surjectivity on the incoming image transports generic variation
vanishing to the specialized receiver. -/
theorem projectedVariation_eq_zero_of_incomingImageMap_surjective
    (reader : Specialization specialize incomingR targetR incomingK targetK rowR rowK)
    (imageSurjective : Function.Surjective reader.incomingImageMap)
    (genericVariationVanishes : projectedVariation incomingR targetR rowR = 0) :
    projectedVariation incomingK targetK rowK = 0 := by
  apply reader.projectedVariation_eq_zero_of_specializedValues imageSurjective
  intro x
  rw [genericVariationVanishes]
  simp

end Specialization

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SemilinearVariation
