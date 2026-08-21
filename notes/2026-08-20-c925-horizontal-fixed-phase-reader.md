# Module 62. A horizontal fixed-phase reader in Lean

**Packet part:** Module 62.  The paper-local package is
`papers/cubic-stabilization-irrationality/lean/`.

**Status:** the crossed-edge algebra, intrinsic projected variation,
monodromy-image functoriality, and the reduced zero-transport theorem are
kernel checked.  A semilinear trait specialization transports variation
without assuming tensor/image base change, and an actual-receiver
can/variation certificate now merges incoming realization with coverage
without imposing the split model's involutivity.  The schober source supplies
the no-boundary-quotient input after specialization, but no source identifies
its local can/variation quiver and target square with the actual fixed-phase
QDM/Malgrange receiver.  No unconditional `m = 2` or all-`m` conclusion
follows.

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

`Comparison.SelectedLocalSystemReader.DiagramIdentification` now isolates the
two vertical identifications that remain after that selection: the trait-side
selected loops and row must equal the crossed-coordinate model diagram, and
the fibre-side selected loops and row must equal the externally supplied
actual diagram.  Given those two equalities and ambient surjectivity,
`SelectedLocalSystemReader.Reader.ofMarkedLocalSystemOfSurjective` constructs
the complete trait-horizontal reader.  With a non-surjective comparison,
`ofMarkedLocalSystemWithImageSpan` consumes the weaker incoming-image coverage
clause directly.  This is a packaging reduction, not a proof of either QDM
identification.

Literal equality is not load-bearing.  A geometric comparison usually lands
in a chosen gauge rather than the model's definitional frame.
`MarkedMonodromyDiagram.DiagramEquivalence` therefore records one linear
equivalence that conjugates both selected monodromies and transports the marked
row.  `SelectedLocalSystemReader.selectedGaugeMorphism` transports the global
semilinear map through a model gauge and an actual gauge; ambient surjectivity
survives.  The two `GaugeReader` constructors consume either image-span
coverage or ambient surjectivity.  Thus the vertical theorems may be stated as
gauge equivalences, which matches the natural output shape of QDM comparison.

### 62.5A Gate decomposition

The remaining identification theorem has three independently falsifiable
parts.

1. **Crossed edge to model monodromies.**  Modules 60--61 already supply the
   enumerated completed-window pilot `(B,D)`, its special Fourier-row crossed
   defect, and a lawful decategorified \(K_0\) coefficient trait with
   uniformizer `1-q_coeff` after choosing an adapted splitting.  The crossed
   normal is the corresponding product
   `A_(1,q_coeff)=(1-q_coeff)^|J|`.  It remains to construct the trait nearby
   module and the two invertible monodromies, identify the incoming image with
   the moving source, prove the vector crossed-coordinate equation, and prove
   the source/common/moving rank-row coordinate laws.  These are exactly the
   fields of `ModelCrossedCoordinates.Coordinates`.  Lean now separates them as
   `IncomingCoordinates`, `TargetCoordinates`, and `RowCoordinates`;
   `Coordinates.ofParts` is the only assembly step.  Thus the known scalar row
   pilot cannot masquerade as the missing vector or incoming-image witnesses.
   One sufficient construction now eliminates those separate fields.  Put
   `i=(B,D):M0 -> C1 x M1`.  If `i` has an `R`-linear retraction,
   `SplitMovingTarget.coordinates` constructs the entire model on
   `M0 x (C1 x M1)`: the incoming operator is a shear, the target operator is
   the involution exchanging `M0` with its split image, and the direct-sum row
   supplies all three row equations.  Moreover,
   `SplitMovingTarget.ofFullMapEquivalence` constructs the retraction whenever
   the full upper-triangular map is an integral linear equivalence.  The exact
   finite certificate now closes that source subgoal for all thirty-two
   directed pilot transitions: the residue matrix of `(B,D)` has full column
   rank, with a recorded nonzero maximal minor.  That minor is a unit over
   `C[[1-q_coeff]]` and gives the required retraction.  This lands the
   **algebraic existence** part for every completed pilot, but not yet the
   source-faithful identification.  The constructed target monodromy is an
   involution.  By
   `ScaledSpecialization.targetSquare_eq_on_incomingImage`, any horizontal
   comparison with incoming-image coverage would force the actual target
   monodromy to square to the identity on the actual incoming packet.  General
   Malgrange/QDM monodromy is not known to satisfy that condition.  Gate 1 must
   therefore either prove this sectorial involutivity or construct the two
   selected source monodromies directly.  Generic invertibility and
   torsion-freeness alone would not have supplied even the retraction:
   multiplication by a DVR uniformizer is the counterexample.
   If a whole based-loop
   representation is used, this gate also includes its marked gauge
   equivalence to the coordinate model.
   There is now a source-faithful conditional alternative.
   `CanVariationCoordinates.FixedReceiverCertificate` is parameterized by an
   externally supplied directed fixed-phase receiver, so it cannot replace
   that receiver's two monodromies or row.  It accepts an incoming packet
   monodromy, signed can/variation factorizations, the vector identity

   \[
      T_jv_i(x)=j_M(Dx)+j_C(Bx),
   \]

   and the three row restrictions.  Its resulting coordinate model uses the
   supplied (T_i,T_j) and therefore imposes no involutivity.  The displayed
   vector identity, not the scalar crossed-row law, is the exact remaining
   wall-map/Malgrange identification.  Sources using (T-1) instead of
   (1-T) must carry the corresponding sign in (v_i) and the row laws.
2. **Model diagram to actual fixed-phase diagram.**  It remains to choose the
   actual based loops and primitive projector, construct one horizontal map,
   prove conjugacy for both selected monodromies, transport the rank/Gamma row,
   and certify the same occurrence, QDM path, phase, character, and direction.
   The minimal output is the two-loop marked semilinear comparison consumed by
   `TraitHorizontalReader`.  A stronger global output consists of trait and
   fibre `Representation`s, a loop-group homomorphism, an endpoint
   `LoopAssignment`, one `SemilinearHorizontal`, and the selected
   representation-to-actual marked gauge.  Together with Gate 1's model gauge,
   these are consumed by `SelectedLocalSystemReader.GaugeReader`; literal
   equality is unnecessary.  The exact `GaugeReader` row laws are covector equations:
   `r_model ∘ g_model = r_selected` and
   `r_actual ∘ g_actual = r_selected`.  Exact normalization is not needed for
   the vanishing consumer: `TraitHorizontalReader.ScaledReader` accepts one
   `ScaledSemilinearMorphism` with
   `r_actual F = c specialize(r_model)` for an arbitrary target scalar `c`.
   The global selected-loop route now has the same flexibility.  If the model
   and actual operator-diagram equivalences have row factors `alpha` and
   `beta`, respectively,
   `selectedRowScaledGaugeMorphism` needs only a supplied factor `c` satisfying
   `beta = c specialize(alpha)`; it never divides by `alpha`.  For genuine
   row-normalization gauges, `alpha` and `beta` are units and the compatibility
   forces `c` to be a unit.  The algebraic forward vanishing theorem remains
   valid for arbitrary row factors, including zero; those factors are not
   promoted to invertible marked gauges.
3. **Incoming-image coverage at resonance.**  It is enough either to prove the
   specialized ambient comparison surjective or directly to prove that its
   induced incoming image spans the actual packet.  Exact range base change,
   a flat cokernel/direct-summand image theorem, or strict nearby-cycle
   specialization are stronger possible providers.  Generic horizontality
   alone is excluded by the `sR` countermodel.
   The can/variation route is now smaller still.  If the actual maps satisfy
   `variation * can = 1-T_V` and `can * variation = 1-T_P`, the exact coverage
   condition is only that can cover the packet modulo the variation kernel:

   \[
      \forall p\;\exists x,\qquad v(c(x))=v(p),
      \quad\text{equivalently}\quad P=\operatorname{im}(c)+\ker(v).
   \]

   `canCoversVariation_iff_ambientRange_eq_variationRange` proves this is
   necessary and sufficient for `im(1-T_V)=im(variation)`.  Packet-defect
   coverage modulo `ker(v)`, namely `v((1-T_P)P)=v(P)`, is stronger; full
   surjectivity of `1-T_P` is stronger again.  In finite dimension, absence of
   packet fixed vectors implies the latter.  Independently proving that the
   actual can map is onto is another direct provider, formalized by
   `canCoversVariation_of_can_surjective`; in a perverse-sheaf construction
   this is the exact intermediate-extension clause to target.  A non-one deck
   or formal character is not enough by itself, while the exact can-coverage
   condition can be proved without identifying every packet eigenvalue.  The
   remaining geometric input is the actual occurrence-level can/variation
   diagram with this exact can-coverage certificate.

   The source side of that provider is already visible at resonance.  In the
   first paragraph of the proof of Špenko--Van den Bergh's Corollary 13.2,
   Lemma 13.3 gives the window-sum identity and the authors state that it
   remains true after specialization; this proves that \(S^c(h)\) has no
   perverse quotient supported on the discriminant.  The nonresonance
   hypothesis enters only in the later no-subobject half.  On a transverse
   smooth wall, the standard local quiver dictionary identifies absence of a
   wall-supported quotient with surjectivity of can.  Hence Gate 3 no longer
   needs a packet-spectrum argument at \(h=1\).  It needs the occurrence-level
   identification of this schober local quiver, including its can/variation
   signs, with the actual fixed-phase QDM packet.

On a specialized crossed edge with zero normal,
`FixedReceiverCertificate.projectedVariation_eq_zero` consumes these data
directly and kills the projected variation of the externally supplied
receiver on its whole incoming image.  In that same-receiver form the
incoming part of Gate 1 and all of Gate 3 are one theorem.  It does not
construct the specialized edge, the actual packet certificate, the target
transport identity, or the three row restrictions.  If those data are first
built on a trait model, Gate 2 remains the semilinear model-to-actual
comparison above.

The source-facing form is
`FixedReceiverWindowCertificate`.  Let (F=(B,D)) denote the full moving
column of the completed-window comparison and let
(j_+:C_1\oplus M_1\to V) be its realization in the actual receiver.  The
three target component equations reduce to one square

\[
                         T_jv_i=j_+F.                         \tag{62.12}
\]

One target window-row equation then supplies both target row restrictions.
`ScaledFixedReceiverWindowCertificate` allows the source and target window
row equations to carry the same arbitrary scalar.  The zero theorem does not
divide by it.  A genuine Gamma/rank identification still requires its
nonzero, and in a reversible gauge unit, normalization; a zero-scale witness
does not count as source progress.
Spenko--Van den Bergh's Proposition 12.6 and the Module 59 certificate compute
(F) exactly, but they do not prove (62.12): their (F) is a decategorified
window/groupoid map, while the right-hand side of (62.12) lives in the actual
fixed-phase Malgrange/QDM receiver.  Their Theorem 6.4 and Proposition 13.4 do
identify this transition representation with analytic GKZ continuation at a
nonresonant parameter in Proposition 13.4's real negative cone
(\(\alpha\in\sum_i\mathbf R_{<0}a_i\)); Theorem 6.4's monodromy formula itself
only requires \(\operatorname{Re}\alpha\in\mathbf R_{<0}A\).  Under

\[
                 \widehat M_\chi\longmapsto[\overline P_{-\iota\chi}]_h,
\]

the two chamber-groupoid maps agree.  Thus the generic selected-loop
comparison is source-provided along that sector, not over the whole punctured
trait.  The same paper explicitly excludes the resonant value (h=1) from that
comparison, and it supplies neither the actual can/variation and target-square
realization, the fixed-phase QDM/Gamma row, nor the closed-fibre packet.  The
precise source extension is therefore those actual packet maps together with
the resonant trait-to-fibre and QDM/Gamma realization of (62.12), not another
Stokes-matrix calculation.  See Špenko--Van den
Bergh, *Perverse schobers and GKZ systems* (2020), arXiv:2007.04924,
Theorem 6.4 and Proposition 13.4.

| datum | supplied now | exact remaining source subgoal |
|---|---|---|
| completed-window map (F=(B,D)) | Proposition 12.6 plus the thirty-two finite residue certificates | none at the decategorified pilot level |
| generic selected loop | Theorem 6.4 gives the transition formula for nonresonant \(\alpha\) with \(\operatorname{Re}\alpha\in\mathbf R_{<0}A\); Proposition 13.4 identifies the two representations for nonresonant \(\alpha\in\sum_i\mathbf R_{<0}a_i\) | extend the sectorial comparison over the named punctured resonance trait and identify its closed fibre with the actual fixed-phase QDM receiver |
| incoming packet | abstract can/variation coverage theorem | identify the occurrence packet (P_i), (c_i,v_i), and the signed identities (v_ic_i=1-T_i), (c_iv_i=1-T_{P_i}) |
| packet coverage | exact can-coverage equivalence; the first half of the proof of Corollary 13.2 gives the no-boundary-quotient input after specialization | identify the transverse local schober quiver and its can map with the actual occurrence packet; no-boundary-quotient then gives surjective can and closes coverage |
| target vector reading | source-facing window constructor | prove the single common-receiver square (62.12) |
| marked row | Fourier-row pilot on the window side | prove the source and target window restrictions of the actual fixed-phase Gamma/rank row |
| trait-to-fibre passage | semilinear and gauge adapters | needed only if the certificate is constructed first on the trait model rather than directly on the specialized actual receiver |

Gate 1 has a new cheap rejection test.  In any lawful coordinate model,
`Coordinates.sourceToIncomingImage_eq_zero_of_crossedMap_eq_zero_of_movingMap_eq_zero`
proves

\[
  \ker(B,D)\subseteq\ker(\text{source-to-incoming-image}).
\]

Indeed the target monodromy sends such a realized source vector to zero, so
invertibility kills it.  If the source-to-image map is injective, `(B,D)` must
be jointly injective.  Thus the scalar Fourier-row law cannot by itself create
the model; the source comparison must supply this vector-level kernel control.
The pilot has a natural sufficient route: if the full upper-triangular window
map `(c,m) ↦ (A c+B m,D m)` is injective, then
`CrossedEdge.crossedMap_movingMap_jointly_injective_of_fullMap_injective`
supplies the joint-kernel condition.  Over a domain, generic invertibility is
a likely proof of injectivity only when the source lattice is torsion-free and
the generic map is the localization of this same integral full map.  The trait
lattice and specialization still have to be identified with the model rather
than inferred from the scalar row formula.

The incoming-image coverage clause cannot be omitted.  Over `R = C[[s]]`, take
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
- `Comparison.FixedPhaseReader.CrossedEdge.crossedMap_movingMap_jointly_injective_of_fullMap_injective`;
- `Comparison.LawfulReaderIndex.Endpoint.compatibility`;
- `Comparison.MonodromyImage.imageMap_comp`;
- `Comparison.ProjectedVariation.projectedVariation_natural`;
- `Comparison.ProjectedVariation.projectedVariation_eq_zero_of_surjective`;
- `Comparison.ModelCrossedCoordinates.Coordinates.sourceValue_eq_zero_of_crossedMap_eq_zero_of_movingMap_eq_zero`;
- `Comparison.ModelCrossedCoordinates.Coordinates.ofParts`;
- `Comparison.ModelCrossedCoordinates.Coordinates.sourceToIncomingImage_eq_zero_of_crossedMap_eq_zero_of_movingMap_eq_zero`;
- `Comparison.ModelCrossedCoordinates.Coordinates.crossedMap_movingMap_jointly_injective`;
- `Comparison.SplitCrossedCoordinates.SplitMovingTarget.ofFullMapEquivalence`;
- `Comparison.SplitCrossedCoordinates.SplitMovingTarget.coordinates`;
- `Comparison.SplitCrossedCoordinates.SplitMovingTarget.targetMonodromy_involutive`;
- `Comparison.CanVariationCoverage.Diagram.ambientRange_eq_variationRange`;
- `Comparison.CanVariationCoverage.Diagram.canCoversVariation_iff_ambientRange_eq_variationRange`;
- `Comparison.CanVariationCoverage.Diagram.canCoversVariation_of_can_surjective`;
- `Comparison.CanVariationCoverage.Diagram.variationToAmbientRangeOfCanCoverage_surjective`;
- `Comparison.CanVariationCoverage.Diagram.ambientRange_eq_variationRange_of_packetDefectBijective`;
- `Comparison.CanVariationCoverage.Diagram.variationToAmbientRange_surjective`;
- `Comparison.CanVariationCoverage.Diagram.packetDefect_injective_of_fixedVectors_eq_zero`;
- `Comparison.CanVariationCoverage.Diagram.ambientRange_eq_variationRange_of_fixedVectors_eq_zero`;
- `Comparison.CanVariationCoordinates.FixedReceiverCertificate.toCoordinates`;
- `Comparison.CanVariationCoordinates.FixedReceiverCertificate.projectedVariation_eq_zero`;
- `Comparison.CanVariationCoordinates.FixedReceiverWindowCertificate.toFixedReceiverCertificate`;
- `Comparison.CanVariationCoordinates.FixedReceiverWindowCertificate.projectedVariation_eq_zero`;
- `Comparison.CanVariationCoordinates.ScaledFixedReceiverWindowCertificate.projectedVariation_eq_zero`;
- `Comparison.SemilinearVariation.Specialization.projectedVariation_specializes`;
- `Comparison.SemilinearVariation.Specialization.incomingImageSpan_eq_top_of_surjective`;
- `Comparison.SemilinearVariation.Specialization.projectedVariation_eq_zero_of_normalFactor`;
- `Comparison.SemilinearVariation.ScaledSpecialization.projectedVariation_specializes`;
- `Comparison.SemilinearVariation.ScaledSpecialization.projectedVariation_eq_zero_of_normalFactor`;
- `Comparison.SemilinearVariation.ScaledSpecialization.targetSquare_eq_on_incomingImage`;
- `Comparison.MarkedMonodromyDiagram.ScaledSemilinearMorphism.transportRowScaled`;
- `Comparison.MarkedMonodromyDiagram.ScaledSemilinearMorphism.transportRowScaled_map_surjective`;
- `Comparison.MarkedMonodromyDiagram.SemilinearMorphism.projectedVariation_specializes`;
- `Comparison.MarkedMonodromyDiagram.SemilinearMorphism.transport_map_surjective`;
- `Comparison.MarkedLocalSystem.SemilinearHorizontal.projectedVariation_specializes`;
- `Comparison.MarkedLocalSystem.SemilinearHorizontal.projectedVariation_eq_zero_of_normalFactor`;
- `Comparison.SelectedLocalSystemReader.DiagramIdentification.selectedMorphism_map`;
- `Comparison.SelectedLocalSystemReader.selectedGaugeMorphism_map_surjective`;
- `Comparison.DescentPacket.fixed_of_stable_singleton`;
- `Comparison.DescentPacket.unaryPacketEquivariantEquiv`;
- `Comparison.DescentPacket.regular_not_equivariantly_equivalent_fixedThree`;
- `Comparison.HorizontalReader.Reader.modelVariation_eq_zero`;
- `Comparison.HorizontalReader.Reader.actualVariation_eq_zero`;
- `Comparison.TraitHorizontalReader.Reader.actualVariation_eq_zero`;
- `Comparison.TraitHorizontalReader.ScaledReader.actualVariation_eq_zero`;
- `Comparison.SelectedLocalSystemReader.ScaledGaugeReader.ofMarkedLocalSystemOfSurjective`.

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

The Gate 3 closeout gives a third gain.  Incoming-image coverage is equivalent
to the elementary quotient law

\[
                     P=\operatorname{im}(c)+\ker(v).
\]

It therefore needs neither exact image base change nor the spectrum of
\(T_P\).  Moreover, the no-boundary-quotient half of Špenko--Van den Bergh's
Corollary 13.2 proof survives specialization and is precisely the source-side
condition that makes can onto in the transverse local quiver.  Gate 3 is now
part of the same actual-quiver identification already required by Gates 1 and
2, rather than an independent resonance theorem.

The main hostile test is the DVR example above.  It prevents a formal
monodromy comparison from being promoted to the resonant image packet
without explicit incoming-image coverage.  A second hostile test is the closed-fibre
component reader: its consumed-row equation is conclusion-equivalent and
must not be counted as construction progress.

The resulting TT target is one local comparison theorem, not three unrelated
ones: identify the specialized schober can/variation quiver with the actual
fixed-phase packet, prove the window square \(T_jv_i=j_+F\), and transport the
Gamma/rank row with one nonzero common factor.  The first identification then
imports can-surjectivity, while the second and third give the projected-row
defect formula.  No separate packet-eigenvalue calculation is consumed.

## Mystery ledger

| question | state | exact evidence gap |
|---|---|---|
| Does the lawful coefficient trait produce the model projected-variation reading? | split algebraic existence settled; exact actual-receiver provider isolated | Proposition 59.3 and `SplitMovingTarget.coordinates` construct an involutive pilot model; the non-involutive alternative is `FixedReceiverCertificate`, whose load-bearing source theorem is `T_j v_i=j_M D+j_C B` plus the three row restrictions |
| Does one Fourier--Laplace/QDM comparison intertwine the two selected monodromies and the rank row? | open | construct the occurrence-indexed scaled two-loop semilinear comparison, or the stronger loop representations, loop assignment, global horizontal morphism, and row-scaled gauges satisfying `beta = c specialize(alpha)` |
| Does the trait comparison span the actual resonant incoming image? | source-side no-quotient input exists; actual-reader adapter open | Corollary 13.2's proof supplies no boundary quotient after specialization, and Lean turns surjective can into coverage; identify the transverse schober can/variation quiver, signs, and packet with the actual QDM occurrence |
| Does a unary codimension-two correction have fixed \(\mu_3\)-descent? | settled: no formal implication | a unary outer packet preserves a nontrivial inner center action; fixedness requires a common equivariant occurrence reader |
| Is a tensor/image base-change isomorphism necessary? | settled: no for vanishing transport | `SemilinearVariation.projectedVariation_eq_zero_of_normalFactor` uses only semilinear naturality and image-span coverage |
| Are independent can/variation packet maps still needed? | settled: no over one fixed field | `ProjectedVariation.projectedVariation_natural` derives them from the marked horizontal comparison (F_{\mathrm{horizontal}}) |
| Is bijectivity of (F_{\mathrm{horizontal}}) required? | settled: no | the fixed-field forward route uses image-map surjectivity; the trait route uses span coverage; reverse transport needs neither surjectivity nor injectivity |
| Is literal equality of model and actual frames required? | settled: no | `DiagramEquivalence` handles exact rows; `OperatorDiagramEquivalenceWithRowFactor` and `selectedRowScaledGaugeMorphism` handle compatible scalar row factors without division; ambient surjectivity survives both transports |
