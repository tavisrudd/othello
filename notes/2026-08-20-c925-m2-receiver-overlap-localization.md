# Module 39. Receiver-overlap localization for the \(m=2\) obstruction

**Packet part:** Module 39.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** abstract overlap/cocycle theorem proved; the fivefold reduction is
proved from the named C907 wall inputs; the surviving two-wall geometric
transition remains open

## 39.1 Why the one-center formulation is too large

The one-arrow formal-Novikov receiver already proves the full ambient-rank
law for a discrepant wall in its own sectorial realization.  In particular,
the local theorem does not require classification of all QDMs of smooth
threefold centers.  The obstruction appears only when the same intermediate
fivefold is realized by the receivers of two incident walls.

This changes the \(m=2\) question from

\[
\text{can one threefold center reproduce the source triple?}
\tag{39.1}
\]

to the smaller question

\[
\text{can a transition between two incident wall receivers move the
primitive packet into a rank-visible ambient direction?}
\tag{39.2}
\]

The distinction is load-bearing.  A center-supported correction has rank
zero and is harmless.  A transition which is formally the identity may still
have an exponentially small ambient-to-ambient Stokes shear, so formal QDM
splitting alone does not answer (39.2).

## 39.2 Typed receiver path

Let

\[
Y_0\dashleftarrow Y_1\dashrightarrow\cdots\dashrightarrow Y_n
\tag{39.3}
\]

be one chosen factorization path with \(n\ge1\), with edges \(e_i\) for
\(1\le i\le n\), and orient \(-\) to \(+\) in the traversal direction.

For each endpoint of an edge receiver, first choose the stabilized full
realization \(W_i^\pm\) supplied by the one-arrow direct-sum theorem and its
row-null supported/center span \(C_i^\pm\).  Put

\[
V_i^\pm=W_i^\pm/C_i^\pm.
\tag{39.3a}
\]

Let \(q_i^\pm:W_i^\pm\to V_i^\pm\) be the quotient maps.  The quotient must
carry explicit endpoint certificates

\[
P_i^\pm=q_i^\pm(P_{i,\mathrm{full}}^\pm),
\qquad
\widetilde r_i^\pm=r_i^\pm q_i^\pm,
\qquad
\widetilde r_i^\pm\big|_{P_{i,\mathrm{full}}^\pm}\ne0
\Longleftrightarrow
r_i^\pm\big|_{P_i^\pm}\ne0.
\tag{39.3b}
\]

Write those quotient packages as

\[
(V_i^-,P_i^-,r_i^-),\qquad (V_i^+,P_i^+,r_i^+)
\tag{39.4}
\]

Here \(P_i^\pm\subset V_i^\pm\) is the formal primitive-sixth packet in that
ambient-quotient realization and
\(r_i^\pm:V_i^\pm\to K\) is the Gamma rank row.  The one-arrow provider gives
an induced ambient-quotient isomorphism

\[
J_i:V_i^-\overset\sim\longrightarrow V_i^+
\tag{39.5}
\]

which transports the named primitive packet and satisfies

\[
r_i^+J_i=c_i r_i^- ,\qquad c_i\in K^\times.
\tag{39.6}
\]

At the shared geometric vertex between \(e_i\) and \(e_{i+1}\), the two
incident receiver stabilizations need not be identical.  A typed overlap
first needs a full comparison which carries the left supported span to the
right supported span; only then does it induce an ambient-quotient
isomorphism

\[
T_i:V_i^+\overset\sim\longrightarrow V_{i+1}^-,
\qquad T_i(P_i^+)=P_{i+1}^-.
\tag{39.7}
\]

It is **rank-safe** if

\[
r_{i+1}^-T_i=d_i r_i^+,
\qquad d_i\in K^\times.
\tag{39.8}
\]

This is the exact adjacent-reindexing field required by Module 34.  Merely
giving two receiver records for the same variety does not construct (39.7).
Nor may one silently quotient a comparison which fails to preserve the
supported spans.  An arbitrary quotient isomorphism does not imply (39.8).

Set \((P_0,r_0)=(P_1^-,r_1^-)\) and
\((P_n,r_n)=(P_n^+,r_n^+)\) for the two endpoint packages.

### Theorem 39.1 -- overlap localization

If every edge satisfies (39.6) and every overlap satisfies (39.8), then

\[
r_n\big|_{P_n}\ne0
\quad\Longleftrightarrow\quad
r_0\big|_{P_0}\ne0.
\tag{39.9}
\]

More precisely, the alternating composite of the \(J_i\) and \(T_i\) is an
isomorphism of primitive packets and scales the endpoint row by

\[
c_{\rm path}
=\prod_{i=1}^{n}c_i\prod_{i=1}^{n-1}d_i\in K^\times.
\tag{39.10}
\]

#### Proof

Compose (39.6) and (39.8) in path order.  Every factor transports the named
packet, and the row scalars multiply.  Nonzero scalar multiplication cannot
change whether the restricted row is zero.  \(\square\)

Thus the local edge theorem has already done its job.  Every remaining defect
lives at a receiver overlap \(T_i\).

## 39.3 The defect is a crossed Writer cocycle

On one fixed receiver space \(V\), let \(G\leq\operatorname{GL}(V)\), fix a
row \(r\), and fix a multiplicative
normalization character

\[
\lambda:G\longrightarrow K^\times.
\tag{39.11}
\]

For a transition \(g\in G\), define its row defect

\[
\delta(g)=rg-\lambda(g)r\in V^*.
\tag{39.12}
\]

### Proposition 39.2 -- crossed Writer law

For \(g,h\in G\),

\[
\delta(gh)=\delta(g)h+\lambda(g)\delta(h).
\tag{39.13}
\]

In particular, the rank-safe transitions form the kernel of \(\delta\), hence
a subgroup.

#### Proof

Expand:

\[
\begin{aligned}
\delta(gh)
&=rgh-\lambda(g)\lambda(h)r\\
&=(rg-\lambda(g)r)h
  +\lambda(g)(rh-\lambda(h)r).
\end{aligned}
\]

This is (39.13).  \(\square\)

For the varying-space path, the typed formula is separate.  Let
\(g:A\to B\), \(h:B\to C\), choose rows \(r_A,r_B,r_C\), and choose nonzero
scalars with \(\lambda_{hg}=\lambda_h\lambda_g\).  Define

\[
\delta(g)=r_Bg-\lambda_g r_A\in A^*,
\qquad
\delta(h)=r_Ch-\lambda_h r_B\in B^*.
\tag{39.13a}
\]

Then

\[
\delta(hg)=\delta(h)g+\lambda_h\delta(g)\in A^*.
\tag{39.13b}
\]

This follows by inserting and subtracting \(\lambda_h r_Bg\).  Formula
(39.13b), rather than an untyped identification of the dual spaces, is the
crossed Writer law consumed by a receiver path.

The defect is therefore State-plus-Writer data, not an additive invariant of
untyped matrices.  Individual nonzero defects can cancel in (39.13); local
vanishing is sufficient and compositional, but it is not logically
necessary for one fixed path.

## 39.4 Center-supported changes are quotient-trivial

Let \(C\subseteq V\) be a transition-invariant subspace with \(r(C)=0\), and
write \(\bar V=V/C\).  Suppose

\[
g=a+k,
\qquad \operatorname{im}k\subseteq C,
\qquad ra=\lambda(g)r.
\tag{39.14}
\]

Then \(\delta(g)=0\).  Equivalently, it is enough that the induced transition
on \(\bar V\) be rank-safe and that \(g\) preserve \(C\).

The occurrence-typed version uses the full stabilized receiver spaces and
possibly different supported spans:

\[
C_L\subseteq W_L,\qquad C_R\subseteq W_R,\qquad
\widetilde r_L(C_L)=\widetilde r_R(C_R)=0.
\tag{39.14a}
\]

If \(\widetilde T(C_L)=C_R\) and the induced isomorphism
\[
\bar T:W_L/C_L\longrightarrow W_R/C_R
\tag{39.14b}
\]
satisfies \(\bar r_R\bar T=c\bar r_L\), then
\(\widetilde r_R\widetilde T=c\widetilde r_L\).  This follows immediately by
precomposing the quotient-row equality with \(W_L\to W_L/C_L\).

This includes products and inverses of mutations whose correction terms have
image in the span of exceptional/unstable-stratum Gamma classes.  Those
classes have ordinary rank zero.  It does **not** include an arbitrary map
which merely factors through a center object: the final image must remain in
the row-null supported subspace.

Consequently, after supported-span compatibility has been proved, a
dangerous overlap must induce a nontrivial map on the ambient quotient.  If
that compatibility fails, center-to-ambient leakage is itself an additional
overlap defect and cannot be discarded.  In the quotient rank-two normal
form, the remaining danger contains a shear

\[
v\longmapsto v+a w,
\qquad
v\in P_6,\quad r(v)=0,\quad r(w)\ne0,\quad a\ne0.
\tag{39.15}
\]

This is the smallest exact countermodel.  It is formally invisible if the
coefficient is exponentially small, but it changes the Boolean consumer.

## 39.5 Discrepancy-run compression

Mark each edge of (39.3) as ordinary \(O\) or discrepant \(D\).  Import the
following audited C907 inputs:

1. ordinary walls have an intrinsic point-row comparison and need no
   receiver choice;
2. every discrepant unit wall has the one-arrow rank law (39.6) in its
   fixed-sector receiver; and
3. an overlap incident to an ordinary wall is compatible with that intrinsic
   normalization.

### Corollary 39.2A -- only \(D\)-\(D\) overlaps remain

Under these inputs, every unresolved \(T_i\) lies between two consecutive
discrepant edges.  A maximal run of \(\ell\) discrepant edges contributes at
most \(\ell-1\) overlap defects.  In particular, an isolated discrepant wall
is already safe.

#### Proof

Every overlap of type \(O\)-\(O\), \(O\)-\(D\), or \(D\)-\(O\) is rank-safe by
the intrinsic normalization input.  Only the internal overlaps of a maximal
\(D\)-run remain, and a run of \(\ell\) edges has \(\ell-1\) internal
vertices.  \(\square\)

This is a genuine bypass of the proposed universal classification of
threefold-center QDMs.  The new \(m=2\) carrier is handled one wall at a time
by the existing rank receiver.  What remains is a two-wall supported-span
compatibility and ambient-quotient holonomy theorem.

## 39.6 The neutral-slope sieve in dimension five

The audited C907 carrier-face theorem makes a two-wall peak safe when it has
a \(P_6\)-faithful exposed rational-polyhedral carrier face, strict
\(c_1\)-positivity on the **whole** face, and the required oriented
nonturning path.  Positivity on the two wall rays alone is insufficient
because it may discard the cubic carrier variables.

Independently, a dangerous infinite transition in the remaining reduction
needs a mixed affine effective tower whose recession direction is
\(c_1\)-neutral.  The arithmetic below is therefore a necessary sieve, not a
common-receiver theorem.

Let a two-ray face have primitive effective generators
\(\ell_+,\ell_-\) with

\[
c_1(\ell_+)=a>0,
\qquad
c_1(\ell_-)=-b<0.
\tag{39.16}
\]

### Proposition 39.3 -- unique primitive neutral slope

The nonnegative solutions of

\[
a x-b y=0
\tag{39.17}
\]

are the multiples of

\[
(x_0,y_0)
=\left(\frac b{\gcd(a,b)},\frac a{\gcd(a,b)}\right).
\tag{39.18}
\]

If the two \(c_1\)-degrees have the same strict sign, there is no nonzero
nonnegative neutral solution.

#### Proof

Write \(a=g a'\), \(b=g b'\) with \(\gcd(a',b')=1\).  Equation (39.17) gives
\(a'x=b'y\), hence \(b'\mid x\), \(a'\mid y\), and
\((x,y)=n(b',a')\).  The same-sign assertion is immediate.  \(\square\)

For unit walls in a fivefold, the audited wall classification gives absolute
discrepancy magnitudes in

\[
\{1,2,3,4\}.
\tag{39.19}
\]

Therefore every two-ray neutral slope belongs to the finite ordered list

\[
(1,1),\ (2,1),\ (1,2),\ (3,1),\ (1,3),\
(4,1),\ (1,4),\ (3,2),\ (2,3),\ (4,3),\ (3,4).
\tag{39.20}
\]

Up to exchanging the two walls there are six types:

\[
(1,1),\ (2,1),\ (3,1),\ (4,1),\ (3,2),\ (4,3).
\tag{39.21}
\]

The list is only a numerical sieve.  A slope is dangerous only if it is
realized by an infinite effective tower, has a connected boundary incidence
path, couples to the cubic primitive packet, survives the quotient by all
supported wall blocks, and lands in a rank-visible ambient direction.

## 39.7 Corrected \(m=2\) endgame

Combine the source and endpoint inputs already audited in Modules 33--35
with the C907 wall inputs above.

### Theorem 39.4 -- conditional two-wall \(m=2\) theorem

Assume that for every hypothetical birational map

\[
X\times\mathbf P^2\dashrightarrow\mathbf P^5
\tag{39.22}
\]

there is one admitted unit-wall factorization such that every consecutive
discrepant overlap satisfies either:

1. its transition is generated by corrections with image in the
   current center-supported rank-zero span, every full factor carries that
   current span onto the next supported span, and every induced ambient
   normalizing factor is rank-safe;
2. its peak admits the full \(P_6\)-faithful \(K\)-positive carrier face and
   oriented-path data of the imported carrier-face theorem;
3. both transition gauges solve the same Hom-system, have the same formal
   identity asymptotic, and are multisummed on one common nonturning sector
   in the uniqueness aperture; or
4. its full overlap comparison \(\widetilde T_i\) carries the actual
   row-null supported span \(C_i^+\) onto \(C_{i+1}^-\), and its induced
   quotient map satisfies
   \[
   \bar r_{i+1}^-\bar T_i=d_i\bar r_i^+,
   \qquad d_i\in K^\times.
   \tag{39.22a}
   \]

Then \(X\times\mathbf P^2\) is irrational.

#### Proof

Each condition makes the overlap rank-safe: respectively by Section 39.4,
the imported carrier-face theorem, uniqueness of multisummation in the common
receiver, or definition.  Corollary 39.2A then supplies every overlap law
required by Theorem 39.1.  The nonzero cubic-product source row would
telescope to the zero projective endpoint row, a contradiction.  \(\square\)

The theorem does not assume that arbitrary threefold centers lack cubic
QDMs.  Nor does it require a single positive charge cone for higher-
codimension centers.  At consecutive discrepant walls it asks for
supported-span compatibility and then the actual ambient-quotient
transition.

## 39.8 The exact surviving geometric object

Apart from failure of supported-span compatibility, the previous C907
reduction shows that a remaining ambient-quotient failure requires more than
a center packet or a neutral boundary series.  It requires:

1. two incident discrepant unit walls of opposite \(c_1\)-orientation;
2. an infinite affine effective tower with one of the slopes (39.20);
3. a connected mixed boundary incidence path;
4. an off-boundary carrier coupling from the primitive-sixth packet; and
5. a resulting ambient target \(w\) with \(r(w)\ne0\), as in (39.15).

Before this ambient list applies, the overlap must also preserve the
supported span.  Failure there is the separate center-to-ambient leakage
case isolated in Section 39.4.

Pure-boundary towers, ordinary flop directions, isolated wall packets, and
mutations by unstable-stratum objects fail the last two tests and are
rank-safe.  The smallest known genuine neutral toric tower is still
pure-boundary and its primary one- and two-leg pushforwards vanish; it is a
calibration, not a counterexample.

Thus the next calculation is not “classify all smooth threefold centers.”
It is the finite family of mixed two-wall boundary-to-ambient coupling
shadows in (39.20), beginning with the smallest opposite-sign unit pair.

## 39.9 Executable calibration

The shared finite replay verifies:

- the crossed Writer identity (39.13) on nontrivial row defects;
- the equality between \(D\)-\(D\) adjacency count and the sum of
  \(\ell-1\) over maximal discrepant runs;
- quotient-triviality of products of center-image mutations;
- the rank-two ambient-target shear (39.15); and
- the complete arithmetic list (39.20), together with the absence of
  same-sign nonnegative neutral solutions.

These are finite algebraic witnesses only.  They do not construct a
sectorial overlap or an effective neutral tower.

## 39.10 Source and scope audit

The geometric inputs are imported, not re-proved here, from:

- notes/2026-08-13-c907-formal-novikov-sectorial-receiver.md;
- notes/2026-08-13-c907-ordinary-flop-point-row-theorem.md;
- notes/2026-08-13-c907-simple-vgit-rank-theorem.md;
- notes/2026-08-13-c907-akmw-pi-nonsingular-circuits-are-unit.md;
- notes/2026-08-13-c907-k-positive-carrier-face-peak-theorem.md; and
- notes/2026-08-13-c907-remaining-mixed-stokes-shear-gate.md.

The abstract overlap theorem, crossed Writer law, discrepancy-run count, and
neutral-slope arithmetic are proved in this module.  No theorem cited above
proves the surviving mixed ambient transition is rank-safe.

## 39.11 EJ/TT and mystery ledger

**EJ.** The right state is a receiver atlas: edge providers are local charts,
overlap maps are explicit state transitions, and the row defect is a crossed
Writer cocycle.  The consumer does not need a globally canonical chart; it
needs the overlaps to reduce to the rank stabilizer.

**TT.** Do not ask a center-only invariant to solve a two-wall holonomy
problem.  Conversely, do not call an arbitrary center factor harmless: its
correction must have supported/rank-zero **image**, or its ambient quotient
must be checked.

| question | status | exact evidence or gate |
|---|---|---|
| Does the one-arrow receiver already handle an isolated discrepant wall? | **yes, from imported inputs** | Corollary 39.2A |
| Where can the telescope still fail? | **only at consecutive discrepant receiver overlaps** | Theorem 39.1 and Corollary 39.2A |
| What is the first overlap gate? | **supported-span compatibility** | (39.14a)--(39.14b) |
| Is the defect compositional? | **yes, as a crossed cocycle** | Proposition 39.2 |
| Are center-image mutations harmless? | **yes** | (39.14) and rank zero |
| Are arbitrary maps through a center harmless? | **no** | target image can return to a rank-visible ambient line |
| Can a same-sign two-ray face carry a neutral tower? | **no** | Proposition 39.3 |
| Is the list of fivefold two-ray slopes finite? | **yes** | (39.19)--(39.21) |
| Does this prove \(m=2\)? | **no** | mixed boundary-to-ambient coupling remains open |

## Boundary

The universal threefold-center transport lemma and the arbitrary
relative-cap point-purity lemma are not consumed by this conditional
rank-row route.  The \(m=2\) obstruction localizes to consecutive discrepant
receiver overlaps.  Each such overlap must first preserve its row-null
supported span; after that gate and the existing sieves, the remaining
obstruction is one mixed \(c_1\)-neutral ambient-to-ambient Stokes shear.  No
unconditional \(m=2\) theorem follows.
