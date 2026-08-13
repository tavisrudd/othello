import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisGram

/-!
# Opaque organizational relative six-axis packet

The relative abelian-scheme construction in the manuscript lies beyond the
current Mathlib API.  This module provides an opaque organizational signature
for its supplied geometric assertions.  Lean independently proves the full
integral Smith witness for the displayed five-axis Gram matrix.

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
supplied wholesale; the full integral Smith witness is proved by Lean. -/
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

/-- Package the supplied opaque relative-six-axis fields with the independently
proved integral Smith witness. -/
theorem relativeSixAxis_of_geometricInputs
    {Base : Type*} (objects : RelativeSixAxisObjects Base)
    (geometry : RelativeSixAxisGeometricInput objects) :
    RelativeSixAxisConclusion objects :=
  ⟨⟨geometry⟩,
    GraphLattices.sixAxisGram_smith_reduction,
    GraphLattices.sixAxisSmithLeft_mul_inverse,
    GraphLattices.sixAxisSmithLeft_inverse_mul,
    GraphLattices.sixAxisSmithRight_mul_inverse,
    GraphLattices.sixAxisSmithRight_inverse_mul⟩

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
