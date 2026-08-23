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
materializing either stabilizer.  When a local calculation gives exact orbit
periods, the module derives those loop-power witnesses from the inequality of
the source and target periods.  For a cyclic translation it also proves the
period formula \(n/\gcd(n,a)\) from divisibility.  It does not construct the
loop action or its geometric comparison.

The loop-stabilizer path module removes the need to assemble one global
stable-disjoint-union ledger.  One vertex-indexed family supplies the packet
and actual loop action at each path vertex.  A forward edge is an equivariant
equivalence from the blowup packet to the disjoint union of its ambient and
correction packets; it assumes only that the correction contains no point
with the selected exact period.  Lean proves an iff for this forward
decomposition.  In reverse, the inverse ambient inclusion transports support
without any correction-period hypothesis.  A directional finite typed path
composes these two rules.  Adjacent occurrences share their packet and action
by construction.  Geometry must still construct the marked finite-etale packets,
the edgewise equivariant comparisons, the common actual-loop actions, and the
correction-period exclusions.

The same module treats a nonsplit outer packet without imposing commuting
inner and outer actions.  If the projected outer point has period `t` and the
actual return map after `t` loop steps has period `h` on the chosen fibre
point, Lean proves that the total point has period `t * h`.  Only the
power-equivariance of the outer label and the fixedness law for the return map
are assumed.  This theorem does not construct the label, return map, or their
geometric realization.

An even looser one-way interface consumes only injective equivariant maps
between consecutive packets.  It transports the chosen orbit without asking
for surjectivity, a full correction ledger, or an enumeration of unrelated
target points.  This is the appropriate consumer when geometry can prove
directly that the carried marked orbit lands in the ambient factor.  Reverse
traversal then needs its own directed injection; Lean does not infer it from a
forward injection.

The occurrence-loop certificate module makes the finite adapter more
defensive.  Its total carrier is a dependent sum of occurrence tags and their
label types; the loop acts fibrewise, so neither it nor any natural power can
silently mix occurrences.  A legal relabelling must conjugate the displayed
permutations.  A finite certificate stores one witness power per target point
and checks fixedness directly, rather than trusting a claimed period.  A
separate `Realizes` equation identifies the computed permutation with the
actual group generator.  This still does not construct that generator, prove
that the tagged enumeration is exhaustive, or identify it with the geometric
marked packet.  Fibrewise occurrence preservation is imposed by the type; it
is not inferred from QDM canonicity.

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

`Comparison.StableRationalityConsequences` gives two global consumers that do
not use a weak-factorization path. One transports a stable birational
invariant; the other pulls a projective-space witness back through a supplied
birational relation and then applies a separately supplied cancellation map
for the projective factor. The module packages upward closure of rational
stabilization indices and proves its consequences. Its finite countermodels
show that a nonzero multiplicity does not formally justify cancellation and
that an abstract signed class need not have a positive-monoid representative.
It does not instantiate a diagonal decomposition, a theta class, or any
geometric birational relation.

`Comparison.R10AlbaneseParity` checks the finite `F_2` computation for the
reduced `R10` Albanese graph in Engel--de Gaay Fortman--Schreieder,
arXiv:2507.15704v3, Proposition 7.6. Ten explicit row-span masks factor the
colour-profile matrix through the `160 × 160` admissibility matrix; native
evaluation checks all 1,600 coefficients, and a symbolic matrix argument
deduces that every admissible vector has zero colour profile. The module does
not formalize the geometric reduction to this graph or the subsequent theta-
class and stable-rationality deductions.

`Comparison.ThreefoldKummerCompatibility` records the exact finite boundary
of a proposed dimension-three correction exclusion.  A six-dimensional
linear model has the even-cohomology grading spectrum and perfect pairing of
a Picard-rank-two threefold while its branch compression has the marked
discriminant `4/9`; Lean also checks that this model violates the strict
logarithmic homogeneity equation.  Separately, multiplication by `x + e` in
`Q[x,e]/(x^3,e^2)` is self-adjoint and has Jordan form `J_4 ⊕ J_2`.  These
are compatibility and falsifier calculations, not a construction or
classification of a threefold quantum connection.  A separate abstract lemma
shows that a residue-graded carrier containing the full residue-zero class is
preserved by a grading operator which preserves that class and is scalar on
the other two.  For the strict cubic dual-number model, the module also checks
an explicit separating basis, the first Sylvester gauge, the vanishing return
entry, and the resulting zero modified-residue discriminant.  A two-parameter
rank-one calculation proves that the same return polynomial vanishes whenever
the nilpotent cube is self-adjoint for the hyperbolic unit--point pairing.
The uniform cyclic lemma proves that `n` equivalent residue pieces of total
dimension `2n` each have dimension two and exhaust any containing
two-dimensional zero-residue class.  These results do not construct the
residue projections, descend the marked block lattices, or identify a
geometric path loop with a pure native Euler coordinate.  In particular they
do not justify purity after localization by coefficient variables of nonzero
degree; the geometric adapter must retain an effective flat QDM frame.
For low-dimensional period arithmetic, Lean also proves that a constant outer
charge on two or four labels must vanish when a total point returns after
three steps.  The curve residue matrix
`[-1/2, c; 0, -1/2]` has zero discriminant for every rational `c`.  These are
finite statements; identifying the labels and residue with a curve or surface
correction factor remains external.  A kernel reduction records the candidate
dimensions before the strict equality case is treated.  At packet length `3`
they are `{1, 3}`; the displayed curve calculation excludes `1` only after
the curve-to-matrix adapter is supplied.  A second, explicitly post-strict
table at packet lengths `2, 3, 4, 5, 14` is respectively none, none, `{3}`,
none, and `{8, 9, 11, 13}`.  These are arithmetic regressions, not a proof of
the equality case or a construction of the occurrence-labelled carrier.
The module also kernel-checks the final characteristic-zero scalar
contradiction obtained from the three weight equations of the degree-one-unit
countermodel.  It does not derive those equations from flatness or the divisor
equation; that matrix-to-geometry reduction remains external.

`Comparison.KummerDivisorGenerator` isolates three finite algebra steps for a
genuine cubic Kummer divisor direction.  A commuting derivative whose kernel
is fixed by an order-three action preserves the action's fixed-point
fingerprint.  Compression by a projector commuting with a multiplication
operator leaves the trace of its commutator equal to zero.  Finally, three
distinct divisor eigenvalues generate all functions on the three geometric
points by the Vandermonde isomorphism; a separate theorem proves that a moved
point in an order-three orbit has three distinct iterates.  The module also
defines the exact cubic marked-point subtype with rank two, nonzero nilpotent,
and discriminant `4/9`.  These statements do not construct the marked factors,
the scalar conjugacy orbit, or the logarithmic divisor direction, and they do
not remove a regular base-gauge term introduced by a parameter-dependent
spectral frame.
The same module gives an exact rational countermodel to a stronger inference:
a parabolic Poincare isometry fixes the unit and both displayed divisor
vectors, preserves the cubic dual-number Jordan form, and yields modified-
residue discriminant `4/9`.  The kernel checks the isometry, fixed columns,
change of basis, separation of the displayed `2+4` first recurrence, its
selected second-recurrence entry, and the resulting discriminant.  It does not
construct a formal gauge, a flat connection, or a Frobenius family.  Excluding
this calibration requires an effective large-radius or equivalent geometric
hypothesis not present in the finite matrix model.

`Comparison.BinaryCubicJordanStrata` checks the classical rank-six case
without selecting the special dual-cubic order.  For a binary intersection
cubic and one marked divisor, five explicit invertible chain bases give the
five possible nilpotent Jordan types.  The fully degenerate type has singular
divisor pairing for every divisor and is therefore incompatible with hard
Lefschetz.  The kernel checks only this operator classification.  It does not
construct the classical specialization of a marked carrier, identify the
Euler and transported Kummer divisor lines, or classify integral orders over
a degeneration trait.

`Comparison.BinaryCubicOrderResidues` checks the next finite layer for the two
complex local Gorenstein algebra types.  Explicit rank-two projectors, left
inverses, normalized block-off-diagonal gauges, and recurrence coefficients
show that the dual-number order has modified-residue discriminant zero.  For
the distinct-root order the reduced grading does not preserve the leading
nilpotent line, so the elementary modification used by the marker is not a
regular lattice operation.  Lean therefore excludes the exact `4/9` marker
for these two normalized reductions.  It does not prove that a geometric
carrier descends to a regular unital order or that its occurrence comparison
selects either normalization.

`Comparison.RankSixRecurrenceCertificate` checks the strict cyclic companion
recurrence without trusting a precomputed first gauge.  The tracked Rust
program `scripts/rank_six_recurrence_cert.rs` solves the rational Sylvester
system with zero selected and complementary diagonal blocks and emits both
`certificates/rank-six-recurrence.json` and the generated Lean matrix data.
Lean independently checks the projector, selected Jordan block, gauge
normalization, full gauge-derivative recurrence, and discriminants `0` and
`4`.  It also proves that a nonzero hyperbolic-self-adjoint square-zero
endpoint map has exactly the lower or upper orientation.  Its `Calibration`
interface requires simultaneous intertwining of multiplication, projector,
first gauge, grading, selected basis, and left inverse; Lean proves that such
a calibration preserves both selected recurrence coefficients and the
modified-residue discriminant.  Run

    nix run .#verify-rank-six-recurrence

from this directory to regenerate both outputs in a temporary directory and
compare them byte for byte.  The certificate does not prove that an actual
marked occurrence admits this calibration; a generic or unordered block
isomorphism is deliberately insufficient.  The replay also checks the three
tracked artifact digests in `certificates/rank-six-recurrence.sha256` before
executing the solver.

`Comparison.MarkedReesShadowCertificate` checks the two independent
ambiguity layers left by the generic marked packet.  The exact Rust program
`scripts/marked_rees_shadow_cert.rs` emits the full Laurent `6 x 6`
basis-change matrix, its three extracted `2 x 2` blocks, their claimed
relative coweight, and the first parabolic Rees jet.  Lean verifies the block
extraction and off-block vanishing from the full matrix, recomputes the block
elementary divisors as `(-1,0)`, `(0,1)`, and
`(0,0)`, recovers the relative coweight `(-1,0,0,0,0,1)`, and
checks self-duality.  It also verifies that the zero-coweight shear jet is
nonzero, tangent to the Poincare isometry group, fixes the first three
columns, has the required filtration weight, and is the linear term of the
already checked parabolic shear.  Thus a generic packet can forget a nonzero
coweight, while fixed coweight can still forget the jet which changes the
displayed residue from `0` to `4/9`.  Run

    nix run .#verify-marked-rees-shadow

to check the artifact digests, compile the exact solver, and compare its JSON
and generated Lean output byte for byte.  `ReesPortChart` is only the finite
chart consumed after geometric identification.  It does not supply the
Kummer trait, actual loop, native QDM lattice, or Iritani occurrence map, and
therefore does not close the source adapter.

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
