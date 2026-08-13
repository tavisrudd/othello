# C907 pair-of-pants log gluing gate

**Lane:** `clebsch`

**Status:** hostile-audited repair specification.  The pair-of-pants support
complex, global multihomogeneous graph closure, Cartier strict-transform
mechanism, and local log/control coarsening are settled.  The finite regular
refinement, all-point normality, and actual-boundary tangent ledger remain open.  The apparent extra
imbalanced packet is an artificial-face warning, not a critical scheme of the
full chart.

## Settled support mechanism

Put

\[
U=1-B,\qquad V=1-C
\tag{1}
\]

and retain $B+U=1$, $C+V=1$.  The two marked projective lines have tropical
tripods with rays $0,1,\infty$.  On their product, together with the $y$-fan
and $t=v(\delta)$, the six graph weights are

\[
0,\quad p_1,\quad p_2,\quad p_3,\quad
-p+v(B)+v(C),\quad 2t-v(U)-v(V).
\tag{2}
\]

Their pairwise-equality subdivision is a finite rational cone complex.  The
deterministic replay verifies sixteen ordered strata, ten unordered orbit
types, twelve quotient Hasse edges, and every printed local maximum formula.
This is a support statement only.

An ordinary toric fan in the original $(B,C)$ torus cannot replace it:
$B=1,C=1$ lie inside that torus, on which toric modifications are
isomorphisms.

## Global multihomogeneous graph lemma

The affine expression

\[
\delta^2YBC(L-S)-\delta^2Q-YBC(1-B)(1-C)
\tag{3}
\]

is not a global function on the marked projective lines.  Use coordinates

\[
[b_0:b_1],\quad B=b_1/b_0,
\qquad [c_0:c_1],\quad C=c_1/c_0.
\]

The exact bidegree-$(2,2)$ homogenization is

\[
\begin{aligned}
\overline P={}&
\delta^2Yb_0b_1c_0c_1(L-S)
-\delta^2Qb_0^2c_0^2\\
&-Yb_1c_1(b_0-b_1)(c_0-c_1).
\end{aligned}
\tag{4}
\]

Let $e=(1,1,1)$ and

\[
\Delta_y=\operatorname{conv}\{0,e,e+e_1,e+e_2,e+e_3\}.
\tag{5}
\]

On a smooth projective toric refinement $X_y$ of the normal fan of
$\Delta_y$, equation (4) is a section of

\[
\mathcal O_{X_y}(D_{\Delta_y})\boxtimes
\mathcal O_{\mathbf P^1_B\times\mathbf P^1_C}(2,2).
\tag{6}
\]

In a toric chart at a vertex/minimizer $m_\sigma$, trivialization by
$\chi^{m_\sigma}$ makes all five Laurent exponents regular.  At the generic
point of each divisor excluded from the dense graph domain, one term of (4)
remains nonzero.  Hence its Cartier divisor has no component supported in the
complement and is the schematic closure of the dense graph.

The dense domain removes $\delta=0$, the $y_i=0,\infty$ toric boundary, and
$B,C=0,\infty$.  It deliberately retains $B=1,C=1$.  Those translated
divisors must never be saturated away.

## Cartier strict-transform lemma

Let $\pi:\mathcal A'\to\mathcal A$ be a proper modification which is an
isomorphism over the dense graph domain.  Assume $\mathcal A'$ is regular and
its exceptional complement is SNC.  On a chart where its genuine components
have equations $x_i=0$, write

\[
\pi^*\overline P=u\prod_i x_i^{a_i}G,
\qquad
a_i=\operatorname{ord}_{x_i=0}(\pi^*D),
\tag{7}
\]

with $u$ a unit.  Then

\[
I_{\operatorname{StrTr}_\pi D}=(G)
=(\pi^*\overline P):(\prod_i x_i)^\infty.
\tag{8}
\]

Thus the strict transform is Cartier and its local generators differ by
units on overlaps.  Regularity is essential: a normalized Rees blowup alone
does not justify (8), so one takes a further regular log refinement.

Only components outside the original graph domain enter the product in (8).
The toy model $f=xy$ on $D(x)\subset\operatorname{Spec}k[x,y]$ shows why:
$(xy):x^\infty=(y)$, whereas saturating by $xy$ incorrectly gives the unit
ideal.  This is exactly the danger in dividing by every visible boundary
coordinate.

The remaining chartwise obligation is to prove that each $G$ in (7) equals
the local saturated graph equation already used by the tangent certificates,
including every new exceptional chart.  Support equality alone does not do
this.

## Imbalanced-chart regression warning

In the $Z^{-1}$ chart put

\[
r=Z^{-1},\qquad v=ZU,\qquad \delta=rh,\qquad A=Q/Y.
\tag{9}
\]

The exact potential is

\[
\Phi=S+\frac A{BC}+v-hA-r^2hAv+r^2h^2A^2,
\tag{10}
\]

with

\[
B=1-h+r^2h^2A,\qquad
C=1-r^2hv+r^2h^2A.
\tag{11}
\]

On both central components $r=0$ and $h=0$ one has
$\partial_v\Phi=1$.  Hence the full imbalanced central chart is free.

If a refinement incorrectly promotes the smooth coordinate face $v=0$ to a
log stratum, then on $r=v=0$ the restricted tangent equation factors as
$h(2-h)$.  It manufactures two reduced Morse packets:

\[
h=0,\ a^4=Q,\ L=4a,
\qquad
h=2,\ b^4=-3Q,\ L=4b.
\tag{12}
\]

Neither packet is critical for the full map because the discarded derivative
is $\partial_v\Phi=1$.  The exact decomposition is replayed in
`2026-08-12-c907-imbalanced-endpoint-audit.md`.  This is a regression test for
the stratum ledger: $v$ must remain an interior coordinate in both imbalanced
charts.

## Exact theorem still required

A valid gluing theorem must now supply the following finite data.

1. Serialize a regular integral refinement of the support complex, including
   every tie-cone, face, residual Rees cone, and exceptional residue chart.
2. Verify that it is an isomorphism over the original graph domain and does
   not mark $v=0$ in either imbalanced chart.
3. Pull back (4), compute only the genuine exceptional multiplicities in
   (7), and identify the resulting $G$ with the saturated dense-graph closure
   in every chart.
4. Map every point of the special fibre to a smoothness or $R_1+S_2$
   certificate before invoking normality.
5. Forget auxiliary translated divisors when passing from the algebraic log
   atlas to the topological control partition.  For every actual infinity or
   central-fibre control stratum $T$, form
   \[
   \Omega^1_{(G\cap T)_{\mathrm{red}}/\Delta}/\mathcal O\,dL
   \tag{13}
   \]
   after reduction and verify its chart presentations on overlaps.  Use the
   unit-direction coarsening lemma in the imbalanced charts.
6. Audit the finite genuine-stratum critical-value list and choose one fixed
   residual path neighborhood excluding all nonresidual values.

Only then may one assert properness of the graph family, absence of
nonresidual critical schemes over the path neighborhood, or begin the
fibrewise collar theorem.

## EJ/TT and mystery ledger

- **EJ:** the six-weight tripod subdivision is the support skeleton; (4) is
  the global graph; (8) is the overlap mechanism.  Keeping these three roles
  separate removes most chartwise conceptual duplication.
- **TT:** saturation follows the original graph domain, not the visual list
  of chart coordinates.  Likewise, not every coordinate zero is a log
  stratum; marking $v=0$ manufactures false critical packets.
- **Settled:** support replay; impossibility of an original-coordinate fan;
  exact multihomogeneous closure; Cartier strict-transform lemma; full-chart
  imbalanced freeness; artificial-face regression replay; local log/control
  coarsening lemma.
- **Open evidence gap:** finite regular-refinement serialization, chartwise
  strict-transform identification, all-point normality, and the complete
  genuine-stratum Fitting/value audit.
- **Open topology:** proper fibrewise collars begin only after that algebraic
  gate closes.
