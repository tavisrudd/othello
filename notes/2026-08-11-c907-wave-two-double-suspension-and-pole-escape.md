# C907 Wave 2: double suspension and pole escape

**Lane:** `clebsch`

**Date:** 2026-08-11

## Verdict

The toric codimension-two pilot now has an exact local double-suspension
model.  Its four residual critical points, local vanishing cycles, and
bounded-value logarithmic tail are the corresponding `P^3` objects.  A direct
bounded-speed horizontal transport in the fixed suspension chart is
nevertheless impossible: two explicit mixed pole channels have bounded
potential but nonintegrable parameter drift.

Thus the next analytic theorem is not another Stokes-matrix calculation.  It
is a framed relative double-suspension/excision theorem proving that the two
pole channels do not change the residual four-thimble summand.

On the invariant side, an enrichment of individual KKPYY abstract atoms is
too coarse: projective-bundle equivalence yields three copies of `J_1`, while
the endpoint requires the operation-framed Tate string `J_3`.  C907 must
enhance the atomic composition together with its projective-bundle/blow-up
operation frame.

## 1. Exact residual chart

Start from

\[
W=x_1+x_2+x_3+x_4+x_5+
\frac{Q}{x_1x_2x_3x_4x_5}+t x_4x_5.
\]

On a simply connected `t`-sector put `epsilon=t^(3/2)`,
`epsilon=delta^2`, and

\[
x_i=t^{1/2}y_i\ (i\le3),\quad
x_4=-t^{-1}+t^{1/2}z,\quad
x_5=-t^{-1}+t^{1/2}w,
\quad A=\frac Q{y_1y_2y_3}.
\]

Then exactly

\[
t^{-1/2}(W+t^{-1})
=\sum_{i=1}^3y_i+
\frac{A}{(1-\epsilon z)(1-\epsilon w)}+\epsilon zw.
\]

Set `z=-A+delta^(-1)Z`, `w=-A+delta^(-1)U`.  With

\[
B=1-\delta Z+\delta^2A,\qquad
C=1-\delta U+\delta^2A,
\]

the normalized potential is

\[
g_\delta=S+\frac A{BC}+ZU-\delta A(Z+U)+\delta^2A^2,
\qquad S=y_1+y_2+y_3,
\]

and hence

\[
g_0=f_Q(y)+ZU,\qquad
f_Q=y_1+y_2+y_3+\frac Q{y_1y_2y_3}.
\tag{DS}
\]

Taking `t=s^4`, `delta=s^3` makes this a holomorphic ramified family at
`s=0` on the fixed rescaled chart.

## 2. Local double-suspension theorem

For `a^4=Q`, the four limiting critical points are

\[
p_a=(a,a,a,0,0),\qquad g_0(p_a)=4a.
\]

Their Hessians satisfy

\[
\operatorname{Hess}_y(f_Q)=a^{-1}(I_3+J_3),\qquad
\operatorname{Hess}_{Z,U}(ZU)=
\begin{pmatrix}0&1\\1&0\end{pmatrix},
\]

so the total determinant is `-4/a^3`.  Parameterized holomorphic Morse
theory therefore gives four unique critical sections and their local
rank-one vanishing-cycle systems.  Moreover

\[
g_\delta=g_0+\delta^2
\bigl(A(Z^2+ZU+U^2)-A^2\bigr)+O(\delta^3)
\]

on compact sets, so

\[
p_a(\delta)=p_a+O(\delta^2),\qquad
g_\delta(p_a(\delta))=4a-a^2\delta^2+O(\delta^3).
\]

At `delta=0`, `(DS)` is an exact Thom--Sebastiani sum.  With the transverse
`ZU` thimble oriented to have self-Seifert pairing `+1`, the local residual
vanishing-cycle lattice is the `P^3` lattice with an even degree shift and no
extra Koszul sign.  This is a local statement; it does not yet identify the
global four escaping thimbles.

## 3. Bounded-value logarithmic tameness

Use the fixed torus variables `(y_1,y_2,y_3,B,C)` and put

\[
P=\frac A{BC},\qquad q=\delta^{-2}(1-B)(1-C).
\]

Then `F_delta` is `g_delta` after the `(Z,U)` to `(B,C)` substitution, and

\[
F_\delta=\sum_i y_i+P+q
\]

and its logarithmic derivatives are exactly

\[
D_{y_i}=y_i-P,qquad
D_B=-P-\delta^{-2}B(1-C),\qquad
D_C=-P-\delta^{-2}C(1-B).
\tag{L}
\]

### Lemma

For fixed `Q != 0` and `R`, there are a compact residual core `K` and `c>0`
such that for small `delta`

\[
|F_\delta|\le R,\quad (y,B,C)\notin K
\quad\Longrightarrow\quad
\|D_{log}F_\delta\|\ge c.
\tag{UDG}
\]

Indeed an approximate-critical Puiseux arc has `y_i/P -> 1` and
`B-C=o(delta^2)`.  If `v(P)>0`, the monomial identity forces `B,C` to grow
and `(L)` cannot vanish.  If `v(P)=0`, `(L)` forces
`B,C=1+delta^2P+o(delta^2)` and the arc remains in the four-point core.  If
`v(P)<0`, the unique balance is

\[
v(P)=-2/3,\qquad v(B)=v(C)=4/3,
\]

but then `q=delta^(-2)(1+o(1))` cannot be cancelled by the terms of order
`delta^(-2/3)`.  Real-semialgebraic curve selection on a ramified sector
turns a countersequence into such an arc.

There is also a global algebraic estimate

\[
|q|\le C_Q\bigl(1+|F_\delta|+\|D_{log}F_\delta\|\bigr).
\tag{Q}
\]

If `(Q)` failed after division by `q`, `(L)` would give
`P/q -> -1/4` and `P^4BC -> Q`, hence `BC -> 0`; but the two remaining
derivatives give `B/(1-B),C/(1-C) -> 1/4`, hence `B,C -> 1/5`, a
contradiction.

Consequently `(UDG)` and `(Q)` give complete logarithmic value-horizontal
lifts on bounded regular-value windows, outside the fixed critical core, for
parameter intervals bounded away from `delta=0`.  They give neither a family
lift across `delta=0` nor a lift over a window containing the four critical
values.

## 4. Exact pole-escape obstruction

The fixed suspension chart has

\[
g_\delta=g_0+\delta^2R_\delta,
\]

but the apparent `delta^2` gain is not uniform at its moving poles.  Fix
`y=y_0`, put `a=A(y_0)`, `s=S(y_0)`, choose
`u` outside `{0,1,1/2}` with `u^2-u-1 != 0`, and set

\[
c=1-u,\qquad b=-\frac a{uc},\qquad
U=\frac u\delta,\qquad
Z=\delta^{-1}+\delta(a-b).
\]

Then

\[
B=\delta^2b,\qquad C=c+\delta^2a
\]

and exactly

\[
g_\delta=s+\frac{ua}{c+\delta^2a}-a-ub+\delta^2ab,
\]

so the potential remains bounded.  In the product metric that is logarithmic
in `y` and Euclidean in `Z,U`, all leading coefficients below are nonzero:

\[
\|dg_\delta\|
\sim\left|\frac a{b^2c}\right||\delta|^{-3},\qquad
\partial_\delta g_\delta
\sim\frac a{b^2c}\delta^{-5}.
\]

Thus

\[
\frac{|\partial_\delta g_\delta|}{\|dg_\delta\|}
\asymp|\delta|^{-2}.
\tag{P}
\]

Every lift `V_delta` with
`dg_delta(V_delta)=-partial_delta g_delta` therefore has norm at least the
ratio in `(P)`.  In logarithmic time its norm is at least order
`|delta|^(-1)`, so no endpoint-integrable bounded-speed lift exists in this
product metric.  That metric is incomplete at the removed divisors `B=0` and
`C=0`; the conclusion does not exclude a complete adapted metric or
compactification.  Interchanging `Z,U` gives the second pole channel.

Moreover the limiting value of the channel is

\[
L_{y_0}(u)=S(y_0)+\frac{2A(y_0)u}{1-u}.
\]

At a residual critical point `y_0=(a,a,a)`, choosing `u=1/3` gives
`L_(y_0)(u)=4a` with nonzero derivative in `u`.  Hence these pole channels
fill neighborhoods of every residual critical value; target paths cannot
avoid them merely by shrinking their value domains.

This is not a new critical point: `(UDG)` still holds in the fixed torus
metric.  The result proves total-family nonproperness over the residual value
window and kills the direct endpoint-lift bridge.  It does not prove that the
pole end contributes nonzero rapid-decay homology or changes a Stokes matrix;
an adapted compactification or relative-boundary excision may still remove it.

## 5. Minimum sufficient analytic theorem

Let `Omega_delta` isolate the four residual critical values and `U_delta`
their local suspension neighborhoods.  For the outgoing rapid-decay boundary
`A_delta^phi`, the required theorem must prove:

1. uniform admissible residual paths with no residual/ambient braid;
2. excision of both pole channels and vanishing of the outside terms in the
   triple sequence
   \[
   H_6(M,U_\delta\cup A_\delta^\phi)\to
   H_5(U_\delta,U_\delta\cap A_\delta^\phi)\to
   H_5(M,A_\delta^\phi)\to
   H_5(M,U_\delta\cup A_\delta^\phi);
   \]
3. oriented Thom--Sebastiani compatibility for directed thimbles, not only
   their symmetric intersection form; and
4. identification of the transported basis with Iritani's Orlov/Gamma basis.

Only then is the marked residual Stokes matrix the `P^3` Beilinson matrix

\[
\begin{pmatrix}
1&4&10&20\\
0&1&4&10\\
0&0&1&4\\
0&0&0&1
\end{pmatrix}.
\]

The pole arc `(P)` kills a proof by unqualified global horizontal transport;
it does not yet show that either pole channel contributes to the residual
relative homology.

## 6. Correct invariant level

KKPYY Proposition 5.22 maps abstract `G`-atoms to geometric atomic
`F`-bundle classes.  A statistic already defined on Definition 5.21 geometric
classes pulls back without re-proving the elementary equivalences.  But such
an atomwise statistic is too weak:

\[
P^2\text{-bundle additivity gives }J_1^{\oplus3},
\qquad C907\text{ needs }J_3.
\]

The minimum candidate is therefore an operation-framed atomic composition

\[
(V_\alpha,F^{St},\mathcal R,N,\mu),
\]

with a Tate-string lift for projective bundles and a strict biproduct lift for
blow-ups.  KKPYY supplies the ungraded local copies, not the Rees string,
Stokes mutation frame, Gamma lattice, or coherent operation lifts.

Bare primitive-sixth formal support may still descend atomwise if it is
proved constant on each connected spectral-cover component in Definition
5.21.  Proposition 5.23 proves constancy of the `u=0` representation, not
HLT residue support; this support-descent lemma remains open.  Conditional on
it, support is empty for every smooth threefold birational to a smooth
nef-canonical threefold or to a projective bundle over a base of dimension at
most two.  This prunes zero-support carriers but proves no enriched length
bound for a nonempty carrier.

## EJ/TT closeout

- **EJ:** the second rescaling exposes an exact double suspension, not merely
  matching critical values; `(UDG)` and `(Q)` close all bounded-value
  asymptotic-critical escapes.
- **TT:** local Morse equivalence, intersection forms, and fiberwise tameness
  still do not determine a marked Stokes matrix.  The explicit pole arc is
  the hostile test that rejects that jump.

## Mystery ledger

- **Settled:** exact local residual `P^3+ZU` model and its four Morse sections.
- **Settled:** no bounded-value logarithmic approximate-critical escape.
- **Settled negatively:** direct bounded-speed endpoint transport in the fixed
  suspension chart is not integrable because of two explicit pole channels.
- **Open, analytic:** excise or calculate those channels in rapid-decay
  relative homology and identify the resulting directed thimbles with the
  Orlov/Gamma basis.
- **Open, definition:** construct the operation-framed Tate/Stokes/Rees lift;
  atomwise enrichment cannot calibrate the endpoint.
- **Open, support:** prove HLT support constant on Definition 5.21 connected
  atom components.
- **Open, carrier:** control nonempty-support non-nef threefold centers in the
  operation frame.

## Sources

- Iritani, arXiv:1906.00801, Theorem 7.5, Remark 7.6, Lemma 7.24, and
  Sections 7.4.1--7.4.5.  Cached SHA-256:
  `dc25e5cbd849ee5daa7643d69ae2e77936d5cd343ceb66ce8bbd8e03fbf874c7`.
- KKPYY, arXiv:2508.05105v2, Theorems 4.5 and 4.11, Definition 5.21,
  Propositions 5.22--5.23, Remark 3.14, and Claim 6.15.  Cached SHA-256:
  `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`.

No finite computation or Gamma conjecture is used in this report.
