# C907 — the sole remaining Gold failure mode is a mixed ambient Stokes shear

Date: 2026-08-13

Status: exact reduction, not Gold closure.  After the ordinary-flop theorem,
the simple-VGIT wall theorem, and the AKMW unit-circuit coverage theorem, a
failure of the Gamma-rank telescope can occur only at two consecutive
discrepant unit walls.  The transition must contain an exponentially small
**ambient-to-ambient** Stokes shear which changes the rank restriction on the
primitive-sixth packet.  Center-supported shears, single-wall effects,
ordinary crepant directions, and packet-faithful `c_1`-positive carrier faces
cannot cause failure.  A dangerous shear must be supported by an affine
tower of mixed classes in a `c_1`-neutral direction involving both incident
wall parameters.

This is the precise target for either a final proof or a counterexample.

## 1. Set-up after geometric coverage

Choose the projective pi-desingularized AKMW elementary chain between
`X x P^2` and `P^5`.  By
`2026-08-13-c907-akmw-pi-nonsingular-circuits-are-unit.md`, every wall is a
unit-coefficient standard wall (including blowups as one-sided cases).

For an ordinary wall, the intrinsic C907 point-row theorem compares the
large-radius Gamma row and `P_6` across analytic continuation.  Such a wall
composes without a receiver choice.

For a discrepant wall, Gu--Yu--Yu give a pairing-compatible decomposition

\[
 QDM(Y_-)=QDM(Y_+)\oplus\bigoplus_j QDM(S)_j,                       \tag{1}
\]

and the C907 simple-wall theorem gives, in its fixed-sector receiver,

\[
 r_-|_{\mathrm{amb}}=r_+,
 \qquad r_-|_{QDM(S)_j}=0.                                         \tag{2}
\]

Thus only a chamber `Y` incident to two discrepant walls has two unresolved
realizations.  Let `R_L(Y)` and `R_R(Y)` denote their sectorial fibre
functors and let

\[
 T_Y:R_L(Y)\dashrightarrow R_R(Y)                                  \tag{3}
\]

be the unproved transition.

## 2. Center shears are harmless

Let `C_L,C_R` be the sums of all wall/exceptional blocks entering the two
receivers.  Every Gamma lattice vector in either center block is represented
by an object supported on the exceptional locus, hence has rank zero.  By
flat Gamma/Euler pairing,

\[
 r_Y(C_L)=r_Y(C_R)=0.                                               \tag{4}
\]

Suppose the transition (3), in either orientation, differs from its ambient
identification only by maps through these center blocks.  Then

\[
 r_YT_Y=r_Y                                                        \tag{5}
\]

on the whole ambient solution space.  Consequently its restriction is
nonzero on `P_6` in one receiver iff it is nonzero in the other.  This remains
true for any finite sequence of mutations by center blocks and for every
`O(kE)` twist, since support and rank do not change.

Therefore the familiar Stokes-small center admixtures are not the remaining
problem.  A counterexample must have a nonzero induced transformation on the
ambient quotient

\[
 \overline T_Y: R_L(Y)/C_L\longrightarrow R_R(Y)/C_R.             \tag{6}
\]

## 3. Exact shape of a Boolean-changing shear

The positive-`z` QDM identifications on both sides of (6) are the same
intrinsic ambient QDM of `Y`.  Hence the formal asymptotic expansion of
`overline T_Y` is the identity.  Any nonidentity term is an exponentially
small Stokes automorphism, invisible in the formal Novikov/QDM category.

For it to change the Boolean, there must be a primitive-sixth vector `v` and
an ambient vector `w` outside its sectorial packet such that a Stokes term

\[
 v\longmapsto v+c\,w\quad\text{or}\quad
 w\longmapsto w+c\,v,\qquad c\ne0,                                \tag{7}
\]

changes whether `r_Y` annihilates the transported packet.  Necessarily

\[
 r_Y(w)\ne0                                                        \tag{8}
\]

in the dangerous orientation.  A shear into a center direction violates
(8) by (4), and a change of basis internal to `P_6` cannot change whether the
restriction of a covector to the whole packet is zero.

Thus the missing datum is one ambient-to-ambient Stokes coefficient, not a
center row and not the full central connection matrix.

## 4. Its curve classes must form a mixed `c_1`-neutral tower

A one-wall contribution is already measured by (1)--(2), so a coefficient
in (7) must involve both incident wall parameters.  It disappears on each
one-axis extremal specialization and can only occur in mixed monomials.

If all packet-carrying mixed classes lie on an exposed rational-polyhedral
face on which `c_1` is strictly positive, the complete carrier connection is
polynomial by the genus-zero dimension axiom.  The K-positive carrier-face
theorem then joins the two receivers in one honest nonturning analytic family
and rules out a Boolean-changing transition.

If the mixed direction is an ordinary crepant extremal ray, the LLW graph
gauge and the ordinary-flop point-row theorem rule it out.

The precise conclusion is slightly subtler than saying that the dangerous
stable-map class itself has `c_1=0`.  A surviving coefficient requires a
nonzero numerical direction `delta` with

\[
 c_1(Y)\cdot\delta=0,                                               \tag{9}
\]

and infinitely many effective packet-carrying classes in an affine tower

\[
 \beta_n=\beta_0+n\delta.                                          \tag{9a}
\]

Here `delta` involves both incident parameters but is not itself isolated as
an ordinary-flop ray covered by the graph theorem.  It can be a formal
difference direction even when not every `delta` is separately effective;
what matters is effectivity of the tower.  The contact-budget examples show
that neutral directions are not formally impossible: iterated blowups can
create K-trivial differences of exceptional curves.

What is now required is far stronger: the tower (9a) must produce the
ambient Stokes coefficient (7) with the nonzero-rank condition (8).  The
individual classes can have positive fixed `c_1(beta_0)`; the zero slope in
the `delta` direction is what defeats coefficientwise polynomiality.

## 5. Two exact routes to closure

Before the two routes, one large class of suspects can be eliminated
unconditionally.

### Pure-boundary elimination lemma

Let `D subset Y` be the union of the toroidal/exceptional boundary strata in
the chosen AKMW model, and let

\[
 H_D=\operatorname{im}\bigl(H_D^*(Y)\longrightarrow H^*(Y)\bigr). \tag{10}
\]

Suppose an effective curve class `beta` has the property that every stable
map of class `beta` is supported in `D`.  For any insertions, the output
evaluation map of the corresponding genus-zero correspondence factors
through `D`.  If `Q_beta(alpha)` denotes the `Q^beta` coefficient of quantum
multiplication by `alpha`, then every positive-`beta` correction has image in
`H_D`:

\[
 Q_\beta(\alpha)(H^*(Y))\subset H_D.                                \tag{11}
\]

The same support argument makes `H_D` stable under these corrections.  Thus
the quantum connection in all such variables induces, on the quotient, only
the fixed classical divisor action and no positive-curve correction:

\[
 H^*(Y)/H_D.                                                       \tag{12}
\]

Its irregular sectorial/Stokes transport is therefore the identity on (12),
up to the regular classical line-bundle factor, which preserves rank.  Under
Chern character, `H_D` is generated over `C` by supported perfect classes and
the Gamma rank covector annihilates it.  Therefore a pure-boundary class can
produce only the harmless center-type shears of Section 2, even when
`c_1(beta)=0` and even when several exceptional variables occur.

This eliminates the concrete likely suspects already encountered:

- differences and combinations of exceptional fibre classes created by
  iterated blowups;
- the six Geiser flop curves and all ordinary-flop packets;
- center-supported curve/surface packets in the standard walls;
- the Fano-surface/C908 two-layer packet;
- any toroidal circuit curve contained in the factorization boundary.

The support lemma does **not** eliminate a connected stable map with an
off-boundary component and boundary bubbles.  Such a class can meet the
chosen point on its ambient component.  Consequently the only remaining
geometric suspect is a tower

\[
 \beta_n=\beta_{\mathrm{carrier}}+\tau_0+n\delta,\qquad
 c_1(\delta)=0,                                                     \tag{13}
\]

where the first component carries the cubic primitive-sixth atom and
`tau_0+n delta` is a boundary tree meeting it at relative nodes.  The total
`c_1(beta_n)` can be positive and fixed.  This is a mixed relative-Gromov--
Witten effect, not a pure exceptional-class effect.  None of the currently
computed regressions exhibits a nonzero coefficient of this kind.

### The first unresolved coupling is a one-legged neutral tail

The genus-zero virtual dimension gives a further restriction.  On a
fivefold,

\[
 \operatorname{vdim}_\mathbf C\overline M_{0,k}(Y,n\delta)=2+k
 \quad\text{when }c_1(\delta)=0.                                  \tag{14}
\]

For `k=1`, evaluation of a pure neutral tail is therefore a three-dimensional
cycle supported on the exceptional/toroidal locus.  More generally, the
affine tower `tau_0+n delta` gives a supported cycle of the fixed dimension
`3+c_1(tau_0)`, independent of `n`.  In every non-blowup
standard wall in the fivefold portfolio, the largest exceptional locus has
dimension three.  The leading one-leg state is consequently a linear
combination of fundamental classes of three-dimensional exceptional
components (and descendants lie in still smaller supported degree).  For a
blowup wall the exceptional divisor can have dimension four, but the same
evaluation is still a supported three-cycle; only the description as a
fundamental component changes.

Summing arbitrary one-legged boundary trees is the standard genus-zero tail
resummation: it replaces the attaching insertion by the corresponding
cohomology-valued `J`-tail, equivalently a mirror/bulk translation.  Here that
translation lies in boundary-supported cohomology.  This fact alone does
**not** make it harmless.  An off-boundary carrier vertex can accept the
supported state at the attaching node while its other markings carry an
ambient primitive-sixth input and an ambient rank-visible output.  In other
words, a supported intermediate state need not remain supported after
convolution with a mixed carrier invariant.

Write `j_n in H_D` for the one-leg state of the neutral tower.  The first
unresolved datum is the mixed carrier coupling

\[
 C_n(v)=
 (\operatorname{ev}_{\mathrm{out}})_*
 \bigl[overline M_{0,k}(Y,\beta_{\mathrm{carrier}};
        v,j_n,\ldots)\bigr]^{\mathrm{vir}},                       \tag{15}
\]

where `v` is an ambient primitive-sixth state and the omitted insertions
include the point/rank measurement or the connection insertions.  Danger
requires that the image of `C_n` survive `H^*(Y)/H_D` and have nonzero rank.
If every such coupling sends `H_D` back into `H_D`, then one-legged tails are
harmless; this is a substantive module/factorization statement, not a
consequence of support alone.

Only after the one-leg coupling is killed does the next possible datum become
the two-leg correspondence

\[
 (\operatorname{ev}_1,\operatorname{ev}_2)_*
 [\overline M_{0,2}(Y,n\delta)]^{\mathrm{vir}},                    \tag{15a}
\]

supported on a product of exceptional strata.  A scalar diagonal or a
factorization through one supported block is harmless; a Gold obstruction
requires a genuinely off-diagonal component which, after gluing to the two
ambient sides, produces the nonzero-rank shear (7)--(8).

Thus the dangerous object is not a curve class alone.  At minimum it is an
unbounded neutral tower together with a **mixed boundary-to-ambient coupling**.
A multi-legged boundary propagator joining two carrier components is the
second obstruction if the one-legged coupling vanishes.

### Valence/contact-budget lemma

The neutral balance cannot be assembled from two independent one-wall tails
attached to a fixed carrier unless the boundary itself connects the two sign
sectors.

Indeed, let `B_-` be a connected boundary subcurve of class `gamma_n` with

\[
 c_1(\gamma_n)\leq -\nu n+O(1),\qquad \nu>0,
\]

and let `k_n` be the number of flags by which it meets the rest of the stable
map.  Its genus-zero virtual dimension on a fivefold is

\[
 2+k_n+c_1(\gamma_n).
\]

A nonzero virtual correspondence therefore requires

\[
 k_n\geq \nu n-O(1).                                               \tag{15b}
\]

On the other hand, an off-boundary carrier of fixed numerical class meets
the toroidal boundary with uniformly bounded total contact.  Choose an
effective Cartier divisor containing each relevant boundary stratum but no
carrier component; the sum of the contact multiplicities is bounded by its
intersection with the fixed carrier class.  Constant components lying in the
boundary are absorbed into the boundary subtree and do not evade this bound.

Consequently, if positive- and negative-sign boundary components belong to
different connected components of the boundary incidence graph met by the
carrier, the left side of (15b) is bounded and the tower is finite.  An
unbounded neutral tower forces a connected boundary subtree which contains
both signs, hence an actual incidence path between the exceptional strata of
the two incident walls.  Equivalently:

> **No mixed-sign boundary incidence path, no dangerous Stokes shear.**

This also corrects a tempting false model: two arbitrarily long independent
`J`-tails, one on each wall axis, cannot balance through a fixed ambient
vertex.  The negative tail eventually has negative virtual dimension unless
it acquires linearly many attachments, and the fixed carrier cannot supply
them.  The only escape is internal positive/negative boundary gluing—the
mixed rubber object already isolated above.

### Anatomy of the first possible dangerous graph

The genus-zero dual graph makes this description concrete.  Let `B` be a
maximal connected subtree all of whose nonconstant components lie in the
boundary and whose class belongs to the neutral tower.  There are two minimal
shapes.

The one-leg shape is

\[
 B_n\;---\;A_{\mathrm{atom/rank}},                                \tag{16}
\]

where one off-boundary carrier subtree contains the remaining marked legs and
the mixed coupling (15) must carry the supported node state to an ambient
rank-visible output.  If that coupling is triangular modulo `H_D`, the first
remaining shape is the bridge

\[
 A_{\mathrm{atom}}
 \;---\; B_n \;---\;
 A_{\mathrm{rank}},
 \qquad [B_n]=\tau_0+n\delta,\quad n\geq0.                         \tag{16}
\]

In the bridge shape the two external flags must attach to two *different*
off-boundary connected components: two attachments to the same outside
connected component would create a cycle in the dual graph and hence
arithmetic genus at least one.  Across the two shapes:

1. The off-boundary carrier data supply both the ambient primitive-sixth state
   and an ambient state detected by the point/rank covector.  They can occur
   on one carrier subtree in the one-leg shape or on distinct subtrees in the
   bridge shape.  In a point-pairing presentation, the rank side contains the
   marked point chosen in the common open complement of the boundary.
2. The two endpoint evaluations of `B_n` land in boundary strata, normally
   associated to the two incident circuits.  The class and contact data must
   use both wall variables, so the contribution vanishes on either one-axis
   specialization.
3. The direction `delta` has `c_1(delta)=0`, and the classes
   `tau_0+n delta` occur for infinitely many `n`.  A single curve, a finite
   list of degrees, or a strictly `c_1`-positive recession direction is not
   enough.
4. Since
   `vdim_C Mbar_{0,2}(Y,tau_0+n delta)=4+c_1(tau_0)` is independent of `n`,
   the bridge defines a fixed-degree correspondence between its two endpoint
   strata.  In the pure neutral case this is the four-dimensional cycle
   (15a).  A pure-neutral one-leg state has virtual dimension three by (14),
   and a fixed affine offset changes this to `3+c_1(tau_0)`.
5. After convolution with the carrier correspondence or correspondences,
   its image must be nonzero in the ambient quotient `H^*(Y)/H_D` and its
   target must have nonzero rank.  If the convolution factors through a
   supported solution block, it is killed by (4), however complicated the
   boundary series is.
6. The resulting ambient branch must meet the primitive-sixth branch in the
   correct anti-Stokes ordering.  A nonzero relative Gromov--Witten series
   without this exponential alignment still cannot supply the coefficient
   `c` in (7).

This gives three increasingly cheap falsifiers for each adjacent pair of
unit circuits:

- **cone test:** the mixed affine effective cone has no nonzero recession
  direction in `ker(c_1)`;
- **incidence test:** no connected boundary stratum chain carrying such a
  direction meets an off-boundary carrier locus in the required contact
  degree; for a bridge, it must meet two distinct carrier components;
- **factorization test:** every one-leg carrier coupling and every surviving
  two-leg correspondence factors through the supported wall/center state
  spaces.

Failure of any one test proves that pair harmless without constructing a
two-wall analytic receiver.

### The current likely suspects are excluded

The conditions above eliminate the concrete objects that have appeared so
far:

- an isolated exceptional fibre, a difference of exceptional fibres, or a
  tower of multiple covers wholly inside the boundary fails the two-carrier
  and ambient-quotient tests;
- the six Geiser curves and their products are an ordinary-flop tower and
  are already killed by the LLW graph gauge;
- a standard-wall center packet, including a projective-bundle packet over a
  point or curve, is a one-wall supported factor;
- a neutral tree dangling from one carrier is reduced to a supported
  `J`-tail, but it is excluded only when the associated carrier coupling is
  triangular modulo `H_D`; this is now explicitly part of the remaining
  test rather than a claimed automatic vanishing;
- the C908 theta/Fano-surface packet is supported and finite in the relevant
  wall framing; it has no mixed two-circuit neutral bridge;
- a scalar diagonal two-point series on one boundary stratum remains a
  center mutation and preserves rank;
- every strictly `c_1`-positive carrier face is coefficientwise finite and
  belongs to the already closed polynomial receiver case.

Consequently none of the named geometric packets is itself the dangerous
object.  The first unresolved suspect is a **mixed two-wall rubber tail**:
an infinite neutral boundary series whose one-leg coupling to an ambient
carrier survives the quotient by all supported wall blocks.  If all one-leg
couplings are triangular, the first suspect upgrades to a two-leg rubber
propagator joining two different ambient carrier components.  No example of
either surviving coupling is currently known.

### Shadow-first attack

The reconstruction papers suggest not computing the propagator itself.  A
dangerous propagator must cast several much cheaper shadows, and the shadows
can be tested in order.

#### 1. Carrier shadow

Equations (9), (13), and (16) give a purely numerical shadow: a mixed affine
effective tower with recession direction in `ker(c_1)`, together with a path
in the boundary incidence complex joining two carrier attachment strata.
This uses only the two circuit lattices, the canonical class, and the
incidence poset of toroidal strata.  Absence of this shadow rules out the
object before any Gromov--Witten calculation.

There is an immediate sign sieve.  On a two-ray face, write the effective
ray generators as `ell_L,ell_R`.  If `c_1` has the same strict sign on both,
the face contains no nonzero neutral recession direction.  A dangerous
tower can therefore occur only at a sign-changing chamber.  If

\[
 c_1(\ell_L)=\nu_L>0,
 \qquad c_1(\ell_R)=-\nu_R<0,
\]

then, up to scale, its only possible neutral slope in that face is

\[
 \delta_0=
 \frac{\nu_R}{\gcd(\nu_L,\nu_R)}\ell_L+
 \frac{\nu_L}{\gcd(\nu_L,\nu_R)}\ell_R.                           \tag{17a}
\]

For unit standard walls on a fivefold, the genuine non-blowup discrepancies
are only `1` for `(2,3)` and `2` for `(2,4)`; blowup discrepancies are
`1,2,3,4` for centers of codimension `2,3,4,5`.  Hence the possible primitive
two-ray slopes form a finite list.  Same-orientation adjacent walls are
eliminated numerically.

#### 2. Low-moment coupling shadow

The one-leg state `j_n` is determined by its moments against a basis of the
boundary-supported cohomology.  The first shadow to test is not merely
`j_n`, however, but the finite matrix of mixed carrier moments

\[
 \langle b,C_n(v)\rangle,
 \qquad v\in P_6^{\mathrm{amb}},\quad b\in H^*(Y),                 \tag{17}
\]

for the coupling (15).  Vanishing of its projection to the ambient quotient,
or factorization of that matrix through a supported block, kills every
one-legged neutral tower.

For the next layer, define the connected two-leg class

\[
 \Gamma_n^{\mathrm{conn}}
 \in H_*\bigl(D_L\mathbin{\times}D_R\bigr)                         \tag{17b}
\]

by the relative/rubber two-point correspondence of the neutral subtree,
with the factorized one-leg contributions removed.  Its pair moments

\[
 m_{ab}(n)=
 \int_{\Gamma_n^{\mathrm{conn}}}
 p_L^*a\,p_R^*b                                                    \tag{18}
\]

are the analogue of the weighted pair concurrences elsewhere in the paper
series.  For a non-blowup standard wall on a fivefold, the endpoint strata
are projective bundles over a point or a curve: indeed
`dim S+r_++r_--1=5`, and the only discrepant non-blowup rank types are
`(r_+,r_-)=(2,3)` over a curve and `(2,4)` over a point.  Their cohomology is
generated by finitely many fibre-hyperplane and base classes.  Consequently
a finite table of moments (18) determines the cohomology class (17) in every
degree `n`.

If all the one-leg coupling moments and connected pair moments vanish, or if
their matrices factor through supported center blocks, the rubber tower is
harmless.  A
Hodge--Riemann norm of the primitive algebraic part gives a nonnegative
defect shadow: zero norm forces that cohomology class to vanish.  This is an
available proof pattern, not yet a computed identity for the two circuit
types.

#### 3. Spectral/turning shadow

Stokes matrices are locally constant on a nonturning isomonodromic chamber.
Therefore a coefficient which vanishes on both one-wall faces cannot grow as
an ordinary mixed formal power series.  To differ between the two incident
receivers, the comparison paths must be separated by a turning or
anti-Stokes wall for an ambient primitive-sixth exponential and a
rank-visible ambient exponential.  The discriminant and argument ordering
of the formal exponential factors are a necessary spectral shadow.

Thus a computation of the two-wall quantum spectrum can kill the dangerous
object without computing its Stokes multiplier: if a common corridor joins
the receivers while avoiding the relevant turning walls, local constancy
forces the multiplier to remain zero.

#### 4. Divisor-tag shadow

In a relative factorization over `P^2`, the common line bundle
`L=f^*O_{P^2}(1)` gives `N=1-L` with `N^3=0`.  On the endpoint
primitive-sixth packet, `N` is the length-three Jordan string inherited from
`K_0(P^2)`.  Any receiver transition intertwining the common Galois/line-
bundle action must commute with `N`.  Hence a dangerous scalar cannot occur
alone: it must extend to an `N`-linear shadow between compatible base
strings.  Packets of coniveau forcing `N^2=0`, and all rank-zero supported
strings, cannot be its rank-visible target.

This is a shadow version of the support-square idea.  It uses the exact
line-bundle tag rather than asking for a support-compatible extraction of the
whole primitive-sixth packet.

#### 5. Window/K-theory shadow

The common-open point class is the same numerical `K`-class in both incident
VGIT presentations.  Algebraic grade-restriction window changes are generated
by unstable-stratum objects.  Every such object has rank zero, so any product
of the corresponding Euler mutations fixes the rank covector exactly.  Thus
it is enough to show that the adjacent analytic Stokes transition has the
same **numerical K-theory shadow** as a window change; equality of the full
functors or of their central connection matrices is unnecessary.

The algebraic part of this statement is proved and audited in
`2026-08-13-c907-window-shadow-boundary.md`: weight truncation for birational
cobordisms and the standard-wall semiorthogonal decompositions make the
categorical window action rank-trivial modulo supported classes.  What remains
unproved is precisely that the analytic adjacent-receiver transition casts
this algebraic numerical shadow.

This isolates a particularly small theorem target: the sectorial transition
and the algebraic window transition induce the same map on

\[
 K_0^{\mathrm{num}}(Y)\big/\langle\text{unstable-stratum classes}\rangle.
                                                                    \tag{18a}
\]

On this quotient the algebraic transition is the identity.  A dangerous
rubber object would have to cast a contrary K-theory shadow—an ambient
numerical class not generated by either unstable stratum.  This is the exact
analogue of recovering a carrier from its minimum-support or pair data.

#### 6. Euler-lattice nullity shadow

Let `K=K_0^{num}(Y)` in Gamma framing, let `chi` be its Euler matrix, let
`C_L,C_R subset ker(rank)` be the two supported lattices, and let `T_D` be
the common line-bundle operators.  The exponential ordering gives a finite
zero pattern for an allowed Stokes unipotent `S`.  Any actual dangerous
transition must satisfy the finite constraints

\[
 S^t\chi S=\chi,
 \qquad [S,T_D]=0,
 \qquad S\equiv 1\ \text{on the prescribed formal graded pieces},            \tag{19}
\]

together with the two wall-triangularity patterns.  The Gold-threatening
condition is

\[
 rS|_{P_6}\ne r|_{P_6}.                                           \tag{20}
\]

Equations (19)--(20) define a finite matrix/nullity problem.  If every
solution of (19) stabilizes the rank row modulo `C_L+C_R`, then no dangerous
propagator can exist.  This is directly analogous to the diagonal-nullity
and sparse-carrier reconstructions elsewhere in the collection: the hidden
operator is ruled out by the small algebra of shadows it would have to
preserve.

The caveat is exact.  To use the integral Euler lattice rather than only the
complex flat pairing, one must know that the adjacent sectorial transition
acts on the same Gamma lattice.  Proving the full transition equals a window
functor would be too much; it is enough to prove that it has the shadows in
(19).  Shen--Shoemaker and Gu--Yu--Yu provide these shadows one wall at a
time, so the remaining task is their two-wall compatibility, not a direct
evaluation of the rubber series.

The practical order is therefore:

1. enumerate the carrier and incidence shadows;
2. compute the finite one-leg carrier-coupling and connected pair-moment
   matrices for the surviving `(2,3)` and `(2,4)` local types and the incident
   blowup types;
3. compute the relevant spectral turning arrangement;
4. compare the numerical window shadows and solve the Euler/divisor-tag
   nullity system (19);
5. attempt a Mellin--Barnes coefficient only if all cheaper shadows
   survive.

This programme can prove the impossibility of the opposite: a hypothetical
Gold counterexample must realize *all* six shadows simultaneously.  The
named C908, Geiser, ordinary-flop, and one-wall center objects already fail at
the first or second shadow.

The cone/incidence tests are not vacuous.  The first exact survivor is
`2026-08-13-c907-minimal-neutral-toric-shadow.md`: blow up a codimension-two
toric center meeting the negative exceptional line of the point `(1,3)`
flip.  The strict line and exceptional fibre have `c_1`-degrees `-3` and
`+1`, and the neutral class has charge

\[
 (3,1,1,-1,-1,-1,-2).
\]

Its reduced GKZ shadow is the rank-three regular-singular system
`_3F_2(1,1,1/2;1/3,2/3;4q/27)`.  This proves that a connected infinite
neutral boundary tower can occur.  It remains pure-boundary and rank-zero,
and it fails the next primary low-moment shadow: its one- and two-leg
evaluation pushforwards vanish because their images lie in a fixed boundary
curve and its square.  The hypergeometric tail is a descendant/equivariant
calibration, not yet an ambient carrier-coupling row.

### Route A: vanishing/triangularity

Prove that every neutral-tail Stokes term between incident unit walls factors
through the wall-supported categories.  Equation (4) then kills it.  A
categorical version would say that the incident window transition is a
finite composition of mutations by unstable-stratum objects; rank descends
unchanged to the ambient quotient.

This is weaker than a full Gamma/Orlov/Stokes theorem: only the quotient
transition and one rank row are involved.

### Route B: a two-wall Fourier--Fubini receiver

Construct one rank-two master for the two incident unit circuits.  At every
Artin level in the remaining Novikov variables, the two orders of the
Gu--Yu--Yu Mellin--Barnes/Fourier transform are finite-dimensional integrals.
On a common absolute-convergence sector, Fubini gives equality of the two
orders; Gamma kernels and pairings factor, and the common-open point class
has zero restriction to every unstable stratum.  The resulting common
receiver makes `overline T_Y=id` on the rank row.

The bounded regression is the smallest pair of adjacent unit discrepant
toric circuits.  A failure there must exhibit the coefficient `c` in (7)
explicitly.  A success gives the local analytic lemma needed for the full
AKMW chain because all other variables remain Artin-formal.

## 6. What cannot close the gate

- Formal constant banking: it cannot identify the two sectorial embeddings.
- Good formal structure at the two-parameter corner: it sees exponential
  labels but not the Stokes coefficient `c`.
- Center-row computation: center rows are annihilated already by (4).
- The C908 theta lattice: its ordinary blowup framing contains the primitive
  exceptional identity component and does not constrain (7).
- Bare Barnes-integrality: the two cubic point coefficients prove that both
  primitive-sixth branch ranks are nonzero, but they are given only up to
  independent nonzero normalizations of the formal branches.  They do not
  determine the integral `K`-lattice rank values or an integral ratio against
  which a Stokes coefficient could be tested.  Integrality becomes a usable
  shadow only after the numerical window/Gamma comparison is supplied.
- General birational rigidity: the product has explicit relative Sarkisov
  links and lies outside known rigidity criteria.

These negatives are now useful: they certify that any proposed proof which
does not address (7)--(9) is solving the wrong problem.

## EJ / TT / AA

- **EJ:** the only dangerous number is a mixed ambient Stokes coefficient
  whose target has nonzero rank.  Pure-boundary quantum corrections vanish
  on the ambient quotient, so the source must be a carrier component with a
  negative boundary tail.
- **TT:** “formal identity modulo centers” is insufficient; the shear in (7)
  is exponentially small and lives precisely beyond the formal comparison.
- **AA:** first enumerate the smallest unit two-circuit toric models which
  admit (13).  Models with only boundary-supported `c_1=0` curves are now
  proved harmless.  For the first model with an off-boundary carrier, compute
  the two Fourier orders; a discrepancy is the exact Gold falsifier.

## Dependencies

- `2026-08-13-c907-simple-vgit-rank-theorem.md`.
- `2026-08-13-c907-ordinary-flop-point-row-theorem.md`.
- `2026-08-13-c907-k-positive-carrier-face-peak-theorem.md`.
- `2026-08-13-c907-akmw-pi-nonsingular-circuits-are-unit.md`.
- `2026-08-13-c907-peak-confluence-obstruction.md`.
