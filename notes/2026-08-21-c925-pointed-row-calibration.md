# C925 pointed row calibration

## Status

The false flat-point uniqueness step can be removed from the algebraic
consumer.  Gu--Yu--Yu's adjoint Fourier formula gives the rank-row equation
generatorwise on the nonlocalized completed QDM source.  The paper-local Lean
modules `Comparison.PointedDirectSum` and
`Comparison.RowedRepresentationDecomposition` separate that equation from
point representatives and endpoint loop selection.

The latest consumer bypasses adjacent vertex comparisons entirely.  One
finite marked representation before chamber completion may be extended
faithfully flat to each endpoint coefficient field and mapped directly to
that endpoint.  It is enough that the map intertwine the selected loop,
compare the rows up to a unit, and cover the selected generalized-primary
kernel.  The paper-local Lean modules
`Comparison.PrimaryDetectionBaseChange` and
`Comparison.ParallelPrimaryQuotients` prove that any two such endpoints have
the same detected-primary Boolean.  At an exponent where source and target
have the relevant Fitting decompositions, ordinary surjectivity implies the
needed primary coverage.  The source problem is consequently one global
marked-core theorem rather than adjacent sectorial coherence.

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
correct: the source (X\times\mathbf P^m) has a string of length (m+1),
and a codimension-(c) blowup correction tensors a center string with the
length-((c-1)) Lefschetz character.

The carrier premise is false because the index (j) ranges over all
integers.  In particular, (A(1)) is a weight-one Hodge structure.  Choose a
smooth curve (C) for which (J(C)\twoheadrightarrow J(X)); semisimplicity
then makes (A(1)) a direct summand of (H^1(C)).  If
(C\subset\mathbf P^D) is blown up, the correction terms

\[
 H^1(C)(-i),\qquad 1\le i\le D-2,
\]

contain

\[
 A(1-i)\subset H^{1+2i},
\]

which is exactly the string (A(-j)\subset H^{3+2j}) for
(j=0,\ldots,D-3).  Its length is (D-2), equal to the string in
(X\times\mathbf P^{D-3}).  Thus one lawful curve blowup changes the proposed
top multiplicity.  The same counterexample already has length two when
(D=4), so the unconditional one-stabilization atom necessarily retains
extra polarization, QDM, or occurrence marking that ordinary Hodge
semisimplification forgets.

The Hard--Lefschetz/Clebsch--Gordan calculation survives only as a conditional
combinatorial lemma.  It cannot supply an unconditional (m=2) or all-(m)
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

The second route closes the formal rank-row equation directly.  The third is
an alternative construction of its analytic fixed-phase lift: support collapse
is coefficientwise in all remaining Novikov and bulk variables, but needs an
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
satisfies the unit-scaled row square sends a detected core witness to a
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
