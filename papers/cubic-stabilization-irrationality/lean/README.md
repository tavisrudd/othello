# Lean companion to the cubic-stabilization irrationality paper

This is a paper-local Mathlib package. Its top-level namespace is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality
```

and its reviewer-facing entry point is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.PaperInterface
```

The modules isolate the fixed-phase identification interface. Lean checks the
crossed-row algebra, endpoint-indexed path syntax, monodromy-image
functoriality, and naturality of the directed projected variation. Vector
crossed-coordinate equations derive the model row reading. The reduced
horizontal reader proves that one marked comparison intertwining the two
monodromies transports model-side vanishing to an externally supplied actual
receiver when its induced incoming-image map is surjective.
The model construction is split into three separately inhabitable capability
records: incoming-image realization, target vector coordinates, and scalar row
coordinates. Only their assembly yields the full crossed-coordinate model.
The trait-level module proves the weaker specialization law actually consumed
by the vanishing argument: pointwise specialized variation commutes with a
marked semilinear comparison, so a normal-factor reading whose normal maps to
zero kills the fibre variation without asserting a tensor-product description
of the image packet.
The two named monodromies and the row form one endpoint-indexed diagram. A
single naturality field packages both intertwining equations; this is the same
mathematical input as the two equations in the semilinear-specialization
record. When the stronger datum of a horizontal morphism of full based-loop
representations is available, selecting loop classes constructs that diagram
morphism uniformly for every directed comparison.
The selected-local-system adapter makes the required vertical identifications
explicit: the pair selected from the trait representation must be the crossed
coordinate model diagram, and the pair selected from the fibre representation
must be the supplied actual fixed-phase diagram. With those two identifications
and ambient surjectivity, the global horizontal morphism constructs the full
trait-horizontal reader.
The same construction accepts marked gauge equivalences instead of literal
equality of frames. Each equivalence conjugates both selected monodromies and
transports the scalar row; the global semilinear map is transported through
the two gauges. Ambient surjectivity is invariant under this transport.
The horizontal morphism carries an explicit homomorphism between the trait and
fibre loop groups, so ramified loop reindexing is not identified with equality.
An endpoint-loop assignment can be constructed from the endpoint's QDM/deck
path and one supplied path-to-loop interpretation, eliminating per-edge loop
choice relative to that interpretation.
Common outputs carry a dependent provenance witness indexed by their actual
value: marking an output as moving-produced requires a moving source whose
crossed image is that value.
Environment-indexed endpoints compute the quantum path from the chamber path
and share their phase, character, and direction as type parameters, so those
compatibility equations are obtained by construction.
The descent-packet module separately checks the elementary equivariant
distinction between one regular orbit and three fixed points. It also makes the
load-bearing qualification explicit: a one-element correction is fixed only
when its singleton is stable under the supplied descent action. A unary outer
constructor otherwise retains the full action on its inner packet; formally,
the unary packet is fixed if and only if its inner value is fixed.
The two-layer descent module isolates the additional hypothesis that repairs
this obstruction.  With an action of a product group, an external-regular
coordinate has no point fixed by the external subgroup, whereas an
external-trivial packet is pointwise fixed by that subgroup even when its
internal action is arbitrary.  The module proves that these packets cannot be
equivariantly equivalent, even after adjoining an arbitrary external-trivial
correction packet to the external-regular source.  A weaker theorem requires
only that the target ledger have no externally free point; target actions may
factor nontrivially through proper quotients of the external group.  It does
not require pointwise external triviality.  The weakest theorem uses the
original loop group directly: an equivariant stable ledger must carry a chosen
source point to a point with exactly the same stabilizer.  This avoids assuming
that a cyclic quotient of the loop action splits.  A finite provider may
instead give, for each target point, one loop power whose fixedness differs
from the source point; the module derives the same obstruction without
materializing either stabilizer.  It does not construct the loop action or
its geometric comparison.

The geometric comparison with the actual QDM packet remains an explicit
inhabited-structure proposition. In particular, the package does not assume
that monodromy-image formation commutes with specialization. An application
may provide a marked semilinear comparison whose induced incoming image spans
the fibre packet. An explicit range base-change certificate is a stronger
implementation of that coverage condition; the monodromy and row compatibility
remain separate data.
Ambient surjectivity is another sufficient implementation: it formally makes
the induced incoming image surjective, hence spanning. The constructor
`TraitHorizontalReader.Reader.ofSurjective` packages that specialization.
Exact row normalization is not needed for vanishing. The scaled semilinear
reader permits the actual row to pull back to any target-scalar multiple of the
specialized model row; projected variation acquires the same factor, so a
normal specializing to zero still kills it.
For a whole based-loop representation, operator-diagram equivalences with row
factors on the model and actual sides are also accepted: their factors `alpha`
and `beta` need only
satisfy `beta = c * specialize alpha` for the residual row factor `c`. No
division by either row factor occurs.

For the projected-row vanishing alone, the model can be smaller.  The module
`Comparison.VariationNormalFactor` consumes the trait covector identity

`r * (1 - T_j) * (1 - T_i) = a * lambda`.

If `a` specializes to zero, a semilinear two-monodromy comparison whose
incoming image spans the fibre proves vanishing there.  A one-sided
can/variation factorization `v * c = 1 - T_i`, together with a scalar normal
form for `r * (1 - T_j) * v`, constructs this ambient identity.  The second
can/variation triangle and coverage of the full variation image are not used.
The reference covector `lambda` is explicit data; the formal result does not
assert that a divisible quotient extends regularly from a generic fibre.
For the integral window formula, `Comparison.ResonantWindowRank` proves the
finite alternating-mask identity that makes the rank of every moved generator
equal to one at resonance.

`Comparison.PointedDirectSum` isolates a different asymmetric bypass.  An
uncalibrated pairing-compatible direct-sum comparison cannot enter the row
consumer.  It must first carry a `ScaledRowCalibration` with a unit scale. An
`ExactRowCalibration` supplies its unit-one case. A stronger
`ExactPointCalibration`, asserting equality of the actual flat point with the
ambient point plus zero correction, constructs that row certificate by
pairing preservation; a full-variable point-insertion identity may instead
construct the exact row certificate directly. A
`CommonReceiverRowFactorization` gives a third constructor from two maps into
one rowed receiver. Dually, `CommonSourceRowFactorization` starts with two
endpoint maps out of one augmented Fourier or gauged source. In both cases a
commutative map square and multiplicatively compatible unit scales imply
`ScaledRowCalibration` without division. These are the types consumed by a
support-localization identity and use no uniqueness statement for a flat
point. `CommonSourceGeneratorAgreement` weakens the source-side presentation
further: exact agreement on any spanning generator set extends by linearity,
matching Fourier maps defined by explicit basis formulas. The still smaller
`RowedComparison` does not mention points or pairings at all, and
`CommonSourceGeneratorRows` constructs it from the same generatorwise data.
This row-only interface is appropriate when an adjoint augmentation formula
identifies the two rank rows directly. With the perfect QDM pairing the two
exact calibrations are equivalent; the second route changes how the source
theorem is proved, not its mathematical strength. A leading-term equality is
deliberately neither certificate.  Once exact row calibration is supplied,
the point row factors through ambient projection, ambient inclusion preserves
it, and the projection intertwines every forward iterate of the selected
invertible monodromy. The algebra is applied only after restricting scalars
to a base over which the pairing is bilinear; the full QDM pairing retains
the usual `z` versus `-z` variance and needs that typed adapter. Lean does not
construct the geometric calibration or infer it from horizontality and a
leading class.

`Comparison.RowedRepresentationDecomposition` combines the row-only direct
sum with one whole based-loop representation. Its comparison intertwines
every loop before endpoint loops are selected. One `LoopAssignment` then
produces exact marked diagram equivalences for every directed pair belonging
to that one edge. Separate incident edges may still carry unrelated copies of
the nominally shared vertex representation.
For any loop already in that representation, Lean proves that the source row
detects a generalized eigenspace if and only if the ambient row detects the
same eigenvalue and nilpotence exponent. Correction summands may contain that
eigenvalue; row factorization makes their multiplicity irrelevant.

`Comparison.RowedProjectorDecomposition` is the no-loop specialization for
an intrinsic spectral marker. `Projector` stores both a linear endomorphism
and its idempotence proof. `Data` stores source, ambient, and correction
projectors, a direct-sum equivalence, projector block naturality, and an exact
row factorization through ambient projection. The row may take values in a
different `R`-module, matching an algebraic QDM row with values in a larger
Givental coefficient module. Lean proves that row-visible marked support is
equivalent on source and ambient even when the correction projector is
nonzero, and that a detected source contradicts a zero ambient projector.
`Data.ofBasisSquares` constructs the full comparison data when the two squares
are verified only on a source basis.  This is the finite-free extension used
for Gu--Yu--Yu's ordinary equivariant basis of the completed wall module; it
does not invoke density, topology, or convergence.  The file does not
construct spectral projectors or prove the geometric basis equations.
`UnitScaledData` permits the two rows to differ by a unit, while
`CommonSourcePresentation` composes two presentations of one marked source;
its basis constructor checks the row square and both projector squares before
forming the endpoint comparison.  Faithfully flat scalar extensions reflect
and preserve detection through a common base, but the existence of such a
descent is an explicit hypothesis.  An injective map of row codomains may be
handled separately.  Polynomial functional calculus derives projector
naturality from one operator square, and tensoring with an auxiliary vector
whose row value is one preserves an endpoint witness.  These results verify
the algebraic consequences of finite certificates; they do not prove the
existence of the completed quantum-module maps or of a polynomial presentation
of the geometric spectral projector.
`Comparison.CoprimeFactorProjector` replaces that last presentation by an
explicit algebraic certificate: two polynomial factors, Bezout coefficients,
and annihilation by their product. Lean constructs the idempotent, proves that
it selects the first factor kernel and kills the second, and transports it
through every intertwiner of the chosen operators. It does not prove that a
geometric marker supplies those factors or that their product annihilates the
quantum module.
`Comparison.ProjectedRowProjectorDecomposition` weakens the row hypothesis to
the marked projector images.  Its detection theorem permits arbitrary row
leakage on unmarked correction factors while retaining the full projector
square and a unit normalization.  A full unit-scaled row comparison supplies
this restricted interface, but the converse is not assumed.  The same module
proves that a row-visible marked vector with zero ambient comparison component
rules out even this restricted interface.
`Comparison.PoleFreeProjectorObstruction` records the obstruction to replacing
the completed rowed carrier by algebraic vectors in a larger formal module.
The vectors fixed by the formal projector pull back to a submodule of the
algebraic carrier. If connection stability and irreducibility make that
submodule either zero or the whole carrier, and the projector is proper on the
included carrier, then no scalar row detects an included fixed vector. The
file also proves that horizontal inclusion and projector maps make the
pullback fixed submodule connection-stable and, under irreducibility and
properness, force it to be zero. It does not prove a
hypergeometric irreducibility criterion, construct the algebraic-to-formal
inclusion, or establish horizontality for a geometric projector.
`Comparison.TwoBaseRowedProjectorEdge` allows the two native endpoint modules
to have different coefficient rings. Faithful scalar extensions to one common
edge ring, together with the row and projector squares, preserve native
detection. Separate endpoint identifications then produce the semantic edge
used by `IntrinsicPath`; the file does not infer those identifications from
the vertex names.
The same module records that the projective-product branch count `m + 1` is
positive for every natural stabilization index; bounded external test suites
are not used to establish that quantifier.

`Comparison.CubicBlockCertificate` kernel-checks the exact rational marker
data used at the cubic endpoint: a nonzero nilpotent, modified-residue trace
`-1`, determinant `5/36`, discriminant `4/9`, and a row-visible normalized
block.  It also transports this witness through any tensor factor carrying a
row-value-one vector.  It does not identify that finite matrix model with a
geometric QDM.

`Comparison.HirzebruchSurfaceAugmentation` checks a four-coordinate
consequence of the published small quantum multiplication table for the first
Hirzebruch surface.  When both Novikov parameters are nonzero, every nonzero
eigenvector of multiplication by the first divisor has nonzero degree-zero
coordinate.  The theorem therefore rules out raw degree-zero augmentation as
a correction-killing row on any one-dimensional generic spectral factor of
that algebra.  It also proves that tensoring such an eigenvector with any
row-visible vector remains row-visible.  Combining this tensor statement with
the zero-ambient obstruction is purely linear algebra; identifying a
geometric product correction and its marked projector with those factors is
an external input.  The multiplication table and its geometric interpretation
are the cited external inputs.  The same module proves the operator relation
`T⁴ + q₁ T³ - q₁² q₂ = 0` and checks that, at `q₂ = 0`, the
additional root `-q₁` is simple.  This is the finite algebra used when a
Hensel argument separates the exceptional branch from the triple ambient
root; existence of that Hensel lift and its identification with a named
geometric deck action are not proved by the module.

`Comparison.ProjectiveSpaceQuantumPolynomial` proves that
`X^(m+4) - q` is separable over every characteristic-zero field when
`q` is nonzero.  This checks the absence of repeated spectral roots in the
standard small-quantum presentation of `P^(m+3)`; the geometric presentation
itself remains an imported input.

`Comparison.RowedProjectorPath` assigns every path vertex one carrier, row,
and marked projector.  Its edges are indexed by those exact values, so two
incident edges cannot silently choose unrelated realizations of their shared
vertex.  An oriented step may follow a direct-sum edge or traverse it in
reverse, so a path can mix blowups and blowdowns.  Lean composes the one-edge
detection equivalences and derives the zero-projector endpoint contradiction.
Constructing the native vertex
family, or proving that every completed edge occurrence is its faithful
pullback, remains an external geometric hypothesis.

When an edge theorem is already stated for one intrinsic vertex-indexed
detection predicate, `IntrinsicPath` gives a weaker telescope: it composes the
edgewise proposition equivalences without identifying adjacent carriers.
Each edge must still prove that its local comparison reflects that exact
intrinsic predicate.

`Comparison.RowedProjectorOccurrence` provides two source-facing assembly
lemmas.  A unit-scaled row/projector equivalence preserves detection between
two occurrences, and exact common-source presentations construct the typed
edge used by the path theorem.  Both compatibility equations must use one
map; the records do not construct the geometric presentations.  Its stricter
`FaithfulScalarEdge` interface fixes the two local rows and projectors
definitionally as faithful scalar extensions of native endpoint data.  Only a
direct-sum comparison, a correction projector, a unit row scale, and the row
and projector squares remain.  Those squares may be checked on a basis, and
the projector square may instead be derived from one intertwined operator and
polynomial presentations of the two projectors.  Lean then constructs the
intrinsic proposition-valued edge.  The interface does not prove that a
geometric completed comparison has these scalar-extension presentations,
satisfies the row equation, or realizes the marker by the named polynomial.

`Comparison.MarkedRepresentationEquivalence` gives the adjacent-edge
connector without imposing equality or uniqueness of sectorial frames. If
both copies of a shared vertex are marked-equivalent to one common carrier,
their transition conjugates every loop, transports the row, and preserves all
detected generalized-eigenspace Booleans. Constructing those marked
equivalences from a geometric quantum connection, including the passage from
the large-radius Gamma row to the selected irregular solution object, remains
an external input.

`Comparison.RowedRepresentationPath` gives the stronger pathwise type. A
single vertex-indexed family assigns each weak-factorization vertex one
carrier, one whole loop representation, and one row. Every directed edge is
indexed by the exact source and target values of that family, so consecutive
edges cannot use unrelated copies of their shared vertex. Lean then composes
the edgewise detected-support equivalences along any finite typed path. The
source of such a family must still provide one common coefficient base and
compatible completed germs; differently based formal power-series expansions
cannot inhabit the same vertex value merely because they describe the same
variety.

`Comparison.ParallelAugmentedSource` removes the need to compose those germs
when geometry supplies a stronger common source.  Each branch maps one
definitionally shared marked representation isomorphically to an endpoint
representation plus a row-invisible correction representation.  Lean proves
that any two branches have the same detected generalized-eigenspace Boolean,
although their endpoint carriers and correction representations may differ.
The module does not construct a global Fourier, gauged, or birational-cobordism
source with the required branch maps.

`Comparison.ParallelScalarExtensions` weakens the remaining coefficient-ring
requirement.  It starts from one marked representation before completion, but
allows every endpoint branch to use its own scalar ring and its own augmented
source decomposition.  The branch must explicitly certify that scalar
realization reflects the row-detected generalized-primary predicate.  Lean
then compares endpoints over unrelated chamber completions through the common
pre-completion Boolean.  This conservativity is not inferred from arbitrary
base change: specialization can kill a row or create a primary block.

`Comparison.PrimaryDetectionBaseChange` discharges that conservativity for
faithfully flat scalar extension.  Flatness identifies the generalized-primary
kernel after extension with the tensor product of the original kernel, and
faithfulness reflects whether the restricted marked row is zero.  The smart
constructor `ParallelScalarExtensions.Branch.ofFaithfullyFlatBaseChange`
therefore accepts an augmented decomposition over each branch field without a
separate Boolean-reflection proof.  It does not construct the finite rational
core or identify an analytic/Gamma endpoint with that algebraic base change.
Only eigenvalues already defined over the core are compared; the core must
therefore contain the selected primitive-sixth label and fix the compatible
root lift used by every branch.

`Comparison.ParallelPrimaryQuotients` removes the direct-sum requirement as
well.  Each branch may instead map its scalar-extended common source to the
endpoint, provided the map intertwines the selected loop, compares the rows
up to a unit, and covers the selected generalized-primary kernel.  Lean then
identifies endpoint detection through the common core.  Primary coverage is
not implied by ordinary surjectivity for a fixed nilpotence exponent: a
nonsplit operator extension can prevent a target kernel vector from having a
kernel lift of the same exponent.  When that exponent gives a Fitting
decomposition on the source and endpoint shifted operators, surjectivity does
give the required lift.  The constructor
`ParallelPrimaryQuotients.Branch.ofSurjectiveOfFitting` records this sharper
route.

`Comparison.MarkedWitnessObstruction` is the one-sided specialization used
when the target row has no selected-primary support. A detected primary witness in
the common marked core maps to a detected endpoint witness under only the
selected-loop square and a scalar row square. It assumes neither
surjectivity nor primary coverage.

`Comparison.GlobalCommonSourceObstruction` types a single-master-space
implementation of that consumer.  The map to the endpoint where detection is
already known must lift the selected primary vectors and compare rows by a
unit.  The map to the endpoint with empty marked support remains one-sided
and need not be surjective.  A surjective source-endpoint map yields the
required primary lift at an exponent satisfying the two Fitting conditions.
The module does not construct the master space, Fourier maps, common selected
action, or row identities.  Its `ScalarData` wrapper allows the two endpoint
maps to use unrelated faithfully flat coefficient extensions of one rational
marked core; the same-field `Data` is only the simpler special case.

`Comparison.BasedCoefficientMap` isolates the first requirement on such
completed germs. A map is based only when its residue square commutes. Hence a
coordinate vanishing at the source point cannot map to a target coordinate
plus a term with nonzero residue. The module also proves that an element with
unit residue cannot be nilpotent, so an Artin quotient cannot legalize a
translation by a unit constant. Completeness, continuity, and analytic
continuation remain outside this elementary coefficient-ring interface.

The algebraic model has a compact sufficient constructor. If the combined
crossed and moving map `(B,D)` admits a linear retraction, an explicit incoming
shear and target involution construct every crossed-coordinate field. An
integral linear equivalence realizing the full upper-triangular edge supplies
such a retraction. This condition is sufficient, not necessary, and generic
invertibility alone does not imply it over a trait ring. Because this target
operator is an involution, an actual comparison using this constructor must
separately justify involutivity on the covered target packet.

The stronger identification of the whole incoming packet also has a
can/variation implementation. If the two
composites are the identity-minus-monodromy operators on the ambient and
packet modules, and can covers the packet modulo the kernel of variation, the
ambient monodromy image is exactly the variation image. Packet-defect coverage
modulo that kernel and full packet-defect surjectivity are stronger; in finite
dimension, absence of packet fixed vectors implies full surjectivity. The
`FixedReceiverCertificate` attaches these maps, the target crossed-coordinate
equation, and the three row restrictions to one externally supplied
fixed-phase receiver. If the crossed normal vanishes, its projected variation
vanishes on the whole incoming image. This avoids both a manufactured target
operator and an image/base-change isomorphism; identifying the supplied
certificate with the intended geometric packet remains part of the input.
The source-facing `FixedReceiverWindowCertificate` compresses the target
components to one window map: it asks for the single square
`T_j * v_i = j_+ * (B,D)` and one target window-row restriction. Its scaled
variant permits one common scalar on the source and target window rows; no
unit hypothesis is needed for the forward zero conclusion.

`PaperInterface.lean` is the reviewer-facing aggregate.  The companion
`Verification/AxiomAudit.lean` prints the axioms of every exported terminal in
this comparison package.
