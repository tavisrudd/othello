import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.ProjectiveProductMultiplicity
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.RelativeSixAxis
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.AlternatingFiveIdentification
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.ConnectedPacketPersistence
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.ExoticStabilizerCore
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.FrobeniusNormalizer
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.FrobeniusPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.HeartOrthogonalLines
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.IntegralDiscriminantGroup
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.PrimaryDiscriminantSplitting
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.PrincipalGluingPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisDiscriminantGroup
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisGram
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisLocalChart
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisPrimaryDiscriminantSplitting
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisSlopeModels
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisSourcePermutationAction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisSourcePolarization
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisThreePrimaryHeartCoordinates
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisThreePrimaryLatticeComparison
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisThreePrimaryPairing
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisTwoPrimaryDiscriminant
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisTwoPrimaryLatticeComparison
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisTwoPrimaryPairing
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisTwoPrimaryStandardCoordinates
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointAlternatingAction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointAxisDescent
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointAxisFixedLine
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointAxisNorm
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointAxisTransport
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointCoefficientHeart
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointDuadFactorization
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointHeartEndomorphisms
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointIntegralQuotient
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointLabelHeartMatrix
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointOddLabelHeartAction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointPacketLabelGroup
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointProjectiveLine
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointProjectiveSpecialLinearAction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointStableHalfFrobenius
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointStableHalves
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointSylowFiveAction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointThreePrimary
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SymmetricSixExclusion
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.TraceDeterminantPairing
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.AssociatedGradedTagging
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedNovikovInverseLimit
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedNovikovSupport
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.EffectiveBlockLedger
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredCoefficientQuotients
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.HirzebruchEulerSpectrum
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.QuarticDiscriminantDerivations
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoResidueMarker

/-!
# Six-axis envelope and polarization reviewer terminals

Six-axis envelope, polarization, and finite-packet terminals.  Geometric and
literature inputs remain explicit in the declaration types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

open TensorProduct

open scoped MatrixGroups

/-- Interface for the relative six-axis source.  The supplied geometric input
now carries an integral first-homology realization of every fibre — a
unimodular alternating form for the intermediate Jacobian, an integral
comparison matrix, and the polarization pullback identity between them — and
torsion coordinates on the two- and three-primary discriminants and on the
`H₂ ⊗ E[2]` and `H₃ ⊗ E[3]` fibres.
From that data Lean proves the source polarization has determinant `6⁸`, every
comparison matrix has determinant of absolute value `6⁴` and is injective, and
each primary discriminant identification is the computed kernel equivalence
in those coordinates.  The families of elliptic, source, Jacobian, and kernel
fibres, the assertion that the displayed matrices are the ones induced by the
relative geometry, the `A₅`/`S₆` equivariance, the kernel description, and its
maximal isotropy remain supplied propositions with no scheme-theoretic
semantics.  Lean further contributes the integral Smith reduction of the
identified five-axis Gram matrix and, for every `F₂`-module `T`, an explicit
linear equivalence between the tensor-extended two-primary coefficient kernel
and four copies of `T`.  In particular, a two-dimensional tensor factor gives a
kernel of order `2⁸`, and the scalar coordinates agree with the six-point
coefficient heart.
The normalized heart dot product is proved bilinear, alternating, and
nondegenerate, and every word in the generated six-point action preserves it.
After choosing a symplectic basis of a two-dimensional tensor factor, the
induced rank-eight tensor-product form is also alternating and nondegenerate.
Every isotropic four-dimensional subspace of this model is proved maximal
isotropic.  Under the explicit symplectic coordinate equivalence with two
heart copies, the five projective-line packet members are exactly the
diagonally stable maximal-isotropic subspaces of this rank-eight model.
The named proposition fields do not define
scheme-theoretic semantics, and Lean constructs no relative scheme, torsion
local system, or geometric group action. -/
theorem relativeSixAxis_of_supplied_relative_geometry
    {Base : Type*} (objects : Applications.RelativeSixAxisObjects Base)
    (geometry : Applications.RelativeSixAxisGeometricInput objects) :
    Applications.RelativeSixAxisConclusion objects :=
  Applications.relativeSixAxis_of_geometricInputs objects geometry
/-- Degree and finiteness of the six-axis comparison from its polarization
pullback identity.  For an integral first-homology realization — a unimodular
alternating form standing for the principal polarization of the intermediate
Jacobian, an integral comparison matrix, and the identity that the comparison
pulls the former back to the Kronecker polarization of the six-axis source —
the source polarization has determinant `6⁸`, the comparison has determinant of
absolute value `6⁴`, and the comparison is injective on the integral source
lattice.  These are the homology-level forms of the manuscript's kernel order
`6⁸`, isogeny degree `6⁴`, and finiteness; the identification of the displayed
matrices with the maps induced by an actual elliptic scheme and relative
morphism is supplied, not proved. -/
theorem relativeSixAxis_polarizationPullback_degree
    (realization : Applications.RelativeSixAxisHomologyRealization) :
    (GraphLattices.sixAxisSourcePolarization ℤ).det = 6 ^ 8 ∧
      realization.comparison.det.natAbs = 6 ^ 4 ∧
        Function.Injective realization.comparison.mulVec :=
  ⟨GraphLattices.sixAxisSourcePolarization_det,
    Applications.relativeSixAxisHomologyRealization_comparison_natAbs_det realization,
    Applications.relativeSixAxisHomologyRealization_comparison_injective realization⟩
/-- The discriminant group of the six-axis source polarization and the lattice
model of the isogeny kernel inside it.  The discriminant group is the dual
quotient `Λ^#/Λ` of the integral source lattice, presented as the cokernel of
the polarization; it has order `6⁸`.  From a fibre's homology realization —
a unimodular alternating polarization matrix for the Jacobian fibre, an
integral comparison matrix, and the pullback identity between them — the image
of the comparison cokernel in that group has order `6⁴`, equals its own
orthogonal complement for the `ℚ/ℤ`-valued discriminant pairing, and is
therefore maximal among isotropic subgroups.  These are the manuscript's order
of the kernel of the source polarization, degree of the relative isogeny, and
maximal isotropy of its kernel, proved for the supplied integral matrices; no
abelian scheme, isogeny, Weil pairing, or geometric commutator pairing is
constructed.  The primary refinement is
`relativeSixAxis_primaryDiscriminantSplitting_maximalIsotropicKernels`. -/
theorem relativeSixAxis_discriminantGroup_maximalIsotropicKernel
    (realization : Applications.RelativeSixAxisHomologyRealization) :
    Nat.card GraphLattices.sixAxisSourceDiscriminantGroup = 6 ^ 8 ∧
      Nat.card (Applications.relativeSixAxisKernelSubgroup realization) = 6 ^ 4 ∧
        Applications.relativeSixAxisKernelSubgroup realization =
            GraphLattices.discriminantPerp
              (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
              GraphLattices.sixAxisSourcePolarization_det_ne_zero
              (Applications.relativeSixAxisKernelSubgroup realization) ∧
          GraphLattices.IsMaximalIsotropicSubgroup
            (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
            GraphLattices.sixAxisSourcePolarization_det_ne_zero
            (Applications.relativeSixAxisKernelSubgroup realization) :=
  ⟨(Applications.relativeSixAxisKernelSubgroup_natCard realization).1,
    (Applications.relativeSixAxisKernelSubgroup_natCard realization).2,
    GraphLattices.sixAxisSourceKernelSubgroup_eq_perp
      realization.jacobianPolarizationPrincipal realization.polarizationPullback,
    Applications.relativeSixAxisKernelSubgroup_isMaximalIsotropic realization⟩
/-- Primary splitting of the six-axis source discriminant group, and relative
maximal isotropy of each primary part of the lattice model of the isogeny
kernel.  The source polarization times its integral cofactor — the Kronecker
product of `I₅+J₅` with the inverse of the rank-two elliptic homology pairing —
is six times the identity, so six annihilates the discriminant group.  Two and
three are coprime, so Bezout's identity splits that group into its two- and
three-torsion parts, which meet only in zero; a class annihilated by a power of
one of the two primes is annihilated by that prime itself, so these parts are
the primary parts in the usual sense.  They are orthogonal for the `ℚ/ℤ`-valued
discriminant pairing, since a value annihilated by two and by three vanishes.
From a fibre's homology realization the lattice model of the isogeny kernel
splits along the same decomposition, and each of its primary parts equals its
own orthogonal complement taken inside the corresponding primary part of the
discriminant group, hence is maximal among the isotropic subgroups of that
part.  This is the manuscript's assertion that the `p`-primary part of the
kernel of the relative isogeny is a relative maximal isotropic subgroup of the
`p`-primary discriminant, proved for the supplied integral matrices; no abelian
scheme, isogeny, torsion local system, Weil pairing, or geometric commutator
pairing is constructed, and no order of a primary part is claimed. -/
theorem relativeSixAxis_primaryDiscriminantSplitting_maximalIsotropicKernels
    (realization : Applications.RelativeSixAxisHomologyRealization) :
    (∀ element : GraphLattices.sixAxisSourceDiscriminantGroup,
        (element ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ↔
            ∃ exponent : ℕ, ((2 : ℤ) ^ exponent) • element = 0) ∧
          (element ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3 ↔
            ∃ exponent : ℕ, ((3 : ℤ) ^ exponent) • element = 0)) ∧
      (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ⊔
            GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3 = ⊤ ∧
          GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ⊓
            GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3 = ⊥ ∧
          ∀ left ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2,
            ∀ right ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3,
              GraphLattices.sixAxisSourceDiscriminantPairing left right = 0) ∧
        (Applications.relativeSixAxisKernelSubgroup realization =
              Applications.relativeSixAxisPrimaryKernelSubgroup realization 2 ⊔
                Applications.relativeSixAxisPrimaryKernelSubgroup realization 3 ∧
            Applications.relativeSixAxisPrimaryKernelSubgroup realization 2 ⊓
              Applications.relativeSixAxisPrimaryKernelSubgroup realization 3 = ⊥) ∧
          GraphLattices.IsRelativeMaximalIsotropicSubgroup
              (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
              GraphLattices.sixAxisSourcePolarization_det_ne_zero
              (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2)
              (Applications.relativeSixAxisPrimaryKernelSubgroup realization 2) ∧
            GraphLattices.IsRelativeMaximalIsotropicSubgroup
              (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
              GraphLattices.sixAxisSourcePolarization_det_ne_zero
              (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3)
              (Applications.relativeSixAxisPrimaryKernelSubgroup realization 3) :=
  ⟨GraphLattices.mem_sixAxisSourceDiscriminantPrimaryPart_iff_exists_pow,
    Applications.relativeSixAxisDiscriminantGroup_primaryDecomposition,
    Applications.relativeSixAxisKernelSubgroup_primaryDecomposition realization,
    (Applications.relativeSixAxisPrimaryKernelSubgroup_isRelativeMaximalIsotropic realization).1,
    (Applications.relativeSixAxisPrimaryKernelSubgroup_isRelativeMaximalIsotropic realization).2⟩
/-- Orders of the two primary parts of the lattice model of the isogeny kernel.
The whole lattice model has order `6⁴` and is the direct sum of its two- and
three-primary parts; those parts sit inside the corresponding primary parts of
the discriminant group, of orders `2⁸` and `3⁸`, so Lagrange's theorem
distributes the two prime-power factors of `6⁴` one to each part: the
two-primary part has order `2⁴` and the three-primary part has order `3⁴`.
These are the manuscript's per-prime orders of the kernel of the relative
isogeny, proved for the supplied integral matrices.  The maximal isotropy of
each primary part is proved separately and is not used here; no abelian scheme,
isogeny, Weil pairing, or geometric commutator pairing is constructed. -/
theorem relativeSixAxis_primaryKernelOrders
    (realization : Applications.RelativeSixAxisHomologyRealization) :
    Nat.card
        (Applications.relativeSixAxisPrimaryKernelSubgroup realization 2) =
        2 ^ 4 ∧
      Nat.card
        (Applications.relativeSixAxisPrimaryKernelSubgroup realization 3) =
        3 ^ 4 :=
  Applications.relativeSixAxisPrimaryKernelSubgroup_natCard realization
/-- The two-primary part of the source discriminant group is the kernel of the
two-torsion reduction of the source polarization.  Two models of the
two-primary discriminant occur in this development: the two-torsion part of the
cokernel of the integral polarization, and the kernel of that polarization
reduced modulo two, which is the model carrying the coefficient heart, the
rank-eight tensor form, and the classification of stable maximal-isotropic
subspaces.  The comparison between them is division free: the polarization has
an integral cofactor `C` with `F C = C F = 6`, so the reduction modulo two of
`C v` depends only on the class of `v`.  That map kills exactly the
three-primary part, lands in the kernel of the reduced polarization, and is
onto it, so it restricts to an isomorphism of abelian groups from the
two-primary part of the discriminant group onto that kernel, and hence onto
four copies of the rank-two two-torsion module in the normalized coefficient
coordinates.  This is the lattice-level form of the manuscript's two-primary
identification `D₂ ≃ H₂ ⊗ E[2]`; no elliptic two-torsion group scheme, Weil
pairing, or geometric discriminant is constructed, and no compatibility with a
pairing is asserted here. -/
theorem relativeSixAxis_twoPrimaryDiscriminantLatticeModel :
    LinearMap.ker GraphLattices.sixAxisSourceTwoPrimaryComparison =
        GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3 ∧
      (∀ element : GraphLattices.sixAxisSourceDiscriminantGroup,
          GraphLattices.sixAxisSourceTwoPrimaryComparison element ∈
            GraphLattices.sixAxisSourceTwoPrimaryDiscriminant) ∧
        Nonempty (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ≃+
            GraphLattices.sixAxisSourceTwoPrimaryDiscriminant) ∧
          Nonempty (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ≃+
            (Fin 4 → Fin 2 → GraphLattices.F2)) :=
  ⟨GraphLattices.sixAxisSourceTwoPrimaryComparison_ker,
    GraphLattices.sixAxisSourceTwoPrimaryComparison_mem_kernel,
    ⟨GraphLattices.sixAxisSourceTwoPrimaryLatticeEquiv⟩,
    ⟨GraphLattices.sixAxisSourceTwoPrimaryLatticeCoordinates⟩⟩
/-- The discriminant pairing on the two-primary part of the source
discriminant, read in the kernel of the reduced polarization, and the resulting
self-duality of the two-primary kernel there.  The adjugate of the source
polarization is `6⁷` times its integral cofactor, so the discriminant pairing
of two classes vanishes exactly when six divides the cofactor form of two
representatives.  Writing two-torsion classes as halves of polarization images,
`2 v = F y`, that condition becomes divisibility of `y ⬝ F z` by four, and the
halved value reduces modulo two to the tensor of the dot product on axis
coordinates with the reduced elliptic homology pairing — the manuscript's
normalized two-primary pairing.  Since the comparison sends the class of `v` to
the reduction of `y`, the discriminant pairing of two two-torsion classes
vanishes exactly when that normalized form of their comparison images does.
Consequently the image of the two-primary part of the lattice model of the
isogeny kernel is exactly its own orthogonal complement inside the kernel of
the reduced polarization, which is the relative maximal isotropy of the
two-primary kernel read in the model carrying the coefficient heart.  No
elliptic two-torsion group scheme, Weil pairing, or geometric commutator
pairing is constructed, and the normalized form is not here identified with the
rank-eight tensor form in the standard symplectic coordinates. -/
theorem relativeSixAxis_twoPrimaryDiscriminantPairing
    (realization : Applications.RelativeSixAxisHomologyRealization) :
    (GraphLattices.sixAxisSourcePolarization ℤ).adjugate =
        (6 ^ 7 : ℤ) • GraphLattices.sixAxisSourcePolarizationCofactor ∧
      (∀ leftClass ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2,
          ∀ rightClass ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2,
            (GraphLattices.sixAxisSourceDiscriminantPairing leftClass rightClass = 0 ↔
              GraphLattices.sixAxisReducedTensorForm
                (GraphLattices.sixAxisSourceTwoPrimaryComparison leftClass)
                (GraphLattices.sixAxisSourceTwoPrimaryComparison rightClass) = 0)) ∧
        ∀ vector ∈ GraphLattices.sixAxisSourceTwoPrimaryDiscriminant,
          ((∀ other ∈ Applications.relativeSixAxisTwoPrimaryKernelImage realization,
              GraphLattices.sixAxisReducedTensorForm vector other = 0) ↔
            vector ∈ Applications.relativeSixAxisTwoPrimaryKernelImage realization) :=
  ⟨GraphLattices.sixAxisSourcePolarization_adjugate,
    (Applications.relativeSixAxisTwoPrimaryKernelImage_eq_perp realization).1,
    (Applications.relativeSixAxisTwoPrimaryKernelImage_eq_perp realization).2⟩
/-- The two-primary kernel in the standard symplectic coordinates, and its
membership in the projective-line packet.  The coordinate equivalence on the
kernel of the reduced polarization is an isometry from the normalized
two-primary form onto the rank-eight tensor form of the coefficient heart: a
kernel vector has vanishing axis coordinate sum along each elliptic homology
coordinate, so in characteristic two its fifth axis coordinate is the sum of
the other four, which is exactly the fifth entry of the normalized heart
representative, and the five-term dot product of two kernel slices is the
six-term dot product of the corresponding heart representatives.  Carrying the
two-primary part of the lattice model of the isogeny kernel across that
isometry therefore gives a subspace of the standard coordinates that is maximal
isotropic for the rank-eight tensor form, and it belongs to the five-member
projective-line packet as soon as it is stable under the two diagonal
generators.  Stability is the only remaining input; no elliptic two-torsion
group scheme, Weil pairing, geometric group action, or geometric classifying
map is constructed. -/
theorem relativeSixAxis_twoPrimaryKernelStandardCoordinates
    (realization : Applications.RelativeSixAxisHomologyRealization) :
    (∀ left right : GraphLattices.sixAxisSourceTwoPrimaryDiscriminant,
        GraphLattices.sixAxisReducedTensorForm left.1 right.1 =
          GraphLattices.sixAxisStandardDiscriminantForm
            (GraphLattices.sixAxisSourceTwoPrimaryDiscriminantCoordinates left)
            (GraphLattices.sixAxisSourceTwoPrimaryDiscriminantCoordinates right)) ∧
      GraphLattices.IsMaximalIsotropic GraphLattices.sixAxisStandardDiscriminantBilinForm
          (Applications.relativeSixAxisTwoPrimaryKernelCoordinates realization) ∧
        (GraphLattices.SixAxisStandardDiscriminantGeneratorStable
            (Applications.relativeSixAxisTwoPrimaryKernelCoordinates realization) →
          (Applications.relativeSixAxisTwoPrimaryKernelCoordinates realization).map
              GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
            GraphLattices.SixPointHeartStableHalfPacket) :=
  ⟨GraphLattices.sixAxisReducedTensorForm_eq_standardForm,
    (Applications.relativeSixAxisTwoPrimaryKernelCoordinates_isMaximalIsotropic realization).1,
    (Applications.relativeSixAxisTwoPrimaryKernelCoordinates_isMaximalIsotropic realization).2⟩
/-- The orders of the two primary parts of the source discriminant group.
Each primary part is carried by the reduction of the cofactor image
isomorphically onto the kernel of the polarization reduced at that prime, and
that kernel is four copies of the rank-two module over the prime field, so the
two-primary part has order `2⁸` and the three-primary part has order `3⁸`.
Together with the order `6⁸` of the whole discriminant group this is the
splitting of that order into its prime-power factors.  These are orders of
subgroups of the cokernel of an explicit integral matrix; no geometric torsion
local system is constructed. -/
theorem relativeSixAxis_primaryDiscriminantOrders :
    Nat.card (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2) = 2 ^ 8 ∧
      Nat.card (GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3) = 3 ^ 8 :=
  ⟨GraphLattices.natCard_sixAxisSourceDiscriminantPrimaryPart_two,
    GraphLattices.natCard_sixAxisSourceDiscriminantPrimaryPart_three⟩
/-- The three-primary part of the source discriminant as the kernel of the
polarization reduced modulo three, and the normalized three-primary pairing on
it.  The reduction modulo three of the cofactor image is defined on the
discriminant group because `C F = 6`; its kernel is exactly the two-primary
part, so it embeds the three-primary part into the kernel of the reduced
polarization, and every vector of that kernel is reached.  On three-torsion
classes, written as thirds `3 v = F y` of polarization images, the discriminant
pairing vanishes exactly when nine divides `y ⬝ F z`, and the value
`(y ⬝ F z)/3` reduces modulo three to minus the dot product on axis
coordinates tensored with the reduced elliptic pairing, which is the
manuscript's normalized three-primary form; the comparison sends the class of
`v` to `-ȳ`, and that form is unchanged by negating both arguments.
Consequently the image of the three-primary part of the lattice model of the
isogeny kernel is exactly its own orthogonal complement inside the kernel of
the reduced polarization, which is the relative maximal isotropy of the
three-primary kernel read in the model carrying the three-primary coefficient
heart.  No elliptic three-torsion group scheme, Weil pairing, or geometric
commutator pairing is constructed, and the normalized form is not here
identified with the two-copy polarization form of the heart. -/
theorem relativeSixAxis_threePrimaryDiscriminantPairing
    (realization : Applications.RelativeSixAxisHomologyRealization) :
    LinearMap.ker GraphLattices.sixAxisSourceThreePrimaryComparison =
        GraphLattices.sixAxisSourceDiscriminantPrimaryPart 2 ∧
      (∀ leftClass ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3,
          ∀ rightClass ∈ GraphLattices.sixAxisSourceDiscriminantPrimaryPart 3,
            (GraphLattices.sixAxisSourceDiscriminantPairing leftClass rightClass = 0 ↔
              GraphLattices.sixAxisThreeReducedTensorForm
                (GraphLattices.sixAxisSourceThreePrimaryComparison leftClass)
                (GraphLattices.sixAxisSourceThreePrimaryComparison rightClass) = 0)) ∧
        ∀ vector ∈ GraphLattices.sixAxisSourceThreePrimaryDiscriminant,
          ((∀ other ∈ Applications.relativeSixAxisThreePrimaryKernelImage realization,
              GraphLattices.sixAxisThreeReducedTensorForm vector other = 0) ↔
            vector ∈ Applications.relativeSixAxisThreePrimaryKernelImage realization) :=
  ⟨GraphLattices.sixAxisSourceThreePrimaryComparison_ker,
    (Applications.relativeSixAxisThreePrimaryKernelImage_eq_perp realization).1,
    (Applications.relativeSixAxisThreePrimaryKernelImage_eq_perp realization).2⟩
/-- The three-primary kernel in the two-heart coordinates, and its membership
in the vertical-and-scalar-graph packet.  The coordinate equivalence on the
kernel of the reduced polarization is an isometry from the normalized
three-primary form onto the two-copy polarization form of the three-primary
coefficient heart: a kernel vector has vanishing axis coordinate sum along each
elliptic homology coordinate, so its fifth axis coordinate is minus the sum of
the other four, which is exactly the fifth entry of the normalized heart
representative, and minus the five-term dot product of two kernel slices is the
coefficient form of the corresponding heart vectors.  Carrying the three-primary
part of the lattice model of the isogeny kernel across that isometry therefore
gives a subspace of two heart copies that is maximal isotropic and, by the
half-dimension count in an eight-dimensional nondegenerate alternating space,
four-dimensional; it is the vertical copy or one of the three scalar graphs as
soon as it is stable under the two diagonal generators.  Stability is the only
remaining input; no elliptic three-torsion group scheme, Weil pairing,
geometric group action, or geometric classifying map is constructed. -/
theorem relativeSixAxis_threePrimaryKernelHeartCoordinates
    (realization : Applications.RelativeSixAxisHomologyRealization) :
    (∀ left right : GraphLattices.sixAxisSourceThreePrimaryDiscriminant,
        GraphLattices.sixAxisThreeReducedTensorForm left.1 right.1 =
          GraphLattices.sixPointThreeHeartPairPolarizationForm
            (GraphLattices.sixAxisSourceThreePrimaryHeartCoordinates left)
            (GraphLattices.sixAxisSourceThreePrimaryHeartCoordinates right)) ∧
      GraphLattices.IsMaximalIsotropic
          GraphLattices.sixPointThreeHeartPairPolarizationBilinForm
          (Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates realization) ∧
        Module.finrank GraphLattices.F3
            (Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates realization) = 4 ∧
          (GraphLattices.SixPointThreeHeartPairGeneratorStable
              (Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates realization) →
            Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates realization ∈
              GraphLattices.SixPointThreeHeartStableHalfPacket) :=
  ⟨GraphLattices.sixAxisThreeReducedTensorForm_eq_pairPolarizationForm,
    (Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates_isMaximalIsotropic
      realization).1,
    (Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates_isMaximalIsotropic
      realization).2.1,
    (Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates_isMaximalIsotropic
      realization).2.2⟩
/-- The six-label permutation action on the polarized source lattice.  A
permutation acts on coordinate families by inverse precomposition; in the
five-coordinate chart of the six-label quotient by the constant line the
induced map has an explicit integral matrix, these matrices carry the identity
to the identity and products to products, and each of them preserves the
coefficient matrix `6I₅-J₅`.  Acting trivially on the rank-two elliptic
homology coordinate extends the representation to the source lattice, where it
preserves the source polarization; the contragredient action, the transpose of
the matrix of the inverse permutation, intertwines the polarization with the
action and commutes in the same sense with the integral cofactor, which is what
makes it descend to the discriminant group in its cokernel presentation.  The
alternating action in question is the restriction to the two displayed
permutations of the six labels and their words, which realize, faithfully and
onto, the alternating group on the five matchings of the displayed
one-factorization.  This is an action on explicit integral matrices; no
geometric group action, abelian scheme, or identification of the six labels
with the manuscript's dihedral axes is constructed. -/
theorem relativeSixAxis_sourceLatticePermutationAction :
    (∀ permutation : Equiv.Perm (Fin 6),
        Matrix.transpose (GraphLattices.sixAxisSourcePermutationMatrix ℤ permutation) *
            GraphLattices.sixAxisSourcePolarization ℤ *
              GraphLattices.sixAxisSourcePermutationMatrix ℤ permutation =
          GraphLattices.sixAxisSourcePolarization ℤ) ∧
      (GraphLattices.sixPointChartMatrix ℤ 1 = 1 ∧
          ∀ left right : Equiv.Perm (Fin 6),
            GraphLattices.sixPointChartMatrix ℤ (left * right) =
              GraphLattices.sixPointChartMatrix ℤ left *
                GraphLattices.sixPointChartMatrix ℤ right) ∧
        (∀ permutation : Equiv.Perm (Fin 6),
            Matrix.transpose (GraphLattices.sixPointChartMatrix ℤ permutation) *
                GraphLattices.sixAxisGram ℤ *
                  GraphLattices.sixPointChartMatrix ℤ permutation =
              GraphLattices.sixAxisGram ℤ) ∧
          ∀ permutation : Equiv.Perm (Fin 6),
            GraphLattices.sixAxisSourceDualPermutationMatrix permutation *
                  GraphLattices.sixAxisSourcePolarization ℤ =
                GraphLattices.sixAxisSourcePolarization ℤ *
                  GraphLattices.sixAxisSourcePermutationMatrix ℤ permutation ∧
              GraphLattices.sixAxisSourcePolarizationCofactor *
                  GraphLattices.sixAxisSourceDualPermutationMatrix permutation =
                GraphLattices.sixAxisSourcePermutationMatrix ℤ permutation *
                  GraphLattices.sixAxisSourcePolarizationCofactor :=
  ⟨GraphLattices.sixAxisSourcePermutationMatrix_polarization,
    ⟨GraphLattices.sixPointChartMatrix_one, fun left right ↦
      GraphLattices.sixPointChartMatrix_mul left right⟩,
    GraphLattices.sixPointChartMatrix_gram,
    fun permutation ↦
      ⟨GraphLattices.sixAxisSourceDualPermutationMatrix_mul_polarization permutation,
        GraphLattices.sixAxisSourcePolarizationCofactor_mul_dual permutation⟩⟩
/-- Diagonal stability of both primary kernels from equivariance of the
comparison matrix.  Suppose one fibre's integral comparison matrix pulls a
unimodular alternating form back to the source polarization and is equivariant
for the two displayed generators of the six-label action, in the sense that
each source action is carried to some integral action of the target lattice.
Then the contragredient action descends to the discriminant group, preserves
the lattice model of the isogeny kernel and each of its primary parts, and is
carried by the two primary comparisons to the reduced source action; on chart
vectors of vanishing coordinate sum that action is the heart action of the same
permutation.  Hence both transported primary kernels are stable under the two
diagonal generators, and with the maximal isotropy already proved the
two-primary kernel is one of the five members of the projective-line packet
over the field with four elements and the three-primary kernel is the vertical
copy or one of the three scalar graphs.  Stability is no longer an input at
either prime.  Equivariance of the comparison matrix is a hypothesis: no
relative isogeny, geometric group action, torsion group scheme, or Weil pairing
is constructed. -/
theorem relativeSixAxis_primaryKernelEquivariantPackets
    (realization : Applications.RelativeSixAxisHomologyRealization)
    (equivariant : realization.alternatingEquivariant) :
    (GraphLattices.SixAxisStandardDiscriminantGeneratorStable
          (Applications.relativeSixAxisTwoPrimaryKernelCoordinates realization) ∧
        (Applications.relativeSixAxisTwoPrimaryKernelCoordinates realization).map
            GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
          GraphLattices.SixPointHeartStableHalfPacket) ∧
      GraphLattices.SixPointThreeHeartPairGeneratorStable
          (Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates realization) ∧
        Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates realization ∈
          GraphLattices.SixPointThreeHeartStableHalfPacket :=
  ⟨Applications.relativeSixAxisTwoPrimaryKernelCoordinates_equivariantPacket realization
      equivariant,
    Applications.relativeSixAxisThreePrimaryKernelHeartCoordinates_equivariantPacket realization
      equivariant⟩
/-- Marked selection of the exotic member for the two-primary kernel of one
fibre.  Suppose the fibre's integral comparison matrix pulls a unimodular
alternating form back to the source polarization, is equivariant for the two
displayed generators of the six-label action, and its transported two-primary
kernel is Frobenius marked, that is, its packet class is moved by the Frobenius
involution of the packet of diagonally stable halves.  Then that class is one of
the two exotic members, hence the graph of a slope annihilated by `t²+t+1`,
whose minimal polynomial over the field with two elements is that irreducible
quadratic; this is the coefficient-side slope datum of the marked finite-etale
graph presentation at the prime two.  Equivariance alone cannot select a member,
because the packet is exactly the set of diagonally stable maximal-isotropic
subspaces and so all five members satisfy the same group hypothesis.  The
marking is a hypothesis on explicit matrices: no relative isogeny, torsion group
scheme, Weil pairing, geometric group action, or arithmetic Frobenius of a
family is constructed. -/
theorem relativeSixAxis_twoPrimaryKernelExoticSelection
    (realization : Applications.RelativeSixAxisHomologyRealization)
    (equivariant : realization.alternatingEquivariant)
    (marked : GraphLattices.SixPointHeartFrobeniusMarked
      ((Applications.relativeSixAxisTwoPrimaryKernelCoordinates realization).map
        GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap)) :
    (Applications.relativeSixAxisTwoPrimaryKernelCoordinates realization).map
          GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
        GraphLattices.SixPointHeartExoticHalfPair ∧
      ∃ slope : Matrix (Fin 4) (Fin 4) GraphLattices.F2,
        (Applications.relativeSixAxisTwoPrimaryKernelCoordinates realization).map
            GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap =
            LinearMap.range (GraphLattices.graphEmbedding (K := GraphLattices.F2)
              (Matrix.toLin' slope)) ∧
          slope ^ 2 + slope + 1 = 0 ∧
          minpoly GraphLattices.F2 slope =
            GraphLattices.sixAxisQuadraticSlopePolynomial :=
  Applications.relativeSixAxisTwoPrimaryKernelCoordinates_exoticSelection
    realization equivariant marked
/-- Both primary discriminants of the six-axis source polarization in
coordinates.  The kernel of the two-torsion reduction of the Kronecker
polarization is linearly equivalent to four copies of the rank-two two-torsion
module, and the kernel of its three-torsion reduction to four copies of the
rank-two three-torsion module.  These are the coefficient-side halves of the
manuscript's identifications `D₂ ≃ H₂ ⊗ E[2]` and `D₃ ≃ H₃ ⊗ E[3]`; the
two-torsion and three-torsion modules here are free rank-two modules over the
respective prime field, not the torsion of a constructed elliptic curve, and no
Weil pairing is constructed. -/
theorem relativeSixAxis_primaryDiscriminantCoordinates :
    Nonempty (GraphLattices.sixAxisSourceTwoPrimaryDiscriminant ≃ₗ[GraphLattices.F2]
        (Fin 4 → Fin 2 → GraphLattices.F2)) ∧
      Nonempty (GraphLattices.sixAxisSourceThreePrimaryDiscriminant ≃ₗ[GraphLattices.F3]
        (Fin 4 → Fin 2 → GraphLattices.F3)) :=
  ⟨⟨GraphLattices.sixAxisSourceTwoPrimaryDiscriminantCoordinates⟩,
    ⟨GraphLattices.sixAxisSourceThreePrimaryDiscriminantCoordinates⟩⟩
/-- The normalized primary discriminant pairings of the six-axis coefficient
form.  On a lift with vanishing coordinate sum the six-coordinate form
`6 Σ xᵢyᵢ - (Σx)(Σy)` is six times the dot product.  Its half therefore reduces
modulo two to the dot product, its third reduces modulo three to the negative of
the dot product, and against such a lift the form is divisible by six, so
neither normalization depends on the chosen lift.  These are statements about
the integral coefficient form; no Weil pairing or geometric discriminant is
constructed. -/
theorem relativeSixAxis_normalizedPrimaryPairings
    (left right : Fin 6 → ℤ) (augmentation : ∑ index, left index = 0) :
    GraphLattices.sixPointIntegralQuotientPairing left right =
        6 * ∑ index, left index * right index ∧
      (GraphLattices.sixPointIntegralQuotientPairing left right =
          2 * (3 * ∑ index, left index * right index) ∧
        ((3 * ∑ index, left index * right index : ℤ) : ZMod 2) =
          ((∑ index, left index * right index : ℤ) : ZMod 2)) ∧
      (GraphLattices.sixPointIntegralQuotientPairing left right =
          3 * (2 * ∑ index, left index * right index) ∧
        ((2 * ∑ index, left index * right index : ℤ) : ZMod 3) =
          - ((∑ index, left index * right index : ℤ) : ZMod 3)) ∧
      ∀ test : Fin 6 → ℤ,
        (6 : ℤ) ∣ GraphLattices.sixPointIntegralQuotientPairing test left :=
  ⟨GraphLattices.sixPointIntegralQuotientPairing_of_sum_zero left right augmentation,
    GraphLattices.sixPointIntegralQuotientPairing_two_normalization left right augmentation,
    GraphLattices.sixPointIntegralQuotientPairing_three_normalization left right augmentation,
    fun test ↦
      GraphLattices.sixPointIntegralQuotientPairing_dvd_six_of_sum_zero test left
        augmentation⟩
/-- Exact rank-one fixed-line calculation for the six axis stabilizers.  For
each label, its stabilizer in the concrete alternating-group action has ten
elements and is the corresponding dihedral normalizer.  On the rational
augmentation representation of the six labels, its fixed subspace is exactly
the line generated by the vector with coordinate `5` at that label and `-1`
at the other five labels, hence has dimension one.  This does not construct
the manuscript's norm endomorphism or identify the fixed line with an
elliptic subvariety of the relative intermediate Jacobian. -/
theorem relativeSixAxis_sixPointAxis_fixedLine :
    ∀ label : Fin 6,
      Nat.card (GraphLattices.alternatingFiveSixPointStabilizer label) = 10 ∧
      GraphLattices.sixPointAxisFixedSubspace label =
        ℚ ∙ GraphLattices.sixPointRationalAxisVector label ∧
      Module.finrank ℚ (GraphLattices.sixPointAxisFixedSubspace label) = 1 := by
  intro label
  exact ⟨GraphLattices.alternatingFiveSixPointStabilizer_card label,
    GraphLattices.sixPointAxisFixedSubspace_eq_span label,
    GraphLattices.sixPointAxisFixedSubspace_finrank label⟩
/-- Exact norm-projector calculation for the six axis stabilizers.  Summing
the ten coordinate-permutation operators of a labelled stabilizer gives a
linear norm `N` with `N² = 10N`; its range is exactly the rational axis line.
Consequently one tenth of `N` is an idempotent projector onto that line.  This
does not construct an endomorphism of an abelian scheme or identify the line
with a geometric elliptic subvariety. -/
theorem relativeSixAxis_sixPointAxis_norm :
    ∀ label : Fin 6,
      (∀ vector : GraphLattices.SixPointRationalAugmentation,
        GraphLattices.sixPointAxisNorm label
            (GraphLattices.sixPointAxisNorm label vector) =
          (10 : ℚ) • GraphLattices.sixPointAxisNorm label vector) ∧
      LinearMap.range (GraphLattices.sixPointAxisNorm label) =
        ℚ ∙ GraphLattices.sixPointRationalAxisVector label ∧
      ∀ vector : GraphLattices.SixPointRationalAugmentation,
        ((1 / 10 : ℚ) • GraphLattices.sixPointAxisNorm label)
            (((1 / 10 : ℚ) • GraphLattices.sixPointAxisNorm label) vector) =
          ((1 / 10 : ℚ) • GraphLattices.sixPointAxisNorm label) vector := by
  intro label
  exact ⟨GraphLattices.sixPointAxisNorm_square label,
    GraphLattices.sixPointAxisNorm_range_eq_span label,
    GraphLattices.sixPointAxisNormalizedNorm_idempotent label⟩
/-- Exact self-normalizing statement for the six concrete dihedral axis
stabilizers.  Each is the normalizer of a Sylow-five subgroup, and its own
normalizer inside the alternating group is itself. -/
theorem relativeSixAxis_sixPointAxis_stabilizer_selfNormalizing :
    ∀ label : Fin 6,
      Subgroup.normalizer
          (GraphLattices.alternatingFiveSixPointStabilizer label :
            Set (alternatingGroup (Fin 5))) =
        GraphLattices.alternatingFiveSixPointStabilizer label :=
  GraphLattices.alternatingFiveSixPointStabilizer_normalizer_eq_self
/-- Exact abstract coherence step for the six axes.  If an object is fixed by
one labelled axis stabilizer, then any two alternating-group elements carrying
that label to the same target carry the object to the same image.  The theorem
does not construct the manuscript's elliptic schemes or geometric transport
maps. -/
theorem relativeSixAxis_sixPointAxis_transport_independent
    {Object : Type*} [MulAction (alternatingGroup (Fin 5)) Object]
    (source target : Fin 6) (object : Object)
    (fixed : ∀ transformation : alternatingGroup (Fin 5),
      transformation ∈
          GraphLattices.alternatingFiveSixPointStabilizer source →
        transformation • object = object)
    (left right : alternatingGroup (Fin 5))
    (leftMaps : GraphLattices.alternatingFiveSixPointAction left source = target)
    (rightMaps : GraphLattices.alternatingFiveSixPointAction right source = target) :
    left • object = right • object :=
  GraphLattices.sixPointAxis_transport_independent source target object fixed
    left right leftMaps rightMaps
/-- Exact coefficient-space descent for the six rational axes.  Their sum is
zero, and the linear map synthesizing them from six scalar coefficients has
kernel exactly the constant line and is onto the rational augmentation
representation.  It therefore induces a linear equivalence from the
six-coordinate quotient by the constant line to the augmentation module, and
the synthesis map intertwines the concrete alternating-group actions.  This
does not construct the manuscript's elliptic scheme, its six primitive
inclusions into the relative Jacobian, or the descended homomorphism of
abelian schemes. -/
theorem relativeSixAxis_sixPointAxis_coefficientDescent :
    (∑ label, GraphLattices.sixPointRationalAxisVector label) = 0 ∧
    LinearMap.ker GraphLattices.sixPointRationalAxisSynthesis =
      GraphLattices.sixPointRationalConstantLine ∧
    Function.Surjective GraphLattices.sixPointRationalAxisSynthesis ∧
    Nonempty (GraphLattices.SixPointRationalCoefficientQuotient ≃ₗ[ℚ]
      GraphLattices.SixPointRationalAugmentation) ∧
    (∀ coefficient : Fin 6 → ℚ,
      GraphLattices.sixPointRationalCoefficientQuotientEquivAugmentation
          (Submodule.Quotient.mk coefficient) =
        GraphLattices.sixPointRationalAxisSynthesis coefficient) ∧
    ∀ (transformation : alternatingGroup (Fin 5))
      (coefficient : Fin 6 → ℚ),
      GraphLattices.sixPointRationalAxisSynthesis
          (GraphLattices.sixPointRationalPermutationRepresentation
            transformation coefficient) =
        GraphLattices.sixPointRationalAugmentationRepresentation transformation
          (GraphLattices.sixPointRationalAxisSynthesis coefficient) := by
  exact ⟨GraphLattices.sum_sixPointRationalAxisVector,
    GraphLattices.sixPointRationalAxisSynthesis_ker,
    GraphLattices.sixPointRationalAxisSynthesis_surjective,
    ⟨GraphLattices.sixPointRationalCoefficientQuotientEquivAugmentation⟩,
    GraphLattices.sixPointRationalCoefficientQuotientEquivAugmentation_mk,
    GraphLattices.sixPointRationalAxisSynthesis_equivariant⟩
/-- Exact integral quotient-lattice calculation for the six-axis source.
Subtracting the sixth coordinate identifies the quotient of `ℤ⁶` by its
constant line with `ℤ⁵`.  The symmetric six-coordinate form
`6Σ xᵢyᵢ-(Σ xᵢ)(Σ yᵢ)` annihilates the constant line in both
variables and descends to the quotient; in the displayed five-coordinate
chart its Gram matrix is exactly `6I₅-J₅`.  Every permutation of the six
labels induces a quotient map satisfying the identity and multiplication laws,
and these maps preserve the descended form.  This does not identify the
quotient with an elliptic-power abelian scheme or the descended form with a
geometric polarization. -/
theorem relativeSixAxis_integralCoefficientQuotient_and_form :
    Nonempty (GraphLattices.SixPointIntegralCoefficientQuotient ≃ₗ[ℤ]
      (Fin 5 → ℤ)) ∧
    (∀ vector : Fin 6 → ℤ,
      GraphLattices.sixPointIntegralCoefficientQuotientEquivFive
          (Submodule.Quotient.mk vector) =
        GraphLattices.sixPointIntegralDifferenceCoordinates vector) ∧
    (∀ left right : Fin 6 → ℤ,
      GraphLattices.sixPointIntegralDescendedPairing
          (Submodule.Quotient.mk left) (Submodule.Quotient.mk right) =
        GraphLattices.sixPointIntegralQuotientPairing left right) ∧
    ∀ left right : Fin 5 → ℤ,
      GraphLattices.sixPointIntegralDescendedPairing
          (GraphLattices.sixPointIntegralClassFromFive left)
          (GraphLattices.sixPointIntegralClassFromFive right) =
        dotProduct left (Matrix.mulVec (GraphLattices.sixAxisGram ℤ) right) ∧
    (∀ vector : GraphLattices.SixPointIntegralCoefficientQuotient,
      GraphLattices.sixPointIntegralQuotientPermutation 1 vector = vector) ∧
    (∀ (left right : Equiv.Perm (Fin 6))
      (vector : GraphLattices.SixPointIntegralCoefficientQuotient),
      GraphLattices.sixPointIntegralQuotientPermutation (left * right) vector =
        GraphLattices.sixPointIntegralQuotientPermutation left
          (GraphLattices.sixPointIntegralQuotientPermutation right vector)) ∧
    ∀ (permutation : Equiv.Perm (Fin 6))
      (left right : GraphLattices.SixPointIntegralCoefficientQuotient),
      GraphLattices.sixPointIntegralDescendedPairing
          (GraphLattices.sixPointIntegralQuotientPermutation permutation left)
          (GraphLattices.sixPointIntegralQuotientPermutation permutation right) =
        GraphLattices.sixPointIntegralDescendedPairing left right :=
  ⟨⟨GraphLattices.sixPointIntegralCoefficientQuotientEquivFive⟩,
    GraphLattices.sixPointIntegralCoefficientQuotientEquivFive_mk,
    GraphLattices.sixPointIntegralDescendedPairing_mk,
    fun left right ↦ ⟨
      GraphLattices.sixPointIntegralDescendedPairing_classFromFive left right,
      GraphLattices.sixPointIntegralQuotientPermutation_one,
      GraphLattices.sixPointIntegralQuotientPermutation_mul,
      GraphLattices.sixPointIntegralDescendedPairing_permutation⟩⟩
/-- Exact three-primary coefficient packet for the six-label action.
Normalizing the last coordinate identifies `Aug(F₃⁶)/⟨1⟩` with `F₃⁴`.
The quotient chart intertwines the induced translation and inversion actions
with their displayed matrices and is an isometry for the descended
minus-dot-product form.
The normalized symmetric form is minus the six-coordinate dot product and is
nondegenerate and is preserved by both generators.  Its tensor product with a
two-dimensional symplectic form is an alternating nondegenerate form on two
heart copies and is preserved by the diagonal generator actions.  The four-dimensional
subspaces stable under the displayed translation and inversion generators are
exactly the vertical copy and the three scalar graphs; these four subspaces
are maximal isotropic.  This terminal does not identify the coefficient model
or its pairing with the manuscript's geometric three-primary discriminant
kernel, or derive the pairing from the manuscript's integral `(1/3)(6I-J)`
formula. -/
theorem relativeSixAxis_threePrimary_stableMaximalIsotropicPacket :
    (∀ vector : GraphLattices.SixPointThreeAugmentation,
      GraphLattices.sixPointThreeAugmentationQuotientEquivHeart
          (Submodule.Quotient.mk vector) =
        GraphLattices.sixPointThreeHeartCoordinates vector.1) ∧
    (∀ heart : GraphLattices.SixPointThreeAugmentationQuotient,
      GraphLattices.sixPointThreeAugmentationQuotientEquivHeart
          (GraphLattices.sixPointThreeAugmentationQuotientTranslation heart) =
        Matrix.mulVec GraphLattices.sixPointThreeHeartTranslation
          (GraphLattices.sixPointThreeAugmentationQuotientEquivHeart heart)) ∧
    (∀ heart : GraphLattices.SixPointThreeAugmentationQuotient,
      GraphLattices.sixPointThreeAugmentationQuotientEquivHeart
          (GraphLattices.sixPointThreeAugmentationQuotientInversion heart) =
        Matrix.mulVec GraphLattices.sixPointThreeHeartInversion
          (GraphLattices.sixPointThreeAugmentationQuotientEquivHeart heart)) ∧
    (∀ left right : GraphLattices.SixPointThreeAugmentationQuotient,
      GraphLattices.sixPointThreeAugmentationQuotientBilinForm left right =
        GraphLattices.sixPointThreeHeartCoefficientForm
          (GraphLattices.sixPointThreeAugmentationQuotientEquivHeart left)
          (GraphLattices.sixPointThreeAugmentationQuotientEquivHeart right)) ∧
    (∀ left right : GraphLattices.SixPointThreeHeart,
      GraphLattices.sixPointThreeHeartCoefficientForm left right =
        -dotProduct (GraphLattices.sixPointThreeHeartRepresentative left)
          (GraphLattices.sixPointThreeHeartRepresentative right)) ∧
    (∀ left right : GraphLattices.SixPointThreeHeart,
      GraphLattices.sixPointThreeHeartCoefficientForm
          (Matrix.mulVec GraphLattices.sixPointThreeHeartTranslation left)
          (Matrix.mulVec GraphLattices.sixPointThreeHeartTranslation right) =
        GraphLattices.sixPointThreeHeartCoefficientForm left right) ∧
    (∀ left right : GraphLattices.SixPointThreeHeart,
      GraphLattices.sixPointThreeHeartCoefficientForm
          (Matrix.mulVec GraphLattices.sixPointThreeHeartInversion left)
          (Matrix.mulVec GraphLattices.sixPointThreeHeartInversion right) =
        GraphLattices.sixPointThreeHeartCoefficientForm left right) ∧
    GraphLattices.sixPointThreeHeartCoefficientForm.Nondegenerate ∧
    GraphLattices.sixPointThreeHeartPairPolarizationBilinForm.IsAlt ∧
    GraphLattices.sixPointThreeHeartPairPolarizationBilinForm.Nondegenerate ∧
    (∀ left right : GraphLattices.SixPointThreeHeart ×
        GraphLattices.SixPointThreeHeart,
      GraphLattices.sixPointThreeHeartPairPolarizationBilinForm
          (Matrix.mulVec GraphLattices.sixPointThreeHeartTranslation left.1,
            Matrix.mulVec GraphLattices.sixPointThreeHeartTranslation left.2)
          (Matrix.mulVec GraphLattices.sixPointThreeHeartTranslation right.1,
            Matrix.mulVec GraphLattices.sixPointThreeHeartTranslation right.2) =
        GraphLattices.sixPointThreeHeartPairPolarizationBilinForm left right) ∧
    (∀ left right : GraphLattices.SixPointThreeHeart ×
        GraphLattices.SixPointThreeHeart,
      GraphLattices.sixPointThreeHeartPairPolarizationBilinForm
          (Matrix.mulVec GraphLattices.sixPointThreeHeartInversion left.1,
            Matrix.mulVec GraphLattices.sixPointThreeHeartInversion left.2)
          (Matrix.mulVec GraphLattices.sixPointThreeHeartInversion right.1,
            Matrix.mulVec GraphLattices.sixPointThreeHeartInversion right.2) =
        GraphLattices.sixPointThreeHeartPairPolarizationBilinForm left right) ∧
    GraphLattices.SixPointThreeHeartStableHalfPacket.ncard = 4 ∧
    (∀ subspace : Submodule GraphLattices.F3
        (GraphLattices.SixPointThreeHeart × GraphLattices.SixPointThreeHeart),
      subspace ∈ GraphLattices.SixPointThreeHeartStableHalfPacket ↔
        GraphLattices.SixPointThreeHeartPairGeneratorStable subspace ∧
          Module.finrank GraphLattices.F3 subspace = 4) ∧
    ∀ subspace : Submodule GraphLattices.F3
        (GraphLattices.SixPointThreeHeart × GraphLattices.SixPointThreeHeart),
      subspace ∈ GraphLattices.SixPointThreeHeartStableHalfPacket →
        GraphLattices.IsMaximalIsotropic
          GraphLattices.sixPointThreeHeartPairPolarizationBilinForm subspace := by
  refine ⟨GraphLattices.sixPointThreeAugmentationQuotientEquivHeart_mk,
    GraphLattices.sixPointThreeAugmentationQuotientEquivHeart_translation,
    GraphLattices.sixPointThreeAugmentationQuotientEquivHeart_inversion,
    GraphLattices.sixPointThreeAugmentationQuotientEquivHeart_isometry,
    GraphLattices.sixPointThreeHeartCoefficientForm_eq_negative_dotProduct,
    GraphLattices.sixPointThreeHeartCoefficientForm_translation,
    GraphLattices.sixPointThreeHeartCoefficientForm_inversion,
    GraphLattices.sixPointThreeHeartCoefficientForm_nondegenerate,
    GraphLattices.sixPointThreeHeartPairPolarizationBilinForm_isAlt,
    GraphLattices.sixPointThreeHeartPairPolarizationBilinForm_nondegenerate,
    GraphLattices.sixPointThreeHeartPairPolarizationBilinForm_translation,
    GraphLattices.sixPointThreeHeartPairPolarizationBilinForm_inversion,
    GraphLattices.sixPointThreeHeartStableHalfPacket_ncard,
    GraphLattices.sixPointThreeHeartStableHalfPacket_iff, ?_⟩
  rintro subspace ⟨slope, rfl⟩
  exact GraphLattices.sixPointThreeHeartStableHalf_maximalIsotropic slope
/-- Exact conditional bridge from a supplied geometric kernel fibre to the
explicit five-member packet.  The input supplies coordinates on each
discriminant fibre, proves that the geometric kernel inclusion has exactly a
displayed standard-coordinate subspace as its image, and proves that this
subspace is diagonally stable and maximal isotropic.  Lean constructs a
fibrewise equivalence from the geometric kernel carrier to that subspace and
proves that every transported subspace belongs to the five-member packet.  It
does not construct the coordinates or verify these hypotheses for the
manuscript's relative isogeny. -/
theorem relativeSixAxis_kernelCoordinates_classify_packet
    {Base : Type*} {objects : Applications.RelativeSixAxisObjects Base}
    {geometry : Applications.RelativeSixAxisGeometricInput objects}
    (input : Applications.RelativeSixAxisKernelCoordinateInput objects geometry) :
    (∀ parameter,
      Nonempty (objects.KernelTwo parameter ≃ input.kernelSubspace parameter)) ∧
    ∀ parameter,
      (input.kernelSubspace parameter).map
          GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
        GraphLattices.SixPointHeartStableHalfPacket :=
  Applications.relativeSixAxisKernelCoordinateInput_packet input
/-- The abstract `6I-J` calculation: the constant line has eigenvalue one and
the coordinate-sum-zero hyperplane has eigenvalue six.  No geometric Rosati
identification is asserted. -/
theorem sixAxisGram_unit_and_augmentation_eigenvalues
    {R : Type*} [CommRing R] :
    Matrix.mulVec (GraphLattices.sixAxisGram R)
        (fun _ : Fin 5 ↦ (1 : R)) = (fun _ ↦ 1) ∧
      ∀ vector : Fin 5 → R, (∑ column, vector column) = 0 →
        Matrix.mulVec (GraphLattices.sixAxisGram R) vector =
          (fun row ↦ 6 * vector row) := by
  constructor
  · exact GraphLattices.sixAxisGram_mulVec_one
  · exact GraphLattices.sixAxisGram_mulVec_of_sum_zero
/-- An explicit integral Smith witness: the displayed integral row and column
matrices are invertible over the integers and reduce `6I-J` to
`diag(1,6,6,6,6)`. -/
theorem sixAxisGram_integralSmithReduction :
    GraphLattices.sixAxisSmithLeft * GraphLattices.sixAxisGram ℤ *
        GraphLattices.sixAxisSmithRight = GraphLattices.sixAxisSmithDiagonal ∧
      GraphLattices.sixAxisSmithLeft *
          GraphLattices.sixAxisSmithLeftInverse = 1 ∧
      GraphLattices.sixAxisSmithLeftInverse *
          GraphLattices.sixAxisSmithLeft = 1 ∧
      GraphLattices.sixAxisSmithRight *
          GraphLattices.sixAxisSmithRightInverse = 1 ∧
      GraphLattices.sixAxisSmithRightInverse *
          GraphLattices.sixAxisSmithRight = 1 := by
  exact ⟨GraphLattices.sixAxisGram_smith_reduction,
    GraphLattices.sixAxisSmithLeft_mul_inverse,
    GraphLattices.sixAxisSmithLeft_inverse_mul,
    GraphLattices.sixAxisSmithRight_mul_inverse,
    GraphLattices.sixAxisSmithRight_inverse_mul⟩
/-- Exact arithmetic completion of the numerical step in the six-axis
polarization proof: positivity, the vanishing invariant sum, and the
intersection equation force diagonal entry five and off-diagonal entry
minus one. -/
theorem sixAxisPolarization_parameters_unique
    (diagonal offDiagonal : ℤ)
    (diagonalPositive : 0 < diagonal)
    (invariantSum : diagonal + 5 * offDiagonal = 0)
    (intersection : diagonal ^ 2 - offDiagonal ^ 2 = 24) :
    diagonal = 5 ∧ offDiagonal = -1 :=
  GraphLattices.sixAxisGram_parameters_unique diagonal offDiagonal
    diagonalPositive invariantSum intersection
/-- A finite gluing type persists on a connected smooth component once its
classifying map into the discrete packet is continuous.  Lean proves both
constancy of that map and propagation of membership in a distinguished packet
subset from one fibre to every fibre.  The geometric local system, its packet,
and continuity of the classifying map remain supplied rather than constructed. -/
theorem principalGluingPacket_connectedFamily_persistence
    {Base Packet : Type*} [TopologicalSpace Base] [ConnectedSpace Base]
    [TopologicalSpace Packet] [DiscreteTopology Packet] [Finite Packet]
    (packetClass : Base → Packet) (continuous : Continuous packetClass)
    (distinguished : Set Packet) (basePoint : Base)
    (atBasePoint : packetClass basePoint ∈ distinguished) :
    (∀ first second, packetClass first = packetClass second) ∧
      ∀ point, packetClass point ∈ distinguished := by
  exact ⟨GraphLattices.connectedBase_finiteDiscretePacket_constant
      packetClass continuous,
    GraphLattices.connectedBase_finiteDiscretePacket_membership_persists
      packetClass continuous distinguished basePoint atBasePoint⟩
/-- Specialization of connected-packet persistence to the marked quadratic
pair in the affine chart of the concrete five-point `F4` projective packet.
If a supplied continuous classifier takes one base point to either transported
marked root, then it is constant and every base point remains in that same
two-element pair.  No geometric kernel local system or classifier is
constructed. -/
theorem principalGluingPacket_markedF4Pair_connectedFamily_persistence
    {Base : Type*} [TopologicalSpace Base] [ConnectedSpace Base]
    [TopologicalSpace (Option GraphLattices.F4)]
    [DiscreteTopology (Option GraphLattices.F4)]
    (packetClass : Base → Option GraphLattices.F4)
    (continuous : Continuous packetClass) (basePoint : Base)
    (atBasePoint :
      packetClass basePoint =
          some GraphLattices.sixAxisQuadraticSlopeRootInF4 ∨
        packetClass basePoint =
          some (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1)) :
    (∀ first second, packetClass first = packetClass second) ∧
      ∀ point,
        packetClass point =
            some GraphLattices.sixAxisQuadraticSlopeRootInF4 ∨
          packetClass point =
            some (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1) := by
  exact GraphLattices.connectedBase_f4MarkedProjectivePair_constant_and_persists
    packetClass continuous basePoint atBasePoint
/-- Connected-family persistence stated directly on the actual projective line
over `F4`, rather than on its affine-chart coordinate type.  If a supplied
continuous classifier takes one base point to either scalar graph defined by
the transported marked quadratic root, then the classifier is constant and
every fibre remains in that exact two-point subset.  No geometric kernel local
system or classifier is constructed. -/
theorem principalGluingPacket_markedProjectiveLine_connectedFamily_persistence
    {Base : Type*} [TopologicalSpace Base] [ConnectedSpace Base]
    [TopologicalSpace
      (Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4))]
    [DiscreteTopology
      (Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4))]
    (packetClass : Base →
      Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4))
    (continuous : Continuous packetClass) (basePoint : Base)
    (atBasePoint :
      packetClass basePoint = GraphLattices.scalarGraphPoint GraphLattices.F4
          GraphLattices.sixAxisQuadraticSlopeRootInF4 ∨
        packetClass basePoint =
          GraphLattices.scalarGraphPoint GraphLattices.F4
            (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1)) :
    (∀ first second, packetClass first = packetClass second) ∧
      ∀ point,
        packetClass point = GraphLattices.scalarGraphPoint GraphLattices.F4
            GraphLattices.sixAxisQuadraticSlopeRootInF4 ∨
          packetClass point =
            GraphLattices.scalarGraphPoint GraphLattices.F4
              (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1) := by
  exact
    GraphLattices.connectedBase_f4MarkedProjectiveLinePair_constant_and_persists
      packetClass continuous basePoint atBasePoint
/-- Exact exotic-to-marked persistence on the actual projective line.  A
supplied continuous classifier from a connected base is assumed only to be
nonfixed by coefficientwise Frobenius at one base point.  Lean identifies that
nonfixed point with one of the two scalar graphs defined by the transported
marked quadratic root, proves the classifier constant, and propagates the
exact marked-pair classification to every fibre.  Construction of the
geometric principal-kernel classifier and proof that its chosen fibre is
nonfixed remain outside this theorem. -/
theorem principalGluingPacket_projectiveLine_nonfixed_persists_as_markedPair
    {Base : Type*} [TopologicalSpace Base] [ConnectedSpace Base]
    [TopologicalSpace
      (Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4))]
    [DiscreteTopology
      (Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4))]
    (packetClass : Base →
      Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4))
    (continuous : Continuous packetClass) (basePoint : Base)
    (nonfixed : GraphLattices.f4ProjectiveLineFrobenius
        (packetClass basePoint) ≠ packetClass basePoint) :
    (∀ first second, packetClass first = packetClass second) ∧
      ∀ point,
        packetClass point = GraphLattices.scalarGraphPoint GraphLattices.F4
            GraphLattices.sixAxisQuadraticSlopeRootInF4 ∨
          packetClass point =
            GraphLattices.scalarGraphPoint GraphLattices.F4
              (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1) := by
  exact
    GraphLattices.connectedBase_f4ProjectiveLine_nonfixed_persists_as_markedPair
      packetClass continuous basePoint nonfixed
/-- Marking at one base point suffices on the packet of stable halves.  A
supplied continuous classifier from a connected base into the five-member packet
of diagonally stable halves of the coefficient heart is assumed only to be moved
by the Frobenius involution of the packet at one base point.  Lean proves the
classifier constant and identifies every fibre with one of the two exotic
members.  Construction of the geometric principal-kernel classifier and proof
that its chosen fibre is marked remain outside this theorem. -/
theorem principalGluingPacket_stableHalf_marked_persists_as_exotic
    {Base : Type*} [TopologicalSpace Base] [ConnectedSpace Base]
    [TopologicalSpace {subspace // subspace ∈
      GraphLattices.SixPointHeartStableHalfPacket}]
    [DiscreteTopology {subspace // subspace ∈
      GraphLattices.SixPointHeartStableHalfPacket}]
    (packetClass : Base → {subspace // subspace ∈
      GraphLattices.SixPointHeartStableHalfPacket})
    (continuous : Continuous packetClass) (basePoint : Base)
    (marked : GraphLattices.sixPointHeartStableHalfPacketFrobenius
        (packetClass basePoint) ≠ packetClass basePoint) :
    (∀ first second, packetClass first = packetClass second) ∧
      ∀ point, (packetClass point).1 ∈
        GraphLattices.SixPointHeartExoticHalfPair := by
  exact GraphLattices.connectedBase_stableHalfPacket_marked_persists_as_exotic
    packetClass continuous basePoint marked
/-- Exact projective-line classification and counts behind the finite-field
gluing packets.  Every point is uniquely the vertical line or a scalar graph;
there are five points over `F4` and four over `F3`. -/
theorem principalGluing_projectiveLine_packets :
    Nonempty (Option GraphLattices.F4 ≃
      Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4)) ∧
      Nat.card (Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4)) = 5 ∧
      Nonempty (Option (ZMod 3) ≃
        Projectivization (ZMod 3) (ZMod 3 × ZMod 3)) ∧
      Nat.card (Projectivization (ZMod 3) (ZMod 3 × ZMod 3)) = 4 :=
  ⟨⟨GraphLattices.optionEquivProjectiveLine GraphLattices.F4⟩,
    GraphLattices.f4_projectiveLine_card,
    ⟨GraphLattices.optionEquivProjectiveLine (ZMod 3)⟩,
    GraphLattices.f3_projectiveLine_card⟩
/-- Explicit six-point characteristic-two coefficient-heart calculation.
Lean gives canonical four coordinates on the augmentation hyperplane modulo
the constant line, derives the matrices induced by translation and inversion
on the six-point labelling, identifies that labelling with the actual
projective line `P¹(F5)`, and proves that the two permutations are induced by
the linear maps `(x,y) ↦ (x,x+y)` and `(x,y) ↦ (y,-x)`.  It proves that their
common matrix commutant is exactly the four-element quadratic algebra
`{0,1,W,W+1}` with `W²+W+1=0`.  Every subspace stable under both generators
is zero or the whole heart, and the commutant classification is also proved
for every matrix word in the full generated action.  The generators preserve an explicit
one-factorization; their faithful factor action exhausts the alternating group
on five letters, thereby identifying the abstract generated action with a
concrete `A5`.  It constructs all six Sylow-five subgroups, proves that
conjugation by the two generators permutes them by exactly the original
six-point action, and identifies each ten-element normalizer explicitly with
the dihedral group `D5`.  It also constructs the faithful natural
`PSL₂(F5)` action on `P¹(F5)`, proves that the displayed translation and
inversion come from explicit determinant-one matrices, computes
`|PSL₂(F5)|=60`, and constructs an explicit isomorphism `PSL₂(F5) ≃ A5`
intertwining that projective action with conjugation on the six Sylow-five
subgroups.  Both six-point actions are proved two-transitive.  Each
stabilizer in the natural projective action is proved to
have order ten and is explicitly equivalent to `D5`.  The resulting
six-label equivalence intertwines both
displayed generators with conjugation, and each point stabilizer is its
normalizer.  This is the concrete group-theoretic six-label packet, but the
terminal does not identify it with the manuscript's six
geometrically defined `D5` normalizers, elliptic quotients, or axes. -/
theorem principalGluing_sixPointCoefficientHeart_quadraticCommutant :
    (∀ heart : Fin 4 → GraphLattices.F2,
      (∑ point, GraphLattices.sixPointHeartRepresentative heart point) = 0 ∧
      GraphLattices.sixPointHeartCoordinates
          (GraphLattices.sixPointHeartRepresentative heart) = heart ∧
      GraphLattices.sixPointHeartCoordinates
          (GraphLattices.sixPointHeartRepresentative heart ∘
            GraphLattices.sixPointTranslationPreimage) =
        Matrix.mulVec GraphLattices.sixPointHeartTranslation heart ∧
      GraphLattices.sixPointHeartCoordinates
          (GraphLattices.sixPointHeartRepresentative heart ∘
            GraphLattices.sixPointInversionPreimage) =
        Matrix.mulVec GraphLattices.sixPointHeartInversion heart) ∧
    (∀ (vector : Fin 6 → GraphLattices.F2),
      (∑ point, vector point) = 0 →
        (GraphLattices.sixPointHeartCoordinates vector = 0 ↔
          ∀ point, vector point = vector 5)) ∧
    (∀ subspace : Submodule GraphLattices.F2 (Fin 4 → GraphLattices.F2),
      GraphLattices.SixPointHeartGeneratorStable subspace →
        subspace = ⊥ ∨ subspace = ⊤) ∧
    ((∀ word : List Bool,
        GraphLattices.sixPointFactorWord word ∈ alternatingGroup (Fin 5)) ∧
      (∀ permutation : Equiv.Perm (Fin 5),
        permutation ∈ alternatingGroup (Fin 5) →
          ∃ word : List Bool,
            GraphLattices.sixPointFactorWord word = permutation) ∧
      (∀ left right : List Bool,
        GraphLattices.sixPointFactorWord left =
            GraphLattices.sixPointFactorWord right ↔
          GraphLattices.sixPointPermutationWord left =
            GraphLattices.sixPointPermutationWord right)) ∧
    (∀ label : Fin 6,
      Nat.card (GraphLattices.sixPointFiveSubgroup label) = 5) ∧
    Function.Injective GraphLattices.sixPointFiveSubgroup ∧
    (∀ label : Fin 6,
      (GraphLattices.sixPointFiveSubgroup label).map
          (MulAut.conj GraphLattices.sixPointFactorTranslationA5) =
        GraphLattices.sixPointFiveSubgroup
          (GraphLattices.sixPointTranslationPermutation label) ∧
      (GraphLattices.sixPointFiveSubgroup label).map
          (MulAut.conj GraphLattices.sixPointFactorInversionA5) =
        GraphLattices.sixPointFiveSubgroup
          (GraphLattices.sixPointInversionPermutation label)) ∧
    Nat.card (Sylow 5 (alternatingGroup (Fin 5))) = 6 ∧
    Function.Surjective GraphLattices.sixPointFiveSylow ∧
    (∀ label : Fin 6,
      GraphLattices.sixPointFiveSylowEquiv
          (GraphLattices.sixPointTranslationPermutation label) =
        GraphLattices.sixPointFactorTranslationA5 •
          GraphLattices.sixPointFiveSylowEquiv label ∧
      GraphLattices.sixPointFiveSylowEquiv
          (GraphLattices.sixPointInversionPermutation label) =
        GraphLattices.sixPointFactorInversionA5 •
          GraphLattices.sixPointFiveSylowEquiv label ∧
      MulAction.stabilizer (alternatingGroup (Fin 5))
          (GraphLattices.sixPointFiveSylow label) =
        Subgroup.normalizer
          (GraphLattices.sixPointFiveSubgroup label :
            Set (alternatingGroup (Fin 5)))) ∧
    (∀ label : Fin 6,
      Nat.card (Subgroup.normalizer
        (GraphLattices.sixPointFiveSubgroup label :
          Set (alternatingGroup (Fin 5)))) = 10 ∧
      Nonempty (DihedralGroup 5 ≃*
        Subgroup.normalizer
          (GraphLattices.sixPointFiveSubgroup label :
            Set (alternatingGroup (Fin 5))))) ∧
    (∀ label : Fin 6,
      GraphLattices.sixPointEquivProjectiveLineF5
          (GraphLattices.sixPointTranslationPermutation label) =
        GraphLattices.f5ProjectiveTranslation
          (GraphLattices.sixPointEquivProjectiveLineF5 label) ∧
      GraphLattices.sixPointEquivProjectiveLineF5
          (GraphLattices.sixPointInversionPermutation label) =
        GraphLattices.f5ProjectiveInversion
          (GraphLattices.sixPointEquivProjectiveLineF5 label)) ∧
    Nonempty
      (Projectivization GraphLattices.F5
          (GraphLattices.F5 × GraphLattices.F5) ≃
        Sylow 5 (alternatingGroup (Fin 5))) ∧
    Nat.card PSL(2, GraphLattices.F5) = 60 ∧
    Function.Injective GraphLattices.psl2F5SixPointAction ∧
    GraphLattices.psl2F5SixPointAction
        (GraphLattices.f5TranslationSpecialLinear :
          PSL(2, GraphLattices.F5)) =
      GraphLattices.sixPointTranslationPermutation ∧
    GraphLattices.psl2F5SixPointAction
        (GraphLattices.f5InversionSpecialLinear :
          PSL(2, GraphLattices.F5)) =
      GraphLattices.sixPointInversionPermutation ∧
    (∀ transformation : PSL(2, GraphLattices.F5),
      GraphLattices.alternatingFiveSixPointAction
          (GraphLattices.psl2F5EquivAlternatingFive transformation) =
        GraphLattices.psl2F5SixPointAction transformation) ∧
    (∀ source otherSource target otherTarget : Fin 6,
      source ≠ otherSource → target ≠ otherTarget →
        ∃ transformation : alternatingGroup (Fin 5),
          GraphLattices.alternatingFiveSixPointAction transformation source =
              target ∧
            GraphLattices.alternatingFiveSixPointAction transformation
                otherSource = otherTarget) ∧
    (∀ source otherSource target otherTarget : Fin 6,
      source ≠ otherSource → target ≠ otherTarget →
        ∃ transformation : PSL(2, GraphLattices.F5),
          GraphLattices.psl2F5SixPointAction transformation source = target ∧
            GraphLattices.psl2F5SixPointAction transformation otherSource =
              otherTarget) ∧
    (∀ label : Fin 6,
      Nat.card (GraphLattices.psl2F5SixPointStabilizer label) = 10 ∧
      Nonempty (DihedralGroup 5 ≃*
        GraphLattices.psl2F5SixPointStabilizer label) ∧
      ∀ transformation : PSL(2, GraphLattices.F5),
        transformation ∈ GraphLattices.psl2F5SixPointStabilizer label ↔
          GraphLattices.psl2F5SixPointAction transformation label = label) ∧
    GraphLattices.sixPointHeartCommutantRoot ^ 2 +
        GraphLattices.sixPointHeartCommutantRoot + 1 = 0 ∧
    (∀ matrix : Matrix (Fin 4) (Fin 4) GraphLattices.F2,
      (matrix * GraphLattices.sixPointHeartTranslation =
          GraphLattices.sixPointHeartTranslation * matrix ∧
        matrix * GraphLattices.sixPointHeartInversion =
          GraphLattices.sixPointHeartInversion * matrix) ↔
        matrix = 0 ∨ matrix = 1 ∨
          matrix = GraphLattices.sixPointHeartCommutantRoot ∨
          matrix = GraphLattices.sixPointHeartCommutantRoot + 1) ∧
    (∀ matrix : Matrix (Fin 4) (Fin 4) GraphLattices.F2,
      (∀ word : List Bool,
        matrix * GraphLattices.sixPointHeartWordMatrix word =
          GraphLattices.sixPointHeartWordMatrix word * matrix) ↔
        matrix = 0 ∨ matrix = 1 ∨
          matrix = GraphLattices.sixPointHeartCommutantRoot ∨
          matrix = GraphLattices.sixPointHeartCommutantRoot + 1) := by
  exact ⟨fun heart ↦
      ⟨GraphLattices.sixPointHeartRepresentative_sum_zero heart,
        GraphLattices.sixPointHeartCoordinates_representative heart,
        GraphLattices.sixPointHeartCoordinates_translation heart,
        GraphLattices.sixPointHeartCoordinates_inversion heart⟩,
    GraphLattices.sixPointHeartCoordinates_eq_zero_iff_constant,
    GraphLattices.sixPointHeartGeneratorStable_simple,
    GraphLattices.sixPointGeneratedAction_realizes_alternatingGroup,
    GraphLattices.sixPointFiveSubgroup_card,
    GraphLattices.sixPointFiveSubgroup_injective,
    fun label => ⟨GraphLattices.sixPointFiveSubgroup_translation_conjugation label,
      GraphLattices.sixPointFiveSubgroup_inversion_conjugation label⟩,
    GraphLattices.sixPointFiveSylow_card,
    GraphLattices.sixPointFiveSylow_surjective,
    fun label => ⟨GraphLattices.sixPointFiveSylowEquiv_translation label,
      GraphLattices.sixPointFiveSylowEquiv_inversion label,
      GraphLattices.sixPointFiveSylow_stabilizer_eq_normalizer label⟩,
    fun label => ⟨GraphLattices.sixPointFiveSubgroup_normalizer_card label,
      ⟨GraphLattices.sixPointFiveNormalizerMulEquivDihedral label⟩⟩,
    fun label => ⟨GraphLattices.sixPointEquivProjectiveLineF5_translation label,
      GraphLattices.sixPointEquivProjectiveLineF5_inversion label⟩,
    ⟨GraphLattices.f5ProjectiveLineEquivFiveSylow⟩,
    GraphLattices.f5_projectiveSpecialLinearGroup_two_card,
    GraphLattices.psl2F5SixPointAction_injective,
    GraphLattices.psl2F5SixPointAction_translation,
    GraphLattices.psl2F5SixPointAction_inversion,
    GraphLattices.psl2F5EquivAlternatingFive_action,
    GraphLattices.alternatingFiveSixPointAction_two_transitive,
    GraphLattices.psl2F5SixPointAction_two_transitive,
    fun label => ⟨GraphLattices.psl2F5SixPointStabilizer_card label,
      ⟨GraphLattices.psl2F5SixPointStabilizerEquivDihedral label⟩,
      fun transformation =>
        GraphLattices.mem_psl2F5SixPointStabilizer_iff transformation label⟩,
    GraphLattices.sixPointHeartCommutantRoot_quadratic,
    GraphLattices.sixPointHeart_commonCommutant_classification,
    GraphLattices.sixPointHeart_fullActionCommutant_classification⟩
/-- A subspace of two copies of the explicit six-point coefficient heart is
four-dimensional and stable under the diagonal translation and inversion
actions exactly when it is the vertical copy or the graph of `0`, `1`, `W`,
or `W+1`, where `W²+W+1=0` is the proved quadratic commutant generator.  This
packet has exactly five distinct members.  This classifies the stable halves
of the concrete modular model; it does not identify that model or any of its
halves with the geometric two-primary kernel of a relative isogeny. -/
theorem principalGluing_sixPointCoefficientHeart_stableHalf_classification
    (subspace : Submodule GraphLattices.F2
      (GraphLattices.SixPointHeart × GraphLattices.SixPointHeart)) :
    GraphLattices.SixPointHeartStableHalfPacket.ncard = 5 ∧
    ((subspace = LinearMap.range
        (GraphLattices.graphEmbedding (K := GraphLattices.F2)
          (Matrix.toLin' (0 : Matrix (Fin 4) (Fin 4) GraphLattices.F2))) ∨
    subspace = LinearMap.range
        (GraphLattices.graphEmbedding (K := GraphLattices.F2)
          (Matrix.toLin' (1 : Matrix (Fin 4) (Fin 4) GraphLattices.F2))) ∨
    subspace = LinearMap.range
        (GraphLattices.graphEmbedding (K := GraphLattices.F2)
          (Matrix.toLin' GraphLattices.sixPointHeartCommutantRoot)) ∨
    subspace = LinearMap.range
        (GraphLattices.graphEmbedding (K := GraphLattices.F2)
          (Matrix.toLin'
            (GraphLattices.sixPointHeartCommutantRoot + 1))) ∨
    subspace = LinearMap.range
        (GraphLattices.verticalEmbedding
          (K := GraphLattices.F2) (H := GraphLattices.SixPointHeart))) ↔
      GraphLattices.SixPointHeartPairGeneratorStable subspace ∧
        Module.finrank GraphLattices.F2 subspace = 4) := by
  refine ⟨GraphLattices.sixPointHeartStableHalfPacket_ncard, ?_⟩
  simpa [GraphLattices.SixPointHeartStableHalfPacket] using
    GraphLattices.sixPointHeartStableHalfPacket_iff subspace
/-- The actual projective line over `F4` is explicitly equivalent to the
five-member stable-half packet of the concrete six-point heart.  In the
vertical-plus-affine chart, `none` is the vertical half, while `0`, `1`, the
transported marked quadratic root, and its `root+1` conjugate map respectively
to the graphs of `0`, `1`, `W`, and `W+1`.  This is a concrete modular
parameterization; it does not identify the heart, projective line, or packet
with the geometric two-primary kernel family. -/
theorem principalGluing_sixPointCoefficientHeart_projectiveLine_packet :
    Nonempty
      (Projectivization GraphLattices.F4
          (GraphLattices.F4 × GraphLattices.F4) ≃
        {subspace // subspace ∈
          GraphLattices.SixPointHeartStableHalfPacket}) ∧
    (GraphLattices.sixPointHeartProjectiveChartEquivStableHalfPacket none).1 =
        LinearMap.range
          (GraphLattices.verticalEmbedding (K := GraphLattices.F2)
            (H := GraphLattices.SixPointHeart)) ∧
    (GraphLattices.sixPointHeartProjectiveChartEquivStableHalfPacket
        (some 0)).1 =
        LinearMap.range
          (GraphLattices.graphEmbedding (K := GraphLattices.F2)
            (Matrix.toLin'
              (0 : Matrix (Fin 4) (Fin 4) GraphLattices.F2))) ∧
    (GraphLattices.sixPointHeartProjectiveChartEquivStableHalfPacket
        (some 1)).1 =
        LinearMap.range
          (GraphLattices.graphEmbedding (K := GraphLattices.F2)
            (Matrix.toLin'
              (1 : Matrix (Fin 4) (Fin 4) GraphLattices.F2))) ∧
    (GraphLattices.sixPointHeartProjectiveChartEquivStableHalfPacket
        (some GraphLattices.sixAxisQuadraticSlopeRootInF4)).1 =
        LinearMap.range
          (GraphLattices.graphEmbedding (K := GraphLattices.F2)
            (Matrix.toLin' GraphLattices.sixPointHeartCommutantRoot)) ∧
    (GraphLattices.sixPointHeartProjectiveChartEquivStableHalfPacket
        (some (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1))).1 =
        LinearMap.range
          (GraphLattices.graphEmbedding (K := GraphLattices.F2)
            (Matrix.toLin'
              (GraphLattices.sixPointHeartCommutantRoot + 1))) := by
  exact ⟨⟨GraphLattices.sixPointHeartProjectiveLineEquivStableHalfPacket⟩,
    GraphLattices.sixPointHeartProjectiveChartEquivStableHalfPacket_marked_values⟩
/-- The explicit alternating polarization form on two copies of the six-point
coefficient heart is nondegenerate, and the five packet members are exactly
the diagonally stable maximal-isotropic subspaces.  Choosing the standard
symplectic basis of the two-dimensional torsion factor identifies the
rank-eight tensor discriminant with this two-heart model, preserves the form,
and transports the same exact classification.  This does not identify the
explicit form or packet with a geometric Weil pairing or isogeny kernel. -/
theorem principalGluing_sixPointCoefficientHeart_packet_maximalIsotropic :
    GraphLattices.sixPointHeartPairPolarizationBilinForm.IsAlt ∧
    GraphLattices.sixPointHeartPairPolarizationBilinForm.Nondegenerate ∧
    (∀ subspace : Submodule GraphLattices.F2
        (GraphLattices.SixPointHeart × GraphLattices.SixPointHeart),
      subspace ∈ GraphLattices.SixPointHeartStableHalfPacket ↔
        GraphLattices.SixPointHeartPairGeneratorStable subspace ∧
          GraphLattices.IsMaximalIsotropic
            GraphLattices.sixPointHeartPairPolarizationBilinForm subspace) ∧
    (∀ left right : GraphLattices.SixAxisStandardDiscriminantCoordinates,
      GraphLattices.sixPointHeartPairPolarizationBilinForm
          (GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv left)
          (GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv right) =
        GraphLattices.sixAxisStandardDiscriminantBilinForm left right) ∧
    ∀ subspace : Submodule GraphLattices.F2
        GraphLattices.SixAxisStandardDiscriminantCoordinates,
      subspace.map
          GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
          GraphLattices.SixPointHeartStableHalfPacket ↔
        GraphLattices.SixAxisStandardDiscriminantGeneratorStable subspace ∧
          GraphLattices.IsMaximalIsotropic
            GraphLattices.sixAxisStandardDiscriminantBilinForm subspace :=
  ⟨GraphLattices.sixPointHeartPairPolarizationBilinForm_isAlt,
    GraphLattices.sixPointHeartPairPolarizationBilinForm_nondegenerate,
    GraphLattices.sixPointHeartStableHalfPacket_iff_stable_maximalIsotropic,
    GraphLattices.sixAxisStandardDiscriminantPairLinearEquiv_preserves_form,
    GraphLattices.sixAxisStandardDiscriminant_stablePacket_iff⟩
/-- Polarization core for the gluing packet: a self-adjoint linear slope has
isotropic graph for the alternating two-copy pairing; its graph range has
the dimension of one coefficient copy while the ambient pair has twice that
dimension. -/
theorem principalGluing_selfAdjointGraph_isotropic_halfDimension
    {K H : Type*} [Field K] [AddCommGroup H] [Module K H] [Module.Finite K H]
    (coefficientPairing : H →ₗ[K] H →ₗ[K] K)
    (slope : H →ₗ[K] H)
    (selfAdjoint : ∀ left right,
      coefficientPairing left (slope right) =
        coefficientPairing (slope left) right) :
    (∀ left right : H,
      GraphLattices.multiplicityAlternatingPairing coefficientPairing
        (GraphLattices.graphEmbedding (K := K) slope left)
        (GraphLattices.graphEmbedding (K := K) slope right) = 0) ∧
      Module.finrank K
          (LinearMap.range (GraphLattices.graphEmbedding (K := K) slope)) =
        Module.finrank K H ∧
      Module.finrank K (H × H) = 2 * Module.finrank K H := by
  exact ⟨GraphLattices.graphEmbedding_isotropic_of_selfAdjoint
      coefficientPairing slope selfAdjoint,
    GraphLattices.finrank_graphEmbedding_range slope,
    GraphLattices.finrank_multiplicity_pair⟩
/-- Finite-field Frobenius core for the exotic pair: squaring on the chosen
`F4` fixes exactly `0` and `1`, is involutive, and exchanges every other
element with a distinct conjugate.  On both the affine chart and the actual
projective line, the two nonfixed points are identified exactly as the scalar
graphs of the transported marked quadratic root and `root+1`.
This statement does not identify a
normalizer action with Frobenius. -/
theorem principalGluing_f4Frobenius_fixed_and_exchanged :
    (∀ a : GraphLattices.F4,
      GraphLattices.f4FrobeniusRingEquiv a =
        GraphLattices.f4Frobenius a) ∧
    (∀ point : Option GraphLattices.F4,
      GraphLattices.f4ProjectiveFrobenius point =
        point.map GraphLattices.f4FrobeniusRingEquiv) ∧
    (∀ a : GraphLattices.F4,
      GraphLattices.f4Frobenius a = a ↔ a = 0 ∨ a = 1) ∧
    Function.Involutive GraphLattices.f4Frobenius ∧
    (∀ a : GraphLattices.F4, a ≠ 0 → a ≠ 1 →
      GraphLattices.f4Frobenius a ≠ a ∧
        GraphLattices.f4Frobenius (GraphLattices.f4Frobenius a) = a) ∧
    (∀ point : Option GraphLattices.F4,
      GraphLattices.f4ProjectiveFrobenius point = point ↔
        point = none ∨ point = some 0 ∨ point = some 1) ∧
    (∀ point : Option GraphLattices.F4,
      GraphLattices.f4ProjectiveFrobenius point ≠ point ↔
        point = some GraphLattices.sixAxisQuadraticSlopeRootInF4 ∨
          point =
            some (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1)) ∧
    Function.Involutive GraphLattices.f4ProjectiveLineFrobenius ∧
    (∀ point : Projectivization GraphLattices.F4
        (GraphLattices.F4 × GraphLattices.F4),
      GraphLattices.f4ProjectiveLineFrobenius point ≠ point ↔
        point = GraphLattices.scalarGraphPoint GraphLattices.F4
          GraphLattices.sixAxisQuadraticSlopeRootInF4 ∨
        point = GraphLattices.scalarGraphPoint GraphLattices.F4
          (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1)) := by
  exact ⟨GraphLattices.f4FrobeniusRingEquiv_apply,
    GraphLattices.f4ProjectiveFrobenius_eq_option_map,
    GraphLattices.f4Frobenius_fixed_iff,
    GraphLattices.f4Frobenius_involutive,
    GraphLattices.f4Frobenius_exchanges_nonPrimeElement,
    GraphLattices.f4ProjectiveFrobenius_fixed_iff,
    GraphLattices.f4ProjectiveFrobenius_nonfixed_iff_markedProjectivePair,
    GraphLattices.f4ProjectiveLineFrobenius_involutive,
    GraphLattices.f4ProjectiveLineFrobenius_nonfixed_iff_markedGraphPair⟩
/-- Frobenius marking on the packet of diagonally stable halves of the
coefficient heart.  Frobenius of the labelling field, transported to the packet
through its affine-chart equivalence, is an involution whose fixed members are
exactly the three defined over the prime field — the vertical copy and the
graphs of the slopes `0` and `1` — and which exchanges the two remaining
members, the graphs of `W` and `W+1`.  On a graph member it squares the slope.
Marking a subspace means asserting that it is moved by this involution; for a
packet member that is equivalent to being one of the two exotic members, and
the slope of either has minimal polynomial `t²+t+1` over the field with two
elements, so it generates a quadratic finite-etale extension.  Stability under
the packet-preserving group cannot make this distinction, since every packet
member is stable.  This statement identifies no geometric Galois or normalizer
action with the transported involution. -/
theorem principalGluing_stableHalfPacket_frobeniusMarking :
    Function.Involutive
        GraphLattices.sixPointHeartStableHalfPacketFrobenius ∧
    (∀ member : {subspace // subspace ∈
        GraphLattices.SixPointHeartStableHalfPacket},
      GraphLattices.sixPointHeartStableHalfPacketFrobenius member = member ↔
        member.1 ∈ GraphLattices.SixPointHeartPrimeFieldHalfTriple) ∧
    (∀ member : {subspace // subspace ∈
        GraphLattices.SixPointHeartStableHalfPacket},
      GraphLattices.sixPointHeartStableHalfPacketFrobenius member ≠ member ↔
        member.1 ∈ GraphLattices.SixPointHeartExoticHalfPair) ∧
    (GraphLattices.sixPointHeartStableHalfPacketFrobenius
        (GraphLattices.sixPointHeartProjectiveChartEquivStableHalfPacket
          (some GraphLattices.sixAxisQuadraticSlopeRootInF4))).1 =
        LinearMap.range
          (GraphLattices.graphEmbedding (K := GraphLattices.F2)
            (Matrix.toLin'
              (GraphLattices.sixPointHeartCommutantRoot + 1))) ∧
    (GraphLattices.sixPointHeartStableHalfPacketFrobenius
        (GraphLattices.sixPointHeartProjectiveChartEquivStableHalfPacket
          (some (GraphLattices.sixAxisQuadraticSlopeRootInF4 + 1)))).1 =
        LinearMap.range
          (GraphLattices.graphEmbedding (K := GraphLattices.F2)
            (Matrix.toLin' GraphLattices.sixPointHeartCommutantRoot)) ∧
    (∀ scalar : GraphLattices.F4,
      GraphLattices.sixPointHeartCommutantMatrixOfF4
          (GraphLattices.f4Frobenius scalar) =
        GraphLattices.sixPointHeartCommutantMatrixOfF4 scalar ^ 2) ∧
    (∀ subspace : Submodule GraphLattices.F2
        (GraphLattices.SixPointHeart × GraphLattices.SixPointHeart),
      subspace ∈ GraphLattices.SixPointHeartStableHalfPacket →
        (GraphLattices.SixPointHeartFrobeniusMarked subspace ↔
          subspace ∈ GraphLattices.SixPointHeartExoticHalfPair)) ∧
    ∀ subspace : Submodule GraphLattices.F2
        (GraphLattices.SixPointHeart × GraphLattices.SixPointHeart),
      subspace ∈ GraphLattices.SixPointHeartExoticHalfPair →
        ∃ slope : Matrix (Fin 4) (Fin 4) GraphLattices.F2,
          subspace = LinearMap.range
              (GraphLattices.graphEmbedding (K := GraphLattices.F2)
                (Matrix.toLin' slope)) ∧
            slope ^ 2 + slope + 1 = 0 ∧
            minpoly GraphLattices.F2 slope =
              GraphLattices.sixAxisQuadraticSlopePolynomial := by
  exact ⟨GraphLattices.sixPointHeartStableHalfPacketFrobenius_involutive,
    GraphLattices.sixPointHeartStableHalfPacketFrobenius_fixed_iff,
    GraphLattices.sixPointHeartStableHalfPacketFrobenius_nonfixed_iff_exotic,
    GraphLattices.sixPointHeartStableHalfPacketFrobenius_exchanges_exoticPair.1,
    GraphLattices.sixPointHeartStableHalfPacketFrobenius_exchanges_exoticPair.2,
    GraphLattices.sixPointHeartCommutantMatrixOfF4_frobenius,
    fun _ member ↦ GraphLattices.sixPointHeartFrobeniusMarked_iff_exotic member,
    fun _ member ↦ GraphLattices.sixPointHeartExoticHalfPair_graphSlope member⟩
/-- The transported Frobenius involution of the stable-half packet is the heart
action of an odd permutation of the six labels.  The labels are the six points
of the projective line over the field with five elements; the two displayed
generators of the heart action, the translation and the involution `x ↦ -1/x`,
are even permutations of them, while scaling by the non-square scalar `2` is
odd.  Permuting the six labels acts on the four heart coordinates through the
displayed matrix of the permutation, for every vector of the augmentation
hyperplane and every word in the three generators; the sign of the label
permutation of a word is the parity of its number of scaling letters.  On the
packet of diagonally stable halves of two copies of the heart, the diagonal
action of the scaling matrix is exactly the Frobenius involution transported
from the labelling field, so a packet member is Frobenius marked precisely when
that action moves it.  Every word with an even label permutation fixes every
packet member, and every word with an odd one acts as the transported
involution; the packet action of the group generated by the three displayed
label permutations therefore factors through the sign character of the six
labels.  In the other direction, each of the three members defined over the
prime field is fixed by the diagonal action of every invertible heart matrix, so
a packet member moved by any such action is one of the two exotic members and no
invariance hypothesis under a group of heart matrices can separate the three
prime-field members.  This statement identifies no geometric Galois action or
arithmetic
Frobenius of a family with these permutations, and it does not identify the six
labels with the six conjugate dihedral subgroups of the geometric argument. -/
theorem principalGluing_stableHalfPacket_frobeniusIsOddLabelAction :
    Equiv.Perm.sign GraphLattices.sixPointScalingPermutation = -1 ∧
    Equiv.Perm.sign GraphLattices.sixPointTranslationPermutation = 1 ∧
    Equiv.Perm.sign GraphLattices.sixPointInversionPermutation = 1 ∧
    (∀ word : List (Fin 3), ∀ vector : Fin 6 → GraphLattices.F2,
      ∑ point, vector point = 0 →
        GraphLattices.sixPointHeartCoordinates
            (vector ∘ (GraphLattices.sixPointLabelWordPermutation word).symm) =
          Matrix.mulVec (GraphLattices.sixPointHeartLabelWordMatrix word)
            (GraphLattices.sixPointHeartCoordinates vector)) ∧
    (∀ word : List (Fin 3),
      Equiv.Perm.sign (GraphLattices.sixPointLabelWordPermutation word) =
        if GraphLattices.sixPointLabelWordOdd word then -1 else 1) ∧
    (∀ member : {subspace // subspace ∈
        GraphLattices.SixPointHeartStableHalfPacket},
      (GraphLattices.sixPointHeartStableHalfPacketFrobenius member).1 =
        Submodule.map (GraphLattices.sixPointHeartPairMap
          GraphLattices.sixPointHeartScaling) member.1) ∧
    (∀ subspace : Submodule GraphLattices.F2
        (GraphLattices.SixPointHeart × GraphLattices.SixPointHeart),
      subspace ∈ GraphLattices.SixPointHeartStableHalfPacket →
        (GraphLattices.SixPointHeartFrobeniusMarked subspace ↔
          Submodule.map (GraphLattices.sixPointHeartPairMap
            GraphLattices.sixPointHeartScaling) subspace ≠ subspace)) ∧
    (∀ word : List (Fin 3),
      Equiv.Perm.sign (GraphLattices.sixPointLabelWordPermutation word) = 1 →
        ∀ subspace : Submodule GraphLattices.F2
            (GraphLattices.SixPointHeart × GraphLattices.SixPointHeart),
          subspace ∈ GraphLattices.SixPointHeartStableHalfPacket →
            Submodule.map (GraphLattices.sixPointHeartPairMap
                (GraphLattices.sixPointHeartLabelWordMatrix word)) subspace =
              subspace) ∧
    (∀ word : List (Fin 3),
      Equiv.Perm.sign (GraphLattices.sixPointLabelWordPermutation word) = -1 →
        ∀ member : {subspace // subspace ∈
            GraphLattices.SixPointHeartStableHalfPacket},
          Submodule.map (GraphLattices.sixPointHeartPairMap
              (GraphLattices.sixPointHeartLabelWordMatrix word)) member.1 =
            (GraphLattices.sixPointHeartStableHalfPacketFrobenius member).1) ∧
    ∀ matrix inverse : Matrix (Fin 4) (Fin 4) GraphLattices.F2,
      matrix * inverse = 1 → inverse * matrix = 1 →
        (∀ subspace : Submodule GraphLattices.F2
            (GraphLattices.SixPointHeart × GraphLattices.SixPointHeart),
          subspace ∈ GraphLattices.SixPointHeartPrimeFieldHalfTriple →
            Submodule.map (GraphLattices.sixPointHeartPairMap matrix)
              subspace = subspace) ∧
        ∀ subspace : Submodule GraphLattices.F2
            (GraphLattices.SixPointHeart × GraphLattices.SixPointHeart),
          subspace ∈ GraphLattices.SixPointHeartStableHalfPacket →
            Submodule.map (GraphLattices.sixPointHeartPairMap matrix)
                subspace ≠ subspace →
              subspace ∈ GraphLattices.SixPointHeartExoticHalfPair := by
  exact ⟨GraphLattices.sixPointScalingPermutation_sign,
    GraphLattices.sixPointTranslationPermutation_sign,
    GraphLattices.sixPointInversionPermutation_sign,
    fun word vector augmentation ↦
      GraphLattices.sixPointHeartCoordinates_labelWord word vector augmentation,
    GraphLattices.sixPointLabelWordPermutation_sign,
    GraphLattices.sixPointHeartStableHalfPacketFrobenius_eq_scalingMap,
    fun _ member ↦
      GraphLattices.sixPointHeartFrobeniusMarked_iff_scaling_moves member,
    fun word even _ member ↦
      GraphLattices.sixPointHeartStableHalfPacket_evenLabelWord_fix word even
        member,
    fun word odd member ↦
      GraphLattices.sixPointHeartStableHalfPacket_oddLabelWord_frobenius word
        odd member,
    fun _ _ rightInverse leftInverse ↦
      ⟨fun _ member ↦
          GraphLattices.sixPointHeartPrimeFieldHalfTriple_map_eq_self
            rightInverse leftInverse member,
        fun _ member moved ↦
          GraphLattices.sixPointHeartStableHalfPacket_moved_mem_exoticPair
            rightInverse leftInverse member moved⟩⟩
/-- The packet-preserving label permutations are exactly the group generated by
the three displayed ones, and that group is the full normalizer of the
alternating image.  Every permutation of the six labels acts on the four heart
coordinates through a heart matrix, multiplicatively in the permutation, and it
preserves the packet of diagonally stable halves exactly when conjugation by
that matrix carries the distinguished commutant element `W` either to itself or
to `W+1`.  The permutations whose heart matrix centralizes `W` form a group of
order sixty, which is exactly the image of the alternating group on five letters
acting on its six Sylow-five subgroups, that is, the group generated by the
displayed translation and the displayed involution `x ↦ -1/x`.  Consequently the
packet-preserving permutations form a group of order one hundred twenty; it is
generated by those two permutations together with scaling by the non-square
scalar, and it equals the normalizer of the alternating image in the symmetric
group on the six labels.  So no label permutation outside the displayed
three-generator group preserves the packet, and that group is not merely
contained in the normalizer but equal to it.  This statement identifies no
geometric Galois action with these permutations and does not identify the six
labels with the six conjugate dihedral subgroups of the geometric argument. -/
theorem principalGluing_stableHalfPacket_labelGroupIsNormalizer :
    (∀ permutation : Equiv.Perm (Fin 6),
      GraphLattices.SixPointHeartPacketPreserving permutation ↔
        permutation ∈ GraphLattices.sixPointLabelPacketGroup) ∧
    GraphLattices.sixPointLabelCommutantGroup =
        GraphLattices.alternatingFiveSixPointAction.range ∧
      Nat.card GraphLattices.sixPointLabelCommutantGroup = 60 ∧
        GraphLattices.sixPointLabelPacketGroup =
            Subgroup.closure GraphLattices.sixPointLabelGeneratorSet ∧
          GraphLattices.sixPointLabelPacketGroup =
              Subgroup.normalizer
                GraphLattices.alternatingFiveSixPointAction.range ∧
            Nat.card GraphLattices.sixPointLabelPacketGroup = 120 :=
  ⟨GraphLattices.sixPointHeartPacketPreserving_iff,
    GraphLattices.sixPointLabelCommutantGroup_eq_alternatingRange,
    GraphLattices.natCard_sixPointLabelCommutantGroup,
    GraphLattices.sixPointLabelPacketGroup_eq_closure,
    GraphLattices.sixPointLabelPacketGroup_eq_normalizer,
    GraphLattices.natCard_sixPointLabelPacketGroup⟩
/-- The dictionary between the fifteen pairs of labels and the fifteen nonzero
heart vectors, and what it says about the distinguished commutant element `W`.
The characteristic-two indicator vector of a pair of distinct labels has nonzero
image in the four-dimensional coefficient heart; every nonzero heart vector
arises that way; and the heart matrix of a label permutation carries the heart
vector of a pair to the heart vector of the permuted pair.  Under this
dictionary the displayed one-factorization of the fifteen pairs into five
perfect matchings is exactly the orbit decomposition of multiplication by `W`:
two nonzero heart vectors belong to a common matching precisely when one is the
other, or the other multiplied by `W`, or the other multiplied by `W+1`.
Consequently a permutation of the six labels carries every matching of the
displayed one-factorization to a matching precisely when conjugation by its
heart matrix carries `W` to `W` or to `W+1`, and it centralizes `W` precisely
when it both preserves that one-factorization and is an even permutation of the
six labels.  Preserving the one-factorization is therefore strictly weaker than
centralizing `W`.  The six labels here are abstract: this statement identifies
no geometric Galois action and does not identify them with the six conjugate
dihedral subgroups of the geometric argument. -/
theorem principalGluing_stableHalfPacket_labelOneFactorizationDictionary :
    (∀ first second : Fin 6, first ≠ second →
        GraphLattices.sixPointDuadHeart first second ≠ 0) ∧
      (∀ vector : Fin 4 → GraphLattices.F2, vector ≠ 0 →
          ∃ first second : Fin 6, first ≠ second ∧
            GraphLattices.sixPointDuadHeart first second = vector) ∧
        (∀ (permutation : Equiv.Perm (Fin 6)) (first second : Fin 6),
            Matrix.mulVec
                (GraphLattices.sixPointHeartPermutationMatrix permutation)
                (GraphLattices.sixPointDuadHeart first second) =
              GraphLattices.sixPointDuadHeart (permutation first)
                (permutation second)) ∧
          (∀ left right : Fin 4 → GraphLattices.F2, left ≠ 0 → right ≠ 0 →
              (GraphLattices.sixPointHeartFactor left =
                  GraphLattices.sixPointHeartFactor right ↔
                right = left ∨
                  right = Matrix.mulVec
                      GraphLattices.sixPointHeartCommutantRoot left ∨
                    right = Matrix.mulVec
                      (GraphLattices.sixPointHeartCommutantRoot + 1) left)) ∧
            (∀ permutation : Equiv.Perm (Fin 6),
                GraphLattices.SixPointFactorizationPreserving permutation ↔
                  permutation ∈ GraphLattices.sixPointLabelPacketGroup) ∧
              ∀ permutation : Equiv.Perm (Fin 6),
                permutation ∈ GraphLattices.sixPointLabelCommutantGroup ↔
                  GraphLattices.SixPointFactorizationPreserving permutation ∧
                    Equiv.Perm.sign permutation = 1 :=
  ⟨fun _ _ distinct ↦ GraphLattices.sixPointDuadHeart_ne_zero distinct,
    fun _ nonzero ↦ GraphLattices.sixPointDuadHeart_exists nonzero,
    GraphLattices.sixPointHeartPermutationMatrix_mulVec_duadHeart,
    fun _ _ leftNonzero rightNonzero ↦
      GraphLattices.sixPointHeartFactor_eq_iff leftNonzero rightNonzero,
    GraphLattices.sixPointFactorizationPreserving_iff_mem_packetGroup,
    GraphLattices.mem_sixPointLabelCommutantGroup_iff_even_factorizationPreserving⟩
/-- Concrete polarization calculation from the principal-gluing proof.  The
trace of the determinant on `F4²` is nondegenerate over `F2`; the induced
form on two multiplicity copies is nondegenerate; and every scalar graph is
self-orthogonal, hence maximal isotropic. -/
theorem principalGluing_f4TraceDeterminant_maximalIsotropic :
    GraphLattices.f4TraceDeterminantPairing.Nondegenerate ∧
    GraphLattices.f4MultiplicityAlternatingForm.Nondegenerate ∧
    ∀ a : GraphLattices.F4,
      LinearMap.BilinForm.orthogonal
          GraphLattices.f4MultiplicityAlternatingForm
          (LinearMap.range
            (GraphLattices.graphEmbedding
              (GraphLattices.f4ScalarSlope a))) =
        LinearMap.range
          (GraphLattices.graphEmbedding
            (GraphLattices.f4ScalarSlope a)) := by
  exact ⟨GraphLattices.f4TraceDeterminantPairing_nondegenerate,
    GraphLattices.f4MultiplicityAlternatingForm_nondegenerate,
    GraphLattices.f4ScalarGraph_orthogonal_eq⟩
/-- Algebraic core of the manuscript's exotic-stabilizer order calculation.
Nondegeneracy of the field trace makes any trace-preserving determinant scalar
equal to one, and the resulting concrete special linear group has order `60`.
This statement does not identify a permutation stabilizer with that group or
with `A5`. -/
theorem principalGluing_exoticStabilizer_algebraicCore :
    (∀ d : GraphLattices.F4ˣ,
      (∀ z : GraphLattices.F4,
        Algebra.trace (ZMod 2) GraphLattices.F4 ((d : GraphLattices.F4) * z) =
          Algebra.trace (ZMod 2) GraphLattices.F4 z) →
      d = 1) ∧
    Nat.card
      (Matrix.SpecialLinearGroup (Fin 2) GraphLattices.F4) = 60 := by
  constructor
  · intro d tracePreserved
    apply Units.ext
    exact GraphLattices.f4_eq_one_of_trace_mul_eq_trace d tracePreserved
  · exact GraphLattices.f4_specialLinearGroup_two_card
/-- Abstract exceptional-group identification supporting the stabilizer
paragraph: the ordinary alternating group on five letters has order `60`,
and the concrete `SL₂(F4)` is isomorphic to it.  This does not identify the
manuscript's geometric permutation action or its named `A5` subgroup with
either side of this equivalence. -/
theorem principalGluing_abstractExceptionalGroup :
    Nat.card (alternatingGroup (Fin 5)) = 60 ∧
      Nonempty
        (Matrix.SpecialLinearGroup (Fin 2) GraphLattices.F4 ≃*
          alternatingGroup (Fin 5)) := by
  exact ⟨GraphLattices.alternatingGroup_fin_five_card,
    ⟨GraphLattices.specialLinearGroupF4EquivAlternatingFive⟩⟩
/-- Abstract outer-normalizer calculation on the five-point packet.
Arithmetic Frobenius is a transposition, hence odd, and its conjugation
preserves the transported alternating subgroup.  This does not identify the
permutation with a geometric normalizer element of the six-axis family. -/
theorem principalGluing_f4Frobenius_oddNormalizer :
    Nat.card (Equiv.Perm (Fin 5)) = 120 ∧
      (alternatingGroup (Fin 5)).index = 2 ∧
      Subgroup.normalizer
          (alternatingGroup (Fin 5) : Set (Equiv.Perm (Fin 5))) = ⊤ ∧
      GraphLattices.f4FrobeniusPermutation ∈
        Subgroup.normalizer
          (alternatingGroup (Fin 5) : Set (Equiv.Perm (Fin 5))) ∧
      GraphLattices.f4FrobeniusPermutation ∉ alternatingGroup (Fin 5) ∧
      GraphLattices.f4FrobeniusPermutation.IsSwap ∧
      Equiv.Perm.sign GraphLattices.f4FrobeniusPermutation = -1 ∧
      (∀ permutation : alternatingGroup (Fin 5),
        GraphLattices.f4FrobeniusPermutation * permutation *
            GraphLattices.f4FrobeniusPermutation⁻¹ ∈
          alternatingGroup (Fin 5)) ∧
      ∀ matrix : PSL(2, GraphLattices.F4),
        ∃ conjugate : PSL(2, GraphLattices.F4),
          GraphLattices.psl2F4ProjectiveAction conjugate =
            GraphLattices.f4FrobeniusPermutation *
                GraphLattices.psl2F4ProjectiveAction matrix *
              GraphLattices.f4FrobeniusPermutation⁻¹ := by
  exact ⟨GraphLattices.symmetricGroup_fin_five_card,
    GraphLattices.alternatingGroup_fin_five_index,
    GraphLattices.alternatingGroup_fin_five_normalizer_eq_top,
    GraphLattices.f4FrobeniusPermutation_mem_normalizer,
    GraphLattices.f4FrobeniusPermutation_not_mem_alternating,
    GraphLattices.f4FrobeniusPermutation_isSwap,
    GraphLattices.f4FrobeniusPermutation_sign,
    GraphLattices.f4FrobeniusPermutation_conjugate_mem_alternating,
    GraphLattices.exists_psl2F4_projectiveAction_eq_frobenius_conjugate⟩
/-- Reviewer-facing simplicity and endomorphism algebras of the two six-point
hearts.  The six labels carry the six order-five subgroups of the alternating
group on five letters, and the two generators permute them by conjugation
exactly as they permute the labels; the generator words realize the whole
alternating group.  For each of the characteristics two and three, the heart is
the quotient of the augmentation hyperplane of the six-label permutation module
by its constant line, presented in four explicit coordinates, and the two label
permutations induce the displayed generator matrices.

Every subspace stable under the generated action is zero or everything, so both
hearts are simple.  In characteristic two the commutant of the generated action
is `{0, 1, W, W + 1}` with `W ^ 2 + W + 1 = 0`, `W (W + 1) = 1`, and the four
elements pairwise distinct, so it is the field with four elements; in
characteristic three the commutant consists of the scalar matrices alone, which
is the field with three elements.  The identification of the six labels with
dihedral subgroups arising from a geometric object is not part of this
statement. -/
theorem sixPointHearts_simple_with_endomorphism_algebras :
    (∀ heart : Fin 4 → GraphLattices.F2,
        GraphLattices.sixPointHeartCoordinates
          (GraphLattices.sixPointHeartRepresentative heart) = heart) ∧
      (∀ vector : Fin 6 → GraphLattices.F2, ∑ point, vector point = 0 →
        (GraphLattices.sixPointHeartCoordinates vector = 0 ↔
          ∀ point, vector point = vector 5)) ∧
      (∀ heart : Fin 4 → GraphLattices.F2,
        GraphLattices.sixPointHeartCoordinates
            (GraphLattices.sixPointHeartRepresentative heart ∘
              GraphLattices.sixPointTranslationPreimage) =
          Matrix.mulVec GraphLattices.sixPointHeartTranslation heart ∧
        GraphLattices.sixPointHeartCoordinates
            (GraphLattices.sixPointHeartRepresentative heart ∘
              GraphLattices.sixPointInversionPreimage) =
          Matrix.mulVec GraphLattices.sixPointHeartInversion heart) ∧
      (∀ subspace : Submodule GraphLattices.F2 (Fin 4 → GraphLattices.F2),
        (∀ (word : List Bool) (vector : Fin 4 → GraphLattices.F2),
          vector ∈ subspace →
            Matrix.mulVec (GraphLattices.sixPointHeartWordMatrix word) vector ∈
              subspace) →
          subspace = ⊥ ∨ subspace = ⊤) ∧
      (∀ matrix : Matrix (Fin 4) (Fin 4) GraphLattices.F2,
        (∀ word : List Bool,
          matrix * GraphLattices.sixPointHeartWordMatrix word =
            GraphLattices.sixPointHeartWordMatrix word * matrix) ↔
          matrix = 0 ∨ matrix = 1 ∨
            matrix = GraphLattices.sixPointHeartCommutantRoot ∨
            matrix = GraphLattices.sixPointHeartCommutantRoot + 1) ∧
      (GraphLattices.sixPointHeartCommutantRoot ^ 2 +
            GraphLattices.sixPointHeartCommutantRoot + 1 = 0 ∧
        GraphLattices.sixPointHeartCommutantRoot *
            (GraphLattices.sixPointHeartCommutantRoot + 1) = 1 ∧
        GraphLattices.sixPointHeartCommutantRoot ≠ 0 ∧
        GraphLattices.sixPointHeartCommutantRoot ≠ 1 ∧
        (0 : Matrix (Fin 4) (Fin 4) GraphLattices.F2) ≠ 1) ∧
      (∀ vector : GraphLattices.SixPointThreeAugmentation,
        GraphLattices.sixPointThreeAugmentationQuotientEquivHeart
            (Submodule.Quotient.mk vector) =
          GraphLattices.sixPointThreeHeartCoordinates vector.1) ∧
      (∀ heart : GraphLattices.SixPointThreeAugmentationQuotient,
        GraphLattices.sixPointThreeAugmentationQuotientEquivHeart
              (GraphLattices.sixPointThreeAugmentationQuotientTranslation heart) =
            Matrix.mulVec GraphLattices.sixPointThreeHeartTranslation
              (GraphLattices.sixPointThreeAugmentationQuotientEquivHeart heart) ∧
          GraphLattices.sixPointThreeAugmentationQuotientEquivHeart
              (GraphLattices.sixPointThreeAugmentationQuotientInversion heart) =
            Matrix.mulVec GraphLattices.sixPointThreeHeartInversion
              (GraphLattices.sixPointThreeAugmentationQuotientEquivHeart heart)) ∧
      (∀ subspace :
          Submodule GraphLattices.F3 GraphLattices.SixPointThreeHeart,
        (∀ (word : List Bool) (vector : GraphLattices.SixPointThreeHeart),
          vector ∈ subspace →
            Matrix.mulVec (GraphLattices.sixPointThreeHeartWordMatrix word)
              vector ∈ subspace) →
          subspace = ⊥ ∨ subspace = ⊤) ∧
      (∀ matrix : Matrix (Fin 4) (Fin 4) GraphLattices.F3,
        (∀ word : List Bool,
          matrix * GraphLattices.sixPointThreeHeartWordMatrix word =
            GraphLattices.sixPointThreeHeartWordMatrix word * matrix) ↔
          ∃ value : GraphLattices.F3,
            matrix = Matrix.scalar (Fin 4) value) :=
  GraphLattices.sixPointHearts_simple_with_endomorphism_algebras
/-- Reviewer-facing exclusion of a faithful symmetric action on the classified
automorphism groups.  The gluing argument rules out a rational two-primary
discriminant kernel by showing it would make the symmetric group on six letters
act faithfully on a smooth complex cubic threefold, which the classification of
faithful automorphism groups forbids.  Lean computes the order of that symmetric
group and proves the arithmetic that closes the argument: a group admitting an
injective homomorphism from it has order divisible by that order, so no group
whose order is smaller, and no group of order `9720`, admits one.

The classification enters as the hypothesis that the ambient order is one of a
supplied list, each entry of which is smaller than `720` or equal to `9720`.
Lean constructs neither cubic threefolds nor their automorphism groups and does
not prove the classification. -/
theorem symmetricSix_no_faithful_action_on_classified_orders
    {G : Type*} [Group G] [Finite G]
    (classifiedOrders : List ℕ) (listed : Nat.card G ∈ classifiedOrders)
    (classification : ∀ order ∈ classifiedOrders, order < 720 ∨ order = 9720) :
    Nat.card (Equiv.Perm (Fin 6)) = 720 ∧
      ¬ ∃ action : Equiv.Perm (Fin 6) →* G, Function.Injective action :=
  ⟨GraphLattices.symmetricSix_card, by
    rintro ⟨action, faithful⟩
    exact GraphLattices.no_faithful_symmetricSix_of_classified_list classifiedOrders
      listed classification action faithful⟩
/-- Reviewer-facing exclusion of two orthogonal lines in the two-primary
coefficient heart.  The heart is modelled as a two-dimensional space over the
four-element field with the trace-determinant pairing to the two-element field.
A line over the four-element field is totally isotropic for that pairing, and
two such lines orthogonal to one another coincide: the second spanning vector is
a multiple of the first.  So an orthogonal decomposition of the heart into
subspaces over the four-element field cannot have two one-dimensional summands,
and one summand carries the whole heart.  Lean constructs no abelian variety,
isogeny, polarization, or integral homology lattice, and does not identify this
model with the discriminant heart of the six-axis lattice. -/
theorem twoPrimaryHeart_orthogonal_lines_coincide
    {left right : GraphLattices.F4 × GraphLattices.F4} (nonzero : left ≠ 0)
    (orthogonal : ∀ first second : GraphLattices.F4,
      GraphLattices.f4TraceDeterminantPairing (first • left) (second • right) = 0) :
    ∃ scalar : GraphLattices.F4, right = scalar • left :=
  GraphLattices.orthogonal_lines_coincide nonzero orthogonal
/-- Reviewer-facing vanishing of a small stable subspace of the two-primary
coefficient heart.  A subspace over the four-element field with at most two
elements is trivial, since a nonzero one contains the four multiples of any of
its nonzero elements.  This is the parity step excluding an odd-degree isogeny
from a product of five elliptic curves: each of the five summands of the heart
would be cyclic of exponent two, hence trivial, and the heart would vanish.
Lean constructs no elliptic curve, isogeny, or summand decomposition of the
heart. -/
theorem twoPrimaryHeart_smallStableSubspace_eq_bot
    {subspace : Submodule GraphLattices.F4 (GraphLattices.F4 × GraphLattices.F4)}
    (small : Nat.card subspace ≤ 2) : subspace = ⊥ :=
  GraphLattices.eq_bot_of_natCard_le_two small

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
