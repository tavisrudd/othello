import Mathlib

/-!
# Functoriality of monodromy images

A linear map intertwining two monodromy operators automatically intertwines
their identity-minus-monodromy operators and induces a map between their
images. The induced map is functorial and preserves any compatible row. Thus
image/can--variation component maps need not be supplied independently once a
horizontal marked comparison has been constructed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MonodromyImage

universe uR uV uW uX

variable {R : Type uR} [CommRing R]
variable {V : Type uV} {W : Type uW} {X : Type uX}
variable [AddCommGroup V] [Module R V]
variable [AddCommGroup W] [Module R W]
variable [AddCommGroup X] [Module R X]

/-- The identity-minus-monodromy operator. -/
def defectOperator (T : V →ₗ[R] V) : V →ₗ[R] V :=
  LinearMap.id - T

/-- A horizontal linear map between two monodromy representations. -/
def Intertwines (F : V →ₗ[R] W) (Tᵥ : V →ₗ[R] V) (T𝓌 : W →ₗ[R] W) : Prop :=
  F.comp Tᵥ = T𝓌.comp F

/-- A horizontal map also intertwines identity-minus-monodromy. -/
theorem defectOperator_intertwines
    (F : V →ₗ[R] W) (Tᵥ : V →ₗ[R] V) (T𝓌 : W →ₗ[R] W)
    (horizontal : Intertwines F Tᵥ T𝓌) :
    F.comp (defectOperator Tᵥ) = (defectOperator T𝓌).comp F := by
  apply LinearMap.ext
  intro x
  have horizontalAt : F (Tᵥ x) = T𝓌 (F x) :=
    LinearMap.congr_fun horizontal x
  simp [defectOperator, LinearMap.comp_apply, horizontalAt]

/-- The map induced by a horizontal comparison on the canonical monodromy
image. -/
def imageMap
    (F : V →ₗ[R] W) (Tᵥ : V →ₗ[R] V) (T𝓌 : W →ₗ[R] W)
    (horizontal : Intertwines F Tᵥ T𝓌) :
    LinearMap.range (defectOperator Tᵥ) →ₗ[R]
      LinearMap.range (defectOperator T𝓌) where
  toFun x := by
    refine ⟨F x.1, ?_⟩
    obtain ⟨source, sourceEquation⟩ := x.2
    refine ⟨F source, ?_⟩
    rw [← LinearMap.comp_apply, ← defectOperator_intertwines F Tᵥ T𝓌 horizontal,
      LinearMap.comp_apply, sourceEquation]
  map_add' left right := by
    ext
    simp
  map_smul' scalar x := by
    ext
    simp

@[simp]
theorem imageMap_value
    (F : V →ₗ[R] W) (Tᵥ : V →ₗ[R] V) (T𝓌 : W →ₗ[R] W)
    (horizontal : Intertwines F Tᵥ T𝓌)
    (x : LinearMap.range (defectOperator Tᵥ)) :
    (imageMap F Tᵥ T𝓌 horizontal x).1 = F x.1 :=
  rfl

/-- The identity comparison induces the identity on the monodromy image. -/
theorem imageMap_id
    (Tᵥ : V →ₗ[R] V)
    (horizontal : Intertwines LinearMap.id Tᵥ Tᵥ) :
    imageMap LinearMap.id Tᵥ Tᵥ horizontal = LinearMap.id := by
  apply LinearMap.ext
  intro x
  ext
  rfl

/-- Image maps compose exactly when horizontal comparisons compose. -/
theorem imageMap_comp
    (F : V →ₗ[R] W) (G : W →ₗ[R] X)
    (Tᵥ : V →ₗ[R] V) (T𝓌 : W →ₗ[R] W) (Tₓ : X →ₗ[R] X)
    (horizontalF : Intertwines F Tᵥ T𝓌)
    (horizontalG : Intertwines G T𝓌 Tₓ)
    (horizontalGF : Intertwines (G.comp F) Tᵥ Tₓ) :
    imageMap (G.comp F) Tᵥ Tₓ horizontalGF =
      (imageMap G T𝓌 Tₓ horizontalG).comp
        (imageMap F Tᵥ T𝓌 horizontalF) := by
  apply LinearMap.ext
  intro x
  ext
  rfl

/-- Surjectivity of a horizontal comparison descends to its canonical
monodromy-image map. -/
theorem imageMap_surjective
    (F : V →ₗ[R] W) (Tᵥ : V →ₗ[R] V) (T𝓌 : W →ₗ[R] W)
    (horizontal : Intertwines F Tᵥ T𝓌)
    (surjective : Function.Surjective F) :
    Function.Surjective (imageMap F Tᵥ T𝓌 horizontal) := by
  rintro ⟨_, ⟨w, rfl⟩⟩
  obtain ⟨v, rfl⟩ := surjective w
  refine ⟨⟨defectOperator Tᵥ v, ⟨v, rfl⟩⟩, ?_⟩
  apply Subtype.ext
  exact LinearMap.congr_fun (defectOperator_intertwines F Tᵥ T𝓌 horizontal) v

/-- Injectivity of a horizontal comparison descends to its canonical
monodromy-image map. -/
theorem imageMap_injective
    (F : V →ₗ[R] W) (Tᵥ : V →ₗ[R] V) (T𝓌 : W →ₗ[R] W)
    (horizontal : Intertwines F Tᵥ T𝓌)
    (injective : Function.Injective F) :
    Function.Injective (imageMap F Tᵥ T𝓌 horizontal) := by
  intro left right equality
  apply Subtype.ext
  apply injective
  exact congrArg Subtype.val equality

/-- A bijective horizontal comparison induces a linear equivalence of the
canonical monodromy images. -/
noncomputable def imageEquiv
    (F : V →ₗ[R] W) (Tᵥ : V →ₗ[R] V) (T𝓌 : W →ₗ[R] W)
    (horizontal : Intertwines F Tᵥ T𝓌)
    (bijective : Function.Bijective F) :
    LinearMap.range (defectOperator Tᵥ) ≃ₗ[R]
      LinearMap.range (defectOperator T𝓌) :=
  LinearEquiv.ofBijective (imageMap F Tᵥ T𝓌 horizontal)
    ⟨imageMap_injective F Tᵥ T𝓌 horizontal bijective.1,
      imageMap_surjective F Tᵥ T𝓌 horizontal bijective.2⟩

/-- A compatible covector restricts compatibly to the canonical monodromy
images. -/
theorem imageMap_preserves_row
    (F : V →ₗ[R] W) (Tᵥ : V →ₗ[R] V) (T𝓌 : W →ₗ[R] W)
    (horizontal : Intertwines F Tᵥ T𝓌)
    (rowV : V →ₗ[R] R) (rowW : W →ₗ[R] R)
    (rowCompatible : rowW.comp F = rowV) :
    (rowW.domRestrict (LinearMap.range (defectOperator T𝓌))).comp
        (imageMap F Tᵥ T𝓌 horizontal) =
      rowV.domRestrict (LinearMap.range (defectOperator Tᵥ)) := by
  apply LinearMap.ext
  intro x
  exact LinearMap.congr_fun rowCompatible x.1

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MonodromyImage
