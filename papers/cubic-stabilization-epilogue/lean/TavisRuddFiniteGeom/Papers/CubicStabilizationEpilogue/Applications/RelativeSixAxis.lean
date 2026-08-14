import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisTwoPrimaryDiscriminant

/-!
# Opaque organizational relative six-axis packet

The relative abelian-scheme construction in the manuscript lies beyond the
current Mathlib API.  This module provides an opaque organizational signature
for its supplied geometric assertions.  Lean independently proves the full
integral Smith witness for the displayed five-axis Gram matrix and computes
the two-primary coefficient discriminant after tensoring with any `F₂`-module.

No scheme, isogeny, torsion local system, group action, or pairing is
constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

universe u v

/-- Relative objects appearing in the six-axis source lemma, indexed by the
connected smooth base. -/
structure RelativeSixAxisObjects (Base : Type u) where
  /-- Fibres of the relative elliptic scheme. -/
  Elliptic : Base → Type v
  /-- Fibres of the augmentation-lattice source. -/
  Source : Base → Type v
  /-- Fibres of the relative intermediate Jacobian. -/
  Jacobian : Base → Type v
  /-- Two-primary discriminant fibres of the source polarization. -/
  DiscriminantTwo : Base → Type v
  /-- Fibres of `H₂ ⊗ E[2]`. -/
  HeartTensorTorsion : Base → Type v
  /-- Two-primary kernel fibres of the relative isogeny. -/
  KernelTwo : Base → Type v

/-- Opaque proposition fields corresponding to the geometric assertions of
the relative six-axis source lemma.  Their scheme-theoretic semantics are not
defined in this companion. -/
structure RelativeSixAxisGeometricInput
    {Base : Type*} (objects : RelativeSixAxisObjects Base) where
  /-- The parameter carrier is the connected smooth locus in question. -/
  connectedSmoothLocus : Prop
  /-- The displayed elliptic family is an elliptic scheme over the base. -/
  ellipticScheme : Prop
  /-- Fibrewise map from the augmentation-lattice source to the intermediate
  Jacobian. -/
  relativeMap : ∀ parameter, objects.Source parameter → objects.Jacobian parameter
  /-- The source is the tensor product of the elliptic scheme with the integral
  augmentation quotient. -/
  sourceIsAugmentationTensor : Prop
  /-- The relative map is an isogeny. -/
  relativeMapIsIsogeny : Prop
  /-- The isogeny is finite and flat. -/
  relativeMapFiniteFlat : Prop
  /-- The relative map is equivariant for the named `A₅` action. -/
  relativeMapA5Equivariant : Prop
  /-- Source and coefficient form carry their natural `S₆` actions. -/
  naturalS6Actions : Prop
  /-- The coefficient form on the augmentation quotient is induced by
  `6I₆-J₆`. -/
  coefficientFormIsSixAxisAugmentationForm : Prop
  /-- Pullback of the principal target polarization equals the source
  polarization. -/
  polarizationPullbackIdentity : Prop
  /-- Omitting one axis identifies the source with five elliptic factors and
  identifies the coefficient form with `6I₅-J₅`. -/
  fiveAxisGramIdentification : Prop
  /-- Relative symplectic identification `D₂ ≃ H₂ ⊗ E[2]`. -/
  discriminantEquivalence : ∀ parameter,
    objects.DiscriminantTwo parameter ≃ objects.HeartTensorTorsion parameter
  /-- The discriminant type represents the two-primary kernel of the source
  polarization. -/
  discriminantIsSourcePolarizationKernel : Prop
  /-- The named tensor type represents `H₂ ⊗ E[2]` for the supplied elliptic
  family. -/
  heartTensorTorsionIsH2TensorEllipticTwoTorsion : Prop
  /-- The discriminant equivalence is `A₅`-equivariant. -/
  discriminantEquivalenceA5Equivariant : Prop
  /-- The preceding relative identification respects the alternating
  pairings. -/
  discriminantEquivalenceSymplectic : Prop
  /-- Inclusion of the two-primary isogeny kernel in the discriminant. -/
  kernelInclusion : ∀ parameter,
    objects.KernelTwo parameter → objects.DiscriminantTwo parameter
  /-- The named kernel type represents the two-primary part of the kernel of
  the supplied relative map. -/
  kernelTwoIsTwoPrimaryKernelOfRelativeMap : Prop
  /-- The kernel map into the discriminant is injective fibrewise. -/
  kernelInclusionInjective : ∀ parameter,
    Function.Injective (kernelInclusion parameter)
  /-- The relative two-primary kernel is `A₅`-stable. -/
  kernelA5Stable : Prop
  /-- The relative two-primary kernel is maximal isotropic. -/
  kernelMaximalIsotropic : Prop

/-- Organizational relative-six-axis packet.  Its geometric component is
supplied wholesale; the integral Smith witness and two-primary coefficient
discriminant are proved by Lean. -/
structure RelativeSixAxisConclusion
    {Base : Type*} (objects : RelativeSixAxisObjects Base) : Prop where
  /-- All relative geometric assertions of the lemma. -/
  geometryExists : Nonempty (RelativeSixAxisGeometricInput objects)
  /-- Kernel-checked integral reduction of `6I₅-J₅` to
  `diag(1,6,6,6,6)`. -/
  integralSmithWitness :
    GraphLattices.sixAxisSmithLeft * GraphLattices.sixAxisGram ℤ *
        GraphLattices.sixAxisSmithRight =
          GraphLattices.sixAxisSmithDiagonal ∧
      GraphLattices.sixAxisSmithLeft *
          GraphLattices.sixAxisSmithLeftInverse = 1 ∧
      GraphLattices.sixAxisSmithLeftInverse *
          GraphLattices.sixAxisSmithLeft = 1 ∧
      GraphLattices.sixAxisSmithRight *
          GraphLattices.sixAxisSmithRightInverse = 1 ∧
      GraphLattices.sixAxisSmithRightInverse *
          GraphLattices.sixAxisSmithRight = 1
  /-- For every `F₂`-module `T`, the kernel of the tensor-extended
  five-axis Gram map is explicitly equivalent to four copies of `T`. -/
  twoPrimaryTensorKernelCoordinates :
    ∀ (T : Type) [AddCommGroup T] [Module GraphLattices.F2 T],
      Nonempty ((Fin 4 → T) ≃ₗ[GraphLattices.F2]
        GraphLattices.SixAxisTwoPrimaryDiscriminant T)
  /-- For a two-dimensional `F₂` tensor factor, the discriminant has
  `2⁸` elements. -/
  twoPrimaryRankEightCardinality :
    Fintype.card
      (GraphLattices.SixAxisTwoPrimaryDiscriminant
        (Fin 2 → GraphLattices.F2)) = 256
  /-- The scalar discriminant coordinates are the normalized coordinates of
  the six-point coefficient heart `Aug(F₂⁶)/⟨1⟩`. -/
  twoPrimaryCoordinatesAgreeWithHeart :
    ∀ (heart : Fin 4 → GraphLattices.F2) (index : Fin 5),
      GraphLattices.sixAxisTwoPrimaryDiscriminantRepresentative heart index =
        GraphLattices.sixPointHeartRepresentative heart ⟨index, by omega⟩
  /-- The normalized dot product on the coefficient heart is bilinear,
  alternating, and nondegenerate. -/
  twoPrimaryHeartCoefficientForm :
    GraphLattices.SixPointHeartCoefficientFormProperties
  /-- The same coefficient form, bundled as a Mathlib bilinear form, is
  alternating and nondegenerate. -/
  twoPrimaryHeartCoefficientBilinForm :
    GraphLattices.sixPointHeartCoefficientBilinForm.IsAlt ∧
      GraphLattices.sixPointHeartCoefficientBilinForm.Nondegenerate
  /-- Every word in the explicit generated six-point action preserves the
  coefficient form. -/
  twoPrimaryHeartActionPreservesForm :
    ∀ word left right,
      GraphLattices.sixPointHeartCoefficientForm
          (GraphLattices.sixPointHeartWordAction word left)
          (GraphLattices.sixPointHeartWordAction word right) =
        GraphLattices.sixPointHeartCoefficientForm left right
  /-- After choosing a symplectic basis of a two-dimensional tensor factor,
  the induced rank-eight tensor-product form is alternating and
  nondegenerate. -/
  twoPrimaryStandardTensorForm :
    GraphLattices.sixAxisStandardDiscriminantBilinForm.IsAlt ∧
      GraphLattices.sixAxisStandardDiscriminantBilinForm.Nondegenerate

/-- Package the supplied opaque relative-six-axis fields with the independently
proved integral Smith witness and two-primary coefficient calculation. -/
theorem relativeSixAxis_of_geometricInputs
    {Base : Type*} (objects : RelativeSixAxisObjects Base)
    (geometry : RelativeSixAxisGeometricInput objects) :
    RelativeSixAxisConclusion objects :=
  ⟨⟨geometry⟩,
    ⟨GraphLattices.sixAxisGram_smith_reduction,
      GraphLattices.sixAxisSmithLeft_mul_inverse,
      GraphLattices.sixAxisSmithLeft_inverse_mul,
      GraphLattices.sixAxisSmithRight_mul_inverse,
      GraphLattices.sixAxisSmithRight_inverse_mul⟩,
    fun T _ _ ↦ ⟨GraphLattices.sixAxisTwoPrimaryDiscriminantLinearEquiv T⟩,
    GraphLattices.sixAxisTwoPrimaryDiscriminant_rankEight_card,
    GraphLattices.sixAxisTwoPrimaryDiscriminantRepresentative_eq_heart,
    GraphLattices.sixPointHeartCoefficientForm_properties,
    ⟨GraphLattices.sixPointHeartCoefficientBilinForm_isAlt,
      GraphLattices.sixPointHeartCoefficientBilinForm_nondegenerate⟩,
    GraphLattices.sixPointHeartWordAction_preserves_coefficientForm,
    ⟨GraphLattices.sixAxisStandardDiscriminantBilinForm_isAlt,
      GraphLattices.sixAxisStandardDiscriminantBilinForm_nondegenerate⟩⟩

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
