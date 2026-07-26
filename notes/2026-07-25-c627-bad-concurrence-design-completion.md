# C627: bad-concurrence packing deficiency and carrier baseline

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** complete positive.  The maximum concurrence centres of an arc form
a packing by maximum matching cliques.  The prescribed-hole defect is at least
the number of blocks by which this packing falls short of a full matching
design.  A packing cannot be exactly one block short: its leave is forced to
be the missing maximum matching.  Therefore abstract nonexistence of
\(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) gives the quantitative gap
\[
 \Delta_{\mathcal H}(A)\ge2.
\]
The same analysis gives an exact completion criterion and a robust
per-secant carrier-triple baseline.  The local conductor covariant is
automatically nonzero on every triple above an arc secant, including genuine
zero-defect hyperovals; carrier nonvanishing alone therefore cannot improve
the defect bound.

The paper-facing finite-graph and defect-transfer spine is now formalized in
`lean/RelativeConicArcs/MatchingPackingDefect.lean` and
`lean/RelativeConicArcs/MatchingPackingDefectBridge.lean`.  No manuscript file
is changed.

## Matching-packing setup

Let \(A\) be a \(k\)-arc, put
\[
 m=\left\lfloor\frac k2\right\rfloor,
 \qquad
 E_0=3\binom{k}{4},
 \qquad
 C_m=\binom m2,
\]
and suppose
\[
 v=\frac{E_0}{C_m}
\]
is an integer.  The vertices of \(KG(k,2)\) are the secants indexed by
two-subsets of \(A\).  Its edges are partitioned by concurrence centres:
a centre of secant index \(r\) contributes one clique \(K_r\).

Let \(b\) be the number of maximum centres, those with \(r=m\), and let
\[
 B=\sum_{2\le r(x)<m}\binom{r(x)}2
\]
be the number of bad Kneser edges.  The exact clique partition gives
\[
 \boxed{\quad
 B=(v-b)C_m.\quad}
\]

The \(b\) maximum-centre cliques are pairwise edge-disjoint \(K_m\)'s in
\(KG(k,2)\).  Equivalently, they are a packing of \(b\) maximum matchings of
\(K_k\), with no pair of independent edges repeated.

Let \(p(k,m)\) be the maximum number of blocks in such a packing.  Then
\[
 b\le p(k,m)\le v.
\]
Equality \(p(k,m)=v\) is exactly existence of an abstract
\(\operatorname{MATCH}(k,m,1)\) design.

## Packing-deficiency transfer

Write
\[
 S=m\Delta_{\mathcal H}(A)
\]
for the integer-normalized prescribed-hole defect.  C558's bad-edge theorem
is
\[
 2B\le(m-1)S.
\]
Since \(2C_m=m(m-1)\), the exact expression for \(B\) gives
\[
 m(v-b)\le S.
\]
Using \(b\le p(k,m)\) yields the main transfer:
\[
 \boxed{\quad
 m\bigl(v-p(k,m)\bigr)\le S,
 \qquad
 v-p(k,m)\le\Delta_{\mathcal H}(A).\quad}
\]

Thus every abstract packing deficiency is automatically a geometric defect
gap.  This is stronger than treating bad edges only as a set to delete: it
identifies the exact missing-block parameter measured by the defect.

## A packing cannot be one block short

### Lemma

Assume \(k=2m\) or \(k=2m+1\), \(m\ge2\), and \(v\) is integral.  If
\(KG(k,2)\) has a packing of \(v-1\) maximum-matching cliques, then it has a
packing of \(v\) such cliques.

### Proof

Let \(L\) be the leave graph after removing the edges in the \(v-1\) selected
cliques.  It has exactly
\[
 |E(L)|=C_m
\]
edges.  Every vertex of \(KG(k,2)\) has degree
\[
 \binom{k-2}{2}
 =
 \begin{cases}
   (m-1)(2m-3),&k=2m,\\
   (m-1)(2m-1),&k=2m+1.
 \end{cases}
\]
Every selected \(K_m\) containing a vertex removes \(m-1\) incident edges.
Hence every positive degree in \(L\) is a multiple of \(m-1\).

Let \(W\) be the set of positive-degree vertices of \(L\).  Since
\[
 \sum_{e\in W}\deg_L(e)=2C_m=m(m-1),
\]
and every term is at least \(m-1\), one has \(|W|\le m\).  On the other hand,
for \(e\in W\),
\[
 m-1\le\deg_L(e)\le|W|-1,
\]
so \(|W|\ge m\).  Therefore \(|W|=m\), every degree is \(m-1\), and
\[
 L=K_m.
\]
Because \(L\) is a subgraph of \(KG(k,2)\), its \(m\) vertices are pairwise
disjoint edges of \(K_k\), hence one maximum matching.  Adding this block
completes the packing.

### Defect-gap corollary

If no \(\operatorname{MATCH}(k,m,1)\) design exists, then
\[
 p(k,m)\le v-2.
\]
The transfer theorem gives
\[
 \boxed{\quad S\ge2m,\qquad
 \Delta_{\mathcal H}(A)\ge2.\quad}
\]

This applies wherever abstract matching-design nonexistence is available.
In the present repository it applies unconditionally to the proved
\(\operatorname{MATCH}(7,3,1)\) and
\(\operatorname{MATCH}(12,6,1)\) nonexistence results.  The reported
\(\operatorname{MATCH}(8,4,1)\) nonexistence would give the same conclusion,
but the inaccessible primary-proof boundary recorded in C573 is retained.

## Exact completion criterion

Let \(G_{\mathrm{bad}}\) be the graph on the secants of \(A\) whose edges are
the bad Kneser edges.  The existing maximum-centre packing extends, without
changing any of its blocks, to a full matching design if and only if
\[
 G_{\mathrm{bad}}
\]
admits an edge decomposition into \(v-b\) cliques \(K_m\), each supported on
a maximum matching of \(K_k\).

All first divisibility conditions are automatic.  For a fixed secant \(e\),
let \(n_e\) be the number of maximum centres on its projective line and
\(d_{\mathrm{bad}}(e)\) its degree in \(G_{\mathrm{bad}}\).  Partitioning the
disjoint partners of \(e\) gives
\[
 \binom{k-2}{2}
 =(m-1)n_e+d_{\mathrm{bad}}(e).
\]
Since the left side is divisible by \(m-1\), every bad degree is divisible by
\(m-1\).  Also
\[
 |E(G_{\mathrm{bad}})|=(v-b)C_m.
\]

Thus edge count and degree congruences do not solve completion.  The remaining
condition is the genuine \(K_m\)-decomposition of the leave.  The C604
secant-deletion theorem bounds a set which destroys bad concurrence pairs, but
does not manufacture this decomposition or its missing projective centres.

## Robust secant-line carrier baseline

Define
\[
 c_k=\frac{\binom{k-2}{2}}{m-1}
 =
 \begin{cases}
 k-3,&k\ \text{even},\\
 k-2,&k\ \text{odd}.
 \end{cases}
\]
The preceding identity gives
\[
 c_k-n_e=\frac{d_{\mathrm{bad}}(e)}{m-1}.
\]
Summing over all \(\binom{k}{2}\) secants and using
\(\sum_e d_{\mathrm{bad}}(e)=2B\) yields the exact formula
\[
 \sum_e(c_k-n_e)
 =\frac{2B}{m-1}
 =m(v-b)
 \le S.
\]

Consequently the number of collinear triples of maximum centres which already
lie on arc secants satisfies
\[
 \begin{aligned}
 T_{\mathrm{sec}}
   &=\sum_e\binom{n_e}{3}\\
   &\ge
   \binom{k}{2}\binom{c_k}{3}
   -S\binom{c_k}{2}.
\end{aligned}
\]
Indeed, decreasing \(c_k\) to \(n_e\) loses at most
\((c_k-n_e)\binom{c_k}{2}\) triples.  At zero defect this is exact:
\[
 T_{\mathrm{sec}}
 =\binom{k}{2}\binom{c_k}{3}.
\]
At \(k=92\), this secant-supported baseline is
\[
 \binom{92}{2}\binom{89}{3}=475378904,
\]
compared with C626's general carrier-set lower bound \(682058\).

This is much larger than C626's general carrier-set lower bound in the
square-root regime.  The dominant collinear triples are forced on the
original arc secants and occur in valid zero-defect families.

## The local conductor is forced nonzero on secant triples

Let \(K\) be perfect of characteristic two.  At the dual point \(p=e^*\) of
an arc secant \(e=ab\), choose local coordinates \(u=a\), \(v=b\).  The dual
Chow product has the form
\[
 F_A=uvR,\qquad R(p)\ne0.
\]
Its quadratic initial form is
\[
 Q_p(w)=R(p)u(w)v(w).
\]

Take three distinct carrier directions \(w_1,w_2,w_3\) through \(p\), and put
\[
 [ij]=u(w_i)v(w_j)+u(w_j)v(w_i).
\]
The relation coefficients are
\[
 c_1=[23],\qquad c_2=[31],\qquad c_3=[12].
\]
C626's first-jet conductor satisfies
\[
 \Omega_p^2
 =R(p)\sum_{i=1}^3c_i^2u(w_i)v(w_i).
\]
Direct expansion in characteristic two gives
\[
 \boxed{\quad
 \Omega_p^2
 =R(p)[12][23][31].\quad}
\]
The three brackets and \(R(p)\) are nonzero, so
\[
 \Omega_p\ne0.
\]

Therefore every triple of distinct maximum centres on an arc secant carries a
nonzero local conductor obstruction.  This happens in genuine zero-defect
hyperoval matching designs.  Nonvanishing of the raw conductor class, even at
the robust abundance forced above, cannot imply positive defect.

## Lean formalization

The focused gate
`RelativeConicArcs.Gates.MatchingPackingDefect` exports six terminals:

- `RelativeConicArcs.MatchingPacking.oneBlockShort_leave_isClique` proves that
  a finite simple graph with \(\binom m2\) edges and all positive degrees
  divisible by \(m-1\) has exactly \(m\) support vertices and is complete on
  its support;
- `RelativeConicArcs.badConcurrenceEdgeCount_add_maximumBlocks` proves the
  exact identity
  \[
    B+b\binom m2=3\binom k4
  \]
  directly from the formal concurrence partition;
- `RelativeConicArcs.maximumConcurrenceBlockDeficiency_le_scaledDefect`
  derives \(m(v-b)\le S\), including \(b\le v\), from the full block-count
  identity; and
- `RelativeConicArcs.two_mul_half_le_scaledDefect_of_two_le_maximumConcurrenceBlockDeficiency`
  derives \(2m\le S\) whenever at least two maximum blocks are missing.

The gate build and its exact-target `--no-build` replay are green.  Every
exported terminal reports exactly
`[propext, Classical.choice, Quot.sound]`; there is no `sorry`, custom axiom,
or native decision procedure in the new modules.

## Outcome and boundary

C627 closes positively at the abstract-design level:

- the exact packing deficiency is a lower bound for prescribed-hole defect;
- abstract nonexistence yields the universal two-unit gap;
- one-block-short completion is automatic; and
- completion of a general leave is isolated as an exact
  maximum-matching-clique decomposition problem.

It closes negatively for the unrenormalized C626 conductor route:

- most carrier triples are the forced triples above arc secants;
- their first conductor coordinate is always nonzero; and
- realizable zero-defect hyperovals already attain this behavior.

A rank-three gap now requires an invariant of the **excess conductor after the
forced secant singularities are removed**, or a theorem producing the missing
projective concurrence centres from an abstract leave decomposition.

No novelty or literature-absence claim is made.  The proof uses the committed
C554/C558 clique partition and bad-edge inequality, C626's local conductor
definition, and elementary finite graph counting.

## `ej` + `tt` closeout

The cheap upgrade is the exact per-secant deficit identity
\[
 \sum_e(c_k-n_e)=m(v-b),
\]
which makes the packing gap, bad-edge budget, and carrier-line loss the same
integer.  It yields the robust secant-triple lower bound without a new moment
calculation.

The Tao-style check asks which part of the conductor is not already forced by
the singularities of \(F_A\).  The displayed determinant identity answers:
the secant-supported part is maximally nonzero and carries no obstruction.
The next object must be a renormalized excess class supported on external
carrier intersections or coupled to the prescribed conic.

## Mystery ledger

| Feature | Disposition |
|:--|:--|
| Can bad-edge removal be upgraded to an abstract design gap? | **Settled positively:** the defect dominates matching-packing deficiency. |
| Can a maximum-matching packing be exactly one block short? | **Settled negatively:** its leave is forced to be the missing \(K_m\), so it completes. |
| What defect follows from abstract design nonexistence? | **Settled:** \(S\ge2m\), equivalently \(\Delta_{\mathcal H}(A)\ge2\). |
| Do edge-count and degree divisibility guarantee completion? | **No:** they are automatic; the remaining gate is an actual \(K_m\)-decomposition of the bad leave. |
| Does C604's deletion set produce the missing blocks? | **No theorem:** it removes bad pairs but supplies neither a leave decomposition nor projective concurrence centres. |
| Can raw C626 conductor nonvanishing force defect? | **Settled negatively:** every secant-supported carrier triple has nonzero conductor, including those in valid zero-defect hyperovals. |
| What conductor information remains unexplained? | **Queued:** subtract the forced secant-supported class and test the external/conic-coupled excess. |
| Does the odd-size carrier have a canonical tangent-twisted form? | **Queued separately:** the residual tangent factor is not canonically removed by the present construction. |
