import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MonodromyImage

/-!
# Monodromy-image coverage from can and variation maps

Let `c : V -> P` and `v : P -> V` be linear maps whose two composites are
the identity-minus-monodromy operators on `V` and `P`. The ambient monodromy
image equals the variation image exactly when can covers `P` modulo the kernel
of variation. Packet-defect coverage modulo that kernel and surjectivity of
`1 - T_P` are stronger sufficient conditions. None of these results asserts
that image formation commutes with scalar extension.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CanVariationCoverage

open MonodromyImage

universe uK uV uP

variable
    {K : Type uK} [CommRing K]
    {V : Type uV} {P : Type uP}
    [AddCommGroup V] [Module K V]
    [AddCommGroup P] [Module K P]

/-- Can/variation factorization of the two identity-minus-monodromy
operators. -/
structure Diagram
    (ambientOperator : V →ₗ[K] V) (packetOperator : P →ₗ[K] P) where
  can : V →ₗ[K] P
  variation : P →ₗ[K] V
  ambientFactorization : variation.comp can = defectOperator ambientOperator
  packetFactorization : can.comp variation = defectOperator packetOperator

namespace Diagram

variable
    {ambientOperator : V →ₗ[K] V} {packetOperator : P →ₗ[K] P}

/-- The can map covers variation if every variation value has a representative
in the image of can.  Equivalently, `P` is the sum of the can image and the
kernel of variation. -/
def CanCoversVariation
    (diagram : Diagram ambientOperator packetOperator) : Prop :=
  ∀ packetValue, ∃ ambientValue,
    diagram.variation (diagram.can ambientValue) = diagram.variation packetValue

/-- Can coverage identifies the ambient monodromy image with the variation
image. -/
theorem ambientRange_eq_variationRange_of_canCoversVariation
    (diagram : Diagram ambientOperator packetOperator)
    (canCoverage : diagram.CanCoversVariation) :
    LinearMap.range (defectOperator ambientOperator) = LinearMap.range diagram.variation := by
  apply le_antisymm
  · rintro value ⟨source, rfl⟩
    refine ⟨diagram.can source, ?_⟩
    exact LinearMap.congr_fun diagram.ambientFactorization source
  · rintro value ⟨packetValue, rfl⟩
    obtain ⟨ambientValue, hambientValue⟩ := canCoverage packetValue
    refine ⟨ambientValue, ?_⟩
    rw [← LinearMap.congr_fun diagram.ambientFactorization]
    exact hambientValue

/-- Equality of the ambient monodromy image and the variation image forces
can coverage. -/
theorem canCoversVariation_of_ambientRange_eq_variationRange
    (diagram : Diagram ambientOperator packetOperator)
    (rangeEquality :
      LinearMap.range (defectOperator ambientOperator) = LinearMap.range diagram.variation) :
    diagram.CanCoversVariation := by
  intro packetValue
  have valueInAmbientRange :
      diagram.variation packetValue ∈ LinearMap.range (defectOperator ambientOperator) := by
    rw [rangeEquality]
    exact ⟨packetValue, rfl⟩
  rcases valueInAmbientRange with ⟨ambientValue, hambientValue⟩
  refine ⟨ambientValue, ?_⟩
  calc
    diagram.variation (diagram.can ambientValue) =
        defectOperator ambientOperator ambientValue :=
      LinearMap.congr_fun diagram.ambientFactorization ambientValue
    _ = diagram.variation packetValue := hambientValue

/-- Can coverage is equivalent to equality of the ambient monodromy and
variation images. -/
theorem canCoversVariation_iff_ambientRange_eq_variationRange
    (diagram : Diagram ambientOperator packetOperator) :
    diagram.CanCoversVariation ↔
      LinearMap.range (defectOperator ambientOperator) = LinearMap.range diagram.variation :=
  ⟨diagram.ambientRange_eq_variationRange_of_canCoversVariation,
    diagram.canCoversVariation_of_ambientRange_eq_variationRange⟩

/-- A surjective can map supplies the exact can-coverage condition. -/
theorem canCoversVariation_of_can_surjective
    (diagram : Diagram ambientOperator packetOperator)
    (canSurjective : Function.Surjective diagram.can) :
    diagram.CanCoversVariation := by
  intro packetValue
  obtain ⟨ambientValue, hambientValue⟩ := canSurjective packetValue
  exact ⟨ambientValue, by rw [hambientValue]⟩

/-- A surjective can map identifies the ambient monodromy image with the
variation image. -/
theorem ambientRange_eq_variationRange_of_can_surjective
    (diagram : Diagram ambientOperator packetOperator)
    (canSurjective : Function.Surjective diagram.can) :
    LinearMap.range (defectOperator ambientOperator) = LinearMap.range diagram.variation :=
  diagram.ambientRange_eq_variationRange_of_canCoversVariation
    (diagram.canCoversVariation_of_can_surjective canSurjective)

/-- The packet defect covers variation if every variation value has a
representative in the image of the packet identity-minus-monodromy operator.
This is surjectivity of the packet defect modulo the kernel of variation. -/
def PacketDefectCoversVariation
    (diagram : Diagram ambientOperator packetOperator) : Prop :=
  ∀ packetValue, ∃ preimage,
    diagram.variation (defectOperator packetOperator preimage) =
      diagram.variation packetValue

/-- Surjectivity of the packet defect implies coverage after applying
variation. -/
theorem packetDefectCoversVariation_of_surjective
    (diagram : Diagram ambientOperator packetOperator)
    (packetDefectSurjective : Function.Surjective (defectOperator packetOperator)) :
    diagram.PacketDefectCoversVariation := by
  intro packetValue
  obtain ⟨preimage, hpreimage⟩ := packetDefectSurjective packetValue
  exact ⟨preimage, by rw [hpreimage]⟩

/-- Packet-defect coverage modulo the variation kernel implies the weaker and
exact can-coverage condition. -/
theorem canCoversVariation_of_packetDefectCoversVariation
    (diagram : Diagram ambientOperator packetOperator)
    (packetCoverage : diagram.PacketDefectCoversVariation) :
    diagram.CanCoversVariation := by
  intro packetValue
  obtain ⟨preimage, hpreimage⟩ := packetCoverage packetValue
  refine ⟨diagram.variation preimage, ?_⟩
  calc
    diagram.variation (diagram.can (diagram.variation preimage)) =
        diagram.variation (defectOperator packetOperator preimage) := by
      rw [← LinearMap.congr_fun diagram.packetFactorization]
      simp only [LinearMap.comp_apply]
    _ = diagram.variation packetValue := hpreimage

/-- Packet-defect coverage modulo the variation kernel already identifies
the ambient monodromy image with the variation image. -/
theorem ambientRange_eq_variationRange_of_packetDefectCoversVariation
    (diagram : Diagram ambientOperator packetOperator)
    (packetCoverage : diagram.PacketDefectCoversVariation) :
    LinearMap.range (defectOperator ambientOperator) = LinearMap.range diagram.variation := by
  exact diagram.ambientRange_eq_variationRange_of_canCoversVariation
    (diagram.canCoversVariation_of_packetDefectCoversVariation packetCoverage)

/-- Surjectivity of the packet identity-minus-monodromy operator identifies
the ambient monodromy image with the variation image. -/
theorem ambientRange_eq_variationRange
    (diagram : Diagram ambientOperator packetOperator)
    (packetDefectSurjective : Function.Surjective (defectOperator packetOperator)) :
    LinearMap.range (defectOperator ambientOperator) = LinearMap.range diagram.variation := by
  exact diagram.ambientRange_eq_variationRange_of_packetDefectCoversVariation
    (diagram.packetDefectCoversVariation_of_surjective packetDefectSurjective)

/-- The variation map, corestricted to the ambient monodromy image using the
exact can-coverage criterion. -/
def variationToAmbientRangeOfCanCoverage
    (diagram : Diagram ambientOperator packetOperator)
    (canCoverage : diagram.CanCoversVariation) :
    P →ₗ[K] LinearMap.range (defectOperator ambientOperator) where
  toFun packetValue :=
    ⟨diagram.variation packetValue, by
      rw [diagram.ambientRange_eq_variationRange_of_canCoversVariation canCoverage]
      exact ⟨packetValue, rfl⟩⟩
  map_add' left right := by apply Subtype.ext; simp
  map_smul' scalar value := by apply Subtype.ext; simp

/-- Can coverage makes the corestricted variation map surjective. -/
theorem variationToAmbientRangeOfCanCoverage_surjective
    (diagram : Diagram ambientOperator packetOperator)
    (canCoverage : diagram.CanCoversVariation) :
    Function.Surjective (diagram.variationToAmbientRangeOfCanCoverage canCoverage) := by
  intro value
  have valueInVariationRange : value.1 ∈ LinearMap.range diagram.variation := by
    rw [← diagram.ambientRange_eq_variationRange_of_canCoversVariation canCoverage]
    exact value.2
  rcases valueInVariationRange with ⟨packetValue, hpacketValue⟩
  refine ⟨packetValue, ?_⟩
  apply Subtype.ext
  exact hpacketValue

/-- The variation map, corestricted to the ambient monodromy image using only
packet-defect coverage modulo the variation kernel. -/
def variationToAmbientRangeOfPacketCoverage
    (diagram : Diagram ambientOperator packetOperator)
    (packetCoverage : diagram.PacketDefectCoversVariation) :
    P →ₗ[K] LinearMap.range (defectOperator ambientOperator) where
  toFun packetValue :=
    ⟨diagram.variation packetValue, by
      rw [diagram.ambientRange_eq_variationRange_of_packetDefectCoversVariation packetCoverage]
      exact ⟨packetValue, rfl⟩⟩
  map_add' left right := by apply Subtype.ext; simp
  map_smul' scalar value := by apply Subtype.ext; simp

/-- Packet-defect coverage modulo the variation kernel makes the corestricted
variation map surjective. -/
theorem variationToAmbientRangeOfPacketCoverage_surjective
    (diagram : Diagram ambientOperator packetOperator)
    (packetCoverage : diagram.PacketDefectCoversVariation) :
    Function.Surjective (diagram.variationToAmbientRangeOfPacketCoverage packetCoverage) := by
  intro value
  have valueInVariationRange : value.1 ∈ LinearMap.range diagram.variation := by
    rw [← diagram.ambientRange_eq_variationRange_of_packetDefectCoversVariation packetCoverage]
    exact value.2
  rcases valueInVariationRange with ⟨packetValue, hpacketValue⟩
  refine ⟨packetValue, ?_⟩
  apply Subtype.ext
  exact hpacketValue

/-- The variation map, corestricted to the ambient monodromy image. -/
def variationToAmbientRange
    (diagram : Diagram ambientOperator packetOperator)
    (packetDefectSurjective : Function.Surjective (defectOperator packetOperator)) :
    P →ₗ[K] LinearMap.range (defectOperator ambientOperator) where
  toFun packetValue :=
    ⟨diagram.variation packetValue, by
      rw [diagram.ambientRange_eq_variationRange packetDefectSurjective]
      exact ⟨packetValue, rfl⟩⟩
  map_add' left right := by apply Subtype.ext; simp
  map_smul' scalar value := by apply Subtype.ext; simp

/-- The corestricted variation map is onto the ambient monodromy image. -/
theorem variationToAmbientRange_surjective
    (diagram : Diagram ambientOperator packetOperator)
    (packetDefectSurjective : Function.Surjective (defectOperator packetOperator)) :
    Function.Surjective (diagram.variationToAmbientRange packetDefectSurjective) := by
  intro value
  have valueInVariationRange : value.1 ∈ LinearMap.range diagram.variation := by
    rw [← diagram.ambientRange_eq_variationRange packetDefectSurjective]
    exact value.2
  rcases valueInVariationRange with ⟨packetValue, hpacketValue⟩
  refine ⟨packetValue, ?_⟩
  apply Subtype.ext
  exact hpacketValue

/-- A bijective packet identity-minus-monodromy operator supplies the same
coverage conclusion. -/
theorem ambientRange_eq_variationRange_of_packetDefectBijective
    (diagram : Diagram ambientOperator packetOperator)
    (packetDefect : P ≃ₗ[K] P)
    (packetDefectAgrees : packetDefect.toLinearMap = defectOperator packetOperator) :
    LinearMap.range (defectOperator ambientOperator) = LinearMap.range diagram.variation := by
  apply diagram.ambientRange_eq_variationRange
  intro packetValue
  refine ⟨packetDefect.symm packetValue, ?_⟩
  rw [← packetDefectAgrees]
  change packetDefect (packetDefect.symm packetValue) = packetValue
  exact packetDefect.apply_symm_apply packetValue

/-- If the packet monodromy has no nonzero fixed vector, its
identity-minus-monodromy operator is injective. -/
theorem packetDefect_injective_of_fixedVectors_eq_zero
    (packetOperator : P →ₗ[K] P)
    (fixedVectorsVanish : ∀ value, packetOperator value = value → value = 0) :
    Function.Injective (defectOperator packetOperator) := by
  intro left right equality
  have differenceDefect : defectOperator packetOperator (left - right) = 0 := by
    rw [map_sub, equality, sub_self]
  have differenceFixed : packetOperator (left - right) = left - right := by
    unfold defectOperator at differenceDefect
    exact (sub_eq_zero.mp differenceDefect).symm
  exact sub_eq_zero.mp (fixedVectorsVanish (left - right) differenceFixed)

end Diagram

section FiniteDimensional

universe uF uX uQ

variable
    {F : Type uF} [Field F]
    {X : Type uX} {Q : Type uQ}
    [AddCommGroup X] [Module F X]
    [AddCommGroup Q] [Module F Q] [FiniteDimensional F Q]

/-- For a finite-dimensional packet, absence of fixed vectors makes the
packet defect onto and hence identifies the ambient monodromy image with the
variation image. -/
theorem Diagram.ambientRange_eq_variationRange_of_fixedVectors_eq_zero
    {ambientOperator : X →ₗ[F] X} {packetOperator : Q →ₗ[F] Q}
    (diagram : Diagram ambientOperator packetOperator)
    (fixedVectorsVanish : ∀ value, packetOperator value = value → value = 0) :
    LinearMap.range (defectOperator ambientOperator) = LinearMap.range diagram.variation := by
  apply diagram.ambientRange_eq_variationRange
  apply LinearMap.surjective_of_injective
  exact packetDefect_injective_of_fixedVectors_eq_zero packetOperator fixedVectorsVanish

end FiniteDimensional

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CanVariationCoverage
