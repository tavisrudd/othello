import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.CubicThreefold
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.CubicAtomOneStep

/-!
# Transport from a cubic threefold to a genus-eight Fano threefold

Two independent routes are formalized, matching the two assertions the
manuscript proves about a smooth prime Fano threefold of genus eight.

The first route transports the framed sixth-root multiplicity.  It uses two
rank-two projective-bundle formulas, a birational map between the two total
spaces, and birational invariance of the multiplicity through dimension four,
and it concludes both that the multiplicity of the Fano carrier is two and that
one projective-line stabilization of it is not rational.

The second route uses no multiplicity at all.  A rank-two projective bundle is
birational to the product of its base with a projective line, so the flop
between the two total spaces makes the stabilized Fano threefold birational to
the stabilized cubic threefold; irrationality then transports backwards from
the cubic, where it is supplied by the ordinary Hodge-atom argument.  Only
symmetry and transitivity of birational equivalence and invariance of
rationality under it are used.

The geometric premise of both routes is the construction in Alexander
Kuznetsov, *Derived categories of cubic and V14 threefolds* (2004), Proceedings
of the Steklov Institute of Mathematics 246, Theorems 2.17--2.18;
arXiv:math/0303037.  The associated cubic packet used by the first route is the
premise documented in the cubic-threefold module.  Neither source is imported as
a Lean axiom, and Lean constructs neither the Fano threefold, the Pfaffian
cubic, the rank-two bundles, their projectivizations, nor the flop.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

variable {Variety Atom : Type*}

/-- The geometric operations and predicates in the genus-eight application.
The associated cubic and the two projective-bundle total spaces are functions
of the specified Fano carrier, preventing unrelated abstract objects from being
substituted for the constructions in the theorem. -/
structure GenusEightGeometry (Variety : Type*) where
  isSmoothPrimeFanoThreefoldOfGenusEight : Variety → Prop
  isSmoothComplexCubicThreefold : Variety → Prop
  associatedPfaffianCubic : Variety → Variety
  fanoRankTwoBundleTotalSpace : Variety → Variety
  cubicRankTwoBundleTotalSpace : Variety → Variety
  productWithProjectiveLine : Variety → Variety
  projectiveFourSpace : Variety
  Rational : Variety → Prop

/-- External mathematical input for packet transport from the associated
Pfaffian cubic to a specified smooth prime Fano threefold of genus eight and
for the subsequent one-step rationality obstruction. -/
structure GenusEightOneStepInput
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : GenusEightGeometry Variety)
    (fano : Variety) where
  fanoIsSmoothPrimeGenusEight :
    geometry.isSmoothPrimeFanoThreefoldOfGenusEight fano
  associatedCubicIsSmooth :
    geometry.isSmoothComplexCubicThreefold (geometry.associatedPfaffianCubic fano)
  fanoBundleFormula : packet.multiplicity (geometry.fanoRankTwoBundleTotalSpace fano) =
    2 * packet.multiplicity fano
  cubicBundleFormula :
    packet.multiplicity (geometry.cubicRankTwoBundleTotalSpace fano) =
      2 * packet.multiplicity (geometry.associatedPfaffianCubic fano)
  fanoBundleDimension :
    packet.dimension (geometry.fanoRankTwoBundleTotalSpace fano) ≤ 4
  bundleFlopBirational : birationalInput.birational
    (geometry.fanoRankTwoBundleTotalSpace fano)
    (geometry.cubicRankTwoBundleTotalSpace fano)
  cubicPacket : packet.multiplicity (geometry.associatedPfaffianCubic fano) = 2
  stabilizationFormula : packet.multiplicity (geometry.productWithProjectiveLine fano) =
    2 * packet.multiplicity fano
  stabilizedDimension : packet.dimension (geometry.productWithProjectiveLine fano) ≤ 4
  projectiveSpacePacket : packet.multiplicity geometry.projectiveFourSpace = 0
  rationalComparison : geometry.Rational (geometry.productWithProjectiveLine fano) →
    birationalInput.birational
      (geometry.productWithProjectiveLine fano) geometry.projectiveFourSpace

/-- The rank-two projective-bundle flop transports packet multiplicity two
from the associated cubic threefold to the genus-eight Fano threefold. -/
theorem genusEight_packet_eq_two_of_projectiveBundle_flop
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : GenusEightGeometry Variety)
    {fano : Variety}
    (input : GenusEightOneStepInput packet birationalInput geometry fano) :
    packet.multiplicity fano = 2 := by
  calc
    packet.multiplicity fano =
        packet.multiplicity (geometry.associatedPfaffianCubic fano) :=
      Quantum.rankTwoProjectiveBundle_transport packet birationalInput
        input.fanoBundleFormula input.cubicBundleFormula
        input.fanoBundleDimension input.bundleFlopBirational
    _ = 2 := input.cubicPacket

/-- Under the explicit projective-bundle, flop, packet, and rational-comparison
premises, one projective-line stabilization of the genus-eight Fano threefold
is irrational. -/
theorem genusEight_oneStepStabilization_not_rational
    (packet : Quantum.PacketData Variety)
    (birationalInput : Quantum.DimensionFourBirationalInput packet)
    (geometry : GenusEightGeometry Variety)
    {fano : Variety}
    (input : GenusEightOneStepInput packet birationalInput geometry fano) :
    ¬ geometry.Rational (geometry.productWithProjectiveLine fano) := by
  apply Quantum.rankTwoStabilization_not_rational packet birationalInput geometry.Rational
    input.stabilizationFormula input.stabilizedDimension
  · rw [genusEight_packet_eq_two_of_projectiveBundle_flop
      packet birationalInput geometry input]
    omega
  · exact input.projectiveSpacePacket
  · exact input.rationalComparison

/-- The naming data of the unconditional route: the two predicates identifying a
smooth prime Fano threefold of genus eight and a smooth complex cubic
threefold, the associated Pfaffian cubic, and the total spaces of the two
rank-two projectivizations related by the flop.  Each object is a function of
the specified Fano carrier, so that unrelated abstract objects cannot be
substituted for the constructions in the theorem. -/
structure GenusEightFlopGeometry (Variety : Type*) where
  isSmoothPrimeFanoThreefoldOfGenusEight : Variety → Prop
  isSmoothComplexCubicThreefold : Variety → Prop
  associatedPfaffianCubic : Variety → Variety
  fanoRankTwoBundleTotalSpace : Variety → Variety
  cubicRankTwoBundleTotalSpace : Variety → Variety

/-- Birational equivalence and its interaction with a rationality predicate, at
the strength the unconditional route uses: the relation is symmetric and
transitive, and a variety birational to a rational one is rational.  No
factorization of a birational map, and no birational invariant, occurs
here. -/
structure BirationalRationalityInput (Variety : Type*) (Rational : Variety → Prop) where
  birational : Variety → Variety → Prop
  birational_symm : ∀ {source target : Variety},
    birational source target → birational target source
  birational_trans : ∀ {source middle target : Variety},
    birational source middle → birational middle target → birational source target
  rational_of_birational : ∀ {source target : Variety},
    birational source target → Rational source → Rational target

/-- External mathematical input for the unconditional route: the two carriers
are of the named kinds, each rank-two projectivization is birational to the
product of its base with a projective line, and the two projectivizations are
birational to each other through Kuznetsov's flop. -/
structure GenusEightFlopInput
    (ledger : Quantum.OrdinaryAtomLedger Variety Atom)
    (geometry : GenusEightFlopGeometry Variety)
    (rationality : BirationalRationalityInput Variety ledger.Rational)
    (fano : Variety) where
  fanoIsSmoothPrimeGenusEight :
    geometry.isSmoothPrimeFanoThreefoldOfGenusEight fano
  associatedCubicIsSmooth :
    geometry.isSmoothComplexCubicThreefold (geometry.associatedPfaffianCubic fano)
  fanoBundleBirationalProduct : rationality.birational
    (geometry.fanoRankTwoBundleTotalSpace fano) (ledger.productWithProjectiveLine fano)
  cubicBundleBirationalProduct : rationality.birational
    (geometry.cubicRankTwoBundleTotalSpace fano)
    (ledger.productWithProjectiveLine (geometry.associatedPfaffianCubic fano))
  bundleFlopBirational : rationality.birational
    (geometry.fanoRankTwoBundleTotalSpace fano)
    (geometry.cubicRankTwoBundleTotalSpace fano)

/-- One projective-line stabilization of the genus-eight Fano threefold is
birational to one projective-line stabilization of its associated Pfaffian
cubic threefold: both stabilizations are birational to the corresponding
rank-two projectivization, and the two projectivizations are related by the
flop. -/
theorem genusEight_stabilization_birational_cubicStabilization
    {ledger : Quantum.OrdinaryAtomLedger Variety Atom}
    {geometry : GenusEightFlopGeometry Variety}
    {rationality : BirationalRationalityInput Variety ledger.Rational}
    {fano : Variety} (input : GenusEightFlopInput ledger geometry rationality fano) :
    rationality.birational (ledger.productWithProjectiveLine fano)
      (ledger.productWithProjectiveLine (geometry.associatedPfaffianCubic fano)) :=
  rationality.birational_trans
    (rationality.birational_symm input.fanoBundleBirationalProduct)
    (rationality.birational_trans input.bundleFlopBirational
      input.cubicBundleBirationalProduct)

/-- One projective-line stabilization of a genus-eight Fano threefold is
irrational whenever the same stabilization of its associated Pfaffian cubic
threefold is.  The two stabilizations are birational through the flop, and
rationality is invariant under birational equivalence. -/
theorem genusEight_oneStepStabilization_not_rational_of_cubicStabilization
    {ledger : Quantum.OrdinaryAtomLedger Variety Atom}
    {geometry : GenusEightFlopGeometry Variety}
    {rationality : BirationalRationalityInput Variety ledger.Rational}
    {fano : Variety} (input : GenusEightFlopInput ledger geometry rationality fano)
    (cubicStabilizationIrrational : ¬ ledger.Rational
      (ledger.productWithProjectiveLine (geometry.associatedPfaffianCubic fano))) :
    ¬ ledger.Rational (ledger.productWithProjectiveLine fano) := fun rationalStabilization =>
  cubicStabilizationIrrational
    (rationality.rational_of_birational
      (genusEight_stabilization_birational_cubicStabilization input) rationalStabilization)

/-- The unconditional assertion about a smooth prime Fano threefold of genus
eight: one projective-line stabilization of it is not rational.  Irrationality
of the stabilized associated Pfaffian cubic comes from the ordinary Hodge-atom
argument, applied to the cubic zero-packet atom of that cubic, and the flop
transports it to the Fano carrier.  No framed multiplicity, weak factorization,
or quantum comparison is used, and no hypothesis beyond the ones displayed: the
flop, the two projectivization comparisons, the ordinary Hodge-atom premises, and
the birational invariance of rationality are hypotheses about supplied data, and
Lean constructs none of the geometry they speak about. -/
theorem genusEight_oneStepStabilization_not_rational_of_atomInputs
    {ledger : Quantum.OrdinaryAtomLedger Variety Atom}
    (stabilization : Quantum.ProjectiveLineStabilizationInput ledger)
    {exclusion : Quantum.LowDimensionalExclusionInput ledger}
    {geometry : GenusEightFlopGeometry Variety}
    {rationality : BirationalRationalityInput Variety ledger.Rational}
    {fano : Variety} {atom : Atom}
    (input : GenusEightFlopInput ledger geometry rationality fano)
    (cubicInput : CubicAtomOneStepInput ledger stabilization exclusion
      (geometry.associatedPfaffianCubic fano) atom) :
    ¬ ledger.Rational (ledger.productWithProjectiveLine fano) :=
  genusEight_oneStepStabilization_not_rational_of_cubicStabilization input
    (cubicAtom_oneStepStabilization_not_rational stabilization cubicInput)

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
