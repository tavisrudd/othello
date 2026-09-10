import Mathlib.Tactic
import Mathlib.RepresentationTheory.Subrepresentation
import Mathlib.RepresentationTheory.Intertwining

/-!
# Full equivariant images of projectors

An endomorphism commuting with a representation has a stable image, carrying
the restricted representation on every image vector. An equivariant linear
coordinate change intertwining two such endomorphisms induces an equivariant
linear equivalence of their actual images. No image is replaced by the
fixed vectors of the group. Idempotence is unnecessary for these image
transport statements; they apply in particular to primary projectors.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The full image subrepresentation of an equivariant endomorphism. -/
def equivariantEndomorphismImage
    {K G V : Type*} [Field K] [Monoid G] [AddCommGroup V] [Module K V]
    (representation : Representation K G V) (operator : Module.End K V)
    (equivariant : ∀ g x, operator (representation g x)=representation g (operator x)) :
    Subrepresentation representation where
  toSubmodule := LinearMap.range operator
  apply_mem_toSubmodule g := by
    rintro _ ⟨x,rfl⟩
    exact ⟨representation g x,equivariant g x⟩

/-- An intertwining linear equivalence restricts to an actual equivalence of
operator images. Both inverse identities hold on the complete image spaces. -/
def intertwiningLinearEquiv_images
    {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
    (source target : Module.End K V) (equiv : V ≃ₗ[K] V)
    (intertwines : ∀ x, target (equiv x)=equiv (source x)) :
    LinearMap.range source ≃ₗ[K] LinearMap.range target where
  toFun x := ⟨equiv x,by
    obtain ⟨y,hy⟩ := x.property
    exact ⟨equiv y,(intertwines y).trans (congrArg equiv hy)⟩⟩
  invFun x := ⟨equiv.symm x,by
    obtain ⟨y,hy⟩ := x.property
    refine ⟨equiv.symm y,?_⟩
    apply equiv.injective
    rw [equiv.apply_symm_apply, ← intertwines, equiv.apply_symm_apply, hy]⟩
  left_inv x := Subtype.ext (equiv.symm_apply_apply x)
  right_inv x := Subtype.ext (equiv.apply_symm_apply x)
  map_add' x y := Subtype.ext (equiv.map_add x y)
  map_smul' c x := Subtype.ext (equiv.map_smul c x)

/-- The induced image equivalence intertwines the full restricted group
representations whenever the original coordinate change is equivariant. -/
theorem intertwiningLinearEquiv_images_equivariant
    {K G V : Type*} [Field K] [Monoid G] [AddCommGroup V] [Module K V]
    (representation : Representation K G V) (source target : Module.End K V)
    (sourceEquivariant : ∀ g x, source (representation g x)=representation g (source x))
    (targetEquivariant : ∀ g x, target (representation g x)=representation g (target x))
    (equiv : V ≃ₗ[K] V)
    (equivariant : ∀ g x, equiv (representation g x)=representation g (equiv x))
    (intertwines : ∀ x, target (equiv x)=equiv (source x)) :
    ∀ g x,
      intertwiningLinearEquiv_images source target equiv intertwines
        ((equivariantEndomorphismImage representation source sourceEquivariant).toRepresentation g x) =
      (equivariantEndomorphismImage representation target targetEquivariant).toRepresentation g
        (intertwiningLinearEquiv_images source target equiv intertwines x) := by
  intro g x
  apply Subtype.ext
  exact equivariant g x

/-- The transported full images are isomorphic as representations, with an
actual bundled inverse intertwining map. -/
def equivariantImageRepresentationEquiv
    {K G V : Type*} [Field K] [Monoid G] [AddCommGroup V] [Module K V]
    (representation : Representation K G V) (source target : Module.End K V)
    (sourceEquivariant : ∀ g x, source (representation g x)=representation g (source x))
    (targetEquivariant : ∀ g x, target (representation g x)=representation g (target x))
    (equiv : V ≃ₗ[K] V)
    (equivariant : ∀ g x, equiv (representation g x)=representation g (equiv x))
    (intertwines : ∀ x, target (equiv x)=equiv (source x)) :
    ((equivariantEndomorphismImage representation source sourceEquivariant).toRepresentation).Equiv
      ((equivariantEndomorphismImage representation target targetEquivariant).toRepresentation) :=
  Representation.Equiv.mk (intertwiningLinearEquiv_images source target equiv intertwines) (by
    intro g
    ext x
    exact congrArg Subtype.val (intertwiningLinearEquiv_images_equivariant representation source target
      sourceEquivariant targetEquivariant equiv equivariant intertwines g x))

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
