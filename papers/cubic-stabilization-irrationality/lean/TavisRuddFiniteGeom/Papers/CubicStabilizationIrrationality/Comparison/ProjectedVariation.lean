import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MonodromyImage

/-!
# Naturality of projected monodromy variation

For two monodromy operators on one space, the canonical monodromy-image model
of the directed block is the restriction of the second
identity-minus-monodromy operator to the image of the first. A covector
consumes only its composition with this directed block. This construction is
natural under one marked horizontal comparison of the common spaces.
Consequently the two image maps and their projected-row compatibility are
derived data inside this model. Identifying actual Malgrange packets with
these images remains an external comparison and base-change hypothesis.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectedVariation

open MonodromyImage

universe uR uV uW

variable {R : Type uR} [CommRing R]
variable {V : Type uV} {W : Type uW}
variable [AddCommGroup V] [Module R V]
variable [AddCommGroup W] [Module R W]

/-- The directed block obtained by applying the target
identity-minus-monodromy operator to the incoming monodromy image. -/
def crossImageMap (incoming target : V →ₗ[R] V) :
    LinearMap.range (defectOperator incoming) →ₗ[R]
      LinearMap.range (defectOperator target) where
  toFun x := ⟨defectOperator target x.1, ⟨x.1, rfl⟩⟩
  map_add' left right := by
    apply Subtype.ext
    exact map_add (defectOperator target) left.1 right.1
  map_smul' scalar x := by
    apply Subtype.ext
    exact map_smul (defectOperator target) scalar x.1

@[simp]
theorem crossImageMap_value
    (incoming target : V →ₗ[R] V)
    (x : LinearMap.range (defectOperator incoming)) :
    (crossImageMap incoming target x).1 = defectOperator target x.1 :=
  rfl

/-- The covector-valued directed projected variation between two monodromy
images. -/
def projectedVariation
    (incoming target : V →ₗ[R] V) (row : V →ₗ[R] R) :
    LinearMap.range (defectOperator incoming) →ₗ[R] R :=
  (row.domRestrict (LinearMap.range (defectOperator target))).comp
    (crossImageMap incoming target)

@[simp]
theorem projectedVariation_apply
    (incoming target : V →ₗ[R] V) (row : V →ₗ[R] R)
    (x : LinearMap.range (defectOperator incoming)) :
    projectedVariation incoming target row x =
      row (defectOperator target x.1) :=
  rfl

/-- One horizontal marked comparison transports the directed projected
variation. The incoming image map and the target variation square are both
forced by the same comparison. -/
theorem projectedVariation_natural
    (F : V →ₗ[R] W)
    (incomingV targetV : V →ₗ[R] V)
    (incomingW targetW : W →ₗ[R] W)
    (horizontalIncoming : Intertwines F incomingV incomingW)
    (horizontalTarget : Intertwines F targetV targetW)
    (rowV : V →ₗ[R] R) (rowW : W →ₗ[R] R)
    (rowCompatible : rowW.comp F = rowV) :
    (projectedVariation incomingW targetW rowW).comp
        (imageMap F incomingV incomingW horizontalIncoming) =
      projectedVariation incomingV targetV rowV := by
  apply LinearMap.ext
  intro x
  change rowW (defectOperator targetW (F x.1)) =
    rowV (defectOperator targetV x.1)
  have targetSquare :
      F (defectOperator targetV x.1) =
        defectOperator targetW (F x.1) :=
    LinearMap.congr_fun
      (defectOperator_intertwines F targetV targetW horizontalTarget) x.1
  calc
    rowW (defectOperator targetW (F x.1)) =
        rowW (F (defectOperator targetV x.1)) := by
      exact congrArg rowW targetSquare.symm
    _ = rowV (defectOperator targetV x.1) := by
      exact LinearMap.congr_fun rowCompatible (defectOperator targetV x.1)

/-- A bijective horizontal marked comparison identifies both incoming image
packets and their projected variations. -/
theorem projectedVariation_via_imageEquiv
    (F : V →ₗ[R] W)
    (incomingV targetV : V →ₗ[R] V)
    (incomingW targetW : W →ₗ[R] W)
    (horizontalIncoming : Intertwines F incomingV incomingW)
    (horizontalTarget : Intertwines F targetV targetW)
    (bijective : Function.Bijective F)
    (rowV : V →ₗ[R] R) (rowW : W →ₗ[R] R)
    (rowCompatible : rowW.comp F = rowV) :
    (projectedVariation incomingW targetW rowW).comp
        (imageEquiv F incomingV incomingW horizontalIncoming bijective).toLinearMap =
      projectedVariation incomingV targetV rowV :=
  projectedVariation_natural F incomingV targetV incomingW targetW
    horizontalIncoming horizontalTarget rowV rowW rowCompatible

/-- For a marked horizontal comparison from a model to an actual receiver,
surjectivity on the incoming monodromy image is enough to transport
vanishing of the model projected variation. -/
theorem projectedVariation_eq_zero_of_imageMap_surjective
    (F : V →ₗ[R] W)
    (incomingV targetV : V →ₗ[R] V)
    (incomingW targetW : W →ₗ[R] W)
    (horizontalIncoming : Intertwines F incomingV incomingW)
    (horizontalTarget : Intertwines F targetV targetW)
    (rowV : V →ₗ[R] R) (rowW : W →ₗ[R] R)
    (rowCompatible : rowW.comp F = rowV)
    (imageSurjective : Function.Surjective
      (imageMap F incomingV incomingW horizontalIncoming))
    (modelVariationVanishes : projectedVariation incomingV targetV rowV = 0) :
    projectedVariation incomingW targetW rowW = 0 := by
  apply LinearMap.ext
  intro y
  obtain ⟨x, rfl⟩ := imageSurjective y
  have naturalityAt := LinearMap.congr_fun
    (projectedVariation_natural F incomingV targetV incomingW targetW
      horizontalIncoming horizontalTarget rowV rowW rowCompatible) x
  simpa [modelVariationVanishes] using naturalityAt

/-- Ambient surjectivity is a convenient sufficient condition for the
minimal incoming-image surjectivity hypothesis. -/
theorem projectedVariation_eq_zero_of_surjective
    (F : V →ₗ[R] W)
    (incomingV targetV : V →ₗ[R] V)
    (incomingW targetW : W →ₗ[R] W)
    (horizontalIncoming : Intertwines F incomingV incomingW)
    (horizontalTarget : Intertwines F targetV targetW)
    (surjective : Function.Surjective F)
    (rowV : V →ₗ[R] R) (rowW : W →ₗ[R] R)
    (rowCompatible : rowW.comp F = rowV)
    (modelVariationVanishes : projectedVariation incomingV targetV rowV = 0) :
    projectedVariation incomingW targetW rowW = 0 :=
  projectedVariation_eq_zero_of_imageMap_surjective
    F incomingV targetV incomingW targetW
    horizontalIncoming horizontalTarget rowV rowW rowCompatible
    (imageMap_surjective F incomingV incomingW horizontalIncoming surjective)
    modelVariationVanishes

/-- For a marked horizontal comparison from an actual receiver to a model,
vanishing of the model projected variation pulls back without a surjectivity
hypothesis. -/
theorem projectedVariation_eq_zero_of_reverse_comparison
    (F : V →ₗ[R] W)
    (incomingV targetV : V →ₗ[R] V)
    (incomingW targetW : W →ₗ[R] W)
    (horizontalIncoming : Intertwines F incomingV incomingW)
    (horizontalTarget : Intertwines F targetV targetW)
    (rowV : V →ₗ[R] R) (rowW : W →ₗ[R] R)
    (rowCompatible : rowW.comp F = rowV)
    (modelVariationVanishes : projectedVariation incomingW targetW rowW = 0) :
    projectedVariation incomingV targetV rowV = 0 := by
  calc
    projectedVariation incomingV targetV rowV =
        (projectedVariation incomingW targetW rowW).comp
          (imageMap F incomingV incomingW horizontalIncoming) :=
      (projectedVariation_natural F incomingV targetV incomingW targetW
        horizontalIncoming horizontalTarget rowV rowW rowCompatible).symm
    _ = 0 := by simp [modelVariationVanishes]

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectedVariation
