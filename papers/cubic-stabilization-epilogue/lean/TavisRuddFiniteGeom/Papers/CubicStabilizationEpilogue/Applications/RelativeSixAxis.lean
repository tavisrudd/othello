import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointStableHalves
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisSourcePolarization
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisDiscriminantGroup
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisPrimaryDiscriminantSplitting

/-!
# The relative six-axis packet over its integral homology realization

The relative abelian-scheme construction of the manuscript lies beyond the
current Mathlib API, so this module separates the geometry into two layers.

The first layer is explicit.  Each fibre supplies an integral first-homology
realization: a unimodular alternating form standing for the principal
polarization of the intermediate Jacobian, an integral comparison matrix
standing for the map induced by the relative morphism, and the polarization
pullback identity between them, stated as an equation of integral matrices
against the Kronecker polarization of the six-axis source.  From that data
Lean proves the degree and finiteness of the comparison — its determinant has
absolute value `6⁴` and it is injective — and, after choosing coordinates on
the two-torsion fibres, produces the two-primary discriminant identification
`D₂ ≃ H₂ ⊗ E[2]` rather than assuming it.  The same data also determines the
discriminant group of the source polarization, of order `6⁸`, together with the
image of the comparison cokernel in it: that image has order `6⁴` and is a
maximal isotropic subgroup for the `ℚ/ℤ`-valued discriminant pairing.  That
group is annihilated by six, so it is the direct sum of its two- and
three-primary parts, which are orthogonal for the pairing; the kernel image
splits along the same decomposition, and each of its primary parts equals its
own orthogonal complement inside the corresponding primary part of the
discriminant group, hence is maximal among the isotropic subgroups of that
part.

The second layer remains supplied: the assertion that these integral matrices
are the ones induced on homology by an actual elliptic scheme, relative
morphism, and polarization, together with the equivariance assertions of the
lemma and the identification of its named geometric kernel and discriminant
types with the lattice-level objects.  Those fields are propositions carried by
the structure, not proofs, and Lean gives them no scheme-theoretic semantics.

Lean also independently proves the full integral Smith witness for the
displayed five-axis Gram matrix and computes the two-primary coefficient
discriminant after tensoring with any `F₂`-module.  For a two-dimensional
symplectic tensor factor, it identifies the rank-eight discriminant with two
copies of the coefficient heart and proves that the five projective-line
packet members are exactly the diagonally stable maximal-isotropic subspaces.

No relative scheme, torsion local system, geometric group action, or Weil
pairing of an actual elliptic curve is constructed here, and no three-primary
geometric identification is made.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

open scoped Matrix

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
  /-- Three-primary discriminant fibres of the source polarization. -/
  DiscriminantThree : Base → Type v
  /-- Fibres of `H₃ ⊗ E[3]`. -/
  HeartThreeTensorTorsion : Base → Type v
  /-- Two-primary kernel fibres of the relative isogeny. -/
  KernelTwo : Base → Type v

/-- Integral first-homology realization of one fibre of the relative six-axis
source, together with its comparison with the intermediate Jacobian.  The
coefficient lattice is the five-axis chart of the six-coordinate quotient, and
the elliptic factor contributes the rank-two homology coordinates, so all three
matrices are indexed by an axis together with an elliptic homology
coordinate. -/
structure RelativeSixAxisHomologyRealization where
  /-- The principal polarization of the intermediate Jacobian fibre, written as
  an integral alternating form on its first homology. -/
  jacobianPolarization : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ
  /-- The target polarization is principal, that is, unimodular. -/
  jacobianPolarizationPrincipal : jacobianPolarization.det = 1
  /-- The map induced on integral first homology by the relative morphism. -/
  comparison : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ
  /-- Pullback of the principal target polarization is the source polarization,
  the homology form of the manuscript's identity `f*λ_Θ = λ_A`. -/
  polarizationPullback :
    comparisonᵀ * jacobianPolarization * comparison =
      GraphLattices.sixAxisSourcePolarization ℤ

/-- Fibrewise geometric input of the relative six-axis source lemma.  The
homology realization and the two-torsion coordinate identifications are
explicit data; the remaining fields are propositions carried by the structure,
recording the assertions whose scheme-theoretic semantics this companion does
not define. -/
structure RelativeSixAxisGeometricInput
    {Base : Type*} (objects : RelativeSixAxisObjects Base) where
  /-- The parameter carrier is the connected smooth locus in question. -/
  connectedSmoothLocus : Prop
  /-- Integral first-homology realization of each fibre of the source, its
  polarization, and its comparison with the intermediate Jacobian. -/
  homology : Base → RelativeSixAxisHomologyRealization
  /-- The displayed matrices are the ones induced on first homology by an
  elliptic scheme, the tensor-product source, the relative morphism, and the
  principal polarization of the intermediate Jacobian. -/
  homologyRealizesRelativeGeometry : Prop
  /-- Fibrewise map from the augmentation-lattice source to the intermediate
  Jacobian. -/
  relativeMap : ∀ parameter, objects.Source parameter → objects.Jacobian parameter
  /-- The relative map is equivariant for the named `A₅` action. -/
  relativeMapA5Equivariant : Prop
  /-- Source and coefficient form carry their natural `S₆` actions. -/
  naturalS6Actions : Prop
  /-- Coordinates identifying each two-primary discriminant fibre with the
  two-torsion kernel of the realized source polarization. -/
  discriminantTwoCoordinates : ∀ parameter,
    objects.DiscriminantTwo parameter ≃
      GraphLattices.sixAxisSourceTwoPrimaryDiscriminant
  /-- Coordinates identifying each `H₂ ⊗ E[2]` fibre with four copies of the
  rank-two two-torsion module, after choosing a symplectic basis of the
  elliptic two-torsion. -/
  heartTensorTorsionCoordinates : ∀ parameter,
    objects.HeartTensorTorsion parameter ≃ (Fin 4 → Fin 2 → GraphLattices.F2)
  /-- The discriminant type represents the two-primary kernel of the source
  polarization. -/
  discriminantIsSourcePolarizationKernel : Prop
  /-- The named tensor type represents `H₂ ⊗ E[2]` for the supplied elliptic
  family. -/
  heartTensorTorsionIsH2TensorEllipticTwoTorsion : Prop
  /-- Coordinates identifying each three-primary discriminant fibre with the
  three-torsion kernel of the realized source polarization. -/
  discriminantThreeCoordinates : ∀ parameter,
    objects.DiscriminantThree parameter ≃
      GraphLattices.sixAxisSourceThreePrimaryDiscriminant
  /-- Coordinates identifying each `H₃ ⊗ E[3]` fibre with four copies of the
  rank-two three-torsion module, after choosing a symplectic basis of the
  elliptic three-torsion. -/
  heartThreeTensorTorsionCoordinates : ∀ parameter,
    objects.HeartThreeTensorTorsion parameter ≃ (Fin 4 → Fin 2 → GraphLattices.F3)
  /-- The three-primary discriminant type represents the three-primary kernel
  of the source polarization. -/
  discriminantThreeIsSourcePolarizationKernel : Prop
  /-- The named tensor type represents `H₃ ⊗ E[3]` for the supplied elliptic
  family. -/
  heartThreeTensorTorsionIsH3TensorEllipticThreeTorsion : Prop
  /-- The discriminant identification is `A₅`-equivariant. -/
  discriminantEquivalenceA5Equivariant : Prop
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

/-- The polarization pullback identity forces the realized comparison matrix to
have determinant of absolute value `6⁴`, which is the degree of the relative
isogeny onto the principally polarized intermediate Jacobian. -/
theorem relativeSixAxisHomologyRealization_comparison_natAbs_det
    (realization : RelativeSixAxisHomologyRealization) :
    realization.comparison.det.natAbs = 6 ^ 4 :=
  GraphLattices.sixAxisPolarizationPullback_natAbs_det
    realization.jacobianPolarizationPrincipal realization.polarizationPullback

/-- The realized comparison matrix is injective on the integral source lattice,
the homology form of finiteness of the relative isogeny. -/
theorem relativeSixAxisHomologyRealization_comparison_injective
    (realization : RelativeSixAxisHomologyRealization) :
    Function.Injective realization.comparison.mulVec :=
  GraphLattices.sixAxisPolarizationPullback_mulVec_injective
    realization.jacobianPolarizationPrincipal realization.polarizationPullback

/-- The image, in the discriminant group of the six-axis source polarization,
of the cokernel of one fibre's comparison matrix.  This is the lattice model of
the kernel of the relative isogeny, seen inside the kernel of the source
polarization. -/
def relativeSixAxisKernelSubgroup (realization : RelativeSixAxisHomologyRealization) :
    Submodule ℤ GraphLattices.sixAxisSourceDiscriminantGroup :=
  GraphLattices.comparisonKernelSubgroup realization.polarizationPullback

/-- The lattice model of the isogeny kernel has order `6⁴` in the discriminant
group, which has order `6⁸`. -/
theorem relativeSixAxisKernelSubgroup_natCard
    (realization : RelativeSixAxisHomologyRealization) :
    Nat.card GraphLattices.sixAxisSourceDiscriminantGroup = 6 ^ 8 ∧
      Nat.card (relativeSixAxisKernelSubgroup realization) = 6 ^ 4 :=
  ⟨GraphLattices.natCard_sixAxisSourceDiscriminantGroup,
    GraphLattices.natCard_sixAxisSourceKernelSubgroup
      realization.jacobianPolarizationPrincipal realization.polarizationPullback⟩

/-- The lattice model of the isogeny kernel is a maximal isotropic subgroup of
the discriminant group of the source polarization: it equals its own orthogonal
complement for the `ℚ/ℤ`-valued discriminant pairing, and no larger subgroup is
isotropic. -/
theorem relativeSixAxisKernelSubgroup_isMaximalIsotropic
    (realization : RelativeSixAxisHomologyRealization) :
    GraphLattices.IsMaximalIsotropicSubgroup
      (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
      GraphLattices.sixAxisSourcePolarization_det_ne_zero
      (relativeSixAxisKernelSubgroup realization) :=
  GraphLattices.sixAxisSourceKernelSubgroup_isMaximalIsotropic
    realization.jacobianPolarizationPrincipal realization.polarizationPullback

/-- The `p`-primary part, for `p` two or three, of the lattice model of the
kernel of the relative isogeny on one fibre: its intersection with the
`p`-primary part of the discriminant group of the source polarization. -/
def relativeSixAxisPrimaryKernelSubgroup
    (realization : RelativeSixAxisHomologyRealization) (prime : ℤ) :
    Submodule ℤ GraphLattices.sixAxisSourceDiscriminantGroup :=
  GraphLattices.sixAxisSourcePrimaryKernelSubgroup realization.polarizationPullback prime

/-- The discriminant group of the source polarization is the direct sum of its
two- and three-primary parts, which are orthogonal for the `ℚ/ℤ`-valued
discriminant pairing. -/
theorem relativeSixAxisDiscriminantGroup_primaryDecomposition :
    GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ⊔
          GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3 = ⊤ ∧
      GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ⊓
          GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3 = ⊥ ∧
        ∀ left ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2,
          ∀ right ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3,
            GraphLattices.sixAxisSourceDiscriminantPairing left right = 0 :=
  GraphLattices.sixAxisSourceDiscriminant_primaryDecomposition

/-- On every fibre the lattice model of the isogeny kernel is the direct sum of
its two- and three-primary parts. -/
theorem relativeSixAxisKernelSubgroup_primaryDecomposition
    (realization : RelativeSixAxisHomologyRealization) :
    relativeSixAxisKernelSubgroup realization =
        relativeSixAxisPrimaryKernelSubgroup realization 2 ⊔
          relativeSixAxisPrimaryKernelSubgroup realization 3 ∧
      relativeSixAxisPrimaryKernelSubgroup realization 2 ⊓
          relativeSixAxisPrimaryKernelSubgroup realization 3 = ⊥ :=
  GraphLattices.sixAxisSourceKernelSubgroup_primaryDecomposition
    realization.polarizationPullback

/-- Each primary part of the lattice model of the isogeny kernel is maximal
among the isotropic subgroups of the corresponding primary part of the
discriminant group: it equals its own orthogonal complement taken inside that
part.  This is the lattice-level form of the manuscript's assertion about the
`p`-primary part of the kernel of the relative isogeny inside the `p`-primary
discriminant. -/
theorem relativeSixAxisPrimaryKernelSubgroup_isRelativeMaximalIsotropic
    (realization : RelativeSixAxisHomologyRealization) :
    GraphLattices.IsRelativeMaximalIsotropicSubgroup
        (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
        GraphLattices.sixAxisSourcePolarization_det_ne_zero
        (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2)
        (relativeSixAxisPrimaryKernelSubgroup realization 2) ∧
      GraphLattices.IsRelativeMaximalIsotropicSubgroup
        (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
        GraphLattices.sixAxisSourcePolarization_det_ne_zero
        (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3)
        (relativeSixAxisPrimaryKernelSubgroup realization 3) :=
  GraphLattices.sixAxisSourcePrimaryKernelSubgroup_isRelativeMaximalIsotropic
    realization.jacobianPolarizationPrincipal realization.polarizationPullback

/-- The two-primary discriminant identification `D₂ ≃ H₂ ⊗ E[2]`, constructed
from the two-torsion coordinates and from the computed kernel of the realized
source polarization rather than supplied. -/
noncomputable def relativeSixAxisDiscriminantEquivalence
    {Base : Type*} {objects : RelativeSixAxisObjects Base}
    (geometry : RelativeSixAxisGeometricInput objects) (parameter : Base) :
    objects.DiscriminantTwo parameter ≃ objects.HeartTensorTorsion parameter :=
  (geometry.discriminantTwoCoordinates parameter).trans
    (GraphLattices.sixAxisSourceTwoPrimaryDiscriminantCoordinates.toEquiv.trans
      (geometry.heartTensorTorsionCoordinates parameter).symm)

/-- The three-primary discriminant identification `D₃ ≃ H₃ ⊗ E[3]`, constructed
from the three-torsion coordinates and from the computed kernel of the realized
source polarization rather than supplied. -/
noncomputable def relativeSixAxisThreePrimaryDiscriminantEquivalence
    {Base : Type*} {objects : RelativeSixAxisObjects Base}
    (geometry : RelativeSixAxisGeometricInput objects) (parameter : Base) :
    objects.DiscriminantThree parameter ≃ objects.HeartThreeTensorTorsion parameter :=
  (geometry.discriminantThreeCoordinates parameter).trans
    (GraphLattices.sixAxisSourceThreePrimaryDiscriminantCoordinates.toEquiv.trans
      (geometry.heartThreeTensorTorsionCoordinates parameter).symm)

/-- Fibrewise standard-coordinate data identifying the supplied geometric
two-primary kernel with a diagonally stable maximal-isotropic subspace of the
explicit rank-eight discriminant. -/
structure RelativeSixAxisKernelCoordinateInput
    {Base : Type*} (objects : RelativeSixAxisObjects Base)
    (geometry : RelativeSixAxisGeometricInput objects) where
  /-- Coordinates on each supplied discriminant fibre. -/
  discriminantCoordinates : ∀ parameter,
    objects.DiscriminantTwo parameter ≃
      GraphLattices.SixAxisStandardDiscriminantCoordinates
  /-- The coordinate subspace occupied by the geometric kernel fibre. -/
  kernelSubspace : Base → Submodule GraphLattices.F2
    GraphLattices.SixAxisStandardDiscriminantCoordinates
  /-- Every geometric kernel element maps into the displayed subspace. -/
  kernelInclusion_mem : ∀ parameter kernelElement,
    discriminantCoordinates parameter
        (geometry.kernelInclusion parameter kernelElement) ∈
      kernelSubspace parameter
  /-- Every vector of the displayed subspace comes from a geometric kernel
  element. -/
  kernelInclusion_surjective : ∀ parameter
      (vector : kernelSubspace parameter),
    ∃ kernelElement,
      discriminantCoordinates parameter
          (geometry.kernelInclusion parameter kernelElement) = vector.1
  /-- The transported kernel is stable under the two diagonal generators. -/
  diagonalStable : ∀ parameter,
    GraphLattices.SixAxisStandardDiscriminantGeneratorStable
      (kernelSubspace parameter)
  /-- The transported kernel is maximal isotropic for the explicit
  rank-eight form. -/
  maximalIsotropic : ∀ parameter,
    GraphLattices.IsMaximalIsotropic
      GraphLattices.sixAxisStandardDiscriminantBilinForm
      (kernelSubspace parameter)

/-- The supplied coordinate identification gives a fibrewise equivalence from
the geometric kernel carrier to its displayed standard-coordinate subspace. -/
noncomputable def relativeSixAxisKernelCoordinateEquiv
    {Base : Type*} {objects : RelativeSixAxisObjects Base}
    {geometry : RelativeSixAxisGeometricInput objects}
    (input : RelativeSixAxisKernelCoordinateInput objects geometry)
    (parameter : Base) :
    objects.KernelTwo parameter ≃ input.kernelSubspace parameter :=
  Equiv.ofBijective
    (fun kernelElement ↦
      ⟨input.discriminantCoordinates parameter
          (geometry.kernelInclusion parameter kernelElement),
        input.kernelInclusion_mem parameter kernelElement⟩)
    ⟨by
        intro left right equality
        apply geometry.kernelInclusionInjective parameter
        apply (input.discriminantCoordinates parameter).injective
        exact congrArg Subtype.val equality,
      by
        intro vector
        obtain ⟨kernelElement, equality⟩ :=
          input.kernelInclusion_surjective parameter vector
        exact ⟨kernelElement, Subtype.ext equality⟩⟩

/-- A fibrewise coordinate realization of the geometric kernel as a stable
maximal-isotropic subspace forces every fibre into the explicit five-member
projective-line packet. -/
theorem relativeSixAxisKernelCoordinateInput_packet
    {Base : Type*} {objects : RelativeSixAxisObjects Base}
    {geometry : RelativeSixAxisGeometricInput objects}
    (input : RelativeSixAxisKernelCoordinateInput objects geometry) :
    (∀ parameter,
      Nonempty (objects.KernelTwo parameter ≃ input.kernelSubspace parameter)) ∧
    ∀ parameter,
      (input.kernelSubspace parameter).map
          GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
        GraphLattices.SixPointHeartStableHalfPacket := by
  constructor
  · exact fun parameter ↦
      ⟨relativeSixAxisKernelCoordinateEquiv input parameter⟩
  · intro parameter
    exact (GraphLattices.sixAxisStandardDiscriminant_stablePacket_iff
      (input.kernelSubspace parameter)).mpr
        ⟨input.diagonalStable parameter, input.maximalIsotropic parameter⟩

/-- Relative-six-axis packet.  The scheme-theoretic assertions are supplied,
while the degree and finiteness of the comparison, the determinant of the
source polarization, the two-primary discriminant identification, the primary
splitting of the discriminant group with the relative maximal isotropy of each
primary part of the kernel, the integral Smith witness, the two-primary
coefficient discriminant, and the explicit stable maximal-isotropic packet are
proved by Lean. -/
structure RelativeSixAxisConclusion
    {Base : Type*} (objects : RelativeSixAxisObjects Base) : Prop where
  /-- All relative geometric assertions of the lemma. -/
  geometryExists : Nonempty (RelativeSixAxisGeometricInput objects)
  /-- The integral source polarization has determinant `6⁸`, so the source
  polarization has kernel of that order. -/
  sourcePolarizationDeterminant :
    (GraphLattices.sixAxisSourcePolarization ℤ).det = 6 ^ 8
  /-- On every fibre the realized comparison matrix has determinant of
  absolute value `6⁴` and is injective on the source lattice. -/
  comparisonDegreeAndFiniteness :
    ∀ (geometry : RelativeSixAxisGeometricInput objects) (parameter : Base),
      (geometry.homology parameter).comparison.det.natAbs = 6 ^ 4 ∧
        Function.Injective (geometry.homology parameter).comparison.mulVec
  /-- On every fibre the discriminant group of the realized source polarization
  has order `6⁸`, the lattice model of the isogeny kernel inside it has order
  `6⁴`, and that subgroup is maximal isotropic for the `ℚ/ℤ`-valued
  discriminant pairing. -/
  discriminantGroupAndKernel :
    ∀ (geometry : RelativeSixAxisGeometricInput objects) (parameter : Base),
      Nat.card GraphLattices.sixAxisSourceDiscriminantGroup = 6 ^ 8 ∧
        Nat.card (relativeSixAxisKernelSubgroup (geometry.homology parameter)) = 6 ^ 4 ∧
          GraphLattices.IsMaximalIsotropicSubgroup
            (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
            GraphLattices.sixAxisSourcePolarization_det_ne_zero
            (relativeSixAxisKernelSubgroup (geometry.homology parameter))
  /-- On every fibre the discriminant group of the source polarization is the
  direct sum of its two- and three-primary parts, those parts are orthogonal
  for the discriminant pairing, the lattice model of the isogeny kernel is the
  direct sum of its own two- and three-primary parts, and each of those is
  maximal among the isotropic subgroups of the corresponding primary part of
  the discriminant group. -/
  primaryDiscriminantSplittingAndKernel :
    ∀ (geometry : RelativeSixAxisGeometricInput objects) (parameter : Base),
      (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ⊔
            GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3 = ⊤ ∧
          GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ⊓
            GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3 = ⊥ ∧
          ∀ left ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2,
            ∀ right ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3,
              GraphLattices.sixAxisSourceDiscriminantPairing left right = 0) ∧
        (relativeSixAxisKernelSubgroup (geometry.homology parameter) =
              relativeSixAxisPrimaryKernelSubgroup (geometry.homology parameter) 2 ⊔
                relativeSixAxisPrimaryKernelSubgroup (geometry.homology parameter) 3 ∧
            relativeSixAxisPrimaryKernelSubgroup (geometry.homology parameter) 2 ⊓
              relativeSixAxisPrimaryKernelSubgroup (geometry.homology parameter) 3 = ⊥) ∧
          GraphLattices.IsRelativeMaximalIsotropicSubgroup
              (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
              GraphLattices.sixAxisSourcePolarization_det_ne_zero
              (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2)
              (relativeSixAxisPrimaryKernelSubgroup (geometry.homology parameter) 2) ∧
            GraphLattices.IsRelativeMaximalIsotropicSubgroup
              (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
              GraphLattices.sixAxisSourcePolarization_det_ne_zero
              (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3)
              (relativeSixAxisPrimaryKernelSubgroup (geometry.homology parameter) 3)
  /-- The two-primary discriminant identification `D₂ ≃ H₂ ⊗ E[2]` is
  constructed from the realized polarization rather than supplied: in the
  supplied two-torsion coordinates it is the computed kernel equivalence of the
  two-torsion source polarization. -/
  twoPrimaryDiscriminantEquivalence :
    ∀ (geometry : RelativeSixAxisGeometricInput objects) (parameter : Base)
      (fibre : objects.DiscriminantTwo parameter),
      geometry.heartTensorTorsionCoordinates parameter
          (relativeSixAxisDiscriminantEquivalence geometry parameter fibre) =
        GraphLattices.sixAxisSourceTwoPrimaryDiscriminantCoordinates
          (geometry.discriminantTwoCoordinates parameter fibre)
  /-- The three-primary discriminant identification `D₃ ≃ H₃ ⊗ E[3]` is
  likewise constructed: in the supplied three-torsion coordinates it is the
  computed kernel equivalence of the three-torsion source polarization. -/
  threePrimaryDiscriminantEquivalence :
    ∀ (geometry : RelativeSixAxisGeometricInput objects) (parameter : Base)
      (fibre : objects.DiscriminantThree parameter),
      geometry.heartThreeTensorTorsionCoordinates parameter
          (relativeSixAxisThreePrimaryDiscriminantEquivalence geometry parameter
            fibre) =
        GraphLattices.sixAxisSourceThreePrimaryDiscriminantCoordinates
          (geometry.discriminantThreeCoordinates parameter fibre)
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
  /-- Every isotropic four-dimensional subspace of the explicit rank-eight
  discriminant is maximal isotropic. -/
  twoPrimaryMaximalIsotropicCriterion :
    ∀ subspace : Submodule GraphLattices.F2
        GraphLattices.SixAxisStandardDiscriminantCoordinates,
      subspace ≤
          GraphLattices.sixAxisStandardDiscriminantBilinForm.orthogonal
            subspace →
      Module.finrank GraphLattices.F2 subspace = 4 →
      GraphLattices.IsMaximalIsotropic
        GraphLattices.sixAxisStandardDiscriminantBilinForm subspace
  /-- Under the explicit symplectic coordinate equivalence with two heart
  copies, the five projective-line packet members are exactly the diagonally
  stable maximal-isotropic subspaces of the rank-eight discriminant. -/
  twoPrimaryStableMaximalIsotropicPacket :
    ∀ subspace : Submodule GraphLattices.F2
        GraphLattices.SixAxisStandardDiscriminantCoordinates,
      subspace.map
          GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
          GraphLattices.SixPointHeartStableHalfPacket ↔
        GraphLattices.SixAxisStandardDiscriminantGeneratorStable subspace ∧
          GraphLattices.IsMaximalIsotropic
            GraphLattices.sixAxisStandardDiscriminantBilinForm subspace

/-- Package the supplied relative-six-axis fields with the degree, finiteness,
and two-primary discriminant consequences of the realized polarization pullback
and with the independently proved integral Smith witness and two-primary
coefficient calculation. -/
theorem relativeSixAxis_of_geometricInputs
    {Base : Type*} (objects : RelativeSixAxisObjects Base)
    (geometry : RelativeSixAxisGeometricInput objects) :
    RelativeSixAxisConclusion objects :=
  ⟨⟨geometry⟩,
    GraphLattices.sixAxisSourcePolarization_det,
    fun otherGeometry parameter ↦
      ⟨relativeSixAxisHomologyRealization_comparison_natAbs_det
          (otherGeometry.homology parameter),
        relativeSixAxisHomologyRealization_comparison_injective
          (otherGeometry.homology parameter)⟩,
    fun otherGeometry parameter ↦
      ⟨(relativeSixAxisKernelSubgroup_natCard (otherGeometry.homology parameter)).1,
        (relativeSixAxisKernelSubgroup_natCard (otherGeometry.homology parameter)).2,
        relativeSixAxisKernelSubgroup_isMaximalIsotropic (otherGeometry.homology parameter)⟩,
    fun otherGeometry parameter ↦
      ⟨relativeSixAxisDiscriminantGroup_primaryDecomposition,
        relativeSixAxisKernelSubgroup_primaryDecomposition (otherGeometry.homology parameter),
        (relativeSixAxisPrimaryKernelSubgroup_isRelativeMaximalIsotropic
          (otherGeometry.homology parameter)).1,
        (relativeSixAxisPrimaryKernelSubgroup_isRelativeMaximalIsotropic
          (otherGeometry.homology parameter)).2⟩,
    fun otherGeometry parameter _ ↦
      (otherGeometry.heartTensorTorsionCoordinates parameter).apply_symm_apply _,
    fun otherGeometry parameter _ ↦
      (otherGeometry.heartThreeTensorTorsionCoordinates parameter).apply_symm_apply _,
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
      GraphLattices.sixAxisStandardDiscriminantBilinForm_nondegenerate⟩,
    GraphLattices.sixAxisStandardDiscriminant_maximalIsotropic_of_finrank_four,
    GraphLattices.sixAxisStandardDiscriminant_stablePacket_iff⟩

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
