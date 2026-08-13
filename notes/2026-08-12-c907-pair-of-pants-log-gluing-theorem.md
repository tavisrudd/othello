# C907 pair-of-pants log gluing gate

**Lane:** `clebsch`

**Status:** hostile audit of the proposed global gluing theorem.  The
pair-of-pants support complex and a global multihomogeneous graph closure
survive.  Normality coverage and reduced-stratum tangent-Fitting gluing do
not; an exact imbalanced endpoint produces four additional stratum-critical
points.  This note is a repair specification, not a theorem.

## Settled support mechanism

Put

\[
U=1-B,\qquad V=1-C
\tag{1}
\]

and retain the equations $B+U=1$, $C+V=1$.  The two marked projective lines
have tropical tripods with rays $0,1,\infty$.  On their product, together
with the $y$-fan and $t=v(\delta)$, the six graph weights are

\[
0,\quad p_1,\quad p_2,\quad p_3,\quad
-p+v(B)+v(C),\quad 2t-v(U)-v(V).
\tag{2}
\]

Their pairwise-equality subdivision is a finite rational cone complex.  The
deterministic replay verifies sixteen ordered strata, ten unordered orbit
types, twelve quotient Hasse edges, and every printed local maximum formula.
This is a support statement only.

An ordinary toric fan in the original $(B,C)$ torus cannot replace this
complex: $B=1$ and $C=1$ lie in the torus, on which every toric modification
is an isomorphism.

## Global graph closure must be multihomogeneous

The affine expression

\[
\delta^2YBC(L-S)-\delta^2Q-YBCUV
\tag{3}
\]

is not itself a global function on the marked projective lines.  Write
$B=b_0/b_\infty$ and $C=c_0/c_\infty$.  After clearing the two projective
denominators, the exact bidegree-$(2,2)$ expression is

\[
\begin{aligned}
\widetilde P={}&
\delta^2Yb_0c_0b_\infty c_\infty(L-S)
-\delta^2Qb_\infty^2c_\infty^2\\
&-Yb_0c_0(b_\infty-b_0)(c_\infty-c_0).
\end{aligned}
\tag{4}
\]

On a complete toric $y$-model, choose one torus-invariant divisor whose
polytope contains the exponent support of the terms in (4).  Toric
homogenization then makes (4) a section of that line bundle tensored with
$\mathcal O(2,2)$ on the marked-line factors.  Its schematic closure, or
equivalently the contraction of the dense graph closure, is the correct
global object.

On a regular log modification the total transform of this section is
Cartier.  Subtracting its divisorial boundary multiplicities gives a global
Cartier strict transform; local equations therefore differ by units.  What
remains to be proved is that this Cartier strict transform is the desired
saturated dense-graph closure in every exceptional chart and is normal near
the full special fibre.  The ten support types do not enumerate all tie-cones,
their faces, or exceptional residue charts, so they do not yet prove this.

## Exact failure of the global-Fitting shortcut

In the $Z^{-1}$ imbalanced residual chart put

\[
r=Z^{-1},\qquad v=ZU,\qquad \delta=rh,\qquad A=Q/Y.
\tag{5}
\]

Direct substitution gives

\[
B=1-h+r^2h^2A,\qquad
C=1-r^2hv+r^2h^2A
\tag{6}
\]

and, on $r=0$,

\[
L=S+\frac{A}{1-h}+v-hA.
\tag{7}
\]

Only the deeper face $r=h=0$ is $f_Q+v$.  On the deeper reduced stratum
$r=v=0$, the tangent equations from (7) are

\[
\partial_hL=A\left((1-h)^{-2}-1\right)=0,
\qquad
\partial_{y_i}L=0.
\tag{8}
\]

They have two branches:

\[
\begin{array}{c|c|c}
h&y_1=y_2=y_3&L\\ \hline
0&a,\ a^4=Q&4a\\
2&b,\ b^4=-3Q&4b.
\end{array}
\tag{9}
\]

The first row is the intended residual locus.  The second consists of four
additional stratum-critical points at $(B,C)=(-1,1)$.  The symmetric
$U^{-1}$ chart gives the exchanged branch.

This also supplies a concrete categorical error in the discarded proof.
On the parent stratum $r=0$, $dv$ is a unit cotangent direction, so the
relative critical ideal is the unit ideal.  Passing to the deeper reduced
stratum $v=0$ removes that normal direction and reveals (9).  Consequently

\[
\Omega^1_{(\mathcal G\cap T)_{\mathrm{red}}/\Delta}/
\mathcal O\,dL
\tag{10}
\]

is not obtained by localizing one global module on $\mathcal G$.  Fitting
ideals commute with localization, but reduction and passage to a boundary
stratum do not commute with the shortcut that was proposed.

The two value sets in (9) are disjoint for $Q\ne0$.  A residual path
neighborhood can therefore be chosen to contain the intended four paths and
exclude the four $h=2$ values.  That observation removes this particular
branch from the value-localized graph, but it is not a completeness proof:
every endpoint and exceptional stratum must first be audited to obtain the
full finite excluded-value list.

## Exact theorem still required

A valid gluing theorem must supply all of the following.

1. Serialize a regular integral refinement of the support complex, including
   every tie-cone, face, residual Rees cone, and exceptional residue chart.
2. Pull back the multihomogeneous section (4), compute its divisorial
   multiplicities, and verify chartwise that the resulting Cartier strict
   transform equals the saturated dense-graph closure.
3. Map every point of the special fibre to an explicit smoothness or
   $R_1+S_2$ certificate before invoking normality.
4. For every global log stratum $T$, form the reduced-stratum module (10)
   independently and verify its presentations on chart overlaps.
5. Audit every seam endpoint, including (9) and its symmetric copy, and choose
   one fixed residual path neighborhood excluding the resulting finite set of
   nonresidual values and all ambient critical values.

Only after these five items may one assert properness of the graph family,
absence of nonresidual critical schemes over the chosen value neighborhood,
or begin the collar theorem.

## EJ/TT and mystery ledger

- **EJ:** the six-weight tripod subdivision is the finite support skeleton,
  while (4) is the correct global graph object; these two constructions solve
  different problems and should not be conflated.
- **TT:** a unit normal derivative on a parent stratum says nothing about the
  reduced critical scheme after that normal coordinate is set to zero.  The
  $h=2$ branch is the smallest exact counterexample.
- **Settled:** support-complex existence and replay; impossibility of an
  original-coordinate toric fan; multihomogeneous form of the graph closure;
  exact $h=0,2$ endpoint calculation.
- **Refuted:** automatic reduced-stratum Fitting gluing from one global
  cotangent module; the claim that the imbalanced endpoint contains only the
  four residual points.
- **Open evidence gap:** finite exceptional-chart serialization, saturated
  strict-transform equality, all-point normality, and the complete
  stratumwise Fitting/endpoint audit.
- **Open topology:** proper fibrewise collars begin only after that algebraic
  gate closes.
