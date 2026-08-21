# C925 pointed row calibration

## Status

The false flat-point uniqueness step can be removed from the algebraic
consumer.  Gu--Yu--Yu's adjoint Fourier formula gives the rank-row equation
generatorwise on the nonlocalized completed QDM source.  The paper-local Lean
modules `Comparison.PointedDirectSum` and
`Comparison.RowedRepresentationDecomposition` separate that equation from
point representatives and endpoint loop selection.

The latest endpoint consumer is asymmetric and bypasses adjacent vertex comparisons.
One finite marked representation over the endpoint ring contains a detected
cubic-product witness.  To contradict the rational endpoint, it is enough to
map that representation to the endpoint by one selected-loop intertwiner
satisfying one scalar row equation.  The scalar need not be a unit, and the
endpoint map need not be surjective or cover its primary kernel.  This is the
same-ring theorem
`Comparison.MarkedWitnessObstruction.Data.endpoint_detects_of_source_detects`.
The theorem `endpoint_detects_of_core_detects` is only a convenient wrapper:
faithfully flat scalar extension transports a witness from a rational core.

The older symmetric comparison remains useful when neither endpoint is known
to be empty.  The paper-local modules
`Comparison.PrimaryDetectionBaseChange` and
`Comparison.ParallelPrimaryQuotients` compare two endpoint Booleans through
one common core.  There primary coverage is load-bearing; ordinary
surjectivity supplies it only at an exponent where the source and endpoint
shifted operators have the required Fitting decompositions.

The consumer obligation is therefore exactly two-part: construct a detected
marked source witness, and construct one actual source-to-rational-endpoint
map whose selected action and rank row are the same objects used in the
endpoint calculation.  No target surjectivity, exceptional splitting,
adjacent overlap, or inverse map is consumed.  The no-Stokes source candidate
below changes the selected action from formal \(z\)-monodromy to an algebraic
deck action, so its source detection and endpoint contrast must be reproved;
they cannot be borrowed from the fixed-phase calculation.

A looser operation-level consumer is now the closure route.  It
does not ask for one map from a global core to projective space.  For each
blowup it retains the intrinsic idempotent projecting to all C924-marked QDM
atoms and a scalar row with arbitrary codomain.  If the actual QDM
decomposition is block-natural for that projector and factors the row through
the ambient projection, row-visible marked support is unchanged even when the
center contains the same atom.  Edgewise equalities of this intrinsic Boolean
telescope by weak factorization.  This is the multiple-source architecture
assembled downstream at the level of one occurrence-independent marker.

The statement-by-statement external-source audit is maintained in
`2026-08-21-c925-no-stokes-source-dossier.md`.  This note owns the consumer
and route ledger; the dossier owns what each paper actually supplies.

## Closure ledger

The landed marked-projector package is:

| gate | exact input | current evidence boundary |
|---|---|---|
| P0: intrinsic projector | On every chosen generic even QDM, the idempotent onto the union of rank-two blocks with (N\ne0) and (delta^\sharp\ne0). | C924 proves the block predicate is regular-isomorphism and scalar-extension invariant; KKPYY Theorem 4.1 gives the canonical spectral summands. |
| P1: projector square | For each Iritani blowup decomposition \(\Psi\), \(\Psi P_{\widetilde Y}=(P_Y\oplus P_Z)\Psi\), marking every ambient and correction occurrence satisfying the predicate. | Closed: the comparison intertwines quantum connections and KKPYY's spectral decomposition is canonical, so the isomorphism-invariant union of marked summands is preserved. |
| P2: algebraic row | The Gu--Yu--Yu covector \(\rho_Y=\epsilon_YM_Y\), allowed to take values in a larger Givental coefficient module but defined on the same QDM lattice as \(P_Y\). | Proposition 4.21 gives \(M_X\mathrm{FT}_X=\mathsf F_XM_W\).  No Gamma, formal monodromy, or sectorial interpretation is requested. |
| P3: row square | \(\rho_{\widetilde Y}=\rho_Y\operatorname{pr}_Y\Psi\) on that same domain. | Closed: Propositions 2.4, 2.8, and 4.21 give the adjoint row identity on the ordinary equivariant classes; Proposition 5.2 makes such classes an \(R\)-basis of the completed wall module, so finite \(R\)-linearity extends the square. |
| P4: endpoints | Source row detects the marked projector on (X\times\mathbf P^m); the projector is zero on (mathbf P^{m+3}). | The C924 separated cubic block has (H^0)-row ((0,-7r^2)\ne0); projective space is generically semisimple with rank-one blocks.  Projective-bundle persistence is supplied by Iritani--Koto/KKPYY. |

P0--P4 are now closed and imply the result for every \(m\), because the
correction row is zero regardless of the correction's marked atoms.  P2
deliberately has a larger codomain, so no false identification of a
\(z=\infty\) row with a \(z=0\) solution row is being made.  Different
edgewise comparison domains do not have to compose: zero/nonzero restriction
of the horizontal row to the canonical horizontal marked summand is an
intrinsic property of each vertex F-bundle.

The older one-sided endpoint gate remains the first fallback:

| gate | exact input | current evidence boundary |
|---|---|---|
| G0: marked source | One representation over the endpoint ring carrying the chosen primitive-sixth scalar, selected loop, and rank row.  It may be obtained from a rational core, but descent is not consumed by the same-ring theorem. | Lean consumes it; no geometric construction from the global cobordism is proved. |
| G1: detected witness | A generalized-primary vector in the marked source on which its row is nonzero. | The fixed-phase cubic-product endpoint has the old witness.  A new algebraic deck carrier must prove its own row-visible primitive witness.  If a witness is supplied after scalar extension, no flatness hypothesis is consumed. |
| G2: rational-endpoint map | A same-ring linear map from the marked source to the actual projective-space representation, intertwining the selected loop. | No target surjectivity, primary lift, correction summand, inverse, or coefficient-descent theorem is required.  The actual map is not yet constructed. |
| G3: row square | On the same map, `source row = scalar * endpoint row`; the scalar may be zero or nonunit for the logical implication, though a geometric normalization should be nondegenerate. | Gu--Yu--Yu's adjoint identity proves a generatorwise algebraic row equation on its nonlocalized completed source.  The no-Stokes route must descend it to the exact deck-marked carrier; the formal fallback instead needs the unresolved row formalization. |
| G4: endpoint contrast | The projective-space row does not detect the selected generalized-primary part. | Established for the old fixed-phase action, provided G0--G3 use exactly that action and row.  Open and separately load-bearing for the algebraic deck candidate because naive coefficient descent creates spurious deck characters. |

For a fixed choice of action and row, G0--G3 are the complete comparison
provider and G4 is the endpoint calculation.  G4 plus
`MarkedWitnessObstruction.false_of_core_detects_of_endpoint_not_detects`
then gives the contradiction.  This ledger is asymmetric by design: no
condition is hidden on target primary coverage.

## Route audit

The following distinctions prevent a failed implication from being mistaken
for a closed mathematical route.

| route | exact disposition |
|---|---|
| Row-visible marked projector | Landed no-Stokes route.  The Iritani/KKPYY projector square and Gu--Yu--Yu adjoint row square coexist on the Laurent QDM domain by connection naturality and the Proposition 5.2 basis argument.  It is all-\(m\). |
| Native projective Kummer/deck carrier | Closed for endpoint contrast: the (r=6) projective-space inverse-branch rank vector already has primitive (C_3) support under four (q)-plane turns on the twelve-fold cover. |
| One-sided marked core | Kernel-checked consumer; G0--G3 remain geometric. |
| Analytic global gauge from the graded `C[z]` comparison | The automatic inference is false: finite Novikov--Artin truncation can still leave an infinite positive-\(z\) tail.  A separately constructed analytic gauge would remain a valid provider. |
| Composition of edge-local completed germs | Automatic composition is false when basepoints differ by a nonnilpotent Laurent constant.  A pathwise based-coordinate theorem or one pre-completion core remains valid. |
| Extremal slice with all ambient Novikov variables zero | Insufficient because the specialization is not detection-reflecting.  A proved slice-faithfulness theorem on the marked finite quotient would repair it. |
| Convergent native QDM family across retained marker values | Not disproved; absent from the cited formal sources.  It remains an analytic provider theorem, not a consequence of integrability or Artin truncation. |
| Can/variation image coverage | Correct optional packet-identification input, but algebraically unnecessary for the closed projected-row zero after substituting \(p=c(x)\). |
| Dual cyclic-subconnection spectrum | Not an equivalent marker: an analytic-monodromy cyclic subspace need not be stable under formal monodromy, and cyclic spectrum forgets both the fixed nilpotence depth and the exponential-block label.  It remains usable only after an independent formal-row realization and collision-free marker theorem. |
| Ordinary Hodge--Lefschetz packet | Genuinely closed by the curve-blowup counterexample below. |
| Kummer/Burnside packet | Still open after adding the explicit common-charge, splitting-field disjointness, and equivariant-ledger hypotheses; only the inference from integral coefficients is closed. |

### Audit against the loosest consumer

The baseline for every proposed provider is now the same-ring theorem in
`MarkedWitnessObstruction`: one detected source witness, one map to the
projective endpoint, selected-loop naturality on that map, and one scalar row
equation.  Faithful flatness appears only in the rational-core convenience
wrapper.  The following stronger data are not part of the consumer and must
not be promoted to necessary gates.

| attempted connector | part of G0--G3 it could supply | excess data that may be discarded | exact live status |
|---|---|---|---|
| Intrinsic marked projector plus algebraic adjoint row | Replaces G0--G4 by the edgewise P0--P4 Boolean. | Any geometric loop, root label, target endpoint map, center classification, Gamma lattice, and Stokes packet. | Landed.  Projector naturality is algebraic, and the row square extends from Gu--Yu--Yu's ordinary Proposition 5.2 basis by finite \(R\)-linearity. |
| Whole meromorphic comparison from \(z=\infty\) to \(z=0\) | G2--G3, if it carries the actual selected loop and Gamma row. | A global gauge on the full QDM, all Stokes blocks, and adjacent-edge coherence. | The inference from finite Artin levels is false; direct construction of the marked restriction remains open. |
| Shared-vertex row-cyclic overlap | Could compose local maps into G2--G3. | Pairwise overlap is unnecessary if one global core maps directly to the rational endpoint. | Valid fallback, no longer a primary gate. |
| Integral nonturning Gamma crystal / pathwise common germ | Could construct G0 and G2--G3 simultaneously. | Full analytic parameter family, full HLT object, inverse edges, and all vertex germs. | Strong open provider; failure of automatic Laurent-germ composition does not rule it out. |
| All-ambient-Novikov-zero extremal slice | Could provide G2--G3 after a reflection theorem. | Full slice equivalence is unnecessary; only the marked witness and its row/loop data must reflect. | Current specialization is nonfaithful.  A finite marked-quotient slice-faithfulness theorem remains open. |
| Parallel augmented source / direct-sum decomposition | Could provide G0--G3. | Target surjectivity, correction factors, direct-sum invertibility, and maps to every endpoint. | Algebraically valid but strictly stronger than the one-sided endpoint map. |
| Parallel primary quotients and Fitting lifts | Could compare two nonempty endpoints. | All target primary coverage and stabilized Fitting data. | Superseded for the projective-space contradiction; retained only for other endpoint pairs. |
| Dual cyclic spectrum | Would replace the marker rather than supply G0--G3. | Not applicable. | Rejected as an equivalent invariant; a separate collision-free formal-marker theorem would define a different viable route. |
| Hodge--Lefschetz string | Would replace the marked QDM witness by an ordinary Hodge witness. | Not applicable. | Genuinely false under one smooth curve blowup, so this exact invariant is closed. |
| Kummer/Burnside packet | Proves a different equivariant telescope without G0--G3. | The ordinary cardinality ledger and integrality-only descent inference. | Still open under the stronger common-charge, splitting-field, and equivariant-ledger hypotheses. |
| Cai formal-solution-ring embedding | Could supply the common representation and the row/loop typing in G0--G3. | Analytic continuation and a full sectorial basis. | Bounded open test; failure closes only this chosen ring embedding. |

In particular, can/variation coverage, endpoint surjectivity, Fitting
decomposition, correction control, inverse maps, and adjacent-receiver
coherence are not missing hypotheses of the live one-sided proof.  They are
only possible implementation data for stronger providers.

### The two lawful source architectures

Every viable provider must reduce to one of two shapes before it reaches the
same-ring consumer.

1. **General source, specialized downstream.**  Construct one marked source
   \(S\) with its detected witness, selected loop, and row, then obtain one
   map \(S_K\to E\) to the projective endpoint after any required scalar
   extension.  The rational-core proposal has this shape.  The detected
   cubic endpoint and the empty rational endpoint may use unrelated
   faithfully flat branch fields; only their descent from the same marked
   core is shared.  This is the exact role of
   `GlobalCommonSourceObstruction.ScalarData`.
2. **Composable local sources, assembled downstream.**  Construct a typed
   chain

   \[
       S_0\longrightarrow S_1\longrightarrow\cdots\longrightarrow E
   \]

   over one final coefficient ring.  Every arrow need only intertwine the
   selected loop and satisfy a scalar row law.  Composition multiplies the
   row scalars and produces the single `MarkedWitnessObstruction.Data` value
   consumed at the end.  No arrow needs to be surjective.  If the local maps
   begin over different rings, a lawful common scalar extension and compatible
   root/loop reindexing must occur before this same-ring composition.

A collection of unrelated local sources is not a third architecture.  It
contributes only after a downstream cocone, reindexing, or ordered chain turns
the source carrying the witness into one actual map to \(E\).  Conversely,
the full augmented direct sums, inverse maps, and correction identifications
used to construct such a chain are implementation details, not consumer
hypotheses.  The global-source route should be tried first; the composed route
is the precise fallback if no single global cobordism map exists.

### No-Stokes constraint

The live provider search must not define its marked row at large radius and
then identify it with a \(z=0\) formal or sectorial row.  That is the missing
Gamma/Stokes connector in another form.  A Stokes-free instantiation must put
the selected action, detected witness, endpoint contrast, and adjoint rank row
on one algebraic marked module before any sectorial splitting.

The highest-value candidate is now the intrinsic marked projector, not a deck
action.  On a split generic QDM, mark the union of all rank-two blocks with
nonzero centered nilpotent and nonzero \(\delta^\sharp\).  Its idempotent
projector acts on the algebraic QDM lattice.  The row
\(\rho=\epsilon M\) is a linear map *from that same lattice* to a possibly
larger Givental coefficient module.  Gu--Yu--Yu's adjoint calculation and the
Iritani/KKPYY block decomposition can therefore be fused without ever calling
the row a covector on a formal-monodromy or sectorial solution object.

The previous Kummer candidate has two independent falsifiers.  Naive
restriction of scalars from \(L=K(q^{1/3})\) gives the scalar coefficient space
itself every deck character.  More decisively, Iritani--Koto formula (5.10)
for \(\mathbf P^5=\mathbf P(\mathbf C^6)\) gives its native six-branch rank
vector primitive \(C_3\) support under the order-three subgroup generated by
four turns of the \(q\)-plane on the twelve-fold cover.  Thus unmarked native
deck support does not distinguish the endpoints.  The exact calculation is
durable in the source dossier.

The marked projector avoids both failures.  It is defined from the atom
itself, includes all isomorphic occurrences, and is zero on projective space.
The two algebraic squares P1 and P3 are maps on one domain: P1 follows from
connection naturality and canonical spectral decomposition, while P3 is
checked on Gu--Yu--Yu's ordinary completed-source basis and extended by
finite \(R\)-linearity.  Correction blocks disappear because of the row
square, not because their atoms or deck actions are classified.
The Cai formal-solution-ring test is retained only as a separate fallback
because it reintroduces the large-radius-to-formal-row bridge.

One narrower fallback is not decided by the failed analytic-gauge argument.  Cai's
formal solution ring contains the \(z=0\) Turrittin symbols over the fraction
field of `C((z))[[q,t]]`.  The next bounded check is whether the normalized
large-radius fundamental solution and the Gu--Yu--Yu adjoint Fourier maps
embed in that exact coefficient field and whether the selected formal
monodromy fixes their image.  Success would construct G3 by scalar extension.
Failure of any one ring map closes this chosen embedding without reopening
sectorial uniqueness.  Passing it would still require proving that the
large-radius row becomes the intended formal row; it is not the no-Stokes
frontier.

## Rejected Hodge--Lefschetz packet shortcut

Ordinary Hodge multiplicities cannot replace the marked QDM row.  Let

\[
 A=H^3(X)_{\mathrm{prim}}.
\]

The tempting construction records the copies

\[
 A(-j)\subset H^{3+2j}(Y)
\]

and applies the primitive Hard--Lefschetz transform to their graded
multiplicities.  Conditionally on a lower carrier bound, the arithmetic is
correct: the source \(X\times\mathbf P^m\) has a string of length \(m+1\),
and a codimension-\(c\) blowup correction tensors a center string with the
length-\((c-1)\) Lefschetz character.

The carrier premise is false because the index \(j\) ranges over all
integers.  In particular, \(A(1)\) is a weight-one Hodge structure.  Choose a
smooth curve \(C\) for which \(J(C)\twoheadrightarrow J(X)\); semisimplicity
then makes \(A(1)\) a direct summand of \(H^1(C)\).  If
\(C\subset\mathbf P^D\) is blown up, the correction terms

\[
 H^1(C)(-i),\qquad 1\le i\le D-2,
\]

contain

\[
 A(1-i)\subset H^{1+2i},
\]

which is exactly the string \(A(-j)\subset H^{3+2j}\) for
\(j=0,\ldots,D-3\).  Its length is \(D-2\), equal to the string in
\(X\times\mathbf P^{D-3}\).  Thus one lawful curve blowup changes the proposed
top multiplicity.  The same counterexample already has length two when
\(D=4\), so the unconditional one-stabilization atom necessarily retains
extra polarization, QDM, or occurrence marking that ordinary Hodge
semisimplification forgets.

The Hard--Lefschetz/Clebsch--Gordan calculation survives only as a conditional
combinatorial lemma.  It cannot supply an unconditional \(m=2\) or all-\(m\)
obstruction.

## The uncalibrated blowup splitting

For a smooth blowup \(\widetilde X=\operatorname{Bl}_Z X\), the blowup case
of Gu--Yu--Yu, Theorems 5.26 and 6.2, supplies over its stated formal base a
connection- and Poincare-pairing-compatible decomposition

\[
 \Psi:\operatorname{QDM}(\widetilde X)
   \xrightarrow{\sim}
   \tau_X^*\operatorname{QDM}(X)\oplus
   \bigoplus_j\zeta_j^*\operatorname{QDM}(Z).
\]

Its leading matrix is the classical blowup decomposition: a point outside
the center has leading image \((p,0)\).  This does **not** imply the same
equation for the flat Gamma point.  At resonance, a pairing-preserving
horizontal gauge can be the identity in its leading coefficient and still
move the point line.

A model is a metric logarithmic connection with residue weights
\(-1,0,1\).  If \(p\) has weight zero and \(e\) weight one, a resonant
horizontal gauge may send \(p\) to \(p+Qe\) while being the identity modulo
\(Q\) and preserving the pairing.  The covector represented by the point
then changes on the weight-minus-one vector.  Thus no uniqueness constructor
from leading agreement is lawful.

## The exact row capability

Let the source and ambient pairings be \(\langle-,-\rangle_{\widetilde X}\)
and \(\langle-,-\rangle_X\), and let \(p_{\widetilde X},p_X\) denote the
actual flat point sections.  One convenient exact normalization is

\[
 \boxed{
 \langle p_{\widetilde X},x\rangle_{\widetilde X}
   =\langle p_X,\operatorname{pr}_X\Psi(x)\rangle_X
 \quad\text{for every }x.}
 \tag{66.1}
\]

At the level of bare modules it is formally weaker than the exact point equation

\[
       \Psi(p_{\widetilde X})=(p_X,0),                         \tag{66.2}
\]

and (66.2) implies (66.1) by pairing preservation.  For the actual perfect
QDM pairing, however, full-row equality is equivalent to point-vector
equality.  The direct row route changes the source proof, not the strength of
the normalized QDM statement.  The Boolean consumer would also accept a
unit-scaled row equation, or an equation only on the selected primary packet;
the exact normalization used here is a stronger convenient provider.

The QDM pairing has the usual \(z\mapsto-z\) variance.  The bilinear Lean
theorem is therefore applied only after restriction of scalars to a base over
which that twist is invisible; a full formal instantiation must instead carry
the sesquilinear variance explicitly.

Lean therefore separates:

- `RowedComparison`, the smallest direct-sum consumer, containing only the
  source row, ambient row, unit scale, and their equation;
- `CommonSourceGeneratorRows`, constructing that row-only consumer from exact
  formulas on a spanning source family;
- `UncalibratedData`, containing the direct sum and pairing square;
- `ExactPointCalibration`, containing (66.2);
- `ExactRowCalibration`, containing (66.1);
- `ScaledRowCalibration`, containing the unit-scaled Boolean variant;
- `CommonReceiverRowFactorization`, containing two endpoint maps to one
  rowed receiver, their map square, and compatible unit scales;
- `CommonSourceRowFactorization`, containing two endpoint maps from one
  augmented source, their induced direct-sum square, and the common pulled-back
  row;
- `CommonSourceGeneratorAgreement`, which asks for the same row identity only
  on a spanning family of the augmented source; and
- `Data`, which accepts only `ScaledRowCalibration`.

There are constructors from exact point calibration to exact row calibration
and from there to the unit-one scaled calibration.  The common-source and
common-receiver factorizations construct the scaled calibration directly.
They formalize the two parallel augmented routes: compare both maps in one
rowed receiver, or compare both endpoint rows after pullback to one common
source.  In the latter route, exact generator formulas suffice by linearity.
This matches Gu--Yu--Yu's definition of the Fourier maps on an explicit
module basis and avoids any inference from a leading asymptotic coefficient.
There is deliberately no constructor from a leading-term point equation.

The row-only interface also removes the artificial bilinear-pairing gate from
the formal source calculation.  Gu--Yu--Yu's pairing has the
\(z\mapsto-z\) variance, but their adjoint augmentation identity is already an
identity of linear covectors.  The pairing is needed only to identify that
covector with the geometric Gamma point row, not to prove its direct-sum
factorization.

## Formal consequence

Write \(r_{\widetilde X}\) and \(r_X\) for the two point rows.  Equation
(66.1) gives

\[
 r_{\widetilde X}=r_X\operatorname{pr}_X\Psi.                 \tag{66.3}
\]

Hence:

1. if \(r_{\widetilde X}(x)\ne0\), then the ambient projection of \(x\)
   still has nonzero row;
2. ambient inclusion preserves the row exactly; and
3. when \(\Psi\) intertwines a selected invertible monodromy, ambient
   projection intertwines every forward iterate of that monodromy.

Thus a row-detected primary vector cannot disappear into the correction
summand.  This is one-way and does not identify correction summands for two
consecutive walls.

If (66.1), selected-primary compatibility, a common coefficient-base
comparison, and coherent full augmented inverses hold occurrence-uniformly
for every smooth blowup and its reverse, weak factorization transports the
point-row Boolean without a two-wall Stokes matrix.  The argument would apply
to all stabilizations, not only \(m=2\).

## Legal source constructors

There are four flexible ways to construct the row calibration.

1. **Pointed Gamma enhancement.**  Prove (66.2) for the Gu--Yu--Yu
   decomposition and use its pairing square.
2. **Adjoint Fourier augmentation.**  Pull the two degree-zero rows back along
   the Gu--Yu--Yu Fourier maps.  Their discrete shift formula gives the same
   generatorwise row on the common source and directly constructs
   `CommonSourceGeneratorRows`.
3. **Full-variable point insertion.**  Identify the two Gu Fourier rows with
   the endpoint rows in the orbit-cylinder/support-collapse identity.  That
   identity has the variance of (66.1), so it constructs the row certificate
   without recovering a point vector.
4. **Kernel fibre identity.**  Realize the comparison by a kernel \(K\) and
   prove, in both source and target directions over the point fibre,
   \(R\!\operatorname{Hom}(\mathcal O_p,\Phi_K(-))
     \simeq R\!\operatorname{Hom}(\mathcal O_p,-)\)
   on the incoming image, compatibly with the Gamma framing.  Since \(p\)
   lies in the common open, a kernel restricting to the diagonal there is a
   natural starting point, but one must additionally exclude cross-boundary
   support on \(\{p\}\times D\) and \(D\times\{p\}\).

The second route proves the generatorwise formal rank-row equation on the
nonlocalized completed QDM source.  It does not by itself extend that row to
the Laurent or fixed-phase solution object.  The third is an alternative
construction of the analytic fixed-phase lift: support collapse is
coefficientwise in all remaining Novikov and bulk variables, but needs an
endpoint same-row theorem after one named common base change.

## Formal Fourier row without uniqueness

The formal row equation itself is already available on Gu--Yu--Yu's common
Fourier source.  Let \(M_W,M_X\) be their fundamental solutions,
\(\mathsf F_X\) the discrete Givental transform of Definition 4.13, and
\(\operatorname{FT}_X\) the QDM map of Proposition 4.21.  The commutative
diagram in that proposition gives

\[
 M_X\operatorname{FT}_X=\mathsf F_XM_W.                       \tag{66.4}
\]

Write \(\epsilon_X\) for projection to cohomological degree zero.  For
\(f=M_Ws\), where \(s\) belongs to the completed, nonlocalized QDM source,
Propositions 2.4 and 2.8 keep every shifted input
\(\mathbb S^k f=M_W\mathbb S^k s\) in the global equivariant lattice.  On
that lattice the classical Kirwan map is graded and unital, so
\(\epsilon_X\kappa_X=\epsilon_W\).  Definition 4.13 therefore gives

\[
 \epsilon_X\mathsf F_X(f)
 =\sum_{k\in\mathbf Z}S^{-k}\epsilon_W(\mathbb S^k f).         \tag{66.5}
\]

The equality is not asserted on the entire localized rational Fourier
domain: localized fixed-point idempotents can have different degree-zero
Kirwan values in different chambers.  On the completed QDM source, however,
the right-hand side depends on the common equivariant input and not on the
endpoint chamber.  Define the formal endpoint row
\(\rho_X=\epsilon_XM_X\).  Equations (66.4)--(66.5) show that the two pullbacks
\(\rho_{X_-}\operatorname{FT}_{X_-}\) and
\(\rho_{X_+}\operatorname{FT}_{X_+}\) agree generatorwise on the explicit
Gu--Yu--Yu source basis.  On the common base of their decomposition theorem,

\[
 \Psi=(\operatorname{FT}_{X_+}\oplus
       \text{center transforms})\operatorname{FT}_{X_-}^{-1}
\]

therefore satisfies

\[
 \rho_{X_-}=\rho_{X_+}\operatorname{pr}_{X_+}\Psi.            \tag{66.6}
\]

This is precisely the input of `CommonSourceGeneratorRows`; Lean extends the
generator equations by `LinearMap.ext_on`.  Gu--Yu--Yu, Theorem 5.5, places
both cone expansions in one extended ring.  What is proved directly is the
generatorwise identity on the nonlocalized completed QDM source.  Extending
that identity to the rowed Laurent solution module, and identifying the
resulting covector with the irregular solution row, are separate base-change
and analytic-formalization steps.  The false point-uniqueness step is absent
from the algebra once those steps are supplied.

For an Iritani Gamma flat section, \(\epsilon_XM_X\) is rank multiplied by a
dimension-dependent \(z\)-factor: the Gamma class and
\(z^{c_1(X)}\) have constant term one and only the rank component contributes
to cohomological degree zero.  After the named Laurent or ramified scalar
extension in which this factor is a unit, birational endpoints have the same
dimension and hence the same factor.  This gives the expected unit-scaled
Gamma rank row.  It does not yet identify that large-radius covector with a
covector on the selected \(z=0\) HLT or sectorial solution representation.

The remaining issue is the vertical marked identification: one representation
must carry both the selected irregular loop and the realized Gamma rank row.
A row-preserving comparison alone does not identify eigenspaces for two
different loops, and a formal loop comparison alone does not transport the
large-radius row.  `RowedRepresentationDecomposition` prevents this mismatch
inside one edge once a whole based-loop representation and one endpoint
`LoopAssignment` are supplied.  It does not identify the independently chosen
representations at two incident edges.

For that third route, let \(A_\pm=D\tau_{\pm,-}D\kappa_\pm\) be the two Woodward
endpoint maps and let \(\operatorname{FT}_{X_\pm}\) be the Gu--Yu--Yu discrete
Fourier maps.  It is enough to prove independently at each endpoint that the
pullback of the Gamma point row along \(\operatorname{FT}_{X_\pm}\) is the
normalized Woodward functional \(r_\pm A_\pm\).  The support-collapse identity
\(r_-A_-=r_+A_+\) then supplies the common-source row, and inversion
of \(\operatorname{FT}_{X_-}\) gives the required scaled row calibration.  This
does not use uniqueness of a horizontal point section.

The tempting raw point argument does not prove this endpoint identity.  In
Gu--Yu--Yu, Proposition 4.11, the continuous Givental transform factors
through restriction to a wall component only after conjugation by the
fundamental solutions.  Thus \(a_p|_{F_0}=0\) kills the raw Givental transform
of \(a_p\), but need not kill the QDM transform of the constant section
\(a_p\).  The corrected flat common source is the half-Tate-normalized section
\(z^{-1/2}M_W^{-1}a_p\) in a named localized solution space.  Its center
transforms vanish, but identifying its two endpoint transforms with the
Gamma point sections is exactly the same missing full-variable theorem.

## Exact remaining geometry

For consecutive edges, the native Gu pullbacks use different formal
coordinate maps and completions.  The proposed connector is the formal
Taylor, or crystal, isomorphism of the native vertex quantum connection.
Both edge coordinate maps reduce to the large-radius vertex after adjoining
their inverse exceptional parameters.  Over the completed product ring, a
flat connection has a Taylor isomorphism between the two pullbacks,
normalized by the identity at that common vertex.

This construction would provide the required adjacent overlap only if the
following chain is proved without changing objects:

1. both ambient edge factors are conservative pullbacks of one finite free
   vertex QDM over a common completed product ring;
2. its formal Taylor isomorphism transports the same Laurent-valued Gamma
   row and intertwines the selected based loop;
3. parameterized summation or the relevant Stokes functor carries that
   Taylor isomorphism to the two actual fixed-phase solution objects; and
4. the edgewise Gu row equation extends to those same objects, with the
   correct pairing slot, inverse character, and unit normalization.

The first two items are formal connection theory once the common base and
faithfulness are fixed.  The third is the precise analytic pressure point:
the graded-completed `C[z]` comparison is not a global meromorphic gauge, so
the conclusion cannot be obtained by an identity theorem on
`C^*`.  The fourth contains the still-open large-radius-to-irregular row
realization.

The Lean theorem
`MarkedRepresentationEquivalence.Equivalence.detectsGeneralizedEigenspace_iff_of_commonCarrier`
is the consumer of this construction.  It allows the two sectorial frames to
differ by a Stokes factor; each frame need only be marked-equivalent to one
common carrier.  Separate edge-local `RowedRepresentationDecomposition.Data`
values do not themselves enforce this adjacency.

### Where formal path composition fails

Retaining every augmented center factor does not make the edge maps formally
composable.  The inverse in Iritani's Theorem 5.18 is based at that edge's
tuple

\[
 (\tau_e^\circ(q_e),\{\varsigma_{e,j}^\circ(q_e)\}).
\]

It is an inverse after writing the target variables as this tuple plus
variables in the formal maximal ideal.  At a shared vertex, the preceding
edge produces the germ based at \(\tau_e^\circ(q_e)\), whereas the following
edge expects the germ based at \(\tau_f^\circ(q_f)\).  Their difference is a
Laurent coefficient, not a formal bulk variable.

The obstruction already occurs for coefficient rings.  Let
\(A=\mathbf C[q^{\pm1}]\), give \(y\) the degree of \(q^{-1}\), and consider
two coordinates \(a+x\) and \(b+y\) with \(a-b=q^{-1}\).  Both coordinate
changes have Jacobian one.  Identifying their completed germs would require

\[
 A[[y]]\longrightarrow A[[x]],\qquad y\longmapsto x+q^{-1}.
\]

The homogeneous series \(\sum_{n\ge0}(qy)^n\) would acquire the undefined
constant coefficient \(\sum_{n\ge0}1\).  Artin truncation does not help:
the relation \(y^N=0\) would map to
\((x+q^{-1})^N\ne0\).  Thus neither the invertible Jacobian nor finite
Novikov--Artin truncation supplies a continuous based map between the two
germs.  Carrying the correction summands along unchanged does not affect this
ambient constant-term mismatch.

This locates the type loss before multisummation:

1. an edge returns a pullback of \(\operatorname{QDM}(Y)\) over the completed
   local ring at \(\tau_e^\circ\);
2. the next edge accepts a pullback over the completed local ring at
   \(\tau_f^\circ\);
3. the label \(Y\) agrees, but there is no based coefficient-ring map between
   the two objects;
4. hence there is no lawful base change of modules, no common loop
   representation, and no row comparison to compose.

The Lean module `Comparison.BasedCoefficientMap` records the first necessary
condition.  A based map must preserve the residue square, so it cannot send a
vanishing coordinate to another vanishing coordinate plus a term with
nonzero residue; an element with unit residue cannot become nilpotent in an
Artin quotient.  The module
`Comparison.RowedRepresentationPath` records the other end of the bridge: a
single vertex-indexed family assigns one carrier, one loop representation,
and one row to each vertex, and a typed path can use only those exact endpoint
values.  Its theorem `Path.detectsAt_iff` telescopes the Boolean once such a
family exists.

The smallest source theorem joining these two interfaces is a pathwise
based-coordinate Gamma-crystal theorem.  It must supply one complete local
domain \(A\), compatible \(A\)-points for all vertices, continuous based
pullbacks for every full edge map and inverse, and a finite projective
row-cyclic module \(C_Y\) at every vertex carrying the selected loop and rank
row.  Every edge occurrence must be marked-equivalent to the corresponding
\(C_Y\), and the scalar extensions must reflect row nonvanishing.  A stronger
convergent big-QDM continuation between the finitely many edge basepoints
would also supply this package.

### Parallel augmented sources

The preceding theorem is unnecessary if all chamber expansions come from one
marked source before completion.  Let \(S\) be one representation carrying a
based-loop action and a row \(r_S\).  For every factorization vertex \(Y_i\),
suppose there is an isomorphism

\[
 F_i:S\xrightarrow{\sim}V_i\oplus C_i
\]

which intertwines the whole loop representation and satisfies
\(r_S=u_i r_i\operatorname{pr}_{V_i}F_i\) for a unit \(u_i\).  No row is
assigned to \(C_i\).  Applying the direct-sum theorem to \(F_i\) and \(F_j\)
through the definitionally same source gives

\[
 r_i|_{\ker(T_i-\lambda)^n}\ne0
 \quad\Longleftrightarrow\quad
 r_j|_{\ker(T_j-\lambda)^n}\ne0 .
\]

This statement is formalized by
`Comparison.ParallelAugmentedSource.Branch.ambient_detects_iff_ambient_detects`.
It neither chooses an intermediate frame twice nor forms a map between two
completed vertex germs.

One common chamber completion is stronger than necessary.  The paper-local
Lean module `Comparison.ParallelScalarExtensions` allows each branch to live
over a different coefficient ring.  It retains one pre-completion marked core
and requires, for each branch, the exact conservative equivalence

\[
 \operatorname{Detect}_{K_i}(S_i,\phi_i(\lambda),n)
 \quad\Longleftrightarrow\quad
 \operatorname{Detect}_{R}(S,\lambda,n).
\]

Together with a branch-local augmented decomposition, this compares any two
endpoint Booleans without embedding their incompatible Novikov completions in
one ring.  The equivalence is a source theorem, not a formal consequence of
completion or specialization.

There is now one exact automatic case.  If a branch ring (K_i) is faithfully
flat over (R) and its local source is the honest tensor product
(K_i\otimes_R S), then flatness identifies every shifted-monodromy kernel
after base change and faithfulness reflects zero of the row on that kernel.
The Lean theorem
`PrimaryDetectionBaseChange.detectsGeneralizedEigenspace_baseChange_iff` and
the smart constructor
`ParallelScalarExtensions.Branch.ofFaithfullyFlatBaseChange` prove the needed
reflection.  In particular, incompatible Laurent-series fields cause no
problem once both extend one finite rational marked core.  The remaining
source task is to construct that core and identify the endpoint fixed-phase
Gamma representations with its branchwise scalar extensions.  The theorem
only compares eigenvalues descending from the core, so that core must already
contain the chosen primitive-sixth label and encode compatible root lifts;
base change may otherwise create genuinely new primary lines.

AKMW birational cobordism gives the geometric shape of such a source.  A
factorization is obtained from regular chamber quotients of one smooth
\(\mathbf C^*\)-cobordism.  The source theorem can therefore be weakened to
branch-local Fourier--Gamma decompositions of one pre-completion core:

1. one finite marked core representation is defined before choosing a
   chamber;
2. for every endpoint, its scalar realization over that endpoint's own
   completion decomposes as the QDM of the quotient plus the fixed-locus
   corrections on the corresponding side;
3. the same global loop induces the normalized formal loop in every ambient
   factor;
4. the adjoint augmentation row pulls back to the Gamma rank row in every
   chamber, while all fixed-locus corrections are row-invisible; and
5. each scalar realization reflects the selected row-detected primary
   Boolean on the finite row-cyclic core.

Gu--Yu--Yu prove the required QDM decomposition for one simple adjacent wall.
Their Fourier source is attached to that wall and its completed coefficient
ring.  AKMW supplies the common cobordism, but the cited QDM theorem does not
state the branch-local decompositions of one pre-completion marked core, the
conservative primary reflection, or the Gamma/Stokes row realization.
Extending the Fourier construction endpoint by endpoint over its native
completion would remove both the impossible common-completion demand and the
adjacent-overlap theorem.  Because the argument uses only the rank row and the
global loop, this is also the direct all-stabilization upgrade path.

There is a narrower construction target.  On the extremal slice
\(Q=\widetilde\tau=0\), Theorem 5.18 gives
\(\tau_e^\circ=u_e[Z]+O(u_e^2)\), so the native vertex QDM can at least be
pulled back to a common formal polydisc in the \(u_e\) if an integral lattice
is proved.  One then needs relative nonturning HLT transport and the Gamma row
only on the finite row-cyclic quotient.  The theorem does not follow from the
full Laurent comparison: its positive ambient Novikov coefficients may have
negative \(u_e\)-powers, and after evaluating \(u_e\ne0\) the Taylor gauge can
have an essential factor such as \(\exp((u_f-u_e)/z)\).  Integrality and
relative Stokes strictness are therefore load-bearing parts of this smaller
bridge, not consequences of the edgewise Jacobian calculation.

## Backward formal-primary telescope

The weakest algebraic consumer is now completely explicit. Suppose a blowup
comparison is natural for one based-loop representation and has the
unit-scaled row form (66.6). If \(T_-\) and \(T_+\) are the operators assigned
to one loop, then for every \(\lambda\) and \(n\)

\[
 r_-|_{\ker(T_--\lambda)^n}\ne0
 \quad\Longleftrightarrow\quad
 r_+|_{\ker(T_+-\lambda)^n}\ne0.                 \tag{66.7}
\]

The forward direction projects a detected generalized eigenvector to the
ambient factor. The reverse direction includes an ambient generalized
eigenvector as \((x,0)\) and applies the inverse direct-sum comparison. The
centre may itself contain \(\lambda\)-primary vectors; its row is identically
invisible. The paper-local Lean theorem is
`RowedRepresentationDecomposition.Data.detectsGeneralizedEigenspace_iff`.

To telescope (66.7), the two copies of every shared vertex still require a
marked overlap. They need not use the same sectorial frame, but they must map
to one common rowed loop representation. The load-bearing geometric checks
are:

1. the formal coordinate pullbacks are faithful on the finite free QDM and
   reflect zero of the selected row projection;
2. Gu--Yu--Yu's connection-compatible comparison intertwines the normalized
   formal (z)-monodromy with the same half-Tate convention on both factors;
3. the adjoint row equality extends from the nonlocalized completed source to
   the extended Laurent completion of Theorem 5.5; and
4. the large-radius Gamma row and the selected irregular loop are realized on
   one marked solution representation; and
5. the two incident pullbacks of each intermediate vertex admit the common
   carrier comparison described above.

If all five hold occurrence-uniformly for arbitrary smooth blowups, weak
factorization makes the Boolean birationally invariant in every dimension.
This would remove the codimension-two centre problem rather than classify its
centres, and would give the all-(m) stabilization statement from the existing
endpoint contrast. Until those five source checks are discharged, this is a
backward theorem, not an unconditional promotion.

## Parallel primary-quotient compression

The direct-sum hypothesis in (66.7) is stronger than the Boolean consumer.
Let (R\to K_i) be faithfully flat extensions of one coefficient ring, let
((V,T,r)) be a marked (R)-representation, and let

\[
 q_i:K_i\otimes_RV\longrightarrow V_i
\]

intertwine the selected loop.  Fix (lambda\in R) and an exponent (N).
Assume

\[
 r_{K_i}=u_i\,r_iq_i,
 \qquad u_i\in K_i^\times,
\]

and that (q_i) maps
(ker(T_{K_i}-\lambda)^N) onto
(ker(T_i-\lambda)^N).  Faithful flatness preserves and reflects detection
on the source primary kernel, while the unit row equation transports it
between source and endpoint.  Hence all endpoint Booleans agree through the
single (R)-core.  This is formalized by
`ParallelPrimaryQuotients.Branch.endpoint_detects_iff_endpoint_detects`.

The primary-kernel surjectivity is not independent once ordinary
surjectivity is combined with Fitting decomposition at the selected exponent.
Put (f=T-\lambda).  If

\[
 V=\ker f^N+\operatorname{im}f^N,
 \qquad
 \ker f_i^N\cap\operatorname{im}f_i^N=0,
\]

lift (y\in\ker f_i^N), decompose its lift as (x_0+x_1), and apply (q_i).
The vector (q_i(x_1)) lies in both the target kernel and target image, hence
vanishes, so (q_i(x_0)=y).  Lean proves this exact argument in
`ParallelPrimaryQuotients.primaryLift_of_surjective_of_fitting` and packages
it in `ParallelPrimaryQuotients.Branch.ofSurjectiveOfFitting`.

This compression is uniform in dimension.  An all-(m) proof would follow
from one smooth global cobordism if its marked equivariant QDM admits a finite
rational core containing the chosen primitive-sixth label and each endpoint
localized quantum-Kirwan map is a faithfully flat scalar realization with:

1. selected-loop naturality;
2. a unit-scaled pulled-back Gamma rank row;
3. ordinary surjectivity; and
4. a common exponent beyond the two Fitting thresholds.

The theorem does not require a common endpoint completion, a map between
adjacent chambers, an exceptional direct-sum splitting, or a full Stokes
matrix.  What is not yet supplied is descent of the actual marked
Gamma/monodromy source to the rational core and realization of the localized
quantum-Kirwan maps with these four properties.

## One-sided target-empty compression

The rational endpoint does not require a quotient theorem.  Suppose the
common marked core already detects the chosen generalized-primary block and
the target has no such block.  Any comparison from a faithfully flat scalar
extension of the core to the target which intertwines the selected loop and
satisfies a scalar row square sends a detected core witness to a
detected target witness.  It therefore gives an immediate contradiction;
surjectivity and primary coverage never enter.  This is proved in
`MarkedWitnessObstruction.endpoint_detects_of_core_detects`.

Accordingly, the source theorem has two asymmetric parts:

1. put one detected cubic-product witness into the global marked core (a
   single primary lift suffices); and
2. construct only a marked selected-loop map from that core to the rational
   endpoint.

This avoids importing general quantum-Kirwan surjectivity, which is
conjectural in the cited generality.  It does not remove the actual
Gamma-row-to-formal-monodromy identification: the loop and row must already
live on the same marked core before the Lean consumer applies.
