# C708 human proofs — outer exchange and doily codes

**Lane:** clebsch

**Date:** 2026-07-31

**Companion to:** notes/2026-07-30-c708-doily-codes-and-outer-exchange.md

## Strategy

Three notions of exchange must be separated.  The mixed operator gives an
outer-twisted intertwiner between the two six-point actions.  An involutory
polarity requires an inner normalization, governed by one twisted norm
equation.  Signed incidence lifts belong to the Clifford problem of C706.
The code tables are downstream invariants of the unsigned incidence
geometry.

## 1. Why the operator is an outer exchange

The six Clifford charts are indexed by synthematic totals, so their
augmentation is the outer five-space \(O_X\).  The six conference axes
carry the ordinary augmentation \(A_X\).  C705's differential has type
\[
 \bar G_x:O_X\longrightarrow A_X^\vee,
\]
and its highest nonzero compound is
\[
 \operatorname{adj}A=6Wq^{\mathsf T},
\]
with \(W\) in total coordinates and \(q\) in axis coordinates.  Thus the
operator couples the two inequivalent degree-six permutation
representations.

A total stabilizer is the outer class of \(S_5\): it fixes one chart but
is transitive on the ordinary six letters.  Transport through \(\bar G\)
sends it to an ordinary point stabilizer.  Since the two \(S_5\) classes
characterize the exceptional automorphism of \(S_6\), this proves that the
operator realizes the outer exchange.  It cannot be a direct equivariant
bijection: under a fixed conference \(S_5\), the chart set has orbits
\(1+5\) while the axis set is transitive.

## 2. Why no involution is selected

On the frozen node marking the compatible exchange \(f\) has order eight.
More structurally,
\[
 f^2=\rho(h),\qquad h=(0\,1)(2\,5\,3\,4),
\]
where \(f\rho(g)f^{-1}=\rho(\alpha(g))\) defines the outer automorphism
\(\alpha\).  An inner correction \(\rho(k)f\) is an involution exactly
when
\[
 (\rho(k)f)^2=1
 \quad\Longleftrightarrow\quad
 k\alpha(k)=h^{-1}.
\tag{1}
\]
This twisted norm equation is the complete normalization problem.

If \(k_0\) is one solution, \(S_6\) acts on all solutions by twisted
conjugation
\[
 k\longmapsto gk\alpha(g)^{-1}.
\]
The stabilizer of \(k_0\) has \(20\) elements, so its orbit has
\(720/20=36\) elements.  Direct substitution in (1) shows that every
solution lies in this orbit.  Hence the \(36\) involutory polarities are
one torsor, not \(36\) unrelated coincidences.

The stabilizer has order distribution
\(1^1\,2^5\,4^{10}\,5^4\).  Its normal Sylow-\(5\) subgroup and an
order-four complement identify it as
\[
 F_{20}=C_5\rtimes C_4\cong\operatorname{AGL}(1,5).
\]
Inside the conference \(S_5\), the same stabilizer has index six.
Therefore the conference-selected orbit is
\[
 S_5/F_{20},
\]
canonically the axis six-set.  This proves both the \(6+30\) split and the
axis indexing of the golden six.  It also proves why neither the operator
nor conference marking selects one of those six without an axis choice.

Intersecting \(F_{20}\) with the orientation-preserving \(A_5\) gives
\(D_{10}\).  In its pentagon model, duads divide into the five axis-star
edges, five polygon sides, and five diagonals; the nodes divide into two
pentagons.  The outer element exchanges the node pentagons.  Restoring the
orientation-reversing coset fuses sides with diagonals and the two node
orbits, giving
\[
 (5+5+5,\ 5+5)\longrightarrow(5+10,\ 10).
\]
This is the incidence proof of the same \(A_5\subset S_5\) phase boundary
found cohomologically in C706.

## 3. Incidence ranks and weights

Let \(I_{cp},I_{gp},I_{gc}\) be the three \(0/1\) incidence matrices.
The doily dictionary constructs them from the six-letter set:

* rows of \(I_{cp}\) are synthemes on duads;
* rows of \(I_{gp}\) are \(3+3\) grids on duads;
* rows of \(I_{gc}\) record which contexts lie in each grid.

This description is already a compact human specification of every
entry.  Gaussian elimination over \(2,3,5\) gives respectively
\[
\begin{array}{c|ccc}
 &C_{cp}&C_{gp}&C_{gc}\\ \hline
2&10&5&5\\
3&10&9&10\\
5&10&10&10.
\end{array}
\]
Applying the same elimination to
\(\begin{psmallmatrix}G\\G^\perp\end{psmallmatrix}\) gives the hulls
\[
(5,4,5),\qquad(1,0,1),\qquad(0,0,0),
\]
and stacking pairs of generators gives the intersection dimensions in
the report.  These are rank certificates on three explicitly defined
matrices; no probabilistic inference is involved.

Minimum distance is obtained more conceptually from the six-letter
supports.  Weight-three words are doily contexts; weight-four words are
the four-cycles or node-incidence blocks; and grid rows have their
displayed weights.  The orbit structure rules out smaller supports.
Enumerating the smaller dual spaces then gives their weight enumerators,
and MacWilliams determines the primal enumerators.  This proves the full
parameter table and also distinguishes equal-parameter but unequal
rowspaces.

The minimum supports reconstruct the duads, synthemes, six stars, and ten
grids.  Any coordinate automorphism must therefore permute the underlying
six letters.  Conversely \(S_6\) preserves all incidences.  Hence every
coordinate automorphism group is exactly \(S_6\) of order \(720\).

Changing context signs scales rows, while the C705 gauge change also
scales columns.  Over odd fields this is monomial equivalence; over
\(\mathbf F_2\) the signs disappear.  Therefore signed versions introduce
no new incidence codes.

## 4. The unique CSS output

The hull calculation shows that among these rowspaces the only nonzero
self-orthogonal member is
\[
 C_{gc}\subset C_{gc}^\perp\quad\text{over }\mathbf F_2.
\]
Since \(\dim C_{gc}=5\), its CSS dimension is
\(15-2\cdot5=5\).  The dual has minimum distance three, so the quantum
distance is three.  Thus the result is
\[
 [[15,5,3]]_2.
\]
All other candidates fail an inclusion already at the exact rowspace
level.  This identifies the standard incidence code and makes no novelty
claim.

## 5. Why the incidence codes do not explain the bad primes

At \(2\), the incidence ranks remain \(10,5,5\), while the C705 operator
ranks collapse to \(1,0\); incidence shares sign loss but cannot force the
larger collapse.  At \(3\), only the grid--point rank drops by one, whereas
both operator ranks become three and the fourth compound vanishes; that
is the scalar-\(6\) mechanism.  At \(5\), every incidence rank is ten with
zero hull and the descended operator remains rank four; only the golden
eigenspace/sign lift ramifies.  The numerical comparison therefore proves
three distinct mechanisms, not merely a failure to find a common code.

Finite enumeration supplies normal forms and weight tables only after the
outer action, twisted norm, and support geometry reduce the problem to
explicit finite objects.
