# Module 62. A horizontal fixed-phase reader in Lean

**Packet part:** Module 62.  The paper-local package is
`papers/cubic-stabilization-irrationality/lean/`.

**Status:** the crossed-edge algebra, intrinsic projected variation,
monodromy-image functoriality, and the reduced zero-transport theorem are
kernel checked.  A semilinear trait specialization now transports variation
without assuming tensor/image base change.  The actual fixed-phase
QDM/Malgrange comparison and its incoming-image coverage are not constructed.
No unconditional `m = 2` or all-`m` conclusion follows.

## 62.1 What the type pass rejected

The first component-reader interface exposed separate actual crossed and
moving maps and an equation

\[
  \rho_{\mathrm{consumed}}
     =\varepsilon\bigl(\rho_{\mathrm{source}}
       -\rho_{\mathrm{moving}}D-\rho_{\mathrm{common}}B\bigr).
\]

At the closed fibre, the remaining component squares, source surjectivity,
and the zero normal already make the parenthesized defect vanish.  The
displayed equation is therefore equivalent there to the desired vanishing
of the consumed row.  It is an honest conditional consumer, but it is not a
noncircular construction of the analytic reader.

The source carrier also required more than a phantom tag.  Lean tactics can
unfold a private reducible wrapper, so that design was rejected.  The landed
encoding is dependent: a provenance witness is indexed by the actual common
output.  Marking a value as moving-produced requires a moving source whose
crossed map equals that same value.  Native and moving provenance may both
exist precisely when the two component images genuinely meet; this is a
lawful overlap, not laundering.  The type still cannot certify the
provenance of a trusted geometric implementation.

## 62.2 Intrinsic projected variation

For a module (V) with two monodromies (T_i,T_j), put

\[
  \phi_i=\operatorname{im}(1-T_i),\qquad
  \phi_j=\operatorname{im}(1-T_j).
\]

The directed Malgrange linear-algebra block is the canonical map

\[
  C_{j\leftarrow i}:\phi_i\longrightarrow\phi_j,qquad
  x\longmapsto(1-T_j)x,
\]

and a marked row (r:V\to K) consumes

\[
  \delta_{j\leftarrow i}=r\circ C_{j\leftarrow i}.
\]

`Comparison.ProjectedVariation` constructs these maps without chosen image
splittings.  If `F : V → W` intertwines both monodromies and
`r_W F = r_V`, Lean proves

\[
  \delta_W\circ\operatorname{im}(F)=\delta_V.                 \tag{62.1}
\]

Consequently:

1. for `F : model → actual`, surjectivity of the induced incoming-image
   map makes model variation zero imply actual variation zero;
2. for `F : actual → model`, no surjectivity is needed.

Thus independent actual can/variation maps, image-packet equivalences, and a
projected-row comparison square are unnecessary over one fixed field.

## 62.3 The reduced reader theorem

`Comparison.HorizontalReader.Reader` packages exactly the forward form
used by the crossed-edge route:

- one algebraic crossed edge, with dependent provenance available for its
  common outputs;
- one intrinsic model nearby space with `T_i`, `T_j`, and `r`;
- source, target-common, and target-moving coordinate maps;
- a surjective specialized map from the algebraic moving block onto
  `im(1 - T_i)`;
- the vector equation identifying the `1 - T_j` action on a source vector
  with its source-minus-moving-minus-common crossed coordinates, together
  with the three row-coordinate equations;
- one externally supplied actual directed receiver;
- one `F : model → actual` intertwining both monodromies and the marked
  row, whose induced incoming-image map is surjective.

`Comparison.ModelCrossedCoordinates` proves from the vector equations,
rather than stores, the scalar model reading

\[
  \delta_{\mathrm{model}}(x)
    =\operatorname{sp}(\Delta_{\mathrm{crossed}}(x)).
\]

Since the crossed algebra proves

\[
  \Delta_{\mathrm{crossed}}=a\,r_{\mathrm{moving}},
\]

the closed equation `sp(a) = 0` kills the model variation.
Equation (62.1) then kills the actual directed projected variation.  The
proof does not postulate the actual projected variation or its vanishing.

This is strictly smaller than the component reader, but it remains
conditional.  The vector crossed-coordinate model, the fixed actual receiver,
and the marked horizontal comparison are the mathematical source data to
construct.

`Comparison.LawfulReaderIndex` moves the discrete compatibility conditions
upstream.  An endpoint stores the occurrence, coefficient label, and chamber
path together with the coefficient-trait equation.  Its QDM/deck path is
computed by the environment, while phase, character, and direction are shared
type parameters.  Two such endpoints therefore produce
`ReaderCompatibility` by reflexivity except for their stored coefficient
certificates.  This gives pairwise compatibility by construction relative to
the supplied environment and shared labels.  It does not certify that the
environment or the labels have their intended geometric meaning; a client can
still instantiate a different shared phase, character, or direction.

The model and actual receivers store both monodromies as linear equivalences,
not arbitrary endomorphisms.  The generic projected-variation lemmas remain
valid for endomorphisms, but a noninvertible fake monodromy can no longer
inhabit either geometric reader.

## 62.4 Trait specialization

Let \(\sigma:R\to k\) be the closed-fibre map.  A semilinear comparison
\(F:V_R\to V_k\) which intertwines both monodromies and satisfies
\(r_kF=\sigma r_R\) induces a semilinear map on the incoming images.  Lean
proves

\[
  \delta_k(F_{\rm im}x)=\sigma(\delta_R(x)).                 \tag{62.2}
\]

If the \(k\)-linear span of the induced image is the whole fibre packet, then
pointwise vanishing of the right side implies \(\delta_k=0\).  In particular,
if

\[
  \delta_R=a\,\lambda,
  \qquad \sigma(a)=0,
\]

the fibre variation vanishes.  Set-surjectivity is a convenient sufficient
condition and is equivalent to this coverage in the usual residue-field
case.  Span coverage is the ring-independent linear-generation hypothesis used
here.

This is weaker than an isomorphism

\[
  k\otimes_R\operatorname{im}(1-T_R)
    \simeq \operatorname{im}(1-T_k).
\]

`Comparison.RangeBaseChange` records that stronger certificate for
applications which require it; no theorem derives it from finite freeness.

`Comparison.TraitHorizontalReader` composes the two checked halves.  Its
externally supplied actual receiver carries the occurrence indices and packet
certificate.  Trait-level crossed coordinates derive the normal-factor
reading, and the marked semilinear comparison plus image-span coverage kills
the actual fibre variation.  Thus the exact Lean goal now matches the geometric
reader to be constructed; it does not store a closed-fibre consumed-row
equation.

## 62.5 Exact remaining identification theorem

For one actual `(1,1)` overlap, it is enough to construct:

1. the lawful Module 61 coefficient trait and its algebraic model nearby
   space;
2. the vector crossed-coordinate realization of the Spenko--Van den Bergh
   edge in the canonical monodromy-image model;
3. the externally fixed actual directed receiver, including its named based
   loop and packet certificate;
4. either a direct fibre comparison whose induced incoming-image map is
   surjective, or a trait-level marked semilinear comparison whose induced
   image spans the fibre packet.  In either form the map must intertwine both
   monodromies and preserve the rank/Gamma row.  An exact range/coimage
   base-change certificate is a stronger sufficient implementation of the
   trait alternative.

The two operator equations admit a coherent repackaging, but that does not
reduce the single-edge mathematical input: the former specialization record
already used one common semilinear map and stored exactly these two squares.
The stronger optional source object
`Comparison.MarkedLocalSystem.Representation` stores a representation of the
whole based-loop group and its marked row, while
`Comparison.MarkedLocalSystem.SemilinearHorizontal` stores one natural
semilinear morphism along a named homomorphism from the trait loop group to the
fibre loop group.  Selecting the incoming and target loop classes produces the
endpoint-indexed two-loop comparison consumed by item 4, with any ramified
loop reindexing applied automatically.  This does not construct the QDM
realization, but it amortizes one global naturality theorem across every loop
pair selected from that representation.  `LoopAssignment.ofQdmPath` types the
remaining endpoint-path-to-loop interpretation once and prevents per-edge loop
choice relative to that supplied interpretation; constructing the geometric
interpretation remains external.

Some form of item 4 cannot be omitted.  Over `R = C[[s]]`, take
`T = (1 - s) id_R`.  Then

\[
  \operatorname{im}(1-T)=sR,
  \qquad (sR)\otimes_R\mathbf C\cong\mathbf C,
\]

but after specialization `T_bar = 1` and
`im(1 - T_bar) = 0`.  Generic or integral horizontality alone
does not give the required closed packet.

The identification side has therefore shrunk again: it is no longer a full
Stokes matrix, two independent packet maps, an independently normalized
projected row, or necessarily a tensor/image base-change isomorphism.  It is
one model-side crossed-coordinate realization, one marked two-loop semilinear
comparison, and coverage of the actual incoming image.  A marked morphism of
the full based-loop representation is a stronger optional way to supply the
same comparison coherently for many edges.
If the ambient semilinear comparison is surjective, the coverage clause follows
formally from
`SemilinearVariation.Specialization.incomingImageSpan_eq_top_of_surjective`;
it remains an independent clause only for a non-surjective realization.
`TraitHorizontalReader.Reader.ofSurjective` constructs the complete reader directly
in this case.

## 62.6 Descent-packet specialization

The proposed Burnside-valued consumer is algebraically valid once a common
\(\mu_3\)-action and an invariant ambient/exceptional decomposition are proved,
with every admitted correction fixed in that action.  In the Burnside ring of
\(\mu_3\), the free orbit
\([\mu_3/e]\) differs from three fixed points: the fixed-point mark sends them
to (0) and (3), respectively.  Consequently corrections represented by
fixed \(\mu_3\)-sets cannot change the free-orbit coefficient.

The codimension count does not supply the needed fixedness.  A codimension-two
blowup has one *outer* exceptional copy, but a unary outer constructor preserves
whatever descent action the center packet already carries.  In symbols,

\[
  [\mathrm{pt}]\times[\mu_3/e]=[\mu_3/e],
\]

not three fixed points.  Moreover, the source cube-root deck action is tied to
the projective-bundle coefficient and is not presently defined on every
birational intermediate.  Without an equivariant splitting it can even mix a
chosen one-dimensional exceptional summand with ambient directions.  Thus the exact geometric input for this
specialization would be a common equivariant occurrence reader proving that
every threefold-center correction is fixed, not merely unary.  No audited
comparison theorem supplies that statement.

Lean checks both set-level implications.  In
`Comparison.DescentPacket.fixed_of_stable_singleton`, stability of a singleton
under the supplied action forces its point to be fixed.  In
`Comparison.DescentPacket.regular_not_equivariantly_equivalent_fixedThree`,
the left regular action of any nontrivial group is not equivariantly equivalent
to three fixed points.  The explicit
`Comparison.DescentPacket.unaryPacketEquivariantEquiv` proves the hostile
point directly: a one-copy outer packet is equivariantly equivalent to its
entire inner packet and therefore retains any nontrivial inner orbit.  None of
these theorems constructs the action or proves that the blowup splitting is
stable under it.

If such a reader is constructed, the Burnside marker could avoid the Gamma-row
normalization.  Without it, the proposal is the bare-deck-orbit route already
blocked by descent equivariance.  For all \(m\), a primitive packet species or
operadic height would additionally need a theorem that composites of lower
arity cannot create the source primitive class; this is the same operation
control isolated by the conditional top-Jordan-string route.

## 62.7 Verification boundary

The reviewer entry point is

`TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.PaperInterface`.

The main checked declarations are:

- `Comparison.CrossedEdgeComposition.compositeDefect_eq`;
- `Comparison.LawfulReaderIndex.Endpoint.compatibility`;
- `Comparison.MonodromyImage.imageMap_comp`;
- `Comparison.ProjectedVariation.projectedVariation_natural`;
- `Comparison.ProjectedVariation.projectedVariation_eq_zero_of_surjective`;
- `Comparison.SemilinearVariation.Specialization.projectedVariation_specializes`;
- `Comparison.SemilinearVariation.Specialization.incomingImageSpan_eq_top_of_surjective`;
- `Comparison.SemilinearVariation.Specialization.projectedVariation_eq_zero_of_normalFactor`;
- `Comparison.MarkedMonodromyDiagram.SemilinearMorphism.projectedVariation_specializes`;
- `Comparison.MarkedLocalSystem.SemilinearHorizontal.projectedVariation_specializes`;
- `Comparison.MarkedLocalSystem.SemilinearHorizontal.projectedVariation_eq_zero_of_normalFactor`;
- `Comparison.DescentPacket.fixed_of_stable_singleton`;
- `Comparison.DescentPacket.unaryPacketEquivariantEquiv`;
- `Comparison.DescentPacket.regular_not_equivariantly_equivalent_fixedThree`;
- `Comparison.HorizontalReader.Reader.modelVariation_eq_zero`;
- `Comparison.HorizontalReader.Reader.actualVariation_eq_zero`;
- `Comparison.TraitHorizontalReader.Reader.actualVariation_eq_zero`.

The package is independent of the (m=1) epilogue package and uses the
top-level namespace
`TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality`.
The guarded library and verification targets build together.  The guarded
axiom audit is green; the new projected-variation theorems use only
`propext`, `Classical.choice`, and `Quot.sound`, while
`DescentPacket.fixed_of_stable_singleton` is axiom-free.

## EJ and TT closeout

The cheap extra theorem is the asymmetric variance law: a reverse
actual-to-model comparison transports zero without surjectivity.  This may
be useful if Fourier--Laplace naturally supplies a conservative restriction
rather than a quotient map.

The upstream typing pass gives a second cheap gain: one horizontal morphism of
the full based-loop representation now generates every directed two-loop
comparison by selection.  If a deck transformation is represented by a loop
element, this supplies operator equivariance for that element.  It does not
supply the finite branch set, semilinear Galois action, row character, or an
invariant ambient/exceptional splitting needed by the descent-packet consumer.

The main hostile test is the DVR example above.  It prevents a formal
monodromy comparison from being promoted to the resonant image packet
without explicit incoming-image coverage.  A second hostile test is the closed-fibre
component reader: its consumed-row equation is conclusion-equivalent and
must not be counted as construction progress.

## Mystery ledger

| question | state | exact evidence gap |
|---|---|---|
| Does the lawful coefficient trait produce the model projected-variation reading? | open | identify the Module 60 crossed (B,D) edge with the canonical two-monodromy model over the named trait |
| Does one Fourier--Laplace/QDM comparison intertwine the two selected monodromies and the rank row? | open | construct the occurrence-indexed marked two-loop semilinear comparison; a `MarkedLocalSystem.SemilinearHorizontal` is a stronger uniform provider, not necessary for one edge |
| Does the trait comparison span the actual resonant incoming image? | open | construct the marked semilinear comparison and prove induced image-span coverage; the `sR` countermodel forbids inference from generic horizontality |
| Does a unary codimension-two correction have fixed \(\mu_3\)-descent? | settled: no formal implication | a unary outer packet preserves a nontrivial inner center action; fixedness requires a common equivariant occurrence reader |
| Is a tensor/image base-change isomorphism necessary? | settled: no for vanishing transport | `SemilinearVariation.projectedVariation_eq_zero_of_normalFactor` uses only semilinear naturality and image-span coverage |
| Are independent can/variation packet maps still needed? | settled: no over one fixed field | `ProjectedVariation.projectedVariation_natural` derives them from (F) |
| Is bijectivity of (F) required? | settled: no | the fixed-field forward route uses image-map surjectivity; the trait route uses span coverage; reverse transport needs neither surjectivity nor injectivity |
